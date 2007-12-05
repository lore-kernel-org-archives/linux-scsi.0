From: michaelc@cs.wisc.edu
Subject: [PATCH 01/23] libiscsi, iscsi_tcp: add device support
Date: Tue,  4 Dec 2007 18:42:15 -0600
Message-ID: <119681536472-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXLEAmv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:42:51 -0500
In-Reply-To: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds logical unit reset support. This should work for ib_iser,
but I have not finished testing that driver so it is not hooked in yet.

This patch also temporarily reverts the iscsi_tcp r2t write out patch.
That code is completely rewritten in this patchset.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    6 -
 drivers/scsi/iscsi_tcp.c                 |  151 +++++-----
 drivers/scsi/iscsi_tcp.h                 |   34 +-
 drivers/scsi/libiscsi.c                  |  494 +++++++++++++++++-------------
 drivers/scsi/scsi_transport_iscsi.c      |    4 +-
 include/scsi/iscsi_if.h                  |    2 +
 include/scsi/iscsi_proto.h               |    2 +
 include/scsi/libiscsi.h                  |   25 +-
 8 files changed, 396 insertions(+), 322 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index bad8dac..2eadb6d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -220,12 +220,6 @@ iscsi_iser_ctask_xmit(struct iscsi_conn *conn,
 	debug_scsi("ctask deq [cid %d itt 0x%x]\n",
 		   conn->id, ctask->itt);
 
-	/*
-	 * serialize with TMF AbortTask
-	 */
-	if (ctask->mtask)
-		return error;
-
 	/* Send the cmd PDU */
 	if (!iser_ctask->command_sent) {
 		error = iser_send_command(conn, ctask);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 57ce225..4b226b8 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -197,7 +197,7 @@ iscsi_tcp_cleanup_ctask(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	if (unlikely(!sc))
 		return;
 
-	tcp_ctask->xmstate = XMSTATE_VALUE_IDLE;
+	tcp_ctask->xmstate = XMSTATE_IDLE;
 	tcp_ctask->r2t = NULL;
 }
 
@@ -369,8 +369,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	spin_lock(&session->lock);
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 
-	if (!ctask->sc || ctask->mtask ||
-	     session->state != ISCSI_STATE_LOGGED_IN) {
+	if (!ctask->sc || session->state != ISCSI_STATE_LOGGED_IN) {
 		printk(KERN_INFO "iscsi_tcp: dropping R2T itt %d in "
 		       "recovery...\n", ctask->itt);
 		spin_unlock(&session->lock);
@@ -409,11 +408,10 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 	tcp_ctask->exp_datasn = r2tsn + 1;
 	__kfifo_put(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*));
-	set_bit(XMSTATE_BIT_SOL_HDR_INIT, &tcp_ctask->xmstate);
-	list_move_tail(&ctask->running, &conn->xmitqueue);
-
-	scsi_queue_work(session->host, &conn->xmitwork);
+	tcp_ctask->xmstate |= XMSTATE_SOL_HDR_INIT;
 	conn->r2t_pdus_cnt++;
+
+	iscsi_requeue_ctask(ctask);
 	spin_unlock(&session->lock);
 
 	return 0;
@@ -1254,7 +1252,7 @@ static void iscsi_set_padding(struct iscsi_tcp_cmd_task *tcp_ctask,
 
 	tcp_ctask->pad_count = ISCSI_PAD_LEN - tcp_ctask->pad_count;
 	debug_scsi("write padding %d bytes\n", tcp_ctask->pad_count);
-	set_bit(XMSTATE_BIT_W_PAD, &tcp_ctask->xmstate);
+	tcp_ctask->xmstate |= XMSTATE_W_PAD;
 }
 
 /**
@@ -1269,7 +1267,7 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task *ctask)
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
 	BUG_ON(__kfifo_len(tcp_ctask->r2tqueue));
-	tcp_ctask->xmstate = 1 << XMSTATE_BIT_CMD_HDR_INIT;
+	tcp_ctask->xmstate = XMSTATE_CMD_HDR_INIT;
 }
 
 /**
@@ -1283,10 +1281,10 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task *ctask)
  *	xmit.
  *
  *	Management xmit state machine consists of these states:
- *		XMSTATE_BIT_IMM_HDR_INIT - calculate digest of PDU Header
- *		XMSTATE_BIT_IMM_HDR      - PDU Header xmit in progress
- *		XMSTATE_BIT_IMM_DATA     - PDU Data xmit in progress
- *		XMSTATE_VALUE_IDLE       - management PDU is done
+ *		XMSTATE_IMM_HDR_INIT	- calculate digest of PDU Header
+ *		XMSTATE_IMM_HDR 	- PDU Header xmit in progress
+ *		XMSTATE_IMM_DATA 	- PDU Data xmit in progress
+ *		XMSTATE_IDLE		- management PDU is done
  **/
 static int
 iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
@@ -1297,12 +1295,12 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 	debug_scsi("mtask deq [cid %d state %x itt 0x%x]\n",
 		conn->id, tcp_mtask->xmstate, mtask->itt);
 
-	if (test_bit(XMSTATE_BIT_IMM_HDR_INIT, &tcp_mtask->xmstate)) {
+	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR_INIT) {
 		iscsi_buf_init_iov(&tcp_mtask->headbuf, (char*)mtask->hdr,
 				   sizeof(struct iscsi_hdr));
 
 		if (mtask->data_count) {
-			set_bit(XMSTATE_BIT_IMM_DATA, &tcp_mtask->xmstate);
+			tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
 			iscsi_buf_init_iov(&tcp_mtask->sendbuf,
 					   (char*)mtask->data,
 					   mtask->data_count);
@@ -1315,20 +1313,21 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 					(u8*)tcp_mtask->hdrext);
 
 		tcp_mtask->sent = 0;
-		clear_bit(XMSTATE_BIT_IMM_HDR_INIT, &tcp_mtask->xmstate);
-		set_bit(XMSTATE_BIT_IMM_HDR, &tcp_mtask->xmstate);
+		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR_INIT;
+		tcp_mtask->xmstate |= XMSTATE_IMM_HDR;
 	}
 
-	if (test_bit(XMSTATE_BIT_IMM_HDR, &tcp_mtask->xmstate)) {
+	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR) {
 		rc = iscsi_sendhdr(conn, &tcp_mtask->headbuf,
 				   mtask->data_count);
 		if (rc)
 			return rc;
-		clear_bit(XMSTATE_BIT_IMM_HDR, &tcp_mtask->xmstate);
+		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR;
 	}
 
-	if (test_and_clear_bit(XMSTATE_BIT_IMM_DATA, &tcp_mtask->xmstate)) {
+	if (tcp_mtask->xmstate & XMSTATE_IMM_DATA) {
 		BUG_ON(!mtask->data_count);
+		tcp_mtask->xmstate &= ~XMSTATE_IMM_DATA;
 		/* FIXME: implement.
 		 * Virtual buffer could be spreaded across multiple pages...
 		 */
@@ -1338,13 +1337,13 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 			rc = iscsi_sendpage(conn, &tcp_mtask->sendbuf,
 					&mtask->data_count, &tcp_mtask->sent);
 			if (rc) {
-				set_bit(XMSTATE_BIT_IMM_DATA, &tcp_mtask->xmstate);
+				tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
 				return rc;
 			}
 		} while (mtask->data_count);
 	}
 
-	BUG_ON(tcp_mtask->xmstate != XMSTATE_VALUE_IDLE);
+	BUG_ON(tcp_mtask->xmstate != XMSTATE_IDLE);
 	if (mtask->hdr->itt == RESERVED_ITT) {
 		struct iscsi_session *session = conn->session;
 
@@ -1364,7 +1363,7 @@ iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	int rc = 0;
 
-	if (test_bit(XMSTATE_BIT_CMD_HDR_INIT, &tcp_ctask->xmstate)) {
+	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_INIT) {
 		tcp_ctask->sent = 0;
 		tcp_ctask->sg_count = 0;
 		tcp_ctask->exp_datasn = 0;
@@ -1389,21 +1388,21 @@ iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 					 (u8*)tcp_ctask->hdrext);
-		clear_bit(XMSTATE_BIT_CMD_HDR_INIT, &tcp_ctask->xmstate);
-		set_bit(XMSTATE_BIT_CMD_HDR_XMIT, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_INIT;
+		tcp_ctask->xmstate |= XMSTATE_CMD_HDR_XMIT;
 	}
 
-	if (test_bit(XMSTATE_BIT_CMD_HDR_XMIT, &tcp_ctask->xmstate)) {
+	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_XMIT) {
 		rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->imm_count);
 		if (rc)
 			return rc;
-		clear_bit(XMSTATE_BIT_CMD_HDR_XMIT, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_XMIT;
 
 		if (sc->sc_data_direction != DMA_TO_DEVICE)
 			return 0;
 
 		if (ctask->imm_count) {
-			set_bit(XMSTATE_BIT_IMM_DATA, &tcp_ctask->xmstate);
+			tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
 			iscsi_set_padding(tcp_ctask, ctask->imm_count);
 
 			if (ctask->conn->datadgst_en) {
@@ -1413,10 +1412,9 @@ iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 			}
 		}
 
-		if (ctask->unsol_count) {
-			set_bit(XMSTATE_BIT_UNS_HDR, &tcp_ctask->xmstate);
-			set_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate);
-		}
+		if (ctask->unsol_count)
+			tcp_ctask->xmstate |=
+					XMSTATE_UNS_HDR | XMSTATE_UNS_INIT;
 	}
 	return rc;
 }
@@ -1428,25 +1426,25 @@ iscsi_send_padding(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	int sent = 0, rc;
 
-	if (test_bit(XMSTATE_BIT_W_PAD, &tcp_ctask->xmstate)) {
+	if (tcp_ctask->xmstate & XMSTATE_W_PAD) {
 		iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
 				   tcp_ctask->pad_count);
 		if (conn->datadgst_en)
 			crypto_hash_update(&tcp_conn->tx_hash,
 					   &tcp_ctask->sendbuf.sg,
 					   tcp_ctask->sendbuf.sg.length);
-	} else if (!test_bit(XMSTATE_BIT_W_RESEND_PAD, &tcp_ctask->xmstate))
+	} else if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_PAD))
 		return 0;
 
-	clear_bit(XMSTATE_BIT_W_PAD, &tcp_ctask->xmstate);
-	clear_bit(XMSTATE_BIT_W_RESEND_PAD, &tcp_ctask->xmstate);
+	tcp_ctask->xmstate &= ~XMSTATE_W_PAD;
+	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_PAD;
 	debug_scsi("sending %d pad bytes for itt 0x%x\n",
 		   tcp_ctask->pad_count, ctask->itt);
 	rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf, &tcp_ctask->pad_count,
 			   &sent);
 	if (rc) {
 		debug_scsi("padding send failed %d\n", rc);
-		set_bit(XMSTATE_BIT_W_RESEND_PAD, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate |= XMSTATE_W_RESEND_PAD;
 	}
 	return rc;
 }
@@ -1465,11 +1463,11 @@ iscsi_send_digest(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	tcp_ctask = ctask->dd_data;
 	tcp_conn = conn->dd_data;
 
-	if (!test_bit(XMSTATE_BIT_W_RESEND_DATA_DIGEST, &tcp_ctask->xmstate)) {
+	if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_DATA_DIGEST)) {
 		crypto_hash_final(&tcp_conn->tx_hash, (u8*)digest);
 		iscsi_buf_init_iov(buf, (char*)digest, 4);
 	}
-	clear_bit(XMSTATE_BIT_W_RESEND_DATA_DIGEST, &tcp_ctask->xmstate);
+	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_DATA_DIGEST;
 
 	rc = iscsi_sendpage(conn, buf, &tcp_ctask->digest_count, &sent);
 	if (!rc)
@@ -1478,7 +1476,7 @@ iscsi_send_digest(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	else {
 		debug_scsi("sending digest 0x%x failed for itt 0x%x!\n",
 			  *digest, ctask->itt);
-		set_bit(XMSTATE_BIT_W_RESEND_DATA_DIGEST, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate |= XMSTATE_W_RESEND_DATA_DIGEST;
 	}
 	return rc;
 }
@@ -1526,8 +1524,8 @@ iscsi_send_unsol_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	struct iscsi_data_task *dtask;
 	int rc;
 
-	set_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate);
-	if (test_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate)) {
+	tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
+	if (tcp_ctask->xmstate & XMSTATE_UNS_INIT) {
 		dtask = &tcp_ctask->unsol_dtask;
 
 		iscsi_prep_unsolicit_data_pdu(ctask, &dtask->hdr);
@@ -1537,14 +1535,14 @@ iscsi_send_unsol_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 					(u8*)dtask->hdrext);
 
-		clear_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate &= ~XMSTATE_UNS_INIT;
 		iscsi_set_padding(tcp_ctask, ctask->data_count);
 	}
 
 	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->data_count);
 	if (rc) {
-		clear_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate);
-		set_bit(XMSTATE_BIT_UNS_HDR, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
+		tcp_ctask->xmstate |= XMSTATE_UNS_HDR;
 		return rc;
 	}
 
@@ -1565,15 +1563,16 @@ iscsi_send_unsol_pdu(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	int rc;
 
-	if (test_and_clear_bit(XMSTATE_BIT_UNS_HDR, &tcp_ctask->xmstate)) {
+	if (tcp_ctask->xmstate & XMSTATE_UNS_HDR) {
 		BUG_ON(!ctask->unsol_count);
+		tcp_ctask->xmstate &= ~XMSTATE_UNS_HDR;
 send_hdr:
 		rc = iscsi_send_unsol_hdr(conn, ctask);
 		if (rc)
 			return rc;
 	}
 
-	if (test_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate)) {
+	if (tcp_ctask->xmstate & XMSTATE_UNS_DATA) {
 		struct iscsi_data_task *dtask = &tcp_ctask->unsol_dtask;
 		int start = tcp_ctask->sent;
 
@@ -1583,14 +1582,14 @@ send_hdr:
 		ctask->unsol_count -= tcp_ctask->sent - start;
 		if (rc)
 			return rc;
-		clear_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
 		/*
 		 * Done with the Data-Out. Next, check if we need
 		 * to send another unsolicited Data-Out.
 		 */
 		if (ctask->unsol_count) {
 			debug_scsi("sending more uns\n");
-			set_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate);
+			tcp_ctask->xmstate |= XMSTATE_UNS_INIT;
 			goto send_hdr;
 		}
 	}
@@ -1606,7 +1605,7 @@ static int iscsi_send_sol_pdu(struct iscsi_conn *conn,
 	struct iscsi_data_task *dtask;
 	int left, rc;
 
-	if (test_bit(XMSTATE_BIT_SOL_HDR_INIT, &tcp_ctask->xmstate)) {
+	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR_INIT) {
 		if (!tcp_ctask->r2t) {
 			spin_lock_bh(&session->lock);
 			__kfifo_get(tcp_ctask->r2tqueue, (void*)&tcp_ctask->r2t,
@@ -1620,19 +1619,19 @@ send_hdr:
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &r2t->headbuf,
 					(u8*)dtask->hdrext);
-		clear_bit(XMSTATE_BIT_SOL_HDR_INIT, &tcp_ctask->xmstate);
-		set_bit(XMSTATE_BIT_SOL_HDR, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR_INIT;
+		tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
 	}
 
-	if (test_bit(XMSTATE_BIT_SOL_HDR, &tcp_ctask->xmstate)) {
+	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR) {
 		r2t = tcp_ctask->r2t;
 		dtask = &r2t->dtask;
 
 		rc = iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count);
 		if (rc)
 			return rc;
-		clear_bit(XMSTATE_BIT_SOL_HDR, &tcp_ctask->xmstate);
-		set_bit(XMSTATE_BIT_SOL_DATA, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
+		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
 
 		if (conn->datadgst_en) {
 			iscsi_data_digest_init(conn->dd_data, tcp_ctask);
@@ -1645,7 +1644,7 @@ send_hdr:
 			r2t->sent);
 	}
 
-	if (test_bit(XMSTATE_BIT_SOL_DATA, &tcp_ctask->xmstate)) {
+	if (tcp_ctask->xmstate & XMSTATE_SOL_DATA) {
 		r2t = tcp_ctask->r2t;
 		dtask = &r2t->dtask;
 
@@ -1654,7 +1653,7 @@ send_hdr:
 				     &dtask->digestbuf, &dtask->digest);
 		if (rc)
 			return rc;
-		clear_bit(XMSTATE_BIT_SOL_DATA, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
 
 		/*
 		 * Done with this Data-Out. Next, check if we have
@@ -1699,32 +1698,32 @@ send_hdr:
  *	xmit stages.
  *
  *iscsi_send_cmd_hdr()
- *	XMSTATE_BIT_CMD_HDR_INIT - prepare Header and Data buffers Calculate
- *	                           Header Digest
- *	XMSTATE_BIT_CMD_HDR_XMIT - Transmit header in progress
+ *	XMSTATE_CMD_HDR_INIT - prepare Header and Data buffers Calculate
+ *	                       Header Digest
+ *	XMSTATE_CMD_HDR_XMIT - Transmit header in progress
  *
  *iscsi_send_padding
- *	XMSTATE_BIT_W_PAD        - Prepare and send pading
- *	XMSTATE_BIT_W_RESEND_PAD - retry send pading
+ *	XMSTATE_W_PAD        - Prepare and send pading
+ *	XMSTATE_W_RESEND_PAD - retry send pading
  *
  *iscsi_send_digest
- *	XMSTATE_BIT_W_RESEND_DATA_DIGEST - Finalize and send Data Digest
- *	XMSTATE_BIT_W_RESEND_DATA_DIGEST - retry sending digest
+ *	XMSTATE_W_RESEND_DATA_DIGEST - Finalize and send Data Digest
+ *	XMSTATE_W_RESEND_DATA_DIGEST - retry sending digest
  *
  *iscsi_send_unsol_hdr
- *	XMSTATE_BIT_UNS_INIT     - prepare un-solicit data header and digest
- *	XMSTATE_BIT_UNS_HDR      - send un-solicit header
+ *	XMSTATE_UNS_INIT     - prepare un-solicit data header and digest
+ *	XMSTATE_UNS_HDR      - send un-solicit header
  *
  *iscsi_send_unsol_pdu
- *	XMSTATE_BIT_UNS_DATA     - send un-solicit data in progress
+ *	XMSTATE_UNS_DATA     - send un-solicit data in progress
  *
  *iscsi_send_sol_pdu
- *	XMSTATE_BIT_SOL_HDR_INIT - solicit data header and digest initialize
- *	XMSTATE_BIT_SOL_HDR      - send solicit header
- *	XMSTATE_BIT_SOL_DATA     - send solicit data
+ *	XMSTATE_SOL_HDR_INIT - solicit data header and digest initialize
+ *	XMSTATE_SOL_HDR      - send solicit header
+ *	XMSTATE_SOL_DATA     - send solicit data
  *
  *iscsi_tcp_ctask_xmit
- *	XMSTATE_BIT_IMM_DATA     - xmit managment data (??)
+ *	XMSTATE_IMM_DATA     - xmit managment data (??)
  **/
 static int
 iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
@@ -1741,13 +1740,13 @@ iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	if (ctask->sc->sc_data_direction != DMA_TO_DEVICE)
 		return 0;
 
-	if (test_bit(XMSTATE_BIT_IMM_DATA, &tcp_ctask->xmstate)) {
+	if (tcp_ctask->xmstate & XMSTATE_IMM_DATA) {
 		rc = iscsi_send_data(ctask, &tcp_ctask->sendbuf, &tcp_ctask->sg,
 				     &tcp_ctask->sent, &ctask->imm_count,
 				     &tcp_ctask->immbuf, &tcp_ctask->immdigest);
 		if (rc)
 			return rc;
-		clear_bit(XMSTATE_BIT_IMM_DATA, &tcp_ctask->xmstate);
+		tcp_ctask->xmstate &= ~XMSTATE_IMM_DATA;
 	}
 
 	rc = iscsi_send_unsol_pdu(conn, ctask);
@@ -1980,7 +1979,7 @@ static void
 iscsi_tcp_mgmt_init(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 {
 	struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
-	tcp_mtask->xmstate = 1 << XMSTATE_BIT_IMM_HDR_INIT;
+	tcp_mtask->xmstate = XMSTATE_IMM_HDR_INIT;
 }
 
 static int
@@ -2226,6 +2225,7 @@ static struct scsi_host_template iscsi_sht = {
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
+	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.slave_configure        = iscsi_tcp_slave_configure,
@@ -2257,7 +2257,8 @@ static struct iscsi_transport iscsi_tcp_transport = {
 				  ISCSI_PERSISTENT_ADDRESS |
 				  ISCSI_TARGET_NAME | ISCSI_TPGT |
 				  ISCSI_USERNAME | ISCSI_PASSWORD |
-				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN,
+				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
+				  ISCSI_FAST_ABORT,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME |
 				  ISCSI_HOST_NETDEV_NAME,
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 68c36cc..7eba44d 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -32,21 +32,21 @@
 #define IN_PROGRESS_PAD_RECV		0x4
 
 /* xmit state machine */
-#define XMSTATE_VALUE_IDLE			0
-#define XMSTATE_BIT_CMD_HDR_INIT		0
-#define XMSTATE_BIT_CMD_HDR_XMIT		1
-#define XMSTATE_BIT_IMM_HDR			2
-#define XMSTATE_BIT_IMM_DATA			3
-#define XMSTATE_BIT_UNS_INIT			4
-#define XMSTATE_BIT_UNS_HDR			5
-#define XMSTATE_BIT_UNS_DATA			6
-#define XMSTATE_BIT_SOL_HDR			7
-#define XMSTATE_BIT_SOL_DATA			8
-#define XMSTATE_BIT_W_PAD			9
-#define XMSTATE_BIT_W_RESEND_PAD		10
-#define XMSTATE_BIT_W_RESEND_DATA_DIGEST	11
-#define XMSTATE_BIT_IMM_HDR_INIT		12
-#define XMSTATE_BIT_SOL_HDR_INIT		13
+#define XMSTATE_IDLE			0x0
+#define XMSTATE_CMD_HDR_INIT		0x1
+#define XMSTATE_CMD_HDR_XMIT		0x2
+#define XMSTATE_IMM_HDR			0x4
+#define XMSTATE_IMM_DATA		0x8
+#define XMSTATE_UNS_INIT		0x10
+#define XMSTATE_UNS_HDR			0x20
+#define XMSTATE_UNS_DATA		0x40
+#define XMSTATE_SOL_HDR			0x80
+#define XMSTATE_SOL_DATA		0x100
+#define XMSTATE_W_PAD			0x200
+#define XMSTATE_W_RESEND_PAD		0x400
+#define XMSTATE_W_RESEND_DATA_DIGEST	0x800
+#define XMSTATE_IMM_HDR_INIT		0x1000
+#define XMSTATE_SOL_HDR_INIT		0x2000
 
 #define ISCSI_PAD_LEN			4
 #define ISCSI_SG_TABLESIZE		SG_ALL
@@ -122,7 +122,7 @@ struct iscsi_data_task {
 struct iscsi_tcp_mgmt_task {
 	struct iscsi_hdr	hdr;
 	char			hdrext[sizeof(__u32)]; /* Header-Digest */
-	unsigned long		xmstate;	/* mgmt xmit progress */
+	int			xmstate;	/* mgmt xmit progress */
 	struct iscsi_buf	headbuf;	/* header buffer */
 	struct iscsi_buf	sendbuf;	/* in progress buffer */
 	int			sent;
@@ -150,7 +150,7 @@ struct iscsi_tcp_cmd_task {
 	int			pad_count;		/* padded bytes */
 	struct iscsi_buf	headbuf;		/* header buf (xmit) */
 	struct iscsi_buf	sendbuf;		/* in progress buffer*/
-	unsigned long		xmstate;		/* xmit xtate machine */
+	int			xmstate;		/* xmit xtate machine */
 	int			sent;
 	struct scatterlist	*sg;			/* per-cmd SG list  */
 	struct scatterlist	*bad_sg;		/* assert statement */
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8b57af5..176458f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -86,7 +86,7 @@ iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 		 * xmit thread
 		 */
 		if (!list_empty(&session->leadconn->xmitqueue) ||
-		    __kfifo_len(session->leadconn->mgmtqueue))
+		    !list_empty(&session->leadconn->mgmtqueue))
 			scsi_queue_work(session->host,
 					&session->leadconn->xmitwork);
 	}
@@ -318,15 +318,15 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 	conn->tmfrsp_pdus_cnt++;
 
-	if (conn->tmabort_state != TMABORT_INITIAL)
+	if (conn->tmf_state != TMF_QUEUED)
 		return;
 
 	if (tmf->response == ISCSI_TMF_RSP_COMPLETE)
-		conn->tmabort_state = TMABORT_SUCCESS;
+		conn->tmf_state = TMF_SUCCESS;
 	else if (tmf->response == ISCSI_TMF_RSP_NO_TASK)
-		conn->tmabort_state = TMABORT_NOT_FOUND;
+		conn->tmf_state = TMF_NOT_FOUND;
 	else
-		conn->tmabort_state = TMABORT_FAILED;
+		conn->tmf_state = TMF_FAILED;
 	wake_up(&conn->ehwait);
 }
 
@@ -429,7 +429,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			 */
 			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 				rc = ISCSI_ERR_CONN_FAILED;
-			list_del(&mtask->running);
+			list_del_init(&mtask->running);
 			if (conn->login_mtask != mtask)
 				__kfifo_put(session->mgmtpool.queue,
 					    (void*)&mtask, sizeof(void*));
@@ -451,10 +451,9 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 				rc = ISCSI_ERR_CONN_FAILED;
-			list_del(&mtask->running);
-			if (conn->login_mtask != mtask)
-				__kfifo_put(session->mgmtpool.queue,
-					    (void*)&mtask, sizeof(void*));
+			list_del_init(&mtask->running);
+			__kfifo_put(session->mgmtpool.queue,
+				    (void*)&mtask, sizeof(void*));
 			break;
 		default:
 			rc = ISCSI_ERR_BAD_OPCODE;
@@ -609,7 +608,8 @@ static void iscsi_prep_mtask(struct iscsi_conn *conn,
 		session->tt->init_mgmt_task(conn, mtask);
 
 	debug_scsi("mgmtpdu [op 0x%x hdr->itt 0x%x datalen %d]\n",
-		   hdr->opcode, hdr->itt, mtask->data_count);
+		   hdr->opcode & ISCSI_OPCODE_MASK, hdr->itt,
+		   mtask->data_count);
 }
 
 static int iscsi_xmit_mtask(struct iscsi_conn *conn)
@@ -658,21 +658,13 @@ static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 static int iscsi_xmit_ctask(struct iscsi_conn *conn)
 {
 	struct iscsi_cmd_task *ctask = conn->ctask;
-	int rc = 0;
-
-	/*
-	 * serialize with TMF AbortTask
-	 */
-	if (ctask->state == ISCSI_TASK_ABORTING)
-		goto done;
+	int rc;
 
 	__iscsi_get_ctask(ctask);
 	spin_unlock_bh(&conn->session->lock);
 	rc = conn->session->tt->xmit_cmd_task(conn, ctask);
 	spin_lock_bh(&conn->session->lock);
 	__iscsi_put_ctask(ctask);
-
-done:
 	if (!rc)
 		/* done with this ctask */
 		conn->ctask = NULL;
@@ -680,6 +672,22 @@ done:
 }
 
 /**
+ * iscsi_requeue_ctask - requeue ctask to run from session workqueue
+ * @ctask: ctask to requeue
+ *
+ * LLDs that need to run a ctask from the session workqueue should call
+ * this. The session lock must be held.
+ */
+void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask)
+{
+	struct iscsi_conn *conn = ctask->conn;
+
+	list_move_tail(&ctask->running, &conn->requeue);
+	scsi_queue_work(conn->session->host, &conn->xmitwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_requeue_ctask);
+
+/**
  * iscsi_data_xmit - xmit any command into the scheduled connection
  * @conn: iscsi connection
  *
@@ -717,36 +725,27 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	 * overflow us with nop-ins
 	 */
 check_mgmt:
-	while (__kfifo_get(conn->mgmtqueue, (void*)&conn->mtask,
-			   sizeof(void*))) {
+	while (!list_empty(&conn->mgmtqueue)) {
+		conn->mtask = list_entry(conn->mgmtqueue.next,
+					 struct iscsi_mgmt_task, running);
 		iscsi_prep_mtask(conn, conn->mtask);
-		list_add_tail(&conn->mtask->running, &conn->mgmt_run_list);
+		list_move_tail(conn->mgmtqueue.next, &conn->mgmt_run_list);
 		rc = iscsi_xmit_mtask(conn);
 		if (rc)
 			goto again;
 	}
 
-	/* process command queue */
+	/* process pending command queue */
 	while (!list_empty(&conn->xmitqueue)) {
-		/*
-		 * iscsi tcp may readd the task to the xmitqueue to send
-		 * write data
-		 */
+		if (conn->tmf_state == TMF_QUEUED)
+			break;
+
 		conn->ctask = list_entry(conn->xmitqueue.next,
 					 struct iscsi_cmd_task, running);
-		switch (conn->ctask->state) {
-		case ISCSI_TASK_ABORTING:
-			break;
-		case ISCSI_TASK_PENDING:
-			iscsi_prep_scsi_cmd_pdu(conn->ctask);
-			conn->session->tt->init_cmd_task(conn->ctask);
-			/* fall through */
-		default:
-			conn->ctask->state = ISCSI_TASK_RUNNING;
-			break;
-		}
+		iscsi_prep_scsi_cmd_pdu(conn->ctask);
+		conn->session->tt->init_cmd_task(conn->ctask);
+		conn->ctask->state = ISCSI_TASK_RUNNING;
 		list_move_tail(conn->xmitqueue.next, &conn->run_list);
-
 		rc = iscsi_xmit_ctask(conn);
 		if (rc)
 			goto again;
@@ -755,7 +754,22 @@ check_mgmt:
 		 * we need to check the mgmt queue for nops that need to
 		 * be sent to aviod starvation
 		 */
-		if (__kfifo_len(conn->mgmtqueue))
+		if (!list_empty(&conn->mgmtqueue))
+			goto check_mgmt;
+	}
+
+	while (!list_empty(&conn->requeue)) {
+		if (conn->session->fast_abort && conn->tmf_state != TMF_INITIAL)
+			break;
+
+		conn->ctask = list_entry(conn->requeue.next,
+					 struct iscsi_cmd_task, running);
+		conn->ctask->state = ISCSI_TASK_RUNNING;
+		list_move_tail(conn->requeue.next, &conn->run_list);
+		rc = iscsi_xmit_ctask(conn);
+		if (rc)
+			goto again;
+		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
 	spin_unlock_bh(&conn->session->lock);
@@ -859,7 +873,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 
 	atomic_set(&ctask->refcount, 1);
 	ctask->state = ISCSI_TASK_PENDING;
-	ctask->mtask = NULL;
 	ctask->conn = conn;
 	ctask->sc = sc;
 	INIT_LIST_HEAD(&ctask->running);
@@ -929,9 +942,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	} else
 		mtask->data_count = 0;
 
-	INIT_LIST_HEAD(&mtask->running);
 	memcpy(mtask->hdr, hdr, sizeof(struct iscsi_hdr));
-	__kfifo_put(conn->mgmtqueue, (void*)&mtask, sizeof(void*));
+	INIT_LIST_HEAD(&mtask->running);
+	list_add_tail(&mtask->running, &conn->mgmtqueue);
 	return mtask;
 }
 
@@ -954,13 +967,12 @@ EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
 void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = class_to_transport_session(cls_session);
-	struct iscsi_conn *conn = session->leadconn;
 
 	spin_lock_bh(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		session->state = ISCSI_STATE_RECOVERY_FAILED;
-		if (conn)
-			wake_up(&conn->ehwait);
+		if (session->leadconn)
+			wake_up(&session->leadconn->ehwait);
 	}
 	spin_unlock_bh(&session->lock);
 }
@@ -971,7 +983,6 @@ int iscsi_eh_host_reset(struct scsi_cmnd *sc)
 	struct Scsi_Host *host = sc->device->host;
 	struct iscsi_session *session = iscsi_hostdata(host->hostdata);
 	struct iscsi_conn *conn = session->leadconn;
-	int fail_session = 0;
 
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_TERMINATE) {
@@ -982,19 +993,13 @@ failed:
 		return FAILED;
 	}
 
-	if (sc->SCp.phase == session->age) {
-		debug_scsi("failing connection CID %d due to SCSI host reset\n",
-			   conn->id);
-		fail_session = 1;
-	}
 	spin_unlock_bh(&session->lock);
 
 	/*
 	 * we drop the lock here but the leadconn cannot be destoyed while
 	 * we are in the scsi eh
 	 */
-	if (fail_session)
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 
 	debug_scsi("iscsi_eh_host_reset wait for relogin\n");
 	wait_event_interruptible(conn->ehwait,
@@ -1015,62 +1020,43 @@ failed:
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_host_reset);
 
-static void iscsi_tmabort_timedout(unsigned long data)
+static void iscsi_tmf_timedout(unsigned long data)
 {
-	struct iscsi_cmd_task *ctask = (struct iscsi_cmd_task *)data;
-	struct iscsi_conn *conn = ctask->conn;
+	struct iscsi_conn *conn = (struct iscsi_conn *)data;
 	struct iscsi_session *session = conn->session;
 
 	spin_lock(&session->lock);
-	if (conn->tmabort_state == TMABORT_INITIAL) {
-		conn->tmabort_state = TMABORT_TIMEDOUT;
-		debug_scsi("tmabort timedout [sc %p itt 0x%x]\n",
-			ctask->sc, ctask->itt);
+	if (conn->tmf_state == TMF_QUEUED) {
+		conn->tmf_state = TMF_TIMEDOUT;
+		debug_scsi("tmf timedout\n");
 		/* unblock eh_abort() */
 		wake_up(&conn->ehwait);
 	}
 	spin_unlock(&session->lock);
 }
 
-static int iscsi_exec_abort_task(struct scsi_cmnd *sc,
-				 struct iscsi_cmd_task *ctask)
+static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
+				   struct iscsi_tm *hdr, int age)
 {
-	struct iscsi_conn *conn = ctask->conn;
 	struct iscsi_session *session = conn->session;
-	struct iscsi_tm *hdr = &conn->tmhdr;
-
-	/*
-	 * ctask timed out but session is OK requests must be serialized.
-	 */
-	memset(hdr, 0, sizeof(struct iscsi_tm));
-	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
-	hdr->flags = ISCSI_TM_FUNC_ABORT_TASK;
-	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
-	memcpy(hdr->lun, ctask->hdr->lun, sizeof(hdr->lun));
-	hdr->rtt = ctask->hdr->itt;
-	hdr->refcmdsn = ctask->hdr->cmdsn;
+	struct iscsi_mgmt_task *mtask;
 
-	ctask->mtask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
-					    NULL, 0);
-	if (!ctask->mtask) {
+	mtask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
+				      NULL, 0);
+	if (!mtask) {
 		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-		spin_lock_bh(&session->lock)
-		debug_scsi("abort sent failure [itt 0x%x]\n", ctask->itt);
+		spin_lock_bh(&session->lock);
+		debug_scsi("tmf exec failure\n");
 		return -EPERM;
 	}
-	ctask->state = ISCSI_TASK_ABORTING;
-
-	debug_scsi("abort sent [itt 0x%x]\n", ctask->itt);
+	conn->tmfcmd_pdus_cnt++;
+	conn->tmf_timer.expires = 30 * HZ + jiffies;
+	conn->tmf_timer.function = iscsi_tmf_timedout;
+	conn->tmf_timer.data = (unsigned long)conn;
+	add_timer(&conn->tmf_timer);
+	debug_scsi("tmf set timeout\n");
 
-	if (conn->tmabort_state == TMABORT_INITIAL) {
-		conn->tmfcmd_pdus_cnt++;
-		conn->tmabort_timer.expires = 20*HZ + jiffies;
-		conn->tmabort_timer.function = iscsi_tmabort_timedout;
-		conn->tmabort_timer.data = (unsigned long)ctask;
-		add_timer(&conn->tmabort_timer);
-		debug_scsi("abort set timeout [itt 0x%x]\n", ctask->itt);
-	}
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
 	scsi_queue_work(session->host, &conn->xmitwork);
@@ -1078,61 +1064,30 @@ static int iscsi_exec_abort_task(struct scsi_cmnd *sc,
 	/*
 	 * block eh thread until:
 	 *
-	 * 1) abort response
-	 * 2) abort timeout
+	 * 1) tmf response
+	 * 2) tmf timeout
 	 * 3) session is terminated or restarted or userspace has
 	 * given up on recovery
 	 */
-	wait_event_interruptible(conn->ehwait,
-				 sc->SCp.phase != session->age ||
+	wait_event_interruptible(conn->ehwait, age != session->age ||
 				 session->state != ISCSI_STATE_LOGGED_IN ||
-				 conn->tmabort_state != TMABORT_INITIAL);
+				 conn->tmf_state != TMF_QUEUED);
 	if (signal_pending(current))
 		flush_signals(current);
-	del_timer_sync(&conn->tmabort_timer);
+	del_timer_sync(&conn->tmf_timer);
+
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
-	return 0;
-}
-
-/*
- * session lock must be held
- */
-static struct iscsi_mgmt_task *
-iscsi_remove_mgmt_task(struct kfifo *fifo, uint32_t itt)
-{
-	int i, nr_tasks = __kfifo_len(fifo) / sizeof(void*);
-	struct iscsi_mgmt_task *task;
-
-	debug_scsi("searching %d tasks\n", nr_tasks);
-
-	for (i = 0; i < nr_tasks; i++) {
-		__kfifo_get(fifo, (void*)&task, sizeof(void*));
-		debug_scsi("check task %u\n", task->itt);
-
-		if (task->itt == itt) {
-			debug_scsi("matched task\n");
-			return task;
-		}
+	/* if the session drops it will clean up the mtask */
+	if (age != session->age ||
+	    session->state != ISCSI_STATE_LOGGED_IN)
+		return -ENOTCONN;
 
-		__kfifo_put(fifo, (void*)&task, sizeof(void*));
+	if (!list_empty(&mtask->running)) {
+		list_del_init(&mtask->running);
+		__kfifo_put(session->mgmtpool.queue, (void*)&mtask,
+			    sizeof(void*));
 	}
-	return NULL;
-}
-
-static int iscsi_ctask_mtask_cleanup(struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_conn *conn = ctask->conn;
-	struct iscsi_session *session = conn->session;
-
-	if (!ctask->mtask)
-		return -EINVAL;
-
-	if (!iscsi_remove_mgmt_task(conn->mgmtqueue, ctask->mtask->itt))
-		list_del(&ctask->mtask->running);
-	__kfifo_put(session->mgmtpool.queue, (void*)&ctask->mtask,
-		    sizeof(void*));
-	ctask->mtask = NULL;
 	return 0;
 }
 
@@ -1156,7 +1111,6 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 		conn->session->queued_cmdsn--;
 	else
 		conn->session->tt->cleanup_cmd_task(conn, ctask);
-	iscsi_ctask_mtask_cleanup(ctask);
 
 	sc->result = err;
 	scsi_set_resid(sc, scsi_bufflen(sc));
@@ -1166,6 +1120,44 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	__iscsi_put_ctask(ctask);
 }
 
+/*
+ * Fail commands. session lock held and recv side suspended and xmit
+ * thread flushed
+ */
+static void fail_all_commands(struct iscsi_conn *conn, unsigned lun)
+{
+	struct iscsi_cmd_task *ctask, *tmp;
+
+	if (conn->ctask && (conn->ctask->sc->device->lun == lun || lun == -1))
+		conn->ctask = NULL;
+
+	/* flush pending */
+	list_for_each_entry_safe(ctask, tmp, &conn->xmitqueue, running) {
+		if (lun == ctask->sc->device->lun || lun == -1) {
+			debug_scsi("failing pending sc %p itt 0x%x\n",
+				   ctask->sc, ctask->itt);
+			fail_command(conn, ctask, DID_BUS_BUSY << 16);
+		}
+	}
+
+	list_for_each_entry_safe(ctask, tmp, &conn->requeue, running) {
+		if (lun == ctask->sc->device->lun || lun == -1) {
+			debug_scsi("failing requeued sc %p itt 0x%x\n",
+				   ctask->sc, ctask->itt);
+			fail_command(conn, ctask, DID_BUS_BUSY << 16);
+		}
+	}
+
+	/* fail all other running */
+	list_for_each_entry_safe(ctask, tmp, &conn->run_list, running) {
+		if (lun == ctask->sc->device->lun || lun == -1) {
+			debug_scsi("failing in progress sc %p itt 0x%x\n",
+				   ctask->sc, ctask->itt);
+			fail_command(conn, ctask, DID_BUS_BUSY << 16);
+		}
+	}
+}
+
 static void iscsi_suspend_tx(struct iscsi_conn *conn)
 {
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
@@ -1178,13 +1170,26 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
 	scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
 
+static void iscsi_prep_abort_task_pdu(struct iscsi_cmd_task *ctask,
+				      struct iscsi_tm *hdr)
+{
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
+	hdr->flags = ISCSI_TM_FUNC_ABORT_TASK & ISCSI_FLAG_TM_FUNC_MASK;
+	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
+	memcpy(hdr->lun, ctask->hdr->lun, sizeof(hdr->lun));
+	hdr->rtt = ctask->hdr->itt;
+	hdr->refcmdsn = ctask->hdr->cmdsn;
+}
+
 int iscsi_eh_abort(struct scsi_cmnd *sc)
 {
 	struct Scsi_Host *host = sc->device->host;
 	struct iscsi_session *session = iscsi_hostdata(host->hostdata);
-	struct iscsi_cmd_task *ctask;
 	struct iscsi_conn *conn;
-	int rc;
+	struct iscsi_cmd_task *ctask;
+	struct iscsi_tm *hdr;
+	int rc, age;
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
@@ -1199,19 +1204,23 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 
-	ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
-	conn = ctask->conn;
-
-	conn->eh_abort_cnt++;
-	debug_scsi("aborting [sc %p itt 0x%x]\n", sc, ctask->itt);
-
 	/*
 	 * If we are not logged in or we have started a new session
 	 * then let the host reset code handle this
 	 */
-	if (session->state != ISCSI_STATE_LOGGED_IN ||
-	    sc->SCp.phase != session->age)
-		goto failed;
+	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN ||
+	    sc->SCp.phase != session->age) {
+		spin_unlock_bh(&session->lock);
+		mutex_unlock(&session->eh_mutex);
+		return FAILED;
+	}
+
+	conn = session->leadconn;
+	conn->eh_abort_cnt++;
+	age = session->age;
+
+	ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
+	debug_scsi("aborting [sc %p itt 0x%x]\n", sc, ctask->itt);
 
 	/* ctask completed before time out */
 	if (!ctask->sc) {
@@ -1219,27 +1228,26 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		goto success;
 	}
 
-	/* what should we do here ? */
-	if (conn->ctask == ctask) {
-		printk(KERN_INFO "iscsi: sc %p itt 0x%x partially sent. "
-		       "Failing abort\n", sc, ctask->itt);
-		goto failed;
-	}
-
 	if (ctask->state == ISCSI_TASK_PENDING) {
 		fail_command(conn, ctask, DID_ABORT << 16);
 		goto success;
 	}
 
-	conn->tmabort_state = TMABORT_INITIAL;
-	rc = iscsi_exec_abort_task(sc, ctask);
-	if (rc || sc->SCp.phase != session->age ||
-	    session->state != ISCSI_STATE_LOGGED_IN)
+	/* only have one tmf outstanding at a time */
+	if (conn->tmf_state != TMF_INITIAL)
 		goto failed;
-	iscsi_ctask_mtask_cleanup(ctask);
+	conn->tmf_state = TMF_QUEUED;
 
-	switch (conn->tmabort_state) {
-	case TMABORT_SUCCESS:
+	hdr = &conn->tmhdr;
+	iscsi_prep_abort_task_pdu(ctask, hdr);
+
+	if (iscsi_exec_task_mgmt_fn(conn, hdr, age)) {
+		rc = FAILED;
+		goto failed;
+	}
+
+	switch (conn->tmf_state) {
+	case TMF_SUCCESS:
 		spin_unlock_bh(&session->lock);
 		iscsi_suspend_tx(conn);
 		/*
@@ -1248,22 +1256,26 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		write_lock_bh(conn->recv_lock);
 		spin_lock(&session->lock);
 		fail_command(conn, ctask, DID_ABORT << 16);
+		conn->tmf_state = TMF_INITIAL;
 		spin_unlock(&session->lock);
 		write_unlock_bh(conn->recv_lock);
 		iscsi_start_tx(conn);
 		goto success_unlocked;
-	case TMABORT_NOT_FOUND:
-		if (!ctask->sc) {
+	case TMF_TIMEDOUT:
+		spin_unlock_bh(&session->lock);
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		goto failed_unlocked;
+	case TMF_NOT_FOUND:
+		if (!sc->SCp.ptr) {
+			conn->tmf_state = TMF_INITIAL;
 			/* ctask completed before tmf abort response */
 			debug_scsi("sc completed while abort in progress\n");
 			goto success;
 		}
 		/* fall through */
 	default:
-		/* timedout or failed */
-		spin_unlock_bh(&session->lock);
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-		goto failed_unlocked;
+		conn->tmf_state = TMF_INITIAL;
+		goto failed;
 	}
 
 success:
@@ -1276,12 +1288,93 @@ success_unlocked:
 failed:
 	spin_unlock_bh(&session->lock);
 failed_unlocked:
-	debug_scsi("abort failed [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
+	debug_scsi("abort failed [sc %p itt 0x%x]\n", sc,
+		    ctask ? ctask->itt : 0);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_abort);
 
+static void iscsi_prep_lun_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
+{
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
+	hdr->flags = ISCSI_TM_FUNC_LOGICAL_UNIT_RESET & ISCSI_FLAG_TM_FUNC_MASK;
+	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
+	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
+	hdr->rtt = ISCSI_RESERVED_TAG;
+}
+
+int iscsi_eh_device_reset(struct scsi_cmnd *sc)
+{
+	struct Scsi_Host *host = sc->device->host;
+	struct iscsi_session *session = iscsi_hostdata(host->hostdata);
+	struct iscsi_conn *conn;
+	struct iscsi_tm *hdr;
+	int rc = FAILED;
+
+	debug_scsi("LU Reset [sc %p lun %u]\n", sc, sc->device->lun);
+
+	mutex_lock(&session->eh_mutex);
+	spin_lock_bh(&session->lock);
+	/*
+	 * Just check if we are not logged in. We cannot check for
+	 * the phase because the reset could come from a ioctl.
+	 */
+	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN)
+		goto unlock;
+	conn = session->leadconn;
+
+	/* only have one tmf outstanding at a time */
+	if (conn->tmf_state != TMF_INITIAL)
+		goto unlock;
+	conn->tmf_state = TMF_QUEUED;
+
+	hdr = &conn->tmhdr;
+	iscsi_prep_lun_reset_pdu(sc, hdr);
+
+	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age)) {
+		rc = FAILED;
+		goto unlock;
+	}
+
+	switch (conn->tmf_state) {
+	case TMF_SUCCESS:
+		break;
+	case TMF_TIMEDOUT:
+		spin_unlock_bh(&session->lock);
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		goto done;
+	default:
+		conn->tmf_state = TMF_INITIAL;
+		goto unlock;
+	}
+
+	rc = SUCCESS;
+	spin_unlock_bh(&session->lock);
+
+	iscsi_suspend_tx(conn);
+	/* need to grab the recv lock then session lock */
+	write_lock_bh(conn->recv_lock);
+	spin_lock(&session->lock);
+	fail_all_commands(conn, sc->device->lun);
+	conn->tmf_state = TMF_INITIAL;
+	spin_unlock(&session->lock);
+	write_unlock_bh(conn->recv_lock);
+
+	iscsi_start_tx(conn);
+	goto done;
+
+unlock:
+	spin_unlock_bh(&session->lock);
+done:
+	debug_scsi("iscsi_eh_device_reset %s\n",
+		  rc == SUCCESS ? "SUCCESS" : "FAILED");
+	mutex_unlock(&session->eh_mutex);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(iscsi_eh_device_reset);
+
 int
 iscsi_pool_init(struct iscsi_queue *q, int max, void ***items, int item_size)
 {
@@ -1546,17 +1639,12 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
 	conn->id = conn_idx;
 	conn->exp_statsn = 0;
-	conn->tmabort_state = TMABORT_INITIAL;
+	conn->tmf_state = TMF_INITIAL;
 	INIT_LIST_HEAD(&conn->run_list);
 	INIT_LIST_HEAD(&conn->mgmt_run_list);
+	INIT_LIST_HEAD(&conn->mgmtqueue);
 	INIT_LIST_HEAD(&conn->xmitqueue);
-
-	/* initialize general immediate & non-immediate PDU commands queue */
-	conn->mgmtqueue = kfifo_alloc(session->mgmtpool_max * sizeof(void*),
-			                GFP_KERNEL, NULL);
-	if (conn->mgmtqueue == ERR_PTR(-ENOMEM))
-		goto mgmtqueue_alloc_fail;
-
+	INIT_LIST_HEAD(&conn->requeue);
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_mtask used for the login/text sequences */
@@ -1574,7 +1662,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 		goto login_mtask_data_alloc_fail;
 	conn->login_mtask->data = conn->data = data;
 
-	init_timer(&conn->tmabort_timer);
+	init_timer(&conn->tmf_timer);
 	init_waitqueue_head(&conn->ehwait);
 
 	return cls_conn;
@@ -1583,8 +1671,6 @@ login_mtask_data_alloc_fail:
 	__kfifo_put(session->mgmtpool.queue, (void*)&conn->login_mtask,
 		    sizeof(void*));
 login_mtask_alloc_fail:
-	kfifo_free(conn->mgmtqueue);
-mgmtqueue_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
 }
@@ -1604,7 +1690,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	unsigned long flags;
 
 	spin_lock_bh(&session->lock);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	conn->c_stage = ISCSI_CONN_CLEANUP_WAIT;
 	if (session->leadconn == conn) {
 		/*
@@ -1637,7 +1722,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	}
 
 	/* flush queued up work because we free the connection below */
-	scsi_flush_work(session->host);
+	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->lock);
 	kfree(conn->data);
@@ -1648,8 +1733,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		session->leadconn = NULL;
 	spin_unlock_bh(&session->lock);
 
-	kfifo_free(conn->mgmtqueue);
-
 	iscsi_destroy_conn(cls_conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_teardown);
@@ -1684,7 +1767,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 		 * commands after successful recovery
 		 */
 		conn->stop_stage = 0;
-		conn->tmabort_state = TMABORT_INITIAL;
+		conn->tmf_state = TMF_INITIAL;
 		session->age++;
 		spin_unlock_bh(&session->lock);
 
@@ -1709,10 +1792,11 @@ flush_control_queues(struct iscsi_session *session, struct iscsi_conn *conn)
 	struct iscsi_mgmt_task *mtask, *tmp;
 
 	/* handle pending */
-	while (__kfifo_get(conn->mgmtqueue, (void*)&mtask, sizeof(void*))) {
+	list_for_each_entry_safe(mtask, tmp, &conn->mgmtqueue, running) {
+		debug_scsi("flushing pending mgmt task itt 0x%x\n", mtask->itt);
+		list_del_init(&mtask->running);
 		if (mtask == conn->login_mtask)
 			continue;
-		debug_scsi("flushing pending mgmt task itt 0x%x\n", mtask->itt);
 		__kfifo_put(session->mgmtpool.queue, (void*)&mtask,
 			    sizeof(void*));
 	}
@@ -1720,7 +1804,7 @@ flush_control_queues(struct iscsi_session *session, struct iscsi_conn *conn)
 	/* handle running */
 	list_for_each_entry_safe(mtask, tmp, &conn->mgmt_run_list, running) {
 		debug_scsi("flushing running mgmt task itt 0x%x\n", mtask->itt);
-		list_del(&mtask->running);
+		list_del_init(&mtask->running);
 
 		if (mtask == conn->login_mtask)
 			continue;
@@ -1731,28 +1815,6 @@ flush_control_queues(struct iscsi_session *session, struct iscsi_conn *conn)
 	conn->mtask = NULL;
 }
 
-/* Fail commands. Mutex and session lock held and recv side suspended */
-static void fail_all_commands(struct iscsi_conn *conn)
-{
-	struct iscsi_cmd_task *ctask, *tmp;
-
-	/* flush pending */
-	list_for_each_entry_safe(ctask, tmp, &conn->xmitqueue, running) {
-		debug_scsi("failing pending sc %p itt 0x%x\n", ctask->sc,
-			   ctask->itt);
-		fail_command(conn, ctask, DID_BUS_BUSY << 16);
-	}
-
-	/* fail all other running */
-	list_for_each_entry_safe(ctask, tmp, &conn->run_list, running) {
-		debug_scsi("failing in progress sc %p itt 0x%x\n",
-			   ctask->sc, ctask->itt);
-		fail_command(conn, ctask, DID_BUS_BUSY << 16);
-	}
-
-	conn->ctask = NULL;
-}
-
 static void iscsi_start_session_recovery(struct iscsi_session *session,
 					 struct iscsi_conn *conn, int flag)
 {
@@ -1818,7 +1880,7 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	 * flush queues.
 	 */
 	spin_lock_bh(&session->lock);
-	fail_all_commands(conn);
+	fail_all_commands(conn, -1);
 	flush_control_queues(session, conn);
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
@@ -1869,6 +1931,9 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 	uint32_t value;
 
 	switch(param) {
+	case ISCSI_PARAM_FAST_ABORT:
+		sscanf(buf, "%d", &session->fast_abort);
+		break;
 	case ISCSI_PARAM_MAX_RECV_DLENGTH:
 		sscanf(buf, "%d", &conn->max_recv_dlength);
 		break;
@@ -1983,6 +2048,9 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 	int len;
 
 	switch(param) {
+	case ISCSI_PARAM_FAST_ABORT:
+		len = sprintf(buf, "%d\n", session->fast_abort);
+		break;
 	case ISCSI_PARAM_INITIAL_R2T_EN:
 		len = sprintf(buf, "%d\n", session->initial_r2t_en);
 		break;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 5428d15..b6f346c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -30,7 +30,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 
-#define ISCSI_SESSION_ATTRS 15
+#define ISCSI_SESSION_ATTRS 16
 #define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 4
 #define ISCSI_TRANSPORT_VERSION "2.0-724"
@@ -1217,6 +1217,7 @@ iscsi_session_attr(username, ISCSI_PARAM_USERNAME, 1);
 iscsi_session_attr(username_in, ISCSI_PARAM_USERNAME_IN, 1);
 iscsi_session_attr(password, ISCSI_PARAM_PASSWORD, 1);
 iscsi_session_attr(password_in, ISCSI_PARAM_PASSWORD_IN, 1);
+iscsi_session_attr(fast_abort, ISCSI_PARAM_FAST_ABORT, 1);
 
 #define iscsi_priv_session_attr_show(field, format)			\
 static ssize_t								\
@@ -1438,6 +1439,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_SESSION_RD_ATTR(password_in, ISCSI_USERNAME_IN);
 	SETUP_SESSION_RD_ATTR(username, ISCSI_PASSWORD);
 	SETUP_SESSION_RD_ATTR(username_in, ISCSI_PASSWORD_IN);
+	SETUP_SESSION_RD_ATTR(fast_abort, ISCSI_FAST_ABORT);
 	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 50e907f..bff0b1f 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -236,6 +236,7 @@ enum iscsi_param {
 	ISCSI_PARAM_PASSWORD,
 	ISCSI_PARAM_PASSWORD_IN,
 
+	ISCSI_PARAM_FAST_ABORT,
 	/* must always be last */
 	ISCSI_PARAM_MAX,
 };
@@ -266,6 +267,7 @@ enum iscsi_param {
 #define ISCSI_USERNAME_IN		(1 << ISCSI_PARAM_USERNAME_IN)
 #define ISCSI_PASSWORD			(1 << ISCSI_PARAM_PASSWORD)
 #define ISCSI_PASSWORD_IN		(1 << ISCSI_PARAM_PASSWORD_IN)
+#define ISCSI_FAST_ABORT		(1 << ISCSI_PARAM_FAST_ABORT)
 
 /* iSCSI HBA params */
 enum iscsi_host_param {
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 8d1e4e8..751c81e 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -600,6 +600,8 @@ struct iscsi_reject {
 #define ISCSI_MIN_MAX_BURST_LEN			512
 #define ISCSI_MAX_MAX_BURST_LEN			16777215
 
+#define ISCSI_DEF_TIME2WAIT			2
+
 /************************* RFC 3720 End *****************************/
 
 #endif /* ISCSI_PROTO_H */
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b4b3113..89429f4 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -57,11 +57,14 @@ struct iscsi_nopin;
 #define ISCSI_MAX_CMD_PER_LUN		128
 
 /* Task Mgmt states */
-#define TMABORT_INITIAL			0x0
-#define TMABORT_SUCCESS			0x1
-#define TMABORT_FAILED			0x2
-#define TMABORT_TIMEDOUT		0x3
-#define TMABORT_NOT_FOUND		0x4
+enum {
+	TMF_INITIAL,
+	TMF_QUEUED,
+	TMF_SUCCESS,
+	TMF_FAILED,
+	TMF_TIMEDOUT,
+	TMF_NOT_FOUND,
+};
 
 /* Connection suspend "bit" */
 #define ISCSI_SUSPEND_BIT		1
@@ -91,7 +94,6 @@ enum {
 	ISCSI_TASK_COMPLETED,
 	ISCSI_TASK_PENDING,
 	ISCSI_TASK_RUNNING,
-	ISCSI_TASK_ABORTING,
 };
 
 struct iscsi_cmd_task {
@@ -110,7 +112,6 @@ struct iscsi_cmd_task {
 	unsigned		data_count;	/* remaining Data-Out */
 	struct scsi_cmnd	*sc;		/* associated SCSI cmd*/
 	struct iscsi_conn	*conn;		/* used connection    */
-	struct iscsi_mgmt_task	*mtask;		/* tmf mtask in progr */
 
 	/* state set/tested under session->lock */
 	int			state;
@@ -152,10 +153,11 @@ struct iscsi_conn {
 	struct iscsi_cmd_task	*ctask;		/* xmit ctask in progress */
 
 	/* xmit */
-	struct kfifo		*mgmtqueue;	/* mgmt (control) xmit queue */
+	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
 	struct list_head	mgmt_run_list;	/* list of control tasks */
 	struct list_head	xmitqueue;	/* data-path cmd queue */
 	struct list_head	run_list;	/* list of cmds in progress */
+	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
 	unsigned long		suspend_tx;	/* suspend Tx */
 	unsigned long		suspend_rx;	/* suspend Rx */
@@ -163,8 +165,8 @@ struct iscsi_conn {
 	/* abort */
 	wait_queue_head_t	ehwait;		/* used in eh_abort() */
 	struct iscsi_tm		tmhdr;
-	struct timer_list	tmabort_timer;
-	int			tmabort_state;	/* see TMABORT_INITIAL, etc.*/
+	struct timer_list	tmf_timer;
+	int			tmf_state;	/* see TMF_INITIAL, etc.*/
 
 	/* negotiated params */
 	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
@@ -231,6 +233,7 @@ struct iscsi_session {
 	int			pdu_inorder_en;
 	int			dataseq_inorder_en;
 	int			erl;
+	int			fast_abort;
 	int			tpgt;
 	char			*username;
 	char			*username_in;
@@ -268,6 +271,7 @@ struct iscsi_session {
 extern int iscsi_change_queue_depth(struct scsi_device *sdev, int depth);
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_host_reset(struct scsi_cmnd *sc);
+extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct scsi_cmnd *sc,
 			      void (*done)(struct scsi_cmnd *));
 
@@ -326,6 +330,7 @@ extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 				char *, int);
 extern int iscsi_verify_itt(struct iscsi_conn *, struct iscsi_hdr *,
 			    uint32_t *);
+extern void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask);
 
 /*
  * generic helpers
-- 
1.5.1.2

