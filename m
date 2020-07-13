Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4C6C433E5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 05:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03D0F207BC
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 05:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgGMFDm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 01:03:42 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:32892 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgGMFDl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 01:03:41 -0400
IronPort-SDR: E/nunR0mpylhFxNg0ie6FP6e0Fm0gCtP9reLOUT6gcklqbQBf1Fme1FxUEP0xUOvSJvPLQxH4T
 /PULK3L3maObq92x4JccC+ikrd4bI3AEXceKWu12vVvAGkTPqiyv6slLjtRMjIx0R904ELlVl1
 oWEdRunycxWvsHPd4kBSDaZ4i2385ap5IahsCmqTQfY3w0Q2cwJh5oO95P7z0x6HkEP1S/w26H
 6P6wiFyCUqIVTM1QQlNPcrPuVHkmY7A1Y/MEo6WqcyZhpFOJifpNFZbQl5vSHz4NIcHMaEwPr6
 6B4=
X-IronPort-AV: E=Sophos;i="5.75,346,1589266800"; 
   d="scan'208";a="47215538"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 12 Jul 2020 21:57:37 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg03-sd.qualcomm.com with ESMTP; 12 Jul 2020 21:57:36 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 5272E22DAF; Sun, 12 Jul 2020 21:57:36 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 4/4] scsi: ufs: Fix up and simplify error recovery mechanism
Date:   Sun, 12 Jul 2020 21:57:12 -0700
Message-Id: <1594616232-25080-5-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594616232-25080-1-git-send-email-cang@codeaurora.org>
References: <1594616232-25080-1-git-send-email-cang@codeaurora.org>
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
  ("scsi: ufs: fix error recovery after the hibern8 exit failure") fixed
  a deadlock due to recursive calls of ufshcd_hold() by adding a check
  of eh_in_progress into ufshcd_hold(), this check added to ufshcd_hold()
  allows eh_work to run in parallel when link recovery is running.

- Similar concurrency can also happen to error recovery invoked from
  eh_host_reset_handler(), although it tries to protect it from happening
  by flushing eh_work before start invoking reset and restore, after flush
  work returns, eh_work can still be scheduled and running in parallel.

- Concurrency can even happen between eh_works. eh_work, currently queued
  on system_wq, is allowed to have multiple instances running in parallel,
  but we don't have proper protection for that.

To fix up and simplify error recovery mechanism, this change mainly does
below things

o Queue eh_work on a single threaded workqueue to avoid concurrency between
  eh_works.

o According to the UFSHCI JEDEC spec, hibern8 enter/exit error occurs when
  the link is broken. This actaully applies to any power mode change
  operations. In this change, if a power mode change operation (including
  AH8 enter/exit) fails, mark the link state as UIC_LINK_BROKEN_STATE and
  schedule eh_work. eh_work needs to do full reset and restore to recover
  the link stack to active. Before the link state is recovered back to
  active by eh_work, any power mode change attempts just return -ENOLINK to
  avoid consecutive HW error.

o To avoid concurrency between eh_work and link recovery, remove link
  recovery from hibern8 enter/exit func. If hibern8 enter/exit func fails,
  simply return error code and let eh_work run in parallel.

o Recover UFS hba runtime PM error in eh_work. If ufschd_suspend/resume
  fails due to UFS error, e.g. hibern8 enter/exit error and SSU cmd error,
  the runtime PM framework saves the error to dev.power.runtime_error.
  After that, hba runtime suspend/resume would not be invoked anymore until
  dev.power.runtime_error is cleared. The runtime PM error can be recovered
  in eh_work by calling pm_runtime_set_active() after reset and restore
  succeeds. Meanwhile, if pm_runtime_set_active() returns no error, which
  means dev.power.runtime_error is cleared, we also need to explicitly
  resume those scsi devices under hba in case any of them has failed to be
  resumed due to hba runtime resume error.

o Fix a racing problem between eh_work and ufshcd_suspend/resume. In the
  old code, it blocks scsi requests before schedules eh_work, but when
  eh_work calls pm_runtime_get_sync(), if ufshcd_suspend/resume is sending
  a scsi cmd, most likely the SSU cmd, pm_runtime_get_sync() will never
  return because scsi requests were blocked. To fix this racing problem,
  o Don't block scsi requests before schedule eh_work, but let eh_work
    block scsi requests when eh_work is ready to start error recovery.
  o Meanwhile, if eh_work is schueduled due to fatal error, don't requeue
    the scsi cmds sent from ufshcd_suspend/resume path, but simply let the
    scsi cmds fail. If the scsi cmds fail, hba runtime suspend/resume fails
    too, but it does hurt since eh_work recovers hba runtime PM error.

o Move host/regs dump in ufshcd_check_errors() to eh_work because heavy
  dump in IRQ context can lead to stability issues. In addition, some clean
  up in ufshcd_print_host_regs() and ufshcd_print_host_state().

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-sysfs.c |   1 +
 drivers/scsi/ufs/ufshcd.c    | 441 ++++++++++++++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h    |  15 ++
 3 files changed, 284 insertions(+), 173 deletions(-)

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
index 33214bb..98bd28b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -15,6 +15,8 @@
 #include <linux/of.h>
 #include <linux/bitfield.h>
 #include <linux/blk-pm.h>
+#include <linux/blkdev.h>
+#include <scsi/scsi_device.h>
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -125,7 +127,8 @@ enum {
 	UFSHCD_STATE_RESET,
 	UFSHCD_STATE_ERROR,
 	UFSHCD_STATE_OPERATIONAL,
-	UFSHCD_STATE_EH_SCHEDULED,
+	UFSHCD_STATE_EH_SCHEDULED_FATAL,
+	UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
 };
 
 /* UFSHCD error handling flags */
@@ -228,6 +231,11 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
+static void ufshcd_schedule_eh_work(struct ufs_hba *hba);
+static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
+static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
+static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
+					 struct ufs_vreg *vreg);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
 static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
@@ -411,15 +419,6 @@ static void ufshcd_print_err_hist(struct ufs_hba *hba,
 static void ufshcd_print_host_regs(struct ufs_hba *hba)
 {
 	ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
-	dev_err(hba->dev, "hba->ufs_version = 0x%x, hba->capabilities = 0x%x\n",
-		hba->ufs_version, hba->capabilities);
-	dev_err(hba->dev,
-		"hba->outstanding_reqs = 0x%x, hba->outstanding_tasks = 0x%x\n",
-		(u32)hba->outstanding_reqs, (u32)hba->outstanding_tasks);
-	dev_err(hba->dev,
-		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt = %d\n",
-		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
-		hba->ufs_stats.hibern8_exit_cnt);
 
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.pa_err, "pa_err");
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.dl_err, "dl_err");
@@ -499,6 +498,8 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 
 static void ufshcd_print_host_state(struct ufs_hba *hba)
 {
+	struct scsi_device *sdev_ufs = hba->sdev_ufs_device;
+
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
 	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
 		hba->outstanding_reqs, hba->outstanding_tasks);
@@ -511,12 +512,22 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
 	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
 		hba->auto_bkops_enabled, hba->host->host_self_blocked);
 	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
+	dev_err(hba->dev,
+		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt = %d\n",
+		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
+		hba->ufs_stats.hibern8_exit_cnt);
+	dev_err(hba->dev, "last intr ts=%lld, last intr status=0x%x\n",
+		ktime_to_us(hba->ufs_stats.last_intr_ts),
+		hba->ufs_stats.last_intr_status);
 	dev_err(hba->dev, "error handling flags=0x%x, req. abort count=%d\n",
 		hba->eh_flags, hba->req_abort_count);
-	dev_err(hba->dev, "Host capabilities=0x%x, caps=0x%x\n",
-		hba->capabilities, hba->caps);
+	dev_err(hba->dev, "hba->ufs_version=0x%x, Host capabilities=0x%x, caps=0x%x\n",
+		hba->ufs_version, hba->capabilities, hba->caps);
 	dev_err(hba->dev, "quirks=0x%x, dev. quirks=0x%x\n", hba->quirks,
 		hba->dev_quirks);
+	if (sdev_ufs)
+		dev_err(hba->dev, "UFS dev info: %.8s %.16s rev %.4s\n",
+			sdev_ufs->vendor, sdev_ufs->model, sdev_ufs->rev);
 }
 
 /**
@@ -1568,11 +1579,6 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
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
@@ -1647,6 +1653,7 @@ EXPORT_SYMBOL_GPL(ufshcd_hold);
 
 static void ufshcd_gate_work(struct work_struct *work)
 {
+	int ret;
 	struct ufs_hba *hba = container_of(work, struct ufs_hba,
 			clk_gating.gate_work.work);
 	unsigned long flags;
@@ -1676,8 +1683,11 @@ static void ufshcd_gate_work(struct work_struct *work)
 
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
@@ -1725,8 +1735,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended
 		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
 		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
-		|| hba->active_uic_cmd || hba->uic_async_done
-		|| ufshcd_eh_in_progress(hba))
+		|| hba->active_uic_cmd || hba->uic_async_done)
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
@@ -2505,34 +2514,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	switch (hba->ufshcd_state) {
-	case UFSHCD_STATE_OPERATIONAL:
-		break;
-	case UFSHCD_STATE_EH_SCHEDULED:
-	case UFSHCD_STATE_RESET:
-		err = SCSI_MLQUEUE_HOST_BUSY;
-		goto out_unlock;
-	case UFSHCD_STATE_ERROR:
-		set_host_byte(cmd, DID_ERROR);
-		cmd->scsi_done(cmd);
-		goto out_unlock;
-	default:
-		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
-				__func__, hba->ufshcd_state);
-		set_host_byte(cmd, DID_BAD_TARGET);
-		cmd->scsi_done(cmd);
-		goto out_unlock;
-	}
-
-	/* if error handling is in progress, don't issue commands */
-	if (ufshcd_eh_in_progress(hba)) {
-		set_host_byte(cmd, DID_ERROR);
-		cmd->scsi_done(cmd);
-		goto out_unlock;
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
 	hba->req_abort_count = 0;
 
 	err = ufshcd_hold(hba, true);
@@ -2568,12 +2549,52 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 
-	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	switch (hba->ufshcd_state) {
+	case UFSHCD_STATE_OPERATIONAL:
+	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
+		break;
+	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
+		/*
+		 * If we are here, eh_work is either scheduled or running.
+		 * Before eh_work sets ufshcd_state to STATE_RESET, it flushes
+		 * runtime PM ops by calling pm_runtime_get_sync(). If a scsi
+		 * cmd, e.g. the SSU cmd, is sent by PM ops, it can never be
+		 * finished if we let SCSI layer keep retrying it, which gets
+		 * eh_work stuck forever. Neither can we let it pass, because
+		 * ufs now is not in good status, so the SSU cmd may eventually
+		 * time out, blocking eh_work for too long. So just let it fail.
+		 */
+		if (hba->pm_op_in_progress) {
+			hba->force_reset = true;
+			set_host_byte(cmd, DID_BAD_TARGET);
+			goto out_compl_cmd;
+		}
+		/* fallthrough */
+	case UFSHCD_STATE_RESET:
+		err = SCSI_MLQUEUE_HOST_BUSY;
+		goto out_compl_cmd;
+	case UFSHCD_STATE_ERROR:
+		set_host_byte(cmd, DID_ERROR);
+		goto out_compl_cmd;
+	default:
+		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
+				__func__, hba->ufshcd_state);
+		set_host_byte(cmd, DID_BAD_TARGET);
+		goto out_compl_cmd;
+	}
 	ufshcd_vops_setup_xfer_req(hba, tag, true);
 	ufshcd_send_command(hba, tag);
-out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	goto out;
+
+out_compl_cmd:
+	scsi_dma_unmap(lrbp->cmd);
+	lrbp->cmd = NULL;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_release(hba);
+	if (!err)
+		cmd->scsi_done(cmd);
 out:
 	up_read(&hba->clk_scaling_lock);
 	return err;
@@ -3746,6 +3767,10 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	ufshcd_add_delay_before_dme_cmd(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (ufshcd_is_link_broken(hba)) {
+		ret = -ENOLINK;
+		goto out_unlock;
+	}
 	hba->uic_async_done = &uic_async_done;
 	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
 		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
@@ -3793,6 +3818,12 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	hba->uic_async_done = NULL;
 	if (reenable_intr)
 		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
+	if (ret) {
+		ufshcd_set_link_broken(hba);
+		ufshcd_schedule_eh_work(hba);
+	}
+
+out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
@@ -3862,7 +3893,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_link_recovery);
 
-static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
 	int ret;
 	struct uic_command uic_cmd = {0};
@@ -3875,45 +3906,16 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
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
@@ -3930,7 +3932,6 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	if (ret) {
 		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
 			__func__, ret);
-		ret = ufshcd_link_recovery(hba);
 	} else {
 		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
 								POST_CHANGE);
@@ -5554,6 +5555,28 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
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
+		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
+		    ufshcd_is_saved_err_fatal(hba))
+			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
+		else
+			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
+		queue_work(hba->eh_wq, &hba->eh_work);
+	}
+}
+
 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
  * @work: pointer to work structure
@@ -5561,24 +5584,53 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 static void ufshcd_err_handler(struct work_struct *work)
 {
 	struct ufs_hba *hba;
+	struct Scsi_Host *shost;
+	struct scsi_device *sdev;
 	unsigned long flags;
 	u32 err_xfer = 0;
 	u32 err_tm = 0;
-	int err = 0;
+	int reset_err = -1;
 	int tag;
 	bool needs_reset = false;
 
 	hba = container_of(work, struct ufs_hba, eh_work);
+	shost = hba->host;
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if ((hba->ufshcd_state == UFSHCD_STATE_ERROR) ||
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
+	/*
+	 * Don't assume anything of pm_runtime_get_sync(), if resume fails,
+	 * irq and clocks can be OFF, and powers can be OFF or in LPM.
+	 */
+	ufshcd_setup_vreg(hba, true);
+	ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
+	ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
+	ufshcd_setup_hba_vreg(hba, true);
+	ufshcd_enable_irq(hba);
+
 	ufshcd_hold(hba, false);
+	if (!ufshcd_is_clkgating_allowed(hba))
+		ufshcd_setup_clocks(hba, true);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-		goto out;
+	if (ufshcd_is_clkscaling_supported(hba)) {
+		cancel_work_sync(&hba->clk_scaling.suspend_work);
+		cancel_work_sync(&hba->clk_scaling.resume_work);
+		ufshcd_suspend_clkscaling(hba);
+	}
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_scsi_block_requests(hba);
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
-	ufshcd_set_eh_in_progress(hba);
 
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
@@ -5590,17 +5642,29 @@ static void ufshcd_err_handler(struct work_struct *work)
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
 
+	if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR |
+			      UFSHCD_UIC_HIBERN8_MASK)) {
+		dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
+				__func__, hba->saved_err, hba->saved_uic_err);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		ufshcd_print_host_state(hba);
+		ufshcd_print_pwr_info(hba);
+		ufshcd_print_host_regs(hba);
+		ufshcd_print_tmrs(hba, hba->outstanding_tasks);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+	}
+
 	/*
 	 * if host reset is required then skip clearing the pending
 	 * transfers forcefully because they will get cleared during
@@ -5652,38 +5716,63 @@ static void ufshcd_err_handler(struct work_struct *work)
 			__ufshcd_transfer_req_compl(hba,
 						    (1UL << (hba->nutrs - 1)));
 
+		hba->force_reset = false;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		err = ufshcd_reset_and_restore(hba);
+		reset_err = ufshcd_reset_and_restore(hba);
 		spin_lock_irqsave(hba->host->host_lock, flags);
-		if (err) {
+		if (reset_err)
 			dev_err(hba->dev, "%s: reset and restore failed\n",
 					__func__);
-			hba->ufshcd_state = UFSHCD_STATE_ERROR;
-		}
-		/*
-		 * Inform scsi mid-layer that we did reset and allow to handle
-		 * Unit Attention properly.
-		 */
-		scsi_report_bus_reset(hba->host, 0);
-		hba->saved_err = 0;
-		hba->saved_uic_err = 0;
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
 
-	ufshcd_clear_eh_in_progress(hba);
+	if (!reset_err) {
+		int ret;
+		struct request_queue *q;
 
-out:
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		/*
+		 * Set RPM status of hba device to RPM_ACTIVE,
+		 * this also clears its runtime error.
+		 */
+		ret = pm_runtime_set_active(hba->dev);
+		/*
+		 * If hba device had runtime error, explicitly resume
+		 * its scsi devices so that block layer can wake up
+		 * those waiting in blk_queue_enter().
+		 */
+		if (!ret) {
+			list_for_each_entry(sdev, &shost->__devices, siblings) {
+				q = sdev->request_queue;
+				if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
+					       q->rpm_status == RPM_SUSPENDING))
+					pm_request_resume(q->dev);
+			}
+		}
+		spin_lock_irqsave(hba->host->host_lock, flags);
+	}
+
+	/* If clk_gating is held by pm ops, release it */
+	if (pm_runtime_active(hba->dev) && hba->clk_gating.held_by_pm) {
+		hba->clk_gating.held_by_pm = false;
+		__ufshcd_release(hba);
+	}
+
+	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
-	pm_runtime_put_sync(hba->dev);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_resume_clkscaling(hba);
+	pm_runtime_put_noidle(hba->dev);
 }
 
 /**
@@ -5813,6 +5902,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 			hba->errors, ufshcd_get_upmcrs(hba));
 		ufshcd_update_reg_hist(&hba->ufs_stats.auto_hibern8_err,
 				       hba->errors);
+		ufshcd_set_link_broken(hba);
 		queue_eh_work = true;
 	}
 
@@ -5823,31 +5913,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 		 */
 		hba->saved_err |= hba->errors;
 		hba->saved_uic_err |= hba->uic_error;
-
-		/* handle fatal errors only when link is functional */
-		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
-			/* block commands from scsi mid-layer */
-			ufshcd_scsi_block_requests(hba);
-
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
-
-			/* dump controller state before resetting */
-			if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
-				bool pr_prdt = !!(hba->saved_err &
-						SYSTEM_BUS_FATAL_ERROR);
-
-				dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
-					__func__, hba->saved_err,
-					hba->saved_uic_err);
-
-				ufshcd_print_host_regs(hba);
-				ufshcd_print_pwr_info(hba);
-				ufshcd_print_tmrs(hba, hba->outstanding_tasks);
-				ufshcd_print_trs(hba, hba->outstanding_reqs,
-							pr_prdt);
-			}
-			schedule_work(&hba->eh_work);
-		}
+		ufshcd_schedule_eh_work(hba);
 		retval |= IRQ_HANDLED;
 	}
 	/*
@@ -5951,6 +6017,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 
 	spin_lock(hba->host->host_lock);
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+	hba->ufs_stats.last_intr_status = intr_status;
+	hba->ufs_stats.last_intr_ts = ktime_get();
 
 	/*
 	 * There could be max of hba->nutrs reqs in flight and in worst case
@@ -6589,9 +6657,6 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 
 	/* Establish the link again and restore the device */
 	err = ufshcd_probe_hba(hba, false);
-
-	if (!err && (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL))
-		err = -EIO;
 out:
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
@@ -6610,9 +6675,23 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
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
@@ -6620,6 +6699,19 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 		err = ufshcd_host_reset_and_restore(hba);
 	} while (err && --retries);
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	/*
+	 * Inform scsi mid-layer that we did reset and allow to handle
+	 * Unit Attention properly.
+	 */
+	scsi_report_bus_reset(hba->host, 0);
+	if (err) {
+		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		hba->saved_err |= saved_err;
+		hba->saved_uic_err |= saved_uic_err;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	return err;
 }
 
@@ -6631,48 +6723,25 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
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
 
@@ -7393,6 +7462,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 {
 	int ret;
+	unsigned long flags;
 	ktime_t start = ktime_get();
 
 	ret = ufshcd_link_startup(hba);
@@ -7458,7 +7528,10 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	ufshcd_set_active_icc_lvl(hba);
 
 	/* set the state as operational after switching to desired gear */
-	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
+		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	ufshcd_wb_config(hba);
 	/* Enable Auto-Hibernate if configured */
@@ -8071,10 +8144,13 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
 
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
@@ -8090,8 +8166,11 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
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
@@ -8226,6 +8305,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * just gate the clocks.
 	 */
 	ufshcd_hold(hba, false);
+	hba->clk_gating.held_by_pm = true;
 	hba->clk_gating.is_suspended = true;
 
 	if (hba->clk_scaling.is_allowed) {
@@ -8345,6 +8425,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
 	ufshcd_release(hba);
+	hba->clk_gating.held_by_pm = false;
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
 		schedule_delayed_work(&hba->rpm_dev_flush_recheck_work,
@@ -8400,10 +8481,13 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
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
@@ -8448,6 +8532,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	/* Schedule clock gating in case of no access to UFS device yet */
 	ufshcd_release(hba);
+	hba->clk_gating.held_by_pm = false;
 
 	goto out;
 
@@ -8777,6 +8862,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	int err;
 	struct Scsi_Host *host = hba->host;
 	struct device *dev = hba->dev;
+	char eh_wq_name[sizeof("ufs_eh_wq_00")];
 
 	if (!mmio_base) {
 		dev_err(hba->dev,
@@ -8838,6 +8924,15 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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
index 656c069..585e58b 100644
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
@@ -349,6 +354,7 @@ struct ufs_clk_gating {
 	struct device_attribute delay_attr;
 	struct device_attribute enable_attr;
 	bool is_enabled;
+	bool held_by_pm;
 	int active_reqs;
 	struct workqueue_struct *clk_gating_workq;
 };
@@ -406,6 +412,8 @@ struct ufs_err_reg_hist {
 
 /**
  * struct ufs_stats - keeps usage/err statistics
+ * @last_intr_status: record the last interrupt status.
+ * @last_intr_ts: record the last interrupt timestamp.
  * @hibern8_exit_cnt: Counter to keep track of number of exits,
  *		reset this after link-startup.
  * @last_hibern8_exit_tstamp: Set time after the hibern8 exit.
@@ -425,6 +433,9 @@ struct ufs_err_reg_hist {
  * @tsk_abort: tracks task abort events
  */
 struct ufs_stats {
+	u32 last_intr_status;
+	ktime_t last_intr_ts;
+
 	u32 hibern8_exit_cnt;
 	ktime_t last_hibern8_exit_tstamp;
 
@@ -608,12 +619,14 @@ struct ufs_hba_variant_params {
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
@@ -702,6 +715,7 @@ struct ufs_hba {
 	bool is_powered;
 
 	/* Work Queues */
+	struct workqueue_struct *eh_wq;
 	struct work_struct eh_work;
 	struct work_struct eeh_work;
 
@@ -711,6 +725,7 @@ struct ufs_hba {
 	u32 saved_err;
 	u32 saved_uic_err;
 	struct ufs_stats ufs_stats;
+	bool force_reset;
 	bool silence_err_logs;
 
 	/* Device management request data */
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

