Received: from mail.cybernetics.com (mail.cybernetics.com [173.71.130.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272242E8DEF
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 18:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.71.130.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357962; cv=none; b=n3rMaex1MxnwOOxE4VMlcsA2NdG1KJxQq61bPMKeyit9C9zVD8EqBX2XsebNbcsTAVajDCxFMAu2eu/WKuFaGtVqxNo538yqvuWUwjp7jWilC1St+EemybIvxh64wsrQkq+z86iVs1jlp2gOh9qVVHQOhp/wbX76bwS1Ik5JCZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357962; c=relaxed/simple;
	bh=eUD4H2lEBl4FgZWPonZsqbKkm7A5DetXQMYfDlhHvyY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Nd9ktSmTUD5QevfPR+h1I5hN3enmZiKGdeDR2zsOFe46wbNwY+8qMtKywhzK54poYzjaDMntBr4EVbY6CMzGWqamlxE6nM+UJhoKfGZKv3aio8+Em+OrWbDmzc/gkcSN5MY5o4dO4asui3lf+Ts4nO5q2gxDomvPE9ZSgNzdf9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=Lsm+PhO4; arc=none smtp.client-ip=173.71.130.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="Lsm+PhO4"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id QbSgKOf29cnpiqoJ; Mon, 08 Sep 2025 14:59:18 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=27Z1VxwqRzQzCgTX9COlyHjuv+YwsY1VzPRfrEERNPk=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=Lsm+PhO423F7mrlzULiN
	T5IU5jZ/qWUUmKKO8vMA63deIRFXVQEwiLy5s0LzvKH6qAYo0RXTYp8zdtPxLnmyzJCo5GpCUwviB
	qWb4efAa1H+Fi8m+E/msUf5P/z/y1LIDOtYzFvS/k6e4Vxf980xHateaiu15cOShdC31eMf3TQ=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14189135; Mon, 08 Sep 2025 14:59:18 -0400
Message-ID: <fa3d6bb5-eea0-4cc3-86c2-93874f439b42@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 14:59:18 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [SCST PATCH 08/15] scsi: qla2xxx: fix oops during cmd abort
Content-Language: en-US
X-ASG-Orig-Subj: [SCST PATCH 08/15] scsi: qla2xxx: fix oops during cmd abort
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <80974286-f8ac-4eff-9439-c05fe38716b1@cybernetics.com>
In-Reply-To: <80974286-f8ac-4eff-9439-c05fe38716b1@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757357958
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 8943
X-ASG-Debug-ID: 1757357958-1cf43947df30c4c0001-ziuLRu

This patch applies to the out-of-tree SCST project, not to the Linux
kernel.  Apply when importing the upstream patch with the same title.

SCST addendum:

- In sqa_on_hw_pending_cmd_timeout(), call qlt_send_term_exchange()
  first and then restart the timeout.  After another timeout, force the
  cmd to finish without waiting for a response from the HW.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c | 172 +++++++++++++-----
 1 file changed, 122 insertions(+), 50 deletions(-)

diff --git a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
index e885b9711..9371dad06 100644
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
@@ -1841,18 +1835,26 @@ static int sqa_qla2xxx_dif_tags(struct qla_tgt_cmd *cmd,
 	return t32;
 }
 
+/*
+ * Prevent the CTIO completion handler from finding the given cmd, which will
+ * cause the CTIO to be ignored.
+ */
 static void sqa_cleanup_hw_pending_cmd(scsi_qla_host_t *vha,
 	struct qla_tgt_cmd *cmd)
 {
+	struct req_que *req = cmd->qpair->req;
 	uint32_t h;
-	struct qla_qpair *qpair = cmd->qpair;
 
-	for (h = 1; h < qpair->req->num_outstanding_cmds; h++) {
-		if (qpair->req->outstanding_cmds[h] == (srb_t *)cmd) {
-			printk(KERN_INFO "Clearing handle %d for cmd %p", h,
-			       cmd);
-			//TRACE_DBG("Clearing handle %d for cmd %p", h, cmd);
-			qpair->req->outstanding_cmds[h] = NULL;
+	cmd->cmd_sent_to_fw = 0;
+	cmd->trc_flags |= TRC_CTIO_IGNORED;
+
+	for (h = 1; h < req->num_outstanding_cmds; h++) {
+		if (req->outstanding_cmds[h] == (srb_t *)cmd) {
+			PRINT_INFO(
+			    "sqatgt(%ld/%d): tag %lld: handle %x: detaching cmd from handle; CTIO will be ignored",
+			    vha->host_no, vha->vp_idx,
+			    se_cmd_tag(&cmd->se_cmd), h);
+			req->outstanding_cmds[h] = NULL;
 			break;
 		}
 	}
@@ -1863,50 +1865,120 @@ static void sqa_on_hw_pending_cmd_timeout(struct scst_cmd *scst_cmd)
 	struct qla_tgt_cmd *cmd = scst_cmd_get_tgt_priv(scst_cmd);
 	struct scsi_qla_host *vha = cmd->vha;
 	struct qla_qpair *qpair = cmd->qpair;
-	uint8_t aborted = cmd->aborted;
 	unsigned long flags;
+	bool advance_cmd = false;
 
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
+	/* Check for chip reset or a timeout after sending a term exchange. */
+	if (!qpair->fw_started ||
+	    cmd->reset_count != qpair->chip_reset ||
+	    (cmd->sent_term_exchg &&
+	     time_is_before_jiffies(cmd->jiffies_at_term_exchg +
+				    SQA_MAX_HW_PENDING_TIME * HZ / 2))) {
+		/*
+		 * Timeout waiting for a response from the hw, so force the cmd
+		 * to finish without waiting any longer.  Note that this is
+		 * slightly dangerous if the hw is still using the DMA
+		 * mapping, so try term exchange first and see if that works.
+		 */
+
+		sqa_cleanup_hw_pending_cmd(vha, cmd);
+
+		qlt_unmap_sg(vha, cmd);
+
+		advance_cmd = true;
+	} else {
+		/*
+		 * We still expect a CTIO response from the hw.  Terminating the
+		 * exchange should force the CTIO response to happen sooner.
+		 */
+		if (!cmd->sent_term_exchg)
+			qlt_send_term_exchange(qpair, cmd, &cmd->atio, 1);
+	}
+
+	if (advance_cmd) {
+		switch (cmd->state) {
+		case QLA_TGT_STATE_NEED_DATA:
+			TRACE_MGMT_DBG(
+			    "sqatgt(%ld/%d): tag %lld: force rx_data",
+			    vha->host_no, vha->vp_idx,
+			    scst_cmd_get_tag(scst_cmd));
+			cmd->state = QLA_TGT_STATE_DATA_IN;
+			scst_set_cmd_error(scst_cmd,
+			    SCST_LOAD_SENSE(scst_sense_internal_failure));
+			scst_rx_data(scst_cmd, SCST_RX_STATUS_ERROR_SENSE_SET,
+			    SCST_CONTEXT_THREAD);
+			break;
+
+		case QLA_TGT_STATE_PROCESSED:
+			TRACE_MGMT_DBG(
+			    "sqatgt(%ld/%d): tag %lld: force finishing cmd",
+			    vha->host_no, vha->vp_idx,
+			    scst_cmd_get_tag(scst_cmd));
+			scst_set_delivery_status(scst_cmd, SCST_CMD_DELIVERY_FAILED);
+			scst_tgt_cmd_done(scst_cmd, SCST_CONTEXT_THREAD);
+			break;
+
+		default:
+			break;
+		}
+	} else {
+		/*
+		 * Restart the timer so that this function is called again
+		 * after another timeout.  This is similar to
+		 * scst_update_hw_pending_start() except that we also set
+		 * cmd_hw_pending to 1.
+		 *
+		 * IRQs are already OFF.
+		 */
+		spin_lock(&scst_cmd->sess->sess_list_lock);
+		scst_cmd->cmd_hw_pending = 1;
+		scst_cmd->hw_pending_start = jiffies;
+		spin_unlock(&scst_cmd->sess->sess_list_lock);
+	}
+
+out_unlock:
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
+	scst_cmd_put(scst_cmd);
+
 	TRACE_EXIT();
 }
 
-- 
2.43.0


