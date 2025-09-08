Received: from mail.cybernetics.com (mail.cybernetics.com [173.71.130.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9363E1A5BBE
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 18:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.71.130.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357889; cv=none; b=J3HMteh4adsKSr+iIGD7cKTXzstN5LRm4xd09YwS23GOuM3qJd7cvqbVjU6vLiigTIFF+xyA8fA+VOeIKg/dmePTXsa4fgZiQ1jLiIPcvIJn3smtJo0gpEtIEFnnxXBKTrKhJqIzp5giXhE0SCaqaD6HOgxYDF+VvmPsdc0WpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357889; c=relaxed/simple;
	bh=z6xiguFRwEVZUVci1ubFJKPnmonNX61NJNbu9I5BV5s=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ETOCYgy/dBm1NUz9iePmMd/WSGO9Eoo/G3Mdi0UK09RrIlBgNtUEr/hX5LA7C7qPB/SlOwP1UJirBPMa3+WGtFTk5gtB7l6H5ZwA3nY8bLGhs4bBE0q9ZN4rHt+GAu706biMVYiGkrtm12OHbXhOOsVf7g3bIjX6AyUtYlEKTlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=Lln3G0Dr; arc=none smtp.client-ip=173.71.130.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="Lln3G0Dr"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id LZ0tN8LV2zDlO3DC; Mon, 08 Sep 2025 14:58:06 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=DUwVIZt9/nOUQijIXMuXJwo53fSVFD7gpbSIsIywAHc=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=Lln3G0DrYU6CsWVTFtVJ
	iX7wA8dfm/ke5BiItobprtlUyhjwfhg/VEP7DtW8tIgm3Pi9kXjOn8V3zl0aw1UE78gCqc1D1T0Qo
	wnSqj7xCFTxGrwljfl3VmHzHoyI76CzGaumaiIz3z2WokCrKaYgAzx2SsQo1rVb0Y41iQsmP1g=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14189143; Mon, 08 Sep 2025 14:58:06 -0400
Message-ID: <80974286-f8ac-4eff-9439-c05fe38716b1@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 14:58:06 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 08/15] scsi: qla2xxx: fix oops during cmd abort
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH 08/15] scsi: qla2xxx: fix oops during cmd abort
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
In-Reply-To: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757357886
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 19423
X-ASG-Debug-ID: 1757357886-1cf43947df30c450001-ziuLRu

(target mode)

There is a race between the following:

CPU 1:
scst_hw_pending_work_fn() ->
sqa_on_hw_pending_cmd_timeout() ->
qlt_abort_cmd() ->
qlt_unmap_sg()

CPU 2:
qla_do_work() ->
qla24xx_process_response_queue() ->
qlt_do_ctio_completion() ->
qlt_unmap_sg()

Two CPUs calling qlt_unmap_sg() on the same cmd at the same time
results in an oops:

dma_unmap_sg_attrs()
	BUG_ON(!valid_dma_direction(dir));

This race is more likely to happen because qlt_abort_cmd() may cause the
hardware to send a CTIO.

The solution is to lock cmd->qpair->qp_lock_ptr when aborting a command.
This makes it possible to check the cmd state and make decisions about
what to do without racing with the CTIO handler and other code.

- Lock cmd->qpair->qp_lock_ptr when aborting a cmd.
- Eliminate cmd->cmd_lock and change cmd->aborted back to a bitfield
  since it is now protected by qp_lock_ptr just like all the other
  flags.
- Add another command state QLA_TGT_STATE_DONE to avoid any possible
  races between qlt_abort_cmd() and tgt_ops->free_cmd().
- Add the cmd->sent_term_exchg flag to indicate if
  qlt_send_term_exchange() has already been called.
- For SCST (scst_hw_pending_work_fn()), export qlt_send_term_exchange()
  and qlt_unmap_sg() so that they can be called directly instead of
  trying to make qlt_abort_cmd() work for both HW timeout and TMR abort.
- Add TRC_CTIO_IGNORED for scst_hw_pending_work_fn().

Fixes: 26f9ce53817a ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 204 +++++++++++++----------------
 drivers/scsi/qla2xxx/qla_target.h  |  19 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   2 +
 3 files changed, 105 insertions(+), 120 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b700bfc642b3..1160ca4c118f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -104,8 +104,6 @@ static void qlt_response_pkt(struct scsi_qla_host *ha, struct rsp_que *rsp,
 	response_t *pkt);
 static int qlt_issue_task_mgmt(struct fc_port *sess, u64 lun,
 	int fn, void *iocb, int flags);
-static void qlt_send_term_exchange(struct qla_qpair *, struct qla_tgt_cmd
-	*cmd, struct atio_from_isp *atio, int ha_locked, int ul_abort);
 static void qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio, uint16_t status, int qfull);
 static void qlt_disable_vha(struct scsi_qla_host *vha);
@@ -136,20 +134,6 @@ static struct workqueue_struct *qla_tgt_wq;
 static DEFINE_MUTEX(qla_tgt_mutex);
 static LIST_HEAD(qla_tgt_glist);
 
-static const char *prot_op_str(u32 prot_op)
-{
-	switch (prot_op) {
-	case TARGET_PROT_NORMAL:	return "NORMAL";
-	case TARGET_PROT_DIN_INSERT:	return "DIN_INSERT";
-	case TARGET_PROT_DOUT_INSERT:	return "DOUT_INSERT";
-	case TARGET_PROT_DIN_STRIP:	return "DIN_STRIP";
-	case TARGET_PROT_DOUT_STRIP:	return "DOUT_STRIP";
-	case TARGET_PROT_DIN_PASS:	return "DIN_PASS";
-	case TARGET_PROT_DOUT_PASS:	return "DOUT_PASS";
-	default:			return "UNKNOWN";
-	}
-}
-
 /* This API intentionally takes dest as a parameter, rather than returning
  * int value to avoid caller forgetting to issue wmb() after the store */
 void qlt_do_generation_tick(struct scsi_qla_host *vha, int *dest)
@@ -252,7 +236,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
 	return;
 
 out_term:
-	qlt_send_term_exchange(vha->hw->base_qpair, NULL, atio, ha_locked, 0);
+	qlt_send_term_exchange(vha->hw->base_qpair, NULL, atio, ha_locked);
 	goto out;
 }
 
@@ -271,7 +255,7 @@ static void qlt_try_to_dequeue_unknown_atios(struct scsi_qla_host *vha,
 			    "Freeing unknown %s %p, because of Abort\n",
 			    "ATIO_TYPE7", u);
 			qlt_send_term_exchange(vha->hw->base_qpair, NULL,
-			    &u->atio, ha_locked, 0);
+			    &u->atio, ha_locked);
 			goto abort;
 		}
 
@@ -285,7 +269,7 @@ static void qlt_try_to_dequeue_unknown_atios(struct scsi_qla_host *vha,
 			    "Freeing unknown %s %p, because tgt is being stopped\n",
 			    "ATIO_TYPE7", u);
 			qlt_send_term_exchange(vha->hw->base_qpair, NULL,
-			    &u->atio, ha_locked, 0);
+			    &u->atio, ha_locked);
 		} else {
 			ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0x503d,
 			    "Reschedule u %p, vha %p, host %p\n", u, vha, host);
@@ -2447,7 +2431,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 	return -1;
 }
 
-static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
+void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 {
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
@@ -2473,6 +2457,7 @@ static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 
 	dma_pool_free(ha->dl_dma_pool, cmd->ctx, cmd->ctx->crc_ctx_dma);
 }
+EXPORT_SYMBOL(qlt_unmap_sg);
 
 static int qlt_check_reserve_free_req(struct qla_qpair *qpair,
 	uint32_t req_cnt)
@@ -3461,7 +3446,6 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 	uint8_t		*ep = &sts->expected_dif[0];
 	uint64_t	lba = cmd->se_cmd.t_task_lba;
 	uint8_t scsi_status, sense_key, asc, ascq;
-	unsigned long flags;
 	struct scsi_qla_host *vha = cmd->vha;
 
 	cmd->trc_flags |= TRC_DIF_ERR;
@@ -3535,13 +3519,10 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 		vha->hw->tgt.tgt_ops->handle_data(cmd);
 		break;
 	default:
-		spin_lock_irqsave(&cmd->cmd_lock, flags);
-		if (cmd->aborted) {
-			spin_unlock_irqrestore(&cmd->cmd_lock, flags);
+		if (cmd->sent_term_exchg) {
 			vha->hw->tgt.tgt_ops->free_cmd(cmd);
 			break;
 		}
-		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
 		qlt_send_resp_ctio(qpair, cmd, scsi_status, sense_key, asc,
 		    ascq);
@@ -3696,9 +3677,22 @@ static int __qlt_send_term_exchange(struct qla_qpair *qpair,
 	return 0;
 }
 
-static void qlt_send_term_exchange(struct qla_qpair *qpair,
-	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked,
-	int ul_abort)
+/*
+ * Aborting a command that is active in the FW (i.e. cmd->cmd_sent_to_fw == 1)
+ * will usually trigger the FW to send a completion CTIO with error status,
+ * and the driver will then call the ->handle_data() or ->free_cmd() callbacks.
+ * This can be used to clear a command that is locked up in the FW unless there
+ * is something more seriously wrong.
+ *
+ * Aborting a command that is not active in the FW (i.e.
+ * cmd->cmd_sent_to_fw == 0) will not directly trigger any callbacks.  Instead,
+ * when the target mode midlevel calls qlt_rdy_to_xfer() or
+ * qlt_xmit_response(), the driver will see that the cmd has been aborted and
+ * call the appropriate callback immediately without performing the requested
+ * operation.
+ */
+void qlt_send_term_exchange(struct qla_qpair *qpair,
+	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked)
 {
 	struct scsi_qla_host *vha;
 	unsigned long flags = 0;
@@ -3722,10 +3716,14 @@ static void qlt_send_term_exchange(struct qla_qpair *qpair,
 		qlt_alloc_qfull_cmd(vha, atio, 0, 0);
 
 done:
-	if (cmd && !ul_abort && !cmd->aborted) {
-		if (cmd->sg_mapped)
-			qlt_unmap_sg(vha, cmd);
-		vha->hw->tgt.tgt_ops->free_cmd(cmd);
+	if (cmd) {
+		/*
+		 * Set this even if -ENOMEM above, since term exchange will be
+		 * sent eventually...
+		 */
+		cmd->sent_term_exchg = 1;
+		cmd->aborted = 1;
+		cmd->jiffies_at_term_exchg = jiffies;
 	}
 
 	if (!ha_locked)
@@ -3733,6 +3731,7 @@ static void qlt_send_term_exchange(struct qla_qpair *qpair,
 
 	return;
 }
+EXPORT_SYMBOL(qlt_send_term_exchange);
 
 static void qlt_init_term_exchange(struct scsi_qla_host *vha)
 {
@@ -3783,38 +3782,35 @@ static void qlt_chk_exch_leak_thresh_hold(struct scsi_qla_host *vha)
 
 int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 {
-	struct qla_tgt *tgt = cmd->tgt;
-	struct scsi_qla_host *vha = tgt->vha;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct scsi_qla_host *vha = cmd->vha;
+	struct qla_qpair *qpair = cmd->qpair;
 	unsigned long flags;
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
-	    "qla_target(%d): terminating exchange for aborted cmd=%p "
-	    "(se_cmd=%p, tag=%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
-	    se_cmd->tag);
-
-	spin_lock_irqsave(&cmd->cmd_lock, flags);
-	if (cmd->aborted) {
-		if (cmd->sg_mapped)
-			qlt_unmap_sg(vha, cmd);
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 
-		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
-		/*
-		 * It's normal to see 2 calls in this path:
-		 *  1) XFER Rdy completion + CMD_T_ABORT
-		 *  2) TCM TMR - drain_state_list
-		 */
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf016,
-		    "multiple abort. %p transport_state %x, t_state %x, "
-		    "se_cmd_flags %x\n", cmd, cmd->se_cmd.transport_state,
-		    cmd->se_cmd.t_state, cmd->se_cmd.se_cmd_flags);
-		return -EIO;
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
+	    "qla_target(%d): tag %lld: cmd being aborted (state %d) %s; %s\n",
+	    vha->vp_idx, cmd->se_cmd.tag, cmd->state,
+	    cmd->cmd_sent_to_fw ? "sent to fw" : "not sent to fw",
+	    cmd->aborted ? "aborted" : "not aborted");
+
+	if (cmd->state != QLA_TGT_STATE_DONE && !cmd->sent_term_exchg) {
+		if (!qpair->fw_started ||
+		    cmd->reset_count != qpair->chip_reset) {
+			/*
+			 * Chip was reset; just pretend that we sent the term
+			 * exchange.
+			 */
+			cmd->sent_term_exchg = 1;
+			cmd->aborted = 1;
+			cmd->jiffies_at_term_exchg = jiffies;
+		} else {
+			qlt_send_term_exchange(qpair, cmd, &cmd->atio, 1);
+		}
 	}
-	cmd->aborted = 1;
-	cmd->trc_flags |= TRC_ABORT;
-	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
-	qlt_send_term_exchange(cmd->qpair, cmd, &cmd->atio, 0, 1);
+	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
 	return 0;
 }
 EXPORT_SYMBOL(qlt_abort_cmd);
@@ -3845,40 +3841,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 }
 EXPORT_SYMBOL(qlt_free_cmd);
 
-/*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
- */
-static int qlt_term_ctio_exchange(struct qla_qpair *qpair, void *ctio,
-	struct qla_tgt_cmd *cmd, uint32_t status)
-{
-	int term = 0;
-	struct scsi_qla_host *vha = qpair->vha;
-
-	if (cmd->se_cmd.prot_op)
-		ql_dbg(ql_dbg_tgt_dif, vha, 0xe013,
-		    "Term DIF cmd: lba[0x%llx|%lld] len[0x%x] "
-		    "se_cmd=%p tag[%x] op %#x/%s",
-		     cmd->lba, cmd->lba,
-		     cmd->num_blks, &cmd->se_cmd,
-		     cmd->atio.u.isp24.exchange_addr,
-		     cmd->se_cmd.prot_op,
-		     prot_op_str(cmd->se_cmd.prot_op));
-
-	if (ctio != NULL) {
-		struct ctio7_from_24xx *c = (struct ctio7_from_24xx *)ctio;
-
-		term = !(c->flags &
-		    cpu_to_le16(OF_TERM_EXCH));
-	} else
-		term = 1;
-
-	if (term)
-		qlt_send_term_exchange(qpair, cmd, &cmd->atio, 1, 0);
-
-	return term;
-}
-
-
 /* ha->hardware_lock supposed to be held on entry */
 static void *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 	struct rsp_que *rsp, uint32_t handle, void *ctio)
@@ -3984,22 +3946,35 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 	qlt_unmap_sg(vha, cmd);
 
 	if (unlikely(status != CTIO_SUCCESS)) {
+		bool term_exchg = false;
+
+		/*
+		 * If the hardware terminated the exchange, then we don't need
+		 * to send an explicit term exchange message.
+		 */
+		if (ctio_flags & OF_TERM_EXCH) {
+			cmd->sent_term_exchg = 1;
+			cmd->aborted = 1;
+			cmd->jiffies_at_term_exchg = jiffies;
+		}
+
 		switch (status & 0xFFFF) {
 		case CTIO_INVALID_RX_ID:
+			term_exchg = true;
 			if (printk_ratelimit())
 				dev_info(&vha->hw->pdev->dev,
 				    "qla_target(%d): CTIO with INVALID_RX_ID ATIO attr %x CTIO Flags %x|%x\n",
 				    vha->vp_idx, cmd->atio.u.isp24.attr,
 				    ((cmd->ctio_flags >> 9) & 0xf),
 				    cmd->ctio_flags);
-
 			break;
+
 		case CTIO_LIP_RESET:
 		case CTIO_TARGET_RESET:
 		case CTIO_ABORTED:
-			/* driver request abort via Terminate exchange */
+			term_exchg = true;
+			fallthrough;
 		case CTIO_TIMEOUT:
-			/* They are OK */
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf058,
 			    "qla_target(%d): CTIO with "
 			    "status %#x received, state %x, se_cmd %p, "
@@ -4020,6 +3995,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 			    logged_out ? "PORT LOGGED OUT" : "PORT UNAVAILABLE",
 			    status, cmd->state, se_cmd);
 
+			term_exchg = true;
 			if (logged_out && cmd->sess) {
 				/*
 				 * Session is already logged out, but we need
@@ -4065,19 +4041,21 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 			break;
 		}
 
+		cmd->trc_flags |= TRC_CTIO_ERR;
 
-		/* "cmd->aborted" means
-		 * cmd is already aborted/terminated, we don't
-		 * need to terminate again.  The exchange is already
-		 * cleaned up/freed at FW level.  Just cleanup at driver
-		 * level.
+		/*
+		 * In state QLA_TGT_STATE_NEED_DATA the failed CTIO was for
+		 * Data-Out, so either abort the exchange or try sending check
+		 * condition with sense data depending on the severity of
+		 * the error.  In state QLA_TGT_STATE_PROCESSED the failed CTIO
+		 * was for status (and possibly Data-In), so don't try sending
+		 * an error status again in that case (if the error was for
+		 * Data-In with status, we could try sending status without
+		 * Data-In, but we don't do that currently).
 		 */
-		if ((cmd->state != QLA_TGT_STATE_NEED_DATA) &&
-		    (!cmd->aborted)) {
-			cmd->trc_flags |= TRC_CTIO_ERR;
-			if (qlt_term_ctio_exchange(qpair, ctio, cmd, status))
-				return;
-		}
+		if (!cmd->sent_term_exchg &&
+		    (term_exchg || cmd->state != QLA_TGT_STATE_NEED_DATA))
+			qlt_send_term_exchange(qpair, cmd, &cmd->atio, 1);
 	}
 
 	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
@@ -4167,7 +4145,6 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 		goto out_term;
 	}
 
-	spin_lock_init(&cmd->cmd_lock);
 	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
 	cmd->se_cmd.tag = le32_to_cpu(atio->u.isp24.exchange_addr);
 
@@ -4204,7 +4181,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	 */
 	cmd->trc_flags |= TRC_DO_WORK_ERR;
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
-	qlt_send_term_exchange(qpair, NULL, &cmd->atio, 1, 0);
+	qlt_send_term_exchange(qpair, NULL, &cmd->atio, 1);
 
 	qlt_decr_num_pend_cmds(vha);
 	cmd->vha->hw->tgt.tgt_ops->rel_cmd(cmd);
@@ -5363,6 +5340,7 @@ static void qlt_handle_imm_notify(struct scsi_qla_host *vha,
 		if (qlt_24xx_handle_els(vha, iocb) == 0)
 			send_notify_ack = 0;
 		break;
+
 	default:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06d,
 		    "qla_target(%d): Received unknown immediate "
@@ -5397,7 +5375,7 @@ static int __qlt_send_busy(struct qla_qpair *qpair,
 	sess = qla2x00_find_fcport_by_nportid(vha, &id, 1);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	if (!sess) {
-		qlt_send_term_exchange(qpair, NULL, atio, 1, 0);
+		qlt_send_term_exchange(qpair, NULL, atio, 1);
 		return 0;
 	}
 	/* Sending marker isn't necessary, since we called from ISR */
@@ -5626,7 +5604,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 				ql_dbg(ql_dbg_tgt, vha, 0xe05f,
 				    "qla_target: Unable to send command to target, sending TERM EXCHANGE for rsp\n");
 				qlt_send_term_exchange(ha->base_qpair, NULL,
-				    atio, 1, 0);
+				    atio, 1);
 				break;
 			case -EBUSY:
 				ql_dbg(ql_dbg_tgt, vha, 0xe060,
@@ -5833,7 +5811,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha,
 				ql_dbg(ql_dbg_tgt, vha, 0xe05f,
 				    "qla_target: Unable to send command to target, sending TERM EXCHANGE for rsp\n");
 				qlt_send_term_exchange(rsp->qpair, NULL,
-				    atio, 1, 0);
+				    atio, 1);
 				break;
 			case -EBUSY:
 				ql_dbg(ql_dbg_tgt, vha, 0xe060,
@@ -6723,7 +6701,7 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 
 			adjust_corrupted_atio(pkt);
 			qlt_send_term_exchange(ha->base_qpair, NULL, pkt,
-			    ha_locked, 0);
+			    ha_locked);
 		} else {
 			qlt_24xx_atio_pkt_all_vps(vha,
 			    (struct atio_from_isp *)pkt, ha_locked);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 15a59c125c53..adbc2a05b159 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -754,6 +754,7 @@ int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
 #define QLA_TGT_STATE_NEED_DATA		1 /* target needs data to continue */
 #define QLA_TGT_STATE_DATA_IN		2 /* Data arrived + target processing */
 #define QLA_TGT_STATE_PROCESSED		3 /* target done processing */
+#define QLA_TGT_STATE_DONE		4 /* cmd being freed */
 
 /* ATIO task_codes field */
 #define ATIO_SIMPLE_QUEUE           0
@@ -858,6 +859,7 @@ enum trace_flags {
 	TRC_DATA_IN = BIT_18,
 	TRC_ABORT = BIT_19,
 	TRC_DIF_ERR = BIT_20,
+	TRC_CTIO_IGNORED = BIT_21,
 };
 
 struct qla_tgt_cmd {
@@ -876,8 +878,6 @@ struct qla_tgt_cmd {
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
 
-	spinlock_t cmd_lock;
-	/* to save extra sess dereferences */
 	unsigned int conf_compl_supported:1;
 	unsigned int sg_mapped:1;
 	unsigned int write_data_transferred:1;
@@ -887,13 +887,14 @@ struct qla_tgt_cmd {
 	unsigned int cmd_in_wq:1;
 	unsigned int edif:1;
 
+	/* Set if the exchange has been terminated. */
+	unsigned int sent_term_exchg:1;
+
 	/*
-	 * This variable may be set from outside the LIO and I/O completion
-	 * callback functions. Do not declare this member variable as a
-	 * bitfield to avoid a read-modify-write operation when this variable
-	 * is set.
+	 * Set if sent_term_exchg is set, or if the cmd was aborted by a TMR,
+	 * or if some other error prevents normal processing of the command.
 	 */
-	unsigned int aborted;
+	unsigned int aborted:1;
 
 	struct scatterlist *sg;	/* cmd data buffer SG vector */
 	int sg_cnt;		/* SG segments count */
@@ -932,6 +933,7 @@ struct qla_tgt_cmd {
 #define DIF_BUNDL_DMA_VALID 1
 	uint16_t prot_flags;
 
+	unsigned long jiffies_at_term_exchg;
 	uint64_t jiffies_at_alloc;
 	uint64_t jiffies_at_free;
 
@@ -1055,6 +1057,9 @@ extern void qlt_response_pkt_all_vps(struct scsi_qla_host *, struct rsp_que *,
 extern int qlt_rdy_to_xfer(struct qla_tgt_cmd *);
 extern int qlt_xmit_response(struct qla_tgt_cmd *, int, uint8_t);
 extern int qlt_abort_cmd(struct qla_tgt_cmd *);
+void qlt_send_term_exchange(struct qla_qpair *qpair,
+	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked);
+void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index ceaf1c7b1d17..169219fe47a2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -303,6 +303,8 @@ static void tcm_qla2xxx_rel_cmd(struct qla_tgt_cmd *cmd)
  */
 static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
 {
+	cmd->state = QLA_TGT_STATE_DONE;
+
 	cmd->qpair->tgt_counters.core_qla_free_cmd++;
 	cmd->cmd_in_wq = 1;
 
-- 
2.43.0


