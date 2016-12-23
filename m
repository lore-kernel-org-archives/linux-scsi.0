From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v3 07/12] scsi: ufs: set default UFS power management level
Date: Thu, 22 Dec 2016 18:41:11 -0800
Message-ID: <1482460871-6210-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46610 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758186AbcLWClR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2016 21:41:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

UFS device and link can be put in multiple different low power modes hence
UFS driver supports multiple different low power modes.
This change sets the default UFS power management level which should put
the link hibernate state and device in sleep state. This default power
management level gives good  power savings with relatively less enter/exit
latencies.

Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
Changes from v2 -> v3:
 - Simplified patch to just set the default power management level.
   Device tree capability to specify broken hardware will be taken up as
   separate patch in different patch series than current one.
---
 drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 30ee04a..12a2250 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -191,6 +191,22 @@ enum {
 	return ufs_pm_lvl_states[lvl].link_state;
 }
 
+static inline enum ufs_pm_level
+ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
+					enum uic_link_state link_state)
+{
+	enum ufs_pm_level lvl;
+
+	for (lvl = UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++) {
+		if ((ufs_pm_lvl_states[lvl].dev_state == dev_state) &&
+			(ufs_pm_lvl_states[lvl].link_state == link_state))
+			return lvl;
+	}
+
+	/* if no match found, return the level 0 */
+	return UFS_PM_LVL_0;
+}
+
 static struct ufs_dev_fix ufs_fixups[] = {
 	/* UFS cards deviations table */
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
@@ -7264,6 +7280,18 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		ufshcd_clkscaling_init_sysfs(hba);
 	}
 
+	/*
+	 * Set the default power management level for runtime and system PM.
+	 * Default power saving mode is to keep UFS link in Hibern8 state
+	 * and UFS device in sleep state.
+	 */
+	hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+						UFS_SLEEP_PWR_MODE,
+						UIC_LINK_HIBERN8_STATE);
+	hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+						UFS_SLEEP_PWR_MODE,
+						UIC_LINK_HIBERN8_STATE);
+
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

