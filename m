From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/10] iscsi: add high mem support
Date: Thu, 12 Jan 2006 23:08:36 -0600
Message-ID: <1137128916.9508.38.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:432 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964878AbWAMFI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 00:08:58 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0D58vs5016451
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2006 23:08:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Mike Christie <michaelc@cs.wisc.edu> and
FUJITA Tomonori <tomof@acm.org>:

We cannot use page_address becuase some pages could be highmem.
Instead, we can use sock_no_sendpage which does kmap for us.


Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 5e8b313..0acc4b2 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -87,35 +87,32 @@ iscsi_buf_init_virt(struct iscsi_buf *ib
 {
 	sg_init_one(&ibuf->sg, (u8 *)vbuf, size);
 	ibuf->sent = 0;
+	ibuf->use_sendmsg = 0;
 }
 
 static inline void
 iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
 {
-	ibuf->sg.page = (void*)vbuf;
-	ibuf->sg.offset = (unsigned int)-1;
+	ibuf->sg.page = virt_to_page(vbuf);
+	ibuf->sg.offset = offset_in_page(vbuf);
 	ibuf->sg.length = size;
 	ibuf->sent = 0;
-}
-
-static inline void*
-iscsi_buf_iov_base(struct iscsi_buf *ibuf)
-{
-	return (char*)ibuf->sg.page + ibuf->sent;
+	ibuf->use_sendmsg = 1;
 }
 
 static inline void
 iscsi_buf_init_sg(struct iscsi_buf *ibuf, struct scatterlist *sg)
 {
+	ibuf->sg.page = sg->page;
+	ibuf->sg.offset = sg->offset;
+	ibuf->sg.length = sg->length;
 	/*
 	 * Fastpath: sg element fits into single page
 	 */
-	if (sg->length + sg->offset <= PAGE_SIZE && page_count(sg->page) >= 2) {
-		ibuf->sg.page = sg->page;
-		ibuf->sg.offset = sg->offset;
-		ibuf->sg.length = sg->length;
-	} else
-		iscsi_buf_init_iov(ibuf, page_address(sg->page), sg->length);
+	if (sg->length + sg->offset <= PAGE_SIZE && page_count(sg->page) >= 2)
+		ibuf->use_sendmsg = 0;
+	else
+		ibuf->use_sendmsg = 1;
 	ibuf->sent = 0;
 }
 
@@ -1311,35 +1308,25 @@ iscsi_conn_restore_callbacks(struct iscs
  * @buf: buffer to write from
  * @size: actual size to write
  * @flags: socket's flags
- *
- * Notes:
- *	depending on buffer will use tcp_sendpage() or tcp_sendmsg().
- *	buf->sg.offset == -1 tells us that buffer is non S/G and forces
- *	to use tcp_sendmsg().
  */
 static inline int
 iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
 {
 	struct socket *sk = conn->sock;
-	int res;
-
-	if ((int)buf->sg.offset >= 0) {
-		int offset = buf->sg.offset + buf->sent;
-
-		res = conn->sendpage(sk, buf->sg.page, offset, size, flags);
-	} else {
-		struct msghdr msg;
-
-		buf->iov.iov_base = iscsi_buf_iov_base(buf);
-		buf->iov.iov_len = size;
-
-		memset(&msg, 0, sizeof(struct msghdr));
-
-		/* tcp_sendmsg */
-		res = kernel_sendmsg(sk, &msg, &buf->iov, 1, size);
-	}
+	int offset = buf->sg.offset + buf->sent;
 
-	return res;
+	/*
+	 * if we got use_sg=0 or are sending something we kmallocd
+	 * then we did not have to do kmap (kmap returns page_address)
+	 *
+	 * if we got use_sg > 0, but had to drop down, we do not
+	 * set clustering so this should only happen for that
+	 * slab case.
+	 */
+	if (buf->use_sendmsg)
+		return sock_no_sendpage(sk, buf->sg.page, offset, size, flags);
+	else
+		return conn->sendpage(sk, buf->sg.page, offset, size, flags);
 }
 
 /**
@@ -1431,19 +1418,6 @@ iscsi_data_digest_init(struct iscsi_conn
 	ctask->digest_count = 4;
 }
 
-static inline void
-iscsi_buf_data_digest_update(struct iscsi_conn *conn, struct iscsi_buf *buf)
-{
-	struct scatterlist sg;
-
-	if (buf->sg.offset != -1)
-		crypto_digest_update(conn->data_tx_tfm, &buf->sg, 1);
-	else {
-		sg_init_one(&sg, (char *)buf->sg.page, buf->sg.length);
-		crypto_digest_update(conn->data_tx_tfm, &sg, 1);
-	}
-}
-
 static inline int
 iscsi_digest_final_send(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 			struct iscsi_buf *buf, uint32_t *digest, int final)
@@ -1806,7 +1780,8 @@ handle_xmstate_imm_data(struct iscsi_con
 			return -EAGAIN;
 		}
 		if (conn->datadgst_en)
-			iscsi_buf_data_digest_update(conn, &ctask->sendbuf);
+			crypto_digest_update(conn->data_tx_tfm,
+					     &ctask->sendbuf.sg, 1);
 
 		if (!ctask->imm_count)
 			break;
@@ -1891,7 +1866,8 @@ handle_xmstate_uns_data(struct iscsi_con
 		 * so pass it
 		 */
 		if (conn->datadgst_en && ctask->sent - start > 0)
-			iscsi_buf_data_digest_update(conn, &ctask->sendbuf);
+			crypto_digest_update(conn->data_tx_tfm,
+					     &ctask->sendbuf.sg, 1);
 
 		if (!ctask->data_count)
 			break;
@@ -1969,7 +1945,7 @@ solicit_again:
 
 	BUG_ON(r2t->data_count < 0);
 	if (conn->datadgst_en)
-		iscsi_buf_data_digest_update(conn, &r2t->sendbuf);
+		crypto_digest_update(conn->data_tx_tfm, &r2t->sendbuf.sg, 1);
 
 	if (r2t->data_count) {
 		BUG_ON(ctask->sc->use_sg == 0);
@@ -2051,7 +2027,7 @@ handle_xmstate_w_pad(struct iscsi_conn *
 	}
 
 	if (conn->datadgst_en) {
-		iscsi_buf_data_digest_update(conn, &ctask->sendbuf);
+		crypto_digest_update(conn->data_tx_tfm, &ctask->sendbuf.sg, 1);
 		/* imm data? */
 		if (!dtask) {
 			if (iscsi_digest_final_send(conn, ctask, &ctask->immbuf,
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index c8bb5b0..f95e61b 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -242,8 +242,8 @@ struct iscsi_session {
 
 struct iscsi_buf {
 	struct scatterlist	sg;
-	struct kvec		iov;
 	unsigned int		sent;
+	char			use_sendmsg;
 };
 
 struct iscsi_data_task {


