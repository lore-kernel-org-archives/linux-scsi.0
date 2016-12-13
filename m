From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 08/12] scsi: ufs: add capability to keep auto bkops always enabled
Date: Mon, 12 Dec 2016 16:54:42 -0800
Message-ID: <1481590482-17207-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58912 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbcLMAyv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2016 19:54:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

UFS device requires to perform bkops (back ground operations) periodically
but host can control (via auto-bkops parameter of device) when device can
perform bkops based on its performance requirements. In general, host
would like to enable the device's auto-bkops only when it's not doing any
regular data transfer but sometimes device may not behave properly if host
keeps the auto-bkops disabled. This change adds the capability to let the
device auto-bkops always enabled except suspend.

Reviewed-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 33 ++++++++++++++++++++++-----------
 drivers/scsi/ufs/ufshcd.h | 13 +++++++++++++
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 43f9b44..53755d3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4161,18 +4161,25 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_force_reset_auto_bkops - force enable of auto bkops
+ * ufshcd_force_reset_auto_bkops - force reset auto bkops state
  * @hba: per adapter instance
  *
  * After a device reset the device may toggle the BKOPS_EN flag
  * to default value. The s/w tracking variables should be updated
- * as well. Do this by forcing enable of auto bkops.
+ * as well. This function would change the auto-bkops state based on
+ * UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND.
  */
-static void  ufshcd_force_reset_auto_bkops(struct ufs_hba *hba)
+static void ufshcd_force_reset_auto_bkops(struct ufs_hba *hba)
 {
-	hba->auto_bkops_enabled = false;
-	hba->ee_ctrl_mask |= MASK_EE_URGENT_BKOPS;
-	ufshcd_enable_auto_bkops(hba);
+	if (ufshcd_keep_autobkops_enabled_except_suspend(hba)) {
+		hba->auto_bkops_enabled = false;
+		hba->ee_ctrl_mask |= MASK_EE_URGENT_BKOPS;
+		ufshcd_enable_auto_bkops(hba);
+	} else {
+		hba->auto_bkops_enabled = true;
+		hba->ee_ctrl_mask &= ~MASK_EE_URGENT_BKOPS;
+		ufshcd_disable_auto_bkops(hba);
+	}
 }
 
 static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
@@ -6594,11 +6601,15 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			goto set_old_link_state;
 	}
 
-	/*
-	 * If BKOPs operations are urgently needed at this moment then
-	 * keep auto-bkops enabled or else disable it.
-	 */
-	ufshcd_urgent_bkops(hba);
+	if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
+		ufshcd_enable_auto_bkops(hba);
+	else
+		/*
+		 * If BKOPs operations are urgently needed at this moment then
+		 * keep auto-bkops enabled or else disable it.
+		 */
+		ufshcd_urgent_bkops(hba);
+
 	hba->clk_gating.is_suspended = false;
 
 	if (hba->clk_scaling.is_allowed)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 97fbe4a..05d2055 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -566,6 +566,14 @@ struct ufs_hba {
 	 * CAUTION: Enabling this might reduce overall UFS throughput.
 	 */
 #define UFSHCD_CAP_INTR_AGGR (1 << 4)
+	/*
+	 * This capability allows the device auto-bkops to be always enabled
+	 * except during suspend (both runtime and suspend).
+	 * Enabling this capability means that device will always be allowed
+	 * to do background operation when it's active but it might degrade
+	 * the performance of ongoing read/write operations.
+	 */
+#define UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND (1 << 5)
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
@@ -663,6 +671,11 @@ static inline void *ufshcd_get_variant(struct ufs_hba *hba)
 	BUG_ON(!hba);
 	return hba->priv;
 }
+static inline bool ufshcd_keep_autobkops_enabled_except_suspend(
+							struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND;
+}
 
 extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
 extern int ufshcd_runtime_resume(struct ufs_hba *hba);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

