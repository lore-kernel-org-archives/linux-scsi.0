From: michaelc@cs.wisc.edu
Subject: [PATCH 09/13] iscsi_tcp: hook iscsi_tcp into new libiscsi_tcp module
Date: Tue,  2 Dec 2008 00:32:12 -0600
Message-ID: <1228199536-12595-10-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-5-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-6-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-7-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-8-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-9-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52476 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYLBGc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:28 -0500
In-Reply-To: <1228199536-12595-9-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This hooks iscsi_tcp into the libiscsi_tcp module and removes
code that is now in libiscsi_tcp.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Makefile    |    2 +-
 drivers/scsi/iscsi_tcp.c | 1524 ++++++++--------------------------------------
 drivers/scsi/iscsi_tcp.h |   71 +--
 3 files changed, 259 insertions(+), 1338 deletions(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 72fd504..b89aedf 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -36,7 +36,7 @@ obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
 obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
 obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
-obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
+obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o
 obj-$(CONFIG_SCSI_ZORRO7XX)	+= 53c700.o	zorro7xx.o
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1db6d3b..728046e 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -27,7 +27,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/list.h>
 #include <linux/inet.h>
 #include <linux/file.h>
 #include <linux/blkdev.h>
@@ -44,12 +43,12 @@
 
 #include "iscsi_tcp.h"
 
-MODULE_AUTHOR("Dmitry Yusupov <dmitry_yus@yahoo.com>, "
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>, "
+	      "Dmitry Yusupov <dmitry_yus@yahoo.com>, "
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
 #undef DEBUG_TCP
-#define DEBUG_ASSERT
 
 #ifdef DEBUG_TCP
 #define debug_tcp(fmt...) printk(KERN_INFO "tcp: " fmt)
@@ -57,924 +56,22 @@ MODULE_LICENSE("GPL");
 #define debug_tcp(fmt...)
 #endif
 
-static struct scsi_transport_template *iscsi_tcp_scsi_transport;
-static struct scsi_host_template iscsi_sht;
-static struct iscsi_transport iscsi_tcp_transport;
+static struct scsi_transport_template *iscsi_sw_tcp_scsi_transport;
+static struct scsi_host_template iscsi_sw_tcp_sht;
+static struct iscsi_transport iscsi_sw_tcp_transport;
 
 static unsigned int iscsi_max_lun = 512;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
-static int iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
-				   struct iscsi_segment *segment);
-
-/*
- * Scatterlist handling: inside the iscsi_segment, we
- * remember an index into the scatterlist, and set data/size
- * to the current scatterlist entry. For highmem pages, we
- * kmap as needed.
- *
- * Note that the page is unmapped when we return from
- * TCP's data_ready handler, so we may end up mapping and
- * unmapping the same page repeatedly. The whole reason
- * for this is that we shouldn't keep the page mapped
- * outside the softirq.
- */
-
-/**
- * iscsi_tcp_segment_init_sg - init indicated scatterlist entry
- * @segment: the buffer object
- * @sg: scatterlist
- * @offset: byte offset into that sg entry
- *
- * This function sets up the segment so that subsequent
- * data is copied to the indicated sg entry, at the given
- * offset.
- */
-static inline void
-iscsi_tcp_segment_init_sg(struct iscsi_segment *segment,
-			  struct scatterlist *sg, unsigned int offset)
-{
-	segment->sg = sg;
-	segment->sg_offset = offset;
-	segment->size = min(sg->length - offset,
-			    segment->total_size - segment->total_copied);
-	segment->data = NULL;
-}
-
-/**
- * iscsi_tcp_segment_map - map the current S/G page
- * @segment: iscsi_segment
- * @recv: 1 if called from recv path
- *
- * We only need to possibly kmap data if scatter lists are being used,
- * because the iscsi passthrough and internal IO paths will never use high
- * mem pages.
- */
-static inline void
-iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
-{
-	struct scatterlist *sg;
-
-	if (segment->data != NULL || !segment->sg)
-		return;
-
-	sg = segment->sg;
-	BUG_ON(segment->sg_mapped);
-	BUG_ON(sg->length == 0);
-
-	/*
-	 * If the page count is greater than one it is ok to send
-	 * to the network layer's zero copy send path. If not we
-	 * have to go the slow sendmsg path. We always map for the
-	 * recv path.
-	 */
-	if (page_count(sg_page(sg)) >= 1 && !recv)
-		return;
-
-	debug_tcp("iscsi_tcp_segment_map %s %p\n", recv ? "recv" : "xmit",
-		  segment);
-	segment->sg_mapped = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
-	segment->data = segment->sg_mapped + sg->offset + segment->sg_offset;
-}
-
-static inline void
-iscsi_tcp_segment_unmap(struct iscsi_segment *segment)
-{
-	debug_tcp("iscsi_tcp_segment_unmap %p\n", segment);
-
-	if (segment->sg_mapped) {
-		debug_tcp("iscsi_tcp_segment_unmap valid\n");
-		kunmap_atomic(segment->sg_mapped, KM_SOFTIRQ0);
-		segment->sg_mapped = NULL;
-		segment->data = NULL;
-	}
-}
-
-/*
- * Splice the digest buffer into the buffer
- */
-static inline void
-iscsi_tcp_segment_splice_digest(struct iscsi_segment *segment, void *digest)
-{
-	segment->data = digest;
-	segment->digest_len = ISCSI_DIGEST_SIZE;
-	segment->total_size += ISCSI_DIGEST_SIZE;
-	segment->size = ISCSI_DIGEST_SIZE;
-	segment->copied = 0;
-	segment->sg = NULL;
-	segment->hash = NULL;
-}
-
-/**
- * iscsi_tcp_segment_done - check whether the segment is complete
- * @segment: iscsi segment to check
- * @recv: set to one of this is called from the recv path
- * @copied: number of bytes copied
- *
- * Check if we're done receiving this segment. If the receive
- * buffer is full but we expect more data, move on to the
- * next entry in the scatterlist.
- *
- * If the amount of data we received isn't a multiple of 4,
- * we will transparently receive the pad bytes, too.
- *
- * This function must be re-entrant.
- */
-static inline int
-iscsi_tcp_segment_done(struct iscsi_segment *segment, int recv, unsigned copied)
-{
-	static unsigned char padbuf[ISCSI_PAD_LEN];
-	struct scatterlist sg;
-	unsigned int pad;
-
-	debug_tcp("copied %u %u size %u %s\n", segment->copied, copied,
-		  segment->size, recv ? "recv" : "xmit");
-	if (segment->hash && copied) {
-		/*
-		 * If a segment is kmapd we must unmap it before sending
-		 * to the crypto layer since that will try to kmap it again.
-		 */
-		iscsi_tcp_segment_unmap(segment);
-
-		if (!segment->data) {
-			sg_init_table(&sg, 1);
-			sg_set_page(&sg, sg_page(segment->sg), copied,
-				    segment->copied + segment->sg_offset +
-							segment->sg->offset);
-		} else
-			sg_init_one(&sg, segment->data + segment->copied,
-				    copied);
-		crypto_hash_update(segment->hash, &sg, copied);
-	}
-
-	segment->copied += copied;
-	if (segment->copied < segment->size) {
-		iscsi_tcp_segment_map(segment, recv);
-		return 0;
-	}
-
-	segment->total_copied += segment->copied;
-	segment->copied = 0;
-	segment->size = 0;
-
-	/* Unmap the current scatterlist page, if there is one. */
-	iscsi_tcp_segment_unmap(segment);
-
-	/* Do we have more scatterlist entries? */
-	debug_tcp("total copied %u total size %u\n", segment->total_copied,
-		   segment->total_size);
-	if (segment->total_copied < segment->total_size) {
-		/* Proceed to the next entry in the scatterlist. */
-		iscsi_tcp_segment_init_sg(segment, sg_next(segment->sg),
-					  0);
-		iscsi_tcp_segment_map(segment, recv);
-		BUG_ON(segment->size == 0);
-		return 0;
-	}
-
-	/* Do we need to handle padding? */
-	pad = iscsi_padding(segment->total_copied);
-	if (pad != 0) {
-		debug_tcp("consume %d pad bytes\n", pad);
-		segment->total_size += pad;
-		segment->size = pad;
-		segment->data = padbuf;
-		return 0;
-	}
-
-	/*
-	 * Set us up for transferring the data digest. hdr digest
-	 * is completely handled in hdr done function.
-	 */
-	if (segment->hash) {
-		crypto_hash_final(segment->hash, segment->digest);
-		iscsi_tcp_segment_splice_digest(segment,
-				 recv ? segment->recv_digest : segment->digest);
-		return 0;
-	}
-
-	return 1;
-}
-
 /**
- * iscsi_tcp_xmit_segment - transmit segment
- * @tcp_conn: the iSCSI TCP connection
- * @segment: the buffer to transmnit
- *
- * This function transmits as much of the buffer as
- * the network layer will accept, and returns the number of
- * bytes transmitted.
- *
- * If CRC hashing is enabled, the function will compute the
- * hash as it goes. When the entire segment has been transmitted,
- * it will retrieve the hash value and send it as well.
- */
-static int
-iscsi_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
-		       struct iscsi_segment *segment)
-{
-	struct socket *sk = tcp_conn->sock;
-	unsigned int copied = 0;
-	int r = 0;
-
-	while (!iscsi_tcp_segment_done(segment, 0, r)) {
-		struct scatterlist *sg;
-		unsigned int offset, copy;
-		int flags = 0;
-
-		r = 0;
-		offset = segment->copied;
-		copy = segment->size - offset;
-
-		if (segment->total_copied + segment->size < segment->total_size)
-			flags |= MSG_MORE;
-
-		/* Use sendpage if we can; else fall back to sendmsg */
-		if (!segment->data) {
-			sg = segment->sg;
-			offset += segment->sg_offset + sg->offset;
-			r = tcp_conn->sendpage(sk, sg_page(sg), offset, copy,
-					       flags);
-		} else {
-			struct msghdr msg = { .msg_flags = flags };
-			struct kvec iov = {
-				.iov_base = segment->data + offset,
-				.iov_len = copy
-			};
-
-			r = kernel_sendmsg(sk, &msg, &iov, 1, copy);
-		}
-
-		if (r < 0) {
-			iscsi_tcp_segment_unmap(segment);
-			if (copied || r == -EAGAIN)
-				break;
-			return r;
-		}
-		copied += r;
-	}
-	return copied;
-}
-
-/**
- * iscsi_tcp_segment_recv - copy data to segment
- * @tcp_conn: the iSCSI TCP connection
- * @segment: the buffer to copy to
- * @ptr: data pointer
- * @len: amount of data available
- *
- * This function copies up to @len bytes to the
- * given buffer, and returns the number of bytes
- * consumed, which can actually be less than @len.
- *
- * If hash digest is enabled, the function will update the
- * hash while copying.
- * Combining these two operations doesn't buy us a lot (yet),
- * but in the future we could implement combined copy+crc,
- * just way we do for network layer checksums.
- */
-static int
-iscsi_tcp_segment_recv(struct iscsi_tcp_conn *tcp_conn,
-		       struct iscsi_segment *segment, const void *ptr,
-		       unsigned int len)
-{
-	unsigned int copy = 0, copied = 0;
-
-	while (!iscsi_tcp_segment_done(segment, 1, copy)) {
-		if (copied == len) {
-			debug_tcp("iscsi_tcp_segment_recv copied %d bytes\n",
-				  len);
-			break;
-		}
-
-		copy = min(len - copied, segment->size - segment->copied);
-		debug_tcp("iscsi_tcp_segment_recv copying %d\n", copy);
-		memcpy(segment->data + segment->copied, ptr + copied, copy);
-		copied += copy;
-	}
-	return copied;
-}
-
-static inline void
-iscsi_tcp_dgst_header(struct hash_desc *hash, const void *hdr, size_t hdrlen,
-		      unsigned char digest[ISCSI_DIGEST_SIZE])
-{
-	struct scatterlist sg;
-
-	sg_init_one(&sg, hdr, hdrlen);
-	crypto_hash_digest(hash, &sg, hdrlen, digest);
-}
-
-static inline int
-iscsi_tcp_dgst_verify(struct iscsi_tcp_conn *tcp_conn,
-		      struct iscsi_segment *segment)
-{
-	if (!segment->digest_len)
-		return 1;
-
-	if (memcmp(segment->recv_digest, segment->digest,
-		   segment->digest_len)) {
-		debug_scsi("digest mismatch\n");
-		return 0;
-	}
-
-	return 1;
-}
-
-/*
- * Helper function to set up segment buffer
- */
-static inline void
-__iscsi_segment_init(struct iscsi_segment *segment, size_t size,
-		     iscsi_segment_done_fn_t *done, struct hash_desc *hash)
-{
-	memset(segment, 0, sizeof(*segment));
-	segment->total_size = size;
-	segment->done = done;
-
-	if (hash) {
-		segment->hash = hash;
-		crypto_hash_init(hash);
-	}
-}
-
-static inline void
-iscsi_segment_init_linear(struct iscsi_segment *segment, void *data,
-			  size_t size, iscsi_segment_done_fn_t *done,
-			  struct hash_desc *hash)
-{
-	__iscsi_segment_init(segment, size, done, hash);
-	segment->data = data;
-	segment->size = size;
-}
-
-static inline int
-iscsi_segment_seek_sg(struct iscsi_segment *segment,
-		      struct scatterlist *sg_list, unsigned int sg_count,
-		      unsigned int offset, size_t size,
-		      iscsi_segment_done_fn_t *done, struct hash_desc *hash)
-{
-	struct scatterlist *sg;
-	unsigned int i;
-
-	debug_scsi("iscsi_segment_seek_sg offset %u size %llu\n",
-		  offset, size);
-	__iscsi_segment_init(segment, size, done, hash);
-	for_each_sg(sg_list, sg, sg_count, i) {
-		debug_scsi("sg %d, len %u offset %u\n", i, sg->length,
-			   sg->offset);
-		if (offset < sg->length) {
-			iscsi_tcp_segment_init_sg(segment, sg, offset);
-			return 0;
-		}
-		offset -= sg->length;
-	}
-
-	return ISCSI_ERR_DATA_OFFSET;
-}
-
-/**
- * iscsi_tcp_hdr_recv_prep - prep segment for hdr reception
- * @tcp_conn: iscsi connection to prep for
- *
- * This function always passes NULL for the hash argument, because when this
- * function is called we do not yet know the final size of the header and want
- * to delay the digest processing until we know that.
- */
-static void
-iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn)
-{
-	debug_tcp("iscsi_tcp_hdr_recv_prep(%p%s)\n", tcp_conn,
-		  tcp_conn->iscsi_conn->hdrdgst_en ? ", digest enabled" : "");
-	iscsi_segment_init_linear(&tcp_conn->in.segment,
-				tcp_conn->in.hdr_buf, sizeof(struct iscsi_hdr),
-				iscsi_tcp_hdr_recv_done, NULL);
-}
-
-/*
- * Handle incoming reply to any other type of command
- */
-static int
-iscsi_tcp_data_recv_done(struct iscsi_tcp_conn *tcp_conn,
-			 struct iscsi_segment *segment)
-{
-	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
-	int rc = 0;
-
-	if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
-		return ISCSI_ERR_DATA_DGST;
-
-	rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr,
-			conn->data, tcp_conn->in.datalen);
-	if (rc)
-		return rc;
-
-	iscsi_tcp_hdr_recv_prep(tcp_conn);
-	return 0;
-}
-
-static void
-iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
-{
-	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
-	struct hash_desc *rx_hash = NULL;
-
-	if (conn->datadgst_en &
-	    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
-		rx_hash = &tcp_conn->rx_hash;
-
-	iscsi_segment_init_linear(&tcp_conn->in.segment,
-				conn->data, tcp_conn->in.datalen,
-				iscsi_tcp_data_recv_done, rx_hash);
-}
-
-/*
- * must be called with session lock
- */
-static void iscsi_tcp_cleanup_task(struct iscsi_task *task)
-{
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct iscsi_r2t_info *r2t;
-
-	/* nothing to do for mgmt or pending tasks */
-	if (!task->sc || task->state == ISCSI_TASK_PENDING)
-		return;
-
-	/* flush task's r2t queues */
-	while (__kfifo_get(tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
-		debug_scsi("iscsi_tcp_cleanup_task pending r2t dropped\n");
-	}
-
-	r2t = tcp_task->r2t;
-	if (r2t != NULL) {
-		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
-		tcp_task->r2t = NULL;
-	}
-}
-
-/**
- * iscsi_tcp_data_in - SCSI Data-In Response processing
- * @conn: iscsi connection
- * @task: scsi command task
- */
-static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
-{
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct iscsi_data_rsp *rhdr = (struct iscsi_data_rsp *)tcp_conn->in.hdr;
-	int datasn = be32_to_cpu(rhdr->datasn);
-	unsigned total_in_length = scsi_in(task->sc)->length;
-
-	iscsi_update_cmdsn(conn->session, (struct iscsi_nopin*)rhdr);
-	if (tcp_conn->in.datalen == 0)
-		return 0;
-
-	if (tcp_task->exp_datasn != datasn) {
-		debug_tcp("%s: task->exp_datasn(%d) != rhdr->datasn(%d)\n",
-		          __func__, tcp_task->exp_datasn, datasn);
-		return ISCSI_ERR_DATASN;
-	}
-
-	tcp_task->exp_datasn++;
-
-	tcp_task->data_offset = be32_to_cpu(rhdr->offset);
-	if (tcp_task->data_offset + tcp_conn->in.datalen > total_in_length) {
-		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
-		          __func__, tcp_task->data_offset,
-		          tcp_conn->in.datalen, total_in_length);
-		return ISCSI_ERR_DATA_OFFSET;
-	}
-
-	conn->datain_pdus_cnt++;
-	return 0;
-}
-
-/**
- * iscsi_tcp_r2t_rsp - iSCSI R2T Response processing
- * @conn: iscsi connection
- * @task: scsi command task
- */
-static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
-{
-	struct iscsi_session *session = conn->session;
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_r2t_rsp *rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
-	struct iscsi_r2t_info *r2t;
-	int r2tsn = be32_to_cpu(rhdr->r2tsn);
-	int rc;
-
-	if (tcp_conn->in.datalen) {
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "invalid R2t with datalen %d\n",
-				  tcp_conn->in.datalen);
-		return ISCSI_ERR_DATALEN;
-	}
-
-	if (tcp_task->exp_datasn != r2tsn){
-		debug_tcp("%s: task->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
-		          __func__, tcp_task->exp_datasn, r2tsn);
-		return ISCSI_ERR_R2TSN;
-	}
-
-	/* fill-in new R2T associated with the task */
-	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
-
-	if (!task->sc || session->state != ISCSI_STATE_LOGGED_IN) {
-		iscsi_conn_printk(KERN_INFO, conn,
-				  "dropping R2T itt %d in recovery.\n",
-				  task->itt);
-		return 0;
-	}
-
-	rc = __kfifo_get(tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
-	if (!rc) {
-		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
-				  "Target has sent more R2Ts than it "
-				  "negotiated for or driver has has leaked.\n");
-		return ISCSI_ERR_PROTO;
-	}
-
-	r2t->exp_statsn = rhdr->statsn;
-	r2t->data_length = be32_to_cpu(rhdr->data_length);
-	if (r2t->data_length == 0) {
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "invalid R2T with zero data len\n");
-		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
-		return ISCSI_ERR_DATALEN;
-	}
-
-	if (r2t->data_length > session->max_burst)
-		debug_scsi("invalid R2T with data len %u and max burst %u."
-			   "Attempting to execute request.\n",
-			    r2t->data_length, session->max_burst);
-
-	r2t->data_offset = be32_to_cpu(rhdr->data_offset);
-	if (r2t->data_offset + r2t->data_length > scsi_out(task->sc)->length) {
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "invalid R2T with data len %u at offset %u "
-				  "and total length %d\n", r2t->data_length,
-				  r2t->data_offset, scsi_out(task->sc)->length);
-		__kfifo_put(tcp_task->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
-		return ISCSI_ERR_DATALEN;
-	}
-
-	r2t->ttt = rhdr->ttt; /* no flip */
-	r2t->datasn = 0;
-	r2t->sent = 0;
-
-	tcp_task->exp_datasn = r2tsn + 1;
-	__kfifo_put(tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
-	conn->r2t_pdus_cnt++;
-
-	iscsi_requeue_task(task);
-	return 0;
-}
-
-/*
- * Handle incoming reply to DataIn command
- */
-static int
-iscsi_tcp_process_data_in(struct iscsi_tcp_conn *tcp_conn,
-			  struct iscsi_segment *segment)
-{
-	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
-	struct iscsi_hdr *hdr = tcp_conn->in.hdr;
-	int rc;
-
-	if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
-		return ISCSI_ERR_DATA_DGST;
-
-	/* check for non-exceptional status */
-	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
-		rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr, NULL, 0);
-		if (rc)
-			return rc;
-	}
-
-	iscsi_tcp_hdr_recv_prep(tcp_conn);
-	return 0;
-}
-
-/**
- * iscsi_tcp_hdr_dissect - process PDU header
- * @conn: iSCSI connection
- * @hdr: PDU header
- *
- * This function analyzes the header of the PDU received,
- * and performs several sanity checks. If the PDU is accompanied
- * by data, the receive buffer is set up to copy the incoming data
- * to the correct location.
- */
-static int
-iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
-{
-	int rc = 0, opcode, ahslen;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_task *task;
-
-	/* verify PDU length */
-	tcp_conn->in.datalen = ntoh24(hdr->dlength);
-	if (tcp_conn->in.datalen > conn->max_recv_dlength) {
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "iscsi_tcp: datalen %d > %d\n",
-				  tcp_conn->in.datalen, conn->max_recv_dlength);
-		return ISCSI_ERR_DATALEN;
-	}
-
-	/* Additional header segments. So far, we don't
-	 * process additional headers.
-	 */
-	ahslen = hdr->hlength << 2;
-
-	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
-	/* verify itt (itt encoding: age+cid+itt) */
-	rc = iscsi_verify_itt(conn, hdr->itt);
-	if (rc)
-		return rc;
-
-	debug_tcp("opcode 0x%x ahslen %d datalen %d\n",
-		  opcode, ahslen, tcp_conn->in.datalen);
-
-	switch(opcode) {
-	case ISCSI_OP_SCSI_DATA_IN:
-		spin_lock(&conn->session->lock);
-		task = iscsi_itt_to_ctask(conn, hdr->itt);
-		if (!task)
-			rc = ISCSI_ERR_BAD_ITT;
-		else
-			rc = iscsi_tcp_data_in(conn, task);
-		if (rc) {
-			spin_unlock(&conn->session->lock);
-			break;
-		}
-
-		if (tcp_conn->in.datalen) {
-			struct iscsi_tcp_task *tcp_task = task->dd_data;
-			struct hash_desc *rx_hash = NULL;
-			struct scsi_data_buffer *sdb = scsi_in(task->sc);
-
-			/*
-			 * Setup copy of Data-In into the Scsi_Cmnd
-			 * Scatterlist case:
-			 * We set up the iscsi_segment to point to the next
-			 * scatterlist entry to copy to. As we go along,
-			 * we move on to the next scatterlist entry and
-			 * update the digest per-entry.
-			 */
-			if (conn->datadgst_en &&
-			    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
-				rx_hash = &tcp_conn->rx_hash;
-
-			debug_tcp("iscsi_tcp_begin_data_in(%p, offset=%d, "
-				  "datalen=%d)\n", tcp_conn,
-				  tcp_task->data_offset,
-				  tcp_conn->in.datalen);
-			rc = iscsi_segment_seek_sg(&tcp_conn->in.segment,
-						   sdb->table.sgl,
-						   sdb->table.nents,
-						   tcp_task->data_offset,
-						   tcp_conn->in.datalen,
-						   iscsi_tcp_process_data_in,
-						   rx_hash);
-			spin_unlock(&conn->session->lock);
-			return rc;
-		}
-		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
-		spin_unlock(&conn->session->lock);
-		break;
-	case ISCSI_OP_SCSI_CMD_RSP:
-		if (tcp_conn->in.datalen) {
-			iscsi_tcp_data_recv_prep(tcp_conn);
-			return 0;
-		}
-		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
-		break;
-	case ISCSI_OP_R2T:
-		spin_lock(&conn->session->lock);
-		task = iscsi_itt_to_ctask(conn, hdr->itt);
-		if (!task)
-			rc = ISCSI_ERR_BAD_ITT;
-		else if (ahslen)
-			rc = ISCSI_ERR_AHSLEN;
-		else if (task->sc->sc_data_direction == DMA_TO_DEVICE)
-			rc = iscsi_tcp_r2t_rsp(conn, task);
-		else
-			rc = ISCSI_ERR_PROTO;
-		spin_unlock(&conn->session->lock);
-		break;
-	case ISCSI_OP_LOGIN_RSP:
-	case ISCSI_OP_TEXT_RSP:
-	case ISCSI_OP_REJECT:
-	case ISCSI_OP_ASYNC_EVENT:
-		/*
-		 * It is possible that we could get a PDU with a buffer larger
-		 * than 8K, but there are no targets that currently do this.
-		 * For now we fail until we find a vendor that needs it
-		 */
-		if (ISCSI_DEF_MAX_RECV_SEG_LEN < tcp_conn->in.datalen) {
-			iscsi_conn_printk(KERN_ERR, conn,
-					  "iscsi_tcp: received buffer of "
-					  "len %u but conn buffer is only %u "
-					  "(opcode %0x)\n",
-					  tcp_conn->in.datalen,
-					  ISCSI_DEF_MAX_RECV_SEG_LEN, opcode);
-			rc = ISCSI_ERR_PROTO;
-			break;
-		}
-
-		/* If there's data coming in with the response,
-		 * receive it to the connection's buffer.
-		 */
-		if (tcp_conn->in.datalen) {
-			iscsi_tcp_data_recv_prep(tcp_conn);
-			return 0;
-		}
-	/* fall through */
-	case ISCSI_OP_LOGOUT_RSP:
-	case ISCSI_OP_NOOP_IN:
-	case ISCSI_OP_SCSI_TMFUNC_RSP:
-		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
-		break;
-	default:
-		rc = ISCSI_ERR_BAD_OPCODE;
-		break;
-	}
-
-	if (rc == 0) {
-		/* Anything that comes with data should have
-		 * been handled above. */
-		if (tcp_conn->in.datalen)
-			return ISCSI_ERR_PROTO;
-		iscsi_tcp_hdr_recv_prep(tcp_conn);
-	}
-
-	return rc;
-}
-
-/**
- * iscsi_tcp_hdr_recv_done - process PDU header
- *
- * This is the callback invoked when the PDU header has
- * been received. If the header is followed by additional
- * header segments, we go back for more data.
- */
-static int
-iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
-			struct iscsi_segment *segment)
-{
-	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
-	struct iscsi_hdr *hdr;
-
-	/* Check if there are additional header segments
-	 * *prior* to computing the digest, because we
-	 * may need to go back to the caller for more.
-	 */
-	hdr = (struct iscsi_hdr *) tcp_conn->in.hdr_buf;
-	if (segment->copied == sizeof(struct iscsi_hdr) && hdr->hlength) {
-		/* Bump the header length - the caller will
-		 * just loop around and get the AHS for us, and
-		 * call again. */
-		unsigned int ahslen = hdr->hlength << 2;
-
-		/* Make sure we don't overflow */
-		if (sizeof(*hdr) + ahslen > sizeof(tcp_conn->in.hdr_buf))
-			return ISCSI_ERR_AHSLEN;
-
-		segment->total_size += ahslen;
-		segment->size += ahslen;
-		return 0;
-	}
-
-	/* We're done processing the header. See if we're doing
-	 * header digests; if so, set up the recv_digest buffer
-	 * and go back for more. */
-	if (conn->hdrdgst_en) {
-		if (segment->digest_len == 0) {
-			/*
-			 * Even if we offload the digest processing we
-			 * splice it in so we can increment the skb/segment
-			 * counters in preparation for the data segment.
-			 */
-			iscsi_tcp_segment_splice_digest(segment,
-							segment->recv_digest);
-			return 0;
-		}
-
-		if (!(conn->session->tt->caps & CAP_DIGEST_OFFLOAD)) {
-			iscsi_tcp_dgst_header(&tcp_conn->rx_hash, hdr,
-				segment->total_copied - ISCSI_DIGEST_SIZE,
-				segment->digest);
-
-			if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
-				return ISCSI_ERR_HDR_DGST;
-		}
-	}
-
-	tcp_conn->in.hdr = hdr;
-	return iscsi_tcp_hdr_dissect(conn, hdr);
-}
-
-inline int iscsi_tcp_recv_segment_is_hdr(struct iscsi_tcp_conn *tcp_conn)
-{
-	return tcp_conn->in.segment.done == iscsi_tcp_hdr_recv_done;
-}
-
-enum {
-	ISCSI_TCP_SEGMENT_DONE,		/* curr seg has been processed */
-	ISCSI_TCP_SKB_DONE,		/* skb is out of data */
-	ISCSI_TCP_CONN_ERR,		/* iscsi layer has fired a conn err */
-	ISCSI_TCP_SUSPENDED,		/* conn is suspended */
-};
-
-/**
- * iscsi_tcp_recv_skb - Process skb
- * @conn: iscsi connection
- * @skb: network buffer with header and/or data segment
- * @offset: offset in skb
- * @offload: bool indicating if transfer was offloaded
- */
-int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
-		       unsigned int offset, bool offloaded, int *status)
-{
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_segment *segment = &tcp_conn->in.segment;
-	struct skb_seq_state seq;
-	unsigned int consumed = 0;
-	int rc = 0;
-
-	debug_tcp("in %d bytes\n", skb->len - offset);
-
-	if (unlikely(conn->suspend_rx)) {
-		debug_tcp("conn %d Rx suspended!\n", conn->id);
-		*status = ISCSI_TCP_SUSPENDED;
-		return 0;
-	}
-
-	if (offloaded) {
-		segment->total_copied = segment->total_size;
-		goto segment_done;
-	}
-
-	skb_prepare_seq_read(skb, offset, skb->len, &seq);
-	while (1) {
-		unsigned int avail;
-		const u8 *ptr;
-
-		avail = skb_seq_read(consumed, &ptr, &seq);
-		if (avail == 0) {
-			debug_tcp("no more data avail. Consumed %d\n",
-				  consumed);
-			*status = ISCSI_TCP_SKB_DONE;
-			skb_abort_seq_read(&seq);
-			goto skb_done;
-		}
-		BUG_ON(segment->copied >= segment->size);
-
-		debug_tcp("skb %p ptr=%p avail=%u\n", skb, ptr, avail);
-		rc = iscsi_tcp_segment_recv(tcp_conn, segment, ptr, avail);
-		BUG_ON(rc == 0);
-		consumed += rc;
-
-		if (segment->total_copied >= segment->total_size) {
-			skb_abort_seq_read(&seq);
-			goto segment_done;
-		}
-	}
-
-segment_done:
-	*status = ISCSI_TCP_SEGMENT_DONE;
-	debug_tcp("segment done\n");
-	rc = segment->done(tcp_conn, segment);
-	if (rc != 0) {
-		*status = ISCSI_TCP_CONN_ERR;
-		debug_tcp("Error receiving PDU, errno=%d\n", rc);
-		iscsi_conn_failure(conn, rc);
-		return 0;
-	}
-	/* The done() functions sets up the next segment. */
-
-skb_done:
-	conn->rxdata_octets += consumed;
-	return consumed;
-}
-EXPORT_SYMBOL_GPL(iscsi_tcp_recv_skb);
-
-/**
- * iscsi_tcp_recv - TCP receive in sendfile fashion
+ * iscsi_sw_tcp_recv - TCP receive in sendfile fashion
  * @rd_desc: read descriptor
  * @skb: socket buffer
  * @offset: offset in skb
  * @len: skb->len - offset
- **/
-static int
-iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
-	       unsigned int offset, size_t len)
+ */
+static int iscsi_sw_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
+			     unsigned int offset, size_t len)
 {
 	struct iscsi_conn *conn = rd_desc->arg.data;
 	unsigned int consumed, total_consumed = 0;
@@ -993,8 +90,7 @@ iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 	return total_consumed;
 }
 
-static void
-iscsi_tcp_data_ready(struct sock *sk, int flag)
+static void iscsi_sw_tcp_data_ready(struct sock *sk, int flag)
 {
 	struct iscsi_conn *conn = sk->sk_user_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
@@ -1010,7 +106,7 @@ iscsi_tcp_data_ready(struct sock *sk, int flag)
 	 */
 	rd_desc.arg.data = conn;
 	rd_desc.count = 1;
-	tcp_read_sock(sk, &rd_desc, iscsi_tcp_recv);
+	tcp_read_sock(sk, &rd_desc, iscsi_sw_tcp_recv);
 
 	read_unlock(&sk->sk_callback_lock);
 
@@ -1019,10 +115,10 @@ iscsi_tcp_data_ready(struct sock *sk, int flag)
 	iscsi_tcp_segment_unmap(&tcp_conn->in.segment);
 }
 
-static void
-iscsi_tcp_state_change(struct sock *sk)
+static void iscsi_sw_tcp_state_change(struct sock *sk)
 {
 	struct iscsi_tcp_conn *tcp_conn;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn;
 	struct iscsi_conn *conn;
 	struct iscsi_session *session;
 	void (*old_state_change)(struct sock *);
@@ -1040,7 +136,8 @@ iscsi_tcp_state_change(struct sock *sk)
 	}
 
 	tcp_conn = conn->dd_data;
-	old_state_change = tcp_conn->old_state_change;
+	tcp_sw_conn = tcp_conn->dd_data;
+	old_state_change = tcp_sw_conn->old_state_change;
 
 	read_unlock(&sk->sk_callback_lock);
 
@@ -1051,59 +148,122 @@ iscsi_tcp_state_change(struct sock *sk)
  * iscsi_write_space - Called when more output buffer space is available
  * @sk: socket space is available for
  **/
-static void iscsi_tcp_write_space(struct sock *sk)
+static void iscsi_sw_tcp_write_space(struct sock *sk)
 {
 	struct iscsi_conn *conn = (struct iscsi_conn*)sk->sk_user_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 
-	tcp_conn->old_write_space(sk);
+	tcp_sw_conn->old_write_space(sk);
 	debug_tcp("iscsi_write_space: cid %d\n", conn->id);
 	scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
 
-static void iscsi_tcp_conn_set_callbacks(struct iscsi_conn *conn)
+static void iscsi_sw_tcp_conn_set_callbacks(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct sock *sk = tcp_conn->sock->sk;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct sock *sk = tcp_sw_conn->sock->sk;
 
 	/* assign new callbacks */
 	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_user_data = conn;
-	tcp_conn->old_data_ready = sk->sk_data_ready;
-	tcp_conn->old_state_change = sk->sk_state_change;
-	tcp_conn->old_write_space = sk->sk_write_space;
-	sk->sk_data_ready = iscsi_tcp_data_ready;
-	sk->sk_state_change = iscsi_tcp_state_change;
-	sk->sk_write_space = iscsi_tcp_write_space;
+	tcp_sw_conn->old_data_ready = sk->sk_data_ready;
+	tcp_sw_conn->old_state_change = sk->sk_state_change;
+	tcp_sw_conn->old_write_space = sk->sk_write_space;
+	sk->sk_data_ready = iscsi_sw_tcp_data_ready;
+	sk->sk_state_change = iscsi_sw_tcp_state_change;
+	sk->sk_write_space = iscsi_sw_tcp_write_space;
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
-static void iscsi_conn_restore_callbacks(struct iscsi_tcp_conn *tcp_conn)
+static void
+iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_sw_tcp_conn *tcp_sw_conn)
 {
-	struct sock *sk = tcp_conn->sock->sk;
+	struct sock *sk = tcp_sw_conn->sock->sk;
 
 	/* restore socket callbacks, see also: iscsi_conn_set_callbacks() */
 	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_user_data    = NULL;
-	sk->sk_data_ready   = tcp_conn->old_data_ready;
-	sk->sk_state_change = tcp_conn->old_state_change;
-	sk->sk_write_space  = tcp_conn->old_write_space;
+	sk->sk_data_ready   = tcp_sw_conn->old_data_ready;
+	sk->sk_state_change = tcp_sw_conn->old_state_change;
+	sk->sk_write_space  = tcp_sw_conn->old_write_space;
 	sk->sk_no_check	 = 0;
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
 /**
- * iscsi_tcp_xmit - TCP transmit
+ * iscsi_sw_tcp_xmit_segment - transmit segment
+ * @tcp_sw_conn: the iSCSI TCP connection
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
+static int iscsi_sw_tcp_xmit_segment(struct iscsi_sw_tcp_conn *tcp_sw_conn,
+				     struct iscsi_segment *segment)
+{
+	struct socket *sk = tcp_sw_conn->sock;
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
+			r = tcp_sw_conn->sendpage(sk, sg_page(sg), offset,
+						  copy, flags);
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
+ * iscsi_sw_tcp_xmit - TCP transmit
  **/
-static int iscsi_tcp_xmit(struct iscsi_conn *conn)
+static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_segment *segment = &tcp_conn->out.segment;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct iscsi_segment *segment = &tcp_sw_conn->out.segment;
 	unsigned int consumed = 0;
 	int rc = 0;
 
 	while (1) {
-		rc = iscsi_tcp_xmit_segment(tcp_conn, segment);
+		rc = iscsi_sw_tcp_xmit_segment(tcp_sw_conn, segment);
 		if (rc < 0) {
 			rc = ISCSI_ERR_XMIT_FAILED;
 			goto error;
@@ -1138,22 +298,22 @@ error:
 /**
  * iscsi_tcp_xmit_qlen - return the number of bytes queued for xmit
  */
-static inline int
-iscsi_tcp_xmit_qlen(struct iscsi_conn *conn)
+static inline int iscsi_sw_tcp_xmit_qlen(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_segment *segment = &tcp_conn->out.segment;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct iscsi_segment *segment = &tcp_sw_conn->out.segment;
 
 	return segment->total_copied - segment->total_size;
 }
 
-static int iscsi_tcp_flush(struct iscsi_task *task)
+static int iscsi_sw_tcp_pdu_xmit(struct iscsi_task *task)
 {
 	struct iscsi_conn *conn = task->conn;
 	int rc;
 
-	while (iscsi_tcp_xmit_qlen(conn)) {
-		rc = iscsi_tcp_xmit(conn);
+	while (iscsi_sw_tcp_xmit_qlen(conn)) {
+		rc = iscsi_sw_tcp_xmit(conn);
 		if (rc == 0)
 			return -EAGAIN;
 		if (rc < 0)
@@ -1167,27 +327,31 @@ static int iscsi_tcp_flush(struct iscsi_task *task)
  * This is called when we're done sending the header.
  * Simply copy the data_segment to the send segment, and return.
  */
-static int
-iscsi_tcp_send_hdr_done(struct iscsi_tcp_conn *tcp_conn,
-			struct iscsi_segment *segment)
+static int iscsi_sw_tcp_send_hdr_done(struct iscsi_tcp_conn *tcp_conn,
+				      struct iscsi_segment *segment)
 {
-	tcp_conn->out.segment = tcp_conn->out.data_segment;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+
+	tcp_sw_conn->out.segment = tcp_sw_conn->out.data_segment;
 	debug_tcp("Header done. Next segment size %u total_size %u\n",
-		  tcp_conn->out.segment.size, tcp_conn->out.segment.total_size);
+		  tcp_sw_conn->out.segment.size,
+		  tcp_sw_conn->out.segment.total_size);
 	return 0;
 }
 
-static void
-iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
+static void iscsi_sw_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr,
+				       size_t hdrlen)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 
 	debug_tcp("%s(%p%s)\n", __func__, tcp_conn,
 			conn->hdrdgst_en? ", digest enabled" : "");
 
 	/* Clear the data segment - needs to be filled in by the
 	 * caller using iscsi_tcp_send_data_prep() */
-	memset(&tcp_conn->out.data_segment, 0, sizeof(struct iscsi_segment));
+	memset(&tcp_sw_conn->out.data_segment, 0,
+	       sizeof(struct iscsi_segment));
 
 	/* If header digest is enabled, compute the CRC and
 	 * place the digest into the same buffer. We make
@@ -1195,7 +359,7 @@ iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
 	 * sufficient room.
 	 */
 	if (conn->hdrdgst_en) {
-		iscsi_tcp_dgst_header(&tcp_conn->tx_hash, hdr, hdrlen,
+		iscsi_tcp_dgst_header(&tcp_sw_conn->tx_hash, hdr, hdrlen,
 				      hdr + hdrlen);
 		hdrlen += ISCSI_DIGEST_SIZE;
 	}
@@ -1203,10 +367,10 @@ iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
 	/* Remember header pointer for later, when we need
 	 * to decide whether there's a payload to go along
 	 * with the header. */
-	tcp_conn->out.hdr = hdr;
+	tcp_sw_conn->out.hdr = hdr;
 
-	iscsi_segment_init_linear(&tcp_conn->out.segment, hdr, hdrlen,
-				iscsi_tcp_send_hdr_done, NULL);
+	iscsi_segment_init_linear(&tcp_sw_conn->out.segment, hdr, hdrlen,
+				  iscsi_sw_tcp_send_hdr_done, NULL);
 }
 
 /*
@@ -1215,11 +379,12 @@ iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
  * of by the iscsi_segment routines.
  */
 static int
-iscsi_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
-			 unsigned int count, unsigned int offset,
-			 unsigned int len)
+iscsi_sw_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
+			    unsigned int count, unsigned int offset,
+			    unsigned int len)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
@@ -1229,22 +394,23 @@ iscsi_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
 
 	/* Make sure the datalen matches what the caller
 	   said he would send. */
-	hdr_spec_len = ntoh24(tcp_conn->out.hdr->dlength);
+	hdr_spec_len = ntoh24(tcp_sw_conn->out.hdr->dlength);
 	WARN_ON(iscsi_padded(len) != iscsi_padded(hdr_spec_len));
 
 	if (conn->datadgst_en)
-		tx_hash = &tcp_conn->tx_hash;
+		tx_hash = &tcp_sw_conn->tx_hash;
 
-	return iscsi_segment_seek_sg(&tcp_conn->out.data_segment,
-				   sg, count, offset, len,
-				   NULL, tx_hash);
+	return iscsi_segment_seek_sg(&tcp_sw_conn->out.data_segment,
+				     sg, count, offset, len,
+				     NULL, tx_hash);
 }
 
 static void
-iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
+iscsi_sw_tcp_send_linear_data_prep(struct iscsi_conn *conn, void *data,
 				   size_t len)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
@@ -1253,34 +419,35 @@ iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
 
 	/* Make sure the datalen matches what the caller
 	   said he would send. */
-	hdr_spec_len = ntoh24(tcp_conn->out.hdr->dlength);
+	hdr_spec_len = ntoh24(tcp_sw_conn->out.hdr->dlength);
 	WARN_ON(iscsi_padded(len) != iscsi_padded(hdr_spec_len));
 
 	if (conn->datadgst_en)
-		tx_hash = &tcp_conn->tx_hash;
+		tx_hash = &tcp_sw_conn->tx_hash;
 
-	iscsi_segment_init_linear(&tcp_conn->out.data_segment,
+	iscsi_segment_init_linear(&tcp_sw_conn->out.data_segment,
 				data, len, NULL, tx_hash);
 }
 
-static int iscsi_tcp_pdu_init(struct iscsi_task *task,
-			      unsigned int offset, unsigned int count)
+static int iscsi_sw_tcp_pdu_init(struct iscsi_task *task,
+				 unsigned int offset, unsigned int count)
 {
 	struct iscsi_conn *conn = task->conn;
 	int err = 0;
 
-	iscsi_tcp_send_hdr_prep(conn, task->hdr, task->hdr_len);
+	iscsi_sw_tcp_send_hdr_prep(conn, task->hdr, task->hdr_len);
 
 	if (!count)
 		return 0;
 
 	if (!task->sc)
-		iscsi_tcp_send_linear_data_prepare(conn, task->data, count);
+		iscsi_sw_tcp_send_linear_data_prep(conn, task->data, count);
 	else {
 		struct scsi_data_buffer *sdb = scsi_out(task->sc);
 
-		err = iscsi_tcp_send_data_prep(conn, sdb->table.sgl,
-					       sdb->table.nents, offset, count);
+		err = iscsi_sw_tcp_send_data_prep(conn, sdb->table.sgl,
+						  sdb->table.nents, offset,
+						  count);
 	}
 
 	if (err) {
@@ -1290,251 +457,122 @@ static int iscsi_tcp_pdu_init(struct iscsi_task *task,
 	return 0;
 }
 
-static int iscsi_tcp_pdu_alloc(struct iscsi_task *task)
-{
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-
-	task->hdr = &tcp_task->hdr.hdrbuf;
-	task->hdr_max = sizeof(tcp_task->hdr) - ISCSI_DIGEST_SIZE;
-	return 0;
-}
-
-/**
- * iscsi_tcp_task - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
- * @conn: iscsi connection
- * @task: scsi command task
- * @sc: scsi command
- **/
-static int iscsi_tcp_task_init(struct iscsi_task *task)
+static int iscsi_sw_tcp_pdu_alloc(struct iscsi_task *task)
 {
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct iscsi_conn *conn = task->conn;
-	struct scsi_cmnd *sc = task->sc;
-	int err;
 
-	if (!sc) {
-		/*
-		 * mgmt tasks do not have a scatterlist since they come
-		 * in from the iscsi interface.
-		 */
-		debug_scsi("mtask deq [cid %d itt 0x%x]\n", conn->id,
-			   task->itt);
-
-		return conn->session->tt->init_pdu(task, 0, task->data_count);
-	}
-
-	BUG_ON(__kfifo_len(tcp_task->r2tqueue));
-	tcp_task->exp_datasn = 0;
-
-	/* Prepare PDU, optionally w/ immediate data */
-	debug_scsi("task deq [cid %d itt 0x%x imm %d unsol %d]\n",
-		    conn->id, task->itt, task->imm_count,
-		    task->unsol_r2t.data_length);
-
-	err = conn->session->tt->init_pdu(task, 0, task->imm_count);
-	if (err)
-		return err;
-	task->imm_count = 0;
+	task->hdr = task->dd_data + sizeof(*tcp_task);
+	task->hdr_max = sizeof(struct iscsi_sw_tcp_hdrbuf) - ISCSI_DIGEST_SIZE;
 	return 0;
 }
 
-static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
-{
-	struct iscsi_session *session = task->conn->session;
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct iscsi_r2t_info *r2t = NULL;
-
-	if (iscsi_task_has_unsol_data(task))
-		r2t = &task->unsol_r2t;
-	else {
-		spin_lock_bh(&session->lock);
-		if (tcp_task->r2t) {
-			r2t = tcp_task->r2t;
-			/* Continue with this R2T? */
-			if (r2t->data_length <= r2t->sent) {
-				debug_scsi("  done with r2t %p\n", r2t);
-				__kfifo_put(tcp_task->r2tpool.queue,
-					    (void *)&tcp_task->r2t,
-					    sizeof(void *));
-				tcp_task->r2t = r2t = NULL;
-			}
-		}
-
-		if (r2t == NULL) {
-			__kfifo_get(tcp_task->r2tqueue,
-				    (void *)&tcp_task->r2t, sizeof(void *));
-			r2t = tcp_task->r2t;
-		}
-		spin_unlock_bh(&session->lock);
-	}
-
-	return r2t;
-}
-
-/*
- * iscsi_tcp_task_xmit - xmit normal PDU task
- * @task: iscsi command task
- *
- * We're expected to return 0 when everything was transmitted succesfully,
- * -EAGAIN if there's still data in the queue, or != 0 for any other kind
- * of error.
- */
-static int iscsi_tcp_task_xmit(struct iscsi_task *task)
-{
-	struct iscsi_conn *conn = task->conn;
-	struct iscsi_session *session = conn->session;
-	struct iscsi_r2t_info *r2t;
-	int rc = 0;
-
-flush:
-	/* Flush any pending data first. */
-	rc = session->tt->xmit_pdu(task);
-	if (rc < 0)
-		return rc;
-
-	/* mgmt command */
-	if (!task->sc) {
-		if (task->hdr->itt == RESERVED_ITT)
-			iscsi_put_task(task);
-		return 0;
-	}
-
-	/* Are we done already? */
-	if (task->sc->sc_data_direction != DMA_TO_DEVICE)
-		return 0;
-
-	r2t = iscsi_tcp_get_curr_r2t(task);
-	if (r2t == NULL) {
-		/* Waiting for more R2Ts to arrive. */
-		debug_tcp("no R2Ts yet\n");
-		return 0;
-	}
-
-	rc = conn->session->tt->alloc_pdu(task);
-	if (rc)
-		return rc;
-	iscsi_prep_data_out_pdu(task, r2t, (struct iscsi_data *) task->hdr);
-
-	debug_scsi("sol dout %p [dsn %d itt 0x%x doff %d dlen %d]\n",
-		   r2t, r2t->datasn - 1, task->hdr->itt,
-		   r2t->data_offset + r2t->sent, r2t->data_count);
-
-	rc = conn->session->tt->init_pdu(task, r2t->data_offset + r2t->sent,
-					 r2t->data_count);
-	if (rc)
-		return rc;
-	r2t->sent += r2t->data_count;
-	goto flush;
-}
-
 static struct iscsi_cls_conn *
-iscsi_tcp_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
+iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
+			 uint32_t conn_idx)
 {
 	struct iscsi_conn *conn;
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_tcp_conn *tcp_conn;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn;
 
-	cls_conn = iscsi_conn_setup(cls_session, sizeof(*tcp_conn), conn_idx);
+	cls_conn = iscsi_tcp_conn_setup(cls_session, sizeof(*tcp_sw_conn),
+					conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
-	/*
-	 * due to strange issues with iser these are not set
-	 * in iscsi_conn_setup
-	 */
-	conn->max_recv_dlength = ISCSI_DEF_MAX_RECV_SEG_LEN;
-
 	tcp_conn = conn->dd_data;
-	tcp_conn->iscsi_conn = conn;
+	tcp_sw_conn = tcp_conn->dd_data;
 
-	tcp_conn->tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
-						  CRYPTO_ALG_ASYNC);
-	tcp_conn->tx_hash.flags = 0;
-	if (IS_ERR(tcp_conn->tx_hash.tfm))
+	tcp_sw_conn->tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
+						     CRYPTO_ALG_ASYNC);
+	tcp_sw_conn->tx_hash.flags = 0;
+	if (IS_ERR(tcp_sw_conn->tx_hash.tfm))
 		goto free_conn;
 
-	tcp_conn->rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
-						  CRYPTO_ALG_ASYNC);
-	tcp_conn->rx_hash.flags = 0;
-	if (IS_ERR(tcp_conn->rx_hash.tfm))
+	tcp_sw_conn->rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
+						     CRYPTO_ALG_ASYNC);
+	tcp_sw_conn->rx_hash.flags = 0;
+	if (IS_ERR(tcp_sw_conn->rx_hash.tfm))
 		goto free_tx_tfm;
+	tcp_conn->rx_hash = &tcp_sw_conn->rx_hash;
 
 	return cls_conn;
 
 free_tx_tfm:
-	crypto_free_hash(tcp_conn->tx_hash.tfm);
+	crypto_free_hash(tcp_sw_conn->tx_hash.tfm);
 free_conn:
 	iscsi_conn_printk(KERN_ERR, conn,
 			  "Could not create connection due to crc32c "
 			  "loading error. Make sure the crc32c "
 			  "module is built as a module or into the "
 			  "kernel\n");
-	iscsi_conn_teardown(cls_conn);
+	iscsi_tcp_conn_teardown(cls_conn);
 	return NULL;
 }
 
-static void
-iscsi_tcp_release_conn(struct iscsi_conn *conn)
+static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct socket *sock = tcp_conn->sock;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct socket *sock = tcp_sw_conn->sock;
 
 	if (!sock)
 		return;
 
 	sock_hold(sock->sk);
-	iscsi_conn_restore_callbacks(tcp_conn);
+	iscsi_sw_tcp_conn_restore_callbacks(tcp_sw_conn);
 	sock_put(sock->sk);
 
 	spin_lock_bh(&session->lock);
-	tcp_conn->sock = NULL;
+	tcp_sw_conn->sock = NULL;
 	spin_unlock_bh(&session->lock);
 	sockfd_put(sock);
 }
 
-static void
-iscsi_tcp_conn_destroy(struct iscsi_cls_conn *cls_conn)
+static void iscsi_sw_tcp_conn_destroy(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 
-	iscsi_tcp_release_conn(conn);
+	iscsi_sw_tcp_release_conn(conn);
 
-	if (tcp_conn->tx_hash.tfm)
-		crypto_free_hash(tcp_conn->tx_hash.tfm);
-	if (tcp_conn->rx_hash.tfm)
-		crypto_free_hash(tcp_conn->rx_hash.tfm);
+	if (tcp_sw_conn->tx_hash.tfm)
+		crypto_free_hash(tcp_sw_conn->tx_hash.tfm);
+	if (tcp_sw_conn->rx_hash.tfm)
+		crypto_free_hash(tcp_sw_conn->rx_hash.tfm);
 
-	iscsi_conn_teardown(cls_conn);
+	iscsi_tcp_conn_teardown(cls_conn);
 }
 
-static void
-iscsi_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
+static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 
 	/* userspace may have goofed up and not bound us */
-	if (!tcp_conn->sock)
+	if (!tcp_sw_conn->sock)
 		return;
 	/*
 	 * Make sure our recv side is stopped.
 	 * Older tools called conn stop before ep_disconnect
 	 * so IO could still be coming in.
 	 */
-	write_lock_bh(&tcp_conn->sock->sk->sk_callback_lock);
+	write_lock_bh(&tcp_sw_conn->sock->sk->sk_callback_lock);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	write_unlock_bh(&tcp_conn->sock->sk->sk_callback_lock);
+	write_unlock_bh(&tcp_sw_conn->sock->sk->sk_callback_lock);
 
 	iscsi_conn_stop(cls_conn, flag);
-	iscsi_tcp_release_conn(conn);
+	iscsi_sw_tcp_release_conn(conn);
 }
 
-static int iscsi_tcp_get_addr(struct iscsi_conn *conn, struct socket *sock,
-			      char *buf, int *port,
-			      int (*getname)(struct socket *, struct sockaddr *,
-					int *addrlen))
+static int iscsi_sw_tcp_get_addr(struct iscsi_conn *conn, struct socket *sock,
+				 char *buf, int *port,
+				 int (*getname)(struct socket *,
+						struct sockaddr *,
+						int *addrlen))
 {
 	struct sockaddr_storage *addr;
 	struct sockaddr_in6 *sin6;
@@ -1572,14 +610,15 @@ free_addr:
 }
 
 static int
-iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
-		    struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
-		    int is_leading)
+iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
+		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
+		       int is_leading)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_host *ihost = shost_priv(shost);
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct sock *sk;
 	struct socket *sock;
 	int err;
@@ -1596,13 +635,13 @@ iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	 * userspace may still want to query the values since we will
 	 * be using them for the reconnect
 	 */
-	err = iscsi_tcp_get_addr(conn, sock, conn->portal_address,
-				 &conn->portal_port, kernel_getpeername);
+	err = iscsi_sw_tcp_get_addr(conn, sock, conn->portal_address,
+				    &conn->portal_port, kernel_getpeername);
 	if (err)
 		goto free_socket;
 
-	err = iscsi_tcp_get_addr(conn, sock, ihost->local_address,
-				&ihost->local_port, kernel_getsockname);
+	err = iscsi_sw_tcp_get_addr(conn, sock, ihost->local_address,
+				    &ihost->local_port, kernel_getsockname);
 	if (err)
 		goto free_socket;
 
@@ -1611,7 +650,7 @@ iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		goto free_socket;
 
 	/* bind iSCSI connection and socket */
-	tcp_conn->sock = sock;
+	tcp_sw_conn->sock = sock;
 
 	/* setup Socket parameters */
 	sk = sock->sk;
@@ -1619,8 +658,8 @@ iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
 	sk->sk_allocation = GFP_ATOMIC;
 
-	iscsi_tcp_conn_set_callbacks(conn);
-	tcp_conn->sendpage = tcp_conn->sock->ops->sendpage;
+	iscsi_sw_tcp_conn_set_callbacks(conn);
+	tcp_sw_conn->sendpage = tcp_sw_conn->sock->ops->sendpage;
 	/*
 	 * set receive state machine into initial state
 	 */
@@ -1632,75 +671,14 @@ free_socket:
 	return err;
 }
 
-static int
-iscsi_r2tpool_alloc(struct iscsi_session *session)
-{
-	int i;
-	int cmd_i;
-
-	/*
-	 * initialize per-task: R2T pool and xmit queue
-	 */
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-	        struct iscsi_task *task = session->cmds[cmd_i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
-
-		/*
-		 * pre-allocated x2 as much r2ts to handle race when
-		 * target acks DataOut faster than we data_xmit() queues
-		 * could replenish r2tqueue.
-		 */
-
-		/* R2T pool */
-		if (iscsi_pool_init(&tcp_task->r2tpool,
-				    session->max_r2t * 2, NULL,
-				    sizeof(struct iscsi_r2t_info))) {
-			goto r2t_alloc_fail;
-		}
-
-		/* R2T xmit queue */
-		tcp_task->r2tqueue = kfifo_alloc(
-		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL, NULL);
-		if (tcp_task->r2tqueue == ERR_PTR(-ENOMEM)) {
-			iscsi_pool_free(&tcp_task->r2tpool);
-			goto r2t_alloc_fail;
-		}
-	}
-
-	return 0;
-
-r2t_alloc_fail:
-	for (i = 0; i < cmd_i; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
-
-		kfifo_free(tcp_task->r2tqueue);
-		iscsi_pool_free(&tcp_task->r2tpool);
-	}
-	return -ENOMEM;
-}
-
-static void
-iscsi_r2tpool_free(struct iscsi_session *session)
-{
-	int i;
-
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
-
-		kfifo_free(tcp_task->r2tqueue);
-		iscsi_pool_free(&tcp_task->r2tpool);
-	}
-}
-
-static int
-iscsi_conn_set_param(struct iscsi_cls_conn *cls_conn, enum iscsi_param param,
-		     char *buf, int buflen)
+static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
+				       enum iscsi_param param, char *buf,
+				       int buflen)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	int value;
 
 	switch(param) {
@@ -1709,8 +687,8 @@ iscsi_conn_set_param(struct iscsi_cls_conn *cls_conn, enum iscsi_param param,
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
-		tcp_conn->sendpage = conn->datadgst_en ?
-			sock_no_sendpage : tcp_conn->sock->ops->sendpage;
+		tcp_sw_conn->sendpage = conn->datadgst_en ?
+			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
 		break;
 	case ISCSI_PARAM_MAX_R2T:
 		sscanf(buf, "%d", &value);
@@ -1718,9 +696,9 @@ iscsi_conn_set_param(struct iscsi_cls_conn *cls_conn, enum iscsi_param param,
 			return -EINVAL;
 		if (session->max_r2t == value)
 			break;
-		iscsi_r2tpool_free(session);
+		iscsi_tcp_r2tpool_free(session);
 		iscsi_set_param(cls_conn, param, buf, buflen);
-		if (iscsi_r2tpool_alloc(session))
+		if (iscsi_tcp_r2tpool_alloc(session))
 			return -ENOMEM;
 		break;
 	default:
@@ -1730,9 +708,8 @@ iscsi_conn_set_param(struct iscsi_cls_conn *cls_conn, enum iscsi_param param,
 	return 0;
 }
 
-static int
-iscsi_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
-			 enum iscsi_param param, char *buf)
+static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
+				       enum iscsi_param param, char *buf)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	int len;
@@ -1756,33 +733,28 @@ iscsi_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 }
 
 static void
-iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
+iscsi_sw_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
+			    struct iscsi_stats *stats)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 
-	stats->txdata_octets = conn->txdata_octets;
-	stats->rxdata_octets = conn->rxdata_octets;
-	stats->scsicmd_pdus = conn->scsicmd_pdus_cnt;
-	stats->dataout_pdus = conn->dataout_pdus_cnt;
-	stats->scsirsp_pdus = conn->scsirsp_pdus_cnt;
-	stats->datain_pdus = conn->datain_pdus_cnt;
-	stats->r2t_pdus = conn->r2t_pdus_cnt;
-	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
-	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
 	stats->custom_length = 3;
 	strcpy(stats->custom[0].desc, "tx_sendpage_failures");
-	stats->custom[0].value = tcp_conn->sendpage_failures_cnt;
+	stats->custom[0].value = tcp_sw_conn->sendpage_failures_cnt;
 	strcpy(stats->custom[1].desc, "rx_discontiguous_hdr");
-	stats->custom[1].value = tcp_conn->discontiguous_hdr_cnt;
+	stats->custom[1].value = tcp_sw_conn->discontiguous_hdr_cnt;
 	strcpy(stats->custom[2].desc, "eh_abort_cnt");
 	stats->custom[2].value = conn->eh_abort_cnt;
+
+	iscsi_tcp_conn_get_stats(cls_conn, stats);
 }
 
 static struct iscsi_cls_session *
-iscsi_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
-			 uint16_t qdepth, uint32_t initial_cmdsn,
-			 uint32_t *hostno)
+iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
+			    uint16_t qdepth, uint32_t initial_cmdsn,
+			    uint32_t *hostno)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -1793,10 +765,10 @@ iscsi_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		return NULL;
 	}
 
-	shost = iscsi_host_alloc(&iscsi_sht, 0, qdepth);
+	shost = iscsi_host_alloc(&iscsi_sw_tcp_sht, 0, qdepth);
 	if (!shost)
 		return NULL;
-	shost->transportt = iscsi_tcp_scsi_transport;
+	shost->transportt = iscsi_sw_tcp_scsi_transport;
 	shost->max_lun = iscsi_max_lun;
 	shost->max_id = 0;
 	shost->max_channel = 0;
@@ -1806,15 +778,17 @@ iscsi_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		goto free_host;
 	*hostno = shost->host_no;
 
-	cls_session = iscsi_session_setup(&iscsi_tcp_transport, shost, cmds_max,
-					  sizeof(struct iscsi_tcp_task),
+	cls_session = iscsi_session_setup(&iscsi_sw_tcp_transport, shost,
+					  cmds_max,
+					  sizeof(struct iscsi_tcp_task) +
+					  sizeof(struct iscsi_sw_tcp_hdrbuf),
 					  initial_cmdsn, 0);
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
 
 	shost->can_queue = session->scsi_cmds_max;
-	if (iscsi_r2tpool_alloc(session))
+	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
 	return cls_session;
 
@@ -1827,25 +801,25 @@ free_host:
 	return NULL;
 }
 
-static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
+static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 
-	iscsi_r2tpool_free(cls_session->dd_data);
+	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
 
 	iscsi_host_remove(shost);
 	iscsi_host_free(shost);
 }
 
-static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
+static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 {
 	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
 	blk_queue_dma_alignment(sdev->request_queue, 0);
 	return 0;
 }
 
-static struct scsi_host_template iscsi_sht = {
+static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
@@ -1858,12 +832,12 @@ static struct scsi_host_template iscsi_sht = {
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler= iscsi_eh_target_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
-	.slave_configure        = iscsi_tcp_slave_configure,
+	.slave_configure        = iscsi_sw_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 };
 
-static struct iscsi_transport iscsi_tcp_transport = {
+static struct iscsi_transport iscsi_sw_tcp_transport = {
 	.owner			= THIS_MODULE,
 	.name			= "tcp",
 	.caps			= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
@@ -1896,37 +870,36 @@ static struct iscsi_transport iscsi_tcp_transport = {
 				  ISCSI_HOST_INITIATOR_NAME |
 				  ISCSI_HOST_NETDEV_NAME,
 	/* session management */
-	.create_session		= iscsi_tcp_session_create,
-	.destroy_session	= iscsi_tcp_session_destroy,
+	.create_session		= iscsi_sw_tcp_session_create,
+	.destroy_session	= iscsi_sw_tcp_session_destroy,
 	/* connection management */
-	.create_conn		= iscsi_tcp_conn_create,
-	.bind_conn		= iscsi_tcp_conn_bind,
-	.destroy_conn		= iscsi_tcp_conn_destroy,
-	.set_param		= iscsi_conn_set_param,
-	.get_conn_param		= iscsi_tcp_conn_get_param,
+	.create_conn		= iscsi_sw_tcp_conn_create,
+	.bind_conn		= iscsi_sw_tcp_conn_bind,
+	.destroy_conn		= iscsi_sw_tcp_conn_destroy,
+	.set_param		= iscsi_sw_tcp_conn_set_param,
+	.get_conn_param		= iscsi_sw_tcp_conn_get_param,
 	.get_session_param	= iscsi_session_get_param,
 	.start_conn		= iscsi_conn_start,
-	.stop_conn		= iscsi_tcp_conn_stop,
+	.stop_conn		= iscsi_sw_tcp_conn_stop,
 	/* iscsi host params */
 	.get_host_param		= iscsi_host_get_param,
 	.set_host_param		= iscsi_host_set_param,
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
-	.get_stats		= iscsi_conn_get_stats,
+	.get_stats		= iscsi_sw_tcp_conn_get_stats,
 	/* iscsi task/cmd helpers */
 	.init_task		= iscsi_tcp_task_init,
 	.xmit_task		= iscsi_tcp_task_xmit,
 	.cleanup_task		= iscsi_tcp_cleanup_task,
 	/* low level pdu helpers */
-	.xmit_pdu		= iscsi_tcp_flush,
-	.init_pdu		= iscsi_tcp_pdu_init,
-	.alloc_pdu		= iscsi_tcp_pdu_alloc,
+	.xmit_pdu		= iscsi_sw_tcp_pdu_xmit,
+	.init_pdu		= iscsi_sw_tcp_pdu_init,
+	.alloc_pdu		= iscsi_sw_tcp_pdu_alloc,
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
 };
 
-static int __init
-iscsi_tcp_init(void)
+static int __init iscsi_sw_tcp_init(void)
 {
 	if (iscsi_max_lun < 1) {
 		printk(KERN_ERR "iscsi_tcp: Invalid max_lun value of %u\n",
@@ -1934,19 +907,18 @@ iscsi_tcp_init(void)
 		return -EINVAL;
 	}
 
-	iscsi_tcp_scsi_transport = iscsi_register_transport(
-							&iscsi_tcp_transport);
-	if (!iscsi_tcp_scsi_transport)
+	iscsi_sw_tcp_scsi_transport = iscsi_register_transport(
+						&iscsi_sw_tcp_transport);
+	if (!iscsi_sw_tcp_scsi_transport)
 		return -ENODEV;
 
 	return 0;
 }
 
-static void __exit
-iscsi_tcp_exit(void)
+static void __exit iscsi_sw_tcp_exit(void)
 {
-	iscsi_unregister_transport(&iscsi_tcp_transport);
+	iscsi_unregister_transport(&iscsi_sw_tcp_transport);
 }
 
-module_init(iscsi_tcp_init);
-module_exit(iscsi_tcp_exit);
+module_init(iscsi_sw_tcp_init);
+module_exit(iscsi_sw_tcp_exit);
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 0ed4773..ca6b7bc 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -19,67 +19,27 @@
  * See the file COPYING included with this distribution for more details.
  */
 
-#ifndef ISCSI_TCP_H
-#define ISCSI_TCP_H
+#ifndef ISCSI_SW_TCP_H
+#define ISCSI_SW_TCP_H
 
 #include <scsi/libiscsi.h>
+#include <scsi/libiscsi_tcp.h>
 
-struct crypto_hash;
 struct socket;
 struct iscsi_tcp_conn;
-struct iscsi_segment;
-
-typedef int iscsi_segment_done_fn_t(struct iscsi_tcp_conn *,
-				    struct iscsi_segment *);
-
-struct iscsi_segment {
-	unsigned char		*data;
-	unsigned int		size;
-	unsigned int		copied;
-	unsigned int		total_size;
-	unsigned int		total_copied;
-
-	struct hash_desc	*hash;
-	unsigned char		recv_digest[ISCSI_DIGEST_SIZE];
-	unsigned char		digest[ISCSI_DIGEST_SIZE];
-	unsigned int		digest_len;
-
-	struct scatterlist	*sg;
-	void			*sg_mapped;
-	unsigned int		sg_offset;
-
-	iscsi_segment_done_fn_t	*done;
-};
-
-/* Socket connection recieve helper */
-struct iscsi_tcp_recv {
-	struct iscsi_hdr	*hdr;
-	struct iscsi_segment	segment;
-
-	/* Allocate buffer for BHS + AHS */
-	uint32_t		hdr_buf[64];
-
-	/* copied and flipped values */
-	int			datalen;
-};
 
 /* Socket connection send helper */
-struct iscsi_tcp_send {
+struct iscsi_sw_tcp_send {
 	struct iscsi_hdr	*hdr;
 	struct iscsi_segment	segment;
 	struct iscsi_segment	data_segment;
 };
 
-struct iscsi_tcp_conn {
+struct iscsi_sw_tcp_conn {
 	struct iscsi_conn	*iscsi_conn;
 	struct socket		*sock;
-	int			stop_stage;	/* conn_stop() flag: *
-						 * stop to recover,  *
-						 * stop to terminate */
-	/* control data */
-	struct iscsi_tcp_recv	in;		/* TCP receive context */
-	struct iscsi_tcp_send	out;		/* TCP send context */
 
+	struct iscsi_sw_tcp_send out;
 	/* old values for socket callbacks */
 	void			(*old_data_ready)(struct sock *, int);
 	void			(*old_state_change)(struct sock *);
@@ -93,24 +53,13 @@ struct iscsi_tcp_conn {
 	uint32_t		sendpage_failures_cnt;
 	uint32_t		discontiguous_hdr_cnt;
 
-	int			error;
-
 	ssize_t (*sendpage)(struct socket *, struct page *, int, size_t, int);
 };
 
-struct iscsi_tcp_task {
-	struct iscsi_hdr_buff {
-		struct iscsi_hdr	hdrbuf;
-		char			hdrextbuf[ISCSI_MAX_AHS_SIZE +
+struct iscsi_sw_tcp_hdrbuf {
+	struct iscsi_hdr	hdrbuf;
+	char			hdrextbuf[ISCSI_MAX_AHS_SIZE +
 		                                  ISCSI_DIGEST_SIZE];
-	} hdr;
-
-	int			sent;
-	uint32_t		exp_datasn;	/* expected target's R2TSN/DataSN */
-	int			data_offset;
-	struct iscsi_r2t_info	*r2t;		/* in progress solict R2T */
-	struct iscsi_pool	r2tpool;
-	struct kfifo		*r2tqueue;
 };
 
-#endif /* ISCSI_H */
+#endif /* ISCSI_SW_TCP_H */
-- 
1.5.6.5

