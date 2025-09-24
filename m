Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE14273FD
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 19:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758743043; cv=none; b=qmc6p9MwdPxeqFJJ8QuBgM2Rv/eQ6/6D9hdc3yntIDKpFcQBibYdqZUfhrreNJyTnWI6cC8Csd4raJdZIEcncnS9H/MloDSDNOnCdj8pBub+nsiNGKWSOxyCL+wCFrP6FxIixd6ZDf5qqNG/q2fwpxlDo4mn1nGNtxD9x7in3Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758743043; c=relaxed/simple;
	bh=/GBfhvz1vgECsunkS5tptPSlU7u3Qwm1QfJQYBQM/0s=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=fKffPEC6P9OtNbIL34Rsl2L5dShO5BEDawEn+lcRFmiKN7oNn57Jen6eBJKxs0V35TYO61EcenJmlHF8ynMz8CQ36FnVPYAbsDYMIC8skzuQcc9qKd4xtT9K4sahspnijUDe+orSlRq+owxsTkcsZH2dGUzbCQ6SOoBDAOUinxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=WS+U9NAg; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="WS+U9NAg"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id fFlWx7UgbaeEltFH; Wed, 24 Sep 2025 15:43:59 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=LJE7QksyA54DuCSiYbp+rvCz3XErUe18AkzLBqdfi/8=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=WS+U9NAgZ+iLXOaUyUpr
	Asz/FAmNFsSuYnL+TODp2/ThjUd88QlwJ8b7mR3rc24uF7SIhGmipHGWMaxda0O4QQ4w2ILCZbKyW
	T7LKcqeVQf89NkQRnUD1vIEfURSNSb5EZqqviDujhdk8iHgUonkZb1EUOwEVyReIsaJ1Emc6cc=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14211690; Wed, 24 Sep 2025 15:43:59 -0400
Message-ID: <66d71ab7-96f9-4d96-9d9c-9d2f43adb170@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Wed, 24 Sep 2025 15:43:59 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 09/16] scsi: qla2xxx: fix races with aborting commands
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v2 09/16] scsi: qla2xxx: fix races with aborting commands
From: Tony Battersby <tonyb@cybernetics.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <80974286-f8ac-4eff-9439-c05fe38716b1@cybernetics.com>
 <20250911142135.GA624@yadro.com>
 <e8cc07cf-9bd1-41a4-bd46-44e18179154b@cybernetics.com>
In-Reply-To: <e8cc07cf-9bd1-41a4-bd46-44e18179154b@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1758743039
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 19130
X-ASG-Debug-ID: 1758743039-1cf43947df39d890001-ziuLRu

(target mode)

cmd->cmd_lock only protects cmd->aborted, but when deciding how to
process a cmd, it is necessary to consider other factors such as
cmd->state and if the chip has been reset, which are protected by
qpair->qp_lock_ptr.  So replace cmd_lock with qp_lock_ptr, whick makes
it possible to check additional values and make decisions about what to
do without racing with the CTIO handler and other code.

- Lock cmd->qpair->qp_lock_ptr when aborting a cmd.
- Eliminate cmd->cmd_lock and change cmd->aborted to a bitfield since it
  is now protected by qp_lock_ptr just like all the other flags.
- Add another command state QLA_TGT_STATE_DONE to avoid any possible
  races between qlt_abort_cmd() and tgt_ops->free_cmd().
- Add the cmd->sent_term_exchg flag to indicate if
  qlt_send_term_exchange() has already been called.
- Export qlt_send_term_exchange() for SCST so that it can be called
  directly instead of trying to make qlt_abort_cmd() work for both
  TMR abort and HW timeout.

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
- No longer export qlt_unmap_sg().
- Export qla2xxx_wake_dpc().
- Remove TRC_CTIO_IGNORED.

 drivers/scsi/qla2xxx/qla_os.c      |   1 +
 drivers/scsi/qla2xxx/qla_target.c  | 198 +++++++++++++----------------
 drivers/scsi/qla2xxx/qla_target.h  |  17 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   2 +
 4 files changed, 102 insertions(+), 116 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 739137ddfd68..2a3eb1dacf86 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7248,6 +7248,7 @@ qla2xxx_wake_dpc(struct scsi_qla_host *vha)
 	if (!test_bit(UNLOADING, &vha->dpc_flags) && t)
 		wake_up_process(t);
 }
+EXPORT_SYMBOL(qla2xxx_wake_dpc);
 
 /*
 *  qla2x00_rst_aen
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2abdb8ce0302..c6dc5e9efb69 100644
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
@@ -3461,7 +3445,6 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 	uint8_t		*ep = &sts->expected_dif[0];
 	uint64_t	lba = cmd->se_cmd.t_task_lba;
 	uint8_t scsi_status, sense_key, asc, ascq;
-	unsigned long flags;
 	struct scsi_qla_host *vha = cmd->vha;
 
 	cmd->trc_flags |= TRC_DIF_ERR;
@@ -3535,13 +3518,10 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
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
@@ -3696,9 +3676,22 @@ static int __qlt_send_term_exchange(struct qla_qpair *qpair,
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
@@ -3722,10 +3715,14 @@ static void qlt_send_term_exchange(struct qla_qpair *qpair,
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
@@ -3733,6 +3730,7 @@ static void qlt_send_term_exchange(struct qla_qpair *qpair,
 
 	return;
 }
+EXPORT_SYMBOL(qlt_send_term_exchange);
 
 static void qlt_init_term_exchange(struct scsi_qla_host *vha)
 {
@@ -3783,35 +3781,35 @@ static void qlt_chk_exch_leak_thresh_hold(struct scsi_qla_host *vha)
 
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
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 
-	spin_lock_irqsave(&cmd->cmd_lock, flags);
-	if (cmd->aborted) {
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
@@ -3842,40 +3840,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
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
@@ -3981,22 +3945,35 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
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
@@ -4017,6 +3994,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 			    logged_out ? "PORT LOGGED OUT" : "PORT UNAVAILABLE",
 			    status, cmd->state, se_cmd);
 
+			term_exchg = true;
 			if (logged_out && cmd->sess) {
 				/*
 				 * Session is already logged out, but we need
@@ -4062,19 +4040,21 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
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
@@ -4164,7 +4144,6 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 		goto out_term;
 	}
 
-	spin_lock_init(&cmd->cmd_lock);
 	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
 	cmd->se_cmd.tag = le32_to_cpu(atio->u.isp24.exchange_addr);
 
@@ -4201,7 +4180,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	 */
 	cmd->trc_flags |= TRC_DO_WORK_ERR;
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
-	qlt_send_term_exchange(qpair, NULL, &cmd->atio, 1, 0);
+	qlt_send_term_exchange(qpair, NULL, &cmd->atio, 1);
 
 	qlt_decr_num_pend_cmds(vha);
 	cmd->vha->hw->tgt.tgt_ops->rel_cmd(cmd);
@@ -5360,6 +5339,7 @@ static void qlt_handle_imm_notify(struct scsi_qla_host *vha,
 		if (qlt_24xx_handle_els(vha, iocb) == 0)
 			send_notify_ack = 0;
 		break;
+
 	default:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06d,
 		    "qla_target(%d): Received unknown immediate "
@@ -5394,7 +5374,7 @@ static int __qlt_send_busy(struct qla_qpair *qpair,
 	sess = qla2x00_find_fcport_by_nportid(vha, &id, 1);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	if (!sess) {
-		qlt_send_term_exchange(qpair, NULL, atio, 1, 0);
+		qlt_send_term_exchange(qpair, NULL, atio, 1);
 		return 0;
 	}
 	/* Sending marker isn't necessary, since we called from ISR */
@@ -5623,7 +5603,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 				ql_dbg(ql_dbg_tgt, vha, 0xe05f,
 				    "qla_target: Unable to send command to target, sending TERM EXCHANGE for rsp\n");
 				qlt_send_term_exchange(ha->base_qpair, NULL,
-				    atio, 1, 0);
+				    atio, 1);
 				break;
 			case -EBUSY:
 				ql_dbg(ql_dbg_tgt, vha, 0xe060,
@@ -5830,7 +5810,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha,
 				ql_dbg(ql_dbg_tgt, vha, 0xe05f,
 				    "qla_target: Unable to send command to target, sending TERM EXCHANGE for rsp\n");
 				qlt_send_term_exchange(rsp->qpair, NULL,
-				    atio, 1, 0);
+				    atio, 1);
 				break;
 			case -EBUSY:
 				ql_dbg(ql_dbg_tgt, vha, 0xe060,
@@ -6720,7 +6700,7 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 
 			adjust_corrupted_atio(pkt);
 			qlt_send_term_exchange(ha->base_qpair, NULL, pkt,
-			    ha_locked, 0);
+			    ha_locked);
 		} else {
 			qlt_24xx_atio_pkt_all_vps(vha,
 			    (struct atio_from_isp *)pkt, ha_locked);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index c483966d0a84..eb15d8e9f79e 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -754,6 +754,7 @@ int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
 #define QLA_TGT_STATE_NEED_DATA		1 /* target needs data to continue */
 #define QLA_TGT_STATE_DATA_IN		2 /* Data arrived + target processing */
 #define QLA_TGT_STATE_PROCESSED		3 /* target done processing */
+#define QLA_TGT_STATE_DONE		4 /* cmd being freed */
 
 /* ATIO task_codes field */
 #define ATIO_SIMPLE_QUEUE           0
@@ -876,8 +877,6 @@ struct qla_tgt_cmd {
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
 
-	spinlock_t cmd_lock;
-	/* to save extra sess dereferences */
 	unsigned int conf_compl_supported:1;
 	unsigned int sg_mapped:1;
 	unsigned int write_data_transferred:1;
@@ -887,13 +886,14 @@ struct qla_tgt_cmd {
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
@@ -932,6 +932,7 @@ struct qla_tgt_cmd {
 #define DIF_BUNDL_DMA_VALID 1
 	uint16_t prot_flags;
 
+	unsigned long jiffies_at_term_exchg;
 	uint64_t jiffies_at_alloc;
 	uint64_t jiffies_at_free;
 
@@ -1055,6 +1056,8 @@ extern void qlt_response_pkt_all_vps(struct scsi_qla_host *, struct rsp_que *,
 extern int qlt_rdy_to_xfer(struct qla_tgt_cmd *);
 extern int qlt_xmit_response(struct qla_tgt_cmd *, int, uint8_t);
 extern int qlt_abort_cmd(struct qla_tgt_cmd *);
+void qlt_send_term_exchange(struct qla_qpair *qpair,
+	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked);
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


