From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] iscsi_tcp: fix potential lockup with write commands
Date: Thu, 25 Oct 2007 15:49:44 -0400
Message-ID: <4720F358.8030307@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:4654 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbXJYTtk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 15:49:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

There is a race condition in iscsi_tcp.c that may cause it to forget
that it received a R2T from the target.  This race may cause a data-out
command (such as a write) to lock up.  The race occurs here:

static int
iscsi_send_unsol_pdu(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
{
	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
	int rc;

	if (tcp_ctask->xmstate & XMSTATE_UNS_HDR) {
		BUG_ON(!ctask->unsol_count);
		tcp_ctask->xmstate &= ~XMSTATE_UNS_HDR; <---- RACE
		...

static int
iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
{
	...
	tcp_ctask->xmstate |= XMSTATE_SOL_HDR_INIT; <---- RACE
	...

While iscsi_xmitworker() (called from scsi_queue_work()) is preparing to
send unsolicited data, iscsi_tcp_data_recv() (called from
tcp_read_sock()) interrupts it upon receipt of a R2T from the target.
Both contexts do read-modify-write of tcp_ctask->xmstate.  Usually, gcc
on x86 will make &= and |= atomic on UP (not guaranteed of course), but
in this case iscsi_send_unsol_pdu() reads the value of xmstate before
clearing the bit, which causes gcc to read xmstate into a CPU register,
test it, clear the bit, and then store it back to memory.  If the recv
interrupt happens during this sequence, then the XMSTATE_SOL_HDR_INIT
bit set by the recv interrupt will be lost, and the R2T will be
forgotten.

The patch below (against 2.6.24-rc1) converts accesses of xmstate to use
set_bit, clear_bit, and test_bit instead of |= and &=.  I have tested
this patch and verified that it fixes the problem.  Another possible
approach would be to hold a lock during most of the rx/tx setup and
post-processing, and drop the lock only for the actual rx/tx.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

 iscsi_tcp.c |  139 +++++++++++++++++++++++++++++-------------------------------
 iscsi_tcp.h |   34 +++++++-------
 2 files changed, 86 insertions(+), 87 deletions(-)

diff -urpN linux-2.6.24-rc1/drivers/scsi/iscsi_tcp.c linux-2.6.24-rc1-iscsi/drivers/scsi/iscsi_tcp.c
--- linux-2.6.24-rc1/drivers/scsi/iscsi_tcp.c	2007-10-25 14:52:30.000000000 -0400
+++ linux-2.6.24-rc1-iscsi/drivers/scsi/iscsi_tcp.c	2007-10-25 14:51:24.000000000 -0400
@@ -199,7 +199,7 @@ iscsi_tcp_cleanup_ctask(struct iscsi_con
 	if (unlikely(!sc))
 		return;
 
-	tcp_ctask->xmstate = XMSTATE_IDLE;
+	tcp_ctask->xmstate = XMSTATE_VALUE_IDLE;
 	tcp_ctask->r2t = NULL;
 }
 
@@ -411,7 +411,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 
 	tcp_ctask->exp_datasn = r2tsn + 1;
 	__kfifo_put(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*));
-	tcp_ctask->xmstate |= XMSTATE_SOL_HDR_INIT;
+	set_bit(XMSTATE_BIT_SOL_HDR_INIT, &tcp_ctask->xmstate);
 	list_move_tail(&ctask->running, &conn->xmitqueue);
 
 	scsi_queue_work(session->host, &conn->xmitwork);
@@ -1257,7 +1257,7 @@ static void iscsi_set_padding(struct isc
 
 	tcp_ctask->pad_count = ISCSI_PAD_LEN - tcp_ctask->pad_count;
 	debug_scsi("write padding %d bytes\n", tcp_ctask->pad_count);
-	tcp_ctask->xmstate |= XMSTATE_W_PAD;
+	set_bit(XMSTATE_BIT_W_PAD, &tcp_ctask->xmstate);
 }
 
 /**
@@ -1272,7 +1272,7 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
 	BUG_ON(__kfifo_len(tcp_ctask->r2tqueue));
-	tcp_ctask->xmstate = XMSTATE_CMD_HDR_INIT;
+	tcp_ctask->xmstate = 1 << XMSTATE_BIT_CMD_HDR_INIT;
 }
 
 /**
@@ -1286,10 +1286,10 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
  *	xmit.
  *
  *	Management xmit state machine consists of these states:
- *		XMSTATE_IMM_HDR_INIT	- calculate digest of PDU Header
- *		XMSTATE_IMM_HDR 	- PDU Header xmit in progress
- *		XMSTATE_IMM_DATA 	- PDU Data xmit in progress
- *		XMSTATE_IDLE		- management PDU is done
+ *		XMSTATE_BIT_IMM_HDR_INIT - calculate digest of PDU Header
+ *		XMSTATE_BIT_IMM_HDR      - PDU Header xmit in progress
+ *		XMSTATE_BIT_IMM_DATA     - PDU Data xmit in progress
+ *		XMSTATE_VALUE_IDLE       - management PDU is done
  **/
 static int
 iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
@@ -1300,12 +1300,12 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *
 	debug_scsi("mtask deq [cid %d state %x itt 0x%x]\n",
 		conn->id, tcp_mtask->xmstate, mtask->itt);
 
-	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR_INIT) {
+	if (test_bit(XMSTATE_BIT_IMM_HDR_INIT, &tcp_mtask->xmstate)) {
 		iscsi_buf_init_iov(&tcp_mtask->headbuf, (char*)mtask->hdr,
 				   sizeof(struct iscsi_hdr));
 
 		if (mtask->data_count) {
-			tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
+			set_bit(XMSTATE_BIT_IMM_DATA, &tcp_mtask->xmstate);
 			iscsi_buf_init_iov(&tcp_mtask->sendbuf,
 					   (char*)mtask->data,
 					   mtask->data_count);
@@ -1318,21 +1318,20 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *
 					(u8*)tcp_mtask->hdrext);
 
 		tcp_mtask->sent = 0;
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR_INIT;
-		tcp_mtask->xmstate |= XMSTATE_IMM_HDR;
+		clear_bit(XMSTATE_BIT_IMM_HDR_INIT, &tcp_mtask->xmstate);
+		set_bit(XMSTATE_BIT_IMM_HDR, &tcp_mtask->xmstate);
 	}
 
-	if (tcp_mtask->xmstate & XMSTATE_IMM_HDR) {
+	if (test_bit(XMSTATE_BIT_IMM_HDR, &tcp_mtask->xmstate)) {
 		rc = iscsi_sendhdr(conn, &tcp_mtask->headbuf,
 				   mtask->data_count);
 		if (rc)
 			return rc;
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_HDR;
+		clear_bit(XMSTATE_BIT_IMM_HDR, &tcp_mtask->xmstate);
 	}
 
-	if (tcp_mtask->xmstate & XMSTATE_IMM_DATA) {
+	if (test_and_clear_bit(XMSTATE_BIT_IMM_DATA, &tcp_mtask->xmstate)) {
 		BUG_ON(!mtask->data_count);
-		tcp_mtask->xmstate &= ~XMSTATE_IMM_DATA;
 		/* FIXME: implement.
 		 * Virtual buffer could be spreaded across multiple pages...
 		 */
@@ -1342,13 +1341,13 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *
 			rc = iscsi_sendpage(conn, &tcp_mtask->sendbuf,
 					&mtask->data_count, &tcp_mtask->sent);
 			if (rc) {
-				tcp_mtask->xmstate |= XMSTATE_IMM_DATA;
+				set_bit(XMSTATE_BIT_IMM_DATA, &tcp_mtask->xmstate);
 				return rc;
 			}
 		} while (mtask->data_count);
 	}
 
-	BUG_ON(tcp_mtask->xmstate != XMSTATE_IDLE);
+	BUG_ON(tcp_mtask->xmstate != XMSTATE_VALUE_IDLE);
 	if (mtask->hdr->itt == RESERVED_ITT) {
 		struct iscsi_session *session = conn->session;
 
@@ -1368,7 +1367,7 @@ iscsi_send_cmd_hdr(struct iscsi_conn *co
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	int rc = 0;
 
-	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_INIT) {
+	if (test_bit(XMSTATE_BIT_CMD_HDR_INIT, &tcp_ctask->xmstate)) {
 		tcp_ctask->sent = 0;
 		tcp_ctask->sg_count = 0;
 		tcp_ctask->exp_datasn = 0;
@@ -1393,21 +1392,21 @@ iscsi_send_cmd_hdr(struct iscsi_conn *co
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 					 (u8*)tcp_ctask->hdrext);
-		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_INIT;
-		tcp_ctask->xmstate |= XMSTATE_CMD_HDR_XMIT;
+		clear_bit(XMSTATE_BIT_CMD_HDR_INIT, &tcp_ctask->xmstate);
+		set_bit(XMSTATE_BIT_CMD_HDR_XMIT, &tcp_ctask->xmstate);
 	}
 
-	if (tcp_ctask->xmstate & XMSTATE_CMD_HDR_XMIT) {
+	if (test_bit(XMSTATE_BIT_CMD_HDR_XMIT, &tcp_ctask->xmstate)) {
 		rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->imm_count);
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_XMIT;
+		clear_bit(XMSTATE_BIT_CMD_HDR_XMIT, &tcp_ctask->xmstate);
 
 		if (sc->sc_data_direction != DMA_TO_DEVICE)
 			return 0;
 
 		if (ctask->imm_count) {
-			tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
+			set_bit(XMSTATE_BIT_IMM_DATA, &tcp_ctask->xmstate);
 			iscsi_set_padding(tcp_ctask, ctask->imm_count);
 
 			if (ctask->conn->datadgst_en) {
@@ -1417,9 +1416,10 @@ iscsi_send_cmd_hdr(struct iscsi_conn *co
 			}
 		}
 
-		if (ctask->unsol_count)
-			tcp_ctask->xmstate |=
-					XMSTATE_UNS_HDR | XMSTATE_UNS_INIT;
+		if (ctask->unsol_count) {
+			set_bit(XMSTATE_BIT_UNS_HDR, &tcp_ctask->xmstate);
+			set_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate);
+		}
 	}
 	return rc;
 }
@@ -1431,25 +1431,25 @@ iscsi_send_padding(struct iscsi_conn *co
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	int sent = 0, rc;
 
-	if (tcp_ctask->xmstate & XMSTATE_W_PAD) {
+	if (test_bit(XMSTATE_BIT_W_PAD, &tcp_ctask->xmstate)) {
 		iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
 				   tcp_ctask->pad_count);
 		if (conn->datadgst_en)
 			crypto_hash_update(&tcp_conn->tx_hash,
 					   &tcp_ctask->sendbuf.sg,
 					   tcp_ctask->sendbuf.sg.length);
-	} else if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_PAD))
+	} else if (!test_bit(XMSTATE_BIT_W_RESEND_PAD, &tcp_ctask->xmstate))
 		return 0;
 
-	tcp_ctask->xmstate &= ~XMSTATE_W_PAD;
-	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_PAD;
+	clear_bit(XMSTATE_BIT_W_PAD, &tcp_ctask->xmstate);
+	clear_bit(XMSTATE_BIT_W_RESEND_PAD, &tcp_ctask->xmstate);
 	debug_scsi("sending %d pad bytes for itt 0x%x\n",
 		   tcp_ctask->pad_count, ctask->itt);
 	rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf, &tcp_ctask->pad_count,
 			   &sent);
 	if (rc) {
 		debug_scsi("padding send failed %d\n", rc);
-		tcp_ctask->xmstate |= XMSTATE_W_RESEND_PAD;
+		set_bit(XMSTATE_BIT_W_RESEND_PAD, &tcp_ctask->xmstate);
 	}
 	return rc;
 }
@@ -1468,11 +1468,11 @@ iscsi_send_digest(struct iscsi_conn *con
 	tcp_ctask = ctask->dd_data;
 	tcp_conn = conn->dd_data;
 
-	if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_DATA_DIGEST)) {
+	if (!test_bit(XMSTATE_BIT_W_RESEND_DATA_DIGEST, &tcp_ctask->xmstate)) {
 		crypto_hash_final(&tcp_conn->tx_hash, (u8*)digest);
 		iscsi_buf_init_iov(buf, (char*)digest, 4);
 	}
-	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_DATA_DIGEST;
+	clear_bit(XMSTATE_BIT_W_RESEND_DATA_DIGEST, &tcp_ctask->xmstate);
 
 	rc = iscsi_sendpage(conn, buf, &tcp_ctask->digest_count, &sent);
 	if (!rc)
@@ -1481,7 +1481,7 @@ iscsi_send_digest(struct iscsi_conn *con
 	else {
 		debug_scsi("sending digest 0x%x failed for itt 0x%x!\n",
 			  *digest, ctask->itt);
-		tcp_ctask->xmstate |= XMSTATE_W_RESEND_DATA_DIGEST;
+		set_bit(XMSTATE_BIT_W_RESEND_DATA_DIGEST, &tcp_ctask->xmstate);
 	}
 	return rc;
 }
@@ -1529,8 +1529,8 @@ iscsi_send_unsol_hdr(struct iscsi_conn *
 	struct iscsi_data_task *dtask;
 	int rc;
 
-	tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
-	if (tcp_ctask->xmstate & XMSTATE_UNS_INIT) {
+	set_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate);
+	if (test_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate)) {
 		dtask = &tcp_ctask->unsol_dtask;
 
 		iscsi_prep_unsolicit_data_pdu(ctask, &dtask->hdr);
@@ -1540,14 +1540,14 @@ iscsi_send_unsol_hdr(struct iscsi_conn *
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 					(u8*)dtask->hdrext);
 
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_INIT;
+		clear_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate);
 		iscsi_set_padding(tcp_ctask, ctask->data_count);
 	}
 
 	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->data_count);
 	if (rc) {
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
-		tcp_ctask->xmstate |= XMSTATE_UNS_HDR;
+		clear_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate);
+		set_bit(XMSTATE_BIT_UNS_HDR, &tcp_ctask->xmstate);
 		return rc;
 	}
 
@@ -1568,16 +1568,15 @@ iscsi_send_unsol_pdu(struct iscsi_conn *
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	int rc;
 
-	if (tcp_ctask->xmstate & XMSTATE_UNS_HDR) {
+	if (test_and_clear_bit(XMSTATE_BIT_UNS_HDR, &tcp_ctask->xmstate)) {
 		BUG_ON(!ctask->unsol_count);
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_HDR;
 send_hdr:
 		rc = iscsi_send_unsol_hdr(conn, ctask);
 		if (rc)
 			return rc;
 	}
 
-	if (tcp_ctask->xmstate & XMSTATE_UNS_DATA) {
+	if (test_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate)) {
 		struct iscsi_data_task *dtask = &tcp_ctask->unsol_dtask;
 		int start = tcp_ctask->sent;
 
@@ -1587,14 +1586,14 @@ send_hdr:
 		ctask->unsol_count -= tcp_ctask->sent - start;
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
+		clear_bit(XMSTATE_BIT_UNS_DATA, &tcp_ctask->xmstate);
 		/*
 		 * Done with the Data-Out. Next, check if we need
 		 * to send another unsolicited Data-Out.
 		 */
 		if (ctask->unsol_count) {
 			debug_scsi("sending more uns\n");
-			tcp_ctask->xmstate |= XMSTATE_UNS_INIT;
+			set_bit(XMSTATE_BIT_UNS_INIT, &tcp_ctask->xmstate);
 			goto send_hdr;
 		}
 	}
@@ -1610,7 +1609,7 @@ static int iscsi_send_sol_pdu(struct isc
 	struct iscsi_data_task *dtask;
 	int left, rc;
 
-	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR_INIT) {
+	if (test_bit(XMSTATE_BIT_SOL_HDR_INIT, &tcp_ctask->xmstate)) {
 		if (!tcp_ctask->r2t) {
 			spin_lock_bh(&session->lock);
 			__kfifo_get(tcp_ctask->r2tqueue, (void*)&tcp_ctask->r2t,
@@ -1624,19 +1623,19 @@ send_hdr:
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &r2t->headbuf,
 					(u8*)dtask->hdrext);
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR_INIT;
-		tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
+		clear_bit(XMSTATE_BIT_SOL_HDR_INIT, &tcp_ctask->xmstate);
+		set_bit(XMSTATE_BIT_SOL_HDR, &tcp_ctask->xmstate);
 	}
 
-	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR) {
+	if (test_bit(XMSTATE_BIT_SOL_HDR, &tcp_ctask->xmstate)) {
 		r2t = tcp_ctask->r2t;
 		dtask = &r2t->dtask;
 
 		rc = iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count);
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
-		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
+		clear_bit(XMSTATE_BIT_SOL_HDR, &tcp_ctask->xmstate);
+		set_bit(XMSTATE_BIT_SOL_DATA, &tcp_ctask->xmstate);
 
 		if (conn->datadgst_en) {
 			iscsi_data_digest_init(conn->dd_data, tcp_ctask);
@@ -1649,7 +1648,7 @@ send_hdr:
 			r2t->sent);
 	}
 
-	if (tcp_ctask->xmstate & XMSTATE_SOL_DATA) {
+	if (test_bit(XMSTATE_BIT_SOL_DATA, &tcp_ctask->xmstate)) {
 		r2t = tcp_ctask->r2t;
 		dtask = &r2t->dtask;
 
@@ -1658,7 +1657,7 @@ send_hdr:
 				     &dtask->digestbuf, &dtask->digest);
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
+		clear_bit(XMSTATE_BIT_SOL_DATA, &tcp_ctask->xmstate);
 
 		/*
 		 * Done with this Data-Out. Next, check if we have
@@ -1703,32 +1702,32 @@ send_hdr:
  *	xmit stages.
  *
  *iscsi_send_cmd_hdr()
- *	XMSTATE_CMD_HDR_INIT - prepare Header and Data buffers Calculate
- *	                       Header Digest
- *	XMSTATE_CMD_HDR_XMIT - Transmit header in progress
+ *	XMSTATE_BIT_CMD_HDR_INIT - prepare Header and Data buffers Calculate
+ *	                           Header Digest
+ *	XMSTATE_BIT_CMD_HDR_XMIT - Transmit header in progress
  *
  *iscsi_send_padding
- *	XMSTATE_W_PAD        - Prepare and send pading
- *	XMSTATE_W_RESEND_PAD - retry send pading
+ *	XMSTATE_BIT_W_PAD        - Prepare and send pading
+ *	XMSTATE_BIT_W_RESEND_PAD - retry send pading
  *
  *iscsi_send_digest
- *	XMSTATE_W_RESEND_DATA_DIGEST - Finalize and send Data Digest
- *	XMSTATE_W_RESEND_DATA_DIGEST - retry sending digest
+ *	XMSTATE_BIT_W_RESEND_DATA_DIGEST - Finalize and send Data Digest
+ *	XMSTATE_BIT_W_RESEND_DATA_DIGEST - retry sending digest
  *
  *iscsi_send_unsol_hdr
- *	XMSTATE_UNS_INIT     - prepare un-solicit data header and digest
- *	XMSTATE_UNS_HDR      - send un-solicit header
+ *	XMSTATE_BIT_UNS_INIT     - prepare un-solicit data header and digest
+ *	XMSTATE_BIT_UNS_HDR      - send un-solicit header
  *
  *iscsi_send_unsol_pdu
- *	XMSTATE_UNS_DATA     - send un-solicit data in progress
+ *	XMSTATE_BIT_UNS_DATA     - send un-solicit data in progress
  *
  *iscsi_send_sol_pdu
- *	XMSTATE_SOL_HDR_INIT - solicit data header and digest initialize
- *	XMSTATE_SOL_HDR      - send solicit header
- *	XMSTATE_SOL_DATA     - send solicit data
+ *	XMSTATE_BIT_SOL_HDR_INIT - solicit data header and digest initialize
+ *	XMSTATE_BIT_SOL_HDR      - send solicit header
+ *	XMSTATE_BIT_SOL_DATA     - send solicit data
  *
  *iscsi_tcp_ctask_xmit
- *	XMSTATE_IMM_DATA     - xmit managment data (??)
+ *	XMSTATE_BIT_IMM_DATA     - xmit managment data (??)
  **/
 static int
 iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
@@ -1745,13 +1744,13 @@ iscsi_tcp_ctask_xmit(struct iscsi_conn *
 	if (ctask->sc->sc_data_direction != DMA_TO_DEVICE)
 		return 0;
 
-	if (tcp_ctask->xmstate & XMSTATE_IMM_DATA) {
+	if (test_bit(XMSTATE_BIT_IMM_DATA, &tcp_ctask->xmstate)) {
 		rc = iscsi_send_data(ctask, &tcp_ctask->sendbuf, &tcp_ctask->sg,
 				     &tcp_ctask->sent, &ctask->imm_count,
 				     &tcp_ctask->immbuf, &tcp_ctask->immdigest);
 		if (rc)
 			return rc;
-		tcp_ctask->xmstate &= ~XMSTATE_IMM_DATA;
+		clear_bit(XMSTATE_BIT_IMM_DATA, &tcp_ctask->xmstate);
 	}
 
 	rc = iscsi_send_unsol_pdu(conn, ctask);
@@ -1984,7 +1983,7 @@ static void
 iscsi_tcp_mgmt_init(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 {
 	struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
-	tcp_mtask->xmstate = XMSTATE_IMM_HDR_INIT;
+	tcp_mtask->xmstate = 1 << XMSTATE_BIT_IMM_HDR_INIT;
 }
 
 static int
diff -urpN linux-2.6.24-rc1/drivers/scsi/iscsi_tcp.h linux-2.6.24-rc1-iscsi/drivers/scsi/iscsi_tcp.h
--- linux-2.6.24-rc1/drivers/scsi/iscsi_tcp.h	2007-10-09 16:31:38.000000000 -0400
+++ linux-2.6.24-rc1-iscsi/drivers/scsi/iscsi_tcp.h	2007-10-25 14:51:24.000000000 -0400
@@ -32,21 +32,21 @@
 #define IN_PROGRESS_PAD_RECV		0x4
 
 /* xmit state machine */
-#define XMSTATE_IDLE			0x0
-#define XMSTATE_CMD_HDR_INIT		0x1
-#define XMSTATE_CMD_HDR_XMIT		0x2
-#define XMSTATE_IMM_HDR			0x4
-#define XMSTATE_IMM_DATA		0x8
-#define XMSTATE_UNS_INIT		0x10
-#define XMSTATE_UNS_HDR			0x20
-#define XMSTATE_UNS_DATA		0x40
-#define XMSTATE_SOL_HDR			0x80
-#define XMSTATE_SOL_DATA		0x100
-#define XMSTATE_W_PAD			0x200
-#define XMSTATE_W_RESEND_PAD		0x400
-#define XMSTATE_W_RESEND_DATA_DIGEST	0x800
-#define XMSTATE_IMM_HDR_INIT		0x1000
-#define XMSTATE_SOL_HDR_INIT		0x2000
+#define XMSTATE_VALUE_IDLE			0
+#define XMSTATE_BIT_CMD_HDR_INIT		0
+#define XMSTATE_BIT_CMD_HDR_XMIT		1
+#define XMSTATE_BIT_IMM_HDR			2
+#define XMSTATE_BIT_IMM_DATA			3
+#define XMSTATE_BIT_UNS_INIT			4
+#define XMSTATE_BIT_UNS_HDR			5
+#define XMSTATE_BIT_UNS_DATA			6
+#define XMSTATE_BIT_SOL_HDR			7
+#define XMSTATE_BIT_SOL_DATA			8
+#define XMSTATE_BIT_W_PAD			9
+#define XMSTATE_BIT_W_RESEND_PAD		10
+#define XMSTATE_BIT_W_RESEND_DATA_DIGEST	11
+#define XMSTATE_BIT_IMM_HDR_INIT		12
+#define XMSTATE_BIT_SOL_HDR_INIT		13
 
 #define ISCSI_PAD_LEN			4
 #define ISCSI_SG_TABLESIZE		SG_ALL
@@ -122,7 +122,7 @@ struct iscsi_data_task {
 struct iscsi_tcp_mgmt_task {
 	struct iscsi_hdr	hdr;
 	char			hdrext[sizeof(__u32)]; /* Header-Digest */
-	int			xmstate;	/* mgmt xmit progress */
+	unsigned long		xmstate;	/* mgmt xmit progress */
 	struct iscsi_buf	headbuf;	/* header buffer */
 	struct iscsi_buf	sendbuf;	/* in progress buffer */
 	int			sent;
@@ -150,7 +150,7 @@ struct iscsi_tcp_cmd_task {
 	int			pad_count;		/* padded bytes */
 	struct iscsi_buf	headbuf;		/* header buf (xmit) */
 	struct iscsi_buf	sendbuf;		/* in progress buffer*/
-	int			xmstate;		/* xmit xtate machine */
+	unsigned long		xmstate;		/* xmit xtate machine */
 	int			sent;
 	struct scatterlist	*sg;			/* per-cmd SG list  */
 	struct scatterlist	*bad_sg;		/* assert statement */


