From: michaelc@cs.wisc.edu
Subject: [PATCH 4/12] iscsi_tcp: fix padding, data digests, and IO at weird offsets
Date: Thu, 31 Aug 2006 18:09:27 -0400
Message-ID: <11570621801879-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu> <11570621791237-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28294 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932413AbWHaXJZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:25 -0400
In-Reply-To: <11570621791237-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_tcp calculates padding by using the expected transfer length. This
has the problem where if we have immediate data = no and initial R2T =
yes, and the transfer length ended up needing padding then we send:

1. header
2. padding which should have gone after data
3. data

Besides this bug, we also assume the target will always ask for nice
transfer lengths and the first burst length will always be a nice value.
As far as I can tell form the RFC this is not a requirement. It would be
silly to do this, but if someone did it we will end doing bad things.

Finally the last bug in that bit of code is in our handling of the
recalculation of data digests when we do not send a whole iscsi_buf in
one try. The bug here is that we call crypto_digest_final on a
iscsi_sendpage error, then when we send the rest of the iscsi_buf, we
doiscsi_data_digest_init and this causes the previous data digest to be
lost.

And to make matters worse, some of these bugs are replicated over and
over and over again for immediate data, solicited data and unsolicited
data. So the attached patch made over the iscsi git tree (see
kernel.org/git for details) which I updated today to include the patches
I said I merged, consolidates the sending of data, padding and digests
and calculation of data digests and fixes the above bugs.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |  636 +++++++++++++++++-----------------------------
 drivers/scsi/iscsi_tcp.h |   33 +-
 drivers/scsi/libiscsi.c  |   37 ++-
 3 files changed, 286 insertions(+), 420 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 668f18c..2ebe8d6 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -281,7 +281,6 @@ iscsi_solicit_data_init(struct iscsi_con
 {
 	struct iscsi_data *hdr;
 	struct scsi_cmnd *sc = ctask->sc;
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
 	hdr = &r2t->dtask.hdr;
 	memset(hdr, 0, sizeof(struct iscsi_data));
@@ -336,10 +335,12 @@ iscsi_solicit_data_init(struct iscsi_con
 			sg_count += sg->length;
 		}
 		BUG_ON(r2t->sg == NULL);
-	} else
-		iscsi_buf_init_iov(&tcp_ctask->sendbuf,
+	} else {
+		iscsi_buf_init_iov(&r2t->sendbuf,
 			    (char*)sc->request_buffer + r2t->data_offset,
 			    r2t->data_count);
+		r2t->sg = NULL;
+	}
 }
 
 /**
@@ -503,7 +504,6 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *co
 			goto copy_hdr;
 
 		spin_lock(&session->lock);
-		iscsi_tcp_cleanup_ctask(conn, tcp_conn->in.ctask);
 		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
 		spin_unlock(&session->lock);
 		break;
@@ -676,15 +676,15 @@ iscsi_tcp_copy(struct iscsi_conn *conn)
 }
 
 static inline void
-partial_sg_digest_update(struct iscsi_tcp_conn *tcp_conn,
-			 struct scatterlist *sg, int offset, int length)
+partial_sg_digest_update(struct crypto_tfm *tfm, struct scatterlist *sg,
+			 int offset, int length)
 {
 	struct scatterlist temp;
 
 	memcpy(&temp, sg, sizeof(struct scatterlist));
 	temp.offset = offset;
 	temp.length = length;
-	crypto_digest_update(tcp_conn->data_rx_tfm, &temp, 1);
+	crypto_digest_update(tfm, &temp, 1);
 }
 
 static void
@@ -751,7 +751,8 @@ static int iscsi_scsi_data_in(struct isc
 							tcp_conn->data_rx_tfm,
 							&sg[i], 1);
 				else
-					partial_sg_digest_update(tcp_conn,
+					partial_sg_digest_update(
+							tcp_conn->data_rx_tfm,
 							&sg[i],
 							sg[i].offset + offset,
 							sg[i].length - offset);
@@ -765,7 +766,8 @@ static int iscsi_scsi_data_in(struct isc
 				/*
 				 * data-in is complete, but buffer not...
 				 */
-				partial_sg_digest_update(tcp_conn, &sg[i],
+				partial_sg_digest_update(tcp_conn->data_rx_tfm,
+						&sg[i],
 						sg[i].offset, sg[i].length-rc);
 			rc = 0;
 			break;
@@ -783,7 +785,6 @@ done:
 			   (long)sc, sc->result, ctask->itt,
 			   tcp_conn->in.hdr->flags);
 		spin_lock(&conn->session->lock);
-		iscsi_tcp_cleanup_ctask(conn, ctask);
 		__iscsi_complete_pdu(conn, tcp_conn->in.hdr, NULL, 0);
 		spin_unlock(&conn->session->lock);
 	}
@@ -803,9 +804,6 @@ iscsi_data_recv(struct iscsi_conn *conn)
 		rc = iscsi_scsi_data_in(conn);
 		break;
 	case ISCSI_OP_SCSI_CMD_RSP:
-		spin_lock(&conn->session->lock);
-		iscsi_tcp_cleanup_ctask(conn, tcp_conn->in.ctask);
-		spin_unlock(&conn->session->lock);
 	case ISCSI_OP_TEXT_RSP:
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_ASYNC_EVENT:
@@ -1188,37 +1186,12 @@ iscsi_sendpage(struct iscsi_conn *conn, 
 
 static inline void
 iscsi_data_digest_init(struct iscsi_tcp_conn *tcp_conn,
-		      struct iscsi_cmd_task *ctask)
+		      struct iscsi_tcp_cmd_task *tcp_ctask)
 {
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-
-	BUG_ON(!tcp_conn->data_tx_tfm);
 	crypto_digest_init(tcp_conn->data_tx_tfm);
 	tcp_ctask->digest_count = 4;
 }
 
-static int
-iscsi_digest_final_send(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
-			struct iscsi_buf *buf, uint32_t *digest, int final)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	int rc = 0;
-	int sent = 0;
-
-	if (final)
-		crypto_digest_final(tcp_conn->data_tx_tfm, (u8*)digest);
-
-	iscsi_buf_init_iov(buf, (char*)digest, 4);
-	rc = iscsi_sendpage(conn, buf, &tcp_ctask->digest_count, &sent);
-	if (rc) {
-		tcp_ctask->datadigest = *digest;
-		tcp_ctask->xmstate |= XMSTATE_DATA_DIGEST;
-	} else
-		tcp_ctask->digest_count = 4;
-	return rc;
-}
-
 /**
  * iscsi_solicit_data_cont - initialize next Data-Out
  * @conn: iscsi connection
@@ -1236,7 +1209,6 @@ static void
 iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 			struct iscsi_r2t_info *r2t, int left)
 {
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_data *hdr;
 	struct scsi_cmnd *sc = ctask->sc;
 	int new_offset;
@@ -1265,14 +1237,30 @@ iscsi_solicit_data_cont(struct iscsi_con
 	iscsi_buf_init_iov(&r2t->headbuf, (char*)hdr,
 			   sizeof(struct iscsi_hdr));
 
-	if (sc->use_sg && !iscsi_buf_left(&r2t->sendbuf)) {
-		BUG_ON(tcp_ctask->bad_sg == r2t->sg);
+	if (iscsi_buf_left(&r2t->sendbuf))
+		return;
+
+	if (sc->use_sg) {
 		iscsi_buf_init_sg(&r2t->sendbuf, r2t->sg);
 		r2t->sg += 1;
-	} else
-		iscsi_buf_init_iov(&tcp_ctask->sendbuf,
+	} else {
+		iscsi_buf_init_iov(&r2t->sendbuf,
 			    (char*)sc->request_buffer + new_offset,
 			    r2t->data_count);
+		r2t->sg = NULL;
+	}
+}
+
+static void iscsi_set_padding(struct iscsi_tcp_cmd_task *tcp_ctask,
+			      unsigned long len)
+{
+	tcp_ctask->pad_count = len & (ISCSI_PAD_LEN - 1);
+	if (!tcp_ctask->pad_count)
+		return;
+
+	tcp_ctask->pad_count = ISCSI_PAD_LEN - tcp_ctask->pad_count;
+	debug_scsi("write padding %d bytes\n", tcp_ctask->pad_count);
+	tcp_ctask->xmstate |= XMSTATE_W_PAD;
 }
 
 /**
@@ -1300,31 +1288,16 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
 		if (sc->use_sg) {
 			struct scatterlist *sg = sc->request_buffer;
 
-			iscsi_buf_init_sg(&tcp_ctask->sendbuf,
-					  &sg[tcp_ctask->sg_count++]);
-			tcp_ctask->sg = sg;
+			iscsi_buf_init_sg(&tcp_ctask->sendbuf, sg);
+			tcp_ctask->sg = sg + 1;
 			tcp_ctask->bad_sg = sg + sc->use_sg;
-		} else
+		} else {
 			iscsi_buf_init_iov(&tcp_ctask->sendbuf,
 					   sc->request_buffer,
 					   sc->request_bufflen);
-
-		if (ctask->imm_count)
-			tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
-
-		tcp_ctask->pad_count = ctask->total_length & (ISCSI_PAD_LEN-1);
-		if (tcp_ctask->pad_count) {
-			tcp_ctask->pad_count = ISCSI_PAD_LEN -
-							tcp_ctask->pad_count;
-			debug_scsi("write padding %d bytes\n",
-				   tcp_ctask->pad_count);
-			tcp_ctask->xmstate |= XMSTATE_W_PAD;
+			tcp_ctask->sg = NULL;
+			tcp_ctask->bad_sg = NULL;
 		}
-
-		if (ctask->unsol_count)
-			tcp_ctask->xmstate |= XMSTATE_UNS_HDR |
-						XMSTATE_UNS_INIT;
-
 		debug_scsi("cmd [itt 0x%x total %d imm_data %d "
 			   "unsol count %d, unsol offset %d]\n",
 			   ctask->itt, ctask->total_length, ctask->imm_count,
@@ -1410,8 +1383,8 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *
 }
 
 static inline int
-handle_xmstate_r_hdr(struct iscsi_conn *conn,
-		     struct iscsi_tcp_cmd_task *tcp_ctask)
+iscsi_send_read_hdr(struct iscsi_conn *conn,
+		    struct iscsi_tcp_cmd_task *tcp_ctask)
 {
 	int rc;
 
@@ -1429,7 +1402,7 @@ handle_xmstate_r_hdr(struct iscsi_conn *
 }
 
 static inline int
-handle_xmstate_w_hdr(struct iscsi_conn *conn,
+iscsi_send_write_hdr(struct iscsi_conn *conn,
 		     struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
@@ -1440,85 +1413,125 @@ handle_xmstate_w_hdr(struct iscsi_conn *
 		iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 				 (u8*)tcp_ctask->hdrext);
 	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->imm_count);
-	if (rc)
+	if (rc) {
 		tcp_ctask->xmstate |= XMSTATE_W_HDR;
-	return rc;
+		return rc;
+	}
+
+	if (ctask->imm_count) {
+		tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
+		iscsi_set_padding(tcp_ctask, ctask->imm_count);
+
+		if (ctask->conn->datadgst_en) {
+			iscsi_data_digest_init(ctask->conn->dd_data, tcp_ctask);
+			tcp_ctask->immdigest = 0;
+		}
+	}
+
+	if (ctask->unsol_count)
+		tcp_ctask->xmstate |= XMSTATE_UNS_HDR | XMSTATE_UNS_INIT;
+	return 0;
 }
 
-static inline int
-handle_xmstate_data_digest(struct iscsi_conn *conn,
-			   struct iscsi_cmd_task *ctask)
+static int
+iscsi_send_padding(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	int rc;
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	int sent = 0, rc;
 
-	tcp_ctask->xmstate &= ~XMSTATE_DATA_DIGEST;
-	debug_tcp("resent data digest 0x%x\n", tcp_ctask->datadigest);
-	rc = iscsi_digest_final_send(conn, ctask, &tcp_ctask->immbuf,
-				    &tcp_ctask->datadigest, 0);
+	if (tcp_ctask->xmstate & XMSTATE_W_PAD) {
+		iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
+				   tcp_ctask->pad_count);
+		if (conn->datadgst_en)
+			crypto_digest_update(tcp_conn->data_tx_tfm,
+					     &tcp_ctask->sendbuf.sg, 1);
+	} else if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_PAD))
+		return 0;
+
+	tcp_ctask->xmstate &= ~XMSTATE_W_PAD;
+	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_PAD;
+	debug_scsi("sending %d pad bytes for itt 0x%x\n",
+		   tcp_ctask->pad_count, ctask->itt); 
+	rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf, &tcp_ctask->pad_count,
+			   &sent);
 	if (rc) {
-		tcp_ctask->xmstate |= XMSTATE_DATA_DIGEST;
-		debug_tcp("resent data digest 0x%x fail!\n",
-			  tcp_ctask->datadigest);
+		debug_scsi("padding send failed %d\n", rc);
+		tcp_ctask->xmstate |= XMSTATE_W_RESEND_PAD;
 	}
-
 	return rc;
 }
 
-static inline int
-handle_xmstate_imm_data(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+static int
+iscsi_send_digest(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
+			struct iscsi_buf *buf, uint32_t *digest)
 {
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	int rc;
+	struct iscsi_tcp_cmd_task *tcp_ctask;
+	struct iscsi_tcp_conn *tcp_conn;
+	int rc, sent = 0;
+
+	if (!conn->datadgst_en)
+		return 0;
 
-	BUG_ON(!ctask->imm_count);
-	tcp_ctask->xmstate &= ~XMSTATE_IMM_DATA;
+	tcp_ctask = ctask->dd_data;
+	tcp_conn = conn->dd_data;
 
-	if (conn->datadgst_en) {
-		iscsi_data_digest_init(tcp_conn, ctask);
-		tcp_ctask->immdigest = 0;
+	if (!(tcp_ctask->xmstate & XMSTATE_W_RESEND_DATA_DIGEST)) {
+		crypto_digest_final(tcp_conn->data_tx_tfm, (u8*)digest);
+		iscsi_buf_init_iov(buf, (char*)digest, 4);
+	}
+	tcp_ctask->xmstate &= ~XMSTATE_W_RESEND_DATA_DIGEST;
+	
+	rc = iscsi_sendpage(conn, buf, &tcp_ctask->digest_count, &sent);
+	if (!rc)
+		debug_scsi("sent digest 0x%x for itt 0x%x\n", *digest,
+			  ctask->itt);
+	else {
+		debug_scsi("sending digest 0x%x failed for itt 0x%x!\n",
+			  *digest, ctask->itt);
+		tcp_ctask->xmstate |= XMSTATE_W_RESEND_DATA_DIGEST;
 	}
+	return rc;
+}
 
-	for (;;) {
-		rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf,
-				   &ctask->imm_count, &tcp_ctask->sent);
-		if (rc) {
-			tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
-			if (conn->datadgst_en) {
-				crypto_digest_final(tcp_conn->data_tx_tfm,
-						(u8*)&tcp_ctask->immdigest);
-				debug_tcp("tx imm sendpage fail 0x%x\n",
-					  tcp_ctask->datadigest);
-			}
-			return rc;
+static int
+iscsi_send_data(struct iscsi_cmd_task *ctask, struct iscsi_buf *sendbuf,
+		struct scatterlist **sg, int *sent, int *count,
+		struct iscsi_buf *digestbuf, uint32_t *digest)
+{
+	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
+	struct iscsi_conn *conn = ctask->conn;
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	int rc, buf_sent, offset;
+
+	while (*count) {
+		buf_sent = 0;
+		offset = sendbuf->sent;
+
+		rc = iscsi_sendpage(conn, sendbuf, count, &buf_sent);
+		*sent = *sent + buf_sent;
+		if (buf_sent && conn->datadgst_en)
+			partial_sg_digest_update(tcp_conn->data_tx_tfm,
+				&sendbuf->sg, sendbuf->sg.offset + offset,
+				buf_sent);
+		if (!iscsi_buf_left(sendbuf) && *sg != tcp_ctask->bad_sg) {
+			iscsi_buf_init_sg(sendbuf, *sg);
+			*sg = *sg + 1;
 		}
-		if (conn->datadgst_en)
-			crypto_digest_update(tcp_conn->data_tx_tfm,
-					     &tcp_ctask->sendbuf.sg, 1);
 
-		if (!ctask->imm_count)
-			break;
-		iscsi_buf_init_sg(&tcp_ctask->sendbuf,
-				  &tcp_ctask->sg[tcp_ctask->sg_count++]);
-	}
-
-	if (conn->datadgst_en && !(tcp_ctask->xmstate & XMSTATE_W_PAD)) {
-		rc = iscsi_digest_final_send(conn, ctask, &tcp_ctask->immbuf,
-				            &tcp_ctask->immdigest, 1);
-		if (rc) {
-			debug_tcp("sending imm digest 0x%x fail!\n",
-				  tcp_ctask->immdigest);
+		if (rc)
 			return rc;
-		}
-		debug_tcp("sending imm digest 0x%x\n", tcp_ctask->immdigest);
 	}
 
-	return 0;
+	rc = iscsi_send_padding(conn, ctask);
+	if (rc)
+		return rc;
+
+	return iscsi_send_digest(conn, ctask, digestbuf, digest);
 }
 
-static inline int
-handle_xmstate_uns_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+static int
+iscsi_send_unsol_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_data_task *dtask;
@@ -1526,14 +1539,21 @@ handle_xmstate_uns_hdr(struct iscsi_conn
 
 	tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
 	if (tcp_ctask->xmstate & XMSTATE_UNS_INIT) {
-		dtask = tcp_ctask->dtask = &tcp_ctask->unsol_dtask;
+		dtask = &tcp_ctask->unsol_dtask;
+
 		iscsi_prep_unsolicit_data_pdu(ctask, &dtask->hdr);
 		iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)&dtask->hdr,
 				   sizeof(struct iscsi_hdr));
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 					(u8*)dtask->hdrext);
+		if (conn->datadgst_en) {
+			iscsi_data_digest_init(ctask->conn->dd_data, tcp_ctask);
+			dtask->digest = 0;
+		}
+
 		tcp_ctask->xmstate &= ~XMSTATE_UNS_INIT;
+		iscsi_set_padding(tcp_ctask, ctask->data_count);
 	}
 
 	rc = iscsi_sendhdr(conn, &tcp_ctask->headbuf, ctask->data_count);
@@ -1548,247 +1568,128 @@ handle_xmstate_uns_hdr(struct iscsi_conn
 	return 0;
 }
 
-static inline int
-handle_xmstate_uns_data(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+static int
+iscsi_send_unsol_pdu(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_data_task *dtask = tcp_ctask->dtask;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	int rc;
 
-	BUG_ON(!ctask->data_count);
-	tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
-
-	if (conn->datadgst_en) {
-		iscsi_data_digest_init(tcp_conn, ctask);
-		dtask->digest = 0;
+	if (tcp_ctask->xmstate & XMSTATE_UNS_HDR) {
+		BUG_ON(!ctask->unsol_count);
+		tcp_ctask->xmstate &= ~XMSTATE_UNS_HDR;
+send_hdr:
+		rc = iscsi_send_unsol_hdr(conn, ctask);
+		if (rc)
+			return rc;
 	}
 
-	for (;;) {
+	if (tcp_ctask->xmstate & XMSTATE_UNS_DATA) {
+		struct iscsi_data_task *dtask = &tcp_ctask->unsol_dtask;
 		int start = tcp_ctask->sent;
 
-		rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf,
-				   &ctask->data_count, &tcp_ctask->sent);
-		if (rc) {
-			ctask->unsol_count -= tcp_ctask->sent - start;
-			tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
-			/* will continue with this ctask later.. */
-			if (conn->datadgst_en) {
-				crypto_digest_final(tcp_conn->data_tx_tfm,
-						(u8 *)&dtask->digest);
-				debug_tcp("tx uns data fail 0x%x\n",
-					  dtask->digest);
-			}
-			return rc;
-		}
-
-		BUG_ON(tcp_ctask->sent > ctask->total_length);
+		rc = iscsi_send_data(ctask, &tcp_ctask->sendbuf, &tcp_ctask->sg,
+				     &tcp_ctask->sent, &ctask->data_count, 
+				     &dtask->digestbuf, &dtask->digest);
 		ctask->unsol_count -= tcp_ctask->sent - start;
-
+		if (rc)
+			return rc;
+		tcp_ctask->xmstate &= ~XMSTATE_UNS_DATA;
 		/*
-		 * XXX:we may run here with un-initial sendbuf.
-		 * so pass it
+		 * Done with the Data-Out. Next, check if we need
+		 * to send another unsolicited Data-Out.
 		 */
-		if (conn->datadgst_en && tcp_ctask->sent - start > 0)
-			crypto_digest_update(tcp_conn->data_tx_tfm,
-					     &tcp_ctask->sendbuf.sg, 1);
-
-		if (!ctask->data_count)
-			break;
-		iscsi_buf_init_sg(&tcp_ctask->sendbuf,
-				  &tcp_ctask->sg[tcp_ctask->sg_count++]);
-	}
-	BUG_ON(ctask->unsol_count < 0);
-
-	/*
-	 * Done with the Data-Out. Next, check if we need
-	 * to send another unsolicited Data-Out.
-	 */
-	if (ctask->unsol_count) {
-		if (conn->datadgst_en) {
-			rc = iscsi_digest_final_send(conn, ctask,
-						    &dtask->digestbuf,
-						    &dtask->digest, 1);
-			if (rc) {
-				debug_tcp("send uns digest 0x%x fail\n",
-					  dtask->digest);
-				return rc;
-			}
-			debug_tcp("sending uns digest 0x%x, more uns\n",
-				  dtask->digest);
+		if (ctask->unsol_count) {
+			debug_scsi("sending more uns\n");
+			tcp_ctask->xmstate |= XMSTATE_UNS_INIT;
+			goto send_hdr;
 		}
-		tcp_ctask->xmstate |= XMSTATE_UNS_INIT;
-		return 1;
 	}
-
-	if (conn->datadgst_en && !(tcp_ctask->xmstate & XMSTATE_W_PAD)) {
-		rc = iscsi_digest_final_send(conn, ctask,
-					    &dtask->digestbuf,
-					    &dtask->digest, 1);
-		if (rc) {
-			debug_tcp("send last uns digest 0x%x fail\n",
-				   dtask->digest);
-			return rc;
-		}
-		debug_tcp("sending uns digest 0x%x\n",dtask->digest);
-	}
-
 	return 0;
 }
 
-static inline int
-handle_xmstate_sol_data(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+static int iscsi_send_sol_pdu(struct iscsi_conn *conn,
+			      struct iscsi_cmd_task *ctask)
 {
-	struct iscsi_session *session = conn->session;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_r2t_info *r2t = tcp_ctask->r2t;
-	struct iscsi_data_task *dtask = &r2t->dtask;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_r2t_info *r2t;
+	struct iscsi_data_task *dtask;
 	int left, rc;
 
-	tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
-	tcp_ctask->dtask = dtask;
-
-	if (conn->datadgst_en) {
-		iscsi_data_digest_init(tcp_conn, ctask);
-		dtask->digest = 0;
-	}
-solicit_again:
-	/*
-	 * send Data-Out within this R2T sequence.
-	 */
-	if (!r2t->data_count)
-		goto data_out_done;
-
-	rc = iscsi_sendpage(conn, &r2t->sendbuf, &r2t->data_count, &r2t->sent);
-	if (rc) {
+	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR) {
+		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
 		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
-		/* will continue with this ctask later.. */
-		if (conn->datadgst_en) {
-			crypto_digest_final(tcp_conn->data_tx_tfm,
-					  (u8 *)&dtask->digest);
-			debug_tcp("r2t data send fail 0x%x\n", dtask->digest);
-		}
-		return rc;
-	}
+		if (!tcp_ctask->r2t)
+			__kfifo_get(tcp_ctask->r2tqueue, (void*)&tcp_ctask->r2t,
+				    sizeof(void*));
+send_hdr:
+		r2t = tcp_ctask->r2t;
+		dtask = &r2t->dtask;
 
-	BUG_ON(r2t->data_count < 0);
-	if (conn->datadgst_en)
-		crypto_digest_update(tcp_conn->data_tx_tfm, &r2t->sendbuf.sg,
-				     1);
-
-	if (r2t->data_count) {
-		BUG_ON(ctask->sc->use_sg == 0);
-		if (!iscsi_buf_left(&r2t->sendbuf)) {
-			BUG_ON(tcp_ctask->bad_sg == r2t->sg);
-			iscsi_buf_init_sg(&r2t->sendbuf, r2t->sg);
-			r2t->sg += 1;
-		}
-		goto solicit_again;
-	}
+		if (conn->hdrdgst_en)
+			iscsi_hdr_digest(conn, &r2t->headbuf,
+					(u8*)dtask->hdrext);
 
-data_out_done:
-	/*
-	 * Done with this Data-Out. Next, check if we have
-	 * to send another Data-Out for this R2T.
-	 */
-	BUG_ON(r2t->data_length - r2t->sent < 0);
-	left = r2t->data_length - r2t->sent;
-	if (left) {
 		if (conn->datadgst_en) {
-			rc = iscsi_digest_final_send(conn, ctask,
-						    &dtask->digestbuf,
-						    &dtask->digest, 1);
-			if (rc) {
-				debug_tcp("send r2t data digest 0x%x"
-					  "fail\n", dtask->digest);
-				return rc;
-			}
-			debug_tcp("r2t data send digest 0x%x\n",
-				  dtask->digest);
+			iscsi_data_digest_init(conn->dd_data, tcp_ctask);
+			dtask->digest = 0;
 		}
-		iscsi_solicit_data_cont(conn, ctask, r2t, left);
-		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
-		return 1;
-	}
 
-	/*
-	 * Done with this R2T. Check if there are more
-	 * outstanding R2Ts ready to be processed.
-	 */
-	if (conn->datadgst_en) {
-		rc = iscsi_digest_final_send(conn, ctask, &dtask->digestbuf,
-					    &dtask->digest, 1);
+		rc = iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count);
 		if (rc) {
-			debug_tcp("send last r2t data digest 0x%x"
-				  "fail\n", dtask->digest);
+			tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
+			tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
 			return rc;
 		}
-		debug_tcp("r2t done dout digest 0x%x\n", dtask->digest);
-	}
 
-	tcp_ctask->r2t = NULL;
-	spin_lock_bh(&session->lock);
-	__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t, sizeof(void*));
-	spin_unlock_bh(&session->lock);
-	if (__kfifo_get(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		tcp_ctask->r2t = r2t;
-		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
-		return 1;
+		iscsi_set_padding(tcp_ctask, r2t->data_count);
+		debug_scsi("sol dout [dsn %d itt 0x%x dlen %d sent %d]\n",
+			r2t->solicit_datasn - 1, ctask->itt, r2t->data_count,
+			r2t->sent);
 	}
 
-	return 0;
-}
+	if (tcp_ctask->xmstate & XMSTATE_SOL_DATA) {
+		r2t = tcp_ctask->r2t;
+		dtask = &r2t->dtask;
 
-static inline int
-handle_xmstate_w_pad(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_data_task *dtask = tcp_ctask->dtask;
-	int sent = 0, rc;
+		rc = iscsi_send_data(ctask, &r2t->sendbuf, &r2t->sg,
+				     &r2t->sent, &r2t->data_count,
+				     &dtask->digestbuf, &dtask->digest);
+		if (rc)
+			return rc;
+		tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
 
-	tcp_ctask->xmstate &= ~XMSTATE_W_PAD;
-	iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
-			    tcp_ctask->pad_count);
-	rc = iscsi_sendpage(conn, &tcp_ctask->sendbuf, &tcp_ctask->pad_count,
-			   &sent);
-	if (rc) {
-		tcp_ctask->xmstate |= XMSTATE_W_PAD;
-		return rc;
-	}
+		/*
+		 * Done with this Data-Out. Next, check if we have
+		 * to send another Data-Out for this R2T.
+		 */
+		BUG_ON(r2t->data_length - r2t->sent < 0);
+		left = r2t->data_length - r2t->sent;
+		if (left) {
+			iscsi_solicit_data_cont(conn, ctask, r2t, left);
+			tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
+			tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
+			goto send_hdr;
+		}
 
-	if (conn->datadgst_en) {
-		crypto_digest_update(tcp_conn->data_tx_tfm,
-				     &tcp_ctask->sendbuf.sg, 1);
-		/* imm data? */
-		if (!dtask) {
-			rc = iscsi_digest_final_send(conn, ctask,
-						    &tcp_ctask->immbuf,
-						    &tcp_ctask->immdigest, 1);
-			if (rc) {
-				debug_tcp("send padding digest 0x%x"
-					  "fail!\n", tcp_ctask->immdigest);
-				return rc;
-			}
-			debug_tcp("done with padding, digest 0x%x\n",
-				  tcp_ctask->datadigest);
-		} else {
-			rc = iscsi_digest_final_send(conn, ctask,
-						    &dtask->digestbuf,
-						    &dtask->digest, 1);
-			if (rc) {
-				debug_tcp("send padding digest 0x%x"
-				          "fail\n", dtask->digest);
-				return rc;
-			}
-			debug_tcp("done with padding, digest 0x%x\n",
-				  dtask->digest);
+		/*
+		 * Done with this R2T. Check if there are more
+		 * outstanding R2Ts ready to be processed.
+		 */
+		spin_lock_bh(&session->lock);
+		tcp_ctask->r2t = NULL;
+		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
+			    sizeof(void*));
+		if (__kfifo_get(tcp_ctask->r2tqueue, (void*)&r2t,
+				sizeof(void*))) {
+			tcp_ctask->r2t = r2t;
+			tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
+			tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
+			spin_unlock_bh(&session->lock);
+			goto send_hdr;
 		}
+		spin_unlock_bh(&session->lock);
 	}
-
 	return 0;
 }
 
@@ -1808,85 +1709,30 @@ iscsi_tcp_ctask_xmit(struct iscsi_conn *
 		return rc;
 
 	if (tcp_ctask->xmstate & XMSTATE_R_HDR)
-		return handle_xmstate_r_hdr(conn, tcp_ctask);
+		return iscsi_send_read_hdr(conn, tcp_ctask);
 
 	if (tcp_ctask->xmstate & XMSTATE_W_HDR) {
-		rc = handle_xmstate_w_hdr(conn, ctask);
-		if (rc)
-			return rc;
-	}
-
-	/* XXX: for data digest xmit recover */
-	if (tcp_ctask->xmstate & XMSTATE_DATA_DIGEST) {
-		rc = handle_xmstate_data_digest(conn, ctask);
+		rc = iscsi_send_write_hdr(conn, ctask);
 		if (rc)
 			return rc;
 	}
 
 	if (tcp_ctask->xmstate & XMSTATE_IMM_DATA) {
-		rc = handle_xmstate_imm_data(conn, ctask);
+		rc = iscsi_send_data(ctask, &tcp_ctask->sendbuf, &tcp_ctask->sg,
+				     &tcp_ctask->sent, &ctask->imm_count,
+				     &tcp_ctask->immbuf, &tcp_ctask->immdigest);
 		if (rc)
 			return rc;
+		tcp_ctask->xmstate &= ~XMSTATE_IMM_DATA;
 	}
 
-	if (tcp_ctask->xmstate & XMSTATE_UNS_HDR) {
-		BUG_ON(!ctask->unsol_count);
-		tcp_ctask->xmstate &= ~XMSTATE_UNS_HDR;
-unsolicit_head_again:
-		rc = handle_xmstate_uns_hdr(conn, ctask);
-		if (rc)
-			return rc;
-	}
-
-	if (tcp_ctask->xmstate & XMSTATE_UNS_DATA) {
-		rc = handle_xmstate_uns_data(conn, ctask);
-		if (rc == 1)
-			goto unsolicit_head_again;
-		else if (rc)
-			return rc;
-		goto done;
-	}
-
-	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR) {
-		struct iscsi_r2t_info *r2t;
-
-		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
-		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
-		if (!tcp_ctask->r2t)
-			__kfifo_get(tcp_ctask->r2tqueue, (void*)&tcp_ctask->r2t,
-				    sizeof(void*));
-solicit_head_again:
-		r2t = tcp_ctask->r2t;
-		if (conn->hdrdgst_en)
-			iscsi_hdr_digest(conn, &r2t->headbuf,
-					(u8*)r2t->dtask.hdrext);
-		rc = iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count);
-		if (rc) {
-			tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
-			tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
-			return rc;
-		}
-
-		debug_scsi("sol dout [dsn %d itt 0x%x dlen %d sent %d]\n",
-			r2t->solicit_datasn - 1, ctask->itt, r2t->data_count,
-			r2t->sent);
-	}
-
-	if (tcp_ctask->xmstate & XMSTATE_SOL_DATA) {
-		rc = handle_xmstate_sol_data(conn, ctask);
-		if (rc == 1)
-			goto solicit_head_again;
-		if (rc)
-			return rc;
-	}
+	rc = iscsi_send_unsol_pdu(conn, ctask);
+	if (rc)
+		return rc;
 
-done:
-	/*
-	 * Last thing to check is whether we need to send write
-	 * padding. Note that we check for xmstate equality, not just the bit.
-	 */
-	if (tcp_ctask->xmstate == XMSTATE_W_PAD)
-		rc = handle_xmstate_w_pad(conn, ctask);
+	rc = iscsi_send_sol_pdu(conn, ctask);
+	if (rc)
+		return rc;
 
 	return rc;
 }
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index aace8f7..7e40e94 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -31,23 +31,21 @@ #define IN_PROGRESS_DATA_RECV		0x2
 #define IN_PROGRESS_DDIGEST_RECV	0x3
 
 /* xmit state machine */
-#define	XMSTATE_IDLE			0x0
-#define	XMSTATE_R_HDR			0x1
-#define	XMSTATE_W_HDR			0x2
-#define	XMSTATE_IMM_HDR			0x4
-#define	XMSTATE_IMM_DATA		0x8
-#define	XMSTATE_UNS_INIT		0x10
-#define	XMSTATE_UNS_HDR			0x20
-#define	XMSTATE_UNS_DATA		0x40
-#define	XMSTATE_SOL_HDR			0x80
-#define	XMSTATE_SOL_DATA		0x100
-#define	XMSTATE_W_PAD			0x200
-#define XMSTATE_DATA_DIGEST		0x400
-
-#define ISCSI_CONN_RCVBUF_MIN		262144
-#define ISCSI_CONN_SNDBUF_MIN		262144
+#define XMSTATE_IDLE			0x0
+#define XMSTATE_R_HDR			0x1
+#define XMSTATE_W_HDR			0x2
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
+
 #define ISCSI_PAD_LEN			4
-#define ISCSI_R2T_MAX			16
 #define ISCSI_SG_TABLESIZE		SG_ALL
 #define ISCSI_TCP_MAX_CMD_LEN		16
 
@@ -162,13 +160,10 @@ struct iscsi_tcp_cmd_task {
 	struct iscsi_queue	r2tpool;
 	struct kfifo		*r2tqueue;
 	struct iscsi_r2t_info	**r2ts;
-	uint32_t		datadigest;		/* for recover digest */
 	int			digest_count;
 	uint32_t		immdigest;		/* for imm data */
 	struct iscsi_buf	immbuf;			/* for imm data digest */
-	struct iscsi_data_task	*dtask;		/* data task in progress*/
 	struct iscsi_data_task	unsol_dtask;	/* unsol data task */
-	int			digest_offset;	/* for partial buff digest */
 };
 
 #endif /* ISCSI_H */
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9584cbc..fb65311 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -325,6 +325,30 @@ static void iscsi_tmf_rsp(struct iscsi_c
 	wake_up(&conn->ehwait);
 }
 
+static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+			       char *data, int datalen)
+{
+	struct iscsi_reject *reject = (struct iscsi_reject *)hdr;
+	struct iscsi_hdr rejected_pdu;
+	uint32_t itt;
+
+	conn->exp_statsn = be32_to_cpu(reject->statsn) + 1;
+
+	if (reject->reason == ISCSI_REASON_DATA_DIGEST_ERROR) {
+		if (ntoh24(reject->dlength) > datalen)
+			return ISCSI_ERR_PROTO;
+
+		if (ntoh24(reject->dlength) >= sizeof(struct iscsi_hdr)) {
+			memcpy(&rejected_pdu, data, sizeof(struct iscsi_hdr));
+			itt = rejected_pdu.itt & ISCSI_ITT_MASK;
+			printk(KERN_ERR "itt 0x%x had pdu (op 0x%x) rejected "
+				"due to DataDigest error.\n", itt,
+				rejected_pdu.opcode);
+		}
+	}
+	return 0;
+}
+
 /**
  * __iscsi_complete_pdu - complete pdu
  * @conn: iscsi conn
@@ -436,6 +460,11 @@ int __iscsi_complete_pdu(struct iscsi_co
 			break;
 		}
 	} else if (itt == ISCSI_RESERVED_TAG) {
+		rc = iscsi_check_assign_cmdsn(session,
+					     (struct iscsi_nopin*)hdr);
+		if (rc)
+			goto done;
+
 		switch(opcode) {
 		case ISCSI_OP_NOOP_IN:
 			if (datalen) {
@@ -443,11 +472,6 @@ int __iscsi_complete_pdu(struct iscsi_co
 				break;
 			}
 
-			rc = iscsi_check_assign_cmdsn(session,
-						 (struct iscsi_nopin*)hdr);
-			if (rc)
-				break;
-
 			if (hdr->ttt == ISCSI_RESERVED_TAG)
 				break;
 
@@ -455,7 +479,8 @@ int __iscsi_complete_pdu(struct iscsi_co
 				rc = ISCSI_ERR_CONN_FAILED;
 			break;
 		case ISCSI_OP_REJECT:
-			/* we need sth like iscsi_reject_rsp()*/
+			rc = iscsi_handle_reject(conn, hdr, data, datalen);
+			break;
 		case ISCSI_OP_ASYNC_EVENT:
 			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 			/* we need sth like iscsi_async_event_rsp() */
-- 
1.4.1.1

