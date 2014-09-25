From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 05/17] qla2xxx: Remove verbose messages in target mode.
Date: Thu, 25 Sep 2014 06:14:47 -0400
Message-ID: <1411640099-7856-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:50255 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbaIYKtA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 06:49:00 -0400
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

From: Arun Easi <arun.easi@qlogic.com>

Turning logging bits for target mode ON dumps quite a lot verbose
messages, remove those and change some of the IO path logging to
use IO bits.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |  154 ++++---------------------------------
 1 files changed, 16 insertions(+), 138 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2fe6da3..1503cf4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1397,8 +1397,6 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 		}
 	}
 
-	ql_dbg(ql_dbg_tgt, prm->cmd->vha, 0xe009, "seg_cnt=%d, req_cnt=%d\n",
-	    prm->seg_cnt, prm->req_cnt);
 	return 0;
 
 out_err:
@@ -1436,10 +1434,6 @@ static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 	if (vha->req->cnt < (req_cnt + 2)) {
 		cnt = (uint16_t)RD_REG_DWORD(vha->req->req_q_out);
 
-		ql_dbg(ql_dbg_tgt, vha, 0xe00a,
-		    "Request ring circled: cnt=%d, vha->->ring_index=%d, "
-		    "vha->req->cnt=%d, req_cnt=%d\n", cnt,
-		    vha->req->ring_index, vha->req->cnt, req_cnt);
 		if  (vha->req->ring_index < cnt)
 			vha->req->cnt = cnt - vha->req->ring_index;
 		else
@@ -1448,7 +1442,7 @@ static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 	}
 
 	if (unlikely(vha->req->cnt < (req_cnt + 2))) {
-		ql_dbg(ql_dbg_tgt, vha, 0xe00b,
+		ql_dbg(ql_dbg_io, vha, 0x305a,
 		    "qla_target(%d): There is no room in the "
 		    "request ring: vha->req->ring_index=%d, vha->req->cnt=%d, "
 		    "req_cnt=%d\n", vha->vp_idx, vha->req->ring_index,
@@ -1489,7 +1483,7 @@ static inline uint32_t qlt_make_handle(struct scsi_qla_host *vha)
 		if (h > DEFAULT_OUTSTANDING_COMMANDS)
 			h = 1; /* 0 is QLA_TGT_NULL_HANDLE */
 		if (h == ha->tgt.current_handle) {
-			ql_dbg(ql_dbg_tgt, vha, 0xe04e,
+			ql_dbg(ql_dbg_io, vha, 0x305b,
 			    "qla_target(%d): Ran out of "
 			    "empty cmd slots in ha %p\n", vha->vp_idx, ha);
 			h = QLA_TGT_NULL_HANDLE;
@@ -1546,9 +1540,6 @@ static int qlt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm,
 	pkt->u.status0.ox_id = cpu_to_le16(temp);
 	pkt->u.status0.relative_offset = cpu_to_le32(prm->cmd->offset);
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe00c,
-	    "qla_target(%d): handle(cmd) -> %08x, timeout %d, ox_id %#x\n",
-	    vha->vp_idx, pkt->handle, QLA_TGT_TIMEOUT, temp);
 	return 0;
 }
 
@@ -1606,14 +1597,6 @@ static void qlt_load_cont_data_segments(struct qla_tgt_prm *prm,
 			}
 			*dword_ptr++ = cpu_to_le32(sg_dma_len(prm->sg));
 
-			ql_dbg(ql_dbg_tgt, vha, 0xe00d,
-			    "S/G Segment Cont. phys_addr=%llx:%llx, len=%d\n",
-			    (long long unsigned int)
-			    pci_dma_hi32(sg_dma_address(prm->sg)),
-			    (long long unsigned int)
-			    pci_dma_lo32(sg_dma_address(prm->sg)),
-			    (int)sg_dma_len(prm->sg));
-
 			prm->sg = sg_next(prm->sg);
 		}
 	}
@@ -1631,11 +1614,6 @@ static void qlt_load_data_segments(struct qla_tgt_prm *prm,
 	int enable_64bit_addressing = prm->tgt->tgt_enable_64bit_addr;
 	struct ctio7_to_24xx *pkt24 = (struct ctio7_to_24xx *)prm->pkt;
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe00e,
-	    "iocb->scsi_status=%x, iocb->flags=%x\n",
-	    le16_to_cpu(pkt24->u.status0.scsi_status),
-	    le16_to_cpu(pkt24->u.status0.flags));
-
 	pkt24->u.status0.transfer_length = cpu_to_le32(prm->cmd->bufflen);
 
 	/* Setup packet address segment pointer */
@@ -1653,7 +1631,6 @@ static void qlt_load_data_segments(struct qla_tgt_prm *prm,
 	}
 
 	/* If scatter gather */
-	ql_dbg(ql_dbg_tgt, vha, 0xe00f, "%s", "Building S/G data segments...");
 
 	/* Load command entry data segments */
 	for (cnt = 0;
@@ -1668,14 +1645,6 @@ static void qlt_load_data_segments(struct qla_tgt_prm *prm,
 		}
 		*dword_ptr++ = cpu_to_le32(sg_dma_len(prm->sg));
 
-		ql_dbg(ql_dbg_tgt, vha, 0xe010,
-		    "S/G Segment phys_addr=%llx:%llx, len=%d\n",
-		    (long long unsigned int)pci_dma_hi32(sg_dma_address(
-		    prm->sg)),
-		    (long long unsigned int)pci_dma_lo32(sg_dma_address(
-		    prm->sg)),
-		    (int)sg_dma_len(prm->sg));
-
 		prm->sg = sg_next(prm->sg);
 	}
 
@@ -1713,10 +1682,6 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 		return QLA_TGT_PRE_XMIT_RESP_CMD_ABORTED;
 	}
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe011, "qla_target(%d): tag=%u ox_id %04x\n",
-		vha->vp_idx, cmd->tag,
-		be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
-
 	prm->cmd = cmd;
 	prm->tgt = tgt;
 	prm->rq_result = scsi_status;
@@ -1727,15 +1692,10 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 	prm->req_cnt = 1;
 	prm->add_status_pkt = 0;
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe012, "rq_result=%x, xmit_type=%x\n",
-	    prm->rq_result, xmit_type);
-
 	/* Send marker if required */
 	if (qlt_issue_marker(vha, 0) != QLA_SUCCESS)
 		return -EFAULT;
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe013, "CTIO start: vha(%d)\n", vha->vp_idx);
-
 	if ((xmit_type & QLA_TGT_XMIT_DATA) && qlt_has_data(cmd)) {
 		if  (qlt_pci_map_calc_cnt(prm) != 0)
 			return -EAGAIN;
@@ -1745,7 +1705,7 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 
 	if (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
 		prm->residual = se_cmd->residual_count;
-		ql_dbg(ql_dbg_tgt, vha, 0xe014,
+		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x305c,
 		    "Residual underflow: %d (tag %d, "
 		    "op %x, bufflen %d, rq_result %x)\n", prm->residual,
 		    cmd->tag, se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
@@ -1753,7 +1713,7 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 		prm->rq_result |= SS_RESIDUAL_UNDER;
 	} else if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
 		prm->residual = se_cmd->residual_count;
-		ql_dbg(ql_dbg_tgt, vha, 0xe015,
+		ql_dbg(ql_dbg_io, vha, 0x305d,
 		    "Residual overflow: %d (tag %d, "
 		    "op %x, bufflen %d, rq_result %x)\n", prm->residual,
 		    cmd->tag, se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
@@ -1776,10 +1736,6 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 		}
 	}
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe016,
-	    "req_cnt=%d, full_req_cnt=%d, add_status_pkt=%d\n",
-	    prm->req_cnt, *full_req_cnt, prm->add_status_pkt);
-
 	return 0;
 }
 
@@ -2356,8 +2312,9 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			struct ctio7_to_24xx *ctio =
 				(struct ctio7_to_24xx *)qlt_get_req_pkt(vha);
 
-			ql_dbg(ql_dbg_tgt, vha, 0xe019,
-			    "Building additional status packet\n");
+			ql_dbg(ql_dbg_io, vha, 0x305e,
+			    "Building additional status packet 0x%p.\n",
+			    ctio);
 
 			/*
 			 * T10Dif: ctio_crc2_to_fw overlay ontop of
@@ -2390,10 +2347,6 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 
 	cmd->state = QLA_TGT_STATE_PROCESSED; /* Mid-level is done processing */
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe01a,
-	    "Xmitting CTIO7 response pkt for 24xx: %p scsi_status: 0x%02x\n",
-	    pkt, scsi_status);
-
 	qla2x00_start_iocbs(vha, vha->req);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -2428,11 +2381,6 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	if (qlt_issue_marker(vha, 0) != QLA_SUCCESS)
 		return -EIO;
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe01b,
-		"%s: CTIO_start: vha(%d) se_cmd %p ox_id %04x\n",
-		__func__, (int)vha->vp_idx, &cmd->se_cmd,
-		be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
-
 	/* Calculate number of entries and segments required */
 	if (qlt_pci_map_calc_cnt(&prm) != 0)
 		return -EAGAIN;
@@ -2861,11 +2809,9 @@ static struct qla_tgt_cmd *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 	    CTIO_INTERMEDIATE_HANDLE_MARK);
 
 	if (handle != QLA_TGT_NULL_HANDLE) {
-		if (unlikely(handle == QLA_TGT_SKIP_HANDLE)) {
-			ql_dbg(ql_dbg_tgt, vha, 0xe01d, "%s",
-			    "SKIP_HANDLE CTIO\n");
+		if (unlikely(handle == QLA_TGT_SKIP_HANDLE))
 			return NULL;
-		}
+
 		/* handle-1 is actually used */
 		if (unlikely(handle > DEFAULT_OUTSTANDING_COMMANDS)) {
 			ql_dbg(ql_dbg_tgt, vha, 0xe052,
@@ -2903,10 +2849,6 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 	struct target_core_fabric_ops *tfo;
 	struct qla_tgt_cmd *cmd;
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe01e,
-	    "qla_target(%d): handle(ctio %p status %#x) <- %08x\n",
-	    vha->vp_idx, ctio, status, handle);
-
 	if (handle & CTIO_INTERMEDIATE_HANDLE_MARK) {
 		/* That could happen only in case of an error/reset/abort */
 		if (status != CTIO_SUCCESS) {
@@ -3017,7 +2959,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 skip_term:
 
 	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
-		ql_dbg(ql_dbg_tgt, vha, 0xe01f, "Command %p finished\n", cmd);
+		;
 	} else if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
 		int rx_status = 0;
 
@@ -3028,10 +2970,6 @@ skip_term:
 		else
 			cmd->write_data_transferred = 1;
 
-		ql_dbg(ql_dbg_tgt, vha, 0xe020,
-		    "Data received, context %x, rx_status %d\n",
-		    0x0, rx_status);
-
 		ha->tgt.tgt_ops->handle_data(cmd);
 		return;
 	} else if (cmd->state == QLA_TGT_STATE_ABORTED) {
@@ -3126,11 +3064,6 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	    &atio->u.isp24.fcp_cmnd.add_cdb[
 	    atio->u.isp24.fcp_cmnd.add_cdb_len]));
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe022,
-		"qla_target: START qla cmd: %p se_cmd %p lun: 0x%04x (tag %d) len(%d) ox_id %x\n",
-		cmd, &cmd->se_cmd, cmd->unpacked_lun, cmd->tag, data_length,
-		cmd->atio.u.isp24.fcp_hdr.ox_id);
-
 	ret = ha->tgt.tgt_ops->handle_cmd(vha, cmd, cdb, data_length,
 				          fcp_task_attr, data_dir, bidi);
 	if (ret != 0)
@@ -3144,7 +3077,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	return;
 
 out_term:
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf020, "Terminating work cmd %p", cmd);
+	ql_dbg(ql_dbg_io, vha, 0x3060, "Terminating work cmd %p", cmd);
 	/*
 	 * cmd has not sent to target yet, so pass NULL as the second
 	 * argument to qlt_send_term_exchange() and free the memory here.
@@ -3262,7 +3195,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	struct qla_tgt_cmd *cmd;
 
 	if (unlikely(tgt->tgt_stop)) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf021,
+		ql_dbg(ql_dbg_io, vha, 0x3061,
 		    "New command while device %p is shutting down\n", tgt);
 		return -EFAULT;
 	}
@@ -3287,7 +3220,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	cmd = qlt_get_tag(vha, sess, atio);
 	if (!cmd) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05e,
+		ql_dbg(ql_dbg_io, vha, 0x3062,
 		    "qla_target(%d): Allocation of cmd failed\n", vha->vp_idx);
 		ha->tgt.tgt_ops->put_sess(sess);
 		return -ENOMEM;
@@ -4138,7 +4071,7 @@ static void qlt_send_busy(struct scsi_qla_host *vha,
 
 	pkt = (request_t *)qla2x00_alloc_iocbs(vha, NULL);
 	if (!pkt) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06e,
+		ql_dbg(ql_dbg_io, vha, 0x3063,
 		    "qla_target(%d): %s failed: unable to allocate "
 		    "request packet", vha->vp_idx, __func__);
 		return;
@@ -4185,14 +4118,10 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 	int rc;
 
 	if (unlikely(tgt == NULL)) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf039,
+		ql_dbg(ql_dbg_io, vha, 0x3064,
 		    "ATIO pkt, but no tgt (ha %p)", ha);
 		return;
 	}
-	ql_dbg(ql_dbg_tgt, vha, 0xe02c,
-	    "qla_target(%d): ATIO pkt %p: type %02x count %02x",
-	    vha->vp_idx, atio, atio->u.raw.entry_type,
-	    atio->u.raw.entry_count);
 	/*
 	 * In tgt_stop mode we also should allow all requests to pass.
 	 * Otherwise, some commands can stuck.
@@ -4202,23 +4131,9 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 
 	switch (atio->u.raw.entry_type) {
 	case ATIO_TYPE7:
-		ql_dbg(ql_dbg_tgt, vha, 0xe02d,
-		    "ATIO_TYPE7 instance %d, lun %Lx, read/write %d/%d, cdb %x, add_cdb_len %x, data_length %04x, s_id %02x%02x%02x\n",
-		    vha->vp_idx, atio->u.isp24.fcp_cmnd.lun,
-		    atio->u.isp24.fcp_cmnd.rddata,
-		    atio->u.isp24.fcp_cmnd.wrdata,
-		    atio->u.isp24.fcp_cmnd.cdb[0],
-		    atio->u.isp24.fcp_cmnd.add_cdb_len,
-		    be32_to_cpu(get_unaligned((uint32_t *)
-			&atio->u.isp24.fcp_cmnd.add_cdb[
-			atio->u.isp24.fcp_cmnd.add_cdb_len])),
-		    atio->u.isp24.fcp_hdr.s_id[0],
-		    atio->u.isp24.fcp_hdr.s_id[1],
-		    atio->u.isp24.fcp_hdr.s_id[2]);
-
 		if (unlikely(atio->u.isp24.exchange_addr ==
 		    ATIO_EXCHANGE_ADDRESS_UNKNOWN)) {
-			ql_dbg(ql_dbg_tgt, vha, 0xe058,
+			ql_dbg(ql_dbg_io, vha, 0x3065,
 			    "qla_target(%d): ATIO_TYPE7 "
 			    "received with UNKNOWN exchange address, "
 			    "sending QUEUE_FULL\n", vha->vp_idx);
@@ -4292,11 +4207,6 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 		return;
 	}
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe02f,
-	    "qla_target(%d): response pkt %p: T %02x C %02x S %02x "
-	    "handle %#x\n", vha->vp_idx, pkt, pkt->entry_type,
-	    pkt->entry_count, pkt->entry_status, pkt->handle);
-
 	/*
 	 * In tgt_stop mode we also should allow all requests to pass.
 	 * Otherwise, some commands can stuck.
@@ -4309,9 +4219,6 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 	case CTIO_TYPE7:
 	{
 		struct ctio7_from_24xx *entry = (struct ctio7_from_24xx *)pkt;
-		ql_dbg(ql_dbg_tgt, vha, 0xe030,
-			"CTIO[0x%x] 12/CTIO7 7A/CRC2: instance %d\n",
-			entry->entry_type, vha->vp_idx);
 		qlt_do_ctio_completion(vha, entry->handle,
 		    le16_to_cpu(entry->status)|(pkt->entry_status << 16),
 		    entry);
@@ -4322,15 +4229,6 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 	{
 		struct atio_from_isp *atio = (struct atio_from_isp *)pkt;
 		int rc;
-		ql_dbg(ql_dbg_tgt, vha, 0xe031,
-		    "ACCEPT_TGT_IO instance %d status %04x "
-		    "lun %04x read/write %d data_length %04x "
-		    "target_id %02x rx_id %04x\n ", vha->vp_idx,
-		    le16_to_cpu(atio->u.isp2x.status),
-		    le16_to_cpu(atio->u.isp2x.lun),
-		    atio->u.isp2x.execution_codes,
-		    le32_to_cpu(atio->u.isp2x.data_length), GET_TARGET_ID(ha,
-		    atio), atio->u.isp2x.rx_id);
 		if (atio->u.isp2x.status !=
 		    __constant_cpu_to_le16(ATIO_CDB_VALID)) {
 			ql_dbg(ql_dbg_tgt, vha, 0xe05e,
@@ -4339,10 +4237,6 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 			    le16_to_cpu(atio->u.isp2x.status));
 			break;
 		}
-		ql_dbg(ql_dbg_tgt, vha, 0xe032,
-		    "FCP CDB: 0x%02x, sizeof(cdb): %lu",
-		    atio->u.isp2x.cdb[0], (unsigned long
-		    int)sizeof(atio->u.isp2x.cdb));
 
 		rc = qlt_handle_cmd_for_atio(vha, atio);
 		if (unlikely(rc != 0)) {
@@ -4375,8 +4269,6 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 	case CONTINUE_TGT_IO_TYPE:
 	{
 		struct ctio_to_2xxx *entry = (struct ctio_to_2xxx *)pkt;
-		ql_dbg(ql_dbg_tgt, vha, 0xe033,
-		    "CONTINUE_TGT_IO: instance %d\n", vha->vp_idx);
 		qlt_do_ctio_completion(vha, entry->handle,
 		    le16_to_cpu(entry->status)|(pkt->entry_status << 16),
 		    entry);
@@ -4386,8 +4278,6 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 	case CTIO_A64_TYPE:
 	{
 		struct ctio_to_2xxx *entry = (struct ctio_to_2xxx *)pkt;
-		ql_dbg(ql_dbg_tgt, vha, 0xe034, "CTIO_A64: instance %d\n",
-		    vha->vp_idx);
 		qlt_do_ctio_completion(vha, entry->handle,
 		    le16_to_cpu(entry->status)|(pkt->entry_status << 16),
 		    entry);
@@ -4491,11 +4381,6 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	int login_code;
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe039,
-	    "scsi(%ld): ha state %d init_done %d oper_mode %d topo %d\n",
-	    vha->host_no, atomic_read(&vha->loop_state), vha->flags.init_done,
-	    ha->operating_mode, ha->current_topology);
-
 	if (!ha->tgt.tgt_ops)
 		return;
 
@@ -4572,11 +4457,6 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 		break;
 
 	default:
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf040,
-		    "qla_target(%d): Async event %#x occurred: "
-		    "ignore (m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx,
-		    code, le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
-		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
 		break;
 	}
 
@@ -4597,8 +4477,6 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 		return NULL;
 	}
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf041, "loop_id %d", loop_id);
-
 	fcport->loop_id = loop_id;
 
 	rc = qla2x00_get_port_database(vha, fcport, 0);
-- 
1.7.7

