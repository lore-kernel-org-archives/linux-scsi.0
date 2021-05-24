Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC64C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04459610CE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhEXIiu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 04:38:50 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:1966 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbhEXIit (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 04:38:49 -0400
IronPort-SDR: e/K3rd80hLCZtZtBoZgOQl/OkPnX0EgUtvbVi0wBOKk9rqtkjVWX/CyfNGSFx8uK0gO+7f2nyb
 SBfTurH5IBbf4cD2hEHACPlgCxFAWVzy+enToQzrW/YlqEax8zA6jE17/LMeo8I6wz2hz7LNAM
 niOcs+22GORXRh2ac6zQ7+nPz8IuM3ksUDR02RKVF4Gx4m1cgOGG0EljOUjZ29U7lRyPjedYv5
 huw9PcTtMcJSd0Q4kEadVp71OLdc5kz/MLDkBZcFZiP87GzIJj3WXk4iS+c3KSAFsekofs86uR
 ey0=
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="29772329"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 24 May 2021 01:37:18 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 24 May 2021 01:37:17 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id C466621AD7; Mon, 24 May 2021 01:37:17 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests send/compl paths
Date:   Mon, 24 May 2021 01:36:57 -0700
Message-Id: <1621845419-14194-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current UFS IRQ handler is completely wrapped by host lock, and because
ufshcd_send_command() is also protected by host lock, when IRQ handler
fires, not only the CPU running the IRQ handler cannot send new requests,
the rest CPUs can neither. Move the host lock wrapping the IRQ handler into
specific branches, i.e., ufshcd_uic_cmd_compl(), ufshcd_check_errors(),
ufshcd_tmc_handler() and ufshcd_transfer_req_compl(). Meanwhile, to further
reduce occpuation of host lock in ufshcd_transfer_req_compl(), host lock is
no longer required to call __ufshcd_transfer_req_compl(). As per test, the
optimization can bring considerable gain to random read/write performance.

Cc: Stanley Chu <stanley.chu@mediatek.com>
Co-developed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 258 ++++++++++++++++++++++------------------------
 drivers/scsi/ufs/ufshcd.h |   2 -
 2 files changed, 126 insertions(+), 134 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c4b37d2..b9b5e61 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -758,7 +758,7 @@ static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
  */
 static inline void ufshcd_outstanding_req_clear(struct ufs_hba *hba, int tag)
 {
-	__clear_bit(tag, &hba->outstanding_reqs);
+	clear_bit(tag, &hba->outstanding_reqs);
 }
 
 /**
@@ -1984,15 +1984,19 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
 	bool queue_resume_work = false;
 	ktime_t curr_t = ktime_get();
+	unsigned long flags;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (!hba->clk_scaling.active_reqs++)
 		queue_resume_work = true;
 
-	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress)
+	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		return;
+	}
 
 	if (queue_resume_work)
 		queue_work(hba->clk_scaling.workq,
@@ -2008,21 +2012,26 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 		hba->clk_scaling.busy_start_t = curr_t;
 		hba->clk_scaling.is_busy_started = true;
 	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
 static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 {
 	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
+	unsigned long flags;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->clk_scaling.active_reqs--;
 	if (!hba->outstanding_reqs && scaling->is_busy_started) {
 		scaling->tot_busy_t += ktime_to_us(ktime_sub(ktime_get(),
 					scaling->busy_start_t));
 		scaling->busy_start_t = 0;
 		scaling->is_busy_started = false;
 	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
 static inline int ufshcd_monitor_opcode2dir(u8 opcode)
@@ -2048,15 +2057,20 @@ static inline bool ufshcd_should_inform_monitor(struct ufs_hba *hba,
 static void ufshcd_start_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
+	unsigned long flags;
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (dir >= 0 && hba->monitor.nr_queued[dir]++ == 0)
 		hba->monitor.busy_start_ts[dir] = ktime_get();
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
 static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
+	unsigned long flags;
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
 		struct request *req = lrbp->cmd->request;
 		struct ufs_hba_monitor *m = &hba->monitor;
@@ -2080,6 +2094,7 @@ static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		/* Push forward the busy start of monitor */
 		m->busy_start_ts[dir] = now;
 	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
 /**
@@ -2091,16 +2106,19 @@ static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
 	struct ufshcd_lrb *lrbp = &hba->lrb[task_tag];
+	unsigned long flags;
 
 	lrbp->issue_time_stamp = ktime_get();
 	lrbp->compl_time_stamp = ktime_set(0, 0);
 	ufshcd_vops_setup_xfer_req(hba, task_tag, (lrbp->cmd ? true : false));
 	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 	ufshcd_clk_scaling_start_busy(hba);
-	__set_bit(task_tag, &hba->outstanding_reqs);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 }
@@ -2671,7 +2689,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	struct ufshcd_lrb *lrbp;
 	struct ufs_hba *hba;
-	unsigned long flags;
 	int tag;
 	int err = 0;
 
@@ -2688,6 +2705,43 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	switch (hba->ufshcd_state) {
+	case UFSHCD_STATE_OPERATIONAL:
+	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
+		break;
+	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
+		/*
+		 * pm_runtime_get_sync() is used at error handling preparation
+		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
+		 * PM ops, it can never be finished if we let SCSI layer keep
+		 * retrying it, which gets err handler stuck forever. Neither
+		 * can we let the scsi cmd pass through, because UFS is in bad
+		 * state, the scsi cmd may eventually time out, which will get
+		 * err handler blocked for too long. So, just fail the scsi cmd
+		 * sent from PM ops, err handler can recover PM error anyways.
+		 */
+		if (hba->pm_op_in_progress) {
+			hba->force_reset = true;
+			set_host_byte(cmd, DID_BAD_TARGET);
+			cmd->scsi_done(cmd);
+			goto out;
+		}
+		fallthrough;
+	case UFSHCD_STATE_RESET:
+		err = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	case UFSHCD_STATE_ERROR:
+		set_host_byte(cmd, DID_ERROR);
+		cmd->scsi_done(cmd);
+		goto out;
+	default:
+		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
+				__func__, hba->ufshcd_state);
+		set_host_byte(cmd, DID_BAD_TARGET);
+		cmd->scsi_done(cmd);
+		goto out;
+	}
+
 	hba->req_abort_count = 0;
 
 	err = ufshcd_hold(hba, true);
@@ -2698,8 +2752,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
 		(hba->clk_gating.state != CLKS_ON));
 
-	lrbp = &hba->lrb[tag];
-	if (unlikely(lrbp->in_use)) {
+	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		if (hba->pm_op_in_progress)
 			set_host_byte(cmd, DID_BAD_TARGET);
 		else
@@ -2708,6 +2761,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto out;
 	}
 
+	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
 	lrbp->sense_bufflen = UFS_SENSE_SIZE;
@@ -2731,51 +2785,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	switch (hba->ufshcd_state) {
-	case UFSHCD_STATE_OPERATIONAL:
-	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
-		break;
-	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
-		/*
-		 * pm_runtime_get_sync() is used at error handling preparation
-		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
-		 * PM ops, it can never be finished if we let SCSI layer keep
-		 * retrying it, which gets err handler stuck forever. Neither
-		 * can we let the scsi cmd pass through, because UFS is in bad
-		 * state, the scsi cmd may eventually time out, which will get
-		 * err handler blocked for too long. So, just fail the scsi cmd
-		 * sent from PM ops, err handler can recover PM error anyways.
-		 */
-		if (hba->pm_op_in_progress) {
-			hba->force_reset = true;
-			set_host_byte(cmd, DID_BAD_TARGET);
-			goto out_compl_cmd;
-		}
-		fallthrough;
-	case UFSHCD_STATE_RESET:
-		err = SCSI_MLQUEUE_HOST_BUSY;
-		goto out_compl_cmd;
-	case UFSHCD_STATE_ERROR:
-		set_host_byte(cmd, DID_ERROR);
-		goto out_compl_cmd;
-	default:
-		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
-				__func__, hba->ufshcd_state);
-		set_host_byte(cmd, DID_BAD_TARGET);
-		goto out_compl_cmd;
-	}
 	ufshcd_send_command(hba, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	goto out;
-
-out_compl_cmd:
-	scsi_dma_unmap(lrbp->cmd);
-	lrbp->cmd = NULL;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_release(hba);
-	if (!err)
-		cmd->scsi_done(cmd);
 out:
 	up_read(&hba->clk_scaling_lock);
 	return err;
@@ -2930,7 +2940,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	int err;
 	int tag;
 	struct completion wait;
-	unsigned long flags;
 
 	down_read(&hba->clk_scaling_lock);
 
@@ -2947,13 +2956,13 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	tag = req->tag;
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
-	init_completion(&wait);
-	lrbp = &hba->lrb[tag];
-	if (unlikely(lrbp->in_use)) {
+	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
 		goto out;
 	}
 
+	init_completion(&wait);
+	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
 	if (unlikely(err))
@@ -2964,12 +2973,9 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_send_command(hba, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	ufshcd_send_command(hba, tag);
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
-
 out:
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
@@ -5147,6 +5153,24 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	return result;
 }
 
+static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
+					 u32 intr_mask)
+{
+	if (!ufshcd_is_auto_hibern8_supported(hba) ||
+	    !ufshcd_is_auto_hibern8_enabled(hba))
+		return false;
+
+	if (!(intr_mask & UFSHCD_UIC_HIBERN8_MASK))
+		return false;
+
+	if (hba->active_uic_cmd &&
+	    (hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_ENTER ||
+	    hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_EXIT))
+		return false;
+
+	return true;
+}
+
 /**
  * ufshcd_uic_cmd_compl - handle completion of uic command
  * @hba: per adapter instance
@@ -5160,6 +5184,10 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 {
 	irqreturn_t retval = IRQ_NONE;
 
+	spin_lock(hba->host->host_lock);
+	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
+		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
+
 	if ((intr_status & UIC_COMMAND_COMPL) && hba->active_uic_cmd) {
 		hba->active_uic_cmd->argument2 |=
 			ufshcd_get_uic_cmd_result(hba);
@@ -5180,6 +5208,7 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 	if (retval == IRQ_HANDLED)
 		ufshcd_add_uic_command_trace(hba, hba->active_uic_cmd,
 					     UFS_CMD_COMP);
+	spin_unlock(hba->host->host_lock);
 	return retval;
 }
 
@@ -5198,8 +5227,9 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	bool update_scaling = false;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
+		if (!test_and_clear_bit(index, &hba->outstanding_reqs))
+			continue;
 		lrbp = &hba->lrb[index];
-		lrbp->in_use = false;
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
 		if (cmd) {
@@ -5213,7 +5243,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			lrbp->cmd = NULL;
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
-			__ufshcd_release(hba);
+			ufshcd_release(hba);
 			update_scaling = true;
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
@@ -5224,14 +5254,9 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 				update_scaling = true;
 			}
 		}
-		if (ufshcd_is_clkscaling_supported(hba) && update_scaling)
-			hba->clk_scaling.active_reqs--;
+		if (update_scaling)
+			ufshcd_clk_scaling_update_busy(hba);
 	}
-
-	/* clear corresponding bits of completed commands */
-	hba->outstanding_reqs ^= completed_reqs;
-
-	ufshcd_clk_scaling_update_busy(hba);
 }
 
 /**
@@ -5244,7 +5269,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
  */
 static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
-	unsigned long completed_reqs;
+	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
 
 	/* Resetting interrupt aggregation counters first and reading the
@@ -5258,8 +5283,10 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (completed_reqs) {
 		__ufshcd_transfer_req_compl(hba, completed_reqs);
@@ -5996,13 +6023,11 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_err_handling_prepare(hba);
+	/* Complete requests that have door-bell cleared by h/w */
+	ufshcd_complete_requests(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 		hba->ufshcd_state = UFSHCD_STATE_RESET;
-
-	/* Complete requests that have door-bell cleared by h/w */
-	ufshcd_complete_requests(hba);
-
 	/*
 	 * A full reset and restore might have happened after preparation
 	 * is finished, double check whether we should stop.
@@ -6085,12 +6110,11 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 
 lock_skip_pending_xfer_clear:
-	spin_lock_irqsave(hba->host->host_lock, flags);
-
 	/* Complete the requests that are cleared by s/w */
 	ufshcd_complete_requests(hba);
-	hba->silence_err_logs = false;
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->silence_err_logs = false;
 	if (err_xfer || err_tm) {
 		needs_reset = true;
 		goto do_reset;
@@ -6240,37 +6264,23 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 	return retval;
 }
 
-static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
-					 u32 intr_mask)
-{
-	if (!ufshcd_is_auto_hibern8_supported(hba) ||
-	    !ufshcd_is_auto_hibern8_enabled(hba))
-		return false;
-
-	if (!(intr_mask & UFSHCD_UIC_HIBERN8_MASK))
-		return false;
-
-	if (hba->active_uic_cmd &&
-	    (hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_ENTER ||
-	    hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_EXIT))
-		return false;
-
-	return true;
-}
-
 /**
  * ufshcd_check_errors - Check for errors that need s/w attention
  * @hba: per-adapter instance
+ * @intr_status: interrupt status generated by the controller
  *
  * Returns
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
+static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 {
 	bool queue_eh_work = false;
 	irqreturn_t retval = IRQ_NONE;
 
+	spin_lock(hba->host->host_lock);
+	hba->errors |= UFSHCD_ERROR_MASK & intr_status;
+
 	if (hba->errors & INT_FATAL_ERRORS) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_FATAL_ERR,
 				       hba->errors);
@@ -6325,6 +6335,9 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 	 * itself without s/w intervention or errors that will be
 	 * handled by the SCSI core layer.
 	 */
+	hba->errors = 0;
+	hba->uic_error = 0;
+	spin_unlock(hba->host->host_lock);
 	return retval;
 }
 
@@ -6359,13 +6372,17 @@ static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
  */
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
+	unsigned long flags;
 	struct request_queue *q = hba->tmf_queue;
 	struct ctm_info ci = {
 		.hba	 = hba,
-		.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL),
 	};
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ci.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
 }
 
@@ -6382,17 +6399,12 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
 	irqreturn_t retval = IRQ_NONE;
 
-	hba->errors = UFSHCD_ERROR_MASK & intr_status;
-
-	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
-		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
-
-	if (hba->errors)
-		retval |= ufshcd_check_errors(hba);
-
 	if (intr_status & UFSHCD_UIC_MASK)
 		retval |= ufshcd_uic_cmd_compl(hba, intr_status);
 
+	if (intr_status & UFSHCD_ERROR_MASK || hba->errors)
+		retval |= ufshcd_check_errors(hba, intr_status);
+
 	if (intr_status & UTP_TASK_REQ_COMPL)
 		retval |= ufshcd_tmc_handler(hba);
 
@@ -6418,7 +6430,6 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	struct ufs_hba *hba = __hba;
 	int retries = hba->nutrs;
 
-	spin_lock(hba->host->host_lock);
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	hba->ufs_stats.last_intr_status = intr_status;
 	hba->ufs_stats.last_intr_ts = ktime_get();
@@ -6449,7 +6460,6 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
 	}
 
-	spin_unlock(hba->host->host_lock);
 	return retval;
 }
 
@@ -6626,7 +6636,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	int err = 0;
 	int tag;
 	struct completion wait;
-	unsigned long flags;
 	u8 upiu_flags;
 
 	down_read(&hba->clk_scaling_lock);
@@ -6639,13 +6648,13 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	tag = req->tag;
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
-	init_completion(&wait);
-	lrbp = &hba->lrb[tag];
-	if (unlikely(lrbp->in_use)) {
+	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
 		goto out;
 	}
 
+	init_completion(&wait);
+	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->sense_bufflen = 0;
@@ -6683,10 +6692,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_send_command(hba, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	ufshcd_send_command(hba, tag);
 	/*
 	 * ignore the returning value here - ufshcd_check_query_response is
 	 * bound to fail since dev_cmd.query and dev_cmd.type were left empty.
@@ -6805,7 +6812,6 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	u32 pos;
 	int err;
 	u8 resp = 0xF, lun;
-	unsigned long flags;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
@@ -6824,11 +6830,9 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
+			__ufshcd_transfer_req_compl(hba, pos);
 		}
 	}
-	spin_lock_irqsave(host->host_lock, flags);
-	ufshcd_transfer_req_compl(hba);
-	spin_unlock_irqrestore(host->host_lock, flags);
 
 out:
 	hba->req_abort_count = 0;
@@ -7005,20 +7009,16 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * will fail, due to spec violation, scsi err handling next step
 	 * will be to send LU reset which, again, is a spec violation.
 	 * To avoid these unnecessary/illegal steps, first we clean up
-	 * the lrb taken by this cmd and mark the lrb as in_use, then
-	 * queue the eh_work and bail.
+	 * the lrb taken by this cmd and re-set it in outstanding_reqs,
+	 * then queue the eh_work and bail.
 	 */
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
+		__ufshcd_transfer_req_compl(hba, (1UL << tag));
+		set_bit(tag, &hba->outstanding_reqs);
 		spin_lock_irqsave(host->host_lock, flags);
-		if (lrbp->cmd) {
-			__ufshcd_transfer_req_compl(hba, (1UL << tag));
-			__set_bit(tag, &hba->outstanding_reqs);
-			lrbp->in_use = true;
-			hba->force_reset = true;
-			ufshcd_schedule_eh_work(hba);
-		}
-
+		hba->force_reset = true;
+		ufshcd_schedule_eh_work(hba);
 		spin_unlock_irqrestore(host->host_lock, flags);
 		goto out;
 	}
@@ -7031,9 +7031,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	if (!err) {
 cleanup:
-		spin_lock_irqsave(host->host_lock, flags);
 		__ufshcd_transfer_req_compl(hba, (1UL << tag));
-		spin_unlock_irqrestore(host->host_lock, flags);
 out:
 		err = SUCCESS;
 	} else {
@@ -7063,19 +7061,15 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 {
 	int err;
-	unsigned long flags;
 
 	/*
 	 * Stop the host controller and complete the requests
 	 * cleared by h/w
 	 */
 	ufshcd_hba_stop(hba);
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->silence_err_logs = true;
 	ufshcd_complete_requests(hba);
 	hba->silence_err_logs = false;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* scale up clocks to max frequency before full reinitialization */
 	ufshcd_set_clk_freq(hba, true);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0f0e62b..a70daf7 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -193,7 +193,6 @@ struct ufs_pm_lvl_states {
  * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
  * @data_unit_num: the data unit number for the first block for inline crypto
  * @req_abort_skip: skip request abort task flag
- * @in_use: indicates that this lrb is still in use
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
@@ -223,7 +222,6 @@ struct ufshcd_lrb {
 #endif
 
 	bool req_abort_skip;
-	bool in_use;
 };
 
 /**
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

