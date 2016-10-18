From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 7/7] ufs-qcom: phy/hcd: Refactoring phy clock handling
Date: Tue, 18 Oct 2016 10:19:05 +0530
Message-ID: <1476766145-27583-8-git-send-email-vivek.gautam@codeaurora.org>
References: <1476766145-27583-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1476766145-27583-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Add phy clock enable code to phy_power_on/off callbacks, and
remove explicit calls to enable these phy clocks from the
ufs-qcom hcd driver.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/phy/phy-qcom-ufs.c  | 12 +++++++++++-
 drivers/scsi/ufs/ufs-qcom.c | 15 ---------------
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 3a87e88..687b9b7 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -681,11 +681,18 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 		goto out_disable_phy;
 	}
 
+	err = ufs_qcom_phy_enable_iface_clk(generic_phy);
+	if (err) {
+		dev_err(dev, "%s enable phy iface clock failed, err=%d\n",
+			__func__, err);
+		goto out_disable_pll;
+	}
+
 	err = ufs_qcom_phy_enable_ref_clk(generic_phy);
 	if (err) {
 		dev_err(dev, "%s enable phy ref clock failed, err=%d\n",
 			__func__, err);
-		goto out_disable_pll;
+		goto out_disable_iface_clk;
 	}
 
 	/* enable device PHY ref_clk pad rail */
@@ -704,6 +711,8 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 
 out_disable_ref_clk:
 	ufs_qcom_phy_disable_ref_clk(generic_phy);
+out_disable_iface_clk:
+	ufs_qcom_phy_disable_iface_clk(generic_phy);
 out_disable_pll:
 	ufs_qcom_phy_disable_vreg(dev, &phy_common->vdda_pll);
 out_disable_phy:
@@ -723,6 +732,7 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
 		ufs_qcom_phy_disable_vreg(phy_common->dev,
 					  &phy_common->vddp_ref_clk);
 	ufs_qcom_phy_disable_ref_clk(generic_phy);
+	ufs_qcom_phy_disable_iface_clk(generic_phy);
 
 	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_pll);
 	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_phy);
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 3aedf73..6e4ce5f 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1112,17 +1112,6 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
 		return 0;
 
 	if (on) {
-		err = ufs_qcom_phy_enable_iface_clk(host->generic_phy);
-		if (err)
-			goto out;
-
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
@@ -1131,9 +1120,6 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
 			ufs_qcom_update_bus_bw_vote(host);
 
 	} else {
-
-		/* M-PHY RMMI interface clocks can be turned off */
-		ufs_qcom_phy_disable_iface_clk(host->generic_phy);
 		if (!ufs_qcom_is_link_active(hba))
 			/* disable device ref_clk */
 			ufs_qcom_dev_ref_clk_ctrl(host, false);
@@ -1146,7 +1132,6 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
 		dev_err(hba->dev, "%s: set bus vote failed %d\n",
 				__func__, err);
 
-out:
 	return err;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
