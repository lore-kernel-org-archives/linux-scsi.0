From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC 1/2] relaxed cache flushes
Date: Tue, 3 Aug 2010 20:49:39 +0200
Message-ID: <20100803184939.GA12198@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100727175418.GF6820@quack.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, tj@kernel.org, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.maso
List-Id: linux-scsi@vger.kernel.org

So instead of cracking my head on the relaxed barriers I've decided to
do the easiet part first.  That is relaxing explicit cache flushes
done by blkdev_issue_flush.  These days these are handled as an
empty barrier, which is completely overkill.  Instead take advantage
of the way we now handle flushes, that is as REQ_FLUSH FS requests.

Do a few updates to the block layer so that we handle REQ_FLUSH
correctly and we can make blkdev_issue_flush submit them directly.

All request based block drivers should just work with it, but bio
based remappers will need some additional work.  The next patch
will do this for DM, but I haven't quite grasped the barrier code
in MD yet.  Despite doing a lot REQ_HARDBARRIER tests DRBD doesn't
actually advertize any ordered mode so it's not affected.  The
barrier handling in the loop driver is currently broken anyway,
and I'm still undecided if I want to fix it before or after
this conversion.


Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2010-08-03 20:26:50.259005954 +0200
+++ linux-2.6/block/blk-barrier.c	2010-08-03 20:33:39.580266216 +0200
@@ -151,25 +151,7 @@ static inline bool start_ordered(struct
 	q->ordered = q->next_ordered;
 	q->ordseq |= QUEUE_ORDSEQ_STARTED;
 
-	/*
-	 * For an empty barrier, there's no actual BAR request, which
-	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
-	 */
-	if (!blk_rq_sectors(rq)) {
-		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
-				QUEUE_ORDERED_DO_POSTFLUSH);
-		/*
-		 * Empty barrier on a write-through device w/ ordered
-		 * tag has no command to issue and without any command
-		 * to issue, ordering by tag can't be used.  Drain
-		 * instead.
-		 */
-		if ((q->ordered & QUEUE_ORDERED_BY_TAG) &&
-		    !(q->ordered & QUEUE_ORDERED_DO_PREFLUSH)) {
-			q->ordered &= ~QUEUE_ORDERED_BY_TAG;
-			q->ordered |= QUEUE_ORDERED_BY_DRAIN;
-		}
-	}
+	BUG_ON(!blk_rq_sectors(rq));
 
 	/* stash away the original request */
 	blk_dequeue_request(rq);
@@ -311,6 +293,9 @@ int blkdev_issue_flush(struct block_devi
 	if (!q)
 		return -ENXIO;
 
+	if (!(q->next_ordered & QUEUE_ORDERED_DO_PREFLUSH))
+		return 0;
+
 	/*
 	 * some block devices may not have their queue correctly set up here
 	 * (e.g. loop device without a backing file) and so issuing a flush
@@ -327,7 +312,7 @@ int blkdev_issue_flush(struct block_devi
 		bio->bi_private = &wait;
 
 	bio_get(bio);
-	submit_bio(WRITE_BARRIER, bio);
+	submit_bio(WRITE_SYNC | REQ_FLUSH, bio);
 	if (test_bit(BLKDEV_WAIT, &flags)) {
 		wait_for_completion(&wait);
 		/*
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c	2010-08-03 20:26:50.268024322 +0200
+++ linux-2.6/block/elevator.c	2010-08-03 20:32:11.949256478 +0200
@@ -423,7 +423,8 @@ void elv_dispatch_sort(struct request_qu
 	q->nr_sorted--;
 
 	boundary = q->end_sector;
-	stop_flags = REQ_SOFTBARRIER | REQ_HARDBARRIER | REQ_STARTED;
+	stop_flags = REQ_SOFTBARRIER | REQ_HARDBARRIER | REQ_STARTED | \
+		     REQ_FLUSH;
 	list_for_each_prev(entry, &q->queue_head) {
 		struct request *pos = list_entry_rq(entry);
 
Index: linux-2.6/include/linux/bio.h
===================================================================
--- linux-2.6.orig/include/linux/bio.h	2010-08-03 20:26:50.298255570 +0200
+++ linux-2.6/include/linux/bio.h	2010-08-03 20:46:48.367257736 +0200
@@ -153,6 +153,7 @@ enum rq_flag_bits {
 	__REQ_META,		/* metadata io request */
 	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
+	__REQ_FLUSH,		/* request for cache flush */
 
 	/* bio only flags */
 	__REQ_UNPLUG,		/* unplug the immediately after submission */
@@ -174,7 +175,6 @@ enum rq_flag_bits {
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
-	__REQ_FLUSH,		/* request for cache flush */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_NR_BITS,		/* stops here */
@@ -189,12 +189,13 @@ enum rq_flag_bits {
 #define REQ_META		(1 << __REQ_META)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
+#define REQ_FLUSH		(1 << __REQ_FLUSH)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_HARDBARRIER | REQ_SYNC | \
-	 REQ_META| REQ_DISCARD | REQ_NOIDLE)
+	 REQ_META| REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH)
 
 #define REQ_UNPLUG		(1 << __REQ_UNPLUG)
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
@@ -214,7 +215,6 @@ enum rq_flag_bits {
 #define REQ_ALLOCED		(1 << __REQ_ALLOCED)
 #define REQ_COPY_USER		(1 << __REQ_COPY_USER)
 #define REQ_INTEGRITY		(1 << __REQ_INTEGRITY)
-#define REQ_FLUSH		(1 << __REQ_FLUSH)
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2010-08-03 20:26:50.311003929 +0200
+++ linux-2.6/include/linux/blkdev.h	2010-08-03 20:32:11.956036684 +0200
@@ -589,7 +589,8 @@ static inline void blk_clear_queue_full(
  * it already be started by driver.
  */
 #define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER)
+	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER | \
+	 REQ_FLUSH)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
 	 (((rq)->cmd_flags & REQ_DISCARD) || \
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2010-08-03 20:26:50.275003649 +0200
+++ linux-2.6/block/blk-core.c	2010-08-03 20:32:11.960004138 +0200
@@ -1203,7 +1203,7 @@ static int __make_request(struct request
 	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 	int rw_flags;
 
-	if ((bio->bi_rw & REQ_HARDBARRIER) &&
+	if ((bio->bi_rw & (REQ_HARDBARRIER|REQ_FLUSH)) &&
 	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
@@ -1217,7 +1217,7 @@ static int __make_request(struct request
 
 	spin_lock_irq(q->queue_lock);
 
-	if (unlikely((bio->bi_rw & REQ_HARDBARRIER)) || elv_queue_empty(q))
+	if ((bio->bi_rw & (REQ_HARDBARRIER|REQ_FLUSH)) || elv_queue_empty(q))
 		goto get_rq;
 
 	el_ret = elv_merge(q, &req, bio);
