From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC 0/5] block large commands support continue
Date: Thu, 24 Apr 2008 15:19:33 +0900
Message-ID: <20080424151925A.tomof@acm.org>
References: <480F4CC2.7070804@panasas.com>
	<20080424133118Q.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080424133118Q.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: bharrosh@panasas.com, jens.axboe@oracle.com, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, pw@osc.edu, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 24 Apr 2008 13:31:21 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Wed, 23 Apr 2008 17:50:42 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > 
> > The support for large commands was dropped from the for-2.6.26 branch
> > and will probably not get accepted into next kernel.
> > 
> > I have tried to take all comments from Jens and Bart. and incorporate
> > it into a new patchset. This is basically Tomo's patchset but with
> > proposed changes.
> 
> Have you seen the patchset to remove request on the stack?
> 
> http://marc.info/?l=linux-ide&m=120882410712466&w=2
> 
> 
> > They are based on current linux-block/master. They will probably conflict with
> > latest patch sent by Tomo for the blk_get_request(). Once those patches
> > get accepted at some git tree, (Where will that be?), I will rebase these
> > on top of them. Please CC me of any progress.
> > 
> > [PATCH 1/5] block: no need to initialize rq->cmd
> >   This is 2 of Tomo's patches squashed together as they are
> >   small and do the same. Tomo is this OK?
> > 
> > [PATCH 2/5] block: replace sizeof(rq->cmd) with BLK_MAX_CDB
> >   Tomos patch rebased to here
> > 
> > [PATCH 3/5] block: Export rq_init, rename to blk_init_rq
> > [PATCH 4/5] block: Use new blk_init_rq
> >   These patches are basically what Jens and Bart has suggested, that with
> >   a small code change to blk-core.c we can memset at rq_init() and only set
> >   none zero members. We can also export that initializer and use it all over
> >   the ide tree where ever requests don't come from a request queue. (OK also
> >   at scsi_error.c)
> 
> +void blk_init_rq(struct request_queue *q, struct request *rq, int cmd_flags)
> 
> Hmm, would it be better to modify the block layer to let rq_init just
> memset() the request structure?

I think, if we move rq_init to blk_alloc_request from get_request,
rq_init can just memset() the structure.

Then we can export rq_init and rq_init works for everyone.


diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 55c5f1f..722140a 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -143,10 +143,8 @@ static void queue_flush(struct request_queue *q, unsigned which)
 		end_io = post_flush_end_io;
 	}
 
-	rq->cmd_flags = REQ_HARDBARRIER;
 	rq_init(q, rq);
-	rq->elevator_private = NULL;
-	rq->elevator_private2 = NULL;
+	rq->cmd_flags = REQ_HARDBARRIER;
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
 	q->prepare_flush_fn(q, rq);
@@ -167,14 +165,11 @@ static inline struct request *start_ordered(struct request_queue *q,
 	blkdev_dequeue_request(rq);
 	q->orig_bar_rq = rq;
 	rq = &q->bar_rq;
-	rq->cmd_flags = 0;
 	rq_init(q, rq);
 	if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
 		rq->cmd_flags |= REQ_RW;
 	if (q->ordered & QUEUE_ORDERED_FUA)
 		rq->cmd_flags |= REQ_FUA;
-	rq->elevator_private = NULL;
-	rq->elevator_private2 = NULL;
 	init_request_from_bio(rq, q->orig_bar_rq->bio);
 	rq->end_io = bar_end_io;
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 2a438a9..e447799 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -107,40 +107,18 @@ struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev)
 }
 EXPORT_SYMBOL(blk_get_backing_dev_info);
 
-/*
- * We can't just memset() the structure, since the allocation path
- * already stored some information in the request.
- */
 void rq_init(struct request_queue *q, struct request *rq)
 {
+	memset(rq, 0, sizeof(*rq));
+
 	INIT_LIST_HEAD(&rq->queuelist);
 	INIT_LIST_HEAD(&rq->donelist);
 	rq->q = q;
 	rq->sector = rq->hard_sector = (sector_t) -1;
-	rq->nr_sectors = rq->hard_nr_sectors = 0;
-	rq->current_nr_sectors = rq->hard_cur_sectors = 0;
-	rq->bio = rq->biotail = NULL;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
-	rq->rq_disk = NULL;
-	rq->nr_phys_segments = 0;
-	rq->nr_hw_segments = 0;
-	rq->ioprio = 0;
-	rq->special = NULL;
-	rq->buffer = NULL;
 	rq->tag = -1;
-	rq->errors = 0;
 	rq->ref_count = 1;
-	rq->cmd_len = 0;
-	memset(rq->cmd, 0, sizeof(rq->cmd));
-	rq->data_len = 0;
-	rq->extra_len = 0;
-	rq->sense_len = 0;
-	rq->data = NULL;
-	rq->sense = NULL;
-	rq->end_io = NULL;
-	rq->end_io_data = NULL;
-	rq->next_rq = NULL;
 }
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
@@ -607,6 +585,8 @@ blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask)
 	if (!rq)
 		return NULL;
 
+	rq_init(q, rq);
+
 	/*
 	 * first three bits are identical in rq->cmd_flags and bio->bi_rw,
 	 * see bio.h and blkdev.h
@@ -789,8 +769,6 @@ rq_starved:
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 
-	rq_init(q, rq);
-
 	blk_add_trace_generic(q, bio, rw, BLK_TA_GETRQ);
 out:
 	return rq;
