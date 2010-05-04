From: giridhar.malavali@qlogic.com
Subject: [PATCH 06/16] qla2xxx: Limit mailbox command contention for ADISC requests.
Date: Tue,  4 May 2010 15:01:26 -0700
Message-ID: <1273010496-43045-7-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47171 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760225Ab0EDWBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:41 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    7 +++
 drivers/scsi/qla2xxx/qla_gbl.h  |    8 ++++
 drivers/scsi/qla2xxx/qla_init.c |   88 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_iocb.c |   39 ++++++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c  |   33 +++++++-------
 drivers/scsi/qla2xxx/qla_os.c   |   31 ++++++++++++-
 6 files changed, 178 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b3cf609..a491338 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -219,6 +219,7 @@ typedef struct srb {
 #define SRB_ELS_CMD_RPT 3
 #define SRB_ELS_CMD_HST 4
 #define SRB_CT_CMD 5
+#define SRB_ADISC_CMD	6
 
 struct srb_ctx {
 	uint16_t type;
@@ -1623,6 +1624,7 @@ typedef struct fc_port {
 #define FCF_FABRIC_DEVICE	BIT_0
 #define FCF_LOGIN_NEEDED	BIT_1
 #define FCF_FCP2_DEVICE		BIT_2
+#define FCF_ASYNC_SENT		BIT_3
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
@@ -2156,6 +2158,8 @@ enum qla_work_type {
 	QLA_EVT_ASYNC_LOGIN_DONE,
 	QLA_EVT_ASYNC_LOGOUT,
 	QLA_EVT_ASYNC_LOGOUT_DONE,
+	QLA_EVT_ASYNC_ADISC,
+	QLA_EVT_ASYNC_ADISC_DONE,
 	QLA_EVT_UEVENT,
 };
 
@@ -2514,6 +2518,9 @@ struct qla_hw_data {
 	dma_addr_t	ex_init_cb_dma;
 	struct ex_init_cb_81xx *ex_init_cb;
 
+	void		*async_pd;
+	dma_addr_t	async_pd_dma;
+
 	/* These are used by mailbox operations. */
 	volatile uint16_t mailbox_out[MAILBOX_REGISTER_COUNT];
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index cff5a4a..03be298 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -56,10 +56,14 @@ extern void qla84xx_put_chip(struct scsi_qla_host *);
 extern int qla2x00_async_login(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_async_logout(struct scsi_qla_host *, fc_port_t *);
+extern int qla2x00_async_adisc(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
 extern int qla2x00_async_login_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_async_logout_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
+extern int qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
 
 extern fc_port_t *
 qla2x00_alloc_fcport(scsi_qla_host_t *, gfp_t );
@@ -97,6 +101,10 @@ extern int qla2x00_post_async_logout_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_post_async_logout_done_work(struct scsi_qla_host *,
     fc_port_t *, uint16_t *);
+extern int qla2x00_post_async_adisc_work(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
+extern int qla2x00_post_async_adisc_done_work(struct scsi_qla_host *,
+    fc_port_t *, uint16_t *);
 extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 
 extern int qla81xx_restart_mpi_firmware(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c3c2c36..4e7a3d5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -119,6 +119,7 @@ qla2x00_async_logio_timeout(srb_t *sp)
 	    "scsi(%ld:%x): Async-%s timeout.\n",
 	    fcport->vha->host_no, sp->handle, lio->ctx.name));
 
+	fcport->flags &= ~FCF_ASYNC_SENT;
 	if (lio->ctx.type == SRB_LOGIN_CMD)
 		qla2x00_post_async_logout_work(fcport->vha, fcport, NULL);
 }
@@ -220,6 +221,56 @@ done:
 	return rval;
 }
 
+static void
+qla2x00_async_adisc_ctx_done(srb_t *sp)
+{
+	struct srb_logio *lio = sp->ctx;
+
+	qla2x00_post_async_adisc_done_work(sp->fcport->vha, sp->fcport,
+	    lio->data);
+	lio->ctx.free(sp);
+}
+
+int
+qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
+    uint16_t *data)
+{
+	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp;
+	struct srb_logio *lio;
+	int rval;
+
+	rval = QLA_FUNCTION_FAILED;
+	sp = qla2x00_get_ctx_sp(vha, fcport, sizeof(struct srb_logio),
+	    ELS_TMO_2_RATOV(ha) + 2);
+	if (!sp)
+		goto done;
+
+	lio = sp->ctx;
+	lio->ctx.type = SRB_ADISC_CMD;
+	lio->ctx.name = "adisc";
+	lio->ctx.timeout = qla2x00_async_logio_timeout;
+	lio->ctx.done = qla2x00_async_adisc_ctx_done;
+	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
+		lio->flags |= SRB_LOGIN_RETRIED;
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	DEBUG2(printk(KERN_DEBUG
+	    "scsi(%ld:%x): Async-adisc - loop-id=%x portid=%02x%02x%02x.\n",
+	    fcport->vha->host_no, sp->handle, fcport->loop_id,
+	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa));
+
+	return rval;
+
+done_free_sp:
+	del_timer_sync(&lio->ctx.timer);
+	lio->ctx.free(sp);
+done:
+	return rval;
+}
+
 int
 qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
@@ -229,15 +280,14 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	switch (data[0]) {
 	case MBS_COMMAND_COMPLETE:
 		if (fcport->flags & FCF_FCP2_DEVICE) {
-			rval = qla2x00_get_port_database(vha, fcport, BIT_1);
-			if (rval != QLA_SUCCESS) {
-				qla2x00_mark_device_lost(vha, fcport, 1, 0);
-				break;
-			}
+			fcport->flags |= FCF_ASYNC_SENT;
+			qla2x00_post_async_adisc_work(vha, fcport, data);
+			break;
 		}
 		qla2x00_update_fcport(vha, fcport);
 		break;
 	case MBS_COMMAND_ERROR:
+		fcport->flags &= ~FCF_ASYNC_SENT;
 		if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		else
@@ -251,6 +301,7 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 		fcport->loop_id++;
 		rval = qla2x00_find_new_loop_id(vha, fcport);
 		if (rval != QLA_SUCCESS) {
+			fcport->flags &= ~FCF_ASYNC_SENT;
 			qla2x00_mark_device_lost(vha, fcport, 1, 0);
 			break;
 		}
@@ -268,6 +319,26 @@ qla2x00_async_logout_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	return QLA_SUCCESS;
 }
 
+int
+qla2x00_async_adisc_done(struct scsi_qla_host *vha, fc_port_t *fcport,
+    uint16_t *data)
+{
+	if (data[0] == MBS_COMMAND_COMPLETE) {
+		qla2x00_update_fcport(vha, fcport);
+
+		return QLA_SUCCESS;
+	}
+
+	/* Retry login. */
+	fcport->flags &= ~FCF_ASYNC_SENT;
+	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+	else
+		qla2x00_mark_device_lost(vha, fcport, 1, 0);
+
+	return QLA_SUCCESS;
+}
+
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
 /****************************************************************************/
@@ -2062,6 +2133,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	if (IS_QLA23XX(ha)) {
 		nv->firmware_options[0] |= BIT_2;
 		nv->firmware_options[0] &= ~BIT_3;
+		nv->firmware_options[0] &= ~BIT_6;
 		nv->add_firmware_options[1] |= BIT_5 | BIT_4;
 
 		if (IS_QLA2300(ha)) {
@@ -2680,7 +2752,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	    PORT_RETRY_TIME;
 	atomic_set(&fcport->port_down_timer, ha->port_down_retry_count *
 	    PORT_RETRY_TIME);
-	fcport->flags &= ~FCF_LOGIN_NEEDED;
+	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 
 	qla2x00_iidma_fcport(vha, fcport);
 
@@ -3326,11 +3398,15 @@ qla2x00_fabric_dev_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 	retry = 0;
 
 	if (IS_ALOGIO_CAPABLE(ha)) {
+		if (fcport->flags & FCF_ASYNC_SENT)
+			return rval;
+		fcport->flags |= FCF_ASYNC_SENT;
 		rval = qla2x00_post_async_login_work(vha, fcport, NULL);
 		if (!rval)
 			return rval;
 	}
 
+	fcport->flags &= ~FCF_ASYNC_SENT;
 	rval = qla2x00_fabric_login(vha, fcport, next_loopid);
 	if (rval == QLA_SUCCESS) {
 		/* Send an ADISC to FCP2 devices.*/
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d792ae3..8112e41 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1054,6 +1054,36 @@ qla2x00_logout_iocb(srb_t *sp, struct mbx_entry *mbx)
 }
 
 static void
+qla24xx_adisc_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+{
+	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
+	logio->control_flags = cpu_to_le16(LCF_COMMAND_ADISC);
+	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	logio->vp_index = sp->fcport->vp_idx;
+}
+
+static void
+qla2x00_adisc_iocb(srb_t *sp, struct mbx_entry *mbx)
+{
+	struct qla_hw_data *ha = sp->fcport->vha->hw;
+
+	mbx->entry_type = MBX_IOCB_TYPE;
+	SET_TARGET_ID(ha, mbx->loop_id, sp->fcport->loop_id);
+	mbx->mb0 = cpu_to_le16(MBC_GET_PORT_DATABASE);
+	if (HAS_EXTENDED_IDS(ha)) {
+		mbx->mb1 = cpu_to_le16(sp->fcport->loop_id);
+		mbx->mb10 = cpu_to_le16(BIT_0);
+	} else {
+		mbx->mb1 = cpu_to_le16((sp->fcport->loop_id << 8) | BIT_0);
+	}
+	mbx->mb2 = cpu_to_le16(MSW(ha->async_pd_dma));
+	mbx->mb3 = cpu_to_le16(LSW(ha->async_pd_dma));
+	mbx->mb6 = cpu_to_le16(MSW(MSD(ha->async_pd_dma)));
+	mbx->mb7 = cpu_to_le16(LSW(MSD(ha->async_pd_dma)));
+	mbx->mb9 = cpu_to_le16(sp->fcport->vp_idx);
+}
+
+static void
 qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
 	struct fc_bsg_job *bsg_job = ((struct srb_bsg*)sp->ctx)->bsg_job;
@@ -1185,12 +1215,12 @@ qla2x00_start_sp(srb_t *sp)
 	switch (ctx->type) {
 	case SRB_LOGIN_CMD:
 		IS_FWI2_CAPABLE(ha) ?
-		    qla24xx_login_iocb(sp, pkt):
+		    qla24xx_login_iocb(sp, pkt) :
 		    qla2x00_login_iocb(sp, pkt);
 		break;
 	case SRB_LOGOUT_CMD:
 		IS_FWI2_CAPABLE(ha) ?
-		    qla24xx_logout_iocb(sp, pkt):
+		    qla24xx_logout_iocb(sp, pkt) :
 		    qla2x00_logout_iocb(sp, pkt);
 		break;
 	case SRB_ELS_CMD_RPT:
@@ -1200,6 +1230,11 @@ qla2x00_start_sp(srb_t *sp)
 	case SRB_CT_CMD:
 		qla24xx_ct_iocb(sp, pkt);
 		break;
+	case SRB_ADISC_CMD:
+		IS_FWI2_CAPABLE(ha) ?
+		    qla24xx_adisc_iocb(sp, pkt) :
+		    qla2x00_adisc_iocb(sp, pkt);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 037bc41..a1968eb 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -899,6 +899,7 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	srb_t *sp;
 	struct srb_logio *lio;
 	uint16_t *data;
+	uint16_t status;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, mbx);
 	if (!sp)
@@ -910,7 +911,9 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	fcport = sp->fcport;
 	data = lio->data;
 
-	data[0] = data[1] = 0;
+	data[0] = MBS_COMMAND_ERROR;
+	data[1] = lio->flags & SRB_LOGIN_RETRIED ?
+	    QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (mbx->entry_status) {
 		DEBUG2(printk(KERN_WARNING
 		    "scsi(%ld:%x): Async-%s error entry - entry-status=%x "
@@ -921,26 +924,27 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    le16_to_cpu(mbx->status_flags)));
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)mbx, sizeof(*mbx)));
 
-		data[0] = MBS_COMMAND_ERROR;
-		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
-		    QLA_LOGIO_LOGIN_RETRIED: 0;
 		goto logio_done;
 	}
 
-	if (!mbx->status && le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE) {
+	status = le16_to_cpu(mbx->status);
+	if (status == 0x30 && lio->ctx.type == SRB_LOGIN_CMD &&
+	    le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE)
+		status = 0;
+	if (!status && le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE) {
 		DEBUG2(printk(KERN_DEBUG
 		    "scsi(%ld:%x): Async-%s complete - mbx1=%x.\n",
 		    fcport->vha->host_no, sp->handle, type,
 		    le16_to_cpu(mbx->mb1)));
 
 		data[0] = MBS_COMMAND_COMPLETE;
-		if (lio->ctx.type == SRB_LOGIN_CMD)
+		if (lio->ctx.type == SRB_LOGIN_CMD) {
 			fcport->port_type = FCT_TARGET;
 			if (le16_to_cpu(mbx->mb1) & BIT_0)
 				fcport->port_type = FCT_INITIATOR;
 			if (le16_to_cpu(mbx->mb1) & BIT_1)
 				fcport->flags |= FCF_FCP2_DEVICE;
-
+		}
 		goto logio_done;
 	}
 
@@ -953,15 +957,13 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		break;
 	default:
 		data[0] = MBS_COMMAND_ERROR;
-		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
-		    QLA_LOGIO_LOGIN_RETRIED: 0;
 		break;
 	}
 
 	DEBUG2(printk(KERN_WARNING
 	    "scsi(%ld:%x): Async-%s failed - status=%x mb0=%x mb1=%x mb2=%x "
 	    "mb6=%x mb7=%x.\n",
-	    fcport->vha->host_no, sp->handle, type, le16_to_cpu(mbx->status),
+	    fcport->vha->host_no, sp->handle, type, status,
 	    le16_to_cpu(mbx->mb0), le16_to_cpu(mbx->mb1),
 	    le16_to_cpu(mbx->mb2), le16_to_cpu(mbx->mb6),
 	    le16_to_cpu(mbx->mb7)));
@@ -1086,7 +1088,9 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	fcport = sp->fcport;
 	data = lio->data;
 
-	data[0] = data[1] = 0;
+	data[0] = MBS_COMMAND_ERROR;
+	data[1] = lio->flags & SRB_LOGIN_RETRIED ?
+		QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (logio->entry_status) {
 		DEBUG2(printk(KERN_WARNING
 		    "scsi(%ld:%x): Async-%s error entry - entry-status=%x.\n",
@@ -1094,9 +1098,6 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    logio->entry_status));
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)logio, sizeof(*logio)));
 
-		data[0] = MBS_COMMAND_ERROR;
-		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
-		    QLA_LOGIO_LOGIN_RETRIED: 0;
 		goto logio_done;
 	}
 
@@ -1107,7 +1108,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    le32_to_cpu(logio->io_parameter[0])));
 
 		data[0] = MBS_COMMAND_COMPLETE;
-		if (lio->ctx.type == SRB_LOGOUT_CMD)
+		if (lio->ctx.type != SRB_LOGIN_CMD)
 			goto logio_done;
 
 		iop[0] = le32_to_cpu(logio->io_parameter[0]);
@@ -1144,8 +1145,6 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		/* Fall through. */
 	default:
 		data[0] = MBS_COMMAND_ERROR;
-		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
-		    QLA_LOGIO_LOGIN_RETRIED: 0;
 		break;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 10c14af..2e083c0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2639,9 +2639,19 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 
 	INIT_LIST_HEAD(&ha->gbl_dsd_list);
 
+	/* Get consistent memory allocated for Async Port-Database. */
+	if (!IS_FWI2_CAPABLE(ha)) {
+		ha->async_pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+			&ha->async_pd_dma);
+		if (!ha->async_pd)
+			goto fail_async_pd;
+	}
+
 	INIT_LIST_HEAD(&ha->vp_list);
 	return 1;
 
+fail_async_pd:
+	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
 fail_ex_init_cb:
 	kfree(ha->npiv_info);
 fail_npiv_info:
@@ -2757,6 +2767,9 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		dma_pool_free(ha->s_dma_pool,
 			ha->ex_init_cb, ha->ex_init_cb_dma);
 
+	if (ha->async_pd)
+		dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_dma);
+
 	if (ha->s_dma_pool)
 		dma_pool_destroy(ha->s_dma_pool);
 
@@ -2809,6 +2822,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->init_cb_dma = 0;
 	ha->ex_init_cb = NULL;
 	ha->ex_init_cb_dma = 0;
+	ha->async_pd = NULL;
+	ha->async_pd_dma = 0;
 
 	ha->s_dma_pool = NULL;
 	ha->dl_dma_pool = NULL;
@@ -2935,6 +2950,8 @@ qla2x00_post_async_work(login, QLA_EVT_ASYNC_LOGIN);
 qla2x00_post_async_work(login_done, QLA_EVT_ASYNC_LOGIN_DONE);
 qla2x00_post_async_work(logout, QLA_EVT_ASYNC_LOGOUT);
 qla2x00_post_async_work(logout_done, QLA_EVT_ASYNC_LOGOUT_DONE);
+qla2x00_post_async_work(adisc, QLA_EVT_ASYNC_ADISC);
+qla2x00_post_async_work(adisc_done, QLA_EVT_ASYNC_ADISC_DONE);
 
 int
 qla2x00_post_uevent_work(struct scsi_qla_host *vha, u32 code)
@@ -3004,6 +3021,14 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 			qla2x00_async_logout_done(vha, e->u.logio.fcport,
 			    e->u.logio.data);
 			break;
+		case QLA_EVT_ASYNC_ADISC:
+			qla2x00_async_adisc(vha, e->u.logio.fcport,
+			    e->u.logio.data);
+			break;
+		case QLA_EVT_ASYNC_ADISC_DONE:
+			qla2x00_async_adisc_done(vha, e->u.logio.fcport,
+			    e->u.logio.data);
+			break;
 		case QLA_EVT_UEVENT:
 			qla2x00_uevent_emit(vha, e->u.uevent.code);
 			break;
@@ -3029,9 +3054,8 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 	 * If the port is not ONLINE then try to login
 	 * to it if we haven't run out of retries.
 	 */
-		if (atomic_read(&fcport->state) !=
-			FCS_ONLINE && fcport->login_retry) {
-
+		if (atomic_read(&fcport->state) != FCS_ONLINE &&
+		    fcport->login_retry && !(fcport->flags & FCF_ASYNC_SENT)) {
 			fcport->login_retry--;
 			if (fcport->flags & FCF_FABRIC_DEVICE) {
 				if (fcport->flags & FCF_FCP2_DEVICE)
@@ -3042,6 +3066,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 							fcport->d_id.b.al_pa);
 
 				if (IS_ALOGIO_CAPABLE(ha)) {
+					fcport->flags |= FCF_ASYNC_SENT;
 					data[0] = 0;
 					data[1] = QLA_LOGIO_LOGIN_RETRIED;
 					status = qla2x00_post_async_login_work(
-- 
1.6.2.rc1.30.gd43c

