


set.seed(1234)

test_that("Estimates lambda2 and omega are correct", {

  data(asrm, package = "Bayesrel")
  set.seed(1234)
  ee <- Bayesrel::strel(asrm, estimates = c("lambda2", "omega"), n.iter = 500, n.boot = 200, n.chains = 1)

  expect_equal(ee$Bayes$est$Bayes_lambda2, 0.7954302, tolerance = 1e-3)
  expect_equal(ee$freq$est$freq_lambda2, 0.7960336, tolerance = 1e-3)
  expect_equal(ee$Bayes$est$Bayes_omega, 0.7735565, tolerance = 1e-3)
  expect_equal(ee$freq$est$freq_omega, 0.7919616, tolerance = 1e-3)
  expect_equal(ee$Bayes$cred$low$Bayes_omega, 0.6929867, tolerance = 1e-3)
  if (as.numeric(R.Version()$minor) > 6) {
    expect_equal(as.numeric(ee$freq$conf$up$freq_lambda2), 0.867655, tolerance = 1e-3)
  } # because of the change in the RNG brought by the new R version

})



test_that("Bayes glb is correct", {

  data(asrm, package = "Bayesrel")
  set.seed(1234)
  ee <- Bayesrel::strel(asrm, estimates = "glb", n.iter = 500, freq = F, n.chains = 1)

  expect_equal(ee$Bayes$est$Bayes_glb, 0.8567471, tolerance = 1e-3)
  expect_equal(ee$Bayes$cred$up$Bayes_glb, 0.9037633, tolerance = 1e-3)


})


test_that("Bayes Alpha if item deleted is correct", {

  data(asrm, package = "Bayesrel")
  set.seed(1234)
  ee <- Bayesrel::strel(asrm, estimates = "alpha", n.iter = 500, freq = F, item.dropped = T, n.chains = 1)
  expect_equal(as.numeric(ee$Bayes$ifitem$est$alpha[1:2]), c(0.7194519, 0.7278869),
               tolerance = 1e-3)
  expect_equal(as.numeric(ee$Bayes$ifitem$cred$alpha[c(1, 6)]), c(0.628871, 0.8060617),
               tolerance = 1e-3)

})




test_that("Bayes prior and posterior probability for Alpha >.8 is correct", {

  data(asrm, package = "Bayesrel")
  set.seed(1234)
  tt <- Bayesrel::strel(asrm, estimates = "alpha", n.iter = 300, freq = F, n.chains = 2)
  ee <- Bayesrel::p_strel(tt, "alpha", .8)

  expect_equal(as.numeric(ee), c(0.1552618, 0.3480000), tolerance = 1e-3)

})


test_that("Omega results with missing data are correct", {

  data(asrm_mis, package = "Bayesrel")
  set.seed(1234)
  ee <- Bayesrel::strel(asrm_mis, estimates = c("omega"), n.iter = 300, n.chains = 1, n.boot = 300)
  expect_equal(as.numeric(ee$Bayes$cred$low$Bayes_omega), c(0.6803034),
               tolerance = 1e-3)
  expect_equal(as.numeric(ee$freq$est$freq_omega), c(0.7943602),
               tolerance = 1e-3)

})

test_that("Results with input cov matrix are correct", {

  data(asrm, package = "Bayesrel")
  cc <- cov(asrm)
  set.seed(1234)
  ee <- Bayesrel::strel(cov.mat = cc, estimates = c("lambda2"), n.iter = 300, n.chains = 1, n.boot = 300, n.obs = 500)
  expect_equal(as.numeric(ee$Bayes$cred$up$Bayes_lambda2), c(0.8148953),
               tolerance = 1e-3)
  expect_equal(as.numeric(ee$freq$conf$low$freq_lambda2), c(0.767236),
               tolerance = 1e-3)

})
