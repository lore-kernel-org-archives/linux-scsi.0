From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 23/23] qla2xxx: Add IOCB Abort command asynchronous handling.
Date: Wed, 26 Feb 2014 04:15:18 -0500
Message-ID: <1393406118-6586-24-git-send-email-saurav.kashyap@qlogic.com>
References: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:32507 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbaBZJuu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 04:50:50 -0500
In-Reply-To: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Send aborts to the firmware via the request/response queue mechanism.

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |   88 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c |   27 +++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c  |   21 +++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |    3 +
 drivers/scsi/qla2xxx/qla_mr.c   |   88 ---------------------------------------
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 7 files changed, 140 insertions(+), 91 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index dcd084a..e665e81 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -330,6 +330,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
     dma_addr_t);
 
 extern int qla24xx_abort_command(srb_t *);
+extern int qla24xx_async_abort_command(srb_t *);
 extern int
 qla24xx_abort_target(struct fc_port *, unsigned int, int);
 extern int
@@ -604,7 +605,6 @@ extern char *qlafx00_fw_version_str(struct scsi_qla_host *, char *);
 extern irqreturn_t qlafx00_intr_handler(int, void *);
 extern void qlafx00_enable_intrs(struct qla_hw_data *);
 extern void qlafx00_disable_intrs(struct qla_hw_data *);
-extern int qlafx00_abort_command(srb_t *);
 extern int qlafx00_abort_target(fc_port_t *, unsigned int, int);
 extern int qlafx00_lun_reset(fc_port_t *, unsigned int, int);
 extern int qlafx00_start_scsi(srb_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2724842..0a25e8b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -347,6 +347,94 @@ done:
 	return rval;
 }
 
+static void
+qla24xx_abort_iocb_timeout(void *data)
+{
+	srb_t *sp = (srb_t *)data;
+	struct srb_iocb *abt = &sp->u.iocb_cmd;
+
+	abt->u.abt.comp_status = CS_TIMEOUT;
+	complete(&abt->u.abt.comp);
+}
+
+static void
+qla24xx_abort_sp_done(void *data, void *ptr, int res)
+{
+	srb_t *sp = (srb_t *)ptr;
+	struct srb_iocb *abt = &sp->u.iocb_cmd;
+
+	complete(&abt->u.abt.comp);
+}
+
+static int
+qla24xx_async_abort_cmd(srb_t *cmd_sp)
+{
+	scsi_qla_host_t *vha = cmd_sp->fcport->vha;
+	fc_port_t *fcport = cmd_sp->fcport;
+	struct srb_iocb *abt_iocb;
+	srb_t *sp;
+	int rval = QLA_FUNCTION_FAILED;
+
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp)
+		goto done;
+
+	abt_iocb = &sp->u.iocb_cmd;
+	sp->type = SRB_ABT_CMD;
+	sp->name = "abort";
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
+	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
+	sp->done = qla24xx_abort_sp_done;
+	abt_iocb->timeout = qla24xx_abort_iocb_timeout;
+	init_completion(&abt_iocb->u.abt.comp);
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	ql_dbg(ql_dbg_async, vha, 0x507c,
+	    "Abort command issued - hdl=%x, target_id=%x\n",
+	    cmd_sp->handle, fcport->tgt_id);
+
+	wait_for_completion(&abt_iocb->u.abt.comp);
+
+	rval = abt_iocb->u.abt.comp_status == CS_COMPLETE ?
+	    QLA_SUCCESS : QLA_FUNCTION_FAILED;
+
+done_free_sp:
+	sp->free(vha, sp);
+done:
+	return rval;
+}
+
+int
+qla24xx_async_abort_command(srb_t *sp)
+{
+	unsigned long   flags = 0;
+
+	uint32_t	handle;
+	fc_port_t	*fcport = sp->fcport;
+	struct scsi_qla_host *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = vha->req;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (handle = 1; handle < req->num_outstanding_cmds; handle++) {
+		if (req->outstanding_cmds[handle] == sp)
+			break;
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (handle == req->num_outstanding_cmds) {
+		/* Command not found. */
+		return QLA_FUNCTION_FAILED;
+	}
+	if (sp->type == SRB_FXIOCB_DCMD)
+		return qlafx00_fx_disc(vha, &vha->hw->mr.fcport,
+		    FXDISC_ABORT_IOCTL);
+
+	return qla24xx_async_abort_cmd(sp);
+}
+
 void
 qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 0aad5e4..8c5dec2 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2585,6 +2585,29 @@ queuing_error:
 	return QLA_FUNCTION_FAILED;
 }
 
+void
+qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
+{
+	struct srb_iocb *aio = &sp->u.iocb_cmd;
+	scsi_qla_host_t *vha = sp->fcport->vha;
+	struct req_que *req = vha->req;
+
+	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
+	abt_iocb->entry_type = ABORT_IOCB_TYPE;
+	abt_iocb->entry_count = 1;
+	abt_iocb->handle = cpu_to_le32(MAKE_HANDLE(req->id, sp->handle));
+	abt_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	abt_iocb->handle_to_abort =
+	    cpu_to_le32(MAKE_HANDLE(req->id, aio->u.abt.cmd_hndl));
+	abt_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
+	abt_iocb->port_id[1] = sp->fcport->d_id.b.area;
+	abt_iocb->port_id[2] = sp->fcport->d_id.b.domain;
+	abt_iocb->vp_index = vha->vp_idx;
+	abt_iocb->req_que_no = cpu_to_le16(req->id);
+	/* Send the command to the firmware */
+	wmb();
+}
+
 int
 qla2x00_start_sp(srb_t *sp)
 {
@@ -2638,7 +2661,9 @@ qla2x00_start_sp(srb_t *sp)
 		qlafx00_fxdisc_iocb(sp, pkt);
 		break;
 	case SRB_ABT_CMD:
-		qlafx00_abort_iocb(sp, pkt);
+		IS_QLAFX00(ha) ?
+			qlafx00_abort_iocb(sp, pkt) :
+			qla24xx_abort_iocb(sp, pkt);
 		break;
 	default:
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 293dbd5..95314ef 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2428,6 +2428,23 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	}
 }
 
+static void
+qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
+	struct abort_entry_24xx *pkt)
+{
+	const char func[] = "ABT_IOCB";
+	srb_t *sp;
+	struct srb_iocb *abt;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	if (!sp)
+		return;
+
+	abt = &sp->u.iocb_cmd;
+	abt->u.abt.comp_status = le32_to_cpu(pkt->nport_handle);
+	sp->done(vha, sp, 0);
+}
+
 /**
  * qla24xx_process_response_queue() - Process response queue entries.
  * @ha: SCSI driver HA context
@@ -2496,6 +2513,10 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			 * from falling into default case
 			 */
 			break;
+		case ABORT_IOCB_TYPE:
+			qla24xx_abort_iocb_entry(vha, rsp->req,
+			    (struct abort_entry_24xx *)pkt);
+			break;
 		default:
 			/* Type Not Supported. */
 			ql_dbg(ql_dbg_async, vha, 0x5042,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b4f7cd5..2528709 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2597,6 +2597,9 @@ qla24xx_abort_command(srb_t *sp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
 	    "Entered %s.\n", __func__);
 
+	if (ql2xasynctmfenable)
+		return qla24xx_async_abort_command(sp);
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < req->num_outstanding_cmds; handle++) {
 		if (req->outstanding_cmds[handle] == sp)
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 165db12..0aaf6a9 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1962,94 +1962,6 @@ done:
 	return rval;
 }
 
-static void
-qlafx00_abort_iocb_timeout(void *data)
-{
-	srb_t *sp = (srb_t *)data;
-	struct srb_iocb *abt = &sp->u.iocb_cmd;
-
-	abt->u.abt.comp_status = cpu_to_le16((uint16_t)CS_TIMEOUT);
-	complete(&abt->u.abt.comp);
-}
-
-static void
-qlafx00_abort_sp_done(void *data, void *ptr, int res)
-{
-	srb_t *sp = (srb_t *)ptr;
-	struct srb_iocb *abt = &sp->u.iocb_cmd;
-
-	complete(&abt->u.abt.comp);
-}
-
-static int
-qlafx00_async_abt_cmd(srb_t *cmd_sp)
-{
-	scsi_qla_host_t *vha = cmd_sp->fcport->vha;
-	fc_port_t *fcport = cmd_sp->fcport;
-	struct srb_iocb *abt_iocb;
-	srb_t *sp;
-	int rval = QLA_FUNCTION_FAILED;
-
-	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
-	if (!sp)
-		goto done;
-
-	abt_iocb = &sp->u.iocb_cmd;
-	sp->type = SRB_ABT_CMD;
-	sp->name = "abort";
-	qla2x00_init_timer(sp, FXDISC_TIMEOUT);
-	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
-	sp->done = qlafx00_abort_sp_done;
-	abt_iocb->timeout = qlafx00_abort_iocb_timeout;
-	init_completion(&abt_iocb->u.abt.comp);
-
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
-
-	ql_dbg(ql_dbg_async, vha, 0x507c,
-	    "Abort command issued - hdl=%x, target_id=%x\n",
-	    cmd_sp->handle, fcport->tgt_id);
-
-	wait_for_completion(&abt_iocb->u.abt.comp);
-
-	rval = abt_iocb->u.abt.comp_status == CS_COMPLETE ?
-	    QLA_SUCCESS : QLA_FUNCTION_FAILED;
-
-done_free_sp:
-	sp->free(vha, sp);
-done:
-	return rval;
-}
-
-int
-qlafx00_abort_command(srb_t *sp)
-{
-	unsigned long   flags = 0;
-
-	uint32_t	handle;
-	fc_port_t	*fcport = sp->fcport;
-	struct scsi_qla_host *vha = fcport->vha;
-	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = vha->req;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (handle = 1; handle < DEFAULT_OUTSTANDING_COMMANDS; handle++) {
-		if (req->outstanding_cmds[handle] == sp)
-			break;
-	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	if (handle == DEFAULT_OUTSTANDING_COMMANDS) {
-		/* Command not found. */
-		return QLA_FUNCTION_FAILED;
-	}
-	if (sp->type == SRB_FXIOCB_DCMD)
-		return qlafx00_fx_disc(vha, &vha->hw->mr.fcport,
-		    FXDISC_ABORT_IOCTL);
-
-	return qlafx00_async_abt_cmd(sp);
-}
-
 /*
  * qlafx00_initialize_adapter
  *      Initialize board.
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7b54e0a..5feed53 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2078,7 +2078,7 @@ static struct isp_operations qlafx00_isp_ops = {
 	.intr_handler		= qlafx00_intr_handler,
 	.enable_intrs		= qlafx00_enable_intrs,
 	.disable_intrs		= qlafx00_disable_intrs,
-	.abort_command		= qlafx00_abort_command,
+	.abort_command		= qla24xx_async_abort_command,
 	.target_reset		= qlafx00_abort_target,
 	.lun_reset		= qlafx00_lun_reset,
 	.fabric_login		= NULL,
-- 
1.7.7

