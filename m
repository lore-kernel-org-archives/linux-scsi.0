Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448E430ACF2
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759156870; cv=none; b=bK1nZHIuvtDGWJbzn6xZauOmEXubgCFMun+znw1WzHYDRWrM4JPv0c9yne3NDvm2VWNZxlMBlSaso8SyhatqdXQvkJtAkc2gFn7gPK+q05bU2I9DfnpkJ+QMtrA8TTFKxfzVV5fbtO+Wf+sgFtt2DisVQdwA2c1DXn3yflHR7q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759156870; c=relaxed/simple;
	bh=i1EWBvl3pgEz04bRJbDeFzyt7OHP5WzSf5nISUU3Ifg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Lg2id4zznMAtnlRE9EqT74kv0Kw5sMDc9uggNkhOpVaTh/jhwZGb8DmlJRVEdY0UX5BS0ELOHifPgo+/H8TTEEhmhQVj3ZWXF4n7Ls7xkFKf4ndqmREMhnhDCvPGpR5lvdjgwEFwU71RpmND1f6PRWT4yU9sppmFGH+p5ws2DSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=X5l6rrMt; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="X5l6rrMt"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id hYYlsID0EHdE499X; Mon, 29 Sep 2025 10:41:06 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=dHPUKOiCryntFUoZ4XwzAXg+TxheQ7iawZOAUoLgJWI=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=X5l6rrMt1yLhESu6/Etc
	t6mFIMi4PsqQBepZFucl2MtYFZ4R5JxV94Kh24QoLUpE+OpqrWkF6hbvsEl0gzDrZoSk2TXQdsMcK
	l7m20DJHyu+ucupJVulqH7wLYs0d4nEADsL7Wqk1Rt907ba4GNZtZs9WjqxoyoDrKRNPcneGR8=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14216635; Mon, 29 Sep 2025 10:41:06 -0400
Message-ID: <dce404c2-c10d-4327-abf3-1cd4885e2081@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 29 Sep 2025 10:41:06 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [SCST PATCH v2 09/16] scsi: qla2xxx: fix races with aborting commands
Content-Language: en-US
X-ASG-Orig-Subj: [SCST PATCH v2 09/16] scsi: qla2xxx: fix races with aborting commands
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <e95ee7d0-3580-4124-b854-7f73ca3a3a84@cybernetics.com>
 <814e26dc-da8d-474f-b2f2-39becfe94eec@cybernetics.com>
In-Reply-To: <814e26dc-da8d-474f-b2f2-39becfe94eec@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1759156866
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 8329
X-Barracuda-BRTS-Status: 1
X-ASG-Debug-ID: 1759156866-1cf43947df3c0360001-ziuLRu

This patch applies to the out-of-tree SCST project, not to the Linux
kernel.  Apply when importing the upstream patch with the same title.

SCST addendum:

sqa_on_hw_pending_cmd_timeout() currently unmaps DMA, sets
outstanding_cmds[h] to NULL, and forces the command to complete.  This
could cause a kernel crash if the HW later accesses the DMA mapping.
It can also cause other problems if outstanding_cmds[h] is reused for a
different command.  Fix by doing this instead:

- In sqa_on_hw_pending_cmd_timeout(), call qlt_send_term_exchange()
  first and then restart the timeout.  After another timeout, reset the
  ISP.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v1 -> v2:
- On second timeout, reset the ISP rather than unmapping DMA that
  might be in use by the hardware.
- Apply "scsi: qla2xxx: clear cmds after chip reset" from Dmitry
  Bogdanov as prerequisite.  This is required for the ISP reset to clear
  the locked-up command.
- Move the revert of 26f9ce53817a ("scsi: qla2xxx: Fix missed DMA unmap
  for aborted commands") from this patch to the previous patch since
  that patch fixed the oops, even though this patch is still necessary
  for its other improvements.  Rename this patch and reword the patch
  description to match.
- Remove TRC_CTIO_IGNORED.

 qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c | 136 ++++++++++--------
 1 file changed, 76 insertions(+), 60 deletions(-)

diff --git a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
index e885b9711..07aee6e81 100644
--- a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
+++ b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
@@ -187,6 +187,7 @@ static struct cmd_state_name {
 	{QLA_TGT_STATE_NEED_DATA, "NeedData"},
 	{QLA_TGT_STATE_DATA_IN, "DataIn"},
 	{QLA_TGT_STATE_PROCESSED, "Processed"},
+	{QLA_TGT_STATE_DONE, "Done"},
 };
 
 static char *cmdstate_to_str(uint8_t state)
@@ -497,23 +498,14 @@ static void sqa_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 {
 	struct scst_cmd *scst_cmd = cmd->scst_cmd;
 	int rx_status;
-	unsigned long flags;
 
 	TRACE_ENTRY();
 
-	spin_lock_irqsave(&cmd->cmd_lock, flags);
-	if (cmd->aborted) {
-		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
-
+	if (unlikely(cmd->aborted)) {
 		scst_set_cmd_error(scst_cmd,
 			SCST_LOAD_SENSE(scst_sense_internal_failure));
-		scst_rx_data(scst_cmd, SCST_RX_STATUS_ERROR_SENSE_SET,
-			SCST_CONTEXT_THREAD);
-		return;
-	}
-	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
-
-	if (cmd->write_data_transferred) {
+		rx_status = SCST_RX_STATUS_ERROR_SENSE_SET;
+	} else if (likely(cmd->write_data_transferred)) {
 		rx_status = SCST_RX_STATUS_SUCCESS;
 	} else {
 		rx_status = SCST_RX_STATUS_ERROR_SENSE_SET;
@@ -691,6 +683,7 @@ static void sqa_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
 
 	TRACE_ENTRY();
 
+	cmd->state = QLA_TGT_STATE_DONE;
 	cmd->trc_flags |= TRC_CMD_DONE;
 	scst_tgt_cmd_done(scst_cmd, scst_work_context);
 
@@ -1522,9 +1515,10 @@ static int sqa_xmit_response(struct scst_cmd *scst_cmd)
 	cmd = scst_cmd_get_tgt_priv(scst_cmd);
 
 	if (scst_cmd_aborted_on_xmit(scst_cmd)) {
-		TRACE_MGMT_DBG("sqatgt(%ld/%d): CMD_ABORTED cmd[%p]",
-			cmd->vha->host_no, cmd->vha->vp_idx,
-			cmd);
+		TRACE_MGMT_DBG(
+		    "sqatgt(%ld/%d): tag %lld: skipping send response for aborted cmd",
+		    cmd->vha->host_no, cmd->vha->vp_idx,
+		    scst_cmd_get_tag(scst_cmd));
 		qlt_abort_cmd(cmd);
 		scst_set_delivery_status(scst_cmd, SCST_CMD_DELIVERY_ABORTED);
 		scst_tgt_cmd_done(scst_cmd, SCST_CONTEXT_DIRECT);
@@ -1841,72 +1835,94 @@ static int sqa_qla2xxx_dif_tags(struct qla_tgt_cmd *cmd,
 	return t32;
 }
 
-static void sqa_cleanup_hw_pending_cmd(scsi_qla_host_t *vha,
-	struct qla_tgt_cmd *cmd)
-{
-	uint32_t h;
-	struct qla_qpair *qpair = cmd->qpair;
-
-	for (h = 1; h < qpair->req->num_outstanding_cmds; h++) {
-		if (qpair->req->outstanding_cmds[h] == (srb_t *)cmd) {
-			printk(KERN_INFO "Clearing handle %d for cmd %p", h,
-			       cmd);
-			//TRACE_DBG("Clearing handle %d for cmd %p", h, cmd);
-			qpair->req->outstanding_cmds[h] = NULL;
-			break;
-		}
-	}
-}
-
 static void sqa_on_hw_pending_cmd_timeout(struct scst_cmd *scst_cmd)
 {
 	struct qla_tgt_cmd *cmd = scst_cmd_get_tgt_priv(scst_cmd);
 	struct scsi_qla_host *vha = cmd->vha;
 	struct qla_qpair *qpair = cmd->qpair;
-	uint8_t aborted = cmd->aborted;
 	unsigned long flags;
 
 	TRACE_ENTRY();
-	TRACE_MGMT_DBG("sqatgt(%ld/%d): Cmd %p HW pending for too long (state %s) %s; %s;",
-		       vha->host_no, vha->vp_idx, cmd,
-		       cmdstate_to_str((uint8_t)cmd->state),
-		       cmd->cmd_sent_to_fw ? "sent to fw" : "not sent to fw",
-		       aborted ? "aborted" : "not aborted");
 
-
-	qlt_abort_cmd(cmd);
+	scst_cmd_get(scst_cmd);
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+
+	TRACE_MGMT_DBG(
+	    "sqatgt(%ld/%d): tag %lld: HW pending for too long (state %s) %s; %s",
+	    vha->host_no, vha->vp_idx, scst_cmd_get_tag(scst_cmd),
+	    cmdstate_to_str((uint8_t)cmd->state),
+	    cmd->cmd_sent_to_fw ? "sent to fw" : "not sent to fw",
+	    cmd->aborted ? "aborted" : "not aborted");
+
 	switch (cmd->state) {
 	case QLA_TGT_STATE_NEW:
 	case QLA_TGT_STATE_DATA_IN:
-		PRINT_ERROR("sqa(%ld): A command in state (%s) should not be HW pending. %s",
-			vha->host_no, cmdstate_to_str((uint8_t)cmd->state),
-			aborted ? "aborted" : "not aborted");
-		break;
+	case QLA_TGT_STATE_DONE:
+		PRINT_ERROR(
+		    "sqatgt(%ld/%d): tag %lld: A command in state (%s) should not be HW pending. %s",
+		    vha->host_no, vha->vp_idx, scst_cmd_get_tag(scst_cmd),
+		    cmdstate_to_str((uint8_t)cmd->state),
+		    cmd->aborted ? "aborted" : "not aborted");
+		goto out_unlock;
 
 	case QLA_TGT_STATE_NEED_DATA:
-		/* the abort will nudge it out of FW */
-		TRACE_MGMT_DBG("Force rx_data cmd %p", cmd);
-		sqa_cleanup_hw_pending_cmd(vha, cmd);
-		scst_set_cmd_error(scst_cmd,
-		    SCST_LOAD_SENSE(scst_sense_internal_failure));
-		scst_rx_data(scst_cmd, SCST_RX_STATUS_ERROR_SENSE_SET,
-		    SCST_CONTEXT_THREAD);
-		break;
 	case QLA_TGT_STATE_PROCESSED:
-		if (!cmd->cmd_sent_to_fw)
-			PRINT_ERROR("sqa(%ld): command should not be in HW pending. It's already processed. ",
-				    vha->host_no);
-		else
-			TRACE_MGMT_DBG("Force finishing cmd %p", cmd);
-		sqa_cleanup_hw_pending_cmd(vha, cmd);
-		scst_set_delivery_status(scst_cmd, SCST_CMD_DELIVERY_FAILED);
-		scst_tgt_cmd_done(scst_cmd, SCST_CONTEXT_THREAD);
 		break;
 	}
+
+	/* Handle race with normal CTIO completion. */
+	if (!cmd->cmd_sent_to_fw) {
+		TRACE_MGMT_DBG(
+		    "sqatgt(%ld/%d): tag %lld: cmd not sent to fw; assuming just completed",
+		    vha->host_no, vha->vp_idx,
+		    scst_cmd_get_tag(scst_cmd));
+		goto out_unlock;
+	}
+
+	/* The command should be aborted elsewhere if the ISP was reset. */
+	if (!qpair->fw_started || cmd->reset_count != qpair->chip_reset)
+		goto out_unlock;
+
+	/* Reset the ISP if there was a timeout after sending a term exchange. */
+	if (cmd->sent_term_exchg &&
+	     time_is_before_jiffies(cmd->jiffies_at_term_exchg +
+				    SQA_MAX_HW_PENDING_TIME * HZ / 2)) {
+		if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) {
+			if (IS_P3P_TYPE(vha->hw))
+				set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+			else
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+		}
+		goto out_unlock;
+	}
+
+	/*
+	 * We still expect a CTIO response from the hw.  Terminating the
+	 * exchange should force the CTIO response to happen sooner.
+	 */
+	if (!cmd->sent_term_exchg)
+		qlt_send_term_exchange(qpair, cmd, &cmd->atio, 1);
+
+	/*
+	 * Restart the timer so that this function is called again
+	 * after another timeout.  This is similar to
+	 * scst_update_hw_pending_start() except that we also set
+	 * cmd_hw_pending to 1.
+	 *
+	 * IRQs are already OFF.
+	 */
+	spin_lock(&scst_cmd->sess->sess_list_lock);
+	scst_cmd->cmd_hw_pending = 1;
+	scst_cmd->hw_pending_start = jiffies;
+	spin_unlock(&scst_cmd->sess->sess_list_lock);
+
+out_unlock:
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
+	scst_cmd_put(scst_cmd);
+
 	TRACE_EXIT();
 }
 
-- 
2.43.0


