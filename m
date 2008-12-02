From: michaelc@cs.wisc.edu
Subject: [PATCH 13/13] libiscsi_tcp: support padding offload
Date: Tue,  2 Dec 2008 00:32:16 -0600
Message-ID: <1228199536-12595-14-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-5-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-6-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-7-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-8-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-9-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-10-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-11-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-12-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-13-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52479 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbYLBGc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:28 -0500
In-Reply-To: <1228199536-12595-13-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

cxgb3i does not offload the processing of the header,
but it will always process the padding. This patch
adds a padding offload flag to detect when the LLD
supports this.

The patch also modifies the header processing so that
we do not try to read/bypass the header dugest in the
skb. cxgb3i will not include it with the header like
with other offload cards.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c    |    9 +++++----
 drivers/scsi/libiscsi_tcp.c |   37 ++++++++++++++++++++-----------------
 include/scsi/iscsi_if.h     |    2 ++
 include/scsi/libiscsi_tcp.h |    3 ++-
 4 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c65175e..8685a33 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -194,7 +194,7 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_sw_tcp_conn *tcp_sw_conn)
 
 /**
  * iscsi_sw_tcp_xmit_segment - transmit segment
- * @tcp_sw_conn: the iSCSI TCP connection
+ * @tcp_conn: the iSCSI TCP connection
  * @segment: the buffer to transmnit
  *
  * This function transmits as much of the buffer as
@@ -205,14 +205,15 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_sw_tcp_conn *tcp_sw_conn)
  * hash as it goes. When the entire segment has been transmitted,
  * it will retrieve the hash value and send it as well.
  */
-static int iscsi_sw_tcp_xmit_segment(struct iscsi_sw_tcp_conn *tcp_sw_conn,
+static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 				     struct iscsi_segment *segment)
 {
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct socket *sk = tcp_sw_conn->sock;
 	unsigned int copied = 0;
 	int r = 0;
 
-	while (!iscsi_tcp_segment_done(segment, 0, r)) {
+	while (!iscsi_tcp_segment_done(tcp_conn, segment, 0, r)) {
 		struct scatterlist *sg;
 		unsigned int offset, copy;
 		int flags = 0;
@@ -263,7 +264,7 @@ static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
 	int rc = 0;
 
 	while (1) {
-		rc = iscsi_sw_tcp_xmit_segment(tcp_sw_conn, segment);
+		rc = iscsi_sw_tcp_xmit_segment(tcp_conn, segment);
 		if (rc < 0) {
 			rc = ISCSI_ERR_XMIT_FAILED;
 			goto error;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 9df6b34..a745f91 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -159,6 +159,7 @@ iscsi_tcp_segment_splice_digest(struct iscsi_segment *segment, void *digest)
 
 /**
  * iscsi_tcp_segment_done - check whether the segment is complete
+ * @tcp_conn: iscsi tcp connection
  * @segment: iscsi segment to check
  * @recv: set to one of this is called from the recv path
  * @copied: number of bytes copied
@@ -172,7 +173,8 @@ iscsi_tcp_segment_splice_digest(struct iscsi_segment *segment, void *digest)
  *
  * This function must be re-entrant.
  */
-int iscsi_tcp_segment_done(struct iscsi_segment *segment, int recv,
+int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
+			   struct iscsi_segment *segment, int recv,
 			   unsigned copied)
 {
 	static unsigned char padbuf[ISCSI_PAD_LEN];
@@ -225,13 +227,15 @@ int iscsi_tcp_segment_done(struct iscsi_segment *segment, int recv,
 	}
 
 	/* Do we need to handle padding? */
-	pad = iscsi_padding(segment->total_copied);
-	if (pad != 0) {
-		debug_tcp("consume %d pad bytes\n", pad);
-		segment->total_size += pad;
-		segment->size = pad;
-		segment->data = padbuf;
-		return 0;
+	if (!(tcp_conn->iscsi_conn->session->tt->caps & CAP_PADDING_OFFLOAD)) {
+		pad = iscsi_padding(segment->total_copied);
+		if (pad != 0) {
+			debug_tcp("consume %d pad bytes\n", pad);
+			segment->total_size += pad;
+			segment->size = pad;
+			segment->data = padbuf;
+			return 0;
+		}
 	}
 
 	/*
@@ -273,7 +277,7 @@ iscsi_tcp_segment_recv(struct iscsi_tcp_conn *tcp_conn,
 {
 	unsigned int copy = 0, copied = 0;
 
-	while (!iscsi_tcp_segment_done(segment, 1, copy)) {
+	while (!iscsi_tcp_segment_done(tcp_conn, segment, 1, copy)) {
 		if (copied == len) {
 			debug_tcp("iscsi_tcp_segment_recv copied %d bytes\n",
 				  len);
@@ -794,7 +798,8 @@ iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 	/* We're done processing the header. See if we're doing
 	 * header digests; if so, set up the recv_digest buffer
 	 * and go back for more. */
-	if (conn->hdrdgst_en) {
+	if (conn->hdrdgst_en &&
+	    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD)) {
 		if (segment->digest_len == 0) {
 			/*
 			 * Even if we offload the digest processing we
@@ -806,14 +811,12 @@ iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 			return 0;
 		}
 
-		if (!(conn->session->tt->caps & CAP_DIGEST_OFFLOAD)) {
-			iscsi_tcp_dgst_header(tcp_conn->rx_hash, hdr,
-				segment->total_copied - ISCSI_DIGEST_SIZE,
-				segment->digest);
+		iscsi_tcp_dgst_header(tcp_conn->rx_hash, hdr,
+				      segment->total_copied - ISCSI_DIGEST_SIZE,
+				      segment->digest);
 
-			if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
-				return ISCSI_ERR_HDR_DGST;
-		}
+		if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
+			return ISCSI_ERR_HDR_DGST;
 	}
 
 	tcp_conn->in.hdr = hdr;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 8e008c9..d0ed522 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -336,6 +336,8 @@ enum iscsi_host_param {
 #define CAP_SENDTARGETS_OFFLOAD	0x400	/* offload discovery process */
 #define CAP_DATA_PATH_OFFLOAD	0x800	/* offload entire IO path */
 #define CAP_DIGEST_OFFLOAD	0x1000	/* offload hdr and data digests */
+#define CAP_PADDING_OFFLOAD	0x2000	/* offload padding insertion, removal,
+					 and verification */
 
 /*
  * These flags describes reason of stop_conn() call
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index e6bf8ef..83e32f6 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -99,7 +99,8 @@ extern int iscsi_tcp_task_xmit(struct iscsi_task *task);
 
 /* segment helpers */
 extern int iscsi_tcp_recv_segment_is_hdr(struct iscsi_tcp_conn *tcp_conn);
-extern int iscsi_tcp_segment_done(struct iscsi_segment *segment, int recv,
+extern int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
+				  struct iscsi_segment *segment, int recv,
 				  unsigned copied);
 extern void iscsi_tcp_segment_unmap(struct iscsi_segment *segment);
 
-- 
1.5.6.5

