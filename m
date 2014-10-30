From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v3 09/11] IB/srp: Use block layer tags
Date: Thu, 30 Oct 2014 14:48:55 +0100
Message-ID: <545241C7.5010707@acm.org>
References: <545240AE.6060009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545240AE.6060009-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Since the block layer already contains functionality to assign
a tag to each request, use that functionality instead of
reimplementing that functionality in the SRP initiator driver.
This change makes the free_reqs list superfluous. Hence remove
that list.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 55 +++++++++++++++++++++++--------------
 drivers/infiniband/ulp/srp/ib_srp.h |  3 --
 2 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cc0bf83b..ee4827f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -821,8 +821,6 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 	dma_addr_t dma_addr;
 	int i, ret = -ENOMEM;
 
-	INIT_LIST_HEAD(&ch->free_reqs);
-
 	ch->req_ring = kcalloc(target->req_ring_size, sizeof(*ch->req_ring),
 			       GFP_KERNEL);
 	if (!ch->req_ring)
@@ -853,8 +851,6 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 			goto out;
 
 		req->indirect_dma_addr = dma_addr;
-		req->index = i;
-		list_add_tail(&req->list, &ch->free_reqs);
 	}
 	ret = 0;
 
@@ -1076,7 +1072,6 @@ static void srp_free_req(struct srp_rdma_ch *ch, struct srp_request *req,
 
 	spin_lock_irqsave(&ch->lock, flags);
 	ch->req_lim += req_lim_delta;
-	list_add_tail(&req->list, &ch->free_reqs);
 	spin_unlock_irqrestore(&ch->lock, flags);
 }
 
@@ -1648,8 +1643,11 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 			ch->tsk_mgmt_status = rsp->data[3];
 		complete(&ch->tsk_mgmt_done);
 	} else {
-		req = &ch->req_ring[rsp->tag];
-		scmnd = srp_claim_req(ch, req, NULL, NULL);
+		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
+		if (scmnd) {
+			req = (void *)scmnd->host_scribble;
+			scmnd = srp_claim_req(ch, req, NULL, scmnd);
+		}
 		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     "Null scmnd for RSP w/tag %016llx\n",
@@ -1889,6 +1887,8 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	struct srp_cmd *cmd;
 	struct ib_device *dev;
 	unsigned long flags;
+	u32 tag;
+	u16 idx;
 	int len, ret;
 	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
 
@@ -1905,17 +1905,22 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (unlikely(scmnd->result))
 		goto err;
 
+	WARN_ON_ONCE(scmnd->request->tag < 0);
+	tag = blk_mq_unique_tag(scmnd->request);
 	ch = &target->ch;
+	idx = blk_mq_unique_tag_to_tag(tag);
+	WARN_ONCE(idx >= target->req_ring_size, "%s: tag %#x: idx %d >= %d\n",
+		  dev_name(&shost->shost_gendev), tag, idx,
+		  target->req_ring_size);
 
 	spin_lock_irqsave(&ch->lock, flags);
 	iu = __srp_get_tx_iu(ch, SRP_IU_CMD);
-	if (!iu)
-		goto err_unlock;
-
-	req = list_first_entry(&ch->free_reqs, struct srp_request, list);
-	list_del(&req->list);
 	spin_unlock_irqrestore(&ch->lock, flags);
 
+	if (!iu)
+		goto err;
+
+	req = &ch->req_ring[idx];
 	dev = target->srp_host->srp_dev->dev;
 	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_iu_len,
 				   DMA_TO_DEVICE);
@@ -1927,7 +1932,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	cmd->opcode = SRP_CMD;
 	cmd->lun    = cpu_to_be64((u64) scmnd->device->lun << 48);
-	cmd->tag    = req->index;
+	cmd->tag    = tag;
 	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
 
 	req->scmnd    = scmnd;
@@ -1976,12 +1981,6 @@ err_iu:
 	 */
 	req->scmnd = NULL;
 
-	spin_lock_irqsave(&ch->lock, flags);
-	list_add(&req->list, &ch->free_reqs);
-
-err_unlock:
-	spin_unlock_irqrestore(&ch->lock, flags);
-
 err:
 	if (scmnd->result) {
 		scmnd->scsi_done(scmnd);
@@ -2409,6 +2408,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
 	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
+	u32 tag;
 	struct srp_rdma_ch *ch;
 	int ret;
 
@@ -2417,7 +2417,8 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	ch = &target->ch;
 	if (!req || !srp_claim_req(ch, req, NULL, scmnd))
 		return SUCCESS;
-	if (srp_send_tsk_mgmt(ch, req->index, scmnd->device->lun,
+	tag = blk_mq_unique_tag(scmnd->request);
+	if (srp_send_tsk_mgmt(ch, tag, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK) == 0)
 		ret = SUCCESS;
 	else if (target->rport->state == SRP_RPORT_LOST)
@@ -2463,6 +2464,15 @@ static int srp_reset_host(struct scsi_cmnd *scmnd)
 	return srp_reconnect_rport(target->rport) == 0 ? SUCCESS : FAILED;
 }
 
+static int srp_slave_alloc(struct scsi_device *sdev)
+{
+	sdev->tagged_supported = 1;
+
+	scsi_activate_tcq(sdev, sdev->queue_depth);
+
+	return 0;
+}
+
 static int srp_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -2641,6 +2651,7 @@ static struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
+	.slave_alloc			= srp_slave_alloc,
 	.slave_configure		= srp_slave_configure,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
@@ -3076,6 +3087,10 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err;
 
+	ret = scsi_init_shared_tag_map(target_host, target_host->can_queue);
+	if (ret)
+		goto err;
+
 	target->req_ring_size = target->queue_size - SRP_TSK_MGMT_SQ_SIZE;
 
 	if (!srp_conn_unique(target->srp_host, target)) {
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 74530d9..37aa9f4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -116,7 +116,6 @@ struct srp_host {
 };
 
 struct srp_request {
-	struct list_head	list;
 	struct scsi_cmnd       *scmnd;
 	struct srp_iu	       *cmd;
 	union {
@@ -127,7 +126,6 @@ struct srp_request {
 	struct srp_direct_buf  *indirect_desc;
 	dma_addr_t		indirect_dma_addr;
 	short			nmdesc;
-	short			index;
 };
 
 /**
@@ -137,7 +135,6 @@ struct srp_request {
 struct srp_rdma_ch {
 	/* These are RW in the hot path, and commonly used together */
 	struct list_head	free_tx;
-	struct list_head	free_reqs;
 	spinlock_t		lock;
 	s32			req_lim;
 
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
