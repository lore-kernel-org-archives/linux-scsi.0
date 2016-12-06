From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 17/22] qla2xxx: Rerfactor use of sp context
Date: Tue, 6 Dec 2016 12:30:46 -0800
Message-ID: <1481056251-2310-18-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   | 12 +++----
 drivers/scsi/qla2xxx/qla_bsg.c    | 13 ++++---
 drivers/scsi/qla2xxx/qla_def.h    |  2 +-
 drivers/scsi/qla2xxx/qla_gs.c     | 14 ++++----
 drivers/scsi/qla2xxx/qla_init.c   | 42 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_inline.h | 10 +++---
 drivers/scsi/qla2xxx/qla_iocb.c   | 76 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_isr.c    | 44 +++++++++++------------
 drivers/scsi/qla2xxx/qla_mid.c    | 12 ++++---
 drivers/scsi/qla2xxx/qla_mr.c     | 46 +++++++++++-------------
 drivers/scsi/qla2xxx/qla_os.c     | 10 +++---
 drivers/scsi/qla2xxx/qla_target.c |  4 +--
 12 files changed, 138 insertions(+), 147 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d8b77aa..5b53fdd 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2498,8 +2498,6 @@ struct device_attribute *qla2x00_host_attrs[] = {
 		    "Timer for the VP[%d] has stopped\n", vha->vp_idx);
 	}
 
-	BUG_ON(atomic_read(&vha->vref_count));
-
 	qla2x00_free_fcports(vha);
 
 	mutex_lock(&ha->vport_lock);
@@ -2510,10 +2508,12 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	dma_free_coherent(&ha->pdev->dev,
 		vha->gnl.size, vha->gnl.l, vha->gnl.ldma);
 
-	if (vha->qpair->vp_idx == vha->vp_idx) {
-		if (qla2xxx_delete_qpair(vha, vha->qpair) != QLA_SUCCESS)
-			ql_log(ql_log_warn, vha, 0x7087,
-			    "Queue Pair delete failed.\n");
+	if (vha->qpair) {
+		if (vha->qpair->vp_idx == vha->vp_idx) {
+			if (qla2xxx_delete_qpair(vha, vha->qpair) != QLA_SUCCESS)
+				ql_log(ql_log_warn, vha, 0x7087,
+				    "Queue Pair delete failed.\n");
+		}
 	}
 
 	ql_log(ql_log_info, vha, 0x7088, "VP[%d] deleted.\n", id);
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index cdf0dce..5db25a7 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -16,21 +16,20 @@
 qla2x00_bsg_job_done(void *data, void *ptr, int res)
 {
 	srb_t *sp = (srb_t *)ptr;
-	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
 	bsg_reply->result = res;
 	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 void
 qla2x00_bsg_sp_free(void *data, void *ptr)
 {
 	srb_t *sp = (srb_t *)ptr;
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
@@ -62,7 +61,7 @@
 	    sp->type == SRB_FXIOCB_BCMD ||
 	    sp->type == SRB_ELS_CMD_HST)
 		qla2x00_free_fcport(sp->fcport);
-	qla2x00_rel_sp(vha, sp);
+	qla2x00_rel_sp(sp);
 }
 
 int
@@ -394,7 +393,7 @@
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x700e,
 		    "qla2x00_start_sp failed = %d\n", rval);
-		qla2x00_rel_sp(vha, sp);
+		qla2x00_rel_sp(sp);
 		rval = -EIO;
 		goto done_unmap_sg;
 	}
@@ -542,7 +541,7 @@
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x7017,
 		    "qla2x00_start_sp failed=%d.\n", rval);
-		qla2x00_rel_sp(vha, sp);
+		qla2x00_rel_sp(sp);
 		rval = -EIO;
 		goto done_free_fcport;
 	}
@@ -2578,6 +2577,6 @@
 
 done:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 	return 0;
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f9a4528..3464d65 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -433,7 +433,7 @@ struct srb_iocb {
 typedef struct srb {
 	atomic_t ref_count;
 	struct fc_port *fcport;
-	void *vha;
+	struct scsi_qla_host *vha;
 	uint32_t handle;
 	uint16_t flags;
 	uint16_t type;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 1e70a58..e36068c 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2854,7 +2854,7 @@ void qla2x00_async_gidpn_sp_done(void *v, void *s, int res)
 
 	qla2x00_fcport_event_handler(vha, &ea);
 
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -2912,7 +2912,7 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
@@ -3018,7 +3018,7 @@ void qla24xx_async_gpsc_sp_done(void *v, void *s, int res)
 	ea.fcport = fcport;
 	qla2x00_fcport_event_handler(vha, &ea);
 
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -3073,7 +3073,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
@@ -3111,7 +3111,7 @@ void qla24xx_async_gpnid_done(scsi_qla_host_t *vha, srb_t *sp)
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
 
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
@@ -3190,7 +3190,7 @@ void qla2x00_async_gpnid_sp_done(void *v, void *s, int res)
 			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 		}
 
-		sp->free(vha, sp);
+		sp->free(sp->vha, sp);
 		return;
 	}
 
@@ -3279,7 +3279,7 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
 
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1899333..dcb8c49 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -47,18 +47,17 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 {
 	srb_t *sp = (srb_t *)__data;
 	struct srb_iocb *iocb;
-	scsi_qla_host_t *vha = (scsi_qla_host_t *)sp->vha;
-	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = ha->req_q_map[0];
+	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+	req = vha->hw->req_q_map[0];
 	req->outstanding_cmds[sp->handle] = NULL;
 	iocb = &sp->u.iocb_cmd;
 	iocb->timeout(sp);
-	sp->free(vha, sp);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	sp->free(sp->vha, sp);
+	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 }
 
 void
@@ -66,10 +65,9 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 {
 	srb_t *sp = (srb_t *)ptr;
 	struct srb_iocb *iocb = &sp->u.iocb_cmd;
-	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 
 	del_timer(&iocb->timer);
-	qla2x00_rel_sp(vha, sp);
+	qla2x00_rel_sp(sp);
 }
 
 /* Asynchronous Login/Logout Routines -------------------------------------- */
@@ -163,7 +161,7 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 		qla2x00_fcport_event_handler(vha, &ea);
 	}
 
-	sp->free(sp->fcport->vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 int
@@ -215,7 +213,7 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 	return rval;
 
 done_free_sp:
-	sp->free(fcport->vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
@@ -230,9 +228,9 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 
 	sp->fcport->flags &= ~FCF_ASYNC_SENT;
 	if (!test_bit(UNLOADING, &vha->dpc_flags))
-		qla2x00_post_async_logout_done_work(sp->fcport->vha, sp->fcport,
+		qla2x00_post_async_logout_done_work(sp->vha, sp->fcport,
 		    lio->u.logio.data);
-	sp->free(sp->fcport->vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 int
@@ -267,7 +265,7 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 	return rval;
 
 done_free_sp:
-	sp->free(fcport->vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	sp->fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
@@ -281,9 +279,9 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 
 	if (!test_bit(UNLOADING, &vha->dpc_flags))
-		qla2x00_post_async_adisc_done_work(sp->fcport->vha, sp->fcport,
+		qla2x00_post_async_adisc_done_work(sp->vha, sp->fcport,
 		    lio->u.logio.data);
-	sp->free(sp->fcport->vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 int
@@ -548,7 +546,7 @@ void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
@@ -617,7 +615,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(fcport->vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
@@ -716,7 +714,7 @@ void qla24xx_async_gpdb_sp_done(void *v, void *s, int res)
 	dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
 		sp->u.iocb_cmd.u.mbx.in_dma);
 
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 static int qla24xx_post_gpdb_work(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
@@ -796,7 +794,7 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	if (pd)
 		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
 
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	qla24xx_post_gpdb_work(vha, fcport, opt);
@@ -1261,7 +1259,7 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 	}
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	return rval;
 }
@@ -1288,7 +1286,7 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 static int
 qla24xx_async_abort_cmd(srb_t *cmd_sp)
 {
-	scsi_qla_host_t *vha = cmd_sp->fcport->vha;
+	scsi_qla_host_t *vha = cmd_sp->vha;
 	fc_port_t *fcport = cmd_sp->fcport;
 	struct srb_iocb *abt_iocb;
 	srb_t *sp;
@@ -1321,7 +1319,7 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 	    QLA_SUCCESS : QLA_FUNCTION_FAILED;
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index d6dd976..d4966e3 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -249,14 +249,13 @@
 qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 {
 	srb_t *sp = NULL;
-	struct qla_hw_data *ha = vha->hw;
 	uint8_t bail;
 
 	QLA_VHA_MARK_BUSY(vha, bail);
 	if (unlikely(bail))
 		return NULL;
 
-	sp = mempool_alloc(ha->srb_mempool, flag);
+	sp = mempool_alloc(vha->hw->srb_mempool, flag);
 	if (!sp)
 		goto done;
 
@@ -267,14 +266,15 @@
 done:
 	if (!sp)
 		QLA_VHA_MARK_NOT_BUSY(vha);
+
 	return sp;
 }
 
 static inline void
-qla2x00_rel_sp(scsi_qla_host_t *vha, srb_t *sp)
+qla2x00_rel_sp(srb_t *sp)
 {
-	mempool_free(sp, vha->hw->srb_mempool);
-	QLA_VHA_MARK_NOT_BUSY(vha);
+	mempool_free(sp, sp->vha->hw->srb_mempool);
+	QLA_VHA_MARK_NOT_BUSY(sp->vha);
 }
 
 static inline void
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b7d3739..f892fca 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -23,7 +23,7 @@
 {
 	uint16_t cflags;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 
 	cflags = 0;
 
@@ -210,7 +210,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 		return;
 	}
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
 	/* Three DSDs are available in the Command Type 2 IOCB */
@@ -267,7 +267,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 		return;
 	}
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
 	/* Two DSDs are available in the Command Type 3 IOCB */
@@ -324,7 +324,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	struct rsp_que *rsp;
 
 	/* Setup device pointers. */
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	ha = vha->hw;
 	reg = &ha->iobase->isp;
 	cmd = GET_CMD_SP(sp);
@@ -601,7 +601,7 @@ int qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
 		return 0;
 	}
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	ha = vha->hw;
 
 	/* Set transfer direction */
@@ -716,7 +716,7 @@ int qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
 		return;
 	}
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -1108,7 +1108,7 @@ struct fw_dif_context {
 	if (sp) {
 		cmd = GET_CMD_SP(sp);
 		sgl = scsi_prot_sglist(cmd);
-		vha = sp->fcport->vha;
+		vha = sp->vha;
 	} else if (tc) {
 		vha = tc->vha;
 		sgl = tc->prot_sg;
@@ -1215,7 +1215,7 @@ struct fw_dif_context {
 	/* Update entry type to indicate Command Type CRC_2 IOCB */
 	*((uint32_t *)(&cmd_pkt->entry_type)) = cpu_to_le32(COMMAND_TYPE_CRC_2);
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	ha = vha->hw;
 
 	/* No data transfer */
@@ -1225,7 +1225,7 @@ struct fw_dif_context {
 		return QLA_SUCCESS;
 	}
 
-	cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+	cmd_pkt->vp_index = sp->vha->vp_idx;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -1420,7 +1420,7 @@ struct fw_dif_context {
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 
 	/* Setup device pointers. */
@@ -1497,7 +1497,7 @@ struct fw_dif_context {
 	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
 	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
 	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-	cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+	cmd_pkt->vp_index = sp->vha->vp_idx;
 
 	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
 	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
@@ -1569,7 +1569,7 @@ struct fw_dif_context {
 	struct req_que		*req = NULL;
 	struct rsp_que		*rsp = NULL;
 	struct scsi_cmnd	*cmd = GET_CMD_SP(sp);
-	struct scsi_qla_host	*vha = sp->fcport->vha;
+	struct scsi_qla_host	*vha = sp->vha;
 	struct qla_hw_data	*ha = vha->hw;
 	struct cmd_type_crc_2	*cmd_pkt;
 	uint32_t		status = 0;
@@ -2219,13 +2219,13 @@ struct fw_dif_context {
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->fcport->vha->vp_idx;
+	logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
 qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
 {
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct qla_hw_data *ha = sp->vha->hw;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 	uint16_t opts;
 
@@ -2243,7 +2243,7 @@ struct fw_dif_context {
 	mbx->mb2 = cpu_to_le16(sp->fcport->d_id.b.domain);
 	mbx->mb3 = cpu_to_le16(sp->fcport->d_id.b.area << 8 |
 	    sp->fcport->d_id.b.al_pa);
-	mbx->mb9 = cpu_to_le16(sp->fcport->vha->vp_idx);
+	mbx->mb9 = cpu_to_le16(sp->vha->vp_idx);
 }
 
 static void
@@ -2259,13 +2259,13 @@ struct fw_dif_context {
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->fcport->vha->vp_idx;
+	logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
 qla2x00_logout_iocb(srb_t *sp, struct mbx_entry *mbx)
 {
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct qla_hw_data *ha = sp->vha->hw;
 
 	mbx->entry_type = MBX_IOCB_TYPE;
 	SET_TARGET_ID(ha, mbx->loop_id, sp->fcport->loop_id);
@@ -2276,7 +2276,7 @@ struct fw_dif_context {
 	mbx->mb2 = cpu_to_le16(sp->fcport->d_id.b.domain);
 	mbx->mb3 = cpu_to_le16(sp->fcport->d_id.b.area << 8 |
 	    sp->fcport->d_id.b.al_pa);
-	mbx->mb9 = cpu_to_le16(sp->fcport->vha->vp_idx);
+	mbx->mb9 = cpu_to_le16(sp->vha->vp_idx);
 	/* Implicit: mbx->mbx10 = 0. */
 }
 
@@ -2286,13 +2286,13 @@ struct fw_dif_context {
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	logio->control_flags = cpu_to_le16(LCF_COMMAND_ADISC);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	logio->vp_index = sp->fcport->vha->vp_idx;
+	logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
 qla2x00_adisc_iocb(srb_t *sp, struct mbx_entry *mbx)
 {
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct qla_hw_data *ha = sp->vha->hw;
 
 	mbx->entry_type = MBX_IOCB_TYPE;
 	SET_TARGET_ID(ha, mbx->loop_id, sp->fcport->loop_id);
@@ -2307,7 +2307,7 @@ struct fw_dif_context {
 	mbx->mb3 = cpu_to_le16(LSW(ha->async_pd_dma));
 	mbx->mb6 = cpu_to_le16(MSW(MSD(ha->async_pd_dma)));
 	mbx->mb7 = cpu_to_le16(LSW(MSD(ha->async_pd_dma)));
-	mbx->mb9 = cpu_to_le16(sp->fcport->vha->vp_idx);
+	mbx->mb9 = cpu_to_le16(sp->vha->vp_idx);
 }
 
 static void
@@ -2359,7 +2359,7 @@ struct fw_dif_context {
 		    elsio->u.els_logo.els_logo_pyld_dma);
 
 	del_timer(&elsio->timer);
-	qla2x00_rel_sp(vha, sp);
+	qla2x00_rel_sp(sp);
 }
 
 static void
@@ -2455,7 +2455,7 @@ struct fw_dif_context {
 			    GFP_KERNEL);
 
 	if (!elsio->u.els_logo.els_logo_pyld) {
-		sp->free(vha, sp);
+		sp->free(sp->vha, sp);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2474,7 +2474,7 @@ struct fw_dif_context {
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		sp->free(vha, sp);
+		sp->free(sp->vha, sp);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2485,14 +2485,14 @@ struct fw_dif_context {
 
 	wait_for_completion(&elsio->u.els_logo.comp);
 
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 	return rval;
 }
 
 static void
 qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
 	els_iocb->entry_type = ELS_IOCB_TYPE;
@@ -2524,7 +2524,7 @@ struct fw_dif_context {
 	els_iocb->rx_address[1] = 0;
 	els_iocb->rx_len = 0;
 
-	sp->fcport->vha->qla_stats.control_requests++;
+	sp->vha->qla_stats.control_requests++;
 }
 
 static void
@@ -2540,7 +2540,7 @@ struct fw_dif_context {
         els_iocb->handle = sp->handle;
         els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	els_iocb->tx_dsd_count = cpu_to_le16(bsg_job->request_payload.sg_cnt);
-	els_iocb->vp_index = sp->fcport->vha->vp_idx;
+	els_iocb->vp_index = sp->vha->vp_idx;
         els_iocb->sof_type = EST_SOFI3;
 	els_iocb->rx_dsd_count = cpu_to_le16(bsg_job->reply_payload.sg_cnt);
 
@@ -2571,7 +2571,7 @@ struct fw_dif_context {
         els_iocb->rx_len = cpu_to_le32(sg_dma_len
             (bsg_job->reply_payload.sg_list));
 
-	sp->fcport->vha->qla_stats.control_requests++;
+	sp->vha->qla_stats.control_requests++;
 }
 
 static void
@@ -2582,7 +2582,7 @@ struct fw_dif_context {
 	struct scatterlist *sg;
 	int index;
 	uint16_t tot_dsds;
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	int loop_iterartion = 0;
@@ -2648,7 +2648,7 @@ struct fw_dif_context {
 	}
 	ct_iocb->entry_count = entry_count;
 
-	sp->fcport->vha->qla_stats.control_requests++;
+	sp->vha->qla_stats.control_requests++;
 }
 
 static void
@@ -2659,7 +2659,7 @@ struct fw_dif_context {
 	struct scatterlist *sg;
 	int index;
 	uint16_t tot_dsds;
-        scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	int loop_iterartion = 0;
@@ -2671,7 +2671,7 @@ struct fw_dif_context {
         ct_iocb->handle = sp->handle;
 
 	ct_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	ct_iocb->vp_index = sp->fcport->vha->vp_idx;
+	ct_iocb->vp_index = sp->vha->vp_idx;
 	ct_iocb->comp_status = cpu_to_le16(0);
 
 	ct_iocb->cmd_dsd_count =
@@ -2745,7 +2745,7 @@ struct fw_dif_context {
 	uint32_t *fcp_dl;
 	uint8_t additional_cdb_len;
 	struct ct6_dsd *ctx;
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
@@ -2907,7 +2907,7 @@ struct fw_dif_context {
 		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
 		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
 		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-		cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+		cmd_pkt->vp_index = sp->vha->vp_idx;
 
 		/* Build IOCB segments */
 		if (qla24xx_build_scsi_type_6_iocbs(sp, cmd_pkt, tot_dsds))
@@ -2980,7 +2980,7 @@ struct fw_dif_context {
 		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
 		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
 		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-		cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+		cmd_pkt->vp_index = sp->vha->vp_idx;
 
 		int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
 		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun,
@@ -3066,7 +3066,7 @@ struct fw_dif_context {
 qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 {
 	struct srb_iocb *aio = &sp->u.iocb_cmd;
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req = vha->req;
 
 	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
@@ -3141,7 +3141,7 @@ static void qla2x00_send_notify_ack_iocb(srb_t *sp,
 qla2x00_start_sp(srb_t *sp)
 {
 	int rval;
-	scsi_qla_host_t *vha = (scsi_qla_host_t *)sp->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	void *pkt;
 	unsigned long flags;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index dac59b3..c81ada0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1246,7 +1246,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		req->outstanding_cmds[index] = NULL;
 
 		/* Save ISP completion status */
-		sp->done(vha, sp, DID_OK << 16);
+		sp->done(sp->vha, sp, DID_OK << 16);
 	} else {
 		ql_log(ql_log_warn, vha, 0x3016, "Invalid SCSI SRB.\n");
 
@@ -1264,18 +1264,16 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	struct qla_hw_data *ha = vha->hw;
 	sts_entry_t *pkt = iocb;
 	srb_t *sp = NULL;
-	uint16_t index;
+	uint16_t index = LSW(pkt->handle);
 
-	index = LSW(pkt->handle);
 	if (index >= req->num_outstanding_cmds) {
 		ql_log(ql_log_warn, vha, 0x5031,
-			   "Invalid command index (%x) type %8ph.\n",
-			   index, iocb);
+		   "Invalid command index (%x) type %8ph.\n", index, iocb);
 		if (IS_P3P_TYPE(ha))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
 		else
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-		goto done;
+		return sp;
 	}
 	sp = req->outstanding_cmds[index];
 	if (!sp) {
@@ -1288,10 +1286,8 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		    "SRB handle (%x) mismatch %x.\n", sp->handle, index);
 		return NULL;
 	}
-
 	req->outstanding_cmds[index] = NULL;
 
-done:
 	return sp;
 }
 
@@ -1378,7 +1374,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	    le16_to_cpu(mbx->mb7));
 
 logio_done:
-	sp->done(vha, sp, 0);
+	sp->done(sp->vha, sp, 0);
 }
 
 static void
@@ -1407,7 +1403,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 
 	res = (si->u.mbx.in_mb[0] & MBS_MASK);
 
-	sp->done(vha, sp, res);
+	sp->done(sp->vha, sp, res);
 }
 
 static void
@@ -1425,7 +1421,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	if (pkt->u.isp2x.status != cpu_to_le16(NOTIFY_ACK_SUCCESS))
 		res = QLA_FUNCTION_FAILED;
 
-	sp->done(vha, sp, res);
+	sp->done(sp->vha, sp, res);
 }
 
 static void
@@ -1535,7 +1531,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		type = "Driver ELS logo";
 		ql_dbg(ql_dbg_user, vha, 0x5047,
 		    "Completing %s: (%p) type=%d.\n", type, sp, sp->type);
-		sp->done(vha, sp, 0);
+		sp->done(sp->vha, sp, 0);
 		return;
 	case SRB_CT_PTHRU_CMD:
 		/* borrowing sts_entry_24xx.comp_status.
@@ -1544,7 +1540,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		res = qla2x00_chk_ms_status(vha, (ms_iocb_entry_t *)pkt,
 			(struct ct_sns_rsp *)sp->u.iocb_cmd.u.ctarg.rsp,
 			sp->name);
-		sp->done(vha, sp, res);
+		sp->done(sp->vha, sp, res);
 		return;
 	default:
 		ql_dbg(ql_dbg_user, vha, 0x503e,
@@ -1600,7 +1596,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		bsg_job->reply_len = 0;
 	}
 
-	sp->done(vha, sp, res);
+	sp->done(sp->vha, sp, res);
 }
 
 static void
@@ -1712,7 +1708,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	    le32_to_cpu(logio->io_parameter[1]));
 
 logio_done:
-	sp->done(vha, sp, 0);
+	sp->done(sp->vha, sp, 0);
 }
 
 static void
@@ -1762,7 +1758,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5055,
 		    (uint8_t *)sts, sizeof(*sts));
 
-	sp->done(vha, sp, 0);
+	sp->done(sp->vha, sp, 0);
 }
 
 /**
@@ -1850,7 +1846,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 		     uint32_t sense_len, struct rsp_que *rsp, int res)
 {
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct scsi_cmnd *cp = GET_CMD_SP(sp);
 	uint32_t track_sense_len;
 
@@ -1878,7 +1874,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	if (sense_len) {
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x301c,
 		    "Check condition Sense data, nexus%ld:%d:%llu cmd=%p.\n",
-		    sp->fcport->vha->host_no, cp->device->id, cp->device->lun,
+		    sp->vha->host_no, cp->device->id, cp->device->lun,
 		    cp);
 		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x302b,
 		    cp->sense_buffer, sense_len);
@@ -1900,7 +1896,7 @@ struct scsi_dif_tuple {
 static inline int
 qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 {
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	uint8_t		*ap = &sts24->data[12];
 	uint8_t		*ep = &sts24->data[20];
@@ -2168,7 +2164,7 @@ struct scsi_dif_tuple {
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	/* Always return DID_OK, bsg will send the vendor specific response
 	 * in this case only */
-	sp->done(vha, sp, (DID_OK << 6));
+	sp->done(sp->vha, sp, DID_OK << 6);
 
 }
 
@@ -2541,7 +2537,7 @@ struct scsi_dif_tuple {
 		    resid_len, fw_resid_len, sp, cp);
 
 	if (rsp->status_srb == NULL)
-		sp->done(vha, sp, res);
+		sp->done(sp->vha, sp, res);
 }
 
 /**
@@ -2598,7 +2594,7 @@ struct scsi_dif_tuple {
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(vha, sp, cp->result);
+		sp->done(sp->vha, sp, cp->result);
 	}
 }
 
@@ -2639,7 +2635,7 @@ struct scsi_dif_tuple {
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
-		sp->done(vha, sp, res);
+		sp->done(sp->vha, sp, res);
 		return;
 	}
 fatal:
@@ -2697,7 +2693,7 @@ struct scsi_dif_tuple {
 
 	abt = &sp->u.iocb_cmd;
 	abt->u.abt.comp_status = le32_to_cpu(pkt->nport_handle);
-	sp->done(vha, sp, 0);
+	sp->done(sp->vha, sp, 0);
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 544aff1..01a2243 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -65,6 +65,7 @@
 	uint16_t vp_id;
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags = 0;
+	uint count = 10;
 
 	mutex_lock(&ha->vport_lock);
 	/*
@@ -74,13 +75,14 @@
 	 * ensures no active vp_list traversal while the vport is removed
 	 * from the queue)
 	 */
-	spin_lock_irqsave(&ha->vport_slock, flags);
-	while (atomic_read(&vha->vref_count)) {
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
-
+	while (count-- && atomic_read(&vha->vref_count))
 		msleep(500);
 
-		spin_lock_irqsave(&ha->vport_slock, flags);
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	if (atomic_read(&vha->vref_count)) {
+		ql_dbg(ql_dbg_vport, vha, 0xfffa,
+		    "vha->vref_count=%u timeout\n", vha->vref_count.counter);
+		vha->vref_count = (atomic_t)ATOMIC_INIT(0);
 	}
 	list_del(&vha->list);
 	qlt_update_vp_map(vha, RESET_VP_IDX);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 4eac33e..599b3e8 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1999,7 +1999,7 @@
 		dma_free_coherent(&ha->pdev->dev, fdisc->u.fxiocb.req_len,
 		    fdisc->u.fxiocb.req_addr, fdisc->u.fxiocb.req_dma_handle);
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	return rval;
 }
@@ -2127,7 +2127,7 @@
 qlafx00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 		     uint32_t sense_len, struct rsp_que *rsp, int res)
 {
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct scsi_cmnd *cp = GET_CMD_SP(sp);
 	uint32_t track_sense_len;
 
@@ -2162,7 +2162,7 @@
 	if (sense_len) {
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3039,
 		    "Check condition Sense data, nexus%ld:%d:%llu cmd=%p.\n",
-		    sp->fcport->vha->host_no, cp->device->id, cp->device->lun,
+		    sp->vha->host_no, cp->device->id, cp->device->lun,
 		    cp);
 		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x3049,
 		    cp->sense_buffer, sense_len);
@@ -2181,7 +2181,7 @@
 	    (sstatus & cpu_to_le16((uint16_t)SS_RESPONSE_INFO_LEN_VALID)))
 		cpstatus = cpu_to_le16((uint16_t)CS_INCOMPLETE);
 	tmf->u.tmf.comp_status = cpstatus;
-	sp->done(vha, sp, 0);
+	sp->done(sp->vha, sp, 0);
 }
 
 static void
@@ -2198,7 +2198,7 @@
 
 	abt = &sp->u.iocb_cmd;
 	abt->u.abt.comp_status = pkt->tgt_id_sts;
-	sp->done(vha, sp, 0);
+	sp->done(sp->vha, sp, 0);
 }
 
 static void
@@ -2252,12 +2252,10 @@
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 			sizeof(struct qla_mt_iocb_rsp_fx00) + sizeof(uint8_t);
 
-		ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
-		    sp->fcport->vha, 0x5080,
+		ql_dump_buffer(ql_dbg_user + ql_dbg_verbose, sp->vha, 0x5080,
 		    (uint8_t *)pkt, sizeof(struct ioctl_iocb_entry_fx00));
 
-		ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
-		    sp->fcport->vha, 0x5074,
+		ql_dump_buffer(ql_dbg_user + ql_dbg_verbose, sp->vha, 0x5074,
 		    (uint8_t *)fw_sts_ptr, sizeof(struct qla_mt_iocb_rsp_fx00));
 
 		res = bsg_reply->result = DID_OK << 16;
@@ -2537,7 +2535,7 @@
 		    par_sense_len, rsp_info_len);
 
 	if (rsp->status_srb == NULL)
-		sp->done(vha, sp, res);
+		sp->done(sp->vha, sp, res);
 }
 
 /**
@@ -2614,7 +2612,7 @@
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(vha, sp, cp->result);
+		sp->done(sp->vha, sp, cp->result);
 	}
 }
 
@@ -2695,7 +2693,7 @@
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
-		sp->done(vha, sp, res);
+		sp->done(sp->vha, sp, res);
 		return;
 	}
 
@@ -2997,7 +2995,7 @@
 	cont_a64_entry_t lcont_pkt;
 	cont_a64_entry_t *cont_pkt;
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	req = vha->req;
 
 	cmd = GET_CMD_SP(sp);
@@ -3081,7 +3079,7 @@
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct cmd_type_7_fx00 *cmd_pkt;
 	struct cmd_type_7_fx00 lcmd_pkt;
@@ -3205,7 +3203,7 @@
 qlafx00_tm_iocb(srb_t *sp, struct tsk_mgmt_entry_fx00 *ptm_iocb)
 {
 	struct srb_iocb *fxio = &sp->u.iocb_cmd;
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req = vha->req;
 	struct tsk_mgmt_entry_fx00 tm_iocb;
 	struct scsi_lun llun;
@@ -3232,7 +3230,7 @@
 qlafx00_abort_iocb(srb_t *sp, struct abort_iocb_entry_fx00 *pabt_iocb)
 {
 	struct srb_iocb *fxio = &sp->u.iocb_cmd;
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req = vha->req;
 	struct abort_iocb_entry_fx00 abt_iocb;
 
@@ -3346,8 +3344,7 @@
 					    REQUEST_ENTRY_SIZE);
 					cont_pkt =
 					    qlafx00_prep_cont_type1_iocb(
-						sp->fcport->vha->req,
-						&lcont_pkt);
+						sp->vha->req, &lcont_pkt);
 					cur_dsd = (__le32 *)
 					    lcont_pkt.dseg_0_address;
 					avail_dsds = 5;
@@ -3368,7 +3365,7 @@
 					    &lcont_pkt, REQUEST_ENTRY_SIZE);
 					ql_dump_buffer(
 					    ql_dbg_user + ql_dbg_verbose,
-					    sp->fcport->vha, 0x3042,
+					    sp->vha, 0x3042,
 					    (uint8_t *)&lcont_pkt,
 					     REQUEST_ENTRY_SIZE);
 				}
@@ -3377,7 +3374,7 @@
 				memcpy_toio((void __iomem *)cont_pkt,
 				    &lcont_pkt, REQUEST_ENTRY_SIZE);
 				ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
-				    sp->fcport->vha, 0x3043,
+				    sp->vha, 0x3043,
 				    (uint8_t *)&lcont_pkt, REQUEST_ENTRY_SIZE);
 			}
 		}
@@ -3409,8 +3406,7 @@
 					    REQUEST_ENTRY_SIZE);
 					cont_pkt =
 					    qlafx00_prep_cont_type1_iocb(
-						sp->fcport->vha->req,
-						&lcont_pkt);
+						sp->vha->req, &lcont_pkt);
 					cur_dsd = (__le32 *)
 					    lcont_pkt.dseg_0_address;
 					avail_dsds = 5;
@@ -3431,7 +3427,7 @@
 					    REQUEST_ENTRY_SIZE);
 					ql_dump_buffer(
 					    ql_dbg_user + ql_dbg_verbose,
-					    sp->fcport->vha, 0x3045,
+					    sp->vha, 0x3045,
 					    (uint8_t *)&lcont_pkt,
 					    REQUEST_ENTRY_SIZE);
 				}
@@ -3440,7 +3436,7 @@
 				memcpy_toio((void __iomem *)cont_pkt,
 				    &lcont_pkt, REQUEST_ENTRY_SIZE);
 				ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
-				    sp->fcport->vha, 0x3046,
+				    sp->vha, 0x3046,
 				    (uint8_t *)&lcont_pkt, REQUEST_ENTRY_SIZE);
 			}
 		}
@@ -3452,7 +3448,7 @@
 	}
 
 	ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
-	    sp->fcport->vha, 0x3047,
+	    sp->vha, 0x3047,
 	    (uint8_t *)&fx_iocb, sizeof(struct fxdisc_entry_fx00));
 
 	memcpy_toio((void __iomem *)pfxiocb, &fx_iocb,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b4f4ce0..87dc64a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -617,7 +617,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 {
 	srb_t *sp = (srb_t *)ptr;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct qla_hw_data *ha = sp->vha->hw;
 	void *ctx = GET_CMD_CTX_SP(sp);
 
 	if (sp->flags & SRB_DMA_VALID) {
@@ -656,7 +656,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	}
 
 	CMD_SP(cmd) = NULL;
-	qla2x00_rel_sp(sp->fcport->vha, sp);
+	qla2x00_rel_sp(sp);
 }
 
 void
@@ -669,7 +669,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	cmd->result = res;
 
 	if (atomic_read(&sp->ref_count) == 0) {
-		ql_dbg(ql_dbg_io, sp->fcport->vha, 0x3015,
+		ql_dbg(ql_dbg_io, sp->vha, 0x3015,
 		    "SP reference-count to ZERO -- sp=%p cmd=%p.\n",
 		    sp, GET_CMD_SP(sp));
 		if (ql2xextended_error_logging & ql_dbg_io)
@@ -1238,7 +1238,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	sp->done(vha, sp, 0);
+	sp->done(sp->vha, sp, 0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Did the command return during mailbox execution? */
@@ -1283,7 +1283,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 			continue;
 		if (sp->type != SRB_SCSI_CMD)
 			continue;
-		if (vha->vp_idx != sp->fcport->vha->vp_idx)
+		if (vha->vp_idx != sp->vha->vp_idx)
 			continue;
 		match = 0;
 		cmd = GET_CMD_SP(sp);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a696bbb..54a5337 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -618,7 +618,7 @@ void qla2x00_async_nack_sp_done(void *v, void *s, int res)
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 }
 
 int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
@@ -668,7 +668,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 	return rval;
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp->vha, sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
-- 
1.8.3.1
