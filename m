From: michaelc@cs.wisc.edu
Subject: [PATCH 05/14] libiscsi_tcp: replace tcp_debug/scsi_debug logging with session/conn logging
Date: Thu,  5 Mar 2009 14:45:59 -0600
Message-ID: <12362859743025-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52774 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbZCEUqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:19 -0500
In-Reply-To: <12362859734023-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This makes the logging a compile time option and replaces
the scsi_debug and tcp_debug macro with session and connection ones
that print out a driver model id prefix.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi_tcp.c |  122 ++++++++++++++++++++++---------------------
 1 files changed, 62 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index e7705d3..91f8ce4 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -49,13 +49,21 @@ MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>, "
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-#undef DEBUG_TCP
 
-#ifdef DEBUG_TCP
-#define debug_tcp(fmt...) printk(KERN_INFO "tcp: " fmt)
-#else
-#define debug_tcp(fmt...)
-#endif
+static int iscsi_dbg_libtcp;
+module_param_named(debug_libiscsi_tcp, iscsi_dbg_libtcp, int,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug_libiscsi_tcp, "Turn on debugging for libiscsi_tcp "
+		 "module. Set to 1 to turn on, and zero to turn off. Default "
+		 "is off.");
+
+#define ISCSI_DBG_TCP(_conn, dbg_fmt, arg...)			\
+	do {							\
+		if (iscsi_dbg_libtcp)				\
+			iscsi_conn_printk(KERN_INFO, _conn,	\
+					     "%s " dbg_fmt,	\
+					     __func__, ##arg);	\
+	} while (0);
 
 static int iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 				   struct iscsi_segment *segment);
@@ -123,18 +131,13 @@ static void iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
 	if (page_count(sg_page(sg)) >= 1 && !recv)
 		return;
 
-	debug_tcp("iscsi_tcp_segment_map %s %p\n", recv ? "recv" : "xmit",
-		  segment);
 	segment->sg_mapped = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
 	segment->data = segment->sg_mapped + sg->offset + segment->sg_offset;
 }
 
 void iscsi_tcp_segment_unmap(struct iscsi_segment *segment)
 {
-	debug_tcp("iscsi_tcp_segment_unmap %p\n", segment);
-
 	if (segment->sg_mapped) {
-		debug_tcp("iscsi_tcp_segment_unmap valid\n");
 		kunmap_atomic(segment->sg_mapped, KM_SOFTIRQ0);
 		segment->sg_mapped = NULL;
 		segment->data = NULL;
@@ -180,8 +183,9 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 	struct scatterlist sg;
 	unsigned int pad;
 
-	debug_tcp("copied %u %u size %u %s\n", segment->copied, copied,
-		  segment->size, recv ? "recv" : "xmit");
+	ISCSI_DBG_TCP(tcp_conn->iscsi_conn, "copied %u %u size %u %s\n",
+		      segment->copied, copied, segment->size,
+		      recv ? "recv" : "xmit");
 	if (segment->hash && copied) {
 		/*
 		 * If a segment is kmapd we must unmap it before sending
@@ -214,8 +218,8 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 	iscsi_tcp_segment_unmap(segment);
 
 	/* Do we have more scatterlist entries? */
-	debug_tcp("total copied %u total size %u\n", segment->total_copied,
-		   segment->total_size);
+	ISCSI_DBG_TCP(tcp_conn->iscsi_conn, "total copied %u total size %u\n",
+		      segment->total_copied, segment->total_size);
 	if (segment->total_copied < segment->total_size) {
 		/* Proceed to the next entry in the scatterlist. */
 		iscsi_tcp_segment_init_sg(segment, sg_next(segment->sg),
@@ -229,7 +233,8 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 	if (!(tcp_conn->iscsi_conn->session->tt->caps & CAP_PADDING_OFFLOAD)) {
 		pad = iscsi_padding(segment->total_copied);
 		if (pad != 0) {
-			debug_tcp("consume %d pad bytes\n", pad);
+			ISCSI_DBG_TCP(tcp_conn->iscsi_conn,
+				      "consume %d pad bytes\n", pad);
 			segment->total_size += pad;
 			segment->size = pad;
 			segment->data = segment->padbuf;
@@ -278,13 +283,13 @@ iscsi_tcp_segment_recv(struct iscsi_tcp_conn *tcp_conn,
 
 	while (!iscsi_tcp_segment_done(tcp_conn, segment, 1, copy)) {
 		if (copied == len) {
-			debug_tcp("iscsi_tcp_segment_recv copied %d bytes\n",
-				  len);
+			ISCSI_DBG_TCP(tcp_conn->iscsi_conn,
+				      "copied %d bytes\n", len);
 			break;
 		}
 
 		copy = min(len - copied, segment->size - segment->copied);
-		debug_tcp("iscsi_tcp_segment_recv copying %d\n", copy);
+		ISCSI_DBG_TCP(tcp_conn->iscsi_conn, "copying %d\n", copy);
 		memcpy(segment->data + segment->copied, ptr + copied, copy);
 		copied += copy;
 	}
@@ -311,7 +316,7 @@ iscsi_tcp_dgst_verify(struct iscsi_tcp_conn *tcp_conn,
 
 	if (memcmp(segment->recv_digest, segment->digest,
 		   segment->digest_len)) {
-		debug_scsi("digest mismatch\n");
+		ISCSI_DBG_TCP(tcp_conn->iscsi_conn, "digest mismatch\n");
 		return 0;
 	}
 
@@ -355,12 +360,8 @@ iscsi_segment_seek_sg(struct iscsi_segment *segment,
 	struct scatterlist *sg;
 	unsigned int i;
 
-	debug_scsi("iscsi_segment_seek_sg offset %u size %llu\n",
-		  offset, size);
 	__iscsi_segment_init(segment, size, done, hash);
 	for_each_sg(sg_list, sg, sg_count, i) {
-		debug_scsi("sg %d, len %u offset %u\n", i, sg->length,
-			   sg->offset);
 		if (offset < sg->length) {
 			iscsi_tcp_segment_init_sg(segment, sg, offset);
 			return 0;
@@ -382,8 +383,9 @@ EXPORT_SYMBOL_GPL(iscsi_segment_seek_sg);
  */
 void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 {
-	debug_tcp("iscsi_tcp_hdr_recv_prep(%p%s)\n", tcp_conn,
-		  tcp_conn->iscsi_conn->hdrdgst_en ? ", digest enabled" : "");
+	ISCSI_DBG_TCP(tcp_conn->iscsi_conn,
+		      "(%s)\n", tcp_conn->iscsi_conn->hdrdgst_en ?
+		      "digest enabled" : "digest disabled");
 	iscsi_segment_init_linear(&tcp_conn->in.segment,
 				tcp_conn->in.hdr_buf, sizeof(struct iscsi_hdr),
 				iscsi_tcp_hdr_recv_done, NULL);
@@ -446,7 +448,7 @@ void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 	while (__kfifo_get(tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
 		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
-		debug_scsi("iscsi_tcp_cleanup_task pending r2t dropped\n");
+		ISCSI_DBG_TCP(task->conn, "pending r2t dropped\n");
 	}
 
 	r2t = tcp_task->r2t;
@@ -476,8 +478,8 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 		return 0;
 
 	if (tcp_task->exp_datasn != datasn) {
-		debug_tcp("%s: task->exp_datasn(%d) != rhdr->datasn(%d)\n",
-		          __func__, tcp_task->exp_datasn, datasn);
+		ISCSI_DBG_TCP(conn, "task->exp_datasn(%d) != rhdr->datasn(%d)"
+			      "\n", tcp_task->exp_datasn, datasn);
 		return ISCSI_ERR_DATASN;
 	}
 
@@ -485,9 +487,9 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 
 	tcp_task->data_offset = be32_to_cpu(rhdr->offset);
 	if (tcp_task->data_offset + tcp_conn->in.datalen > total_in_length) {
-		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
-		          __func__, tcp_task->data_offset,
-		          tcp_conn->in.datalen, total_in_length);
+		ISCSI_DBG_TCP(conn, "data_offset(%d) + data_len(%d) > "
+			      "total_length_in(%d)\n", tcp_task->data_offset,
+			      tcp_conn->in.datalen, total_in_length);
 		return ISCSI_ERR_DATA_OFFSET;
 	}
 
@@ -518,8 +520,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	}
 
 	if (tcp_task->exp_datasn != r2tsn){
-		debug_tcp("%s: task->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
-		          __func__, tcp_task->exp_datasn, r2tsn);
+		ISCSI_DBG_TCP(conn, "task->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
+			      tcp_task->exp_datasn, r2tsn);
 		return ISCSI_ERR_R2TSN;
 	}
 
@@ -552,9 +554,9 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	}
 
 	if (r2t->data_length > session->max_burst)
-		debug_scsi("invalid R2T with data len %u and max burst %u."
-			   "Attempting to execute request.\n",
-			    r2t->data_length, session->max_burst);
+		ISCSI_DBG_TCP(conn, "invalid R2T with data len %u and max "
+			      "burst %u. Attempting to execute request.\n",
+			      r2t->data_length, session->max_burst);
 
 	r2t->data_offset = be32_to_cpu(rhdr->data_offset);
 	if (r2t->data_offset + r2t->data_length > scsi_out(task->sc)->length) {
@@ -641,8 +643,8 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	if (rc)
 		return rc;
 
-	debug_tcp("opcode 0x%x ahslen %d datalen %d\n",
-		  opcode, ahslen, tcp_conn->in.datalen);
+	ISCSI_DBG_TCP(conn, "opcode 0x%x ahslen %d datalen %d\n",
+		      opcode, ahslen, tcp_conn->in.datalen);
 
 	switch(opcode) {
 	case ISCSI_OP_SCSI_DATA_IN:
@@ -674,10 +676,10 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
 				rx_hash = tcp_conn->rx_hash;
 
-			debug_tcp("iscsi_tcp_begin_data_in(%p, offset=%d, "
-				  "datalen=%d)\n", tcp_conn,
-				  tcp_task->data_offset,
-				  tcp_conn->in.datalen);
+			ISCSI_DBG_TCP(conn, "iscsi_tcp_begin_data_in( "
+				     "offset=%d, datalen=%d)\n",
+				      tcp_task->data_offset,
+				      tcp_conn->in.datalen);
 			rc = iscsi_segment_seek_sg(&tcp_conn->in.segment,
 						   sdb->table.sgl,
 						   sdb->table.nents,
@@ -854,10 +856,10 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 	unsigned int consumed = 0;
 	int rc = 0;
 
-	debug_tcp("in %d bytes\n", skb->len - offset);
+	ISCSI_DBG_TCP(conn, "in %d bytes\n", skb->len - offset);
 
 	if (unlikely(conn->suspend_rx)) {
-		debug_tcp("conn %d Rx suspended!\n", conn->id);
+		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
 		*status = ISCSI_TCP_SUSPENDED;
 		return 0;
 	}
@@ -874,15 +876,16 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 
 		avail = skb_seq_read(consumed, &ptr, &seq);
 		if (avail == 0) {
-			debug_tcp("no more data avail. Consumed %d\n",
-				  consumed);
+			ISCSI_DBG_TCP(conn, "no more data avail. Consumed %d\n",
+				      consumed);
 			*status = ISCSI_TCP_SKB_DONE;
 			skb_abort_seq_read(&seq);
 			goto skb_done;
 		}
 		BUG_ON(segment->copied >= segment->size);
 
-		debug_tcp("skb %p ptr=%p avail=%u\n", skb, ptr, avail);
+		ISCSI_DBG_TCP(conn, "skb %p ptr=%p avail=%u\n", skb, ptr,
+			      avail);
 		rc = iscsi_tcp_segment_recv(tcp_conn, segment, ptr, avail);
 		BUG_ON(rc == 0);
 		consumed += rc;
@@ -895,11 +898,11 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 
 segment_done:
 	*status = ISCSI_TCP_SEGMENT_DONE;
-	debug_tcp("segment done\n");
+	ISCSI_DBG_TCP(conn, "segment done\n");
 	rc = segment->done(tcp_conn, segment);
 	if (rc != 0) {
 		*status = ISCSI_TCP_CONN_ERR;
-		debug_tcp("Error receiving PDU, errno=%d\n", rc);
+		ISCSI_DBG_TCP(conn, "Error receiving PDU, errno=%d\n", rc);
 		iscsi_conn_failure(conn, rc);
 		return 0;
 	}
@@ -929,8 +932,7 @@ int iscsi_tcp_task_init(struct iscsi_task *task)
 		 * mgmt tasks do not have a scatterlist since they come
 		 * in from the iscsi interface.
 		 */
-		debug_scsi("mtask deq [cid %d itt 0x%x]\n", conn->id,
-			   task->itt);
+		ISCSI_DBG_TCP(conn, "mtask deq [itt 0x%x]\n", task->itt);
 
 		return conn->session->tt->init_pdu(task, 0, task->data_count);
 	}
@@ -939,9 +941,8 @@ int iscsi_tcp_task_init(struct iscsi_task *task)
 	tcp_task->exp_datasn = 0;
 
 	/* Prepare PDU, optionally w/ immediate data */
-	debug_scsi("task deq [cid %d itt 0x%x imm %d unsol %d]\n",
-		    conn->id, task->itt, task->imm_count,
-		    task->unsol_r2t.data_length);
+	ISCSI_DBG_TCP(conn, "task deq [itt 0x%x imm %d unsol %d]\n",
+		      task->itt, task->imm_count, task->unsol_r2t.data_length);
 
 	err = conn->session->tt->init_pdu(task, 0, task->imm_count);
 	if (err)
@@ -965,7 +966,8 @@ static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
 			r2t = tcp_task->r2t;
 			/* Continue with this R2T? */
 			if (r2t->data_length <= r2t->sent) {
-				debug_scsi("  done with r2t %p\n", r2t);
+				ISCSI_DBG_TCP(task->conn,
+					      "  done with r2t %p\n", r2t);
 				__kfifo_put(tcp_task->r2tpool.queue,
 					    (void *)&tcp_task->r2t,
 					    sizeof(void *));
@@ -1019,7 +1021,7 @@ flush:
 	r2t = iscsi_tcp_get_curr_r2t(task);
 	if (r2t == NULL) {
 		/* Waiting for more R2Ts to arrive. */
-		debug_tcp("no R2Ts yet\n");
+		ISCSI_DBG_TCP(conn, "no R2Ts yet\n");
 		return 0;
 	}
 
@@ -1028,9 +1030,9 @@ flush:
 		return rc;
 	iscsi_prep_data_out_pdu(task, r2t, (struct iscsi_data *) task->hdr);
 
-	debug_scsi("sol dout %p [dsn %d itt 0x%x doff %d dlen %d]\n",
-		   r2t, r2t->datasn - 1, task->hdr->itt,
-		   r2t->data_offset + r2t->sent, r2t->data_count);
+	ISCSI_DBG_TCP(conn, "sol dout %p [dsn %d itt 0x%x doff %d dlen %d]\n",
+		      r2t, r2t->datasn - 1, task->hdr->itt,
+		      r2t->data_offset + r2t->sent, r2t->data_count);
 
 	rc = conn->session->tt->init_pdu(task, r2t->data_offset + r2t->sent,
 					 r2t->data_count);
-- 
1.6.0.6

