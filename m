From: michaelc@cs.wisc.edu
Subject: [PATCH 1/12] libiscsi, iscsi_tcp, iscsi_iser: check that burst lengths are valid.
Date: Thu, 31 Aug 2006 18:09:24 -0400
Message-ID: <11570621761945-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:21894 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932404AbWHaXJV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:21 -0400
In-Reply-To: <11570621752047-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iSCSI RFC states that the first burst length must be smaller than the
max burst length. We currently assume targets will be good, but that may
not be the case, so this patch adds a check.

This patch also moves the unsol data out offset to the lib so the LLDs
do not have to track it.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   18 ++++--------------
 drivers/infiniband/ulp/iser/iscsi_iser.h |    1 -
 drivers/scsi/iscsi_tcp.c                 |   30 +++++++-----------------------
 drivers/scsi/iscsi_tcp.h                 |    1 -
 drivers/scsi/libiscsi.c                  |   25 +++++++++++++++++--------
 include/scsi/libiscsi.h                  |    5 +++--
 6 files changed, 31 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1437d7e..101e407 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -141,18 +141,11 @@ iscsi_iser_cmd_init(struct iscsi_cmd_tas
 
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		BUG_ON(ctask->total_length == 0);
-		/* bytes to be sent via RDMA operations */
-		iser_ctask->rdma_data_count = ctask->total_length -
-					 ctask->imm_count -
-					 ctask->unsol_count;
 
-		debug_scsi("cmd [itt %x total %d imm %d unsol_data %d "
-			   "rdma_data %d]\n",
+		debug_scsi("cmd [itt %x total %d imm %d unsol_data %d\n",
 			   ctask->itt, ctask->total_length, ctask->imm_count,
-			   ctask->unsol_count, iser_ctask->rdma_data_count);
-	} else
-		/* bytes to be sent via RDMA operations */
-		iser_ctask->rdma_data_count = ctask->total_length;
+			   ctask->unsol_count);
+	}
 
 	iser_ctask_rdma_init(iser_ctask);
 }
@@ -196,13 +189,10 @@ iscsi_iser_ctask_xmit_unsol_data(struct 
 {
 	struct iscsi_data  hdr;
 	int error = 0;
-	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
 
 	/* Send data-out PDUs while there's still unsolicited data to send */
 	while (ctask->unsol_count > 0) {
-		iscsi_prep_unsolicit_data_pdu(ctask, &hdr,
-					      iser_ctask->rdma_data_count);
-
+		iscsi_prep_unsolicit_data_pdu(ctask, &hdr);
 		debug_scsi("Sending data-out: itt 0x%x, data count %d\n",
 			   hdr.itt, ctask->data_count);
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 3350ba6..7c3d0c9 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -257,7 +257,6 @@ struct iscsi_iser_conn {
 struct iscsi_iser_cmd_task {
 	struct iser_desc             desc;
 	struct iscsi_iser_conn	     *iser_conn;
-	int			     rdma_data_count;/* RDMA bytes           */
 	enum iser_task_status 	     status;
 	int                          command_sent;  /* set if command  sent  */
 	int                          dir[ISER_DIRS_NUM];      /* set if dir use*/
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 058f094..e07eced 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1264,19 +1264,6 @@ iscsi_solicit_data_cont(struct iscsi_con
 			    r2t->data_count);
 }
 
-static void
-iscsi_unsolicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
-{
-	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-	struct iscsi_data_task *dtask;
-
-	dtask = tcp_ctask->dtask = &tcp_ctask->unsol_dtask;
-	iscsi_prep_unsolicit_data_pdu(ctask, &dtask->hdr,
-				      tcp_ctask->r2t_data_count);
-	iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)&dtask->hdr,
-			   sizeof(struct iscsi_hdr));
-}
-
 /**
  * iscsi_tcp_cmd_init - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
  * @conn: iscsi connection
@@ -1326,14 +1313,11 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
 		if (ctask->unsol_count)
 			tcp_ctask->xmstate |= XMSTATE_UNS_HDR |
 						XMSTATE_UNS_INIT;
-		tcp_ctask->r2t_data_count = ctask->total_length -
-				    ctask->imm_count -
-				    ctask->unsol_count;
 
-		debug_scsi("cmd [itt 0x%x total %d imm %d imm_data %d "
-			   "r2t_data %d]\n",
+		debug_scsi("cmd [itt 0x%x total %d imm_data %d "
+			   "unsol count %d, unsol offset %d]\n",
 			   ctask->itt, ctask->total_length, ctask->imm_count,
-			   ctask->unsol_count, tcp_ctask->r2t_data_count);
+			   ctask->unsol_count, ctask->unsol_offset); 
 	} else
 		tcp_ctask->xmstate = XMSTATE_R_HDR;
 
@@ -1531,8 +1515,10 @@ handle_xmstate_uns_hdr(struct iscsi_conn
 
 	tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
 	if (tcp_ctask->xmstate & XMSTATE_UNS_INIT) {
-		iscsi_unsolicit_data_init(conn, ctask);
-		dtask = tcp_ctask->dtask;
+		dtask = tcp_ctask->dtask = &tcp_ctask->unsol_dtask;
+		iscsi_prep_unsolicit_data_pdu(ctask, &dtask->hdr);
+		iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)&dtask->hdr,
+				   sizeof(struct iscsi_hdr));
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
 					(u8*)dtask->hdrext);
@@ -1720,7 +1706,6 @@ data_out_done:
 	 * Done with this R2T. Check if there are more
 	 * outstanding R2Ts ready to be processed.
 	 */
-	BUG_ON(tcp_ctask->r2t_data_count - r2t->data_length < 0);
 	if (conn->datadgst_en) {
 		rc = iscsi_digest_final_send(conn, ctask, &dtask->digestbuf,
 					    &dtask->digest, 1);
@@ -1732,7 +1717,6 @@ data_out_done:
 		debug_tcp("r2t done dout digest 0x%x\n", dtask->digest);
 	}
 
-	tcp_ctask->r2t_data_count -= r2t->data_length;
 	tcp_ctask->r2t = NULL;
 	spin_lock_bh(&session->lock);
 	__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t, sizeof(void*));
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 6a4ee70..aace8f7 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -157,7 +157,6 @@ struct iscsi_tcp_cmd_task {
 	struct scatterlist	*bad_sg;		/* assert statement */
 	int			sg_count;		/* SG's to process  */
 	uint32_t		exp_r2tsn;
-	int			r2t_data_count;		/* R2T Data-Out bytes */
 	int			data_offset;
 	struct iscsi_r2t_info	*r2t;			/* in progress R2T    */
 	struct iscsi_queue	r2tpool;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5884cd2..a7c6e70 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -68,8 +68,7 @@ iscsi_check_assign_cmdsn(struct iscsi_se
 EXPORT_SYMBOL_GPL(iscsi_check_assign_cmdsn);
 
 void iscsi_prep_unsolicit_data_pdu(struct iscsi_cmd_task *ctask,
-				   struct iscsi_data *hdr,
-				   int transport_data_cnt)
+				   struct iscsi_data *hdr)
 {
 	struct iscsi_conn *conn = ctask->conn;
 
@@ -82,14 +81,12 @@ void iscsi_prep_unsolicit_data_pdu(struc
 
 	hdr->itt = ctask->hdr->itt;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
-
-	hdr->offset = cpu_to_be32(ctask->total_length -
-				  transport_data_cnt -
-				  ctask->unsol_count);
+	hdr->offset = cpu_to_be32(ctask->unsol_offset);
 
 	if (ctask->unsol_count > conn->max_xmit_dlength) {
 		hton24(hdr->dlength, conn->max_xmit_dlength);
 		ctask->data_count = conn->max_xmit_dlength;
+		ctask->unsol_offset += ctask->data_count;
 		hdr->flags = 0;
 	} else {
 		hton24(hdr->dlength, ctask->unsol_count);
@@ -125,6 +122,7 @@ static void iscsi_prep_scsi_cmd_pdu(stru
         memcpy(hdr->cdb, sc->cmnd, sc->cmd_len);
         memset(&hdr->cdb[sc->cmd_len], 0, MAX_COMMAND_SIZE - sc->cmd_len);
 
+	ctask->data_count = 0;
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
 		/*
@@ -143,6 +141,7 @@ static void iscsi_prep_scsi_cmd_pdu(stru
 		 */
 		ctask->imm_count = 0;
 		ctask->unsol_count = 0;
+		ctask->unsol_offset = 0;
 		ctask->unsol_datasn = 0;
 
 		if (session->imm_data_en) {
@@ -156,9 +155,12 @@ static void iscsi_prep_scsi_cmd_pdu(stru
 		} else
 			zero_data(ctask->hdr->dlength);
 
-		if (!session->initial_r2t_en)
+		if (!session->initial_r2t_en) {
 			ctask->unsol_count = min(session->first_burst,
 				ctask->total_length) - ctask->imm_count;
+			ctask->unsol_offset = ctask->imm_count;
+		}
+
 		if (!ctask->unsol_count)
 			/* No unsolicit Data-Out's */
 			ctask->hdr->flags |= ISCSI_FLAG_CMD_FINAL;
@@ -1520,11 +1522,18 @@ int iscsi_conn_start(struct iscsi_cls_co
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
 
-	if (session == NULL) {
+	if (!session) {
 		printk(KERN_ERR "iscsi: can't start unbound connection\n");
 		return -EPERM;
 	}
 
+	if (session->first_burst > session->max_burst) {
+		printk("iscsi: invalid burst lengths: "
+		       "first_burst %d max_burst %d\n",
+		       session->first_burst, session->max_burst);
+		return -EINVAL;
+	}
+
 	spin_lock_bh(&session->lock);
 	conn->c_stage = ISCSI_CONN_STARTED;
 	session->state = ISCSI_STATE_LOGGED_IN;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 41904f6..4900650 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -102,6 +102,8 @@ struct iscsi_cmd_task {
 	uint32_t		unsol_datasn;
 	int			imm_count;	/* imm-data (bytes)   */
 	int			unsol_count;	/* unsolicited (bytes)*/
+	/* offset in unsolicited stream (bytes); */
+	int			unsol_offset;
 	int			data_count;	/* remaining Data-Out */
 	struct scsi_cmnd	*sc;		/* associated SCSI cmd*/
 	int			total_length;
@@ -290,8 +292,7 @@ extern int iscsi_conn_get_param(struct i
 extern int iscsi_check_assign_cmdsn(struct iscsi_session *,
 				    struct iscsi_nopin *);
 extern void iscsi_prep_unsolicit_data_pdu(struct iscsi_cmd_task *,
-					struct iscsi_data *hdr,
-					int transport_data_cnt);
+					struct iscsi_data *hdr);
 extern int iscsi_conn_send_pdu(struct iscsi_cls_conn *, struct iscsi_hdr *,
 				char *, uint32_t);
 extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
-- 
1.4.1.1

