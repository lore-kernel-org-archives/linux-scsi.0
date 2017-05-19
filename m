From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 18/25] qla2xxx: Turn on FW option for exchange check
Date: Fri, 19 May 2017 14:53:37 -0700
Message-ID: <20170519215344.2168-19-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0060.outbound.protection.outlook.com ([104.47.36.60]:45120
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756792AbdESVyU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:54:20 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Tell FW to track exchange/cmd state to prevent driver
from using stale exchange or exchange that is not meant
for this command.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c   | 18 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.c | 27 ++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_target.h |  2 +-
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9aa125795d12..32fb3ed4fb33 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2974,6 +2974,18 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 			ha->fw_options[2] &= ~BIT_11;
 	}
 
+	if (IS_QLA25XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
+		/*
+		 * Tell FW to track each exchange to prevent
+		 * driver from using stale exchange.
+		 */
+		if (qla_tgt_mode_enabled(vha) ||
+		    qla_dual_mode_enabled(vha))
+			ha->fw_options[2] |= BIT_4;
+		else
+			ha->fw_options[2] &= ~BIT_4;
+	}
+
 	ql_dbg(ql_dbg_init, vha, 0x00e8,
 	    "%s, add FW options 1-3 = 0x%04x 0x%04x 0x%04x mode %x\n",
 	    __func__, ha->fw_options[1], ha->fw_options[2],
@@ -7366,6 +7378,12 @@ qla81xx_update_fw_options(scsi_qla_host_t *vha)
 			ha->fw_options[2] &= ~BIT_11;
 	}
 
+	if (qla_tgt_mode_enabled(vha) ||
+	    qla_dual_mode_enabled(vha))
+		ha->fw_options[2] |= BIT_4;
+	else
+		ha->fw_options[2] &= ~BIT_4;
+
 	if (ql2xetsenable) {
 		/* Enable ETS Burst. */
 		memset(ha->fw_options, 0, sizeof(ha->fw_options));
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6d6982249c61..4fce4ff406d8 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2014,8 +2014,10 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 	ctio->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	ctio->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	ctio->exchange_addr = atio->u.isp24.exchange_addr;
-	ctio->u.status1.flags = (atio->u.isp24.attr << 9) |
-	    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS);
+	temp = (atio->u.isp24.attr << 9)|
+		CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS;
+	ctio->u.status1.flags = cpu_to_le16(temp);
+
 	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
 	ctio->u.status1.ox_id = cpu_to_le16(temp);
 	ctio->u.status1.scsi_status =
@@ -2068,8 +2070,9 @@ void qlt_send_resp_ctio(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	ctio->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	ctio->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	ctio->exchange_addr = atio->u.isp24.exchange_addr;
-	ctio->u.status1.flags = (atio->u.isp24.attr << 9) |
-	    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS);
+	temp = (atio->u.isp24.attr << 9) |
+	    CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS;
+	ctio->u.status1.flags = cpu_to_le16(temp);
 	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
 	ctio->u.status1.ox_id = cpu_to_le16(temp);
 	ctio->u.status1.scsi_status =
@@ -2357,7 +2360,8 @@ static int qlt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm,
 	pkt->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	pkt->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	pkt->exchange_addr = atio->u.isp24.exchange_addr;
-	pkt->u.status0.flags |= (atio->u.isp24.attr << 9);
+	temp = atio->u.isp24.attr << 9;
+	pkt->u.status0.flags |= cpu_to_le16(temp);
 	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
 	pkt->u.status0.ox_id = cpu_to_le16(temp);
 	pkt->u.status0.relative_offset = cpu_to_le32(prm->cmd->offset);
@@ -3482,9 +3486,9 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 	ctio24->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	ctio24->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	ctio24->exchange_addr = atio->u.isp24.exchange_addr;
-	ctio24->u.status1.flags = (atio->u.isp24.attr << 9) |
-	    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
-		CTIO7_FLAGS_TERMINATE);
+	temp = (atio->u.isp24.attr << 9) | CTIO7_FLAGS_STATUS_MODE_1 |
+		CTIO7_FLAGS_TERMINATE;
+	ctio24->u.status1.flags = cpu_to_le16(temp);
 	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
 	ctio24->u.status1.ox_id = cpu_to_le16(temp);
 
@@ -4976,6 +4980,7 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	request_t *pkt;
 	struct fc_port *sess = NULL;
 	unsigned long flags;
+	u16 temp;
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
@@ -5008,10 +5013,10 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	ctio24->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	ctio24->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	ctio24->exchange_addr = atio->u.isp24.exchange_addr;
-	ctio24->u.status1.flags = (atio->u.isp24.attr << 9) |
-	    cpu_to_le16(
+	temp = (atio->u.isp24.attr << 9) |
 		CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS |
-		CTIO7_FLAGS_DONT_RET_CTIO);
+		CTIO7_FLAGS_DONT_RET_CTIO;
+	ctio24->u.status1.flags = cpu_to_le16(temp);
 	/*
 	 * CTIO from fw w/o se_cmd doesn't provide enough info to retry it,
 	 * if the explicit conformation is used.
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index dadd9c81bd1d..de6b8c3a863e 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -426,7 +426,7 @@ struct ctio7_to_24xx {
 		} status0;
 		struct {
 			uint16_t sense_length;
-			uint16_t flags;
+			__le16 flags;
 			uint32_t residual;
 			__le16 ox_id;
 			uint16_t scsi_status;
-- 
2.12.0
