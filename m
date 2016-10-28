From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 3/4] scsi: ufs: suspend clock scaling at the start of suspend
Date: Thu, 27 Oct 2016 17:26:09 -0700
Message-ID: <1477614369-5484-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942875AbcJ1A0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2016 20:26:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Currently clock scaling is suspended only after the host and device
are put in low power mode but we should avoid clock scaling running
after UFS link is put in low power mode (hibern8). This change
suspends clock scaling before putting host/device in low power mode.

Reviewed-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6c0082e..9ed96ae 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5892,6 +5892,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_hold(hba, false);
 	hba->clk_gating.is_suspended = true;
 
+	ufshcd_suspend_clkscaling(hba);
+
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
 		goto disable_clks;
@@ -5899,12 +5901,12 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
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
@@ -5941,13 +5943,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
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
@@ -5983,6 +5978,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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

