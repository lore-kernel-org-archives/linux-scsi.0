From: michaelc@cs.wisc.edu
Subject: [PATCH 5/12] scsi_tcp: rm data rx and tx tfms
Date: Thu, 31 Aug 2006 18:09:28 -0400
Message-ID: <11570621821931-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu> <11570621791237-git-send-email-michaelc@cs.wisc.edu> <11570621801879-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36486 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932483AbWHaXJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:31 -0400
In-Reply-To: <11570621801879-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We currently allocated seperate tfms for data and header digests. There
is no reason for this since we can never calculate a rx header and
digest at the same time. Same for sends. So this patch removes the data
tfms and has the send and recv sides use the rx_tfm or tx_tfm.

I also made the connection creation code preallocate the tfms because I
thought I hit a bug where I changed the digests settings during a
relogin but could not allocate the tfm and then we just failed.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |  102 ++++++++++++++++------------------------------
 drivers/scsi/iscsi_tcp.h |    8 +---
 2 files changed, 38 insertions(+), 72 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 2ebe8d6..8c9d7b5 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -693,7 +693,7 @@ iscsi_recv_digest_update(struct iscsi_tc
 	struct scatterlist tmp;
 
 	sg_init_one(&tmp, buf, len);
-	crypto_digest_update(tcp_conn->data_rx_tfm, &tmp, 1);
+	crypto_digest_update(tcp_conn->rx_tfm, &tmp, 1);
 }
 
 static int iscsi_scsi_data_in(struct iscsi_conn *conn)
@@ -748,11 +748,11 @@ static int iscsi_scsi_data_in(struct isc
 			if (conn->datadgst_en) {
 				if (!offset)
 					crypto_digest_update(
-							tcp_conn->data_rx_tfm,
+							tcp_conn->rx_tfm,
 							&sg[i], 1);
 				else
 					partial_sg_digest_update(
-							tcp_conn->data_rx_tfm,
+							tcp_conn->rx_tfm,
 							&sg[i],
 							sg[i].offset + offset,
 							sg[i].length - offset);
@@ -766,7 +766,7 @@ static int iscsi_scsi_data_in(struct isc
 				/*
 				 * data-in is complete, but buffer not...
 				 */
-				partial_sg_digest_update(tcp_conn->data_rx_tfm,
+				partial_sg_digest_update(tcp_conn->rx_tfm,
 						&sg[i],
 						sg[i].offset, sg[i].length-rc);
 			rc = 0;
@@ -885,10 +885,8 @@ more:
 		 */
 		rc = iscsi_tcp_hdr_recv(conn);
 		if (!rc && tcp_conn->in.datalen) {
-			if (conn->datadgst_en) {
-				BUG_ON(!tcp_conn->data_rx_tfm);
-				crypto_digest_init(tcp_conn->data_rx_tfm);
-			}
+			if (conn->datadgst_en)
+				crypto_digest_init(tcp_conn->rx_tfm);
 			tcp_conn->in_progress = IN_PROGRESS_DATA_RECV;
 		} else if (rc) {
 			iscsi_conn_failure(conn, rc);
@@ -940,10 +938,10 @@ more:
 					  tcp_conn->in.padding);
 				memset(pad, 0, tcp_conn->in.padding);
 				sg_init_one(&sg, pad, tcp_conn->in.padding);
-				crypto_digest_update(tcp_conn->data_rx_tfm,
+				crypto_digest_update(tcp_conn->rx_tfm,
 						     &sg, 1);
 			}
-			crypto_digest_final(tcp_conn->data_rx_tfm,
+			crypto_digest_final(tcp_conn->rx_tfm,
 					    (u8 *) & tcp_conn->in.datadgst);
 			debug_tcp("rx digest 0x%x\n", tcp_conn->in.datadgst);
 			tcp_conn->in_progress = IN_PROGRESS_DDIGEST_RECV;
@@ -1188,7 +1186,7 @@ static inline void
 iscsi_data_digest_init(struct iscsi_tcp_conn *tcp_conn,
 		      struct iscsi_tcp_cmd_task *tcp_ctask)
 {
-	crypto_digest_init(tcp_conn->data_tx_tfm);
+	crypto_digest_init(tcp_conn->tx_tfm);
 	tcp_ctask->digest_count = 4;
 }
 
@@ -1444,7 +1442,7 @@ iscsi_send_padding(struct iscsi_conn *co
 		iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
 				   tcp_ctask->pad_count);
 		if (conn->datadgst_en)
-			crypto_digest_update(tcp_conn->data_tx_tfm,
+			crypto_digest_update(tcp_conn->tx_tfm,
 					     &tcp_ctask->sendbuf.sg, 1);
 	} else if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_PAD))
 		return 0;
@@ -1477,7 +1475,7 @@ iscsi_send_digest(struct iscsi_conn *con
 	tcp_conn = conn->dd_data;
 
 	if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_DATA_DIGEST)) {
-		crypto_digest_final(tcp_conn->data_tx_tfm, (u8*)digest);
+		crypto_digest_final(tcp_conn->tx_tfm, (u8*)digest);
 		iscsi_buf_init_iov(buf, (char*)digest, 4);
 	}
 	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_DATA_DIGEST;
@@ -1511,7 +1509,7 @@ iscsi_send_data(struct iscsi_cmd_task *c
 		rc = iscsi_sendpage(conn, sendbuf, count, &buf_sent);
 		*sent = *sent + buf_sent;
 		if (buf_sent && conn->datadgst_en)
-			partial_sg_digest_update(tcp_conn->data_tx_tfm,
+			partial_sg_digest_update(tcp_conn->tx_tfm,
 				&sendbuf->sg, sendbuf->sg.offset + offset,
 				buf_sent);
 		if (!iscsi_buf_left(sendbuf) && *sg != tcp_ctask->bad_sg) {
@@ -1547,10 +1545,6 @@ iscsi_send_unsol_hdr(struct iscsi_conn *
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 					(u8*)dtask->hdrext);
-		if (conn->datadgst_en) {
-			iscsi_data_digest_init(ctask->conn->dd_data, tcp_ctask);
-			dtask->digest = 0;
-		}
 
 		tcp_ctask->xmstate &= ~XMSTATE_UNS_INIT;
 		iscsi_set_padding(tcp_ctask, ctask->data_count);
@@ -1563,6 +1557,12 @@ iscsi_send_unsol_hdr(struct iscsi_conn *
 		return rc;
 	}
 
+	if (conn->datadgst_en) {
+		dtask = &tcp_ctask->unsol_dtask;
+		iscsi_data_digest_init(ctask->conn->dd_data, tcp_ctask);
+		dtask->digest = 0;
+	}
+
 	debug_scsi("uns dout [itt 0x%x dlen %d sent %d]\n",
 		   ctask->itt, ctask->unsol_count, tcp_ctask->sent);
 	return 0;
@@ -1629,12 +1629,6 @@ send_hdr:
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &r2t->headbuf,
 					(u8*)dtask->hdrext);
-
-		if (conn->datadgst_en) {
-			iscsi_data_digest_init(conn->dd_data, tcp_ctask);
-			dtask->digest = 0;
-		}
-
 		rc = iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count);
 		if (rc) {
 			tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
@@ -1642,6 +1636,11 @@ send_hdr:
 			return rc;
 		}
 
+		if (conn->datadgst_en) {
+			iscsi_data_digest_init(conn->dd_data, tcp_ctask);
+			dtask->digest = 0;
+		}
+
 		iscsi_set_padding(tcp_ctask, r2t->data_count);
 		debug_scsi("sol dout [dsn %d itt 0x%x dlen %d sent %d]\n",
 			r2t->solicit_datasn - 1, ctask->itt, r2t->data_count,
@@ -1764,8 +1763,20 @@ iscsi_tcp_conn_create(struct iscsi_cls_s
 	/* initial operational parameters */
 	tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
 
+	tcp_conn->tx_tfm = crypto_alloc_tfm("crc32c", 0);
+	if (!tcp_conn->tx_tfm)
+		goto free_tcp_conn;
+
+	tcp_conn->rx_tfm = crypto_alloc_tfm("crc32c", 0);
+	if (!tcp_conn->rx_tfm)
+		goto free_tx_tfm;
+
 	return cls_conn;
 
+free_tx_tfm:
+	crypto_free_tfm(tcp_conn->tx_tfm);
+free_tcp_conn:
+	kfree(tcp_conn);
 tcp_conn_alloc_fail:
 	iscsi_conn_teardown(cls_conn);
 	return NULL;
@@ -1807,10 +1818,6 @@ iscsi_tcp_conn_destroy(struct iscsi_cls_
 			crypto_free_tfm(tcp_conn->tx_tfm);
 		if (tcp_conn->rx_tfm)
 			crypto_free_tfm(tcp_conn->rx_tfm);
-		if (tcp_conn->data_tx_tfm)
-			crypto_free_tfm(tcp_conn->data_tx_tfm);
-		if (tcp_conn->data_rx_tfm)
-			crypto_free_tfm(tcp_conn->data_rx_tfm);
 	}
 
 	kfree(tcp_conn);
@@ -1968,48 +1975,11 @@ iscsi_conn_set_param(struct iscsi_cls_co
 	case ISCSI_PARAM_HDRDGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
 		tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
-		if (conn->hdrdgst_en) {
+		if (conn->hdrdgst_en)
 			tcp_conn->hdr_size += sizeof(__u32);
-			if (!tcp_conn->tx_tfm)
-				tcp_conn->tx_tfm = crypto_alloc_tfm("crc32c",
-								    0);
-			if (!tcp_conn->tx_tfm)
-				return -ENOMEM;
-			if (!tcp_conn->rx_tfm)
-				tcp_conn->rx_tfm = crypto_alloc_tfm("crc32c",
-								    0);
-			if (!tcp_conn->rx_tfm) {
-				crypto_free_tfm(tcp_conn->tx_tfm);
-				return -ENOMEM;
-			}
-		} else {
-			if (tcp_conn->tx_tfm)
-				crypto_free_tfm(tcp_conn->tx_tfm);
-			if (tcp_conn->rx_tfm)
-				crypto_free_tfm(tcp_conn->rx_tfm);
-		}
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
-		if (conn->datadgst_en) {
-			if (!tcp_conn->data_tx_tfm)
-				tcp_conn->data_tx_tfm =
-				    crypto_alloc_tfm("crc32c", 0);
-			if (!tcp_conn->data_tx_tfm)
-				return -ENOMEM;
-			if (!tcp_conn->data_rx_tfm)
-				tcp_conn->data_rx_tfm =
-				    crypto_alloc_tfm("crc32c", 0);
-			if (!tcp_conn->data_rx_tfm) {
-				crypto_free_tfm(tcp_conn->data_tx_tfm);
-				return -ENOMEM;
-			}
-		} else {
-			if (tcp_conn->data_tx_tfm)
-				crypto_free_tfm(tcp_conn->data_tx_tfm);
-			if (tcp_conn->data_rx_tfm)
-				crypto_free_tfm(tcp_conn->data_rx_tfm);
-		}
 		tcp_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_conn->sock->ops->sendpage;
 		break;
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 7e40e94..609f477 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -81,10 +81,6 @@ struct iscsi_tcp_conn {
 						 * stop to terminate */
 	/* iSCSI connection-wide sequencing */
 	int			hdr_size;	/* PDU header size */
-
-	struct crypto_tfm	*rx_tfm;	/* CRC32C (Rx) */
-	struct crypto_tfm	*data_rx_tfm;	/* CRC32C (Rx) for data */
-
 	/* control data */
 	struct iscsi_tcp_recv	in;		/* TCP receive context */
 	int			in_progress;	/* connection state machine */
@@ -94,9 +90,9 @@ struct iscsi_tcp_conn {
 	void			(*old_state_change)(struct sock *);
 	void			(*old_write_space)(struct sock *);
 
-	/* xmit */
+	/* data and header digests */
 	struct crypto_tfm	*tx_tfm;	/* CRC32C (Tx) */
-	struct crypto_tfm	*data_tx_tfm;	/* CRC32C (Tx) for data */
+	struct crypto_tfm	*rx_tfm;	/* CRC32C (Rx) */
 
 	/* MIB custom statistics */
 	uint32_t		sendpage_failures_cnt;
-- 
1.4.1.1

