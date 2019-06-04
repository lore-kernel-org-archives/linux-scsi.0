From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 1/3] pinctrl: qcom: sdm845: Expose ufs_reset as gpio
Date: Tue,  4 Jun 2019 00:19:59 -0700
Message-ID: <20190604072001.9288-2-bjorn.andersson@linaro.org>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604072001.9288-1-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: Andy Gross <agross@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The ufs_reset pin is expected to be wired to the reset pin of the
primary UFS memory but is pretty much just a general purpose output pinr

Reorder the pins and expose it as gpio 150, so that the UFS driver can
toggle it.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 .../bindings/pinctrl/qcom,sdm845-pinctrl.txt         |  2 +-
 drivers/pinctrl/qcom/pinctrl-sdm845.c                | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,sdm845-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,sdm845-pinctrl.txt
index 665aadb5ea28..33ae08aa4b89 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,sdm845-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,sdm845-pinctrl.txt
@@ -79,7 +79,7 @@ to specify in a pin configuration subnode:
 		      gpio0-gpio149
 		        Supports mux, bias and drive-strength
 
-		      sdc2_clk, sdc2_cmd, sdc2_data
+		      sdc2_clk, sdc2_cmd, sdc2_data, ufs_reset
 		        Supports bias and drive-strength
 
 - function:
diff --git a/drivers/pinctrl/qcom/pinctrl-sdm845.c b/drivers/pinctrl/qcom/pinctrl-sdm845.c
index c97f20fca5fd..e4e5acade086 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdm845.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdm845.c
@@ -420,10 +420,10 @@ DECLARE_MSM_GPIO_PINS(147);
 DECLARE_MSM_GPIO_PINS(148);
 DECLARE_MSM_GPIO_PINS(149);
 
-static const unsigned int sdc2_clk_pins[] = { 150 };
-static const unsigned int sdc2_cmd_pins[] = { 151 };
-static const unsigned int sdc2_data_pins[] = { 152 };
-static const unsigned int ufs_reset_pins[] = { 153 };
+static const unsigned int ufs_reset_pins[] = { 150 };
+static const unsigned int sdc2_clk_pins[] = { 151 };
+static const unsigned int sdc2_cmd_pins[] = { 152 };
+static const unsigned int sdc2_data_pins[] = { 153 };
 
 enum sdm845_functions {
 	msm_mux_gpio,
@@ -1271,10 +1271,10 @@ static const struct msm_pingroup sdm845_groups[] = {
 	PINGROUP(147, NORTH, _, _, _, _, _, _, _, _, _, _),
 	PINGROUP(148, NORTH, _, _, _, _, _, _, _, _, _, _),
 	PINGROUP(149, NORTH, _, _, _, _, _, _, _, _, _, _),
+	UFS_RESET(ufs_reset, 0x99f000),
 	SDC_QDSD_PINGROUP(sdc2_clk, 0x99a000, 14, 6),
 	SDC_QDSD_PINGROUP(sdc2_cmd, 0x99a000, 11, 3),
 	SDC_QDSD_PINGROUP(sdc2_data, 0x99a000, 9, 0),
-	UFS_RESET(ufs_reset, 0x99f000),
 };
 
 static const struct msm_pinctrl_soc_data sdm845_pinctrl = {
@@ -1284,7 +1284,7 @@ static const struct msm_pinctrl_soc_data sdm845_pinctrl = {
 	.nfunctions = ARRAY_SIZE(sdm845_functions),
 	.groups = sdm845_groups,
 	.ngroups = ARRAY_SIZE(sdm845_groups),
-	.ngpios = 150,
+	.ngpios = 151,
 };
 
 static int sdm845_pinctrl_probe(struct platform_device *pdev)
-- 
2.18.0
