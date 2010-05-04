From: giridhar.malavali@qlogic.com
Subject: [PATCH 08/16] qla2xxx: Provide common framework for BSG and IOCB commands.
Date: Tue,  4 May 2010 15:01:28 -0700
Message-ID: <1273010496-43045-9-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47172 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760227Ab0EDWBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:41 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>

From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>

Currently, BSG and IOCB/Logio commands have a different
framework (srb structs). The purpose of this effort is to
consolidate them into a generalized framework for these
as well as other asynchronous operations in the future.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |   28 ++++----
 drivers/scsi/qla2xxx/qla_def.h  |   48 +++++++-------
 drivers/scsi/qla2xxx/qla_gbl.h  |    6 +-
 drivers/scsi/qla2xxx/qla_init.c |  135 ++++++++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_iocb.c |   24 ++++---
 drivers/scsi/qla2xxx/qla_isr.c  |   50 ++++++++-------
 drivers/scsi/qla2xxx/qla_os.c   |   13 +---
 7 files changed, 162 insertions(+), 142 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 21e5bcd..951db81 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -16,7 +16,7 @@ qla2x00_get_ctx_bsg_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size)
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
-	struct srb_bsg_ctx *ctx;
+	struct srb_ctx *ctx;
 
 	sp = mempool_alloc(ha->srb_mempool, GFP_KERNEL);
 	if (!sp)
@@ -208,7 +208,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	int req_sg_cnt, rsp_sg_cnt;
 	int rval =  (DRIVER_ERROR << 16);
 	uint16_t nextlid = 0;
-	struct srb_bsg *els;
+	struct srb_ctx *els;
 
 	/*  Multiple SG's are not supported for ELS requests */
 	if (bsg_job->request_payload.sg_cnt > 1 ||
@@ -307,17 +307,17 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	}
 
 	/* Alloc SRB structure */
-	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_bsg));
+	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_ctx));
 	if (!sp) {
 		rval = -ENOMEM;
 		goto done_unmap_sg;
 	}
 
 	els = sp->ctx;
-	els->ctx.type =
+	els->type =
 		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
 		SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
-	els->bsg_job = bsg_job;
+	els->u.bsg_job = bsg_job;
 
 	DEBUG2(qla_printk(KERN_INFO, ha,
 		"scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
@@ -361,7 +361,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	uint16_t loop_id;
 	struct fc_port *fcport;
 	char  *type = "FC_BSG_HST_CT";
-	struct srb_bsg *ct;
+	struct srb_ctx *ct;
 
 	/* pass through is supported only for ISP 4Gb or higher */
 	if (!IS_FWI2_CAPABLE(ha)) {
@@ -442,15 +442,15 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	fcport->loop_id = loop_id;
 
 	/* Alloc SRB structure */
-	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_bsg));
+	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_ctx));
 	if (!sp) {
 		rval = -ENOMEM;
 		goto done_free_fcport;
 	}
 
 	ct = sp->ctx;
-	ct->ctx.type = SRB_CT_CMD;
-	ct->bsg_job = bsg_job;
+	ct->type = SRB_CT_CMD;
+	ct->u.bsg_job = bsg_job;
 
 	DEBUG2(qla_printk(KERN_INFO, ha,
 		"scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
@@ -1155,7 +1155,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 	int cnt, que;
 	unsigned long flags;
 	struct req_que *req;
-	struct srb_bsg *sp_bsg;
+	struct srb_ctx *sp_bsg;
 
 	/* find the bsg job from the active list of commands */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1167,11 +1167,11 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
 			sp = req->outstanding_cmds[cnt];
 			if (sp) {
-				sp_bsg = (struct srb_bsg *)sp->ctx;
+				sp_bsg = sp->ctx;
 
-				if (((sp_bsg->ctx.type == SRB_CT_CMD) ||
-					(sp_bsg->ctx.type == SRB_ELS_CMD_HST))
-					&& (sp_bsg->bsg_job == bsg_job)) {
+				if (((sp_bsg->type == SRB_CT_CMD) ||
+					(sp_bsg->type == SRB_ELS_CMD_HST))
+					&& (sp_bsg->u.bsg_job == bsg_job)) {
 					if (ha->isp_ops->abort_command(sp)) {
 						DEBUG2(qla_printk(KERN_INFO, ha,
 						    "scsi(%ld): mbx "
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a491338..08f5fd5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -214,16 +214,16 @@ typedef struct srb {
 /*
  * SRB extensions.
  */
-#define SRB_LOGIN_CMD	1
-#define SRB_LOGOUT_CMD	2
-#define SRB_ELS_CMD_RPT 3
-#define SRB_ELS_CMD_HST 4
-#define SRB_CT_CMD 5
-#define SRB_ADISC_CMD	6
-
-struct srb_ctx {
-	uint16_t type;
-	char *name;
+struct srb_iocb {
+	union {
+		struct {
+			uint16_t flags;
+#define SRB_LOGIN_RETRIED	BIT_0
+#define SRB_LOGIN_COND_PLOGI	BIT_1
+#define SRB_LOGIN_SKIP_PRLI	BIT_2
+			uint16_t data[2];
+		} logio;
+	} u;
 
 	struct timer_list timer;
 
@@ -232,23 +232,21 @@ struct srb_ctx {
 	void (*timeout)(srb_t *);
 };
 
-struct srb_logio {
-	struct srb_ctx ctx;
-
-#define SRB_LOGIN_RETRIED	BIT_0
-#define SRB_LOGIN_COND_PLOGI	BIT_1
-#define SRB_LOGIN_SKIP_PRLI	BIT_2
-	uint16_t flags;
-	uint16_t data[2];
-};
+/* Values for srb_ctx type */
+#define SRB_LOGIN_CMD	1
+#define SRB_LOGOUT_CMD	2
+#define SRB_ELS_CMD_RPT 3
+#define SRB_ELS_CMD_HST 4
+#define SRB_CT_CMD	5
+#define SRB_ADISC_CMD	6
 
-struct srb_bsg_ctx {
+struct srb_ctx {
 	uint16_t type;
-};
-
-struct srb_bsg {
-	struct srb_bsg_ctx ctx;
-	struct fc_bsg_job *bsg_job;
+	char *name;
+	union {
+		struct srb_iocb *iocb_cmd;
+		struct fc_bsg_job *bsg_job;
+	} u;
 };
 
 struct msg_echo_lb {
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 03be298..408e5f0 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -58,11 +58,11 @@ extern int qla2x00_async_login(struct scsi_qla_host *, fc_port_t *,
 extern int qla2x00_async_logout(struct scsi_qla_host *, fc_port_t *);
 extern int qla2x00_async_adisc(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
-extern int qla2x00_async_login_done(struct scsi_qla_host *, fc_port_t *,
+extern void qla2x00_async_login_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
-extern int qla2x00_async_logout_done(struct scsi_qla_host *, fc_port_t *,
+extern void qla2x00_async_logout_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
-extern int qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
+extern void qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 
 extern fc_port_t *
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4e7a3d5..72b4ef2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -48,6 +48,7 @@ qla2x00_ctx_sp_timeout(unsigned long __data)
 {
 	srb_t *sp = (srb_t *)__data;
 	struct srb_ctx *ctx;
+	struct srb_iocb *iocb;
 	fc_port_t *fcport = sp->fcport;
 	struct qla_hw_data *ha = fcport->vha->hw;
 	struct req_que *req;
@@ -57,17 +58,21 @@ qla2x00_ctx_sp_timeout(unsigned long __data)
 	req = ha->req_q_map[0];
 	req->outstanding_cmds[sp->handle] = NULL;
 	ctx = sp->ctx;
-	ctx->timeout(sp);
+	iocb = ctx->u.iocb_cmd;
+	iocb->timeout(sp);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	ctx->free(sp);
+	iocb->free(sp);
 }
 
 void
 qla2x00_ctx_sp_free(srb_t *sp)
 {
 	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *iocb = ctx->u.iocb_cmd;
 
+	del_timer_sync(&iocb->timer);
+	kfree(iocb);
 	kfree(ctx);
 	mempool_free(sp, sp->fcport->vha->hw->srb_mempool);
 }
@@ -79,6 +84,7 @@ qla2x00_get_ctx_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size,
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
 	struct srb_ctx *ctx;
+	struct srb_iocb *iocb;
 
 	sp = mempool_alloc(ha->srb_mempool, GFP_KERNEL);
 	if (!sp)
@@ -86,21 +92,30 @@ qla2x00_get_ctx_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size,
 	ctx = kzalloc(size, GFP_KERNEL);
 	if (!ctx) {
 		mempool_free(sp, ha->srb_mempool);
+		sp = NULL;
+		goto done;
+	}
+	iocb = kzalloc(sizeof(struct srb_iocb), GFP_KERNEL);
+	if (!iocb) {
+		mempool_free(sp, ha->srb_mempool);
+		sp = NULL;
+		kfree(ctx);
 		goto done;
 	}
 
 	memset(sp, 0, sizeof(*sp));
 	sp->fcport = fcport;
 	sp->ctx = ctx;
-	ctx->free = qla2x00_ctx_sp_free;
+	ctx->u.iocb_cmd = iocb;
+	iocb->free = qla2x00_ctx_sp_free;
 
-	init_timer(&ctx->timer);
+	init_timer(&iocb->timer);
 	if (!tmo)
 		goto done;
-	ctx->timer.expires = jiffies + tmo * HZ;
-	ctx->timer.data = (unsigned long)sp;
-	ctx->timer.function = qla2x00_ctx_sp_timeout;
-	add_timer(&ctx->timer);
+	iocb->timer.expires = jiffies + tmo * HZ;
+	iocb->timer.data = (unsigned long)sp;
+	iocb->timer.function = qla2x00_ctx_sp_timeout;
+	add_timer(&iocb->timer);
 done:
 	return sp;
 }
@@ -113,25 +128,26 @@ static void
 qla2x00_async_logio_timeout(srb_t *sp)
 {
 	fc_port_t *fcport = sp->fcport;
-	struct srb_logio *lio = sp->ctx;
+	struct srb_ctx *ctx = sp->ctx;
 
 	DEBUG2(printk(KERN_WARNING
 	    "scsi(%ld:%x): Async-%s timeout.\n",
-	    fcport->vha->host_no, sp->handle, lio->ctx.name));
+	    fcport->vha->host_no, sp->handle, ctx->name));
 
 	fcport->flags &= ~FCF_ASYNC_SENT;
-	if (lio->ctx.type == SRB_LOGIN_CMD)
+	if (ctx->type == SRB_LOGIN_CMD)
 		qla2x00_post_async_logout_work(fcport->vha, fcport, NULL);
 }
 
 static void
 qla2x00_async_login_ctx_done(srb_t *sp)
 {
-	struct srb_logio *lio = sp->ctx;
+	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *lio = ctx->u.iocb_cmd;
 
 	qla2x00_post_async_login_done_work(sp->fcport->vha, sp->fcport,
-	    lio->data);
-	lio->ctx.free(sp);
+		lio->u.logio.data);
+	lio->free(sp);
 }
 
 int
@@ -140,23 +156,25 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 {
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
-	struct srb_logio *lio;
+	struct srb_ctx *ctx;
+	struct srb_iocb *lio;
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
-	sp = qla2x00_get_ctx_sp(vha, fcport, sizeof(struct srb_logio),
+	sp = qla2x00_get_ctx_sp(vha, fcport, sizeof(struct srb_ctx),
 	    ELS_TMO_2_RATOV(ha) + 2);
 	if (!sp)
 		goto done;
 
-	lio = sp->ctx;
-	lio->ctx.type = SRB_LOGIN_CMD;
-	lio->ctx.name = "login";
-	lio->ctx.timeout = qla2x00_async_logio_timeout;
-	lio->ctx.done = qla2x00_async_login_ctx_done;
-	lio->flags |= SRB_LOGIN_COND_PLOGI;
+	ctx = sp->ctx;
+	ctx->type = SRB_LOGIN_CMD;
+	ctx->name = "login";
+	lio = ctx->u.iocb_cmd;
+	lio->timeout = qla2x00_async_logio_timeout;
+	lio->done = qla2x00_async_login_ctx_done;
+	lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
-		lio->flags |= SRB_LOGIN_RETRIED;
+		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
@@ -169,8 +187,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	return rval;
 
 done_free_sp:
-	del_timer_sync(&lio->ctx.timer);
-	lio->ctx.free(sp);
+	lio->free(sp);
 done:
 	return rval;
 }
@@ -178,11 +195,12 @@ done:
 static void
 qla2x00_async_logout_ctx_done(srb_t *sp)
 {
-	struct srb_logio *lio = sp->ctx;
+	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *lio = ctx->u.iocb_cmd;
 
 	qla2x00_post_async_logout_done_work(sp->fcport->vha, sp->fcport,
-	    lio->data);
-	lio->ctx.free(sp);
+	    lio->u.logio.data);
+	lio->free(sp);
 }
 
 int
@@ -190,20 +208,22 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
-	struct srb_logio *lio;
+	struct srb_ctx *ctx;
+	struct srb_iocb *lio;
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
-	sp = qla2x00_get_ctx_sp(vha, fcport, sizeof(struct srb_logio),
+	sp = qla2x00_get_ctx_sp(vha, fcport, sizeof(struct srb_ctx),
 	    ELS_TMO_2_RATOV(ha) + 2);
 	if (!sp)
 		goto done;
 
-	lio = sp->ctx;
-	lio->ctx.type = SRB_LOGOUT_CMD;
-	lio->ctx.name = "logout";
-	lio->ctx.timeout = qla2x00_async_logio_timeout;
-	lio->ctx.done = qla2x00_async_logout_ctx_done;
+	ctx = sp->ctx;
+	ctx->type = SRB_LOGOUT_CMD;
+	ctx->name = "logout";
+	lio = ctx->u.iocb_cmd;
+	lio->timeout = qla2x00_async_logio_timeout;
+	lio->done = qla2x00_async_logout_ctx_done;
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
@@ -215,8 +235,7 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	del_timer_sync(&lio->ctx.timer);
-	lio->ctx.free(sp);
+	lio->free(sp);
 done:
 	return rval;
 }
@@ -224,11 +243,12 @@ done:
 static void
 qla2x00_async_adisc_ctx_done(srb_t *sp)
 {
-	struct srb_logio *lio = sp->ctx;
+	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *lio = ctx->u.iocb_cmd;
 
 	qla2x00_post_async_adisc_done_work(sp->fcport->vha, sp->fcport,
-	    lio->data);
-	lio->ctx.free(sp);
+	    lio->u.logio.data);
+	lio->free(sp);
 }
 
 int
@@ -237,22 +257,24 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 {
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
-	struct srb_logio *lio;
+	struct srb_ctx *ctx;
+	struct srb_iocb *lio;
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
-	sp = qla2x00_get_ctx_sp(vha, fcport, sizeof(struct srb_logio),
+	sp = qla2x00_get_ctx_sp(vha, fcport, sizeof(struct srb_ctx),
 	    ELS_TMO_2_RATOV(ha) + 2);
 	if (!sp)
 		goto done;
 
-	lio = sp->ctx;
-	lio->ctx.type = SRB_ADISC_CMD;
-	lio->ctx.name = "adisc";
-	lio->ctx.timeout = qla2x00_async_logio_timeout;
-	lio->ctx.done = qla2x00_async_adisc_ctx_done;
+	ctx = sp->ctx;
+	ctx->type = SRB_ADISC_CMD;
+	ctx->name = "adisc";
+	lio = ctx->u.iocb_cmd;
+	lio->timeout = qla2x00_async_logio_timeout;
+	lio->done = qla2x00_async_adisc_ctx_done;
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
-		lio->flags |= SRB_LOGIN_RETRIED;
+		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
@@ -265,13 +287,12 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 	return rval;
 
 done_free_sp:
-	del_timer_sync(&lio->ctx.timer);
-	lio->ctx.free(sp);
+	lio->free(sp);
 done:
 	return rval;
 }
 
-int
+void
 qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
 {
@@ -308,25 +329,25 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 		qla2x00_post_async_login_work(vha, fcport, NULL);
 		break;
 	}
-	return QLA_SUCCESS;
+	return;
 }
 
-int
+void
 qla2x00_async_logout_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
 {
 	qla2x00_mark_device_lost(vha, fcport, 1, 0);
-	return QLA_SUCCESS;
+	return;
 }
 
-int
+void
 qla2x00_async_adisc_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
 {
 	if (data[0] == MBS_COMMAND_COMPLETE) {
 		qla2x00_update_fcport(vha, fcport);
 
-		return QLA_SUCCESS;
+		return;
 	}
 
 	/* Retry login. */
@@ -336,7 +357,7 @@ qla2x00_async_adisc_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	else
 		qla2x00_mark_device_lost(vha, fcport, 1, 0);
 
-	return QLA_SUCCESS;
+	return;
 }
 
 /****************************************************************************/
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8112e41..8861b88 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -983,13 +983,14 @@ qla2x00_start_iocbs(srb_t *sp)
 static void
 qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 {
-	struct srb_logio *lio = sp->ctx;
+	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *lio = ctx->u.iocb_cmd;
 
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	logio->control_flags = cpu_to_le16(LCF_COMMAND_PLOGI);
-	if (lio->flags & SRB_LOGIN_COND_PLOGI)
+	if (lio->u.logio.flags & SRB_LOGIN_COND_PLOGI)
 		logio->control_flags |= cpu_to_le16(LCF_COND_PLOGI);
-	if (lio->flags & SRB_LOGIN_SKIP_PRLI)
+	if (lio->u.logio.flags & SRB_LOGIN_SKIP_PRLI)
 		logio->control_flags |= cpu_to_le16(LCF_SKIP_PRLI);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
@@ -1002,14 +1003,15 @@ static void
 qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
 {
 	struct qla_hw_data *ha = sp->fcport->vha->hw;
-	struct srb_logio *lio = sp->ctx;
+	struct srb_ctx *ctx = sp->ctx;
+	struct srb_iocb *lio = ctx->u.iocb_cmd;
 	uint16_t opts;
 
 	mbx->entry_type = MBX_IOCB_TYPE;;
 	SET_TARGET_ID(ha, mbx->loop_id, sp->fcport->loop_id);
 	mbx->mb0 = cpu_to_le16(MBC_LOGIN_FABRIC_PORT);
-	opts = lio->flags & SRB_LOGIN_COND_PLOGI ? BIT_0: 0;
-	opts |= lio->flags & SRB_LOGIN_SKIP_PRLI ? BIT_1: 0;
+	opts = lio->u.logio.flags & SRB_LOGIN_COND_PLOGI ? BIT_0 : 0;
+	opts |= lio->u.logio.flags & SRB_LOGIN_SKIP_PRLI ? BIT_1 : 0;
 	if (HAS_EXTENDED_IDS(ha)) {
 		mbx->mb1 = cpu_to_le16(sp->fcport->loop_id);
 		mbx->mb10 = cpu_to_le16(opts);
@@ -1086,7 +1088,7 @@ qla2x00_adisc_iocb(srb_t *sp, struct mbx_entry *mbx)
 static void
 qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
-	struct fc_bsg_job *bsg_job = ((struct srb_bsg*)sp->ctx)->bsg_job;
+	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
 
         els_iocb->entry_type = ELS_IOCB_TYPE;
         els_iocb->entry_count = 1;
@@ -1099,8 +1101,10 @@ qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
         els_iocb->sof_type = EST_SOFI3;
         els_iocb->rx_dsd_count = __constant_cpu_to_le16(bsg_job->reply_payload.sg_cnt);
 
-        els_iocb->opcode =(((struct srb_bsg*)sp->ctx)->ctx.type == SRB_ELS_CMD_RPT) ?
-	    bsg_job->request->rqst_data.r_els.els_code : bsg_job->request->rqst_data.h_els.command_code;
+	els_iocb->opcode =
+	    (((struct srb_ctx *)sp->ctx)->type == SRB_ELS_CMD_RPT) ?
+	    bsg_job->request->rqst_data.r_els.els_code :
+	    bsg_job->request->rqst_data.h_els.command_code;
         els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
         els_iocb->port_id[1] = sp->fcport->d_id.b.area;
         els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
@@ -1134,7 +1138,7 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 	int index;
 	uint16_t tot_dsds;
         scsi_qla_host_t *vha = sp->fcport->vha;
-	struct fc_bsg_job *bsg_job = ((struct srb_bsg*)sp->ctx)->bsg_job;
+	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
 	int loop_iterartion = 0;
 	int cont_iocb_prsnt = 0;
 	int entry_count = 1;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b92f9a6..166bb20 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -897,7 +897,8 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	const char *type;
 	fc_port_t *fcport;
 	srb_t *sp;
-	struct srb_logio *lio;
+	struct srb_iocb *lio;
+	struct srb_ctx *ctx;
 	uint16_t *data;
 	uint16_t status;
 
@@ -905,14 +906,14 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	if (!sp)
 		return;
 
-	lio = sp->ctx;
-	del_timer(&lio->ctx.timer);
-	type = lio->ctx.name;
+	ctx = sp->ctx;
+	lio = ctx->u.iocb_cmd;
+	type = ctx->name;
 	fcport = sp->fcport;
-	data = lio->data;
+	data = lio->u.logio.data;
 
 	data[0] = MBS_COMMAND_ERROR;
-	data[1] = lio->flags & SRB_LOGIN_RETRIED ?
+	data[1] = lio->u.logio.flags & SRB_LOGIN_RETRIED ?
 	    QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (mbx->entry_status) {
 		DEBUG2(printk(KERN_WARNING
@@ -928,7 +929,7 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	status = le16_to_cpu(mbx->status);
-	if (status == 0x30 && lio->ctx.type == SRB_LOGIN_CMD &&
+	if (status == 0x30 && ctx->type == SRB_LOGIN_CMD &&
 	    le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE)
 		status = 0;
 	if (!status && le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE) {
@@ -938,7 +939,7 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    le16_to_cpu(mbx->mb1)));
 
 		data[0] = MBS_COMMAND_COMPLETE;
-		if (lio->ctx.type == SRB_LOGIN_CMD) {
+		if (ctx->type == SRB_LOGIN_CMD) {
 			fcport->port_type = FCT_TARGET;
 			if (le16_to_cpu(mbx->mb1) & BIT_0)
 				fcport->port_type = FCT_INITIATOR;
@@ -969,7 +970,7 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	    le16_to_cpu(mbx->mb7)));
 
 logio_done:
-	lio->ctx.done(sp);
+	lio->done(sp);
 }
 
 static void
@@ -980,7 +981,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	const char *type;
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
-	struct srb_bsg *sp_bsg;
+	struct srb_ctx *sp_bsg;
 	struct fc_bsg_job *bsg_job;
 	uint16_t comp_status;
 	uint32_t fw_status[3];
@@ -989,11 +990,11 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (!sp)
 		return;
-	sp_bsg = (struct srb_bsg*)sp->ctx;
-	bsg_job = sp_bsg->bsg_job;
+	sp_bsg = sp->ctx;
+	bsg_job = sp_bsg->u.bsg_job;
 
 	type = NULL;
-	switch (sp_bsg->ctx.type) {
+	switch (sp_bsg->type) {
 	case SRB_ELS_CMD_RPT:
 	case SRB_ELS_CMD_HST:
 		type = "els";
@@ -1004,7 +1005,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	default:
 		qla_printk(KERN_WARNING, ha,
 		    "%s: Unrecognized SRB: (%p) type=%d.\n", func, sp,
-		    sp_bsg->ctx.type);
+		    sp_bsg->type);
 		return;
 	}
 
@@ -1058,8 +1059,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	dma_unmap_sg(&ha->pdev->dev,
 	    bsg_job->reply_payload.sg_list,
 	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-	if ((sp_bsg->ctx.type == SRB_ELS_CMD_HST) ||
-	    (sp_bsg->ctx.type == SRB_CT_CMD))
+	if ((sp_bsg->type == SRB_ELS_CMD_HST) ||
+	    (sp_bsg->type == SRB_CT_CMD))
 		kfree(sp->fcport);
 	kfree(sp->ctx);
 	mempool_free(sp, ha->srb_mempool);
@@ -1074,7 +1075,8 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	const char *type;
 	fc_port_t *fcport;
 	srb_t *sp;
-	struct srb_logio *lio;
+	struct srb_iocb *lio;
+	struct srb_ctx *ctx;
 	uint16_t *data;
 	uint32_t iop[2];
 
@@ -1082,14 +1084,14 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	if (!sp)
 		return;
 
-	lio = sp->ctx;
-	del_timer(&lio->ctx.timer);
-	type = lio->ctx.name;
+	ctx = sp->ctx;
+	lio = ctx->u.iocb_cmd;
+	type = ctx->name;
 	fcport = sp->fcport;
-	data = lio->data;
+	data = lio->u.logio.data;
 
 	data[0] = MBS_COMMAND_ERROR;
-	data[1] = lio->flags & SRB_LOGIN_RETRIED ?
+	data[1] = lio->u.logio.flags & SRB_LOGIN_RETRIED ?
 		QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (logio->entry_status) {
 		DEBUG2(printk(KERN_WARNING
@@ -1108,7 +1110,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    le32_to_cpu(logio->io_parameter[0])));
 
 		data[0] = MBS_COMMAND_COMPLETE;
-		if (lio->ctx.type != SRB_LOGIN_CMD)
+		if (ctx->type != SRB_LOGIN_CMD)
 			goto logio_done;
 
 		iop[0] = le32_to_cpu(logio->io_parameter[0]);
@@ -1156,7 +1158,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	    le32_to_cpu(logio->io_parameter[1])));
 
 logio_done:
-	lio->ctx.done(sp);
+	lio->done(sp);
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2e083c0..70651f9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1191,24 +1191,19 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 					ctx = sp->ctx;
 					if (ctx->type == SRB_LOGIN_CMD ||
 					    ctx->type == SRB_LOGOUT_CMD) {
-						del_timer_sync(&ctx->timer);
-						ctx->free(sp);
+						ctx->u.iocb_cmd->free(sp);
 					} else {
-						struct srb_bsg *sp_bsg =
-						    (struct srb_bsg *)sp->ctx;
 						struct fc_bsg_job *bsg_job =
-						    sp_bsg->bsg_job;
-
+						    ctx->u.bsg_job;
 						if (bsg_job->request->msgcode
 						    == FC_BSG_HST_CT)
 							kfree(sp->fcport);
 						bsg_job->req->errors = 0;
 						bsg_job->reply->result = res;
-						bsg_job->job_done(
-						    sp_bsg->bsg_job);
+						bsg_job->job_done(bsg_job);
 						kfree(sp->ctx);
 						mempool_free(sp,
-						    ha->srb_mempool);
+							ha->srb_mempool);
 					}
 				}
 			}
-- 
1.6.2.rc1.30.gd43c

