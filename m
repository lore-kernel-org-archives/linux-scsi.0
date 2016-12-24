From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 04/11] qla2xxx: Cleanup SRR code.
Date: Fri, 23 Dec 2016 20:23:32 -0800
Message-ID: <1482553419-4117-5-git-send-email-himanshu.madhani@cavium.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 641 --------------------------------------
 drivers/scsi/qla2xxx/qla_target.h |  21 --
 2 files changed, 662 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c9e6a8b..8a10f93 100644
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
@@ -2183,95 +2181,6 @@ static inline int qlt_need_explicit_conf(struct qla_hw_data *ha,
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
@@ -2686,7 +2595,6 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	memset(&prm, 0, sizeof(prm));
-	qlt_check_srr_debug(cmd, &xmit_type);
 
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe018,
 	    "is_send_status=%d, cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d se_cmd[%p]\n",
@@ -3332,90 +3240,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
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
-	cmd->trc_flags |= TRC_SRR_CTIO;
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
@@ -3633,16 +3457,6 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 			}
 			break;
 		}
-		case CTIO_SRR_RECEIVED:
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05a,
-			    "qla_target(%d): CTIO with SRR_RECEIVED"
-			    " status %x received (state %x, se_cmd %p)\n",
-			    vha->vp_idx, status, cmd->state, se_cmd);
-			if (qlt_prepare_srr_ctio(vha, cmd, ctio) != 0)
-				break;
-			else
-				return;
-
 		case CTIO_DIF_ERROR: {
 			struct ctio_crc_from_fw *crc =
 				(struct ctio_crc_from_fw *)ctio;
@@ -4495,451 +4309,6 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
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
-				cmd->trc_flags |= TRC_SRR_XRDY;
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
-		cmd->trc_flags |= TRC_SRR_RSP;
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
-		cmd->trc_flags |= TRC_SRR_TERM;
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
-		       "SRR cmd %p (se_cmd %p, tag %lld, op %x), sg_cnt=%d, offset=%d",
-		       cmd, &cmd->se_cmd, se_cmd->tag, se_cmd->t_task_cdb ?
-		       se_cmd->t_task_cdb[0] : 0, cmd->sg_cnt, cmd->offset);
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
@@ -5061,12 +4430,6 @@ static void qlt_handle_imm_notify(struct scsi_qla_host *vha,
 		if (qlt_24xx_handle_els(vha, iocb) == 0)
 			send_notify_ack = 0;
 		break;
-
-	case IMM_NTFY_SRR:
-		qlt_prepare_srr_imm(vha, iocb);
-		send_notify_ack = 0;
-		break;
-
 	default:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06d,
 		    "qla_target(%d): Received unknown immediate "
@@ -6017,10 +5380,6 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
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
index f5fec62..2f311b7 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -890,16 +890,7 @@ struct qla_tgt {
 	int notify_ack_expected;
 	int abts_resp_expected;
 	int modify_lun_expected;
-
-	int ctio_srr_id;
-	int imm_srr_id;
-	spinlock_t srr_lock;
-	struct list_head srr_ctio_list;
-	struct list_head srr_imm_list;
-	struct work_struct srr_work;
-
 	atomic_t tgt_global_resets_count;
-
 	struct list_head tgt_list_entry;
 };
 
@@ -1086,18 +1077,6 @@ struct qla_tgt_prm {
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
-- 
1.8.3.1
