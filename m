From: giridhar.malavali@qlogic.com
Subject: [PATCH 09/16] qla2xxx: Support for asynchronous TM and Marker IOCBs.
Date: Tue,  4 May 2010 15:01:29 -0700
Message-ID: <1273010496-43045-10-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47175 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760230Ab0EDWBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:42 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>

From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>

Currently we can only issue the task management (TM)
commands via the mailbox mechanism. This is a limitation,
since only one mailbox command can be issued at a time.
The purpose of this effort is to provide support for
issuing and processing the respose to TM and Marker
IOCBs asynchronously. Towards achieving this, the
consolidated srb architecture that is currently used for
BSG and IOCB/Logio commands has been enhanced and used.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |    4 +
 drivers/scsi/qla2xxx/qla_def.h  |   22 ++++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    7 ++
 drivers/scsi/qla2xxx/qla_init.c |  156 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c |   64 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c  |  102 +++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |   10 +++
 drivers/scsi/qla2xxx/qla_os.c   |    5 +
 8 files changed, 366 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 951db81..b905dfe 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -317,6 +317,9 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	els->type =
 		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
 		SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
+	els->name =
+		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
+		"bsg_els_rpt" : "bsg_els_hst");
 	els->u.bsg_job = bsg_job;
 
 	DEBUG2(qla_printk(KERN_INFO, ha,
@@ -450,6 +453,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 
 	ct = sp->ctx;
 	ct->type = SRB_CT_CMD;
+	ct->name = "bsg_ct";
 	ct->u.bsg_job = bsg_job;
 
 	DEBUG2(qla_printk(KERN_INFO, ha,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 08f5fd5..0d2cecb 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -223,6 +223,26 @@ struct srb_iocb {
 #define SRB_LOGIN_SKIP_PRLI	BIT_2
 			uint16_t data[2];
 		} logio;
+		struct {
+			/*
+			 * Values for flags field below are as
+			 * defined in tsk_mgmt_entry struct
+			 * for control_flags field in qla_fw.h.
+			 */
+			uint32_t flags;
+			uint32_t lun;
+			uint32_t data;
+		} tmf;
+		struct {
+			/*
+			 * values for modif field below are as
+			 * defined in mrk_entry_24xx struct
+			 * for the modifier field in qla_fw.h.
+			 */
+			uint8_t modif;
+			uint16_t lun;
+			uint32_t data;
+		} marker;
 	} u;
 
 	struct timer_list timer;
@@ -239,6 +259,8 @@ struct srb_iocb {
 #define SRB_ELS_CMD_HST 4
 #define SRB_CT_CMD	5
 #define SRB_ADISC_CMD	6
+#define SRB_TM_CMD	7
+#define SRB_MARKER_CMD	8
 
 struct srb_ctx {
 	uint16_t type;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 408e5f0..3dbefe1 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -58,12 +58,18 @@ extern int qla2x00_async_login(struct scsi_qla_host *, fc_port_t *,
 extern int qla2x00_async_logout(struct scsi_qla_host *, fc_port_t *);
 extern int qla2x00_async_adisc(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
+extern int qla2x00_async_tm_cmd(fc_port_t *, uint32_t, uint32_t, uint32_t);
+extern int qla2x00_async_marker(fc_port_t *, uint16_t, uint8_t);
 extern void qla2x00_async_login_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern void qla2x00_async_logout_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern void qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
+extern void qla2x00_async_tm_cmd_done(struct scsi_qla_host *, fc_port_t *,
+	struct srb_iocb *);
+extern void qla2x00_async_marker_done(struct scsi_qla_host *, fc_port_t *,
+	struct srb_iocb *);
 
 extern fc_port_t *
 qla2x00_alloc_fcport(scsi_qla_host_t *, gfp_t );
@@ -87,6 +93,7 @@ extern int ql2xetsenable;
 extern int ql2xshiftctondsd;
 extern int ql2xdbwr;
 extern int ql2xdontresethba;
+extern int ql2xasynctmfenable;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 72b4ef2..e78089d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -125,7 +125,7 @@ done:
 #define ELS_TMO_2_RATOV(ha) ((ha)->r_a_tov / 10 * 2)
 
 static void
-qla2x00_async_logio_timeout(srb_t *sp)
+qla2x00_async_iocb_timeout(srb_t *sp)
 {
 	fc_port_t *fcport = sp->fcport;
 	struct srb_ctx *ctx = sp->ctx;
@@ -170,7 +170,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	ctx->type = SRB_LOGIN_CMD;
 	ctx->name = "login";
 	lio = ctx->u.iocb_cmd;
-	lio->timeout = qla2x00_async_logio_timeout;
+	lio->timeout = qla2x00_async_iocb_timeout;
 	lio->done = qla2x00_async_login_ctx_done;
 	lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
@@ -222,7 +222,7 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	ctx->type = SRB_LOGOUT_CMD;
 	ctx->name = "logout";
 	lio = ctx->u.iocb_cmd;
-	lio->timeout = qla2x00_async_logio_timeout;
+	lio->timeout = qla2x00_async_iocb_timeout;
 	lio->done = qla2x00_async_logout_ctx_done;
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
@@ -271,7 +271,7 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 	ctx->type = SRB_ADISC_CMD;
 	ctx->name = "adisc";
 	lio = ctx->u.iocb_cmd;
-	lio->timeout = qla2x00_async_logio_timeout;
+	lio->timeout = qla2x00_async_iocb_timeout;
 	lio->done = qla2x00_async_adisc_ctx_done;
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
 		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
@@ -292,6 +292,112 @@ done:
 	return rval;
 }
 
+static void
+qla2x00_async_tm_cmd_ctx_done(srb_t *sp)
+{
+	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *iocb = (struct srb_iocb *)ctx->u.iocb_cmd;
+
+	qla2x00_async_tm_cmd_done(sp->fcport->vha, sp->fcport, iocb);
+	iocb->free(sp);
+}
+
+int
+qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
+	uint32_t tag)
+{
+	struct scsi_qla_host *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp;
+	struct srb_ctx *ctx;
+	struct srb_iocb *tcf;
+	int rval;
+
+	rval = QLA_FUNCTION_FAILED;
+	sp = qla2x00_get_ctx_sp(vha, fcport, sizeof(struct srb_ctx),
+	    ELS_TMO_2_RATOV(ha) + 2);
+	if (!sp)
+		goto done;
+
+	ctx = sp->ctx;
+	ctx->type = SRB_TM_CMD;
+	ctx->name = "tmf";
+	tcf = ctx->u.iocb_cmd;
+	tcf->u.tmf.flags = flags;
+	tcf->u.tmf.lun = lun;
+	tcf->u.tmf.data = tag;
+	tcf->timeout = qla2x00_async_iocb_timeout;
+	tcf->done = qla2x00_async_tm_cmd_ctx_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	DEBUG2(printk(KERN_DEBUG
+	    "scsi(%ld:%x): Async-tmf - loop-id=%x portid=%02x%02x%02x.\n",
+	    fcport->vha->host_no, sp->handle, fcport->loop_id,
+	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa));
+
+	return rval;
+
+done_free_sp:
+	tcf->free(sp);
+done:
+	return rval;
+}
+
+static void
+qla2x00_async_marker_ctx_done(srb_t *sp)
+{
+	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *iocb = (struct srb_iocb *)ctx->u.iocb_cmd;
+
+	qla2x00_async_marker_done(sp->fcport->vha, sp->fcport, iocb);
+	iocb->free(sp);
+}
+
+int
+qla2x00_async_marker(fc_port_t *fcport, uint16_t lun, uint8_t modif)
+{
+	struct scsi_qla_host *vha = fcport->vha;
+	srb_t *sp;
+	struct srb_ctx *ctx;
+	struct srb_iocb *mrk;
+	int rval;
+
+	rval = QLA_FUNCTION_FAILED;
+	sp = qla2x00_get_ctx_sp(vha, fcport, sizeof(struct srb_ctx), 0);
+	if (!sp)
+		goto done;
+
+	ctx = sp->ctx;
+	ctx->type = SRB_MARKER_CMD;
+	ctx->name = "marker";
+	mrk = ctx->u.iocb_cmd;
+	mrk->u.marker.lun = lun;
+	mrk->u.marker.modif = modif;
+	mrk->timeout = qla2x00_async_iocb_timeout;
+	mrk->done = qla2x00_async_marker_ctx_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	DEBUG2(printk(KERN_DEBUG
+	    "scsi(%ld:%x): Async-marker - loop-id=%x "
+	    "portid=%02x%02x%02x.\n",
+	    fcport->vha->host_no, sp->handle, fcport->loop_id,
+	    fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa));
+
+	return rval;
+
+done_free_sp:
+	mrk->free(sp);
+done:
+	return rval;
+}
+
 void
 qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
@@ -360,6 +466,48 @@ qla2x00_async_adisc_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	return;
 }
 
+void
+qla2x00_async_tm_cmd_done(struct scsi_qla_host *vha, fc_port_t *fcport,
+    struct srb_iocb *iocb)
+{
+	int rval;
+	uint32_t flags;
+	uint16_t lun;
+
+	flags = iocb->u.tmf.flags;
+	lun = (uint16_t)iocb->u.tmf.lun;
+
+	/* Issue Marker IOCB */
+	rval = qla2x00_async_marker(fcport, lun,
+		flags == TCF_LUN_RESET ? MK_SYNC_ID_LUN : MK_SYNC_ID);
+
+	if ((rval != QLA_SUCCESS) || iocb->u.tmf.data) {
+		DEBUG2_3_11(printk(KERN_WARNING
+			"%s(%ld): TM IOCB failed (%x).\n",
+			__func__, vha->host_no, rval));
+	}
+
+	return;
+}
+
+void
+qla2x00_async_marker_done(struct scsi_qla_host *vha, fc_port_t *fcport,
+    struct srb_iocb *iocb)
+{
+	/*
+	 * Currently we dont have any specific post response processing
+	 * for this IOCB. We'll just return success or failed
+	 * depending on whether the IOCB command succeeded or failed.
+	 */
+	if (iocb->u.tmf.data) {
+		DEBUG2_3_11(printk(KERN_WARNING
+		    "%s(%ld): Marker IOCB failed (%x).\n",
+		    __func__, vha->host_no, iocb->u.tmf.data));
+	}
+
+	return;
+}
+
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
 /****************************************************************************/
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8861b88..d7a9fff 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1086,6 +1086,64 @@ qla2x00_adisc_iocb(srb_t *sp, struct mbx_entry *mbx)
 }
 
 static void
+qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
+{
+	uint32_t flags;
+	unsigned int lun;
+	struct fc_port *fcport = sp->fcport;
+	scsi_qla_host_t *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *iocb = ctx->u.iocb_cmd;
+	struct req_que *req = vha->req;
+
+	flags = iocb->u.tmf.flags;
+	lun = iocb->u.tmf.lun;
+
+	tsk->entry_type = TSK_MGMT_IOCB_TYPE;
+	tsk->entry_count = 1;
+	tsk->handle = MAKE_HANDLE(req->id, tsk->handle);
+	tsk->nport_handle = cpu_to_le16(fcport->loop_id);
+	tsk->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
+	tsk->control_flags = cpu_to_le32(flags);
+	tsk->port_id[0] = fcport->d_id.b.al_pa;
+	tsk->port_id[1] = fcport->d_id.b.area;
+	tsk->port_id[2] = fcport->d_id.b.domain;
+	tsk->vp_index = fcport->vp_idx;
+
+	if (flags == TCF_LUN_RESET) {
+		int_to_scsilun(lun, &tsk->lun);
+		host_to_fcp_swap((uint8_t *)&tsk->lun,
+			sizeof(tsk->lun));
+	}
+}
+
+static void
+qla24xx_marker_iocb(srb_t *sp, struct mrk_entry_24xx *mrk)
+{
+	uint16_t lun;
+	uint8_t modif;
+	struct fc_port *fcport = sp->fcport;
+	scsi_qla_host_t *vha = fcport->vha;
+	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *iocb = ctx->u.iocb_cmd;
+	struct req_que *req = vha->req;
+
+	lun = iocb->u.marker.lun;
+	modif = iocb->u.marker.modif;
+	mrk->entry_type = MARKER_TYPE;
+	mrk->modifier = modif;
+	if (modif !=  MK_SYNC_ALL) {
+		mrk->nport_handle = cpu_to_le16(fcport->loop_id);
+		mrk->lun[1] = LSB(lun);
+		mrk->lun[2] = MSB(lun);
+		host_to_fcp_swap(mrk->lun, sizeof(mrk->lun));
+		mrk->vp_index = vha->vp_idx;
+		mrk->handle = MAKE_HANDLE(req->id, mrk->handle);
+	}
+}
+
+static void
 qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
 	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
@@ -1239,6 +1297,12 @@ qla2x00_start_sp(srb_t *sp)
 		    qla24xx_adisc_iocb(sp, pkt) :
 		    qla2x00_adisc_iocb(sp, pkt);
 		break;
+	case SRB_TM_CMD:
+		qla24xx_tm_iocb(sp, pkt);
+		break;
+	case SRB_MARKER_CMD:
+		qla24xx_marker_iocb(sp, pkt);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 166bb20..eed71ea 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1161,6 +1161,99 @@ logio_done:
 	lio->done(sp);
 }
 
+static void
+qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
+    struct tsk_mgmt_entry *tsk)
+{
+	const char func[] = "TMF-IOCB";
+	const char *type;
+	fc_port_t *fcport;
+	srb_t *sp;
+	struct srb_iocb *iocb;
+	struct srb_ctx *ctx;
+	struct sts_entry_24xx *sts = (struct sts_entry_24xx *)tsk;
+	int error = 1;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, tsk);
+	if (!sp)
+		return;
+
+	ctx = sp->ctx;
+	iocb = ctx->u.iocb_cmd;
+	type = ctx->name;
+	fcport = sp->fcport;
+
+	if (sts->entry_status) {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld:%x): Async-%s error - entry-status(%x).\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    sts->entry_status));
+	} else if (sts->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld:%x): Async-%s error - completion status(%x).\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    sts->comp_status));
+	} else if (!(le16_to_cpu(sts->scsi_status) &
+	    SS_RESPONSE_INFO_LEN_VALID)) {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld:%x): Async-%s error - no response info(%x).\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    sts->scsi_status));
+	} else if (le32_to_cpu(sts->rsp_data_len) < 4) {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld:%x): Async-%s error - not enough response(%d).\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    sts->rsp_data_len));
+	} else if (sts->data[3]) {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld:%x): Async-%s error - response(%x).\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    sts->data[3]));
+	} else {
+		error = 0;
+	}
+
+	if (error) {
+		iocb->u.tmf.data = error;
+		DEBUG2(qla2x00_dump_buffer((uint8_t *)sts, sizeof(*sts)));
+	}
+
+	iocb->done(sp);
+}
+
+static void
+qla24xx_marker_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
+    struct mrk_entry_24xx *mrk)
+{
+	const char func[] = "MRK-IOCB";
+	const char *type;
+	fc_port_t *fcport;
+	srb_t *sp;
+	struct srb_iocb *iocb;
+	struct srb_ctx *ctx;
+	struct sts_entry_24xx *sts = (struct sts_entry_24xx *)mrk;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, mrk);
+	if (!sp)
+		return;
+
+	ctx = sp->ctx;
+	iocb = ctx->u.iocb_cmd;
+	type = ctx->name;
+	fcport = sp->fcport;
+
+	if (sts->entry_status) {
+		iocb->u.marker.data = 1;
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld:%x): Async-%s error entry - entry-status=%x.\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    sts->entry_status));
+		DEBUG2(qla2x00_dump_buffer((uint8_t *)mrk, sizeof(*sts)));
+	}
+
+	iocb->done(sp);
+}
+
 /**
  * qla2x00_process_response_queue() - Process response queue entries.
  * @ha: SCSI driver HA context
@@ -1225,6 +1318,7 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 		case MBX_IOCB_TYPE:
 			qla2x00_mbx_iocb_entry(vha, rsp->req,
 			    (struct mbx_entry *)pkt);
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
@@ -1751,6 +1845,14 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla24xx_logio_entry(vha, rsp->req,
 			    (struct logio_entry_24xx *)pkt);
 			break;
+		case TSK_MGMT_IOCB_TYPE:
+			qla24xx_tm_iocb_entry(vha, rsp->req,
+			    (struct tsk_mgmt_entry *)pkt);
+			break;
+		case MARKER_TYPE:
+			qla24xx_marker_iocb_entry(vha, rsp->req,
+			    (struct mrk_entry_24xx *)pkt);
+			break;
                 case CT_IOCB_TYPE:
 			qla24xx_els_ct_entry(vha, rsp->req, pkt, CT_IOCB_TYPE);
 			clear_bit(MBX_INTERRUPT, &vha->hw->mbx_cmd_flags);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2f30332..f3650d0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2464,12 +2464,22 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 int
 qla24xx_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 {
+	struct qla_hw_data *ha = fcport->vha->hw;
+
+	if ((ql2xasynctmfenable) && IS_FWI2_CAPABLE(ha))
+		return qla2x00_async_tm_cmd(fcport, TCF_TARGET_RESET, l, tag);
+
 	return __qla24xx_issue_tmf("Target", TCF_TARGET_RESET, fcport, l, tag);
 }
 
 int
 qla24xx_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
 {
+	struct qla_hw_data *ha = fcport->vha->hw;
+
+	if ((ql2xasynctmfenable) && IS_FWI2_CAPABLE(ha))
+		return qla2x00_async_tm_cmd(fcport, TCF_LUN_RESET, l, tag);
+
 	return __qla24xx_issue_tmf("Lun", TCF_LUN_RESET, fcport, l, tag);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 70651f9..523d414 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -142,6 +142,11 @@ MODULE_PARM_DESC(ql2xdontresethba,
 	" 1 -- Do not reset on failure.\n");
 
 
+int ql2xasynctmfenable;
+module_param(ql2xasynctmfenable, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xasynctmfenable,
+		"Enables issue of TM IOCBs asynchronously via IOCB mechanism"
+		"Default is 0 - Issue TM IOCBs via mailbox mechanism.");
 /*
  * SCSI host template entry points
  */
-- 
1.6.2.rc1.30.gd43c

