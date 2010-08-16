From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] md: implment REQ_FLUSH/FUA support
Date: Mon, 16 Aug 2010 18:52:02 +0200
Message-ID: <1281977523-19335-5-git-send-email-tj@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1281977523-19335-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
Cc: Tejun Heo <tj@kernle.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <tj@kernle.org>

This patch converts md to support REQ_FLUSH/FUA instead of now
deprecated REQ_HARDBARRIER.  In the core part (md.c), the following
changes are notable.

* Unlike REQ_HARDBARRIER, REQ_FLUSH/FUA don't interfere with
  processing of other requests and thus there is no reason to mark the
  queue congested while FLUSH/FUA is in progress.

* REQ_FLUSH/FUA failures are final and its users don't need retry
  logic.  Retry logic is removed.

* Preflush needs to be issued to all member devices but FUA writes can
  be handled the same way as other writes - their processing can be
  deferred to request_queue of member devices.  md_barrier_request()
  is renamed to md_flush_request() and simplified accordingly.

For linear, raid0 and multipath, the core changes are enough.  raid1,
5 and 10 need the following conversions.

* raid1: Handling of FLUSH/FUA bio's can simply be deferred to
  request_queues of member devices.  Barrier related logic removed.

* raid5: Queue draining logic dropped.  FUA bit is propagated through
  biodrain and stripe resconstruction such that all the updated parts
  of the stripe are written out with FUA writes if any of the dirtying
  writes was FUA.  I think preread_active wait logic can be dropped
  but wasn't sure.  If it can be dropped, please go ahead and drop it.

* raid10: FUA bit needs to be propagated to write clones.

linear, raid0, 1, 5 and 10 tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>
---
 drivers/md/linear.c    |    4 +-
 drivers/md/md.c        |  117 +++++++-------------------------
 drivers/md/md.h        |   23 ++-----
 drivers/md/multipath.c |    4 +-
 drivers/md/raid0.c     |    4 +-
 drivers/md/raid1.c     |  175 ++++++++++++++++--------------------------------
 drivers/md/raid1.h     |    2 -
 drivers/md/raid10.c    |    7 +-
 drivers/md/raid5.c     |   38 ++++++-----
 drivers/md/raid5.h     |    1 +
 10 files changed, 123 insertions(+), 252 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index ba19060..8a2f767 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -294,8 +294,8 @@ static int linear_make_request (mddev_t *mddev, struct bio *bio)
 	dev_info_t *tmp_dev;
 	sector_t start_sector;
 
-	if (unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
-		md_barrier_request(mddev, bio);
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
 		return 0;
 	}
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 700c96e..91b2929 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -226,12 +226,12 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
 		return 0;
 	}
 	rcu_read_lock();
-	if (mddev->suspended || mddev->barrier) {
+	if (mddev->suspended) {
 		DEFINE_WAIT(__wait);
 		for (;;) {
 			prepare_to_wait(&mddev->sb_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
-			if (!mddev->suspended && !mddev->barrier)
+			if (!mddev->suspended)
 				break;
 			rcu_read_unlock();
 			schedule();
@@ -280,40 +280,29 @@ static void mddev_resume(mddev_t *mddev)
 
 int mddev_congested(mddev_t *mddev, int bits)
 {
-	if (mddev->barrier)
-		return 1;
 	return mddev->suspended;
 }
 EXPORT_SYMBOL(mddev_congested);
 
 /*
- * Generic barrier handling for md
+ * Generic flush handling for md
  */
 
-#define POST_REQUEST_BARRIER ((void*)1)
-
-static void md_end_barrier(struct bio *bio, int err)
+static void md_end_flush(struct bio *bio, int err)
 {
 	mdk_rdev_t *rdev = bio->bi_private;
 	mddev_t *mddev = rdev->mddev;
-	if (err == -EOPNOTSUPP && mddev->barrier != POST_REQUEST_BARRIER)
-		set_bit(BIO_EOPNOTSUPP, &mddev->barrier->bi_flags);
 
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
-		if (mddev->barrier == POST_REQUEST_BARRIER) {
-			/* This was a post-request barrier */
-			mddev->barrier = NULL;
-			wake_up(&mddev->sb_wait);
-		} else
-			/* The pre-request barrier has finished */
-			schedule_work(&mddev->barrier_work);
+		/* The pre-request flush has finished */
+		schedule_work(&mddev->flush_work);
 	}
 	bio_put(bio);
 }
 
-static void submit_barriers(mddev_t *mddev)
+static void submit_flushes(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
 
@@ -330,60 +319,56 @@ static void submit_barriers(mddev_t *mddev)
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
 			bi = bio_alloc(GFP_KERNEL, 0);
-			bi->bi_end_io = md_end_barrier;
+			bi->bi_end_io = md_end_flush;
 			bi->bi_private = rdev;
 			bi->bi_bdev = rdev->bdev;
 			atomic_inc(&mddev->flush_pending);
-			submit_bio(WRITE_BARRIER, bi);
+			submit_bio(WRITE_FLUSH, bi);
 			rcu_read_lock();
 			rdev_dec_pending(rdev, mddev);
 		}
 	rcu_read_unlock();
 }
 
-static void md_submit_barrier(struct work_struct *ws)
+static void md_submit_flush_data(struct work_struct *ws)
 {
-	mddev_t *mddev = container_of(ws, mddev_t, barrier_work);
-	struct bio *bio = mddev->barrier;
+	mddev_t *mddev = container_of(ws, mddev_t, flush_work);
+	struct bio *bio = mddev->flush_bio;
 
 	atomic_set(&mddev->flush_pending, 1);
 
-	if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
-		bio_endio(bio, -EOPNOTSUPP);
-	else if (bio->bi_size == 0)
+	if (bio->bi_size == 0)
 		/* an empty barrier - all done */
 		bio_endio(bio, 0);
 	else {
-		bio->bi_rw &= ~REQ_HARDBARRIER;
+		bio->bi_rw &= ~REQ_FLUSH;
 		if (mddev->pers->make_request(mddev, bio))
 			generic_make_request(bio);
-		mddev->barrier = POST_REQUEST_BARRIER;
-		submit_barriers(mddev);
 	}
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
-		mddev->barrier = NULL;
+		mddev->flush_bio = NULL;
 		wake_up(&mddev->sb_wait);
 	}
 }
 
-void md_barrier_request(mddev_t *mddev, struct bio *bio)
+void md_flush_request(mddev_t *mddev, struct bio *bio)
 {
 	spin_lock_irq(&mddev->write_lock);
 	wait_event_lock_irq(mddev->sb_wait,
-			    !mddev->barrier,
+			    !mddev->flush_bio,
 			    mddev->write_lock, /*nothing*/);
-	mddev->barrier = bio;
+	mddev->flush_bio = bio;
 	spin_unlock_irq(&mddev->write_lock);
 
 	atomic_set(&mddev->flush_pending, 1);
-	INIT_WORK(&mddev->barrier_work, md_submit_barrier);
+	INIT_WORK(&mddev->flush_work, md_submit_flush_data);
 
-	submit_barriers(mddev);
+	submit_flushes(mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending))
-		schedule_work(&mddev->barrier_work);
+		schedule_work(&mddev->flush_work);
 }
-EXPORT_SYMBOL(md_barrier_request);
+EXPORT_SYMBOL(md_flush_request);
 
 static inline mddev_t *mddev_get(mddev_t *mddev)
 {
@@ -642,31 +627,6 @@ static void super_written(struct bio *bio, int error)
 	bio_put(bio);
 }
 
-static void super_written_barrier(struct bio *bio, int error)
-{
-	struct bio *bio2 = bio->bi_private;
-	mdk_rdev_t *rdev = bio2->bi_private;
-	mddev_t *mddev = rdev->mddev;
-
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
-	    error == -EOPNOTSUPP) {
-		unsigned long flags;
-		/* barriers don't appear to be supported :-( */
-		set_bit(BarriersNotsupp, &rdev->flags);
-		mddev->barriers_work = 0;
-		spin_lock_irqsave(&mddev->write_lock, flags);
-		bio2->bi_next = mddev->biolist;
-		mddev->biolist = bio2;
-		spin_unlock_irqrestore(&mddev->write_lock, flags);
-		wake_up(&mddev->sb_wait);
-		bio_put(bio);
-	} else {
-		bio_put(bio2);
-		bio->bi_private = rdev;
-		super_written(bio, error);
-	}
-}
-
 void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 		   sector_t sector, int size, struct page *page)
 {
@@ -675,51 +635,28 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 	 * and decrement it on completion, waking up sb_wait
 	 * if zero is reached.
 	 * If an error occurred, call md_error
-	 *
-	 * As we might need to resubmit the request if REQ_HARDBARRIER
-	 * causes ENOTSUPP, we allocate a spare bio...
 	 */
 	struct bio *bio = bio_alloc(GFP_NOIO, 1);
-	int rw = REQ_WRITE | REQ_SYNC | REQ_UNPLUG;
 
 	bio->bi_bdev = rdev->bdev;
 	bio->bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
-	bio->bi_rw = rw;
 
 	atomic_inc(&mddev->pending_writes);
-	if (!test_bit(BarriersNotsupp, &rdev->flags)) {
-		struct bio *rbio;
-		rw |= REQ_HARDBARRIER;
-		rbio = bio_clone(bio, GFP_NOIO);
-		rbio->bi_private = bio;
-		rbio->bi_end_io = super_written_barrier;
-		submit_bio(rw, rbio);
-	} else
-		submit_bio(rw, bio);
+	submit_bio(REQ_WRITE | REQ_SYNC | REQ_UNPLUG | REQ_FLUSH | REQ_FUA,
+		   bio);
 }
 
 void md_super_wait(mddev_t *mddev)
 {
-	/* wait for all superblock writes that were scheduled to complete.
-	 * if any had to be retried (due to BARRIER problems), retry them
-	 */
+	/* wait for all superblock writes that were scheduled to complete */
 	DEFINE_WAIT(wq);
 	for(;;) {
 		prepare_to_wait(&mddev->sb_wait, &wq, TASK_UNINTERRUPTIBLE);
 		if (atomic_read(&mddev->pending_writes)==0)
 			break;
-		while (mddev->biolist) {
-			struct bio *bio;
-			spin_lock_irq(&mddev->write_lock);
-			bio = mddev->biolist;
-			mddev->biolist = bio->bi_next ;
-			bio->bi_next = NULL;
-			spin_unlock_irq(&mddev->write_lock);
-			submit_bio(bio->bi_rw, bio);
-		}
 		schedule();
 	}
 	finish_wait(&mddev->sb_wait, &wq);
@@ -1016,7 +953,6 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 	clear_bit(Faulty, &rdev->flags);
 	clear_bit(In_sync, &rdev->flags);
 	clear_bit(WriteMostly, &rdev->flags);
-	clear_bit(BarriersNotsupp, &rdev->flags);
 
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 0;
@@ -1431,7 +1367,6 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 	clear_bit(Faulty, &rdev->flags);
 	clear_bit(In_sync, &rdev->flags);
 	clear_bit(WriteMostly, &rdev->flags);
-	clear_bit(BarriersNotsupp, &rdev->flags);
 
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 1;
@@ -4463,7 +4398,6 @@ static int md_run(mddev_t *mddev)
 	/* may be over-ridden by personality */
 	mddev->resync_max_sectors = mddev->dev_sectors;
 
-	mddev->barriers_work = 1;
 	mddev->ok_start_degraded = start_dirty_degraded;
 
 	if (start_readonly && mddev->ro == 0)
@@ -4638,7 +4572,6 @@ static void md_clean(mddev_t *mddev)
 	mddev->recovery = 0;
 	mddev->in_sync = 0;
 	mddev->degraded = 0;
-	mddev->barriers_work = 0;
 	mddev->safemode = 0;
 	mddev->bitmap_info.offset = 0;
 	mddev->bitmap_info.default_offset = 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index fc56e0f..de4a365 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -67,7 +67,6 @@ struct mdk_rdev_s
 #define	Faulty		1		/* device is known to have a fault */
 #define	In_sync		2		/* device is in_sync with rest of array */
 #define	WriteMostly	4		/* Avoid reading if at all possible */
-#define	BarriersNotsupp	5		/* REQ_HARDBARRIER is not supported */
 #define	AllReserved	6		/* If whole device is reserved for
 					 * one array */
 #define	AutoDetected	7		/* added by auto-detect */
@@ -249,13 +248,6 @@ struct mddev_s
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
-	int				barriers_work;	/* initialised to true, cleared as soon
-							 * as a barrier request to slave
-							 * fails.  Only supported
-							 */
-	struct bio			*biolist; 	/* bios that need to be retried
-							 * because REQ_HARDBARRIER is not supported
-							 */
 
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
@@ -308,16 +300,13 @@ struct mddev_s
 	struct list_head		all_mddevs;
 
 	struct attribute_group		*to_remove;
-	/* Generic barrier handling.
-	 * If there is a pending barrier request, all other
-	 * writes are blocked while the devices are flushed.
-	 * The last to finish a flush schedules a worker to
-	 * submit the barrier request (without the barrier flag),
-	 * then submit more flush requests.
+	/* Generic flush handling.
+	 * The last to finish preflush schedules a worker to submit
+	 * the rest of the request (without the REQ_FLUSH flag).
 	 */
-	struct bio *barrier;
+	struct bio *flush_bio;
 	atomic_t flush_pending;
-	struct work_struct barrier_work;
+	struct work_struct flush_work;
 };
 
 
@@ -458,7 +447,7 @@ extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
 extern void md_error(mddev_t *mddev, mdk_rdev_t *rdev);
 
 extern int mddev_congested(mddev_t *mddev, int bits);
-extern void md_barrier_request(mddev_t *mddev, struct bio *bio);
+extern void md_flush_request(mddev_t *mddev, struct bio *bio);
 extern void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 			   sector_t sector, int size, struct page *page);
 extern void md_super_wait(mddev_t *mddev);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 0307d21..6d7ddf3 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -142,8 +142,8 @@ static int multipath_make_request(mddev_t *mddev, struct bio * bio)
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
 
-	if (unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
-		md_barrier_request(mddev, bio);
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
 		return 0;
 	}
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6f7af46..a39f4c3 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -483,8 +483,8 @@ static int raid0_make_request(mddev_t *mddev, struct bio *bio)
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
 
-	if (unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
-		md_barrier_request(mddev, bio);
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
 		return 0;
 	}
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1d7b6a8..4b628b7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -319,83 +319,74 @@ static void raid1_end_write_request(struct bio *bio, int error)
 		if (r1_bio->bios[mirror] == bio)
 			break;
 
-	if (error == -EOPNOTSUPP && test_bit(R1BIO_Barrier, &r1_bio->state)) {
-		set_bit(BarriersNotsupp, &conf->mirrors[mirror].rdev->flags);
-		set_bit(R1BIO_BarrierRetry, &r1_bio->state);
-		r1_bio->mddev->barriers_work = 0;
-		/* Don't rdev_dec_pending in this branch - keep it for the retry */
-	} else {
+	/*
+	 * 'one mirror IO has finished' event handler:
+	 */
+	r1_bio->bios[mirror] = NULL;
+	to_put = bio;
+	if (!uptodate) {
+		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
+		/* an I/O failed, we can't clear the bitmap */
+		set_bit(R1BIO_Degraded, &r1_bio->state);
+	} else
 		/*
-		 * this branch is our 'one mirror IO has finished' event handler:
+		 * Set R1BIO_Uptodate in our master bio, so that we
+		 * will return a good error code for to the higher
+		 * levels even if IO on some other mirrored buffer
+		 * fails.
+		 *
+		 * The 'master' represents the composite IO operation
+		 * to user-side. So if something waits for IO, then it
+		 * will wait for the 'master' bio.
 		 */
-		r1_bio->bios[mirror] = NULL;
-		to_put = bio;
-		if (!uptodate) {
-			md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-			/* an I/O failed, we can't clear the bitmap */
-			set_bit(R1BIO_Degraded, &r1_bio->state);
-		} else
-			/*
-			 * Set R1BIO_Uptodate in our master bio, so that
-			 * we will return a good error code for to the higher
-			 * levels even if IO on some other mirrored buffer fails.
-			 *
-			 * The 'master' represents the composite IO operation to
-			 * user-side. So if something waits for IO, then it will
-			 * wait for the 'master' bio.
-			 */
-			set_bit(R1BIO_Uptodate, &r1_bio->state);
-
-		update_head_pos(mirror, r1_bio);
-
-		if (behind) {
-			if (test_bit(WriteMostly, &conf->mirrors[mirror].rdev->flags))
-				atomic_dec(&r1_bio->behind_remaining);
-
-			/* In behind mode, we ACK the master bio once the I/O has safely
-			 * reached all non-writemostly disks. Setting the Returned bit
-			 * ensures that this gets done only once -- we don't ever want to
-			 * return -EIO here, instead we'll wait */
-
-			if (atomic_read(&r1_bio->behind_remaining) >= (atomic_read(&r1_bio->remaining)-1) &&
-			    test_bit(R1BIO_Uptodate, &r1_bio->state)) {
-				/* Maybe we can return now */
-				if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
-					struct bio *mbio = r1_bio->master_bio;
-					PRINTK(KERN_DEBUG "raid1: behind end write sectors %llu-%llu\n",
-					       (unsigned long long) mbio->bi_sector,
-					       (unsigned long long) mbio->bi_sector +
-					       (mbio->bi_size >> 9) - 1);
-					bio_endio(mbio, 0);
-				}
+		set_bit(R1BIO_Uptodate, &r1_bio->state);
+
+	update_head_pos(mirror, r1_bio);
+
+	if (behind) {
+		if (test_bit(WriteMostly, &conf->mirrors[mirror].rdev->flags))
+			atomic_dec(&r1_bio->behind_remaining);
+
+		/*
+		 * In behind mode, we ACK the master bio once the I/O
+		 * has safely reached all non-writemostly
+		 * disks. Setting the Returned bit ensures that this
+		 * gets done only once -- we don't ever want to return
+		 * -EIO here, instead we'll wait
+		 */
+		if (atomic_read(&r1_bio->behind_remaining) >= (atomic_read(&r1_bio->remaining)-1) &&
+		    test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+			/* Maybe we can return now */
+			if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
+				struct bio *mbio = r1_bio->master_bio;
+				PRINTK(KERN_DEBUG "raid1: behind end write sectors %llu-%llu\n",
+				       (unsigned long long) mbio->bi_sector,
+				       (unsigned long long) mbio->bi_sector +
+				       (mbio->bi_size >> 9) - 1);
+				bio_endio(mbio, 0);
 			}
 		}
-		rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
 	}
+	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
+
 	/*
-	 *
 	 * Let's see if all mirrored write operations have finished
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		if (test_bit(R1BIO_BarrierRetry, &r1_bio->state))
-			reschedule_retry(r1_bio);
-		else {
-			/* it really is the end of this request */
-			if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
-				/* free extra copy of the data pages */
-				int i = bio->bi_vcnt;
-				while (i--)
-					safe_put_page(bio->bi_io_vec[i].bv_page);
-			}
-			/* clear the bitmap if all writes complete successfully */
-			bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
-					r1_bio->sectors,
-					!test_bit(R1BIO_Degraded, &r1_bio->state),
-					behind);
-			md_write_end(r1_bio->mddev);
-			raid_end_bio_io(r1_bio);
+		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
+			/* free extra copy of the data pages */
+			int i = bio->bi_vcnt;
+			while (i--)
+				safe_put_page(bio->bi_io_vec[i].bv_page);
 		}
+		/* clear the bitmap if all writes complete successfully */
+		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
+				r1_bio->sectors,
+				!test_bit(R1BIO_Degraded, &r1_bio->state),
+				behind);
+		md_write_end(r1_bio->mddev);
+		raid_end_bio_io(r1_bio);
 	}
 
 	if (to_put)
@@ -788,6 +779,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
 	const unsigned int do_sync = (bio->bi_rw & REQ_SYNC);
+	const unsigned int do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	bool do_barriers;
 	mdk_rdev_t *blocked_rdev;
 
@@ -795,9 +787,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
-	 * We test barriers_work *after* md_write_start as md_write_start
-	 * may cause the first superblock write, and that will check out
-	 * if barriers work.
 	 */
 
 	md_write_start(mddev, bio); /* wait on superblock update early */
@@ -821,13 +810,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		}
 		finish_wait(&conf->wait_barrier, &w);
 	}
-	if (unlikely(!mddev->barriers_work &&
-		     (bio->bi_rw & REQ_HARDBARRIER))) {
-		if (rw == WRITE)
-			md_write_end(mddev);
-		bio_endio(bio, -EOPNOTSUPP);
-		return 0;
-	}
 
 	wait_barrier(conf);
 
@@ -959,10 +941,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	atomic_set(&r1_bio->remaining, 0);
 	atomic_set(&r1_bio->behind_remaining, 0);
 
-	do_barriers = bio->bi_rw & REQ_HARDBARRIER;
-	if (do_barriers)
-		set_bit(R1BIO_Barrier, &r1_bio->state);
-
 	bio_list_init(&bl);
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
@@ -975,7 +953,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_barriers | do_sync;
+		mbio->bi_rw = WRITE | do_flush_fua | do_sync;
 		mbio->bi_private = r1_bio;
 
 		if (behind_pages) {
@@ -1631,41 +1609,6 @@ static void raid1d(mddev_t *mddev)
 		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
 			sync_request_write(mddev, r1_bio);
 			unplug = 1;
-		} else if (test_bit(R1BIO_BarrierRetry, &r1_bio->state)) {
-			/* some requests in the r1bio were REQ_HARDBARRIER
-			 * requests which failed with -EOPNOTSUPP.  Hohumm..
-			 * Better resubmit without the barrier.
-			 * We know which devices to resubmit for, because
-			 * all others have had their bios[] entry cleared.
-			 * We already have a nr_pending reference on these rdevs.
-			 */
-			int i;
-			const bool do_sync = (r1_bio->master_bio->bi_rw & REQ_SYNC);
-			clear_bit(R1BIO_BarrierRetry, &r1_bio->state);
-			clear_bit(R1BIO_Barrier, &r1_bio->state);
-			for (i=0; i < conf->raid_disks; i++)
-				if (r1_bio->bios[i])
-					atomic_inc(&r1_bio->remaining);
-			for (i=0; i < conf->raid_disks; i++)
-				if (r1_bio->bios[i]) {
-					struct bio_vec *bvec;
-					int j;
-
-					bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
-					/* copy pages from the failed bio, as
-					 * this might be a write-behind device */
-					__bio_for_each_segment(bvec, bio, j, 0)
-						bvec->bv_page = bio_iovec_idx(r1_bio->bios[i], j)->bv_page;
-					bio_put(r1_bio->bios[i]);
-					bio->bi_sector = r1_bio->sector +
-						conf->mirrors[i].rdev->data_offset;
-					bio->bi_bdev = conf->mirrors[i].rdev->bdev;
-					bio->bi_end_io = raid1_end_write_request;
-					bio->bi_rw = WRITE | do_sync;
-					bio->bi_private = r1_bio;
-					r1_bio->bios[i] = bio;
-					generic_make_request(bio);
-				}
 		} else {
 			int disk;
 
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 5f2d443..adf8cfd 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -117,8 +117,6 @@ struct r1bio_s {
 #define	R1BIO_IsSync	1
 #define	R1BIO_Degraded	2
 #define	R1BIO_BehindIO	3
-#define	R1BIO_Barrier	4
-#define R1BIO_BarrierRetry 5
 /* For write-behind requests, we call bi_end_io when
  * the last non-write-behind device completes, providing
  * any write was successful.  Otherwise we call when
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5551ccf..cc00c10 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -800,12 +800,13 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	int chunk_sects = conf->chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
 	const unsigned int do_sync = (bio->bi_rw & REQ_SYNC);
+	const unsigned int do_fua = (bio->bi_rw & REQ_FUA);
 	struct bio_list bl;
 	unsigned long flags;
 	mdk_rdev_t *blocked_rdev;
 
-	if (unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
-		md_barrier_request(mddev, bio);
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
 		return 0;
 	}
 
@@ -947,7 +948,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 			conf->mirrors[d].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE | do_sync;
+		mbio->bi_rw = WRITE | do_sync | do_fua;
 		mbio->bi_private = r10_bio;
 
 		atomic_inc(&r10_bio->remaining);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 20ac2f1..7eabd99 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -507,9 +507,12 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		int rw;
 		struct bio *bi;
 		mdk_rdev_t *rdev;
-		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
-			rw = WRITE;
-		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
+		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags)) {
+			if (test_and_clear_bit(R5_WantFUA, &sh->dev[i].flags))
+				rw = WRITE_FUA;
+			else
+				rw = WRITE;
+		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
 			rw = READ;
 		else
 			continue;
@@ -1032,6 +1035,8 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 			while (wbi && wbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
+				if (wbi->bi_rw & REQ_FUA)
+					set_bit(R5_WantFUA, &dev->flags);
 				tx = async_copy_data(1, wbi, dev->page,
 					dev->sector, tx);
 				wbi = r5_next_bio(wbi, dev->sector);
@@ -1049,15 +1054,22 @@ static void ops_complete_reconstruct(void *stripe_head_ref)
 	int pd_idx = sh->pd_idx;
 	int qd_idx = sh->qd_idx;
 	int i;
+	bool fua = false;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	for (i = disks; i--; )
+		fua |= test_bit(R5_WantFUA, &sh->dev[i].flags);
+
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 
-		if (dev->written || i == pd_idx || i == qd_idx)
+		if (dev->written || i == pd_idx || i == qd_idx) {
 			set_bit(R5_UPTODATE, &dev->flags);
+			if (fua)
+				set_bit(R5_WantFUA, &dev->flags);
+		}
 	}
 
 	if (sh->reconstruct_state == reconstruct_state_drain_run)
@@ -3278,7 +3290,7 @@ static void handle_stripe5(struct stripe_head *sh)
 
 	if (dec_preread_active) {
 		/* We delay this until after ops_run_io so that if make_request
-		 * is waiting on a barrier, it won't continue until the writes
+		 * is waiting on a flush, it won't continue until the writes
 		 * have actually been submitted.
 		 */
 		atomic_dec(&conf->preread_active_stripes);
@@ -3580,7 +3592,7 @@ static void handle_stripe6(struct stripe_head *sh)
 
 	if (dec_preread_active) {
 		/* We delay this until after ops_run_io so that if make_request
-		 * is waiting on a barrier, it won't continue until the writes
+		 * is waiting on a flush, it won't continue until the writes
 		 * have actually been submitted.
 		 */
 		atomic_dec(&conf->preread_active_stripes);
@@ -3958,14 +3970,8 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 	const int rw = bio_data_dir(bi);
 	int remaining;
 
-	if (unlikely(bi->bi_rw & REQ_HARDBARRIER)) {
-		/* Drain all pending writes.  We only really need
-		 * to ensure they have been submitted, but this is
-		 * easier.
-		 */
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
-		md_barrier_request(mddev, bi);
+	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bi);
 		return 0;
 	}
 
@@ -4083,7 +4089,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if (mddev->barrier && 
+			if (mddev->flush_bio &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe(sh);
@@ -4106,7 +4112,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 		bio_endio(bi, 0);
 	}
 
-	if (mddev->barrier) {
+	if (mddev->flush_bio) {
 		/* We need to wait for the stripes to all be handled.
 		 * So: wait for preread_active_stripes to drop to 0.
 		 */
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 0f86f5e..ff9cad2 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -275,6 +275,7 @@ struct r6_state {
 				    * filling
 				    */
 #define R5_Wantdrain	13 /* dev->towrite needs to be drained */
+#define R5_WantFUA	14	/* Write should be FUA */
 /*
  * Write method
  */
-- 
1.7.1
