From: Rajendra Nayak <rnayak@codeaurora.org>
Subject: [RFC v2 02/11] OPP: Make dev_pm_opp_set_rate() with freq=0 as valid
Date: Wed, 20 Mar 2019 15:19:09 +0530
Message-ID: <20190320094918.20234-3-rnayak@codeaurora.org>
References: <20190320094918.20234-1-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320094918.20234-1-rnayak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, swboyd@chromium.org, ulf.hansson@linaro.org, viresh.kumar@linaro.org, dianders@chromium.org, rafael@kernel.org, Rajendra Nayak <rnayak@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

For devices with performance state, we use dev_pm_opp_set_rate()
to set the appropriate clk rate and the performance state.
We do need a way to *remove* the performance state vote when
we idle the device and turn the clocks off. Use dev_pm_opp_set_rate()
with freq=0 to achieve this.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/opp/core.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index bc9a7762dd4c..d6acc880676e 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -708,18 +708,24 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
 	struct clk *clk;
 	int ret;
 
-	if (unlikely(!target_freq)) {
-		dev_err(dev, "%s: Invalid target frequency %lu\n", __func__,
-			target_freq);
-		return -EINVAL;
-	}
-
 	opp_table = _find_opp_table(dev);
 	if (IS_ERR(opp_table)) {
 		dev_err(dev, "%s: device opp doesn't exist\n", __func__);
 		return PTR_ERR(opp_table);
 	}
 
+	if (unlikely(!target_freq)) {
+		if (opp_table->required_opp_tables) {
+			/* drop the performance state vote */
+			dev_pm_genpd_set_performance_state(dev, 0);
+			return 0;
+		} else {
+			dev_err(dev, "%s: Invalid target frequency %lu\n", __func__,
+				target_freq);
+			return -EINVAL;
+		}
+	}
+
 	clk = opp_table->clk;
 	if (IS_ERR(clk)) {
 		dev_err(dev, "%s: No clock available for the device\n",
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
