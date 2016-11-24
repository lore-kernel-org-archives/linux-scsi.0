From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 10/11] scsi: ufs: optimize system suspend handling
Date: Wed, 23 Nov 2016 16:33:08 -0800
Message-ID: <1479947588-7297-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51914 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934917AbcKXAdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2016 19:33:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Consider following sequence of events:
1. UFS is runtime suspended, link_state = Hibern8, device_state = sleep
2. System goes into system suspend, ufshcd_system_suspend() brings both
   link and device to active state and then puts the device in Power_Down
   state and link in OFF state.
3. System resumes at some later point in time, ufshcd_system_resume()
   doesn't do anything as UFS state is runtime suspended. Note that link
   is still on OFF state and device is in Power_Down state.
4. Now system again goes into suspend without any UFS accesses before it.
   ufshcd_system_suspend() again brings both link and device to active
   state and then puts the device in Power_Down state and link if OFF
   state. But it's unnecessary to bring the link & device in active state
   as both link and device are already in desired low power states. This
   change fixes this issue by adding proper state checks in
   ufshcd_system_suspend().

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b826078..4b6cc07 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6272,16 +6272,13 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if (!hba || !hba->is_powered)
 		return 0;
 
-	if (pm_runtime_suspended(hba->dev)) {
-		if (hba->rpm_lvl == hba->spm_lvl)
-			/*
-			 * There is possibility that device may still be in
-			 * active state during the runtime suspend.
-			 */
-			if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
-			    hba->curr_dev_pwr_mode) && !hba->auto_bkops_enabled)
-				goto out;
+	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
+	     hba->curr_dev_pwr_mode) &&
+	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
+	     hba->uic_link_state))
+		goto out;
 
+	if (pm_runtime_suspended(hba->dev)) {
 		/*
 		 * UFS device and/or UFS link low power states during runtime
 		 * suspend seems to be different than what is expected during
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

