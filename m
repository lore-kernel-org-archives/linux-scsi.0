From: "Madhani, Madhani" <himanshu.madhani@cavium.com>
Subject: [PATCH v2 2/5] qla2xxx: Add ATIO-Q processing for INTx mode
Date: Fri, 13 Oct 2017 09:34:04 -0700
Message-ID: <20171013163407.8038-3-himanshu.madhani@cavium.com>
References: <20171013163407.8038-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0041.outbound.protection.outlook.com ([104.47.41.41]:13872
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751441AbdJMQeP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Oct 2017 12:34:15 -0400
In-Reply-To: <20171013163407.8038-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@cavium.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  1 +
 drivers/scsi/qla2xxx/qla_isr.c    |  8 ++++++--
 drivers/scsi/qla2xxx/qla_target.c | 12 +++++++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 486c075998f6..66d239cbbd66 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -922,6 +922,7 @@ struct mbx_cmd_32 {
 #define INTR_RSP_QUE_UPDATE_83XX	0x14
 #define INTR_ATIO_QUE_UPDATE		0x1C
 #define INTR_ATIO_RSP_QUE_UPDATE	0x1D
+#define INTR_ATIO_QUE_UPDATE_27XX	0x1E
 
 /* ISP mailbox loopback echo diagnostic error code */
 #define MBS_LB_RESET	0x17
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ef7afd5eefe3..ab97fb06c239 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3129,6 +3129,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 		case INTR_RSP_QUE_UPDATE_83XX:
 			qla24xx_process_response_queue(vha, rsp);
 			break;
+		case INTR_ATIO_QUE_UPDATE_27XX:
 		case INTR_ATIO_QUE_UPDATE:{
 			unsigned long flags2;
 			spin_lock_irqsave(&ha->tgt.atio_lock, flags2);
@@ -3259,6 +3260,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 		case INTR_RSP_QUE_UPDATE_83XX:
 			qla24xx_process_response_queue(vha, rsp);
 			break;
+		case INTR_ATIO_QUE_UPDATE_27XX:
 		case INTR_ATIO_QUE_UPDATE:{
 			unsigned long flags2;
 			spin_lock_irqsave(&ha->tgt.atio_lock, flags2);
@@ -3347,7 +3349,8 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		.pre_vectors = QLA_BASE_VECTORS,
 	};
 
-	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
+	if (QLA_TGT_MODE_ENABLED() && (ql2xenablemsix != 0) &&
+	    IS_ATIO_MSIX_CAPABLE(ha)) {
 		desc.pre_vectors++;
 		min_vecs++;
 	}
@@ -3432,7 +3435,8 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	 * If target mode is enable, also request the vector for the ATIO
 	 * queue.
 	 */
-	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
+	if (QLA_TGT_MODE_ENABLED() && (ql2xenablemsix != 0) &&
+	    IS_ATIO_MSIX_CAPABLE(ha)) {
 		qentry = &ha->msix_entries[QLA_ATIO_VECTOR];
 		rsp->msix = qentry;
 		qentry->handle = rsp;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index f05cfc83c9c8..12976a25f082 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6546,6 +6546,7 @@ void
 qlt_24xx_config_rings(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
+	struct init_cb_24xx *icb;
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
@@ -6553,14 +6554,19 @@ qlt_24xx_config_rings(struct scsi_qla_host *vha)
 	WRT_REG_DWORD(ISP_ATIO_Q_OUT(vha), 0);
 	RD_REG_DWORD(ISP_ATIO_Q_OUT(vha));
 
-	if (IS_ATIO_MSIX_CAPABLE(ha)) {
+	icb = (struct init_cb_24xx *)ha->init_cb;
+
+	if ((ql2xenablemsix != 0) && IS_ATIO_MSIX_CAPABLE(ha)) {
 		struct qla_msix_entry *msix = &ha->msix_entries[2];
-		struct init_cb_24xx *icb = (struct init_cb_24xx *)ha->init_cb;
 
 		icb->msix_atio = cpu_to_le16(msix->entry);
 		ql_dbg(ql_dbg_init, vha, 0xf072,
 		    "Registering ICB vector 0x%x for atio que.\n",
 		    msix->entry);
+	} else if (ql2xenablemsix == 0) {
+		icb->firmware_options_2 |= cpu_to_le32(BIT_26);
+		ql_dbg(ql_dbg_init, vha, 0xf07f,
+		    "Registering INTx vector for ATIO.\n");
 	}
 }
 
@@ -6805,7 +6811,7 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
-	if  (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
+	if  ((ql2xenablemsix == 0) || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 		ISP_ATIO_Q_IN(base_vha) = &ha->mqiobase->isp25mq.atio_q_in;
 		ISP_ATIO_Q_OUT(base_vha) = &ha->mqiobase->isp25mq.atio_q_out;
 	} else {
-- 
2.12.0
