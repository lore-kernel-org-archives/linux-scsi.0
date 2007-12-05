From: michaelc@cs.wisc.edu
Subject: [PATCH 16/23] convert xmit path to iscsi chunks
Date: Tue,  4 Dec 2007 18:42:30 -0600
Message-ID: <11968153853971-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
 <11968153753743-git-send-email-michaelc@cs.wisc.edu>
 <11968153751098-git-send-email-michaelc@cs.wisc.edu>
 <1196815376111-git-send-email-michaelc@cs.wisc.edu>
 <1196815377131-git-send-email-michaelc@cs.wisc.edu>
 <11968153781126-git-send-email-michaelc@cs.wisc.edu>
 <1196815378769-git-send-email-michaelc@cs.wisc.edu>
 <11968153791438-git-send-email-michaelc@cs.wisc.edu>
 <11968153801823-git-send-email-michaelc@cs.wisc.edu>
 <11968153812001-git-send-email-michaelc@cs.wisc.edu>
 <1196815382808-git-send-email-michaelc@cs.wisc.edu>
 <11968153831244-git-send-email-michaelc@cs.wisc.edu>
 <11968153842186-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXLEAoJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:44:09 -0500
In-Reply-To: <11968153842186-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Olaf Kirch <olaf.kirch@oracle.com>

From: Mike Christie <michaelc@cs.wisc.edu>

from olaf.kirch@oracle.com:

Convert xmit to iscsi chunks.

from michaelc@cs.wisc.edu:

Bug fixes, more digest integration, sg chaining conversion and other
sg wrapper changes, coding style sync up, and removal of io fields,
like pdu_sent, that are not needed.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    3 +-
 drivers/scsi/iscsi_tcp.c                 | 1333 ++++++++++++------------------
 drivers/scsi/iscsi_tcp.h                 |   75 +--
 drivers/scsi/libiscsi.c                  |   37 +-
 include/scsi/scsi_transport_iscsi.h      |    2 +-
 5 files changed, 563 insertions(+), 887 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 2656064..fd69fb3 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -129,7 +129,7 @@ error:
  * iscsi_iser_cmd_init - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
  *
  **/
-static void
+static int
 iscsi_iser_cmd_init(struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_iser_conn     *iser_conn  = ctask->conn->dd_data;
@@ -138,6 +138,7 @@ iscsi_iser_cmd_init(struct iscsi_cmd_task *ctask)
 	iser_ctask->command_sent = 0;
 	iser_ctask->iser_conn    = iser_conn;
 	iser_ctask_rdma_init(iser_ctask);
+	return 0;
 }
 
 /**
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9b41852..7212fe9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -68,56 +68,10 @@ static unsigned int iscsi_max_lun = 512;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
 static int iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
-				   struct iscsi_chunk *chunk);
-
-static inline void
-iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
-{
-	ibuf->sg.page = virt_to_page(vbuf);
-	ibuf->sg.offset = offset_in_page(vbuf);
-	ibuf->sg.length = size;
-	ibuf->sent = 0;
-	ibuf->use_sendmsg = 1;
-}
-
-static inline void
-iscsi_buf_init_sg(struct iscsi_buf *ibuf, struct scatterlist *sg)
-{
-	ibuf->sg.page = sg->page;
-	ibuf->sg.offset = sg->offset;
-	ibuf->sg.length = sg->length;
-	/*
-	 * Fastpath: sg element fits into single page
-	 */
-	if (sg->length + sg->offset <= PAGE_SIZE && !PageSlab(sg->page))
-		ibuf->use_sendmsg = 0;
-	else
-		ibuf->use_sendmsg = 1;
-	ibuf->sent = 0;
-}
-
-static inline int
-iscsi_buf_left(struct iscsi_buf *ibuf)
-{
-	int rc;
-
-	rc = ibuf->sg.length - ibuf->sent;
-	BUG_ON(rc < 0);
-	return rc;
-}
-
-static inline void
-iscsi_hdr_digest(struct iscsi_conn *conn, struct iscsi_buf *buf,
-		 u8* crc)
-{
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-
-	crypto_hash_digest(&tcp_conn->tx_hash, &buf->sg, buf->sg.length, crc);
-	buf->sg.length += ISCSI_DIGEST_SIZE;
-}
+				   struct iscsi_segment *segment);
 
 /*
- * Scatterlist handling: inside the iscsi_chunk, we
+ * Scatterlist handling: inside the iscsi_segment, we
  * remember an index into the scatterlist, and set data/size
  * to the current scatterlist entry. For highmem pages, we
  * kmap as needed.
@@ -130,60 +84,72 @@ iscsi_hdr_digest(struct iscsi_conn *conn, struct iscsi_buf *buf,
  */
 
 /**
- * iscsi_tcp_chunk_init_sg - init indicated scatterlist entry
- * @chunk: the buffer object
- * @idx: index into scatterlist
+ * iscsi_tcp_segment_init_sg - init indicated scatterlist entry
+ * @segment: the buffer object
+ * @sg: scatterlist
  * @offset: byte offset into that sg entry
  *
- * This function sets up the chunk so that subsequent
+ * This function sets up the segment so that subsequent
  * data is copied to the indicated sg entry, at the given
  * offset.
  */
 static inline void
-iscsi_tcp_chunk_init_sg(struct iscsi_chunk *chunk,
-			unsigned int idx, unsigned int offset)
+iscsi_tcp_segment_init_sg(struct iscsi_segment *segment,
+			  struct scatterlist *sg, unsigned int offset)
 {
-	struct scatterlist *sg;
-
-	BUG_ON(chunk->sg == NULL);
-
-	sg = &chunk->sg[idx];
-	chunk->sg_index = idx;
-	chunk->sg_offset = offset;
-	chunk->size = min(sg->length - offset, chunk->total_size);
-	chunk->data = NULL;
+	segment->sg = sg;
+	segment->sg_offset = offset;
+	segment->size = min(sg->length - offset,
+			    segment->total_size - segment->total_copied);
+	segment->data = NULL;
 }
 
 /**
- * iscsi_tcp_chunk_map - map the current S/G page
- * @chunk: iscsi chunk
+ * iscsi_tcp_segment_map - map the current S/G page
+ * @segment: iscsi_segment
+ * @recv: 1 if called from recv path
  *
  * We only need to possibly kmap data if scatter lists are being used,
  * because the iscsi passthrough and internal IO paths will never use high
  * mem pages.
  */
 static inline void
-iscsi_tcp_chunk_map(struct iscsi_chunk *chunk)
+iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
 {
 	struct scatterlist *sg;
 
-	if (chunk->data != NULL || !chunk->sg)
+	if (segment->data != NULL || !segment->sg)
 		return;
 
-	sg = &chunk->sg[chunk->sg_index];
-	BUG_ON(chunk->sg_mapped);
+	sg = segment->sg;
+	BUG_ON(segment->sg_mapped);
 	BUG_ON(sg->length == 0);
-	chunk->sg_mapped = kmap_atomic(sg->page, KM_SOFTIRQ0);
-	chunk->data = chunk->sg_mapped + sg->offset + chunk->sg_offset;
+
+	/*
+	 * If the page count is greater than one it is ok to send
+	 * to the network layer's zero copy send path. If not we
+	 * have to go the slow sendmsg path. We always map for the
+	 * recv path.
+	 */
+	if (page_count(sg_page(sg)) >= 1 && !recv)
+		return;
+
+	debug_tcp("iscsi_tcp_segment_map %s %p\n", recv ? "recv" : "xmit",
+		  segment);
+	segment->sg_mapped = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
+	segment->data = segment->sg_mapped + sg->offset + segment->sg_offset;
 }
 
 static inline void
-iscsi_tcp_chunk_unmap(struct iscsi_chunk *chunk)
+iscsi_tcp_segment_unmap(struct iscsi_segment *segment)
 {
-	if (chunk->sg_mapped) {
-		kunmap_atomic(chunk->sg_mapped, KM_SOFTIRQ0);
-		chunk->sg_mapped = NULL;
-		chunk->data = NULL;
+	debug_tcp("iscsi_tcp_segment_unmap %p\n", segment);
+
+	if (segment->sg_mapped) {
+		debug_tcp("iscsi_tcp_segment_unmap valid\n");
+		kunmap_atomic(segment->sg_mapped, KM_SOFTIRQ0);
+		segment->sg_mapped = NULL;
+		segment->data = NULL;
 	}
 }
 
@@ -191,23 +157,24 @@ iscsi_tcp_chunk_unmap(struct iscsi_chunk *chunk)
  * Splice the digest buffer into the buffer
  */
 static inline void
-iscsi_tcp_chunk_splice_digest(struct iscsi_chunk *chunk, void *digest)
+iscsi_tcp_segment_splice_digest(struct iscsi_segment *segment, void *digest)
 {
-	chunk->data = digest;
-	chunk->digest_len = ISCSI_DIGEST_SIZE;
-	chunk->total_size += ISCSI_DIGEST_SIZE;
-	chunk->size = ISCSI_DIGEST_SIZE;
-	chunk->copied = 0;
-	chunk->sg = NULL;
-	chunk->sg_index = 0;
-	chunk->hash = NULL;
+	segment->data = digest;
+	segment->digest_len = ISCSI_DIGEST_SIZE;
+	segment->total_size += ISCSI_DIGEST_SIZE;
+	segment->size = ISCSI_DIGEST_SIZE;
+	segment->copied = 0;
+	segment->sg = NULL;
+	segment->hash = NULL;
 }
 
 /**
- * iscsi_tcp_chunk_done - check whether the chunk is complete
- * @chunk: iscsi chunk to check
+ * iscsi_tcp_segment_done - check whether the segment is complete
+ * @segment: iscsi segment to check
+ * @recv: set to one of this is called from the recv path
+ * @copied: number of bytes copied
  *
- * Check if we're done receiving this chunk. If the receive
+ * Check if we're done receiving this segment. If the receive
  * buffer is full but we expect more data, move on to the
  * next entry in the scatterlist.
  *
@@ -217,62 +184,145 @@ iscsi_tcp_chunk_splice_digest(struct iscsi_chunk *chunk, void *digest)
  * This function must be re-entrant.
  */
 static inline int
-iscsi_tcp_chunk_done(struct iscsi_chunk *chunk)
+iscsi_tcp_segment_done(struct iscsi_segment *segment, int recv, unsigned copied)
 {
 	static unsigned char padbuf[ISCSI_PAD_LEN];
+	struct scatterlist sg;
 	unsigned int pad;
 
-	if (chunk->copied < chunk->size) {
-		iscsi_tcp_chunk_map(chunk);
+	debug_tcp("copied %u %u size %u %s\n", segment->copied, copied,
+		  segment->size, recv ? "recv" : "xmit");
+	if (segment->hash && copied) {
+		/*
+		 * If a segment is kmapd we must unmap it before sending
+		 * to the crypto layer since that will try to kmap it again.
+		 */
+		iscsi_tcp_segment_unmap(segment);
+
+		if (!segment->data) {
+			sg_init_table(&sg, 1);
+			sg_set_page(&sg, sg_page(segment->sg), copied,
+				    segment->copied + segment->sg_offset +
+							segment->sg->offset);
+		} else
+			sg_init_one(&sg, segment->data + segment->copied,
+				    copied);
+		crypto_hash_update(segment->hash, &sg, copied);
+	}
+
+	segment->copied += copied;
+	if (segment->copied < segment->size) {
+		iscsi_tcp_segment_map(segment, recv);
 		return 0;
 	}
 
-	chunk->total_copied += chunk->copied;
-	chunk->copied = 0;
-	chunk->size = 0;
+	segment->total_copied += segment->copied;
+	segment->copied = 0;
+	segment->size = 0;
 
 	/* Unmap the current scatterlist page, if there is one. */
-	iscsi_tcp_chunk_unmap(chunk);
+	iscsi_tcp_segment_unmap(segment);
 
 	/* Do we have more scatterlist entries? */
-	if (chunk->total_copied < chunk->total_size) {
+	debug_tcp("total copied %u total size %u\n", segment->total_copied,
+		   segment->total_size);
+	if (segment->total_copied < segment->total_size) {
 		/* Proceed to the next entry in the scatterlist. */
-		iscsi_tcp_chunk_init_sg(chunk, chunk->sg_index + 1, 0);
-		iscsi_tcp_chunk_map(chunk);
-		BUG_ON(chunk->size == 0);
+		iscsi_tcp_segment_init_sg(segment, sg_next(segment->sg),
+					  0);
+		iscsi_tcp_segment_map(segment, recv);
+		BUG_ON(segment->size == 0);
 		return 0;
 	}
 
 	/* Do we need to handle padding? */
-	pad = iscsi_padding(chunk->total_copied);
+	pad = iscsi_padding(segment->total_copied);
 	if (pad != 0) {
 		debug_tcp("consume %d pad bytes\n", pad);
-		chunk->total_size += pad;
-		chunk->size = pad;
-		chunk->data = padbuf;
+		segment->total_size += pad;
+		segment->size = pad;
+		segment->data = padbuf;
 		return 0;
 	}
 
 	/*
-	 * Set us up for receiving the data digest. hdr digest
+	 * Set us up for transferring the data digest. hdr digest
 	 * is completely handled in hdr done function.
 	 */
-	if (chunk->hash) {
-		if (chunk->digest_len == 0) {
-			crypto_hash_final(chunk->hash, chunk->digest);
-			iscsi_tcp_chunk_splice_digest(chunk,
-						      chunk->recv_digest);
-			return 0;
-		}
+	if (segment->hash) {
+		crypto_hash_final(segment->hash, segment->digest);
+		iscsi_tcp_segment_splice_digest(segment,
+				 recv ? segment->recv_digest : segment->digest);
+		return 0;
 	}
 
 	return 1;
 }
 
 /**
- * iscsi_tcp_chunk_recv - copy data to chunk
+ * iscsi_tcp_xmit_segment - transmit segment
  * @tcp_conn: the iSCSI TCP connection
- * @chunk: the buffer to copy to
+ * @segment: the buffer to transmnit
+ *
+ * This function transmits as much of the buffer as
+ * the network layer will accept, and returns the number of
+ * bytes transmitted.
+ *
+ * If CRC hashing is enabled, the function will compute the
+ * hash as it goes. When the entire segment has been transmitted,
+ * it will retrieve the hash value and send it as well.
+ */
+static int
+iscsi_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
+		       struct iscsi_segment *segment)
+{
+	struct socket *sk = tcp_conn->sock;
+	unsigned int copied = 0;
+	int r = 0;
+
+	while (!iscsi_tcp_segment_done(segment, 0, r)) {
+		struct scatterlist *sg;
+		unsigned int offset, copy;
+		int flags = 0;
+
+		r = 0;
+		offset = segment->copied;
+		copy = segment->size - offset;
+
+		if (segment->total_copied + segment->size < segment->total_size)
+			flags |= MSG_MORE;
+
+		/* Use sendpage if we can; else fall back to sendmsg */
+		if (!segment->data) {
+			sg = segment->sg;
+			offset += segment->sg_offset + sg->offset;
+			r = tcp_conn->sendpage(sk, sg_page(sg), offset, copy,
+					       flags);
+		} else {
+			struct msghdr msg = { .msg_flags = flags };
+			struct kvec iov = {
+				.iov_base = segment->data + offset,
+				.iov_len = copy
+			};
+
+			r = kernel_sendmsg(sk, &msg, &iov, 1, copy);
+		}
+
+		if (r < 0) {
+			iscsi_tcp_segment_unmap(segment);
+			if (copied || r == -EAGAIN)
+				break;
+			return r;
+		}
+		copied += r;
+	}
+	return copied;
+}
+
+/**
+ * iscsi_tcp_segment_recv - copy data to segment
+ * @tcp_conn: the iSCSI TCP connection
+ * @segment: the buffer to copy to
  * @ptr: data pointer
  * @len: amount of data available
  *
@@ -287,29 +337,24 @@ iscsi_tcp_chunk_done(struct iscsi_chunk *chunk)
  * just way we do for network layer checksums.
  */
 static int
-iscsi_tcp_chunk_recv(struct iscsi_tcp_conn *tcp_conn,
-		     struct iscsi_chunk *chunk, const void *ptr,
-		     unsigned int len)
+iscsi_tcp_segment_recv(struct iscsi_tcp_conn *tcp_conn,
+		       struct iscsi_segment *segment, const void *ptr,
+		       unsigned int len)
 {
-	struct scatterlist sg;
-	unsigned int copy, copied = 0;
-
-	while (!iscsi_tcp_chunk_done(chunk)) {
-		if (copied == len)
-			goto out;
+	unsigned int copy = 0, copied = 0;
 
-		copy = min(len - copied, chunk->size - chunk->copied);
-		memcpy(chunk->data + chunk->copied, ptr + copied, copy);
-
-		if (chunk->hash) {
-			sg_init_one(&sg, ptr + copied, copy);
-			crypto_hash_update(chunk->hash, &sg, copy);
+	while (!iscsi_tcp_segment_done(segment, 1, copy)) {
+		if (copied == len) {
+			debug_tcp("iscsi_tcp_segment_recv copied %d bytes\n",
+				  len);
+			break;
 		}
-		chunk->copied += copy;
+
+		copy = min(len - copied, segment->size - segment->copied);
+		debug_tcp("iscsi_tcp_segment_recv copying %d\n", copy);
+		memcpy(segment->data + segment->copied, ptr + copied, copy);
 		copied += copy;
 	}
-
-out:
 	return copied;
 }
 
@@ -325,12 +370,13 @@ iscsi_tcp_dgst_header(struct hash_desc *hash, const void *hdr, size_t hdrlen,
 
 static inline int
 iscsi_tcp_dgst_verify(struct iscsi_tcp_conn *tcp_conn,
-		      struct iscsi_chunk *chunk)
+		      struct iscsi_segment *segment)
 {
-	if (!chunk->digest_len)
+	if (!segment->digest_len)
 		return 1;
 
-	if (memcmp(chunk->recv_digest, chunk->digest, chunk->digest_len)) {
+	if (memcmp(segment->recv_digest, segment->digest,
+		   segment->digest_len)) {
 		debug_scsi("digest mismatch\n");
 		return 0;
 	}
@@ -339,55 +385,59 @@ iscsi_tcp_dgst_verify(struct iscsi_tcp_conn *tcp_conn,
 }
 
 /*
- * Helper function to set up chunk buffer
+ * Helper function to set up segment buffer
  */
 static inline void
-__iscsi_chunk_init(struct iscsi_chunk *chunk, size_t size,
-		   iscsi_chunk_done_fn_t *done, struct hash_desc *hash)
+__iscsi_segment_init(struct iscsi_segment *segment, size_t size,
+		     iscsi_segment_done_fn_t *done, struct hash_desc *hash)
 {
-	memset(chunk, 0, sizeof(*chunk));
-	chunk->total_size = size;
-	chunk->done = done;
+	memset(segment, 0, sizeof(*segment));
+	segment->total_size = size;
+	segment->done = done;
 
 	if (hash) {
-		chunk->hash = hash;
+		segment->hash = hash;
 		crypto_hash_init(hash);
 	}
 }
 
 static inline void
-iscsi_chunk_init_linear(struct iscsi_chunk *chunk, void *data, size_t size,
-			iscsi_chunk_done_fn_t *done, struct hash_desc *hash)
+iscsi_segment_init_linear(struct iscsi_segment *segment, void *data,
+			  size_t size, iscsi_segment_done_fn_t *done,
+			  struct hash_desc *hash)
 {
-	__iscsi_chunk_init(chunk, size, done, hash);
-	chunk->data = data;
-	chunk->size = size;
+	__iscsi_segment_init(segment, size, done, hash);
+	segment->data = data;
+	segment->size = size;
 }
 
 static inline int
-iscsi_chunk_seek_sg(struct iscsi_chunk *chunk,
-		    struct scatterlist *sg, unsigned int sg_count,
-		    unsigned int offset, size_t size,
-		    iscsi_chunk_done_fn_t *done, struct hash_desc *hash)
+iscsi_segment_seek_sg(struct iscsi_segment *segment,
+		      struct scatterlist *sg_list, unsigned int sg_count,
+		      unsigned int offset, size_t size,
+		      iscsi_segment_done_fn_t *done, struct hash_desc *hash)
 {
+	struct scatterlist *sg;
 	unsigned int i;
 
-	__iscsi_chunk_init(chunk, size, done, hash);
-	for (i = 0; i < sg_count; ++i) {
-		if (offset < sg[i].length) {
-			chunk->sg = sg;
-			chunk->sg_count = sg_count;
-			iscsi_tcp_chunk_init_sg(chunk, i, offset);
+	debug_scsi("iscsi_segment_seek_sg offset %u size %llu\n",
+		  offset, size);
+	__iscsi_segment_init(segment, size, done, hash);
+	for_each_sg(sg_list, sg, sg_count, i) {
+		debug_scsi("sg %d, len %u offset %u\n", i, sg->length,
+			   sg->offset);
+		if (offset < sg->length) {
+			iscsi_tcp_segment_init_sg(segment, sg, offset);
 			return 0;
 		}
-		offset -= sg[i].length;
+		offset -= sg->length;
 	}
 
 	return ISCSI_ERR_DATA_OFFSET;
 }
 
 /**
- * iscsi_tcp_hdr_recv_prep - prep chunk for hdr reception
+ * iscsi_tcp_hdr_recv_prep - prep segment for hdr reception
  * @tcp_conn: iscsi connection to prep for
  *
  * This function always passes NULL for the hash argument, because when this
@@ -399,7 +449,7 @@ iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 {
 	debug_tcp("iscsi_tcp_hdr_recv_prep(%p%s)\n", tcp_conn,
 		  tcp_conn->iscsi_conn->hdrdgst_en ? ", digest enabled" : "");
-	iscsi_chunk_init_linear(&tcp_conn->in.chunk,
+	iscsi_segment_init_linear(&tcp_conn->in.segment,
 				tcp_conn->in.hdr_buf, sizeof(struct iscsi_hdr),
 				iscsi_tcp_hdr_recv_done, NULL);
 }
@@ -409,12 +459,12 @@ iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn)
  */
 static int
 iscsi_tcp_data_recv_done(struct iscsi_tcp_conn *tcp_conn,
-			 struct iscsi_chunk *chunk)
+			 struct iscsi_segment *segment)
 {
 	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
 	int rc = 0;
 
-	if (!iscsi_tcp_dgst_verify(tcp_conn, chunk))
+	if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
 		return ISCSI_ERR_DATA_DGST;
 
 	rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr,
@@ -435,7 +485,7 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 	if (conn->datadgst_en)
 		rx_hash = &tcp_conn->rx_hash;
 
-	iscsi_chunk_init_linear(&tcp_conn->in.chunk,
+	iscsi_segment_init_linear(&tcp_conn->in.segment,
 				conn->data, tcp_conn->in.datalen,
 				iscsi_tcp_data_recv_done, rx_hash);
 }
@@ -448,7 +498,6 @@ iscsi_tcp_cleanup_ctask(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_r2t_info *r2t;
-	struct scsi_cmnd *sc;
 
 	/* flush ctask's r2t queues */
 	while (__kfifo_get(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*))) {
@@ -457,12 +506,12 @@ iscsi_tcp_cleanup_ctask(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 		debug_scsi("iscsi_tcp_cleanup_ctask pending r2t dropped\n");
 	}
 
-	sc = ctask->sc;
-	if (unlikely(!sc))
-		return;
-
-	tcp_ctask->xmstate = XMSTATE_IDLE;
-	tcp_ctask->r2t = NULL;
+	r2t = tcp_ctask->r2t;
+	if (r2t != NULL) {
+		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
+			    sizeof(void*));
+		tcp_ctask->r2t = NULL;
+	}
 }
 
 /**
@@ -481,11 +530,6 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	int datasn = be32_to_cpu(rhdr->datasn);
 
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
-	/*
-	 * setup Data-In byte counter (gets decremented..)
-	 */
-	ctask->data_count = tcp_conn->in.datalen;
-
 	if (tcp_conn->in.datalen == 0)
 		return 0;
 
@@ -543,9 +587,6 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 			struct iscsi_r2t_info *r2t)
 {
 	struct iscsi_data *hdr;
-	struct scsi_cmnd *sc = ctask->sc;
-	int i, sg_count = 0;
-	struct scatterlist *sg;
 
 	hdr = &r2t->dtask.hdr;
 	memset(hdr, 0, sizeof(struct iscsi_data));
@@ -569,34 +610,6 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	conn->dataout_pdus_cnt++;
 
 	r2t->sent = 0;
-
-	iscsi_buf_init_iov(&r2t->headbuf, (char*)hdr,
-			   sizeof(struct iscsi_hdr));
-
-	sg = scsi_sglist(sc);
-	r2t->sg = NULL;
-	for (i = 0; i < scsi_sg_count(sc); i++, sg += 1) {
-		/* FIXME: prefetch ? */
-		if (sg_count + sg->length > r2t->data_offset) {
-			int page_offset;
-
-			/* sg page found! */
-
-			/* offset within this page */
-			page_offset = r2t->data_offset - sg_count;
-
-			/* fill in this buffer */
-			iscsi_buf_init_sg(&r2t->sendbuf, sg);
-			r2t->sendbuf.sg.offset += page_offset;
-			r2t->sendbuf.sg.length -= page_offset;
-
-			/* xmit logic will continue with next one */
-			r2t->sg = sg + 1;
-			break;
-		}
-		sg_count += sg->length;
-	}
-	BUG_ON(r2t->sg == NULL);
 }
 
 /**
@@ -670,7 +683,6 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 	tcp_ctask->exp_datasn = r2tsn + 1;
 	__kfifo_put(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*));
-	tcp_ctask->xmstate |= XMSTATE_SOL_HDR_INIT;
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_ctask(ctask);
@@ -684,13 +696,13 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
  */
 static int
 iscsi_tcp_process_data_in(struct iscsi_tcp_conn *tcp_conn,
-			  struct iscsi_chunk *chunk)
+			  struct iscsi_segment *segment)
 {
 	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
 	struct iscsi_hdr *hdr = tcp_conn->in.hdr;
 	int rc;
 
-	if (!iscsi_tcp_dgst_verify(tcp_conn, chunk))
+	if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
 		return ISCSI_ERR_DATA_DGST;
 
 	/* check for non-exceptional status */
@@ -762,7 +774,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			/*
 			 * Setup copy of Data-In into the Scsi_Cmnd
 			 * Scatterlist case:
-			 * We set up the iscsi_chunk to point to the next
+			 * We set up the iscsi_segment to point to the next
 			 * scatterlist entry to copy to. As we go along,
 			 * we move on to the next scatterlist entry and
 			 * update the digest per-entry.
@@ -774,13 +786,13 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 				  "datalen=%d)\n", tcp_conn,
 				  tcp_ctask->data_offset,
 				  tcp_conn->in.datalen);
-			return iscsi_chunk_seek_sg(&tcp_conn->in.chunk,
-						scsi_sglist(ctask->sc),
-						scsi_sg_count(ctask->sc),
-						tcp_ctask->data_offset,
-						tcp_conn->in.datalen,
-						iscsi_tcp_process_data_in,
-						rx_hash);
+			return iscsi_segment_seek_sg(&tcp_conn->in.segment,
+						     scsi_sglist(ctask->sc),
+						     scsi_sg_count(ctask->sc),
+						     tcp_ctask->data_offset,
+						     tcp_conn->in.datalen,
+						     iscsi_tcp_process_data_in,
+						     rx_hash);
 		}
 		/* fall through */
 	case ISCSI_OP_SCSI_CMD_RSP:
@@ -846,17 +858,6 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	return rc;
 }
 
-static inline void
-partial_sg_digest_update(struct hash_desc *desc, struct scatterlist *sg,
-			 int offset, int length)
-{
-	struct scatterlist temp;
-
-	sg_init_table(&temp, 1);
-	sg_set_page(&temp, sg_page(sg), length, offset);
-	crypto_hash_update(desc, &temp, length);
-}
-
 /**
  * iscsi_tcp_hdr_recv_done - process PDU header
  *
@@ -866,7 +867,7 @@ partial_sg_digest_update(struct hash_desc *desc, struct scatterlist *sg,
  */
 static int
 iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
-			struct iscsi_chunk *chunk)
+			struct iscsi_segment *segment)
 {
 	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
 	struct iscsi_hdr *hdr;
@@ -876,7 +877,7 @@ iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 	 * may need to go back to the caller for more.
 	 */
 	hdr = (struct iscsi_hdr *) tcp_conn->in.hdr_buf;
-	if (chunk->copied == sizeof(struct iscsi_hdr) && hdr->hlength) {
+	if (segment->copied == sizeof(struct iscsi_hdr) && hdr->hlength) {
 		/* Bump the header length - the caller will
 		 * just loop around and get the AHS for us, and
 		 * call again. */
@@ -886,8 +887,8 @@ iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 		if (sizeof(*hdr) + ahslen > sizeof(tcp_conn->in.hdr_buf))
 			return ISCSI_ERR_AHSLEN;
 
-		chunk->total_size += ahslen;
-		chunk->size += ahslen;
+		segment->total_size += ahslen;
+		segment->size += ahslen;
 		return 0;
 	}
 
@@ -895,16 +896,16 @@ iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 	 * header digests; if so, set up the recv_digest buffer
 	 * and go back for more. */
 	if (conn->hdrdgst_en) {
-		if (chunk->digest_len == 0) {
-			iscsi_tcp_chunk_splice_digest(chunk,
-						      chunk->recv_digest);
+		if (segment->digest_len == 0) {
+			iscsi_tcp_segment_splice_digest(segment,
+							segment->recv_digest);
 			return 0;
 		}
 		iscsi_tcp_dgst_header(&tcp_conn->rx_hash, hdr,
-				      chunk->total_copied - ISCSI_DIGEST_SIZE,
-				      chunk->digest);
+				      segment->total_copied - ISCSI_DIGEST_SIZE,
+				      segment->digest);
 
-		if (!iscsi_tcp_dgst_verify(tcp_conn, chunk))
+		if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
 			return ISCSI_ERR_HDR_DGST;
 	}
 
@@ -925,7 +926,7 @@ iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 {
 	struct iscsi_conn *conn = rd_desc->arg.data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_chunk *chunk = &tcp_conn->in.chunk;
+	struct iscsi_segment *segment = &tcp_conn->in.segment;
 	struct skb_seq_state seq;
 	unsigned int consumed = 0;
 	int rc = 0;
@@ -943,27 +944,31 @@ iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 		const u8 *ptr;
 
 		avail = skb_seq_read(consumed, &ptr, &seq);
-		if (avail == 0)
+		if (avail == 0) {
+			debug_tcp("no more data avail. Consumed %d\n",
+				  consumed);
 			break;
-		BUG_ON(chunk->copied >= chunk->size);
+		}
+		BUG_ON(segment->copied >= segment->size);
 
 		debug_tcp("skb %p ptr=%p avail=%u\n", skb, ptr, avail);
-		rc = iscsi_tcp_chunk_recv(tcp_conn, chunk, ptr, avail);
+		rc = iscsi_tcp_segment_recv(tcp_conn, segment, ptr, avail);
 		BUG_ON(rc == 0);
 		consumed += rc;
 
-		if (chunk->total_copied >= chunk->total_size) {
-			rc = chunk->done(tcp_conn, chunk);
+		if (segment->total_copied >= segment->total_size) {
+			debug_tcp("segment done\n");
+			rc = segment->done(tcp_conn, segment);
 			if (rc != 0) {
 				skb_abort_seq_read(&seq);
 				goto error;
 			}
 
 			/* The done() functions sets up the
-			 * next chunk. */
+			 * next segment. */
 		}
 	}
-
+	skb_abort_seq_read(&seq);
 	conn->rxdata_octets += consumed;
 	return consumed;
 
@@ -996,7 +1001,7 @@ iscsi_tcp_data_ready(struct sock *sk, int flag)
 
 	/* If we had to (atomically) map a highmem page,
 	 * unmap it now. */
-	iscsi_tcp_chunk_unmap(&tcp_conn->in.chunk);
+	iscsi_tcp_segment_unmap(&tcp_conn->in.segment);
 }
 
 static void
@@ -1076,121 +1081,173 @@ iscsi_conn_restore_callbacks(struct iscsi_tcp_conn *tcp_conn)
 }
 
 /**
- * iscsi_send - generic send routine
- * @sk: kernel's socket
- * @buf: buffer to write from
- * @size: actual size to write
- * @flags: socket's flags
- */
-static inline int
-iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
+ * iscsi_xmit - TCP transmit
+ **/
+static int
+iscsi_xmit(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct socket *sk = tcp_conn->sock;
-	int offset = buf->sg.offset + buf->sent, res;
+	struct iscsi_segment *segment = &tcp_conn->out.segment;
+	unsigned int consumed = 0;
+	int rc = 0;
 
-	/*
-	 * if we got use_sg=0 or are sending something we kmallocd
-	 * then we did not have to do kmap (kmap returns page_address)
-	 *
-	 * if we got use_sg > 0, but had to drop down, we do not
-	 * set clustering so this should only happen for that
-	 * slab case.
-	 */
-	if (buf->use_sendmsg)
-		res = sock_no_sendpage(sk, buf->sg.page, offset, size, flags);
-	else
-		res = tcp_conn->sendpage(sk, buf->sg.page, offset, size, flags);
-
-	if (res >= 0) {
-		conn->txdata_octets += res;
-		buf->sent += res;
-		return res;
+	while (1) {
+		rc = iscsi_tcp_xmit_segment(tcp_conn, segment);
+		if (rc < 0)
+			goto error;
+		if (rc == 0)
+			break;
+
+		consumed += rc;
+
+		if (segment->total_copied >= segment->total_size) {
+			if (segment->done != NULL) {
+				rc = segment->done(tcp_conn, segment);
+				if (rc < 0)
+					goto error;
+			}
+		}
 	}
 
-	tcp_conn->sendpage_failures_cnt++;
-	if (res == -EAGAIN)
-		res = -ENOBUFS;
-	else
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-	return res;
+	debug_tcp("xmit %d bytes\n", consumed);
+
+	conn->txdata_octets += consumed;
+	return consumed;
+
+error:
+	/* Transmit error. We could initiate error recovery
+	 * here. */
+	debug_tcp("Error sending PDU, errno=%d\n", rc);
+	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	return rc;
 }
 
 /**
- * iscsi_sendhdr - send PDU Header via tcp_sendpage()
- * @conn: iscsi connection
- * @buf: buffer to write from
- * @datalen: lenght of data to be sent after the header
- *
- * Notes:
- *	(Tx, Fast Path)
- **/
+ * iscsi_tcp_xmit_qlen - return the number of bytes queued for xmit
+ */
 static inline int
-iscsi_sendhdr(struct iscsi_conn *conn, struct iscsi_buf *buf, int datalen)
+iscsi_tcp_xmit_qlen(struct iscsi_conn *conn)
 {
-	int flags = 0; /* MSG_DONTWAIT; */
-	int res, size;
-
-	size = buf->sg.length - buf->sent;
-	BUG_ON(buf->sent + size > buf->sg.length);
-	if (buf->sent + size != buf->sg.length || datalen)
-		flags |= MSG_MORE;
-
-	res = iscsi_send(conn, buf, size, flags);
-	debug_tcp("sendhdr %d bytes, sent %d res %d\n", size, buf->sent, res);
-	if (res >= 0) {
-		if (size != res)
-			return -EAGAIN;
-		return 0;
-	}
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_segment *segment = &tcp_conn->out.segment;
 
-	return res;
+	return segment->total_copied - segment->total_size;
 }
 
-/**
- * iscsi_sendpage - send one page of iSCSI Data-Out.
- * @conn: iscsi connection
- * @buf: buffer to write from
- * @count: remaining data
- * @sent: number of bytes sent
- *
- * Notes:
- *	(Tx, Fast Path)
- **/
 static inline int
-iscsi_sendpage(struct iscsi_conn *conn, struct iscsi_buf *buf,
-	       int *count, int *sent)
+iscsi_tcp_flush(struct iscsi_conn *conn)
 {
-	int flags = 0; /* MSG_DONTWAIT; */
-	int res, size;
-
-	size = buf->sg.length - buf->sent;
-	BUG_ON(buf->sent + size > buf->sg.length);
-	if (size > *count)
-		size = *count;
-	if (buf->sent + size != buf->sg.length || *count != size)
-		flags |= MSG_MORE;
-
-	res = iscsi_send(conn, buf, size, flags);
-	debug_tcp("sendpage: %d bytes, sent %d left %d sent %d res %d\n",
-		  size, buf->sent, *count, *sent, res);
-	if (res >= 0) {
-		*count -= res;
-		*sent += res;
-		if (size != res)
+	int rc;
+
+	while (iscsi_tcp_xmit_qlen(conn)) {
+		rc = iscsi_xmit(conn);
+		if (rc == 0)
 			return -EAGAIN;
-		return 0;
+		if (rc < 0)
+			return rc;
 	}
 
-	return res;
+	return 0;
 }
 
-static inline void
-iscsi_data_digest_init(struct iscsi_tcp_conn *tcp_conn,
-		      struct iscsi_tcp_cmd_task *tcp_ctask)
+/*
+ * This is called when we're done sending the header.
+ * Simply copy the data_segment to the send segment, and return.
+ */
+static int
+iscsi_tcp_send_hdr_done(struct iscsi_tcp_conn *tcp_conn,
+			struct iscsi_segment *segment)
 {
-	crypto_hash_init(&tcp_conn->tx_hash);
-	tcp_ctask->digest_count = 4;
+	tcp_conn->out.segment = tcp_conn->out.data_segment;
+	debug_tcp("Header done. Next segment size %u total_size %u\n",
+		  tcp_conn->out.segment.size, tcp_conn->out.segment.total_size);
+	return 0;
+}
+
+static void
+iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
+{
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+
+	debug_tcp("%s(%p%s)\n", __FUNCTION__, tcp_conn,
+			conn->hdrdgst_en? ", digest enabled" : "");
+
+	/* Clear the data segment - needs to be filled in by the
+	 * caller using iscsi_tcp_send_data_prep() */
+	memset(&tcp_conn->out.data_segment, 0, sizeof(struct iscsi_segment));
+
+	/* If header digest is enabled, compute the CRC and
+	 * place the digest into the same buffer. We make
+	 * sure that both iscsi_tcp_ctask and mtask have
+	 * sufficient room.
+	 */
+	if (conn->hdrdgst_en) {
+		iscsi_tcp_dgst_header(&tcp_conn->tx_hash, hdr, hdrlen,
+				      hdr + hdrlen);
+		hdrlen += ISCSI_DIGEST_SIZE;
+	}
+
+	/* Remember header pointer for later, when we need
+	 * to decide whether there's a payload to go along
+	 * with the header. */
+	tcp_conn->out.hdr = hdr;
+
+	iscsi_segment_init_linear(&tcp_conn->out.segment, hdr, hdrlen,
+				iscsi_tcp_send_hdr_done, NULL);
+}
+
+/*
+ * Prepare the send buffer for the payload data.
+ * Padding and checksumming will all be taken care
+ * of by the iscsi_segment routines.
+ */
+static int
+iscsi_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
+			 unsigned int count, unsigned int offset,
+			 unsigned int len)
+{
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct hash_desc *tx_hash = NULL;
+	unsigned int hdr_spec_len;
+
+	debug_tcp("%s(%p, offset=%d, datalen=%d%s)\n", __FUNCTION__,
+			tcp_conn, offset, len,
+			conn->datadgst_en? ", digest enabled" : "");
+
+	/* Make sure the datalen matches what the caller
+	   said he would send. */
+	hdr_spec_len = ntoh24(tcp_conn->out.hdr->dlength);
+	WARN_ON(iscsi_padded(len) != iscsi_padded(hdr_spec_len));
+
+	if (conn->datadgst_en)
+		tx_hash = &tcp_conn->tx_hash;
+
+	return iscsi_segment_seek_sg(&tcp_conn->out.data_segment,
+				   sg, count, offset, len,
+				   NULL, tx_hash);
+}
+
+static void
+iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
+				   size_t len)
+{
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct hash_desc *tx_hash = NULL;
+	unsigned int hdr_spec_len;
+
+	debug_tcp("%s(%p, datalen=%d%s)\n", __FUNCTION__, tcp_conn, len,
+		  conn->datadgst_en? ", digest enabled" : "");
+
+	/* Make sure the datalen matches what the caller
+	   said he would send. */
+	hdr_spec_len = ntoh24(tcp_conn->out.hdr->dlength);
+	WARN_ON(iscsi_padded(len) != iscsi_padded(hdr_spec_len));
+
+	if (conn->datadgst_en)
+		tx_hash = &tcp_conn->tx_hash;
+
+	iscsi_segment_init_linear(&tcp_conn->out.data_segment,
+				data, len, NULL, tx_hash);
 }
 
 /**
@@ -1206,12 +1263,17 @@ iscsi_data_digest_init(struct iscsi_tcp_conn *tcp_conn,
  *
  *	Called under connection lock.
  **/
-static void
+static int
 iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
-			struct iscsi_r2t_info *r2t, int left)
+			struct iscsi_r2t_info *r2t)
 {
 	struct iscsi_data *hdr;
-	int new_offset;
+	int new_offset, left;
+
+	BUG_ON(r2t->data_length - r2t->sent < 0);
+	left = r2t->data_length - r2t->sent;
+	if (left == 0)
+		return 0;
 
 	hdr = &r2t->dtask.hdr;
 	memset(hdr, 0, sizeof(struct iscsi_data));
@@ -1232,43 +1294,46 @@ iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 		r2t->data_count = left;
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
 	}
-	conn->dataout_pdus_cnt++;
-
-	iscsi_buf_init_iov(&r2t->headbuf, (char*)hdr,
-			   sizeof(struct iscsi_hdr));
-
-	if (iscsi_buf_left(&r2t->sendbuf))
-		return;
-
-	iscsi_buf_init_sg(&r2t->sendbuf, r2t->sg);
-	r2t->sg += 1;
-}
-
-static void iscsi_set_padding(struct iscsi_tcp_cmd_task *tcp_ctask,
-			      unsigned long len)
-{
-	tcp_ctask->pad_count = len & (ISCSI_PAD_LEN - 1);
-	if (!tcp_ctask->pad_count)
-		return;
 
-	tcp_ctask->pad_count = ISCSI_PAD_LEN - tcp_ctask->pad_count;
-	debug_scsi("write padding %d bytes\n", tcp_ctask->pad_count);
-	tcp_ctask->xmstate |= XMSTATE_W_PAD;
+	conn->dataout_pdus_cnt++;
+	return 1;
 }
 
 /**
- * iscsi_tcp_cmd_init - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
+ * iscsi_tcp_ctask - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
  * @conn: iscsi connection
  * @ctask: scsi command task
  * @sc: scsi command
  **/
-static void
-iscsi_tcp_cmd_init(struct iscsi_cmd_task *ctask)
+static int
+iscsi_tcp_ctask_init(struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	struct iscsi_conn *conn = ctask->conn;
+	struct scsi_cmnd *sc = ctask->sc;
+	int err;
 
 	BUG_ON(__kfifo_len(tcp_ctask->r2tqueue));
-	tcp_ctask->xmstate = XMSTATE_CMD_HDR_INIT;
+	tcp_ctask->sent = 0;
+	tcp_ctask->exp_datasn = 0;
+
+	/* Prepare PDU, optionally w/ immediate data */
+	debug_scsi("ctask deq [cid %d itt 0x%x imm %d unsol %d]\n",
+		    conn->id, ctask->itt, ctask->imm_count,
+		    ctask->unsol_count);
+	iscsi_tcp_send_hdr_prep(conn, ctask->hdr, ctask->hdr_len);
+
+	if (!ctask->imm_count)
+		return 0;
+
+	/* If we have immediate data, attach a payload */
+	err = iscsi_tcp_send_data_prep(conn, scsi_sglist(sc), scsi_sg_count(sc),
+				       0, ctask->imm_count);
+	if (err)
+		return err;
+	tcp_ctask->sent += ctask->imm_count;
+	ctask->imm_count = 0;
+	return 0;
 }
 
 /**
@@ -1280,71 +1345,17 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task *ctask)
  *	The function can return -EAGAIN in which case caller must
  *	call it again later, or recover. '0' return code means successful
  *	xmit.
- *
- *	Management xmit state machine consists of these states:
- *		XMSTATE_IMM_HDR_INIT	- calculate digest of PDU Header
- *		XMSTATE_IMM_HDR 	- PDU Header xmit in progress
- *		XMSTATE_IMM_DATA 	- PDU Data xmit in progress
- *		XMSTATE_IDLE		- management PDU is done
  **/
 static int
 iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 {
-	struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
 	int rc;
 
-	debug_scsi("mtask deq [cid %d state %x itt 0x%x]\n",
-		conn->id, tcp_mtask->xmstate, mtask->itt);
-
-	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR_INIT) {
-		iscsi_buf_init_iov(&tcp_mtask->headbuf, (char*)mtask->hdr,
-				   sizeof(struct iscsi_hdr));
-
-		if (mtask->data_count) {
-			tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
-			iscsi_buf_init_iov(&tcp_mtask->sendbuf,
-					   (char*)mtask->data,
-					   mtask->data_count);
-		}
-
-		if (conn->c_stage != ISCSI_CONN_INITIAL_STAGE &&
-		    conn->stop_stage != STOP_CONN_RECOVER &&
-		    conn->hdrdgst_en)
-			iscsi_hdr_digest(conn, &tcp_mtask->headbuf,
-					(u8*)tcp_mtask->hdrext);
-
-		tcp_mtask->sent = 0;
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR_INIT;
-		tcp_mtask->xmstate |= XMSTATE_IMM_HDR;
-	}
-
-	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR) {
-		rc = iscsi_sendhdr(conn, &tcp_mtask->headbuf,
-				   mtask->data_count);
-		if (rc)
-			return rc;
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR;
-	}
-
-	if (tcp_mtask->xmstate & XMSTATE_IMM_DATA) {
-		BUG_ON(!mtask->data_count);
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_DATA;
-		/* FIXME: implement.
-		 * Virtual buffer could be spreaded across multiple pages...
-		 */
-		do {
-			int rc;
-
-			rc = iscsi_sendpage(conn, &tcp_mtask->sendbuf,
-					&mtask->data_count, &tcp_mtask->sent);
-			if (rc) {
-				tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
-				return rc;
-			}
-		} while (mtask->data_count);
-	}
+	/* Flush any pending data first. */
+	rc = iscsi_tcp_flush(conn);
+	if (rc < 0)
+		return rc;
 
-	BUG_ON(tcp_mtask->xmstate != XMSTATE_IDLE);
 	if (mtask->hdr->itt == RESERVED_ITT) {
 		struct iscsi_session *session = conn->session;
 
@@ -1352,411 +1363,112 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 		iscsi_free_mgmt_task(conn, mtask);
 		spin_unlock_bh(&session->lock);
 	}
+
 	return 0;
 }
 
+/*
+ * iscsi_tcp_ctask_xmit - xmit normal PDU task
+ * @conn: iscsi connection
+ * @ctask: iscsi command task
+ *
+ * We're expected to return 0 when everything was transmitted succesfully,
+ * -EAGAIN if there's still data in the queue, or != 0 for any other kind
+ * of error.
+ */
 static int
-iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
-	struct scsi_cmnd *sc = ctask->sc;
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	struct scsi_cmnd *sc = ctask->sc;
 	int rc = 0;
 
-	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_INIT) {
-		tcp_ctask->sent = 0;
-		tcp_ctask->sg_count = 0;
-		tcp_ctask->exp_datasn = 0;
-
-		if (sc->sc_data_direction == DMA_TO_DEVICE) {
-			struct scatterlist *sg = scsi_sglist(sc);
-
-			iscsi_buf_init_sg(&tcp_ctask->sendbuf, sg);
-			tcp_ctask->sg = sg + 1;
-			tcp_ctask->bad_sg = sg + scsi_sg_count(sc);
-
-			debug_scsi("cmd [itt 0x%x total %d imm_data %d "
-				   "unsol count %d, unsol offset %d]\n",
-				   ctask->itt, scsi_bufflen(sc),
-				   ctask->imm_count, ctask->unsol_count,
-				   ctask->unsol_offset);
-		}
-
-		iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)ctask->hdr,
-				  ctask->hdr_len);
-
-		if (conn->hdrdgst_en)
-			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
-					 iscsi_next_hdr(ctask));
-		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_INIT;
-		tcp_ctask->xmstate |= XMSTATE_CMD_HDR_XMIT;
-	}
-
-	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_XMIT) {
-		rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->imm_count);
-		if (rc)
-			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_XMIT;
-
-		if (sc->sc_data_direction != DMA_TO_DEVICE)
-			return 0;
-
-		if (ctask->imm_count) {
-			tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
-			iscsi_set_padding(tcp_ctask, ctask->imm_count);
-
-			if (ctask->conn->datadgst_en) {
-				iscsi_data_digest_init(ctask->conn->dd_data,
-						       tcp_ctask);
-				tcp_ctask->immdigest = 0;
-			}
-		}
-
-		if (ctask->unsol_count)
-			tcp_ctask->xmstate |=
-					XMSTATE_UNS_HDR | XMSTATE_UNS_INIT;
-	}
-	return rc;
-}
-
-static int
-iscsi_send_padding(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	int sent = 0, rc;
-
-	if (tcp_ctask->xmstate & XMSTATE_W_PAD) {
-		iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
-				   tcp_ctask->pad_count);
-		if (conn->datadgst_en)
-			crypto_hash_update(&tcp_conn->tx_hash,
-					   &tcp_ctask->sendbuf.sg,
-					   tcp_ctask->sendbuf.sg.length);
-	} else if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_PAD))
-		return 0;
-
-	tcp_ctask->xmstate &= ~XMSTATE_W_PAD;
-	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_PAD;
-	debug_scsi("sending %d pad bytes for itt 0x%x\n",
-		   tcp_ctask->pad_count, ctask->itt);
-	rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf, &tcp_ctask->pad_count,
-			   &sent);
-	if (rc) {
-		debug_scsi("padding send failed %d\n", rc);
-		tcp_ctask->xmstate |= XMSTATE_W_RESEND_PAD;
-	}
-	return rc;
-}
-
-static int
-iscsi_send_digest(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
-			struct iscsi_buf *buf, uint32_t *digest)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask;
-	struct iscsi_tcp_conn *tcp_conn;
-	int rc, sent = 0;
-
-	if (!conn->datadgst_en)
-		return 0;
-
-	tcp_ctask = ctask->dd_data;
-	tcp_conn = conn->dd_data;
-
-	if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_DATA_DIGEST)) {
-		crypto_hash_final(&tcp_conn->tx_hash, (u8*)digest);
-		iscsi_buf_init_iov(buf, (char*)digest, 4);
-	}
-	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_DATA_DIGEST;
-
-	rc = iscsi_sendpage(conn, buf, &tcp_ctask->digest_count, &sent);
-	if (!rc)
-		debug_scsi("sent digest 0x%x for itt 0x%x\n", *digest,
-			  ctask->itt);
-	else {
-		debug_scsi("sending digest 0x%x failed for itt 0x%x!\n",
-			  *digest, ctask->itt);
-		tcp_ctask->xmstate |= XMSTATE_W_RESEND_DATA_DIGEST;
-	}
-	return rc;
-}
-
-static int
-iscsi_send_data(struct iscsi_cmd_task *ctask, struct iscsi_buf *sendbuf,
-		struct scatterlist **sg, int *sent, int *count,
-		struct iscsi_buf *digestbuf, uint32_t *digest)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_conn *conn = ctask->conn;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	int rc, buf_sent, offset;
-
-	while (*count) {
-		buf_sent = 0;
-		offset = sendbuf->sent;
-
-		rc = iscsi_sendpage(conn, sendbuf, count, &buf_sent);
-		*sent = *sent + buf_sent;
-		if (buf_sent && conn->datadgst_en)
-			partial_sg_digest_update(&tcp_conn->tx_hash,
-				&sendbuf->sg, sendbuf->sg.offset + offset,
-				buf_sent);
-		if (!iscsi_buf_left(sendbuf) && *sg != tcp_ctask->bad_sg) {
-			iscsi_buf_init_sg(sendbuf, *sg);
-			*sg = *sg + 1;
-		}
-
-		if (rc)
-			return rc;
-	}
-
-	rc = iscsi_send_padding(conn, ctask);
-	if (rc)
+flush:
+	/* Flush any pending data first. */
+	rc = iscsi_tcp_flush(conn);
+	if (rc < 0)
 		return rc;
 
-	return iscsi_send_digest(conn, ctask, digestbuf, digest);
-}
-
-static int
-iscsi_send_unsol_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_data_task *dtask;
-	int rc;
-
-	tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
-	if (tcp_ctask->xmstate & XMSTATE_UNS_INIT) {
-		dtask = &tcp_ctask->unsol_dtask;
-
-		iscsi_prep_unsolicit_data_pdu(ctask, &dtask->hdr);
-		iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)&dtask->hdr,
-				   sizeof(struct iscsi_hdr));
-		if (conn->hdrdgst_en)
-			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
-					(u8*)dtask->hdrext);
-
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_INIT;
-		iscsi_set_padding(tcp_ctask, ctask->data_count);
-	}
-
-	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->data_count);
-	if (rc) {
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
-		tcp_ctask->xmstate |= XMSTATE_UNS_HDR;
-		return rc;
-	}
+	/* Are we done already? */
+	if (sc->sc_data_direction != DMA_TO_DEVICE)
+		return 0;
 
-	if (conn->datadgst_en) {
-		dtask = &tcp_ctask->unsol_dtask;
-		iscsi_data_digest_init(ctask->conn->dd_data, tcp_ctask);
-		dtask->digest = 0;
-	}
+	if (ctask->unsol_count != 0) {
+		struct iscsi_data *hdr = &tcp_ctask->unsol_dtask.hdr;
 
-	debug_scsi("uns dout [itt 0x%x dlen %d sent %d]\n",
-		   ctask->itt, ctask->unsol_count, tcp_ctask->sent);
-	return 0;
-}
+		/* Prepare a header for the unsolicited PDU.
+		 * The amount of data we want to send will be
+		 * in ctask->data_count.
+		 * FIXME: return the data count instead.
+		 */
+		iscsi_prep_unsolicit_data_pdu(ctask, hdr);
 
-static int
-iscsi_send_unsol_pdu(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	int rc;
+		debug_tcp("unsol dout [itt 0x%x doff %d dlen %d]\n",
+				ctask->itt, tcp_ctask->sent, ctask->data_count);
 
-	if (tcp_ctask->xmstate & XMSTATE_UNS_HDR) {
-		BUG_ON(!ctask->unsol_count);
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_HDR;
-send_hdr:
-		rc = iscsi_send_unsol_hdr(conn, ctask);
+		iscsi_tcp_send_hdr_prep(conn, hdr, sizeof(*hdr));
+		rc = iscsi_tcp_send_data_prep(conn, scsi_sglist(sc),
+					      scsi_sg_count(sc),
+					      tcp_ctask->sent,
+					      ctask->data_count);
 		if (rc)
-			return rc;
-	}
-
-	if (tcp_ctask->xmstate & XMSTATE_UNS_DATA) {
-		struct iscsi_data_task *dtask = &tcp_ctask->unsol_dtask;
-		int start = tcp_ctask->sent;
+			goto fail;
+		tcp_ctask->sent += ctask->data_count;
+		ctask->unsol_count -= ctask->data_count;
+		goto flush;
+	} else {
+		struct iscsi_session *session = conn->session;
+		struct iscsi_r2t_info *r2t;
 
-		rc = iscsi_send_data(ctask, &tcp_ctask->sendbuf, &tcp_ctask->sg,
-				     &tcp_ctask->sent, &ctask->data_count,
-				     &dtask->digestbuf, &dtask->digest);
-		ctask->unsol_count -= tcp_ctask->sent - start;
-		if (rc)
-			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
-		/*
-		 * Done with the Data-Out. Next, check if we need
-		 * to send another unsolicited Data-Out.
+		/* All unsolicited PDUs sent. Check for solicited PDUs.
 		 */
-		if (ctask->unsol_count) {
-			debug_scsi("sending more uns\n");
-			tcp_ctask->xmstate |= XMSTATE_UNS_INIT;
-			goto send_hdr;
+		spin_lock_bh(&session->lock);
+		r2t = tcp_ctask->r2t;
+		if (r2t != NULL) {
+			/* Continue with this R2T? */
+			if (!iscsi_solicit_data_cont(conn, ctask, r2t)) {
+				debug_scsi("  done with r2t %p\n", r2t);
+
+				__kfifo_put(tcp_ctask->r2tpool.queue,
+					    (void*)&r2t, sizeof(void*));
+				tcp_ctask->r2t = r2t = NULL;
+			}
 		}
-	}
-	return 0;
-}
 
-static int iscsi_send_sol_pdu(struct iscsi_conn *conn,
-			      struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_session *session = conn->session;
-	struct iscsi_r2t_info *r2t;
-	struct iscsi_data_task *dtask;
-	int left, rc;
-
-	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR_INIT) {
-		if (!tcp_ctask->r2t) {
-			spin_lock_bh(&session->lock);
+		if (r2t == NULL) {
 			__kfifo_get(tcp_ctask->r2tqueue, (void*)&tcp_ctask->r2t,
 				    sizeof(void*));
-			spin_unlock_bh(&session->lock);
+			r2t = tcp_ctask->r2t;
 		}
-send_hdr:
-		r2t = tcp_ctask->r2t;
-		dtask = &r2t->dtask;
-
-		if (conn->hdrdgst_en)
-			iscsi_hdr_digest(conn, &r2t->headbuf,
-					(u8*)dtask->hdrext);
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR_INIT;
-		tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
-	}
-
-	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR) {
-		r2t = tcp_ctask->r2t;
-		dtask = &r2t->dtask;
-
-		rc = iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count);
-		if (rc)
-			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
-		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
+		spin_unlock_bh(&session->lock);
 
-		if (conn->datadgst_en) {
-			iscsi_data_digest_init(conn->dd_data, tcp_ctask);
-			dtask->digest = 0;
+		/* Waiting for more R2Ts to arrive. */
+		if (r2t == NULL) {
+			debug_tcp("no R2Ts yet\n");
+			return 0;
 		}
 
-		iscsi_set_padding(tcp_ctask, r2t->data_count);
-		debug_scsi("sol dout [dsn %d itt 0x%x dlen %d sent %d]\n",
-			r2t->solicit_datasn - 1, ctask->itt, r2t->data_count,
-			r2t->sent);
-	}
+		debug_scsi("sol dout %p [dsn %d itt 0x%x doff %d dlen %d]\n",
+			r2t, r2t->solicit_datasn - 1, ctask->itt,
+			r2t->data_offset + r2t->sent, r2t->data_count);
 
-	if (tcp_ctask->xmstate & XMSTATE_SOL_DATA) {
-		r2t = tcp_ctask->r2t;
-		dtask = &r2t->dtask;
+		iscsi_tcp_send_hdr_prep(conn, &r2t->dtask.hdr,
+					sizeof(struct iscsi_hdr));
 
-		rc = iscsi_send_data(ctask, &r2t->sendbuf, &r2t->sg,
-				     &r2t->sent, &r2t->data_count,
-				     &dtask->digestbuf, &dtask->digest);
+		rc = iscsi_tcp_send_data_prep(conn, scsi_sglist(sc),
+					      scsi_sg_count(sc),
+					      r2t->data_offset + r2t->sent,
+					      r2t->data_count);
 		if (rc)
-			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
-
-		/*
-		 * Done with this Data-Out. Next, check if we have
-		 * to send another Data-Out for this R2T.
-		 */
-		BUG_ON(r2t->data_length - r2t->sent < 0);
-		left = r2t->data_length - r2t->sent;
-		if (left) {
-			iscsi_solicit_data_cont(conn, ctask, r2t, left);
-			goto send_hdr;
-		}
-
-		/*
-		 * Done with this R2T. Check if there are more
-		 * outstanding R2Ts ready to be processed.
-		 */
-		spin_lock_bh(&session->lock);
-		tcp_ctask->r2t = NULL;
-		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
-		if (__kfifo_get(tcp_ctask->r2tqueue, (void*)&r2t,
-				sizeof(void*))) {
-			tcp_ctask->r2t = r2t;
-			spin_unlock_bh(&session->lock);
-			goto send_hdr;
-		}
-		spin_unlock_bh(&session->lock);
+			goto fail;
+		tcp_ctask->sent += r2t->data_count;
+		r2t->sent += r2t->data_count;
+		goto flush;
 	}
 	return 0;
-}
-
-/**
- * iscsi_tcp_ctask_xmit - xmit normal PDU task
- * @conn: iscsi connection
- * @ctask: iscsi command task
- *
- * Notes:
- *	The function can return -EAGAIN in which case caller must
- *	call it again later, or recover. '0' return code means successful
- *	xmit.
- *	The function is devided to logical helpers (above) for the different
- *	xmit stages.
- *
- *iscsi_send_cmd_hdr()
- *	XMSTATE_CMD_HDR_INIT - prepare Header and Data buffers Calculate
- *	                       Header Digest
- *	XMSTATE_CMD_HDR_XMIT - Transmit header in progress
- *
- *iscsi_send_padding
- *	XMSTATE_W_PAD        - Prepare and send pading
- *	XMSTATE_W_RESEND_PAD - retry send pading
- *
- *iscsi_send_digest
- *	XMSTATE_W_RESEND_DATA_DIGEST - Finalize and send Data Digest
- *	XMSTATE_W_RESEND_DATA_DIGEST - retry sending digest
- *
- *iscsi_send_unsol_hdr
- *	XMSTATE_UNS_INIT     - prepare un-solicit data header and digest
- *	XMSTATE_UNS_HDR      - send un-solicit header
- *
- *iscsi_send_unsol_pdu
- *	XMSTATE_UNS_DATA     - send un-solicit data in progress
- *
- *iscsi_send_sol_pdu
- *	XMSTATE_SOL_HDR_INIT - solicit data header and digest initialize
- *	XMSTATE_SOL_HDR      - send solicit header
- *	XMSTATE_SOL_DATA     - send solicit data
- *
- *iscsi_tcp_ctask_xmit
- *	XMSTATE_IMM_DATA     - xmit managment data (??)
- **/
-static int
-iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	int rc = 0;
-
-	debug_scsi("ctask deq [cid %d xmstate %x itt 0x%x]\n",
-		conn->id, tcp_ctask->xmstate, ctask->itt);
-
-	rc = iscsi_send_cmd_hdr(conn, ctask);
-	if (rc)
-		return rc;
-	if (ctask->sc->sc_data_direction != DMA_TO_DEVICE)
-		return 0;
-
-	if (tcp_ctask->xmstate & XMSTATE_IMM_DATA) {
-		rc = iscsi_send_data(ctask, &tcp_ctask->sendbuf, &tcp_ctask->sg,
-				     &tcp_ctask->sent, &ctask->imm_count,
-				     &tcp_ctask->immbuf, &tcp_ctask->immdigest);
-		if (rc)
-			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_IMM_DATA;
-	}
-
-	rc = iscsi_send_unsol_pdu(conn, ctask);
-	if (rc)
-		return rc;
-
-	rc = iscsi_send_sol_pdu(conn, ctask);
-	if (rc)
-		return rc;
-
-	return rc;
+fail:
+	iscsi_conn_failure(conn, rc);
+	return -EIO;
 }
 
 static struct iscsi_cls_conn *
@@ -1970,10 +1682,17 @@ free_socket:
 
 /* called with host lock */
 static void
-iscsi_tcp_mgmt_init(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
+iscsi_tcp_mtask_init(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 {
-	struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
-	tcp_mtask->xmstate = XMSTATE_IMM_HDR_INIT;
+	debug_scsi("mtask deq [cid %d itt 0x%x]\n", conn->id, mtask->itt);
+
+	/* Prepare PDU, optionally w/ immediate data */
+	iscsi_tcp_send_hdr_prep(conn, mtask->hdr, sizeof(*mtask->hdr));
+
+	/* If we have immediate data, attach a payload */
+	if (mtask->data_count)
+		iscsi_tcp_send_linear_data_prepare(conn, mtask->data,
+						   mtask->data_count);
 }
 
 static int
@@ -2177,7 +1896,7 @@ iscsi_tcp_session_create(struct iscsi_transport *iscsit,
 		struct iscsi_mgmt_task *mtask = session->mgmt_cmds[cmd_i];
 		struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
 
-		mtask->hdr = &tcp_mtask->hdr;
+		mtask->hdr = (struct iscsi_hdr *) &tcp_mtask->hdr;
 	}
 
 	if (iscsi_r2tpool_alloc(class_to_transport_session(cls_session)))
@@ -2274,8 +1993,8 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_conn_get_stats,
-	.init_cmd_task		= iscsi_tcp_cmd_init,
-	.init_mgmt_task		= iscsi_tcp_mgmt_init,
+	.init_cmd_task		= iscsi_tcp_ctask_init,
+	.init_mgmt_task		= iscsi_tcp_mtask_init,
 	.xmit_cmd_task		= iscsi_tcp_ctask_xmit,
 	.xmit_mgmt_task		= iscsi_tcp_mtask_xmit,
 	.cleanup_cmd_task	= iscsi_tcp_cleanup_ctask,
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index d49d876..893cd2e 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -24,35 +24,18 @@
 
 #include <scsi/libiscsi.h>
 
-/* xmit state machine */
-#define XMSTATE_IDLE			0x0
-#define XMSTATE_CMD_HDR_INIT		0x1
-#define XMSTATE_CMD_HDR_XMIT		0x2
-#define XMSTATE_IMM_HDR			0x4
-#define XMSTATE_IMM_DATA		0x8
-#define XMSTATE_UNS_INIT		0x10
-#define XMSTATE_UNS_HDR			0x20
-#define XMSTATE_UNS_DATA		0x40
-#define XMSTATE_SOL_HDR			0x80
-#define XMSTATE_SOL_DATA		0x100
-#define XMSTATE_W_PAD			0x200
-#define XMSTATE_W_RESEND_PAD		0x400
-#define XMSTATE_W_RESEND_DATA_DIGEST	0x800
-#define XMSTATE_IMM_HDR_INIT		0x1000
-#define XMSTATE_SOL_HDR_INIT		0x2000
-
 #define ISCSI_SG_TABLESIZE		SG_ALL
 #define ISCSI_TCP_MAX_CMD_LEN		16
 
 struct crypto_hash;
 struct socket;
 struct iscsi_tcp_conn;
-struct iscsi_chunk;
+struct iscsi_segment;
 
-typedef int iscsi_chunk_done_fn_t(struct iscsi_tcp_conn *,
-				  struct iscsi_chunk *);
+typedef int iscsi_segment_done_fn_t(struct iscsi_tcp_conn *,
+				    struct iscsi_segment *);
 
-struct iscsi_chunk {
+struct iscsi_segment {
 	unsigned char		*data;
 	unsigned int		size;
 	unsigned int		copied;
@@ -67,16 +50,14 @@ struct iscsi_chunk {
 	struct scatterlist	*sg;
 	void			*sg_mapped;
 	unsigned int		sg_offset;
-	unsigned int		sg_index;
-	unsigned int		sg_count;
 
-	iscsi_chunk_done_fn_t	*done;
+	iscsi_segment_done_fn_t	*done;
 };
 
 /* Socket connection recieve helper */
 struct iscsi_tcp_recv {
 	struct iscsi_hdr	*hdr;
-	struct iscsi_chunk	chunk;
+	struct iscsi_segment	segment;
 
 	/* Allocate buffer for BHS + AHS */
 	uint32_t		hdr_buf[64];
@@ -88,11 +69,8 @@ struct iscsi_tcp_recv {
 /* Socket connection send helper */
 struct iscsi_tcp_send {
 	struct iscsi_hdr	*hdr;
-	struct iscsi_chunk	chunk;
-	struct iscsi_chunk	data_chunk;
-
-	/* Allocate buffer for BHS + AHS */
-	uint32_t		hdr_buf[64];
+	struct iscsi_segment	segment;
+	struct iscsi_segment	data_segment;
 };
 
 struct iscsi_tcp_conn {
@@ -118,29 +96,19 @@ struct iscsi_tcp_conn {
 	uint32_t		sendpage_failures_cnt;
 	uint32_t		discontiguous_hdr_cnt;
 
-	ssize_t (*sendpage)(struct socket *, struct page *, int, size_t, int);
-};
+	int			error;
 
-struct iscsi_buf {
-	struct scatterlist	sg;
-	unsigned int		sent;
-	char			use_sendmsg;
+	ssize_t (*sendpage)(struct socket *, struct page *, int, size_t, int);
 };
 
 struct iscsi_data_task {
 	struct iscsi_data	hdr;			/* PDU */
 	char			hdrext[ISCSI_DIGEST_SIZE];/* Header-Digest */
-	struct iscsi_buf	digestbuf;		/* digest buffer */
-	uint32_t		digest;			/* data digest */
 };
 
 struct iscsi_tcp_mgmt_task {
 	struct iscsi_hdr	hdr;
 	char			hdrext[ISCSI_DIGEST_SIZE]; /* Header-Digest */
-	int			xmstate;	/* mgmt xmit progress */
-	struct iscsi_buf	headbuf;	/* header buffer */
-	struct iscsi_buf	sendbuf;	/* in progress buffer */
-	int			sent;
 };
 
 struct iscsi_r2t_info {
@@ -148,13 +116,10 @@ struct iscsi_r2t_info {
 	__be32			exp_statsn;	/* copied from R2T */
 	uint32_t		data_length;	/* copied from R2T */
 	uint32_t		data_offset;	/* copied from R2T */
-	struct iscsi_buf	headbuf;	/* Data-Out Header Buffer */
-	struct iscsi_buf	sendbuf;	/* Data-Out in progress buffer*/
 	int			sent;		/* R2T sequence progress */
 	int			data_count;	/* DATA-Out payload progress */
-	struct scatterlist	*sg;		/* per-R2T SG list */
 	int			solicit_datasn;
-	struct iscsi_data_task   dtask;        /* which data task */
+	struct iscsi_data_task	dtask;		/* Data-Out header buf */
 };
 
 struct iscsi_tcp_cmd_task {
@@ -163,24 +128,14 @@ struct iscsi_tcp_cmd_task {
 		char			hdrextbuf[ISCSI_MAX_AHS_SIZE +
 		                                  ISCSI_DIGEST_SIZE];
 	} hdr;
-	char			pad[ISCSI_PAD_LEN];
-	int			pad_count;		/* padded bytes */
-	struct iscsi_buf	headbuf;		/* header buf (xmit) */
-	struct iscsi_buf	sendbuf;		/* in progress buffer*/
-	int			xmstate;		/* xmit xtate machine */
+
 	int			sent;
-	struct scatterlist	*sg;			/* per-cmd SG list  */
-	struct scatterlist	*bad_sg;		/* assert statement */
-	int			sg_count;		/* SG's to process  */
-	uint32_t		exp_datasn;		/* expected target's R2TSN/DataSN */
+	uint32_t		exp_datasn;	/* expected target's R2TSN/DataSN */
 	int			data_offset;
-	struct iscsi_r2t_info	*r2t;			/* in progress R2T    */
+	struct iscsi_r2t_info	*r2t;		/* in progress R2T    */
 	struct iscsi_pool	r2tpool;
 	struct kfifo		*r2tqueue;
-	int			digest_count;
-	uint32_t		immdigest;		/* for imm data */
-	struct iscsi_buf	immbuf;			/* for imm data digest */
-	struct iscsi_data_task	unsol_dtask;	/* unsol data task */
+	struct iscsi_data_task	unsol_dtask;	/* Data-Out header buf */
 };
 
 #endif /* ISCSI_H */
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b0bc8c3..f15df8d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -156,20 +156,19 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	rc = iscsi_add_hdr(ctask, sizeof(*hdr));
 	if (rc)
 		return rc;
-        hdr->opcode = ISCSI_OP_SCSI_CMD;
-        hdr->flags = ISCSI_ATTR_SIMPLE;
-        int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
-        hdr->itt = build_itt(ctask->itt, conn->id, session->age);
-        hdr->data_length = cpu_to_be32(scsi_bufflen(sc));
-        hdr->cmdsn = cpu_to_be32(session->cmdsn);
-        session->cmdsn++;
-        hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
-        memcpy(hdr->cdb, sc->cmnd, sc->cmd_len);
+	hdr->opcode = ISCSI_OP_SCSI_CMD;
+	hdr->flags = ISCSI_ATTR_SIMPLE;
+	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
+	hdr->itt = build_itt(ctask->itt, conn->id, session->age);
+	hdr->data_length = cpu_to_be32(scsi_bufflen(sc));
+	hdr->cmdsn = cpu_to_be32(session->cmdsn);
+	session->cmdsn++;
+	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
+	memcpy(hdr->cdb, sc->cmnd, sc->cmd_len);
 	if (sc->cmd_len < MAX_COMMAND_SIZE)
 		memset(&hdr->cdb[sc->cmd_len], 0,
 			MAX_COMMAND_SIZE - sc->cmd_len);
 
-	ctask->data_count = 0;
 	ctask->imm_count = 0;
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
@@ -198,9 +197,9 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 			else
 				ctask->imm_count = min(scsi_bufflen(sc),
 							conn->max_xmit_dlength);
-			hton24(ctask->hdr->dlength, ctask->imm_count);
+			hton24(hdr->dlength, ctask->imm_count);
 		} else
-			zero_data(ctask->hdr->dlength);
+			zero_data(hdr->dlength);
 
 		if (!session->initial_r2t_en) {
 			ctask->unsol_count = min((session->first_burst),
@@ -210,7 +209,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 
 		if (!ctask->unsol_count)
 			/* No unsolicit Data-Out's */
-			ctask->hdr->flags |= ISCSI_FLAG_CMD_FINAL;
+			hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 	} else {
 		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 		zero_data(hdr->dlength);
@@ -228,13 +227,15 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	WARN_ON(hdrlength >= 256);
 	hdr->hlength = hdrlength & 0xFF;
 
-	conn->scsicmd_pdus_cnt++;
+	if (conn->session->tt->init_cmd_task(conn->ctask))
+		return EIO;
 
-        debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
+	conn->scsicmd_pdus_cnt++;
+	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
 		"cmdsn %d win %d]\n",
-                sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
+		sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
 		conn->id, sc, sc->cmnd[0], ctask->itt, scsi_bufflen(sc),
-                session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
+		session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
 }
 
@@ -927,7 +928,7 @@ check_mgmt:
 			fail_command(conn, conn->ctask, DID_ABORT << 16);
 			continue;
 		}
-		conn->session->tt->init_cmd_task(conn->ctask);
+
 		conn->ctask->state = ISCSI_TASK_RUNNING;
 		list_move_tail(conn->xmitqueue.next, &conn->run_list);
 		rc = iscsi_xmit_ctask(conn);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 093b403..404f11d 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -118,7 +118,7 @@ struct iscsi_transport {
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
 			   struct iscsi_stats *stats);
-	void (*init_cmd_task) (struct iscsi_cmd_task *ctask);
+	int (*init_cmd_task) (struct iscsi_cmd_task *ctask);
 	void (*init_mgmt_task) (struct iscsi_conn *conn,
 				struct iscsi_mgmt_task *mtask);
 	int (*xmit_cmd_task) (struct iscsi_conn *conn,
-- 
1.5.1.2

