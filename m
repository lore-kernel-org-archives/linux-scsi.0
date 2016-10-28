From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 11/12] nvme: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Fri, 28 Oct 2016 11:51:35 -0700
Message-ID: <655c62ca-5da8-3c8f-9e56-016b7d518267@sandisk.com>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <805e1911-cd10-0563-c76b-256d76054b08@sandisk.com>
 <20161028160145.GC5621@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------FF0AC109AC1DF013EC67AEAD"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161028160145.GC5621@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

--------------FF0AC109AC1DF013EC67AEAD
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/2016 08:51 AM, Keith Busch wrote:
> On Wed, Oct 26, 2016 at 03:56:04PM -0700, Bart Van Assche wrote:
>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>> index 7bb73ba..b662416 100644
>> --- a/drivers/nvme/host/core.c
>> +++ b/drivers/nvme/host/core.c
>> @@ -205,7 +205,7 @@ void nvme_requeue_req(struct request *req)
>>
>>  	blk_mq_requeue_request(req, false);
>>  	spin_lock_irqsave(req->q->queue_lock, flags);
>> -	if (!blk_queue_stopped(req->q))
>> +	if (!blk_mq_queue_stopped(req->q))
>>  		blk_mq_kick_requeue_list(req->q);
>>  	spin_unlock_irqrestore(req->q->queue_lock, flags);
>>  }
>> @@ -2079,10 +2079,6 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
>>
>>  	mutex_lock(&ctrl->namespaces_mutex);
>>  	list_for_each_entry(ns, &ctrl->namespaces, list) {
>> -		spin_lock_irq(ns->queue->queue_lock);
>> -		queue_flag_set(QUEUE_FLAG_STOPPED, ns->queue);
>> -		spin_unlock_irq(ns->queue->queue_lock);
>> -
>>  		blk_mq_cancel_requeue_work(ns->queue);
>>  		blk_mq_stop_hw_queues(ns->queue);
>
> There's actually a reason the queue stoppage is using a different flag
> than blk_mq_queue_stopped: kicking the queue starts stopped queues.
> The driver has to ensure the requeue work can't be kicked prior to
> cancelling the current requeue work. Once we know requeue work isn't
> running and can't restart again, then we're safe to stop the hw queues.
>
> It's a pretty obscure condition, requiring the controller post an
> error completion at the same time the driver decides to reset the
> controller. Here's the sequence with the wrong outcome:
>
>  CPU A                   CPU B
>  -----                   -----
> nvme_stop_queues         nvme_requeue_req
>  blk_mq_stop_hw_queues    if (blk_mq_queue_stopped) <- returns false
>   blk_mq_stop_hw_queue     blk_mq_kick_requeue_list
>                          blk_mq_requeue_work
>                           blk_mq_start_hw_queues

Hello Keith,

I think it is wrong that kicking the requeue list starts stopped queues 
because this makes it impossible to stop request processing without 
setting an additional flag next to BLK_MQ_S_STOPPED. Can you have a look 
at the attached two patches? These patches survive my dm-multipath and 
SCSI tests.

Thanks,

Bart.



--------------FF0AC109AC1DF013EC67AEAD
Content-Type: text/x-patch;
	name="0001-block-Avoid-that-requeueing-starts-stopped-queues.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-block-Avoid-that-requeueing-starts-stopped-queues.patch"

>From e93799f726485a3eeee98837c992c5c0068d7180 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Fri, 28 Oct 2016 10:48:58 -0700
Subject: [PATCH 1/2] block: Avoid that requeueing starts stopped queues

Since blk_mq_requeue_work() starts stopped queues and since
execution of this function can be scheduled after a queue has
been stopped it is not possible to stop queues without using
an additional state variable to track whether or not the queue
has been stopped. Hence modify blk_mq_requeue_work() such that it
does not start stopped queues. My conclusion after a review of
the blk_mq_stop_hw_queues() and blk_mq_{delay_,}kick_requeue_list()
callers is as follows:
* In the dm driver starting and stopping queues should only happen
  if __dm_suspend() or __dm_resume() is called and not if the
  requeue list is processed.
* In the SCSI core queue stopping and starting should only be
  performed by the scsi_internal_device_block() and
  scsi_internal_device_unblock() functions but not by any other
  function.
* In the NVMe core only the functions that call
  blk_mq_start_stopped_hw_queues() explicitly should start stopped
  queues.
* A blk_mq_start_stopped_hwqueues() call must be added in the
  xen-blkfront driver in its blkif_recover() function.
---
 block/blk-mq.c               | 6 +-----
 drivers/block/xen-blkfront.c | 1 +
 drivers/md/dm-rq.c           | 7 +------
 drivers/scsi/scsi_lib.c      | 1 -
 4 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a49b8af..24dfd0d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -528,11 +528,7 @@ static void blk_mq_requeue_work(struct work_struct *work)
 		blk_mq_insert_request(rq, false, false, false);
 	}
 
-	/*
-	 * Use the start variant of queue running here, so that running
-	 * the requeue work will kick stopped queues.
-	 */
-	blk_mq_start_hw_queues(q);
+	blk_mq_run_hw_queues(q, false);
 }
 
 void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 1ca702d..a3e1727 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2045,6 +2045,7 @@ static int blkif_recover(struct blkfront_info *info)
 		BUG_ON(req->nr_phys_segments > segs);
 		blk_mq_requeue_request(req, false);
 	}
+	blk_mq_start_stopped_hwqueues(info->rq);
 	blk_mq_kick_requeue_list(info->rq);
 
 	while ((bio = bio_list_pop(&info->bio_list)) != NULL) {
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 107ed19..b951ae83 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -326,12 +326,7 @@ static void dm_old_requeue_request(struct request *rq)
 
 static void __dm_mq_kick_requeue_list(struct request_queue *q, unsigned long msecs)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (!blk_mq_queue_stopped(q))
-		blk_mq_delay_kick_requeue_list(q, msecs);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	blk_mq_delay_kick_requeue_list(q, msecs);
 }
 
 void dm_mq_kick_requeue_list(struct mapped_device *md)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4cddaff..94f54ac 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1939,7 +1939,6 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 out:
 	switch (ret) {
 	case BLK_MQ_RQ_QUEUE_BUSY:
-		blk_mq_stop_hw_queue(hctx);
 		if (atomic_read(&sdev->device_busy) == 0 &&
 		    !scsi_device_blocked(sdev))
 			blk_mq_delay_queue(hctx, SCSI_QUEUE_DELAY);
-- 
2.10.1


--------------FF0AC109AC1DF013EC67AEAD
Content-Type: text/x-patch;
	name="0002-blk-mq-Remove-blk_mq_cancel_requeue_work.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0002-blk-mq-Remove-blk_mq_cancel_requeue_work.patch"

>From 47eec3bdcf4b673e3ab606543cb3acdf7f4de593 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Fri, 28 Oct 2016 10:50:04 -0700
Subject: [PATCH 2/2] blk-mq: Remove blk_mq_cancel_requeue_work()

Since blk_mq_requeue_work() no longer restarts stopped queues
canceling requeue work is no longer needed to prevent that a
stopped queue would be restarted. Hence remove this function.
---
 block/blk-mq.c           | 6 ------
 drivers/md/dm-rq.c       | 2 --
 drivers/nvme/host/core.c | 1 -
 include/linux/blk-mq.h   | 1 -
 4 files changed, 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 24dfd0d..1aa79e5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -557,12 +557,6 @@ void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
 }
 EXPORT_SYMBOL(blk_mq_add_to_requeue_list);
 
-void blk_mq_cancel_requeue_work(struct request_queue *q)
-{
-	cancel_delayed_work_sync(&q->requeue_work);
-}
-EXPORT_SYMBOL_GPL(blk_mq_cancel_requeue_work);
-
 void blk_mq_kick_requeue_list(struct request_queue *q)
 {
 	kblockd_schedule_delayed_work(&q->requeue_work, 0);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index b951ae83..7f426ab 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -102,8 +102,6 @@ static void dm_mq_stop_queue(struct request_queue *q)
 	if (blk_mq_queue_stopped(q))
 		return;
 
-	/* Avoid that requeuing could restart the queue. */
-	blk_mq_cancel_requeue_work(q);
 	blk_mq_stop_hw_queues(q);
 	/* Wait until dm_mq_queue_rq() has finished. */
 	blk_mq_quiesce_queue(q);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d6ab9a0..a67e815 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2075,7 +2075,6 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
 		struct request_queue *q = ns->queue;
 
-		blk_mq_cancel_requeue_work(q);
 		blk_mq_stop_hw_queues(q);
 		blk_mq_quiesce_queue(q);
 	}
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 76f6319..35a0af5 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -221,7 +221,6 @@ void __blk_mq_end_request(struct request *rq, int error);
 void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list);
 void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
 				bool kick_requeue_list);
-void blk_mq_cancel_requeue_work(struct request_queue *q);
 void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
 void blk_mq_abort_requeue_list(struct request_queue *q);
-- 
2.10.1


--------------FF0AC109AC1DF013EC67AEAD--
