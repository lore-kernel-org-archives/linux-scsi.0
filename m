From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH] Flush only barriers (Was: Re: [RFC] relaxed barrier
 semantics)
Date: Mon, 2 Aug 2010 14:28:04 -0400
Message-ID: <20100802182804.GD19740@redhat.com>
References: <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <20100729024334.GA21736@redhat.com>
 <20100729084225.GA30446@lst.de>
 <20100729200217.GD28704@redhat.com>
 <20100729200655.GB17767@lst.de>
 <20100730031721.GA31762@redhat.com>
 <20100730070732.GA6291@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab0HBS21 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2010 14:28:27 -0400
Content-Disposition: inline
In-Reply-To: <20100730070732.GA6291@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Fri, Jul 30, 2010 at 09:07:32AM +0200, Christoph Hellwig wrote:
> On Thu, Jul 29, 2010 at 11:17:21PM -0400, Vivek Goyal wrote:
> > To me it looked like as if everything is there and it is just a matter
> > of skipping elevator draining and request queue draining.
> 
> The problem is that is just appears to be so.  The code blocking only
> the next barrier for tagged writes is there, but in that form it doesn't
> work and probably never did.  When I try to use it and debug it I always
> get my post-flush request issued before the barrier request has
> finished.

Hi Christoph,

Please find attached a new version of patch where I am trying to implement
flush only barriers. Why do that? I was thinking that it would nice to avoid
elevator drains with WCE=1.

Here I have a DRAIN queue and I seem to be issuing post-flush only after
barrier has finished. Need to find some device with TAG queue also to test.

This is still a very crude patch where I need to do lot of testing to see if
things are working. For the time being I have just hooked up ext3 to use
flush barrier and verified that in case of WCE=0 we don't issue barrier
and in case of WCE=1 we do issue barrier with pre flush and postflush.

I don't yet have found a device with FUA and tagging support to verify 
that functionality.

I looked at your BH_ordered kill patch. For the time being I have
introduced another flag BH_Flush_Ordered along the lines of BH_Ordered.
But it can be easily replaced once your kill patch is in.

Thanks
Vivek


o Implement flush only barriers. These do not implement any drain semantics.
  File system needs to wait for completion of all the dependent IO.

o On storage with no write cache, these barriers should just do nothing.
  Empty barrier request returns immediately and a write request with
  barrier is processed as normal request. No drains, no flushing.

o On storage with write cache, for empty barrier, only pre-flush is done.
  For barrier request with some data one of following should happen depending
  on queue capability.

	Draining queue
	--------------
	preflush ==> barrier (FUA)
	preflush ==> barrier ===> postflush
	
	Ordered Queue
	-------------
	preflush-->barrier (FUA)
	preflush --> barrier ---> postflush

	===> Wait for previous request to finish
	---> Issue an ordered request in Tagged queue.

o For write cache enabled case, we are not completely drain free.

  - I don't try to drain request queue for dispatching pre flush request.

  - But after dispatching pre flush, I wait for it to finish before actual
    barrier request goes in. So if controller re-orders the pre-flush and
    executes it ahead of other request, full draining will be avoided
    otherwise it will take place.

  - Similarly post-flush will wait for previous barrier request to finish
    and this will ultimately lead to draining the queue if drive is not
    re-ordering the requests.

  - So what did we gain by this patch in case of WCE=1. I think primarily
    we avoided elevator draining which can be useful for IO controller
    where we provide service differentation in elevator.

  - Not sure how to avoid this drain. Trying to allow other non-barrier
    requests to dispatch while we wait for pre-flush/flush barrier to finish
    will make code more complicated.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Makefile                    |    2 -
 block/blk-barrier.c         |   67 ++++++++++++++++++++++++++++++++++++++++----
 block/blk-core.c            |    9 +++--
 block/elevator.c            |    9 +++--
 fs/buffer.c                 |    3 +
 fs/ext3/fsync.c             |    2 -
 fs/jbd/commit.c             |    2 -
 include/linux/bio.h         |    7 +++-
 include/linux/blkdev.h      |    9 ++++-
 include/linux/buffer_head.h |    3 +
 include/linux/fs.h          |    1 
 kernel/trace/blktrace.c     |    2 -
 12 files changed, 97 insertions(+), 19 deletions(-)

Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2010-08-02 13:17:35.000000000 -0400
+++ linux-2.6/include/linux/blkdev.h	2010-08-02 14:01:17.000000000 -0400
@@ -97,6 +97,7 @@ enum rq_flag_bits {
 	__REQ_SORTED,		/* elevator knows about this request */
 	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
 	__REQ_HARDBARRIER,	/* may not be passed by drive either */
+	__REQ_FLUSHBARRIER,	/* only flush barrier. no drains required  */
 	__REQ_FUA,		/* forced unit access */
 	__REQ_NOMERGE,		/* don't touch this for merging */
 	__REQ_STARTED,		/* drive already may have started this one */
@@ -126,6 +127,7 @@ enum rq_flag_bits {
 #define REQ_SORTED	(1 << __REQ_SORTED)
 #define REQ_SOFTBARRIER	(1 << __REQ_SOFTBARRIER)
 #define REQ_HARDBARRIER	(1 << __REQ_HARDBARRIER)
+#define REQ_FLUSHBARRIER	(1 << __REQ_FLUSHBARRIER)
 #define REQ_FUA		(1 << __REQ_FUA)
 #define REQ_NOMERGE	(1 << __REQ_NOMERGE)
 #define REQ_STARTED	(1 << __REQ_STARTED)
@@ -625,7 +627,8 @@ enum {
 
 #define blk_rq_cpu_valid(rq)	((rq)->cpu != -1)
 #define blk_sorted_rq(rq)	((rq)->cmd_flags & REQ_SORTED)
-#define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
+#define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER || (rq)->cmd_flags & REQ_FLUSHBARRIER)
+#define blk_flush_barrier_rq(rq)	((rq)->cmd_flags & REQ_FLUSHBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
 #define blk_discard_rq(rq)	((rq)->cmd_flags & REQ_DISCARD)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
@@ -681,7 +684,7 @@ static inline void blk_clear_queue_full(
  * it already be started by driver.
  */
 #define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER)
+	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER | REQ_FLUSHBARRIER)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
 	 (blk_discard_rq(rq) || blk_fs_request((rq))))
@@ -1006,9 +1009,11 @@ static inline struct request *blk_map_qu
 enum{
 	BLKDEV_WAIT,	/* wait for completion */
 	BLKDEV_BARRIER,	/*issue request with barrier */
+	BLKDEV_FLUSHBARRIER,	/*issue request with flush barrier. no drains */
 };
 #define BLKDEV_IFL_WAIT		(1 << BLKDEV_WAIT)
 #define BLKDEV_IFL_BARRIER	(1 << BLKDEV_BARRIER)
+#define BLKDEV_IFL_FLUSHBARRIER	(1 << BLKDEV_FLUSHBARRIER)
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
 			unsigned long);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2010-08-02 13:17:35.000000000 -0400
+++ linux-2.6/block/blk-barrier.c	2010-08-02 14:01:17.000000000 -0400
@@ -129,7 +129,7 @@ static void post_flush_end_io(struct req
 	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_POSTFLUSH, error);
 }
 
-static void queue_flush(struct request_queue *q, unsigned which)
+static void queue_flush(struct request_queue *q, unsigned which, bool ordered)
 {
 	struct request *rq;
 	rq_end_io_fn *end_io;
@@ -143,7 +143,17 @@ static void queue_flush(struct request_q
 	}
 
 	blk_rq_init(q, rq);
-	rq->cmd_flags = REQ_HARDBARRIER;
+
+	/*
+	 * Does this flush request has to be ordered? In case of FLUSHBARRIERS
+	 * we don't need PREFLUSH to be ordered. POSTFLUSH needs to be ordered
+	 * if device does not support FUA.
+	 */
+	if (ordered)
+		rq->cmd_flags = REQ_HARDBARRIER;
+	else
+		rq->cmd_flags = REQ_FLUSHBARRIER;
+
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
 	q->prepare_flush_fn(q, rq);
@@ -192,7 +202,7 @@ static inline bool start_ordered(struct 
 	 * request gets inbetween ordered sequence.
 	 */
 	if (q->ordered & QUEUE_ORDERED_DO_POSTFLUSH) {
-		queue_flush(q, QUEUE_ORDERED_DO_POSTFLUSH);
+		queue_flush(q, QUEUE_ORDERED_DO_POSTFLUSH, 1);
 		rq = &q->post_flush_rq;
 	} else
 		skip |= QUEUE_ORDSEQ_POSTFLUSH;
@@ -207,6 +217,17 @@ static inline bool start_ordered(struct 
 		if (q->ordered & QUEUE_ORDERED_DO_FUA)
 			rq->cmd_flags |= REQ_FUA;
 		init_request_from_bio(rq, q->orig_bar_rq->bio);
+
+		/*
+		 * For flush barriers, we want these to be ordered w.r.t
+		 * preflush hence mark them as HARDBARRIER here.
+		 *
+		 * Note: init_request_from_bio() call above will mark it
+		 * as FLUSHBARRIER
+		 */
+		if (blk_flush_barrier_rq(q->orig_bar_rq))
+			rq->cmd_flags |= REQ_HARDBARRIER;
+
 		rq->end_io = bar_end_io;
 
 		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
@@ -214,12 +235,21 @@ static inline bool start_ordered(struct 
 		skip |= QUEUE_ORDSEQ_BAR;
 
 	if (q->ordered & QUEUE_ORDERED_DO_PREFLUSH) {
-		queue_flush(q, QUEUE_ORDERED_DO_PREFLUSH);
+		/*
+		 * For flush only barrier, we don't care to order preflush
+		 * request w.r.t other requests in the controller queue.
+		 */
+		if (blk_flush_barrier_rq(q->orig_bar_rq))
+			queue_flush(q, QUEUE_ORDERED_DO_PREFLUSH, 0);
+		else
+			queue_flush(q, QUEUE_ORDERED_DO_PREFLUSH, 1);
+
 		rq = &q->pre_flush_rq;
 	} else
 		skip |= QUEUE_ORDSEQ_PREFLUSH;
 
-	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && queue_in_flight(q))
+	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && queue_in_flight(q)
+	    && !blk_flush_barrier_rq(q->orig_bar_rq))
 		rq = NULL;
 	else
 		skip |= QUEUE_ORDSEQ_DRAIN;
@@ -241,6 +271,29 @@ bool blk_do_ordered(struct request_queue
 	if (!q->ordseq) {
 		if (!is_barrier)
 			return true;
+		/*
+		 * For flush only barriers, nothing has to be done if there is
+		 * no caching happening on the deice. The barrier request is
+		 * still has to be written to disk but it can written as
+		 * normal rq.
+		 */
+
+		if (blk_flush_barrier_rq(rq)
+		    && (q->ordered == QUEUE_ORDERED_DRAIN
+		        || q->ordered == QUEUE_ORDERED_TAG)) {
+			if (!blk_rq_sectors(rq)) {
+				/*
+				 * Empty barrier. Device is write through.
+				 * Nothing has to be done. Return success.
+				 */
+				blk_dequeue_request(rq);
+				__blk_end_request_all(rq, 0);
+				*rqp = NULL;
+				return false;
+			} else
+				/* Process as normal rq. */
+				return true;
+		}
 
 		if (q->next_ordered != QUEUE_ORDERED_NONE)
 			return start_ordered(q, rqp);
@@ -311,6 +364,8 @@ int blkdev_issue_flush(struct block_devi
 	struct request_queue *q;
 	struct bio *bio;
 	int ret = 0;
+	int type = flags & BLKDEV_IFL_FLUSHBARRIER ? WRITE_FLUSHBARRIER
+				: WRITE_BARRIER;
 
 	if (bdev->bd_disk == NULL)
 		return -ENXIO;
@@ -326,7 +381,7 @@ int blkdev_issue_flush(struct block_devi
 		bio->bi_private = &wait;
 
 	bio_get(bio);
-	submit_bio(WRITE_BARRIER, bio);
+	submit_bio(type, bio);
 	if (test_bit(BLKDEV_WAIT, &flags)) {
 		wait_for_completion(&wait);
 		/*
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c	2010-08-02 13:17:35.000000000 -0400
+++ linux-2.6/block/elevator.c	2010-08-02 13:19:02.000000000 -0400
@@ -424,7 +424,8 @@ void elv_dispatch_sort(struct request_qu
 	q->nr_sorted--;
 
 	boundary = q->end_sector;
-	stop_flags = REQ_SOFTBARRIER | REQ_HARDBARRIER | REQ_STARTED;
+	stop_flags = REQ_SOFTBARRIER | REQ_HARDBARRIER | REQ_STARTED
+			| REQ_FLUSHBARRIER;
 	list_for_each_prev(entry, &q->queue_head) {
 		struct request *pos = list_entry_rq(entry);
 
@@ -628,7 +629,8 @@ void elv_insert(struct request_queue *q,
 
 	case ELEVATOR_INSERT_BACK:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
-		elv_drain_elevator(q);
+		if (!blk_flush_barrier_rq(rq))
+			elv_drain_elevator(q);
 		list_add_tail(&rq->queuelist, &q->queue_head);
 		/*
 		 * We kick the queue here for the following reasons.
@@ -712,7 +714,8 @@ void __elv_add_request(struct request_qu
 	if (q->ordcolor)
 		rq->cmd_flags |= REQ_ORDERED_COLOR;
 
-	if (rq->cmd_flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER)) {
+	if (rq->cmd_flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER |
+		REQ_FLUSHBARRIER)) {
 		/*
 		 * toggle ordered color
 		 */
Index: linux-2.6/include/linux/bio.h
===================================================================
--- linux-2.6.orig/include/linux/bio.h	2010-08-02 13:17:35.000000000 -0400
+++ linux-2.6/include/linux/bio.h	2010-08-02 14:01:17.000000000 -0400
@@ -161,6 +161,10 @@ struct bio {
  *	Don't want driver retries for any fast fail whatever the reason.
  * bit 10 -- Tell the IO scheduler not to wait for more requests after this
 	one has been submitted, even if it is a SYNC request.
+ * bit 11 -- This is flush only barrier and does not perform drain operations.
+ * 	     A user using this should make sure all the requests one is
+ * 	     depndent on have completed and then use this barrier to flush
+ * 	     the cache and also do FUA write if it is non empty barrier.
  */
 enum bio_rw_flags {
 	BIO_RW,
@@ -175,6 +179,7 @@ enum bio_rw_flags {
 	BIO_RW_META,
 	BIO_RW_DISCARD,
 	BIO_RW_NOIDLE,
+	BIO_RW_FLUSHBARRIER,
 };
 
 /*
@@ -211,7 +216,7 @@ static inline bool bio_rw_flagged(struct
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
-#define bio_empty_barrier(bio)	(bio_rw_flagged(bio, BIO_RW_BARRIER) && !bio_has_data(bio) && !bio_rw_flagged(bio, BIO_RW_DISCARD))
+#define bio_empty_barrier(bio)	((bio_rw_flagged(bio, BIO_RW_BARRIER) || bio_rw_flagged(bio, BIO_RW_FLUSHBARRIER)) && !bio_has_data(bio) && !bio_rw_flagged(bio, BIO_RW_DISCARD))
 
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2010-08-02 13:17:35.000000000 -0400
+++ linux-2.6/block/blk-core.c	2010-08-02 14:01:17.000000000 -0400
@@ -1153,6 +1153,8 @@ void init_request_from_bio(struct reques
 		req->cmd_flags |= REQ_DISCARD;
 	if (bio_rw_flagged(bio, BIO_RW_BARRIER))
 		req->cmd_flags |= REQ_HARDBARRIER;
+	if (bio_rw_flagged(bio, BIO_RW_FLUSHBARRIER))
+		req->cmd_flags |= REQ_FLUSHBARRIER;
 	if (bio_rw_flagged(bio, BIO_RW_SYNCIO))
 		req->cmd_flags |= REQ_RW_SYNC;
 	if (bio_rw_flagged(bio, BIO_RW_META))
@@ -1185,9 +1187,10 @@ static int __make_request(struct request
 	const bool unplug = bio_rw_flagged(bio, BIO_RW_UNPLUG);
 	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 	int rw_flags;
+	const bool is_barrier = (bio_rw_flagged(bio, BIO_RW_BARRIER)
+				|| bio_rw_flagged(bio, BIO_RW_FLUSHBARRIER));
 
-	if (bio_rw_flagged(bio, BIO_RW_BARRIER) &&
-	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+	if (is_barrier && (q->next_ordered == QUEUE_ORDERED_NONE)) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
@@ -1200,7 +1203,7 @@ static int __make_request(struct request
 
 	spin_lock_irq(q->queue_lock);
 
-	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER)) || elv_queue_empty(q))
+	if (unlikely(is_barrier) || elv_queue_empty(q))
 		goto get_rq;
 
 	el_ret = elv_merge(q, &req, bio);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-08-02 13:17:35.000000000 -0400
+++ linux-2.6/include/linux/fs.h	2010-08-02 13:19:02.000000000 -0400
@@ -160,6 +160,7 @@ struct inodes_stat_t {
 			(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
 #define SWRITE_SYNC	(SWRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
+#define WRITE_FLUSHBARRIER	(WRITE | (1 << BIO_RW_FLUSHBARRIER))
 
 /*
  * These aren't really reads or writes, they pass down information about
Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile	2010-08-02 13:17:35.000000000 -0400
+++ linux-2.6/Makefile	2010-08-02 13:19:02.000000000 -0400
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 35
-EXTRAVERSION = -rc6
+EXTRAVERSION = -rc6-flush-barriers
 NAME = Sheep on Meth
 
 # *DOCUMENTATION*
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2010-08-02 14:01:08.000000000 -0400
+++ linux-2.6/fs/buffer.c	2010-08-02 14:01:17.000000000 -0400
@@ -3026,6 +3026,9 @@ int submit_bh(int rw, struct buffer_head
 	if (buffer_ordered(bh) && (rw & WRITE))
 		rw |= WRITE_BARRIER;
 
+	if (buffer_flush_ordered(bh) && (rw & WRITE))
+		rw |= WRITE_FLUSHBARRIER;
+
 	/*
 	 * Only clear out a write error when rewriting
 	 */
Index: linux-2.6/fs/ext3/fsync.c
===================================================================
--- linux-2.6.orig/fs/ext3/fsync.c	2010-08-02 14:01:08.000000000 -0400
+++ linux-2.6/fs/ext3/fsync.c	2010-08-02 14:01:17.000000000 -0400
@@ -91,6 +91,6 @@ int ext3_sync_file(struct file *file, in
 	 */
 	if (needs_barrier)
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
-				BLKDEV_IFL_WAIT);
+				BLKDEV_IFL_WAIT | BLKDEV_IFL_FLUSHBARRIER);
 	return ret;
 }
Index: linux-2.6/fs/jbd/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd/commit.c	2010-08-02 14:01:08.000000000 -0400
+++ linux-2.6/fs/jbd/commit.c	2010-08-02 14:01:17.000000000 -0400
@@ -138,7 +138,7 @@ static int journal_write_commit_record(j
 	JBUFFER_TRACE(descriptor, "write commit block");
 	set_buffer_dirty(bh);
 	if (journal->j_flags & JFS_BARRIER) {
-		set_buffer_ordered(bh);
+		set_buffer_flush_ordered(bh);
 		barrier_done = 1;
 	}
 	ret = sync_dirty_buffer(bh);
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h	2010-08-02 14:01:08.000000000 -0400
+++ linux-2.6/include/linux/buffer_head.h	2010-08-02 14:01:17.000000000 -0400
@@ -33,6 +33,8 @@ enum bh_state_bits {
 	BH_Boundary,	/* Block is followed by a discontiguity */
 	BH_Write_EIO,	/* I/O error on write */
 	BH_Ordered,	/* ordered write */
+	BH_Flush_Ordered,/* ordered write. Ordered w.r.t contents in write
+			    cache */
 	BH_Eopnotsupp,	/* operation not supported (barrier) */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
@@ -126,6 +128,7 @@ BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Ordered, ordered)
+BUFFER_FNS(Flush_Ordered, flush_ordered)
 BUFFER_FNS(Eopnotsupp, eopnotsupp)
 BUFFER_FNS(Unwritten, unwritten)
 
Index: linux-2.6/kernel/trace/blktrace.c
===================================================================
--- linux-2.6.orig/kernel/trace/blktrace.c	2010-08-02 14:01:08.000000000 -0400
+++ linux-2.6/kernel/trace/blktrace.c	2010-08-02 14:01:17.000000000 -0400
@@ -1764,7 +1764,7 @@ void blk_fill_rwbs(char *rwbs, u32 rw, i
 
 	if (rw & 1 << BIO_RW_AHEAD)
 		rwbs[i++] = 'A';
-	if (rw & 1 << BIO_RW_BARRIER)
+	if (rw & 1 << BIO_RW_BARRIER || rw & 1 << BIO_RW_FLUSHBARRIER)
 		rwbs[i++] = 'B';
 	if (rw & 1 << BIO_RW_SYNCIO)
 		rwbs[i++] = 'S';
