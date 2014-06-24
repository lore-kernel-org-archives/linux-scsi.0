From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH V2] qla2xxx: Fix sparse warning in qla_target.c.
Date: Tue, 24 Jun 2014 00:22:29 -0400
Message-ID: <1403583749-21472-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:23283 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbaFXExH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2014 00:53:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   17 +++++++++++------
 drivers/scsi/qla2xxx/qla_target.h |    4 ++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2619ed4..18d2305 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1129,7 +1129,7 @@ static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
 	ctio->u.status1.flags =
 	    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
 		CTIO7_FLAGS_TERMINATE);
-	ctio->u.status1.ox_id = entry->fcp_hdr_le.ox_id;
+	ctio->u.status1.ox_id = cpu_to_le16(entry->fcp_hdr_le.ox_id);
 
 	qla2x00_start_iocbs(vha, vha->req);
 
@@ -1263,6 +1263,7 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 {
 	struct atio_from_isp *atio = &mcmd->orig_iocb.atio;
 	struct ctio7_to_24xx *ctio;
+	uint16_t temp;
 
 	ql_dbg(ql_dbg_tgt, ha, 0xe008,
 	    "Sending task mgmt CTIO7 (ha=%p, atio=%p, resp_code=%x\n",
@@ -1293,7 +1294,8 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 	ctio->u.status1.flags = (atio->u.isp24.attr << 9) |
 	    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
 		CTIO7_FLAGS_SEND_STATUS);
-	ctio->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
+	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
+	ctio->u.status1.ox_id = cpu_to_le16(temp);
 	ctio->u.status1.scsi_status =
 	    __constant_cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID);
 	ctio->u.status1.response_len = __constant_cpu_to_le16(8);
@@ -1514,6 +1516,7 @@ static int qlt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm,
 	struct ctio7_to_24xx *pkt;
 	struct qla_hw_data *ha = vha->hw;
 	struct atio_from_isp *atio = &prm->cmd->atio;
+	uint16_t temp;
 
 	pkt = (struct ctio7_to_24xx *)vha->req->ring_ptr;
 	prm->pkt = pkt;
@@ -1542,13 +1545,13 @@ static int qlt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm,
 	pkt->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	pkt->exchange_addr = atio->u.isp24.exchange_addr;
 	pkt->u.status0.flags |= (atio->u.isp24.attr << 9);
-	pkt->u.status0.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
+	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
+	pkt->u.status0.ox_id = cpu_to_le16(temp);
 	pkt->u.status0.relative_offset = cpu_to_le32(prm->cmd->offset);
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe00c,
 	    "qla_target(%d): handle(cmd) -> %08x, timeout %d, ox_id %#x\n",
-	    vha->vp_idx, pkt->handle, QLA_TGT_TIMEOUT,
-	    le16_to_cpu(pkt->u.status0.ox_id));
+	    vha->vp_idx, pkt->handle, QLA_TGT_TIMEOUT, temp);
 	return 0;
 }
 
@@ -2620,6 +2623,7 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	request_t *pkt;
 	int ret = 0;
+	uint16_t temp;
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe01c, "Sending TERM EXCH CTIO (ha=%p)\n", ha);
 
@@ -2656,7 +2660,8 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 	ctio24->u.status1.flags = (atio->u.isp24.attr << 9) |
 	    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
 		CTIO7_FLAGS_TERMINATE);
-	ctio24->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
+	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
+	ctio24->u.status1.ox_id = cpu_to_le16(temp);
 
 	/* Most likely, it isn't needed */
 	ctio24->u.status1.residual = get_unaligned((uint32_t *)
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index fa5630b..a106a8a 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -443,7 +443,7 @@ struct ctio7_to_24xx {
 			uint16_t reserved1;
 			__le16 flags;
 			uint32_t residual;
-			uint16_t ox_id;
+			__le16 ox_id;
 			uint16_t scsi_status;
 			uint32_t relative_offset;
 			uint32_t reserved2;
@@ -458,7 +458,7 @@ struct ctio7_to_24xx {
 			uint16_t sense_length;
 			uint16_t flags;
 			uint32_t residual;
-			uint16_t ox_id;
+			__le16 ox_id;
 			uint16_t scsi_status;
 			uint16_t response_len;
 			uint16_t reserved;
-- 
1.7.7

