From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v3 0/11] Fix race conditions related to stopping block
 layer queues
Date: Thu, 20 Oct 2016 10:52:24 -0400
Message-ID: <20161020145224.GA2771@localhost.localdomain>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
 <20161019222454.GA1215@localhost.localdomain>
 <25418d7a-7e66-3b99-7532-669f7ebd58a6@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <25418d7a-7e66-3b99-7532-669f7ebd58a6@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 19, 2016 at 04:51:18PM -0700, Bart Van Assche wrote:
> 
> I assume that line 498 in blk-mq.c corresponds to BUG_ON(blk_queued_rq(rq))?
> Anyway, it seems to me like this is a bug in the NVMe code and also that
> this bug is completely unrelated to my patch series. In nvme_complete_rq() I
> see that blk_mq_requeue_request() is called. I don't think this is allowed
> from the context of nvme_cancel_request() because blk_mq_requeue_request()
> assumes that a request has already been removed from the request list.
> However, neither blk_mq_tagset_busy_iter() nor nvme_cancel_request() remove
> a request from the request list before nvme_complete_rq() is called. I think
> this is what triggers the BUG_ON() statement in blk_mq_requeue_request().
> Have you noticed that e.g. the scsi-mq code only calls
> blk_mq_requeue_request() after __blk_mq_end_request() has finished? Have you
> considered to follow the same approach in nvme_cancel_request()?

Both nvme and scsi requeue through their mp_ops 'complete' callback, so
nvme is similarly waiting for __blk_mq_end_request before requesting to
requeue. The problem, I think, is nvme's IO cancelling path is observing
active requests that it's requeuing from the queue_rq path.

Patch [11/11] kicks the requeue list unconditionally. This restarts queues
the driver had just quiesced a moment before, restarting those requests,
but the driver isn't ready to handle them. When the driver ultimately
unbinds from the device, it requeues those requests a second time.

Either the requeuing can't kick the requeue work when queisced, or the
shutdown needs to quiesce even when it hasn't restarted the queues.
Either patch below appears to fix the issue.

---
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ccd9cc5..078530c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -201,7 +201,7 @@ static struct nvme_ns *nvme_get_ns_from_disk(struct gendisk *disk)
 
 void nvme_requeue_req(struct request *req)
 {
-	blk_mq_requeue_request(req, true);
+	blk_mq_requeue_request(req, !blk_mq_queue_stopped(req->q));
 }
 EXPORT_SYMBOL_GPL(nvme_requeue_req);
--

--- 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4b30fa2..a05da98 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1681,10 +1681,9 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 	del_timer_sync(&dev->watchdog_timer);
 
 	mutex_lock(&dev->shutdown_lock);
-	if (pci_is_enabled(to_pci_dev(dev->dev))) {
-		nvme_stop_queues(&dev->ctrl);
+	nvme_stop_queues(&dev->ctrl);
+	if (pci_is_enabled(to_pci_dev(dev->dev)))
 		csts = readl(dev->bar + NVME_REG_CSTS);
-	}
 
 	queues = dev->online_queues - 1;
 	for (i = dev->queue_count - 1; i > 0; i--)
--
