From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/9] IB/iser: Convert to CQ abstraction
Date: Fri, 13 Nov 2015 14:46:50 +0100
Message-ID: <1447422410-20891-10-git-send-email-hch@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447422410-20891-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  68 ++++---
 drivers/infiniband/ulp/iser/iser_initiator.c | 142 ++++++++++-----
 drivers/infiniband/ulp/iser/iser_memory.c    |  21 ++-
 drivers/infiniband/ulp/iser/iser_verbs.c     | 258 ++++++---------------------
 4 files changed, 209 insertions(+), 280 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index cf4c4ce..1799c87 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -151,16 +151,12 @@
 					 - ISER_MAX_RX_MISC_PDUS) /	\
 					 (1 + ISER_INFLIGHT_DATAOUTS))
 
-#define ISER_WC_BATCH_COUNT   16
 #define ISER_SIGNAL_CMD_COUNT 32
 
 #define ISER_VER			0x10
 #define ISER_WSV			0x08
 #define ISER_RSV			0x04
 
-#define ISER_FASTREG_LI_WRID		0xffffffffffffffffULL
-#define ISER_BEACON_WRID		0xfffffffffffffffeULL
-
 /**
  * struct iser_hdr - iSER header
  *
@@ -269,7 +265,7 @@ enum iser_desc_type {
 #define ISER_MAX_WRS 7
 
 /**
- * struct iser_tx_desc - iSER TX descriptor (for send wr_id)
+ * struct iser_tx_desc - iSER TX descriptor
  *
  * @iser_header:   iser header
  * @iscsi_header:  iscsi header
@@ -293,6 +289,7 @@ struct iser_tx_desc {
 	u64		             dma_addr;
 	struct ib_sge		     tx_sg[2];
 	int                          num_sge;
+	struct ib_cqe		     cqe;
 	bool			     mapped;
 	u8                           wr_idx;
 	union iser_wr {
@@ -306,9 +303,10 @@ struct iser_tx_desc {
 };
 
 #define ISER_RX_PAD_SIZE	(256 - (ISER_RX_PAYLOAD_SIZE + \
-					sizeof(u64) + sizeof(struct ib_sge)))
+				 sizeof(u64) + sizeof(struct ib_sge) + \
+				 sizeof(struct ib_cqe)))
 /**
- * struct iser_rx_desc - iSER RX descriptor (for recv wr_id)
+ * struct iser_rx_desc - iSER RX descriptor
  *
  * @iser_header:   iser header
  * @iscsi_header:  iscsi header
@@ -323,6 +321,7 @@ struct iser_rx_desc {
 	char		             data[ISER_RECV_DATA_SEG_LEN];
 	u64		             dma_addr;
 	struct ib_sge		     rx_sg;
+	struct ib_cqe		     cqe;
 	char		             pad[ISER_RX_PAD_SIZE];
 } __attribute__((packed));
 
@@ -335,6 +334,7 @@ struct iser_rx_desc {
  * @req_dma:       DMA address of login request buffer
  * @rsp_dma:      DMA address of login response buffer
  * @sge:           IB sge for login post recv
+ * @cqe:           completion handler
  */
 struct iser_login_desc {
 	void                         *req;
@@ -342,6 +342,7 @@ struct iser_login_desc {
 	u64                          req_dma;
 	u64                          rsp_dma;
 	struct ib_sge                sge;
+	struct ib_cqe		     cqe;
 } __attribute__((packed));
 
 
@@ -352,18 +353,12 @@ struct iscsi_iser_task;
 /**
  * struct iser_comp - iSER completion context
  *
- * @device:     pointer to device handle
  * @cq:         completion queue
- * @wcs:        work completion array
- * @tasklet:    Tasklet handle
  * @active_qps: Number of active QPs attached
  *              to completion context
  */
 struct iser_comp {
-	struct iser_device      *device;
 	struct ib_cq		*cq;
-	struct ib_wc		 wcs[ISER_WC_BATCH_COUNT];
-	struct tasklet_struct	 tasklet;
 	int                      active_qps;
 };
 
@@ -492,10 +487,11 @@ struct iser_fr_pool {
  * @rx_wr:               receive work request for batch posts
  * @device:              reference to iser device
  * @comp:                iser completion context
- * @pi_support:          Indicate device T10-PI support
- * @beacon:              beacon send wr to signal all flush errors were drained
- * @flush_comp:          completes when all connection completions consumed
  * @fr_pool:             connection fast registration poool
+ * @pi_support:          Indicate device T10-PI support
+ * @last:                last send wr to signal all flush errors were drained
+ * @last_cqe:            cqe handler for last wr
+ * @last_comp:           completes when all connection completions consumed
  */
 struct ib_conn {
 	struct rdma_cm_id           *cma_id;
@@ -505,10 +501,12 @@ struct ib_conn {
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
 	struct iser_device          *device;
 	struct iser_comp	    *comp;
-	bool			     pi_support;
-	struct ib_send_wr	     beacon;
-	struct completion	     flush_comp;
 	struct iser_fr_pool          fr_pool;
+	bool			     pi_support;
+	struct ib_send_wr	     last;
+	struct ib_cqe		     last_cqe;
+	struct ib_cqe		     reg_cqe;
+	struct completion	     last_comp;
 };
 
 /**
@@ -643,12 +641,14 @@ int iser_conn_terminate(struct iser_conn *iser_conn);
 
 void iser_release_work(struct work_struct *work);
 
-void iser_rcv_completion(struct iser_rx_desc *desc,
-			 unsigned long dto_xfer_len,
-			 struct ib_conn *ib_conn);
-
-void iser_snd_completion(struct iser_tx_desc *desc,
-			 struct ib_conn *ib_conn);
+void iser_err_comp(struct ib_wc *wc, const char *type);
+void iser_login_rsp(struct ib_cq *cq, struct ib_wc *wc);
+void iser_task_rsp(struct ib_cq *cq, struct ib_wc *wc);
+void iser_cmd_comp(struct ib_cq *cq, struct ib_wc *wc);
+void iser_ctrl_comp(struct ib_cq *cq, struct ib_wc *wc);
+void iser_dataout_comp(struct ib_cq *cq, struct ib_wc *wc);
+void iser_reg_comp(struct ib_cq *cq, struct ib_wc *wc);
+void iser_last_comp(struct ib_cq *cq, struct ib_wc *wc);
 
 void iser_task_rdma_init(struct iscsi_iser_task *task);
 
@@ -735,4 +735,22 @@ to_iser_conn(struct ib_conn *ib_conn)
 	return container_of(ib_conn, struct iser_conn, ib_conn);
 }
 
+static inline struct iser_rx_desc *
+iser_rx(struct ib_cqe *cqe)
+{
+	return container_of(cqe, struct iser_rx_desc, cqe);
+}
+
+static inline struct iser_tx_desc *
+iser_tx(struct ib_cqe *cqe)
+{
+	return container_of(cqe, struct iser_tx_desc, cqe);
+}
+
+static inline struct iser_login_desc *
+iser_login(struct ib_cqe *cqe)
+{
+	return container_of(cqe, struct iser_login_desc, cqe);
+}
+
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 21148b6..44ecb89 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -270,11 +270,11 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 			goto rx_desc_dma_map_failed;
 
 		rx_desc->dma_addr = dma_addr;
-
+		rx_desc->cqe.done = iser_task_rsp;
 		rx_sg = &rx_desc->rx_sg;
-		rx_sg->addr   = rx_desc->dma_addr;
+		rx_sg->addr = rx_desc->dma_addr;
 		rx_sg->length = ISER_RX_PAYLOAD_SIZE;
-		rx_sg->lkey   = device->pd->local_dma_lkey;
+		rx_sg->lkey = device->pd->local_dma_lkey;
 	}
 
 	iser_conn->rx_desc_head = 0;
@@ -373,6 +373,7 @@ int iser_send_command(struct iscsi_conn *conn,
 
 	/* build the tx desc regd header and add it to the tx desc dto */
 	tx_desc->type = ISCSI_TX_SCSI_COMMAND;
+	tx_desc->cqe.done = iser_cmd_comp;
 	iser_create_send_desc(iser_conn, tx_desc);
 
 	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
@@ -454,6 +455,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 	}
 
 	tx_desc->type = ISCSI_TX_DATAOUT;
+	tx_desc->cqe.done = iser_dataout_comp;
 	tx_desc->iser_header.flags = ISER_VER;
 	memcpy(&tx_desc->iscsi_header, hdr, sizeof(struct iscsi_hdr));
 
@@ -503,6 +505,7 @@ int iser_send_control(struct iscsi_conn *conn,
 
 	/* build the tx desc regd header and add it to the tx desc dto */
 	mdesc->type = ISCSI_TX_CONTROL;
+	mdesc->cqe.done = iser_ctrl_comp;
 	iser_create_send_desc(iser_conn, mdesc);
 
 	device = iser_conn->ib_conn.device;
@@ -552,44 +555,69 @@ send_control_error:
 	return err;
 }
 
-/**
- * iser_rcv_dto_completion - recv DTO completion
- */
-void iser_rcv_completion(struct iser_rx_desc *rx_desc,
-			 unsigned long rx_xfer_len,
-			 struct ib_conn *ib_conn)
+void iser_login_rsp(struct ib_cq *cq, struct ib_wc *wc)
 {
+	struct ib_conn *ib_conn = wc->qp->qp_context;
 	struct iser_conn *iser_conn = to_iser_conn(ib_conn);
+	struct iser_login_desc *desc = iser_login(wc->wr_cqe);
 	struct iscsi_hdr *hdr;
 	char *data;
-	u64 rx_dma;
-	int rx_buflen, outstanding, count, err;
-
-	/* differentiate between login to all other PDUs */
-	if (rx_desc == (void *)&iser_conn->login_desc) {
-		rx_dma = iser_conn->login_desc.rsp_dma;
-		rx_buflen = ISER_RX_LOGIN_SIZE;
-		hdr = iser_conn->login_desc.rsp + sizeof(struct iser_hdr);
-		data = iser_conn->login_desc.rsp + ISER_HEADERS_LEN;
-	} else {
-		rx_dma = rx_desc->dma_addr;
-		rx_buflen = ISER_RX_PAYLOAD_SIZE;
-		hdr = &rx_desc->iscsi_header;
-		data = rx_desc->data;
+	int length;
+
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
+		iser_err_comp(wc, "login_rsp");
+		return;
+	}
+
+	ib_dma_sync_single_for_cpu(ib_conn->device->ib_device,
+				   desc->rsp_dma, ISER_RX_LOGIN_SIZE,
+				   DMA_FROM_DEVICE);
+
+	hdr = desc->rsp + sizeof(struct iser_hdr);
+	data = desc->rsp + ISER_HEADERS_LEN;
+	length = wc->byte_len - ISER_HEADERS_LEN;
+
+	iser_dbg("op 0x%x itt 0x%x dlen %d\n", hdr->opcode,
+		 hdr->itt, length);
+
+	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, data, length);
+
+	ib_dma_sync_single_for_device(ib_conn->device->ib_device,
+				      desc->rsp_dma, ISER_RX_LOGIN_SIZE,
+				      DMA_FROM_DEVICE);
+
+	ib_conn->post_recv_buf_count--;
+}
+
+void iser_task_rsp(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct ib_conn *ib_conn = wc->qp->qp_context;
+	struct iser_conn *iser_conn = to_iser_conn(ib_conn);
+	struct iser_rx_desc *desc = iser_rx(wc->wr_cqe);
+	struct iscsi_hdr *hdr;
+	int length;
+	int outstanding, count, err;
+
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
+		iser_err_comp(wc, "task_rsp");
+		return;
 	}
 
-	ib_dma_sync_single_for_cpu(ib_conn->device->ib_device, rx_dma,
-				   rx_buflen, DMA_FROM_DEVICE);
+	ib_dma_sync_single_for_cpu(ib_conn->device->ib_device,
+				   desc->dma_addr, ISER_RX_PAYLOAD_SIZE,
+				   DMA_FROM_DEVICE);
 
+	hdr = &desc->iscsi_header;
+	length = wc->byte_len - ISER_HEADERS_LEN;
 
 	iser_dbg("op 0x%x itt 0x%x dlen %d\n", hdr->opcode,
-			hdr->itt, (int)(rx_xfer_len - ISER_HEADERS_LEN));
+		 hdr->itt, length);
 
-	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, data,
-			rx_xfer_len - ISER_HEADERS_LEN);
+	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, desc->data, length);
 
-	ib_dma_sync_single_for_device(ib_conn->device->ib_device, rx_dma,
-				      rx_buflen, DMA_FROM_DEVICE);
+	ib_dma_sync_single_for_device(ib_conn->device->ib_device,
+				      desc->dma_addr, ISER_RX_PAYLOAD_SIZE,
+				      DMA_FROM_DEVICE);
 
 	/* decrementing conn->post_recv_buf_count only --after-- freeing the   *
 	 * task eliminates the need to worry on tasks which are completed in   *
@@ -597,9 +625,6 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	 * for the posted rx bufs refcount to become zero handles everything   */
 	ib_conn->post_recv_buf_count--;
 
-	if (rx_desc == (void *)&iser_conn->login_desc)
-		return;
-
 	outstanding = ib_conn->post_recv_buf_count;
 	if (outstanding + iser_conn->min_posted_rx <= iser_conn->qp_max_recv_dtos) {
 		count = min(iser_conn->qp_max_recv_dtos - outstanding,
@@ -610,26 +635,47 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	}
 }
 
-void iser_snd_completion(struct iser_tx_desc *tx_desc,
-			struct ib_conn *ib_conn)
+void iser_cmd_comp(struct ib_cq *cq, struct ib_wc *wc)
+{
+	if (unlikely(wc->status != IB_WC_SUCCESS))
+		iser_err_comp(wc, "command");
+}
+
+void iser_ctrl_comp(struct ib_cq *cq, struct ib_wc *wc)
 {
+	struct iser_tx_desc *desc = iser_tx(wc->wr_cqe);
 	struct iscsi_task *task;
-	struct iser_device *device = ib_conn->device;
 
-	if (tx_desc->type == ISCSI_TX_DATAOUT) {
-		ib_dma_unmap_single(device->ib_device, tx_desc->dma_addr,
-					ISER_HEADERS_LEN, DMA_TO_DEVICE);
-		kmem_cache_free(ig.desc_cache, tx_desc);
-		tx_desc = NULL;
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
+		iser_err_comp(wc, "control");
+		return;
 	}
 
-	if (tx_desc && tx_desc->type == ISCSI_TX_CONTROL) {
-		/* this arithmetic is legal by libiscsi dd_data allocation */
-		task = (void *) ((long)(void *)tx_desc -
-				  sizeof(struct iscsi_task));
-		if (task->hdr->itt == RESERVED_ITT)
-			iscsi_put_task(task);
-	}
+	/* this arithmetic is legal by libiscsi dd_data allocation */
+	task = (void *)desc - sizeof(struct iscsi_task);
+	if (task->hdr->itt == RESERVED_ITT)
+		iscsi_put_task(task);
+}
+
+void iser_dataout_comp(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct iser_tx_desc *desc = iser_tx(wc->wr_cqe);
+	struct ib_conn *ib_conn = wc->qp->qp_context;
+	struct iser_device *device = ib_conn->device;
+
+	if (unlikely(wc->status != IB_WC_SUCCESS))
+		iser_err_comp(wc, "dataout");
+
+	ib_dma_unmap_single(device->ib_device, desc->dma_addr,
+			    ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	kmem_cache_free(ig.desc_cache, desc);
+}
+
+void iser_last_comp(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct ib_conn *ib_conn = wc->qp->qp_context;
+
+	complete(&ib_conn->last_comp);
 }
 
 void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 81ad5e9..454c8cd 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -67,6 +67,11 @@ static struct iser_reg_ops fmr_ops = {
 	.reg_desc_put	= iser_reg_desc_put_fmr,
 };
 
+void iser_reg_comp(struct ib_cq *cq, struct ib_wc *wc)
+{
+	iser_err_comp(wc, "memreg");
+}
+
 int iser_assign_reg_ops(struct iser_device *device)
 {
 	struct ib_device *ib_dev = device->ib_device;
@@ -413,12 +418,14 @@ iser_set_prot_checks(struct scsi_cmnd *sc, u8 *mask)
 }
 
 static void
-iser_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
+iser_inv_rkey(struct ib_send_wr *inv_wr,
+	      struct ib_mr *mr,
+	      struct ib_cqe *cqe)
 {
 	u32 rkey;
 
 	inv_wr->opcode = IB_WR_LOCAL_INV;
-	inv_wr->wr_id = ISER_FASTREG_LI_WRID;
+	inv_wr->wr_cqe = cqe;
 	inv_wr->ex.invalidate_rkey = mr->rkey;
 	inv_wr->send_flags = 0;
 	inv_wr->num_sge = 0;
@@ -436,6 +443,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 {
 	struct iser_tx_desc *tx_desc = &iser_task->desc;
 	struct ib_sig_attrs *sig_attrs = &tx_desc->sig_attrs;
+	struct ib_cqe *cqe = &iser_task->iser_conn->ib_conn.reg_cqe;
 	struct ib_sig_handover_wr *wr;
 	int ret;
 
@@ -447,11 +455,11 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	iser_set_prot_checks(iser_task->sc, &sig_attrs->check_mask);
 
 	if (!pi_ctx->sig_mr_valid)
-		iser_inv_rkey(iser_tx_next_wr(tx_desc), pi_ctx->sig_mr);
+		iser_inv_rkey(iser_tx_next_wr(tx_desc), pi_ctx->sig_mr, cqe);
 
 	wr = sig_handover_wr(iser_tx_next_wr(tx_desc));
 	wr->wr.opcode = IB_WR_REG_SIG_MR;
-	wr->wr.wr_id = ISER_FASTREG_LI_WRID;
+	wr->wr.wr_cqe = cqe;
 	wr->wr.sg_list = &data_reg->sge;
 	wr->wr.num_sge = 1;
 	wr->wr.send_flags = 0;
@@ -484,12 +492,13 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 			    struct iser_mem_reg *reg)
 {
 	struct iser_tx_desc *tx_desc = &iser_task->desc;
+	struct ib_cqe *cqe = &iser_task->iser_conn->ib_conn.reg_cqe;
 	struct ib_mr *mr = rsc->mr;
 	struct ib_reg_wr *wr;
 	int n;
 
 	if (!rsc->mr_valid)
-		iser_inv_rkey(iser_tx_next_wr(tx_desc), mr);
+		iser_inv_rkey(iser_tx_next_wr(tx_desc), mr, cqe);
 
 	n = ib_map_mr_sg(mr, mem->sg, mem->size, SIZE_4K);
 	if (unlikely(n != mem->size)) {
@@ -500,7 +509,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 
 	wr = reg_wr(iser_tx_next_wr(tx_desc));
 	wr->wr.opcode = IB_WR_REG_MR;
-	wr->wr.wr_id = ISER_FASTREG_LI_WRID;
+	wr->wr.wr_cqe = cqe;
 	wr->wr.send_flags = 0;
 	wr->wr.num_sge = 0;
 	wr->mr = mr;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index f75ef0c..29d9046 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -44,17 +44,6 @@
 #define ISER_MAX_CQ_LEN		(ISER_MAX_RX_LEN + ISER_MAX_TX_LEN + \
 				 ISCSI_ISER_MAX_CONN)
 
-static int iser_cq_poll_limit = 512;
-
-static void iser_cq_tasklet_fn(unsigned long data);
-static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
-
-static void iser_cq_event_callback(struct ib_event *cause, void *context)
-{
-	iser_err("cq event %s (%d)\n",
-		 ib_event_msg(cause->event), cause->event);
-}
-
 static void iser_qp_event_callback(struct ib_event *cause, void *context)
 {
 	iser_err("qp event %s (%d)\n",
@@ -104,27 +93,14 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		goto pd_err;
 
 	for (i = 0; i < device->comps_used; i++) {
-		struct ib_cq_init_attr cq_attr = {};
 		struct iser_comp *comp = &device->comps[i];
 
-		comp->device = device;
-		cq_attr.cqe = max_cqe;
-		cq_attr.comp_vector = i;
-		comp->cq = ib_create_cq(ib_dev,
-					iser_cq_callback,
-					iser_cq_event_callback,
-					(void *)comp,
-					&cq_attr);
+		comp->cq = ib_alloc_cq(ib_dev, comp, max_cqe, i,
+				IB_POLL_SOFTIRQ);
 		if (IS_ERR(comp->cq)) {
 			comp->cq = NULL;
 			goto cq_err;
 		}
-
-		if (ib_req_notify_cq(comp->cq, IB_CQ_NEXT_COMP))
-			goto cq_err;
-
-		tasklet_init(&comp->tasklet, iser_cq_tasklet_fn,
-			     (unsigned long)comp);
 	}
 
 	if (!iser_always_reg) {
@@ -134,7 +110,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
 
 		device->mr = ib_get_dma_mr(device->pd, access);
 		if (IS_ERR(device->mr))
-			goto dma_mr_err;
+			goto cq_err;
 	}
 
 	INIT_IB_EVENT_HANDLER(&device->event_handler, device->ib_device,
@@ -147,15 +123,12 @@ static int iser_create_device_ib_res(struct iser_device *device)
 handler_err:
 	if (device->mr)
 		ib_dereg_mr(device->mr);
-dma_mr_err:
-	for (i = 0; i < device->comps_used; i++)
-		tasklet_kill(&device->comps[i].tasklet);
 cq_err:
 	for (i = 0; i < device->comps_used; i++) {
 		struct iser_comp *comp = &device->comps[i];
 
 		if (comp->cq)
-			ib_destroy_cq(comp->cq);
+			ib_free_cq(comp->cq);
 	}
 	ib_dealloc_pd(device->pd);
 pd_err:
@@ -176,8 +149,7 @@ static void iser_free_device_ib_res(struct iser_device *device)
 	for (i = 0; i < device->comps_used; i++) {
 		struct iser_comp *comp = &device->comps[i];
 
-		tasklet_kill(&comp->tasklet);
-		ib_destroy_cq(comp->cq);
+		ib_free_cq(comp->cq);
 		comp->cq = NULL;
 	}
 
@@ -717,13 +689,13 @@ int iser_conn_terminate(struct iser_conn *iser_conn)
 				 iser_conn, err);
 
 		/* post an indication that all flush errors were consumed */
-		err = ib_post_send(ib_conn->qp, &ib_conn->beacon, &bad_wr);
+		err = ib_post_send(ib_conn->qp, &ib_conn->last, &bad_wr);
 		if (err) {
-			iser_err("conn %p failed to post beacon", ib_conn);
+			iser_err("conn %p failed to post last wr", ib_conn);
 			return 1;
 		}
 
-		wait_for_completion(&ib_conn->flush_comp);
+		wait_for_completion(&ib_conn->last_comp);
 	}
 
 	return 1;
@@ -960,14 +932,21 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 
 void iser_conn_init(struct iser_conn *iser_conn)
 {
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
+
 	iser_conn->state = ISER_CONN_INIT;
-	iser_conn->ib_conn.post_recv_buf_count = 0;
-	init_completion(&iser_conn->ib_conn.flush_comp);
 	init_completion(&iser_conn->stop_completion);
 	init_completion(&iser_conn->ib_completion);
 	init_completion(&iser_conn->up_completion);
 	INIT_LIST_HEAD(&iser_conn->conn_list);
 	mutex_init(&iser_conn->state_mutex);
+
+	ib_conn->post_recv_buf_count = 0;
+	ib_conn->reg_cqe.done = iser_reg_comp;
+	ib_conn->last_cqe.done = iser_last_comp;
+	ib_conn->last.wr_cqe = &ib_conn->last_cqe;
+	ib_conn->last.opcode = IB_WR_SEND;
+	init_completion(&ib_conn->last_comp);
 }
 
  /**
@@ -993,9 +972,6 @@ int iser_connect(struct iser_conn   *iser_conn,
 
 	iser_conn->state = ISER_CONN_PENDING;
 
-	ib_conn->beacon.wr_id = ISER_BEACON_WRID;
-	ib_conn->beacon.opcode = IB_WR_SEND;
-
 	ib_conn->cma_id = rdma_create_id(&init_net, iser_cma_handler,
 					 (void *)iser_conn,
 					 RDMA_PS_TCP, IB_QPT_RC);
@@ -1038,56 +1014,60 @@ connect_failure:
 
 int iser_post_recvl(struct iser_conn *iser_conn)
 {
-	struct ib_recv_wr rx_wr, *rx_wr_failed;
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct iser_login_desc *desc = &iser_conn->login_desc;
+	struct ib_recv_wr wr, *wr_failed;
 	int ib_ret;
 
 	desc->sge.addr = desc->rsp_dma;
 	desc->sge.length = ISER_RX_LOGIN_SIZE;
 	desc->sge.lkey = ib_conn->device->pd->local_dma_lkey;
 
-	rx_wr.wr_id = (uintptr_t)desc;
-	rx_wr.sg_list = &desc->sge;
-	rx_wr.num_sge = 1;
-	rx_wr.next = NULL;
+	desc->cqe.done = iser_login_rsp;
+	wr.wr_cqe = &desc->cqe;
+	wr.sg_list = &desc->sge;
+	wr.num_sge = 1;
+	wr.next = NULL;
 
 	ib_conn->post_recv_buf_count++;
-	ib_ret	= ib_post_recv(ib_conn->qp, &rx_wr, &rx_wr_failed);
+	ib_ret = ib_post_recv(ib_conn->qp, &wr, &wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
 		ib_conn->post_recv_buf_count--;
 	}
+
 	return ib_ret;
 }
 
 int iser_post_recvm(struct iser_conn *iser_conn, int count)
 {
-	struct ib_recv_wr *rx_wr, *rx_wr_failed;
-	int i, ib_ret;
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	unsigned int my_rx_head = iser_conn->rx_desc_head;
 	struct iser_rx_desc *rx_desc;
+	struct ib_recv_wr *wr, *wr_failed;
+	int i, ib_ret;
 
-	for (rx_wr = ib_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
-		rx_desc		= &iser_conn->rx_descs[my_rx_head];
-		rx_wr->wr_id	= (uintptr_t)rx_desc;
-		rx_wr->sg_list	= &rx_desc->rx_sg;
-		rx_wr->num_sge	= 1;
-		rx_wr->next	= rx_wr + 1;
+	for (wr = ib_conn->rx_wr, i = 0; i < count; i++, wr++) {
+		rx_desc = &iser_conn->rx_descs[my_rx_head];
+		rx_desc->cqe.done = iser_task_rsp;
+		wr->wr_cqe = &rx_desc->cqe;
+		wr->sg_list = &rx_desc->rx_sg;
+		wr->num_sge = 1;
+		wr->next = wr + 1;
 		my_rx_head = (my_rx_head + 1) & iser_conn->qp_max_recv_dtos_mask;
 	}
 
-	rx_wr--;
-	rx_wr->next = NULL; /* mark end of work requests list */
+	wr--;
+	wr->next = NULL; /* mark end of work requests list */
 
 	ib_conn->post_recv_buf_count += count;
-	ib_ret	= ib_post_recv(ib_conn->qp, ib_conn->rx_wr, &rx_wr_failed);
+	ib_ret = ib_post_recv(ib_conn->qp, ib_conn->rx_wr, &wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
 		ib_conn->post_recv_buf_count -= count;
 	} else
 		iser_conn->rx_desc_head = my_rx_head;
+
 	return ib_ret;
 }
 
@@ -1108,7 +1088,7 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
 				      DMA_TO_DEVICE);
 
 	wr->next = NULL;
-	wr->wr_id = (uintptr_t)tx_desc;
+	wr->wr_cqe = &tx_desc->cqe;
 	wr->sg_list = tx_desc->tx_sg;
 	wr->num_sge = tx_desc->num_sge;
 	wr->opcode = IB_WR_SEND;
@@ -1122,148 +1102,6 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
 	return ib_ret;
 }
 
-/**
- * is_iser_tx_desc - Indicate if the completion wr_id
- *     is a TX descriptor or not.
- * @iser_conn: iser connection
- * @wr_id: completion WR identifier
- *
- * Since we cannot rely on wc opcode in FLUSH errors
- * we must work around it by checking if the wr_id address
- * falls in the iser connection rx_descs buffer. If so
- * it is an RX descriptor, otherwize it is a TX.
- */
-static inline bool
-is_iser_tx_desc(struct iser_conn *iser_conn, void *wr_id)
-{
-	void *start = iser_conn->rx_descs;
-	int len = iser_conn->num_rx_descs * sizeof(*iser_conn->rx_descs);
-
-	if (wr_id >= start && wr_id < start + len)
-		return false;
-
-	return true;
-}
-
-/**
- * iser_handle_comp_error() - Handle error completion
- * @ib_conn:   connection RDMA resources
- * @wc:        work completion
- *
- * Notes: We may handle a FLUSH error completion and in this case
- *        we only cleanup in case TX type was DATAOUT. For non-FLUSH
- *        error completion we should also notify iscsi layer that
- *        connection is failed (in case we passed bind stage).
- */
-static void
-iser_handle_comp_error(struct ib_conn *ib_conn,
-		       struct ib_wc *wc)
-{
-	struct iser_conn *iser_conn = to_iser_conn(ib_conn);
-	void *wr_id = (void *)(uintptr_t)wc->wr_id;
-
-	if (wc->status != IB_WC_WR_FLUSH_ERR)
-		if (iser_conn->iscsi_conn)
-			iscsi_conn_failure(iser_conn->iscsi_conn,
-					   ISCSI_ERR_CONN_FAILED);
-
-	if (wc->wr_id == ISER_FASTREG_LI_WRID)
-		return;
-
-	if (is_iser_tx_desc(iser_conn, wr_id)) {
-		struct iser_tx_desc *desc = wr_id;
-
-		if (desc->type == ISCSI_TX_DATAOUT)
-			kmem_cache_free(ig.desc_cache, desc);
-	} else {
-		ib_conn->post_recv_buf_count--;
-	}
-}
-
-/**
- * iser_handle_wc - handle a single work completion
- * @wc: work completion
- *
- * Soft-IRQ context, work completion can be either
- * SEND or RECV, and can turn out successful or
- * with error (or flush error).
- */
-static void iser_handle_wc(struct ib_wc *wc)
-{
-	struct ib_conn *ib_conn;
-	struct iser_tx_desc *tx_desc;
-	struct iser_rx_desc *rx_desc;
-
-	ib_conn = wc->qp->qp_context;
-	if (likely(wc->status == IB_WC_SUCCESS)) {
-		if (wc->opcode == IB_WC_RECV) {
-			rx_desc = (struct iser_rx_desc *)(uintptr_t)wc->wr_id;
-			iser_rcv_completion(rx_desc, wc->byte_len,
-					    ib_conn);
-		} else
-		if (wc->opcode == IB_WC_SEND) {
-			tx_desc = (struct iser_tx_desc *)(uintptr_t)wc->wr_id;
-			iser_snd_completion(tx_desc, ib_conn);
-		} else {
-			iser_err("Unknown wc opcode %d\n", wc->opcode);
-		}
-	} else {
-		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			iser_err("%s (%d): wr id %llx vend_err %x\n",
-				 ib_wc_status_msg(wc->status), wc->status,
-				 wc->wr_id, wc->vendor_err);
-		else
-			iser_dbg("%s (%d): wr id %llx\n",
-				 ib_wc_status_msg(wc->status), wc->status,
-				 wc->wr_id);
-
-		if (wc->wr_id == ISER_BEACON_WRID)
-			/* all flush errors were consumed */
-			complete(&ib_conn->flush_comp);
-		else
-			iser_handle_comp_error(ib_conn, wc);
-	}
-}
-
-/**
- * iser_cq_tasklet_fn - iSER completion polling loop
- * @data: iSER completion context
- *
- * Soft-IRQ context, polling connection CQ until
- * either CQ was empty or we exausted polling budget
- */
-static void iser_cq_tasklet_fn(unsigned long data)
-{
-	struct iser_comp *comp = (struct iser_comp *)data;
-	struct ib_cq *cq = comp->cq;
-	struct ib_wc *const wcs = comp->wcs;
-	int i, n, completed = 0;
-
-	while ((n = ib_poll_cq(cq, ARRAY_SIZE(comp->wcs), wcs)) > 0) {
-		for (i = 0; i < n; i++)
-			iser_handle_wc(&wcs[i]);
-
-		completed += n;
-		if (completed >= iser_cq_poll_limit)
-			break;
-	}
-
-	/*
-	 * It is assumed here that arming CQ only once its empty
-	 * would not cause interrupts to be missed.
-	 */
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-
-	iser_dbg("got %d completions\n", completed);
-}
-
-static void iser_cq_callback(struct ib_cq *cq, void *cq_context)
-{
-	struct iser_comp *comp = cq_context;
-
-	tasklet_schedule(&comp->tasklet);
-}
-
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector)
 {
@@ -1311,3 +1149,21 @@ err:
 	/* Not alot we can do here, return ambiguous guard error */
 	return 0x1;
 }
+
+void iser_err_comp(struct ib_wc *wc, const char *type)
+{
+	if (wc->status != IB_WC_WR_FLUSH_ERR) {
+		struct iser_conn *iser_conn = to_iser_conn(wc->qp->qp_context);
+
+		iser_err("%s failure: %s (%d) vend_err %x\n", type,
+			 ib_wc_status_msg(wc->status), wc->status,
+			 wc->vendor_err);
+
+		if (iser_conn->iscsi_conn)
+			iscsi_conn_failure(iser_conn->iscsi_conn,
+					   ISCSI_ERR_CONN_FAILED);
+	} else {
+		iser_dbg("%s failure: %s (%d)\n", type,
+			 ib_wc_status_msg(wc->status), wc->status);
+	}
+}
-- 
1.9.1
