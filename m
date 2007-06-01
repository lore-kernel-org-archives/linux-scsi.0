From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] iscsi_tcp: convert to use the data buffer accessors
Date: Fri, 1 Jun 2007 18:56:20 +0900 (JST)
Message-ID: <20070531033019V.fujita.tomonori@lab.ntt.co.jp>
References: <dcbf60d819ad4d62643fc074968699563f25621b.1180539510.git.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:60189 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbXFAJ4f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 05:56:35 -0400
In-Reply-To: <dcbf60d819ad4d62643fc074968699563f25621b.1180539510.git.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, michaelc@cs.wisc.edu, open-iscsi@googlegroups.com

iscsi_tcp: convert to use the data buffer accessors

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

TODO: use scsi_for_each_sg().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/iscsi_tcp.c |  117 +++++++++++++++-------------------------------
 drivers/scsi/libiscsi.c  |   20 ++++----
 2 files changed, 48 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index d5a6527..aee2b60 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -237,10 +237,10 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	tcp_ctask->exp_datasn++;
 
 	tcp_ctask->data_offset = be32_to_cpu(rhdr->offset);
-	if (tcp_ctask->data_offset + tcp_conn->in.datalen > sc->request_bufflen) {
+	if (tcp_ctask->data_offset + tcp_conn->in.datalen > scsi_bufflen(sc)) {
 		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
 		          __FUNCTION__, tcp_ctask->data_offset,
-		          tcp_conn->in.datalen, sc->request_bufflen);
+		          tcp_conn->in.datalen, scsi_buffle(sc));
 		return ISCSI_ERR_DATA_OFFSET;
 	}
 
@@ -250,14 +250,14 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 			int res_count = be32_to_cpu(rhdr->residual_count);
 
 			if (res_count > 0 &&
-			    res_count <= sc->request_bufflen) {
-				sc->resid = res_count;
+			    res_count <= scsi_bufflen(sc)) {
+				scsi_set_resid(sc, res_count);
 				sc->result = (DID_OK << 16) | rhdr->cmd_status;
 			} else
 				sc->result = (DID_BAD_TARGET << 16) |
 					rhdr->cmd_status;
 		} else if (rhdr->flags & ISCSI_FLAG_DATA_OVERFLOW) {
-			sc->resid = be32_to_cpu(rhdr->residual_count);
+			scsi_set_resid(sc, be32_to_cpu(rhdr->residual_count));
 			sc->result = (DID_OK << 16) | rhdr->cmd_status;
 		} else
 			sc->result = (DID_OK << 16) | rhdr->cmd_status;
@@ -285,6 +285,8 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 {
 	struct iscsi_data *hdr;
 	struct scsi_cmnd *sc = ctask->sc;
+	int i, sg_count = 0;
+	struct scatterlist *sg;
 
 	hdr = &r2t->dtask.hdr;
 	memset(hdr, 0, sizeof(struct iscsi_data));
@@ -312,39 +314,30 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	iscsi_buf_init_iov(&r2t->headbuf, (char*)hdr,
 			   sizeof(struct iscsi_hdr));
 
-	if (sc->use_sg) {
-		int i, sg_count = 0;
-		struct scatterlist *sg = sc->request_buffer;
-
-		r2t->sg = NULL;
-		for (i = 0; i < sc->use_sg; i++, sg += 1) {
-			/* FIXME: prefetch ? */
-			if (sg_count + sg->length > r2t->data_offset) {
-				int page_offset;
+	sg = scsi_sglist(sc);
+	r2t->sg = NULL;
+	for (i = 0; i < scsi_sg_count(sc); i++, sg += 1) {
+		/* FIXME: prefetch ? */
+		if (sg_count + sg->length > r2t->data_offset) {
+			int page_offset;
 
-				/* sg page found! */
+			/* sg page found! */
 
-				/* offset within this page */
-				page_offset = r2t->data_offset - sg_count;
+			/* offset within this page */
+			page_offset = r2t->data_offset - sg_count;
 
-				/* fill in this buffer */
-				iscsi_buf_init_sg(&r2t->sendbuf, sg);
-				r2t->sendbuf.sg.offset += page_offset;
-				r2t->sendbuf.sg.length -= page_offset;
+			/* fill in this buffer */
+			iscsi_buf_init_sg(&r2t->sendbuf, sg);
+			r2t->sendbuf.sg.offset += page_offset;
+			r2t->sendbuf.sg.length -= page_offset;
 
-				/* xmit logic will continue with next one */
-				r2t->sg = sg + 1;
-				break;
-			}
-			sg_count += sg->length;
+			/* xmit logic will continue with next one */
+			r2t->sg = sg + 1;
+			break;
 		}
-		BUG_ON(r2t->sg == NULL);
-	} else {
-		iscsi_buf_init_iov(&r2t->sendbuf,
-			    (char*)sc->request_buffer + r2t->data_offset,
-			    r2t->data_count);
-		r2t->sg = NULL;
+		sg_count += sg->length;
 	}
+	BUG_ON(r2t->sg == NULL);
 }
 
 /**
@@ -404,11 +397,11 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 			    r2t->data_length, session->max_burst);
 
 	r2t->data_offset = be32_to_cpu(rhdr->data_offset);
-	if (r2t->data_offset + r2t->data_length > ctask->sc->request_bufflen) {
+	if (r2t->data_offset + r2t->data_length > scsi_bufflen(ctask->sc)) {
 		spin_unlock(&session->lock);
 		printk(KERN_ERR "iscsi_tcp: invalid R2T with data len %u at "
 		       "offset %u and total length %d\n", r2t->data_length,
-		       r2t->data_offset, ctask->sc->request_bufflen);
+		       r2t->data_offset, scsi_bufflen(ctask->sc));
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -612,7 +605,7 @@ iscsi_ctask_copy(struct iscsi_tcp_conn *tcp_conn, struct iscsi_cmd_task *ctask,
 	       size, tcp_conn->in.offset, tcp_conn->in.copied);
 
 	BUG_ON(size <= 0);
-	BUG_ON(tcp_ctask->sent + size > ctask->sc->request_bufflen);
+	BUG_ON(tcp_ctask->sent + size > scsi_bufflen(ctask->sc));
 
 	rc = skb_copy_bits(tcp_conn->in.skb, tcp_conn->in.offset,
 			   (char*)buf + (offset + tcp_conn->data_copied), size);
@@ -710,25 +703,8 @@ static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 
 	BUG_ON((void*)ctask != sc->SCp.ptr);
 
-	/*
-	 * copying Data-In into the Scsi_Cmnd
-	 */
-	if (!sc->use_sg) {
-		i = ctask->data_count;
-		rc = iscsi_ctask_copy(tcp_conn, ctask, sc->request_buffer,
-				      sc->request_bufflen,
-				      tcp_ctask->data_offset);
-		if (rc == -EAGAIN)
-			return rc;
-		if (conn->datadgst_en)
-			iscsi_recv_digest_update(tcp_conn, sc->request_buffer,
-						 i);
-		rc = 0;
-		goto done;
-	}
-
 	offset = tcp_ctask->data_offset;
-	sg = sc->request_buffer;
+	sg = scsi_sglist(sc);
 
 	if (tcp_ctask->data_offset)
 		for (i = 0; i < tcp_ctask->sg_count; i++)
@@ -737,7 +713,7 @@ static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 	if (offset < 0)
 		offset = 0;
 
-	for (i = tcp_ctask->sg_count; i < sc->use_sg; i++) {
+	for (i = tcp_ctask->sg_count; i < scsi_sg_count(sc); i++) {
 		char *dest;
 
 		dest = kmap_atomic(sg[i].page, KM_SOFTIRQ0);
@@ -782,7 +758,6 @@ static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 	}
 	BUG_ON(ctask->data_count);
 
-done:
 	/* check for non-exceptional status */
 	if (tcp_conn->in.hdr->flags & ISCSI_FLAG_DATA_STATUS) {
 		debug_scsi("done [sc %lx res %d itt 0x%x flags 0x%x]\n",
@@ -1241,7 +1216,6 @@ iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 			struct iscsi_r2t_info *r2t, int left)
 {
 	struct iscsi_data *hdr;
-	struct scsi_cmnd *sc = ctask->sc;
 	int new_offset;
 
 	hdr = &r2t->dtask.hdr;
@@ -1271,15 +1245,8 @@ iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	if (iscsi_buf_left(&r2t->sendbuf))
 		return;
 
-	if (sc->use_sg) {
-		iscsi_buf_init_sg(&r2t->sendbuf, r2t->sg);
-		r2t->sg += 1;
-	} else {
-		iscsi_buf_init_iov(&r2t->sendbuf,
-			    (char*)sc->request_buffer + new_offset,
-			    r2t->data_count);
-		r2t->sg = NULL;
-	}
+	iscsi_buf_init_sg(&r2t->sendbuf, r2t->sg);
+	r2t->sg += 1;
 }
 
 static void iscsi_set_padding(struct iscsi_tcp_cmd_task *tcp_ctask,
@@ -1408,23 +1375,15 @@ iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 		tcp_ctask->exp_datasn = 0;
 
 		if (sc->sc_data_direction == DMA_TO_DEVICE) {
-			if (sc->use_sg) {
-				struct scatterlist *sg = sc->request_buffer;
-
-				iscsi_buf_init_sg(&tcp_ctask->sendbuf, sg);
-				tcp_ctask->sg = sg + 1;
-				tcp_ctask->bad_sg = sg + sc->use_sg;
-			} else {
-				iscsi_buf_init_iov(&tcp_ctask->sendbuf,
-						   sc->request_buffer,
-						   sc->request_bufflen);
-				tcp_ctask->sg = NULL;
-				tcp_ctask->bad_sg = NULL;
-			}
+			struct scatterlist *sg = scsi_sglist(sc);
+
+			iscsi_buf_init_sg(&tcp_ctask->sendbuf, sg);
+			tcp_ctask->sg = sg + 1;
+			tcp_ctask->bad_sg = sg + scsi_sg_count(sc);
 
 			debug_scsi("cmd [itt 0x%x total %d imm_data %d "
 				   "unsol count %d, unsol offset %d]\n",
-				   ctask->itt, sc->request_bufflen,
+				   ctask->itt, scsi_bufflen(sc),
 				   ctask->imm_count, ctask->unsol_count,
 				   ctask->unsol_offset);
 		}
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 865dd57..4d85ce1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -140,7 +140,7 @@ static void iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
         hdr->flags = ISCSI_ATTR_SIMPLE;
         int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
         hdr->itt = build_itt(ctask->itt, conn->id, session->age);
-        hdr->data_length = cpu_to_be32(sc->request_bufflen);
+        hdr->data_length = cpu_to_be32(scsi_bufflen(sc));
         hdr->cmdsn = cpu_to_be32(session->cmdsn);
         session->cmdsn++;
         hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
@@ -172,11 +172,11 @@ static void iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 		ctask->unsol_datasn = 0;
 
 		if (session->imm_data_en) {
-			if (sc->request_bufflen >= session->first_burst)
+			if (scsi_bufflen(sc) >= session->first_burst)
 				ctask->imm_count = min(session->first_burst,
 							conn->max_xmit_dlength);
 			else
-				ctask->imm_count = min(sc->request_bufflen,
+				ctask->imm_count = min(scsi_bufflen(sc),
 							conn->max_xmit_dlength);
 			hton24(ctask->hdr->dlength, ctask->imm_count);
 		} else
@@ -184,7 +184,7 @@ static void iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 
 		if (!session->initial_r2t_en) {
 			ctask->unsol_count = min((session->first_burst),
-				(sc->request_bufflen)) - ctask->imm_count;
+				(scsi_bufflen(sc))) - ctask->imm_count;
 			ctask->unsol_offset = ctask->imm_count;
 		}
 
@@ -204,7 +204,7 @@ static void iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
         debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
 		"cmdsn %d win %d]\n",
                 sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
-                conn->id, sc, sc->cmnd[0], ctask->itt, sc->request_bufflen,
+		conn->id, sc, sc->cmnd[0], ctask->itt, scsi_bufflen(sc),
                 session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 }
 
@@ -297,14 +297,14 @@ invalid_datalen:
 	if (rhdr->flags & ISCSI_FLAG_CMD_UNDERFLOW) {
 		int res_count = be32_to_cpu(rhdr->residual_count);
 
-		if (res_count > 0 && res_count <= sc->request_bufflen)
-			sc->resid = res_count;
+		if (res_count > 0 && res_count <= scsi_bufflen(sc))
+			scsi_set_resid(sc, res_count);
 		else
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	} else if (rhdr->flags & ISCSI_FLAG_CMD_BIDI_UNDERFLOW)
 		sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	else if (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW)
-		sc->resid = be32_to_cpu(rhdr->residual_count);
+		scsi_set_resid(sc, be32_to_cpu(rhdr->residual_count));
 
 out:
 	debug_scsi("done [sc %lx res %d itt 0x%x]\n",
@@ -876,7 +876,7 @@ fault:
 	printk(KERN_ERR "iscsi: cmd 0x%x is not queued (%d)\n",
 	       sc->cmnd[0], reason);
 	sc->result = (DID_NO_CONNECT << 16);
-	sc->resid = sc->request_bufflen;
+	scsi_set_resid(sc, scsi_bufflen(sc));
 	sc->scsi_done(sc);
 	return 0;
 }
@@ -1145,7 +1145,7 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 	iscsi_ctask_mtask_cleanup(ctask);
 
 	sc->result = err;
-	sc->resid = sc->request_bufflen;
+	scsi_set_resid(sc, scsi_bufflen(sc));
 	if (conn->ctask == ctask)
 		conn->ctask = NULL;
 	/* release ref from queuecommand */
-- 
1.4.4.4

