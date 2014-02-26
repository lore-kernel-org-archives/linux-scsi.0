From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 22/23] qla2xxx: Fix Task Management command asynchronous handling
Date: Wed, 26 Feb 2014 04:15:17 -0500
Message-ID: <1393406118-6586-23-git-send-email-saurav.kashyap@qlogic.com>
References: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:56595 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbaBZJux (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 04:50:53 -0500
In-Reply-To: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

- Fix interpreting the wrong IOCB type for task management
functions in the response path.
- Merge the task management function handling for various adapters.

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   79 +++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_isr.c  |   46 +++++++++++------------
 drivers/scsi/qla2xxx/qla_mr.c   |   66 +-------------------------------
 4 files changed, 69 insertions(+), 123 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index c68b600..97255f7 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -34,6 +34,7 @@
  * |                              |                    | 0x5047,0x5052  |
  * |                              |                    | 0x5084,0x5075	|
  * |                              |                    | 0x503d,0x5044  |
+ * |                              |                    | 0x507b		|
  * | Timer Routines               |       0x6012       |                |
  * | User Space Interactions      |       0x70e2       | 0x7018,0x702e  |
  * |				  |		       | 0x7020,0x7024  |
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f75d19f..2724842 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -271,56 +271,46 @@ done:
 }
 
 static void
-qla2x00_async_tm_cmd_done(void *data, void *ptr, int res)
+qla2x00_tmf_iocb_timeout(void *data)
 {
-	srb_t *sp = (srb_t *)ptr;
-	struct srb_iocb *iocb = &sp->u.iocb_cmd;
-	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
-	uint32_t flags;
-	uint16_t lun;
-	int rval;
-
-	if (!test_bit(UNLOADING, &vha->dpc_flags)) {
-		flags = iocb->u.tmf.flags;
-		lun = (uint16_t)iocb->u.tmf.lun;
+	srb_t *sp = (srb_t *)data;
+	struct srb_iocb *tmf = &sp->u.iocb_cmd;
 
-		/* Issue Marker IOCB */
-		rval = qla2x00_marker(vha, vha->hw->req_q_map[0],
-			vha->hw->rsp_q_map[0], sp->fcport->loop_id, lun,
-			flags == TCF_LUN_RESET ? MK_SYNC_ID_LUN : MK_SYNC_ID);
+	tmf->u.tmf.comp_status = CS_TIMEOUT;
+	complete(&tmf->u.tmf.comp);
+}
 
-		if ((rval != QLA_SUCCESS) || iocb->u.tmf.data) {
-			ql_dbg(ql_dbg_taskm, vha, 0x8030,
-			    "TM IOCB failed (%x).\n", rval);
-		}
-	}
-	sp->free(sp->fcport->vha, sp);
+static void
+qla2x00_tmf_sp_done(void *data, void *ptr, int res)
+{
+	srb_t *sp = (srb_t *)ptr;
+	struct srb_iocb *tmf = &sp->u.iocb_cmd;
+	complete(&tmf->u.tmf.comp);
 }
 
 int
-qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t tm_flags, uint32_t lun,
+qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	uint32_t tag)
 {
 	struct scsi_qla_host *vha = fcport->vha;
+	struct srb_iocb *tm_iocb;
 	srb_t *sp;
-	struct srb_iocb *tcf;
-	int rval;
+	int rval = QLA_FUNCTION_FAILED;
 
-	rval = QLA_FUNCTION_FAILED;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
+	tm_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_TM_CMD;
 	sp->name = "tmf";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	tcf = &sp->u.iocb_cmd;
-	tcf->u.tmf.flags = tm_flags;
-	tcf->u.tmf.lun = lun;
-	tcf->u.tmf.data = tag;
-	tcf->timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_tm_cmd_done;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
+	tm_iocb->u.tmf.flags = flags;
+	tm_iocb->u.tmf.lun = lun;
+	tm_iocb->u.tmf.data = tag;
+	sp->done = qla2x00_tmf_sp_done;
+	tm_iocb->timeout = qla2x00_tmf_iocb_timeout;
+	init_completion(&tm_iocb->u.tmf.comp);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
@@ -330,10 +320,29 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t tm_flags, uint32_t lun,
 	    "Async-tmf hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
 	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
-	return rval;
+
+	wait_for_completion(&tm_iocb->u.tmf.comp);
+
+	rval = tm_iocb->u.tmf.comp_status == CS_COMPLETE ?
+	    QLA_SUCCESS : QLA_FUNCTION_FAILED;
+
+	if ((rval != QLA_SUCCESS) || tm_iocb->u.tmf.data) {
+		ql_dbg(ql_dbg_taskm, vha, 0x8030,
+		    "TM IOCB failed (%x).\n", rval);
+	}
+
+	if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw)) {
+		flags = tm_iocb->u.tmf.flags;
+		lun = (uint16_t)tm_iocb->u.tmf.lun;
+
+		/* Issue Marker IOCB */
+		qla2x00_marker(vha, vha->hw->req_q_map[0],
+		    vha->hw->rsp_q_map[0], sp->fcport->loop_id, lun,
+		    flags == TCF_LUN_RESET ? MK_SYNC_ID_LUN : MK_SYNC_ID);
+	}
 
 done_free_sp:
-	sp->free(fcport->vha, sp);
+	sp->free(vha, sp);
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c2aaf6a..293dbd5 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1498,8 +1498,7 @@ logio_done:
 }
 
 static void
-qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
-    struct tsk_mgmt_entry *tsk)
+qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 {
 	const char func[] = "TMF-IOCB";
 	const char *type;
@@ -1507,7 +1506,6 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	srb_t *sp;
 	struct srb_iocb *iocb;
 	struct sts_entry_24xx *sts = (struct sts_entry_24xx *)tsk;
-	int error = 1;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, tsk);
 	if (!sp)
@@ -1516,37 +1514,35 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	iocb = &sp->u.iocb_cmd;
 	type = sp->name;
 	fcport = sp->fcport;
+	iocb->u.tmf.data = QLA_SUCCESS;
 
 	if (sts->entry_status) {
 		ql_log(ql_log_warn, fcport->vha, 0x5038,
 		    "Async-%s error - hdl=%x entry-status(%x).\n",
 		    type, sp->handle, sts->entry_status);
+		iocb->u.tmf.data = QLA_FUNCTION_FAILED;
 	} else if (sts->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
 		ql_log(ql_log_warn, fcport->vha, 0x5039,
 		    "Async-%s error - hdl=%x completion status(%x).\n",
 		    type, sp->handle, sts->comp_status);
-	} else if (!(le16_to_cpu(sts->scsi_status) &
+		iocb->u.tmf.data = QLA_FUNCTION_FAILED;
+	} else if ((le16_to_cpu(sts->scsi_status) &
 	    SS_RESPONSE_INFO_LEN_VALID)) {
-		ql_log(ql_log_warn, fcport->vha, 0x503a,
-		    "Async-%s error - hdl=%x no response info(%x).\n",
-		    type, sp->handle, sts->scsi_status);
-	} else if (le32_to_cpu(sts->rsp_data_len) < 4) {
-		ql_log(ql_log_warn, fcport->vha, 0x503b,
-		    "Async-%s error - hdl=%x not enough response(%d).\n",
-		    type, sp->handle, sts->rsp_data_len);
-	} else if (sts->data[3]) {
-		ql_log(ql_log_warn, fcport->vha, 0x503c,
-		    "Async-%s error - hdl=%x response(%x).\n",
-		    type, sp->handle, sts->data[3]);
-	} else {
-		error = 0;
+		if (le32_to_cpu(sts->rsp_data_len) < 4) {
+			ql_log(ql_log_warn, fcport->vha, 0x503b,
+			    "Async-%s error - hdl=%x not enough response(%d).\n",
+			    type, sp->handle, sts->rsp_data_len);
+		} else if (sts->data[3]) {
+			ql_log(ql_log_warn, fcport->vha, 0x503c,
+			    "Async-%s error - hdl=%x response(%x).\n",
+			    type, sp->handle, sts->data[3]);
+		iocb->u.tmf.data = QLA_FUNCTION_FAILED;
+		}
 	}
 
-	if (error) {
-		iocb->u.tmf.data = error;
+	if (iocb->u.tmf.data != QLA_SUCCESS)
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5055,
 		    (uint8_t *)sts, sizeof(*sts));
-	}
 
 	sp->done(vha, sp, 0);
 }
@@ -2026,6 +2022,12 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
+	/* Task Management completion. */
+	if (sp->type == SRB_TM_CMD) {
+		qla24xx_tm_iocb_entry(vha, req, pkt);
+		return;
+	}
+
 	/* Fast path completion. */
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
 		qla2x00_process_completed_request(vha, req, handle);
@@ -2475,10 +2477,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla24xx_logio_entry(vha, rsp->req,
 			    (struct logio_entry_24xx *)pkt);
 			break;
-		case TSK_MGMT_IOCB_TYPE:
-			qla24xx_tm_iocb_entry(vha, rsp->req,
-			    (struct tsk_mgmt_entry *)pkt);
-			break;
                 case CT_IOCB_TYPE:
 			qla24xx_els_ct_entry(vha, rsp->req, pkt, CT_IOCB_TYPE);
 			break;
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 046a169..165db12 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -685,78 +685,16 @@ qlafx00_disable_intrs(struct qla_hw_data *ha)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
-static void
-qlafx00_tmf_iocb_timeout(void *data)
-{
-	srb_t *sp = (srb_t *)data;
-	struct srb_iocb *tmf = &sp->u.iocb_cmd;
-
-	tmf->u.tmf.comp_status = cpu_to_le16((uint16_t)CS_TIMEOUT);
-	complete(&tmf->u.tmf.comp);
-}
-
-static void
-qlafx00_tmf_sp_done(void *data, void *ptr, int res)
-{
-	srb_t *sp = (srb_t *)ptr;
-	struct srb_iocb *tmf = &sp->u.iocb_cmd;
-
-	complete(&tmf->u.tmf.comp);
-}
-
-static int
-qlafx00_async_tm_cmd(fc_port_t *fcport, uint32_t flags,
-		     uint32_t lun, uint32_t tag)
-{
-	scsi_qla_host_t *vha = fcport->vha;
-	struct srb_iocb *tm_iocb;
-	srb_t *sp;
-	int rval = QLA_FUNCTION_FAILED;
-
-	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
-	if (!sp)
-		goto done;
-
-	tm_iocb = &sp->u.iocb_cmd;
-	sp->type = SRB_TM_CMD;
-	sp->name = "tmf";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
-	tm_iocb->u.tmf.flags = flags;
-	tm_iocb->u.tmf.lun = lun;
-	tm_iocb->u.tmf.data = tag;
-	sp->done = qlafx00_tmf_sp_done;
-	tm_iocb->timeout = qlafx00_tmf_iocb_timeout;
-	init_completion(&tm_iocb->u.tmf.comp);
-
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
-
-	ql_dbg(ql_dbg_async, vha, 0x507b,
-	    "Task management command issued target_id=%x\n",
-	    fcport->tgt_id);
-
-	wait_for_completion(&tm_iocb->u.tmf.comp);
-
-	rval = tm_iocb->u.tmf.comp_status == CS_COMPLETE ?
-	    QLA_SUCCESS : QLA_FUNCTION_FAILED;
-
-done_free_sp:
-	sp->free(vha, sp);
-done:
-	return rval;
-}
-
 int
 qlafx00_abort_target(fc_port_t *fcport, unsigned int l, int tag)
 {
-	return qlafx00_async_tm_cmd(fcport, TCF_TARGET_RESET, l, tag);
+	return qla2x00_async_tm_cmd(fcport, TCF_TARGET_RESET, l, tag);
 }
 
 int
 qlafx00_lun_reset(fc_port_t *fcport, unsigned int l, int tag)
 {
-	return qlafx00_async_tm_cmd(fcport, TCF_LUN_RESET, l, tag);
+	return qla2x00_async_tm_cmd(fcport, TCF_LUN_RESET, l, tag);
 }
 
 int
-- 
1.7.7

