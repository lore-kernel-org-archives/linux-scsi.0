From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 2.6.29-rc v2] iscsi - add offset and count to alloc_pdu()
Date: Wed, 11 Feb 2009 12:09:49 -0800
Message-ID: <200902112009.n1BK9nkO012612@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:3268 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZBKUIS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 15:08:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, kxie@chelsio.com, James.Bottomley@HansenPartnership.com

[PATCH 2.6.29-rc v2] iscsi - add offset and count to alloc_pdu().

From: Karen Xie <kxie@chelsio.com>

Second try: update iser and cxgb3i alloc_pdu() function prototypes.

Added the offset and count as additional parameters to alloc_pdu(). So that
the pdu payload is known at the time of pdu memory allocation.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/infiniband/ulp/iser/iscsi_iser.c |    3 +
 drivers/scsi/cxgb3i/cxgb3i.h             |    2 -
 drivers/scsi/cxgb3i/cxgb3i_pdu.c         |    3 +
 drivers/scsi/iscsi_tcp.c                 |    3 +
 drivers/scsi/libiscsi.c                  |   93 +++++++++++++++---------------
 drivers/scsi/libiscsi_tcp.c              |    6 ++
 include/scsi/libiscsi.h                  |   12 ++++
 include/scsi/scsi_transport_iscsi.h      |    3 +
 8 files changed, 72 insertions(+), 53 deletions(-)


diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1287639..fc97ae4 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -119,7 +119,8 @@ error:
 	iscsi_conn_failure(conn, rc);
 }
 
-static int iscsi_iser_pdu_alloc(struct iscsi_task *task, uint8_t opcode)
+static int iscsi_iser_pdu_alloc(struct iscsi_task *task, uint8_t opcode,
+				unsigned int offset, unsigned int count)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index fde6e4c..12937ad 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -129,7 +129,7 @@ void cxgb3i_hba_host_remove(struct cxgb3i_hba *);
 int cxgb3i_pdu_init(void);
 void cxgb3i_pdu_cleanup(void);
 void cxgb3i_conn_cleanup_task(struct iscsi_task *);
-int cxgb3i_conn_alloc_pdu(struct iscsi_task *, u8);
+int cxgb3i_conn_alloc_pdu(struct iscsi_task *, u8, unsigned int, unsigned int);
 int cxgb3i_conn_init_pdu(struct iscsi_task *, unsigned int, unsigned int);
 int cxgb3i_conn_xmit_pdu(struct iscsi_task *);
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index ce7ce8c..3d30ed0 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -162,7 +162,8 @@ void cxgb3i_conn_cleanup_task(struct iscsi_task *task)
 /*
  * We do not support ahs yet
  */
-int cxgb3i_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
+int cxgb3i_conn_alloc_pdu(struct iscsi_task *task, u8 opcode,
+			  unsigned int offset, unsigned int count)
 {
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct sk_buff *skb;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 23808df..7fe0c68 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -458,7 +458,8 @@ static int iscsi_sw_tcp_pdu_init(struct iscsi_task *task,
 	return 0;
 }
 
-static int iscsi_sw_tcp_pdu_alloc(struct iscsi_task *task, uint8_t opcode)
+static int iscsi_sw_tcp_pdu_alloc(struct iscsi_task *task, uint8_t opcode,
+				 unsigned int offset, unsigned int count)
 {
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 809d32d..22c84ed 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -104,7 +104,6 @@ void iscsi_prep_data_out_pdu(struct iscsi_task *task, struct iscsi_r2t_info *r2t
 			   struct iscsi_data *hdr)
 {
 	struct iscsi_conn *conn = task->conn;
-	unsigned int left = r2t->data_length - r2t->sent;
 
 	task->hdr_len = sizeof(struct iscsi_data);
 
@@ -117,15 +116,11 @@ void iscsi_prep_data_out_pdu(struct iscsi_task *task, struct iscsi_r2t_info *r2t
 	hdr->itt = task->hdr_itt;
 	hdr->exp_statsn = r2t->exp_statsn;
 	hdr->offset = cpu_to_be32(r2t->data_offset + r2t->sent);
-	if (left > conn->max_xmit_dlength) {
-		hton24(hdr->dlength, conn->max_xmit_dlength);
-		r2t->data_count = conn->max_xmit_dlength;
-		hdr->flags = 0;
-	} else {
-		hton24(hdr->dlength, left);
-		r2t->data_count = left;
+	hton24(hdr->dlength, r2t->data_count);
+	if (r2t->data_length == (r2t->sent + r2t->data_count))
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
-	}
+	else
+		hdr->flags = 0;
 	conn->dataout_pdus_cnt++;
 }
 EXPORT_SYMBOL_GPL(iscsi_prep_data_out_pdu);
@@ -225,7 +220,45 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	itt_t itt;
 	int rc;
 
-	rc = conn->session->tt->alloc_pdu(task, ISCSI_OP_SCSI_CMD);
+	if (sc->sc_data_direction == DMA_TO_DEVICE) {
+		unsigned out_len = scsi_out(sc)->length;
+		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
+
+		/*
+		 * Write counters:
+		 *
+		 *	imm_count	bytes to be sent right after
+		 *			SCSI PDU Header
+		 *
+		 *	unsol_count	bytes(as Data-Out) to be sent
+		 *			without	R2T ack right after
+		 *			immediate data
+		 *
+		 *	r2t data_length bytes to be sent via R2T ack's
+		 *
+		 *      pad_count       bytes to be sent as zero-padding
+		 */
+		if (session->imm_data_en) {
+			if (out_len >= session->first_burst)
+				task->imm_count = min(session->first_burst,
+							conn->max_xmit_dlength);
+			else
+				task->imm_count = min(out_len,
+							conn->max_xmit_dlength);
+		}
+
+		memset(r2t, 0, sizeof(*r2t));
+		if (!session->initial_r2t_en) {
+			r2t->data_length = min(session->first_burst, out_len) -
+					       task->imm_count;
+			r2t->data_offset = task->imm_count;
+			r2t->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
+			r2t->exp_statsn = cpu_to_be32(conn->exp_statsn);
+		}
+	}
+
+	rc = conn->session->tt->alloc_pdu(task, ISCSI_OP_SCSI_CMD, 0,
+					task->imm_count);
 	if (rc)
 		return rc;
 	hdr = (struct iscsi_cmd *) task->hdr;
@@ -259,7 +292,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	}
 	memcpy(hdr->cdb, sc->cmnd, cmd_len);
 
-	task->imm_count = 0;
 	if (scsi_bidi_cmnd(sc)) {
 		hdr->flags |= ISCSI_FLAG_CMD_READ;
 		rc = iscsi_prep_bidi_ahs(task);
@@ -267,46 +299,13 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 			return rc;
 	}
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
-		unsigned out_len = scsi_out(sc)->length;
-		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
-
-		hdr->data_length = cpu_to_be32(out_len);
+		hdr->data_length = cpu_to_be32(scsi_out(sc)->length);
 		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
-		/*
-		 * Write counters:
-		 *
-		 *	imm_count	bytes to be sent right after
-		 *			SCSI PDU Header
-		 *
-		 *	unsol_count	bytes(as Data-Out) to be sent
-		 *			without	R2T ack right after
-		 *			immediate data
-		 *
-		 *	r2t data_length bytes to be sent via R2T ack's
-		 *
-		 *      pad_count       bytes to be sent as zero-padding
-		 */
-		memset(r2t, 0, sizeof(*r2t));
-
-		if (session->imm_data_en) {
-			if (out_len >= session->first_burst)
-				task->imm_count = min(session->first_burst,
-							conn->max_xmit_dlength);
-			else
-				task->imm_count = min(out_len,
-							conn->max_xmit_dlength);
+		if (task->imm_count) {
 			hton24(hdr->dlength, task->imm_count);
 		} else
 			zero_data(hdr->dlength);
 
-		if (!session->initial_r2t_en) {
-			r2t->data_length = min(session->first_burst, out_len) -
-					       task->imm_count;
-			r2t->data_offset = task->imm_count;
-			r2t->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
-			r2t->exp_statsn = cpu_to_be32(conn->exp_statsn);
-		}
-
 		if (!task->unsol_r2t.data_length)
 			/* No unsolicit Data-Out's */
 			hdr->flags |= ISCSI_FLAG_CMD_FINAL;
@@ -532,7 +531,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	} else
 		task->data_count = 0;
 
-	if (conn->session->tt->alloc_pdu(task, hdr->opcode)) {
+	if (conn->session->tt->alloc_pdu(task, hdr->opcode, 0, data_size)) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate "
 				 "pdu for mgmt task.\n");
 		goto requeue_task;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index e7705d3..23fad1b 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1023,7 +1023,11 @@ flush:
 		return 0;
 	}
 
-	rc = conn->session->tt->alloc_pdu(task, ISCSI_OP_SCSI_DATA_OUT);
+	iscsi_calc_data_out_payload(task, r2t);
+
+	rc = conn->session->tt->alloc_pdu(task, ISCSI_OP_SCSI_DATA_OUT,
+					r2t->data_offset + r2t->sent,
+					r2t->data_count);
 	if (rc)
 		return rc;
 	iscsi_prep_data_out_pdu(task, r2t, (struct iscsi_data *) task->hdr);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7360e19..2097ee5 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -395,6 +395,18 @@ extern void iscsi_suspend_tx(struct iscsi_conn *conn);
 /*
  * pdu and task processing
  */
+static inline void iscsi_calc_data_out_payload(struct iscsi_task *task,
+						struct iscsi_r2t_info *r2t)
+{
+	struct iscsi_conn *conn = task->conn;
+	unsigned int left = r2t->data_length - r2t->sent;
+
+	if (left > conn->max_xmit_dlength)
+		r2t->data_count = conn->max_xmit_dlength;
+	else
+		r2t->data_count = left;
+}
+
 extern void iscsi_update_cmdsn(struct iscsi_session *, struct iscsi_nopin *);
 extern void iscsi_prep_data_out_pdu(struct iscsi_task *task,
 				    struct iscsi_r2t_info *r2t,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b50aabe..715fefc 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -118,7 +118,8 @@ struct iscsi_transport {
 	int (*xmit_task) (struct iscsi_task *task);
 	void (*cleanup_task) (struct iscsi_task *task);
 
-	int (*alloc_pdu) (struct iscsi_task *task, uint8_t opcode);
+	int (*alloc_pdu) (struct iscsi_task *task, uint8_t opcode,
+			  unsigned int offset, unsigned int count);
 	int (*xmit_pdu) (struct iscsi_task *task);
 	int (*init_pdu) (struct iscsi_task *task, unsigned int offset,
 			 unsigned int count);
