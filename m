From: michaelc@cs.wisc.edu
Subject: [PATCH 11/19] iscsi tcp: fix iscsi xmit state machine
Date: Wed, 30 May 2007 12:57:17 -0500
Message-ID: <118054785852-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu> <1180547857548-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbXE3R5q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:46 -0400
In-Reply-To: <1180547857548-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If iscsi_tcp partially sends a header, it would recalculate the
header size and readd the size of the digest (if header digests
are used).This would cause us to send sizeof(digest) extra bytes
when we sent the rest of the header.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |  258 ++++++++++++++++++++++++++--------------------
 drivers/scsi/iscsi_tcp.h |    6 +
 drivers/scsi/libiscsi.c  |    2 
 3 files changed, 150 insertions(+), 116 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1e722f5..0afdca2 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -109,7 +109,7 @@ iscsi_hdr_digest(struct iscsi_conn *conn
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
 	crypto_hash_digest(&tcp_conn->tx_hash, &buf->sg, buf->sg.length, crc);
-	buf->sg.length = tcp_conn->hdr_size;
+	buf->sg.length += sizeof(u32);
 }
 
 static inline int
@@ -423,7 +423,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 
 	tcp_ctask->exp_datasn = r2tsn + 1;
 	__kfifo_put(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*));
-	tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
+	tcp_ctask->xmstate |= XMSTATE_SOL_HDR_INIT;
 	list_move_tail(&ctask->running, &conn->xmitqueue);
 
 	scsi_queue_work(session->host, &conn->xmitwork);
@@ -1284,41 +1284,10 @@ static void iscsi_set_padding(struct isc
 static void
 iscsi_tcp_cmd_init(struct iscsi_cmd_task *ctask)
 {
-	struct scsi_cmnd *sc = ctask->sc;
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
 	BUG_ON(__kfifo_len(tcp_ctask->r2tqueue));
-
-	tcp_ctask->sent = 0;
-	tcp_ctask->sg_count = 0;
-	tcp_ctask->exp_datasn = 0;
-
-	if (sc->sc_data_direction == DMA_TO_DEVICE) {
-		tcp_ctask->xmstate = XMSTATE_W_HDR;
-		BUG_ON(sc->request_bufflen == 0);
-
-		if (sc->use_sg) {
-			struct scatterlist *sg = sc->request_buffer;
-
-			iscsi_buf_init_sg(&tcp_ctask->sendbuf, sg);
-			tcp_ctask->sg = sg + 1;
-			tcp_ctask->bad_sg = sg + sc->use_sg;
-		} else {
-			iscsi_buf_init_iov(&tcp_ctask->sendbuf,
-					   sc->request_buffer,
-					   sc->request_bufflen);
-			tcp_ctask->sg = NULL;
-			tcp_ctask->bad_sg = NULL;
-		}
-		debug_scsi("cmd [itt 0x%x total %d imm_data %d "
-			   "unsol count %d, unsol offset %d]\n",
-			   ctask->itt, sc->request_bufflen, ctask->imm_count,
-			   ctask->unsol_count, ctask->unsol_offset);
-	} else
-		tcp_ctask->xmstate = XMSTATE_R_HDR;
-
-	iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)ctask->hdr,
-			    sizeof(struct iscsi_hdr));
+	tcp_ctask->xmstate = XMSTATE_CMD_HDR_INIT;
 }
 
 /**
@@ -1331,9 +1300,11 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
  *	call it again later, or recover. '0' return code means successful
  *	xmit.
  *
- *	Management xmit state machine consists of two states:
- *		IN_PROGRESS_IMM_HEAD - PDU Header xmit in progress
- *		IN_PROGRESS_IMM_DATA - PDU Data xmit in progress
+ *	Management xmit state machine consists of these states:
+ *		XMSTATE_IMM_HDR_INIT	- calculate digest of PDU Header
+ *		XMSTATE_IMM_HDR 	- PDU Header xmit in progress
+ *		XMSTATE_IMM_DATA 	- PDU Data xmit in progress
+ *		XMSTATE_IDLE		- management PDU is done
  **/
 static int
 iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
@@ -1344,23 +1315,34 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *
 	debug_scsi("mtask deq [cid %d state %x itt 0x%x]\n",
 		conn->id, tcp_mtask->xmstate, mtask->itt);
 
-	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR) {
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR;
-		if (mtask->data_count)
+	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR_INIT) {
+		iscsi_buf_init_iov(&tcp_mtask->headbuf, (char*)mtask->hdr,
+				   sizeof(struct iscsi_hdr));
+
+		if (mtask->data_count) {
 			tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
+			iscsi_buf_init_iov(&tcp_mtask->sendbuf,
+					   (char*)mtask->data,
+					   mtask->data_count);
+		}
+
 		if (conn->c_stage != ISCSI_CONN_INITIAL_STAGE &&
 		    conn->stop_stage != STOP_CONN_RECOVER &&
 		    conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_mtask->headbuf,
 					(u8*)tcp_mtask->hdrext);
+
+		tcp_mtask->sent = 0;
+		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR_INIT;
+		tcp_mtask->xmstate |= XMSTATE_IMM_HDR;
+	}
+
+	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR) {
 		rc = iscsi_sendhdr(conn, &tcp_mtask->headbuf,
 				   mtask->data_count);
-		if (rc) {
-			tcp_mtask->xmstate |= XMSTATE_IMM_HDR;
-			if (mtask->data_count)
-				tcp_mtask->xmstate &= ~XMSTATE_IMM_DATA;
+		if (rc)
 			return rc;
-		}
+		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR;
 	}
 
 	if (tcp_mtask->xmstate & XMSTATE_IMM_DATA) {
@@ -1394,55 +1376,75 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *
 	return 0;
 }
 
-static inline int
-iscsi_send_read_hdr(struct iscsi_conn *conn,
-		    struct iscsi_tcp_cmd_task *tcp_ctask)
+static int
+iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
-	int rc;
+	struct scsi_cmnd *sc = ctask->sc;
+	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	int rc = 0;
 
-	tcp_ctask->xmstate &= ~XMSTATE_R_HDR;
-	if (conn->hdrdgst_en)
-		iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
-				 (u8*)tcp_ctask->hdrext);
-	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, 0);
-	if (!rc) {
-		BUG_ON(tcp_ctask->xmstate != XMSTATE_IDLE);
-		return 0; /* wait for Data-In */
-	}
-	tcp_ctask->xmstate |= XMSTATE_R_HDR;
-	return rc;
-}
+	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_INIT) {
+		tcp_ctask->sent = 0;
+		tcp_ctask->sg_count = 0;
+		tcp_ctask->exp_datasn = 0;
+
+		if (sc->sc_data_direction == DMA_TO_DEVICE) {
+			if (sc->use_sg) {
+				struct scatterlist *sg = sc->request_buffer;
+
+				iscsi_buf_init_sg(&tcp_ctask->sendbuf, sg);
+				tcp_ctask->sg = sg + 1;
+				tcp_ctask->bad_sg = sg + sc->use_sg;
+			} else {
+				iscsi_buf_init_iov(&tcp_ctask->sendbuf,
+						   sc->request_buffer,
+						   sc->request_bufflen);
+				tcp_ctask->sg = NULL;
+				tcp_ctask->bad_sg = NULL;
+			}
 
-static inline int
-iscsi_send_write_hdr(struct iscsi_conn *conn,
-		     struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	int rc;
+			debug_scsi("cmd [itt 0x%x total %d imm_data %d "
+				   "unsol count %d, unsol offset %d]\n",
+				   ctask->itt, sc->request_bufflen,
+				   ctask->imm_count, ctask->unsol_count,
+				   ctask->unsol_offset);
+		}
 
-	tcp_ctask->xmstate &= ~XMSTATE_W_HDR;
-	if (conn->hdrdgst_en)
-		iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
-				 (u8*)tcp_ctask->hdrext);
-	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->imm_count);
-	if (rc) {
-		tcp_ctask->xmstate |= XMSTATE_W_HDR;
-		return rc;
+		iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)ctask->hdr,
+				  sizeof(struct iscsi_hdr));
+
+		if (conn->hdrdgst_en)
+			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
+					 (u8*)tcp_ctask->hdrext);
+		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_INIT;
+		tcp_ctask->xmstate |= XMSTATE_CMD_HDR_XMIT;
 	}
 
-	if (ctask->imm_count) {
-		tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
-		iscsi_set_padding(tcp_ctask, ctask->imm_count);
+	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_XMIT) {
+		rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->imm_count);
+		if (rc)
+			return rc;
+		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_XMIT;
+
+		if (sc->sc_data_direction != DMA_TO_DEVICE)
+			return 0;
+
+		if (ctask->imm_count) {
+			tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
+			iscsi_set_padding(tcp_ctask, ctask->imm_count);
 
-		if (ctask->conn->datadgst_en) {
-			iscsi_data_digest_init(ctask->conn->dd_data, tcp_ctask);
-			tcp_ctask->immdigest = 0;
+			if (ctask->conn->datadgst_en) {
+				iscsi_data_digest_init(ctask->conn->dd_data,
+						       tcp_ctask);
+				tcp_ctask->immdigest = 0;
+			}
 		}
-	}
 
-	if (ctask->unsol_count)
-		tcp_ctask->xmstate |= XMSTATE_UNS_HDR | XMSTATE_UNS_INIT;
-	return 0;
+		if (ctask->unsol_count)
+			tcp_ctask->xmstate |=
+					XMSTATE_UNS_HDR | XMSTATE_UNS_INIT;
+	}
+	return rc;
 }
 
 static int
@@ -1631,9 +1633,7 @@ static int iscsi_send_sol_pdu(struct isc
 	struct iscsi_data_task *dtask;
 	int left, rc;
 
-	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR) {
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
-		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
+	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR_INIT) {
 		if (!tcp_ctask->r2t) {
 			spin_lock_bh(&session->lock);
 			__kfifo_get(tcp_ctask->r2tqueue, (void*)&tcp_ctask->r2t,
@@ -1647,12 +1647,19 @@ send_hdr:
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &r2t->headbuf,
 					(u8*)dtask->hdrext);
+		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR_INIT;
+		tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
+	}
+
+	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR) {
+		r2t = tcp_ctask->r2t;
+		dtask = &r2t->dtask;
+
 		rc = iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count);
-		if (rc) {
-			tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
-			tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
+		if (rc)
 			return rc;
-		}
+		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
+		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
 
 		if (conn->datadgst_en) {
 			iscsi_data_digest_init(conn->dd_data, tcp_ctask);
@@ -1684,8 +1691,6 @@ send_hdr:
 		left = r2t->data_length - r2t->sent;
 		if (left) {
 			iscsi_solicit_data_cont(conn, ctask, r2t, left);
-			tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
-			tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
 			goto send_hdr;
 		}
 
@@ -1700,8 +1705,6 @@ send_hdr:
 		if (__kfifo_get(tcp_ctask->r2tqueue, (void*)&r2t,
 				sizeof(void*))) {
 			tcp_ctask->r2t = r2t;
-			tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
-			tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
 			spin_unlock_bh(&session->lock);
 			goto send_hdr;
 		}
@@ -1710,6 +1713,46 @@ send_hdr:
 	return 0;
 }
 
+/**
+ * iscsi_tcp_ctask_xmit - xmit normal PDU task
+ * @conn: iscsi connection
+ * @ctask: iscsi command task
+ *
+ * Notes:
+ *	The function can return -EAGAIN in which case caller must
+ *	call it again later, or recover. '0' return code means successful
+ *	xmit.
+ *	The function is devided to logical helpers (above) for the different
+ *	xmit stages.
+ *
+ *iscsi_send_cmd_hdr()
+ *	XMSTATE_CMD_HDR_INIT - prepare Header and Data buffers Calculate
+ *	                       Header Digest
+ *	XMSTATE_CMD_HDR_XMIT - Transmit header in progress
+ *
+ *iscsi_send_padding
+ *	XMSTATE_W_PAD        - Prepare and send pading
+ *	XMSTATE_W_RESEND_PAD - retry send pading
+ *
+ *iscsi_send_digest
+ *	XMSTATE_W_RESEND_DATA_DIGEST - Finalize and send Data Digest
+ *	XMSTATE_W_RESEND_DATA_DIGEST - retry sending digest
+ *
+ *iscsi_send_unsol_hdr
+ *	XMSTATE_UNS_INIT     - prepare un-solicit data header and digest
+ *	XMSTATE_UNS_HDR      - send un-solicit header
+ *
+ *iscsi_send_unsol_pdu
+ *	XMSTATE_UNS_DATA     - send un-solicit data in progress
+ *
+ *iscsi_send_sol_pdu
+ *	XMSTATE_SOL_HDR_INIT - solicit data header and digest initialize
+ *	XMSTATE_SOL_HDR      - send solicit header
+ *	XMSTATE_SOL_DATA     - send solicit data
+ *
+ *iscsi_tcp_ctask_xmit
+ *	XMSTATE_IMM_DATA     - xmit managment data (??)
+ **/
 static int
 iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
@@ -1725,14 +1768,11 @@ iscsi_tcp_ctask_xmit(struct iscsi_conn *
 	if (ctask->mtask)
 		return rc;
 
-	if (tcp_ctask->xmstate & XMSTATE_R_HDR)
-		return iscsi_send_read_hdr(conn, tcp_ctask);
-
-	if (tcp_ctask->xmstate & XMSTATE_W_HDR) {
-		rc = iscsi_send_write_hdr(conn, ctask);
-		if (rc)
-			return rc;
-	}
+	rc = iscsi_send_cmd_hdr(conn, ctask);
+	if (rc)
+		return rc;
+	if (ctask->sc->sc_data_direction != DMA_TO_DEVICE)
+		return 0;
 
 	if (tcp_ctask->xmstate & XMSTATE_IMM_DATA) {
 		rc = iscsi_send_data(ctask, &tcp_ctask->sendbuf, &tcp_ctask->sg,
@@ -1913,15 +1953,7 @@ iscsi_tcp_mgmt_init(struct iscsi_conn *c
 		    char *data, uint32_t data_size)
 {
 	struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
-
-	iscsi_buf_init_iov(&tcp_mtask->headbuf, (char*)mtask->hdr,
-			   sizeof(struct iscsi_hdr));
-	tcp_mtask->xmstate = XMSTATE_IMM_HDR;
-	tcp_mtask->sent = 0;
-
-	if (mtask->data_count)
-		iscsi_buf_init_iov(&tcp_mtask->sendbuf, (char*)mtask->data,
-				    mtask->data_count);
+	tcp_mtask->xmstate = XMSTATE_IMM_HDR_INIT;
 }
 
 static int
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index f909edb..b039160 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -32,8 +32,8 @@ #define IN_PROGRESS_DDIGEST_RECV	0x3
 
 /* xmit state machine */
 #define XMSTATE_IDLE			0x0
-#define XMSTATE_R_HDR			0x1
-#define XMSTATE_W_HDR			0x2
+#define XMSTATE_CMD_HDR_INIT		0x1
+#define XMSTATE_CMD_HDR_XMIT		0x2
 #define XMSTATE_IMM_HDR			0x4
 #define XMSTATE_IMM_DATA		0x8
 #define XMSTATE_UNS_INIT		0x10
@@ -44,6 +44,8 @@ #define XMSTATE_SOL_DATA		0x100
 #define XMSTATE_W_PAD			0x200
 #define XMSTATE_W_RESEND_PAD		0x400
 #define XMSTATE_W_RESEND_DATA_DIGEST	0x800
+#define XMSTATE_IMM_HDR_INIT		0x1000
+#define XMSTATE_SOL_HDR_INIT		0x2000
 
 #define ISCSI_PAD_LEN			4
 #define ISCSI_SG_TABLESIZE		SG_ALL
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 63981ed..63f0a15 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -125,6 +125,7 @@ static void iscsi_prep_scsi_cmd_pdu(stru
 			MAX_COMMAND_SIZE - sc->cmd_len);
 
 	ctask->data_count = 0;
+	ctask->imm_count = 0;
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
 		/*
@@ -141,7 +142,6 @@ static void iscsi_prep_scsi_cmd_pdu(stru
 		 *
 		 *      pad_count       bytes to be sent as zero-padding
 		 */
-		ctask->imm_count = 0;
 		ctask->unsol_count = 0;
 		ctask->unsol_offset = 0;
 		ctask->unsol_datasn = 0;
-- 
1.4.1.1

