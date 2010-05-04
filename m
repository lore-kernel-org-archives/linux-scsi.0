From: giridhar.malavali@qlogic.com
Subject: [PATCH 05/16] qla2xxx: Further generalization of SRB CTX infrastructure.
Date: Tue,  4 May 2010 15:01:25 -0700
Message-ID: <1273010496-43045-6-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47170 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760171Ab0EDWBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:40 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Prepare CTX infrastructure for additional asynchronous
executions, add generic done() operator, pull CMD definitions.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   17 ++++++---
 drivers/scsi/qla2xxx/qla_init.c |   43 +++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_isr.c  |   74 +++++++++++----------------------------
 3 files changed, 65 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d4a53e5..b3cf609 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -214,14 +214,21 @@ typedef struct srb {
 /*
  * SRB extensions.
  */
-struct srb_ctx {
 #define SRB_LOGIN_CMD	1
 #define SRB_LOGOUT_CMD	2
+#define SRB_ELS_CMD_RPT 3
+#define SRB_ELS_CMD_HST 4
+#define SRB_CT_CMD 5
+
+struct srb_ctx {
 	uint16_t type;
+	char *name;
+
 	struct timer_list timer;
 
-	void (*free)(srb_t *sp);
-	void (*timeout)(srb_t *sp);
+	void (*done)(srb_t *);
+	void (*free)(srb_t *);
+	void (*timeout)(srb_t *);
 };
 
 struct srb_logio {
@@ -231,12 +238,10 @@ struct srb_logio {
 #define SRB_LOGIN_COND_PLOGI	BIT_1
 #define SRB_LOGIN_SKIP_PRLI	BIT_2
 	uint16_t flags;
+	uint16_t data[2];
 };
 
 struct srb_bsg_ctx {
-#define SRB_ELS_CMD_RPT 3
-#define SRB_ELS_CMD_HST 4
-#define SRB_CT_CMD 5
 	uint16_t type;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 55540d2..c3c2c36 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -117,13 +117,22 @@ qla2x00_async_logio_timeout(srb_t *sp)
 
 	DEBUG2(printk(KERN_WARNING
 	    "scsi(%ld:%x): Async-%s timeout.\n",
-	    fcport->vha->host_no, sp->handle,
-	    lio->ctx.type == SRB_LOGIN_CMD ? "login": "logout"));
+	    fcport->vha->host_no, sp->handle, lio->ctx.name));
 
 	if (lio->ctx.type == SRB_LOGIN_CMD)
 		qla2x00_post_async_logout_work(fcport->vha, fcport, NULL);
 }
 
+static void
+qla2x00_async_login_ctx_done(srb_t *sp)
+{
+	struct srb_logio *lio = sp->ctx;
+
+	qla2x00_post_async_login_done_work(sp->fcport->vha, sp->fcport,
+	    lio->data);
+	lio->ctx.free(sp);
+}
+
 int
 qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
@@ -141,7 +150,9 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 
 	lio = sp->ctx;
 	lio->ctx.type = SRB_LOGIN_CMD;
+	lio->ctx.name = "login";
 	lio->ctx.timeout = qla2x00_async_logio_timeout;
+	lio->ctx.done = qla2x00_async_login_ctx_done;
 	lio->flags |= SRB_LOGIN_COND_PLOGI;
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
 		lio->flags |= SRB_LOGIN_RETRIED;
@@ -163,6 +174,16 @@ done:
 	return rval;
 }
 
+static void
+qla2x00_async_logout_ctx_done(srb_t *sp)
+{
+	struct srb_logio *lio = sp->ctx;
+
+	qla2x00_post_async_logout_done_work(sp->fcport->vha, sp->fcport,
+	    lio->data);
+	lio->ctx.free(sp);
+}
+
 int
 qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
@@ -179,7 +200,9 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	lio = sp->ctx;
 	lio->ctx.type = SRB_LOGOUT_CMD;
+	lio->ctx.name = "logout";
 	lio->ctx.timeout = qla2x00_async_logio_timeout;
+	lio->ctx.done = qla2x00_async_logout_ctx_done;
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
@@ -202,17 +225,17 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
 {
 	int rval;
-	uint8_t opts = 0;
 
 	switch (data[0]) {
 	case MBS_COMMAND_COMPLETE:
-		if (fcport->flags & FCF_FCP2_DEVICE)
-			opts |= BIT_1;
-		rval = qla2x00_get_port_database(vha, fcport, opts);
-		if (rval != QLA_SUCCESS)
-			qla2x00_mark_device_lost(vha, fcport, 1, 0);
-		else
-			qla2x00_update_fcport(vha, fcport);
+		if (fcport->flags & FCF_FCP2_DEVICE) {
+			rval = qla2x00_get_port_database(vha, fcport, BIT_1);
+			if (rval != QLA_SUCCESS) {
+				qla2x00_mark_device_lost(vha, fcport, 1, 0);
+				break;
+			}
+		}
+		qla2x00_update_fcport(vha, fcport);
 		break;
 	case MBS_COMMAND_ERROR:
 		if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f1ac62d..037bc41 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -895,34 +895,20 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 {
 	const char func[] = "MBX-IOCB";
 	const char *type;
-	struct qla_hw_data *ha = vha->hw;
 	fc_port_t *fcport;
 	srb_t *sp;
 	struct srb_logio *lio;
-	uint16_t data[2];
+	uint16_t *data;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, mbx);
 	if (!sp)
 		return;
 
-	type = NULL;
 	lio = sp->ctx;
-	switch (lio->ctx.type) {
-	case SRB_LOGIN_CMD:
-		type = "login";
-		break;
-	case SRB_LOGOUT_CMD:
-		type = "logout";
-		break;
-	default:
-		qla_printk(KERN_WARNING, ha,
-		    "%s: Unrecognized SRB: (%p) type=%d.\n", func, sp,
-		    lio->ctx.type);
-		return;
-	}
-
 	del_timer(&lio->ctx.timer);
+	type = lio->ctx.name;
 	fcport = sp->fcport;
+	data = lio->data;
 
 	data[0] = data[1] = 0;
 	if (mbx->entry_status) {
@@ -938,7 +924,7 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		data[0] = MBS_COMMAND_ERROR;
 		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
 		    QLA_LOGIO_LOGIN_RETRIED: 0;
-		goto done_post_logio_done_work;
+		goto logio_done;
 	}
 
 	if (!mbx->status && le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE) {
@@ -948,10 +934,14 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    le16_to_cpu(mbx->mb1)));
 
 		data[0] = MBS_COMMAND_COMPLETE;
-		if (lio->ctx.type == SRB_LOGIN_CMD && le16_to_cpu(mbx->mb1) & BIT_1)
-			fcport->flags |= FCF_FCP2_DEVICE;
+		if (lio->ctx.type == SRB_LOGIN_CMD)
+			fcport->port_type = FCT_TARGET;
+			if (le16_to_cpu(mbx->mb1) & BIT_0)
+				fcport->port_type = FCT_INITIATOR;
+			if (le16_to_cpu(mbx->mb1) & BIT_1)
+				fcport->flags |= FCF_FCP2_DEVICE;
 
-		goto done_post_logio_done_work;
+		goto logio_done;
 	}
 
 	data[0] = le16_to_cpu(mbx->mb0);
@@ -976,12 +966,8 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	    le16_to_cpu(mbx->mb2), le16_to_cpu(mbx->mb6),
 	    le16_to_cpu(mbx->mb7)));
 
-done_post_logio_done_work:
-	lio->ctx.type == SRB_LOGIN_CMD ?
-	    qla2x00_post_async_login_done_work(fcport->vha, fcport, data):
-	    qla2x00_post_async_logout_done_work(fcport->vha, fcport, data);
-
-	lio->ctx.free(sp);
+logio_done:
+	lio->ctx.done(sp);
 }
 
 static void
@@ -1084,35 +1070,21 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 {
 	const char func[] = "LOGIO-IOCB";
 	const char *type;
-	struct qla_hw_data *ha = vha->hw;
 	fc_port_t *fcport;
 	srb_t *sp;
 	struct srb_logio *lio;
-	uint16_t data[2];
+	uint16_t *data;
 	uint32_t iop[2];
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, logio);
 	if (!sp)
 		return;
 
-	type = NULL;
 	lio = sp->ctx;
-	switch (lio->ctx.type) {
-	case SRB_LOGIN_CMD:
-		type = "login";
-		break;
-	case SRB_LOGOUT_CMD:
-		type = "logout";
-		break;
-	default:
-		qla_printk(KERN_WARNING, ha,
-		    "%s: Unrecognized SRB: (%p) type=%d.\n", func, sp,
-		    lio->ctx.type);
-		return;
-	}
-
 	del_timer(&lio->ctx.timer);
+	type = lio->ctx.name;
 	fcport = sp->fcport;
+	data = lio->data;
 
 	data[0] = data[1] = 0;
 	if (logio->entry_status) {
@@ -1125,7 +1097,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		data[0] = MBS_COMMAND_ERROR;
 		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
 		    QLA_LOGIO_LOGIN_RETRIED: 0;
-		goto done_post_logio_done_work;
+		goto logio_done;
 	}
 
 	if (le16_to_cpu(logio->comp_status) == CS_COMPLETE) {
@@ -1136,7 +1108,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 		data[0] = MBS_COMMAND_COMPLETE;
 		if (lio->ctx.type == SRB_LOGOUT_CMD)
-			goto done_post_logio_done_work;
+			goto logio_done;
 
 		iop[0] = le32_to_cpu(logio->io_parameter[0]);
 		if (iop[0] & BIT_4) {
@@ -1151,7 +1123,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		if (logio->io_parameter[9] || logio->io_parameter[10])
 			fcport->supported_classes |= FC_COS_CLASS3;
 
-		goto done_post_logio_done_work;
+		goto logio_done;
 	}
 
 	iop[0] = le32_to_cpu(logio->io_parameter[0]);
@@ -1184,12 +1156,8 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	    le32_to_cpu(logio->io_parameter[0]),
 	    le32_to_cpu(logio->io_parameter[1])));
 
-done_post_logio_done_work:
-	lio->ctx.type == SRB_LOGIN_CMD ?
-	    qla2x00_post_async_login_done_work(fcport->vha, fcport, data):
-	    qla2x00_post_async_logout_done_work(fcport->vha, fcport, data);
-
-	lio->ctx.free(sp);
+logio_done:
+	lio->ctx.done(sp);
 }
 
 /**
-- 
1.6.2.rc1.30.gd43c

