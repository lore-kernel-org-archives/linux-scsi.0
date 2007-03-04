From: michaelc@cs.wisc.edu
Subject: [PATCH 3/7] Support large sg io segments
Date: Sun, 04 Mar 2007 12:31:20 -0600
Message-ID: <11730330861995-git-send-email-michaelc@cs.wisc.edu>
References: <1173033084706-git-send-email-michaelc@cs.wisc.edu> <11730330852430-git-send-email-michaelc@cs.wisc.edu> <11730330851234-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXCDSbj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 13:31:39 -0500
In-Reply-To: <11730330851234-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

sg.c and st allocate large chunks of clustered pages
to try and make really large requests. The block
layer sg io code only allocates a page at a time,
so we can end up with lots of unclustered pages
and smaller requests.

This patch modifies the block layer to allocate large
segments like st and sg so they can use those functions.

This patch also renames the blk_rq* helpers to clarify
what they are doing:

Previously, we did blk_rq_map_user() to map or copy date to a buffer. Then
called blk_rq_unmap_user to unmap or copy back data. sg and st want finer
control over when to use DIO vs indirect IO, and for sg mmap we want to
use the code that sets up a bio buffer which is also used by indirect IO.

Now, if the caller does not care how we transfer data they can call
blk_rq_init_transfer() to setup the buffers (this does what blk_rq_map_user()
did before where it would try DIO first then fall back to indirect IO)
and then call blk_rq_complete_transfer() when the IO is done (this
does what blk_rq_unmap_user did before). block/scsi_ioctl.c, cdrom,
and bsg use these functions.

If the callers wants to try to do DIO, then they can call blk_rq_map_user()
to set up the buffer. When the IO is done you can then call
blk_rq_destroy_buffer(). You could also call blk_rq_complete_transfer() is
just a smart wrapper.

To do indirect IO, we now have blk_rq_copy_user_iov(). When that IO
is done, you then call blk_rq_uncopy_user_iov().
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c      |  379 +++++++++++++++++++++++++++++++++++-------------
 block/scsi_ioctl.c     |    4 -
 drivers/cdrom/cdrom.c  |    4 -
 fs/bio.c               |  193 ++++++++++++++----------
 include/linux/bio.h    |    5 -
 include/linux/blkdev.h |   11 +
 6 files changed, 400 insertions(+), 196 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 7a108d5..c9d765b 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -35,6 +35,10 @@ #include <linux/fault-inject.h>
  * for max sense size
  */
 #include <scsi/scsi_cmnd.h>
+/*
+ * for struct sg_iovc
+ */
+#include <scsi/sg.h>
 
 static void blk_unplug_work(struct work_struct *work);
 static void blk_unplug_timeout(unsigned long data);
@@ -2314,138 +2318,301 @@ void blk_insert_request(request_queue_t 
 
 EXPORT_SYMBOL(blk_insert_request);
 
-static int __blk_rq_unmap_user(struct bio *bio)
+static void __blk_rq_destroy_buffer(struct bio *bio)
 {
-	int ret = 0;
+	if (bio_flagged(bio, BIO_USER_MAPPED))
+		bio_unmap_user(bio);
+	else
+		bio_destroy_user_buffer(bio);
+}
 
-	if (bio) {
-		if (bio_flagged(bio, BIO_USER_MAPPED))
-			bio_unmap_user(bio);
-		else
-			ret = bio_uncopy_user(bio);
-	}
+void blk_rq_destroy_buffer(struct bio *bio)
+{
+	struct bio *mapped_bio;
 
-	return ret;
+	while (bio) {
+		mapped_bio = bio;
+		if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
+			mapped_bio = bio->bi_private;
+		__blk_rq_destroy_buffer(mapped_bio);
+		mapped_bio = bio;
+		bio = bio->bi_next;
+		bio_put(mapped_bio);
+	}
 }
+EXPORT_SYMBOL(blk_rq_destroy_buffer);
 
-static int __blk_rq_map_user(request_queue_t *q, struct request *rq,
-			     void __user *ubuf, unsigned int len)
+/**
+ * blk_rq_setup_buffer - setup buffer to bio mappings
+ * @rq:		request structure to fill
+ * @ubuf:	the user buffer (optional)
+ * @len:	length of buffer
+ *
+ * Description:
+ *    The caller must call blk_rq_destroy_buffer when the IO is completed.
+ */
+int blk_rq_setup_buffer(struct request *rq, void __user *ubuf,
+			unsigned long len)
 {
-	unsigned long uaddr;
+	struct request_queue *q = rq->q;
+	unsigned long bytes_read = 0;
 	struct bio *bio, *orig_bio;
 	int reading, ret;
 
-	reading = rq_data_dir(rq) == READ;
-
-	/*
-	 * if alignment requirement is satisfied, map in user pages for
-	 * direct dma. else, set up kernel bounce buffers
-	 */
-	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
-		bio = bio_map_user(q, uaddr, len, reading);
-	else
-		bio = bio_copy_user(q, uaddr, len, reading);
+	if (!len || len > (q->max_hw_sectors << 9))
+		return -EINVAL;
 
-	if (IS_ERR(bio))
-		return PTR_ERR(bio);
+	reading = rq_data_dir(rq) == READ;
+	rq->bio = NULL;
+	while (bytes_read != len) {
+		unsigned long map_len, end, start, uaddr = 0;
 
-	orig_bio = bio;
-	blk_queue_bounce(q, &bio);
+		map_len = min_t(unsigned long, len - bytes_read, BIO_MAX_SIZE);
+		if (ubuf) {
+			uaddr = (unsigned long)ubuf;
+			end = (uaddr + map_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+			start = uaddr >> PAGE_SHIFT;
+			/*
+			 * For DIO, a bad offset could cause us to require
+			 * BIO_MAX_PAGES + 1 pages. If this happens we just
+			 * lower the requested mapping len by a page so that
+			 * we can fit
+		 	*/
+			if (end - start > BIO_MAX_PAGES)
+				map_len -= PAGE_SIZE;
+
+			bio = bio_map_user(q, uaddr, map_len, reading);
+		} else
+			bio = bio_setup_user_buffer(q, map_len, reading);
+		if (IS_ERR(bio)) {
+			ret = PTR_ERR(bio);
+			goto unmap_rq;
+		}
 
-	/*
-	 * We link the bounce buffer in and could have to traverse it
-	 * later so we have to get a ref to prevent it from being freed
-	 */
-	bio_get(bio);
+		orig_bio = bio;
+		blk_queue_bounce(q, &bio);
+		/*
+		 * We link the bounce buffer in and could have to traverse it
+		 * later so we have to get a ref to prevent it from being freed
+		 */
+		bio_get(bio);
 
-	if (!rq->bio)
-		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio)) {
-		ret = -EINVAL;
-		goto unmap_bio;
-	} else {
-		rq->biotail->bi_next = bio;
-		rq->biotail = bio;
+		if (!rq->bio)
+			blk_rq_bio_prep(q, rq, bio);
+		else if (!ll_back_merge_fn(q, rq, bio)) {
+			ret = -EINVAL;
+			goto unmap_bio;
+		} else {
+			rq->biotail->bi_next = bio;
+			rq->biotail = bio;
+			rq->data_len += bio->bi_size;
+		}
 
-		rq->data_len += bio->bi_size;
+		bytes_read += bio->bi_size;
+		if (ubuf)
+			ubuf += bio->bi_size;
 	}
 
-	return bio->bi_size;
+	rq->buffer = rq->data = NULL;
+	return 0;
+
 
 unmap_bio:
 	/* if it was boucned we must call the end io function */
 	bio_endio(bio, bio->bi_size, 0);
-	__blk_rq_unmap_user(orig_bio);
+	__blk_rq_destroy_buffer(orig_bio);
 	bio_put(bio);
+unmap_rq:
+	blk_rq_destroy_buffer(rq->bio);
+	rq->bio = NULL;
+ 	return ret;
+}
+EXPORT_SYMBOL(blk_rq_setup_buffer);
+
+/**
+ * blk_rq_map_user - map user data to a request.
+ * @q:		request queue where request should be inserted
+ * @rq:		request structure to fill
+ * @ubuf:	the user buffer
+ * @len:	length of user data
+ * Description:
+ *    This function is for REQ_BLOCK_PC usage.
+
+ *    Data will be mapped directly for zero copy io.
+ *
+ *    A matching blk_rq_destroy_buffer() must be issued at the end of io,
+ *    while still in process context.
+ *
+ *    It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_destroy_buffer() for
+ *    proper unmapping.
+ */
+int blk_rq_map_user(request_queue_t *q, struct request *rq,
+		     void __user *ubuf, unsigned long len)
+{
+	return blk_rq_setup_buffer(rq, ubuf, len);
+}
+EXPORT_SYMBOL(blk_rq_map_user);
+
+static int copy_user_iov(struct bio *head, struct sg_iovec *iov, int iov_count)
+{
+	unsigned int iov_len = 0;
+	int ret, i = 0, iov_index = 0;
+	struct bio *bio;
+	struct bio_vec *bvec;
+	char __user *p = NULL;
+
+	if (!iov || !iov_count)
+		return 0;
+
+	for (bio = head; bio; bio = bio->bi_next) {
+		bio_for_each_segment(bvec, bio, i) {
+			unsigned int copy_bytes, bvec_offset = 0;
+			char *addr;
+
+continue_from_bvec:
+			addr = page_address(bvec->bv_page) + bvec_offset;
+			if (!p) {
+				if (iov_index == iov_count)
+					/*
+					 * caller wanted a buffer larger
+					 * than transfer
+					 */
+					break;
+
+				p = iov[iov_index].iov_base;
+				iov_len = iov[iov_index].iov_len;
+				if (!p || !iov_len) {
+					iov_index++;
+					p = NULL;
+					/*
+					 * got an invalid iov, so just try to
+					 * complete what is valid
+					 */
+					goto continue_from_bvec;
+				}
+			}
+
+			copy_bytes = min(iov_len, bvec->bv_len - bvec_offset);
+			if (bio_data_dir(head) == READ)
+				ret = copy_to_user(p, addr, copy_bytes);
+			else
+				ret = copy_from_user(addr, p, copy_bytes);
+			if (ret)
+				return -EFAULT;
+
+			bvec_offset += copy_bytes;
+			iov_len -= copy_bytes;
+			if (iov_len == 0) {
+				p = NULL;
+				iov_index++;
+				if (bvec_offset < bvec->bv_len)
+					goto continue_from_bvec;
+			} else
+				p += copy_bytes;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * blk_rq_copy_user_iov - copy user data to a request.
+ * @rq:		request structure to fill
+ * @iov:	sg iovec
+ * @iov_count:	number of elements in the iovec
+ * @len:	max length of data (length of buffer)
+ *
+ * Description:
+ *    This function is for REQ_BLOCK_PC usage.
+ *
+ *    A matching blk_rq_uncopy_user_iov() must be issued at the end of io,
+ *    while still in process context.
+ *
+ *    It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_uncopy_user_iov() for
+ *    proper unmapping.
+ */
+int blk_rq_copy_user_iov(struct request *rq, struct sg_iovec *iov,
+			 int iov_count, unsigned long len)
+{
+	int ret;
+
+	ret = blk_rq_setup_buffer(rq, NULL, len);
+	if (ret)
+		return ret;
+
+	if (rq_data_dir(rq) == READ)
+		return 0;
+
+	ret = copy_user_iov(rq->bio, iov, iov_count);
+	if (ret)
+		goto fail;
+	return 0;
+fail:
+	blk_rq_destroy_buffer(rq->bio);
+	return -EFAULT;
+}
+EXPORT_SYMBOL(blk_rq_copy_user_iov);
+
+int blk_rq_uncopy_user_iov(struct bio *bio, struct sg_iovec *iov,
+			   int iov_count)
+{
+	int ret = 0;
+
+	if (!bio)
+		return 0;
+
+	if (bio_data_dir(bio) == READ)
+		ret = copy_user_iov(bio, iov, iov_count);
+	blk_rq_destroy_buffer(bio);
 	return ret;
 }
+EXPORT_SYMBOL(blk_rq_uncopy_user_iov);
 
 /**
- * blk_rq_map_user - map user data to a request, for REQ_BLOCK_PC usage
+ * blk_rq_init_transfer - map or copy user data to a request.
  * @q:		request queue where request should be inserted
  * @rq:		request structure to fill
  * @ubuf:	the user buffer
  * @len:	length of user data
  *
  * Description:
+ *    This function is for REQ_BLOCK_PC usage.
+ *
  *    Data will be mapped directly for zero copy io, if possible. Otherwise
  *    a kernel bounce buffer is used.
  *
- *    A matching blk_rq_unmap_user() must be issued at the end of io, while
- *    still in process context.
+ *    A matching blk_rq_complete_transfer() must be issued at the end of io,
+ *    while still in process context.
  *
  *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
  *    before being submitted to the device, as pages mapped may be out of
  *    reach. It's the callers responsibility to make sure this happens. The
- *    original bio must be passed back in to blk_rq_unmap_user() for proper
- *    unmapping.
+ *    original bio must be passed back in to blk_rq_complete_transfer() for
+ *    proper unmapping.
  */
-int blk_rq_map_user(request_queue_t *q, struct request *rq, void __user *ubuf,
-		    unsigned long len)
+int blk_rq_init_transfer(request_queue_t *q, struct request *rq,
+			 void __user *ubuf, unsigned long len)
 {
-	unsigned long bytes_read = 0;
-	struct bio *bio = NULL;
 	int ret;
 
-	if (len > (q->max_hw_sectors << 9))
-		return -EINVAL;
-	if (!len || !ubuf)
+	if (!ubuf)
 		return -EINVAL;
 
-	while (bytes_read != len) {
-		unsigned long map_len, end, start;
-
-		map_len = min_t(unsigned long, len - bytes_read, BIO_MAX_SIZE);
-		end = ((unsigned long)ubuf + map_len + PAGE_SIZE - 1)
-								>> PAGE_SHIFT;
-		start = (unsigned long)ubuf >> PAGE_SHIFT;
+	ret = blk_rq_map_user(q, rq, ubuf, len);
+	if (ret) {
+		struct sg_iovec iov;
 
-		/*
-		 * A bad offset could cause us to require BIO_MAX_PAGES + 1
-		 * pages. If this happens we just lower the requested
-		 * mapping len by a page so that we can fit
-		 */
-		if (end - start > BIO_MAX_PAGES)
-			map_len -= PAGE_SIZE;
+		iov.iov_base = ubuf;
+		iov.iov_len = len;
 
-		ret = __blk_rq_map_user(q, rq, ubuf, map_len);
-		if (ret < 0)
-			goto unmap_rq;
-		if (!bio)
-			bio = rq->bio;
-		bytes_read += ret;
-		ubuf += ret;
+		ret = blk_rq_copy_user_iov(rq, &iov, 1, len);
 	}
-
-	rq->buffer = rq->data = NULL;
-	return 0;
-unmap_rq:
-	blk_rq_unmap_user(bio);
 	return ret;
 }
 
-EXPORT_SYMBOL(blk_rq_map_user);
+EXPORT_SYMBOL(blk_rq_init_transfer);
 
 /**
  * blk_rq_map_user_iov - map user data to a request, for REQ_BLOCK_PC usage
@@ -2459,14 +2626,14 @@ EXPORT_SYMBOL(blk_rq_map_user);
  *    Data will be mapped directly for zero copy io, if possible. Otherwise
  *    a kernel bounce buffer is used.
  *
- *    A matching blk_rq_unmap_user() must be issued at the end of io, while
+ *    A matching blk_rq_destroy_buffer() must be issued at the end of io, while
  *    still in process context.
  *
  *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
  *    before being submitted to the device, as pages mapped may be out of
  *    reach. It's the callers responsibility to make sure this happens. The
- *    original bio must be passed back in to blk_rq_unmap_user() for proper
- *    unmapping.
+ *    original bio must be passed back in to blk_rq_complete_transfer()
+ *    for proper unmapping.
  */
 int blk_rq_map_user_iov(request_queue_t *q, struct request *rq,
 			struct sg_iovec *iov, int iov_count, unsigned int len)
@@ -2498,37 +2665,37 @@ int blk_rq_map_user_iov(request_queue_t 
 EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
- * blk_rq_unmap_user - unmap a request with user data
+ * blk_rq_complete_transfer - unmap a request with user data
+ * @q:		       request q bio was sent to
  * @bio:	       start of bio list
+ * @ubuf:              buffer to copy to if needed
+ * @len:               number of bytes to copy if needed
  *
  * Description:
- *    Unmap a rq previously mapped by blk_rq_map_user(). The caller must
- *    supply the original rq->bio from the blk_rq_map_user() return, since
- *    the io completion may have changed rq->bio.
+ *    Unmap a rq mapped with blk_rq_init_transfer, blk_rq_map_user_iov,
+ *    blk_rq_map_user or blk_rq_copy_user_iov (if copying back to single buf).
+ *    The caller must supply the original rq->bio, since the io completion
+ *    may have changed rq->bio.
  */
-int blk_rq_unmap_user(struct bio *bio)
+int blk_rq_complete_transfer(struct bio *bio, void __user *ubuf,
+			     unsigned long len)
 {
-	struct bio *mapped_bio;
-	int ret = 0, ret2;
-
-	while (bio) {
-		mapped_bio = bio;
-		if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
-			mapped_bio = bio->bi_private;
+	struct sg_iovec iov;
+	int ret = 0;
 
-		ret2 = __blk_rq_unmap_user(mapped_bio);
-		if (ret2 && !ret)
-			ret = ret2;
+	if (!bio)
+		return 0;
 
-		mapped_bio = bio;
-		bio = bio->bi_next;
-		bio_put(mapped_bio);
+	if (bio_flagged(bio, BIO_USER_MAPPED))
+		blk_rq_destroy_buffer(bio);
+	else {
+		iov.iov_base = ubuf;
+		iov.iov_len = len;
+		ret = blk_rq_uncopy_user_iov(bio, &iov, 1);
 	}
-
 	return ret;
 }
-
-EXPORT_SYMBOL(blk_rq_unmap_user);
+EXPORT_SYMBOL(blk_rq_complete_transfer);
 
 /**
  * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 65c6a3c..a290a99 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -298,7 +298,7 @@ static int sg_io(struct file *file, requ
 					  hdr->dxfer_len);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
+		ret = blk_rq_init_transfer(q, rq, hdr->dxferp, hdr->dxfer_len);
 
 	if (ret)
 		goto out;
@@ -334,7 +334,7 @@ static int sg_io(struct file *file, requ
 			hdr->sb_len_wr = len;
 	}
 
-	if (blk_rq_unmap_user(bio))
+	if (blk_rq_complete_transfer(bio, hdr->dxferp, hdr->dxfer_len))
 		ret = -EFAULT;
 
 	/* may not have succeeded, but output values written to control
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index b36f44d..4c0e63a 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2118,7 +2118,7 @@ static int cdrom_read_cdda_bpc(struct cd
 
 		len = nr * CD_FRAMESIZE_RAW;
 
-		ret = blk_rq_map_user(q, rq, ubuf, len);
+		ret = blk_rq_init_transfer(q, rq, ubuf, len);
 		if (ret)
 			break;
 
@@ -2145,7 +2145,7 @@ static int cdrom_read_cdda_bpc(struct cd
 			cdi->last_sense = s->sense_key;
 		}
 
-		if (blk_rq_unmap_user(bio))
+		if (blk_rq_complete_transfer(bio, ubuf, len))
 			ret = -EFAULT;
 
 		if (ret)
diff --git a/fs/bio.c b/fs/bio.c
index 8ae7223..2fff42a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -451,16 +451,16 @@ int bio_add_page(struct bio *bio, struct
 	return __bio_add_page(q, bio, page, len, offset, q->max_sectors);
 }
 
-struct bio_map_data {
-	struct bio_vec *iovecs;
-	void __user *userptr;
+struct bio_map_vec {
+	struct page *page;
+	int order;
+	unsigned int len;
 };
 
-static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio)
-{
-	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
-	bio->bi_private = bmd;
-}
+struct bio_map_data {
+	struct bio_map_vec *iovecs;
+	int nr_vecs;
+};
 
 static void bio_free_map_data(struct bio_map_data *bmd)
 {
@@ -470,12 +470,12 @@ static void bio_free_map_data(struct bio
 
 static struct bio_map_data *bio_alloc_map_data(int nr_segs)
 {
-	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), GFP_KERNEL);
+	struct bio_map_data *bmd = kzalloc(sizeof(*bmd), GFP_KERNEL);
 
 	if (!bmd)
 		return NULL;
 
-	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, GFP_KERNEL);
+	bmd->iovecs = kzalloc(sizeof(struct bio_map_vec) * nr_segs, GFP_KERNEL);
 	if (bmd->iovecs)
 		return bmd;
 
@@ -483,117 +483,146 @@ static struct bio_map_data *bio_alloc_ma
 	return NULL;
 }
 
-/**
- *	bio_uncopy_user	-	finish previously mapped bio
- *	@bio: bio being terminated
+/*
+ * This is only a esitmation. Drivers, like MD/DM RAID could have strange
+ * boundaries not expressed in a q limit, so we do not know the real
+ * limit until we add the page to the bio.
  *
- *	Free pages allocated from bio_copy_user() and write back data
- *	to user space in case of a read.
+ * This should only be used by bio helpers, because we cut off the max
+ * segment size at BIO_MAX_SIZE. There is hw that can do larger segments,
+ * but there is no current need and aligning the segments to fit in
+ * a single BIO makes the code simple.
  */
-int bio_uncopy_user(struct bio *bio)
+static unsigned int bio_estimate_max_segment_size(struct request_queue *q)
 {
-	struct bio_map_data *bmd = bio->bi_private;
-	const int read = bio_data_dir(bio) == READ;
-	struct bio_vec *bvec;
-	int i, ret = 0;
+	unsigned int bytes;
+
+	if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER)))
+		return PAGE_SIZE;
+	bytes = min(q->max_segment_size, q->max_hw_sectors << 9);
+	if (bytes > BIO_MAX_SIZE)
+		bytes = BIO_MAX_SIZE;
+	return bytes;
+}
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
-		char *addr = page_address(bvec->bv_page);
-		unsigned int len = bmd->iovecs[i].bv_len;
+static struct page *bio_alloc_pages(struct request_queue *q, unsigned int len,
+				    int *ret_order)
+{
+	unsigned int bytes;
+	struct page *pages;
+	int order;
+
+	bytes = bio_estimate_max_segment_size(q);
+	if (bytes > len)
+		bytes = len;
+
+	order = get_order(bytes);
+	do {
+		pages = alloc_pages(q->bounce_gfp | GFP_KERNEL, order);
+		if (!pages)
+			order--;
+	} while (!pages && order > 0);
+
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+		memset(page_address(pages), 0, (1 << order) << PAGE_SHIFT);
+
+	*ret_order = order;
+	return pages;
+}
 
-		if (read && !ret && copy_to_user(bmd->userptr, addr, len))
-			ret = -EFAULT;
+static void bio_destroy_map_vec(struct bio *bio, struct bio_map_data *bmd,
+				struct bio_map_vec *vec)
+{
+	__free_pages(vec->page, vec->order);
+}
 
-		__free_page(bvec->bv_page);
-		bmd->userptr += len;
-	}
+/**
+ *	bio_destroy_user_buffer - free buffers
+ *	@bio:		bio being terminated
+ *
+ *	Free pages allocated from bio_setup_user_buffer();
+ */
+void bio_destroy_user_buffer(struct bio *bio)
+{
+	struct bio_map_data *bmd = bio->bi_private;
+	int i;
+
+	for (i = 0; i < bmd->nr_vecs; i++)
+		bio_destroy_map_vec(bio, bmd, &bmd->iovecs[i]);
 	bio_free_map_data(bmd);
 	bio_put(bio);
-	return ret;
 }
 
 /**
- *	bio_copy_user	-	copy user data to bio
+ *	bio_setup_user_buffer - setup buffer to bio mappings
  *	@q: destination block queue
  *	@uaddr: start of user address
- *	@len: length in bytes
+ *	@len: max length in bytes (length of buffer)
  *	@write_to_vm: bool indicating writing to pages or not
  *
- *	Prepares and returns a bio for indirect user io, bouncing data
- *	to/from kernel pages as necessary. Must be paired with
- *	call bio_uncopy_user() on io completion.
+ *	Prepares and returns a bio for indirect user io or mmap usage.
+ *      It will allocate buffers with the queue's bounce_pfn, so
+ *	there is no bounce buffers needed. Must be paired with
+ *	call bio_destroy_user_buffer() on io completion. If
+ *      len is larger than the bio can hold, len bytes will be setup.
  */
-struct bio *bio_copy_user(request_queue_t *q, unsigned long uaddr,
-			  unsigned int len, int write_to_vm)
+struct bio *bio_setup_user_buffer(request_queue_t *q, unsigned int len,
+				  int write_to_vm)
 {
-	unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = uaddr >> PAGE_SHIFT;
 	struct bio_map_data *bmd;
-	struct bio_vec *bvec;
-	struct page *page;
 	struct bio *bio;
-	int i, ret;
+	struct page *page;
+	int i = 0, ret, nr_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-	bmd = bio_alloc_map_data(end - start);
+	bmd = bio_alloc_map_data(nr_pages);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
-	bmd->userptr = (void __user *) uaddr;
-
-	ret = -ENOMEM;
-	bio = bio_alloc(GFP_KERNEL, end - start);
-	if (!bio)
+	bio = bio_alloc(GFP_KERNEL, nr_pages);
+	if (!bio) {
+		ret = -ENOMEM;
 		goto out_bmd;
-
+	}
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
 
 	ret = 0;
 	while (len) {
-		unsigned int bytes = PAGE_SIZE;
+		unsigned add_len;
+		int order = 0;
 
-		if (bytes > len)
-			bytes = len;
-
-		page = alloc_page(q->bounce_gfp | GFP_KERNEL);
+		page = bio_alloc_pages(q, len, &order);
 		if (!page) {
 			ret = -ENOMEM;
-			break;
+			goto cleanup;
 		}
 
-		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes)
-			break;
+		bmd->nr_vecs++;
+		bmd->iovecs[i].page = page;
+		bmd->iovecs[i].order = order;
+		bmd->iovecs[i].len = 0;
 
-		len -= bytes;
-	}
+		add_len = min_t(unsigned int, (1 << order) << PAGE_SHIFT, len);
+		while (add_len) {
+			unsigned int added, bytes = PAGE_SIZE;
 
-	if (ret)
-		goto cleanup;
+			if (bytes > add_len)
+				bytes = add_len;
 
-	/*
-	 * success
-	 */
-	if (!write_to_vm) {
-		char __user *p = (char __user *) uaddr;
-
-		/*
-		 * for a write, copy in data to kernel pages
-		 */
-		ret = -EFAULT;
-		bio_for_each_segment(bvec, bio, i) {
-			char *addr = page_address(bvec->bv_page);
-
-			if (copy_from_user(addr, p, bvec->bv_len))
-				goto cleanup;
-			p += bvec->bv_len;
+			added = bio_add_pc_page(q, bio, page++, bytes, 0);
+			bmd->iovecs[i].len += added;
+			if (added < bytes)
+				break;
+			add_len -= bytes;
+			len -= bytes;
 		}
+		i++;
 	}
 
-	bio_set_map_data(bmd, bio);
+	bio->bi_private = bmd;
 	return bio;
 cleanup:
-	bio_for_each_segment(bvec, bio, i)
-		__free_page(bvec->bv_page);
-
+	for (i = 0; i < bmd->nr_vecs; i++)
+		bio_destroy_map_vec(bio, bmd, &bmd->iovecs[i]);
 	bio_put(bio);
 out_bmd:
 	bio_free_map_data(bmd);
@@ -1254,8 +1283,8 @@ EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
 EXPORT_SYMBOL(bio_split_pool);
-EXPORT_SYMBOL(bio_copy_user);
-EXPORT_SYMBOL(bio_uncopy_user);
+EXPORT_SYMBOL(bio_setup_user_buffer);
+EXPORT_SYMBOL(bio_destroy_user_buffer);
 EXPORT_SYMBOL(bioset_create);
 EXPORT_SYMBOL(bioset_free);
 EXPORT_SYMBOL(bio_alloc_bioset);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index cfb6a7d..e568373 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -309,8 +309,9 @@ extern struct bio *bio_map_kern(struct r
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern void bio_release_pages(struct bio *bio);
-extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
-extern int bio_uncopy_user(struct bio *);
+extern struct bio *bio_setup_user_buffer(struct request_queue *, unsigned int,
+					 int);
+extern void bio_destroy_user_buffer(struct bio *bio);
 void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 83dcd8c..7382988 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -670,8 +670,15 @@ extern void blk_sync_queue(struct reques
 extern void __blk_stop_queue(request_queue_t *q);
 extern void blk_run_queue(request_queue_t *);
 extern void blk_start_queueing(request_queue_t *);
-extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned long);
-extern int blk_rq_unmap_user(struct bio *);
+extern int blk_rq_init_transfer(request_queue_t *, struct request *, void __user *, unsigned long);
+extern int blk_rq_map_user(request_queue_t *, struct request *,
+			   void __user *, unsigned long);
+extern int blk_rq_setup_buffer(struct request *, void __user *, unsigned long);
+extern void blk_rq_destroy_buffer(struct bio *);
+extern int blk_rq_copy_user_iov(struct request *, struct sg_iovec *,
+				int, unsigned long);
+extern int blk_rq_uncopy_user_iov(struct bio *, struct sg_iovec *, int);
+extern int blk_rq_complete_transfer(struct bio *, void __user *, unsigned long);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(request_queue_t *, struct request *,
 			       struct sg_iovec *, int, unsigned int);
-- 
1.4.1.1

