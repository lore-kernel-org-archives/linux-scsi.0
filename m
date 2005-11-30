From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/8] iscsi: data digest calculation fix
Date: Tue, 29 Nov 2005 23:12:57 -0600
Message-ID: <1133327577.28356.43.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49082 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751029AbVK3FN0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 00:13:26 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU5DOoS009284
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:13:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Wang Zhenyu:

data digest fix (the bug caused data corruption w/Wasabi StorageBuilder target)

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 602de27..287fea4 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -903,11 +903,20 @@ partial_sg_digest_update(struct iscsi_co
 	crypto_digest_update(conn->data_rx_tfm, &temp, 1);
 }
 
+static void
+iscsi_recv_digest_update(struct iscsi_conn *conn, char* buf, int len)
+{
+	struct scatterlist tmp;
+
+	sg_init_one(&tmp, buf, len);
+	crypto_digest_update(conn->data_rx_tfm, &tmp, 1);
+}
+
 static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 {
 	struct iscsi_cmd_task *ctask = conn->in.ctask;
 	struct scsi_cmnd *sc = ctask->sc;
-	struct scatterlist tmp, *sg;
+	struct scatterlist *sg;
 	int i, offset, rc = 0;
 
 	BUG_ON((void*)ctask != sc->SCp.ptr);
@@ -921,10 +930,8 @@ static int iscsi_scsi_data_in(struct isc
 				      sc->request_bufflen, ctask->data_offset);
 		if (rc == -EAGAIN)
 			return rc;
-		if (conn->datadgst_en) {
-			sg_init_one(&tmp, sc->request_buffer, i);
-			crypto_digest_update(conn->data_rx_tfm, &tmp, 1);
-		}
+		if (conn->datadgst_en) 
+			iscsi_recv_digest_update(conn, sc->request_buffer, i);
 		rc = 0;
 		goto done;
 	}
@@ -1018,6 +1025,9 @@ iscsi_data_recv(struct iscsi_conn *conn)
 		conn->in.hdr = &conn->hdr;
 		conn->senselen = (conn->data[0] << 8) | conn->data[1];
 		rc = iscsi_cmd_rsp(conn, conn->in.ctask);
+		if (!rc && conn->datadgst_en) 
+			iscsi_recv_digest_update(conn, conn->data,
+						 conn->in.datalen);
 	}
 	break;
 	case ISCSI_OP_TEXT_RSP:
@@ -1042,6 +1052,11 @@ iscsi_data_recv(struct iscsi_conn *conn)
 		rc = iscsi_recv_pdu(iscsi_handle(conn), conn->in.hdr,
 				    conn->data, conn->in.datalen);
 
+		if (!rc && conn->datadgst_en && 
+			conn->in.opcode != ISCSI_OP_LOGIN_RSP)
+			iscsi_recv_digest_update(conn, conn->data,
+			  			conn->in.datalen);
+
 		if (mtask && conn->login_mtask != mtask) {
 			spin_lock(&session->lock);
 			__kfifo_put(session->mgmtpool.queue, (void*)&mtask,
@@ -1050,6 +1065,8 @@ iscsi_data_recv(struct iscsi_conn *conn)
 		}
 	}
 	break;
+	case ISCSI_OP_ASYNC_EVENT:
+	case ISCSI_OP_REJECT:
 	default:
 		BUG_ON(1);
 	}
@@ -1112,7 +1129,7 @@ more:
 		rc = iscsi_hdr_recv(conn);
 		if (!rc && conn->in.datalen) {
 			if (conn->datadgst_en &&
-			    conn->in.opcode == ISCSI_OP_SCSI_DATA_IN) {
+				conn->in.opcode != ISCSI_OP_LOGIN_RSP) {
 				BUG_ON(!conn->data_rx_tfm);
 				crypto_digest_init(conn->data_rx_tfm);
 			}
@@ -1124,26 +1141,24 @@ more:
 	}
 
 	if (conn->in_progress == IN_PROGRESS_DDIGEST_RECV) {
+		uint32_t recv_digest;
 		debug_tcp("extra data_recv offset %d copy %d\n",
 			  conn->in.offset, conn->in.copy);
-		if (conn->in.opcode == ISCSI_OP_SCSI_DATA_IN) {
-			uint32_t recv_digest;
-			skb_copy_bits(conn->in.skb, conn->in.offset,
-				      &recv_digest, 4);
-			conn->in.offset += 4;
-			conn->in.copy -= 4;
-			if (recv_digest != conn->in.datadgst) {
-				debug_tcp("iscsi_tcp: data digest error!"
-					  "0x%x != 0x%x\n", recv_digest,
-					  conn->in.datadgst);
-				iscsi_conn_failure(conn, ISCSI_ERR_DATA_DGST);
-				return 0;
-			} else {
-				debug_tcp("iscsi_tcp: data digest match!"
-					  "0x%x == 0x%x\n", recv_digest,
-					  conn->in.datadgst);
-				conn->in_progress = IN_PROGRESS_WAIT_HEADER;
-			}
+		skb_copy_bits(conn->in.skb, conn->in.offset,
+				&recv_digest, 4);
+		conn->in.offset += 4;
+		conn->in.copy -= 4;
+		if (recv_digest != conn->in.datadgst) {
+			debug_tcp("iscsi_tcp: data digest error!"
+				  "0x%x != 0x%x\n", recv_digest,
+				  conn->in.datadgst);
+			iscsi_conn_failure(conn, ISCSI_ERR_DATA_DGST);
+			return 0;
+		} else {
+			debug_tcp("iscsi_tcp: data digest match!"
+				  "0x%x == 0x%x\n", recv_digest,
+				  conn->in.datadgst);
+			conn->in_progress = IN_PROGRESS_WAIT_HEADER;
 		}
 	}
 
@@ -1165,7 +1180,7 @@ more:
 		conn->in.copy -= conn->in.padding;
 		conn->in.offset += conn->in.padding;
 		if (conn->datadgst_en &&
-		    conn->in.opcode == ISCSI_OP_SCSI_DATA_IN) {
+			conn->in.opcode != ISCSI_OP_LOGIN_RSP) {
 			if (conn->in.padding) {
 				debug_tcp("padding -> %d\n", conn->in.padding);
 				memset(pad, 0, conn->in.padding);


