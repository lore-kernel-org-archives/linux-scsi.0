From: michaelc@cs.wisc.edu
Subject: [PATCH 9/19] iscsi: Some fixes in preparation for bidirectional support - total_length
Date: Wed, 30 May 2007 12:57:15 -0500
Message-ID: <11805478564182-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbXE3R5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:44 -0400
In-Reply-To: <11805478543860-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>

From: Mike Christie <michaelc@cs.wisc.edu>

- Remove shadow of request length from struct iscsi_cmd_task.
- change all users to use scsi_cmnd->request_bufflen directly

(With bidi we will use scsi-ml API to retrieve in/out length)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    4 ++--
 drivers/scsi/iscsi_tcp.c                 |   21 ++++++++++++---------
 drivers/scsi/libiscsi.c                  |    9 ++++-----
 include/scsi/libiscsi.h                  |   21 ++++++++++-----------
 4 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index e39d9a0..568f88b 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -140,10 +140,10 @@ iscsi_iser_cmd_init(struct iscsi_cmd_tas
 	iser_ctask->iser_conn    = iser_conn;
 
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
-		BUG_ON(ctask->total_length == 0);
+		BUG_ON(sc->request_bufflen == 0);
 
 		debug_scsi("cmd [itt %x total %d imm %d unsol_data %d\n",
-			   ctask->itt, ctask->total_length, ctask->imm_count,
+			   ctask->itt, sc->request_bufflen, ctask->imm_count,
 			   ctask->unsol_count);
 	}
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 17fc79c..b2827d1 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -216,6 +216,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, 
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_data_rsp *rhdr = (struct iscsi_data_rsp *)tcp_conn->in.hdr;
 	struct iscsi_session *session = conn->session;
+	struct scsi_cmnd *sc = ctask->sc;
 	int datasn = be32_to_cpu(rhdr->datasn);
 
 	rc = iscsi_check_assign_cmdsn(session, (struct iscsi_nopin*)rhdr);
@@ -238,12 +239,14 @@ iscsi_data_rsp(struct iscsi_conn *conn, 
 	tcp_ctask->exp_datasn++;
 
 	tcp_ctask->data_offset = be32_to_cpu(rhdr->offset);
-	if (tcp_ctask->data_offset + tcp_conn->in.datalen > ctask->total_length)
+	if (tcp_ctask->data_offset + tcp_conn->in.datalen > sc->request_bufflen) {
+		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
+		          __FUNCTION__, tcp_ctask->data_offset,
+		          tcp_conn->in.datalen, sc->request_bufflen);
 		return ISCSI_ERR_DATA_OFFSET;
+	}
 
 	if (rhdr->flags & ISCSI_FLAG_DATA_STATUS) {
-		struct scsi_cmnd *sc = ctask->sc;
-
 		conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 		if (rhdr->flags & ISCSI_FLAG_DATA_UNDERFLOW) {
 			int res_count = be32_to_cpu(rhdr->residual_count);
@@ -405,11 +408,11 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 			    r2t->data_length, session->max_burst);
 
 	r2t->data_offset = be32_to_cpu(rhdr->data_offset);
-	if (r2t->data_offset + r2t->data_length > ctask->total_length) {
+	if (r2t->data_offset + r2t->data_length > ctask->sc->request_bufflen) {
 		spin_unlock(&session->lock);
 		printk(KERN_ERR "iscsi_tcp: invalid R2T with data len %u at "
 		       "offset %u and total length %d\n", r2t->data_length,
-		       r2t->data_offset, ctask->total_length);
+		       r2t->data_offset, ctask->sc->request_bufflen);
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -604,7 +607,7 @@ iscsi_ctask_copy(struct iscsi_tcp_conn *
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	int buf_left = buf_size - (tcp_conn->data_copied + offset);
-	int size = min(tcp_conn->in.copy, buf_left);
+	unsigned size = min(tcp_conn->in.copy, buf_left);
 	int rc;
 
 	size = min(size, ctask->data_count);
@@ -613,7 +616,7 @@ iscsi_ctask_copy(struct iscsi_tcp_conn *
 	       size, tcp_conn->in.offset, tcp_conn->in.copied);
 
 	BUG_ON(size <= 0);
-	BUG_ON(tcp_ctask->sent + size > ctask->total_length);
+	BUG_ON(tcp_ctask->sent + size > ctask->sc->request_bufflen);
 
 	rc = skb_copy_bits(tcp_conn->in.skb, tcp_conn->in.offset,
 			   (char*)buf + (offset + tcp_conn->data_copied), size);
@@ -1292,7 +1295,7 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
 
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		tcp_ctask->xmstate = XMSTATE_W_HDR;
-		BUG_ON(ctask->total_length == 0);
+		BUG_ON(sc->request_bufflen == 0);
 
 		if (sc->use_sg) {
 			struct scatterlist *sg = sc->request_buffer;
@@ -1309,7 +1312,7 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
 		}
 		debug_scsi("cmd [itt 0x%x total %d imm_data %d "
 			   "unsol count %d, unsol offset %d]\n",
-			   ctask->itt, ctask->total_length, ctask->imm_count,
+			   ctask->itt, sc->request_bufflen, ctask->imm_count,
 			   ctask->unsol_count, ctask->unsol_offset);
 	} else
 		tcp_ctask->xmstate = XMSTATE_R_HDR;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index eb51136..0a9c64e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -147,19 +147,19 @@ static void iscsi_prep_scsi_cmd_pdu(stru
 		ctask->unsol_datasn = 0;
 
 		if (session->imm_data_en) {
-			if (ctask->total_length >= session->first_burst)
+			if (sc->request_bufflen >= session->first_burst)
 				ctask->imm_count = min(session->first_burst,
 							conn->max_xmit_dlength);
 			else
-				ctask->imm_count = min(ctask->total_length,
+				ctask->imm_count = min(sc->request_bufflen,
 							conn->max_xmit_dlength);
 			hton24(ctask->hdr->dlength, ctask->imm_count);
 		} else
 			zero_data(ctask->hdr->dlength);
 
 		if (!session->initial_r2t_en) {
-			ctask->unsol_count = min(session->first_burst,
-				ctask->total_length) - ctask->imm_count;
+			ctask->unsol_count = min((session->first_burst),
+				(sc->request_bufflen)) - ctask->imm_count;
 			ctask->unsol_offset = ctask->imm_count;
 		}
 
@@ -815,7 +815,6 @@ int iscsi_queuecommand(struct scsi_cmnd 
 	ctask->conn = conn;
 	ctask->sc = sc;
 	INIT_LIST_HEAD(&ctask->running);
-	ctask->total_length = sc->request_bufflen;
 	iscsi_prep_scsi_cmd_pdu(ctask);
 
 	session->tt->init_cmd_task(ctask);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 61e0692..348265d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -80,7 +80,7 @@ struct iscsi_mgmt_task {
 	 */
 	struct iscsi_hdr	*hdr;
 	char			*data;		/* mgmt payload */
-	int			data_count;	/* counts data to be sent */
+	unsigned		data_count;	/* counts data to be sent */
 	uint32_t		itt;		/* this ITT */
 	void			*dd_data;	/* driver/transport data */
 	struct list_head	running;
@@ -101,13 +101,12 @@ struct iscsi_cmd_task {
 	int			itt;		/* this ITT */
 
 	uint32_t		unsol_datasn;
-	int			imm_count;	/* imm-data (bytes)   */
-	int			unsol_count;	/* unsolicited (bytes)*/
+	unsigned		imm_count;	/* imm-data (bytes)   */
+	unsigned		unsol_count;	/* unsolicited (bytes)*/
 	/* offset in unsolicited stream (bytes); */
-	int			unsol_offset;
-	int			data_count;	/* remaining Data-Out */
+	unsigned		unsol_offset;
+	unsigned		data_count;	/* remaining Data-Out */
 	struct scsi_cmnd	*sc;		/* associated SCSI cmd*/
-	int			total_length;
 	struct iscsi_conn	*conn;		/* used connection    */
 	struct iscsi_mgmt_task	*mtask;		/* tmf mtask in progr */
 
@@ -173,8 +172,8 @@ struct iscsi_conn {
 	int			tmabort_state;	/* see TMABORT_INITIAL, etc.*/
 
 	/* negotiated params */
-	int			max_recv_dlength; /* initiator_max_recv_dsl*/
-	int			max_xmit_dlength; /* target_max_recv_dsl */
+	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
+	unsigned		max_xmit_dlength; /* target_max_recv_dsl */
 	int			hdrdgst_en;
 	int			datadgst_en;
 	int			ifmarker_en;
@@ -212,10 +211,10 @@ struct iscsi_session {
 
 	/* configuration */
 	int			initial_r2t_en;
-	int			max_r2t;
+	unsigned		max_r2t;
 	int			imm_data_en;
-	int			first_burst;
-	int			max_burst;
+	unsigned		first_burst;
+	unsigned		max_burst;
 	int			time2wait;
 	int			time2retain;
 	int			pdu_inorder_en;
-- 
1.4.1.1

