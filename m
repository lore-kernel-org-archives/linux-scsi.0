From: michaelc@cs.wisc.edu
Subject: [PATCH 01/13] prepare iscsi_tcp helpers for LLDs that can offload some operations
Date: Tue,  2 Dec 2008 00:32:04 -0600
Message-ID: <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbYLBGcW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:22 -0500
In-Reply-To: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

cxgb3i is unlike qla4xxx and bnx2i in that it does not offload entire
scsi commands or iscsi sequences. Instead it only offloads the transfer
of a ISCSI DATA_IN pdu's data, the digests and padding. This patch fixes up the
iscsi tcp recv path so that it exports its skb recv processing so
cxgb3i and other drivers can call them. All they have to do is pass
the function the skb with the hdr or data pdu header and this function
will do the rest.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |  120 ++++++++++++++++++++++++++++++++++------------
 include/scsi/iscsi_if.h  |    5 +-
 2 files changed, 92 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ed6c54c..d8066c0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -486,7 +486,8 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
 	struct hash_desc *rx_hash = NULL;
 
-	if (conn->datadgst_en)
+	if (conn->datadgst_en &
+	    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
 		rx_hash = &tcp_conn->rx_hash;
 
 	iscsi_segment_init_linear(&tcp_conn->in.segment,
@@ -774,7 +775,8 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			 * we move on to the next scatterlist entry and
 			 * update the digest per-entry.
 			 */
-			if (conn->datadgst_en)
+			if (conn->datadgst_en &&
+			    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
 				rx_hash = &tcp_conn->rx_hash;
 
 			debug_tcp("iscsi_tcp_begin_data_in(%p, offset=%d, "
@@ -902,34 +904,52 @@ iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 	 * and go back for more. */
 	if (conn->hdrdgst_en) {
 		if (segment->digest_len == 0) {
+			/*
+			 * Even if we offload the digest processing we
+			 * splice it in so we can increment the skb/segment
+			 * counters in preparation for the data segment.
+			 */
 			iscsi_tcp_segment_splice_digest(segment,
 							segment->recv_digest);
 			return 0;
 		}
-		iscsi_tcp_dgst_header(&tcp_conn->rx_hash, hdr,
-				      segment->total_copied - ISCSI_DIGEST_SIZE,
-				      segment->digest);
 
-		if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
-			return ISCSI_ERR_HDR_DGST;
+		if (!(conn->session->tt->caps & CAP_DIGEST_OFFLOAD)) {
+			iscsi_tcp_dgst_header(&tcp_conn->rx_hash, hdr,
+				segment->total_copied - ISCSI_DIGEST_SIZE,
+				segment->digest);
+
+			if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
+				return ISCSI_ERR_HDR_DGST;
+		}
 	}
 
 	tcp_conn->in.hdr = hdr;
 	return iscsi_tcp_hdr_dissect(conn, hdr);
 }
 
+inline int iscsi_tcp_recv_segment_is_hdr(struct iscsi_tcp_conn *tcp_conn)
+{
+	return tcp_conn->in.segment.done == iscsi_tcp_hdr_recv_done;
+}
+
+enum {
+	ISCSI_TCP_SEGMENT_DONE,		/* curr seg has been processed */
+	ISCSI_TCP_SKB_DONE,		/* skb is out of data */
+	ISCSI_TCP_CONN_ERR,		/* iscsi layer has fired a conn err */
+	ISCSI_TCP_SUSPENDED,		/* conn is suspended */
+};
+
 /**
- * iscsi_tcp_recv - TCP receive in sendfile fashion
- * @rd_desc: read descriptor
- * @skb: socket buffer
+ * iscsi_tcp_recv_skb - Process skb
+ * @conn: iscsi connection
+ * @skb: network buffer with header and/or data segment
  * @offset: offset in skb
- * @len: skb->len - offset
- **/
-static int
-iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
-	       unsigned int offset, size_t len)
+ * @offload: bool indicating if transfer was offloaded
+ */
+int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
+		       unsigned int offset, bool offloaded, int *status)
 {
-	struct iscsi_conn *conn = rd_desc->arg.data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_segment *segment = &tcp_conn->in.segment;
 	struct skb_seq_state seq;
@@ -940,9 +960,15 @@ iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 
 	if (unlikely(conn->suspend_rx)) {
 		debug_tcp("conn %d Rx suspended!\n", conn->id);
+		*status = ISCSI_TCP_SUSPENDED;
 		return 0;
 	}
 
+	if (offloaded) {
+		segment->total_copied = segment->total_size;
+		goto segment_done;
+	}
+
 	skb_prepare_seq_read(skb, offset, skb->len, &seq);
 	while (1) {
 		unsigned int avail;
@@ -952,7 +978,9 @@ iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 		if (avail == 0) {
 			debug_tcp("no more data avail. Consumed %d\n",
 				  consumed);
-			break;
+			*status = ISCSI_TCP_SKB_DONE;
+			skb_abort_seq_read(&seq);
+			goto skb_done;
 		}
 		BUG_ON(segment->copied >= segment->size);
 
@@ -962,25 +990,55 @@ iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 		consumed += rc;
 
 		if (segment->total_copied >= segment->total_size) {
-			debug_tcp("segment done\n");
-			rc = segment->done(tcp_conn, segment);
-			if (rc != 0) {
-				skb_abort_seq_read(&seq);
-				goto error;
-			}
-
-			/* The done() functions sets up the
-			 * next segment. */
+			skb_abort_seq_read(&seq);
+			goto segment_done;
 		}
 	}
-	skb_abort_seq_read(&seq);
+
+segment_done:
+	*status = ISCSI_TCP_SEGMENT_DONE;
+	debug_tcp("segment done\n");
+	rc = segment->done(tcp_conn, segment);
+	if (rc != 0) {
+		*status = ISCSI_TCP_CONN_ERR;
+		debug_tcp("Error receiving PDU, errno=%d\n", rc);
+		iscsi_conn_failure(conn, rc);
+		return 0;
+	}
+	/* The done() functions sets up the next segment. */
+
+skb_done:
 	conn->rxdata_octets += consumed;
 	return consumed;
+}
+EXPORT_SYMBOL_GPL(iscsi_tcp_recv_skb);
 
-error:
-	debug_tcp("Error receiving PDU, errno=%d\n", rc);
-	iscsi_conn_failure(conn, rc);
-	return 0;
+/**
+ * iscsi_tcp_recv - TCP receive in sendfile fashion
+ * @rd_desc: read descriptor
+ * @skb: socket buffer
+ * @offset: offset in skb
+ * @len: skb->len - offset
+ **/
+static int
+iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
+	       unsigned int offset, size_t len)
+{
+	struct iscsi_conn *conn = rd_desc->arg.data;
+	unsigned int consumed, total_consumed = 0;
+	int status;
+
+	debug_tcp("in %d bytes\n", skb->len - offset);
+
+	do {
+		status = 0;
+		consumed = iscsi_tcp_recv_skb(conn, skb, offset, 0, &status);
+		offset += consumed;
+		total_consumed += consumed;
+	} while (consumed != 0 && status != ISCSI_TCP_SKB_DONE);
+
+	debug_tcp("read %d bytes status %d\n", skb->len - offset, status);
+	return total_consumed;
 }
 
 static void
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 0c9514d..8e008c9 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -333,8 +333,9 @@ enum iscsi_host_param {
 #define CAP_TEXT_NEGO		0x80
 #define CAP_MARKERS		0x100
 #define CAP_FW_DB		0x200
-#define CAP_SENDTARGETS_OFFLOAD	0x400
-#define CAP_DATA_PATH_OFFLOAD	0x800
+#define CAP_SENDTARGETS_OFFLOAD	0x400	/* offload discovery process */
+#define CAP_DATA_PATH_OFFLOAD	0x800	/* offload entire IO path */
+#define CAP_DIGEST_OFFLOAD	0x1000	/* offload hdr and data digests */
 
 /*
  * These flags describes reason of stop_conn() call
-- 
1.5.6.5

