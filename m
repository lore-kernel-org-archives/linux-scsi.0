From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/41] dm: relax ordering of bio-based flush
	implementation
Date: Fri,  3 Sep 2010 12:29:40 +0200
Message-ID: <1283509796-1510-26-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Unlike REQ_HARDBARRIER, REQ_FLUSH/FUA doesn't mandate any ordering
against other bio's.  This patch relaxes ordering around flushes.

* A flush bio is no longer deferred to workqueue directly.  It's
  processed like other bio's but __split_and_process_bio() uses
  md->flush_bio as the clone source.  md->flush_bio is initialized to
  empty flush during md initialization and shared for all flushes.

* As a flush bio now travels through the same execution path as other
  bio's, there's no need for dedicated error handling path either.  It
  can use the same error handling path in dec_pending().  Dedicated
  error handling removed along with md->flush_error.

* When dec_pending() detects that a flush has completed, it checks
  whether the original bio has data.  If so, the bio is queued to the
  deferred list w/ REQ_FLUSH cleared; otherwise, it's completed.

* As flush sequencing is handled in the usual issue/completion path,
  dm_wq_work() no longer needs to handle flushes differently.  Now its
  only responsibility is re-issuing deferred bio's the same way as
  _dm_request() would.  REQ_FLUSH handling logic including
  process_flush() is dropped.

* There's no reason for queue_io() and dm_wq_work() write lock
  dm->io_lock.  queue_io() now only uses md->deferred_lock and
  dm_wq_work() read locks dm->io_lock.

* bio's no longer need to be queued on the deferred list while a flush
  is in progress making DMF_QUEUE_IO_TO_THREAD unncessary.  Drop it.

This avoids stalling the device during flushes and simplifies the
implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/md/dm.c |  157 ++++++++++++++++---------------------------------------
 1 files changed, 45 insertions(+), 112 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 65114e4..2011704 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -110,7 +110,6 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_FREEING 3
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
-#define DMF_QUEUE_IO_TO_THREAD 6
 
 /*
  * Work processed by per-device workqueue.
@@ -144,11 +143,6 @@ struct mapped_device {
 	spinlock_t deferred_lock;
 
 	/*
-	 * An error from the flush request currently being processed.
-	 */
-	int flush_error;
-
-	/*
 	 * Processing queue (flush)
 	 */
 	struct workqueue_struct *wq;
@@ -518,16 +512,10 @@ static void end_io_acct(struct dm_io *io)
  */
 static void queue_io(struct mapped_device *md, struct bio *bio)
 {
-	down_write(&md->io_lock);
-
 	spin_lock_irq(&md->deferred_lock);
 	bio_list_add(&md->deferred, bio);
 	spin_unlock_irq(&md->deferred_lock);
-
-	if (!test_and_set_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags))
-		queue_work(md->wq, &md->work);
-
-	up_write(&md->io_lock);
+	queue_work(md->wq, &md->work);
 }
 
 /*
@@ -615,11 +603,9 @@ static void dec_pending(struct dm_io *io, int error)
 			 * Target requested pushing back the I/O.
 			 */
 			spin_lock_irqsave(&md->deferred_lock, flags);
-			if (__noflush_suspending(md)) {
-				if (!(io->bio->bi_rw & REQ_FLUSH))
-					bio_list_add_head(&md->deferred,
-							  io->bio);
-			} else
+			if (__noflush_suspending(md))
+				bio_list_add_head(&md->deferred, io->bio);
+			else
 				/* noflush suspend was interrupted. */
 				io->error = -EIO;
 			spin_unlock_irqrestore(&md->deferred_lock, flags);
@@ -627,26 +613,22 @@ static void dec_pending(struct dm_io *io, int error)
 
 		io_error = io->error;
 		bio = io->bio;
+		end_io_acct(io);
+		free_io(md, io);
+
+		if (io_error == DM_ENDIO_REQUEUE)
+			return;
 
-		if (bio->bi_rw & REQ_FLUSH) {
+		if (!(bio->bi_rw & REQ_FLUSH) || !bio->bi_size) {
+			trace_block_bio_complete(md->queue, bio);
+			bio_endio(bio, io_error);
+		} else {
 			/*
-			 * There can be just one flush request so we use
-			 * a per-device variable for error reporting.
-			 * Note that you can't touch the bio after end_io_acct
+			 * Preflush done for flush with data, reissue
+			 * without REQ_FLUSH.
 			 */
-			if (!md->flush_error)
-				md->flush_error = io_error;
-			end_io_acct(io);
-			free_io(md, io);
-		} else {
-			end_io_acct(io);
-			free_io(md, io);
-
-			if (io_error != DM_ENDIO_REQUEUE) {
-				trace_block_bio_complete(md->queue, bio);
-
-				bio_endio(bio, io_error);
-			}
+			bio->bi_rw &= ~REQ_FLUSH;
+			queue_io(md, bio);
 		}
 	}
 }
@@ -1298,21 +1280,17 @@ static int __clone_and_map(struct clone_info *ci)
  */
 static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
 {
+	bool is_flush = bio->bi_rw & REQ_FLUSH;
 	struct clone_info ci;
 	int error = 0;
 
 	ci.map = dm_get_live_table(md);
 	if (unlikely(!ci.map)) {
-		if (!(bio->bi_rw & REQ_FLUSH))
-			bio_io_error(bio);
-		else
-			if (!md->flush_error)
-				md->flush_error = -EIO;
+		bio_io_error(bio);
 		return;
 	}
 
 	ci.md = md;
-	ci.bio = bio;
 	ci.io = alloc_io(md);
 	ci.io->error = 0;
 	atomic_set(&ci.io->io_count, 1);
@@ -1320,18 +1298,19 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
 	ci.io->md = md;
 	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_sector;
-	if (!(bio->bi_rw & REQ_FLUSH))
+	ci.idx = bio->bi_idx;
+
+	if (!is_flush) {
+		ci.bio = bio;
 		ci.sector_count = bio_sectors(bio);
-	else {
-		/* all FLUSH bio's reaching here should be empty */
-		WARN_ON_ONCE(bio_has_data(bio));
+	} else {
+		ci.bio = &ci.md->flush_bio;
 		ci.sector_count = 1;
 	}
-	ci.idx = bio->bi_idx;
 
 	start_io_acct(ci.io);
 	while (ci.sector_count && !error) {
-		if (!(bio->bi_rw & REQ_FLUSH))
+		if (!is_flush)
 			error = __clone_and_map(&ci);
 		else
 			error = __clone_and_map_flush(&ci);
@@ -1419,22 +1398,14 @@ static int _dm_request(struct request_queue *q, struct bio *bio)
 	part_stat_add(cpu, &dm_disk(md)->part0, sectors[rw], bio_sectors(bio));
 	part_stat_unlock();
 
-	/*
-	 * If we're suspended or the thread is processing flushes
-	 * we have to queue this io for later.
-	 */
-	if (unlikely(test_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags)) ||
-	    (bio->bi_rw & REQ_FLUSH)) {
+	/* if we're suspended, we have to queue this io for later */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
 		up_read(&md->io_lock);
 
-		if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) &&
-		    bio_rw(bio) == READA) {
+		if (bio_rw(bio) != READA)
+			queue_io(md, bio);
+		else
 			bio_io_error(bio);
-			return 0;
-		}
-
-		queue_io(md, bio);
-
 		return 0;
 	}
 
@@ -1923,6 +1894,10 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->bdev)
 		goto bad_bdev;
 
+	bio_init(&md->flush_bio);
+	md->flush_bio.bi_bdev = md->bdev;
+	md->flush_bio.bi_rw = WRITE_FLUSH;
+
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);
 	old_md = idr_replace(&_minor_idr, md, minor);
@@ -2313,37 +2288,6 @@ static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
 	return r;
 }
 
-static void process_flush(struct mapped_device *md, struct bio *bio)
-{
-	md->flush_error = 0;
-
-	/* handle REQ_FLUSH */
-	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-
-	bio_init(&md->flush_bio);
-	md->flush_bio.bi_bdev = md->bdev;
-	md->flush_bio.bi_rw = WRITE_FLUSH;
-	__split_and_process_bio(md, &md->flush_bio);
-
-	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-
-	/* if it's an empty flush or the preflush failed, we're done */
-	if (!bio_has_data(bio) || md->flush_error) {
-		if (md->flush_error != DM_ENDIO_REQUEUE)
-			bio_endio(bio, md->flush_error);
-		else {
-			spin_lock_irq(&md->deferred_lock);
-			bio_list_add_head(&md->deferred, bio);
-			spin_unlock_irq(&md->deferred_lock);
-		}
-		return;
-	}
-
-	/* issue data + REQ_FUA */
-	bio->bi_rw &= ~REQ_FLUSH;
-	__split_and_process_bio(md, bio);
-}
-
 /*
  * Process the deferred bios
  */
@@ -2353,33 +2297,27 @@ static void dm_wq_work(struct work_struct *work)
 						work);
 	struct bio *c;
 
-	down_write(&md->io_lock);
+	down_read(&md->io_lock);
 
 	while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
 		spin_lock_irq(&md->deferred_lock);
 		c = bio_list_pop(&md->deferred);
 		spin_unlock_irq(&md->deferred_lock);
 
-		if (!c) {
-			clear_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags);
+		if (!c)
 			break;
-		}
 
-		up_write(&md->io_lock);
+		up_read(&md->io_lock);
 
 		if (dm_request_based(md))
 			generic_make_request(c);
-		else {
-			if (c->bi_rw & REQ_FLUSH)
-				process_flush(md, c);
-			else
-				__split_and_process_bio(md, c);
-		}
+		else
+			__split_and_process_bio(md, c);
 
-		down_write(&md->io_lock);
+		down_read(&md->io_lock);
 	}
 
-	up_write(&md->io_lock);
+	up_read(&md->io_lock);
 }
 
 static void dm_queue_flush(struct mapped_device *md)
@@ -2511,17 +2449,12 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	 *
 	 * To get all processes out of __split_and_process_bio in dm_request,
 	 * we take the write lock. To prevent any process from reentering
-	 * __split_and_process_bio from dm_request, we set
-	 * DMF_QUEUE_IO_TO_THREAD.
-	 *
-	 * To quiesce the thread (dm_wq_work), we set DMF_BLOCK_IO_FOR_SUSPEND
-	 * and call flush_workqueue(md->wq). flush_workqueue will wait until
-	 * dm_wq_work exits and DMF_BLOCK_IO_FOR_SUSPEND will prevent any
-	 * further calls to __split_and_process_bio from dm_wq_work.
+	 * __split_and_process_bio from dm_request and quiesce the thread
+	 * (dm_wq_work), we set BMF_BLOCK_IO_FOR_SUSPEND and call
+	 * flush_workqueue(md->wq).
 	 */
 	down_write(&md->io_lock);
 	set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
-	set_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags);
 	up_write(&md->io_lock);
 
 	/*
-- 
1.7.1
