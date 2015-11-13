From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/9] srpt: use the new CQ API
Date: Fri, 13 Nov 2015 14:46:46 +0100
Message-ID: <1447422410-20891-6-git-send-email-hch@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbbKMNvc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2015 08:51:32 -0500
In-Reply-To: <1447422410-20891-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 327 +++++++++-------------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  28 +--
 2 files changed, 88 insertions(+), 267 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 2b6dd71..d4bbad3 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -95,6 +95,8 @@ MODULE_PARM_DESC(srpt_service_guid,
 static struct ib_client srpt_client;
 static void srpt_release_channel(struct srpt_rdma_ch *ch);
 static int srpt_queue_status(struct se_cmd *cmd);
+static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc);
+static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc);
 
 /**
  * opposite_dma_dir() - Swap DMA_TO_DEVICE and DMA_FROM_DEVICE.
@@ -780,12 +782,12 @@ static int srpt_post_recv(struct srpt_device *sdev,
 	struct ib_recv_wr wr, *bad_wr;
 
 	BUG_ON(!sdev);
-	wr.wr_id = encode_wr_id(SRPT_RECV, ioctx->ioctx.index);
-
 	list.addr = ioctx->ioctx.dma;
 	list.length = srp_max_req_size;
 	list.lkey = sdev->pd->local_dma_lkey;
 
+	ioctx->ioctx.cqe.done = srpt_recv_done;
+	wr.wr_cqe = &ioctx->ioctx.cqe;
 	wr.next = NULL;
 	wr.sg_list = &list;
 	wr.num_sge = 1;
@@ -821,8 +823,9 @@ static int srpt_post_send(struct srpt_rdma_ch *ch,
 	list.length = len;
 	list.lkey = sdev->pd->local_dma_lkey;
 
+	ioctx->ioctx.cqe.done = srpt_send_done;
 	wr.next = NULL;
-	wr.wr_id = encode_wr_id(SRPT_SEND, ioctx->ioctx.index);
+	wr.wr_cqe = &ioctx->ioctx.cqe;
 	wr.sg_list = &list;
 	wr.num_sge = 1;
 	wr.opcode = IB_WR_SEND;
@@ -1385,116 +1388,44 @@ out:
 }
 
 /**
- * srpt_handle_send_err_comp() - Process an IB_WC_SEND error completion.
- */
-static void srpt_handle_send_err_comp(struct srpt_rdma_ch *ch, u64 wr_id)
-{
-	struct srpt_send_ioctx *ioctx;
-	enum srpt_command_state state;
-	u32 index;
-
-	atomic_inc(&ch->sq_wr_avail);
-
-	index = idx_from_wr_id(wr_id);
-	ioctx = ch->ioctx_ring[index];
-	state = srpt_get_cmd_state(ioctx);
-
-	WARN_ON(state != SRPT_STATE_CMD_RSP_SENT
-		&& state != SRPT_STATE_MGMT_RSP_SENT
-		&& state != SRPT_STATE_NEED_DATA
-		&& state != SRPT_STATE_DONE);
-
-	/* If SRP_RSP sending failed, undo the ch->req_lim change. */
-	if (state == SRPT_STATE_CMD_RSP_SENT
-	    || state == SRPT_STATE_MGMT_RSP_SENT)
-		atomic_dec(&ch->req_lim);
-
-	srpt_abort_cmd(ioctx);
-}
-
-/**
- * srpt_handle_send_comp() - Process an IB send completion notification.
- */
-static void srpt_handle_send_comp(struct srpt_rdma_ch *ch,
-				  struct srpt_send_ioctx *ioctx)
-{
-	enum srpt_command_state state;
-
-	atomic_inc(&ch->sq_wr_avail);
-
-	state = srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
-
-	if (WARN_ON(state != SRPT_STATE_CMD_RSP_SENT
-		    && state != SRPT_STATE_MGMT_RSP_SENT
-		    && state != SRPT_STATE_DONE))
-		pr_debug("state = %d\n", state);
-
-	if (state != SRPT_STATE_DONE) {
-		srpt_unmap_sg_to_ib_sge(ch, ioctx);
-		transport_generic_free_cmd(&ioctx->cmd, 0);
-	} else {
-		pr_err("IB completion has been received too late for"
-		       " wr_id = %u.\n", ioctx->ioctx.index);
-	}
-}
-
-/**
- * srpt_handle_rdma_comp() - Process an IB RDMA completion notification.
- *
  * XXX: what is now target_execute_cmd used to be asynchronous, and unmapping
  * the data that has been transferred via IB RDMA had to be postponed until the
  * check_stop_free() callback.  None of this is necessary anymore and needs to
  * be cleaned up.
  */
-static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
-				  struct srpt_send_ioctx *ioctx,
-				  enum srpt_opcode opcode)
+static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 {
+	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_send_ioctx *ioctx =
+		container_of(wc->wr_cqe, struct srpt_send_ioctx, ioctx.cqe);
+
 	WARN_ON(ioctx->n_rdma <= 0);
 	atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
 
-	if (opcode == SRPT_RDMA_READ_LAST) {
-		if (srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA,
-						SRPT_STATE_DATA_IN))
-			target_execute_cmd(&ioctx->cmd);
-		else
-			pr_err("%s[%d]: wrong state = %d\n", __func__,
-			       __LINE__, srpt_get_cmd_state(ioctx));
-	} else {
-		WARN(true, "unexpected opcode %d\n", opcode);
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
+		pr_info("RDMA_READ for ioctx 0x%p failed with status %d\n",
+			ioctx, wc->status);
+		srpt_abort_cmd(ioctx);
+		return;
 	}
+
+	if (srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA,
+					SRPT_STATE_DATA_IN))
+		target_execute_cmd(&ioctx->cmd);
+	else
+		pr_err("%s[%d]: wrong state = %d\n", __func__,
+		       __LINE__, srpt_get_cmd_state(ioctx));
 }
 
-/**
- * srpt_handle_rdma_err_comp() - Process an IB RDMA error completion.
- */
-static void srpt_handle_rdma_err_comp(struct srpt_rdma_ch *ch,
-				      struct srpt_send_ioctx *ioctx,
-				      enum srpt_opcode opcode)
+static void srpt_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	enum srpt_command_state state;
+	struct srpt_send_ioctx *ioctx =
+		container_of(wc->wr_cqe, struct srpt_send_ioctx, ioctx.cqe);
 
-	state = srpt_get_cmd_state(ioctx);
-	switch (opcode) {
-	case SRPT_RDMA_READ_LAST:
-		if (ioctx->n_rdma <= 0) {
-			pr_err("Received invalid RDMA read"
-			       " error completion with idx %d\n",
-			       ioctx->ioctx.index);
-			break;
-		}
-		atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
-		if (state == SRPT_STATE_NEED_DATA)
-			srpt_abort_cmd(ioctx);
-		else
-			pr_err("%s[%d]: wrong state = %d\n",
-			       __func__, __LINE__, state);
-		break;
-	case SRPT_RDMA_WRITE_LAST:
-		break;
-	default:
-		pr_err("%s[%d]: opcode = %u\n", __func__, __LINE__, opcode);
-		break;
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
+		pr_info("RDMA_WRITE for ioctx 0x%p failed with status %d\n",
+			ioctx, wc->status);
+		srpt_abort_cmd(ioctx);
 	}
 }
 
@@ -1929,32 +1860,26 @@ out:
 	return;
 }
 
-static void srpt_process_rcv_completion(struct ib_cq *cq,
-					struct srpt_rdma_ch *ch,
-					struct ib_wc *wc)
+static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_device *sdev = ch->sport->sdev;
-	struct srpt_recv_ioctx *ioctx;
-	u32 index;
+	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_recv_ioctx *ioctx =
+		container_of(wc->wr_cqe, struct srpt_recv_ioctx, ioctx.cqe);
 
-	index = idx_from_wr_id(wc->wr_id);
 	if (wc->status == IB_WC_SUCCESS) {
 		int req_lim;
 
 		req_lim = atomic_dec_return(&ch->req_lim);
 		if (unlikely(req_lim < 0))
 			pr_err("req_lim = %d < 0\n", req_lim);
-		ioctx = sdev->ioctx_ring[index];
 		srpt_handle_new_iu(ch, ioctx, NULL);
 	} else {
-		pr_info("receiving failed for idx %u with status %d\n",
-			index, wc->status);
+		pr_info("receiving failed for ioctx %p with status %d\n",
+			ioctx, wc->status);
 	}
 }
 
 /**
- * srpt_process_send_completion() - Process an IB send completion.
- *
  * Note: Although this has not yet been observed during tests, at least in
  * theory it is possible that the srpt_get_send_ioctx() call invoked by
  * srpt_handle_new_iu() fails. This is possible because the req_lim_delta
@@ -1967,108 +1892,52 @@ static void srpt_process_rcv_completion(struct ib_cq *cq,
  * are queued on cmd_wait_list. The code below processes these delayed
  * requests one at a time.
  */
-static void srpt_process_send_completion(struct ib_cq *cq,
-					 struct srpt_rdma_ch *ch,
-					 struct ib_wc *wc)
+static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct srpt_send_ioctx *send_ioctx;
-	uint32_t index;
-	enum srpt_opcode opcode;
+	struct srpt_rdma_ch *ch = cq->cq_context;
+	struct srpt_send_ioctx *ioctx =
+		container_of(wc->wr_cqe, struct srpt_send_ioctx, ioctx.cqe);
+	enum srpt_command_state state;
+		
+	state = srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
 
-	index = idx_from_wr_id(wc->wr_id);
-	opcode = opcode_from_wr_id(wc->wr_id);
-	send_ioctx = ch->ioctx_ring[index];
-	if (wc->status == IB_WC_SUCCESS) {
-		if (opcode == SRPT_SEND)
-			srpt_handle_send_comp(ch, send_ioctx);
-		else {
-			WARN_ON(wc->opcode != IB_WC_RDMA_READ);
-			srpt_handle_rdma_comp(ch, send_ioctx, opcode);
-		}
+	WARN_ON(state != SRPT_STATE_CMD_RSP_SENT &&
+		state != SRPT_STATE_MGMT_RSP_SENT);
+
+	atomic_inc(&ch->sq_wr_avail);
+
+	if (wc->status != IB_WC_SUCCESS) {
+		pr_info("sending response for ioctx 0x%p failed"
+			" with status %d\n", ioctx, wc->status);
+
+		atomic_dec(&ch->req_lim);
+		srpt_abort_cmd(ioctx);
+		goto out;
+	}
+
+	if (state != SRPT_STATE_DONE) {
+		srpt_unmap_sg_to_ib_sge(ch, ioctx);
+		transport_generic_free_cmd(&ioctx->cmd, 0);
 	} else {
-		if (opcode == SRPT_SEND) {
-			pr_info("sending response for idx %u failed"
-				" with status %d\n", index, wc->status);
-			srpt_handle_send_err_comp(ch, wc->wr_id);
-		} else if (opcode != SRPT_RDMA_MID) {
-			pr_info("RDMA t %d for idx %u failed with"
-				" status %d\n", opcode, index, wc->status);
-			srpt_handle_rdma_err_comp(ch, send_ioctx, opcode);
-		}
+		pr_err("IB completion has been received too late for"
+		       " wr_id = %u.\n", ioctx->ioctx.index);
 	}
 
-	while (unlikely(opcode == SRPT_SEND
-			&& !list_empty(&ch->cmd_wait_list)
-			&& srpt_get_ch_state(ch) == CH_LIVE
-			&& (send_ioctx = srpt_get_send_ioctx(ch)) != NULL)) {
+out:
+	while (!list_empty(&ch->cmd_wait_list) &&
+	       srpt_get_ch_state(ch) == CH_LIVE &&
+	       (ioctx = srpt_get_send_ioctx(ch)) != NULL) {
 		struct srpt_recv_ioctx *recv_ioctx;
 
 		recv_ioctx = list_first_entry(&ch->cmd_wait_list,
 					      struct srpt_recv_ioctx,
 					      wait_list);
 		list_del(&recv_ioctx->wait_list);
-		srpt_handle_new_iu(ch, recv_ioctx, send_ioctx);
-	}
-}
-
-static void srpt_process_completion(struct ib_cq *cq, struct srpt_rdma_ch *ch)
-{
-	struct ib_wc *const wc = ch->wc;
-	int i, n;
-
-	WARN_ON(cq != ch->cq);
-
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	while ((n = ib_poll_cq(cq, ARRAY_SIZE(ch->wc), wc)) > 0) {
-		for (i = 0; i < n; i++) {
-			if (opcode_from_wr_id(wc[i].wr_id) == SRPT_RECV)
-				srpt_process_rcv_completion(cq, ch, &wc[i]);
-			else
-				srpt_process_send_completion(cq, ch, &wc[i]);
-		}
+		srpt_handle_new_iu(ch, recv_ioctx, ioctx);
 	}
 }
 
 /**
- * srpt_completion() - IB completion queue callback function.
- *
- * Notes:
- * - It is guaranteed that a completion handler will never be invoked
- *   concurrently on two different CPUs for the same completion queue. See also
- *   Documentation/infiniband/core_locking.txt and the implementation of
- *   handle_edge_irq() in kernel/irq/chip.c.
- * - When threaded IRQs are enabled, completion handlers are invoked in thread
- *   context instead of interrupt context.
- */
-static void srpt_completion(struct ib_cq *cq, void *ctx)
-{
-	struct srpt_rdma_ch *ch = ctx;
-
-	wake_up_interruptible(&ch->wait_queue);
-}
-
-static int srpt_compl_thread(void *arg)
-{
-	struct srpt_rdma_ch *ch;
-
-	/* Hibernation / freezing of the SRPT kernel thread is not supported. */
-	current->flags |= PF_NOFREEZE;
-
-	ch = arg;
-	BUG_ON(!ch);
-	pr_info("Session %s: kernel thread %s (PID %d) started\n",
-		ch->sess_name, ch->thread->comm, current->pid);
-	while (!kthread_should_stop()) {
-		wait_event_interruptible(ch->wait_queue,
-			(srpt_process_completion(ch->cq, ch),
-			 kthread_should_stop()));
-	}
-	pr_info("Session %s: kernel thread %s (PID %d) stopped\n",
-		ch->sess_name, ch->thread->comm, current->pid);
-	return 0;
-}
-
-/**
  * srpt_create_ch_ib() - Create receive and send completion queues.
  */
 static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
@@ -2077,7 +1946,6 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	struct srpt_port *sport = ch->sport;
 	struct srpt_device *sdev = sport->sdev;
 	u32 srp_sq_size = sport->port_attrib.srp_sq_size;
-	struct ib_cq_init_attr cq_attr = {};
 	int ret;
 
 	WARN_ON(ch->rq_size < 1);
@@ -2088,9 +1956,8 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 		goto out;
 
 retry:
-	cq_attr.cqe = ch->rq_size + srp_sq_size;
-	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
-			      &cq_attr);
+	ch->cq = ib_alloc_cq(sdev->device, ch, ch->rq_size + srp_sq_size,
+			0 /* XXX: spread CQs */, IB_POLL_WORKQUEUE);
 	if (IS_ERR(ch->cq)) {
 		ret = PTR_ERR(ch->cq);
 		pr_err("failed to create CQ cqe= %d ret= %d\n",
@@ -2133,18 +2000,6 @@ retry:
 	if (ret)
 		goto err_destroy_qp;
 
-	init_waitqueue_head(&ch->wait_queue);
-
-	pr_debug("creating thread for session %s\n", ch->sess_name);
-
-	ch->thread = kthread_run(srpt_compl_thread, ch, "ib_srpt_compl");
-	if (IS_ERR(ch->thread)) {
-		pr_err("failed to create kernel thread %ld\n",
-		       PTR_ERR(ch->thread));
-		ch->thread = NULL;
-		goto err_destroy_qp;
-	}
-
 out:
 	kfree(qp_init);
 	return ret;
@@ -2152,17 +2007,14 @@ out:
 err_destroy_qp:
 	ib_destroy_qp(ch->qp);
 err_destroy_cq:
-	ib_destroy_cq(ch->cq);
+	ib_free_cq(ch->cq);
 	goto out;
 }
 
 static void srpt_destroy_ch_ib(struct srpt_rdma_ch *ch)
 {
-	if (ch->thread)
-		kthread_stop(ch->thread);
-
 	ib_destroy_qp(ch->qp);
-	ib_destroy_cq(ch->cq);
+	ib_free_cq(ch->cq);
 }
 
 /**
@@ -2824,9 +2676,7 @@ static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
 			      struct srpt_send_ioctx *ioctx)
 {
 	struct ib_send_wr *bad_wr;
-	int i;
-	int ret;
-	int sq_wr_avail;
+	int sq_wr_avail, ret, i;
 	enum dma_data_direction dir;
 	const int n_rdma = ioctx->n_rdma;
 
@@ -2843,29 +2693,24 @@ static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
 	}
 
 	for (i = 0; i < n_rdma; i++) {
-		struct ib_rdma_wr *wr = &ioctx->rdma_ius[i];
-
-		if (dir == DMA_FROM_DEVICE) {
-			wr->wr.opcode = IB_WR_RDMA_WRITE;
-			wr->wr.wr_id = encode_wr_id(i == n_rdma - 1 ?
-						SRPT_RDMA_WRITE_LAST :
-						SRPT_RDMA_MID,
-						ioctx->ioctx.index);
-		} else {
-			wr->wr.opcode = IB_WR_RDMA_READ;
-			wr->wr.wr_id = encode_wr_id(i == n_rdma - 1 ?
-						SRPT_RDMA_READ_LAST :
-						SRPT_RDMA_MID,
-						ioctx->ioctx.index);
-		}
+		struct ib_send_wr *wr = &ioctx->rdma_ius[i].wr;
+
+		wr->opcode = (dir == DMA_FROM_DEVICE) ?
+				IB_WR_RDMA_WRITE : IB_WR_RDMA_READ;
 
 		if (i == n_rdma - 1) {
 			/* only get completion event for the last rdma read */
-			if (dir == DMA_TO_DEVICE)
-				wr->wr.send_flags = IB_SEND_SIGNALED;
-			wr->wr.next = NULL;
+			if (dir == DMA_TO_DEVICE) {
+				wr->send_flags = IB_SEND_SIGNALED;
+				ioctx->rdma_cqe.done = srpt_rdma_read_done;
+			} else {
+				ioctx->rdma_cqe.done = srpt_rdma_write_done;
+			}
+			wr->wr_cqe = &ioctx->rdma_cqe;
+			wr->next = NULL;
 		} else {
-			wr->wr.next = &ioctx->rdma_ius[i + 1].wr;
+			wr->wr_cqe = NULL;
+			wr->next = &ioctx->rdma_ius[i + 1].wr;
 		}
 	}
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index fd6097e..f9568f5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -128,27 +128,6 @@ enum {
 	DEFAULT_MAX_RDMA_SIZE = 65536,
 };
 
-enum srpt_opcode {
-	SRPT_RECV,
-	SRPT_SEND,
-	SRPT_RDMA_MID,
-	SRPT_RDMA_READ_LAST,
-	SRPT_RDMA_WRITE_LAST,
-};
-
-static inline u64 encode_wr_id(u8 opcode, u32 idx)
-{
-	return ((u64)opcode << 32) | idx;
-}
-static inline enum srpt_opcode opcode_from_wr_id(u64 wr_id)
-{
-	return wr_id >> 32;
-}
-static inline u32 idx_from_wr_id(u64 wr_id)
-{
-	return (u32)wr_id;
-}
-
 /**
  * enum srpt_command_state - SCSI command state managed by SRPT.
  * @SRPT_STATE_NEW:           New command arrived and is being processed.
@@ -180,6 +159,7 @@ enum srpt_command_state {
  * @index: Index of the I/O context in its ioctx_ring array.
  */
 struct srpt_ioctx {
+	struct ib_cqe		cqe;
 	void			*buf;
 	dma_addr_t		dma;
 	uint32_t		index;
@@ -218,6 +198,7 @@ struct srpt_send_ioctx {
 	struct srpt_ioctx	ioctx;
 	struct srpt_rdma_ch	*ch;
 	struct ib_rdma_wr	*rdma_ius;
+	struct ib_cqe		rdma_cqe;
 	struct srp_direct_buf	*rbufs;
 	struct srp_direct_buf	single_rbuf;
 	struct scatterlist	*sg;
@@ -255,9 +236,6 @@ enum rdma_ch_state {
 
 /**
  * struct srpt_rdma_ch - RDMA channel.
- * @wait_queue:    Allows the kernel thread to wait for more work.
- * @thread:        Kernel thread that processes the IB queues associated with
- *                 the channel.
  * @cm_id:         IB CM ID associated with the channel.
  * @qp:            IB queue pair used for communicating over this channel.
  * @cq:            IB completion queue for this channel.
@@ -287,8 +265,6 @@ enum rdma_ch_state {
  * @release_done:  Enables waiting for srpt_release_channel() completion.
  */
 struct srpt_rdma_ch {
-	wait_queue_head_t	wait_queue;
-	struct task_struct	*thread;
 	struct ib_cm_id		*cm_id;
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
-- 
1.9.1

