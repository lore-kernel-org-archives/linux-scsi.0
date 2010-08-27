From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Fri, 27 Aug 2010 10:43:46 +0900
Message-ID: <4C771852.3050500@ce.jp.nec.com>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de> <20100803185148.GA12258@lst.de> <4C58F341.9060605@ct.jp.nec.com> <20100804085423.GA15687@lst.de> <4C5A1F05.40308@ce.jp.nec.com> <20100826225024.GB17832@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100826225024.GB17832@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, tj@kernel.org, tytso@mit.edu, swhiteho@redhat.com, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi Mike,

(08/27/10 07:50), Mike Snitzer wrote:
>> Special casing is necessary because device-mapper may have to
>> send multiple copies of REQ_FLUSH request to multiple
>> targets, while normal request is just sent to single target.
> 
> Yes, request-based DM is meant to have all the same capabilities as
> bio-based DM.  So in theory it should support multiple targets but in
> practice it doesn't.  DM's multipath target is the only consumer of
> request-based DM and it only ever clones a single flush request
> (num_flush_requests = 1).

This is correct. But,

> So why not remove all of request-based DM's barrier infrastructure and
> simply rely on the revised block layer to sequence the FLUSH+WRITE
> request for request-based DM?
> 
> Given that we do not have a request-based DM target that requires
> cloning multiple FLUSH requests its unused code that is delaying DM
> support for the new FLUSH+FUA work (NOTE: bio-based DM obviously still
> needs work in this area).

the above mentioned 'special casing' is not a hard part.
See the attached patch.

The hard part is discerning the error type for flush failure
as discussed in the other thread.
And as Kiyoshi wrote, that's an existing problem so it can
be worked on as a separate issue than the new FLUSH work.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation


Cope with new sequencing of flush requests in the block layer.

Request-based dm used to depend on the barrier sequencer in the block layer
in that, when a flush request is dispatched, there are no other requests
in-flight. So it reused md->pending counter for checking completion of
cloned flush requests.

This patch separates the pending counter for flush request
as a prepartion for the new FLUSH work, where a flush request can be
dispatched while other normal requests are in-flight.

Index: linux-2.6.36-rc2/drivers/md/dm.c
===================================================================
--- linux-2.6.36-rc2.orig/drivers/md/dm.c
+++ linux-2.6.36-rc2/drivers/md/dm.c
@@ -162,6 +162,7 @@ struct mapped_device {
 
 	/* A pointer to the currently processing pre/post flush request */
 	struct request *flush_request;
+	atomic_t flush_pending;
 
 	/*
 	 * The current mapping.
@@ -777,10 +778,16 @@ static void store_barrier_error(struct m
  * the md may be freed in dm_put() at the end of this function.
  * Or do dm_get() before calling this function and dm_put() later.
  */
-static void rq_completed(struct mapped_device *md, int rw, int run_queue)
+static void rq_completed(struct mapped_device *md, int rw, int run_queue, bool is_flush)
 {
 	atomic_dec(&md->pending[rw]);
 
+	if (is_flush) {
+		atomic_dec(&md->flush_pending);
+		if (!atomic_read(&md->flush_pending))
+			wake_up(&md->wait);
+	}
+
 	/* nudge anyone waiting on suspend queue */
 	if (!md_in_flight(md))
 		wake_up(&md->wait);
@@ -837,7 +844,7 @@ static void dm_end_request(struct reques
 	} else
 		blk_end_request_all(rq, error);
 
-	rq_completed(md, rw, run_queue);
+	rq_completed(md, rw, run_queue, is_barrier);
 }
 
 static void dm_unprep_request(struct request *rq)
@@ -880,7 +887,7 @@ void dm_requeue_unmapped_request(struct 
 	blk_requeue_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	rq_completed(md, rw, 0);
+	rq_completed(md, rw, 0, false);
 }
 EXPORT_SYMBOL_GPL(dm_requeue_unmapped_request);
 
@@ -1993,6 +2000,7 @@ static struct mapped_device *alloc_dev(i
 
 	atomic_set(&md->pending[0], 0);
 	atomic_set(&md->pending[1], 0);
+	atomic_set(&md->flush_pending, 0);
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	INIT_WORK(&md->barrier_work, dm_rq_barrier_work);
@@ -2375,7 +2383,7 @@ void dm_put(struct mapped_device *md)
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
-static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
+static int dm_wait_for_completion(struct mapped_device *md, int interruptible, bool for_flush)
 {
 	int r = 0;
 	DECLARE_WAITQUEUE(wait, current);
@@ -2388,6 +2396,8 @@ static int dm_wait_for_completion(struct
 		set_current_state(interruptible);
 
 		smp_mb();
+		if (for_flush && !atomic_read(&md->flush_pending))
+			break;
 		if (!md_in_flight(md))
 			break;
 
@@ -2408,14 +2418,14 @@ static int dm_wait_for_completion(struct
 
 static void dm_flush(struct mapped_device *md)
 {
-	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
+	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE, false);
 
 	bio_init(&md->barrier_bio);
 	md->barrier_bio.bi_bdev = md->bdev;
 	md->barrier_bio.bi_rw = WRITE_BARRIER;
 	__split_and_process_bio(md, &md->barrier_bio);
 
-	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
+	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE, false);
 }
 
 static void process_barrier(struct mapped_device *md, struct bio *bio)
@@ -2512,11 +2522,12 @@ static int dm_rq_barrier(struct mapped_d
 			clone = clone_rq(md->flush_request, md, GFP_NOIO);
 			dm_rq_set_target_request_nr(clone, j);
 			atomic_inc(&md->pending[rq_data_dir(clone)]);
+			atomic_inc(&md->flush_pending);
 			map_request(ti, clone, md);
 		}
 	}
 
-	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
+	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE, true);
 	dm_table_put(map);
 
 	return md->barrier_error;
@@ -2705,7 +2716,7 @@ int dm_suspend(struct mapped_device *md,
 	 * We call dm_wait_for_completion to wait for all existing requests
 	 * to finish.
 	 */
-	r = dm_wait_for_completion(md, TASK_INTERRUPTIBLE);
+	r = dm_wait_for_completion(md, TASK_INTERRUPTIBLE, false);
 
 	down_write(&md->io_lock);
 	if (noflush)
