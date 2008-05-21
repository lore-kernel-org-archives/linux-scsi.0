From: michaelc@cs.wisc.edu
Subject: [PATCH 13/25] iser: convert ib_iser to support merged tasks
Date: Wed, 21 May 2008 15:54:08 -0500
Message-ID: <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936932AbYEUUyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:32 -0400
In-Reply-To: <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Convert ib_iser to support merged tasks.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   82 +++++++++++++-------------
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   14 ++--
 drivers/infiniband/ulp/iser/iser_initiator.c |   42 ++++++-------
 3 files changed, 68 insertions(+), 70 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 7b14688..baecca1 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -124,15 +124,23 @@ error:
 
 
 /**
- * iscsi_iser_cmd_init - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
+ * iscsi_iser_task_init - Initialize ctask
+ * @ctask: iscsi ctask
  *
- **/
+ * Initialize the ctask for the scsi command or mgmt command.
+ */
 static int
-iscsi_iser_cmd_init(struct iscsi_cmd_task *ctask)
+iscsi_iser_task_init(struct iscsi_cmd_task *ctask)
 {
-	struct iscsi_iser_conn     *iser_conn  = ctask->conn->dd_data;
+	struct iscsi_iser_conn *iser_conn  = ctask->conn->dd_data;
 	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
 
+	/* mgmt ctask */
+	if (!ctask->sc) {
+		iser_ctask->desc.data = ctask->data;
+		return 0;
+	}
+
 	iser_ctask->command_sent = 0;
 	iser_ctask->iser_conn    = iser_conn;
 	iser_ctask_rdma_init(iser_ctask);
@@ -140,9 +148,9 @@ iscsi_iser_cmd_init(struct iscsi_cmd_task *ctask)
 }
 
 /**
- * iscsi_mtask_xmit - xmit management(immediate) task
+ * iscsi_iser_mtask_xmit - xmit management(immediate) ctask
  * @conn: iscsi connection
- * @mtask: task management task
+ * @ctask: ctask management ctask
  *
  * Notes:
  *	The function can return -EAGAIN in which case caller must
@@ -151,20 +159,19 @@ iscsi_iser_cmd_init(struct iscsi_cmd_task *ctask)
  *
  **/
 static int
-iscsi_iser_mtask_xmit(struct iscsi_conn *conn,
-		      struct iscsi_mgmt_task *mtask)
+iscsi_iser_mtask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	int error = 0;
 
-	debug_scsi("mtask deq [cid %d itt 0x%x]\n", conn->id, mtask->itt);
+	debug_scsi("ctask deq [cid %d itt 0x%x]\n", conn->id, ctask->itt);
 
-	error = iser_send_control(conn, mtask);
+	error = iser_send_control(conn, ctask);
 
-	/* since iser xmits control with zero copy, mtasks can not be recycled
+	/* since iser xmits control with zero copy, ctasks can not be recycled
 	 * right after sending them.
 	 * The recycling scheme is based on whether a response is expected
-	 * - if yes, the mtask is recycled at iscsi_complete_pdu
-	 * - if no,  the mtask is recycled at iser_snd_completion
+	 * - if yes, the ctask is recycled at iscsi_complete_pdu
+	 * - if no,  the ctask is recycled at iser_snd_completion
 	 */
 	if (error && error != -ENOBUFS)
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
@@ -173,7 +180,7 @@ iscsi_iser_mtask_xmit(struct iscsi_conn *conn,
 }
 
 static int
-iscsi_iser_ctask_xmit_unsol_data(struct iscsi_conn *conn,
+iscsi_iser_task_xmit_unsol_data(struct iscsi_conn *conn,
 				 struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_data  hdr;
@@ -190,24 +197,27 @@ iscsi_iser_ctask_xmit_unsol_data(struct iscsi_conn *conn,
 		error = iser_send_data_out(conn, ctask, &hdr);
 		if (error) {
 			ctask->unsol_datasn--;
-			goto iscsi_iser_ctask_xmit_unsol_data_exit;
+			goto iscsi_iser_task_xmit_unsol_data_exit;
 		}
 		ctask->unsol_count -= ctask->data_count;
 		debug_scsi("Need to send %d more as data-out PDUs\n",
 			   ctask->unsol_count);
 	}
 
-iscsi_iser_ctask_xmit_unsol_data_exit:
+iscsi_iser_task_xmit_unsol_data_exit:
 	return error;
 }
 
 static int
-iscsi_iser_ctask_xmit(struct iscsi_conn *conn,
-		      struct iscsi_cmd_task *ctask)
+iscsi_iser_task_xmit(struct iscsi_cmd_task *ctask)
 {
+	struct iscsi_conn *conn = ctask->conn;
 	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
 	int error = 0;
 
+	if (!ctask->sc)
+		return iscsi_iser_mtask_xmit(conn, ctask);
+
 	if (ctask->sc->sc_data_direction == DMA_TO_DEVICE) {
 		BUG_ON(scsi_bufflen(ctask->sc) == 0);
 
@@ -223,25 +233,29 @@ iscsi_iser_ctask_xmit(struct iscsi_conn *conn,
 	if (!iser_ctask->command_sent) {
 		error = iser_send_command(conn, ctask);
 		if (error)
-			goto iscsi_iser_ctask_xmit_exit;
+			goto iscsi_iser_task_xmit_exit;
 		iser_ctask->command_sent = 1;
 	}
 
 	/* Send unsolicited data-out PDU(s) if necessary */
 	if (ctask->unsol_count)
-		error = iscsi_iser_ctask_xmit_unsol_data(conn, ctask);
+		error = iscsi_iser_task_xmit_unsol_data(conn, ctask);
 
- iscsi_iser_ctask_xmit_exit:
+ iscsi_iser_task_xmit_exit:
 	if (error && error != -ENOBUFS)
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 	return error;
 }
 
 static void
-iscsi_iser_cleanup_ctask(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_iser_cleanup_task(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
 
+	/* mgmt tasks do not need special cleanup */
+	if (!ctask->sc)
+		return;
+
 	if (iser_ctask->status == ISER_TASK_STATUS_STARTED) {
 		iser_ctask->status = ISER_TASK_STATUS_COMPLETED;
 		iser_ctask_rdma_finalize(iser_ctask);
@@ -394,10 +408,8 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	int i;
-	struct iscsi_cmd_task  *ctask;
-	struct iscsi_mgmt_task *mtask;
+	struct iscsi_cmd_task *ctask;
 	struct iscsi_iser_cmd_task *iser_ctask;
-	struct iser_desc *desc;
 
 	if (shost) {
 		printk(KERN_ERR "iscsi_tcp: invalid shost %d.\n",
@@ -425,28 +437,19 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 	cls_session = iscsi_session_setup(&iscsi_iser_transport, shost,
 					  ISCSI_DEF_XMIT_CMDS_MAX,
 					  sizeof(struct iscsi_iser_cmd_task),
-					  sizeof(struct iser_desc),
 					  initial_cmdsn);
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
 
-	shost->can_queue = session->cmds_max;
+	shost->can_queue = session->scsi_cmds_max;
 	/* libiscsi setup itts, data and pool so just set desc fields */
 	for (i = 0; i < session->cmds_max; i++) {
-		ctask      = session->cmds[i];
+		ctask = session->cmds[i];
 		iser_ctask = ctask->dd_data;
 		ctask->hdr = (struct iscsi_cmd *)&iser_ctask->desc.iscsi_header;
 		ctask->hdr_max = sizeof(iser_ctask->desc.iscsi_header);
 	}
-
-	for (i = 0; i < session->mgmtpool_max; i++) {
-		mtask      = session->mgmt_cmds[i];
-		desc       = mtask->dd_data;
-		mtask->hdr = &desc->iscsi_header;
-		desc->data = mtask->data;
-	}
-
 	return cls_session;
 
 remove_host:
@@ -659,10 +662,9 @@ static struct iscsi_transport iscsi_iser_transport = {
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_iser_conn_get_stats,
-	.init_cmd_task		= iscsi_iser_cmd_init,
-	.xmit_cmd_task		= iscsi_iser_ctask_xmit,
-	.xmit_mgmt_task		= iscsi_iser_mtask_xmit,
-	.cleanup_cmd_task	= iscsi_iser_cleanup_ctask,
+	.init_task		= iscsi_iser_task_init,
+	.xmit_task		= iscsi_iser_task_xmit,
+	.cleanup_task		= iscsi_iser_cleanup_task,
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index bd5c1a5..96a600f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -298,15 +298,15 @@ extern int iser_debug_level;
 /* allocate connection resources needed for rdma functionality */
 int iser_conn_set_full_featured_mode(struct iscsi_conn *conn);
 
-int iser_send_control(struct iscsi_conn      *conn,
-		      struct iscsi_mgmt_task *mtask);
+int iser_send_control(struct iscsi_conn *conn,
+		      struct iscsi_cmd_task *ctask);
 
-int iser_send_command(struct iscsi_conn      *conn,
-		      struct iscsi_cmd_task  *ctask);
+int iser_send_command(struct iscsi_conn *conn,
+		      struct iscsi_cmd_task *ctask);
 
-int iser_send_data_out(struct iscsi_conn     *conn,
+int iser_send_data_out(struct iscsi_conn *conn,
 		       struct iscsi_cmd_task *ctask,
-		       struct iscsi_data          *hdr);
+		       struct iscsi_data *hdr);
 
 void iscsi_iser_recv(struct iscsi_conn *conn,
 		     struct iscsi_hdr       *hdr,
@@ -326,7 +326,7 @@ void iser_rcv_completion(struct iser_desc *desc,
 
 void iser_snd_completion(struct iser_desc *desc);
 
-void iser_ctask_rdma_init(struct iscsi_iser_cmd_task     *ctask);
+void iser_ctask_rdma_init(struct iscsi_iser_cmd_task *ctask);
 
 void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *ctask);
 
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index b82a5f2..4ea78fb 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -300,13 +300,13 @@ int iser_conn_set_full_featured_mode(struct iscsi_conn *conn)
 }
 
 static int
-iser_check_xmit(struct iscsi_conn *conn, void *task)
+iser_check_xmit(struct iscsi_conn *conn, void *ctask)
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
 
 	if (atomic_read(&iser_conn->ib_conn->post_send_buf_count) ==
 	    ISER_QP_MAX_REQ_DTOS) {
-		iser_dbg("%ld can't xmit task %p\n",jiffies,task);
+		iser_dbg("%ld can't xmit ctask %p\n",jiffies,ctask);
 		return -ENOBUFS;
 	}
 	return 0;
@@ -316,7 +316,7 @@ iser_check_xmit(struct iscsi_conn *conn, void *task)
 /**
  * iser_send_command - send command PDU
  */
-int iser_send_command(struct iscsi_conn     *conn,
+int iser_send_command(struct iscsi_conn *conn,
 		      struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
@@ -395,7 +395,7 @@ send_command_error:
 /**
  * iser_send_data_out - send data out PDU
  */
-int iser_send_data_out(struct iscsi_conn     *conn,
+int iser_send_data_out(struct iscsi_conn *conn,
 		       struct iscsi_cmd_task *ctask,
 		       struct iscsi_data *hdr)
 {
@@ -470,10 +470,11 @@ send_data_out_error:
 }
 
 int iser_send_control(struct iscsi_conn *conn,
-		      struct iscsi_mgmt_task *mtask)
+		      struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
-	struct iser_desc *mdesc = mtask->dd_data;
+	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
+	struct iser_desc *mdesc = &iser_ctask->desc;
 	struct iser_dto *send_dto = NULL;
 	unsigned long data_seg_len;
 	int err = 0;
@@ -485,7 +486,7 @@ int iser_send_control(struct iscsi_conn *conn,
 		return -EPERM;
 	}
 
-	if (iser_check_xmit(conn,mtask))
+	if (iser_check_xmit(conn, ctask))
 		return -ENOBUFS;
 
 	/* build the tx desc regd header and add it to the tx desc dto */
@@ -498,14 +499,14 @@ int iser_send_control(struct iscsi_conn *conn,
 
 	iser_reg_single(device, send_dto->regd[0], DMA_TO_DEVICE);
 
-	data_seg_len = ntoh24(mtask->hdr->dlength);
+	data_seg_len = ntoh24(ctask->hdr->dlength);
 
 	if (data_seg_len > 0) {
 		regd_buf = &mdesc->data_regd_buf;
 		memset(regd_buf, 0, sizeof(struct iser_regd_buf));
 		regd_buf->device = device;
-		regd_buf->virt_addr = mtask->data;
-		regd_buf->data_size = mtask->data_count;
+		regd_buf->virt_addr = ctask->data;
+		regd_buf->data_size = ctask->data_count;
 		iser_reg_single(device, regd_buf,
 				DMA_TO_DEVICE);
 		iser_dto_add_regd_buff(send_dto, regd_buf,
@@ -535,7 +536,7 @@ send_control_error:
 void iser_rcv_completion(struct iser_desc *rx_desc,
 			 unsigned long dto_xfer_len)
 {
-	struct iser_dto        *dto = &rx_desc->dto;
+	struct iser_dto *dto = &rx_desc->dto;
 	struct iscsi_iser_conn *conn = dto->ib_conn->iser_conn;
 	struct iscsi_cmd_task *ctask;
 	struct iscsi_iser_cmd_task *iser_ctask;
@@ -559,7 +560,7 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 	if (opcode == ISCSI_OP_SCSI_CMD_RSP) {
 		ctask = iscsi_itt_to_ctask(conn->iscsi_conn, hdr->itt);
 		if (!ctask)
-			iser_err("itt can't be matched to task!!! "
+			iser_err("itt can't be matched to ctask!!! "
 				 "conn %p opcode %d itt %d\n",
 				 conn->iscsi_conn, opcode, hdr->itt);
 		else {
@@ -577,7 +578,7 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 	kmem_cache_free(ig.desc_cache, rx_desc);
 
 	/* decrementing conn->post_recv_buf_count only --after-- freeing the   *
-	 * task eliminates the need to worry on tasks which are completed in   *
+	 * ctask eliminates the need to worry on ctasks which are completed in   *
 	 * parallel to the execution of iser_conn_term. So the code that waits *
 	 * for the posted rx bufs refcount to become zero handles everything   */
 	atomic_dec(&conn->ib_conn->post_recv_buf_count);
@@ -589,7 +590,7 @@ void iser_snd_completion(struct iser_desc *tx_desc)
 	struct iser_conn       *ib_conn = dto->ib_conn;
 	struct iscsi_iser_conn *iser_conn = ib_conn->iser_conn;
 	struct iscsi_conn      *conn = iser_conn->iscsi_conn;
-	struct iscsi_mgmt_task *mtask;
+	struct iscsi_cmd_task *ctask;
 	int resume_tx = 0;
 
 	iser_dbg("Initiator, Data sent dto=0x%p\n", dto);
@@ -612,15 +613,10 @@ void iser_snd_completion(struct iser_desc *tx_desc)
 
 	if (tx_desc->type == ISCSI_TX_CONTROL) {
 		/* this arithmetic is legal by libiscsi dd_data allocation */
-		mtask = (void *) ((long)(void *)tx_desc -
-				  sizeof(struct iscsi_mgmt_task));
-		if (mtask->hdr->itt == RESERVED_ITT) {
-			struct iscsi_session *session = conn->session;
-
-			spin_lock(&conn->session->lock);
-			iscsi_free_mgmt_task(conn, mtask);
-			spin_unlock(&session->lock);
-		}
+		ctask = (void *) ((long)(void *)tx_desc -
+				  sizeof(struct iscsi_cmd_task));
+		if (ctask->hdr->itt == RESERVED_ITT)
+			iscsi_put_ctask(ctask);
 	}
 }
 
-- 
1.5.4.1

