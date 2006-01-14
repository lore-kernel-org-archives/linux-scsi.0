From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RESEND PATCH 4/8] iscsi: data digest page cache usage fix
Date: Fri, 13 Jan 2006 18:05:44 -0600
Message-ID: <1137197144.2720.34.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:31924 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423149AbWANAGG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 19:06:06 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0E065sl021730
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 18:06:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From FUJITA Tomonori <tomof@acm.org>:

Users can write to a page while we are sending it and making
digest calculations. This ends up causing us to retry the command
when a digest error is later reported. By using sock_no_sendpage
when data digests are calculated we can avoid a lot of (not all but it
helps) the retries becuase sock_no_sendpage is not zero copy.


Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index cd1491e..5e8b313 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1318,15 +1318,15 @@ iscsi_conn_restore_callbacks(struct iscs
  *	to use tcp_sendmsg().
  */
 static inline int
-iscsi_send(struct socket *sk, struct iscsi_buf *buf, int size, int flags)
+iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
 {
+	struct socket *sk = conn->sock;
 	int res;
 
 	if ((int)buf->sg.offset >= 0) {
 		int offset = buf->sg.offset + buf->sent;
 
-		/* tcp_sendpage */
-		res = sk->ops->sendpage(sk, buf->sg.page, offset, size, flags);
+		res = conn->sendpage(sk, buf->sg.page, offset, size, flags);
 	} else {
 		struct msghdr msg;
 
@@ -1354,7 +1354,6 @@ iscsi_send(struct socket *sk, struct isc
 static inline int
 iscsi_sendhdr(struct iscsi_conn *conn, struct iscsi_buf *buf, int datalen)
 {
-	struct socket *sk = conn->sock;
 	int flags = 0; /* MSG_DONTWAIT; */
 	int res, size;
 
@@ -1363,7 +1362,7 @@ iscsi_sendhdr(struct iscsi_conn *conn, s
 	if (buf->sent + size != buf->sg.length || datalen)
 		flags |= MSG_MORE;
 
-	res = iscsi_send(sk, buf, size, flags);
+	res = iscsi_send(conn, buf, size, flags);
 	debug_tcp("sendhdr %d bytes, sent %d res %d\n", size, buf->sent, res);
 	if (res >= 0) {
 		conn->txdata_octets += res;
@@ -1394,7 +1393,6 @@ static inline int
 iscsi_sendpage(struct iscsi_conn *conn, struct iscsi_buf *buf,
 	       int *count, int *sent)
 {
-	struct socket *sk = conn->sock;
 	int flags = 0; /* MSG_DONTWAIT; */
 	int res, size;
 
@@ -1405,7 +1403,7 @@ iscsi_sendpage(struct iscsi_conn *conn, 
 	if (buf->sent + size != buf->sg.length || *count != size)
 		flags |= MSG_MORE;
 
-	res = iscsi_send(sk, buf, size, flags);
+	res = iscsi_send(conn, buf, size, flags);
 	debug_tcp("sendpage: %d bytes, sent %d left %d sent %d res %d\n",
 		  size, buf->sent, *count, *sent, res);
 	if (res >= 0) {
@@ -2713,6 +2711,8 @@ iscsi_conn_bind(iscsi_sessionh_t session
 		 */
 		iscsi_conn_set_callbacks(conn);
 
+		conn->sendpage = conn->sock->ops->sendpage;
+
 		/*
 		 * set receive state machine into initial state
 		 */
@@ -3467,6 +3467,8 @@ iscsi_conn_set_param(iscsi_connh_t connh
 			if (conn->data_rx_tfm)
 				crypto_free_tfm(conn->data_rx_tfm);
 		}
+		conn->sendpage = conn->datadgst_en ?
+			sock_no_sendpage : conn->sock->ops->sendpage;
 		break;
 	case ISCSI_PARAM_INITIAL_R2T_EN:
 		session->initial_r2t_en = value;
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 9badafe..c8bb5b0 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -191,6 +191,8 @@ struct iscsi_conn {
 	uint32_t		sendpage_failures_cnt;
 	uint32_t		discontiguous_hdr_cnt;
 	uint32_t		eh_abort_cnt;
+
+	ssize_t (*sendpage)(struct socket *, struct page *, int, size_t, int);
 };
 
 struct iscsi_session {


