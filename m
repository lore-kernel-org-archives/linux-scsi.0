From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 11/12] IB/srp: Eliminate free_reqs list
Date: Tue, 07 Oct 2014 15:06:54 +0200
Message-ID: <5433E56E.6010600@acm.org>
References: <5433E43D.3010107@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5433E43D.3010107-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The free_reqs list is no longer needed now that we are using
tags assigned by the block layer. Hence remove it.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 24 +++++++++---------------
 drivers/infiniband/ulp/srp/ib_srp.h |  1 -
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 224ef25..eccaf65 100644
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
@@ -853,7 +851,6 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 			goto out;
 
 		req->indirect_dma_addr = dma_addr;
-		list_add_tail(&req->list, &ch->free_reqs);
 	}
 	ret = 0;
 
@@ -1075,7 +1072,6 @@ static void srp_free_req(struct srp_rdma_ch *ch, struct srp_request *req,
 
 	spin_lock_irqsave(&ch->lock, flags);
 	ch->req_lim += req_lim_delta;
-	list_add_tail(&req->list, &ch->free_reqs);
 	spin_unlock_irqrestore(&ch->lock, flags);
 }
 
@@ -1892,6 +1888,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	struct ib_device *dev;
 	unsigned long flags;
 	u32 tag;
+	u16 idx;
 	int len, ret;
 	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
 
@@ -1910,16 +1907,19 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	tag = blk_mq_unique_tag(scmnd->request);
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
@@ -1980,12 +1980,6 @@ err_iu:
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
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 75e8f36..bb185d4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -136,7 +136,6 @@ struct srp_request {
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
