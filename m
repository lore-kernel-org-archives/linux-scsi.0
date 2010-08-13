From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Fri, 13 Aug 2010 16:51:17 +0200
Message-ID: <4C655BE5.4070809@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100813143820.GA7931@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/13/2010 04:38 PM, Christoph Hellwig wrote:
> On Fri, Aug 13, 2010 at 03:48:59PM +0200, Tejun Heo wrote:
>> There are two reason to avoid changing the meaning of REQ_HARDBARRIER
>> and just deprecate it.  One is to avoid breaking filesystems'
>> expectations underneath it.  Please note that there are out-of-tree
>> filesystems too.  I think it would be too dangerous to relax
>> REQ_HARDBARRIER.
> 
> Note that the renaming patch would include a move from REQ_HARDBARRIER
> to REQ_FLUSH_FUA, so things just using REQ_HARDBARRIER will fail to
> compile.  And while out of tree filesystems do exist they it's their
> problem to keep up with kernel changes.  They decide not to be part
> of the Linux kernel, so it'll be their job to keep up with it.

Oh, right, we can simply remove REQ_HARDBARRIER completely.

>> Another is that pseudo block layer drivers (loop, virtio_blk,
>> md/dm...) have assumptions about REQ_HARDBARRIER behavior and things
>> would be broken in obscure ways between REQ_HARDBARRIER semantics
>> change and updates to each of those drivers, so I don't really think
>> changing the semantics while the mechanism is online is a good idea.
> 
> I don't think doing those changes in a separate commit is a good idea.

Do you want to change the whole thing in a single commit?  That would
be a pretty big invasive patch touching multiple subsystems.  Also, I
don't know what to do about drdb and would like to leave its
conversion to the maintainer (in separate patches).

Eh, well, this is mostly logistics.  Jens, what do you think?

>>> Then we can patches do disable the reiserfs barrier "optimization" as
>>> the very first one, and DM/MD support which I'm currently working on
>>> as the last one and we can start doing the heavy testing.
>>
>> Oops, I've already converted loop, virtio_blk/lguest and am working on
>> md/dm right now too.  I'm almost done with md and now doing dm. :-)
>> Maybe we should post them right now so that we don't waste too much
>> time trying to solve the same problems?
> 
> Here's the dm patch.  It only handles normal bio based dm yet, which
> I understand and can test.  request  based dm (multipath) still needs
> work.

Here's the combined patch I've been working on.  I've verified loop
and virtio_blk/loop.  I just (like five mins ago) got dm/dm conversion
compiling, so I'm sure they're broken.  The neat part is that thanks
to the separation between REQ_FLUSH and FUA handling, bio mangling
drivers only have to sequence the pre-flush and pass FUA directly to
lower layers which in many cases saves an array-wide cache flush
cycle.

After getting this patch working, the only remaining bits would be
blktrace and drdb.

Thanks.

 Documentation/lguest/lguest.c   |   36 +++-----
 drivers/block/loop.c            |   18 ++--
 drivers/block/virtio_blk.c      |   26 ++---
 drivers/md/dm-io.c              |   20 ----
 drivers/md/dm-log.c             |    2
 drivers/md/dm-raid1.c           |    8 -
 drivers/md/dm-snap-persistent.c |    2
 drivers/md/dm.c                 |  176 +++++++++++++++++++--------------------
 drivers/md/linear.c             |    4
 drivers/md/md.c                 |  117 +++++---------------------
 drivers/md/md.h                 |   23 +----
 drivers/md/multipath.c          |    4
 drivers/md/raid0.c              |    4
 drivers/md/raid1.c              |  178 +++++++++++++---------------------------
 drivers/md/raid1.h              |    2
 drivers/md/raid10.c             |    6 -
 drivers/md/raid5.c              |   18 +---
 include/linux/virtio_blk.h      |    6 +
 18 files changed, 244 insertions(+), 406 deletions(-)

Index: block/drivers/block/loop.c
===================================================================
--- block.orig/drivers/block/loop.c
+++ block/drivers/block/loop.c
@@ -477,17 +477,17 @@ static int do_bio_filebacked(struct loop
 	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;

 	if (bio_rw(bio) == WRITE) {
-		bool barrier = (bio->bi_rw & REQ_HARDBARRIER);
 		struct file *file = lo->lo_backing_file;

-		if (barrier) {
-			if (unlikely(!file->f_op->fsync)) {
-				ret = -EOPNOTSUPP;
-				goto out;
-			}
+		/* REQ_HARDBARRIER is deprecated */
+		if (bio->bi_rw & REQ_HARDBARRIER) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}

+		if (bio->bi_rw & REQ_FLUSH) {
 			ret = vfs_fsync(file, 0);
-			if (unlikely(ret)) {
+			if (unlikely(ret && ret != -EINVAL)) {
 				ret = -EIO;
 				goto out;
 			}
@@ -495,9 +495,9 @@ static int do_bio_filebacked(struct loop

 		ret = lo_send(lo, bio, pos);

-		if (barrier && !ret) {
+		if ((bio->bi_rw & REQ_FUA) && !ret) {
 			ret = vfs_fsync(file, 0);
-			if (unlikely(ret))
+			if (unlikely(ret && ret != -EINVAL))
 				ret = -EIO;
 		}
 	} else
Index: block/drivers/block/virtio_blk.c
===================================================================
--- block.orig/drivers/block/virtio_blk.c
+++ block/drivers/block/virtio_blk.c
@@ -128,9 +128,6 @@ static bool do_req(struct request_queue
 		}
 	}

-	if (vbr->req->cmd_flags & REQ_HARDBARRIER)
-		vbr->out_hdr.type |= VIRTIO_BLK_T_BARRIER;
-
 	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));

 	/*
@@ -157,6 +154,8 @@ static bool do_req(struct request_queue
 		if (rq_data_dir(vbr->req) == WRITE) {
 			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
 			out += num;
+			if (req->cmd_flags & REQ_FUA)
+				vbr->out_hdr.type |= VIRTIO_BLK_T_FUA;
 		} else {
 			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
 			in += num;
@@ -307,6 +306,7 @@ static int __devinit virtblk_probe(struc
 {
 	struct virtio_blk *vblk;
 	struct request_queue *q;
+	unsigned int flush;
 	int err;
 	u64 cap;
 	u32 v, blk_size, sg_elems, opt_io_size;
@@ -388,15 +388,13 @@ static int __devinit virtblk_probe(struc
 	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;

-	/*
-	 * If the FLUSH feature is supported we do have support for
-	 * flushing a volatile write cache on the host.  Use that to
-	 * implement write barrier support; otherwise, we must assume
-	 * that the host does not perform any kind of volatile write
-	 * caching.
-	 */
+	/* configure queue flush support */
+	flush = 0;
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
-		blk_queue_flush(q, REQ_FLUSH);
+		flush |= REQ_FLUSH;
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FUA))
+		flush |= REQ_FUA;
+	blk_queue_flush(q, flush);

 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
@@ -515,9 +513,9 @@ static const struct virtio_device_id id_
 };

 static unsigned int features[] = {
-	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
-	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
-	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
+	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
+	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
+	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_FUA,
 };

 /*
Index: block/include/linux/virtio_blk.h
===================================================================
--- block.orig/include/linux/virtio_blk.h
+++ block/include/linux/virtio_blk.h
@@ -16,6 +16,7 @@
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
 #define VIRTIO_BLK_F_FLUSH	9	/* Cache flush command support */
 #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
+#define VIRTIO_BLK_F_FUA	11	/* Forced Unit Access write support */

 #define VIRTIO_BLK_ID_BYTES	20	/* ID string length */

@@ -70,7 +71,10 @@ struct virtio_blk_config {
 #define VIRTIO_BLK_T_FLUSH	4

 /* Get device ID command */
-#define VIRTIO_BLK_T_GET_ID    8
+#define VIRTIO_BLK_T_GET_ID	8
+
+/* FUA command */
+#define VIRTIO_BLK_T_FUA	16

 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
Index: block/Documentation/lguest/lguest.c
===================================================================
--- block.orig/Documentation/lguest/lguest.c
+++ block/Documentation/lguest/lguest.c
@@ -1639,15 +1639,6 @@ static void blk_request(struct virtqueue
 	off = out->sector * 512;

 	/*
-	 * The block device implements "barriers", where the Guest indicates
-	 * that it wants all previous writes to occur before this write.  We
-	 * don't have a way of asking our kernel to do a barrier, so we just
-	 * synchronize all the data in the file.  Pretty poor, no?
-	 */
-	if (out->type & VIRTIO_BLK_T_BARRIER)
-		fdatasync(vblk->fd);
-
-	/*
 	 * In general the virtio block driver is allowed to try SCSI commands.
 	 * It'd be nice if we supported eject, for example, but we don't.
 	 */
@@ -1679,6 +1670,19 @@ static void blk_request(struct virtqueue
 			/* Die, bad Guest, die. */
 			errx(1, "Write past end %llu+%u", off, ret);
 		}
+
+		/* Honor FUA by syncing everything. */
+		if (ret >= 0 && (out->type & VIRTIO_BLK_T_FUA)) {
+			ret = fdatasync(vblk->fd);
+			verbose("FUA fdatasync: %i\n", ret);
+		}
+
+		wlen = sizeof(*in);
+		*in = (ret >= 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR);
+	} else if (out->type & VIRTIO_BLK_T_FLUSH) {
+		/* Flush */
+		ret = fdatasync(vblk->fd);
+		verbose("FLUSH fdatasync: %i\n", ret);
 		wlen = sizeof(*in);
 		*in = (ret >= 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR);
 	} else {
@@ -1702,15 +1706,6 @@ static void blk_request(struct virtqueue
 		}
 	}

-	/*
-	 * OK, so we noted that it was pretty poor to use an fdatasync as a
-	 * barrier.  But Christoph Hellwig points out that we need a sync
-	 * *afterwards* as well: "Barriers specify no reordering to the front
-	 * or the back."  And Jens Axboe confirmed it, so here we are:
-	 */
-	if (out->type & VIRTIO_BLK_T_BARRIER)
-		fdatasync(vblk->fd);
-
 	/* Finished that request. */
 	add_used(vq, head, wlen);
 }
@@ -1735,8 +1730,9 @@ static void setup_block_file(const char
 	vblk->fd = open_or_die(filename, O_RDWR|O_LARGEFILE);
 	vblk->len = lseek64(vblk->fd, 0, SEEK_END);

-	/* We support barriers. */
-	add_feature(dev, VIRTIO_BLK_F_BARRIER);
+	/* We support FLUSH and FUA. */
+	add_feature(dev, VIRTIO_BLK_F_FLUSH);
+	add_feature(dev, VIRTIO_BLK_F_FUA);

 	/* Tell Guest how many sectors this device has. */
 	conf.capacity = cpu_to_le64(vblk->len / 512);
Index: block/drivers/md/linear.c
===================================================================
--- block.orig/drivers/md/linear.c
+++ block/drivers/md/linear.c
@@ -294,8 +294,8 @@ static int linear_make_request (mddev_t
 	dev_info_t *tmp_dev;
 	sector_t start_sector;

-	if (unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
-		md_barrier_request(mddev, bio);
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
 		return 0;
 	}

Index: block/drivers/md/md.c
===================================================================
--- block.orig/drivers/md/md.c
+++ block/drivers/md/md.c
@@ -226,12 +226,12 @@ static int md_make_request(struct reques
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

@@ -330,60 +319,56 @@ static void submit_barriers(mddev_t *mdd
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
@@ -642,31 +627,6 @@ static void super_written(struct bio *bi
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
@@ -675,51 +635,28 @@ void md_super_write(mddev_t *mddev, mdk_
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
@@ -1016,7 +953,6 @@ static int super_90_validate(mddev_t *md
 	clear_bit(Faulty, &rdev->flags);
 	clear_bit(In_sync, &rdev->flags);
 	clear_bit(WriteMostly, &rdev->flags);
-	clear_bit(BarriersNotsupp, &rdev->flags);

 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 0;
@@ -1431,7 +1367,6 @@ static int super_1_validate(mddev_t *mdd
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
Index: block/drivers/md/md.h
===================================================================
--- block.orig/drivers/md/md.h
+++ block/drivers/md/md.h
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


@@ -458,7 +447,7 @@ extern void md_done_sync(mddev_t *mddev,
 extern void md_error(mddev_t *mddev, mdk_rdev_t *rdev);

 extern int mddev_congested(mddev_t *mddev, int bits);
-extern void md_barrier_request(mddev_t *mddev, struct bio *bio);
+extern void md_flush_request(mddev_t *mddev, struct bio *bio);
 extern void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 			   sector_t sector, int size, struct page *page);
 extern void md_super_wait(mddev_t *mddev);
Index: block/drivers/md/raid0.c
===================================================================
--- block.orig/drivers/md/raid0.c
+++ block/drivers/md/raid0.c
@@ -483,8 +483,8 @@ static int raid0_make_request(mddev_t *m
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;

-	if (unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
-		md_barrier_request(mddev, bio);
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
 		return 0;
 	}

Index: block/drivers/md/raid1.c
===================================================================
--- block.orig/drivers/md/raid1.c
+++ block/drivers/md/raid1.c
@@ -319,83 +319,74 @@ static void raid1_end_write_request(stru
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
+		set_bit(R1BIO_Uptodate, &r1_bio->state);
+
+	update_head_pos(mirror, r1_bio);

-		update_head_pos(mirror, r1_bio);
+	if (behind) {
+		if (test_bit(WriteMostly, &conf->mirrors[mirror].rdev->flags))
+			atomic_dec(&r1_bio->behind_remaining);

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
-		}
+		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
+			/* free extra copy of the data pages */
+			int i = bio->bi_vcnt;
+			while (i--)
+				safe_put_page(bio->bi_io_vec[i].bv_page);
+		}
+		/* clear the bitmap if all writes complete successfully */
+		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
+				r1_bio->sectors,
+				!test_bit(R1BIO_Degraded, &r1_bio->state),
+				behind);
+		md_write_end(r1_bio->mddev);
+		raid_end_bio_io(r1_bio);
 	}

 	if (to_put)
@@ -787,17 +778,14 @@ static int make_request(mddev_t *mddev,
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
-	const bool do_sync = (bio->bi_rw & REQ_SYNC);
-	bool do_barriers;
+	const unsigned int do_sync = (bio->bi_rw & REQ_SYNC);
+	const unsigned int do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	mdk_rdev_t *blocked_rdev;

 	/*
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
-	 * We test barriers_work *after* md_write_start as md_write_start
-	 * may cause the first superblock write, and that will check out
-	 * if barriers work.
 	 */

 	md_write_start(mddev, bio); /* wait on superblock update early */
@@ -821,13 +809,6 @@ static int make_request(mddev_t *mddev,
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

@@ -877,7 +858,7 @@ static int make_request(mddev_t *mddev,
 		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
-		read_bio->bi_rw = READ | do_sync;
+		read_bio->bi_rw = READ | do_sync | do_flush_fua;
 		read_bio->bi_private = r1_bio;

 		generic_make_request(read_bio);
@@ -959,10 +940,6 @@ static int make_request(mddev_t *mddev,
 	atomic_set(&r1_bio->remaining, 0);
 	atomic_set(&r1_bio->behind_remaining, 0);

-	do_barriers = bio->bi_rw & REQ_HARDBARRIER;
-	if (do_barriers)
-		set_bit(R1BIO_Barrier, &r1_bio->state);
-
 	bio_list_init(&bl);
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
@@ -975,7 +952,7 @@ static int make_request(mddev_t *mddev,
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_barriers | do_sync;
+		mbio->bi_rw = WRITE | do_sync;
 		mbio->bi_private = r1_bio;

 		if (behind_pages) {
@@ -1631,41 +1608,6 @@ static void raid1d(mddev_t *mddev)
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

Index: block/drivers/md/raid1.h
===================================================================
--- block.orig/drivers/md/raid1.h
+++ block/drivers/md/raid1.h
@@ -117,8 +117,6 @@ struct r1bio_s {
 #define	R1BIO_IsSync	1
 #define	R1BIO_Degraded	2
 #define	R1BIO_BehindIO	3
-#define	R1BIO_Barrier	4
-#define R1BIO_BarrierRetry 5
 /* For write-behind requests, we call bi_end_io when
  * the last non-write-behind device completes, providing
  * any write was successful.  Otherwise we call when
Index: block/drivers/md/raid5.c
===================================================================
--- block.orig/drivers/md/raid5.c
+++ block/drivers/md/raid5.c
@@ -3278,7 +3278,7 @@ static void handle_stripe5(struct stripe

 	if (dec_preread_active) {
 		/* We delay this until after ops_run_io so that if make_request
-		 * is waiting on a barrier, it won't continue until the writes
+		 * is waiting on a flush, it won't continue until the writes
 		 * have actually been submitted.
 		 */
 		atomic_dec(&conf->preread_active_stripes);
@@ -3580,7 +3580,7 @@ static void handle_stripe6(struct stripe

 	if (dec_preread_active) {
 		/* We delay this until after ops_run_io so that if make_request
-		 * is waiting on a barrier, it won't continue until the writes
+		 * is waiting on a flush, it won't continue until the writes
 		 * have actually been submitted.
 		 */
 		atomic_dec(&conf->preread_active_stripes);
@@ -3958,14 +3958,8 @@ static int make_request(mddev_t *mddev,
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

@@ -4083,7 +4077,7 @@ static int make_request(mddev_t *mddev,
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if (mddev->barrier &&
+			if (mddev->flush_bio &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe(sh);
@@ -4106,7 +4100,7 @@ static int make_request(mddev_t *mddev,
 		bio_endio(bi, 0);
 	}

-	if (mddev->barrier) {
+	if (mddev->flush_bio) {
 		/* We need to wait for the stripes to all be handled.
 		 * So: wait for preread_active_stripes to drop to 0.
 		 */
Index: block/drivers/md/multipath.c
===================================================================
--- block.orig/drivers/md/multipath.c
+++ block/drivers/md/multipath.c
@@ -142,8 +142,8 @@ static int multipath_make_request(mddev_
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;

-	if (unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
-		md_barrier_request(mddev, bio);
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
 		return 0;
 	}

Index: block/drivers/md/raid10.c
===================================================================
--- block.orig/drivers/md/raid10.c
+++ block/drivers/md/raid10.c
@@ -799,13 +799,13 @@ static int make_request(mddev_t *mddev,
 	int i;
 	int chunk_sects = conf->chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
-	const bool do_sync = (bio->bi_rw & REQ_SYNC);
+	const unsigned int do_sync = (bio->bi_rw & REQ_SYNC);
 	struct bio_list bl;
 	unsigned long flags;
 	mdk_rdev_t *blocked_rdev;

-	if (unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
-		md_barrier_request(mddev, bio);
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
 		return 0;
 	}

Index: block/drivers/md/dm-io.c
===================================================================
--- block.orig/drivers/md/dm-io.c
+++ block/drivers/md/dm-io.c
@@ -31,7 +31,6 @@ struct dm_io_client {
  */
 struct io {
 	unsigned long error_bits;
-	unsigned long eopnotsupp_bits;
 	atomic_t count;
 	struct task_struct *sleeper;
 	struct dm_io_client *client;
@@ -130,11 +129,8 @@ static void retrieve_io_and_region_from_
  *---------------------------------------------------------------*/
 static void dec_count(struct io *io, unsigned int region, int error)
 {
-	if (error) {
+	if (error)
 		set_bit(region, &io->error_bits);
-		if (error == -EOPNOTSUPP)
-			set_bit(region, &io->eopnotsupp_bits);
-	}

 	if (atomic_dec_and_test(&io->count)) {
 		if (io->sleeper)
@@ -310,8 +306,8 @@ static void do_region(int rw, unsigned r
 	sector_t remaining = where->count;

 	/*
-	 * where->count may be zero if rw holds a write barrier and we
-	 * need to send a zero-sized barrier.
+	 * where->count may be zero if rw holds a flush and we need to
+	 * send a zero-sized flush.
 	 */
 	do {
 		/*
@@ -364,7 +360,7 @@ static void dispatch_io(int rw, unsigned
 	 */
 	for (i = 0; i < num_regions; i++) {
 		*dp = old_pages;
-		if (where[i].count || (rw & REQ_HARDBARRIER))
+		if (where[i].count || (rw & REQ_FLUSH))
 			do_region(rw, i, where + i, dp, io);
 	}

@@ -393,9 +389,7 @@ static int sync_io(struct dm_io_client *
 		return -EIO;
 	}

-retry:
 	io->error_bits = 0;
-	io->eopnotsupp_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->sleeper = current;
 	io->client = client;
@@ -412,11 +406,6 @@ retry:
 	}
 	set_current_state(TASK_RUNNING);

-	if (io->eopnotsupp_bits && (rw & REQ_HARDBARRIER)) {
-		rw &= ~REQ_HARDBARRIER;
-		goto retry;
-	}
-
 	if (error_bits)
 		*error_bits = io->error_bits;

@@ -437,7 +426,6 @@ static int async_io(struct dm_io_client

 	io = mempool_alloc(client->pool, GFP_NOIO);
 	io->error_bits = 0;
-	io->eopnotsupp_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->sleeper = NULL;
 	io->client = client;
Index: block/drivers/md/dm-raid1.c
===================================================================
--- block.orig/drivers/md/dm-raid1.c
+++ block/drivers/md/dm-raid1.c
@@ -259,7 +259,7 @@ static int mirror_flush(struct dm_target
 	struct dm_io_region io[ms->nr_mirrors];
 	struct mirror *m;
 	struct dm_io_request io_req = {
-		.bi_rw = WRITE_BARRIER,
+		.bi_rw = WRITE_FLUSH,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.bvec = NULL,
 		.client = ms->io_client,
@@ -629,7 +629,7 @@ static void do_write(struct mirror_set *
 	struct dm_io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 	struct dm_io_request io_req = {
-		.bi_rw = WRITE | (bio->bi_rw & WRITE_BARRIER),
+		.bi_rw = WRITE | (bio->bi_rw & (WRITE_FLUSH | WRITE_FUA)),
 		.mem.type = DM_IO_BVEC,
 		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
 		.notify.fn = write_callback,
@@ -670,7 +670,7 @@ static void do_writes(struct mirror_set
 	bio_list_init(&requeue);

 	while ((bio = bio_list_pop(writes))) {
-		if (unlikely(bio_empty_barrier(bio))) {
+		if ((bio->bi_rw & REQ_FLUSH) && !bio_has_data(bio)) {
 			bio_list_add(&sync, bio);
 			continue;
 		}
@@ -1203,7 +1203,7 @@ static int mirror_end_io(struct dm_targe
 	 * We need to dec pending if this was a write.
 	 */
 	if (rw == WRITE) {
-		if (likely(!bio_empty_barrier(bio)))
+		if (!(bio->bi_rw & REQ_FLUSH) || bio_has_data(bio))
 			dm_rh_dec(ms->rh, map_context->ll);
 		return error;
 	}
Index: block/drivers/md/dm.c
===================================================================
--- block.orig/drivers/md/dm.c
+++ block/drivers/md/dm.c
@@ -139,21 +139,21 @@ struct mapped_device {
 	spinlock_t deferred_lock;

 	/*
-	 * An error from the barrier request currently being processed.
+	 * An error from the flush request currently being processed.
 	 */
-	int barrier_error;
+	int flush_error;

 	/*
-	 * Protect barrier_error from concurrent endio processing
+	 * Protect flush_error from concurrent endio processing
 	 * in request-based dm.
 	 */
-	spinlock_t barrier_error_lock;
+	spinlock_t flush_error_lock;

 	/*
-	 * Processing queue (flush/barriers)
+	 * Processing queue (flush)
 	 */
 	struct workqueue_struct *wq;
-	struct work_struct barrier_work;
+	struct work_struct flush_work;

 	/* A pointer to the currently processing pre/post flush request */
 	struct request *flush_request;
@@ -195,8 +195,8 @@ struct mapped_device {
 	/* sysfs handle */
 	struct kobject kobj;

-	/* zero-length barrier that will be cloned and submitted to targets */
-	struct bio barrier_bio;
+	/* zero-length flush that will be cloned and submitted to targets */
+	struct bio flush_bio;
 };

 /*
@@ -507,7 +507,7 @@ static void end_io_acct(struct dm_io *io

 	/*
 	 * After this is decremented the bio must not be touched if it is
-	 * a barrier.
+	 * a flush.
 	 */
 	dm_disk(md)->part0.in_flight[rw] = pending =
 		atomic_dec_return(&md->pending[rw]);
@@ -621,7 +621,7 @@ static void dec_pending(struct dm_io *io
 			 */
 			spin_lock_irqsave(&md->deferred_lock, flags);
 			if (__noflush_suspending(md)) {
-				if (!(io->bio->bi_rw & REQ_HARDBARRIER))
+				if (!(io->bio->bi_rw & REQ_FLUSH))
 					bio_list_add_head(&md->deferred,
 							  io->bio);
 			} else
@@ -633,14 +633,14 @@ static void dec_pending(struct dm_io *io
 		io_error = io->error;
 		bio = io->bio;

-		if (bio->bi_rw & REQ_HARDBARRIER) {
+		if (bio->bi_rw & REQ_FLUSH) {
 			/*
-			 * There can be just one barrier request so we use
+			 * There can be just one flush request so we use
 			 * a per-device variable for error reporting.
 			 * Note that you can't touch the bio after end_io_acct
 			 */
-			if (!md->barrier_error && io_error != -EOPNOTSUPP)
-				md->barrier_error = io_error;
+			if (!md->flush_error)
+				md->flush_error = io_error;
 			end_io_acct(io);
 			free_io(md, io);
 		} else {
@@ -744,21 +744,18 @@ static void end_clone_bio(struct bio *cl
 	blk_update_request(tio->orig, 0, nr_bytes);
 }

-static void store_barrier_error(struct mapped_device *md, int error)
+static void store_flush_error(struct mapped_device *md, int error)
 {
 	unsigned long flags;

-	spin_lock_irqsave(&md->barrier_error_lock, flags);
+	spin_lock_irqsave(&md->flush_error_lock, flags);
 	/*
-	 * Basically, the first error is taken, but:
-	 *   -EOPNOTSUPP supersedes any I/O error.
-	 *   Requeue request supersedes any I/O error but -EOPNOTSUPP.
-	 */
-	if (!md->barrier_error || error == -EOPNOTSUPP ||
-	    (md->barrier_error != -EOPNOTSUPP &&
-	     error == DM_ENDIO_REQUEUE))
-		md->barrier_error = error;
-	spin_unlock_irqrestore(&md->barrier_error_lock, flags);
+	 * Basically, the first error is taken, but requeue request
+	 * supersedes any I/O error.
+	 */
+	if (!md->flush_error || error == DM_ENDIO_REQUEUE)
+		md->flush_error = error;
+	spin_unlock_irqrestore(&md->flush_error_lock, flags);
 }

 /*
@@ -799,12 +796,12 @@ static void dm_end_request(struct reques
 {
 	int rw = rq_data_dir(clone);
 	int run_queue = 1;
-	bool is_barrier = clone->cmd_flags & REQ_HARDBARRIER;
+	bool is_flush = clone->cmd_flags & REQ_FLUSH;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;

-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && !is_barrier) {
+	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && !is_flush) {
 		rq->errors = clone->errors;
 		rq->resid_len = clone->resid_len;

@@ -819,12 +816,13 @@ static void dm_end_request(struct reques

 	free_rq_clone(clone);

-	if (unlikely(is_barrier)) {
+	if (!is_flush)
+		blk_end_request_all(rq, error);
+	else {
 		if (unlikely(error))
-			store_barrier_error(md, error);
+			store_flush_error(md, error);
 		run_queue = 0;
-	} else
-		blk_end_request_all(rq, error);
+	}

 	rq_completed(md, rw, run_queue);
 }
@@ -851,9 +849,9 @@ void dm_requeue_unmapped_request(struct
 	struct request_queue *q = rq->q;
 	unsigned long flags;

-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
+	if (clone->cmd_flags & REQ_FLUSH) {
 		/*
-		 * Barrier clones share an original request.
+		 * Flush clones share an original request.
 		 * Leave it to dm_end_request(), which handles this special
 		 * case.
 		 */
@@ -950,14 +948,14 @@ static void dm_complete_request(struct r
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;

-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
+	if (clone->cmd_flags & REQ_FLUSH) {
 		/*
-		 * Barrier clones share an original request.  So can't use
+		 * Flush clones share an original request.  So can't use
 		 * softirq_done with the original.
 		 * Pass the clone to dm_done() directly in this special case.
 		 * It is safe (even if clone->q->queue_lock is held here)
 		 * because there is no I/O dispatching during the completion
-		 * of barrier clone.
+		 * of flush clone.
 		 */
 		dm_done(clone, error, true);
 		return;
@@ -979,9 +977,9 @@ void dm_kill_unmapped_request(struct req
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;

-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
+	if (clone->cmd_flags & REQ_FLUSH) {
 		/*
-		 * Barrier clones share an original request.
+		 * Flush clones share an original request.
 		 * Leave it to dm_end_request(), which handles this special
 		 * case.
 		 */
@@ -1098,7 +1096,7 @@ static void dm_bio_destructor(struct bio
 }

 /*
- * Creates a little bio that is just does part of a bvec.
+ * Creates a little bio that is just a part of a bvec.
  */
 static struct bio *split_bvec(struct bio *bio, sector_t sector,
 			      unsigned short idx, unsigned int offset,
@@ -1113,7 +1111,7 @@ static struct bio *split_bvec(struct bio

 	clone->bi_sector = sector;
 	clone->bi_bdev = bio->bi_bdev;
-	clone->bi_rw = bio->bi_rw & ~REQ_HARDBARRIER;
+	clone->bi_rw = bio->bi_rw;
 	clone->bi_vcnt = 1;
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
@@ -1140,7 +1138,6 @@ static struct bio *clone_bio(struct bio

 	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
 	__bio_clone(clone, bio);
-	clone->bi_rw &= ~REQ_HARDBARRIER;
 	clone->bi_destructor = dm_bio_destructor;
 	clone->bi_sector = sector;
 	clone->bi_idx = idx;
@@ -1186,7 +1183,7 @@ static void __flush_target(struct clone_
 	__map_bio(ti, clone, tio);
 }

-static int __clone_and_map_empty_barrier(struct clone_info *ci)
+static int __clone_and_map_flush(struct clone_info *ci)
 {
 	unsigned target_nr = 0, flush_nr;
 	struct dm_target *ti;
@@ -1208,9 +1205,6 @@ static int __clone_and_map(struct clone_
 	sector_t len = 0, max;
 	struct dm_target_io *tio;

-	if (unlikely(bio_empty_barrier(bio)))
-		return __clone_and_map_empty_barrier(ci);
-
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
 		return -EIO;
@@ -1308,11 +1302,11 @@ static void __split_and_process_bio(stru

 	ci.map = dm_get_live_table(md);
 	if (unlikely(!ci.map)) {
-		if (!(bio->bi_rw & REQ_HARDBARRIER))
+		if (!(bio->bi_rw & REQ_FLUSH))
 			bio_io_error(bio);
 		else
-			if (!md->barrier_error)
-				md->barrier_error = -EIO;
+			if (!md->flush_error)
+				md->flush_error = -EIO;
 		return;
 	}

@@ -1325,14 +1319,22 @@ static void __split_and_process_bio(stru
 	ci.io->md = md;
 	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_sector;
-	ci.sector_count = bio_sectors(bio);
-	if (unlikely(bio_empty_barrier(bio)))
+	if (!(bio->bi_rw & REQ_FLUSH))
+		ci.sector_count = bio_sectors(bio);
+	else {
+		/* FLUSH bio reaching here should all be empty */
+		WARN_ON_ONCE(bio_has_data(bio));
 		ci.sector_count = 1;
+	}
 	ci.idx = bio->bi_idx;

 	start_io_acct(ci.io);
-	while (ci.sector_count && !error)
-		error = __clone_and_map(&ci);
+	while (ci.sector_count && !error) {
+		if (!(bio->bi_rw & REQ_FLUSH))
+			error = __clone_and_map(&ci);
+		else
+			error = __clone_and_map_flush(&ci);
+	}

 	/* drop the extra reference count */
 	dec_pending(ci.io, error);
@@ -1417,11 +1419,11 @@ static int _dm_request(struct request_qu
 	part_stat_unlock();

 	/*
-	 * If we're suspended or the thread is processing barriers
+	 * If we're suspended or the thread is processing flushes
 	 * we have to queue this io for later.
 	 */
 	if (unlikely(test_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags)) ||
-	    unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
+	    (bio->bi_rw & REQ_FLUSH)) {
 		up_read(&md->io_lock);

 		if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) &&
@@ -1464,10 +1466,7 @@ static int dm_request(struct request_que

 static bool dm_rq_is_flush_request(struct request *rq)
 {
-	if (rq->cmd_flags & REQ_FLUSH)
-		return true;
-	else
-		return false;
+	return rq->cmd_flags & REQ_FLUSH;
 }

 void dm_dispatch_request(struct request *rq)
@@ -1520,7 +1519,7 @@ static int setup_clone(struct request *c
 	if (dm_rq_is_flush_request(rq)) {
 		blk_rq_init(NULL, clone);
 		clone->cmd_type = REQ_TYPE_FS;
-		clone->cmd_flags |= (REQ_HARDBARRIER | WRITE);
+		clone->cmd_flags |= (REQ_FLUSH | WRITE);
 	} else {
 		r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
 				      dm_rq_bio_constructor, tio);
@@ -1668,7 +1667,7 @@ static void dm_request_fn(struct request
 			BUG_ON(md->flush_request);
 			md->flush_request = rq;
 			blk_start_request(rq);
-			queue_work(md->wq, &md->barrier_work);
+			queue_work(md->wq, &md->flush_work);
 			goto out;
 		}

@@ -1843,7 +1842,7 @@ out:
 static const struct block_device_operations dm_blk_dops;

 static void dm_wq_work(struct work_struct *work);
-static void dm_rq_barrier_work(struct work_struct *work);
+static void dm_rq_flush_work(struct work_struct *work);

 /*
  * Allocate and initialise a blank device with a given minor.
@@ -1873,7 +1872,7 @@ static struct mapped_device *alloc_dev(i
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
 	spin_lock_init(&md->deferred_lock);
-	spin_lock_init(&md->barrier_error_lock);
+	spin_lock_init(&md->flush_error_lock);
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
@@ -1918,7 +1917,7 @@ static struct mapped_device *alloc_dev(i
 	atomic_set(&md->pending[1], 0);
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
-	INIT_WORK(&md->barrier_work, dm_rq_barrier_work);
+	INIT_WORK(&md->flush_work, dm_rq_flush_work);
 	init_waitqueue_head(&md->eventq);

 	md->disk->major = _major;
@@ -2233,31 +2232,28 @@ static int dm_wait_for_completion(struct
 	return r;
 }

-static void dm_flush(struct mapped_device *md)
+static void process_flush(struct mapped_device *md, struct bio *bio)
 {
+	md->flush_error = 0;
+
+	/* handle REQ_FLUSH */
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);

-	bio_init(&md->barrier_bio);
-	md->barrier_bio.bi_bdev = md->bdev;
-	md->barrier_bio.bi_rw = WRITE_BARRIER;
-	__split_and_process_bio(md, &md->barrier_bio);
+	bio_init(&md->flush_bio);
+	md->flush_bio.bi_bdev = md->bdev;
+	md->flush_bio.bi_rw = WRITE_FLUSH;
+	__split_and_process_bio(md, &md->flush_bio);

 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-}
-
-static void process_barrier(struct mapped_device *md, struct bio *bio)
-{
-	md->barrier_error = 0;

-	dm_flush(md);
+	bio->bi_rw &= ~REQ_FLUSH;

-	if (!bio_empty_barrier(bio)) {
+	/* handle data + REQ_FUA */
+	if (bio_has_data(bio))
 		__split_and_process_bio(md, bio);
-		dm_flush(md);
-	}

-	if (md->barrier_error != DM_ENDIO_REQUEUE)
-		bio_endio(bio, md->barrier_error);
+	if (md->flush_error != DM_ENDIO_REQUEUE)
+		bio_endio(bio, md->flush_error);
 	else {
 		spin_lock_irq(&md->deferred_lock);
 		bio_list_add_head(&md->deferred, bio);
@@ -2291,8 +2287,8 @@ static void dm_wq_work(struct work_struc
 		if (dm_request_based(md))
 			generic_make_request(c);
 		else {
-			if (c->bi_rw & REQ_HARDBARRIER)
-				process_barrier(md, c);
+			if (c->bi_rw & REQ_FLUSH)
+				process_flush(md, c);
 			else
 				__split_and_process_bio(md, c);
 		}
@@ -2317,8 +2313,8 @@ static void dm_rq_set_flush_nr(struct re
 	tio->info.flush_request = flush_nr;
 }

-/* Issue barrier requests to targets and wait for their completion. */
-static int dm_rq_barrier(struct mapped_device *md)
+/* Issue flush requests to targets and wait for their completion. */
+static int dm_rq_flush(struct mapped_device *md)
 {
 	int i, j;
 	struct dm_table *map = dm_get_live_table(md);
@@ -2326,7 +2322,7 @@ static int dm_rq_barrier(struct mapped_d
 	struct dm_target *ti;
 	struct request *clone;

-	md->barrier_error = 0;
+	md->flush_error = 0;

 	for (i = 0; i < num_targets; i++) {
 		ti = dm_table_get_target(map, i);
@@ -2341,26 +2337,26 @@ static int dm_rq_barrier(struct mapped_d
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
 	dm_table_put(map);

-	return md->barrier_error;
+	return md->flush_error;
 }

-static void dm_rq_barrier_work(struct work_struct *work)
+static void dm_rq_flush_work(struct work_struct *work)
 {
 	int error;
 	struct mapped_device *md = container_of(work, struct mapped_device,
-						barrier_work);
+						flush_work);
 	struct request_queue *q = md->queue;
 	struct request *rq;
 	unsigned long flags;

 	/*
 	 * Hold the md reference here and leave it at the last part so that
-	 * the md can't be deleted by device opener when the barrier request
+	 * the md can't be deleted by device opener when the flush request
 	 * completes.
 	 */
 	dm_get(md);

-	error = dm_rq_barrier(md);
+	error = dm_rq_flush(md);

 	rq = md->flush_request;
 	md->flush_request = NULL;
@@ -2520,7 +2516,7 @@ int dm_suspend(struct mapped_device *md,
 	up_write(&md->io_lock);

 	/*
-	 * Request-based dm uses md->wq for barrier (dm_rq_barrier_work) which
+	 * Request-based dm uses md->wq for flush (dm_rq_flush_work) which
 	 * can be kicked until md->queue is stopped.  So stop md->queue before
 	 * flushing md->wq.
 	 */
Index: block/drivers/md/dm-log.c
===================================================================
--- block.orig/drivers/md/dm-log.c
+++ block/drivers/md/dm-log.c
@@ -300,7 +300,7 @@ static int flush_header(struct log_c *lc
 		.count = 0,
 	};

-	lc->io_req.bi_rw = WRITE_BARRIER;
+	lc->io_req.bi_rw = WRITE_FLUSH;

 	return dm_io(&lc->io_req, 1, &null_location, NULL);
 }
Index: block/drivers/md/dm-snap-persistent.c
===================================================================
--- block.orig/drivers/md/dm-snap-persistent.c
+++ block/drivers/md/dm-snap-persistent.c
@@ -687,7 +687,7 @@ static void persistent_commit_exception(
 	/*
 	 * Commit exceptions to disk.
 	 */
-	if (ps->valid && area_io(ps, WRITE_BARRIER))
+	if (ps->valid && area_io(ps, WRITE_FLUSH_FUA))
 		ps->valid = 0;

 	/*

-- 
tejun
