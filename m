From: giridhar.malavali@qlogic.com
Subject: [PATCH 02/17] qla2xxx: Add portid to async-request messages.
Date: Fri, 28 May 2010 15:08:16 -0700
Message-ID: <1275084511-95266-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52660 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751576Ab0E1WIc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:32 -0400
In-Reply-To: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

This helps to correlate submission/completion messages during
triaging.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 +++-
 drivers/scsi/qla2xxx/qla_isr.c  |   41 +++++++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f1db11a..4bf9734 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -131,8 +131,10 @@ qla2x00_async_iocb_timeout(srb_t *sp)
 	struct srb_ctx *ctx = sp->ctx;
 
 	DEBUG2(printk(KERN_WARNING
-	    "scsi(%ld:%x): Async-%s timeout.\n",
-	    fcport->vha->host_no, sp->handle, ctx->name));
+		"scsi(%ld:%x): Async-%s timeout - portid=%02x%02x%02x.\n",
+		fcport->vha->host_no, sp->handle,
+		ctx->name, fcport->d_id.b.domain,
+		fcport->d_id.b.area, fcport->d_id.b.al_pa));
 
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	if (ctx->type == SRB_LOGIN_CMD)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index be3d8be..bc82ba9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -918,12 +918,15 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	    QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (mbx->entry_status) {
 		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld:%x): Async-%s error entry - entry-status=%x "
-		    "status=%x state-flag=%x status-flags=%x.\n",
+		    "scsi(%ld:%x): Async-%s error entry - portid=%02x%02x%02x "
+		    "entry-status=%x status=%x state-flag=%x "
+		    "status-flags=%x.\n",
 		    fcport->vha->host_no, sp->handle, type,
-		    mbx->entry_status, le16_to_cpu(mbx->status),
-		    le16_to_cpu(mbx->state_flags),
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa, mbx->entry_status,
+		    le16_to_cpu(mbx->status), le16_to_cpu(mbx->state_flags),
 		    le16_to_cpu(mbx->status_flags)));
+
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)mbx, sizeof(*mbx)));
 
 		goto logio_done;
@@ -935,9 +938,11 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		status = 0;
 	if (!status && le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE) {
 		DEBUG2(printk(KERN_DEBUG
-		    "scsi(%ld:%x): Async-%s complete - mbx1=%x.\n",
+		    "scsi(%ld:%x): Async-%s complete - portid=%02x%02x%02x "
+		    "mbx1=%x.\n",
 		    fcport->vha->host_no, sp->handle, type,
-		    le16_to_cpu(mbx->mb1)));
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa, le16_to_cpu(mbx->mb1)));
 
 		data[0] = MBS_COMMAND_COMPLETE;
 		if (ctx->type == SRB_LOGIN_CMD) {
@@ -963,9 +968,10 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	DEBUG2(printk(KERN_WARNING
-	    "scsi(%ld:%x): Async-%s failed - status=%x mb0=%x mb1=%x mb2=%x "
-	    "mb6=%x mb7=%x.\n",
-	    fcport->vha->host_no, sp->handle, type, status,
+	    "scsi(%ld:%x): Async-%s failed - portid=%02x%02x%02x status=%x "
+	    "mb0=%x mb1=%x mb2=%x mb6=%x mb7=%x.\n",
+	    fcport->vha->host_no, sp->handle, type, fcport->d_id.b.domain,
+	    fcport->d_id.b.area, fcport->d_id.b.al_pa, status,
 	    le16_to_cpu(mbx->mb0), le16_to_cpu(mbx->mb1),
 	    le16_to_cpu(mbx->mb2), le16_to_cpu(mbx->mb6),
 	    le16_to_cpu(mbx->mb7)));
@@ -1096,9 +1102,11 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (logio->entry_status) {
 		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld:%x): Async-%s error entry - entry-status=%x.\n",
+		    "scsi(%ld:%x): Async-%s error entry - "
+		    "portid=%02x%02x%02x entry-status=%x.\n",
 		    fcport->vha->host_no, sp->handle, type,
-		    logio->entry_status));
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa, logio->entry_status));
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)logio, sizeof(*logio)));
 
 		goto logio_done;
@@ -1106,8 +1114,11 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 	if (le16_to_cpu(logio->comp_status) == CS_COMPLETE) {
 		DEBUG2(printk(KERN_DEBUG
-		    "scsi(%ld:%x): Async-%s complete - iop0=%x.\n",
+		    "scsi(%ld:%x): Async-%s complete - portid=%02x%02x%02x "
+		    "iop0=%x.\n",
 		    fcport->vha->host_no, sp->handle, type,
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa,
 		    le32_to_cpu(logio->io_parameter[0])));
 
 		data[0] = MBS_COMMAND_COMPLETE;
@@ -1152,8 +1163,10 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	DEBUG2(printk(KERN_WARNING
-	    "scsi(%ld:%x): Async-%s failed - comp=%x iop0=%x iop1=%x.\n",
-	    fcport->vha->host_no, sp->handle, type,
+	    "scsi(%ld:%x): Async-%s failed - portid=%02x%02x%02x comp=%x "
+	    "iop0=%x iop1=%x.\n",
+	    fcport->vha->host_no, sp->handle, type, fcport->d_id.b.domain,
+	    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 	    le16_to_cpu(logio->comp_status),
 	    le32_to_cpu(logio->io_parameter[0]),
 	    le32_to_cpu(logio->io_parameter[1])));
-- 
1.6.2.rc1.30.gd43c

