From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 9/9] qla2xxx: Remove se_cmd struct out of qla_tgt_cmd/qla_tgt_mgmt_cmd
Date: Sun, 18 Dec 2016 01:02:49 -0800
Message-ID: <1482051769-22941-10-git-send-email-himanshu.madhani@cavium.com>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0055.outbound.protection.outlook.com ([104.47.34.55]:51262
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759901AbcLRJEB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Dec 2016 04:04:01 -0500
In-Reply-To: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Move se_cmd struct outside of qla_tgt_cmd/qla_tgt_mgmt_cmd.
To convert the pointer from one struct to another, new inline
functions was added to take care of the convertion.

Cleanup dead SRR code.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 745 ++-----------------------------------
 drivers/scsi/qla2xxx/qla_target.h  |  18 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 184 ++++++---
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  10 +
 4 files changed, 182 insertions(+), 775 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c0d847a..96c7158 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -106,8 +106,6 @@ static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 	int fn, void *iocb, int flags);
 static void qlt_send_term_exchange(struct scsi_qla_host *ha, struct qla_tgt_cmd
 	*cmd, struct atio_from_isp *atio, int ha_locked, int ul_abort);
-static void qlt_reject_free_srr_imm(struct scsi_qla_host *ha,
-	struct qla_tgt_srr_imm *imm, int ha_lock);
 static void qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha,
 	struct qla_tgt_cmd *cmd);
 static void qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
@@ -2171,95 +2169,6 @@ static inline int qlt_need_explicit_conf(struct qla_hw_data *ha,
 		    cmd->conf_compl_supported;
 }
 
-#ifdef CONFIG_QLA_TGT_DEBUG_SRR
-/*
- *  Original taken from the XFS code
- */
-static unsigned long qlt_srr_random(void)
-{
-	static int Inited;
-	static unsigned long RandomValue;
-	static DEFINE_SPINLOCK(lock);
-	/* cycles pseudo-randomly through all values between 1 and 2^31 - 2 */
-	register long rv;
-	register long lo;
-	register long hi;
-	unsigned long flags;
-
-	spin_lock_irqsave(&lock, flags);
-	if (!Inited) {
-		RandomValue = jiffies;
-		Inited = 1;
-	}
-	rv = RandomValue;
-	hi = rv / 127773;
-	lo = rv % 127773;
-	rv = 16807 * lo - 2836 * hi;
-	if (rv <= 0)
-		rv += 2147483647;
-	RandomValue = rv;
-	spin_unlock_irqrestore(&lock, flags);
-	return rv;
-}
-
-static void qlt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type)
-{
-#if 0 /* This is not a real status packets lost, so it won't lead to SRR */
-	if ((*xmit_type & QLA_TGT_XMIT_STATUS) && (qlt_srr_random() % 200)
-	    == 50) {
-		*xmit_type &= ~QLA_TGT_XMIT_STATUS;
-		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf015,
-		    "Dropping cmd %p (tag %d) status", cmd, se_cmd->tag);
-	}
-#endif
-	/*
-	 * It's currently not possible to simulate SRRs for FCP_WRITE without
-	 * a physical link layer failure, so don't even try here..
-	 */
-	if (cmd->dma_data_direction != DMA_FROM_DEVICE)
-		return;
-
-	if (qlt_has_data(cmd) && (cmd->sg_cnt > 1) &&
-	    ((qlt_srr_random() % 100) == 20)) {
-		int i, leave = 0;
-		unsigned int tot_len = 0;
-
-		while (leave == 0)
-			leave = qlt_srr_random() % cmd->sg_cnt;
-
-		for (i = 0; i < leave; i++)
-			tot_len += cmd->sg[i].length;
-
-		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf016,
-		    "Cutting cmd %p (tag %d) buffer"
-		    " tail to len %d, sg_cnt %d (cmd->bufflen %d,"
-		    " cmd->sg_cnt %d)", cmd, se_cmd->tag, tot_len, leave,
-		    cmd->bufflen, cmd->sg_cnt);
-
-		cmd->bufflen = tot_len;
-		cmd->sg_cnt = leave;
-	}
-
-	if (qlt_has_data(cmd) && ((qlt_srr_random() % 100) == 70)) {
-		unsigned int offset = qlt_srr_random() % cmd->bufflen;
-
-		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf017,
-		    "Cutting cmd %p (tag %d) buffer head "
-		    "to offset %d (cmd->bufflen %d)", cmd, se_cmd->tag, offset,
-		    cmd->bufflen);
-		if (offset == 0)
-			*xmit_type &= ~QLA_TGT_XMIT_DATA;
-		else if (qlt_set_data_offset(cmd, offset)) {
-			ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf018,
-			    "qlt_set_data_offset() failed (tag %d)", se_cmd->tag);
-		}
-	}
-}
-#else
-static inline void qlt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type)
-{}
-#endif
-
 static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	struct qla_tgt_prm *prm)
 {
@@ -2365,8 +2274,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 static inline void
 qlt_set_t10dif_tags(struct qla_tgt_cmd *cmd, struct crc_context *ctx)
 {
-	struct se_cmd *se_cmd = &cmd->se_cmd;
-	uint32_t lba = 0xffffffff & se_cmd->t_task_lba;
+	uint32_t lba = 0xffffffff & cmd->lba;
 
 	/* wait til Mode Sense/Select cmd, modepage Ah, subpage 2
 	 * have been immplemented by TCM, before AppTag is avail.
@@ -2450,7 +2358,6 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	dma_addr_t		crc_ctx_dma;
 	uint16_t		fw_prot_opts = 0;
 	struct qla_tgt_cmd	*cmd = prm->cmd;
-	struct se_cmd		*se_cmd = &cmd->se_cmd;
 	uint32_t h;
 	struct atio_from_isp *atio = &prm->cmd->atio;
 	uint16_t t16;
@@ -2462,19 +2369,19 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	memset(pkt, 0, sizeof(*pkt));
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe071,
-		"qla_target(%d):%s: se_cmd[%p] CRC2 prot_op[0x%x] cmd prot sg:cnt[%p:%x] lba[%llu]\n",
-		vha->vp_idx, __func__, se_cmd, se_cmd->prot_op,
+		"qla_target(%d):%s: ulp_cmd[%p] CRC2 prot_op[0x%x] cmd prot sg:cnt[%p:%x] lba[%llu]\n",
+		vha->vp_idx, __func__, cmd->ulp_cmd, cmd->prot_op,
 		prm->prot_sg, prm->prot_seg_cnt, cmd->lba);
 
-	if ((se_cmd->prot_op == TARGET_PROT_DIN_INSERT) ||
-	    (se_cmd->prot_op == TARGET_PROT_DOUT_STRIP))
+	if ((cmd->prot_op == TARGET_PROT_DIN_INSERT) ||
+	    (cmd->prot_op == TARGET_PROT_DOUT_STRIP))
 		bundling = 0;
 
 	/* Compute dif len and adjust data len to incude protection */
 	data_bytes = cmd->bufflen;
 	dif_bytes  = (data_bytes / cmd->blk_sz) * 8;
 
-	switch (se_cmd->prot_op) {
+	switch (cmd->prot_op) {
 	case TARGET_PROT_DIN_INSERT:
 	case TARGET_PROT_DOUT_STRIP:
 		transfer_length = data_bytes;
@@ -2675,13 +2582,12 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	memset(&prm, 0, sizeof(prm));
-	qlt_check_srr_debug(cmd, &xmit_type);
 
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe018,
-	    "is_send_status=%d, cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d se_cmd[%p]\n",
+	    "is_send_status=%d, cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d ulp_cmd[%p]\n",
 	    (xmit_type & QLA_TGT_XMIT_STATUS) ?
 	    1 : 0, cmd->bufflen, cmd->sg_cnt, cmd->dma_data_direction,
-	    &cmd->se_cmd);
+	    cmd->ulp_cmd);
 
 	res = qlt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status,
 	    &full_req_cnt);
@@ -2934,8 +2840,6 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 
 		/* 2TB boundary case covered automatically with this */
 		blocks_done = cmd->e_ref_tag - (uint32_t)lba + 1;
-		cmd->se_cmd.bad_sector = cmd->e_ref_tag;
-		cmd->se_cmd.pi_err = 0;
 		ql_dbg(ql_dbg_tgt, vha, 0xf074,
 			"need to return scsi good\n");
 
@@ -2944,7 +2848,6 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 			uint32_t i, k = 0, num_ent;
 			struct scatterlist *sg, *sgl;
 
-
 			sgl = cmd->prot_sg;
 
 			/* Patch the corresponding protection tags */
@@ -2965,45 +2868,8 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 				goto out;
 			}
 		}
-
 		return 0;
 	}
-
-	/* check guard */
-	if (cmd->e_guard != cmd->a_guard) {
-		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->lba;
-		ql_log(ql_log_warn, vha, 0xe076,
-		    "Guard ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
-		    cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-		    cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
-		    cmd->a_guard, cmd->e_guard, cmd);
-		goto out;
-	}
-
-	/* check ref tag */
-	if (cmd->e_ref_tag != cmd->a_ref_tag) {
-		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->e_ref_tag;
-		ql_log(ql_log_warn, vha, 0xe077,
-			"Ref Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
-			cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-			cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
-			cmd->a_guard, cmd->e_guard, cmd);
-		goto out;
-	}
-
-	/* check appl tag */
-	if (cmd->e_app_tag != cmd->a_app_tag) {
-		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->lba;
-		ql_log(ql_log_warn, vha, 0xe078,
-			"App Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
-			cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-			cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
-			cmd->a_guard, cmd->e_guard, cmd);
-		goto out;
-	}
 out:
 	return 1;
 }
@@ -3241,13 +3107,12 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 {
 	struct qla_tgt *tgt = cmd->tgt;
 	struct scsi_qla_host *vha = tgt->vha;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
 	unsigned long flags;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
 	    "qla_target(%d): terminating exchange for aborted cmd=%p "
-	    "(se_cmd=%p, tag=%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
-	    se_cmd->tag);
+	    "(ulp_cmd=%p, tag=%d)", vha->vp_idx, cmd, cmd->ulp_cmd,
+	    cmd->atio.u.isp24.exchange_addr);
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
@@ -3257,10 +3122,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 		 *  1) XFER Rdy completion + CMD_T_ABORT
 		 *  2) TCM TMR - drain_state_list
 		 */
-	        ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
-			"multiple abort. %p transport_state %x, t_state %x,"
-			" se_cmd_flags %x \n", cmd, cmd->se_cmd.transport_state,
-			cmd->se_cmd.t_state,cmd->se_cmd.se_cmd_flags);
 		return EIO;
 	}
 	cmd->aborted = 1;
@@ -3275,8 +3136,8 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 {
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe074,
-	    "%s: se_cmd[%p] ox_id %04x\n",
-	    __func__, &cmd->se_cmd,
+	    "%s: ulp_cmd[%p] ox_id %04x\n",
+	    __func__, cmd->ulp_cmd,
 	    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
 
 	BUG_ON(cmd->cmd_in_wq);
@@ -3294,90 +3155,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 }
 EXPORT_SYMBOL(qlt_free_cmd);
 
-/* ha->hardware_lock supposed to be held on entry */
-static int qlt_prepare_srr_ctio(struct scsi_qla_host *vha,
-	struct qla_tgt_cmd *cmd, void *ctio)
-{
-	struct qla_tgt_srr_ctio *sc;
-	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_srr_imm *imm;
-
-	tgt->ctio_srr_id++;
-	cmd->cmd_flags |= BIT_15;
-
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf019,
-	    "qla_target(%d): CTIO with SRR status received\n", vha->vp_idx);
-
-	if (!ctio) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf055,
-		    "qla_target(%d): SRR CTIO, but ctio is NULL\n",
-		    vha->vp_idx);
-		return -EINVAL;
-	}
-
-	sc = kzalloc(sizeof(*sc), GFP_ATOMIC);
-	if (sc != NULL) {
-		sc->cmd = cmd;
-		/* IRQ is already OFF */
-		spin_lock(&tgt->srr_lock);
-		sc->srr_id = tgt->ctio_srr_id;
-		list_add_tail(&sc->srr_list_entry,
-		    &tgt->srr_ctio_list);
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01a,
-		    "CTIO SRR %p added (id %d)\n", sc, sc->srr_id);
-		if (tgt->imm_srr_id == tgt->ctio_srr_id) {
-			int found = 0;
-			list_for_each_entry(imm, &tgt->srr_imm_list,
-			    srr_list_entry) {
-				if (imm->srr_id == sc->srr_id) {
-					found = 1;
-					break;
-				}
-			}
-			if (found) {
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01b,
-				    "Scheduling srr work\n");
-				schedule_work(&tgt->srr_work);
-			} else {
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf056,
-				    "qla_target(%d): imm_srr_id "
-				    "== ctio_srr_id (%d), but there is no "
-				    "corresponding SRR IMM, deleting CTIO "
-				    "SRR %p\n", vha->vp_idx,
-				    tgt->ctio_srr_id, sc);
-				list_del(&sc->srr_list_entry);
-				spin_unlock(&tgt->srr_lock);
-
-				kfree(sc);
-				return -EINVAL;
-			}
-		}
-		spin_unlock(&tgt->srr_lock);
-	} else {
-		struct qla_tgt_srr_imm *ti;
-
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf057,
-		    "qla_target(%d): Unable to allocate SRR CTIO entry\n",
-		    vha->vp_idx);
-		spin_lock(&tgt->srr_lock);
-		list_for_each_entry_safe(imm, ti, &tgt->srr_imm_list,
-		    srr_list_entry) {
-			if (imm->srr_id == tgt->ctio_srr_id) {
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01c,
-				    "IMM SRR %p deleted (id %d)\n",
-				    imm, imm->srr_id);
-				list_del(&imm->srr_list_entry);
-				qlt_reject_free_srr_imm(vha, imm, 1);
-			}
-		}
-		spin_unlock(&tgt->srr_lock);
-
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  */
@@ -3533,7 +3310,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 	uint32_t status, void *ctio)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct se_cmd *se_cmd;
+	void *ulp_cmd;
 	struct qla_tgt_cmd *cmd;
 
 	if (handle & CTIO_INTERMEDIATE_HANDLE_MARK) {
@@ -3550,7 +3327,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 	if (cmd == NULL)
 		return;
 
-	se_cmd = &cmd->se_cmd;
+	ulp_cmd = (void *)cmd->ulp_cmd;
 	cmd->cmd_sent_to_fw = 0;
 
 	qlt_unmap_sg(vha, cmd);
@@ -3566,10 +3343,10 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 			/* They are OK */
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf058,
 			    "qla_target(%d): CTIO with "
-			    "status %#x received, state %x, se_cmd %p, "
+			    "status %#x received, state %x, ulp_cmd %p, "
 			    "(LIP_RESET=e, ABORTED=2, TARGET_RESET=17, "
 			    "TIMEOUT=b, INVALID_RX_ID=8)\n", vha->vp_idx,
-			    status, cmd->state, se_cmd);
+			    status, cmd->state, ulp_cmd);
 			break;
 
 		case CTIO_PORT_LOGGED_OUT:
@@ -3579,10 +3356,11 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 				(status & 0xFFFF) == CTIO_PORT_LOGGED_OUT;
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
-			    "qla_target(%d): CTIO with %s status %x "
-			    "received (state %x, se_cmd %p)\n", vha->vp_idx,
-			    logged_out ? "PORT LOGGED OUT" : "PORT UNAVAILABLE",
-			    status, cmd->state, se_cmd);
+			    "qla_target(%d): CTIO with PORT LOGGED "
+			    "OUT (29) or PORT UNAVAILABLE (28) status %x "
+			    "received (state %x, ulp_cmd %p)\n", vha->vp_idx,
+			    status, cmd->state, ulp_cmd);
+			break;
 
 			if (logged_out && cmd->sess) {
 				/*
@@ -3598,19 +3376,16 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		case CTIO_SRR_RECEIVED:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05a,
 			    "qla_target(%d): CTIO with SRR_RECEIVED"
-			    " status %x received (state %x, se_cmd %p)\n",
-			    vha->vp_idx, status, cmd->state, se_cmd);
-			if (qlt_prepare_srr_ctio(vha, cmd, ctio) != 0)
-				break;
-			else
-				return;
+			    " status %x received (state %x, ulp_cmd %p)\n",
+			    vha->vp_idx, status, cmd->state, ulp_cmd);
+			return;
 
 		case CTIO_DIF_ERROR: {
 			struct ctio_crc_from_fw *crc =
 				(struct ctio_crc_from_fw *)ctio;
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf073,
-			    "qla_target(%d): CTIO with DIF_ERROR status %x received (state %x, se_cmd %p) actual_dif[0x%llx] expect_dif[0x%llx]\n",
-			    vha->vp_idx, status, cmd->state, se_cmd,
+			    "qla_target(%d): CTIO with DIF_ERROR status %x received (state %x, ulp_cmd %p) actual_dif[0x%llx] expect_dif[0x%llx]\n",
+			    vha->vp_idx, status, cmd->state, ulp_cmd,
 			    *((u64 *)&crc->actual_dif[0]),
 			    *((u64 *)&crc->expected_dif[0]));
 
@@ -3638,8 +3413,9 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		}
 		default:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
-			    "qla_target(%d): CTIO with error status 0x%x received (state %x, se_cmd %p\n",
-			    vha->vp_idx, status, cmd->state, se_cmd);
+			    "qla_target(%d): CTIO with error status 0x%x received "
+				"(state %x, ulp_cmd %p\n",
+			    vha->vp_idx, status, cmd->state, ulp_cmd);
 			break;
 		}
 
@@ -3672,7 +3448,8 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 	} else if (cmd->aborted) {
 		cmd->cmd_flags |= BIT_18;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01e,
-		  "Aborted command %p (tag %lld) finished\n", cmd, se_cmd->tag);
+		  "Aborted command %p (tag %d) finished\n",
+		  cmd, cmd->atio.u.isp24.exchange_addr);
 	} else {
 		cmd->cmd_flags |= BIT_19;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05c,
@@ -3752,7 +3529,6 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 
 	spin_lock_init(&cmd->cmd_lock);
 	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
-	cmd->se_cmd.tag = atio->u.isp24.exchange_addr;
 	cmd->unpacked_lun = scsilun_to_int(
 	    (struct scsi_lun *)&atio->u.isp24.fcp_cmnd.lun);
 
@@ -3973,8 +3749,6 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	cmd->cmd_in_wq = 1;
 	cmd->cmd_flags |= BIT_0;
-	cmd->se_cmd.cpuid = ha->msix_count ?
-		ha->tgt.rspq_vector_cpuid : WORK_CPU_UNBOUND;
 
 	spin_lock(&vha->cmd_list_lock);
 	list_add_tail(&cmd->cmd_list, &vha->qla_cmd_list);
@@ -3986,8 +3760,8 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 			queue_work_on(smp_processor_id(), qla_tgt_wq,
 			    &cmd->work);
 		else
-			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
-			    &cmd->work);
+			queue_work_on(ha->tgt.rspq_vector_cpuid,
+			    qla_tgt_wq, &cmd->work);
 	} else {
 		queue_work(qla_tgt_wq, &cmd->work);
 	}
@@ -4451,453 +4225,6 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	return res;
 }
 
-static int qlt_set_data_offset(struct qla_tgt_cmd *cmd, uint32_t offset)
-{
-#if 1
-	/*
-	 * FIXME: Reject non zero SRR relative offset until we can test
-	 * this code properly.
-	 */
-	pr_debug("Rejecting non zero SRR rel_offs: %u\n", offset);
-	return -1;
-#else
-	struct scatterlist *sg, *sgp, *sg_srr, *sg_srr_start = NULL;
-	size_t first_offset = 0, rem_offset = offset, tmp = 0;
-	int i, sg_srr_cnt, bufflen = 0;
-
-	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe023,
-	    "Entering qla_tgt_set_data_offset: cmd: %p, cmd->sg: %p, "
-	    "cmd->sg_cnt: %u, direction: %d\n",
-	    cmd, cmd->sg, cmd->sg_cnt, cmd->dma_data_direction);
-
-	if (!cmd->sg || !cmd->sg_cnt) {
-		ql_dbg(ql_dbg_tgt, cmd->vha, 0xe055,
-		    "Missing cmd->sg or zero cmd->sg_cnt in"
-		    " qla_tgt_set_data_offset\n");
-		return -EINVAL;
-	}
-	/*
-	 * Walk the current cmd->sg list until we locate the new sg_srr_start
-	 */
-	for_each_sg(cmd->sg, sg, cmd->sg_cnt, i) {
-		ql_dbg(ql_dbg_tgt, cmd->vha, 0xe024,
-		    "sg[%d]: %p page: %p, length: %d, offset: %d\n",
-		    i, sg, sg_page(sg), sg->length, sg->offset);
-
-		if ((sg->length + tmp) > offset) {
-			first_offset = rem_offset;
-			sg_srr_start = sg;
-			ql_dbg(ql_dbg_tgt, cmd->vha, 0xe025,
-			    "Found matching sg[%d], using %p as sg_srr_start, "
-			    "and using first_offset: %zu\n", i, sg,
-			    first_offset);
-			break;
-		}
-		tmp += sg->length;
-		rem_offset -= sg->length;
-	}
-
-	if (!sg_srr_start) {
-		ql_dbg(ql_dbg_tgt, cmd->vha, 0xe056,
-		    "Unable to locate sg_srr_start for offset: %u\n", offset);
-		return -EINVAL;
-	}
-	sg_srr_cnt = (cmd->sg_cnt - i);
-
-	sg_srr = kzalloc(sizeof(struct scatterlist) * sg_srr_cnt, GFP_KERNEL);
-	if (!sg_srr) {
-		ql_dbg(ql_dbg_tgt, cmd->vha, 0xe057,
-		    "Unable to allocate sgp\n");
-		return -ENOMEM;
-	}
-	sg_init_table(sg_srr, sg_srr_cnt);
-	sgp = &sg_srr[0];
-	/*
-	 * Walk the remaining list for sg_srr_start, mapping to the newly
-	 * allocated sg_srr taking first_offset into account.
-	 */
-	for_each_sg(sg_srr_start, sg, sg_srr_cnt, i) {
-		if (first_offset) {
-			sg_set_page(sgp, sg_page(sg),
-			    (sg->length - first_offset), first_offset);
-			first_offset = 0;
-		} else {
-			sg_set_page(sgp, sg_page(sg), sg->length, 0);
-		}
-		bufflen += sgp->length;
-
-		sgp = sg_next(sgp);
-		if (!sgp)
-			break;
-	}
-
-	cmd->sg = sg_srr;
-	cmd->sg_cnt = sg_srr_cnt;
-	cmd->bufflen = bufflen;
-	cmd->offset += offset;
-	cmd->free_sg = 1;
-
-	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe026, "New cmd->sg: %p\n", cmd->sg);
-	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe027, "New cmd->sg_cnt: %u\n",
-	    cmd->sg_cnt);
-	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe028, "New cmd->bufflen: %u\n",
-	    cmd->bufflen);
-	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe029, "New cmd->offset: %u\n",
-	    cmd->offset);
-
-	if (cmd->sg_cnt < 0)
-		BUG();
-
-	if (cmd->bufflen < 0)
-		BUG();
-
-	return 0;
-#endif
-}
-
-static inline int qlt_srr_adjust_data(struct qla_tgt_cmd *cmd,
-	uint32_t srr_rel_offs, int *xmit_type)
-{
-	int res = 0, rel_offs;
-
-	rel_offs = srr_rel_offs - cmd->offset;
-	ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf027, "srr_rel_offs=%d, rel_offs=%d",
-	    srr_rel_offs, rel_offs);
-
-	*xmit_type = QLA_TGT_XMIT_ALL;
-
-	if (rel_offs < 0) {
-		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf062,
-		    "qla_target(%d): SRR rel_offs (%d) < 0",
-		    cmd->vha->vp_idx, rel_offs);
-		res = -1;
-	} else if (rel_offs == cmd->bufflen)
-		*xmit_type = QLA_TGT_XMIT_STATUS;
-	else if (rel_offs > 0)
-		res = qlt_set_data_offset(cmd, rel_offs);
-
-	return res;
-}
-
-/* No locks, thread context */
-static void qlt_handle_srr(struct scsi_qla_host *vha,
-	struct qla_tgt_srr_ctio *sctio, struct qla_tgt_srr_imm *imm)
-{
-	struct imm_ntfy_from_isp *ntfy =
-	    (struct imm_ntfy_from_isp *)&imm->imm_ntfy;
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_cmd *cmd = sctio->cmd;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
-	unsigned long flags;
-	int xmit_type = 0, resp = 0;
-	uint32_t offset;
-	uint16_t srr_ui;
-
-	offset = le32_to_cpu(ntfy->u.isp24.srr_rel_offs);
-	srr_ui = ntfy->u.isp24.srr_ui;
-
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf028, "SRR cmd %p, srr_ui %x\n",
-	    cmd, srr_ui);
-
-	switch (srr_ui) {
-	case SRR_IU_STATUS:
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		qlt_send_notify_ack(vha, ntfy,
-		    0, 0, 0, NOTIFY_ACK_SRR_FLAGS_ACCEPT, 0, 0);
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		xmit_type = QLA_TGT_XMIT_STATUS;
-		resp = 1;
-		break;
-	case SRR_IU_DATA_IN:
-		if (!cmd->sg || !cmd->sg_cnt) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf063,
-			    "Unable to process SRR_IU_DATA_IN due to"
-			    " missing cmd->sg, state: %d\n", cmd->state);
-			dump_stack();
-			goto out_reject;
-		}
-		if (se_cmd->scsi_status != 0) {
-			ql_dbg(ql_dbg_tgt, vha, 0xe02a,
-			    "Rejecting SRR_IU_DATA_IN with non GOOD "
-			    "scsi_status\n");
-			goto out_reject;
-		}
-		cmd->bufflen = se_cmd->data_length;
-
-		if (qlt_has_data(cmd)) {
-			if (qlt_srr_adjust_data(cmd, offset, &xmit_type) != 0)
-				goto out_reject;
-			spin_lock_irqsave(&ha->hardware_lock, flags);
-			qlt_send_notify_ack(vha, ntfy,
-			    0, 0, 0, NOTIFY_ACK_SRR_FLAGS_ACCEPT, 0, 0);
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			resp = 1;
-		} else {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf064,
-			       "qla_target(%d): SRR for in data for cmd without them (tag %lld, SCSI status %d), reject",
-			       vha->vp_idx, se_cmd->tag,
-			    cmd->se_cmd.scsi_status);
-			goto out_reject;
-		}
-		break;
-	case SRR_IU_DATA_OUT:
-		if (!cmd->sg || !cmd->sg_cnt) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf065,
-			    "Unable to process SRR_IU_DATA_OUT due to"
-			    " missing cmd->sg\n");
-			dump_stack();
-			goto out_reject;
-		}
-		if (se_cmd->scsi_status != 0) {
-			ql_dbg(ql_dbg_tgt, vha, 0xe02b,
-			    "Rejecting SRR_IU_DATA_OUT"
-			    " with non GOOD scsi_status\n");
-			goto out_reject;
-		}
-		cmd->bufflen = se_cmd->data_length;
-
-		if (qlt_has_data(cmd)) {
-			if (qlt_srr_adjust_data(cmd, offset, &xmit_type) != 0)
-				goto out_reject;
-			spin_lock_irqsave(&ha->hardware_lock, flags);
-			qlt_send_notify_ack(vha, ntfy,
-			    0, 0, 0, NOTIFY_ACK_SRR_FLAGS_ACCEPT, 0, 0);
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			if (xmit_type & QLA_TGT_XMIT_DATA) {
-				cmd->cmd_flags |= BIT_8;
-				qlt_rdy_to_xfer(cmd);
-			}
-		} else {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf066,
-			    "qla_target(%d): SRR for out data for cmd without them (tag %lld, SCSI status %d), reject",
-			       vha->vp_idx, se_cmd->tag, cmd->se_cmd.scsi_status);
-			goto out_reject;
-		}
-		break;
-	default:
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf067,
-		    "qla_target(%d): Unknown srr_ui value %x",
-		    vha->vp_idx, srr_ui);
-		goto out_reject;
-	}
-
-	/* Transmit response in case of status and data-in cases */
-	if (resp) {
-		cmd->cmd_flags |= BIT_7;
-		qlt_xmit_response(cmd, xmit_type, se_cmd->scsi_status);
-	}
-
-	return;
-
-out_reject:
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	qlt_send_notify_ack(vha, ntfy, 0, 0, 0,
-	    NOTIFY_ACK_SRR_FLAGS_REJECT,
-	    NOTIFY_ACK_SRR_REJECT_REASON_UNABLE_TO_PERFORM,
-	    NOTIFY_ACK_SRR_FLAGS_REJECT_EXPL_NO_EXPL);
-	if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
-		cmd->state = QLA_TGT_STATE_DATA_IN;
-		dump_stack();
-	} else {
-		cmd->cmd_flags |= BIT_9;
-		qlt_send_term_exchange(vha, cmd, &cmd->atio, 1, 0);
-	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
-
-static void qlt_reject_free_srr_imm(struct scsi_qla_host *vha,
-	struct qla_tgt_srr_imm *imm, int ha_locked)
-{
-	struct qla_hw_data *ha = vha->hw;
-	unsigned long flags = 0;
-
-#ifndef __CHECKER__
-	if (!ha_locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-#endif
-
-	qlt_send_notify_ack(vha, (void *)&imm->imm_ntfy, 0, 0, 0,
-	    NOTIFY_ACK_SRR_FLAGS_REJECT,
-	    NOTIFY_ACK_SRR_REJECT_REASON_UNABLE_TO_PERFORM,
-	    NOTIFY_ACK_SRR_FLAGS_REJECT_EXPL_NO_EXPL);
-
-#ifndef __CHECKER__
-	if (!ha_locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-#endif
-
-	kfree(imm);
-}
-
-static void qlt_handle_srr_work(struct work_struct *work)
-{
-	struct qla_tgt *tgt = container_of(work, struct qla_tgt, srr_work);
-	struct scsi_qla_host *vha = tgt->vha;
-	struct qla_tgt_srr_ctio *sctio;
-	unsigned long flags;
-
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf029, "Entering SRR work (tgt %p)\n",
-	    tgt);
-
-restart:
-	spin_lock_irqsave(&tgt->srr_lock, flags);
-	list_for_each_entry(sctio, &tgt->srr_ctio_list, srr_list_entry) {
-		struct qla_tgt_srr_imm *imm, *i, *ti;
-		struct qla_tgt_cmd *cmd;
-		struct se_cmd *se_cmd;
-
-		imm = NULL;
-		list_for_each_entry_safe(i, ti, &tgt->srr_imm_list,
-						srr_list_entry) {
-			if (i->srr_id == sctio->srr_id) {
-				list_del(&i->srr_list_entry);
-				if (imm) {
-					ql_dbg(ql_dbg_tgt_mgt, vha, 0xf068,
-					  "qla_target(%d): There must be "
-					  "only one IMM SRR per CTIO SRR "
-					  "(IMM SRR %p, id %d, CTIO %p\n",
-					  vha->vp_idx, i, i->srr_id, sctio);
-					qlt_reject_free_srr_imm(tgt->vha, i, 0);
-				} else
-					imm = i;
-			}
-		}
-
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02a,
-		    "IMM SRR %p, CTIO SRR %p (id %d)\n", imm, sctio,
-		    sctio->srr_id);
-
-		if (imm == NULL) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02b,
-			    "Not found matching IMM for SRR CTIO (id %d)\n",
-			    sctio->srr_id);
-			continue;
-		} else
-			list_del(&sctio->srr_list_entry);
-
-		spin_unlock_irqrestore(&tgt->srr_lock, flags);
-
-		cmd = sctio->cmd;
-		/*
-		 * Reset qla_tgt_cmd SRR values and SGL pointer+count to follow
-		 * tcm_qla2xxx_write_pending() and tcm_qla2xxx_queue_data_in()
-		 * logic..
-		 */
-		cmd->offset = 0;
-		if (cmd->free_sg) {
-			kfree(cmd->sg);
-			cmd->sg = NULL;
-			cmd->free_sg = 0;
-		}
-		se_cmd = &cmd->se_cmd;
-
-		cmd->sg_cnt = se_cmd->t_data_nents;
-		cmd->sg = se_cmd->t_data_sg;
-
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02c,
-		    "SRR cmd %p (se_cmd %p, tag %d, op %x), "
-		    "sg_cnt=%d, offset=%d",
-		    cmd, &cmd->se_cmd, cmd->atio.u.isp24.exchange_addr,
-		    cmd->cdb ? cmd->cdb[0] : 0,
-		    cmd->sg_cnt, cmd->offset);
-
-		qlt_handle_srr(vha, sctio, imm);
-
-		kfree(imm);
-		kfree(sctio);
-		goto restart;
-	}
-	spin_unlock_irqrestore(&tgt->srr_lock, flags);
-}
-
-/* ha->hardware_lock supposed to be held on entry */
-static void qlt_prepare_srr_imm(struct scsi_qla_host *vha,
-	struct imm_ntfy_from_isp *iocb)
-{
-	struct qla_tgt_srr_imm *imm;
-	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_srr_ctio *sctio;
-
-	tgt->imm_srr_id++;
-
-	ql_log(ql_log_warn, vha, 0xf02d, "qla_target(%d): SRR received\n",
-	    vha->vp_idx);
-
-	imm = kzalloc(sizeof(*imm), GFP_ATOMIC);
-	if (imm != NULL) {
-		memcpy(&imm->imm_ntfy, iocb, sizeof(imm->imm_ntfy));
-
-		/* IRQ is already OFF */
-		spin_lock(&tgt->srr_lock);
-		imm->srr_id = tgt->imm_srr_id;
-		list_add_tail(&imm->srr_list_entry,
-		    &tgt->srr_imm_list);
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02e,
-		    "IMM NTFY SRR %p added (id %d, ui %x)\n",
-		    imm, imm->srr_id, iocb->u.isp24.srr_ui);
-		if (tgt->imm_srr_id == tgt->ctio_srr_id) {
-			int found = 0;
-			list_for_each_entry(sctio, &tgt->srr_ctio_list,
-			    srr_list_entry) {
-				if (sctio->srr_id == imm->srr_id) {
-					found = 1;
-					break;
-				}
-			}
-			if (found) {
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02f, "%s",
-				    "Scheduling srr work\n");
-				schedule_work(&tgt->srr_work);
-			} else {
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf030,
-				    "qla_target(%d): imm_srr_id "
-				    "== ctio_srr_id (%d), but there is no "
-				    "corresponding SRR CTIO, deleting IMM "
-				    "SRR %p\n", vha->vp_idx, tgt->ctio_srr_id,
-				    imm);
-				list_del(&imm->srr_list_entry);
-
-				kfree(imm);
-
-				spin_unlock(&tgt->srr_lock);
-				goto out_reject;
-			}
-		}
-		spin_unlock(&tgt->srr_lock);
-	} else {
-		struct qla_tgt_srr_ctio *ts;
-
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf069,
-		    "qla_target(%d): Unable to allocate SRR IMM "
-		    "entry, SRR request will be rejected\n", vha->vp_idx);
-
-		/* IRQ is already OFF */
-		spin_lock(&tgt->srr_lock);
-		list_for_each_entry_safe(sctio, ts, &tgt->srr_ctio_list,
-		    srr_list_entry) {
-			if (sctio->srr_id == tgt->imm_srr_id) {
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf031,
-				    "CTIO SRR %p deleted (id %d)\n",
-				    sctio, sctio->srr_id);
-				list_del(&sctio->srr_list_entry);
-				qlt_send_term_exchange(vha, sctio->cmd,
-				    &sctio->cmd->atio, 1, 0);
-				kfree(sctio);
-			}
-		}
-		spin_unlock(&tgt->srr_lock);
-		goto out_reject;
-	}
-
-	return;
-
-out_reject:
-	qlt_send_notify_ack(vha, iocb, 0, 0, 0,
-	    NOTIFY_ACK_SRR_FLAGS_REJECT,
-	    NOTIFY_ACK_SRR_REJECT_REASON_UNABLE_TO_PERFORM,
-	    NOTIFY_ACK_SRR_FLAGS_REJECT_EXPL_NO_EXPL);
-}
-
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  */
@@ -5021,8 +4348,6 @@ static void qlt_handle_imm_notify(struct scsi_qla_host *vha,
 		break;
 
 	case IMM_NTFY_SRR:
-		qlt_prepare_srr_imm(vha, iocb);
-		send_notify_ack = 0;
 		break;
 
 	default:
@@ -5965,10 +5290,6 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	spin_lock_init(&tgt->sess_work_lock);
 	INIT_WORK(&tgt->sess_work, qlt_sess_work_fn);
 	INIT_LIST_HEAD(&tgt->sess_works_list);
-	spin_lock_init(&tgt->srr_lock);
-	INIT_LIST_HEAD(&tgt->srr_ctio_list);
-	INIT_LIST_HEAD(&tgt->srr_imm_list);
-	INIT_WORK(&tgt->srr_work, qlt_handle_srr_work);
 	atomic_set(&tgt->tgt_global_resets_count, 0);
 
 	base_vha->vha_tgt.qla_tgt = tgt;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index df04663..0198f72 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -709,10 +709,8 @@ struct abts_resp_from_24xx_fw {
 /********************************************************************\
  * Type Definitions used by initiator & target halves
 \********************************************************************/
-
 struct qla_tgt_mgmt_cmd;
 struct qla_tgt_sess;
-
 /*
  * This structure provides a template of function calls that the
  * target driver (from within qla_target.c) can issue to the
@@ -979,7 +977,7 @@ struct qla_tgt_sess {
 } cmd_flags_t;
 
 struct qla_tgt_cmd {
-	struct se_cmd se_cmd;
+	void *ulp_cmd;
 	struct qla_tgt_sess *sess;
 	int state;
 	struct work_struct free_work;
@@ -1051,7 +1049,7 @@ struct qla_tgt_mgmt_cmd {
 	uint16_t tmr_func;
 	uint8_t fc_tm_rsp;
 	struct qla_tgt_sess *sess;
-	struct se_cmd se_cmd;
+	void *ulp_cmd;
 	struct work_struct free_work;
 	unsigned int flags;
 	uint32_t reset_count;
@@ -1082,18 +1080,6 @@ struct qla_tgt_prm {
 	uint16_t tot_dsds;
 };
 
-struct qla_tgt_srr_imm {
-	struct list_head srr_list_entry;
-	int srr_id;
-	struct imm_ntfy_from_isp imm_ntfy;
-};
-
-struct qla_tgt_srr_ctio {
-	struct list_head srr_list_entry;
-	int srr_id;
-	struct qla_tgt_cmd *cmd;
-};
-
 /* Check for Switch reserved address */
 #define IS_SW_RESV_ADDR(_s_id) \
 	((_s_id.b.domain == 0xff) && (_s_id.b.area == 0xfc))
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 016a27c..f9753b4 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -51,6 +51,38 @@
 static struct workqueue_struct *tcm_qla2xxx_free_wq;
 static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
 
+inline struct se_cmd *Q_TO_SE_CMD(struct qla_tgt_cmd *qcmd)
+{
+	struct tcm_qla_tgt_cmd *tc =
+		container_of(qcmd, struct tcm_qla_tgt_cmd, qcmd);
+
+	return &tc->se_cmd;
+}
+
+inline struct qla_tgt_cmd *SE_TO_Q_CMD(struct se_cmd *se_cmd)
+{
+	struct tcm_qla_tgt_cmd *tc =
+		container_of(se_cmd, struct tcm_qla_tgt_cmd, se_cmd);
+
+	return &tc->qcmd;
+}
+
+inline struct se_cmd *QMGT_TO_SE_CMD(struct qla_tgt_mgmt_cmd *qcmd)
+{
+	struct tcm_qla_tgt_mgmt_cmd *tc =
+		container_of(qcmd, struct tcm_qla_tgt_mgmt_cmd, mgt_cmd);
+
+	return &tc->se_cmd;
+}
+
+inline struct qla_tgt_mgmt_cmd *SE_TO_QMGT_CMD(struct se_cmd *se_cmd)
+{
+	struct tcm_qla_tgt_mgmt_cmd *tc =
+		container_of(se_cmd, struct tcm_qla_tgt_mgmt_cmd, se_cmd);
+
+	return &tc->mgt_cmd;
+}
+
 /*
  * Parse WWN.
  * If strict, we require lower-case hex and colon separators to be sure
@@ -262,7 +294,7 @@ static void tcm_qla2xxx_complete_mcmd(struct work_struct *work)
 	struct qla_tgt_mgmt_cmd *mcmd = container_of(work,
 			struct qla_tgt_mgmt_cmd, free_work);
 
-	transport_generic_free_cmd(&mcmd->se_cmd, 0);
+	transport_generic_free_cmd(QMGT_TO_SE_CMD(mcmd), 0);
 }
 
 static void tcm_qla2xxx_check_resid(struct se_cmd *se_cmd,
@@ -295,7 +327,7 @@ static void tcm_qla2xxx_complete_free(struct work_struct *work)
 
 	cmd->vha->tgt_counters.qla_core_ret_sta_ctio++;
 	cmd->cmd_flags |= BIT_16;
-	transport_generic_free_cmd(&cmd->se_cmd, 0);
+	transport_generic_free_cmd(Q_TO_SE_CMD(cmd), 0);
 }
 
 /*
@@ -323,7 +355,7 @@ static int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
 	struct qla_tgt_cmd *cmd;
 
 	if ((se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) == 0) {
-		cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+		cmd = SE_TO_Q_CMD(se_cmd);
 		cmd->cmd_flags |= BIT_14;
 	}
 
@@ -347,13 +379,12 @@ static void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
 	struct se_session *se_sess;
 
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
-		struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
-				struct qla_tgt_mgmt_cmd, se_cmd);
+		struct qla_tgt_mgmt_cmd *mcmd = SE_TO_QMGT_CMD(se_cmd);
 		qlt_free_mcmd(mcmd);
 		return;
 	}
 
-	cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+	cmd = SE_TO_Q_CMD(se_cmd);
 	qlt_free_cmd(cmd);
 
 	if (!cmd->sess || !cmd->sess->se_sess) {
@@ -369,7 +400,7 @@ static void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
 
 static void tcm_qla2xxx_rel_cmd(struct qla_tgt_cmd *cmd)
 {
-	tcm_qla2xxx_release_cmd(&cmd->se_cmd);
+	tcm_qla2xxx_release_cmd(Q_TO_SE_CMD(cmd));
 }
 
 static struct qla_tgt_cmd *tcm_qla2xxx_alloc_cmd(struct qla_tgt_sess *sess)
@@ -377,15 +408,23 @@ static struct qla_tgt_cmd *tcm_qla2xxx_alloc_cmd(struct qla_tgt_sess *sess)
 	struct se_session *se_sess = (struct se_session *)sess->se_sess;
 	int tag;
 	struct qla_tgt_cmd *cmd = NULL;
+	struct tcm_qla_tgt_cmd *tc = NULL;
+	struct qla_hw_data *ha = sess->vha->hw;
 
 	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0)
 		return NULL;
 
-	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
-	if (cmd) {
-		memset(cmd, 0, sizeof(struct qla_tgt_cmd));
-		cmd->se_cmd.map_tag = tag;
+	tc = &((struct tcm_qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
+	if (tc) {
+		memset(tc, 0, sizeof(struct tcm_qla_tgt_cmd));
+		tc->se_cmd.map_tag = tag;
+		tc->se_cmd.cpuid = -1;
+
+		if (ha->msix_count)
+			tc->se_cmd.cpuid = ha->tgt.rspq_vector_cpuid;
+
+		tc->qcmd.ulp_cmd = (void *)&tc->se_cmd;
 	}
 	return cmd;
 }
@@ -412,8 +451,7 @@ static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
 
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
 
 	if (cmd->aborted) {
 		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
@@ -422,10 +460,10 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 		 */
 		pr_debug("write_pending aborted cmd[%p] refcount %d "
 			"transport_state %x, t_state %x, se_cmd_flags %x\n",
-			cmd,cmd->se_cmd.cmd_kref.refcount.counter,
-			cmd->se_cmd.transport_state,
-			cmd->se_cmd.t_state,
-			cmd->se_cmd.se_cmd_flags);
+			cmd, se_cmd->cmd_kref.refcount.counter,
+			se_cmd->transport_state,
+			se_cmd->t_state,
+			se_cmd->se_cmd_flags);
 		return 0;
 	}
 	cmd->cmd_flags |= BIT_3;
@@ -477,8 +515,7 @@ static void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *nacl)
 static int tcm_qla2xxx_get_cmd_state(struct se_cmd *se_cmd)
 {
 	if (!(se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
-		struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+		struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
 		return cmd->state;
 	}
 
@@ -492,7 +529,7 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	unsigned char *cdb, uint32_t data_length, int fcp_task_attr,
 	int data_dir, int bidi)
 {
-	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct se_cmd *se_cmd =  Q_TO_SE_CMD(cmd);
 	struct se_session *se_sess;
 	struct qla_tgt_sess *sess;
 #ifdef CONFIG_TCM_QLA2XXX_DEBUG
@@ -513,6 +550,7 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 		return -EINVAL;
 	}
 
+	se_cmd->tag = cmd->atio.u.isp24.exchange_addr;
 	se_sess = sess->se_sess;
 	if (!se_sess) {
 		pr_err("Unable to locate active struct se_session\n");
@@ -534,10 +572,58 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 				data_dir, flags);
 }
 
+static void tcm_qla2xxx_check_dif_err(struct qla_tgt_cmd *cmd)
+{
+	struct se_cmd *se_cmd = Q_TO_SE_CMD(cmd);
+
+	if ((cmd->a_app_tag == 0xffff) &&
+	    ((cmd->prot_type != TARGET_DIF_TYPE3_PROT) ||
+	     (cmd->a_ref_tag == 0xffffffff))) {
+		se_cmd->bad_sector = cmd->e_ref_tag;
+		se_cmd->pi_err = 0;
+		return;
+	}
+
+	/* check guard */
+	if (cmd->e_guard != cmd->a_guard) {
+		se_cmd->pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+		se_cmd->bad_sector = cmd->lba;
+		pr_err("Guard ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
+		    cmd->atio.u.isp24.fcp_cmnd.cdb[0], cmd->lba, cmd->a_ref_tag,
+		    cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag, cmd->a_guard, cmd->e_guard, cmd);
+		goto out;
+	}
+
+	/* check ref tag */
+	if (cmd->e_ref_tag != cmd->a_ref_tag) {
+		se_cmd->pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
+		se_cmd->bad_sector = cmd->e_ref_tag;
+		pr_err("Ref Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
+		    cmd->atio.u.isp24.fcp_cmnd.cdb[0], cmd->lba, cmd->a_ref_tag,
+		    cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
+		    cmd->a_guard, cmd->e_guard, cmd);
+		goto out;
+	}
+
+	/* check appl tag */
+	if (cmd->e_app_tag != cmd->a_app_tag) {
+		se_cmd->pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
+		se_cmd->bad_sector = cmd->lba;
+		pr_err("App Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
+		    cmd->atio.u.isp24.fcp_cmnd.cdb[0], cmd->lba, cmd->a_ref_tag,
+		    cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
+		    cmd->a_guard, cmd->e_guard, cmd);
+		goto out;
+	}
+out:
+	return;
+}
+
 static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
 	unsigned long flags;
+	struct se_cmd *se_cmd = Q_TO_SE_CMD(cmd);
 
 	/*
 	 * Ensure that the complete FCP WRITE payload has been received.
@@ -557,27 +643,31 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
 	cmd->vha->tgt_counters.qla_core_ret_ctio++;
+
+	if (cmd->prot_op)
+		tcm_qla2xxx_check_dif_err(cmd);
+
 	if (!cmd->write_data_transferred) {
 		/*
 		 * Check if se_cmd has already been aborted via LUN_RESET, and
 		 * waiting upon completion in tcm_qla2xxx_write_pending_status()
 		 */
-		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
-			complete(&cmd->se_cmd.t_transport_stop_comp);
+		if (se_cmd->transport_state & CMD_T_ABORTED) {
+			complete(&se_cmd->t_transport_stop_comp);
 			return;
 		}
 
-		if (cmd->se_cmd.pi_err)
-			transport_generic_request_failure(&cmd->se_cmd,
-				cmd->se_cmd.pi_err);
+		if (se_cmd->pi_err)
+			transport_generic_request_failure(se_cmd,
+				se_cmd->pi_err);
 		else
-			transport_generic_request_failure(&cmd->se_cmd,
+			transport_generic_request_failure(se_cmd,
 				TCM_CHECK_CONDITION_ABORT_CMD);
 
 		return;
 	}
 
-	return target_execute_cmd(&cmd->se_cmd);
+	return target_execute_cmd(se_cmd);
 }
 
 /*
@@ -594,13 +684,16 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 static void tcm_qla2xxx_handle_dif_work(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
+	struct se_cmd *se_cmd = Q_TO_SE_CMD(cmd);
+
+	tcm_qla2xxx_check_dif_err(cmd);
 
 	/* take an extra kref to prevent cmd free too early.
 	 * need to wait for SCSI status/check condition to
 	 * finish responding generate by transport_generic_request_failure.
 	 */
-	kref_get(&cmd->se_cmd.cmd_kref);
-	transport_generic_request_failure(&cmd->se_cmd, cmd->se_cmd.pi_err);
+	kref_get(&se_cmd->cmd_kref);
+	transport_generic_request_failure(se_cmd, se_cmd->pi_err);
 }
 
 /*
@@ -619,7 +712,7 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 	uint16_t tmr_func, uint32_t tag)
 {
 	struct qla_tgt_sess *sess = mcmd->sess;
-	struct se_cmd *se_cmd = &mcmd->se_cmd;
+	struct se_cmd *se_cmd = QMGT_TO_SE_CMD(mcmd);
 	struct se_session *se_sess = sess->se_sess;
 	bool found_lun = false;
 	int transl_tmr_func;
@@ -628,8 +721,7 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 	case QLA_TGT_ABTS:
 		spin_lock(&se_sess->sess_cmd_lock);
 		list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-			struct qla_tgt_cmd *cmd =
-				container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+			struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
 			struct abts_recv_from_24xx *abts = &mcmd->orig_iocb.abts;
 
 			if (se_cmd->tag == abts->exchange_addr_to_abort) {
@@ -682,8 +774,7 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 
 static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
 
 	if (cmd->aborted) {
 		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
@@ -692,10 +783,10 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 		 */
 		pr_debug("queue_data_in aborted cmd[%p] refcount %d "
 			"transport_state %x, t_state %x, se_cmd_flags %x\n",
-			cmd,cmd->se_cmd.cmd_kref.refcount.counter,
-			cmd->se_cmd.transport_state,
-			cmd->se_cmd.t_state,
-			cmd->se_cmd.se_cmd_flags);
+			cmd, se_cmd->cmd_kref.refcount.counter,
+			se_cmd->transport_state,
+			se_cmd->t_state,
+			se_cmd->se_cmd_flags);
 		return 0;
 	}
 
@@ -725,8 +816,8 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 
 static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
+
 	int xmit_type = QLA_TGT_XMIT_STATUS;
 
 	cmd->bufflen = se_cmd->data_length;
@@ -766,8 +857,8 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
-	struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
-				struct qla_tgt_mgmt_cmd, se_cmd);
+	struct qla_tgt_mgmt_cmd *mcmd = SE_TO_QMGT_CMD(se_cmd);
+
 
 	pr_debug("queue_tm_rsp: mcmd: %p func: 0x%02x response: 0x%02x\n",
 			mcmd, se_tmr->function, se_tmr->response);
@@ -803,8 +894,7 @@ static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 	 CMD_FLAG_DATA_WORK)
 static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
 	unsigned long flags;
 
 	if (qlt_abort_cmd(cmd))
@@ -1585,9 +1675,9 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 * via ConfigFS, or via running in TPG demo mode.
 	 */
 	se_sess = target_alloc_session(&tpg->se_tpg, num_tags,
-				       sizeof(struct qla_tgt_cmd),
-				       TARGET_PROT_ALL, port_name,
-				       qlat_sess, tcm_qla2xxx_session_cb);
+	    sizeof(struct tcm_qla_tgt_cmd), TARGET_PROT_ALL, port_name,
+	    qlat_sess, tcm_qla2xxx_session_cb);
+
 	if (IS_ERR(se_sess))
 		return PTR_ERR(se_sess);
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 37e026a..080647d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -81,3 +81,13 @@ struct tcm_qla2xxx_lport {
 	/* Returned by tcm_qla2xxx_make_lport() */
 	struct se_wwn lport_wwn;
 };
+
+struct tcm_qla_tgt_cmd {
+	struct se_cmd se_cmd;
+	struct qla_tgt_cmd qcmd;
+};
+
+struct tcm_qla_tgt_mgmt_cmd {
+	struct se_cmd se_cmd;
+	struct qla_tgt_mgmt_cmd mgt_cmd;
+};
-- 
1.8.3.1

