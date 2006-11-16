From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/8] block: support larger block pc requests
Date: Thu, 16 Nov 2006 19:24:07 +0900
Message-ID: <20061116192407R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:60391 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1423648AbWKPKZQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 05:25:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

This patch modifies blk_rq_map/unmap_user() and the cdrom and scsi_ioctl.c
users so that it supports requests larger than bio by chaining them together.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/ll_rw_blk.c      |  166 ++++++++++++++++++++++++++++++++++++------------
 block/scsi_ioctl.c     |   53 ++++++++--------
 drivers/cdrom/cdrom.c  |    6 +-
 fs/bio.c               |   18 +-----
 include/linux/blkdev.h |    7 +-
 5 files changed, 160 insertions(+), 90 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 9eaee66..0f82e12 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2322,6 +2322,84 @@ void blk_insert_request(request_queue_t
 
 EXPORT_SYMBOL(blk_insert_request);
 
+static int __blk_rq_unmap_user(struct bio *bio)
+{
+	int ret = 0;
+
+	if (bio) {
+		if (bio_flagged(bio, BIO_USER_MAPPED))
+			bio_unmap_user(bio);
+		else
+			ret = bio_uncopy_user(bio);
+	}
+
+	return ret;
+}
+
+static int __blk_rq_map_user(request_queue_t *q, struct request *rq,
+			     void __user *ubuf, unsigned int len)
+{
+	unsigned long uaddr;
+	struct bio *bio, *orig_bio;
+	int reading, ret;
+
+	reading = rq_data_dir(rq) == READ;
+
+	/*
+	 * if alignment requirement is satisfied, map in user pages for
+	 * direct dma. else, set up kernel bounce buffers
+	 */
+	uaddr = (unsigned long) ubuf;
+	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
+		bio = bio_map_user(q, NULL, uaddr, len, reading);
+	else
+		bio = bio_copy_user(q, uaddr, len, reading);
+
+	if (IS_ERR(bio)) {
+		return PTR_ERR(bio);
+	}
+
+	orig_bio = bio;
+	blk_queue_bounce(q, &bio);
+	/*
+	 * We link the bounce buffer in and could have to traverse it
+	 * later so we have to get a ref to prevent it from being freed
+	 */
+	bio_get(bio);
+
+	/*
+	 * for most (all? don't know of any) queues we could
+	 * skip grabbing the queue lock here. only drivers with
+	 * funky private ->back_merge_fn() function could be
+	 * problematic.
+	 */
+	spin_lock_irq(q->queue_lock);
+	if (!rq->bio)
+		blk_rq_bio_prep(q, rq, bio);
+	else if (!q->back_merge_fn(q, rq, bio)) {
+		ret = -EINVAL;
+		spin_unlock_irq(q->queue_lock);
+		goto unmap_bio;
+	} else {
+		rq->biotail->bi_next = bio;
+		rq->biotail = bio;
+
+		rq->nr_sectors += bio_sectors(bio);
+		rq->hard_nr_sectors = rq->nr_sectors;
+		rq->data_len += bio->bi_size;
+	}
+	spin_unlock_irq(q->queue_lock);
+
+	return bio->bi_size;
+
+unmap_bio:
+	/* if it was boucned we must call the end io function */
+	bio_endio(bio, bio->bi_size, 0);
+	__blk_rq_unmap_user(orig_bio);
+	bio_put(bio);
+	return ret;
+}
+
 /**
  * blk_rq_map_user - map user data to a request, for REQ_BLOCK_PC usage
  * @q:		request queue where request should be inserted
@@ -2343,42 +2421,44 @@ EXPORT_SYMBOL(blk_insert_request);
  *    unmapping.
  */
 int blk_rq_map_user(request_queue_t *q, struct request *rq, void __user *ubuf,
-		    unsigned int len)
+		    unsigned long len)
 {
-	unsigned long uaddr;
-	struct bio *bio;
-	int reading;
+	unsigned long bytes_read = 0;
+	int ret;
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
 	if (!len || !ubuf)
 		return -EINVAL;
 
-	reading = rq_data_dir(rq) == READ;
+	while (bytes_read != len) {
+		unsigned long map_len, end, start;
 
-	/*
-	 * if alignment requirement is satisfied, map in user pages for
-	 * direct dma. else, set up kernel bounce buffers
-	 */
-	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
-		bio = bio_map_user(q, NULL, uaddr, len, reading);
-	else
-		bio = bio_copy_user(q, uaddr, len, reading);
+		map_len = min_t(unsigned long, len - bytes_read, BIO_MAX_SIZE);
+		end = ((unsigned long)ubuf + map_len + PAGE_SIZE - 1)
+								>> PAGE_SHIFT;
+		start = (unsigned long)ubuf >> PAGE_SHIFT;
 
-	if (!IS_ERR(bio)) {
-		rq->bio = rq->biotail = bio;
-		blk_rq_bio_prep(q, rq, bio);
+		/*
+		 * A bad offset could cause us to require BIO_MAX_PAGES + 1
+		 * pages. If this happens we just lower the requested
+		 * mapping len by a page so that we can fit
+		 */
+		if (end - start > BIO_MAX_PAGES)
+			map_len -= PAGE_SIZE;
 
-		rq->buffer = rq->data = NULL;
-		rq->data_len = len;
-		return 0;
+		ret = __blk_rq_map_user(q, rq, ubuf, map_len);
+		if (ret < 0)
+			goto unmap_rq;
+		bytes_read += ret;
+		ubuf += ret;
 	}
 
-	/*
-	 * bio is the err-ptr
-	 */
-	return PTR_ERR(bio);
+	rq->buffer = rq->data = NULL;
+	return 0;
+unmap_rq:
+	blk_rq_unmap_user(rq);
+	return ret;
 }
 
 EXPORT_SYMBOL(blk_rq_map_user);
@@ -2404,7 +2484,7 @@ EXPORT_SYMBOL(blk_rq_map_user);
  *    unmapping.
  */
 int blk_rq_map_user_iov(request_queue_t *q, struct request *rq,
-			struct sg_iovec *iov, int iov_count)
+			struct sg_iovec *iov, int iov_count, unsigned int len)
 {
 	struct bio *bio;
 
@@ -2418,10 +2498,15 @@ int blk_rq_map_user_iov(request_queue_t
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	rq->bio = rq->biotail = bio;
+	if (bio->bi_size != len) {
+		bio_endio(bio, bio->bi_size, 0);
+		bio_unmap_user(bio);
+		return -EINVAL;
+	}
+
+	bio_get(bio);
 	blk_rq_bio_prep(q, rq, bio);
 	rq->buffer = rq->data = NULL;
-	rq->data_len = bio->bi_size;
 	return 0;
 }
 
@@ -2429,23 +2514,26 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
  * blk_rq_unmap_user - unmap a request with user data
- * @bio:	bio to be unmapped
- * @ulen:	length of user buffer
+ * @rq:		rq to be unmapped
  *
  * Description:
- *    Unmap a bio previously mapped by blk_rq_map_user().
+ *    Unmap a rq previously mapped by blk_rq_map_user().
+ *    rq->bio must be set to the original head of the request.
  */
-int blk_rq_unmap_user(struct bio *bio, unsigned int ulen)
+int blk_rq_unmap_user(struct request *rq)
 {
-	int ret = 0;
+	struct bio *bio, *mapped_bio;
 
-	if (bio) {
-		if (bio_flagged(bio, BIO_USER_MAPPED))
-			bio_unmap_user(bio);
+	while ((bio = rq->bio)) {
+		if (bio_flagged(bio, BIO_BOUNCED))
+			mapped_bio = bio->bi_private;
 		else
-			ret = bio_uncopy_user(bio);
-	}
+			mapped_bio = bio;
 
+		__blk_rq_unmap_user(mapped_bio);
+		rq->bio = bio->bi_next;
+		bio_put(bio);
+	}
 	return 0;
 }
 
@@ -2476,11 +2564,8 @@ int blk_rq_map_kern(request_queue_t *q,
 	if (rq_data_dir(rq) == WRITE)
 		bio->bi_rw |= (1 << BIO_RW);
 
-	rq->bio = rq->biotail = bio;
 	blk_rq_bio_prep(q, rq, bio);
-
 	rq->buffer = rq->data = NULL;
-	rq->data_len = len;
 	return 0;
 }
 
@@ -3495,6 +3580,7 @@ void blk_rq_bio_prep(request_queue_t *q,
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
+	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
 }
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a19338e..90f95e5 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -226,7 +226,6 @@ static int sg_io(struct file *file, requ
 	unsigned long start_time;
 	int writing = 0, ret = 0;
 	struct request *rq;
-	struct bio *bio;
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	unsigned char cmd[BLK_MAX_CDB];
 
@@ -258,30 +257,6 @@ static int sg_io(struct file *file, requ
 	if (!rq)
 		return -ENOMEM;
 
-	if (hdr->iovec_count) {
-		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
-		struct sg_iovec *iov;
-
-		iov = kmalloc(size, GFP_KERNEL);
-		if (!iov) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		if (copy_from_user(iov, hdr->dxferp, size)) {
-			kfree(iov);
-			ret = -EFAULT;
-			goto out;
-		}
-
-		ret = blk_rq_map_user_iov(q, rq, iov, hdr->iovec_count);
-		kfree(iov);
-	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
-
-	if (ret)
-		goto out;
-
 	/*
 	 * fill in request structure
 	 */
@@ -295,7 +270,6 @@ static int sg_io(struct file *file, requ
 	rq->sense_len = 0;
 
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	bio = rq->bio;
 
 	/*
 	 * bounce this after holding a reference to the original bio, it's
@@ -310,6 +284,31 @@ static int sg_io(struct file *file, requ
 	if (!rq->timeout)
 		rq->timeout = BLK_DEFAULT_TIMEOUT;
 
+	if (hdr->iovec_count) {
+		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
+		struct sg_iovec *iov;
+
+		iov = kmalloc(size, GFP_KERNEL);
+		if (!iov) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		if (copy_from_user(iov, hdr->dxferp, size)) {
+			kfree(iov);
+			ret = -EFAULT;
+			goto out;
+		}
+
+		ret = blk_rq_map_user_iov(q, rq, iov, hdr->iovec_count,
+					  hdr->dxfer_len);
+		kfree(iov);
+	} else if (hdr->dxfer_len)
+		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
+
+	if (ret)
+		goto out;
+
 	rq->retries = 0;
 
 	start_time = jiffies;
@@ -340,7 +339,7 @@ static int sg_io(struct file *file, requ
 			hdr->sb_len_wr = len;
 	}
 
-	if (blk_rq_unmap_user(bio, hdr->dxfer_len))
+	if (blk_rq_unmap_user(rq))
 		ret = -EFAULT;
 
 	/* may not have succeeded, but output values written to control
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 7ea0f48..2df5cf4 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2133,16 +2133,14 @@ static int cdrom_read_cdda_bpc(struct cd
 		rq->timeout = 60 * HZ;
 		bio = rq->bio;
 
-		if (rq->bio)
-			blk_queue_bounce(q, &rq->bio);
-
 		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
 			struct request_sense *s = rq->sense;
 			ret = -EIO;
 			cdi->last_sense = s->sense_key;
 		}
 
-		if (blk_rq_unmap_user(bio, len))
+		rq->bio = bio;
+		if (blk_rq_unmap_user(rq))
 			ret = -EFAULT;
 
 		if (ret)
diff --git a/fs/bio.c b/fs/bio.c
index d91cfbf..aa4d09b 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -560,10 +560,8 @@ struct bio *bio_copy_user(request_queue_
 			break;
 		}
 
-		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes) {
-			ret = -EINVAL;
+		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes)
 			break;
-		}
 
 		len -= bytes;
 	}
@@ -750,7 +748,6 @@ struct bio *bio_map_user_iov(request_que
 			     int write_to_vm)
 {
 	struct bio *bio;
-	int len = 0, i;
 
 	bio = __bio_map_user_iov(q, bdev, iov, iov_count, write_to_vm);
 
@@ -765,18 +762,7 @@ struct bio *bio_map_user_iov(request_que
 	 */
 	bio_get(bio);
 
-	for (i = 0; i < iov_count; i++)
-		len += iov[i].iov_len;
-
-	if (bio->bi_size == len)
-		return bio;
-
-	/*
-	 * don't support partial mappings
-	 */
-	bio_endio(bio, bio->bi_size, 0);
-	bio_unmap_user(bio);
-	return ERR_PTR(-EINVAL);
+	return bio;
 }
 
 static void __bio_unmap_user(struct bio *bio)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7bfcde2..e1c7286 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -678,10 +678,11 @@ extern void __blk_stop_queue(request_que
 extern void blk_run_queue(request_queue_t *);
 extern void blk_start_queueing(request_queue_t *);
 extern void blk_queue_activity_fn(request_queue_t *, activity_fn *, void *);
-extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned int);
-extern int blk_rq_unmap_user(struct bio *, unsigned int);
+extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned long);
+extern int blk_rq_unmap_user(struct request *);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, gfp_t);
-extern int blk_rq_map_user_iov(request_queue_t *, struct request *, struct sg_iovec *, int);
+extern int blk_rq_map_user_iov(request_queue_t *, struct request *,
+			       struct sg_iovec *, int, unsigned int);
 extern int blk_execute_rq(request_queue_t *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(request_queue_t *, struct gendisk *,
-- 
1.4.3.2

