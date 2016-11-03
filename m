From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v4 09/12] ufs-qcom: phy/hcd: Refactoring phy clock handling
Date: Thu,  3 Nov 2016 23:00:50 +0530
Message-ID: <1478194250-19132-1-git-send-email-vivek.gautam@codeaurora.org>
References: <CAFp+6iGiQG2BV0W0rFKEW6YnEWDkjOqoruJ-neTjKjfKx7yVdA@mail.gmail.com>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAFp+6iGiQG2BV0W0rFKEW6YnEWDkjOqoruJ-neTjKjfKx7yVdA@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Add phy clock enable code to phy_power_on/off callbacks, and
remove explicit calls to enable these phy clocks from the
ufs-qcom hcd driver.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---

Changes since v3:
 - Moved phy_power_off() under *link not active* check
   during aggressive clock gating.

Changes since v2:
 - Added phy_power_on() and phy_power_off() calls to
   power-cycle the PHY during aggressive clk gating.

Changes since v1:
 - staticized ufs_qcom_phy_enable(/disable)_ref_clk(),
 - staticized ufs_qcom_phy_enable(/disable)_iface_clk()
 - removed function declaration and export symbol for these APIs.

 drivers/phy/phy-qcom-ufs.c       | 36 ++++++++++++++++++------------------
 drivers/scsi/ufs/ufs-qcom.c      | 21 ++++++---------------
 include/linux/phy/phy-qcom-ufs.h | 18 ------------------
 3 files changed, 24 insertions(+), 51 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 1ec64d5..9dff4c2 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -366,10 +366,9 @@ int ufs_qcom_phy_enable_vreg(struct device *dev,
 	return ret;
 }
 
-int ufs_qcom_phy_enable_ref_clk(struct phy *generic_phy)
+static int ufs_qcom_phy_enable_ref_clk(struct ufs_qcom_phy *phy)
 {
 	int ret = 0;
-	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
 
 	if (phy->is_ref_clk_enabled)
 		goto out;
@@ -416,7 +415,6 @@ int ufs_qcom_phy_enable_ref_clk(struct phy *generic_phy)
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_ref_clk);
 
 static
 int ufs_qcom_phy_disable_vreg(struct device *dev,
@@ -441,10 +439,8 @@ int ufs_qcom_phy_disable_vreg(struct device *dev,
 	return ret;
 }
 
-void ufs_qcom_phy_disable_ref_clk(struct phy *generic_phy)
+static void ufs_qcom_phy_disable_ref_clk(struct ufs_qcom_phy *phy)
 {
-	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
-
 	if (phy->is_ref_clk_enabled) {
 		clk_disable_unprepare(phy->ref_clk);
 		/*
@@ -457,7 +453,6 @@ void ufs_qcom_phy_disable_ref_clk(struct phy *generic_phy)
 		phy->is_ref_clk_enabled = false;
 	}
 }
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_ref_clk);
 
 #define UFS_REF_CLK_EN	(1 << 5)
 
@@ -510,9 +505,8 @@ void ufs_qcom_phy_disable_dev_ref_clk(struct phy *generic_phy)
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_dev_ref_clk);
 
 /* Turn ON M-PHY RMMI interface clocks */
-int ufs_qcom_phy_enable_iface_clk(struct phy *generic_phy)
+static int ufs_qcom_phy_enable_iface_clk(struct ufs_qcom_phy *phy)
 {
-	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
 	int ret = 0;
 
 	if (phy->is_iface_clk_enabled)
@@ -536,20 +530,16 @@ int ufs_qcom_phy_enable_iface_clk(struct phy *generic_phy)
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_iface_clk);
 
 /* Turn OFF M-PHY RMMI interface clocks */
-void ufs_qcom_phy_disable_iface_clk(struct phy *generic_phy)
+void ufs_qcom_phy_disable_iface_clk(struct ufs_qcom_phy *phy)
 {
-	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
-
 	if (phy->is_iface_clk_enabled) {
 		clk_disable_unprepare(phy->tx_iface_clk);
 		clk_disable_unprepare(phy->rx_iface_clk);
 		phy->is_iface_clk_enabled = false;
 	}
 }
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_iface_clk);
 
 int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
 {
@@ -667,13 +657,20 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 		goto out_disable_phy;
 	}
 
-	err = ufs_qcom_phy_enable_ref_clk(generic_phy);
+	err = ufs_qcom_phy_enable_iface_clk(phy_common);
 	if (err) {
-		dev_err(dev, "%s enable phy ref clock failed, err=%d\n",
+		dev_err(dev, "%s enable phy iface clock failed, err=%d\n",
 			__func__, err);
 		goto out_disable_pll;
 	}
 
+	err = ufs_qcom_phy_enable_ref_clk(phy_common);
+	if (err) {
+		dev_err(dev, "%s enable phy ref clock failed, err=%d\n",
+			__func__, err);
+		goto out_disable_iface_clk;
+	}
+
 	/* enable device PHY ref_clk pad rail */
 	if (phy_common->vddp_ref_clk.reg) {
 		err = ufs_qcom_phy_enable_vreg(dev,
@@ -689,7 +686,9 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 	goto out;
 
 out_disable_ref_clk:
-	ufs_qcom_phy_disable_ref_clk(generic_phy);
+	ufs_qcom_phy_disable_ref_clk(phy_common);
+out_disable_iface_clk:
+	ufs_qcom_phy_disable_iface_clk(phy_common);
 out_disable_pll:
 	ufs_qcom_phy_disable_vreg(dev, &phy_common->vdda_pll);
 out_disable_phy:
@@ -708,7 +707,8 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
 	if (phy_common->vddp_ref_clk.reg)
 		ufs_qcom_phy_disable_vreg(phy_common->dev,
 					  &phy_common->vddp_ref_clk);
-	ufs_qcom_phy_disable_ref_clk(generic_phy);
+	ufs_qcom_phy_disable_ref_clk(phy_common);
+	ufs_qcom_phy_disable_iface_clk(phy_common);
 
 	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_pll);
 	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_phy);
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 3aedf73..3a86ff3 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1112,17 +1112,8 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
 		return 0;
 
 	if (on) {
-		err = ufs_qcom_phy_enable_iface_clk(host->generic_phy);
-		if (err)
-			goto out;
+		phy_power_on(host->generic_phy);
 
-		err = ufs_qcom_phy_enable_ref_clk(host->generic_phy);
-		if (err) {
-			dev_err(hba->dev, "%s enable phy ref clock failed, err=%d\n",
-				__func__, err);
-			ufs_qcom_phy_disable_iface_clk(host->generic_phy);
-			goto out;
-		}
 		/* enable the device ref clock for HS mode*/
 		if (ufshcd_is_hs_mode(&hba->pwr_info))
 			ufs_qcom_dev_ref_clk_ctrl(host, true);
@@ -1131,13 +1122,14 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
 			ufs_qcom_update_bus_bw_vote(host);
 
 	} else {
-
-		/* M-PHY RMMI interface clocks can be turned off */
-		ufs_qcom_phy_disable_iface_clk(host->generic_phy);
-		if (!ufs_qcom_is_link_active(hba))
+		if (!ufs_qcom_is_link_active(hba)) {
 			/* disable device ref_clk */
 			ufs_qcom_dev_ref_clk_ctrl(host, false);
 
+			/* powering off PHY during aggressive clk gating */
+			phy_power_off(host->generic_phy);
+		}
+
 		vote = host->bus_vote.min_bw_vote;
 	}
 
@@ -1146,7 +1138,6 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
 		dev_err(hba->dev, "%s: set bus vote failed %d\n",
 				__func__, err);
 
-out:
 	return err;
 }
 
diff --git a/include/linux/phy/phy-qcom-ufs.h b/include/linux/phy/phy-qcom-ufs.h
index 9d18e9f..35c070e 100644
--- a/include/linux/phy/phy-qcom-ufs.h
+++ b/include/linux/phy/phy-qcom-ufs.h
@@ -18,22 +18,6 @@
 #include "phy.h"
 
 /**
- * ufs_qcom_phy_enable_ref_clk() - Enable the phy
- * ref clock.
- * @phy: reference to a generic phy
- *
- * returns 0 for success, and non-zero for error.
- */
-int ufs_qcom_phy_enable_ref_clk(struct phy *phy);
-
-/**
- * ufs_qcom_phy_disable_ref_clk() - Disable the phy
- * ref clock.
- * @phy: reference to a generic phy.
- */
-void ufs_qcom_phy_disable_ref_clk(struct phy *phy);
-
-/**
  * ufs_qcom_phy_enable_dev_ref_clk() - Enable the device
  * ref clock.
  * @phy: reference to a generic phy.
@@ -47,8 +31,6 @@
  */
 void ufs_qcom_phy_disable_dev_ref_clk(struct phy *phy);
 
-int ufs_qcom_phy_enable_iface_clk(struct phy *phy);
-void ufs_qcom_phy_disable_iface_clk(struct phy *phy);
 int ufs_qcom_phy_start_serdes(struct phy *phy);
 int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes);
 int ufs_qcom_phy_calibrate_phy(struct phy *phy, bool is_rate_B);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
