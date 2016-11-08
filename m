From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v5 03/12] phy: qcom-ufs: Cleanup clock and regulator initialization
Date: Tue,  8 Nov 2016 15:37:42 +0530
Message-ID: <1478599671-13071-4-git-send-email-vivek.gautam@codeaurora.org>
References: <1478599671-13071-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1478599671-13071-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Different menthods pass around generic phy pointer to
extract device pointer. Instead, pass the device pointer
directly between function calls.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/phy/phy-qcom-ufs-i.h        |  6 +--
 drivers/phy/phy-qcom-ufs-qmp-14nm.c |  4 +-
 drivers/phy/phy-qcom-ufs-qmp-20nm.c |  4 +-
 drivers/phy/phy-qcom-ufs.c          | 80 ++++++++++++++-----------------------
 4 files changed, 37 insertions(+), 57 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs-i.h b/drivers/phy/phy-qcom-ufs-i.h
index 2bd5ce4..69e836d 100644
--- a/drivers/phy/phy-qcom-ufs-i.h
+++ b/drivers/phy/phy-qcom-ufs-i.h
@@ -142,10 +142,8 @@ struct ufs_qcom_phy_specific_ops {
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
index 6ee5149..e3bede7 100644
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
index 770087a..e09ecb8c 100644
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
index 5dc24d8..b0171fe 100644
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
@@ -174,30 +172,27 @@ static int __ufs_qcom_phy_clk_get(struct phy *phy,
 	return err;
 }
 
-static
-int ufs_qcom_phy_clk_get(struct phy *phy,
+static int ufs_qcom_phy_clk_get(struct device *dev,
 			 const char *name, struct clk **clk_out)
 {
-	return __ufs_qcom_phy_clk_get(phy, name, clk_out, true);
+	return __ufs_qcom_phy_clk_get(dev, name, clk_out, true);
 }
 
-int
-ufs_qcom_phy_init_clks(struct phy *generic_phy,
-		       struct ufs_qcom_phy *phy_common)
+int ufs_qcom_phy_init_clks(struct ufs_qcom_phy *phy_common)
 {
 	int err;
 
-	err = ufs_qcom_phy_clk_get(generic_phy, "tx_iface_clk",
+	err = ufs_qcom_phy_clk_get(phy_common->dev, "tx_iface_clk",
 				   &phy_common->tx_iface_clk);
 	if (err)
 		goto out;
 
-	err = ufs_qcom_phy_clk_get(generic_phy, "rx_iface_clk",
+	err = ufs_qcom_phy_clk_get(phy_common->dev, "rx_iface_clk",
 				   &phy_common->rx_iface_clk);
 	if (err)
 		goto out;
 
-	err = ufs_qcom_phy_clk_get(generic_phy, "ref_clk_src",
+	err = ufs_qcom_phy_clk_get(phy_common->dev, "ref_clk_src",
 				   &phy_common->ref_clk_src);
 	if (err)
 		goto out;
@@ -206,10 +201,10 @@ int ufs_qcom_phy_clk_get(struct phy *phy,
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
@@ -217,37 +212,33 @@ int ufs_qcom_phy_clk_get(struct phy *phy,
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_init_clks);
 
-int
-ufs_qcom_phy_init_vregulators(struct phy *generic_phy,
-			      struct ufs_qcom_phy *phy_common)
+int ufs_qcom_phy_init_vregulators(struct ufs_qcom_phy *phy_common)
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
 
@@ -304,14 +295,13 @@ static int __ufs_qcom_phy_init_vreg(struct phy *phy,
 	return err;
 }
 
-static int ufs_qcom_phy_init_vreg(struct phy *phy,
+static int ufs_qcom_phy_init_vreg(struct device *dev,
 			struct ufs_qcom_phy_vreg *vreg, const char *name)
 {
-	return __ufs_qcom_phy_init_vreg(phy, vreg, name, false);
+	return __ufs_qcom_phy_init_vreg(dev, vreg, name, false);
 }
 
-static
-int ufs_qcom_phy_cfg_vreg(struct phy *phy,
+static int ufs_qcom_phy_cfg_vreg(struct device *dev,
 			  struct ufs_qcom_phy_vreg *vreg, bool on)
 {
 	int ret = 0;
@@ -319,8 +309,6 @@ int ufs_qcom_phy_cfg_vreg(struct phy *phy,
 	const char *name = vreg->name;
 	int min_uV;
 	int uA_load;
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
-	struct device *dev = ufs_qcom_phy->dev;
 
 	if (regulator_count_voltages(reg) > 0) {
 		min_uV = on ? vreg->min_uV : 0;
@@ -348,18 +336,15 @@ int ufs_qcom_phy_cfg_vreg(struct phy *phy,
 	return ret;
 }
 
-static
-int ufs_qcom_phy_enable_vreg(struct phy *phy,
+static int ufs_qcom_phy_enable_vreg(struct device *dev,
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
@@ -430,12 +415,9 @@ int ufs_qcom_phy_enable_ref_clk(struct phy *generic_phy)
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_ref_clk);
 
-static
-int ufs_qcom_phy_disable_vreg(struct phy *phy,
+static int ufs_qcom_phy_disable_vreg(struct device *dev,
 			      struct ufs_qcom_phy_vreg *vreg)
 {
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
-	struct device *dev = ufs_qcom_phy->dev;
 	int ret = 0;
 
 	if (!vreg || !vreg->enabled || vreg->is_always_on)
@@ -445,7 +427,7 @@ int ufs_qcom_phy_disable_vreg(struct phy *phy,
 
 	if (!ret) {
 		/* ignore errors on applying disable config */
-		ufs_qcom_phy_cfg_vreg(phy, vreg, false);
+		ufs_qcom_phy_cfg_vreg(dev, vreg, false);
 		vreg->enabled = false;
 	} else {
 		dev_err(dev, "%s: %s disable failed, err=%d\n",
@@ -673,7 +655,7 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 	struct device *dev = phy_common->dev;
 	int err;
 
-	err = ufs_qcom_phy_enable_vreg(generic_phy, &phy_common->vdda_phy);
+	err = ufs_qcom_phy_enable_vreg(dev, &phy_common->vdda_phy);
 	if (err) {
 		dev_err(dev, "%s enable vdda_phy failed, err=%d\n",
 			__func__, err);
@@ -683,7 +665,7 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 	phy_common->phy_spec_ops->power_control(phy_common, true);
 
 	/* vdda_pll also enables ref clock LDOs so enable it first */
-	err = ufs_qcom_phy_enable_vreg(generic_phy, &phy_common->vdda_pll);
+	err = ufs_qcom_phy_enable_vreg(dev, &phy_common->vdda_pll);
 	if (err) {
 		dev_err(dev, "%s enable vdda_pll failed, err=%d\n",
 			__func__, err);
@@ -699,7 +681,7 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 
 	/* enable device PHY ref_clk pad rail */
 	if (phy_common->vddp_ref_clk.reg) {
-		err = ufs_qcom_phy_enable_vreg(generic_phy,
+		err = ufs_qcom_phy_enable_vreg(dev,
 					       &phy_common->vddp_ref_clk);
 		if (err) {
 			dev_err(dev, "%s enable vddp_ref_clk failed, err=%d\n",
@@ -714,9 +696,9 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
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
@@ -729,12 +711,12 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
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
