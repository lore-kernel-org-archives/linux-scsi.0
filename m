From: michaelc@cs.wisc.edu
Subject: [PATCH 16/25] iser: handle iscsi_cmd_task rename
Date: Wed, 21 May 2008 15:54:11 -0500
Message-ID: <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
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
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937053AbYEUUye (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:34 -0400
In-Reply-To: <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This handles the iscsi_cmd_task rename and renames
the iser cmd task to iser task.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  114 ++++++++--------
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   24 ++--
 drivers/infiniband/ulp/iser/iser_initiator.c |  190 +++++++++++++-------------
 drivers/infiniband/ulp/iser/iser_memory.c    |   77 ++++++-----
 4 files changed, 203 insertions(+), 202 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index baecca1..86d9c42 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -124,33 +124,33 @@ error:
 
 
 /**
- * iscsi_iser_task_init - Initialize ctask
- * @ctask: iscsi ctask
+ * iscsi_iser_task_init - Initialize task
+ * @task: iscsi task
  *
- * Initialize the ctask for the scsi command or mgmt command.
+ * Initialize the task for the scsi command or mgmt command.
  */
 static int
-iscsi_iser_task_init(struct iscsi_cmd_task *ctask)
+iscsi_iser_task_init(struct iscsi_task *task)
 {
-	struct iscsi_iser_conn *iser_conn  = ctask->conn->dd_data;
-	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
+	struct iscsi_iser_conn *iser_conn  = task->conn->dd_data;
+	struct iscsi_iser_task *iser_task = task->dd_data;
 
-	/* mgmt ctask */
-	if (!ctask->sc) {
-		iser_ctask->desc.data = ctask->data;
+	/* mgmt task */
+	if (!task->sc) {
+		iser_task->desc.data = task->data;
 		return 0;
 	}
 
-	iser_ctask->command_sent = 0;
-	iser_ctask->iser_conn    = iser_conn;
-	iser_ctask_rdma_init(iser_ctask);
+	iser_task->command_sent = 0;
+	iser_task->iser_conn    = iser_conn;
+	iser_task_rdma_init(iser_task);
 	return 0;
 }
 
 /**
- * iscsi_iser_mtask_xmit - xmit management(immediate) ctask
+ * iscsi_iser_mtask_xmit - xmit management(immediate) task
  * @conn: iscsi connection
- * @ctask: ctask management ctask
+ * @task: task management task
  *
  * Notes:
  *	The function can return -EAGAIN in which case caller must
@@ -159,19 +159,19 @@ iscsi_iser_task_init(struct iscsi_cmd_task *ctask)
  *
  **/
 static int
-iscsi_iser_mtask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_iser_mtask_xmit(struct iscsi_conn *conn, struct iscsi_task *task)
 {
 	int error = 0;
 
-	debug_scsi("ctask deq [cid %d itt 0x%x]\n", conn->id, ctask->itt);
+	debug_scsi("task deq [cid %d itt 0x%x]\n", conn->id, task->itt);
 
-	error = iser_send_control(conn, ctask);
+	error = iser_send_control(conn, task);
 
-	/* since iser xmits control with zero copy, ctasks can not be recycled
+	/* since iser xmits control with zero copy, tasks can not be recycled
 	 * right after sending them.
 	 * The recycling scheme is based on whether a response is expected
-	 * - if yes, the ctask is recycled at iscsi_complete_pdu
-	 * - if no,  the ctask is recycled at iser_snd_completion
+	 * - if yes, the task is recycled at iscsi_complete_pdu
+	 * - if no,  the task is recycled at iser_snd_completion
 	 */
 	if (error && error != -ENOBUFS)
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
@@ -181,27 +181,27 @@ iscsi_iser_mtask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 static int
 iscsi_iser_task_xmit_unsol_data(struct iscsi_conn *conn,
-				 struct iscsi_cmd_task *ctask)
+				 struct iscsi_task *task)
 {
 	struct iscsi_data  hdr;
 	int error = 0;
 
 	/* Send data-out PDUs while there's still unsolicited data to send */
-	while (ctask->unsol_count > 0) {
-		iscsi_prep_unsolicit_data_pdu(ctask, &hdr);
+	while (task->unsol_count > 0) {
+		iscsi_prep_unsolicit_data_pdu(task, &hdr);
 		debug_scsi("Sending data-out: itt 0x%x, data count %d\n",
-			   hdr.itt, ctask->data_count);
+			   hdr.itt, task->data_count);
 
 		/* the buffer description has been passed with the command */
 		/* Send the command */
-		error = iser_send_data_out(conn, ctask, &hdr);
+		error = iser_send_data_out(conn, task, &hdr);
 		if (error) {
-			ctask->unsol_datasn--;
+			task->unsol_datasn--;
 			goto iscsi_iser_task_xmit_unsol_data_exit;
 		}
-		ctask->unsol_count -= ctask->data_count;
+		task->unsol_count -= task->data_count;
 		debug_scsi("Need to send %d more as data-out PDUs\n",
-			   ctask->unsol_count);
+			   task->unsol_count);
 	}
 
 iscsi_iser_task_xmit_unsol_data_exit:
@@ -209,37 +209,37 @@ iscsi_iser_task_xmit_unsol_data_exit:
 }
 
 static int
-iscsi_iser_task_xmit(struct iscsi_cmd_task *ctask)
+iscsi_iser_task_xmit(struct iscsi_task *task)
 {
-	struct iscsi_conn *conn = ctask->conn;
-	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
+	struct iscsi_conn *conn = task->conn;
+	struct iscsi_iser_task *iser_task = task->dd_data;
 	int error = 0;
 
-	if (!ctask->sc)
-		return iscsi_iser_mtask_xmit(conn, ctask);
+	if (!task->sc)
+		return iscsi_iser_mtask_xmit(conn, task);
 
-	if (ctask->sc->sc_data_direction == DMA_TO_DEVICE) {
-		BUG_ON(scsi_bufflen(ctask->sc) == 0);
+	if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
+		BUG_ON(scsi_bufflen(task->sc) == 0);
 
 		debug_scsi("cmd [itt %x total %d imm %d unsol_data %d\n",
-			   ctask->itt, scsi_bufflen(ctask->sc),
-			   ctask->imm_count, ctask->unsol_count);
+			   task->itt, scsi_bufflen(task->sc),
+			   task->imm_count, task->unsol_count);
 	}
 
-	debug_scsi("ctask deq [cid %d itt 0x%x]\n",
-		   conn->id, ctask->itt);
+	debug_scsi("task deq [cid %d itt 0x%x]\n",
+		   conn->id, task->itt);
 
 	/* Send the cmd PDU */
-	if (!iser_ctask->command_sent) {
-		error = iser_send_command(conn, ctask);
+	if (!iser_task->command_sent) {
+		error = iser_send_command(conn, task);
 		if (error)
 			goto iscsi_iser_task_xmit_exit;
-		iser_ctask->command_sent = 1;
+		iser_task->command_sent = 1;
 	}
 
 	/* Send unsolicited data-out PDU(s) if necessary */
-	if (ctask->unsol_count)
-		error = iscsi_iser_task_xmit_unsol_data(conn, ctask);
+	if (task->unsol_count)
+		error = iscsi_iser_task_xmit_unsol_data(conn, task);
 
  iscsi_iser_task_xmit_exit:
 	if (error && error != -ENOBUFS)
@@ -248,17 +248,17 @@ iscsi_iser_task_xmit(struct iscsi_cmd_task *ctask)
 }
 
 static void
-iscsi_iser_cleanup_task(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
+iscsi_iser_cleanup_task(struct iscsi_conn *conn, struct iscsi_task *task)
 {
-	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
+	struct iscsi_iser_task *iser_task = task->dd_data;
 
 	/* mgmt tasks do not need special cleanup */
-	if (!ctask->sc)
+	if (!task->sc)
 		return;
 
-	if (iser_ctask->status == ISER_TASK_STATUS_STARTED) {
-		iser_ctask->status = ISER_TASK_STATUS_COMPLETED;
-		iser_ctask_rdma_finalize(iser_ctask);
+	if (iser_task->status == ISER_TASK_STATUS_STARTED) {
+		iser_task->status = ISER_TASK_STATUS_COMPLETED;
+		iser_task_rdma_finalize(iser_task);
 	}
 }
 
@@ -408,8 +408,8 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	int i;
-	struct iscsi_cmd_task *ctask;
-	struct iscsi_iser_cmd_task *iser_ctask;
+	struct iscsi_task *task;
+	struct iscsi_iser_task *iser_task;
 
 	if (shost) {
 		printk(KERN_ERR "iscsi_tcp: invalid shost %d.\n",
@@ -436,7 +436,7 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 	 */
 	cls_session = iscsi_session_setup(&iscsi_iser_transport, shost,
 					  ISCSI_DEF_XMIT_CMDS_MAX,
-					  sizeof(struct iscsi_iser_cmd_task),
+					  sizeof(struct iscsi_iser_task),
 					  initial_cmdsn);
 	if (!cls_session)
 		goto remove_host;
@@ -445,10 +445,10 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 	shost->can_queue = session->scsi_cmds_max;
 	/* libiscsi setup itts, data and pool so just set desc fields */
 	for (i = 0; i < session->cmds_max; i++) {
-		ctask = session->cmds[i];
-		iser_ctask = ctask->dd_data;
-		ctask->hdr = (struct iscsi_cmd *)&iser_ctask->desc.iscsi_header;
-		ctask->hdr_max = sizeof(iser_ctask->desc.iscsi_header);
+		task = session->cmds[i];
+		iser_task = task->dd_data;
+		task->hdr = (struct iscsi_cmd *)&iser_task->desc.iscsi_header;
+		task->hdr_max = sizeof(iser_task->desc.iscsi_header);
 	}
 	return cls_session;
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 96a600f..05431f2 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -173,7 +173,7 @@ struct iser_data_buf {
 /* fwd declarations */
 struct iser_device;
 struct iscsi_iser_conn;
-struct iscsi_iser_cmd_task;
+struct iscsi_iser_task;
 
 struct iser_mem_reg {
 	u32  lkey;
@@ -197,7 +197,7 @@ struct iser_regd_buf {
 #define MAX_REGD_BUF_VECTOR_LEN	2
 
 struct iser_dto {
-	struct iscsi_iser_cmd_task *ctask;
+	struct iscsi_iser_task *task;
 	struct iser_conn *ib_conn;
 	int                        notify_enable;
 
@@ -265,7 +265,7 @@ struct iscsi_iser_conn {
 	rwlock_t		     lock;
 };
 
-struct iscsi_iser_cmd_task {
+struct iscsi_iser_task {
 	struct iser_desc             desc;
 	struct iscsi_iser_conn	     *iser_conn;
 	enum iser_task_status 	     status;
@@ -299,13 +299,13 @@ extern int iser_debug_level;
 int iser_conn_set_full_featured_mode(struct iscsi_conn *conn);
 
 int iser_send_control(struct iscsi_conn *conn,
-		      struct iscsi_cmd_task *ctask);
+		      struct iscsi_task *task);
 
 int iser_send_command(struct iscsi_conn *conn,
-		      struct iscsi_cmd_task *ctask);
+		      struct iscsi_task *task);
 
 int iser_send_data_out(struct iscsi_conn *conn,
-		       struct iscsi_cmd_task *ctask,
+		       struct iscsi_task *task,
 		       struct iscsi_data *hdr);
 
 void iscsi_iser_recv(struct iscsi_conn *conn,
@@ -326,9 +326,9 @@ void iser_rcv_completion(struct iser_desc *desc,
 
 void iser_snd_completion(struct iser_desc *desc);
 
-void iser_ctask_rdma_init(struct iscsi_iser_cmd_task *ctask);
+void iser_task_rdma_init(struct iscsi_iser_task *task);
 
-void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *ctask);
+void iser_task_rdma_finalize(struct iscsi_iser_task *task);
 
 void iser_dto_buffs_release(struct iser_dto *dto);
 
@@ -338,10 +338,10 @@ void iser_reg_single(struct iser_device      *device,
 		     struct iser_regd_buf    *regd_buf,
 		     enum dma_data_direction direction);
 
-void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *ctask,
+void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *task,
 				     enum iser_data_dir         cmd_dir);
 
-int  iser_reg_rdma_mem(struct iscsi_iser_cmd_task *ctask,
+int  iser_reg_rdma_mem(struct iscsi_iser_task *task,
 		       enum   iser_data_dir        cmd_dir);
 
 int  iser_connect(struct iser_conn   *ib_conn,
@@ -361,10 +361,10 @@ int  iser_post_send(struct iser_desc *tx_desc);
 int iser_conn_state_comp(struct iser_conn *ib_conn,
 			 enum iser_ib_conn_state comp);
 
-int iser_dma_map_task_data(struct iscsi_iser_cmd_task *iser_ctask,
+int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 			    struct iser_data_buf       *data,
 			    enum   iser_data_dir       iser_dir,
 			    enum   dma_data_direction  dma_dir);
 
-void iser_dma_unmap_task_data(struct iscsi_iser_cmd_task *iser_ctask);
+void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 4ea78fb..35af60a 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -66,46 +66,46 @@ static void iser_dto_add_regd_buff(struct iser_dto *dto,
 
 /* Register user buffer memory and initialize passive rdma
  *  dto descriptor. Total data size is stored in
- *  iser_ctask->data[ISER_DIR_IN].data_len
+ *  iser_task->data[ISER_DIR_IN].data_len
  */
-static int iser_prepare_read_cmd(struct iscsi_cmd_task *ctask,
+static int iser_prepare_read_cmd(struct iscsi_task *task,
 				 unsigned int edtl)
 
 {
-	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
+	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_regd_buf *regd_buf;
 	int err;
-	struct iser_hdr *hdr = &iser_ctask->desc.iser_header;
-	struct iser_data_buf *buf_in = &iser_ctask->data[ISER_DIR_IN];
+	struct iser_hdr *hdr = &iser_task->desc.iser_header;
+	struct iser_data_buf *buf_in = &iser_task->data[ISER_DIR_IN];
 
-	err = iser_dma_map_task_data(iser_ctask,
+	err = iser_dma_map_task_data(iser_task,
 				     buf_in,
 				     ISER_DIR_IN,
 				     DMA_FROM_DEVICE);
 	if (err)
 		return err;
 
-	if (edtl > iser_ctask->data[ISER_DIR_IN].data_len) {
+	if (edtl > iser_task->data[ISER_DIR_IN].data_len) {
 		iser_err("Total data length: %ld, less than EDTL: "
 			 "%d, in READ cmd BHS itt: %d, conn: 0x%p\n",
-			 iser_ctask->data[ISER_DIR_IN].data_len, edtl,
-			 ctask->itt, iser_ctask->iser_conn);
+			 iser_task->data[ISER_DIR_IN].data_len, edtl,
+			 task->itt, iser_task->iser_conn);
 		return -EINVAL;
 	}
 
-	err = iser_reg_rdma_mem(iser_ctask,ISER_DIR_IN);
+	err = iser_reg_rdma_mem(iser_task,ISER_DIR_IN);
 	if (err) {
 		iser_err("Failed to set up Data-IN RDMA\n");
 		return err;
 	}
-	regd_buf = &iser_ctask->rdma_regd[ISER_DIR_IN];
+	regd_buf = &iser_task->rdma_regd[ISER_DIR_IN];
 
 	hdr->flags    |= ISER_RSV;
 	hdr->read_stag = cpu_to_be32(regd_buf->reg.rkey);
 	hdr->read_va   = cpu_to_be64(regd_buf->reg.va);
 
 	iser_dbg("Cmd itt:%d READ tags RKEY:%#.4X VA:%#llX\n",
-		 ctask->itt, regd_buf->reg.rkey,
+		 task->itt, regd_buf->reg.rkey,
 		 (unsigned long long)regd_buf->reg.va);
 
 	return 0;
@@ -113,43 +113,43 @@ static int iser_prepare_read_cmd(struct iscsi_cmd_task *ctask,
 
 /* Register user buffer memory and initialize passive rdma
  *  dto descriptor. Total data size is stored in
- *  ctask->data[ISER_DIR_OUT].data_len
+ *  task->data[ISER_DIR_OUT].data_len
  */
 static int
-iser_prepare_write_cmd(struct iscsi_cmd_task *ctask,
+iser_prepare_write_cmd(struct iscsi_task *task,
 		       unsigned int imm_sz,
 		       unsigned int unsol_sz,
 		       unsigned int edtl)
 {
-	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
+	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_regd_buf *regd_buf;
 	int err;
-	struct iser_dto *send_dto = &iser_ctask->desc.dto;
-	struct iser_hdr *hdr = &iser_ctask->desc.iser_header;
-	struct iser_data_buf *buf_out = &iser_ctask->data[ISER_DIR_OUT];
+	struct iser_dto *send_dto = &iser_task->desc.dto;
+	struct iser_hdr *hdr = &iser_task->desc.iser_header;
+	struct iser_data_buf *buf_out = &iser_task->data[ISER_DIR_OUT];
 
-	err = iser_dma_map_task_data(iser_ctask,
+	err = iser_dma_map_task_data(iser_task,
 				     buf_out,
 				     ISER_DIR_OUT,
 				     DMA_TO_DEVICE);
 	if (err)
 		return err;
 
-	if (edtl > iser_ctask->data[ISER_DIR_OUT].data_len) {
+	if (edtl > iser_task->data[ISER_DIR_OUT].data_len) {
 		iser_err("Total data length: %ld, less than EDTL: %d, "
 			 "in WRITE cmd BHS itt: %d, conn: 0x%p\n",
-			 iser_ctask->data[ISER_DIR_OUT].data_len,
-			 edtl, ctask->itt, ctask->conn);
+			 iser_task->data[ISER_DIR_OUT].data_len,
+			 edtl, task->itt, task->conn);
 		return -EINVAL;
 	}
 
-	err = iser_reg_rdma_mem(iser_ctask,ISER_DIR_OUT);
+	err = iser_reg_rdma_mem(iser_task,ISER_DIR_OUT);
 	if (err != 0) {
 		iser_err("Failed to register write cmd RDMA mem\n");
 		return err;
 	}
 
-	regd_buf = &iser_ctask->rdma_regd[ISER_DIR_OUT];
+	regd_buf = &iser_task->rdma_regd[ISER_DIR_OUT];
 
 	if (unsol_sz < edtl) {
 		hdr->flags     |= ISER_WSV;
@@ -158,13 +158,13 @@ iser_prepare_write_cmd(struct iscsi_cmd_task *ctask,
 
 		iser_dbg("Cmd itt:%d, WRITE tags, RKEY:%#.4X "
 			 "VA:%#llX + unsol:%d\n",
-			 ctask->itt, regd_buf->reg.rkey,
+			 task->itt, regd_buf->reg.rkey,
 			 (unsigned long long)regd_buf->reg.va, unsol_sz);
 	}
 
 	if (imm_sz > 0) {
 		iser_dbg("Cmd itt:%d, WRITE, adding imm.data sz: %d\n",
-			 ctask->itt, imm_sz);
+			 task->itt, imm_sz);
 		iser_dto_add_regd_buff(send_dto,
 				       regd_buf,
 				       0,
@@ -300,13 +300,13 @@ int iser_conn_set_full_featured_mode(struct iscsi_conn *conn)
 }
 
 static int
-iser_check_xmit(struct iscsi_conn *conn, void *ctask)
+iser_check_xmit(struct iscsi_conn *conn, void *task)
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
 
 	if (atomic_read(&iser_conn->ib_conn->post_send_buf_count) ==
 	    ISER_QP_MAX_REQ_DTOS) {
-		iser_dbg("%ld can't xmit ctask %p\n",jiffies,ctask);
+		iser_dbg("%ld can't xmit task %p\n",jiffies,task);
 		return -ENOBUFS;
 	}
 	return 0;
@@ -317,37 +317,37 @@ iser_check_xmit(struct iscsi_conn *conn, void *ctask)
  * iser_send_command - send command PDU
  */
 int iser_send_command(struct iscsi_conn *conn,
-		      struct iscsi_cmd_task *ctask)
+		      struct iscsi_task *task)
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
-	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
+	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_dto *send_dto = NULL;
 	unsigned long edtl;
 	int err = 0;
 	struct iser_data_buf *data_buf;
 
-	struct iscsi_cmd *hdr =  ctask->hdr;
-	struct scsi_cmnd *sc  =  ctask->sc;
+	struct iscsi_cmd *hdr =  task->hdr;
+	struct scsi_cmnd *sc  =  task->sc;
 
 	if (!iser_conn_state_comp(iser_conn->ib_conn, ISER_CONN_UP)) {
 		iser_err("Failed to send, conn: 0x%p is not up\n", iser_conn->ib_conn);
 		return -EPERM;
 	}
-	if (iser_check_xmit(conn, ctask))
+	if (iser_check_xmit(conn, task))
 		return -ENOBUFS;
 
 	edtl = ntohl(hdr->data_length);
 
 	/* build the tx desc regd header and add it to the tx desc dto */
-	iser_ctask->desc.type = ISCSI_TX_SCSI_COMMAND;
-	send_dto = &iser_ctask->desc.dto;
-	send_dto->ctask = iser_ctask;
-	iser_create_send_desc(iser_conn, &iser_ctask->desc);
+	iser_task->desc.type = ISCSI_TX_SCSI_COMMAND;
+	send_dto = &iser_task->desc.dto;
+	send_dto->task = iser_task;
+	iser_create_send_desc(iser_conn, &iser_task->desc);
 
 	if (hdr->flags & ISCSI_FLAG_CMD_READ)
-		data_buf = &iser_ctask->data[ISER_DIR_IN];
+		data_buf = &iser_task->data[ISER_DIR_IN];
 	else
-		data_buf = &iser_ctask->data[ISER_DIR_OUT];
+		data_buf = &iser_task->data[ISER_DIR_OUT];
 
 	if (scsi_sg_count(sc)) { /* using a scatter list */
 		data_buf->buf  = scsi_sglist(sc);
@@ -357,15 +357,15 @@ int iser_send_command(struct iscsi_conn *conn,
 	data_buf->data_len = scsi_bufflen(sc);
 
 	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
-		err = iser_prepare_read_cmd(ctask, edtl);
+		err = iser_prepare_read_cmd(task, edtl);
 		if (err)
 			goto send_command_error;
 	}
 	if (hdr->flags & ISCSI_FLAG_CMD_WRITE) {
-		err = iser_prepare_write_cmd(ctask,
-					     ctask->imm_count,
-				             ctask->imm_count +
-					     ctask->unsol_count,
+		err = iser_prepare_write_cmd(task,
+					     task->imm_count,
+				             task->imm_count +
+					     task->unsol_count,
 					     edtl);
 		if (err)
 			goto send_command_error;
@@ -380,15 +380,15 @@ int iser_send_command(struct iscsi_conn *conn,
 		goto send_command_error;
 	}
 
-	iser_ctask->status = ISER_TASK_STATUS_STARTED;
+	iser_task->status = ISER_TASK_STATUS_STARTED;
 
-	err = iser_post_send(&iser_ctask->desc);
+	err = iser_post_send(&iser_task->desc);
 	if (!err)
 		return 0;
 
 send_command_error:
 	iser_dto_buffs_release(send_dto);
-	iser_err("conn %p failed ctask->itt %d err %d\n",conn, ctask->itt, err);
+	iser_err("conn %p failed task->itt %d err %d\n",conn, task->itt, err);
 	return err;
 }
 
@@ -396,11 +396,11 @@ send_command_error:
  * iser_send_data_out - send data out PDU
  */
 int iser_send_data_out(struct iscsi_conn *conn,
-		       struct iscsi_cmd_task *ctask,
+		       struct iscsi_task *task,
 		       struct iscsi_data *hdr)
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
-	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
+	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_desc *tx_desc = NULL;
 	struct iser_dto *send_dto = NULL;
 	unsigned long buf_offset;
@@ -413,7 +413,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 		return -EPERM;
 	}
 
-	if (iser_check_xmit(conn, ctask))
+	if (iser_check_xmit(conn, task))
 		return -ENOBUFS;
 
 	itt = (__force uint32_t)hdr->itt;
@@ -434,7 +434,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 
 	/* build the tx desc regd header and add it to the tx desc dto */
 	send_dto = &tx_desc->dto;
-	send_dto->ctask = iser_ctask;
+	send_dto->task = iser_task;
 	iser_create_send_desc(iser_conn, tx_desc);
 
 	iser_reg_single(iser_conn->ib_conn->device,
@@ -442,15 +442,15 @@ int iser_send_data_out(struct iscsi_conn *conn,
 
 	/* all data was registered for RDMA, we can use the lkey */
 	iser_dto_add_regd_buff(send_dto,
-			       &iser_ctask->rdma_regd[ISER_DIR_OUT],
+			       &iser_task->rdma_regd[ISER_DIR_OUT],
 			       buf_offset,
 			       data_seg_len);
 
-	if (buf_offset + data_seg_len > iser_ctask->data[ISER_DIR_OUT].data_len) {
+	if (buf_offset + data_seg_len > iser_task->data[ISER_DIR_OUT].data_len) {
 		iser_err("Offset:%ld & DSL:%ld in Data-Out "
 			 "inconsistent with total len:%ld, itt:%d\n",
 			 buf_offset, data_seg_len,
-			 iser_ctask->data[ISER_DIR_OUT].data_len, itt);
+			 iser_task->data[ISER_DIR_OUT].data_len, itt);
 		err = -EINVAL;
 		goto send_data_out_error;
 	}
@@ -470,11 +470,11 @@ send_data_out_error:
 }
 
 int iser_send_control(struct iscsi_conn *conn,
-		      struct iscsi_cmd_task *ctask)
+		      struct iscsi_task *task)
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
-	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
-	struct iser_desc *mdesc = &iser_ctask->desc;
+	struct iscsi_iser_task *iser_task = task->dd_data;
+	struct iser_desc *mdesc = &iser_task->desc;
 	struct iser_dto *send_dto = NULL;
 	unsigned long data_seg_len;
 	int err = 0;
@@ -486,27 +486,27 @@ int iser_send_control(struct iscsi_conn *conn,
 		return -EPERM;
 	}
 
-	if (iser_check_xmit(conn, ctask))
+	if (iser_check_xmit(conn, task))
 		return -ENOBUFS;
 
 	/* build the tx desc regd header and add it to the tx desc dto */
 	mdesc->type = ISCSI_TX_CONTROL;
 	send_dto = &mdesc->dto;
-	send_dto->ctask = NULL;
+	send_dto->task = NULL;
 	iser_create_send_desc(iser_conn, mdesc);
 
 	device = iser_conn->ib_conn->device;
 
 	iser_reg_single(device, send_dto->regd[0], DMA_TO_DEVICE);
 
-	data_seg_len = ntoh24(ctask->hdr->dlength);
+	data_seg_len = ntoh24(task->hdr->dlength);
 
 	if (data_seg_len > 0) {
 		regd_buf = &mdesc->data_regd_buf;
 		memset(regd_buf, 0, sizeof(struct iser_regd_buf));
 		regd_buf->device = device;
-		regd_buf->virt_addr = ctask->data;
-		regd_buf->data_size = ctask->data_count;
+		regd_buf->virt_addr = task->data;
+		regd_buf->data_size = task->data_count;
 		iser_reg_single(device, regd_buf,
 				DMA_TO_DEVICE);
 		iser_dto_add_regd_buff(send_dto, regd_buf,
@@ -538,8 +538,8 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 {
 	struct iser_dto *dto = &rx_desc->dto;
 	struct iscsi_iser_conn *conn = dto->ib_conn->iser_conn;
-	struct iscsi_cmd_task *ctask;
-	struct iscsi_iser_cmd_task *iser_ctask;
+	struct iscsi_task *task;
+	struct iscsi_iser_task *iser_task;
 	struct iscsi_hdr *hdr;
 	char   *rx_data = NULL;
 	int     rx_data_len = 0;
@@ -558,16 +558,16 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 
 	if (opcode == ISCSI_OP_SCSI_CMD_RSP) {
-		ctask = iscsi_itt_to_ctask(conn->iscsi_conn, hdr->itt);
-		if (!ctask)
-			iser_err("itt can't be matched to ctask!!! "
+		task = iscsi_itt_to_ctask(conn->iscsi_conn, hdr->itt);
+		if (!task)
+			iser_err("itt can't be matched to task!!! "
 				 "conn %p opcode %d itt %d\n",
 				 conn->iscsi_conn, opcode, hdr->itt);
 		else {
-			iser_ctask = ctask->dd_data;
-			iser_dbg("itt %d ctask %p\n",hdr->itt, ctask);
-			iser_ctask->status = ISER_TASK_STATUS_COMPLETED;
-			iser_ctask_rdma_finalize(iser_ctask);
+			iser_task = task->dd_data;
+			iser_dbg("itt %d task %p\n",hdr->itt, task);
+			iser_task->status = ISER_TASK_STATUS_COMPLETED;
+			iser_task_rdma_finalize(iser_task);
 		}
 	}
 	iser_dto_buffs_release(dto);
@@ -578,7 +578,7 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 	kmem_cache_free(ig.desc_cache, rx_desc);
 
 	/* decrementing conn->post_recv_buf_count only --after-- freeing the   *
-	 * ctask eliminates the need to worry on ctasks which are completed in   *
+	 * task eliminates the need to worry on tasks which are completed in   *
 	 * parallel to the execution of iser_conn_term. So the code that waits *
 	 * for the posted rx bufs refcount to become zero handles everything   */
 	atomic_dec(&conn->ib_conn->post_recv_buf_count);
@@ -590,7 +590,7 @@ void iser_snd_completion(struct iser_desc *tx_desc)
 	struct iser_conn       *ib_conn = dto->ib_conn;
 	struct iscsi_iser_conn *iser_conn = ib_conn->iser_conn;
 	struct iscsi_conn      *conn = iser_conn->iscsi_conn;
-	struct iscsi_cmd_task *ctask;
+	struct iscsi_task *task;
 	int resume_tx = 0;
 
 	iser_dbg("Initiator, Data sent dto=0x%p\n", dto);
@@ -613,31 +613,31 @@ void iser_snd_completion(struct iser_desc *tx_desc)
 
 	if (tx_desc->type == ISCSI_TX_CONTROL) {
 		/* this arithmetic is legal by libiscsi dd_data allocation */
-		ctask = (void *) ((long)(void *)tx_desc -
-				  sizeof(struct iscsi_cmd_task));
-		if (ctask->hdr->itt == RESERVED_ITT)
-			iscsi_put_ctask(ctask);
+		task = (void *) ((long)(void *)tx_desc -
+				  sizeof(struct iscsi_task));
+		if (task->hdr->itt == RESERVED_ITT)
+			iscsi_put_task(task);
 	}
 }
 
-void iser_ctask_rdma_init(struct iscsi_iser_cmd_task *iser_ctask)
+void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
 
 {
-	iser_ctask->status = ISER_TASK_STATUS_INIT;
+	iser_task->status = ISER_TASK_STATUS_INIT;
 
-	iser_ctask->dir[ISER_DIR_IN] = 0;
-	iser_ctask->dir[ISER_DIR_OUT] = 0;
+	iser_task->dir[ISER_DIR_IN] = 0;
+	iser_task->dir[ISER_DIR_OUT] = 0;
 
-	iser_ctask->data[ISER_DIR_IN].data_len  = 0;
-	iser_ctask->data[ISER_DIR_OUT].data_len = 0;
+	iser_task->data[ISER_DIR_IN].data_len  = 0;
+	iser_task->data[ISER_DIR_OUT].data_len = 0;
 
-	memset(&iser_ctask->rdma_regd[ISER_DIR_IN], 0,
+	memset(&iser_task->rdma_regd[ISER_DIR_IN], 0,
 	       sizeof(struct iser_regd_buf));
-	memset(&iser_ctask->rdma_regd[ISER_DIR_OUT], 0,
+	memset(&iser_task->rdma_regd[ISER_DIR_OUT], 0,
 	       sizeof(struct iser_regd_buf));
 }
 
-void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *iser_ctask)
+void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 {
 	int deferred;
 	int is_rdma_aligned = 1;
@@ -646,17 +646,17 @@ void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *iser_ctask)
 	/* if we were reading, copy back to unaligned sglist,
 	 * anyway dma_unmap and free the copy
 	 */
-	if (iser_ctask->data_copy[ISER_DIR_IN].copy_buf != NULL) {
+	if (iser_task->data_copy[ISER_DIR_IN].copy_buf != NULL) {
 		is_rdma_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_ctask, ISER_DIR_IN);
+		iser_finalize_rdma_unaligned_sg(iser_task, ISER_DIR_IN);
 	}
-	if (iser_ctask->data_copy[ISER_DIR_OUT].copy_buf != NULL) {
+	if (iser_task->data_copy[ISER_DIR_OUT].copy_buf != NULL) {
 		is_rdma_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_ctask, ISER_DIR_OUT);
+		iser_finalize_rdma_unaligned_sg(iser_task, ISER_DIR_OUT);
 	}
 
-	if (iser_ctask->dir[ISER_DIR_IN]) {
-		regd = &iser_ctask->rdma_regd[ISER_DIR_IN];
+	if (iser_task->dir[ISER_DIR_IN]) {
+		regd = &iser_task->rdma_regd[ISER_DIR_IN];
 		deferred = iser_regd_buff_release(regd);
 		if (deferred) {
 			iser_err("%d references remain for BUF-IN rdma reg\n",
@@ -664,8 +664,8 @@ void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *iser_ctask)
 		}
 	}
 
-	if (iser_ctask->dir[ISER_DIR_OUT]) {
-		regd = &iser_ctask->rdma_regd[ISER_DIR_OUT];
+	if (iser_task->dir[ISER_DIR_OUT]) {
+		regd = &iser_task->rdma_regd[ISER_DIR_OUT];
 		deferred = iser_regd_buff_release(regd);
 		if (deferred) {
 			iser_err("%d references remain for BUF-OUT rdma reg\n",
@@ -675,7 +675,7 @@ void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *iser_ctask)
 
        /* if the data was unaligned, it was already unmapped and then copied */
        if (is_rdma_aligned)
-		iser_dma_unmap_task_data(iser_ctask);
+		iser_dma_unmap_task_data(iser_task);
 }
 
 void iser_dto_buffs_release(struct iser_dto *dto)
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index cac50c4..48f2a60 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -101,13 +101,13 @@ void iser_reg_single(struct iser_device *device,
 /**
  * iser_start_rdma_unaligned_sg
  */
-static int iser_start_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
+static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 					enum iser_data_dir cmd_dir)
 {
 	int dma_nents;
 	struct ib_device *dev;
 	char *mem = NULL;
-	struct iser_data_buf *data = &iser_ctask->data[cmd_dir];
+	struct iser_data_buf *data = &iser_task->data[cmd_dir];
 	unsigned long  cmd_data_len = data->data_len;
 
 	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
@@ -140,37 +140,37 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 		}
 	}
 
-	sg_init_one(&iser_ctask->data_copy[cmd_dir].sg_single, mem, cmd_data_len);
-	iser_ctask->data_copy[cmd_dir].buf  =
-		&iser_ctask->data_copy[cmd_dir].sg_single;
-	iser_ctask->data_copy[cmd_dir].size = 1;
+	sg_init_one(&iser_task->data_copy[cmd_dir].sg_single, mem, cmd_data_len);
+	iser_task->data_copy[cmd_dir].buf  =
+		&iser_task->data_copy[cmd_dir].sg_single;
+	iser_task->data_copy[cmd_dir].size = 1;
 
-	iser_ctask->data_copy[cmd_dir].copy_buf  = mem;
+	iser_task->data_copy[cmd_dir].copy_buf  = mem;
 
-	dev = iser_ctask->iser_conn->ib_conn->device->ib_device;
+	dev = iser_task->iser_conn->ib_conn->device->ib_device;
 	dma_nents = ib_dma_map_sg(dev,
-				  &iser_ctask->data_copy[cmd_dir].sg_single,
+				  &iser_task->data_copy[cmd_dir].sg_single,
 				  1,
 				  (cmd_dir == ISER_DIR_OUT) ?
 				  DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	BUG_ON(dma_nents == 0);
 
-	iser_ctask->data_copy[cmd_dir].dma_nents = dma_nents;
+	iser_task->data_copy[cmd_dir].dma_nents = dma_nents;
 	return 0;
 }
 
 /**
  * iser_finalize_rdma_unaligned_sg
  */
-void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
+void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 				     enum iser_data_dir         cmd_dir)
 {
 	struct ib_device *dev;
 	struct iser_data_buf *mem_copy;
 	unsigned long  cmd_data_len;
 
-	dev = iser_ctask->iser_conn->ib_conn->device->ib_device;
-	mem_copy = &iser_ctask->data_copy[cmd_dir];
+	dev = iser_task->iser_conn->ib_conn->device->ib_device;
+	mem_copy = &iser_task->data_copy[cmd_dir];
 
 	ib_dma_unmap_sg(dev, &mem_copy->sg_single, 1,
 			(cmd_dir == ISER_DIR_OUT) ?
@@ -186,8 +186,8 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 		/* copy back read RDMA to unaligned sg */
 		mem	= mem_copy->copy_buf;
 
-		sgl	= (struct scatterlist *)iser_ctask->data[ISER_DIR_IN].buf;
-		sg_size = iser_ctask->data[ISER_DIR_IN].size;
+		sgl	= (struct scatterlist *)iser_task->data[ISER_DIR_IN].buf;
+		sg_size = iser_task->data[ISER_DIR_IN].size;
 
 		p = mem;
 		for_each_sg(sgl, sg, sg_size, i) {
@@ -200,7 +200,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 		}
 	}
 
-	cmd_data_len = iser_ctask->data[cmd_dir].data_len;
+	cmd_data_len = iser_task->data[cmd_dir].data_len;
 
 	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
 		free_pages((unsigned long)mem_copy->copy_buf,
@@ -378,15 +378,15 @@ static void iser_page_vec_build(struct iser_data_buf *data,
 	}
 }
 
-int iser_dma_map_task_data(struct iscsi_iser_cmd_task *iser_ctask,
-			    struct iser_data_buf       *data,
-			    enum   iser_data_dir       iser_dir,
-			    enum   dma_data_direction  dma_dir)
+int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
+			    struct iser_data_buf *data,
+			    enum iser_data_dir iser_dir,
+			    enum dma_data_direction dma_dir)
 {
 	struct ib_device *dev;
 
-	iser_ctask->dir[iser_dir] = 1;
-	dev = iser_ctask->iser_conn->ib_conn->device->ib_device;
+	iser_task->dir[iser_dir] = 1;
+	dev = iser_task->iser_conn->ib_conn->device->ib_device;
 
 	data->dma_nents = ib_dma_map_sg(dev, data->buf, data->size, dma_dir);
 	if (data->dma_nents == 0) {
@@ -396,20 +396,20 @@ int iser_dma_map_task_data(struct iscsi_iser_cmd_task *iser_ctask,
 	return 0;
 }
 
-void iser_dma_unmap_task_data(struct iscsi_iser_cmd_task *iser_ctask)
+void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task)
 {
 	struct ib_device *dev;
 	struct iser_data_buf *data;
 
-	dev = iser_ctask->iser_conn->ib_conn->device->ib_device;
+	dev = iser_task->iser_conn->ib_conn->device->ib_device;
 
-	if (iser_ctask->dir[ISER_DIR_IN]) {
-		data = &iser_ctask->data[ISER_DIR_IN];
+	if (iser_task->dir[ISER_DIR_IN]) {
+		data = &iser_task->data[ISER_DIR_IN];
 		ib_dma_unmap_sg(dev, data->buf, data->size, DMA_FROM_DEVICE);
 	}
 
-	if (iser_ctask->dir[ISER_DIR_OUT]) {
-		data = &iser_ctask->data[ISER_DIR_OUT];
+	if (iser_task->dir[ISER_DIR_OUT]) {
+		data = &iser_task->data[ISER_DIR_OUT];
 		ib_dma_unmap_sg(dev, data->buf, data->size, DMA_TO_DEVICE);
 	}
 }
@@ -420,21 +420,21 @@ void iser_dma_unmap_task_data(struct iscsi_iser_cmd_task *iser_ctask)
  *
  * returns 0 on success, errno code on failure
  */
-int iser_reg_rdma_mem(struct iscsi_iser_cmd_task *iser_ctask,
+int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
 		      enum   iser_data_dir        cmd_dir)
 {
-	struct iscsi_conn    *iscsi_conn = iser_ctask->iser_conn->iscsi_conn;
-	struct iser_conn     *ib_conn = iser_ctask->iser_conn->ib_conn;
+	struct iscsi_conn    *iscsi_conn = iser_task->iser_conn->iscsi_conn;
+	struct iser_conn     *ib_conn = iser_task->iser_conn->ib_conn;
 	struct iser_device   *device = ib_conn->device;
 	struct ib_device     *ibdev = device->ib_device;
-	struct iser_data_buf *mem = &iser_ctask->data[cmd_dir];
+	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
 	struct iser_regd_buf *regd_buf;
 	int aligned_len;
 	int err;
 	int i;
 	struct scatterlist *sg;
 
-	regd_buf = &iser_ctask->rdma_regd[cmd_dir];
+	regd_buf = &iser_task->rdma_regd[cmd_dir];
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
@@ -444,13 +444,13 @@ int iser_reg_rdma_mem(struct iscsi_iser_cmd_task *iser_ctask,
 		iser_data_buf_dump(mem, ibdev);
 
 		/* unmap the command data before accessing it */
-		iser_dma_unmap_task_data(iser_ctask);
+		iser_dma_unmap_task_data(iser_task);
 
 		/* allocate copy buf, if we are writing, copy the */
 		/* unaligned scatterlist, dma map the copy        */
-		if (iser_start_rdma_unaligned_sg(iser_ctask, cmd_dir) != 0)
+		if (iser_start_rdma_unaligned_sg(iser_task, cmd_dir) != 0)
 				return -ENOMEM;
-		mem = &iser_ctask->data_copy[cmd_dir];
+		mem = &iser_task->data_copy[cmd_dir];
 	}
 
 	/* if there a single dma entry, FMR is not needed */
@@ -474,8 +474,9 @@ int iser_reg_rdma_mem(struct iscsi_iser_cmd_task *iser_ctask,
 		err = iser_reg_page_vec(ib_conn, ib_conn->page_vec, &regd_buf->reg);
 		if (err) {
 			iser_data_buf_dump(mem, ibdev);
-			iser_err("mem->dma_nents = %d (dlength = 0x%x)\n", mem->dma_nents,
-				 ntoh24(iser_ctask->desc.iscsi_header.dlength));
+			iser_err("mem->dma_nents = %d (dlength = 0x%x)\n",
+				 mem->dma_nents,
+				 ntoh24(iser_task->desc.iscsi_header.dlength));
 			iser_err("page_vec: data_size = 0x%x, length = %d, offset = 0x%x\n",
 				 ib_conn->page_vec->data_size, ib_conn->page_vec->length,
 				 ib_conn->page_vec->offset);
-- 
1.5.4.1

