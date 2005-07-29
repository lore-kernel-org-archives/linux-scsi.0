From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC] allow bio code to unmap sg io requests and have
	blk_execute_rq_nowait bounce bios
Date: Fri, 29 Jul 2005 04:20:00 -0500
Message-ID: <1122628800.8900.22.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:20365 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262514AbVG2JUG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 05:20:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

Hey Jens and James,

The inlined patch moves the bounce buffer handling to blk_execute_rq_nowait
so the scsi, sg io and cdrom code does not have to handle it. To accomplish
this I moved the bio_uncopy_user to a bi_end_io function and bio_unmap_user
to a work struct that is schedule from a bi_end_io functions. Did you say
you disliked the idea of calling bio_unmap_user from a work struct - don't
remember and I lost my emails when I moved? :(

In my patch there is the possiblity of pages being marked dirty after the
request has been returned to userspace instead of the pages being dirtied
before in the bio_unmap_user. Is this OK?

And, as I work on the adding of BLKERR_* error values in replacement
of the dm-multupath/bio sense patch, I was thinking about your comment
about having one true make_request function. It seems like if we extended
bios to handle more request stuff (like what is needed for SG IO) we could
just pass the bio to __make_request - with some modifications to __make_request -
instead of doing it request based and moving the blk_queue_bounce call to
blk_execute_rq_nowait  like I did in my patch. Is this what you were thinking when
adding the bio sense code?


Patch was made against James scsi-block-2.6 tree.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -2193,31 +2193,6 @@ int blk_rq_map_user_iov(request_queue_t 
 EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
- * blk_rq_unmap_user - unmap a request with user data
- * @rq:		request to be unmapped
- * @bio:	bio for the request
- * @ulen:	length of user buffer
- *
- * Description:
- *    Unmap a request previously mapped by blk_rq_map_user().
- */
-int blk_rq_unmap_user(struct bio *bio, unsigned int ulen)
-{
-	int ret = 0;
-
-	if (bio) {
-		if (bio_flagged(bio, BIO_USER_MAPPED))
-			bio_unmap_user(bio);
-		else
-			ret = bio_uncopy_user(bio);
-	}
-
-	return 0;
-}
-
-EXPORT_SYMBOL(blk_rq_unmap_user);
-
-/**
  * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
  * @q:		request queue where request should be inserted
  * @rw:		READ or WRITE data
@@ -2257,6 +2232,9 @@ void blk_execute_rq_nowait(request_queue
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
+        if (rq->bio)
+                blk_queue_bounce(q, &rq->bio);
+
 	rq->rq_disk = bd_disk;
 	rq->flags |= REQ_NOMERGE;
 	rq->end_io = done;
diff --git a/drivers/block/scsi_ioctl.c b/drivers/block/scsi_ioctl.c
--- a/drivers/block/scsi_ioctl.c
+++ b/drivers/block/scsi_ioctl.c
@@ -218,7 +218,6 @@ static int sg_io(struct file *file, requ
 	unsigned long start_time;
 	int writing = 0, ret = 0;
 	struct request *rq;
-	struct bio *bio;
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	unsigned char cmd[BLK_MAX_CDB];
 
@@ -287,14 +286,6 @@ static int sg_io(struct file *file, requ
 	rq->sense_len = 0;
 
 	rq->flags |= REQ_BLOCK_PC;
-	bio = rq->bio;
-
-	/*
-	 * bounce this after holding a reference to the original bio, it's
-	 * needed for proper unmapping
-	 */
-	if (rq->bio)
-		blk_queue_bounce(q, &rq->bio);
 
 	rq->timeout = (hdr->timeout * HZ) / 1000;
 	if (!rq->timeout)
@@ -330,9 +321,6 @@ static int sg_io(struct file *file, requ
 			hdr->sb_len_wr = len;
 	}
 
-	if (blk_rq_unmap_user(bio, hdr->dxfer_len))
-		ret = -EFAULT;
-
 	/* may not have succeeded, but output values written to control
 	 * structure (struct sg_io_hdr).  */
 out:
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2090,7 +2090,6 @@ static int cdrom_read_cdda_bpc(struct cd
 {
 	request_queue_t *q = cdi->disk->queue;
 	struct request *rq;
-	struct bio *bio;
 	unsigned int len;
 	int nr, ret = 0;
 
@@ -2131,10 +2130,6 @@ static int cdrom_read_cdda_bpc(struct cd
 		rq->cmd_len = 12;
 		rq->flags |= REQ_BLOCK_PC;
 		rq->timeout = 60 * HZ;
-		bio = rq->bio;
-
-		if (rq->bio)
-			blk_queue_bounce(q, &rq->bio);
 
 		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
 			struct request_sense *s = rq->sense;
@@ -2142,9 +2137,6 @@ static int cdrom_read_cdda_bpc(struct cd
 			cdi->last_sense = s->sense_key;
 		}
 
-		if (blk_rq_unmap_user(bio, len))
-			ret = -EFAULT;
-
 		if (ret)
 			break;
 
diff --git a/fs/bio.c b/fs/bio.c
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -432,13 +432,15 @@ static struct bio_map_data *bio_alloc_ma
 }
 
 /**
- *	bio_uncopy_user	-	finish previously mapped bio
+ *	bio_uncopy_user_endio	-	finish previously mapped bio
  *	@bio: bio being terminated
+ *	@bytes: bytes completed
+ *	@err: completion status
  *
  *	Free pages allocated from bio_copy_user() and write back data
  *	to user space in case of a read.
  */
-int bio_uncopy_user(struct bio *bio)
+static int bio_uncopy_user_endio(struct bio *bio, unsigned int bytes, int err)
 {
 	struct bio_map_data *bmd = bio->bi_private;
 	const int read = bio_data_dir(bio) == READ;
@@ -457,7 +459,7 @@ int bio_uncopy_user(struct bio *bio)
 	}
 	bio_free_map_data(bmd);
 	bio_put(bio);
-	return ret;
+	return 0;
 }
 
 /**
@@ -494,6 +496,7 @@ struct bio *bio_copy_user(request_queue_
 		goto out_bmd;
 
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
+	bio->bi_end_io = bio_uncopy_user_endio;
 
 	ret = 0;
 	while (len) {
@@ -550,6 +553,55 @@ out_bmd:
 	return ERR_PTR(ret);
 }
 
+static void __bio_unmap_user(struct bio *bio)
+{
+	struct bio_vec *bvec;
+	int i;
+
+	/*
+	 * make sure we dirty pages we wrote to
+	 */
+	__bio_for_each_segment(bvec, bio, i, 0) {
+		if (bio_data_dir(bio) == READ)
+			set_page_dirty_lock(bvec->bv_page);
+
+		page_cache_release(bvec->bv_page);
+	}
+
+	kfree(bio->bi_private);
+}
+
+/**
+ *	bio_unmap_user	-	unmap a bio
+ *	@bio:		the bio being unmapped
+ *
+ *	Unmap a bio previously mapped by bio_map_user(). Must be called with
+ *	a process context.
+ *
+ *	bio_unmap_user() may sleep.
+ */
+static void bio_unmap_user(void *data)
+{
+	struct bio *bio = data;
+
+	__bio_unmap_user(bio);
+	bio_put(bio);
+}
+
+
+static int bio_unmap_user_endio(struct bio *bio, unsigned int bytes, int err)
+{
+	struct work_struct *work;
+
+	if (bio->bi_size)
+		return 1;
+
+	work = bio->bi_private;
+	INIT_WORK(work, bio_unmap_user, bio); 
+	schedule_work(work);
+	return 0;
+}
+
 static struct bio *__bio_map_user_iov(request_queue_t *q,
 				      struct block_device *bdev,
 				      struct sg_iovec *iov, int iov_count,
@@ -557,7 +609,7 @@ static struct bio *__bio_map_user_iov(re
 {
 	int i, j;
 	int nr_pages = 0;
-	struct page **pages;
+	struct page **pages = NULL;
 	struct bio *bio;
 	int cur_page = 0;
 	int ret, offset;
@@ -585,6 +637,10 @@ static struct bio *__bio_map_user_iov(re
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
+	bio->bi_private = kmalloc(GFP_KERNEL, sizeof(struct work_struct));
+	if (!bio->bi_private)
+		goto out;
+
 	pages = kmalloc(nr_pages * sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		goto out;
@@ -645,6 +701,7 @@ static struct bio *__bio_map_user_iov(re
 	if (!write_to_vm)
 		bio->bi_rw |= (1 << BIO_RW);
 
+	bio->bi_end_io = bio_unmap_user_endio;
 	bio->bi_bdev = bdev;
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
 	return bio;
@@ -656,6 +713,7 @@ static struct bio *__bio_map_user_iov(re
 		page_cache_release(pages[i]);
 	}
  out:
+	kfree(bio->bi_private);
 	kfree(pages);
 	bio_put(bio);
 	return ERR_PTR(ret);
@@ -706,14 +764,6 @@ struct bio *bio_map_user_iov(request_que
 	if (IS_ERR(bio))
 		return bio;
 
-	/*
-	 * subtle -- if __bio_map_user() ended up bouncing a bio,
-	 * it would normally disappear when its bi_end_io is run.
-	 * however, we need it for the unmap, so grab an extra
-	 * reference to it
-	 */
-	bio_get(bio);
-
 	for (i = 0; i < iov_count; i++)
 		len += iov[i].iov_len;
 
@@ -724,43 +774,9 @@ struct bio *bio_map_user_iov(request_que
 	 * don't support partial mappings
 	 */
 	bio_endio(bio, bio->bi_size, 0);
-	bio_unmap_user(bio);
 	return ERR_PTR(-EINVAL);
 }
 
-static void __bio_unmap_user(struct bio *bio)
-{
-	struct bio_vec *bvec;
-	int i;
-
-	/*
-	 * make sure we dirty pages we wrote to
-	 */
-	__bio_for_each_segment(bvec, bio, i, 0) {
-		if (bio_data_dir(bio) == READ)
-			set_page_dirty_lock(bvec->bv_page);
-
-		page_cache_release(bvec->bv_page);
-	}
-
-	bio_put(bio);
-}
-
-/**
- *	bio_unmap_user	-	unmap a bio
- *	@bio:		the bio being unmapped
- *
- *	Unmap a bio previously mapped by bio_map_user(). Must be called with
- *	a process context.
- *
- *	bio_unmap_user() may sleep.
- */
-void bio_unmap_user(struct bio *bio)
-{
-	__bio_unmap_user(bio);
-	bio_put(bio);
-}
-
 static int bio_map_kern_endio(struct bio *bio, unsigned int bytes_done, int err)
 {
 	if (bio->bi_size)
@@ -1223,13 +1239,11 @@ EXPORT_SYMBOL(bio_hw_segments);
 EXPORT_SYMBOL(bio_add_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
 EXPORT_SYMBOL(bio_map_user);
-EXPORT_SYMBOL(bio_unmap_user);
 EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
 EXPORT_SYMBOL(bio_split_pool);
 EXPORT_SYMBOL(bio_copy_user);
-EXPORT_SYMBOL(bio_uncopy_user);
 EXPORT_SYMBOL(bioset_create);
 EXPORT_SYMBOL(bioset_free);
 EXPORT_SYMBOL(bio_alloc_bioset);
diff --git a/include/linux/bio.h b/include/linux/bio.h
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -285,13 +285,11 @@ struct sg_iovec;
 extern struct bio *bio_map_user_iov(struct request_queue *,
 				    struct block_device *,
 				    struct sg_iovec *, int, int);
-extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 				unsigned int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
-extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -553,7 +553,6 @@ extern void __blk_stop_queue(request_que
 extern void blk_run_queue(request_queue_t *);
 extern void blk_queue_activity_fn(request_queue_t *, activity_fn *, void *);
 extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned int);
-extern int blk_rq_unmap_user(struct bio *, unsigned int);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, unsigned int);
 extern int blk_rq_map_user_iov(request_queue_t *, struct request *, struct sg_iovec *, int);
 extern int blk_execute_rq(request_queue_t *, struct gendisk *,


