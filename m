From: michaelc@cs.wisc.edu
Subject: [PATCH 15/25] iscsi_tcp: handle iscsi_cmd_task rename
Date: Wed, 21 May 2008 15:54:10 -0500
Message-ID: <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937027AbYEUUyd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:33 -0400
In-Reply-To: <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This converts iscsi_tcp to use the iscsi_task name.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |  262 +++++++++++++++++++++++-----------------------
 drivers/scsi/iscsi_tcp.h |    2 +-
 2 files changed, 132 insertions(+), 132 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 517bad1..33cd0ca 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -498,43 +498,43 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
  * must be called with session lock
  */
 static void
-iscsi_tcp_cleanup_task(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_tcp_cleanup_task(struct iscsi_conn *conn, struct iscsi_task *task)
 {
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_r2t_info *r2t;
 
-	/* nothing to do for mgmt ctasks */
-	if (!ctask->sc)
+	/* nothing to do for mgmt tasks */
+	if (!task->sc)
 		return;
 
-	/* flush ctask's r2t queues */
-	while (__kfifo_get(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
+	/* flush task's r2t queues */
+	while (__kfifo_get(tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
+		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
-		debug_scsi("iscsi_tcp_cleanup_ctask pending r2t dropped\n");
+		debug_scsi("iscsi_tcp_cleanup_task pending r2t dropped\n");
 	}
 
-	r2t = tcp_ctask->r2t;
+	r2t = tcp_task->r2t;
 	if (r2t != NULL) {
-		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
+		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
-		tcp_ctask->r2t = NULL;
+		tcp_task->r2t = NULL;
 	}
 }
 
 /**
  * iscsi_data_rsp - SCSI Data-In Response processing
  * @conn: iscsi connection
- * @ctask: scsi command ctask
+ * @task: scsi command task
  **/
 static int
-iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_data_rsp *rhdr = (struct iscsi_data_rsp *)tcp_conn->in.hdr;
 	struct iscsi_session *session = conn->session;
-	struct scsi_cmnd *sc = ctask->sc;
+	struct scsi_cmnd *sc = task->sc;
 	int datasn = be32_to_cpu(rhdr->datasn);
 	unsigned total_in_length = scsi_in(sc)->length;
 
@@ -542,18 +542,18 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	if (tcp_conn->in.datalen == 0)
 		return 0;
 
-	if (tcp_ctask->exp_datasn != datasn) {
-		debug_tcp("%s: ctask->exp_datasn(%d) != rhdr->datasn(%d)\n",
-		          __FUNCTION__, tcp_ctask->exp_datasn, datasn);
+	if (tcp_task->exp_datasn != datasn) {
+		debug_tcp("%s: task->exp_datasn(%d) != rhdr->datasn(%d)\n",
+		          __FUNCTION__, tcp_task->exp_datasn, datasn);
 		return ISCSI_ERR_DATASN;
 	}
 
-	tcp_ctask->exp_datasn++;
+	tcp_task->exp_datasn++;
 
-	tcp_ctask->data_offset = be32_to_cpu(rhdr->offset);
-	if (tcp_ctask->data_offset + tcp_conn->in.datalen > total_in_length) {
+	tcp_task->data_offset = be32_to_cpu(rhdr->offset);
+	if (tcp_task->data_offset + tcp_conn->in.datalen > total_in_length) {
 		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
-		          __FUNCTION__, tcp_ctask->data_offset,
+		          __FUNCTION__, tcp_task->data_offset,
 		          tcp_conn->in.datalen, total_in_length);
 		return ISCSI_ERR_DATA_OFFSET;
 	}
@@ -582,7 +582,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 /**
  * iscsi_solicit_data_init - initialize first Data-Out
  * @conn: iscsi connection
- * @ctask: scsi command ctask
+ * @task: scsi command task
  * @r2t: R2T info
  *
  * Notes:
@@ -592,7 +592,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
  *	This function is called with connection lock taken.
  **/
 static void
-iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
+iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_task *task,
 			struct iscsi_r2t_info *r2t)
 {
 	struct iscsi_data *hdr;
@@ -603,8 +603,8 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	hdr->datasn = cpu_to_be32(r2t->solicit_datasn);
 	r2t->solicit_datasn++;
 	hdr->opcode = ISCSI_OP_SCSI_DATA_OUT;
-	memcpy(hdr->lun, ctask->hdr->lun, sizeof(hdr->lun));
-	hdr->itt = ctask->hdr->itt;
+	memcpy(hdr->lun, task->hdr->lun, sizeof(hdr->lun));
+	hdr->itt = task->hdr->itt;
 	hdr->exp_statsn = r2t->exp_statsn;
 	hdr->offset = cpu_to_be32(r2t->data_offset);
 	if (r2t->data_length > conn->max_xmit_dlength) {
@@ -624,14 +624,14 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 /**
  * iscsi_r2t_rsp - iSCSI R2T Response processing
  * @conn: iscsi connection
- * @ctask: scsi command ctask
+ * @task: scsi command task
  **/
 static int
-iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 {
 	struct iscsi_r2t_info *r2t;
 	struct iscsi_session *session = conn->session;
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_r2t_rsp *rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
 	int r2tsn = be32_to_cpu(rhdr->r2tsn);
@@ -644,23 +644,23 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 		return ISCSI_ERR_DATALEN;
 	}
 
-	if (tcp_ctask->exp_datasn != r2tsn){
-		debug_tcp("%s: ctask->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
-		          __FUNCTION__, tcp_ctask->exp_datasn, r2tsn);
+	if (tcp_task->exp_datasn != r2tsn){
+		debug_tcp("%s: task->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
+		          __FUNCTION__, tcp_task->exp_datasn, r2tsn);
 		return ISCSI_ERR_R2TSN;
 	}
 
-	/* fill-in new R2T associated with the ctask */
+	/* fill-in new R2T associated with the task */
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 
-	if (!ctask->sc || session->state != ISCSI_STATE_LOGGED_IN) {
+	if (!task->sc || session->state != ISCSI_STATE_LOGGED_IN) {
 		iscsi_conn_printk(KERN_INFO, conn,
 				  "dropping R2T itt %d in recovery.\n",
-				  ctask->itt);
+				  task->itt);
 		return 0;
 	}
 
-	rc = __kfifo_get(tcp_ctask->r2tpool.queue, (void*)&r2t, sizeof(void*));
+	rc = __kfifo_get(tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
 	BUG_ON(!rc);
 
 	r2t->exp_statsn = rhdr->statsn;
@@ -668,7 +668,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	if (r2t->data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
+		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -679,12 +679,12 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 			    r2t->data_length, session->max_burst);
 
 	r2t->data_offset = be32_to_cpu(rhdr->data_offset);
-	if (r2t->data_offset + r2t->data_length > scsi_out(ctask->sc)->length) {
+	if (r2t->data_offset + r2t->data_length > scsi_out(task->sc)->length) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
-				  r2t->data_offset, scsi_out(ctask->sc)->length);
-		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
+				  r2t->data_offset, scsi_out(task->sc)->length);
+		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -692,13 +692,13 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	r2t->ttt = rhdr->ttt; /* no flip */
 	r2t->solicit_datasn = 0;
 
-	iscsi_solicit_data_init(conn, ctask, r2t);
+	iscsi_solicit_data_init(conn, task, r2t);
 
-	tcp_ctask->exp_datasn = r2tsn + 1;
-	__kfifo_put(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*));
+	tcp_task->exp_datasn = r2tsn + 1;
+	__kfifo_put(tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
 	conn->r2t_pdus_cnt++;
 
-	iscsi_requeue_ctask(ctask);
+	iscsi_requeue_task(task);
 	return 0;
 }
 
@@ -743,7 +743,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	int rc = 0, opcode, ahslen;
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_cmd_task *ctask;
+	struct iscsi_task *task;
 
 	/* verify PDU length */
 	tcp_conn->in.datalen = ntoh24(hdr->dlength);
@@ -770,21 +770,21 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 
 	switch(opcode) {
 	case ISCSI_OP_SCSI_DATA_IN:
-		ctask = iscsi_itt_to_ctask(conn, hdr->itt);
-		if (!ctask)
+		task = iscsi_itt_to_ctask(conn, hdr->itt);
+		if (!task)
 			return ISCSI_ERR_BAD_ITT;
-		if (!ctask->sc)
+		if (!task->sc)
 			return ISCSI_ERR_NO_SCSI_CMD;
 
 		spin_lock(&conn->session->lock);
-		rc = iscsi_data_rsp(conn, ctask);
+		rc = iscsi_data_rsp(conn, task);
 		spin_unlock(&conn->session->lock);
 		if (rc)
 			return rc;
 		if (tcp_conn->in.datalen) {
-			struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+			struct iscsi_tcp_task *tcp_task = task->dd_data;
 			struct hash_desc *rx_hash = NULL;
-			struct scsi_data_buffer *sdb = scsi_in(ctask->sc);
+			struct scsi_data_buffer *sdb = scsi_in(task->sc);
 
 			/*
 			 * Setup copy of Data-In into the Scsi_Cmnd
@@ -799,12 +799,12 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 
 			debug_tcp("iscsi_tcp_begin_data_in(%p, offset=%d, "
 				  "datalen=%d)\n", tcp_conn,
-				  tcp_ctask->data_offset,
+				  tcp_task->data_offset,
 				  tcp_conn->in.datalen);
 			return iscsi_segment_seek_sg(&tcp_conn->in.segment,
 						     sdb->table.sgl,
 						     sdb->table.nents,
-						     tcp_ctask->data_offset,
+						     tcp_task->data_offset,
 						     tcp_conn->in.datalen,
 						     iscsi_tcp_process_data_in,
 						     rx_hash);
@@ -818,17 +818,17 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
 		break;
 	case ISCSI_OP_R2T:
-		ctask = iscsi_itt_to_ctask(conn, hdr->itt);
-		if (!ctask)
+		task = iscsi_itt_to_ctask(conn, hdr->itt);
+		if (!task)
 			return ISCSI_ERR_BAD_ITT;
-		if (!ctask->sc)
+		if (!task->sc)
 			return ISCSI_ERR_NO_SCSI_CMD;
 
 		if (ahslen)
 			rc = ISCSI_ERR_AHSLEN;
-		else if (ctask->sc->sc_data_direction == DMA_TO_DEVICE) {
+		else if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
 			spin_lock(&session->lock);
-			rc = iscsi_r2t_rsp(conn, ctask);
+			rc = iscsi_r2t_rsp(conn, task);
 			spin_unlock(&session->lock);
 		} else
 			rc = ISCSI_ERR_PROTO;
@@ -1202,7 +1202,7 @@ iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
 
 	/* If header digest is enabled, compute the CRC and
 	 * place the digest into the same buffer. We make
-	 * sure that both iscsi_tcp_cmd_task and mctask have
+	 * sure that both iscsi_tcp_task and mtask have
 	 * sufficient room.
 	 */
 	if (conn->hdrdgst_en) {
@@ -1277,7 +1277,7 @@ iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
 /**
  * iscsi_solicit_data_cont - initialize next Data-Out
  * @conn: iscsi connection
- * @ctask: scsi command ctask
+ * @task: scsi command task
  * @r2t: R2T info
  * @left: bytes left to transfer
  *
@@ -1288,7 +1288,7 @@ iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
  *	Called under connection lock.
  **/
 static int
-iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
+iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_task *task,
 			struct iscsi_r2t_info *r2t)
 {
 	struct iscsi_data *hdr;
@@ -1305,8 +1305,8 @@ iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	hdr->datasn = cpu_to_be32(r2t->solicit_datasn);
 	r2t->solicit_datasn++;
 	hdr->opcode = ISCSI_OP_SCSI_DATA_OUT;
-	memcpy(hdr->lun, ctask->hdr->lun, sizeof(hdr->lun));
-	hdr->itt = ctask->hdr->itt;
+	memcpy(hdr->lun, task->hdr->lun, sizeof(hdr->lun));
+	hdr->itt = task->hdr->itt;
 	hdr->exp_statsn = r2t->exp_statsn;
 	new_offset = r2t->data_offset + r2t->sent;
 	hdr->offset = cpu_to_be32(new_offset);
@@ -1326,73 +1326,73 @@ iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 /**
  * iscsi_tcp_task - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
  * @conn: iscsi connection
- * @ctask: scsi command ctask
+ * @task: scsi command task
  * @sc: scsi command
  **/
 static int
-iscsi_tcp_task_init(struct iscsi_cmd_task *ctask)
+iscsi_tcp_task_init(struct iscsi_task *task)
 {
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_conn *conn = ctask->conn;
-	struct scsi_cmnd *sc = ctask->sc;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct iscsi_conn *conn = task->conn;
+	struct scsi_cmnd *sc = task->sc;
 	int err;
 
 	if (!sc) {
 		/*
-		 * mgmt ctasks do not have a scatterlist since they come
+		 * mgmt tasks do not have a scatterlist since they come
 		 * in from the iscsi interface.
 		 */
-		debug_scsi("mctask deq [cid %d itt 0x%x]\n", conn->id,
-			   ctask->itt);
+		debug_scsi("mtask deq [cid %d itt 0x%x]\n", conn->id,
+			   task->itt);
 
 		/* Prepare PDU, optionally w/ immediate data */
-		iscsi_tcp_send_hdr_prep(conn, ctask->hdr, sizeof(*ctask->hdr));
+		iscsi_tcp_send_hdr_prep(conn, task->hdr, sizeof(*task->hdr));
 
 		/* If we have immediate data, attach a payload */
-		if (ctask->data_count)
-			iscsi_tcp_send_linear_data_prepare(conn, ctask->data,
-							   ctask->data_count);
+		if (task->data_count)
+			iscsi_tcp_send_linear_data_prepare(conn, task->data,
+							   task->data_count);
 		return 0;
 	}
 
-	BUG_ON(__kfifo_len(tcp_ctask->r2tqueue));
-	tcp_ctask->sent = 0;
-	tcp_ctask->exp_datasn = 0;
+	BUG_ON(__kfifo_len(tcp_task->r2tqueue));
+	tcp_task->sent = 0;
+	tcp_task->exp_datasn = 0;
 
 	/* Prepare PDU, optionally w/ immediate data */
-	debug_scsi("ctask deq [cid %d itt 0x%x imm %d unsol %d]\n",
-		    conn->id, ctask->itt, ctask->imm_count,
-		    ctask->unsol_count);
-	iscsi_tcp_send_hdr_prep(conn, ctask->hdr, ctask->hdr_len);
+	debug_scsi("task deq [cid %d itt 0x%x imm %d unsol %d]\n",
+		    conn->id, task->itt, task->imm_count,
+		    task->unsol_count);
+	iscsi_tcp_send_hdr_prep(conn, task->hdr, task->hdr_len);
 
-	if (!ctask->imm_count)
+	if (!task->imm_count)
 		return 0;
 
 	/* If we have immediate data, attach a payload */
 	err = iscsi_tcp_send_data_prep(conn, scsi_out(sc)->table.sgl,
 				       scsi_out(sc)->table.nents,
-				       0, ctask->imm_count);
+				       0, task->imm_count);
 	if (err)
 		return err;
-	tcp_ctask->sent += ctask->imm_count;
-	ctask->imm_count = 0;
+	tcp_task->sent += task->imm_count;
+	task->imm_count = 0;
 	return 0;
 }
 
 /*
- * iscsi_tcp_task_xmit - xmit normal PDU ctask
- * @ctask: iscsi command ctask
+ * iscsi_tcp_task_xmit - xmit normal PDU task
+ * @task: iscsi command task
  *
  * We're expected to return 0 when everything was transmitted succesfully,
  * -EAGAIN if there's still data in the queue, or != 0 for any other kind
  * of error.
  */
 static int
-iscsi_tcp_task_xmit(struct iscsi_cmd_task *ctask)
+iscsi_tcp_task_xmit(struct iscsi_task *task)
 {
-	struct iscsi_conn *conn = ctask->conn;
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct scsi_cmnd *sc = ctask->sc;
+	struct iscsi_conn *conn = task->conn;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct scsi_cmnd *sc = task->sc;
 	struct scsi_data_buffer *sdb;
 	int rc = 0;
 
@@ -1404,8 +1404,8 @@ flush:
 
 	/* mgmt command */
 	if (!sc) {
-		if (ctask->hdr->itt == RESERVED_ITT)
-			iscsi_put_ctask(ctask);
+		if (task->hdr->itt == RESERVED_ITT)
+			iscsi_put_task(task);
 		return 0;
 	}
 
@@ -1414,27 +1414,27 @@ flush:
 		return 0;
 
 	sdb = scsi_out(sc);
-	if (ctask->unsol_count != 0) {
-		struct iscsi_data *hdr = &tcp_ctask->unsol_dtask.hdr;
+	if (task->unsol_count != 0) {
+		struct iscsi_data *hdr = &tcp_task->unsol_dtask.hdr;
 
 		/* Prepare a header for the unsolicited PDU.
 		 * The amount of data we want to send will be
-		 * in ctask->data_count.
+		 * in task->data_count.
 		 * FIXME: return the data count instead.
 		 */
-		iscsi_prep_unsolicit_data_pdu(ctask, hdr);
+		iscsi_prep_unsolicit_data_pdu(task, hdr);
 
 		debug_tcp("unsol dout [itt 0x%x doff %d dlen %d]\n",
-				ctask->itt, tcp_ctask->sent, ctask->data_count);
+				task->itt, tcp_task->sent, task->data_count);
 
 		iscsi_tcp_send_hdr_prep(conn, hdr, sizeof(*hdr));
 		rc = iscsi_tcp_send_data_prep(conn, sdb->table.sgl,
-					      sdb->table.nents, tcp_ctask->sent,
-					      ctask->data_count);
+					      sdb->table.nents, tcp_task->sent,
+					      task->data_count);
 		if (rc)
 			goto fail;
-		tcp_ctask->sent += ctask->data_count;
-		ctask->unsol_count -= ctask->data_count;
+		tcp_task->sent += task->data_count;
+		task->unsol_count -= task->data_count;
 		goto flush;
 	} else {
 		struct iscsi_session *session = conn->session;
@@ -1443,22 +1443,22 @@ flush:
 		/* All unsolicited PDUs sent. Check for solicited PDUs.
 		 */
 		spin_lock_bh(&session->lock);
-		r2t = tcp_ctask->r2t;
+		r2t = tcp_task->r2t;
 		if (r2t != NULL) {
 			/* Continue with this R2T? */
-			if (!iscsi_solicit_data_cont(conn, ctask, r2t)) {
+			if (!iscsi_solicit_data_cont(conn, task, r2t)) {
 				debug_scsi("  done with r2t %p\n", r2t);
 
-				__kfifo_put(tcp_ctask->r2tpool.queue,
+				__kfifo_put(tcp_task->r2tpool.queue,
 					    (void*)&r2t, sizeof(void*));
-				tcp_ctask->r2t = r2t = NULL;
+				tcp_task->r2t = r2t = NULL;
 			}
 		}
 
 		if (r2t == NULL) {
-			__kfifo_get(tcp_ctask->r2tqueue, (void*)&tcp_ctask->r2t,
+			__kfifo_get(tcp_task->r2tqueue, (void*)&tcp_task->r2t,
 				    sizeof(void*));
-			r2t = tcp_ctask->r2t;
+			r2t = tcp_task->r2t;
 		}
 		spin_unlock_bh(&session->lock);
 
@@ -1469,7 +1469,7 @@ flush:
 		}
 
 		debug_scsi("sol dout %p [dsn %d itt 0x%x doff %d dlen %d]\n",
-			r2t, r2t->solicit_datasn - 1, ctask->itt,
+			r2t, r2t->solicit_datasn - 1, task->itt,
 			r2t->data_offset + r2t->sent, r2t->data_count);
 
 		iscsi_tcp_send_hdr_prep(conn, &r2t->dtask.hdr,
@@ -1481,7 +1481,7 @@ flush:
 					      r2t->data_count);
 		if (rc)
 			goto fail;
-		tcp_ctask->sent += r2t->data_count;
+		tcp_task->sent += r2t->data_count;
 		r2t->sent += r2t->data_count;
 		goto flush;
 	}
@@ -1698,11 +1698,11 @@ iscsi_r2tpool_alloc(struct iscsi_session *session)
 	int cmd_i;
 
 	/*
-	 * initialize per-ctask: R2T pool and xmit queue
+	 * initialize per-task: R2T pool and xmit queue
 	 */
 	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-	        struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
-		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	        struct iscsi_task *task = session->cmds[cmd_i];
+		struct iscsi_tcp_task *tcp_task = task->dd_data;
 
 		/*
 		 * pre-allocated x4 as much r2ts to handle race when
@@ -1711,16 +1711,16 @@ iscsi_r2tpool_alloc(struct iscsi_session *session)
 		 */
 
 		/* R2T pool */
-		if (iscsi_pool_init(&tcp_ctask->r2tpool, session->max_r2t * 4, NULL,
+		if (iscsi_pool_init(&tcp_task->r2tpool, session->max_r2t * 4, NULL,
 				    sizeof(struct iscsi_r2t_info))) {
 			goto r2t_alloc_fail;
 		}
 
 		/* R2T xmit queue */
-		tcp_ctask->r2tqueue = kfifo_alloc(
+		tcp_task->r2tqueue = kfifo_alloc(
 		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL, NULL);
-		if (tcp_ctask->r2tqueue == ERR_PTR(-ENOMEM)) {
-			iscsi_pool_free(&tcp_ctask->r2tpool);
+		if (tcp_task->r2tqueue == ERR_PTR(-ENOMEM)) {
+			iscsi_pool_free(&tcp_task->r2tpool);
 			goto r2t_alloc_fail;
 		}
 	}
@@ -1729,11 +1729,11 @@ iscsi_r2tpool_alloc(struct iscsi_session *session)
 
 r2t_alloc_fail:
 	for (i = 0; i < cmd_i; i++) {
-		struct iscsi_cmd_task *ctask = session->cmds[i];
-		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+		struct iscsi_task *task = session->cmds[i];
+		struct iscsi_tcp_task *tcp_task = task->dd_data;
 
-		kfifo_free(tcp_ctask->r2tqueue);
-		iscsi_pool_free(&tcp_ctask->r2tpool);
+		kfifo_free(tcp_task->r2tqueue);
+		iscsi_pool_free(&tcp_task->r2tpool);
 	}
 	return -ENOMEM;
 }
@@ -1744,11 +1744,11 @@ iscsi_r2tpool_free(struct iscsi_session *session)
 	int i;
 
 	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_cmd_task *ctask = session->cmds[i];
-		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+		struct iscsi_task *task = session->cmds[i];
+		struct iscsi_tcp_task *tcp_task = task->dd_data;
 
-		kfifo_free(tcp_ctask->r2tqueue);
-		iscsi_pool_free(&tcp_ctask->r2tpool);
+		kfifo_free(tcp_task->r2tqueue);
+		iscsi_pool_free(&tcp_task->r2tpool);
 	}
 }
 
@@ -1867,7 +1867,7 @@ iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 	*hostno = shost->host_no;
 
 	cls_session = iscsi_session_setup(&iscsi_tcp_transport, shost, cmds_max,
-					  sizeof(struct iscsi_tcp_cmd_task),
+					  sizeof(struct iscsi_tcp_task),
 					  initial_cmdsn);
 	if (!cls_session)
 		goto remove_host;
@@ -1875,11 +1875,11 @@ iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 
 	shost->can_queue = session->scsi_cmds_max;
 	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-		struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
-		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+		struct iscsi_task *task = session->cmds[cmd_i];
+		struct iscsi_tcp_task *tcp_task = task->dd_data;
 
-		ctask->hdr = &tcp_ctask->hdr.cmd_hdr;
-		ctask->hdr_max = sizeof(tcp_ctask->hdr) - ISCSI_DIGEST_SIZE;
+		task->hdr = &tcp_task->hdr.cmd_hdr;
+		task->hdr_max = sizeof(tcp_task->hdr) - ISCSI_DIGEST_SIZE;
 	}
 
 	if (iscsi_r2tpool_alloc(session))
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index c9c8633..498d8ca 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -114,7 +114,7 @@ struct iscsi_r2t_info {
 	struct iscsi_data_task	dtask;		/* Data-Out header buf */
 };
 
-struct iscsi_tcp_cmd_task {
+struct iscsi_tcp_task {
 	struct iscsi_hdr_buff {
 		struct iscsi_cmd	cmd_hdr;
 		char			hdrextbuf[ISCSI_MAX_AHS_SIZE +
-- 
1.5.4.1

