From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/13] IB/srp: use the new CQ API
Date: Mon,  7 Dec 2015 12:51:49 -0800
Message-ID: <1449521512-22921-11-git-send-email-hch@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This also moves recv completion handling from hardirq context into
softirq context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 173 +++++++++++++++++-------------------
 drivers/infiniband/ulp/srp/ib_srp.h |   7 +-
 2 files changed, 86 insertions(+), 94 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 784dd97..d61489e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -132,8 +132,9 @@ MODULE_PARM_DESC(ch_count,
 
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device, void *client_data);
-static void srp_recv_completion(struct ib_cq *cq, void *ch_ptr);
-static void srp_send_completion(struct ib_cq *cq, void *ch_ptr);
+static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc);
+static void srp_handle_qp_err(struct ib_cq *cq, struct ib_wc *wc,
+		const char *opname);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
 
 static struct scsi_transport_template *ib_srp_transport_template;
@@ -445,6 +446,17 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
 				  dev->max_pages_per_mr);
 }
 
+static void srp_drain_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct srp_rdma_ch *ch = cq->cq_context;
+
+	complete(&ch->done);
+}
+
+static struct ib_cqe srp_drain_cqe = {
+	.done		= srp_drain_done,
+};
+
 /**
  * srp_destroy_qp() - destroy an RDMA queue pair
  * @ch: SRP RDMA channel.
@@ -461,7 +473,7 @@ static void srp_destroy_qp(struct srp_rdma_ch *ch)
 	struct ib_recv_wr *bad_wr;
 	int ret;
 
-	wr.wr_id = SRP_LAST_WR_ID;
+	wr.wr_cqe = &srp_drain_cqe;
 	/* Destroying a QP and reusing ch->done is only safe if not connected */
 	WARN_ON_ONCE(ch->connected);
 
@@ -490,34 +502,27 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	struct ib_fmr_pool *fmr_pool = NULL;
 	struct srp_fr_pool *fr_pool = NULL;
 	const int m = 1 + dev->use_fast_reg;
-	struct ib_cq_init_attr cq_attr = {};
 	int ret;
 
 	init_attr = kzalloc(sizeof *init_attr, GFP_KERNEL);
 	if (!init_attr)
 		return -ENOMEM;
 
-	/* + 1 for SRP_LAST_WR_ID */
-	cq_attr.cqe = target->queue_size + 1;
-	cq_attr.comp_vector = ch->comp_vector;
-	recv_cq = ib_create_cq(dev->dev, srp_recv_completion, NULL, ch,
-			       &cq_attr);
+	/* queue_size + 1 for ib_drain_qp */
+	recv_cq = ib_alloc_cq(dev->dev, ch, target->queue_size + 1,
+				ch->comp_vector, IB_POLL_SOFTIRQ);
 	if (IS_ERR(recv_cq)) {
 		ret = PTR_ERR(recv_cq);
 		goto err;
 	}
 
-	cq_attr.cqe = m * target->queue_size;
-	cq_attr.comp_vector = ch->comp_vector;
-	send_cq = ib_create_cq(dev->dev, srp_send_completion, NULL, ch,
-			       &cq_attr);
+	send_cq = ib_alloc_cq(dev->dev, ch, m * target->queue_size,
+				ch->comp_vector, IB_POLL_DIRECT);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
 		goto err_recv_cq;
 	}
 
-	ib_req_notify_cq(recv_cq, IB_CQ_NEXT_COMP);
-
 	init_attr->event_handler       = srp_qp_event;
 	init_attr->cap.max_send_wr     = m * target->queue_size;
 	init_attr->cap.max_recv_wr     = target->queue_size + 1;
@@ -559,9 +564,9 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	if (ch->qp)
 		srp_destroy_qp(ch);
 	if (ch->recv_cq)
-		ib_destroy_cq(ch->recv_cq);
+		ib_free_cq(ch->recv_cq);
 	if (ch->send_cq)
-		ib_destroy_cq(ch->send_cq);
+		ib_free_cq(ch->send_cq);
 
 	ch->qp = qp;
 	ch->recv_cq = recv_cq;
@@ -581,13 +586,13 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	return 0;
 
 err_qp:
-	ib_destroy_qp(qp);
+	srp_destroy_qp(ch);
 
 err_send_cq:
-	ib_destroy_cq(send_cq);
+	ib_free_cq(send_cq);
 
 err_recv_cq:
-	ib_destroy_cq(recv_cq);
+	ib_free_cq(recv_cq);
 
 err:
 	kfree(init_attr);
@@ -623,9 +628,10 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 		if (ch->fmr_pool)
 			ib_destroy_fmr_pool(ch->fmr_pool);
 	}
+
 	srp_destroy_qp(ch);
-	ib_destroy_cq(ch->send_cq);
-	ib_destroy_cq(ch->recv_cq);
+	ib_free_cq(ch->send_cq);
+	ib_free_cq(ch->recv_cq);
 
 	/*
 	 * Avoid that the SCSI error handler tries to use this channel after
@@ -1038,7 +1044,13 @@ static int srp_connect_ch(struct srp_rdma_ch *ch, bool multich)
 	}
 }
 
-static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey)
+static void srp_inv_rkey_err_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	srp_handle_qp_err(cq, wc, "INV RKEY");
+}
+
+static int srp_inv_rkey(struct srp_request *req, struct srp_rdma_ch *ch,
+		u32 rkey)
 {
 	struct ib_send_wr *bad_wr;
 	struct ib_send_wr wr = {
@@ -1049,8 +1061,8 @@ static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey)
 		.ex.invalidate_rkey = rkey,
 	};
 
-	wr.wr_id = LOCAL_INV_WR_ID_MASK;
-
+	wr.wr_cqe = &req->reg_cqe;
+	req->reg_cqe.done = srp_inv_rkey_err_done;
 	return ib_post_send(ch->qp, &wr, &bad_wr);
 }
 
@@ -1072,7 +1084,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		struct srp_fr_desc **pfr;
 
 		for (i = req->nmdesc, pfr = req->fr_list; i > 0; i--, pfr++) {
-			res = srp_inv_rkey(ch, (*pfr)->mr->rkey);
+			res = srp_inv_rkey(req, ch, (*pfr)->mr->rkey);
 			if (res < 0) {
 				shost_printk(KERN_ERR, target->scsi_host, PFX
 				  "Queueing INV WR for rkey %#x failed (%d)\n",
@@ -1310,7 +1322,13 @@ reset_state:
 	return 0;
 }
 
+static void srp_reg_mr_err_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	srp_handle_qp_err(cq, wc, "FAST REG");
+}
+
 static int srp_map_finish_fr(struct srp_map_state *state,
+			     struct srp_request *req,
 			     struct srp_rdma_ch *ch)
 {
 	struct srp_target_port *target = ch->target;
@@ -1348,9 +1366,11 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	if (unlikely(n < 0))
 		return n;
 
+	req->reg_cqe.done = srp_reg_mr_err_done;
+
 	wr.wr.next = NULL;
 	wr.wr.opcode = IB_WR_REG_MR;
-	wr.wr.wr_id = FAST_REG_WR_ID_MASK;
+	wr.wr.wr_cqe = &req->reg_cqe;
 	wr.wr.num_sge = 0;
 	wr.wr.send_flags = 0;
 	wr.mr = desc->mr;
@@ -1455,7 +1475,7 @@ static int srp_map_sg_fr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	while (state->sg_nents) {
 		int i, n;
 
-		n = srp_map_finish_fr(state, ch);
+		n = srp_map_finish_fr(state, req, ch);
 		if (unlikely(n < 0))
 			return n;
 
@@ -1522,7 +1542,7 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
 		state.sg_nents = 1;
 		sg_set_buf(idb_sg, req->indirect_desc, idb_len);
 		idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
-		ret = srp_map_finish_fr(&state, ch);
+		ret = srp_map_finish_fr(&state, req, ch);
 		if (ret < 0)
 			return ret;
 	} else if (dev->use_fmr) {
@@ -1717,7 +1737,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_rdma_ch *ch,
 	s32 rsv = (iu_type == SRP_IU_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
 	struct srp_iu *iu;
 
-	srp_send_completion(ch->send_cq, ch);
+	ib_process_cq_direct(ch->send_cq, -1);
 
 	if (list_empty(&ch->free_tx))
 		return NULL;
@@ -1737,6 +1757,19 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_rdma_ch *ch,
 	return iu;
 }
 
+static void srp_send_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct srp_iu *iu = container_of(wc->wr_cqe, struct srp_iu, cqe);
+	struct srp_rdma_ch *ch = cq->cq_context;
+
+	if (likely(wc->status != IB_WC_SUCCESS)) {
+		srp_handle_qp_err(cq, wc, "SEND");
+		return;
+	}
+
+	list_add(&iu->list, &ch->free_tx);
+}
+
 static int srp_post_send(struct srp_rdma_ch *ch, struct srp_iu *iu, int len)
 {
 	struct srp_target_port *target = ch->target;
@@ -1747,8 +1780,10 @@ static int srp_post_send(struct srp_rdma_ch *ch, struct srp_iu *iu, int len)
 	list.length = len;
 	list.lkey   = target->lkey;
 
+	iu->cqe.done = srp_send_done;
+
 	wr.next       = NULL;
-	wr.wr_id      = (uintptr_t) iu;
+	wr.wr_cqe     = &iu->cqe;
 	wr.sg_list    = &list;
 	wr.num_sge    = 1;
 	wr.opcode     = IB_WR_SEND;
@@ -1767,8 +1802,10 @@ static int srp_post_recv(struct srp_rdma_ch *ch, struct srp_iu *iu)
 	list.length = iu->size;
 	list.lkey   = target->lkey;
 
+	iu->cqe.done = srp_recv_done;
+
 	wr.next     = NULL;
-	wr.wr_id    = (uintptr_t) iu;
+	wr.wr_cqe   = &iu->cqe;
 	wr.sg_list  = &list;
 	wr.num_sge  = 1;
 
@@ -1900,14 +1937,20 @@ static void srp_process_aer_req(struct srp_rdma_ch *ch,
 			     "problems processing SRP_AER_REQ\n");
 }
 
-static void srp_handle_recv(struct srp_rdma_ch *ch, struct ib_wc *wc)
+static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
+	struct srp_iu *iu = container_of(wc->wr_cqe, struct srp_iu, cqe);
+	struct srp_rdma_ch *ch = cq->cq_context;
 	struct srp_target_port *target = ch->target;
 	struct ib_device *dev = target->srp_host->srp_dev->dev;
-	struct srp_iu *iu = (struct srp_iu *) (uintptr_t) wc->wr_id;
 	int res;
 	u8 opcode;
 
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
+		srp_handle_qp_err(cq, wc, "RECV");
+		return;
+	}
+
 	ib_dma_sync_single_for_cpu(dev, iu->dma, ch->max_ti_iu_len,
 				   DMA_FROM_DEVICE);
 
@@ -1970,68 +2013,22 @@ static void srp_tl_err_work(struct work_struct *work)
 		srp_start_tl_fail_timers(target->rport);
 }
 
-static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
-			      bool send_err, struct srp_rdma_ch *ch)
+static void srp_handle_qp_err(struct ib_cq *cq, struct ib_wc *wc,
+		const char *opname)
 {
+	struct srp_rdma_ch *ch = cq->cq_context;
 	struct srp_target_port *target = ch->target;
 
-	if (wr_id == SRP_LAST_WR_ID) {
-		complete(&ch->done);
-		return;
-	}
-
 	if (ch->connected && !target->qp_in_error) {
-		if (wr_id & LOCAL_INV_WR_ID_MASK) {
-			shost_printk(KERN_ERR, target->scsi_host, PFX
-				     "LOCAL_INV failed with status %s (%d)\n",
-				     ib_wc_status_msg(wc_status), wc_status);
-		} else if (wr_id & FAST_REG_WR_ID_MASK) {
-			shost_printk(KERN_ERR, target->scsi_host, PFX
-				     "FAST_REG_MR failed status %s (%d)\n",
-				     ib_wc_status_msg(wc_status), wc_status);
-		} else {
-			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed %s status %s (%d) for iu %p\n",
-				     send_err ? "send" : "receive",
-				     ib_wc_status_msg(wc_status), wc_status,
-				     (void *)(uintptr_t)wr_id);
-		}
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "failed %s status %s (%d) for CQE %p\n",
+			     opname, ib_wc_status_msg(wc->status), wc->status,
+			     wc->wr_cqe);
 		queue_work(system_long_wq, &target->tl_err_work);
 	}
 	target->qp_in_error = true;
 }
 
-static void srp_recv_completion(struct ib_cq *cq, void *ch_ptr)
-{
-	struct srp_rdma_ch *ch = ch_ptr;
-	struct ib_wc wc;
-
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (likely(wc.status == IB_WC_SUCCESS)) {
-			srp_handle_recv(ch, &wc);
-		} else {
-			srp_handle_qp_err(wc.wr_id, wc.status, false, ch);
-		}
-	}
-}
-
-static void srp_send_completion(struct ib_cq *cq, void *ch_ptr)
-{
-	struct srp_rdma_ch *ch = ch_ptr;
-	struct ib_wc wc;
-	struct srp_iu *iu;
-
-	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (likely(wc.status == IB_WC_SUCCESS)) {
-			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
-			list_add(&iu->list, &ch->free_tx);
-		} else {
-			srp_handle_qp_err(wc.wr_id, wc.status, true, ch);
-		}
-	}
-}
-
 static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(shost);
@@ -3571,8 +3568,6 @@ static int __init srp_init_module(void)
 {
 	int ret;
 
-	BUILD_BUG_ON(FIELD_SIZEOF(struct ib_wc, wr_id) < sizeof(void *));
-
 	if (srp_sg_tablesize) {
 		pr_warn("srp_sg_tablesize is deprecated, please use cmd_sg_entries\n");
 		if (!cmd_sg_entries)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 87a2a91..7fec482 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -66,11 +66,6 @@ enum {
 	SRP_TAG_TSK_MGMT	= 1U << 31,
 
 	SRP_MAX_PAGES_PER_MR	= 512,
-
-	LOCAL_INV_WR_ID_MASK	= 1,
-	FAST_REG_WR_ID_MASK	= 2,
-
-	SRP_LAST_WR_ID		= 0xfffffffcU,
 };
 
 enum srp_target_state {
@@ -128,6 +123,7 @@ struct srp_request {
 	struct srp_direct_buf  *indirect_desc;
 	dma_addr_t		indirect_dma_addr;
 	short			nmdesc;
+	struct ib_cqe		reg_cqe;
 };
 
 /**
@@ -231,6 +227,7 @@ struct srp_iu {
 	void		       *buf;
 	size_t			size;
 	enum dma_data_direction	direction;
+	struct ib_cqe		cqe;
 };
 
 /**
-- 
1.9.1
