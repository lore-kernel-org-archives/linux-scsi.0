From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 7/8] IB/srp: Separate target and channel variables
Date: Fri, 19 Sep 2014 14:59:52 +0200
Message-ID: <541C28C8.7000007@acm.org>
References: <541C27BF.6070609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:53631 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbaISM7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 08:59:54 -0400
In-Reply-To: <541C27BF.6070609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

Changes in this patch:
- Move channel variables into a new structure (struct srp_rdma_ch).
- cm_id and completion handler context pointer are now of type
  srp_rdma_ch * insteoad of srp_target_port *.

No functionality is changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 707 +++++++++++++++++++-----------------
 drivers/infiniband/ulp/srp/ib_srp.h |  59 +--
 2 files changed, 417 insertions(+), 349 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fd88fb8..9feeea1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -125,8 +125,8 @@ MODULE_PARM_DESC(dev_loss_tmo,
 
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
-static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
-static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
+static void srp_recv_completion(struct ib_cq *cq, void *ch_ptr);
+static void srp_send_completion(struct ib_cq *cq, void *ch_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
 
 static struct scsi_transport_template *ib_srp_transport_template;
@@ -262,7 +262,7 @@ static int srp_init_qp(struct srp_target_port *target,
 
 	ret = ib_find_pkey(target->srp_host->srp_dev->dev,
 			   target->srp_host->port,
-			   be16_to_cpu(target->path.pkey),
+			   be16_to_cpu(target->pkey),
 			   &attr->pkey_index);
 	if (ret)
 		goto out;
@@ -283,18 +283,23 @@ out:
 	return ret;
 }
 
-static int srp_new_cm_id(struct srp_target_port *target)
+static int srp_new_cm_id(struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	struct ib_cm_id *new_cm_id;
 
 	new_cm_id = ib_create_cm_id(target->srp_host->srp_dev->dev,
-				    srp_cm_handler, target);
+				    srp_cm_handler, ch);
 	if (IS_ERR(new_cm_id))
 		return PTR_ERR(new_cm_id);
 
-	if (target->cm_id)
-		ib_destroy_cm_id(target->cm_id);
-	target->cm_id = new_cm_id;
+	if (ch->cm_id)
+		ib_destroy_cm_id(ch->cm_id);
+	ch->cm_id = new_cm_id;
+	ch->path.sgid = target->sgid;
+	ch->path.dgid = target->orig_dgid;
+	ch->path.pkey = target->pkey;
+	ch->path.service_id = target->service_id;
 
 	return 0;
 }
@@ -443,8 +448,9 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
 				  dev->max_pages_per_mr);
 }
 
-static int srp_create_target_ib(struct srp_target_port *target)
+static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_qp_init_attr *init_attr;
 	struct ib_cq *recv_cq, *send_cq;
@@ -458,15 +464,15 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	if (!init_attr)
 		return -ENOMEM;
 
-	recv_cq = ib_create_cq(dev->dev, srp_recv_completion, NULL, target,
-			       target->queue_size, target->comp_vector);
+	recv_cq = ib_create_cq(dev->dev, srp_recv_completion, NULL, ch,
+			       target->queue_size, ch->comp_vector);
 	if (IS_ERR(recv_cq)) {
 		ret = PTR_ERR(recv_cq);
 		goto err;
 	}
 
-	send_cq = ib_create_cq(dev->dev, srp_send_completion, NULL, target,
-			       m * target->queue_size, target->comp_vector);
+	send_cq = ib_create_cq(dev->dev, srp_send_completion, NULL, ch,
+			       m * target->queue_size, ch->comp_vector);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
 		goto err_recv_cq;
@@ -502,9 +508,9 @@ static int srp_create_target_ib(struct srp_target_port *target)
 				     "FR pool allocation failed (%d)\n", ret);
 			goto err_qp;
 		}
-		if (target->fr_pool)
-			srp_destroy_fr_pool(target->fr_pool);
-		target->fr_pool = fr_pool;
+		if (ch->fr_pool)
+			srp_destroy_fr_pool(ch->fr_pool);
+		ch->fr_pool = fr_pool;
 	} else if (!dev->use_fast_reg && dev->has_fmr) {
 		fmr_pool = srp_alloc_fmr_pool(target);
 		if (IS_ERR(fmr_pool)) {
@@ -513,21 +519,21 @@ static int srp_create_target_ib(struct srp_target_port *target)
 				     "FMR pool allocation failed (%d)\n", ret);
 			goto err_qp;
 		}
-		if (target->fmr_pool)
-			ib_destroy_fmr_pool(target->fmr_pool);
-		target->fmr_pool = fmr_pool;
+		if (ch->fmr_pool)
+			ib_destroy_fmr_pool(ch->fmr_pool);
+		ch->fmr_pool = fmr_pool;
 	}
 
-	if (target->qp)
-		ib_destroy_qp(target->qp);
-	if (target->recv_cq)
-		ib_destroy_cq(target->recv_cq);
-	if (target->send_cq)
-		ib_destroy_cq(target->send_cq);
+	if (ch->qp)
+		ib_destroy_qp(ch->qp);
+	if (ch->recv_cq)
+		ib_destroy_cq(ch->recv_cq);
+	if (ch->send_cq)
+		ib_destroy_cq(ch->send_cq);
 
-	target->qp = qp;
-	target->recv_cq = recv_cq;
-	target->send_cq = send_cq;
+	ch->qp = qp;
+	ch->recv_cq = recv_cq;
+	ch->send_cq = send_cq;
 
 	kfree(init_attr);
 	return 0;
@@ -548,98 +554,102 @@ err:
 
 /*
  * Note: this function may be called without srp_alloc_iu_bufs() having been
- * invoked. Hence the target->[rt]x_ring checks.
+ * invoked. Hence the ch->[rt]x_ring checks.
  */
-static void srp_free_target_ib(struct srp_target_port *target)
+static void srp_free_ch_ib(struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	int i;
 
-	if (target->cm_id) {
-		ib_destroy_cm_id(target->cm_id);
-		target->cm_id = NULL;
+	if (ch->cm_id) {
+		ib_destroy_cm_id(ch->cm_id);
+		ch->cm_id = NULL;
 	}
 
 	if (dev->use_fast_reg) {
-		if (target->fr_pool)
-			srp_destroy_fr_pool(target->fr_pool);
+		if (ch->fr_pool)
+			srp_destroy_fr_pool(ch->fr_pool);
 	} else {
-		if (target->fmr_pool)
-			ib_destroy_fmr_pool(target->fmr_pool);
+		if (ch->fmr_pool)
+			ib_destroy_fmr_pool(ch->fmr_pool);
 	}
-	ib_destroy_qp(target->qp);
-	ib_destroy_cq(target->send_cq);
-	ib_destroy_cq(target->recv_cq);
+	ib_destroy_qp(ch->qp);
+	ib_destroy_cq(ch->send_cq);
+	ib_destroy_cq(ch->recv_cq);
 
-	target->qp = NULL;
-	target->send_cq = target->recv_cq = NULL;
+	ch->qp = NULL;
+	ch->send_cq = ch->recv_cq = NULL;
 
-	if (target->rx_ring) {
+	if (ch->rx_ring) {
 		for (i = 0; i < target->queue_size; ++i)
-			srp_free_iu(target->srp_host, target->rx_ring[i]);
-		kfree(target->rx_ring);
-		target->rx_ring = NULL;
+			srp_free_iu(target->srp_host, ch->rx_ring[i]);
+		kfree(ch->rx_ring);
+		ch->rx_ring = NULL;
 	}
-	if (target->tx_ring) {
+	if (ch->tx_ring) {
 		for (i = 0; i < target->queue_size; ++i)
-			srp_free_iu(target->srp_host, target->tx_ring[i]);
-		kfree(target->tx_ring);
-		target->tx_ring = NULL;
+			srp_free_iu(target->srp_host, ch->tx_ring[i]);
+		kfree(ch->tx_ring);
+		ch->tx_ring = NULL;
 	}
 }
 
 static void srp_path_rec_completion(int status,
 				    struct ib_sa_path_rec *pathrec,
-				    void *target_ptr)
+				    void *ch_ptr)
 {
-	struct srp_target_port *target = target_ptr;
+	struct srp_rdma_ch *ch = ch_ptr;
+	struct srp_target_port *target = ch->target;
 
-	target->status = status;
+	ch->status = status;
 	if (status)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "Got failed path rec status %d\n", status);
 	else
-		target->path = *pathrec;
-	complete(&target->done);
+		ch->path = *pathrec;
+	complete(&ch->done);
 }
 
-static int srp_lookup_path(struct srp_target_port *target)
+static int srp_lookup_path(struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	int ret;
 
-	target->path.numb_path = 1;
-
-	init_completion(&target->done);
-
-	target->path_query_id = ib_sa_path_rec_get(&srp_sa_client,
-						   target->srp_host->srp_dev->dev,
-						   target->srp_host->port,
-						   &target->path,
-						   IB_SA_PATH_REC_SERVICE_ID	|
-						   IB_SA_PATH_REC_DGID		|
-						   IB_SA_PATH_REC_SGID		|
-						   IB_SA_PATH_REC_NUMB_PATH	|
-						   IB_SA_PATH_REC_PKEY,
-						   SRP_PATH_REC_TIMEOUT_MS,
-						   GFP_KERNEL,
-						   srp_path_rec_completion,
-						   target, &target->path_query);
-	if (target->path_query_id < 0)
-		return target->path_query_id;
-
-	ret = wait_for_completion_interruptible(&target->done);
+	ch->path.numb_path = 1;
+
+	init_completion(&ch->done);
+
+	ch->path_query_id = ib_sa_path_rec_get(&srp_sa_client,
+					       target->srp_host->srp_dev->dev,
+					       target->srp_host->port,
+					       &ch->path,
+					       IB_SA_PATH_REC_SERVICE_ID |
+					       IB_SA_PATH_REC_DGID	 |
+					       IB_SA_PATH_REC_SGID	 |
+					       IB_SA_PATH_REC_NUMB_PATH	 |
+					       IB_SA_PATH_REC_PKEY,
+					       SRP_PATH_REC_TIMEOUT_MS,
+					       GFP_KERNEL,
+					       srp_path_rec_completion,
+					       ch, &ch->path_query);
+	if (ch->path_query_id < 0)
+		return ch->path_query_id;
+
+	ret = wait_for_completion_interruptible(&ch->done);
 	if (ret < 0)
 		return ret;
 
-	if (target->status < 0)
+	if (ch->status < 0)
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "Path record query failed\n");
 
-	return target->status;
+	return ch->status;
 }
 
-static int srp_send_req(struct srp_target_port *target)
+static int srp_send_req(struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	struct {
 		struct ib_cm_req_param param;
 		struct srp_login_req   priv;
@@ -650,11 +660,11 @@ static int srp_send_req(struct srp_target_port *target)
 	if (!req)
 		return -ENOMEM;
 
-	req->param.primary_path 	      = &target->path;
+	req->param.primary_path		      = &ch->path;
 	req->param.alternate_path 	      = NULL;
 	req->param.service_id 		      = target->service_id;
-	req->param.qp_num 		      = target->qp->qp_num;
-	req->param.qp_type 		      = target->qp->qp_type;
+	req->param.qp_num		      = ch->qp->qp_num;
+	req->param.qp_type		      = ch->qp->qp_type;
 	req->param.private_data 	      = &req->priv;
 	req->param.private_data_len 	      = sizeof req->priv;
 	req->param.flow_control 	      = 1;
@@ -689,7 +699,7 @@ static int srp_send_req(struct srp_target_port *target)
 	 */
 	if (target->io_class == SRP_REV10_IB_IO_CLASS) {
 		memcpy(req->priv.initiator_port_id,
-		       &target->path.sgid.global.interface_id, 8);
+		       &target->sgid.global.interface_id, 8);
 		memcpy(req->priv.initiator_port_id + 8,
 		       &target->initiator_ext, 8);
 		memcpy(req->priv.target_port_id,     &target->ioc_guid, 8);
@@ -698,7 +708,7 @@ static int srp_send_req(struct srp_target_port *target)
 		memcpy(req->priv.initiator_port_id,
 		       &target->initiator_ext, 8);
 		memcpy(req->priv.initiator_port_id + 8,
-		       &target->path.sgid.global.interface_id, 8);
+		       &target->sgid.global.interface_id, 8);
 		memcpy(req->priv.target_port_id,     &target->id_ext, 8);
 		memcpy(req->priv.target_port_id + 8, &target->ioc_guid, 8);
 	}
@@ -718,7 +728,7 @@ static int srp_send_req(struct srp_target_port *target)
 		       &target->srp_host->srp_dev->dev->node_guid, 8);
 	}
 
-	status = ib_send_cm_req(target->cm_id, &req->param);
+	status = ib_send_cm_req(ch->cm_id, &req->param);
 
 	kfree(req);
 
@@ -759,28 +769,31 @@ static bool srp_change_conn_state(struct srp_target_port *target,
 
 static void srp_disconnect_target(struct srp_target_port *target)
 {
+	struct srp_rdma_ch *ch = &target->ch;
+
 	if (srp_change_conn_state(target, false)) {
 		/* XXX should send SRP_I_LOGOUT request */
 
-		if (ib_send_cm_dreq(target->cm_id, NULL, 0)) {
+		if (ib_send_cm_dreq(ch->cm_id, NULL, 0)) {
 			shost_printk(KERN_DEBUG, target->scsi_host,
 				     PFX "Sending CM DREQ failed\n");
 		}
 	}
 }
 
-static void srp_free_req_data(struct srp_target_port *target)
+static void srp_free_req_data(struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
 	struct srp_request *req;
 	int i;
 
-	if (!target->req_ring)
+	if (!ch->req_ring)
 		return;
 
 	for (i = 0; i < target->req_ring_size; ++i) {
-		req = &target->req_ring[i];
+		req = &ch->req_ring[i];
 		if (dev->use_fast_reg)
 			kfree(req->fr_list);
 		else
@@ -794,12 +807,13 @@ static void srp_free_req_data(struct srp_target_port *target)
 		kfree(req->indirect_desc);
 	}
 
-	kfree(target->req_ring);
-	target->req_ring = NULL;
+	kfree(ch->req_ring);
+	ch->req_ring = NULL;
 }
 
-static int srp_alloc_req_data(struct srp_target_port *target)
+static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_device *srp_dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
 	struct srp_request *req;
@@ -807,15 +821,15 @@ static int srp_alloc_req_data(struct srp_target_port *target)
 	dma_addr_t dma_addr;
 	int i, ret = -ENOMEM;
 
-	INIT_LIST_HEAD(&target->free_reqs);
+	INIT_LIST_HEAD(&ch->free_reqs);
 
-	target->req_ring = kzalloc(target->req_ring_size *
-				   sizeof(*target->req_ring), GFP_KERNEL);
-	if (!target->req_ring)
+	ch->req_ring = kcalloc(target->req_ring_size, sizeof(*ch->req_ring),
+			       GFP_KERNEL);
+	if (!ch->req_ring)
 		goto out;
 
 	for (i = 0; i < target->req_ring_size; ++i) {
-		req = &target->req_ring[i];
+		req = &ch->req_ring[i];
 		mr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
 				  GFP_KERNEL);
 		if (!mr_list)
@@ -840,7 +854,7 @@ static int srp_alloc_req_data(struct srp_target_port *target)
 
 		req->indirect_dma_addr = dma_addr;
 		req->index = i;
-		list_add_tail(&req->list, &target->free_reqs);
+		list_add_tail(&req->list, &ch->free_reqs);
 	}
 	ret = 0;
 
@@ -865,6 +879,8 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 
 static void srp_remove_target(struct srp_target_port *target)
 {
+	struct srp_rdma_ch *ch = &target->ch;
+
 	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);
 
 	srp_del_scsi_host_attr(target->scsi_host);
@@ -873,10 +889,10 @@ static void srp_remove_target(struct srp_target_port *target)
 	scsi_remove_host(target->scsi_host);
 	srp_stop_rport_timers(target->rport);
 	srp_disconnect_target(target);
-	srp_free_target_ib(target);
+	srp_free_ch_ib(ch);
 	cancel_work_sync(&target->tl_err_work);
 	srp_rport_put(target->rport);
-	srp_free_req_data(target);
+	srp_free_req_data(ch);
 
 	spin_lock(&target->srp_host->target_lock);
 	list_del(&target->list);
@@ -902,24 +918,25 @@ static void srp_rport_delete(struct srp_rport *rport)
 	srp_queue_remove_work(target);
 }
 
-static int srp_connect_target(struct srp_target_port *target)
+static int srp_connect_ch(struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	int ret;
 
 	WARN_ON_ONCE(target->connected);
 
 	target->qp_in_error = false;
 
-	ret = srp_lookup_path(target);
+	ret = srp_lookup_path(ch);
 	if (ret)
 		return ret;
 
 	while (1) {
-		init_completion(&target->done);
-		ret = srp_send_req(target);
+		init_completion(&ch->done);
+		ret = srp_send_req(ch);
 		if (ret)
 			return ret;
-		ret = wait_for_completion_interruptible(&target->done);
+		ret = wait_for_completion_interruptible(&ch->done);
 		if (ret < 0)
 			return ret;
 
@@ -929,13 +946,13 @@ static int srp_connect_target(struct srp_target_port *target)
 		 * back, or SRP_DLID_REDIRECT if we get a lid/qp
 		 * redirect REJ back.
 		 */
-		switch (target->status) {
+		switch (ch->status) {
 		case 0:
 			srp_change_conn_state(target, true);
 			return 0;
 
 		case SRP_PORT_REDIRECT:
-			ret = srp_lookup_path(target);
+			ret = srp_lookup_path(ch);
 			if (ret)
 				return ret;
 			break;
@@ -946,16 +963,16 @@ static int srp_connect_target(struct srp_target_port *target)
 		case SRP_STALE_CONN:
 			shost_printk(KERN_ERR, target->scsi_host, PFX
 				     "giving up on stale connection\n");
-			target->status = -ECONNRESET;
-			return target->status;
+			ch->status = -ECONNRESET;
+			return ch->status;
 
 		default:
-			return target->status;
+			return ch->status;
 		}
 	}
 }
 
-static int srp_inv_rkey(struct srp_target_port *target, u32 rkey)
+static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey)
 {
 	struct ib_send_wr *bad_wr;
 	struct ib_send_wr wr = {
@@ -967,13 +984,14 @@ static int srp_inv_rkey(struct srp_target_port *target, u32 rkey)
 		.ex.invalidate_rkey = rkey,
 	};
 
-	return ib_post_send(target->qp, &wr, &bad_wr);
+	return ib_post_send(ch->qp, &wr, &bad_wr);
 }
 
 static void srp_unmap_data(struct scsi_cmnd *scmnd,
-			   struct srp_target_port *target,
+			   struct srp_rdma_ch *ch,
 			   struct srp_request *req)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
 	int i, res;
@@ -987,7 +1005,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		struct srp_fr_desc **pfr;
 
 		for (i = req->nmdesc, pfr = req->fr_list; i > 0; i--, pfr++) {
-			res = srp_inv_rkey(target, (*pfr)->mr->rkey);
+			res = srp_inv_rkey(ch, (*pfr)->mr->rkey);
 			if (res < 0) {
 				shost_printk(KERN_ERR, target->scsi_host, PFX
 				  "Queueing INV WR for rkey %#x failed (%d)\n",
@@ -997,7 +1015,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 			}
 		}
 		if (req->nmdesc)
-			srp_fr_pool_put(target->fr_pool, req->fr_list,
+			srp_fr_pool_put(ch->fr_pool, req->fr_list,
 					req->nmdesc);
 	} else {
 		struct ib_pool_fmr **pfmr;
@@ -1012,7 +1030,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 
 /**
  * srp_claim_req - Take ownership of the scmnd associated with a request.
- * @target: SRP target port.
+ * @ch: SRP RDMA channel.
  * @req: SRP request.
  * @sdev: If not NULL, only take ownership for this SCSI device.
  * @scmnd: If NULL, take ownership of @req->scmnd. If not NULL, only take
@@ -1021,14 +1039,14 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
  * Return value:
  * Either NULL or a pointer to the SCSI command the caller became owner of.
  */
-static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
+static struct scsi_cmnd *srp_claim_req(struct srp_rdma_ch *ch,
 				       struct srp_request *req,
 				       struct scsi_device *sdev,
 				       struct scsi_cmnd *scmnd)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&target->lock, flags);
+	spin_lock_irqsave(&ch->lock, flags);
 	if (req->scmnd &&
 	    (!sdev || req->scmnd->device == sdev) &&
 	    (!scmnd || req->scmnd == scmnd)) {
@@ -1037,40 +1055,38 @@ static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
 	} else {
 		scmnd = NULL;
 	}
-	spin_unlock_irqrestore(&target->lock, flags);
+	spin_unlock_irqrestore(&ch->lock, flags);
 
 	return scmnd;
 }
 
 /**
  * srp_free_req() - Unmap data and add request to the free request list.
- * @target: SRP target port.
+ * @ch:     SRP RDMA channel.
  * @req:    Request to be freed.
  * @scmnd:  SCSI command associated with @req.
  * @req_lim_delta: Amount to be added to @target->req_lim.
  */
-static void srp_free_req(struct srp_target_port *target,
-			 struct srp_request *req, struct scsi_cmnd *scmnd,
-			 s32 req_lim_delta)
+static void srp_free_req(struct srp_rdma_ch *ch, struct srp_request *req,
+			 struct scsi_cmnd *scmnd, s32 req_lim_delta)
 {
 	unsigned long flags;
 
-	srp_unmap_data(scmnd, target, req);
+	srp_unmap_data(scmnd, ch, req);
 
-	spin_lock_irqsave(&target->lock, flags);
-	target->req_lim += req_lim_delta;
-	list_add_tail(&req->list, &target->free_reqs);
-	spin_unlock_irqrestore(&target->lock, flags);
+	spin_lock_irqsave(&ch->lock, flags);
+	ch->req_lim += req_lim_delta;
+	list_add_tail(&req->list, &ch->free_reqs);
+	spin_unlock_irqrestore(&ch->lock, flags);
 }
 
-static void srp_finish_req(struct srp_target_port *target,
-			   struct srp_request *req, struct scsi_device *sdev,
-			   int result)
+static void srp_finish_req(struct srp_rdma_ch *ch, struct srp_request *req,
+			   struct scsi_device *sdev, int result)
 {
-	struct scsi_cmnd *scmnd = srp_claim_req(target, req, sdev, NULL);
+	struct scsi_cmnd *scmnd = srp_claim_req(ch, req, sdev, NULL);
 
 	if (scmnd) {
-		srp_free_req(target, req, scmnd, 0);
+		srp_free_req(ch, req, scmnd, 0);
 		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
 	}
@@ -1079,6 +1095,7 @@ static void srp_finish_req(struct srp_target_port *target,
 static void srp_terminate_io(struct srp_rport *rport)
 {
 	struct srp_target_port *target = rport->lld_data;
+	struct srp_rdma_ch *ch = &target->ch;
 	struct Scsi_Host *shost = target->scsi_host;
 	struct scsi_device *sdev;
 	int i;
@@ -1091,8 +1108,9 @@ static void srp_terminate_io(struct srp_rport *rport)
 		WARN_ON_ONCE(sdev->request_queue->request_fn_active);
 
 	for (i = 0; i < target->req_ring_size; ++i) {
-		struct srp_request *req = &target->req_ring[i];
-		srp_finish_req(target, req, NULL, DID_TRANSPORT_FAILFAST << 16);
+		struct srp_request *req = &ch->req_ring[i];
+
+		srp_finish_req(ch, req, NULL, DID_TRANSPORT_FAILFAST << 16);
 	}
 }
 
@@ -1108,6 +1126,7 @@ static void srp_terminate_io(struct srp_rport *rport)
 static int srp_rport_reconnect(struct srp_rport *rport)
 {
 	struct srp_target_port *target = rport->lld_data;
+	struct srp_rdma_ch *ch = &target->ch;
 	int i, ret;
 
 	srp_disconnect_target(target);
@@ -1120,11 +1139,12 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	 * case things are really fouled up. Doing so also ensures that all CM
 	 * callbacks will have finished before a new QP is allocated.
 	 */
-	ret = srp_new_cm_id(target);
+	ret = srp_new_cm_id(ch);
 
 	for (i = 0; i < target->req_ring_size; ++i) {
-		struct srp_request *req = &target->req_ring[i];
-		srp_finish_req(target, req, NULL, DID_RESET << 16);
+		struct srp_request *req = &ch->req_ring[i];
+
+		srp_finish_req(ch, req, NULL, DID_RESET << 16);
 	}
 
 	/*
@@ -1132,14 +1152,14 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	 * QP. This guarantees that all callback functions for the old QP have
 	 * finished before any send requests are posted on the new QP.
 	 */
-	ret += srp_create_target_ib(target);
+	ret += srp_create_ch_ib(ch);
 
-	INIT_LIST_HEAD(&target->free_tx);
+	INIT_LIST_HEAD(&ch->free_tx);
 	for (i = 0; i < target->queue_size; ++i)
-		list_add(&target->tx_ring[i]->list, &target->free_tx);
+		list_add(&ch->tx_ring[i]->list, &ch->free_tx);
 
 	if (ret == 0)
-		ret = srp_connect_target(target);
+		ret = srp_connect_ch(ch);
 
 	if (ret == 0)
 		shost_printk(KERN_INFO, target->scsi_host,
@@ -1163,12 +1183,12 @@ static void srp_map_desc(struct srp_map_state *state, dma_addr_t dma_addr,
 }
 
 static int srp_map_finish_fmr(struct srp_map_state *state,
-			      struct srp_target_port *target)
+			      struct srp_rdma_ch *ch)
 {
 	struct ib_pool_fmr *fmr;
 	u64 io_addr = 0;
 
-	fmr = ib_fmr_pool_map_phys(target->fmr_pool, state->pages,
+	fmr = ib_fmr_pool_map_phys(ch->fmr_pool, state->pages,
 				   state->npages, io_addr);
 	if (IS_ERR(fmr))
 		return PTR_ERR(fmr);
@@ -1182,15 +1202,16 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 }
 
 static int srp_map_finish_fr(struct srp_map_state *state,
-			     struct srp_target_port *target)
+			     struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_send_wr *bad_wr;
 	struct ib_send_wr wr;
 	struct srp_fr_desc *desc;
 	u32 rkey;
 
-	desc = srp_fr_pool_get(target->fr_pool);
+	desc = srp_fr_pool_get(ch->fr_pool);
 	if (!desc)
 		return -ENOMEM;
 
@@ -1219,12 +1240,13 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	srp_map_desc(state, state->base_dma_addr, state->dma_len,
 		     desc->mr->rkey);
 
-	return ib_post_send(target->qp, &wr, &bad_wr);
+	return ib_post_send(ch->qp, &wr, &bad_wr);
 }
 
 static int srp_finish_mapping(struct srp_map_state *state,
-			      struct srp_target_port *target)
+			      struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	int ret = 0;
 
 	if (state->npages == 0)
@@ -1235,8 +1257,8 @@ static int srp_finish_mapping(struct srp_map_state *state,
 			     target->rkey);
 	else
 		ret = target->srp_host->srp_dev->use_fast_reg ?
-			srp_map_finish_fr(state, target) :
-			srp_map_finish_fmr(state, target);
+			srp_map_finish_fr(state, ch) :
+			srp_map_finish_fmr(state, ch);
 
 	if (ret == 0) {
 		state->npages = 0;
@@ -1256,10 +1278,11 @@ static void srp_map_update_start(struct srp_map_state *state,
 }
 
 static int srp_map_sg_entry(struct srp_map_state *state,
-			    struct srp_target_port *target,
+			    struct srp_rdma_ch *ch,
 			    struct scatterlist *sg, int sg_index,
 			    bool use_mr)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
 	dma_addr_t dma_addr = ib_sg_dma_address(ibdev, sg);
@@ -1288,7 +1311,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 */
 	if ((!dev->use_fast_reg && dma_addr & ~dev->mr_page_mask) ||
 	    dma_len > dev->mr_max_size) {
-		ret = srp_finish_mapping(state, target);
+		ret = srp_finish_mapping(state, ch);
 		if (ret)
 			return ret;
 
@@ -1309,7 +1332,7 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	while (dma_len) {
 		unsigned offset = dma_addr & ~dev->mr_page_mask;
 		if (state->npages == dev->max_pages_per_mr || offset != 0) {
-			ret = srp_finish_mapping(state, target);
+			ret = srp_finish_mapping(state, ch);
 			if (ret)
 				return ret;
 
@@ -1333,17 +1356,18 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 	 */
 	ret = 0;
 	if (len != dev->mr_page_size) {
-		ret = srp_finish_mapping(state, target);
+		ret = srp_finish_mapping(state, ch);
 		if (!ret)
 			srp_map_update_start(state, NULL, 0, 0);
 	}
 	return ret;
 }
 
-static int srp_map_sg(struct srp_map_state *state,
-		      struct srp_target_port *target, struct srp_request *req,
-		      struct scatterlist *scat, int count)
+static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
+		      struct srp_request *req, struct scatterlist *scat,
+		      int count)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
 	struct scatterlist *sg;
@@ -1354,14 +1378,14 @@ static int srp_map_sg(struct srp_map_state *state,
 	state->pages	= req->map_page;
 	if (dev->use_fast_reg) {
 		state->next_fr = req->fr_list;
-		use_mr = !!target->fr_pool;
+		use_mr = !!ch->fr_pool;
 	} else {
 		state->next_fmr = req->fmr_list;
-		use_mr = !!target->fmr_pool;
+		use_mr = !!ch->fmr_pool;
 	}
 
 	for_each_sg(scat, sg, count, i) {
-		if (srp_map_sg_entry(state, target, sg, i, use_mr)) {
+		if (srp_map_sg_entry(state, ch, sg, i, use_mr)) {
 			/*
 			 * Memory registration failed, so backtrack to the
 			 * first unmapped entry and continue on without using
@@ -1383,7 +1407,7 @@ backtrack:
 		}
 	}
 
-	if (use_mr && srp_finish_mapping(state, target))
+	if (use_mr && srp_finish_mapping(state, ch))
 		goto backtrack;
 
 	req->nmdesc = state->nmdesc;
@@ -1391,9 +1415,10 @@ backtrack:
 	return 0;
 }
 
-static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
+static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 			struct srp_request *req)
 {
+	struct srp_target_port *target = ch->target;
 	struct scatterlist *scat;
 	struct srp_cmd *cmd = req->cmd->buf;
 	int len, nents, count;
@@ -1455,7 +1480,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 				   target->indirect_size, DMA_TO_DEVICE);
 
 	memset(&state, 0, sizeof(state));
-	srp_map_sg(&state, target, req, scat, count);
+	srp_map_sg(&state, ch, req, scat, count);
 
 	/* We've mapped the request, now pull as much of the indirect
 	 * descriptor table as we can into the command buffer. If this
@@ -1516,20 +1541,20 @@ map_complete:
 /*
  * Return an IU and possible credit to the free pool
  */
-static void srp_put_tx_iu(struct srp_target_port *target, struct srp_iu *iu,
+static void srp_put_tx_iu(struct srp_rdma_ch *ch, struct srp_iu *iu,
 			  enum srp_iu_type iu_type)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&target->lock, flags);
-	list_add(&iu->list, &target->free_tx);
+	spin_lock_irqsave(&ch->lock, flags);
+	list_add(&iu->list, &ch->free_tx);
 	if (iu_type != SRP_IU_RSP)
-		++target->req_lim;
-	spin_unlock_irqrestore(&target->lock, flags);
+		++ch->req_lim;
+	spin_unlock_irqrestore(&ch->lock, flags);
 }
 
 /*
- * Must be called with target->lock held to protect req_lim and free_tx.
+ * Must be called with ch->lock held to protect req_lim and free_tx.
  * If IU is not sent, it must be returned using srp_put_tx_iu().
  *
  * Note:
@@ -1541,35 +1566,36 @@ static void srp_put_tx_iu(struct srp_target_port *target, struct srp_iu *iu,
  * - SRP_IU_RSP: 1, since a conforming SRP target never sends more than
  *   one unanswered SRP request to an initiator.
  */
-static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
+static struct srp_iu *__srp_get_tx_iu(struct srp_rdma_ch *ch,
 				      enum srp_iu_type iu_type)
 {
+	struct srp_target_port *target = ch->target;
 	s32 rsv = (iu_type == SRP_IU_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
 	struct srp_iu *iu;
 
-	srp_send_completion(target->send_cq, target);
+	srp_send_completion(ch->send_cq, target);
 
-	if (list_empty(&target->free_tx))
+	if (list_empty(&ch->free_tx))
 		return NULL;
 
 	/* Initiator responses to target requests do not consume credits */
 	if (iu_type != SRP_IU_RSP) {
-		if (target->req_lim <= rsv) {
+		if (ch->req_lim <= rsv) {
 			++target->zero_req_lim;
 			return NULL;
 		}
 
-		--target->req_lim;
+		--ch->req_lim;
 	}
 
-	iu = list_first_entry(&target->free_tx, struct srp_iu, list);
+	iu = list_first_entry(&ch->free_tx, struct srp_iu, list);
 	list_del(&iu->list);
 	return iu;
 }
 
-static int srp_post_send(struct srp_target_port *target,
-			 struct srp_iu *iu, int len)
+static int srp_post_send(struct srp_rdma_ch *ch, struct srp_iu *iu, int len)
 {
+	struct srp_target_port *target = ch->target;
 	struct ib_sge list;
 	struct ib_send_wr wr, *bad_wr;
 
@@ -1584,11 +1610,12 @@ static int srp_post_send(struct srp_target_port *target,
 	wr.opcode     = IB_WR_SEND;
 	wr.send_flags = IB_SEND_SIGNALED;
 
-	return ib_post_send(target->qp, &wr, &bad_wr);
+	return ib_post_send(ch->qp, &wr, &bad_wr);
 }
 
-static int srp_post_recv(struct srp_target_port *target, struct srp_iu *iu)
+static int srp_post_recv(struct srp_rdma_ch *ch, struct srp_iu *iu)
 {
+	struct srp_target_port *target = ch->target;
 	struct ib_recv_wr wr, *bad_wr;
 	struct ib_sge list;
 
@@ -1601,35 +1628,36 @@ static int srp_post_recv(struct srp_target_port *target, struct srp_iu *iu)
 	wr.sg_list  = &list;
 	wr.num_sge  = 1;
 
-	return ib_post_recv(target->qp, &wr, &bad_wr);
+	return ib_post_recv(ch->qp, &wr, &bad_wr);
 }
 
-static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
+static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_request *req;
 	struct scsi_cmnd *scmnd;
 	unsigned long flags;
 
 	if (unlikely(rsp->tag & SRP_TAG_TSK_MGMT)) {
-		spin_lock_irqsave(&target->lock, flags);
-		target->req_lim += be32_to_cpu(rsp->req_lim_delta);
-		spin_unlock_irqrestore(&target->lock, flags);
+		spin_lock_irqsave(&ch->lock, flags);
+		ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
+		spin_unlock_irqrestore(&ch->lock, flags);
 
-		target->tsk_mgmt_status = -1;
+		ch->tsk_mgmt_status = -1;
 		if (be32_to_cpu(rsp->resp_data_len) >= 4)
-			target->tsk_mgmt_status = rsp->data[3];
-		complete(&target->tsk_mgmt_done);
+			ch->tsk_mgmt_status = rsp->data[3];
+		complete(&ch->tsk_mgmt_done);
 	} else {
-		req = &target->req_ring[rsp->tag];
-		scmnd = srp_claim_req(target, req, NULL, NULL);
+		req = &ch->req_ring[rsp->tag];
+		scmnd = srp_claim_req(ch, req, NULL, NULL);
 		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     "Null scmnd for RSP w/tag %016llx\n",
 				     (unsigned long long) rsp->tag);
 
-			spin_lock_irqsave(&target->lock, flags);
-			target->req_lim += be32_to_cpu(rsp->req_lim_delta);
-			spin_unlock_irqrestore(&target->lock, flags);
+			spin_lock_irqsave(&ch->lock, flags);
+			ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
+			spin_unlock_irqrestore(&ch->lock, flags);
 
 			return;
 		}
@@ -1651,7 +1679,7 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOOVER))
 			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_out_res_cnt));
 
-		srp_free_req(target, req, scmnd,
+		srp_free_req(ch, req, scmnd,
 			     be32_to_cpu(rsp->req_lim_delta));
 
 		scmnd->host_scribble = NULL;
@@ -1659,18 +1687,19 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 	}
 }
 
-static int srp_response_common(struct srp_target_port *target, s32 req_delta,
+static int srp_response_common(struct srp_rdma_ch *ch, s32 req_delta,
 			       void *rsp, int len)
 {
+	struct srp_target_port *target = ch->target;
 	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	unsigned long flags;
 	struct srp_iu *iu;
 	int err;
 
-	spin_lock_irqsave(&target->lock, flags);
-	target->req_lim += req_delta;
-	iu = __srp_get_tx_iu(target, SRP_IU_RSP);
-	spin_unlock_irqrestore(&target->lock, flags);
+	spin_lock_irqsave(&ch->lock, flags);
+	ch->req_lim += req_delta;
+	iu = __srp_get_tx_iu(ch, SRP_IU_RSP);
+	spin_unlock_irqrestore(&ch->lock, flags);
 
 	if (!iu) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX
@@ -1682,17 +1711,17 @@ static int srp_response_common(struct srp_target_port *target, s32 req_delta,
 	memcpy(iu->buf, rsp, len);
 	ib_dma_sync_single_for_device(dev, iu->dma, len, DMA_TO_DEVICE);
 
-	err = srp_post_send(target, iu, len);
+	err = srp_post_send(ch, iu, len);
 	if (err) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX
 			     "unable to post response: %d\n", err);
-		srp_put_tx_iu(target, iu, SRP_IU_RSP);
+		srp_put_tx_iu(ch, iu, SRP_IU_RSP);
 	}
 
 	return err;
 }
 
-static void srp_process_cred_req(struct srp_target_port *target,
+static void srp_process_cred_req(struct srp_rdma_ch *ch,
 				 struct srp_cred_req *req)
 {
 	struct srp_cred_rsp rsp = {
@@ -1701,14 +1730,15 @@ static void srp_process_cred_req(struct srp_target_port *target,
 	};
 	s32 delta = be32_to_cpu(req->req_lim_delta);
 
-	if (srp_response_common(target, delta, &rsp, sizeof rsp))
-		shost_printk(KERN_ERR, target->scsi_host, PFX
+	if (srp_response_common(ch, delta, &rsp, sizeof(rsp)))
+		shost_printk(KERN_ERR, ch->target->scsi_host, PFX
 			     "problems processing SRP_CRED_REQ\n");
 }
 
-static void srp_process_aer_req(struct srp_target_port *target,
+static void srp_process_aer_req(struct srp_rdma_ch *ch,
 				struct srp_aer_req *req)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_aer_rsp rsp = {
 		.opcode = SRP_AER_RSP,
 		.tag = req->tag,
@@ -1718,19 +1748,20 @@ static void srp_process_aer_req(struct srp_target_port *target,
 	shost_printk(KERN_ERR, target->scsi_host, PFX
 		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
 
-	if (srp_response_common(target, delta, &rsp, sizeof rsp))
+	if (srp_response_common(ch, delta, &rsp, sizeof(rsp)))
 		shost_printk(KERN_ERR, target->scsi_host, PFX
 			     "problems processing SRP_AER_REQ\n");
 }
 
-static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
+static void srp_handle_recv(struct srp_rdma_ch *ch, struct ib_wc *wc)
 {
+	struct srp_target_port *target = ch->target;
 	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	struct srp_iu *iu = (struct srp_iu *) (uintptr_t) wc->wr_id;
 	int res;
 	u8 opcode;
 
-	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_ti_iu_len,
+	ib_dma_sync_single_for_cpu(dev, iu->dma, ch->max_ti_iu_len,
 				   DMA_FROM_DEVICE);
 
 	opcode = *(u8 *) iu->buf;
@@ -1744,15 +1775,15 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 
 	switch (opcode) {
 	case SRP_RSP:
-		srp_process_rsp(target, iu->buf);
+		srp_process_rsp(ch, iu->buf);
 		break;
 
 	case SRP_CRED_REQ:
-		srp_process_cred_req(target, iu->buf);
+		srp_process_cred_req(ch, iu->buf);
 		break;
 
 	case SRP_AER_REQ:
-		srp_process_aer_req(target, iu->buf);
+		srp_process_aer_req(ch, iu->buf);
 		break;
 
 	case SRP_T_LOGOUT:
@@ -1767,10 +1798,10 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 		break;
 	}
 
-	ib_dma_sync_single_for_device(dev, iu->dma, target->max_ti_iu_len,
+	ib_dma_sync_single_for_device(dev, iu->dma, ch->max_ti_iu_len,
 				      DMA_FROM_DEVICE);
 
-	res = srp_post_recv(target, iu);
+	res = srp_post_recv(ch, iu);
 	if (res != 0)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "Recv failed with error code %d\n", res);
@@ -1815,33 +1846,35 @@ static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
 	target->qp_in_error = true;
 }
 
-static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
+static void srp_recv_completion(struct ib_cq *cq, void *ch_ptr)
 {
-	struct srp_target_port *target = target_ptr;
+	struct srp_rdma_ch *ch = ch_ptr;
 	struct ib_wc wc;
 
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		if (likely(wc.status == IB_WC_SUCCESS)) {
-			srp_handle_recv(target, &wc);
+			srp_handle_recv(ch, &wc);
 		} else {
-			srp_handle_qp_err(wc.wr_id, wc.status, false, target);
+			srp_handle_qp_err(wc.wr_id, wc.status, false,
+					  ch->target);
 		}
 	}
 }
 
-static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
+static void srp_send_completion(struct ib_cq *cq, void *ch_ptr)
 {
-	struct srp_target_port *target = target_ptr;
+	struct srp_rdma_ch *ch = ch_ptr;
 	struct ib_wc wc;
 	struct srp_iu *iu;
 
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		if (likely(wc.status == IB_WC_SUCCESS)) {
 			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
-			list_add(&iu->list, &target->free_tx);
+			list_add(&iu->list, &ch->free_tx);
 		} else {
-			srp_handle_qp_err(wc.wr_id, wc.status, true, target);
+			srp_handle_qp_err(wc.wr_id, wc.status, true,
+					  ch->target);
 		}
 	}
 }
@@ -1850,6 +1883,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(shost);
 	struct srp_rport *rport = target->rport;
+	struct srp_rdma_ch *ch;
 	struct srp_request *req;
 	struct srp_iu *iu;
 	struct srp_cmd *cmd;
@@ -1871,14 +1905,16 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (unlikely(scmnd->result))
 		goto err;
 
-	spin_lock_irqsave(&target->lock, flags);
-	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
+	ch = &target->ch;
+
+	spin_lock_irqsave(&ch->lock, flags);
+	iu = __srp_get_tx_iu(ch, SRP_IU_CMD);
 	if (!iu)
 		goto err_unlock;
 
-	req = list_first_entry(&target->free_reqs, struct srp_request, list);
+	req = list_first_entry(&ch->free_reqs, struct srp_request, list);
 	list_del(&req->list);
-	spin_unlock_irqrestore(&target->lock, flags);
+	spin_unlock_irqrestore(&ch->lock, flags);
 
 	dev = target->srp_host->srp_dev->dev;
 	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_iu_len,
@@ -1897,7 +1933,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	req->scmnd    = scmnd;
 	req->cmd      = iu;
 
-	len = srp_map_data(scmnd, target, req);
+	len = srp_map_data(scmnd, ch, req);
 	if (len < 0) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "Failed to map data (%d)\n", len);
@@ -1915,7 +1951,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	ib_dma_sync_single_for_device(dev, iu->dma, target->max_iu_len,
 				      DMA_TO_DEVICE);
 
-	if (srp_post_send(target, iu, len)) {
+	if (srp_post_send(ch, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
 	}
@@ -1929,10 +1965,10 @@ unlock_rport:
 	return ret;
 
 err_unmap:
-	srp_unmap_data(scmnd, target, req);
+	srp_unmap_data(scmnd, ch, req);
 
 err_iu:
-	srp_put_tx_iu(target, iu, SRP_IU_CMD);
+	srp_put_tx_iu(ch, iu, SRP_IU_CMD);
 
 	/*
 	 * Avoid that the loops that iterate over the request ring can
@@ -1940,11 +1976,11 @@ err_iu:
 	 */
 	req->scmnd = NULL;
 
-	spin_lock_irqsave(&target->lock, flags);
-	list_add(&req->list, &target->free_reqs);
+	spin_lock_irqsave(&ch->lock, flags);
+	list_add(&req->list, &ch->free_reqs);
 
 err_unlock:
-	spin_unlock_irqrestore(&target->lock, flags);
+	spin_unlock_irqrestore(&ch->lock, flags);
 
 err:
 	if (scmnd->result) {
@@ -1959,53 +1995,54 @@ err:
 
 /*
  * Note: the resources allocated in this function are freed in
- * srp_free_target_ib().
+ * srp_free_ch_ib().
  */
-static int srp_alloc_iu_bufs(struct srp_target_port *target)
+static int srp_alloc_iu_bufs(struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	int i;
 
-	target->rx_ring = kzalloc(target->queue_size * sizeof(*target->rx_ring),
-				  GFP_KERNEL);
-	if (!target->rx_ring)
+	ch->rx_ring = kcalloc(target->queue_size, sizeof(*ch->rx_ring),
+			      GFP_KERNEL);
+	if (!ch->rx_ring)
 		goto err_no_ring;
-	target->tx_ring = kzalloc(target->queue_size * sizeof(*target->tx_ring),
-				  GFP_KERNEL);
-	if (!target->tx_ring)
+	ch->tx_ring = kcalloc(target->queue_size, sizeof(*ch->tx_ring),
+			      GFP_KERNEL);
+	if (!ch->tx_ring)
 		goto err_no_ring;
 
 	for (i = 0; i < target->queue_size; ++i) {
-		target->rx_ring[i] = srp_alloc_iu(target->srp_host,
-						  target->max_ti_iu_len,
-						  GFP_KERNEL, DMA_FROM_DEVICE);
-		if (!target->rx_ring[i])
+		ch->rx_ring[i] = srp_alloc_iu(target->srp_host,
+					      ch->max_ti_iu_len,
+					      GFP_KERNEL, DMA_FROM_DEVICE);
+		if (!ch->rx_ring[i])
 			goto err;
 	}
 
 	for (i = 0; i < target->queue_size; ++i) {
-		target->tx_ring[i] = srp_alloc_iu(target->srp_host,
-						  target->max_iu_len,
-						  GFP_KERNEL, DMA_TO_DEVICE);
-		if (!target->tx_ring[i])
+		ch->tx_ring[i] = srp_alloc_iu(target->srp_host,
+					      target->max_iu_len,
+					      GFP_KERNEL, DMA_TO_DEVICE);
+		if (!ch->tx_ring[i])
 			goto err;
 
-		list_add(&target->tx_ring[i]->list, &target->free_tx);
+		list_add(&ch->tx_ring[i]->list, &ch->free_tx);
 	}
 
 	return 0;
 
 err:
 	for (i = 0; i < target->queue_size; ++i) {
-		srp_free_iu(target->srp_host, target->rx_ring[i]);
-		srp_free_iu(target->srp_host, target->tx_ring[i]);
+		srp_free_iu(target->srp_host, ch->rx_ring[i]);
+		srp_free_iu(target->srp_host, ch->tx_ring[i]);
 	}
 
 
 err_no_ring:
-	kfree(target->tx_ring);
-	target->tx_ring = NULL;
-	kfree(target->rx_ring);
-	target->rx_ring = NULL;
+	kfree(ch->tx_ring);
+	ch->tx_ring = NULL;
+	kfree(ch->rx_ring);
+	ch->rx_ring = NULL;
 
 	return -ENOMEM;
 }
@@ -2039,23 +2076,24 @@ static uint32_t srp_compute_rq_tmo(struct ib_qp_attr *qp_attr, int attr_mask)
 
 static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 			       struct srp_login_rsp *lrsp,
-			       struct srp_target_port *target)
+			       struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	struct ib_qp_attr *qp_attr = NULL;
 	int attr_mask = 0;
 	int ret;
 	int i;
 
 	if (lrsp->opcode == SRP_LOGIN_RSP) {
-		target->max_ti_iu_len = be32_to_cpu(lrsp->max_ti_iu_len);
-		target->req_lim       = be32_to_cpu(lrsp->req_lim_delta);
+		ch->max_ti_iu_len = be32_to_cpu(lrsp->max_ti_iu_len);
+		ch->req_lim       = be32_to_cpu(lrsp->req_lim_delta);
 
 		/*
 		 * Reserve credits for task management so we don't
 		 * bounce requests back to the SCSI mid-layer.
 		 */
 		target->scsi_host->can_queue
-			= min(target->req_lim - SRP_TSK_MGMT_SQ_SIZE,
+			= min(ch->req_lim - SRP_TSK_MGMT_SQ_SIZE,
 			      target->scsi_host->can_queue);
 		target->scsi_host->cmd_per_lun
 			= min_t(int, target->scsi_host->can_queue,
@@ -2067,8 +2105,8 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 		goto error;
 	}
 
-	if (!target->rx_ring) {
-		ret = srp_alloc_iu_bufs(target);
+	if (!ch->rx_ring) {
+		ret = srp_alloc_iu_bufs(ch);
 		if (ret)
 			goto error;
 	}
@@ -2083,13 +2121,14 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 	if (ret)
 		goto error_free;
 
-	ret = ib_modify_qp(target->qp, qp_attr, attr_mask);
+	ret = ib_modify_qp(ch->qp, qp_attr, attr_mask);
 	if (ret)
 		goto error_free;
 
 	for (i = 0; i < target->queue_size; i++) {
-		struct srp_iu *iu = target->rx_ring[i];
-		ret = srp_post_recv(target, iu);
+		struct srp_iu *iu = ch->rx_ring[i];
+
+		ret = srp_post_recv(ch, iu);
 		if (ret)
 			goto error_free;
 	}
@@ -2101,7 +2140,7 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 
 	target->rq_tmo_jiffies = srp_compute_rq_tmo(qp_attr, attr_mask);
 
-	ret = ib_modify_qp(target->qp, qp_attr, attr_mask);
+	ret = ib_modify_qp(ch->qp, qp_attr, attr_mask);
 	if (ret)
 		goto error_free;
 
@@ -2111,13 +2150,14 @@ error_free:
 	kfree(qp_attr);
 
 error:
-	target->status = ret;
+	ch->status = ret;
 }
 
 static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 			       struct ib_cm_event *event,
-			       struct srp_target_port *target)
+			       struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
 	struct Scsi_Host *shost = target->scsi_host;
 	struct ib_class_port_info *cpi;
 	int opcode;
@@ -2125,12 +2165,12 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 	switch (event->param.rej_rcvd.reason) {
 	case IB_CM_REJ_PORT_CM_REDIRECT:
 		cpi = event->param.rej_rcvd.ari;
-		target->path.dlid = cpi->redirect_lid;
-		target->path.pkey = cpi->redirect_pkey;
+		ch->path.dlid = cpi->redirect_lid;
+		ch->path.pkey = cpi->redirect_pkey;
 		cm_id->remote_cm_qpn = be32_to_cpu(cpi->redirect_qp) & 0x00ffffff;
-		memcpy(target->path.dgid.raw, cpi->redirect_gid, 16);
+		memcpy(ch->path.dgid.raw, cpi->redirect_gid, 16);
 
-		target->status = target->path.dlid ?
+		ch->status = ch->path.dlid ?
 			SRP_DLID_REDIRECT : SRP_PORT_REDIRECT;
 		break;
 
@@ -2141,26 +2181,26 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 			 * reject reason code 25 when they mean 24
 			 * (port redirect).
 			 */
-			memcpy(target->path.dgid.raw,
+			memcpy(ch->path.dgid.raw,
 			       event->param.rej_rcvd.ari, 16);
 
 			shost_printk(KERN_DEBUG, shost,
 				     PFX "Topspin/Cisco redirect to target port GID %016llx%016llx\n",
-				     (unsigned long long) be64_to_cpu(target->path.dgid.global.subnet_prefix),
-				     (unsigned long long) be64_to_cpu(target->path.dgid.global.interface_id));
+				     be64_to_cpu(ch->path.dgid.global.subnet_prefix),
+				     be64_to_cpu(ch->path.dgid.global.interface_id));
 
-			target->status = SRP_PORT_REDIRECT;
+			ch->status = SRP_PORT_REDIRECT;
 		} else {
 			shost_printk(KERN_WARNING, shost,
 				     "  REJ reason: IB_CM_REJ_PORT_REDIRECT\n");
-			target->status = -ECONNRESET;
+			ch->status = -ECONNRESET;
 		}
 		break;
 
 	case IB_CM_REJ_DUPLICATE_LOCAL_COMM_ID:
 		shost_printk(KERN_WARNING, shost,
 			    "  REJ reason: IB_CM_REJ_DUPLICATE_LOCAL_COMM_ID\n");
-		target->status = -ECONNRESET;
+		ch->status = -ECONNRESET;
 		break;
 
 	case IB_CM_REJ_CONSUMER_DEFINED:
@@ -2175,30 +2215,31 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 			else
 				shost_printk(KERN_WARNING, shost, PFX
 					     "SRP LOGIN from %pI6 to %pI6 REJECTED, reason 0x%08x\n",
-					     target->path.sgid.raw,
-					     target->orig_dgid, reason);
+					     target->sgid.raw,
+					     target->orig_dgid.raw, reason);
 		} else
 			shost_printk(KERN_WARNING, shost,
 				     "  REJ reason: IB_CM_REJ_CONSUMER_DEFINED,"
 				     " opcode 0x%02x\n", opcode);
-		target->status = -ECONNRESET;
+		ch->status = -ECONNRESET;
 		break;
 
 	case IB_CM_REJ_STALE_CONN:
 		shost_printk(KERN_WARNING, shost, "  REJ reason: stale connection\n");
-		target->status = SRP_STALE_CONN;
+		ch->status = SRP_STALE_CONN;
 		break;
 
 	default:
 		shost_printk(KERN_WARNING, shost, "  REJ reason 0x%x\n",
 			     event->param.rej_rcvd.reason);
-		target->status = -ECONNRESET;
+		ch->status = -ECONNRESET;
 	}
 }
 
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 {
-	struct srp_target_port *target = cm_id->context;
+	struct srp_rdma_ch *ch = cm_id->context;
+	struct srp_target_port *target = ch->target;
 	int comp = 0;
 
 	switch (event->event) {
@@ -2206,19 +2247,19 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		shost_printk(KERN_DEBUG, target->scsi_host,
 			     PFX "Sending CM REQ failed\n");
 		comp = 1;
-		target->status = -ECONNRESET;
+		ch->status = -ECONNRESET;
 		break;
 
 	case IB_CM_REP_RECEIVED:
 		comp = 1;
-		srp_cm_rep_handler(cm_id, event->private_data, target);
+		srp_cm_rep_handler(cm_id, event->private_data, ch);
 		break;
 
 	case IB_CM_REJ_RECEIVED:
 		shost_printk(KERN_DEBUG, target->scsi_host, PFX "REJ received\n");
 		comp = 1;
 
-		srp_cm_rej_handler(cm_id, event, target);
+		srp_cm_rej_handler(cm_id, event, ch);
 		break;
 
 	case IB_CM_DREQ_RECEIVED:
@@ -2236,7 +2277,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 			     PFX "connection closed\n");
 		comp = 1;
 
-		target->status = 0;
+		ch->status = 0;
 		break;
 
 	case IB_CM_MRA_RECEIVED:
@@ -2251,7 +2292,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	}
 
 	if (comp)
-		complete(&target->done);
+		complete(&ch->done);
 
 	return 0;
 }
@@ -2307,9 +2348,10 @@ srp_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 	return sdev->queue_depth;
 }
 
-static int srp_send_tsk_mgmt(struct srp_target_port *target,
-			     u64 req_tag, unsigned int lun, u8 func)
+static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag,
+			     unsigned int lun, u8 func)
 {
+	struct srp_target_port *target = ch->target;
 	struct srp_rport *rport = target->rport;
 	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	struct srp_iu *iu;
@@ -2318,16 +2360,16 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	if (!target->connected || target->qp_in_error)
 		return -1;
 
-	init_completion(&target->tsk_mgmt_done);
+	init_completion(&ch->tsk_mgmt_done);
 
 	/*
-	 * Lock the rport mutex to avoid that srp_create_target_ib() is
+	 * Lock the rport mutex to avoid that srp_create_ch_ib() is
 	 * invoked while a task management function is being sent.
 	 */
 	mutex_lock(&rport->mutex);
-	spin_lock_irq(&target->lock);
-	iu = __srp_get_tx_iu(target, SRP_IU_TSK_MGMT);
-	spin_unlock_irq(&target->lock);
+	spin_lock_irq(&ch->lock);
+	iu = __srp_get_tx_iu(ch, SRP_IU_TSK_MGMT);
+	spin_unlock_irq(&ch->lock);
 
 	if (!iu) {
 		mutex_unlock(&rport->mutex);
@@ -2348,15 +2390,15 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	ib_dma_sync_single_for_device(dev, iu->dma, sizeof *tsk_mgmt,
 				      DMA_TO_DEVICE);
-	if (srp_post_send(target, iu, sizeof *tsk_mgmt)) {
-		srp_put_tx_iu(target, iu, SRP_IU_TSK_MGMT);
+	if (srp_post_send(ch, iu, sizeof(*tsk_mgmt))) {
+		srp_put_tx_iu(ch, iu, SRP_IU_TSK_MGMT);
 		mutex_unlock(&rport->mutex);
 
 		return -1;
 	}
 	mutex_unlock(&rport->mutex);
 
-	if (!wait_for_completion_timeout(&target->tsk_mgmt_done,
+	if (!wait_for_completion_timeout(&ch->tsk_mgmt_done,
 					 msecs_to_jiffies(SRP_ABORT_TIMEOUT_MS)))
 		return -1;
 
@@ -2367,20 +2409,22 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
 	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
+	struct srp_rdma_ch *ch;
 	int ret;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || !srp_claim_req(target, req, NULL, scmnd))
+	ch = &target->ch;
+	if (!req || !srp_claim_req(ch, req, NULL, scmnd))
 		return SUCCESS;
-	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
+	if (srp_send_tsk_mgmt(ch, req->index, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK) == 0)
 		ret = SUCCESS;
 	else if (target->rport->state == SRP_RPORT_LOST)
 		ret = FAST_IO_FAIL;
 	else
 		ret = FAILED;
-	srp_free_req(target, req, scmnd, 0);
+	srp_free_req(ch, req, scmnd, 0);
 	scmnd->result = DID_ABORT << 16;
 	scmnd->scsi_done(scmnd);
 
@@ -2390,19 +2434,21 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 static int srp_reset_device(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
+	struct srp_rdma_ch *ch = &target->ch;
 	int i;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
-	if (srp_send_tsk_mgmt(target, SRP_TAG_NO_REQ, scmnd->device->lun,
+	if (srp_send_tsk_mgmt(ch, SRP_TAG_NO_REQ, scmnd->device->lun,
 			      SRP_TSK_LUN_RESET))
 		return FAILED;
-	if (target->tsk_mgmt_status)
+	if (ch->tsk_mgmt_status)
 		return FAILED;
 
 	for (i = 0; i < target->req_ring_size; ++i) {
-		struct srp_request *req = &target->req_ring[i];
-		srp_finish_req(target, req, scmnd->device, DID_RESET << 16);
+		struct srp_request *req = &ch->req_ring[i];
+
+		srp_finish_req(ch, req, scmnd->device, DID_RESET << 16);
 	}
 
 	return SUCCESS;
@@ -2464,7 +2510,7 @@ static ssize_t show_pkey(struct device *dev, struct device_attribute *attr,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	return sprintf(buf, "0x%04x\n", be16_to_cpu(target->path.pkey));
+	return sprintf(buf, "0x%04x\n", be16_to_cpu(target->pkey));
 }
 
 static ssize_t show_sgid(struct device *dev, struct device_attribute *attr,
@@ -2472,15 +2518,16 @@ static ssize_t show_sgid(struct device *dev, struct device_attribute *attr,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	return sprintf(buf, "%pI6\n", target->path.sgid.raw);
+	return sprintf(buf, "%pI6\n", target->sgid.raw);
 }
 
 static ssize_t show_dgid(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+	struct srp_rdma_ch *ch = &target->ch;
 
-	return sprintf(buf, "%pI6\n", target->path.dgid.raw);
+	return sprintf(buf, "%pI6\n", ch->path.dgid.raw);
 }
 
 static ssize_t show_orig_dgid(struct device *dev,
@@ -2488,7 +2535,7 @@ static ssize_t show_orig_dgid(struct device *dev,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	return sprintf(buf, "%pI6\n", target->orig_dgid);
+	return sprintf(buf, "%pI6\n", target->orig_dgid.raw);
 }
 
 static ssize_t show_req_lim(struct device *dev,
@@ -2496,7 +2543,7 @@ static ssize_t show_req_lim(struct device *dev,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	return sprintf(buf, "%d\n", target->req_lim);
+	return sprintf(buf, "%d\n", target->ch.req_lim);
 }
 
 static ssize_t show_zero_req_lim(struct device *dev,
@@ -2778,7 +2825,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 	int opt_mask = 0;
 	int token;
 	int ret = -EINVAL;
-	int i;
+	int i, b;
 
 	options = kstrdup(buf, GFP_KERNEL);
 	if (!options)
@@ -2826,11 +2873,15 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			}
 
 			for (i = 0; i < 16; ++i) {
-				strlcpy(dgid, p + i * 2, 3);
-				target->path.dgid.raw[i] = simple_strtoul(dgid, NULL, 16);
+				strlcpy(dgid, p + i * 2, sizeof(dgid));
+				if (sscanf(dgid, "%x", &b) < 1) {
+					ret = -EINVAL;
+					kfree(p);
+					goto out;
+				}
+				target->orig_dgid.raw[i] = b;
 			}
 			kfree(p);
-			memcpy(target->orig_dgid, target->path.dgid.raw, 16);
 			break;
 
 		case SRP_OPT_PKEY:
@@ -2838,7 +2889,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				pr_warn("bad P_Key parameter '%s'\n", p);
 				goto out;
 			}
-			target->path.pkey = cpu_to_be16(token);
+			target->pkey = cpu_to_be16(token);
 			break;
 
 		case SRP_OPT_SERVICE_ID:
@@ -2848,7 +2899,6 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				goto out;
 			}
 			target->service_id = cpu_to_be64(simple_strtoull(p, NULL, 16));
-			target->path.service_id = target->service_id;
 			kfree(p);
 			break;
 
@@ -2985,6 +3035,7 @@ static ssize_t srp_create_target(struct device *dev,
 		container_of(dev, struct srp_host, dev);
 	struct Scsi_Host *target_host;
 	struct srp_target_port *target;
+	struct srp_rdma_ch *ch;
 	struct srp_device *srp_dev = host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
 	int ret;
@@ -3047,24 +3098,28 @@ static ssize_t srp_create_target(struct device *dev,
 	INIT_WORK(&target->tl_err_work, srp_tl_err_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
-	INIT_LIST_HEAD(&target->free_tx);
-	ret = srp_alloc_req_data(target);
+	ch = &target->ch;
+	ch->target = target;
+	ch->comp_vector = target->comp_vector;
+	spin_lock_init(&ch->lock);
+	INIT_LIST_HEAD(&ch->free_tx);
+	ret = srp_alloc_req_data(ch);
 	if (ret)
 		goto err_free_mem;
 
-	ret = ib_query_gid(ibdev, host->port, 0, &target->path.sgid);
+	ret = ib_query_gid(ibdev, host->port, 0, &target->sgid);
 	if (ret)
 		goto err_free_mem;
 
-	ret = srp_create_target_ib(target);
+	ret = srp_create_ch_ib(ch);
 	if (ret)
 		goto err_free_mem;
 
-	ret = srp_new_cm_id(target);
+	ret = srp_new_cm_id(ch);
 	if (ret)
 		goto err_free_ib;
 
-	ret = srp_connect_target(target);
+	ret = srp_connect_ch(ch);
 	if (ret) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "Connection failed\n");
@@ -3083,9 +3138,9 @@ static ssize_t srp_create_target(struct device *dev,
 			     "new target: id_ext %016llx ioc_guid %016llx pkey %04x service_id %016llx sgid %pI6 dgid %pI6\n",
 			     be64_to_cpu(target->id_ext),
 			     be64_to_cpu(target->ioc_guid),
-			     be16_to_cpu(target->path.pkey),
+			     be16_to_cpu(target->pkey),
 			     be64_to_cpu(target->service_id),
-			     target->path.sgid.raw, target->orig_dgid);
+			     target->sgid.raw, target->orig_dgid.raw);
 	}
 
 	scsi_host_put(target->scsi_host);
@@ -3100,10 +3155,10 @@ err_disconnect:
 	srp_disconnect_target(target);
 
 err_free_ib:
-	srp_free_target_ib(target);
+	srp_free_ch_ib(ch);
 
 err_free_mem:
-	srp_free_req_data(target);
+	srp_free_req_data(ch);
 
 err:
 	scsi_host_put(target_host);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 00c7c48..0609124 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -130,7 +130,7 @@ struct srp_request {
 	short			index;
 };
 
-struct srp_target_port {
+struct srp_rdma_ch {
 	/* These are RW in the hot path, and commonly used together */
 	struct list_head	free_tx;
 	struct list_head	free_reqs;
@@ -138,13 +138,43 @@ struct srp_target_port {
 	s32			req_lim;
 
 	/* These are read-only in the hot path */
-	struct ib_cq	       *send_cq ____cacheline_aligned_in_smp;
+	struct srp_target_port *target ____cacheline_aligned_in_smp;
+	struct ib_cq	       *send_cq;
 	struct ib_cq	       *recv_cq;
 	struct ib_qp	       *qp;
 	union {
 		struct ib_fmr_pool     *fmr_pool;
 		struct srp_fr_pool     *fr_pool;
 	};
+
+	/* Everything above this point is used in the hot path of
+	 * command processing. Try to keep them packed into cachelines.
+	 */
+
+	struct completion	done;
+	int			status;
+
+	struct ib_sa_path_rec	path;
+	struct ib_sa_query     *path_query;
+	int			path_query_id;
+
+	struct ib_cm_id	       *cm_id;
+	struct srp_iu	      **tx_ring;
+	struct srp_iu	      **rx_ring;
+	struct srp_request     *req_ring;
+	int			max_ti_iu_len;
+	int			comp_vector;
+
+	struct completion	tsk_mgmt_done;
+	u8			tsk_mgmt_status;
+};
+
+struct srp_target_port {
+	/* read and written in the hot path */
+	spinlock_t		lock;
+
+	struct srp_rdma_ch	ch;
+	/* read only in the hot path */
 	u32			lkey;
 	u32			rkey;
 	enum srp_target_state	state;
@@ -153,10 +183,8 @@ struct srp_target_port {
 	unsigned int		indirect_size;
 	bool			allow_ext_sg;
 
-	/* Everything above this point is used in the hot path of
-	 * command processing. Try to keep them packed into cachelines.
-	 */
-
+	/* other member variables */
+	union ib_gid		sgid;
 	__be64			id_ext;
 	__be64			ioc_guid;
 	__be64			service_id;
@@ -173,34 +201,19 @@ struct srp_target_port {
 	int			comp_vector;
 	int			tl_retry_count;
 
-	struct ib_sa_path_rec	path;
-	__be16			orig_dgid[8];
-	struct ib_sa_query     *path_query;
-	int			path_query_id;
+	union ib_gid		orig_dgid;
+	__be16			pkey;
 
 	u32			rq_tmo_jiffies;
 	bool			connected;
 
-	struct ib_cm_id	       *cm_id;
-
-	int			max_ti_iu_len;
-
 	int			zero_req_lim;
 
-	struct srp_iu	       **tx_ring;
-	struct srp_iu	       **rx_ring;
-	struct srp_request	*req_ring;
-
 	struct work_struct	tl_err_work;
 	struct work_struct	remove_work;
 
 	struct list_head	list;
-	struct completion	done;
-	int			status;
 	bool			qp_in_error;
-
-	struct completion	tsk_mgmt_done;
-	u8			tsk_mgmt_status;
 };
 
 struct srp_iu {
-- 
1.8.4.5

