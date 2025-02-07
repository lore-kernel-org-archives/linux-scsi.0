Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08F42417CA
	for <linux-scsi@vger.kernel.org>; Fri,  7 Feb 2025 04:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738901954; cv=none; b=HAa8tN4W8wyfxNmOI3AtGJ5a7f508ZKei7mEmI0m4iIhhM80WtbAIM3qfaG+GqM46cxMvwAFpjTjn2R1E9bpn/NMY51IaWcoWwRaEU3sB789qBeSkMMxL6uadpqXwEDtU7ZToClt5CoKz6GfocIrG5TYLWMp5OLenRPwR4zLyYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738901954; c=relaxed/simple;
	bh=pNsCyQsFBjPUJcymqWoFwKfnlAd7BuAI8CZ6dH6Oj3A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=b0gEWt71w9J4KbA0Pn40gcBHsFfXialjj8nHSIQ2xsMnZBKAAZ4FPbDcZvC2YdGiVj8JZHo/guOqDAXAG9SIHWLLMvvogp6Szu281z9vCIUZhrl5JCIiUUltRvQbV/Nf71uYV/lIbuQG5Rbt7UZhtR/A54VX7sQ8ANYqKgYhwHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OH/RUhRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OH/RUhRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C22DC4CED1;
	Fri,  7 Feb 2025 04:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738901954;
	bh=pNsCyQsFBjPUJcymqWoFwKfnlAd7BuAI8CZ6dH6Oj3A=;
	h=From:To:Subject:Date:From;
	b=OH/RUhRaxnSrxt6/wB2gkX1OgrUWwthdYa2h1KMU/OqBwwgwy+PU4I4Cug2F8fpJR
	 kfmQITChcVV6EAqf9agHjmEhxJPl2Km2xQr41GEtieNbeLOwT7y2CptKZyCVcNC2I7
	 I9hExwWwZzKLEYsJtQxTxBLktnM5vZvdwa8nTwjIsjUw0OlfvigMoFHAfI42btRV6p
	 e6VSD7cH3trRIlytN9YrHSVQYKTVa7dcUmG8Qasr7rTVSVAFTJTaDTZWe6ktXr5g0b
	 q7G57b4l+evyERv/MUWxqwXAoy3QKRYU6w2eg6jTnKXvYYGEhfJ4zm4XYe5AHMH6Ed
	 X6oIAsmToGnFg==
From: Eric Biggers <ebiggers@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com
Subject: [PATCH] scsi: iscsi_tcp: switch to using the crc32c library
Date: Thu,  6 Feb 2025 20:17:24 -0800
Message-ID: <20250207041724.70733-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Now that the crc32c() library function directly takes advantage of
architecture-specific optimizations, it is unnecessary to go through the
crypto API.  Just use crc32c().  This is much simpler, and it improves
performance due to eliminating the crypto API overhead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/Kconfig        |  2 +-
 drivers/scsi/iscsi_tcp.c    | 60 ++++--------------------
 drivers/scsi/iscsi_tcp.h    |  4 +-
 drivers/scsi/libiscsi_tcp.c | 91 ++++++++++++++++---------------------
 include/scsi/libiscsi_tcp.h | 16 +++----
 5 files changed, 57 insertions(+), 116 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 37c24ffea65cc..25e17dd7bba0c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -301,13 +301,13 @@ menuconfig SCSI_LOWLEVEL
 if SCSI_LOWLEVEL && SCSI
 
 config ISCSI_TCP
 	tristate "iSCSI Initiator over TCP/IP"
 	depends on SCSI && INET
+	select CRC32
 	select CRYPTO
 	select CRYPTO_MD5
-	select CRYPTO_CRC32C
 	select SCSI_ISCSI_ATTRS
 	help
 	 The iSCSI Driver provides a host with the ability to access storage
 	 through an IP network. The driver uses the iSCSI protocol to transport
 	 SCSI requests and responses over a TCP/IP network between the host
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e81f609851931..7b4fe0e6afb2d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -15,11 +15,10 @@
  *	FUJITA Tomonori
  *	Arne Redlich
  *	Zhenyu Wang
  */
 
-#include <crypto/hash.h>
 #include <linux/types.h>
 #include <linux/inet.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
 #include <linux/file.h>
@@ -466,12 +465,11 @@ static void iscsi_sw_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr,
 	 * place the digest into the same buffer. We make
 	 * sure that both iscsi_tcp_task and mtask have
 	 * sufficient room.
 	 */
 	if (conn->hdrdgst_en) {
-		iscsi_tcp_dgst_header(tcp_sw_conn->tx_hash, hdr, hdrlen,
-				      hdr + hdrlen);
+		iscsi_tcp_dgst_header(hdr, hdrlen, hdr + hdrlen);
 		hdrlen += ISCSI_DIGEST_SIZE;
 	}
 
 	/* Remember header pointer for later, when we need
 	 * to decide whether there's a payload to go along
@@ -492,11 +490,11 @@ iscsi_sw_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
 			    unsigned int count, unsigned int offset,
 			    unsigned int len)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
-	struct ahash_request *tx_hash = NULL;
+	u32 *tx_crcp = NULL;
 	unsigned int hdr_spec_len;
 
 	ISCSI_SW_TCP_DBG(conn, "offset=%d, datalen=%d %s\n", offset, len,
 			 conn->datadgst_en ?
 			 "digest enabled" : "digest disabled");
@@ -505,24 +503,23 @@ iscsi_sw_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
 	   said he would send. */
 	hdr_spec_len = ntoh24(tcp_sw_conn->out.hdr->dlength);
 	WARN_ON(iscsi_padded(len) != iscsi_padded(hdr_spec_len));
 
 	if (conn->datadgst_en)
-		tx_hash = tcp_sw_conn->tx_hash;
+		tx_crcp = &tcp_sw_conn->tx_crc;
 
 	return iscsi_segment_seek_sg(&tcp_sw_conn->out.data_segment,
-				     sg, count, offset, len,
-				     NULL, tx_hash);
+				     sg, count, offset, len, NULL, tx_crcp);
 }
 
 static void
 iscsi_sw_tcp_send_linear_data_prep(struct iscsi_conn *conn, void *data,
 				   size_t len)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
-	struct ahash_request *tx_hash = NULL;
+	u32 *tx_crcp = NULL;
 	unsigned int hdr_spec_len;
 
 	ISCSI_SW_TCP_DBG(conn, "datalen=%zd %s\n", len, conn->datadgst_en ?
 			 "digest enabled" : "digest disabled");
 
@@ -530,14 +527,14 @@ iscsi_sw_tcp_send_linear_data_prep(struct iscsi_conn *conn, void *data,
 	   said he would send. */
 	hdr_spec_len = ntoh24(tcp_sw_conn->out.hdr->dlength);
 	WARN_ON(iscsi_padded(len) != iscsi_padded(hdr_spec_len));
 
 	if (conn->datadgst_en)
-		tx_hash = tcp_sw_conn->tx_hash;
+		tx_crcp = &tcp_sw_conn->tx_crc;
 
 	iscsi_segment_init_linear(&tcp_sw_conn->out.data_segment,
-				data, len, NULL, tx_hash);
+				  data, len, NULL, tx_crcp);
 }
 
 static int iscsi_sw_tcp_pdu_init(struct iscsi_task *task,
 				 unsigned int offset, unsigned int count)
 {
@@ -581,11 +578,10 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 {
 	struct iscsi_conn *conn;
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
-	struct crypto_ahash *tfm;
 
 	cls_conn = iscsi_tcp_conn_setup(cls_session, sizeof(*tcp_sw_conn),
 					conn_idx);
 	if (!cls_conn)
 		return NULL;
@@ -594,41 +590,13 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 	tcp_sw_conn = tcp_conn->dd_data;
 	INIT_WORK(&conn->recvwork, iscsi_sw_tcp_recv_data_work);
 	tcp_sw_conn->queue_recv = iscsi_recv_from_iscsi_q;
 
 	mutex_init(&tcp_sw_conn->sock_lock);
-
-	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm))
-		goto free_conn;
-
-	tcp_sw_conn->tx_hash = ahash_request_alloc(tfm, GFP_KERNEL);
-	if (!tcp_sw_conn->tx_hash)
-		goto free_tfm;
-	ahash_request_set_callback(tcp_sw_conn->tx_hash, 0, NULL, NULL);
-
-	tcp_sw_conn->rx_hash = ahash_request_alloc(tfm, GFP_KERNEL);
-	if (!tcp_sw_conn->rx_hash)
-		goto free_tx_hash;
-	ahash_request_set_callback(tcp_sw_conn->rx_hash, 0, NULL, NULL);
-
-	tcp_conn->rx_hash = tcp_sw_conn->rx_hash;
+	tcp_conn->rx_crcp = &tcp_sw_conn->rx_crc;
 
 	return cls_conn;
-
-free_tx_hash:
-	ahash_request_free(tcp_sw_conn->tx_hash);
-free_tfm:
-	crypto_free_ahash(tfm);
-free_conn:
-	iscsi_conn_printk(KERN_ERR, conn,
-			  "Could not create connection due to crc32c "
-			  "loading error. Make sure the crc32c "
-			  "module is built as a module or into the "
-			  "kernel\n");
-	iscsi_tcp_conn_teardown(cls_conn);
-	return NULL;
 }
 
 static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
@@ -662,24 +630,12 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 }
 
 static void iscsi_sw_tcp_conn_destroy(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 
 	iscsi_sw_tcp_release_conn(conn);
-
-	ahash_request_free(tcp_sw_conn->rx_hash);
-	if (tcp_sw_conn->tx_hash) {
-		struct crypto_ahash *tfm;
-
-		tfm = crypto_ahash_reqtfm(tcp_sw_conn->tx_hash);
-		ahash_request_free(tcp_sw_conn->tx_hash);
-		crypto_free_ahash(tfm);
-	}
-
 	iscsi_tcp_conn_teardown(cls_conn);
 }
 
 static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 89a6fc552f0b9..c3e5d9fa6add9 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -39,12 +39,12 @@ struct iscsi_sw_tcp_conn {
 	void			(*old_data_ready)(struct sock *);
 	void			(*old_state_change)(struct sock *);
 	void			(*old_write_space)(struct sock *);
 
 	/* data and header digests */
-	struct ahash_request	*tx_hash;	/* CRC32C (Tx) */
-	struct ahash_request	*rx_hash;	/* CRC32C (Rx) */
+	u32			tx_crc;	/* CRC32C (Tx) */
+	u32			rx_crc;	/* CRC32C (Rx) */
 
 	/* MIB custom statistics */
 	uint32_t		sendpage_failures_cnt;
 	uint32_t		discontiguous_hdr_cnt;
 };
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index c182aa83f2c93..e90805ba868fb 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -13,11 +13,11 @@
  *	FUJITA Tomonori
  *	Arne Redlich
  *	Zhenyu Wang
  */
 
-#include <crypto/hash.h>
+#include <linux/crc32c.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/inet.h>
 #include <linux/slab.h>
 #include <linux/file.h>
@@ -166,11 +166,11 @@ iscsi_tcp_segment_splice_digest(struct iscsi_segment *segment, void *digest)
 	segment->digest_len = ISCSI_DIGEST_SIZE;
 	segment->total_size += ISCSI_DIGEST_SIZE;
 	segment->size = ISCSI_DIGEST_SIZE;
 	segment->copied = 0;
 	segment->sg = NULL;
-	segment->hash = NULL;
+	segment->crcp = NULL;
 }
 
 /**
  * iscsi_tcp_segment_done - check whether the segment is complete
  * @tcp_conn: iscsi tcp connection
@@ -189,33 +189,31 @@ iscsi_tcp_segment_splice_digest(struct iscsi_segment *segment, void *digest)
  */
 int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 			   struct iscsi_segment *segment, int recv,
 			   unsigned copied)
 {
-	struct scatterlist sg;
 	unsigned int pad;
 
 	ISCSI_DBG_TCP(tcp_conn->iscsi_conn, "copied %u %u size %u %s\n",
 		      segment->copied, copied, segment->size,
 		      recv ? "recv" : "xmit");
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
-		ahash_request_set_crypt(segment->hash, &sg, NULL, copied);
-		crypto_ahash_update(segment->hash);
+	if (segment->crcp && copied) {
+		if (segment->data) {
+			*segment->crcp = crc32c(*segment->crcp,
+						segment->data + segment->copied,
+						copied);
+		} else {
+			const void *data;
+
+			data = kmap_local_page(sg_page(segment->sg));
+			*segment->crcp = crc32c(*segment->crcp,
+						data + segment->copied +
+						segment->sg_offset +
+						segment->sg->offset,
+						copied);
+			kunmap_local(data);
+		}
 	}
 
 	segment->copied += copied;
 	if (segment->copied < segment->size) {
 		iscsi_tcp_segment_map(segment, recv);
@@ -256,14 +254,12 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 
 	/*
 	 * Set us up for transferring the data digest. hdr digest
 	 * is completely handled in hdr done function.
 	 */
-	if (segment->hash) {
-		ahash_request_set_crypt(segment->hash, NULL,
-					segment->digest, 0);
-		crypto_ahash_final(segment->hash);
+	if (segment->crcp) {
+		put_unaligned_le32(~*segment->crcp, segment->digest);
 		iscsi_tcp_segment_splice_digest(segment,
 				 recv ? segment->recv_digest : segment->digest);
 		return 0;
 	}
 
@@ -280,12 +276,11 @@ EXPORT_SYMBOL_GPL(iscsi_tcp_segment_done);
  *
  * This function copies up to @len bytes to the
  * given buffer, and returns the number of bytes
  * consumed, which can actually be less than @len.
  *
- * If hash digest is enabled, the function will update the
- * hash while copying.
+ * If CRC is enabled, the function will update the CRC while copying.
  * Combining these two operations doesn't buy us a lot (yet),
  * but in the future we could implement combined copy+crc,
  * just way we do for network layer checksums.
  */
 static int
@@ -309,18 +304,14 @@ iscsi_tcp_segment_recv(struct iscsi_tcp_conn *tcp_conn,
 	}
 	return copied;
 }
 
 inline void
-iscsi_tcp_dgst_header(struct ahash_request *hash, const void *hdr,
-		      size_t hdrlen, unsigned char digest[ISCSI_DIGEST_SIZE])
+iscsi_tcp_dgst_header(const void *hdr, size_t hdrlen,
+		      unsigned char digest[ISCSI_DIGEST_SIZE])
 {
-	struct scatterlist sg;
-
-	sg_init_one(&sg, hdr, hdrlen);
-	ahash_request_set_crypt(hash, &sg, digest, hdrlen);
-	crypto_ahash_digest(hash);
+	put_unaligned_le32(~crc32c(~0, hdr, hdrlen), digest);
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_dgst_header);
 
 static inline int
 iscsi_tcp_dgst_verify(struct iscsi_tcp_conn *tcp_conn,
@@ -341,44 +332,42 @@ iscsi_tcp_dgst_verify(struct iscsi_tcp_conn *tcp_conn,
 /*
  * Helper function to set up segment buffer
  */
 static inline void
 __iscsi_segment_init(struct iscsi_segment *segment, size_t size,
-		     iscsi_segment_done_fn_t *done, struct ahash_request *hash)
+		     iscsi_segment_done_fn_t *done, u32 *crcp)
 {
 	memset(segment, 0, sizeof(*segment));
 	segment->total_size = size;
 	segment->done = done;
 
-	if (hash) {
-		segment->hash = hash;
-		crypto_ahash_init(hash);
+	if (crcp) {
+		segment->crcp = crcp;
+		*crcp = ~0;
 	}
 }
 
 inline void
 iscsi_segment_init_linear(struct iscsi_segment *segment, void *data,
-			  size_t size, iscsi_segment_done_fn_t *done,
-			  struct ahash_request *hash)
+			  size_t size, iscsi_segment_done_fn_t *done, u32 *crcp)
 {
-	__iscsi_segment_init(segment, size, done, hash);
+	__iscsi_segment_init(segment, size, done, crcp);
 	segment->data = data;
 	segment->size = size;
 }
 EXPORT_SYMBOL_GPL(iscsi_segment_init_linear);
 
 inline int
 iscsi_segment_seek_sg(struct iscsi_segment *segment,
 		      struct scatterlist *sg_list, unsigned int sg_count,
 		      unsigned int offset, size_t size,
-		      iscsi_segment_done_fn_t *done,
-		      struct ahash_request *hash)
+		      iscsi_segment_done_fn_t *done, u32 *crcp)
 {
 	struct scatterlist *sg;
 	unsigned int i;
 
-	__iscsi_segment_init(segment, size, done, hash);
+	__iscsi_segment_init(segment, size, done, crcp);
 	for_each_sg(sg_list, sg, sg_count, i) {
 		if (offset < sg->length) {
 			iscsi_tcp_segment_init_sg(segment, sg, offset);
 			return 0;
 		}
@@ -391,11 +380,11 @@ EXPORT_SYMBOL_GPL(iscsi_segment_seek_sg);
 
 /**
  * iscsi_tcp_hdr_recv_prep - prep segment for hdr reception
  * @tcp_conn: iscsi connection to prep for
  *
- * This function always passes NULL for the hash argument, because when this
+ * This function always passes NULL for the crcp argument, because when this
  * function is called we do not yet know the final size of the header and want
  * to delay the digest processing until we know that.
  */
 void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 {
@@ -432,19 +421,19 @@ iscsi_tcp_data_recv_done(struct iscsi_tcp_conn *tcp_conn,
 
 static void
 iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 {
 	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
-	struct ahash_request *rx_hash = NULL;
+	u32 *rx_crcp = NULL;
 
 	if (conn->datadgst_en &&
 	    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
-		rx_hash = tcp_conn->rx_hash;
+		rx_crcp = tcp_conn->rx_crcp;
 
 	iscsi_segment_init_linear(&tcp_conn->in.segment,
 				conn->data, tcp_conn->in.datalen,
-				iscsi_tcp_data_recv_done, rx_hash);
+				iscsi_tcp_data_recv_done, rx_crcp);
 }
 
 /**
  * iscsi_tcp_cleanup_task - free tcp_task resources
  * @task: iscsi task
@@ -728,11 +717,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			break;
 		}
 
 		if (tcp_conn->in.datalen) {
 			struct iscsi_tcp_task *tcp_task = task->dd_data;
-			struct ahash_request *rx_hash = NULL;
+			u32 *rx_crcp = NULL;
 			struct scsi_data_buffer *sdb = &task->sc->sdb;
 
 			/*
 			 * Setup copy of Data-In into the struct scsi_cmnd
 			 * Scatterlist case:
@@ -741,11 +730,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			 * we move on to the next scatterlist entry and
 			 * update the digest per-entry.
 			 */
 			if (conn->datadgst_en &&
 			    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
-				rx_hash = tcp_conn->rx_hash;
+				rx_crcp = tcp_conn->rx_crcp;
 
 			ISCSI_DBG_TCP(conn, "iscsi_tcp_begin_data_in( "
 				     "offset=%d, datalen=%d)\n",
 				      tcp_task->data_offset,
 				      tcp_conn->in.datalen);
@@ -754,11 +743,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 						   sdb->table.sgl,
 						   sdb->table.nents,
 						   tcp_task->data_offset,
 						   tcp_conn->in.datalen,
 						   iscsi_tcp_process_data_in,
-						   rx_hash);
+						   rx_crcp);
 			spin_unlock(&conn->session->back_lock);
 			return rc;
 		}
 		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
 		spin_unlock(&conn->session->back_lock);
@@ -876,11 +865,11 @@ iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 			iscsi_tcp_segment_splice_digest(segment,
 							segment->recv_digest);
 			return 0;
 		}
 
-		iscsi_tcp_dgst_header(tcp_conn->rx_hash, hdr,
+		iscsi_tcp_dgst_header(hdr,
 				      segment->total_copied - ISCSI_DIGEST_SIZE,
 				      segment->digest);
 
 		if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
 			return ISCSI_ERR_HDR_DGST;
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 7c8ba9d7378b6..ef53d4bea28a0 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -13,11 +13,10 @@
 #include <scsi/libiscsi.h>
 
 struct iscsi_tcp_conn;
 struct iscsi_segment;
 struct sk_buff;
-struct ahash_request;
 
 typedef int iscsi_segment_done_fn_t(struct iscsi_tcp_conn *,
 				    struct iscsi_segment *);
 
 struct iscsi_segment {
@@ -25,11 +24,11 @@ struct iscsi_segment {
 	unsigned int		size;
 	unsigned int		copied;
 	unsigned int		total_size;
 	unsigned int		total_copied;
 
-	struct ahash_request	*hash;
+	u32			*crcp;
 	unsigned char		padbuf[ISCSI_PAD_LEN];
 	unsigned char		recv_digest[ISCSI_DIGEST_SIZE];
 	unsigned char		digest[ISCSI_DIGEST_SIZE];
 	unsigned int		digest_len;
 
@@ -59,12 +58,12 @@ struct iscsi_tcp_conn {
 	int			stop_stage;	/* conn_stop() flag: *
 						 * stop to recover,  *
 						 * stop to terminate */
 	/* control data */
 	struct iscsi_tcp_recv	in;		/* TCP receive context */
-	/* CRC32C (Rx) LLD should set this is they do not offload */
-	struct ahash_request	*rx_hash;
+	/* CRC32C (Rx) LLD should set this if they do not offload */
+	u32			*rx_crcp;
 };
 
 struct iscsi_tcp_task {
 	uint32_t		exp_datasn;	/* expected target's R2TSN/DataSN */
 	int			data_offset;
@@ -97,22 +96,19 @@ extern int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 				  unsigned copied);
 extern void iscsi_tcp_segment_unmap(struct iscsi_segment *segment);
 
 extern void iscsi_segment_init_linear(struct iscsi_segment *segment,
 				      void *data, size_t size,
-				      iscsi_segment_done_fn_t *done,
-				      struct ahash_request *hash);
+				      iscsi_segment_done_fn_t *done, u32 *crcp);
 extern int
 iscsi_segment_seek_sg(struct iscsi_segment *segment,
 		      struct scatterlist *sg_list, unsigned int sg_count,
 		      unsigned int offset, size_t size,
-		      iscsi_segment_done_fn_t *done,
-		      struct ahash_request *hash);
+		      iscsi_segment_done_fn_t *done, u32 *crcp);
 
 /* digest helpers */
-extern void iscsi_tcp_dgst_header(struct ahash_request *hash, const void *hdr,
-				  size_t hdrlen,
+extern void iscsi_tcp_dgst_header(const void *hdr, size_t hdrlen,
 				  unsigned char digest[ISCSI_DIGEST_SIZE]);
 extern struct iscsi_cls_conn *
 iscsi_tcp_conn_setup(struct iscsi_cls_session *cls_session, int dd_data_size,
 		     uint32_t conn_idx);
 extern void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn);

base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.48.1

