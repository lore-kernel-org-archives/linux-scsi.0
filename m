Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94820C433F4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75D7D2080D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgGWLqw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 07:46:52 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:16314 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbgGWLqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 07:46:52 -0400
IronPort-SDR: 5I6T6aLhFbQLvX4BRhmK3Mq+ubNzJjF7QIrnBf/NgHayUia2vkEc6VZyKlc0jj13g8WJSBr0O1
 1oXasPCIz7f9XknoRFmpAk1THe4a9GSozl9fyxVIGviQZQmkPIKzB3kKJaE+uI+Cm8iLRFHJin
 5ZzQbamHFplMfTeRLgA5mFJ4ZlONWpgEoWuAfh1IqduElAY4t/2hSn8eDJd00XrjlqxoLmgChd
 IH1J9UzLobcJGVc1qKNKDFw28asviRJiNvDK0zJUODRcn1L41nSbXH836NUVvYfJjXnulU2Lc2
 NHo=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="29048254"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 23 Jul 2020 04:46:50 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg04-sd.qualcomm.com with ESMTP; 23 Jul 2020 04:46:49 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 1FA8722E23; Thu, 23 Jul 2020 04:46:49 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        sh425.lee@samsung.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 5/8] scsi: ufs: Fix concurrency of error handler and other error recovery paths
Date:   Thu, 23 Jul 2020 04:46:23 -0700
Message-Id: <1595504787-19429-6-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595504787-19429-1-git-send-email-cang@codeaurora.org>
References: <1595504787-19429-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Error recovery can be invoked from multiple paths, including hibern8
enter/exit, some vendor vops, ufshcd_eh_host_reset_handler(), resume and
eh_work scheduled from IRQ context. Ultimately, these paths are trying to
invoke ufshcd_reset_and_restore(), in either sync or async manner.

Having both sync and async manners at the same time has some problems

- If link recovery happens during clock scaling work, acquring scaling_lock
  in ufshcd_exec_dev_cmd() would cause dead lock, because scaling_lock is
  already held by scaling work before link recovery happens.

- If link recovery happens during ungate work, ufshcd_hold() would be
  called recursively. Although commit 53c12d0ef6fcb
  ("scsi: ufs: fix error recovery after the hibern8 exit failure") [1]
  fixed a deadlock due to recursive calls of ufshcd_hold() by adding a
  check of eh_in_progress into ufshcd_hold, this check allows eh_work to
  run in parallel when link recovery is running.

- Similar concurrency can also happen when error recovery is invoked from
  eh_host_reset_handler. Although it tries to avoid that from happening
  by flushing eh_work before start invoking reset and restore, after flush
  work returns, eh_work can still be scheduled and running in parallel.

- Concurrency can even happen between eh_works. eh_work, currently queued
  on system_wq, is allowed to have multiple instances running in parallel,
  but we don't have proper protection for that.

If any of above concurrency happens, error recovery would fail and lead
ufs device and host into bad states. To fix the concurrency problem, this
change queues eh_work on a single threaded workqueue and remove link
recovery calls from hibern8 enter/exit path. Meanwhile, make use of eh_work
in eh_host_reset_handler instead of calling ufshcd_reset_and_restore. This
unifies UFS error recovery mechanism.

In addition, according to the UFSHCI JEDEC spec, hibern8 enter/exit error
occurs when the link is broken. This essentially applies to any power mode
change operations (since they all use PACP_PWR cmds in UniPro layer). So,
in this change, if a power mode change operation (including AH8 enter/exit)
fails, mark link state as UIC_LINK_BROKEN_STATE and schedule the eh_work.
In this case, error handler needs to do a full reset and restore to recover
the link back to active. Before the link state is recovered to active,
ufshcd_uic_pwr_ctrl simply returns -ENOLINK to avoid more errors.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-sysfs.c |   1 +
 drivers/scsi/ufs/ufshcd.c    | 268 +++++++++++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h    |   9 ++
 3 files changed, 151 insertions(+), 127 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 2d71d23..02d379f00 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -16,6 +16,7 @@ static const char *ufschd_uic_link_state_to_string(
 	case UIC_LINK_OFF_STATE:	return "OFF";
 	case UIC_LINK_ACTIVE_STATE:	return "ACTIVE";
 	case UIC_LINK_HIBERN8_STATE:	return "HIBERN8";
+	case UIC_LINK_BROKEN_STATE:	return "BROKEN";
 	default:			return "UNKNOWN";
 	}
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index eda4dc6..c2d7a90 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -228,6 +228,7 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
+static void ufshcd_schedule_eh_work(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
 static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
@@ -1571,11 +1572,6 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->clk_gating.active_reqs++;
 
-	if (ufshcd_eh_in_progress(hba)) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		return 0;
-	}
-
 start:
 	switch (hba->clk_gating.state) {
 	case CLKS_ON:
@@ -1653,6 +1649,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 	struct ufs_hba *hba = container_of(work, struct ufs_hba,
 			clk_gating.gate_work.work);
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	/*
@@ -1679,8 +1676,11 @@ static void ufshcd_gate_work(struct work_struct *work)
 
 	/* put the link into hibern8 mode before turning off clocks */
 	if (ufshcd_can_hibern8_during_gating(hba)) {
-		if (ufshcd_uic_hibern8_enter(hba)) {
+		ret = ufshcd_uic_hibern8_enter(hba);
+		if (ret) {
 			hba->clk_gating.state = CLKS_ON;
+			dev_err(hba->dev, "%s: hibern8 enter failed %d\n",
+					__func__, ret);
 			trace_ufshcd_clk_gating(dev_name(hba->dev),
 						hba->clk_gating.state);
 			goto out;
@@ -1725,11 +1725,10 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	hba->clk_gating.active_reqs--;
 
-	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended
-		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
-		|| hba->active_uic_cmd || hba->uic_async_done
-		|| ufshcd_eh_in_progress(hba))
+	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
+	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
+	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
+	    hba->active_uic_cmd || hba->uic_async_done)
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
@@ -3750,6 +3749,10 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	ufshcd_add_delay_before_dme_cmd(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (ufshcd_is_link_broken(hba)) {
+		ret = -ENOLINK;
+		goto out_unlock;
+	}
 	hba->uic_async_done = &uic_async_done;
 	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
 		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
@@ -3797,6 +3800,11 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	hba->uic_async_done = NULL;
 	if (reenable_intr)
 		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
+	if (ret) {
+		ufshcd_set_link_broken(hba);
+		ufshcd_schedule_eh_work(hba);
+	}
+out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
@@ -3866,7 +3874,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_link_recovery);
 
-static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
 	int ret;
 	struct uic_command uic_cmd = {0};
@@ -3879,45 +3887,16 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "enter",
 			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
-	if (ret) {
-		int err;
-
+	if (ret)
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
 			__func__, ret);
-
-		/*
-		 * If link recovery fails then return error code returned from
-		 * ufshcd_link_recovery().
-		 * If link recovery succeeds then return -EAGAIN to attempt
-		 * hibern8 enter retry again.
-		 */
-		err = ufshcd_link_recovery(hba);
-		if (err) {
-			dev_err(hba->dev, "%s: link recovery failed", __func__);
-			ret = err;
-		} else {
-			ret = -EAGAIN;
-		}
-	} else
+	else
 		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
 								POST_CHANGE);
 
 	return ret;
 }
 
-static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
-{
-	int ret = 0, retries;
-
-	for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; retries--) {
-		ret = __ufshcd_uic_hibern8_enter(hba);
-		if (!ret)
-			goto out;
-	}
-out:
-	return ret;
-}
-
 int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {0};
@@ -3934,7 +3913,6 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	if (ret) {
 		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
 			__func__, ret);
-		ret = ufshcd_link_recovery(hba);
 	} else {
 		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
 								POST_CHANGE);
@@ -5557,6 +5535,24 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 	return err_handling;
 }
 
+/* host lock must be held before calling this func */
+static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
+{
+	return ((hba->saved_err & INT_FATAL_ERRORS) ||
+		((hba->saved_err & UIC_ERROR) &&
+		 (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR)));
+}
+
+/* host lock must be held before calling this func */
+static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
+{
+	/* handle fatal errors only when link is not in error state */
+	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
+		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
+		queue_work(hba->eh_wq, &hba->eh_work);
+	}
+}
+
 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
  * @work: pointer to work structure
@@ -5573,15 +5569,22 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	hba = container_of(work, struct ufs_hba, eh_work);
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->ufshcd_state == UFSHCD_STATE_ERROR ||
+	    (!(hba->saved_err || hba->saved_uic_err || hba->force_reset) &&
+	     !ufshcd_is_link_broken(hba))) {
+		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
+			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		return;
+	}
+	ufshcd_set_eh_in_progress(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	pm_runtime_get_sync(hba->dev);
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-		goto out;
-
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
-	ufshcd_set_eh_in_progress(hba);
 
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
@@ -5593,15 +5596,15 @@ static void ufshcd_err_handler(struct work_struct *work)
 		/* release the lock as ufshcd_quirk_dl_nac_errors() may sleep */
 		ret = ufshcd_quirk_dl_nac_errors(hba);
 		spin_lock_irqsave(hba->host->host_lock, flags);
-		if (!ret)
+		if (!ret && !hba->force_reset && ufshcd_is_link_active(hba))
 			goto skip_err_handling;
 	}
-	if ((hba->saved_err & INT_FATAL_ERRORS) ||
-	    (hba->saved_err & UFSHCD_UIC_HIBERN8_MASK) ||
+
+	if (hba->force_reset || ufshcd_is_link_broken(hba) ||
+	    ufshcd_is_saved_err_fatal(hba) ||
 	    ((hba->saved_err & UIC_ERROR) &&
-	    (hba->saved_uic_err & (UFSHCD_UIC_DL_PA_INIT_ERROR |
-				   UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
-				   UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
+	     (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
+				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
 		needs_reset = true;
 
 	/*
@@ -5655,34 +5658,25 @@ static void ufshcd_err_handler(struct work_struct *work)
 			__ufshcd_transfer_req_compl(hba,
 						    (1UL << (hba->nutrs - 1)));
 
+		hba->force_reset = false;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		err = ufshcd_reset_and_restore(hba);
 		spin_lock_irqsave(hba->host->host_lock, flags);
-		if (err) {
-			dev_err(hba->dev, "%s: reset and restore failed\n",
-					__func__);
-			hba->ufshcd_state = UFSHCD_STATE_ERROR;
-		}
-		/*
-		 * Inform scsi mid-layer that we did reset and allow to handle
-		 * Unit Attention properly.
-		 */
-		scsi_report_bus_reset(hba->host, 0);
-		hba->saved_err = 0;
-		hba->saved_uic_err = 0;
+		if (err)
+			dev_err(hba->dev, "%s: reset and restore failed with err %d\n",
+					__func__, err);
 	}
 
 skip_err_handling:
 	if (!needs_reset) {
-		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
+			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 		if (hba->saved_err || hba->saved_uic_err)
 			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x saved_uic_err 0x%x",
 			    __func__, hba->saved_err, hba->saved_uic_err);
 	}
 
 	ufshcd_clear_eh_in_progress(hba);
-
-out:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
@@ -5816,6 +5810,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 			hba->errors, ufshcd_get_upmcrs(hba));
 		ufshcd_update_reg_hist(&hba->ufs_stats.auto_hibern8_err,
 				       hba->errors);
+		ufshcd_set_link_broken(hba);
 		queue_eh_work = true;
 	}
 
@@ -5827,30 +5822,25 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 		hba->saved_err |= hba->errors;
 		hba->saved_uic_err |= hba->uic_error;
 
-		/* handle fatal errors only when link is functional */
-		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
-			/* block commands from scsi mid-layer */
-			ufshcd_scsi_block_requests(hba);
-
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
+		/* block commands from scsi mid-layer */
+		ufshcd_scsi_block_requests(hba);
 
-			/* dump controller state before resetting */
-			if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
-				bool pr_prdt = !!(hba->saved_err &
-						SYSTEM_BUS_FATAL_ERROR);
+		/* dump controller state before resetting */
+		if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
+			bool pr_prdt = !!(hba->saved_err &
+					SYSTEM_BUS_FATAL_ERROR);
 
-				dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
+			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
 					__func__, hba->saved_err,
 					hba->saved_uic_err);
 
-				ufshcd_print_host_regs(hba);
-				ufshcd_print_pwr_info(hba);
-				ufshcd_print_tmrs(hba, hba->outstanding_tasks);
-				ufshcd_print_trs(hba, hba->outstanding_reqs,
-							pr_prdt);
-			}
-			schedule_work(&hba->eh_work);
+			ufshcd_print_host_regs(hba);
+			ufshcd_print_pwr_info(hba);
+			ufshcd_print_tmrs(hba, hba->outstanding_tasks);
+			ufshcd_print_trs(hba, hba->outstanding_reqs,
+					pr_prdt);
 		}
+		ufshcd_schedule_eh_work(hba);
 		retval |= IRQ_HANDLED;
 	}
 	/*
@@ -6595,8 +6585,6 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	/* Establish the link again and restore the device */
 	err = ufshcd_probe_hba(hba, false);
 
-	if (!err && (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL))
-		err = -EIO;
 out:
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
@@ -6615,9 +6603,23 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
  */
 static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 {
+	u32 saved_err;
+	u32 saved_uic_err;
 	int err = 0;
+	unsigned long flags;
 	int retries = MAX_HOST_RESET_RETRIES;
 
+	/*
+	 * This is a fresh start, cache and clear saved error first,
+	 * in case new error generated during reset and restore.
+	 */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	saved_err = hba->saved_err;
+	saved_uic_err = hba->saved_uic_err;
+	hba->saved_err = 0;
+	hba->saved_uic_err = 0;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	do {
 		/* Reset the attached device */
 		ufshcd_vops_device_reset(hba);
@@ -6625,6 +6627,18 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 		err = ufshcd_host_reset_and_restore(hba);
 	} while (err && --retries);
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	/*
+	 * Inform scsi mid-layer that we did reset and allow to handle
+	 * Unit Attention properly.
+	 */
+	scsi_report_bus_reset(hba->host, 0);
+	if (err) {
+		hba->saved_err |= saved_err;
+		hba->saved_uic_err |= saved_uic_err;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	return err;
 }
 
@@ -6636,48 +6650,25 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
  */
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	int err;
+	int err = SUCCESS;
 	unsigned long flags;
 	struct ufs_hba *hba;
 
 	hba = shost_priv(cmd->device->host);
 
-	ufshcd_hold(hba, false);
-	/*
-	 * Check if there is any race with fatal error handling.
-	 * If so, wait for it to complete. Even though fatal error
-	 * handling does reset and restore in some cases, don't assume
-	 * anything out of it. We are just avoiding race here.
-	 */
-	do {
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		if (!(work_pending(&hba->eh_work) ||
-			    hba->ufshcd_state == UFSHCD_STATE_RESET ||
-			    hba->ufshcd_state == UFSHCD_STATE_EH_SCHEDULED))
-			break;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		dev_dbg(hba->dev, "%s: reset in progress\n", __func__);
-		flush_work(&hba->eh_work);
-	} while (1);
-
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
-	ufshcd_set_eh_in_progress(hba);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->force_reset = true;
+	ufshcd_schedule_eh_work(hba);
+	dev_err(hba->dev, "%s: reset in progress - 1\n", __func__);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	err = ufshcd_reset_and_restore(hba);
+	flush_work(&hba->eh_work);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (!err) {
-		err = SUCCESS;
-		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-	} else {
+	if (hba->ufshcd_state == UFSHCD_STATE_ERROR)
 		err = FAILED;
-		hba->ufshcd_state = UFSHCD_STATE_ERROR;
-	}
-	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	ufshcd_release(hba);
 	return err;
 }
 
@@ -7398,6 +7389,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 {
 	int ret;
+	unsigned long flags;
 	ktime_t start = ktime_get();
 
 	ret = ufshcd_link_startup(hba);
@@ -7462,14 +7454,17 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	 */
 	ufshcd_set_active_icc_lvl(hba);
 
-	/* set the state as operational after switching to desired gear */
-	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-
 	ufshcd_wb_config(hba);
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
 out:
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (ret)
+		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+	else if (hba->ufshcd_state == UFSHCD_STATE_RESET)
+		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	trace_ufshcd_init(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
@@ -8076,10 +8071,13 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
 
 	if (req_link_state == UIC_LINK_HIBERN8_STATE) {
 		ret = ufshcd_uic_hibern8_enter(hba);
-		if (!ret)
+		if (!ret) {
 			ufshcd_set_link_hibern8(hba);
-		else
+		} else {
+			dev_err(hba->dev, "%s: hibern8 enter failed %d\n",
+					__func__, ret);
 			goto out;
+		}
 	}
 	/*
 	 * If autobkops is enabled, link can't be turned off because
@@ -8095,8 +8093,11 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
 		 * unipro. But putting the link in hibern8 is much faster.
 		 */
 		ret = ufshcd_uic_hibern8_enter(hba);
-		if (ret)
+		if (ret) {
+			dev_err(hba->dev, "%s: hibern8 enter failed %d\n",
+					__func__, ret);
 			goto out;
+		}
 		/*
 		 * Change controller state to "reset state" which
 		 * should also put the link in off/reset state
@@ -8405,10 +8406,13 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (ufshcd_is_link_hibern8(hba)) {
 		ret = ufshcd_uic_hibern8_exit(hba);
-		if (!ret)
+		if (!ret) {
 			ufshcd_set_link_active(hba);
-		else
+		} else {
+			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
+					__func__, ret);
 			goto vendor_suspend;
+		}
 	} else if (ufshcd_is_link_off(hba)) {
 		/*
 		 * A full initialization of the host and the device is
@@ -8782,6 +8786,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	int err;
 	struct Scsi_Host *host = hba->host;
 	struct device *dev = hba->dev;
+	char eh_wq_name[sizeof("ufs_eh_wq_00")];
 
 	if (!mmio_base) {
 		dev_err(hba->dev,
@@ -8843,6 +8848,15 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->max_pwr_info.is_valid = false;
 
 	/* Initialize work queues */
+	snprintf(eh_wq_name, sizeof(eh_wq_name), "ufs_eh_wq_%d",
+		 hba->host->host_no);
+	hba->eh_wq = create_singlethread_workqueue(eh_wq_name);
+	if (!hba->eh_wq) {
+		dev_err(hba->dev, "%s: failed to create eh workqueue\n",
+				__func__);
+		err = -ENOMEM;
+		goto out_disable;
+	}
 	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5b2cdaf..83e5cd9 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -90,6 +90,7 @@ enum uic_link_state {
 	UIC_LINK_OFF_STATE	= 0, /* Link powered down or disabled */
 	UIC_LINK_ACTIVE_STATE	= 1, /* Link is in Fast/Slow/Sleep state */
 	UIC_LINK_HIBERN8_STATE	= 2, /* Link is in Hibernate state */
+	UIC_LINK_BROKEN_STATE	= 3, /* Link is in broken state */
 };
 
 #define ufshcd_is_link_off(hba) ((hba)->uic_link_state == UIC_LINK_OFF_STATE)
@@ -97,11 +98,15 @@ enum uic_link_state {
 				    UIC_LINK_ACTIVE_STATE)
 #define ufshcd_is_link_hibern8(hba) ((hba)->uic_link_state == \
 				    UIC_LINK_HIBERN8_STATE)
+#define ufshcd_is_link_broken(hba) ((hba)->uic_link_state == \
+				   UIC_LINK_BROKEN_STATE)
 #define ufshcd_set_link_off(hba) ((hba)->uic_link_state = UIC_LINK_OFF_STATE)
 #define ufshcd_set_link_active(hba) ((hba)->uic_link_state = \
 				    UIC_LINK_ACTIVE_STATE)
 #define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
 				    UIC_LINK_HIBERN8_STATE)
+#define ufshcd_set_link_broken(hba) ((hba)->uic_link_state = \
+				    UIC_LINK_BROKEN_STATE)
 
 #define ufshcd_set_ufs_dev_active(h) \
 	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
@@ -613,12 +618,14 @@ struct ufs_hba_variant_params {
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
  * @is_powered: flag to check if HBA is powered
+ * @eh_wq: Workqueue that eh_work works on
  * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
  * @uic_error: UFS interconnect layer error status
  * @saved_err: sticky error mask
  * @saved_uic_err: sticky UIC error mask
+ * @force_reset: flag to force eh_work perform a full reset
  * @silence_err_logs: flag to silence error logs
  * @dev_cmd: ufs device management command information
  * @last_dme_cmd_tstamp: time stamp of the last completed DME command
@@ -707,6 +714,7 @@ struct ufs_hba {
 	bool is_powered;
 
 	/* Work Queues */
+	struct workqueue_struct *eh_wq;
 	struct work_struct eh_work;
 	struct work_struct eeh_work;
 
@@ -716,6 +724,7 @@ struct ufs_hba {
 	u32 saved_err;
 	u32 saved_uic_err;
 	struct ufs_stats ufs_stats;
+	bool force_reset;
 	bool silence_err_logs;
 
 	/* Device management request data */
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

