From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 04/29] qla2xxx: Correct multiqueue offset calculations.
Date: Tue, 27 Aug 2013 01:37:30 -0400
Message-ID: <1377581875-8574-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51749 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691Ab3H0GGf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:35 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63vVk012060
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:34 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa4-5
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:34 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   17 ++++++++++-------
 drivers/scsi/qla2xxx/qla_def.h |    5 ++---
 drivers/scsi/qla2xxx/qla_mbx.c |   18 ++++--------------
 drivers/scsi/qla2xxx/qla_mid.c |    2 ++
 4 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 6ed98f9..aa10109 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -527,7 +527,7 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 	uint32_t cnt, que_idx;
 	uint8_t que_cnt;
 	struct qla2xxx_mq_chain *mq = ptr;
-	struct device_reg_25xxmq __iomem *reg;
+	device_reg_t __iomem *reg;
 
 	if (!ha->mqenable || IS_QLA83XX(ha))
 		return ptr;
@@ -541,13 +541,16 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 		ha->max_req_queues : ha->max_rsp_queues;
 	mq->count = htonl(que_cnt);
 	for (cnt = 0; cnt < que_cnt; cnt++) {
-		reg = (struct device_reg_25xxmq __iomem *)
-			(ha->mqiobase + cnt * QLA_QUE_PAGE);
+		reg = ISP_QUE_REG(ha, cnt);
 		que_idx = cnt * 4;
-		mq->qregs[que_idx] = htonl(RD_REG_DWORD(&reg->req_q_in));
-		mq->qregs[que_idx+1] = htonl(RD_REG_DWORD(&reg->req_q_out));
-		mq->qregs[que_idx+2] = htonl(RD_REG_DWORD(&reg->rsp_q_in));
-		mq->qregs[que_idx+3] = htonl(RD_REG_DWORD(&reg->rsp_q_out));
+		mq->qregs[que_idx] =
+		    htonl(RD_REG_DWORD(&reg->isp25mq.req_q_in));
+		mq->qregs[que_idx+1] =
+		    htonl(RD_REG_DWORD(&reg->isp25mq.req_q_out));
+		mq->qregs[que_idx+2] =
+		    htonl(RD_REG_DWORD(&reg->isp25mq.rsp_q_in));
+		mq->qregs[que_idx+3] =
+		    htonl(RD_REG_DWORD(&reg->isp25mq.rsp_q_out));
 	}
 
 	return ptr + sizeof(struct qla2xxx_mq_chain);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c0a1a71..d675860 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2671,9 +2671,8 @@ struct bidi_statistics {
 #define QLA_MAX_QUEUES 256
 #define ISP_QUE_REG(ha, id) \
 	((ha->mqenable || IS_QLA83XX(ha)) ? \
-	((device_reg_t __iomem *)(ha->mqiobase) +\
-	(QLA_QUE_PAGE * id)) :\
-	((device_reg_t __iomem *)(ha->iobase)))
+	 ((void __iomem *)ha->mqiobase + (QLA_QUE_PAGE * id)) :\
+	 ((void __iomem *)ha->iobase))
 #define QLA_REQ_QUE_ID(tag) \
 	((tag < QLA_MAX_QUEUES && tag > 0) ? tag : 0)
 #define QLA_DEFAULT_QUE_QOS 5
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 98e8a16..bce41f4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3574,7 +3574,6 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	unsigned long flags;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	struct device_reg_25xxmq __iomem *reg;
 	struct qla_hw_data *ha = vha->hw;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10d3,
@@ -3595,9 +3594,6 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	if (IS_QLA83XX(ha))
 		mcp->mb[15] = 0;
 
-	reg = (struct device_reg_25xxmq __iomem *)((ha->mqiobase) +
-		QLA_QUE_PAGE * req->id);
-
 	mcp->mb[4] = req->id;
 	/* que in ptr index */
 	mcp->mb[8] = 0;
@@ -3619,12 +3615,10 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (!(req->options & BIT_0)) {
-		WRT_REG_DWORD(&reg->req_q_in, 0);
+		WRT_REG_DWORD(req->req_q_in, 0);
 		if (!IS_QLA83XX(ha))
-			WRT_REG_DWORD(&reg->req_q_out, 0);
+			WRT_REG_DWORD(req->req_q_out, 0);
 	}
-	req->req_q_in = &reg->req_q_in;
-	req->req_q_out = &reg->req_q_out;
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -3646,7 +3640,6 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	unsigned long flags;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	struct device_reg_25xxmq __iomem *reg;
 	struct qla_hw_data *ha = vha->hw;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10d6,
@@ -3664,9 +3657,6 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	if (IS_QLA83XX(ha))
 		mcp->mb[15] = 0;
 
-	reg = (struct device_reg_25xxmq __iomem *)((ha->mqiobase) +
-		QLA_QUE_PAGE * rsp->id);
-
 	mcp->mb[4] = rsp->id;
 	/* que in ptr index */
 	mcp->mb[8] = 0;
@@ -3690,9 +3680,9 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (!(rsp->options & BIT_0)) {
-		WRT_REG_DWORD(&reg->rsp_q_out, 0);
+		WRT_REG_DWORD(rsp->rsp_q_out, 0);
 		if (!IS_QLA83XX(ha))
-			WRT_REG_DWORD(&reg->rsp_q_in, 0);
+			WRT_REG_DWORD(rsp->rsp_q_in, 0);
 	}
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index f868a9f..a72df70 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -699,6 +699,8 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->cnt = req->length;
 	req->id = que_id;
 	reg = ISP_QUE_REG(ha, que_id);
+	req->req_q_in = &reg->isp25mq.req_q_in;
+	req->req_q_out = &reg->isp25mq.req_q_out;
 	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
 	mutex_unlock(&ha->vport_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc004,
-- 
1.7.7

