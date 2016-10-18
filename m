From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 08/11] scsi: ufs: suspend clock scaling at the start of suspend
Date: Mon, 17 Oct 2016 17:10:28 -0700
Message-ID: <1476749429-11365-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43895 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030388AbcJRAKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 20:10:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Currently clock scaling is suspended only after the host and device
are put in low power mode but we should avoid clock scaling running
after UFS link is put in low power mode (hibern8). This change
suspends clock scaling before putting host/device in low power mode.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fced52f..43f1c55 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5870,6 +5870,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_hold(hba, false);
 	hba->clk_gating.is_suspended = true;
 
+	ufshcd_suspend_clkscaling(hba);
+
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
 		goto disable_clks;
@@ -5877,12 +5879,12 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if ((req_dev_pwr_mode == hba->curr_dev_pwr_mode) &&
 	    (req_link_state == hba->uic_link_state))
-		goto out;
+		goto enable_gating;
 
 	/* UFS device & link must be active before we enter in this function */
 	if (!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba)) {
 		ret = -EINVAL;
-		goto out;
+		goto enable_gating;
 	}
 
 	if (ufshcd_is_runtime_pm(pm_op)) {
@@ -5919,13 +5921,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 disable_clks:
 	/*
-	 * The clock scaling needs access to controller registers. Hence, Wait
-	 * for pending clock scaling work to be done before clocks are
-	 * turned off.
-	 */
-	ufshcd_suspend_clkscaling(hba);
-
-	/*
 	 * Call vendor specific suspend callback. As these callbacks may access
 	 * vendor specific host controller register space call them before the
 	 * host clocks are ON.
@@ -5961,6 +5956,7 @@ set_dev_active:
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
 		ufshcd_disable_auto_bkops(hba);
 enable_gating:
+	ufshcd_resume_clkscaling(hba);
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
 out:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

