From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/5] iscsi update: fix writepsace race
Date: Tue, 30 May 2006 00:37:28 -0500
Message-ID: <1148967448.3005.16.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:25271 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932142AbWE3F6u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 01:58:50 -0400
Received: from [192.168.0.7] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4U5wTvl027091
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 May 2006 00:58:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We can race and misset the suspend bit if iscsi_write_space is
called then iscsi_send returns with a failure indicating
there is no space.

To handle this this patch returns a error upwards allowing xmitworker
to decide if we need to try and transmit again. For the no
write space case xmitworker will not retry, and instead
let iscsi_write_space queue it back up if needed (this relies
on the work queue code to properly requeue us if needed).

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 2abda80..7fa8593 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1006,7 +1006,6 @@ iscsi_write_space(struct sock *sk)
 
 	tcp_conn->old_write_space(sk);
 	debug_tcp("iscsi_write_space: cid %d\n", conn->id);
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
 
@@ -1056,7 +1055,7 @@ iscsi_send(struct iscsi_conn *conn, stru
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct socket *sk = tcp_conn->sock;
-	int offset = buf->sg.offset + buf->sent;
+	int offset = buf->sg.offset + buf->sent, res;
 
 	/*
 	 * if we got use_sg=0 or are sending something we kmallocd
@@ -1067,10 +1066,22 @@ iscsi_send(struct iscsi_conn *conn, stru
 	 * slab case.
 	 */
 	if (buf->use_sendmsg)
-		return sock_no_sendpage(sk, buf->sg.page, offset, size, flags);
+		res = sock_no_sendpage(sk, buf->sg.page, offset, size, flags);
 	else
-		return tcp_conn->sendpage(sk, buf->sg.page, offset, size,
-					  flags);
+		res = tcp_conn->sendpage(sk, buf->sg.page, offset, size, flags);
+
+	if (res >= 0) {
+		conn->txdata_octets += res;
+		buf->sent += res;
+		return res;
+	}
+
+	tcp_conn->sendpage_failures_cnt++;
+	if (res == -EAGAIN)
+		res = -ENOBUFS;
+	else
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	return res;
 }
 
 /**
@@ -1085,7 +1096,6 @@ iscsi_send(struct iscsi_conn *conn, stru
 static inline int
 iscsi_sendhdr(struct iscsi_conn *conn, struct iscsi_buf *buf, int datalen)
 {
-	struct iscsi_tcp_conn *tcp_conn;
 	int flags = 0; /* MSG_DONTWAIT; */
 	int res, size;
 
@@ -1097,17 +1107,10 @@ iscsi_sendhdr(struct iscsi_conn *conn, s
 	res = iscsi_send(conn, buf, size, flags);
 	debug_tcp("sendhdr %d bytes, sent %d res %d\n", size, buf->sent, res);
 	if (res >= 0) {
-		conn->txdata_octets += res;
-		buf->sent += res;
 		if (size != res)
 			return -EAGAIN;
 		return 0;
-	} else if (res == -EAGAIN) {
-		tcp_conn = conn->dd_data;
-		tcp_conn->sendpage_failures_cnt++;
-		set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	} else if (res == -EPIPE)
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	}
 
 	return res;
 }
@@ -1126,7 +1129,6 @@ static inline int
 iscsi_sendpage(struct iscsi_conn *conn, struct iscsi_buf *buf,
 	       int *count, int *sent)
 {
-	struct iscsi_tcp_conn *tcp_conn;
 	int flags = 0; /* MSG_DONTWAIT; */
 	int res, size;
 
@@ -1141,19 +1143,12 @@ iscsi_sendpage(struct iscsi_conn *conn, 
 	debug_tcp("sendpage: %d bytes, sent %d left %d sent %d res %d\n",
 		  size, buf->sent, *count, *sent, res);
 	if (res >= 0) {
-		conn->txdata_octets += res;
-		buf->sent += res;
 		*count -= res;
 		*sent += res;
 		if (size != res)
 			return -EAGAIN;
 		return 0;
-	} else if (res == -EAGAIN) {
-		tcp_conn = conn->dd_data;
-		tcp_conn->sendpage_failures_cnt++;
-		set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	} else if (res == -EPIPE)
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	}
 
 	return res;
 }
@@ -1342,6 +1337,7 @@ static int
 iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 {
 	struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
+	int rc;
 
 	debug_scsi("mtask deq [cid %d state %x itt 0x%x]\n",
 		conn->id, tcp_mtask->xmstate, mtask->itt);
@@ -1355,12 +1351,13 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *
 		    conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_mtask->headbuf,
 					(u8*)tcp_mtask->hdrext);
-		if (iscsi_sendhdr(conn, &tcp_mtask->headbuf,
-				  mtask->data_count)) {
+		rc = iscsi_sendhdr(conn, &tcp_mtask->headbuf,
+				   mtask->data_count);
+		if (rc) {
 			tcp_mtask->xmstate |= XMSTATE_IMM_HDR;
 			if (mtask->data_count)
 				tcp_mtask->xmstate &= ~XMSTATE_IMM_DATA;
-			return -EAGAIN;
+			return rc;
 		}
 	}
 
@@ -1371,10 +1368,13 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *
 		 * Virtual buffer could be spreaded across multiple pages...
 		 */
 		do {
-			if (iscsi_sendpage(conn, &tcp_mtask->sendbuf,
-				   &mtask->data_count, &tcp_mtask->sent)) {
+			int rc;
+
+			rc = iscsi_sendpage(conn, &tcp_mtask->sendbuf,
+					&mtask->data_count, &tcp_mtask->sent);
+			if (rc) {
 				tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
-				return -EAGAIN;
+				return rc;
 			}
 		} while (mtask->data_count);
 	}
@@ -1396,16 +1396,19 @@ static inline int
 handle_xmstate_r_hdr(struct iscsi_conn *conn,
 		     struct iscsi_tcp_cmd_task *tcp_ctask)
 {
+	int rc;
+
 	tcp_ctask->xmstate &= ~XMSTATE_R_HDR;
 	if (conn->hdrdgst_en)
 		iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 				 (u8*)tcp_ctask->hdrext);
-	if (!iscsi_sendhdr(conn, &tcp_ctask->headbuf, 0)) {
+	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, 0);
+	if (!rc) {
 		BUG_ON(tcp_ctask->xmstate != XMSTATE_IDLE);
 		return 0; /* wait for Data-In */
 	}
 	tcp_ctask->xmstate |= XMSTATE_R_HDR;
-	return -EAGAIN;
+	return rc;
 }
 
 static inline int
@@ -1413,16 +1416,16 @@ handle_xmstate_w_hdr(struct iscsi_conn *
 		     struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	int rc;
 
 	tcp_ctask->xmstate &= ~XMSTATE_W_HDR;
 	if (conn->hdrdgst_en)
 		iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 				 (u8*)tcp_ctask->hdrext);
-	if (iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->imm_count)) {
+	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->imm_count);
+	if (rc)
 		tcp_ctask->xmstate |= XMSTATE_W_HDR;
-		return -EAGAIN;
-	}
-	return 0;
+	return rc;
 }
 
 static inline int
@@ -1430,17 +1433,19 @@ handle_xmstate_data_digest(struct iscsi_
 			   struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	int rc;
 
 	tcp_ctask->xmstate &= ~XMSTATE_DATA_DIGEST;
 	debug_tcp("resent data digest 0x%x\n", tcp_ctask->datadigest);
-	if (iscsi_digest_final_send(conn, ctask, &tcp_ctask->immbuf,
-				    &tcp_ctask->datadigest, 0)) {
+	rc = iscsi_digest_final_send(conn, ctask, &tcp_ctask->immbuf,
+				    &tcp_ctask->datadigest, 0);
+	if (rc) {
 		tcp_ctask->xmstate |= XMSTATE_DATA_DIGEST;
 		debug_tcp("resent data digest 0x%x fail!\n",
 			  tcp_ctask->datadigest);
-		return -EAGAIN;
 	}
-	return 0;
+
+	return rc;
 }
 
 static inline int
@@ -1448,6 +1453,7 @@ handle_xmstate_imm_data(struct iscsi_con
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	int rc;
 
 	BUG_ON(!ctask->imm_count);
 	tcp_ctask->xmstate &= ~XMSTATE_IMM_DATA;
@@ -1458,8 +1464,9 @@ handle_xmstate_imm_data(struct iscsi_con
 	}
 
 	for (;;) {
-		if (iscsi_sendpage(conn, &tcp_ctask->sendbuf, &ctask->imm_count,
-				   &tcp_ctask->sent)) {
+		rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf,
+				   &ctask->imm_count, &tcp_ctask->sent);
+		if (rc) {
 			tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
 			if (conn->datadgst_en) {
 				crypto_digest_final(tcp_conn->data_tx_tfm,
@@ -1467,7 +1474,7 @@ handle_xmstate_imm_data(struct iscsi_con
 				debug_tcp("tx imm sendpage fail 0x%x\n",
 					  tcp_ctask->datadigest);
 			}
-			return -EAGAIN;
+			return rc;
 		}
 		if (conn->datadgst_en)
 			crypto_digest_update(tcp_conn->data_tx_tfm,
@@ -1480,11 +1487,12 @@ handle_xmstate_imm_data(struct iscsi_con
 	}
 
 	if (conn->datadgst_en && !(tcp_ctask->xmstate & XMSTATE_W_PAD)) {
-		if (iscsi_digest_final_send(conn, ctask, &tcp_ctask->immbuf,
-				            &tcp_ctask->immdigest, 1)) {
+		rc = iscsi_digest_final_send(conn, ctask, &tcp_ctask->immbuf,
+				            &tcp_ctask->immdigest, 1);
+		if (rc) {
 			debug_tcp("sending imm digest 0x%x fail!\n",
 				  tcp_ctask->immdigest);
-			return -EAGAIN;
+			return rc;
 		}
 		debug_tcp("sending imm digest 0x%x\n", tcp_ctask->immdigest);
 	}
@@ -1497,6 +1505,7 @@ handle_xmstate_uns_hdr(struct iscsi_conn
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_data_task *dtask;
+	int rc;
 
 	tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
 	if (tcp_ctask->xmstate & XMSTATE_UNS_INIT) {
@@ -1507,10 +1516,12 @@ handle_xmstate_uns_hdr(struct iscsi_conn
 					(u8*)dtask->hdrext);
 		tcp_ctask->xmstate &= ~XMSTATE_UNS_INIT;
 	}
-	if (iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->data_count)) {
+
+	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->data_count);
+	if (rc) {
 		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
 		tcp_ctask->xmstate |= XMSTATE_UNS_HDR;
-		return -EAGAIN;
+		return rc;
 	}
 
 	debug_scsi("uns dout [itt 0x%x dlen %d sent %d]\n",
@@ -1524,6 +1535,7 @@ handle_xmstate_uns_data(struct iscsi_con
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_data_task *dtask = tcp_ctask->dtask;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	int rc;
 
 	BUG_ON(!ctask->data_count);
 	tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
@@ -1536,8 +1548,9 @@ handle_xmstate_uns_data(struct iscsi_con
 	for (;;) {
 		int start = tcp_ctask->sent;
 
-		if (iscsi_sendpage(conn, &tcp_ctask->sendbuf,
-				   &ctask->data_count, &tcp_ctask->sent)) {
+		rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf,
+				   &ctask->data_count, &tcp_ctask->sent);
+		if (rc) {
 			ctask->unsol_count -= tcp_ctask->sent - start;
 			tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
 			/* will continue with this ctask later.. */
@@ -1547,7 +1560,7 @@ handle_xmstate_uns_data(struct iscsi_con
 				debug_tcp("tx uns data fail 0x%x\n",
 					  dtask->digest);
 			}
-			return -EAGAIN;
+			return rc;
 		}
 
 		BUG_ON(tcp_ctask->sent > ctask->total_length);
@@ -1574,12 +1587,13 @@ handle_xmstate_uns_data(struct iscsi_con
 	 */
 	if (ctask->unsol_count) {
 		if (conn->datadgst_en) {
-			if (iscsi_digest_final_send(conn, ctask,
+			rc = iscsi_digest_final_send(conn, ctask,
 						    &dtask->digestbuf,
-						    &dtask->digest, 1)) {
+						    &dtask->digest, 1);
+			if (rc) {
 				debug_tcp("send uns digest 0x%x fail\n",
 					  dtask->digest);
-				return -EAGAIN;
+				return rc;
 			}
 			debug_tcp("sending uns digest 0x%x, more uns\n",
 				  dtask->digest);
@@ -1589,12 +1603,13 @@ handle_xmstate_uns_data(struct iscsi_con
 	}
 
 	if (conn->datadgst_en && !(tcp_ctask->xmstate & XMSTATE_W_PAD)) {
-		if (iscsi_digest_final_send(conn, ctask,
+		rc = iscsi_digest_final_send(conn, ctask,
 					    &dtask->digestbuf,
-					    &dtask->digest, 1)) {
+					    &dtask->digest, 1);
+		if (rc) {
 			debug_tcp("send last uns digest 0x%x fail\n",
 				   dtask->digest);
-			return -EAGAIN;
+			return rc;
 		}
 		debug_tcp("sending uns digest 0x%x\n",dtask->digest);
 	}
@@ -1610,7 +1625,7 @@ handle_xmstate_sol_data(struct iscsi_con
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_r2t_info *r2t = tcp_ctask->r2t;
 	struct iscsi_data_task *dtask = &r2t->dtask;
-	int left;
+	int left, rc;
 
 	tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
 	tcp_ctask->dtask = dtask;
@@ -1626,7 +1641,8 @@ solicit_again:
 	if (!r2t->data_count)
 		goto data_out_done;
 
-	if (iscsi_sendpage(conn, &r2t->sendbuf, &r2t->data_count, &r2t->sent)) {
+	rc = iscsi_sendpage(conn, &r2t->sendbuf, &r2t->data_count, &r2t->sent);
+	if (rc) {
 		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
 		/* will continue with this ctask later.. */
 		if (conn->datadgst_en) {
@@ -1634,7 +1650,7 @@ solicit_again:
 					  (u8 *)&dtask->digest);
 			debug_tcp("r2t data send fail 0x%x\n", dtask->digest);
 		}
-		return -EAGAIN;
+		return rc;
 	}
 
 	BUG_ON(r2t->data_count < 0);
@@ -1661,12 +1677,13 @@ data_out_done:
 	left = r2t->data_length - r2t->sent;
 	if (left) {
 		if (conn->datadgst_en) {
-			if (iscsi_digest_final_send(conn, ctask,
+			rc = iscsi_digest_final_send(conn, ctask,
 						    &dtask->digestbuf,
-						    &dtask->digest, 1)) {
+						    &dtask->digest, 1);
+			if (rc) {
 				debug_tcp("send r2t data digest 0x%x"
 					  "fail\n", dtask->digest);
-				return -EAGAIN;
+				return rc;
 			}
 			debug_tcp("r2t data send digest 0x%x\n",
 				  dtask->digest);
@@ -1683,11 +1700,12 @@ data_out_done:
 	 */
 	BUG_ON(tcp_ctask->r2t_data_count - r2t->data_length < 0);
 	if (conn->datadgst_en) {
-		if (iscsi_digest_final_send(conn, ctask, &dtask->digestbuf,
-					    &dtask->digest, 1)) {
+		rc = iscsi_digest_final_send(conn, ctask, &dtask->digestbuf,
+					    &dtask->digest, 1);
+		if (rc) {
 			debug_tcp("send last r2t data digest 0x%x"
 				  "fail\n", dtask->digest);
-			return -EAGAIN;
+			return rc;
 		}
 		debug_tcp("r2t done dout digest 0x%x\n", dtask->digest);
 	}
@@ -1713,15 +1731,16 @@ handle_xmstate_w_pad(struct iscsi_conn *
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_data_task *dtask = tcp_ctask->dtask;
-	int sent;
+	int sent, rc;
 
 	tcp_ctask->xmstate &= ~XMSTATE_W_PAD;
 	iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
 			    tcp_ctask->pad_count);
-	if (iscsi_sendpage(conn, &tcp_ctask->sendbuf, &tcp_ctask->pad_count,
-			   &sent)) {
+	rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf, &tcp_ctask->pad_count,
+			   &sent);
+	if (rc) {
 		tcp_ctask->xmstate |= XMSTATE_W_PAD;
-		return -EAGAIN;
+		return rc;
 	}
 
 	if (conn->datadgst_en) {
@@ -1729,22 +1748,24 @@ handle_xmstate_w_pad(struct iscsi_conn *
 				     &tcp_ctask->sendbuf.sg, 1);
 		/* imm data? */
 		if (!dtask) {
-			if (iscsi_digest_final_send(conn, ctask,
+			rc = iscsi_digest_final_send(conn, ctask,
 						    &tcp_ctask->immbuf,
-						    &tcp_ctask->immdigest, 1)) {
+						    &tcp_ctask->immdigest, 1);
+			if (rc) {
 				debug_tcp("send padding digest 0x%x"
 					  "fail!\n", tcp_ctask->immdigest);
-				return -EAGAIN;
+				return rc;
 			}
 			debug_tcp("done with padding, digest 0x%x\n",
 				  tcp_ctask->datadigest);
 		} else {
-			if (iscsi_digest_final_send(conn, ctask,
+			rc = iscsi_digest_final_send(conn, ctask,
 						    &dtask->digestbuf,
-						    &dtask->digest, 1)) {
+						    &dtask->digest, 1);
+			if (rc) {
 				debug_tcp("send padding digest 0x%x"
 				          "fail\n", dtask->digest);
-				return -EAGAIN;
+				return rc;
 			}
 			debug_tcp("done with padding, digest 0x%x\n",
 				  dtask->digest);
@@ -1769,10 +1790,8 @@ iscsi_tcp_ctask_xmit(struct iscsi_conn *
 	if (ctask->mtask)
 		return rc;
 
-	if (tcp_ctask->xmstate & XMSTATE_R_HDR) {
-		rc = handle_xmstate_r_hdr(conn, tcp_ctask);
-		return rc;
-	}
+	if (tcp_ctask->xmstate & XMSTATE_R_HDR)
+		return handle_xmstate_r_hdr(conn, tcp_ctask);
 
 	if (tcp_ctask->xmstate & XMSTATE_W_HDR) {
 		rc = handle_xmstate_w_hdr(conn, ctask);
@@ -1824,10 +1843,11 @@ solicit_head_again:
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &r2t->headbuf,
 					(u8*)r2t->dtask.hdrext);
-		if (iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count)) {
+		rc = iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count);
+		if (rc) {
 			tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
 			tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
-			return -EAGAIN;
+			return rc;
 		}
 
 		debug_scsi("sol dout [dsn %d itt 0x%x dlen %d sent %d]\n",
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 256b87a..2673a11 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -513,10 +513,11 @@ EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 static int iscsi_data_xmit(struct iscsi_conn *conn)
 {
 	struct iscsi_transport *tt;
+	int rc = 0;
 
 	if (unlikely(conn->suspend_tx)) {
 		debug_scsi("conn %d Tx suspended!\n", conn->id);
-		return 0;
+		return -ENODATA;
 	}
 	tt = conn->session->tt;
 
@@ -536,13 +537,15 @@ static int iscsi_data_xmit(struct iscsi_
 	BUG_ON(conn->ctask && conn->mtask);
 
 	if (conn->ctask) {
-		if (tt->xmit_cmd_task(conn, conn->ctask))
+		rc = tt->xmit_cmd_task(conn, conn->ctask);
+		if (rc)
 			goto again;
 		/* done with this in-progress ctask */
 		conn->ctask = NULL;
 	}
 	if (conn->mtask) {
-	        if (tt->xmit_mgmt_task(conn, conn->mtask))
+		rc = tt->xmit_mgmt_task(conn, conn->mtask);
+	        if (rc)
 		        goto again;
 		/* done with this in-progress mtask */
 		conn->mtask = NULL;
@@ -556,7 +559,8 @@ static int iscsi_data_xmit(struct iscsi_
 			list_add_tail(&conn->mtask->running,
 				      &conn->mgmt_run_list);
 			spin_unlock_bh(&conn->session->lock);
-		        if (tt->xmit_mgmt_task(conn, conn->mtask))
+			rc = tt->xmit_mgmt_task(conn, conn->mtask);
+		        if (rc)
 			        goto again;
 	        }
 		/* done with this mtask */
@@ -574,7 +578,8 @@ static int iscsi_data_xmit(struct iscsi_
 		if (list_empty(&conn->ctask->running))
 			list_add_tail(&conn->ctask->running, &conn->run_list);
 		spin_unlock_bh(&conn->session->lock);
-		if (tt->xmit_cmd_task(conn, conn->ctask))
+		rc = tt->xmit_cmd_task(conn, conn->ctask);
+		if (rc)
 			goto again;
 	}
 	/* done with this ctask */
@@ -588,32 +593,34 @@ static int iscsi_data_xmit(struct iscsi_
 			list_add_tail(&conn->mtask->running,
 				      &conn->mgmt_run_list);
 			spin_unlock_bh(&conn->session->lock);
-		        if (tt->xmit_mgmt_task(conn, conn->mtask))
+		        rc = tt->xmit_mgmt_task(conn, conn->mtask);
+			if (rc)
 			        goto again;
 	        }
 		/* done with this mtask */
 		conn->mtask = NULL;
 	}
 
-	return 0;
+	return -ENODATA;
 
 again:
 	if (unlikely(conn->suspend_tx))
-		return 0;
+		return -ENODATA;
 
-	return -EAGAIN;
+	return rc;
 }
 
 static void iscsi_xmitworker(void *data)
 {
 	struct iscsi_conn *conn = data;
-
+	int rc;
 	/*
 	 * serialize Xmit worker on a per-connection basis.
 	 */
 	mutex_lock(&conn->xmitmutex);
-	if (iscsi_data_xmit(conn))
-		scsi_queue_work(conn->session->host, &conn->xmitwork);
+	do {
+		rc = iscsi_data_xmit(conn);
+	} while (rc >= 0 || rc == -EAGAIN);
 	mutex_unlock(&conn->xmitmutex);
 }
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 92129b9..b684426 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -57,8 +57,12 @@ struct iscsi_mgmt_task;
  *			Called from queuecommand with session lock held.
  * @init_mgmt_task:	Initialize a iscsi_mgmt_task and any internal structs.
  *			Called from iscsi_conn_send_generic with xmitmutex.
- * @xmit_cmd_task:	requests LLD to transfer cmd task
- * @xmit_mgmt_task:	requests LLD to transfer mgmt task
+ * @xmit_cmd_task:	Requests LLD to transfer cmd task. Returns 0 or the
+ *			the number of bytes transferred on success, and -Exyz
+ *			value on error.
+ * @xmit_mgmt_task:	Requests LLD to transfer mgmt task. Returns 0 or the
+ *			the number of bytes transferred on success, and -Exyz
+ *			value on error.
  * @cleanup_cmd_task:	requests LLD to fail cmd task. Called with xmitmutex
  *			and session->lock after the connection has been
  *			suspended and terminated during recovery. If called


