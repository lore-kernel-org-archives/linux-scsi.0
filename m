From: michaelc@cs.wisc.edu
Subject: [PATCH 02/23] iscsi_tcp: rewrite recv path
Date: Tue,  4 Dec 2007 18:42:16 -0600
Message-ID: <11968153663560-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbXLEAnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:11 -0500
In-Reply-To: <119681536472-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, olaf.kirch@oracle.com

From: Mike Christie <michaelc@cs.wisc.edu>

>From Olaf Kirch:

Rewrite recv path. Fixes:
- data digest processing and error handling.
- ahs support.

Some fixups by Mike Christie

Signed-off-by: olaf.kirch@oracle.com
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c | 1018 +++++++++++++++++++++++-----------------------
 drivers/scsi/iscsi_tcp.h |   66 ++--
 include/scsi/libiscsi.h  |    4 +
 3 files changed, 552 insertions(+), 536 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4b226b8..1b540e0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -48,7 +48,7 @@ MODULE_AUTHOR("Dmitry Yusupov <dmitry_yus@yahoo.com>, "
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-/* #define DEBUG_TCP */
+#undef DEBUG_TCP
 #define DEBUG_ASSERT
 
 #ifdef DEBUG_TCP
@@ -67,10 +67,15 @@ MODULE_LICENSE("GPL");
 static unsigned int iscsi_max_lun = 512;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
+static int iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
+				   struct iscsi_chunk *chunk);
+
 static inline void
 iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
 {
-	sg_init_one(&ibuf->sg, vbuf, size);
+	ibuf->sg.page = virt_to_page(vbuf);
+	ibuf->sg.offset = offset_in_page(vbuf);
+	ibuf->sg.length = size;
 	ibuf->sent = 0;
 	ibuf->use_sendmsg = 1;
 }
@@ -78,12 +83,13 @@ iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
 static inline void
 iscsi_buf_init_sg(struct iscsi_buf *ibuf, struct scatterlist *sg)
 {
-	sg_init_table(&ibuf->sg, 1);
-	sg_set_page(&ibuf->sg, sg_page(sg), sg->length, sg->offset);
+	ibuf->sg.page = sg->page;
+	ibuf->sg.offset = sg->offset;
+	ibuf->sg.length = sg->length;
 	/*
 	 * Fastpath: sg element fits into single page
 	 */
-	if (sg->length + sg->offset <= PAGE_SIZE && !PageSlab(sg_page(sg)))
+	if (sg->length + sg->offset <= PAGE_SIZE && !PageSlab(sg->page))
 		ibuf->use_sendmsg = 0;
 	else
 		ibuf->use_sendmsg = 1;
@@ -110,72 +116,331 @@ iscsi_hdr_digest(struct iscsi_conn *conn, struct iscsi_buf *buf,
 	buf->sg.length += sizeof(u32);
 }
 
+/*
+ * Scatterlist handling: inside the iscsi_chunk, we
+ * remember an index into the scatterlist, and set data/size
+ * to the current scatterlist entry. For highmem pages, we
+ * kmap as needed.
+ *
+ * Note that the page is unmapped when we return from
+ * TCP's data_ready handler, so we may end up mapping and
+ * unmapping the same page repeatedly. The whole reason
+ * for this is that we shouldn't keep the page mapped
+ * outside the softirq.
+ */
+
+/**
+ * iscsi_tcp_chunk_init_sg - init indicated scatterlist entry
+ * @chunk: the buffer object
+ * @idx: index into scatterlist
+ * @offset: byte offset into that sg entry
+ *
+ * This function sets up the chunk so that subsequent
+ * data is copied to the indicated sg entry, at the given
+ * offset.
+ */
+static inline void
+iscsi_tcp_chunk_init_sg(struct iscsi_chunk *chunk,
+			unsigned int idx, unsigned int offset)
+{
+	struct scatterlist *sg;
+
+	BUG_ON(chunk->sg == NULL);
+
+	sg = &chunk->sg[idx];
+	chunk->sg_index = idx;
+	chunk->sg_offset = offset;
+	chunk->size = min(sg->length - offset, chunk->total_size);
+	chunk->data = NULL;
+}
+
+/**
+ * iscsi_tcp_chunk_map - map the current S/G page
+ * @chunk: iscsi chunk
+ *
+ * We only need to possibly kmap data if scatter lists are being used,
+ * because the iscsi passthrough and internal IO paths will never use high
+ * mem pages.
+ */
+static inline void
+iscsi_tcp_chunk_map(struct iscsi_chunk *chunk)
+{
+	struct scatterlist *sg;
+
+	if (chunk->data != NULL || !chunk->sg)
+		return;
+
+	sg = &chunk->sg[chunk->sg_index];
+	BUG_ON(chunk->sg_mapped);
+	BUG_ON(sg->length == 0);
+	chunk->sg_mapped = kmap_atomic(sg->page, KM_SOFTIRQ0);
+	chunk->data = chunk->sg_mapped + sg->offset + chunk->sg_offset;
+}
+
+static inline void
+iscsi_tcp_chunk_unmap(struct iscsi_chunk *chunk)
+{
+	if (chunk->sg_mapped) {
+		kunmap_atomic(chunk->sg_mapped, KM_SOFTIRQ0);
+		chunk->sg_mapped = NULL;
+		chunk->data = NULL;
+	}
+}
+
+/*
+ * Splice the digest buffer into the buffer
+ */
+static inline void
+iscsi_tcp_chunk_splice_digest(struct iscsi_chunk *chunk, void *digest)
+{
+	chunk->data = digest;
+	chunk->digest_len = ISCSI_DIGEST_SIZE;
+	chunk->total_size += ISCSI_DIGEST_SIZE;
+	chunk->size = ISCSI_DIGEST_SIZE;
+	chunk->copied = 0;
+	chunk->sg = NULL;
+	chunk->sg_index = 0;
+	chunk->hash = NULL;
+}
+
+/**
+ * iscsi_tcp_chunk_done - check whether the chunk is complete
+ * @chunk: iscsi chunk to check
+ *
+ * Check if we're done receiving this chunk. If the receive
+ * buffer is full but we expect more data, move on to the
+ * next entry in the scatterlist.
+ *
+ * If the amount of data we received isn't a multiple of 4,
+ * we will transparently receive the pad bytes, too.
+ *
+ * This function must be re-entrant.
+ */
 static inline int
-iscsi_hdr_extract(struct iscsi_tcp_conn *tcp_conn)
+iscsi_tcp_chunk_done(struct iscsi_chunk *chunk)
 {
-	struct sk_buff *skb = tcp_conn->in.skb;
+	static unsigned char padbuf[ISCSI_PAD_LEN];
+
+	if (chunk->copied < chunk->size) {
+		iscsi_tcp_chunk_map(chunk);
+		return 0;
+	}
 
-	tcp_conn->in.zero_copy_hdr = 0;
+	chunk->total_copied += chunk->copied;
+	chunk->copied = 0;
+	chunk->size = 0;
 
-	if (tcp_conn->in.copy >= tcp_conn->hdr_size &&
-	    tcp_conn->in_progress == IN_PROGRESS_WAIT_HEADER) {
-		/*
-		 * Zero-copy PDU Header: using connection context
-		 * to store header pointer.
-		 */
-		if (skb_shinfo(skb)->frag_list == NULL &&
-		    !skb_shinfo(skb)->nr_frags) {
-			tcp_conn->in.hdr = (struct iscsi_hdr *)
-				((char*)skb->data + tcp_conn->in.offset);
-			tcp_conn->in.zero_copy_hdr = 1;
-		} else {
-			/* ignoring return code since we checked
-			 * in.copy before */
-			skb_copy_bits(skb, tcp_conn->in.offset,
-				&tcp_conn->hdr, tcp_conn->hdr_size);
-			tcp_conn->in.hdr = &tcp_conn->hdr;
+	/* Unmap the current scatterlist page, if there is one. */
+	iscsi_tcp_chunk_unmap(chunk);
+
+	/* Do we have more scatterlist entries? */
+	if (chunk->total_copied < chunk->total_size) {
+		/* Proceed to the next entry in the scatterlist. */
+		iscsi_tcp_chunk_init_sg(chunk, chunk->sg_index + 1, 0);
+		iscsi_tcp_chunk_map(chunk);
+		BUG_ON(chunk->size == 0);
+		return 0;
+	}
+
+	/* Do we need to handle padding? */
+	if (chunk->total_copied & (ISCSI_PAD_LEN-1)) {
+		unsigned int pad;
+
+		pad = ISCSI_PAD_LEN - (chunk->total_copied & (ISCSI_PAD_LEN-1));
+		debug_tcp("consume %d pad bytes\n", pad);
+		chunk->total_size += pad;
+		chunk->size = pad;
+		chunk->data = padbuf;
+		return 0;
+	}
+
+	/*
+	 * Set us up for receiving the data digest. hdr digest
+	 * is completely handled in hdr done function.
+	 */
+	if (chunk->hash) {
+		if (chunk->digest_len == 0) {
+			crypto_hash_final(chunk->hash, chunk->digest);
+			iscsi_tcp_chunk_splice_digest(chunk,
+						      chunk->recv_digest);
+			return 0;
 		}
-		tcp_conn->in.offset += tcp_conn->hdr_size;
-		tcp_conn->in.copy -= tcp_conn->hdr_size;
-	} else {
-		int hdr_remains;
-		int copylen;
+	}
 
-		/*
-		 * PDU header scattered across SKB's,
-		 * copying it... This'll happen quite rarely.
-		 */
+	return 1;
+}
+
+/**
+ * iscsi_tcp_chunk_recv - copy data to chunk
+ * @tcp_conn: the iSCSI TCP connection
+ * @chunk: the buffer to copy to
+ * @ptr: data pointer
+ * @len: amount of data available
+ *
+ * This function copies up to @len bytes to the
+ * given buffer, and returns the number of bytes
+ * consumed, which can actually be less than @len.
+ *
+ * If hash digest is enabled, the function will update the
+ * hash while copying.
+ * Combining these two operations doesn't buy us a lot (yet),
+ * but in the future we could implement combined copy+crc,
+ * just way we do for network layer checksums.
+ */
+static int
+iscsi_tcp_chunk_recv(struct iscsi_tcp_conn *tcp_conn,
+		     struct iscsi_chunk *chunk, const void *ptr,
+		     unsigned int len)
+{
+	struct scatterlist sg;
+	unsigned int copy, copied = 0;
+
+	while (!iscsi_tcp_chunk_done(chunk)) {
+		if (copied == len)
+			goto out;
+
+		copy = min(len - copied, chunk->size - chunk->copied);
+		memcpy(chunk->data + chunk->copied, ptr + copied, copy);
+
+		if (chunk->hash) {
+			sg_init_one(&sg, ptr + copied, copy);
+			crypto_hash_update(chunk->hash, &sg, copy);
+		}
+		chunk->copied += copy;
+		copied += copy;
+	}
+
+out:
+	return copied;
+}
 
-		if (tcp_conn->in_progress == IN_PROGRESS_WAIT_HEADER)
-			tcp_conn->in.hdr_offset = 0;
+static inline void
+iscsi_tcp_dgst_header(struct hash_desc *hash, const void *hdr, size_t hdrlen,
+		      unsigned char digest[ISCSI_DIGEST_SIZE])
+{
+	struct scatterlist sg;
+
+	sg_init_one(&sg, hdr, hdrlen);
+	crypto_hash_digest(hash, &sg, hdrlen, digest);
+}
+
+static inline int
+iscsi_tcp_dgst_verify(struct iscsi_tcp_conn *tcp_conn,
+		      struct iscsi_chunk *chunk)
+{
+	if (!chunk->digest_len)
+		return 1;
+
+	if (memcmp(chunk->recv_digest, chunk->digest, chunk->digest_len)) {
+		debug_scsi("digest mismatch\n");
+		return 0;
+	}
 
-		hdr_remains = tcp_conn->hdr_size - tcp_conn->in.hdr_offset;
-		BUG_ON(hdr_remains <= 0);
+	return 1;
+}
 
-		copylen = min(tcp_conn->in.copy, hdr_remains);
-		skb_copy_bits(skb, tcp_conn->in.offset,
-			(char*)&tcp_conn->hdr + tcp_conn->in.hdr_offset,
-			copylen);
+/*
+ * Helper function to set up chunk buffer
+ */
+static inline void
+__iscsi_chunk_init(struct iscsi_chunk *chunk, size_t size,
+		   iscsi_chunk_done_fn_t *done, struct hash_desc *hash)
+{
+	memset(chunk, 0, sizeof(*chunk));
+	chunk->total_size = size;
+	chunk->done = done;
 
-		debug_tcp("PDU gather offset %d bytes %d in.offset %d "
-		       "in.copy %d\n", tcp_conn->in.hdr_offset, copylen,
-		       tcp_conn->in.offset, tcp_conn->in.copy);
+	if (hash) {
+		chunk->hash = hash;
+		crypto_hash_init(hash);
+	}
+}
 
-		tcp_conn->in.offset += copylen;
-		tcp_conn->in.copy -= copylen;
-		if (copylen < hdr_remains)  {
-			tcp_conn->in_progress = IN_PROGRESS_HEADER_GATHER;
-			tcp_conn->in.hdr_offset += copylen;
-		        return -EAGAIN;
+static inline void
+iscsi_chunk_init_linear(struct iscsi_chunk *chunk, void *data, size_t size,
+			iscsi_chunk_done_fn_t *done, struct hash_desc *hash)
+{
+	__iscsi_chunk_init(chunk, size, done, hash);
+	chunk->data = data;
+	chunk->size = size;
+}
+
+static inline int
+iscsi_chunk_seek_sg(struct iscsi_chunk *chunk,
+		    struct scatterlist *sg, unsigned int sg_count,
+		    unsigned int offset, size_t size,
+		    iscsi_chunk_done_fn_t *done, struct hash_desc *hash)
+{
+	unsigned int i;
+
+	__iscsi_chunk_init(chunk, size, done, hash);
+	for (i = 0; i < sg_count; ++i) {
+		if (offset < sg[i].length) {
+			chunk->sg = sg;
+			chunk->sg_count = sg_count;
+			iscsi_tcp_chunk_init_sg(chunk, i, offset);
+			return 0;
 		}
-		tcp_conn->in.hdr = &tcp_conn->hdr;
-		tcp_conn->discontiguous_hdr_cnt++;
-	        tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
+		offset -= sg[i].length;
 	}
 
+	return ISCSI_ERR_DATA_OFFSET;
+}
+
+/**
+ * iscsi_tcp_hdr_recv_prep - prep chunk for hdr reception
+ * @tcp_conn: iscsi connection to prep for
+ *
+ * This function always passes NULL for the hash argument, because when this
+ * function is called we do not yet know the final size of the header and want
+ * to delay the digest processing until we know that.
+ */
+static void
+iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn)
+{
+	debug_tcp("iscsi_tcp_hdr_recv_prep(%p%s)\n", tcp_conn,
+		  tcp_conn->iscsi_conn->hdrdgst_en ? ", digest enabled" : "");
+	iscsi_chunk_init_linear(&tcp_conn->in.chunk,
+				tcp_conn->in.hdr_buf, sizeof(struct iscsi_hdr),
+				iscsi_tcp_hdr_recv_done, NULL);
+}
+
+/*
+ * Handle incoming reply to any other type of command
+ */
+static int
+iscsi_tcp_data_recv_done(struct iscsi_tcp_conn *tcp_conn,
+			 struct iscsi_chunk *chunk)
+{
+	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
+	int rc = 0;
+
+	if (!iscsi_tcp_dgst_verify(tcp_conn, chunk))
+		return ISCSI_ERR_DATA_DGST;
+
+	rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr,
+			conn->data, tcp_conn->in.datalen);
+	if (rc)
+		return rc;
+
+	iscsi_tcp_hdr_recv_prep(tcp_conn);
 	return 0;
 }
 
+static void
+iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
+{
+	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
+	struct hash_desc *rx_hash = NULL;
+
+	if (conn->datadgst_en)
+		rx_hash = &tcp_conn->rx_hash;
+
+	iscsi_chunk_init_linear(&tcp_conn->in.chunk,
+				conn->data, tcp_conn->in.datalen,
+				iscsi_tcp_data_recv_done, rx_hash);
+}
+
 /*
  * must be called with session lock
  */
@@ -417,16 +682,49 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	return 0;
 }
 
+/*
+ * Handle incoming reply to DataIn command
+ */
 static int
-iscsi_tcp_hdr_recv(struct iscsi_conn *conn)
+iscsi_tcp_process_data_in(struct iscsi_tcp_conn *tcp_conn,
+			  struct iscsi_chunk *chunk)
+{
+	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
+	struct iscsi_hdr *hdr = tcp_conn->in.hdr;
+	int rc;
+
+	if (!iscsi_tcp_dgst_verify(tcp_conn, chunk))
+		return ISCSI_ERR_DATA_DGST;
+
+	/* check for non-exceptional status */
+	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
+		rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr, NULL, 0);
+		if (rc)
+			return rc;
+	}
+
+	iscsi_tcp_hdr_recv_prep(tcp_conn);
+	return 0;
+}
+
+/**
+ * iscsi_tcp_hdr_dissect - process PDU header
+ * @conn: iSCSI connection
+ * @hdr: PDU header
+ *
+ * This function analyzes the header of the PDU received,
+ * and performs several sanity checks. If the PDU is accompanied
+ * by data, the receive buffer is set up to copy the incoming data
+ * to the correct location.
+ */
+static int
+iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
 	int rc = 0, opcode, ahslen;
-	struct iscsi_hdr *hdr;
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	uint32_t cdgst, rdgst = 0, itt;
-
-	hdr = tcp_conn->in.hdr;
+	struct iscsi_cmd_task *ctask;
+	uint32_t itt;
 
 	/* verify PDU length */
 	tcp_conn->in.datalen = ntoh24(hdr->dlength);
@@ -435,77 +733,72 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *conn)
 		       tcp_conn->in.datalen, conn->max_recv_dlength);
 		return ISCSI_ERR_DATALEN;
 	}
-	tcp_conn->data_copied = 0;
 
-	/* read AHS */
+	/* Additional header segments. So far, we don't
+	 * process additional headers.
+	 */
 	ahslen = hdr->hlength << 2;
-	tcp_conn->in.offset += ahslen;
-	tcp_conn->in.copy -= ahslen;
-	if (tcp_conn->in.copy < 0) {
-		printk(KERN_ERR "iscsi_tcp: can't handle AHS with length "
-		       "%d bytes\n", ahslen);
-		return ISCSI_ERR_AHSLEN;
-	}
-
-	/* calculate read padding */
-	tcp_conn->in.padding = tcp_conn->in.datalen & (ISCSI_PAD_LEN-1);
-	if (tcp_conn->in.padding) {
-		tcp_conn->in.padding = ISCSI_PAD_LEN - tcp_conn->in.padding;
-		debug_scsi("read padding %d bytes\n", tcp_conn->in.padding);
-	}
-
-	if (conn->hdrdgst_en) {
-		struct scatterlist sg;
-
-		sg_init_one(&sg, (u8 *)hdr,
-			    sizeof(struct iscsi_hdr) + ahslen);
-		crypto_hash_digest(&tcp_conn->rx_hash, &sg, sg.length,
-				   (u8 *)&cdgst);
-		rdgst = *(uint32_t*)((char*)hdr + sizeof(struct iscsi_hdr) +
-				     ahslen);
-		if (cdgst != rdgst) {
-			printk(KERN_ERR "iscsi_tcp: hdrdgst error "
-			       "recv 0x%x calc 0x%x\n", rdgst, cdgst);
-			return ISCSI_ERR_HDR_DGST;
-		}
-	}
 
 	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	/* verify itt (itt encoding: age+cid+itt) */
 	rc = iscsi_verify_itt(conn, hdr, &itt);
 	if (rc == ISCSI_ERR_NO_SCSI_CMD) {
+		/* XXX: what does this do? */
 		tcp_conn->in.datalen = 0; /* force drop */
 		return 0;
 	} else if (rc)
 		return rc;
 
-	debug_tcp("opcode 0x%x offset %d copy %d ahslen %d datalen %d\n",
-		  opcode, tcp_conn->in.offset, tcp_conn->in.copy,
-		  ahslen, tcp_conn->in.datalen);
+	debug_tcp("opcode 0x%x ahslen %d datalen %d\n",
+		  opcode, ahslen, tcp_conn->in.datalen);
 
 	switch(opcode) {
 	case ISCSI_OP_SCSI_DATA_IN:
-		tcp_conn->in.ctask = session->cmds[itt];
-		rc = iscsi_data_rsp(conn, tcp_conn->in.ctask);
+		ctask = session->cmds[itt];
+		rc = iscsi_data_rsp(conn, ctask);
 		if (rc)
 			return rc;
+		if (tcp_conn->in.datalen) {
+			struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+			struct hash_desc *rx_hash = NULL;
+
+			/*
+			 * Setup copy of Data-In into the Scsi_Cmnd
+			 * Scatterlist case:
+			 * We set up the iscsi_chunk to point to the next
+			 * scatterlist entry to copy to. As we go along,
+			 * we move on to the next scatterlist entry and
+			 * update the digest per-entry.
+			 */
+			if (conn->datadgst_en)
+				rx_hash = &tcp_conn->rx_hash;
+
+			debug_tcp("iscsi_tcp_begin_data_in(%p, offset=%d, "
+				  "datalen=%d)\n", tcp_conn,
+				  tcp_ctask->data_offset,
+				  tcp_conn->in.datalen);
+			return iscsi_chunk_seek_sg(&tcp_conn->in.chunk,
+						scsi_sglist(ctask->sc),
+						scsi_sg_count(ctask->sc),
+						tcp_ctask->data_offset,
+						tcp_conn->in.datalen,
+						iscsi_tcp_process_data_in,
+						rx_hash);
+		}
 		/* fall through */
 	case ISCSI_OP_SCSI_CMD_RSP:
-		tcp_conn->in.ctask = session->cmds[itt];
-		if (tcp_conn->in.datalen)
-			goto copy_hdr;
-
-		spin_lock(&session->lock);
-		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
-		spin_unlock(&session->lock);
+		if (tcp_conn->in.datalen) {
+			iscsi_tcp_data_recv_prep(tcp_conn);
+			return 0;
+		}
+		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
 		break;
 	case ISCSI_OP_R2T:
-		tcp_conn->in.ctask = session->cmds[itt];
+		ctask = session->cmds[itt];
 		if (ahslen)
 			rc = ISCSI_ERR_AHSLEN;
-		else if (tcp_conn->in.ctask->sc->sc_data_direction ==
-								DMA_TO_DEVICE)
-			rc = iscsi_r2t_rsp(conn, tcp_conn->in.ctask);
+		else if (ctask->sc->sc_data_direction == DMA_TO_DEVICE)
+			rc = iscsi_r2t_rsp(conn, ctask);
 		else
 			rc = ISCSI_ERR_PROTO;
 		break;
@@ -518,8 +811,7 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *conn)
 		 * than 8K, but there are no targets that currently do this.
 		 * For now we fail until we find a vendor that needs it
 		 */
-		if (ISCSI_DEF_MAX_RECV_SEG_LEN <
-		    tcp_conn->in.datalen) {
+		if (ISCSI_DEF_MAX_RECV_SEG_LEN < tcp_conn->in.datalen) {
 			printk(KERN_ERR "iscsi_tcp: received buffer of len %u "
 			      "but conn buffer is only %u (opcode %0x)\n",
 			      tcp_conn->in.datalen,
@@ -528,8 +820,13 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *conn)
 			break;
 		}
 
-		if (tcp_conn->in.datalen)
-			goto copy_hdr;
+		/* If there's data coming in with the response,
+		 * receive it to the connection's buffer.
+		 */
+		if (tcp_conn->in.datalen) {
+			iscsi_tcp_data_recv_prep(tcp_conn);
+			return 0;
+		}
 	/* fall through */
 	case ISCSI_OP_LOGOUT_RSP:
 	case ISCSI_OP_NOOP_IN:
@@ -541,129 +838,15 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *conn)
 		break;
 	}
 
-	return rc;
-
-copy_hdr:
-	/*
-	 * if we did zero copy for the header but we will need multiple
-	 * skbs to complete the command then we have to copy the header
-	 * for later use
-	 */
-	if (tcp_conn->in.zero_copy_hdr && tcp_conn->in.copy <=
-	   (tcp_conn->in.datalen + tcp_conn->in.padding +
-	    (conn->datadgst_en ? 4 : 0))) {
-		debug_tcp("Copying header for later use. in.copy %d in.datalen"
-			  " %d\n", tcp_conn->in.copy, tcp_conn->in.datalen);
-		memcpy(&tcp_conn->hdr, tcp_conn->in.hdr,
-		       sizeof(struct iscsi_hdr));
-		tcp_conn->in.hdr = &tcp_conn->hdr;
-		tcp_conn->in.zero_copy_hdr = 0;
-	}
-	return 0;
-}
-
-/**
- * iscsi_ctask_copy - copy skb bits to the destanation cmd task
- * @conn: iscsi tcp connection
- * @ctask: scsi command task
- * @buf: buffer to copy to
- * @buf_size: size of buffer
- * @offset: offset within the buffer
- *
- * Notes:
- *	The function calls skb_copy_bits() and updates per-connection and
- *	per-cmd byte counters.
- *
- *	Read counters (in bytes):
- *
- *	conn->in.offset		offset within in progress SKB
- *	conn->in.copy		left to copy from in progress SKB
- *				including padding
- *	conn->in.copied		copied already from in progress SKB
- *	conn->data_copied	copied already from in progress buffer
- *	ctask->sent		total bytes sent up to the MidLayer
- *	ctask->data_count	left to copy from in progress Data-In
- *	buf_left		left to copy from in progress buffer
- **/
-static inline int
-iscsi_ctask_copy(struct iscsi_tcp_conn *tcp_conn, struct iscsi_cmd_task *ctask,
-		void *buf, int buf_size, int offset)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	int buf_left = buf_size - (tcp_conn->data_copied + offset);
-	unsigned size = min(tcp_conn->in.copy, buf_left);
-	int rc;
-
-	size = min(size, ctask->data_count);
-
-	debug_tcp("ctask_copy %d bytes at offset %d copied %d\n",
-	       size, tcp_conn->in.offset, tcp_conn->in.copied);
-
-	BUG_ON(size <= 0);
-	BUG_ON(tcp_ctask->sent + size > scsi_bufflen(ctask->sc));
-
-	rc = skb_copy_bits(tcp_conn->in.skb, tcp_conn->in.offset,
-			   (char*)buf + (offset + tcp_conn->data_copied), size);
-	/* must fit into skb->len */
-	BUG_ON(rc);
-
-	tcp_conn->in.offset += size;
-	tcp_conn->in.copy -= size;
-	tcp_conn->in.copied += size;
-	tcp_conn->data_copied += size;
-	tcp_ctask->sent += size;
-	ctask->data_count -= size;
-
-	BUG_ON(tcp_conn->in.copy < 0);
-	BUG_ON(ctask->data_count < 0);
-
-	if (buf_size != (tcp_conn->data_copied + offset)) {
-		if (!ctask->data_count) {
-			BUG_ON(buf_size - tcp_conn->data_copied < 0);
-			/* done with this PDU */
-			return buf_size - tcp_conn->data_copied;
-		}
-		return -EAGAIN;
+	if (rc == 0) {
+		/* Anything that comes with data should have
+		 * been handled above. */
+		if (tcp_conn->in.datalen)
+			return ISCSI_ERR_PROTO;
+		iscsi_tcp_hdr_recv_prep(tcp_conn);
 	}
 
-	/* done with this buffer or with both - PDU and buffer */
-	tcp_conn->data_copied = 0;
-	return 0;
-}
-
-/**
- * iscsi_tcp_copy - copy skb bits to the destanation buffer
- * @conn: iscsi tcp connection
- *
- * Notes:
- *	The function calls skb_copy_bits() and updates per-connection
- *	byte counters.
- **/
-static inline int
-iscsi_tcp_copy(struct iscsi_conn *conn, int buf_size)
-{
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	int buf_left = buf_size - tcp_conn->data_copied;
-	int size = min(tcp_conn->in.copy, buf_left);
-	int rc;
-
-	debug_tcp("tcp_copy %d bytes at offset %d copied %d\n",
-	       size, tcp_conn->in.offset, tcp_conn->data_copied);
-	BUG_ON(size <= 0);
-
-	rc = skb_copy_bits(tcp_conn->in.skb, tcp_conn->in.offset,
-			   (char*)conn->data + tcp_conn->data_copied, size);
-	BUG_ON(rc);
-
-	tcp_conn->in.offset += size;
-	tcp_conn->in.copy -= size;
-	tcp_conn->in.copied += size;
-	tcp_conn->data_copied += size;
-
-	if (buf_size != tcp_conn->data_copied)
-		return -EAGAIN;
-
-	return 0;
+	return rc;
 }
 
 static inline void
@@ -677,325 +860,146 @@ partial_sg_digest_update(struct hash_desc *desc, struct scatterlist *sg,
 	crypto_hash_update(desc, &temp, length);
 }
 
-static void
-iscsi_recv_digest_update(struct iscsi_tcp_conn *tcp_conn, char* buf, int len)
-{
-	struct scatterlist tmp;
-
-	sg_init_one(&tmp, buf, len);
-	crypto_hash_update(&tcp_conn->rx_hash, &tmp, len);
-}
-
-static int iscsi_scsi_data_in(struct iscsi_conn *conn)
+/**
+ * iscsi_tcp_hdr_recv_done - process PDU header
+ *
+ * This is the callback invoked when the PDU header has
+ * been received. If the header is followed by additional
+ * header segments, we go back for more data.
+ */
+static int
+iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
+			struct iscsi_chunk *chunk)
 {
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_cmd_task *ctask = tcp_conn->in.ctask;
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct scsi_cmnd *sc = ctask->sc;
-	struct scatterlist *sg;
-	int i, offset, rc = 0;
-
-	BUG_ON((void*)ctask != sc->SCp.ptr);
-
-	offset = tcp_ctask->data_offset;
-	sg = scsi_sglist(sc);
-
-	if (tcp_ctask->data_offset)
-		for (i = 0; i < tcp_ctask->sg_count; i++)
-			offset -= sg[i].length;
-	/* we've passed through partial sg*/
-	if (offset < 0)
-		offset = 0;
-
-	for (i = tcp_ctask->sg_count; i < scsi_sg_count(sc); i++) {
-		char *dest;
-
-		dest = kmap_atomic(sg_page(&sg[i]), KM_SOFTIRQ0);
-		rc = iscsi_ctask_copy(tcp_conn, ctask, dest + sg[i].offset,
-				      sg[i].length, offset);
-		kunmap_atomic(dest, KM_SOFTIRQ0);
-		if (rc == -EAGAIN)
-			/* continue with the next SKB/PDU */
-			return rc;
-		if (!rc) {
-			if (conn->datadgst_en) {
-				if (!offset)
-					crypto_hash_update(
-							&tcp_conn->rx_hash,
-							&sg[i], sg[i].length);
-				else
-					partial_sg_digest_update(
-							&tcp_conn->rx_hash,
-							&sg[i],
-							sg[i].offset + offset,
-							sg[i].length - offset);
-			}
-			offset = 0;
-			tcp_ctask->sg_count++;
-		}
-
-		if (!ctask->data_count) {
-			if (rc && conn->datadgst_en)
-				/*
-				 * data-in is complete, but buffer not...
-				 */
-				partial_sg_digest_update(&tcp_conn->rx_hash,
-							 &sg[i],
-							 sg[i].offset,
-							 sg[i].length-rc);
-			rc = 0;
-			break;
-		}
-
-		if (!tcp_conn->in.copy)
-			return -EAGAIN;
-	}
-	BUG_ON(ctask->data_count);
+	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
+	struct iscsi_hdr *hdr;
 
-	/* check for non-exceptional status */
-	if (tcp_conn->in.hdr->flags & ISCSI_FLAG_DATA_STATUS) {
-		debug_scsi("done [sc %lx res %d itt 0x%x flags 0x%x]\n",
-			   (long)sc, sc->result, ctask->itt,
-			   tcp_conn->in.hdr->flags);
-		spin_lock(&conn->session->lock);
-		__iscsi_complete_pdu(conn, tcp_conn->in.hdr, NULL, 0);
-		spin_unlock(&conn->session->lock);
+	/* Check if there are additional header segments
+	 * *prior* to computing the digest, because we
+	 * may need to go back to the caller for more.
+	 */
+	hdr = (struct iscsi_hdr *) tcp_conn->in.hdr_buf;
+	if (chunk->copied == sizeof(struct iscsi_hdr) && hdr->hlength) {
+		/* Bump the header length - the caller will
+		 * just loop around and get the AHS for us, and
+		 * call again. */
+		unsigned int ahslen = hdr->hlength << 2;
+
+		/* Make sure we don't overflow */
+		if (sizeof(*hdr) + ahslen > sizeof(tcp_conn->in.hdr_buf))
+			return ISCSI_ERR_AHSLEN;
+
+		chunk->total_size += ahslen;
+		chunk->size += ahslen;
+		return 0;
 	}
 
-	return rc;
-}
-
-static int
-iscsi_data_recv(struct iscsi_conn *conn)
-{
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	int rc = 0, opcode;
-
-	opcode = tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK;
-	switch (opcode) {
-	case ISCSI_OP_SCSI_DATA_IN:
-		rc = iscsi_scsi_data_in(conn);
-		break;
-	case ISCSI_OP_SCSI_CMD_RSP:
-	case ISCSI_OP_TEXT_RSP:
-	case ISCSI_OP_LOGIN_RSP:
-	case ISCSI_OP_ASYNC_EVENT:
-	case ISCSI_OP_REJECT:
-		/*
-		 * Collect data segment to the connection's data
-		 * placeholder
-		 */
-		if (iscsi_tcp_copy(conn, tcp_conn->in.datalen)) {
-			rc = -EAGAIN;
-			goto exit;
+	/* We're done processing the header. See if we're doing
+	 * header digests; if so, set up the recv_digest buffer
+	 * and go back for more. */
+	if (conn->hdrdgst_en) {
+		if (chunk->digest_len == 0) {
+			iscsi_tcp_chunk_splice_digest(chunk,
+						      chunk->recv_digest);
+			return 0;
 		}
+		iscsi_tcp_dgst_header(&tcp_conn->rx_hash, hdr,
+				      chunk->total_copied - ISCSI_DIGEST_SIZE,
+				      chunk->digest);
 
-		rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr, conn->data,
-					tcp_conn->in.datalen);
-		if (!rc && conn->datadgst_en && opcode != ISCSI_OP_LOGIN_RSP)
-			iscsi_recv_digest_update(tcp_conn, conn->data,
-			  			tcp_conn->in.datalen);
-		break;
-	default:
-		BUG_ON(1);
+		if (!iscsi_tcp_dgst_verify(tcp_conn, chunk))
+			return ISCSI_ERR_HDR_DGST;
 	}
-exit:
-	return rc;
+
+	tcp_conn->in.hdr = hdr;
+	return iscsi_tcp_hdr_dissect(conn, hdr);
 }
 
 /**
- * iscsi_tcp_data_recv - TCP receive in sendfile fashion
+ * iscsi_tcp_recv - TCP receive in sendfile fashion
  * @rd_desc: read descriptor
  * @skb: socket buffer
  * @offset: offset in skb
  * @len: skb->len - offset
  **/
 static int
-iscsi_tcp_data_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
-		unsigned int offset, size_t len)
+iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
+	       unsigned int offset, size_t len)
 {
-	int rc;
 	struct iscsi_conn *conn = rd_desc->arg.data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	int processed;
-	char pad[ISCSI_PAD_LEN];
-	struct scatterlist sg;
-
-	/*
-	 * Save current SKB and its offset in the corresponding
-	 * connection context.
-	 */
-	tcp_conn->in.copy = skb->len - offset;
-	tcp_conn->in.offset = offset;
-	tcp_conn->in.skb = skb;
-	tcp_conn->in.len = tcp_conn->in.copy;
-	BUG_ON(tcp_conn->in.copy <= 0);
-	debug_tcp("in %d bytes\n", tcp_conn->in.copy);
+	struct iscsi_chunk *chunk = &tcp_conn->in.chunk;
+	struct skb_seq_state seq;
+	unsigned int consumed = 0;
+	int rc = 0;
 
-more:
-	tcp_conn->in.copied = 0;
-	rc = 0;
+	debug_tcp("in %d bytes\n", skb->len - offset);
 
 	if (unlikely(conn->suspend_rx)) {
 		debug_tcp("conn %d Rx suspended!\n", conn->id);
 		return 0;
 	}
 
-	if (tcp_conn->in_progress == IN_PROGRESS_WAIT_HEADER ||
-	    tcp_conn->in_progress == IN_PROGRESS_HEADER_GATHER) {
-		rc = iscsi_hdr_extract(tcp_conn);
-		if (rc) {
-		       if (rc == -EAGAIN)
-				goto nomore;
-		       else {
-				iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-				return 0;
-		       }
-		}
-
-		/*
-		 * Verify and process incoming PDU header.
-		 */
-		rc = iscsi_tcp_hdr_recv(conn);
-		if (!rc && tcp_conn->in.datalen) {
-			if (conn->datadgst_en)
-				crypto_hash_init(&tcp_conn->rx_hash);
-			tcp_conn->in_progress = IN_PROGRESS_DATA_RECV;
-		} else if (rc) {
-			iscsi_conn_failure(conn, rc);
-			return 0;
-		}
-	}
-
-	if (tcp_conn->in_progress == IN_PROGRESS_DDIGEST_RECV &&
-	    tcp_conn->in.copy) {
-		uint32_t recv_digest;
+	skb_prepare_seq_read(skb, offset, skb->len, &seq);
+	while (1) {
+		unsigned int avail;
+		const u8 *ptr;
 
-		debug_tcp("extra data_recv offset %d copy %d\n",
-			  tcp_conn->in.offset, tcp_conn->in.copy);
-
-		if (!tcp_conn->data_copied) {
-			if (tcp_conn->in.padding) {
-				debug_tcp("padding -> %d\n",
-					  tcp_conn->in.padding);
-				memset(pad, 0, tcp_conn->in.padding);
-				sg_init_one(&sg, pad, tcp_conn->in.padding);
-				crypto_hash_update(&tcp_conn->rx_hash,
-						   &sg, sg.length);
+		avail = skb_seq_read(consumed, &ptr, &seq);
+		if (avail == 0)
+			break;
+		BUG_ON(chunk->copied >= chunk->size);
+
+		debug_tcp("skb %p ptr=%p avail=%u\n", skb, ptr, avail);
+		rc = iscsi_tcp_chunk_recv(tcp_conn, chunk, ptr, avail);
+		BUG_ON(rc == 0);
+		consumed += rc;
+
+		if (chunk->total_copied >= chunk->total_size) {
+			rc = chunk->done(tcp_conn, chunk);
+			if (rc != 0) {
+				skb_abort_seq_read(&seq);
+				goto error;
 			}
-			crypto_hash_final(&tcp_conn->rx_hash,
-					  (u8 *) &tcp_conn->in.datadgst);
-			debug_tcp("rx digest 0x%x\n", tcp_conn->in.datadgst);
-		}
-
-		rc = iscsi_tcp_copy(conn, sizeof(uint32_t));
-		if (rc) {
-			if (rc == -EAGAIN)
-				goto again;
-			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-			return 0;
-		}
-
-		memcpy(&recv_digest, conn->data, sizeof(uint32_t));
-		if (recv_digest != tcp_conn->in.datadgst) {
-			debug_tcp("iscsi_tcp: data digest error!"
-				  "0x%x != 0x%x\n", recv_digest,
-				  tcp_conn->in.datadgst);
-			iscsi_conn_failure(conn, ISCSI_ERR_DATA_DGST);
-			return 0;
-		} else {
-			debug_tcp("iscsi_tcp: data digest match!"
-				  "0x%x == 0x%x\n", recv_digest,
-				  tcp_conn->in.datadgst);
-			tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
-		}
-	}
-
-	if (tcp_conn->in_progress == IN_PROGRESS_DATA_RECV &&
-	    tcp_conn->in.copy) {
-		debug_tcp("data_recv offset %d copy %d\n",
-		       tcp_conn->in.offset, tcp_conn->in.copy);
 
-		rc = iscsi_data_recv(conn);
-		if (rc) {
-			if (rc == -EAGAIN)
-				goto again;
-			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-			return 0;
+			/* The done() functions sets up the
+			 * next chunk. */
 		}
-
-		if (tcp_conn->in.padding)
-			tcp_conn->in_progress = IN_PROGRESS_PAD_RECV;
-		else if (conn->datadgst_en)
-			tcp_conn->in_progress = IN_PROGRESS_DDIGEST_RECV;
-		else
-			tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
-		tcp_conn->data_copied = 0;
-	}
-
-	if (tcp_conn->in_progress == IN_PROGRESS_PAD_RECV &&
-	    tcp_conn->in.copy) {
-		int copylen = min(tcp_conn->in.padding - tcp_conn->data_copied,
-				  tcp_conn->in.copy);
-
-		tcp_conn->in.copy -= copylen;
-		tcp_conn->in.offset += copylen;
-		tcp_conn->data_copied += copylen;
-
-		if (tcp_conn->data_copied != tcp_conn->in.padding)
-			tcp_conn->in_progress = IN_PROGRESS_PAD_RECV;
-		else if (conn->datadgst_en)
-			tcp_conn->in_progress = IN_PROGRESS_DDIGEST_RECV;
-		else
-			tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
-		tcp_conn->data_copied = 0;
 	}
 
-	debug_tcp("f, processed %d from out of %d padding %d\n",
-	       tcp_conn->in.offset - offset, (int)len, tcp_conn->in.padding);
-	BUG_ON(tcp_conn->in.offset - offset > len);
+	conn->rxdata_octets += consumed;
+	return consumed;
 
-	if (tcp_conn->in.offset - offset != len) {
-		debug_tcp("continue to process %d bytes\n",
-		       (int)len - (tcp_conn->in.offset - offset));
-		goto more;
-	}
-
-nomore:
-	processed = tcp_conn->in.offset - offset;
-	BUG_ON(processed == 0);
-	return processed;
-
-again:
-	processed = tcp_conn->in.offset - offset;
-	debug_tcp("c, processed %d from out of %d rd_desc_cnt %d\n",
-	          processed, (int)len, (int)rd_desc->count);
-	BUG_ON(processed == 0);
-	BUG_ON(processed > len);
-
-	conn->rxdata_octets += processed;
-	return processed;
+error:
+	debug_tcp("Error receiving PDU, errno=%d\n", rc);
+	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	return 0;
 }
 
 static void
 iscsi_tcp_data_ready(struct sock *sk, int flag)
 {
 	struct iscsi_conn *conn = sk->sk_user_data;
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	read_descriptor_t rd_desc;
 
 	read_lock(&sk->sk_callback_lock);
 
 	/*
-	 * Use rd_desc to pass 'conn' to iscsi_tcp_data_recv.
+	 * Use rd_desc to pass 'conn' to iscsi_tcp_recv.
 	 * We set count to 1 because we want the network layer to
-	 * hand us all the skbs that are available. iscsi_tcp_data_recv
+	 * hand us all the skbs that are available. iscsi_tcp_recv
 	 * handled pdus that cross buffers or pdus that still need data.
 	 */
 	rd_desc.arg.data = conn;
 	rd_desc.count = 1;
-	tcp_read_sock(sk, &rd_desc, iscsi_tcp_data_recv);
+	tcp_read_sock(sk, &rd_desc, iscsi_tcp_recv);
 
 	read_unlock(&sk->sk_callback_lock);
+
+	/* If we had to (atomically) map a highmem page,
+	 * unmap it now. */
+	iscsi_tcp_chunk_unmap(&tcp_conn->in.chunk);
 }
 
 static void
@@ -1097,9 +1101,9 @@ iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
 	 * slab case.
 	 */
 	if (buf->use_sendmsg)
-		res = sock_no_sendpage(sk, sg_page(&buf->sg), offset, size, flags);
+		res = sock_no_sendpage(sk, buf->sg.page, offset, size, flags);
 	else
-		res = tcp_conn->sendpage(sk, sg_page(&buf->sg), offset, size, flags);
+		res = tcp_conn->sendpage(sk, buf->sg.page, offset, size, flags);
 
 	if (res >= 0) {
 		conn->txdata_octets += res;
@@ -1783,9 +1787,6 @@ iscsi_tcp_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 
 	conn->dd_data = tcp_conn;
 	tcp_conn->iscsi_conn = conn;
-	tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
-	/* initial operational parameters */
-	tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
 
 	tcp_conn->tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
@@ -1862,11 +1863,9 @@ static void
 iscsi_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
 	iscsi_conn_stop(cls_conn, flag);
 	iscsi_tcp_release_conn(conn);
-	tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
 }
 
 static int iscsi_tcp_get_addr(struct iscsi_conn *conn, struct socket *sock,
@@ -1966,7 +1965,7 @@ iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	/*
 	 * set receive state machine into initial state
 	 */
-	tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
+	iscsi_tcp_hdr_recv_prep(tcp_conn);
 	return 0;
 
 free_socket:
@@ -2059,9 +2058,6 @@ iscsi_conn_set_param(struct iscsi_cls_conn *cls_conn, enum iscsi_param param,
 	switch(param) {
 	case ISCSI_PARAM_HDRDGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
-		tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
-		if (conn->hdrdgst_en)
-			tcp_conn->hdr_size += sizeof(__u32);
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 7eba44d..f1c5411 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -24,13 +24,6 @@
 
 #include <scsi/libiscsi.h>
 
-/* Socket's Receive state machine */
-#define IN_PROGRESS_WAIT_HEADER		0x0
-#define IN_PROGRESS_HEADER_GATHER	0x1
-#define IN_PROGRESS_DATA_RECV		0x2
-#define IN_PROGRESS_DDIGEST_RECV	0x3
-#define IN_PROGRESS_PAD_RECV		0x4
-
 /* xmit state machine */
 #define XMSTATE_IDLE			0x0
 #define XMSTATE_CMD_HDR_INIT		0x1
@@ -54,41 +47,64 @@
 
 struct crypto_hash;
 struct socket;
+struct iscsi_tcp_conn;
+struct iscsi_chunk;
+
+typedef int iscsi_chunk_done_fn_t(struct iscsi_tcp_conn *,
+				  struct iscsi_chunk *);
+
+struct iscsi_chunk {
+	unsigned char		*data;
+	unsigned int		size;
+	unsigned int		copied;
+	unsigned int		total_size;
+	unsigned int		total_copied;
+
+	struct hash_desc	*hash;
+	unsigned char		recv_digest[ISCSI_DIGEST_SIZE];
+	unsigned char		digest[ISCSI_DIGEST_SIZE];
+	unsigned int		digest_len;
+
+	struct scatterlist	*sg;
+	void			*sg_mapped;
+	unsigned int		sg_offset;
+	unsigned int		sg_index;
+	unsigned int		sg_count;
+
+	iscsi_chunk_done_fn_t	*done;
+};
 
 /* Socket connection recieve helper */
 struct iscsi_tcp_recv {
 	struct iscsi_hdr	*hdr;
-	struct sk_buff		*skb;
-	int			offset;
-	int			len;
-	int			hdr_offset;
-	int			copy;
-	int			copied;
-	int			padding;
-	struct iscsi_cmd_task	*ctask;		/* current cmd in progress */
+	struct iscsi_chunk	chunk;
+
+	/* Allocate buffer for BHS + AHS */
+	uint32_t		hdr_buf[64];
 
 	/* copied and flipped values */
 	int			datalen;
-	int			datadgst;
-	char			zero_copy_hdr;
+};
+
+/* Socket connection send helper */
+struct iscsi_tcp_send {
+	struct iscsi_hdr	*hdr;
+	struct iscsi_chunk	chunk;
+	struct iscsi_chunk	data_chunk;
+
+	/* Allocate buffer for BHS + AHS */
+	uint32_t		hdr_buf[64];
 };
 
 struct iscsi_tcp_conn {
 	struct iscsi_conn	*iscsi_conn;
 	struct socket		*sock;
-	struct iscsi_hdr	hdr;		/* header placeholder */
-	char			hdrext[4*sizeof(__u16) +
-				    sizeof(__u32)];
-	int			data_copied;
 	int			stop_stage;	/* conn_stop() flag: *
 						 * stop to recover,  *
 						 * stop to terminate */
-	/* iSCSI connection-wide sequencing */
-	int			hdr_size;	/* PDU header size */
-
 	/* control data */
 	struct iscsi_tcp_recv	in;		/* TCP receive context */
-	int			in_progress;	/* connection state machine */
+	struct iscsi_tcp_send	out;		/* TCP send context */
 
 	/* old values for socket callbacks */
 	void			(*old_data_ready)(struct sock *, int);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 89429f4..e1fb3d0 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -77,6 +77,10 @@ enum {
 
 #define ISCSI_ADDRESS_BUF_LEN		64
 
+enum {
+	ISCSI_DIGEST_SIZE = sizeof(__u32),
+};
+
 struct iscsi_mgmt_task {
 	/*
 	 * Becuae LLDs allocate their hdr differently, this is a pointer to
-- 
1.5.1.2

