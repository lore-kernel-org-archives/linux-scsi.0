From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 06/10] phy: qcom-ufs: Remove unnecessary function declarations
Date: Tue, 18 Oct 2016 19:58:13 +0530
Message-ID: <1476800897-19898-7-git-send-email-vivek.gautam@codeaurora.org>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Move the functions' definitions to remove unnecessary
declarations.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---

New patch added in v2 series.

 drivers/phy/phy-qcom-ufs.c | 133 +++++++++++++++++++++------------------------
 1 file changed, 63 insertions(+), 70 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 3a87e88..144b11f 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -22,13 +22,6 @@
 #define VDDP_REF_CLK_MIN_UV        1200000
 #define VDDP_REF_CLK_MAX_UV        1200000
 
-static int __ufs_qcom_phy_init_vreg(struct device *, struct ufs_qcom_phy_vreg *,
-				    const char *, bool);
-static int ufs_qcom_phy_init_vreg(struct device *, struct ufs_qcom_phy_vreg *,
-				  const char *);
-static int ufs_qcom_phy_base_init(struct platform_device *pdev,
-				  struct ufs_qcom_phy *phy_common);
-
 int ufs_qcom_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
 			   struct ufs_qcom_phy_calibration *tbl_A,
 			   int tbl_size_A,
@@ -75,45 +68,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_calibrate);
 
-struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
-				struct ufs_qcom_phy *common_cfg,
-				const struct phy_ops *ufs_qcom_phy_gen_ops,
-				struct ufs_qcom_phy_specific_ops *phy_spec_ops)
-{
-	int err;
-	struct device *dev = &pdev->dev;
-	struct phy *generic_phy = NULL;
-	struct phy_provider *phy_provider;
-
-	err = ufs_qcom_phy_base_init(pdev, common_cfg);
-	if (err) {
-		dev_err(dev, "%s: phy base init failed %d\n", __func__, err);
-		goto out;
-	}
-
-	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	if (IS_ERR(phy_provider)) {
-		err = PTR_ERR(phy_provider);
-		dev_err(dev, "%s: failed to register phy %d\n", __func__, err);
-		goto out;
-	}
-
-	generic_phy = devm_phy_create(dev, NULL, ufs_qcom_phy_gen_ops);
-	if (IS_ERR(generic_phy)) {
-		err =  PTR_ERR(generic_phy);
-		dev_err(dev, "%s: failed to create phy %d\n", __func__, err);
-		generic_phy = NULL;
-		goto out;
-	}
-
-	common_cfg->phy_spec_ops = phy_spec_ops;
-	common_cfg->dev = dev;
-
-out:
-	return generic_phy;
-}
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_generic_probe);
-
 /*
  * This assumes the embedded phy structure inside generic_phy is of type
  * struct ufs_qcom_phy. In order to function properly it's crucial
@@ -154,6 +108,45 @@ int ufs_qcom_phy_base_init(struct platform_device *pdev,
 	return 0;
 }
 
+struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
+				struct ufs_qcom_phy *common_cfg,
+				const struct phy_ops *ufs_qcom_phy_gen_ops,
+				struct ufs_qcom_phy_specific_ops *phy_spec_ops)
+{
+	int err;
+	struct device *dev = &pdev->dev;
+	struct phy *generic_phy = NULL;
+	struct phy_provider *phy_provider;
+
+	err = ufs_qcom_phy_base_init(pdev, common_cfg);
+	if (err) {
+		dev_err(dev, "%s: phy base init failed %d\n", __func__, err);
+		goto out;
+	}
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider)) {
+		err = PTR_ERR(phy_provider);
+		dev_err(dev, "%s: failed to register phy %d\n", __func__, err);
+		goto out;
+	}
+
+	generic_phy = devm_phy_create(dev, NULL, ufs_qcom_phy_gen_ops);
+	if (IS_ERR(generic_phy)) {
+		err =  PTR_ERR(generic_phy);
+		dev_err(dev, "%s: failed to create phy %d\n", __func__, err);
+		generic_phy = NULL;
+		goto out;
+	}
+
+	common_cfg->phy_spec_ops = phy_spec_ops;
+	common_cfg->dev = dev;
+
+out:
+	return generic_phy;
+}
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_generic_probe);
+
 static int __ufs_qcom_phy_clk_get(struct device *dev,
 			 const char *name, struct clk **clk_out, bool err_print)
 {
@@ -224,30 +217,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_init_clks);
 
-int
-ufs_qcom_phy_init_vregulators(struct ufs_qcom_phy *phy_common)
-{
-	int err;
-
-	err = ufs_qcom_phy_init_vreg(phy_common->dev, &phy_common->vdda_pll,
-		"vdda-pll");
-	if (err)
-		goto out;
-
-	err = ufs_qcom_phy_init_vreg(phy_common->dev, &phy_common->vdda_phy,
-		"vdda-phy");
-
-	if (err)
-		goto out;
-
-	/* vddp-ref-clk-* properties are optional */
-	__ufs_qcom_phy_init_vreg(phy_common->dev, &phy_common->vddp_ref_clk,
-				 "vddp-ref-clk", true);
-out:
-	return err;
-}
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_init_vregulators);
-
 static int __ufs_qcom_phy_init_vreg(struct device *dev,
 		struct ufs_qcom_phy_vreg *vreg, const char *name, bool optional)
 {
@@ -316,6 +285,30 @@ static int ufs_qcom_phy_init_vreg(struct device *dev,
 	return __ufs_qcom_phy_init_vreg(dev, vreg, name, false);
 }
 
+int
+ufs_qcom_phy_init_vregulators(struct ufs_qcom_phy *phy_common)
+{
+	int err;
+
+	err = ufs_qcom_phy_init_vreg(phy_common->dev, &phy_common->vdda_pll,
+		"vdda-pll");
+	if (err)
+		goto out;
+
+	err = ufs_qcom_phy_init_vreg(phy_common->dev, &phy_common->vdda_phy,
+		"vdda-phy");
+
+	if (err)
+		goto out;
+
+	/* vddp-ref-clk-* properties are optional */
+	__ufs_qcom_phy_init_vreg(phy_common->dev, &phy_common->vddp_ref_clk,
+				 "vddp-ref-clk", true);
+out:
+	return err;
+}
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_init_vregulators);
+
 static
 int ufs_qcom_phy_cfg_vreg(struct device *dev,
 			  struct ufs_qcom_phy_vreg *vreg, bool on)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
