using Turing: link, invlink, logpdf_with_trans
using Base.Test
using Distributions

dists = [Arcsine(2, 4), Beta(2,2), Dirichlet(2, 3), Wishart(7, [1 0.5; 0.5 1])]

for dist in dists
  x = rand(dist)    # sample
  y = link(dist, x) # X -> R
  # Test if R -> X is equal to the original value
  @test_approx_eq_eps invlink(dist, y) x 1e-9
end


# julia> logpdf_with_trans(Dirichlet([1., 1., 1.]), exp([-1000., -1000., -1000.]), true)
# NaN
# julia> logpdf_with_trans(Dirichlet([1., 1., 1.]), [-1000., -1000., -1000.], true, true)
# -1999.30685281944
#
# julia> logpdf_with_trans(Dirichlet([1., 1., 1.]), exp([-1., -2., -3.]), true)
# -3.006450206744678
# julia> logpdf_with_trans(Dirichlet([1., 1., 1.]), [-1., -2., -3.], true, true)
# -3.006450206744678
d  = Dirichlet([1., 1., 1.])
r  = [-1000., -1000., -1000.]
r2 = [-1., -2., -3.]

@test_approx_eq_eps invlink(d, r) [0., 0., 1.]  1e-9
#@test_approx_eq_eps logpdf_with_trans(d, invlink(d, r), true) -1999.30685281944 1e-9 # NaN
@test_approx_eq_eps logpdf_with_trans(d, invlink(d, r2), true) -3.760398892580863 1e-9
