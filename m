From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 8/8] IB/srp: Add multichannel support
Date: Fri, 19 Sep 2014 15:00:16 +0200
Message-ID: <541C28E0.7010705@acm.org>
References: <541C27BF.6070609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541C27BF.6070609-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Improve performance by using multiple RDMA/RC channels per SCSI host
for communicating with an SRP target.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-driver-ib_srp |  25 +-
 drivers/infiniband/ulp/srp/ib_srp.c          | 337 ++++++++++++++++++++-------
 drivers/infiniband/ulp/srp/ib_srp.h          |  20 +-
 3 files changed, 287 insertions(+), 95 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-ib_srp b/Documentation/ABI/stable/sysfs-driver-ib_srp
index b9688de..d5a459e 100644
--- a/Documentation/ABI/stable/sysfs-driver-ib_srp
+++ b/Documentation/ABI/stable/sysfs-driver-ib_srp
@@ -55,12 +55,12 @@ Description:	Interface for making ib_srp connect to a new target.
 		  only safe with partial memory descriptor list support enabled
 		  (allow_ext_sg=1).
 		* comp_vector, a number in the range 0..n-1 specifying the
-		  MSI-X completion vector. Some HCA's allocate multiple (n)
-		  MSI-X vectors per HCA port. If the IRQ affinity masks of
-		  these interrupts have been configured such that each MSI-X
-		  interrupt is handled by a different CPU then the comp_vector
-		  parameter can be used to spread the SRP completion workload
-		  over multiple CPU's.
+		  MSI-X completion vector of the first RDMA channel. Some
+		  HCA's allocate multiple (n) MSI-X vectors per HCA port. If
+		  the IRQ affinity masks of these interrupts have been
+		  configured such that each MSI-X interrupt is handled by a
+		  different CPU then the comp_vector parameter can be used to
+		  spread the SRP completion workload over multiple CPU's.
 		* tl_retry_count, a number in the range 2..7 specifying the
 		  IB RC retry count.
 		* queue_size, the maximum number of commands that the
@@ -88,6 +88,13 @@ Description:	Whether ib_srp is allowed to include a partial memory
 		descriptor list in an SRP_CMD when communicating with an SRP
 		target.
 
+What:		/sys/class/scsi_host/host<n>/ch_count
+Date:		November 1, 2014
+KernelVersion:	3.18
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Number of RDMA channels used for communication with the SRP
+		target.
+
 What:		/sys/class/scsi_host/host<n>/cmd_sg_entries
 Date:		May 19, 2011
 KernelVersion:	2.6.39
@@ -95,6 +102,12 @@ Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	Maximum number of data buffer descriptors that may be sent to
 		the target in a single SRP_CMD request.
 
+What:		/sys/class/scsi_host/host<n>/comp_vector
+Date:		September 2, 2013
+KernelVersion:	3.11
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Completion vector used for the first RDMA channel.
+
 What:		/sys/class/scsi_host/host<n>/dgid
 Date:		June 17, 2006
 KernelVersion:	2.6.17
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 9feeea1..58ca618 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -123,6 +123,16 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 " if fast_io_fail_tmo has not been set. \"off\" means that"
 		 " this functionality is disabled.");
 
+static unsigned ch_count;
+module_param(ch_count, uint, 0444);
+MODULE_PARM_DESC(ch_count,
+		 "Number of RDMA channels to use for communication with an SRP"
+		 " target. Using more than one channel improves performance"
+		 " if the HCA supports multiple completion vectors. The"
+		 " default value is the minimum of four times the number of"
+		 " online CPU sockets and the number of completion vectors"
+		 " supported by the HCA.");
+
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *ch_ptr);
@@ -556,17 +566,32 @@ err:
  * Note: this function may be called without srp_alloc_iu_bufs() having been
  * invoked. Hence the ch->[rt]x_ring checks.
  */
-static void srp_free_ch_ib(struct srp_rdma_ch *ch)
+static void srp_free_ch_ib(struct srp_target_port *target,
+			   struct srp_rdma_ch *ch)
 {
-	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	int i;
 
+	if (!ch->target)
+		return;
+
+	/*
+	 * Avoid that the SCSI error handler tries to use this channel after
+	 * it has been freed. The SCSI error handler can namely continue
+	 * trying to perform recovery actions after scsi_remove_host()
+	 * returned.
+	 */
+	ch->target = NULL;
+
 	if (ch->cm_id) {
 		ib_destroy_cm_id(ch->cm_id);
 		ch->cm_id = NULL;
 	}
 
+	/* If srp_new_cm_id() succeeded but srp_create_ch_ib() not, return. */
+	if (!ch->qp)
+		return;
+
 	if (dev->use_fast_reg) {
 		if (ch->fr_pool)
 			srp_destroy_fr_pool(ch->fr_pool);
@@ -647,7 +672,7 @@ static int srp_lookup_path(struct srp_rdma_ch *ch)
 	return ch->status;
 }
 
-static int srp_send_req(struct srp_rdma_ch *ch)
+static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 {
 	struct srp_target_port *target = ch->target;
 	struct {
@@ -688,6 +713,8 @@ static int srp_send_req(struct srp_rdma_ch *ch)
 	req->priv.req_it_iu_len = cpu_to_be32(target->max_iu_len);
 	req->priv.req_buf_fmt 	= cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
 					      SRP_BUF_FORMAT_INDIRECT);
+	req->priv.req_flags	= (multich ? SRP_MULTICHAN_MULTI :
+				   SRP_MULTICHAN_SINGLE);
 	/*
 	 * In the published SRP specification (draft rev. 16a), the
 	 * port identifier format is 8 bytes of ID extension followed
@@ -769,27 +796,31 @@ static bool srp_change_conn_state(struct srp_target_port *target,
 
 static void srp_disconnect_target(struct srp_target_port *target)
 {
-	struct srp_rdma_ch *ch = &target->ch;
+	struct srp_rdma_ch *ch;
+	int i;
 
 	if (srp_change_conn_state(target, false)) {
 		/* XXX should send SRP_I_LOGOUT request */
 
-		if (ib_send_cm_dreq(ch->cm_id, NULL, 0)) {
-			shost_printk(KERN_DEBUG, target->scsi_host,
-				     PFX "Sending CM DREQ failed\n");
+		for (i = 0; i < target->ch_count; i++) {
+			ch = &target->ch[i];
+			if (ch->cm_id && ib_send_cm_dreq(ch->cm_id, NULL, 0)) {
+				shost_printk(KERN_DEBUG, target->scsi_host,
+					     PFX "Sending CM DREQ failed\n");
+			}
 		}
 	}
 }
 
-static void srp_free_req_data(struct srp_rdma_ch *ch)
+static void srp_free_req_data(struct srp_target_port *target,
+			      struct srp_rdma_ch *ch)
 {
-	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
 	struct srp_request *req;
 	int i;
 
-	if (!ch->req_ring)
+	if (!ch->target || !ch->req_ring)
 		return;
 
 	for (i = 0; i < target->req_ring_size; ++i) {
@@ -853,7 +884,7 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 			goto out;
 
 		req->indirect_dma_addr = dma_addr;
-		req->index = i;
+		req->tag = build_srp_tag(ch - target->ch, i);
 		list_add_tail(&req->list, &ch->free_reqs);
 	}
 	ret = 0;
@@ -879,7 +910,8 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 
 static void srp_remove_target(struct srp_target_port *target)
 {
-	struct srp_rdma_ch *ch = &target->ch;
+	struct srp_rdma_ch *ch;
+	int i;
 
 	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);
 
@@ -889,10 +921,18 @@ static void srp_remove_target(struct srp_target_port *target)
 	scsi_remove_host(target->scsi_host);
 	srp_stop_rport_timers(target->rport);
 	srp_disconnect_target(target);
-	srp_free_ch_ib(ch);
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		srp_free_ch_ib(target, ch);
+	}
 	cancel_work_sync(&target->tl_err_work);
 	srp_rport_put(target->rport);
-	srp_free_req_data(ch);
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		srp_free_req_data(target, ch);
+	}
+	kfree(target->ch);
+	target->ch = NULL;
 
 	spin_lock(&target->srp_host->target_lock);
 	list_del(&target->list);
@@ -918,12 +958,12 @@ static void srp_rport_delete(struct srp_rport *rport)
 	srp_queue_remove_work(target);
 }
 
-static int srp_connect_ch(struct srp_rdma_ch *ch)
+static int srp_connect_ch(struct srp_rdma_ch *ch, bool multich)
 {
 	struct srp_target_port *target = ch->target;
 	int ret;
 
-	WARN_ON_ONCE(target->connected);
+	WARN_ON_ONCE(!multich && target->connected);
 
 	target->qp_in_error = false;
 
@@ -933,7 +973,7 @@ static int srp_connect_ch(struct srp_rdma_ch *ch)
 
 	while (1) {
 		init_completion(&ch->done);
-		ret = srp_send_req(ch);
+		ret = srp_send_req(ch, multich);
 		if (ret)
 			return ret;
 		ret = wait_for_completion_interruptible(&ch->done);
@@ -1095,10 +1135,10 @@ static void srp_finish_req(struct srp_rdma_ch *ch, struct srp_request *req,
 static void srp_terminate_io(struct srp_rport *rport)
 {
 	struct srp_target_port *target = rport->lld_data;
-	struct srp_rdma_ch *ch = &target->ch;
+	struct srp_rdma_ch *ch;
 	struct Scsi_Host *shost = target->scsi_host;
 	struct scsi_device *sdev;
-	int i;
+	int i, j;
 
 	/*
 	 * Invoking srp_terminate_io() while srp_queuecommand() is running
@@ -1107,10 +1147,15 @@ static void srp_terminate_io(struct srp_rport *rport)
 	shost_for_each_device(sdev, shost)
 		WARN_ON_ONCE(sdev->request_queue->request_fn_active);
 
-	for (i = 0; i < target->req_ring_size; ++i) {
-		struct srp_request *req = &ch->req_ring[i];
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+
+		for (j = 0; j < target->req_ring_size; ++j) {
+			struct srp_request *req = &ch->req_ring[j];
 
-		srp_finish_req(ch, req, NULL, DID_TRANSPORT_FAILFAST << 16);
+			srp_finish_req(ch, req, NULL,
+				       DID_TRANSPORT_FAILFAST << 16);
+		}
 	}
 }
 
@@ -1126,8 +1171,9 @@ static void srp_terminate_io(struct srp_rport *rport)
 static int srp_rport_reconnect(struct srp_rport *rport)
 {
 	struct srp_target_port *target = rport->lld_data;
-	struct srp_rdma_ch *ch = &target->ch;
-	int i, ret;
+	struct srp_rdma_ch *ch;
+	int i, j, ret = 0;
+	bool multich = false;
 
 	srp_disconnect_target(target);
 
@@ -1139,27 +1185,43 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	 * case things are really fouled up. Doing so also ensures that all CM
 	 * callbacks will have finished before a new QP is allocated.
 	 */
-	ret = srp_new_cm_id(ch);
-
-	for (i = 0; i < target->req_ring_size; ++i) {
-		struct srp_request *req = &ch->req_ring[i];
-
-		srp_finish_req(ch, req, NULL, DID_RESET << 16);
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		if (!ch->target)
+			return -ENODEV;
+		ret += srp_new_cm_id(ch);
+	}
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		for (j = 0; j < target->req_ring_size; ++j) {
+			struct srp_request *req = &ch->req_ring[j];
+
+			srp_finish_req(ch, req, NULL, DID_RESET << 16);
+		}
 	}
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		/*
+		 * Whether or not creating a new CM ID succeeded, create a new
+		 * QP. This guarantees that all completion callback function
+		 * invocations have finished before request resetting starts.
+		 */
+		ret += srp_create_ch_ib(ch);
 
-	/*
-	 * Whether or not creating a new CM ID succeeded, create a new
-	 * QP. This guarantees that all callback functions for the old QP have
-	 * finished before any send requests are posted on the new QP.
-	 */
-	ret += srp_create_ch_ib(ch);
-
-	INIT_LIST_HEAD(&ch->free_tx);
-	for (i = 0; i < target->queue_size; ++i)
-		list_add(&ch->tx_ring[i]->list, &ch->free_tx);
-
-	if (ret == 0)
-		ret = srp_connect_ch(ch);
+		INIT_LIST_HEAD(&ch->free_tx);
+		for (j = 0; j < target->queue_size; ++j)
+			list_add(&ch->tx_ring[j]->list, &ch->free_tx);
+	}
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		if (ret) {
+			if (i > 1)
+				ret = 0;
+			break;
+		}
+		ret = srp_connect_ch(ch, multich);
+		multich = true;
+	}
 
 	if (ret == 0)
 		shost_printk(KERN_INFO, target->scsi_host,
@@ -1573,7 +1635,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_rdma_ch *ch,
 	s32 rsv = (iu_type == SRP_IU_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
 	struct srp_iu *iu;
 
-	srp_send_completion(ch->send_cq, target);
+	srp_send_completion(ch->send_cq, ch);
 
 	if (list_empty(&ch->free_tx))
 		return NULL;
@@ -1637,6 +1699,7 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 	struct srp_request *req;
 	struct scsi_cmnd *scmnd;
 	unsigned long flags;
+	unsigned i;
 
 	if (unlikely(rsp->tag & SRP_TAG_TSK_MGMT)) {
 		spin_lock_irqsave(&ch->lock, flags);
@@ -1648,12 +1711,20 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 			ch->tsk_mgmt_status = rsp->data[3];
 		complete(&ch->tsk_mgmt_done);
 	} else {
-		req = &ch->req_ring[rsp->tag];
-		scmnd = srp_claim_req(ch, req, NULL, NULL);
+		if (srp_tag_ch(rsp->tag) != ch - target->ch)
+			pr_err("Channel idx mismatch: tag %#llx <> ch %#lx\n",
+			       rsp->tag, ch - target->ch);
+		i = srp_tag_idx(rsp->tag);
+		if (i < target->req_ring_size) {
+			req = &ch->req_ring[i];
+			scmnd = srp_claim_req(ch, req, NULL, NULL);
+		} else {
+			scmnd = NULL;
+		}
 		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
-				     "Null scmnd for RSP w/tag %016llx\n",
-				     (unsigned long long) rsp->tag);
+				     "Null scmnd for RSP w/tag %#016llx received on ch %ld / QP %#x\n",
+				     rsp->tag, ch - target->ch, ch->qp->qp_num);
 
 			spin_lock_irqsave(&ch->lock, flags);
 			ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
@@ -1879,7 +1950,8 @@ static void srp_send_completion(struct ib_cq *cq, void *ch_ptr)
 	}
 }
 
-static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
+static int srp_queuecommand(unsigned hwq, struct Scsi_Host *shost,
+			    struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(shost);
 	struct srp_rport *rport = target->rport;
@@ -1905,7 +1977,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (unlikely(scmnd->result))
 		goto err;
 
-	ch = &target->ch;
+	ch = &target->ch[hwq];
 
 	spin_lock_irqsave(&ch->lock, flags);
 	iu = __srp_get_tx_iu(ch, SRP_IU_CMD);
@@ -1927,7 +1999,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	cmd->opcode = SRP_CMD;
 	cmd->lun    = cpu_to_be64((u64) scmnd->device->lun << 48);
-	cmd->tag    = req->index;
+	cmd->tag    = req->tag;
 	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
 
 	req->scmnd    = scmnd;
@@ -1993,6 +2065,17 @@ err:
 	goto unlock_rport;
 }
 
+static int srp_sq_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
+{
+	return srp_queuecommand(0, shost, scmnd);
+}
+
+static int srp_mq_queuecommand(struct blk_mq_hw_ctx *hctx,
+			       struct scsi_cmnd *scmnd)
+{
+	return srp_queuecommand(hctx->queue_num, scmnd->device->host, scmnd);
+}
+
 /*
  * Note: the resources allocated in this function are freed in
  * srp_free_ch_ib().
@@ -2409,15 +2492,23 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
 	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
+	u16 ch_idx;
 	struct srp_rdma_ch *ch;
 	int ret;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	ch = &target->ch;
-	if (!req || !srp_claim_req(ch, req, NULL, scmnd))
+	if (!req)
+		return SUCCESS;
+	ch_idx = srp_tag_ch(req->tag);
+	if (WARN_ON_ONCE(ch_idx >= target->ch_count))
 		return SUCCESS;
-	if (srp_send_tsk_mgmt(ch, req->index, scmnd->device->lun,
+	ch = &target->ch[ch_idx];
+	if (!srp_claim_req(ch, req, NULL, scmnd))
+		return SUCCESS;
+	shost_printk(KERN_ERR, target->scsi_host,
+		     "Sending SRP abort for tag %#x\n", req->tag);
+	if (srp_send_tsk_mgmt(ch, req->tag, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK) == 0)
 		ret = SUCCESS;
 	else if (target->rport->state == SRP_RPORT_LOST)
@@ -2434,21 +2525,25 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 static int srp_reset_device(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
-	struct srp_rdma_ch *ch = &target->ch;
+	struct srp_rdma_ch *ch;
 	int i;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
+	ch = &target->ch[0];
 	if (srp_send_tsk_mgmt(ch, SRP_TAG_NO_REQ, scmnd->device->lun,
 			      SRP_TSK_LUN_RESET))
 		return FAILED;
 	if (ch->tsk_mgmt_status)
 		return FAILED;
 
-	for (i = 0; i < target->req_ring_size; ++i) {
-		struct srp_request *req = &ch->req_ring[i];
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		for (i = 0; i < target->req_ring_size; ++i) {
+			struct srp_request *req = &ch->req_ring[i];
 
-		srp_finish_req(ch, req, scmnd->device, DID_RESET << 16);
+			srp_finish_req(ch, req, scmnd->device, DID_RESET << 16);
+		}
 	}
 
 	return SUCCESS;
@@ -2525,7 +2620,7 @@ static ssize_t show_dgid(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
-	struct srp_rdma_ch *ch = &target->ch;
+	struct srp_rdma_ch *ch = &target->ch[0];
 
 	return sprintf(buf, "%pI6\n", ch->path.dgid.raw);
 }
@@ -2542,8 +2637,14 @@ static ssize_t show_req_lim(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+	struct srp_rdma_ch *ch;
+	int i, req_lim = INT_MAX;
 
-	return sprintf(buf, "%d\n", target->ch.req_lim);
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		req_lim = min(req_lim, ch->req_lim);
+	}
+	return sprintf(buf, "%d\n", req_lim);
 }
 
 static ssize_t show_zero_req_lim(struct device *dev,
@@ -2570,6 +2671,14 @@ static ssize_t show_local_ib_device(struct device *dev,
 	return sprintf(buf, "%s\n", target->srp_host->srp_dev->dev->name);
 }
 
+static ssize_t show_ch_count(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%d\n", target->ch_count);
+}
+
 static ssize_t show_comp_vector(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -2613,6 +2722,7 @@ static DEVICE_ATTR(req_lim,         S_IRUGO, show_req_lim,         NULL);
 static DEVICE_ATTR(zero_req_lim,    S_IRUGO, show_zero_req_lim,	   NULL);
 static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
+static DEVICE_ATTR(ch_count,        S_IRUGO, show_ch_count,        NULL);
 static DEVICE_ATTR(comp_vector,     S_IRUGO, show_comp_vector,     NULL);
 static DEVICE_ATTR(tl_retry_count,  S_IRUGO, show_tl_retry_count,  NULL);
 static DEVICE_ATTR(cmd_sg_entries,  S_IRUGO, show_cmd_sg_entries,  NULL);
@@ -2630,6 +2740,7 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_zero_req_lim,
 	&dev_attr_local_ib_port,
 	&dev_attr_local_ib_device,
+	&dev_attr_ch_count,
 	&dev_attr_comp_vector,
 	&dev_attr_tl_retry_count,
 	&dev_attr_cmd_sg_entries,
@@ -2643,7 +2754,8 @@ static struct scsi_host_template srp_template = {
 	.proc_name			= DRV_NAME,
 	.slave_configure		= srp_slave_configure,
 	.info				= srp_target_info,
-	.queuecommand			= srp_queuecommand,
+	.queuecommand			= srp_sq_queuecommand,
+	.mq_queuecommand		= srp_mq_queuecommand,
 	.change_queue_depth             = srp_change_queue_depth,
 	.change_queue_type              = srp_change_queue_type,
 	.eh_abort_handler		= srp_abort,
@@ -3038,7 +3150,8 @@ static ssize_t srp_create_target(struct device *dev,
 	struct srp_rdma_ch *ch;
 	struct srp_device *srp_dev = host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
-	int ret;
+	int ret, node_idx, node, cpu, i;
+	bool multich = false;
 
 	target_host = scsi_host_alloc(&srp_template,
 				      sizeof (struct srp_target_port));
@@ -3098,34 +3211,82 @@ static ssize_t srp_create_target(struct device *dev,
 	INIT_WORK(&target->tl_err_work, srp_tl_err_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
-	ch = &target->ch;
-	ch->target = target;
-	ch->comp_vector = target->comp_vector;
-	spin_lock_init(&ch->lock);
-	INIT_LIST_HEAD(&ch->free_tx);
-	ret = srp_alloc_req_data(ch);
-	if (ret)
-		goto err_free_mem;
-
 	ret = ib_query_gid(ibdev, host->port, 0, &target->sgid);
 	if (ret)
-		goto err_free_mem;
+		goto err;
 
-	ret = srp_create_ch_ib(ch);
-	if (ret)
-		goto err_free_mem;
+	ret = -ENOMEM;
+	target->ch_count = max_t(unsigned, num_online_nodes(),
+				 min(ch_count ? :
+				     min(4 * num_online_nodes(),
+					 ibdev->num_comp_vectors),
+				     num_online_cpus()));
+	target->ch = kcalloc(target->ch_count, sizeof(*target->ch),
+			     GFP_KERNEL);
+	if (!target->ch)
+		goto err;
 
-	ret = srp_new_cm_id(ch);
-	if (ret)
-		goto err_free_ib;
+	node_idx = 0;
+	for_each_online_node(node) {
+		const int ch_start = (node_idx * target->ch_count /
+				      num_online_nodes());
+		const int ch_end = ((node_idx + 1) * target->ch_count /
+				    num_online_nodes());
+		const int cv_start = (node_idx * ibdev->num_comp_vectors /
+				      num_online_nodes() + target->comp_vector)
+				     % ibdev->num_comp_vectors;
+		const int cv_end = ((node_idx + 1) * ibdev->num_comp_vectors /
+				    num_online_nodes() + target->comp_vector)
+				   % ibdev->num_comp_vectors;
+		int cpu_idx = 0;
+
+		for_each_online_cpu(cpu) {
+			if (cpu_to_node(cpu) != node)
+				continue;
+			if (ch_start + cpu_idx >= ch_end)
+				continue;
+			ch = &target->ch[ch_start + cpu_idx];
+			ch->target = target;
+			ch->comp_vector = cv_start == cv_end ? cv_start :
+				cv_start + cpu_idx % (cv_end - cv_start);
+			spin_lock_init(&ch->lock);
+			INIT_LIST_HEAD(&ch->free_tx);
+			ret = srp_new_cm_id(ch);
+			if (ret)
+				goto err_disconnect;
 
-	ret = srp_connect_ch(ch);
-	if (ret) {
-		shost_printk(KERN_ERR, target->scsi_host,
-			     PFX "Connection failed\n");
-		goto err_free_ib;
+			ret = srp_create_ch_ib(ch);
+			if (ret)
+				goto err_disconnect;
+
+			ret = srp_alloc_req_data(ch);
+			if (ret)
+				goto err_disconnect;
+
+			ret = srp_connect_ch(ch, multich);
+			if (ret) {
+				shost_printk(KERN_ERR, target->scsi_host,
+					     PFX "Connection %d/%d failed\n",
+					     ch_start + cpu_idx,
+					     target->ch_count);
+				if (node_idx == 0 && cpu_idx == 0) {
+					goto err_disconnect;
+				} else {
+					srp_free_ch_ib(target, ch);
+					srp_free_req_data(target, ch);
+					target->ch_count = ch - target->ch;
+					break;
+				}
+			}
+
+			multich = true;
+			cpu_idx++;
+		}
+		node_idx++;
 	}
 
+	target->scsi_host->nr_hw_queues = target->ch_count;
+
 	ret = srp_add_target(host, target);
 	if (ret)
 		goto err_disconnect;
@@ -3154,11 +3315,13 @@ out:
 err_disconnect:
 	srp_disconnect_target(target);
 
-err_free_ib:
-	srp_free_ch_ib(ch);
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		srp_free_ch_ib(target, ch);
+		srp_free_req_data(target, ch);
+	}
 
-err_free_mem:
-	srp_free_req_data(ch);
+	kfree(target->ch);
 
 err:
 	scsi_host_put(target_host);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 0609124..d9660e1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -84,6 +84,21 @@ enum srp_iu_type {
 	SRP_IU_RSP,
 };
 
+static inline u32 build_srp_tag(u16 ch, u16 req_idx)
+{
+	return ch << 16 | req_idx;
+}
+
+static inline u16 srp_tag_ch(u32 tag)
+{
+	return tag >> 16;
+}
+
+static inline u16 srp_tag_idx(u32 tag)
+{
+	return tag & ((1 << 16) - 1);
+}
+
 /*
  * @mr_page_mask: HCA memory registration page mask.
  * @mr_page_size: HCA memory registration page size.
@@ -127,7 +142,7 @@ struct srp_request {
 	struct srp_direct_buf  *indirect_desc;
 	dma_addr_t		indirect_dma_addr;
 	short			nmdesc;
-	short			index;
+	uint32_t		tag;
 };
 
 struct srp_rdma_ch {
@@ -173,8 +188,9 @@ struct srp_target_port {
 	/* read and written in the hot path */
 	spinlock_t		lock;
 
-	struct srp_rdma_ch	ch;
 	/* read only in the hot path */
+	struct srp_rdma_ch	*ch;
+	u32			ch_count;
 	u32			lkey;
 	u32			rkey;
 	enum srp_target_state	state;
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
