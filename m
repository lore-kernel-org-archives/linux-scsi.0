From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 6/7] qla2xxx: Fix remoteport disconnect for FC-NVMe
Date: Wed, 19 Jul 2017 11:51:50 -0700
Message-ID: <20170719185151.8564-7-himanshu.madhani@cavium.com>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0066.outbound.protection.outlook.com ([104.47.32.66]:33401
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753631AbdGSSwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jul 2017 14:52:08 -0400
In-Reply-To: <20170719185151.8564-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_isr.c  | 37 +++++++++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_nvme.c | 11 ++++++++---
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 317fe6026856..c14fab35fc36 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1856,17 +1856,42 @@ qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 	fd->transferred_length = fd->payload_length -
 	    le32_to_cpu(sts->residual_len);
 
+	/*
+	 * If transport error then Failure (HBA rejects request)
+	 * otherwise transport will handle.
+	 */
 	if (sts->entry_status) {
 		ql_log(ql_log_warn, fcport->vha, 0x5038,
 		    "NVME-%s error - hdl=%x entry-status(%x).\n",
 		    sp->name, sp->handle, sts->entry_status);
 		ret = QLA_FUNCTION_FAILED;
-	} else if (sts->comp_status != cpu_to_le16(CS_COMPLETE)) {
-		ql_log(ql_log_warn, fcport->vha, 0x5039,
-		    "NVME-%s error - hdl=%x completion status(%x) resid=%x  ox_id=%x\n",
-		    sp->name, sp->handle, sts->comp_status,
-		    le32_to_cpu(sts->residual_len), sts->ox_id);
-		ret = QLA_FUNCTION_FAILED;
+	} else  {
+		switch (le16_to_cpu(sts->comp_status)) {
+			case CS_COMPLETE:
+				ret = 0;
+			break;
+
+			case CS_ABORTED:
+			case CS_RESET:
+			case CS_PORT_UNAVAILABLE:
+			case CS_PORT_LOGGED_OUT:
+			case CS_PORT_BUSY:
+				ql_log(ql_log_warn, fcport->vha, 0x5060,
+				"NVME-%s ERR Handling - hdl=%x completion status(%x) resid=%x  ox_id=%x\n",
+				sp->name, sp->handle, sts->comp_status,
+				le32_to_cpu(sts->residual_len), sts->ox_id);
+				fd->transferred_length = fd->payload_length;
+				ret = QLA_ABORTED;
+			break;
+
+			default:
+				ql_log(ql_log_warn, fcport->vha, 0x5060,
+				"NVME-%s error - hdl=%x completion status(%x) resid=%x  ox_id=%x\n",
+				sp->name, sp->handle, sts->comp_status,
+				le32_to_cpu(sts->residual_len), sts->ox_id);
+				ret = QLA_FUNCTION_FAILED;
+				break;
+		}
 	}
 	sp->done(sp, ret);
 }
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index ccafcdb228e8..da32a06f17a0 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -180,13 +180,13 @@ static void qla_nvme_sp_done(void *ptr, int res)
 	if (!(sp->fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		goto rel;
 
-	if (unlikely(nvme->u.nvme.comp_status || res))
-		fd->status = -EINVAL;
+	if (unlikely(res == QLA_FUNCTION_FAILED))
+		fd->status = NVME_SC_FC_TRANSPORT_ERROR;
 	else
 		fd->status = 0;
 
 	fd->rcv_rsplen = nvme->u.nvme.rsp_pyld_len;
-	if (res == QLA_FUNCTION_FAILED) {
+	if (res) {
 		INIT_WORK(&nvme->rq_work, qla_nvme_io_work);
 		queue_work(sp->fcport->vha->nvme_io_wq, &nvme->rq_work);
 		return;
@@ -653,13 +653,18 @@ static void qla_nvme_unregister_remote_port(struct work_struct *work)
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return;
 
+	ql_log(ql_log_warn, NULL, 0x2112,
+	    "%s: unregister remoteport on %p\n",__func__, fcport);
+
 	list_for_each_entry_safe(rport, trport,
 	    &fcport->vha->nvme_rport_list, list) {
 		if (rport->fcport == fcport) {
 			ql_log(ql_log_info, fcport->vha, 0x2113,
 			    "%s: fcport=%p\n", __func__, fcport);
+			init_completion(&fcport->nvme_del_done);
 			nvme_fc_unregister_remoteport(
 			    fcport->nvme_remote_port);
+			qla_nvme_wait_on_rport_del(fcport);
 		}
 	}
 }
-- 
2.12.0
