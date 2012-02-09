From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 01/29] qla2xxx: Enhanced the dump routines to capture multiple request and response queues.
Date: Thu, 9 Feb 2012 11:15:33 -0800
Message-ID: <1328814961-21866-2-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:23005
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758379Ab2BITcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:09 -0500
Received: from mail93-ch1 (localhost [127.0.0.1])	by mail93-ch1-R.bigfish.com
 (Postfix) with ESMTP id 07C9F480561	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:08 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |   83 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_dbg.h  |   14 +++++++
 drivers/scsi/qla2xxx/qla_init.c |   11 +++++-
 3 files changed, 105 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 45cbf0b..cdf0617 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -375,6 +375,77 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 }
 
 static inline void *
+qla25xx_copy_mqueues(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
+{
+	struct qla2xxx_mqueue_chain *q;
+	struct qla2xxx_mqueue_header *qh;
+	struct req_que *req;
+	struct rsp_que *rsp;
+	int que;
+
+	if (!ha->mqenable)
+		return ptr;
+
+	/* Request queues */
+	for (que = 1; que < ha->max_req_queues; que++) {
+		req = ha->req_q_map[que];
+		if (!req)
+			break;
+
+		/* Add chain. */
+		q = ptr;
+		*last_chain = &q->type;
+		q->type = __constant_htonl(DUMP_CHAIN_QUEUE);
+		q->chain_size = htonl(
+		    sizeof(struct qla2xxx_mqueue_chain) +
+		    sizeof(struct qla2xxx_mqueue_header) +
+		    (req->length * sizeof(request_t)));
+		ptr += sizeof(struct qla2xxx_mqueue_chain);
+
+		/* Add header. */
+		qh = ptr;
+		qh->queue = __constant_htonl(TYPE_REQUEST_QUEUE);
+		qh->number = htonl(que);
+		qh->size = htonl(req->length * sizeof(request_t));
+		ptr += sizeof(struct qla2xxx_mqueue_header);
+
+		/* Add data. */
+		memcpy(ptr, req->ring, req->length * sizeof(request_t));
+		ptr += req->length * sizeof(request_t);
+	}
+
+	/* Response queues */
+	for (que = 1; que < ha->max_rsp_queues; que++) {
+		rsp = ha->rsp_q_map[que];
+		if (!rsp)
+			break;
+
+		/* Add chain. */
+		q = ptr;
+		*last_chain = &q->type;
+		q->type = __constant_htonl(DUMP_CHAIN_QUEUE);
+		q->chain_size = htonl(
+		    sizeof(struct qla2xxx_mqueue_chain) +
+		    sizeof(struct qla2xxx_mqueue_header) +
+		    (rsp->length * sizeof(response_t)));
+		ptr += sizeof(struct qla2xxx_mqueue_chain);
+
+		/* Add header. */
+		qh = ptr;
+		qh->queue = __constant_htonl(TYPE_RESPONSE_QUEUE);
+		qh->number = htonl(que);
+		qh->size = htonl(rsp->length * sizeof(response_t));
+		ptr += sizeof(struct qla2xxx_mqueue_header);
+
+		/* Add data. */
+		memcpy(ptr, rsp->ring, rsp->length * sizeof(response_t));
+		ptr += rsp->length * sizeof(response_t);
+	}
+
+	return ptr;
+}
+
+static inline void *
 qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 {
 	uint32_t cnt, que_idx;
@@ -1322,12 +1393,16 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	nxt = qla24xx_copy_eft(ha, nxt);
 
 	/* Chain entries -- started with MQ. */
-	qla25xx_copy_fce(ha, nxt_chain, &last_chain);
+	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
+	nxt_chain = qla25xx_copy_mqueues(ha, nxt_chain, &last_chain);
 	if (last_chain) {
 		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
 		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
 	}
 
+	/* Adjust valid length. */
+	ha->fw_dump_len = (nxt_chain - (void *)ha->fw_dump);
+
 qla25xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
 
@@ -1636,12 +1711,16 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	nxt = qla24xx_copy_eft(ha, nxt);
 
 	/* Chain entries -- started with MQ. */
-	qla25xx_copy_fce(ha, nxt_chain, &last_chain);
+	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
+	nxt_chain = qla25xx_copy_mqueues(ha, nxt_chain, &last_chain);
 	if (last_chain) {
 		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
 		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
 	}
 
+	/* Adjust valid length. */
+	ha->fw_dump_len = (nxt_chain - (void *)ha->fw_dump);
+
 qla81xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 5f1b6d9..6b05cb1 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -192,9 +192,23 @@ struct qla2xxx_mq_chain {
 	uint32_t qregs[4 * QLA_MQ_SIZE];
 };
 
+struct qla2xxx_mqueue_header {
+	uint32_t queue;
+#define TYPE_REQUEST_QUEUE	0x1
+#define TYPE_RESPONSE_QUEUE	0x2
+	uint32_t number;
+	uint32_t size;
+};
+
+struct qla2xxx_mqueue_chain {
+	uint32_t type;
+	uint32_t chain_size;
+};
+
 #define DUMP_CHAIN_VARIANT	0x80000000
 #define DUMP_CHAIN_FCE		0x7FFFFAF0
 #define DUMP_CHAIN_MQ		0x7FFFFAF1
+#define DUMP_CHAIN_QUEUE	0x7FFFFAF2
 #define DUMP_CHAIN_LAST		0x80000000
 
 struct qla2xxx_fw_dump {
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1fa067e..68555df 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1270,8 +1270,17 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			fixed_size = offsetof(struct qla24xx_fw_dump, ext_mem);
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
-		if (ha->mqenable)
+		if (ha->mqenable) {
 			mq_size = sizeof(struct qla2xxx_mq_chain);
+			/*
+			 * Allocate maximum buffer size for all queues.
+			 * Resizing must be done at end-of-dump processing.
+			 */
+			mq_size += ha->max_req_queues *
+			    (req->length * sizeof(request_t));
+			mq_size += ha->max_rsp_queues *
+			    (rsp->length * sizeof(response_t));
+		}
 		/* Allocate memory for Fibre Channel Event Buffer. */
 		if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha))
 			goto try_eft;
-- 
1.6.0.2


