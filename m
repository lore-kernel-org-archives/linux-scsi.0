Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B861E5B9A
	for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 14:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789914807; cv=none; b=f2WEZIIfql7ouhtLYtCVnmnJNMPwc9lWXab0TiIPmrcnieijNw2B9B7AqRVtLiurzEGxDBXgp9OIKdoq+Lay4KzcNiStJDwNQ0Ol5OIgrmt6vL/59LnaoRKc8EMpUIHqF8/nK6PCgG4O8qrCtVAwdUdJXvGI1lA8moEFm6pwgCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789914807; c=relaxed/simple;
	bh=sJx+fGONxOD7zqOqztnWWiB8387wFQ98KF5wUeDckEk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KTnC0/+G6HTv3f7W3DzFHxF8JMeTYyyetlwprayJRNxIbypyVRwaunWUC9Jhz2z7Mf+z2MjeyI9jHCET/QWrXhA7zopWOUBmHCwMMe51K67ZOZ85dokboYngv8HS4JJ2tfabhV/dZgRBrWr9ANdxAODCXCzy3HsLPbJteaEde0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JL97fww/; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JL97fww/"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-877ef1457aeso1209012b3a.1
        for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 07:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789914803; x=1790519603; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HQJQEJidXMPmVBcJtdQq733W8kc6T28EtDqD+r1rwkI=;
        b=JL97fww/e7ANb2EPJrAf/ER6si+qfDPAzBNp/c9RR2c4a1d0/eClZ+WDliKvS18gEW
         s/Zv5n0PhNFeTsCX90Yi5RaBHcJHvQfMzO5hKMSGwpxdqD5r0mWWZAFC+Q6Y1Qfv9f1Z
         TzH0kMxkv+sg2SbWE3z//Llp1JQ4ZQf/n45EsArnW+gSUh9NVHW1rUf+5laVlJy13DeW
         haOwfJTbfZpUOKNLdbKrVHUQcb/3NWT44/7HvMNI1569rRw9M1DjJmo00tNx9IhFz7Wu
         oG3wlpl1/RytilbYXnZar7FFX5Olnaf+8T7eFShJmYV4qJ9zT6x5CNEfnubs3Vx51fM6
         kxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789914803; x=1790519603;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HQJQEJidXMPmVBcJtdQq733W8kc6T28EtDqD+r1rwkI=;
        b=RXMFUkVZiuT6nWVYI+TDjTh3WQ0lEbRmlCp+RsoQMyg+F745k3hc73fgiLPd1HCKkr
         OZFTuqazr322s3dAMbR70f2XxPq8yr9Cqf/3SAeBC4SYatOqMpSU8TtcvF8+jnvFcy3/
         dkFxu4Z+Z5AgD/cjBL2PIU8nlKZ7tzXZxAppKyQsmIJ4Wde3b6+N0bVtk+a/PvCYqfev
         o2wynk6W+t9mNBNirodFrbH/aprbX971HvZZP8xT2DcHtpx0pMgOg8vczL5alQUpR2Nv
         PvBAYT4nOY3lmO6/UC/pFhHsVMrBoWWha4znyFjVQJBgJmrTfyeAU6h7yMBm+g3kt6mB
         q2FQ==
X-Forwarded-Encrypted: i=1; AKwUvBxTboWGKhODyrE0/B8H5u5mEsn96FTpRzqMiO1Uug9qKyT0f3fd+7zgDtVbE94GeNqQ6zDWtXxGGCoo@vger.kernel.org
X-Gm-Message-State: AFuF++kM/pYceLmV+eQyQceA4pINWTFcLi6U5MAhx+SdVXoYLeppzp11
	wy2ufjVrMxzchO8oHjwzNjKVwLpsrU5o+Nlz97bAZgUpK+dezS+okj/wZONBUboz4pkex1sDJ/V
	XvIdJH6L4uc9ExKCowK9iYw==
X-Received: from pfqy28.prod.google.com ([2002:aa7:9e1c:0:b0:873:a672:e379])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:9086:b0:878:34d7:69af with SMTP id d2e1a72fcca58-87834d76ccemr5134070b3a.54.1789914802966;
 Sun, 20 Sep 2026 07:33:22 -0700 (PDT)
Date: Sun, 20 Sep 2026 22:33:18 +0800
In-Reply-To: <20260920143319.3659543-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260920143319.3659543-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260920143319.3659543-2-stanleyjhu@google.com>
Subject: [PATCH 1/2] scsi: ufs: core: Release command resources instead of force-completing
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen" <mkp@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>, 
	"Bao D . Nguyen" <quic_nguyenb@quicinc.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

In ufshcd_host_reset_and_restore(), ufshcd_complete_requests(hba, true)
couples LLD resource release (ufshcd_release_scsi_cmd()) with command
completion (scsi_done()) right after ufshcd_hba_stop():

1. EH-owned SCSI commands (SCMD_STATE_COMPLETE set): skipping
   scsi_done() in ufshcd_mcq_force_compl_one() also skips
   ufshcd_release_scsi_cmd(), leaking DMA mappings and
   clk_gating.active_reqs whenever ufshcd_abort() fails.
2. Non-EH SCSI commands (!SCMD_STATE_COMPLETE): calling scsi_done()
   right after ufshcd_hba_stop() completes them before link recovery
   finishes.

To fix this, enforce a strict ownership boundary between LLD hardware
resources and SCSI command completion:

- LLD resources (DMA mappings, crypto PRDT, clk_gating.active_reqs) are
  tied to controller execution and must be released whenever the
  hardware stops executing a command, regardless of whether SCSI EH
  owns the command.
- Command completion (scsi_done()) belongs exclusively to SCSI EH once
  SCMD_STATE_COMPLETE is set. However, for commands where
  SCMD_STATE_COMPLETE is not set, UFS cannot delegate completion to
  SCSI EH because UFS also performs autonomous resets
  (ufshcd_err_handler() on UIC/controller errors) outside of
  scsi_error_handler(). Since ufshcd_hba_stop() (HCE = 0) wipes all
  in-flight hardware transfers while SCSI EH is inactive, the driver
  itself must requeue halted non-EH commands with DID_REQUEUE after
  recovery finishes, or else they stall for the 30s block timeout.

Implement this in three steps:

1. Track controller resource ownership with lrbp->in_flight so
   ufshcd_release_scsi_cmd() is idempotent across normal completion,
   successful task abort, and host reset teardown.
2. At controller stop (ufshcd_release_stopped_reqs()), release LLD
   resources for all halted commands without calling scsi_done(), clear
   any uncompleted reserved dev_cmd, and mark halted non-EH commands
   with lrbp->pending_requeue.
3. After host and link recovery finish (ufshcd_requeue_non_eh_cmds()),
   requeue pending commands that remain non-EH (!SCMD_STATE_COMPLETE)
   with DID_REQUEUE while leaving EH-owned commands on shost->eh_cmd_q.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 183 ++++++++++++++++++++++++++++++--------
 include/ufs/ufshcd.h      |   6 ++
 2 files changed, 154 insertions(+), 35 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 234e18b5078f..c0772822731e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2432,6 +2432,7 @@ static inline void ufshcd_send_command(struct ufs_hba *hba,
 		lrbp->compl_time_stamp = ktime_set(0, 0);
 		lrbp->compl_time_stamp_local_clock = 0;
 	}
+	lrbp->in_flight = true;
 	if (ufshcd_is_scsi_cmd(cmd)) {
 		ufshcd_add_command_trace(hba, cmd, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
@@ -3116,11 +3117,15 @@ static int ufshcd_init_cmd_priv(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 static enum scsi_qc_status ufshcd_queuecommand(struct Scsi_Host *host,
 					       struct scsi_cmnd *cmd)
 {
+	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	struct ufs_hba *hba = shost_priv(host);
 	int tag = scsi_cmd_to_rq(cmd)->tag;
 	int err = 0;
 	struct ufs_hw_queue *hwq = NULL;
 
+	lrbp->in_flight = false;
+	lrbp->pending_requeue = false;
+
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 		break;
@@ -3203,6 +3208,8 @@ static enum scsi_qc_status ufshcd_queue_reserved_command(struct Scsi_Host *host,
 	struct ufs_hw_queue *hwq =
 		hba->mcq_enabled ? ufshcd_mcq_req_to_hwq(hba, rq) : NULL;
 
+	lrbp->in_flight = false;
+	lrbp->pending_requeue = false;
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
 	ufshcd_send_command(hba, cmd, hwq);
 	return 0;
@@ -4671,6 +4678,28 @@ int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 }
 EXPORT_SYMBOL_GPL(ufshcd_uic_change_pwr_mode);
 
+static bool ufshcd_requeue_one_non_eh_cmd(struct request *req, void *data)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+
+	if (blk_mq_is_reserved_rq(req) || !lrbp->pending_requeue)
+		return true;
+
+	lrbp->pending_requeue = false;
+	if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
+		set_host_byte(cmd, DID_REQUEUE);
+		scsi_done(cmd);
+	}
+	return true;
+}
+
+static void ufshcd_requeue_non_eh_cmds(struct ufs_hba *hba)
+{
+	blk_mq_tagset_busy_iter(&hba->host->tag_set,
+				ufshcd_requeue_one_non_eh_cmd, hba);
+}
+
 int ufshcd_link_recovery(struct ufs_hba *hba)
 {
 	int ret;
@@ -4692,6 +4721,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
+	ufshcd_requeue_non_eh_cmds(hba);
+
 	if (ret)
 		dev_err(hba->dev, "%s: link recovery failed, err %d",
 			__func__, ret);
@@ -5937,6 +5968,17 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 /* Release the resources allocated for processing a SCSI command. */
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 {
+	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+
+	lrbp->pending_requeue = false;
+	if (!lrbp->in_flight)
+		return;
+	lrbp->in_flight = false;
+
+	/* Device management commands do not own any of the below. */
+	if (!ufshcd_is_scsi_cmd(cmd))
+		return;
+
 	scsi_dma_unmap(cmd);
 	ufshcd_crypto_clear_prdt(hba, cmd);
 	ufshcd_release(hba);
@@ -5968,8 +6010,9 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 		if (unlikely(ufshcd_should_inform_monitor(hba, cmd)))
 			ufshcd_update_monitor(hba, cmd);
 		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
-		cmd->result = ufshcd_transfer_rsp_status(hba, cmd, cqe);
-		ufshcd_release_scsi_cmd(hba, cmd);
+		if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state))
+			cmd->result =
+				ufshcd_transfer_rsp_status(hba, cmd, cqe);
 	} else {
 		if (cqe) {
 			ocs = cqe->overall_status & MASK_OCS;
@@ -5981,8 +6024,17 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			hba,
 			ocs == OCS_SUCCESS ? UFS_QUERY_COMP : UFS_QUERY_ERR,
 			(struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
-		cmd->result = 0;
+		if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state))
+			cmd->result = 0;
 	}
+	ufshcd_release_scsi_cmd(hba, cmd);
+	/*
+	 * Clear lrbp->pending_requeue before the tag is freed so that the
+	 * next user of this tag is not mistaken for a command halted by
+	 * ufshcd_hba_stop().
+	 */
+	lrbp->pending_requeue = false;
+
 	/* Do not touch lrbp after scsi_done() has been called. */
 	scsi_done(cmd);
 }
@@ -7912,6 +7964,8 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
 	struct ufs_hba *hba = shost_priv(shost);
 	const u64 lun = *(u64 *)priv;
 	const u32 tag = req->tag;
+	unsigned long flags;
+	bool outstanding;
 
 	if (blk_mq_is_reserved_rq(req) || sdev->lun != lun)
 		return true;
@@ -7930,7 +7984,11 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
 		return true;
 	}
 
-	ufshcd_compl_one_cqe(hba, tag, NULL);
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+	if (outstanding)
+		ufshcd_compl_one_cqe(hba, tag, NULL);
 	return true;
 }
 
@@ -8087,6 +8145,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	u32 reg;
 
 	ufshcd_hold(hba);
+	lrbp->pending_requeue = false;
 
 	if (!hba->mcq_enabled) {
 		reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
@@ -8153,6 +8212,16 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	if (hba->mcq_enabled) {
 		/* MCQ mode. Branch off to handle abort for mcq mode */
 		err = ufshcd_mcq_abort(cmd);
+		if (err == SUCCESS) {
+			struct ufs_hw_queue *hwq =
+				ufshcd_mcq_req_to_hwq(hba, rq);
+
+			if (hwq) {
+				spin_lock_irqsave(&hwq->cq_lock, flags);
+				ufshcd_release_scsi_cmd(hba, cmd);
+				spin_unlock_irqrestore(&hwq->cq_lock, flags);
+			}
+		}
 		goto release;
 	}
 
@@ -8216,6 +8285,71 @@ static void ufshcd_process_probe_result(struct ufs_hba *hba,
 			  hba->curr_dev_pwr_mode, hba->uic_link_state);
 }
 
+/*
+ * The caller must own @rq, either by having claimed its bit in
+ * hba->outstanding_reqs (legacy mode) or by holding hwq->cq_lock (MCQ mode).
+ */
+static void __ufshcd_release_stopped_req(struct ufs_hba *hba,
+					 struct request *rq,
+					 struct scsi_cmnd *cmd)
+{
+	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+
+	if (!lrbp->in_flight)
+		return;
+
+	ufshcd_release_scsi_cmd(hba, cmd);
+	if (test_bit(SCMD_STATE_COMPLETE, &cmd->state))
+		return;
+
+	if (blk_mq_is_reserved_rq(rq)) {
+		/* Device management commands are not requeued. */
+		set_host_byte(cmd, DID_TIME_OUT);
+		scsi_done(cmd);
+	} else {
+		lrbp->pending_requeue = true;
+	}
+}
+
+static bool ufshcd_release_one_stopped_req(struct request *rq, void *priv)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+	struct ufs_hba *hba = priv;
+	unsigned long flags;
+	bool owned;
+
+	if (hba->mcq_enabled) {
+		struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
+
+		if (hwq) {
+			spin_lock_irqsave(&hwq->cq_lock, flags);
+			__ufshcd_release_stopped_req(hba, rq, cmd);
+			spin_unlock_irqrestore(&hwq->cq_lock, flags);
+		}
+		return true;
+	}
+
+	/*
+	 * Keep hba->outstanding_lock a leaf lock, as in ufshcd_poll() and
+	 * ufshcd_abort(): clearing the bit already grants exclusive ownership.
+	 */
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	owned = __test_and_clear_bit(rq->tag, &hba->outstanding_reqs);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+	if (owned)
+		__ufshcd_release_stopped_req(hba, rq, cmd);
+
+	return true;
+}
+
+static void ufshcd_release_stopped_reqs(struct ufs_hba *hba)
+{
+	blk_mq_tagset_busy_iter(&hba->host->tag_set,
+				ufshcd_release_one_stopped_req, hba);
+	/* TMF sweep inherited from the replaced ufshcd_complete_requests(). */
+	ufshcd_tmc_handler(hba);
+}
+
 /**
  * ufshcd_host_reset_and_restore - reset and restore host controller
  * @hba: per-adapter instance
@@ -8231,13 +8365,11 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	int err;
 
 	/*
-	 * Stop the host controller and complete the requests
-	 * cleared by h/w
+	 * Stop the host controller and release driver resources for
+	 * requests cleared by h/w
 	 */
 	ufshcd_hba_stop(hba);
-	hba->silence_err_logs = true;
-	ufshcd_complete_requests(hba, true);
-	hba->silence_err_logs = false;
+	ufshcd_release_stopped_reqs(hba);
 
 	/* scale up clocks to max frequency before full reinitialization */
 	if (ufshcd_is_clkscaling_supported(hba))
@@ -8319,6 +8451,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 	}
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
+	ufshcd_requeue_non_eh_cmds(hba);
+
 	return err;
 }
 
@@ -9597,30 +9731,6 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
 		 __func__, hba->outstanding_tasks);
 
-	/*
-	 * ufshcd_link_recovery() may already have completed @scmd, e.g. via
-	 * the existing MCQ force-completion path.
-	 */
-	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
-		if (!hba->mcq_enabled) {
-			unsigned long flags;
-			struct request *rq = scsi_cmd_to_rq(scmd);
-
-			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			__clear_bit(rq->tag, &hba->outstanding_reqs);
-			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-		}
-
-		if (ufshcd_is_scsi_cmd(scmd)) {
-			set_host_byte(scmd, DID_REQUEUE);
-			ufshcd_release_scsi_cmd(hba, scmd);
-		} else {
-			set_host_byte(scmd, DID_TIME_OUT);
-		}
-
-		scsi_done(scmd);
-	}
-
 	return SCSI_EH_DONE;
 }
 
@@ -10464,15 +10574,18 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_device_reset(hba);
 		WARN_ON(!ufshcd_is_link_off(hba));
 	}
-	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
+	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba)) {
 		ufshcd_set_link_active(hba);
-	else if (ufshcd_is_link_off(hba))
+	} else if (ufshcd_is_link_off(hba)) {
 		ufshcd_host_reset_and_restore(hba);
+		ufshcd_requeue_non_eh_cmds(hba);
+	}
 set_dev_active:
 	/* Can also get here needing to exit DeepSleep */
 	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
 		ufshcd_device_reset(hba);
 		ufshcd_host_reset_and_restore(hba);
+		ufshcd_requeue_non_eh_cmds(hba);
 	}
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
 		ufshcd_disable_auto_bkops(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c..cd84f617f95c 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -166,6 +166,10 @@ struct ufs_pm_lvl_states {
  * @lun: LUN of the command
  * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
  * @req_abort_skip: skip request abort task flag
+ * @in_flight: true after the command has been submitted to the controller and
+ *	       before its resources have been released
+ * @pending_requeue: true if command was halted by ufshcd_hba_stop() and awaits
+ *		     post-recovery requeue
  * @issue_time_stamp: time stamp for debug purposes (CLOCK_MONOTONIC)
  * @issue_time_stamp_local_clock: time stamp for debug purposes (local_clock)
  * @compl_time_stamp: time stamp for statistics (CLOCK_MONOTONIC)
@@ -190,6 +194,8 @@ struct ufshcd_lrb {
 	u8 lun; /* UPIU LUN id field is only 8-bit wide */
 	bool intr_cmd;
 	bool req_abort_skip;
+	bool in_flight;
+	bool pending_requeue;
 	ktime_t issue_time_stamp;
 	u64 issue_time_stamp_local_clock;
 	ktime_t compl_time_stamp;
-- 
2.55.0.1082.g2b9226bbc0-goog

