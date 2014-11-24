From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/4] scsi: remove MSG_*_TAG defines
Date: Mon, 24 Nov 2014 07:07:25 -0800
Message-ID: <20141124150725.GA23165@infradead.org>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaKXPH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 10:07:26 -0500
Content-Disposition: inline
In-Reply-To: <1416839781-26988-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

For SPI drivers use the message defintions from scsi.c, and for target
drivers introduce a new TCM_*_TAG namespace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c      | 10 +++++-----
 drivers/scsi/advansys.c                    |  8 ++++----
 drivers/scsi/qla2xxx/qla_target.c          | 12 ++++++------
 drivers/scsi/scsi_debug.c                  |  1 -
 drivers/scsi/scsi_transport_spi.c          |  2 +-
 drivers/scsi/tmscsim.c                     |  2 +-
 drivers/target/iscsi/iscsi_target.c        | 14 +++++++-------
 drivers/target/loopback/tcm_loop.c         |  4 ++--
 drivers/target/sbp/sbp_target.c            |  2 +-
 drivers/target/target_core_pscsi.c         |  2 +-
 drivers/target/target_core_sbc.c           |  2 +-
 drivers/target/target_core_spc.c           |  4 ++--
 drivers/target/target_core_transport.c     | 16 ++++++++--------
 drivers/target/tcm_fc/tfc_cmd.c            |  8 ++++----
 drivers/usb/gadget/legacy/tcm_usb_gadget.c | 10 +++++-----
 drivers/xen/xen-scsiback.c                 |  2 +-
 include/scsi/scsi_tcq.h                    |  5 -----
 include/target/target_core_base.h          |  6 ++++++
 include/trace/events/target.h              |  8 ++++----
 19 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7206547..3a0ca61 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1708,17 +1708,17 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 
 	switch (srp_cmd->task_attr) {
 	case SRP_CMD_SIMPLE_Q:
-		cmd->sam_task_attr = MSG_SIMPLE_TAG;
+		cmd->sam_task_attr = TCM_SIMPLE_TAG;
 		break;
 	case SRP_CMD_ORDERED_Q:
 	default:
-		cmd->sam_task_attr = MSG_ORDERED_TAG;
+		cmd->sam_task_attr = TCM_ORDERED_TAG;
 		break;
 	case SRP_CMD_HEAD_OF_Q:
-		cmd->sam_task_attr = MSG_HEAD_TAG;
+		cmd->sam_task_attr = TCM_HEAD_TAG;
 		break;
 	case SRP_CMD_ACA:
-		cmd->sam_task_attr = MSG_ACA_TAG;
+		cmd->sam_task_attr = TCM_ACA_TAG;
 		break;
 	}
 
@@ -1733,7 +1733,7 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 				       sizeof(srp_cmd->lun));
 	rc = target_submit_cmd(cmd, ch->sess, srp_cmd->cdb,
 			&send_ioctx->sense_data[0], unpacked_lun, data_len,
-			MSG_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
+			TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto send_sense;
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 6719a33..2c5ce48 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7921,9 +7921,9 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 */
 	if ((asc_dvc->cur_dvc_qng[scp->device->id] > 0) &&
 	    (boardp->reqcnt[scp->device->id] % 255) == 0) {
-		asc_scsi_q->q2.tag_code = MSG_ORDERED_TAG;
+		asc_scsi_q->q2.tag_code = ORDERED_QUEUE_TAG;
 	} else {
-		asc_scsi_q->q2.tag_code = MSG_SIMPLE_TAG;
+		asc_scsi_q->q2.tag_code = SIMPLE_QUEUE_TAG;
 	}
 
 	/* Build ASC_SCSI_Q */
@@ -8351,7 +8351,7 @@ static int AscPutReadyQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
 	}
 	q_addr = ASC_QNO_TO_QADDR(q_no);
 	if ((scsiq->q1.target_id & asc_dvc->use_tagged_qng) == 0) {
-		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
+		scsiq->q2.tag_code &= ~SIMPLE_QUEUE_TAG;
 	}
 	scsiq->q1.status = QS_FREE;
 	AscMemWordCopyPtrToLram(iop_base,
@@ -8669,7 +8669,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 		}
 	}
 	if (disable_syn_offset_one_fix) {
-		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
+		scsiq->q2.tag_code &= ~SIMPLE_QUEUE_TAG;
 		scsiq->q2.tag_code |= (ASC_TAG_FLAG_DISABLE_ASYN_USE_SYN_FIX |
 				       ASC_TAG_FLAG_DISABLE_DISCONNECT);
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a902fa1..5741825 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3218,25 +3218,25 @@ static inline int qlt_get_fcp_task_attr(struct scsi_qla_host *vha,
 
 	switch (task_codes) {
 	case ATIO_SIMPLE_QUEUE:
-		fcp_task_attr = MSG_SIMPLE_TAG;
+		fcp_task_attr = TCM_SIMPLE_TAG;
 		break;
 	case ATIO_HEAD_OF_QUEUE:
-		fcp_task_attr = MSG_HEAD_TAG;
+		fcp_task_attr = TCM_HEAD_TAG;
 		break;
 	case ATIO_ORDERED_QUEUE:
-		fcp_task_attr = MSG_ORDERED_TAG;
+		fcp_task_attr = TCM_ORDERED_TAG;
 		break;
 	case ATIO_ACA_QUEUE:
-		fcp_task_attr = MSG_ACA_TAG;
+		fcp_task_attr = TCM_ACA_TAG;
 		break;
 	case ATIO_UNTAGGED:
-		fcp_task_attr = MSG_SIMPLE_TAG;
+		fcp_task_attr = TCM_SIMPLE_TAG;
 		break;
 	default:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05d,
 		    "qla_target: unknown task code %x, use ORDERED instead\n",
 		    task_codes);
-		fcp_task_attr = MSG_ORDERED_TAG;
+		fcp_task_attr = TCM_ORDERED_TAG;
 		break;
 	}
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 169c84f..bac3e62 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -125,7 +125,6 @@ static const char *scsi_debug_version_date = "20140706";
 #define DEF_REMOVABLE false
 #define DEF_SCSI_LEVEL   6    /* INQUIRY, byte2 [6->SPC-4] */
 #define DEF_SECTOR_SIZE 512
-#define DEF_TAGGED_QUEUING 0 /* 0 | MSG_SIMPLE_TAG | MSG_ORDERED_TAG */
 #define DEF_UNMAP_ALIGNMENT 0
 #define DEF_UNMAP_GRANULARITY 1
 #define DEF_UNMAP_MAX_BLOCKS 0xFFFFFFFF
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index fa2aece..31bbb0d 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1221,7 +1221,7 @@ EXPORT_SYMBOL_GPL(spi_populate_ppr_msg);
 int spi_populate_tag_msg(unsigned char *msg, struct scsi_cmnd *cmd)
 {
         if (cmd->flags & SCMD_TAGGED) {
-		*msg++ = MSG_SIMPLE_TAG;
+		*msg++ = SIMPLE_QUEUE_TAG;
         	*msg++ = cmd->request->tag;
         	return 2;
 	}
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 14ccc9a..bdfbc27 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -559,7 +559,7 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
     DC390_write8 (ScsiFifo, IDENTIFY(disc_allowed, pDCB->TargetLUN));
     /* Change 99/05/31: Don't use tags when not disconnecting (BUSY) */
     if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed && (scmd->flags & SCMD_TAGGED)) {
-	DC390_write8(ScsiFifo, MSG_SIMPLE_TAG);
+	DC390_write8(ScsiFifo, SIMPLE_QUEUE_TAG);
 	pDCB->TagMask |= 1 << scmd->request->tag;
 	pSRB->TagNumber = scmd->request->tag;
 	DC390_write8(ScsiFifo, scmd->request->tag);
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b19e432..67802cc 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -943,17 +943,17 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	 */
 	if ((iscsi_task_attr == ISCSI_ATTR_UNTAGGED) ||
 	    (iscsi_task_attr == ISCSI_ATTR_SIMPLE))
-		sam_task_attr = MSG_SIMPLE_TAG;
+		sam_task_attr = TCM_SIMPLE_TAG;
 	else if (iscsi_task_attr == ISCSI_ATTR_ORDERED)
-		sam_task_attr = MSG_ORDERED_TAG;
+		sam_task_attr = TCM_ORDERED_TAG;
 	else if (iscsi_task_attr == ISCSI_ATTR_HEAD_OF_QUEUE)
-		sam_task_attr = MSG_HEAD_TAG;
+		sam_task_attr = TCM_HEAD_TAG;
 	else if (iscsi_task_attr == ISCSI_ATTR_ACA)
-		sam_task_attr = MSG_ACA_TAG;
+		sam_task_attr = TCM_ACA_TAG;
 	else {
 		pr_debug("Unknown iSCSI Task Attribute: 0x%02x, using"
-			" MSG_SIMPLE_TAG\n", iscsi_task_attr);
-		sam_task_attr = MSG_SIMPLE_TAG;
+			" TCM_SIMPLE_TAG\n", iscsi_task_attr);
+		sam_task_attr = TCM_SIMPLE_TAG;
 	}
 
 	cmd->iscsi_opcode	= ISCSI_OP_SCSI_CMD;
@@ -1811,7 +1811,7 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		transport_init_se_cmd(&cmd->se_cmd,
 				      &lio_target_fabric_configfs->tf_ops,
 				      conn->sess->se_sess, 0, DMA_NONE,
-				      MSG_SIMPLE_TAG, cmd->sense_buffer + 2);
+				      TCM_SIMPLE_TAG, cmd->sense_buffer + 2);
 
 		target_get_sess_cmd(conn->sess->se_sess, &cmd->se_cmd, true);
 		sess_ref = true;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 24e2c94..dda9a08 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -168,7 +168,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 
 	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			transfer_length, MSG_SIMPLE_TAG,
+			transfer_length, TCM_SIMPLE_TAG,
 			sc->sc_data_direction, 0,
 			scsi_sglist(sc), scsi_sg_count(sc),
 			sgl_bidi, sgl_bidi_count,
@@ -248,7 +248,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
-				DMA_NONE, MSG_SIMPLE_TAG,
+				DMA_NONE, TCM_SIMPLE_TAG,
 				&tl_cmd->tl_sense_buf[0]);
 
 	rc = core_tmr_alloc_req(se_cmd, tl_tmr, tmr, GFP_KERNEL);
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e7e9372..9512af6 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1237,7 +1237,7 @@ static void sbp_handle_command(struct sbp_target_request *req)
 
 	if (target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
 			      req->sense_buf, unpacked_lun, data_length,
-			      MSG_SIMPLE_TAG, data_dir, 0))
+			      TCM_SIMPLE_TAG, data_dir, 0))
 		goto err;
 
 	return;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 7c8291f..caf03d5 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1094,7 +1094,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 	req->retries = PS_RETRY;
 
 	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, NULL, req,
-			(cmd->sam_task_attr == MSG_HEAD_TAG),
+			(cmd->sam_task_attr == TCM_HEAD_TAG),
 			pscsi_req_done);
 
 	return 0;
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ebe62af..d6e06af 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -485,7 +485,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
 	cmd->t_data_nents_orig = cmd->t_data_nents;
 	cmd->t_data_nents = 1;
 
-	cmd->sam_task_attr = MSG_HEAD_TAG;
+	cmd->sam_task_attr = TCM_HEAD_TAG;
 	cmd->transport_complete_callback = compare_and_write_post;
 	/*
 	 * Now reset ->execute_cmd() to the normal sbc_execute_rw() handler
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index bc286a6..1307600 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1357,7 +1357,7 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		 * Do implicit HEAD_OF_QUEUE processing for INQUIRY.
 		 * See spc4r17 section 5.3
 		 */
-		cmd->sam_task_attr = MSG_HEAD_TAG;
+		cmd->sam_task_attr = TCM_HEAD_TAG;
 		cmd->execute_cmd = spc_emulate_inquiry;
 		break;
 	case SECURITY_PROTOCOL_IN:
@@ -1391,7 +1391,7 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		 * Do implicit HEAD_OF_QUEUE processing for REPORT_LUNS
 		 * See spc4r17 section 5.3
 		 */
-		cmd->sam_task_attr = MSG_HEAD_TAG;
+		cmd->sam_task_attr = TCM_HEAD_TAG;
 		break;
 	case TEST_UNIT_READY:
 		cmd->execute_cmd = spc_emulate_testunitready;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9ea0d5f..d9b5010 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1159,7 +1159,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
 		return 0;
 
-	if (cmd->sam_task_attr == MSG_ACA_TAG) {
+	if (cmd->sam_task_attr == TCM_ACA_TAG) {
 		pr_debug("SAM Task Attribute ACA"
 			" emulation is not supported\n");
 		return TCM_INVALID_CDB_FIELD;
@@ -1531,7 +1531,7 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			      0, DMA_NONE, MSG_SIMPLE_TAG, sense);
+			      0, DMA_NONE, TCM_SIMPLE_TAG, sense);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
@@ -1718,12 +1718,12 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	 * to allow the passed struct se_cmd list of tasks to the front of the list.
 	 */
 	switch (cmd->sam_task_attr) {
-	case MSG_HEAD_TAG:
+	case TCM_HEAD_TAG:
 		pr_debug("Added HEAD_OF_QUEUE for CDB: 0x%02x, "
 			 "se_ordered_id: %u\n",
 			 cmd->t_task_cdb[0], cmd->se_ordered_id);
 		return false;
-	case MSG_ORDERED_TAG:
+	case TCM_ORDERED_TAG:
 		atomic_inc_mb(&dev->dev_ordered_sync);
 
 		pr_debug("Added ORDERED for CDB: 0x%02x to ordered list, "
@@ -1828,7 +1828,7 @@ static void target_restart_delayed_cmds(struct se_device *dev)
 
 		__target_execute_cmd(cmd);
 
-		if (cmd->sam_task_attr == MSG_ORDERED_TAG)
+		if (cmd->sam_task_attr == TCM_ORDERED_TAG)
 			break;
 	}
 }
@@ -1844,18 +1844,18 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
 		return;
 
-	if (cmd->sam_task_attr == MSG_SIMPLE_TAG) {
+	if (cmd->sam_task_attr == TCM_SIMPLE_TAG) {
 		atomic_dec_mb(&dev->simple_cmds);
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev->dev_cur_ordered_id: %u for"
 			" SIMPLE: %u\n", dev->dev_cur_ordered_id,
 			cmd->se_ordered_id);
-	} else if (cmd->sam_task_attr == MSG_HEAD_TAG) {
+	} else if (cmd->sam_task_attr == TCM_HEAD_TAG) {
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev_cur_ordered_id: %u for"
 			" HEAD_OF_QUEUE: %u\n", dev->dev_cur_ordered_id,
 			cmd->se_ordered_id);
-	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
+	} else if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
 		atomic_dec_mb(&dev->dev_ordered_sync);
 
 		dev->dev_cur_ordered_id++;
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index be0c0d0..edcafa4 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -554,17 +554,17 @@ static void ft_send_work(struct work_struct *work)
 	 */
 	switch (fcp->fc_pri_ta & FCP_PTA_MASK) {
 	case FCP_PTA_HEADQ:
-		task_attr = MSG_HEAD_TAG;
+		task_attr = TCM_HEAD_TAG;
 		break;
 	case FCP_PTA_ORDERED:
-		task_attr = MSG_ORDERED_TAG;
+		task_attr = TCM_ORDERED_TAG;
 		break;
 	case FCP_PTA_ACA:
-		task_attr = MSG_ACA_TAG;
+		task_attr = TCM_ACA_TAG;
 		break;
 	case FCP_PTA_SIMPLE: /* Fallthrough */
 	default:
-		task_attr = MSG_SIMPLE_TAG;
+		task_attr = TCM_SIMPLE_TAG;
 	}
 
 	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
diff --git a/drivers/usb/gadget/legacy/tcm_usb_gadget.c b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
index 6cdb7a5..283ee14 100644
--- a/drivers/usb/gadget/legacy/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
@@ -1131,19 +1131,19 @@ static int usbg_submit_command(struct f_uas *fu,
 
 	switch (cmd_iu->prio_attr & 0x7) {
 	case UAS_HEAD_TAG:
-		cmd->prio_attr = MSG_HEAD_TAG;
+		cmd->prio_attr = TCM_HEAD_TAG;
 		break;
 	case UAS_ORDERED_TAG:
-		cmd->prio_attr = MSG_ORDERED_TAG;
+		cmd->prio_attr = TCM_ORDERED_TAG;
 		break;
 	case UAS_ACA:
-		cmd->prio_attr = MSG_ACA_TAG;
+		cmd->prio_attr = TCM_ACA_TAG;
 		break;
 	default:
 		pr_debug_once("Unsupported prio_attr: %02x.\n",
 				cmd_iu->prio_attr);
 	case UAS_SIMPLE_TAG:
-		cmd->prio_attr = MSG_SIMPLE_TAG;
+		cmd->prio_attr = TCM_SIMPLE_TAG;
 		break;
 	}
 
@@ -1240,7 +1240,7 @@ static int bot_submit_command(struct f_uas *fu,
 		goto err;
 	}
 
-	cmd->prio_attr = MSG_SIMPLE_TAG;
+	cmd->prio_attr = TCM_SIMPLE_TAG;
 	se_cmd = &cmd->se_cmd;
 	cmd->unpacked_lun = cbw->Lun;
 	cmd->is_read = cbw->Flags & US_BULK_FLAG_IN ? 1 : 0;
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 50610a6..e999496e 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -606,7 +606,7 @@ static void scsiback_device_action(struct vscsibk_pend *pending_req,
 	init_waitqueue_head(&tmr->tmr_wait);
 
 	transport_init_se_cmd(se_cmd, tpg->se_tpg.se_tpg_tfo,
-		tpg->tpg_nexus->tvn_se_sess, 0, DMA_NONE, MSG_SIMPLE_TAG,
+		tpg->tpg_nexus->tvn_se_sess, 0, DMA_NONE, TCM_SIMPLE_TAG,
 		&pending_req->sense_buffer[0]);
 
 	rc = core_tmr_alloc_req(se_cmd, tmr, act, GFP_KERNEL);
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index e624aca..9708b28 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -6,11 +6,6 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
-#define MSG_SIMPLE_TAG	0x20
-#define MSG_HEAD_TAG	0x21
-#define MSG_ORDERED_TAG	0x22
-#define MSG_ACA_TAG	0x24	/* unsupported */
-
 #define SCSI_NO_TAG	(-1)    /* identify no tag in use */
 
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 23c518a..397fb63 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -476,6 +476,12 @@ struct se_dif_v1_tuple {
 	__be32			ref_tag;
 };
 
+/* for sam_task_attr */
+#define TCM_SIMPLE_TAG	0x20
+#define TCM_HEAD_TAG	0x21
+#define TCM_ORDERED_TAG	0x22
+#define TCM_ACA_TAG	0x24
+
 struct se_cmd {
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index da9cc0f..a456680 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -109,10 +109,10 @@
 
 #define show_task_attribute_name(val)				\
 	__print_symbolic(val,					\
-		{ MSG_SIMPLE_TAG,	"SIMPLE"	},	\
-		{ MSG_HEAD_TAG,		"HEAD"		},	\
-		{ MSG_ORDERED_TAG,	"ORDERED"	},	\
-		{ MSG_ACA_TAG,		"ACA"		} )
+		{ TCM_SIMPLE_TAG,	"SIMPLE"	},	\
+		{ TCM_HEAD_TAG,		"HEAD"		},	\
+		{ TCM_ORDERED_TAG,	"ORDERED"	},	\
+		{ TCM_ACA_TAG,		"ACA"		} )
 
 #define show_scsi_status_name(val)				\
 	__print_symbolic(val,					\
-- 
1.9.1

