From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 5/6] qla2xxx: Fix remoteport disconnect for FC-NVMe
Date: Fri, 21 Jul 2017 09:32:27 -0700
Message-ID: <20170721163228.32339-6-himanshu.madhani@cavium.com>
References: <20170721163228.32339-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0069.outbound.protection.outlook.com ([104.47.33.69]:25872
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754518AbdGUQco (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jul 2017 12:32:44 -0400
In-Reply-To: <20170721163228.32339-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_isr.c  | 37 +++++++++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_nvme.c |  9 +++++++--
 2 files changed, 38 insertions(+), 8 deletions(-)

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
index 6c5eebbbda4c..97a7b222b549 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -169,8 +169,8 @@ static void qla_nvme_sp_done(void *ptr, int res)
 	if (!(sp->fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		goto rel;
 
-	if (unlikely(nvme->u.nvme.comp_status || res))
-		fd->status = -EINVAL;
+	if (unlikely(res == QLA_FUNCTION_FAILED))
+		fd->status = NVME_SC_FC_TRANSPORT_ERROR;
 	else
 		fd->status = 0;
 
@@ -635,13 +635,18 @@ static void qla_nvme_unregister_remote_port(struct work_struct *work)
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
