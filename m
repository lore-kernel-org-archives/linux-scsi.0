From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/2] qla2xxx: Add asynchronous-login support.
Date: Thu, 20 Aug 2009 11:06:05 -0700
Message-ID: <1250791565-285-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1250791565-285-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59438 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755144AbZHTSGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 14:06:06 -0400
In-Reply-To: <1250791565-285-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

ISPs which support this feature include 23xx and above.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   32 +++++
 drivers/scsi/qla2xxx/qla_gbl.h  |   20 +++
 drivers/scsi/qla2xxx/qla_init.c |  215 +++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c |  202 +++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c  |  250 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mid.c  |    2 +
 drivers/scsi/qla2xxx/qla_os.c   |   72 ++++++++++-
 7 files changed, 784 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9eb7be6..efdfb1e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -207,6 +207,28 @@ typedef struct srb {
 #define SRB_DMA_VALID		BIT_0	/* Command sent to ISP */
 
 /*
+ * SRB extensions.
+ */
+struct srb_ctx {
+#define SRB_LOGIN_CMD	1
+#define SRB_LOGOUT_CMD	2
+	uint16_t type;
+	struct timer_list timer;
+
+	void (*free)(srb_t *sp);
+	void (*timeout)(srb_t *sp);
+};
+
+struct srb_logio {
+	struct srb_ctx ctx;
+
+#define SRB_LOGIN_RETRIED	BIT_0
+#define SRB_LOGIN_COND_PLOGI	BIT_1
+#define SRB_LOGIN_SKIP_PRLI	BIT_2
+	uint16_t flags;
+};
+
+/*
  * ISP I/O Register Set structure definitions.
  */
 struct device_reg_2xxx {
@@ -2096,6 +2118,10 @@ struct qla_msix_entry {
 enum qla_work_type {
 	QLA_EVT_AEN,
 	QLA_EVT_IDC_ACK,
+	QLA_EVT_ASYNC_LOGIN,
+	QLA_EVT_ASYNC_LOGIN_DONE,
+	QLA_EVT_ASYNC_LOGOUT,
+	QLA_EVT_ASYNC_LOGOUT_DONE,
 };
 
 
@@ -2114,6 +2140,11 @@ struct qla_work_evt {
 #define QLA_IDC_ACK_REGS	7
 			uint16_t mb[QLA_IDC_ACK_REGS];
 		} idc_ack;
+		struct {
+			struct fc_port *fcport;
+#define QLA_LOGIO_LOGIN_RETRIED	BIT_0
+			u16 data[2];
+		} logio;
 	} u;
 };
 
@@ -2354,6 +2385,7 @@ struct qla_hw_data {
 				(ha)->flags.msix_enabled)
 #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha))
 #define IS_NOCACHE_VPD_TYPE(ha)	(IS_QLA81XX(ha))
+#define IS_ALOGIO_CAPABLE(ha)	(IS_QLA23XX(ha) || IS_FWI2_CAPABLE(ha))
 
 #define IS_IIDMA_CAPABLE(ha)    ((ha)->device_type & DT_IIDMA)
 #define IS_FWI2_CAPABLE(ha)     ((ha)->device_type & DT_FWI2)
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 65b12d8..f3d1d1a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -52,6 +52,14 @@ extern void qla2x00_try_to_stop_firmware(scsi_qla_host_t *);
 
 extern void qla84xx_put_chip(struct scsi_qla_host *);
 
+extern int qla2x00_async_login(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
+extern int qla2x00_async_logout(struct scsi_qla_host *, fc_port_t *);
+extern int qla2x00_async_login_done(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
+extern int qla2x00_async_logout_done(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
+
 /*
  * Global Data in qla_os.c source file.
  */
@@ -76,6 +84,15 @@ extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
 extern int qla2x00_post_aen_work(struct scsi_qla_host *, enum
     fc_host_event_code, u32);
 extern int qla2x00_post_idc_ack_work(struct scsi_qla_host *, uint16_t *);
+extern int qla2x00_post_async_login_work(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
+extern int qla2x00_post_async_login_done_work(struct scsi_qla_host *,
+    fc_port_t *, uint16_t *);
+extern int qla2x00_post_async_logout_work(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
+extern int qla2x00_post_async_logout_done_work(struct scsi_qla_host *,
+    fc_port_t *, uint16_t *);
+
 extern int qla81xx_restart_mpi_firmware(scsi_qla_host_t *);
 
 extern void qla2x00_abort_fcport_cmds(fc_port_t *);
@@ -83,6 +100,8 @@ extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
 	struct qla_hw_data *);
 extern void qla2x00_free_host(struct scsi_qla_host *);
 extern void qla2x00_relogin(struct scsi_qla_host *);
+extern void qla2x00_do_work(struct scsi_qla_host *);
+
 /*
  * Global Functions in qla_mid.c source file.
  */
@@ -135,6 +154,7 @@ int qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
 						uint16_t, uint16_t, uint8_t);
 int __qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
 						uint16_t, uint16_t, uint8_t);
+extern int qla2x00_start_sp(srb_t *);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0cbe39e..37c99a2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -40,6 +40,210 @@ static struct qla_chip_state_84xx *qla84xx_get_chip(struct scsi_qla_host *);
 static int qla84xx_init_chip(scsi_qla_host_t *);
 static int qla25xx_init_queues(struct qla_hw_data *);
 
+/* SRB Extensions ---------------------------------------------------------- */
+
+static void
+qla2x00_ctx_sp_timeout(unsigned long __data)
+{
+	srb_t *sp = (srb_t *)__data;
+	struct srb_ctx *ctx;
+	fc_port_t *fcport = sp->fcport;
+	struct qla_hw_data *ha = fcport->vha->hw;
+	struct req_que *req;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	req = ha->req_q_map[0];
+	req->outstanding_cmds[sp->handle] = NULL;
+	ctx = sp->ctx;
+	ctx->timeout(sp);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	ctx->free(sp);
+}
+
+static void
+qla2x00_ctx_sp_free(srb_t *sp)
+{
+	struct srb_ctx *ctx = sp->ctx;
+
+	kfree(ctx);
+	mempool_free(sp, sp->fcport->vha->hw->srb_mempool);
+}
+
+inline srb_t *
+qla2x00_get_ctx_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size,
+    unsigned long tmo)
+{
+	srb_t *sp;
+	struct qla_hw_data *ha = vha->hw;
+	struct srb_ctx *ctx;
+
+	sp = mempool_alloc(ha->srb_mempool, GFP_KERNEL);
+	if (!sp)
+		goto done;
+	ctx = kzalloc(size, GFP_KERNEL);
+	if (!ctx) {
+		mempool_free(sp, ha->srb_mempool);
+		goto done;
+	}
+
+	memset(sp, 0, sizeof(*sp));
+	sp->fcport = fcport;
+	sp->ctx = ctx;
+	ctx->free = qla2x00_ctx_sp_free;
+
+	init_timer(&ctx->timer);
+	if (!tmo)
+		goto done;
+	ctx->timer.expires = jiffies + tmo * HZ;
+	ctx->timer.data = (unsigned long)sp;
+	ctx->timer.function = qla2x00_ctx_sp_timeout;
+	add_timer(&ctx->timer);
+done:
+	return sp;
+}
+
+/* Asynchronous Login/Logout Routines -------------------------------------- */
+
+#define ELS_TMO_2_RATOV(ha) ((ha)->r_a_tov / 10 * 2)
+
+static void
+qla2x00_async_logio_timeout(srb_t *sp)
+{
+	fc_port_t *fcport = sp->fcport;
+	struct srb_logio *lio = sp->ctx;
+
+	DEBUG2(printk(KERN_WARNING
+	    "scsi(%ld:%x): Async-%s timeout.\n",
+	    fcport->vha->host_no, sp->handle,
+	    lio->ctx.type == SRB_LOGIN_CMD ? "login": "logout"));
+
+	if (lio->ctx.type == SRB_LOGIN_CMD)
+		qla2x00_post_async_logout_work(fcport->vha, fcport, NULL);
+}
+
+int
+qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
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
+	lio->ctx.type = SRB_LOGIN_CMD;
+	lio->ctx.timeout = qla2x00_async_logio_timeout;
+	lio->flags |= SRB_LOGIN_COND_PLOGI;
+	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
+		lio->flags |= SRB_LOGIN_RETRIED;
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	DEBUG2(printk(KERN_DEBUG
+	    "scsi(%ld:%x): Async-login - loop-id=%x portid=%02x%02x%02x "
+	    "retries=%d.\n", fcport->vha->host_no, sp->handle, fcport->loop_id,
+	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa,
+	    fcport->login_retry));
+	return rval;
+
+done_free_sp:
+	del_timer_sync(&lio->ctx.timer);
+	lio->ctx.free(sp);
+done:
+	return rval;
+}
+
+int
+qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
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
+	lio->ctx.type = SRB_LOGOUT_CMD;
+	lio->ctx.timeout = qla2x00_async_logio_timeout;
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	DEBUG2(printk(KERN_DEBUG
+	    "scsi(%ld:%x): Async-logout - loop-id=%x portid=%02x%02x%02x.\n",
+	    fcport->vha->host_no, sp->handle, fcport->loop_id,
+	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa));
+	return rval;
+
+done_free_sp:
+	del_timer_sync(&lio->ctx.timer);
+	lio->ctx.free(sp);
+done:
+	return rval;
+}
+
+int
+qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
+    uint16_t *data)
+{
+	int rval;
+	uint8_t opts = 0;
+
+	switch (data[0]) {
+	case MBS_COMMAND_COMPLETE:
+		if (fcport->flags & FCF_TAPE_PRESENT)
+			opts |= BIT_1;
+		rval = qla2x00_get_port_database(vha, fcport, opts);
+		if (rval != QLA_SUCCESS)
+			qla2x00_mark_device_lost(vha, fcport, 1, 0);
+		else
+			qla2x00_update_fcport(vha, fcport);
+		break;
+	case MBS_COMMAND_ERROR:
+		if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+		else
+			qla2x00_mark_device_lost(vha, fcport, 1, 0);
+		break;
+	case MBS_PORT_ID_USED:
+		fcport->loop_id = data[1];
+		qla2x00_post_async_login_work(vha, fcport, NULL);
+		break;
+	case MBS_LOOP_ID_USED:
+		fcport->loop_id++;
+		rval = qla2x00_find_new_loop_id(vha, fcport);
+		if (rval != QLA_SUCCESS) {
+			qla2x00_mark_device_lost(vha, fcport, 1, 0);
+			break;
+		}
+		qla2x00_post_async_login_work(vha, fcport, NULL);
+		break;
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla2x00_async_logout_done(struct scsi_qla_host *vha, fc_port_t *fcport,
+    uint16_t *data)
+{
+	qla2x00_mark_device_lost(vha, fcport, 1, 0);
+	return QLA_SUCCESS;
+}
+
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
 /****************************************************************************/
@@ -1977,7 +2181,7 @@ qla2x00_rport_del(void *data)
 	struct fc_rport *rport;
 
 	spin_lock_irq(fcport->vha->host->host_lock);
-	rport = fcport->drport;
+	rport = fcport->drport ? fcport->drport: fcport->rport;
 	fcport->drport = NULL;
 	spin_unlock_irq(fcport->vha->host->host_lock);
 	if (rport)
@@ -2344,8 +2548,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct fc_rport *rport;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (fcport->drport)
-		qla2x00_rport_del(fcport);
+	qla2x00_rport_del(fcport);
 
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
@@ -3038,6 +3241,12 @@ qla2x00_fabric_dev_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 	rval = QLA_SUCCESS;
 	retry = 0;
 
+	if (IS_ALOGIO_CAPABLE(ha)) {
+		rval = qla2x00_post_async_login_work(vha, fcport, NULL);
+		if (!rval)
+			return rval;
+	}
+
 	rval = qla2x00_fabric_login(vha, fcport, next_loopid);
 	if (rval == QLA_SUCCESS) {
 		/* Send an ADISC to tape devices.*/
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d37554e..c5ccac0 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -860,3 +860,205 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 	 else
 		*rsp = ha->rsp_q_map[0];
 }
+
+/* Generic Control-SRB manipulation functions. */
+
+static void *
+qla2x00_alloc_iocbs(srb_t *sp)
+{
+	scsi_qla_host_t	*vha = sp->fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
+	uint32_t index, handle;
+	request_t *pkt;
+	uint16_t cnt, req_cnt;
+
+	pkt = NULL;
+	req_cnt = 1;
+
+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+		handle++;
+		if (handle == MAX_OUTSTANDING_COMMANDS)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+	if (index == MAX_OUTSTANDING_COMMANDS)
+		goto queuing_error;
+
+	/* Check for room on request queue. */
+	if (req->cnt < req_cnt) {
+		if (ha->mqenable)
+			cnt = RD_REG_DWORD(&reg->isp25mq.req_q_out);
+		else if (IS_FWI2_CAPABLE(ha))
+			cnt = RD_REG_DWORD(&reg->isp24.req_q_out);
+		else
+			cnt = qla2x00_debounce_register(
+			    ISP_REQ_Q_OUT(ha, &reg->isp));
+
+		if  (req->ring_index < cnt)
+			req->cnt = cnt - req->ring_index;
+		else
+			req->cnt = req->length -
+			    (req->ring_index - cnt);
+	}
+	if (req->cnt < req_cnt)
+		goto queuing_error;
+
+	/* Prep packet */
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = sp;
+	req->cnt -= req_cnt;
+
+	pkt = req->ring_ptr;
+	memset(pkt, 0, REQUEST_ENTRY_SIZE);
+	pkt->entry_count = req_cnt;
+	pkt->handle = handle;
+	sp->handle = handle;
+
+queuing_error:
+	return pkt;
+}
+
+static void
+qla2x00_start_iocbs(srb_t *sp)
+{
+	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
+	struct device_reg_2xxx __iomem *ioreg = &ha->iobase->isp;
+
+	/* Adjust ring index. */
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
+	} else
+		req->ring_ptr++;
+
+	/* Set chip new ring index. */
+	if (ha->mqenable) {
+		WRT_REG_DWORD(&reg->isp25mq.req_q_in, req->ring_index);
+		RD_REG_DWORD(&ioreg->hccr);
+	} else if (IS_FWI2_CAPABLE(ha)) {
+		WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
+		RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
+	} else {
+		WRT_REG_WORD(ISP_REQ_Q_IN(ha, &reg->isp), req->ring_index);
+		RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, &reg->isp));
+	}
+}
+
+static void
+qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+{
+	struct srb_logio *lio = sp->ctx;
+
+	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
+	logio->control_flags = cpu_to_le16(LCF_COMMAND_PLOGI);
+	if (lio->flags & SRB_LOGIN_COND_PLOGI)
+		logio->control_flags |= cpu_to_le16(LCF_COND_PLOGI);
+	if (lio->flags & SRB_LOGIN_SKIP_PRLI)
+		logio->control_flags |= cpu_to_le16(LCF_SKIP_PRLI);
+	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
+	logio->port_id[1] = sp->fcport->d_id.b.area;
+	logio->port_id[2] = sp->fcport->d_id.b.domain;
+	logio->vp_index = sp->fcport->vp_idx;
+}
+
+static void
+qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
+{
+	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct srb_logio *lio = sp->ctx;
+	uint16_t opts;
+
+	mbx->entry_type = MBX_IOCB_TYPE;;
+	SET_TARGET_ID(ha, mbx->loop_id, sp->fcport->loop_id);
+	mbx->mb0 = cpu_to_le16(MBC_LOGIN_FABRIC_PORT);
+	opts = lio->flags & SRB_LOGIN_COND_PLOGI ? BIT_0: 0;
+	opts |= lio->flags & SRB_LOGIN_SKIP_PRLI ? BIT_1: 0;
+	if (HAS_EXTENDED_IDS(ha)) {
+		mbx->mb1 = cpu_to_le16(sp->fcport->loop_id);
+		mbx->mb10 = cpu_to_le16(opts);
+	} else {
+		mbx->mb1 = cpu_to_le16((sp->fcport->loop_id << 8) | opts);
+	}
+	mbx->mb2 = cpu_to_le16(sp->fcport->d_id.b.domain);
+	mbx->mb3 = cpu_to_le16(sp->fcport->d_id.b.area << 8 |
+	    sp->fcport->d_id.b.al_pa);
+	mbx->mb9 = cpu_to_le16(sp->fcport->vp_idx);
+}
+
+static void
+qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+{
+	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
+	logio->control_flags =
+	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
+	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
+	logio->port_id[1] = sp->fcport->d_id.b.area;
+	logio->port_id[2] = sp->fcport->d_id.b.domain;
+	logio->vp_index = sp->fcport->vp_idx;
+}
+
+static void
+qla2x00_logout_iocb(srb_t *sp, struct mbx_entry *mbx)
+{
+	struct qla_hw_data *ha = sp->fcport->vha->hw;
+
+	mbx->entry_type = MBX_IOCB_TYPE;;
+	SET_TARGET_ID(ha, mbx->loop_id, sp->fcport->loop_id);
+	mbx->mb0 = cpu_to_le16(MBC_LOGOUT_FABRIC_PORT);
+	mbx->mb1 = HAS_EXTENDED_IDS(ha) ?
+	    cpu_to_le16(sp->fcport->loop_id):
+	    cpu_to_le16(sp->fcport->loop_id << 8);
+	mbx->mb2 = cpu_to_le16(sp->fcport->d_id.b.domain);
+	mbx->mb3 = cpu_to_le16(sp->fcport->d_id.b.area << 8 |
+	    sp->fcport->d_id.b.al_pa);
+	mbx->mb9 = cpu_to_le16(sp->fcport->vp_idx);
+	/* Implicit: mbx->mbx10 = 0. */
+}
+
+int
+qla2x00_start_sp(srb_t *sp)
+{
+	int rval;
+	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	void *pkt;
+	struct srb_ctx *ctx = sp->ctx;
+	unsigned long flags;
+
+	rval = QLA_FUNCTION_FAILED;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	pkt = qla2x00_alloc_iocbs(sp);
+	if (!pkt)
+		goto done;
+
+	rval = QLA_SUCCESS;
+	switch (ctx->type) {
+	case SRB_LOGIN_CMD:
+		IS_FWI2_CAPABLE(ha) ?
+		    qla24xx_login_iocb(sp, pkt):
+		    qla2x00_login_iocb(sp, pkt);
+		break;
+	case SRB_LOGOUT_CMD:
+		IS_FWI2_CAPABLE(ha) ?
+		    qla24xx_logout_iocb(sp, pkt):
+		    qla2x00_logout_iocb(sp, pkt);
+		break;
+	default:
+		break;
+	}
+
+	wmb();
+	qla2x00_start_iocbs(sp);
+done:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 74fa6f9..c0fec69 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -919,6 +919,249 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 	}
 }
 
+static srb_t *
+qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
+    struct req_que *req, void *iocb)
+{
+	struct qla_hw_data *ha = vha->hw;
+	sts_entry_t *pkt = iocb;
+	srb_t *sp = NULL;
+	uint16_t index;
+
+	index = LSW(pkt->handle);
+	if (index >= MAX_OUTSTANDING_COMMANDS) {
+		qla_printk(KERN_WARNING, ha,
+		    "%s: Invalid completion handle (%x).\n", func, index);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		goto done;
+	}
+	sp = req->outstanding_cmds[index];
+	if (!sp) {
+		qla_printk(KERN_WARNING, ha,
+		    "%s: Invalid completion handle (%x) -- timed-out.\n", func,
+		    index);
+		return sp;
+	}
+	if (sp->handle != index) {
+		qla_printk(KERN_WARNING, ha,
+		    "%s: SRB handle (%x) mismatch %x.\n", func, sp->handle,
+		    index);
+		return NULL;
+	}
+	req->outstanding_cmds[index] = NULL;
+done:
+	return sp;
+}
+
+static void
+qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
+    struct mbx_entry *mbx)
+{
+	const char func[] = "MBX-IOCB";
+	const char *type;
+	struct qla_hw_data *ha = vha->hw;
+	fc_port_t *fcport;
+	srb_t *sp;
+	struct srb_logio *lio;
+	uint16_t data[2];
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, mbx);
+	if (!sp)
+		return;
+
+	type = NULL;
+	lio = sp->ctx;
+	switch (lio->ctx.type) {
+	case SRB_LOGIN_CMD:
+		type = "login";
+		break;
+	case SRB_LOGOUT_CMD:
+		type = "logout";
+		break;
+	default:
+		qla_printk(KERN_WARNING, ha,
+		    "%s: Unrecognized SRB: (%p) type=%d.\n", func, sp,
+		    lio->ctx.type);
+		return;
+	}
+
+	del_timer(&lio->ctx.timer);
+	fcport = sp->fcport;
+
+	data[0] = data[1] = 0;
+	if (mbx->entry_status) {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld:%x): Async-%s error entry - entry-status=%x "
+		    "status=%x state-flag=%x status-flags=%x.\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    mbx->entry_status, le16_to_cpu(mbx->status),
+		    le16_to_cpu(mbx->state_flags),
+		    le16_to_cpu(mbx->status_flags)));
+		DEBUG2(qla2x00_dump_buffer((uint8_t *)mbx, sizeof(*mbx)));
+
+		data[0] = MBS_COMMAND_ERROR;
+		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
+		    QLA_LOGIO_LOGIN_RETRIED: 0;
+		goto done_post_logio_done_work;
+	}
+
+	if (!mbx->status && le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE) {
+		DEBUG2(printk(KERN_DEBUG
+		    "scsi(%ld:%x): Async-%s complete - mbx1=%x.\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    le16_to_cpu(mbx->mb1)));
+
+		data[0] = MBS_COMMAND_COMPLETE;
+		if (lio->ctx.type == SRB_LOGIN_CMD && le16_to_cpu(mbx->mb1) & BIT_1)
+			fcport->flags |= FCF_TAPE_PRESENT;
+
+		goto done_post_logio_done_work;
+	}
+
+	data[0] = le16_to_cpu(mbx->mb0);
+	switch (data[0]) {
+	case MBS_PORT_ID_USED:
+		data[1] = le16_to_cpu(mbx->mb1);
+		break;
+	case MBS_LOOP_ID_USED:
+		break;
+	default:
+		data[0] = MBS_COMMAND_ERROR;
+		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
+		    QLA_LOGIO_LOGIN_RETRIED: 0;
+		break;
+	}
+
+	DEBUG2(printk(KERN_WARNING
+	    "scsi(%ld:%x): Async-%s failed - status=%x mb0=%x mb1=%x mb2=%x "
+	    "mb6=%x mb7=%x.\n",
+	    fcport->vha->host_no, sp->handle, type, le16_to_cpu(mbx->status),
+	    le16_to_cpu(mbx->mb0), le16_to_cpu(mbx->mb1),
+	    le16_to_cpu(mbx->mb2), le16_to_cpu(mbx->mb6),
+	    le16_to_cpu(mbx->mb7)));
+
+done_post_logio_done_work:
+	lio->ctx.type == SRB_LOGIN_CMD ?
+	    qla2x00_post_async_login_done_work(fcport->vha, fcport, data):
+	    qla2x00_post_async_logout_done_work(fcport->vha, fcport, data);
+
+	lio->ctx.free(sp);
+}
+
+static void
+qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
+    struct logio_entry_24xx *logio)
+{
+	const char func[] = "LOGIO-IOCB";
+	const char *type;
+	struct qla_hw_data *ha = vha->hw;
+	fc_port_t *fcport;
+	srb_t *sp;
+	struct srb_logio *lio;
+	uint16_t data[2];
+	uint32_t iop[2];
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, logio);
+	if (!sp)
+		return;
+
+	type = NULL;
+	lio = sp->ctx;
+	switch (lio->ctx.type) {
+	case SRB_LOGIN_CMD:
+		type = "login";
+		break;
+	case SRB_LOGOUT_CMD:
+		type = "logout";
+		break;
+	default:
+		qla_printk(KERN_WARNING, ha,
+		    "%s: Unrecognized SRB: (%p) type=%d.\n", func, sp,
+		    lio->ctx.type);
+		return;
+	}
+
+	del_timer(&lio->ctx.timer);
+	fcport = sp->fcport;
+
+	data[0] = data[1] = 0;
+	if (logio->entry_status) {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld:%x): Async-%s error entry - entry-status=%x.\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    logio->entry_status));
+		DEBUG2(qla2x00_dump_buffer((uint8_t *)logio, sizeof(*logio)));
+
+		data[0] = MBS_COMMAND_ERROR;
+		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
+		    QLA_LOGIO_LOGIN_RETRIED: 0;
+		goto done_post_logio_done_work;
+	}
+
+	if (le16_to_cpu(logio->comp_status) == CS_COMPLETE) {
+		DEBUG2(printk(KERN_DEBUG
+		    "scsi(%ld:%x): Async-%s complete - iop0=%x.\n",
+		    fcport->vha->host_no, sp->handle, type,
+		    le32_to_cpu(logio->io_parameter[0])));
+
+		data[0] = MBS_COMMAND_COMPLETE;
+		if (lio->ctx.type == SRB_LOGOUT_CMD)
+			goto done_post_logio_done_work;
+
+		iop[0] = le32_to_cpu(logio->io_parameter[0]);
+		if (iop[0] & BIT_4) {
+			fcport->port_type = FCT_TARGET;
+			if (iop[0] & BIT_8)
+				fcport->flags |= FCF_TAPE_PRESENT;
+		}
+		if (iop[0] & BIT_5)
+			fcport->port_type = FCT_INITIATOR;
+		if (logio->io_parameter[7] || logio->io_parameter[8])
+			fcport->supported_classes |= FC_COS_CLASS2;
+		if (logio->io_parameter[9] || logio->io_parameter[10])
+			fcport->supported_classes |= FC_COS_CLASS3;
+
+		goto done_post_logio_done_work;
+	}
+
+	iop[0] = le32_to_cpu(logio->io_parameter[0]);
+	iop[1] = le32_to_cpu(logio->io_parameter[1]);
+	switch (iop[0]) {
+	case LSC_SCODE_PORTID_USED:
+		data[0] = MBS_PORT_ID_USED;
+		data[1] = LSW(iop[1]);
+		break;
+	case LSC_SCODE_NPORT_USED:
+		data[0] = MBS_LOOP_ID_USED;
+		break;
+	case LSC_SCODE_CMD_FAILED:
+		if ((iop[1] & 0xff) == 0x05) {
+			data[0] = MBS_NOT_LOGGED_IN;
+			break;
+		}
+		/* Fall through. */
+	default:
+		data[0] = MBS_COMMAND_ERROR;
+		data[1] = lio->flags & SRB_LOGIN_RETRIED ?
+		    QLA_LOGIO_LOGIN_RETRIED: 0;
+		break;
+	}
+
+	DEBUG2(printk(KERN_WARNING
+	    "scsi(%ld:%x): Async-%s failed - comp=%x iop0=%x iop1=%x.\n",
+	    fcport->vha->host_no, sp->handle, type,
+	    le16_to_cpu(logio->comp_status),
+	    le32_to_cpu(logio->io_parameter[0]),
+	    le32_to_cpu(logio->io_parameter[1])));
+
+done_post_logio_done_work:
+	lio->ctx.type == SRB_LOGIN_CMD ?
+	    qla2x00_post_async_login_done_work(fcport->vha, fcport, data):
+	    qla2x00_post_async_logout_done_work(fcport->vha, fcport, data);
+
+	lio->ctx.free(sp);
+}
+
 /**
  * qla2x00_process_response_queue() - Process response queue entries.
  * @ha: SCSI driver HA context
@@ -980,6 +1223,9 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 		case STATUS_CONT_TYPE:
 			qla2x00_status_cont_entry(rsp, (sts_cont_entry_t *)pkt);
 			break;
+		case MBX_IOCB_TYPE:
+			qla2x00_mbx_iocb_entry(vha, rsp->req,
+			    (struct mbx_entry *)pkt);
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
@@ -1590,6 +1836,10 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla24xx_report_id_acquisition(vha,
 			    (struct vp_rpt_id_entry_24xx *)pkt);
 			break;
+		case LOGINOUT_PORT_IOCB_TYPE:
+			qla24xx_logio_entry(vha, rsp->req,
+			    (struct logio_entry_24xx *)pkt);
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 6238be3..a748a95 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -253,6 +253,8 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 	if (!(ha->current_topology & ISP_CFG_F))
 		return 0;
 
+	qla2x00_do_work(vha);
+
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
 		/* VP acquired. complete port configuration */
 		if (atomic_read(&base_vha->loop_state) == LOOP_READY) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b6c088c..5fd7adb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1170,6 +1170,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 	int que, cnt;
 	unsigned long flags;
 	srb_t *sp;
+	struct srb_ctx *ctx;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
 
@@ -1182,8 +1183,14 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 			sp = req->outstanding_cmds[cnt];
 			if (sp) {
 				req->outstanding_cmds[cnt] = NULL;
-				sp->cmd->result = res;
-				qla2x00_sp_compl(ha, sp);
+				if (!sp->ctx) {
+					sp->cmd->result = res;
+					qla2x00_sp_compl(ha, sp);
+				} else {
+					ctx = sp->ctx;
+					del_timer_sync(&ctx->timer);
+					ctx->free(sp);
+				}
 			}
 		}
 	}
@@ -2618,7 +2625,31 @@ qla2x00_post_idc_ack_work(struct scsi_qla_host *vha, uint16_t *mb)
 	return qla2x00_post_work(vha, e);
 }
 
-static void
+#define qla2x00_post_async_work(name, type)	\
+int qla2x00_post_async_##name##_work(		\
+    struct scsi_qla_host *vha,			\
+    fc_port_t *fcport, uint16_t *data)		\
+{						\
+	struct qla_work_evt *e;			\
+						\
+	e = qla2x00_alloc_work(vha, type);	\
+	if (!e)					\
+		return QLA_FUNCTION_FAILED;	\
+						\
+	e->u.logio.fcport = fcport;		\
+	if (data) {				\
+		e->u.logio.data[0] = data[0];	\
+		e->u.logio.data[1] = data[1];	\
+	}					\
+	return qla2x00_post_work(vha, e);	\
+}
+
+qla2x00_post_async_work(login, QLA_EVT_ASYNC_LOGIN);
+qla2x00_post_async_work(login_done, QLA_EVT_ASYNC_LOGIN_DONE);
+qla2x00_post_async_work(logout, QLA_EVT_ASYNC_LOGOUT);
+qla2x00_post_async_work(logout_done, QLA_EVT_ASYNC_LOGOUT_DONE);
+
+void
 qla2x00_do_work(struct scsi_qla_host *vha)
 {
 	struct qla_work_evt *e, *tmp;
@@ -2640,6 +2671,21 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 		case QLA_EVT_IDC_ACK:
 			qla81xx_idc_ack(vha, e->u.idc_ack.mb);
 			break;
+		case QLA_EVT_ASYNC_LOGIN:
+			qla2x00_async_login(vha, e->u.logio.fcport,
+			    e->u.logio.data);
+			break;
+		case QLA_EVT_ASYNC_LOGIN_DONE:
+			qla2x00_async_login_done(vha, e->u.logio.fcport,
+			    e->u.logio.data);
+			break;
+		case QLA_EVT_ASYNC_LOGOUT:
+			qla2x00_async_logout(vha, e->u.logio.fcport);
+			break;
+		case QLA_EVT_ASYNC_LOGOUT_DONE:
+			qla2x00_async_logout_done(vha, e->u.logio.fcport,
+			    e->u.logio.data);
+			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
@@ -2655,6 +2701,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 	int status;
 	uint16_t        next_loopid = 0;
 	struct qla_hw_data *ha = vha->hw;
+	uint16_t data[2];
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 	/*
@@ -2664,6 +2711,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 		if (atomic_read(&fcport->state) !=
 			FCS_ONLINE && fcport->login_retry) {
 
+			fcport->login_retry--;
 			if (fcport->flags & FCF_FABRIC_DEVICE) {
 				if (fcport->flags & FCF_TAPE_PRESENT)
 					ha->isp_ops->fabric_logout(vha,
@@ -2672,13 +2720,22 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 							fcport->d_id.b.area,
 							fcport->d_id.b.al_pa);
 
-				status = qla2x00_fabric_login(vha, fcport,
-							&next_loopid);
+				if (IS_ALOGIO_CAPABLE(ha)) {
+					data[0] = 0;
+					data[1] = QLA_LOGIO_LOGIN_RETRIED;
+					status = qla2x00_post_async_login_work(
+					    vha, fcport, data);
+					if (status == QLA_SUCCESS)
+						continue;
+					/* Attempt a retry. */
+					status = 1;
+				} else
+					status = qla2x00_fabric_login(vha,
+					    fcport, &next_loopid);
 			} else
 				status = qla2x00_local_device_login(vha,
 								fcport);
 
-			fcport->login_retry--;
 			if (status == QLA_SUCCESS) {
 				fcport->old_loop_id = fcport->loop_id;
 
@@ -2851,6 +2908,9 @@ qla2x00_do_dpc(void *data)
 	 */
 	ha->dpc_active = 0;
 
+	/* Cleanup any residual CTX SRBs. */
+	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
+
 	return 0;
 }
 
-- 
1.6.2.rc1.30.gd43c

