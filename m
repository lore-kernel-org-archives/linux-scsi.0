From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 5/7] phy: qcom-ufs: Cleanup clock and regulator initialization
Date: Tue, 18 Oct 2016 10:19:03 +0530
Message-ID: <1476766145-27583-6-git-send-email-vivek.gautam@codeaurora.org>
References: <1476766145-27583-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36102 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754732AbcJREtg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 00:49:36 -0400
In-Reply-To: <1476766145-27583-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>

Different methods pass around generic phy pointer to
extract device pointer. Instead, pass the device pointer
directly between function calls.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/phy/phy-qcom-ufs-i.h        |  6 +--
 drivers/phy/phy-qcom-ufs-qmp-14nm.c |  4 +-
 drivers/phy/phy-qcom-ufs-qmp-20nm.c |  4 +-
 drivers/phy/phy-qcom-ufs.c          | 79 ++++++++++++++++---------------------
 4 files changed, 39 insertions(+), 54 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs-i.h b/drivers/phy/phy-qcom-ufs-i.h
index 2bd5ce4..69e836d 100644
--- a/drivers/phy/phy-qcom-ufs-i.h
+++ b/drivers/phy/phy-qcom-ufs-i.h
@@ -142,10 +142,8 @@ struct ufs_qcom_phy *get_ufs_qcom_phy(struct phy *generic_phy);
 int ufs_qcom_phy_power_on(struct phy *generic_phy);
 int ufs_qcom_phy_power_off(struct phy *generic_phy);
 int ufs_qcom_phy_exit(struct phy *generic_phy);
-int ufs_qcom_phy_init_clks(struct phy *generic_phy,
-			struct ufs_qcom_phy *phy_common);
-int ufs_qcom_phy_init_vregulators(struct phy *generic_phy,
-			struct ufs_qcom_phy *phy_common);
+int ufs_qcom_phy_init_clks(struct ufs_qcom_phy *phy_common);
+int ufs_qcom_phy_init_vregulators(struct ufs_qcom_phy *phy_common);
 int ufs_qcom_phy_remove(struct phy *generic_phy,
 		       struct ufs_qcom_phy *ufs_qcom_phy);
 struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
diff --git a/drivers/phy/phy-qcom-ufs-qmp-14nm.c b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
index a305016..55fecbb 100644
--- a/drivers/phy/phy-qcom-ufs-qmp-14nm.c
+++ b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
@@ -48,14 +48,14 @@ static int ufs_qcom_phy_qmp_14nm_init(struct phy *generic_phy)
 	struct ufs_qcom_phy *phy_common = &phy->common_cfg;
 	int err;
 
-	err = ufs_qcom_phy_init_clks(generic_phy, phy_common);
+	err = ufs_qcom_phy_init_clks(phy_common);
 	if (err) {
 		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks() failed %d\n",
 			__func__, err);
 		goto out;
 	}
 
-	err = ufs_qcom_phy_init_vregulators(generic_phy, phy_common);
+	err = ufs_qcom_phy_init_vregulators(phy_common);
 	if (err) {
 		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_vregulators() failed %d\n",
 			__func__, err);
diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
index 2db1fbb..9a2f53d 100644
--- a/drivers/phy/phy-qcom-ufs-qmp-20nm.c
+++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
@@ -67,14 +67,14 @@ static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
 	struct ufs_qcom_phy *phy_common = &phy->common_cfg;
 	int err = 0;
 
-	err = ufs_qcom_phy_init_clks(generic_phy, phy_common);
+	err = ufs_qcom_phy_init_clks(phy_common);
 	if (err) {
 		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks() failed %d\n",
 			__func__, err);
 		goto out;
 	}
 
-	err = ufs_qcom_phy_init_vregulators(generic_phy, phy_common);
+	err = ufs_qcom_phy_init_vregulators(phy_common);
 	if (err) {
 		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_vregulators() failed %d\n",
 			__func__, err);
diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index b8f9286..3a87e88 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -22,9 +22,9 @@
 #define VDDP_REF_CLK_MIN_UV        1200000
 #define VDDP_REF_CLK_MAX_UV        1200000
 
-static int __ufs_qcom_phy_init_vreg(struct phy *, struct ufs_qcom_phy_vreg *,
+static int __ufs_qcom_phy_init_vreg(struct device *, struct ufs_qcom_phy_vreg *,
 				    const char *, bool);
-static int ufs_qcom_phy_init_vreg(struct phy *, struct ufs_qcom_phy_vreg *,
+static int ufs_qcom_phy_init_vreg(struct device *, struct ufs_qcom_phy_vreg *,
 				  const char *);
 static int ufs_qcom_phy_base_init(struct platform_device *pdev,
 				  struct ufs_qcom_phy *phy_common);
@@ -154,13 +154,11 @@ int ufs_qcom_phy_base_init(struct platform_device *pdev,
 	return 0;
 }
 
-static int __ufs_qcom_phy_clk_get(struct phy *phy,
+static int __ufs_qcom_phy_clk_get(struct device *dev,
 			 const char *name, struct clk **clk_out, bool err_print)
 {
 	struct clk *clk;
 	int err = 0;
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
-	struct device *dev = ufs_qcom_phy->dev;
 
 	clk = devm_clk_get(dev, name);
 	if (IS_ERR(clk)) {
@@ -175,40 +173,38 @@ static int __ufs_qcom_phy_clk_get(struct phy *phy,
 }
 
 static
-int ufs_qcom_phy_clk_get(struct phy *phy,
+int ufs_qcom_phy_clk_get(struct device *dev,
 			 const char *name, struct clk **clk_out)
 {
-	return __ufs_qcom_phy_clk_get(phy, name, clk_out, true);
+	return __ufs_qcom_phy_clk_get(dev, name, clk_out, true);
 }
 
 int
-ufs_qcom_phy_init_clks(struct phy *generic_phy,
-		       struct ufs_qcom_phy *phy_common)
+ufs_qcom_phy_init_clks(struct ufs_qcom_phy *phy_common)
 {
 	int err;
-	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
 
-	err = ufs_qcom_phy_clk_get(generic_phy, "tx_iface_clk",
+	err = ufs_qcom_phy_clk_get(phy_common->dev, "tx_iface_clk",
 				   &phy_common->tx_iface_clk);
 	/*
 	 * tx_iface_clk does not exist in newer version of ufs-phy HW,
 	 * so don't return error if it is not found
 	 */
 	if (err)
-		dev_dbg(phy->dev, "%s: failed to get tx_iface_clk\n",
+		dev_dbg(phy_common->dev, "%s: failed to get tx_iface_clk\n",
 			__func__);
 
-	err = ufs_qcom_phy_clk_get(generic_phy, "rx_iface_clk",
+	err = ufs_qcom_phy_clk_get(phy_common->dev, "rx_iface_clk",
 				   &phy_common->rx_iface_clk);
 	/*
 	 * rx_iface_clk does not exist in newer version of ufs-phy HW,
 	 * so don't return error if it is not found
 	 */
 	if (err)
-		dev_dbg(phy->dev, "%s: failed to get rx_iface_clk\n",
+		dev_dbg(phy_common->dev, "%s: failed to get rx_iface_clk\n",
 			__func__);
 
-	err = ufs_qcom_phy_clk_get(generic_phy, "ref_clk_src",
+	err = ufs_qcom_phy_clk_get(phy_common->dev, "ref_clk_src",
 				   &phy_common->ref_clk_src);
 	if (err)
 		goto out;
@@ -217,10 +213,10 @@ ufs_qcom_phy_init_clks(struct phy *generic_phy,
 	 * "ref_clk_parent" is optional hence don't abort init if it's not
 	 * found.
 	 */
-	__ufs_qcom_phy_clk_get(generic_phy, "ref_clk_parent",
+	__ufs_qcom_phy_clk_get(phy_common->dev, "ref_clk_parent",
 				   &phy_common->ref_clk_parent, false);
 
-	err = ufs_qcom_phy_clk_get(generic_phy, "ref_clk",
+	err = ufs_qcom_phy_clk_get(phy_common->dev, "ref_clk",
 				   &phy_common->ref_clk);
 
 out:
@@ -229,36 +225,33 @@ out:
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_init_clks);
 
 int
-ufs_qcom_phy_init_vregulators(struct phy *generic_phy,
-			      struct ufs_qcom_phy *phy_common)
+ufs_qcom_phy_init_vregulators(struct ufs_qcom_phy *phy_common)
 {
 	int err;
 
-	err = ufs_qcom_phy_init_vreg(generic_phy, &phy_common->vdda_pll,
+	err = ufs_qcom_phy_init_vreg(phy_common->dev, &phy_common->vdda_pll,
 		"vdda-pll");
 	if (err)
 		goto out;
 
-	err = ufs_qcom_phy_init_vreg(generic_phy, &phy_common->vdda_phy,
+	err = ufs_qcom_phy_init_vreg(phy_common->dev, &phy_common->vdda_phy,
 		"vdda-phy");
 
 	if (err)
 		goto out;
 
 	/* vddp-ref-clk-* properties are optional */
-	__ufs_qcom_phy_init_vreg(generic_phy, &phy_common->vddp_ref_clk,
+	__ufs_qcom_phy_init_vreg(phy_common->dev, &phy_common->vddp_ref_clk,
 				 "vddp-ref-clk", true);
 out:
 	return err;
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_init_vregulators);
 
-static int __ufs_qcom_phy_init_vreg(struct phy *phy,
+static int __ufs_qcom_phy_init_vreg(struct device *dev,
 		struct ufs_qcom_phy_vreg *vreg, const char *name, bool optional)
 {
 	int err = 0;
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
-	struct device *dev = ufs_qcom_phy->dev;
 
 	char prop_name[MAX_PROP_NAME];
 
@@ -317,14 +310,14 @@ out:
 	return err;
 }
 
-static int ufs_qcom_phy_init_vreg(struct phy *phy,
+static int ufs_qcom_phy_init_vreg(struct device *dev,
 			struct ufs_qcom_phy_vreg *vreg, const char *name)
 {
-	return __ufs_qcom_phy_init_vreg(phy, vreg, name, false);
+	return __ufs_qcom_phy_init_vreg(dev, vreg, name, false);
 }
 
 static
-int ufs_qcom_phy_cfg_vreg(struct phy *phy,
+int ufs_qcom_phy_cfg_vreg(struct device *dev,
 			  struct ufs_qcom_phy_vreg *vreg, bool on)
 {
 	int ret = 0;
@@ -332,8 +325,6 @@ int ufs_qcom_phy_cfg_vreg(struct phy *phy,
 	const char *name = vreg->name;
 	int min_uV;
 	int uA_load;
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
-	struct device *dev = ufs_qcom_phy->dev;
 
 	if (regulator_count_voltages(reg) > 0) {
 		min_uV = on ? vreg->min_uV : 0;
@@ -362,17 +353,15 @@ out:
 }
 
 static
-int ufs_qcom_phy_enable_vreg(struct phy *phy,
+int ufs_qcom_phy_enable_vreg(struct device *dev,
 			     struct ufs_qcom_phy_vreg *vreg)
 {
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
-	struct device *dev = ufs_qcom_phy->dev;
 	int ret = 0;
 
 	if (!vreg || vreg->enabled)
 		goto out;
 
-	ret = ufs_qcom_phy_cfg_vreg(phy, vreg, true);
+	ret = ufs_qcom_phy_cfg_vreg(dev, vreg, true);
 	if (ret) {
 		dev_err(dev, "%s: ufs_qcom_phy_cfg_vreg() failed, err=%d\n",
 			__func__, ret);
@@ -444,11 +433,9 @@ out:
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_ref_clk);
 
 static
-int ufs_qcom_phy_disable_vreg(struct phy *phy,
+int ufs_qcom_phy_disable_vreg(struct device *dev,
 			      struct ufs_qcom_phy_vreg *vreg)
 {
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
-	struct device *dev = ufs_qcom_phy->dev;
 	int ret = 0;
 
 	if (!vreg || !vreg->enabled || vreg->is_always_on)
@@ -458,7 +445,7 @@ int ufs_qcom_phy_disable_vreg(struct phy *phy,
 
 	if (!ret) {
 		/* ignore errors on applying disable config */
-		ufs_qcom_phy_cfg_vreg(phy, vreg, false);
+		ufs_qcom_phy_cfg_vreg(dev, vreg, false);
 		vreg->enabled = false;
 	} else {
 		dev_err(dev, "%s: %s disable failed, err=%d\n",
@@ -677,7 +664,7 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 	struct device *dev = phy_common->dev;
 	int err;
 
-	err = ufs_qcom_phy_enable_vreg(generic_phy, &phy_common->vdda_phy);
+	err = ufs_qcom_phy_enable_vreg(dev, &phy_common->vdda_phy);
 	if (err) {
 		dev_err(dev, "%s enable vdda_phy failed, err=%d\n",
 			__func__, err);
@@ -687,7 +674,7 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 	phy_common->phy_spec_ops->power_control(phy_common, true);
 
 	/* vdda_pll also enables ref clock LDOs so enable it first */
-	err = ufs_qcom_phy_enable_vreg(generic_phy, &phy_common->vdda_pll);
+	err = ufs_qcom_phy_enable_vreg(dev, &phy_common->vdda_pll);
 	if (err) {
 		dev_err(dev, "%s enable vdda_pll failed, err=%d\n",
 			__func__, err);
@@ -703,7 +690,7 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 
 	/* enable device PHY ref_clk pad rail */
 	if (phy_common->vddp_ref_clk.reg) {
-		err = ufs_qcom_phy_enable_vreg(generic_phy,
+		err = ufs_qcom_phy_enable_vreg(dev,
 					       &phy_common->vddp_ref_clk);
 		if (err) {
 			dev_err(dev, "%s enable vddp_ref_clk failed, err=%d\n",
@@ -718,9 +705,9 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 out_disable_ref_clk:
 	ufs_qcom_phy_disable_ref_clk(generic_phy);
 out_disable_pll:
-	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
+	ufs_qcom_phy_disable_vreg(dev, &phy_common->vdda_pll);
 out_disable_phy:
-	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
+	ufs_qcom_phy_disable_vreg(dev, &phy_common->vdda_phy);
 out:
 	return err;
 }
@@ -733,12 +720,12 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
 	phy_common->phy_spec_ops->power_control(phy_common, false);
 
 	if (phy_common->vddp_ref_clk.reg)
-		ufs_qcom_phy_disable_vreg(generic_phy,
+		ufs_qcom_phy_disable_vreg(phy_common->dev,
 					  &phy_common->vddp_ref_clk);
 	ufs_qcom_phy_disable_ref_clk(generic_phy);
 
-	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_pll);
-	ufs_qcom_phy_disable_vreg(generic_phy, &phy_common->vdda_phy);
+	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_pll);
+	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_phy);
 	phy_common->is_powered_on = false;
 
 	return 0;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

