From: michaelc@cs.wisc.edu
Subject: [PATCH 04/10] convert blk_rq_map helpers to use bioset's
	page pool helper
Date: Sat, 20 Oct 2007 00:44:38 -0500
Message-ID: <11928590871413-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
	<1192859085521-git-send-email-michaelc@cs.wisc.edu>
	<11928590862112-git-send-email-michaelc@cs.wisc.edu>
	<11928590861021-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11928590861021-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts the blk_rq map helpers to use the page pool
helpers instead of bio_copy_user. bio_copy/uncopy_user used to allocate
the bio, set up biovecs, allocate pages and copy/uncopy the data. Now
the bio page pool helper only takes care of allocating the bio and pages
and setting up the biovecs. The data transfer is done by a new blk helper
copy_user_iov. This seperation of the bio allocation/setup and copy/uncopy
if data will be useful for mmap support later on in the patches.

Also with this patch, we rename blk_rq_map_user to blk_rq_setup_transfer
to make it clear that it does not necessarily map the data, and because
in the future sg will want to control if it wants to map the data or
copy the data.

This patch is a little larger because it also converts the users
of blk_rq_map_user to the new api.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/bsg.c                 |   23 ++-
 block/ll_rw_blk.c           |  370 ++++++++++++++++++++++++++++++++-----------
 block/scsi_ioctl.c          |   11 +-
 drivers/block/pktcdvd.c     |    3 +-
 drivers/cdrom/cdrom.c       |    4 +-
 drivers/md/dm-mpath-rdac.c  |    3 +-
 drivers/scsi/scsi_lib.c     |    4 +-
 drivers/scsi/scsi_tgt_lib.c |    5 +-
 fs/bio.c                    |  263 ++++++++-----------------------
 include/linux/bio.h         |   16 +-
 include/linux/blkdev.h      |   18 ++-
 11 files changed, 396 insertions(+), 324 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 8e181ab..5ff02fa 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -281,7 +281,9 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 		rq->next_rq = next_rq;
 
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
-		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
+		dxfer_len = hdr->din_xfer_len;
+		ret = blk_rq_setup_transfer(NULL, next_rq, dxferp, dxfer_len,
+					    GFP_KERNEL);
 		if (ret)
 			goto out;
 	}
@@ -296,7 +298,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 		dxfer_len = 0;
 
 	if (dxfer_len) {
-		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
+		ret = blk_rq_setup_transfer(NULL, rq, dxferp, dxfer_len,
+					    GFP_KERNEL);
 		if (ret)
 			goto out;
 	}
@@ -304,7 +307,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 out:
 	blk_put_request(rq);
 	if (next_rq) {
-		blk_rq_unmap_user(next_rq->bio);
+		blk_rq_complete_transfer(next_rq->bio, dxferp, dxfer_len);
 		blk_put_request(next_rq);
 	}
 	return ERR_PTR(ret);
@@ -409,6 +412,8 @@ static struct bsg_command *bsg_get_done_cmd(struct bsg_device *bd)
 static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 				    struct bio *bio, struct bio *bidi_bio)
 {
+	unsigned int dxfer_len = 0;
+	void *dxferp = NULL;
 	int ret = 0;
 
 	dprintk("rq %p bio %p %u\n", rq, bio, rq->errors);
@@ -438,14 +443,18 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	if (rq->next_rq) {
 		hdr->dout_resid = rq->data_len;
 		hdr->din_resid = rq->next_rq->data_len;
-		blk_rq_unmap_user(bidi_bio);
+		blk_rq_complete_transfer(bidi_bio,
+					 (void __user *)hdr->din_xferp,
+					 hdr->din_xfer_len);
 		blk_put_request(rq->next_rq);
-	} else if (rq_data_dir(rq) == READ)
+	} else if (rq_data_dir(rq) == READ) {
 		hdr->din_resid = rq->data_len;
-	else
+		dxfer_len = hdr->din_xfer_len;
+		dxferp = (void*)(unsigned long)hdr->din_xferp;
+	} else
 		hdr->dout_resid = rq->data_len;
 
-	blk_rq_unmap_user(bio);
+	blk_rq_complete_transfer(bio, dxferp, dxfer_len);
 	blk_put_request(rq);
 
 	return ret;
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 7c90e9b..fad17de 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -36,6 +36,10 @@
  * for max sense size
  */
 #include <scsi/scsi_cmnd.h>
+/*
+ * for struct sg_iovc
+ */
+#include <scsi/sg.h>
 
 static void blk_unplug_work(struct work_struct *work);
 static void blk_unplug_timeout(unsigned long data);
@@ -2337,20 +2341,6 @@ void blk_insert_request(struct request_queue *q, struct request *rq,
 
 EXPORT_SYMBOL(blk_insert_request);
 
-static int __blk_rq_unmap_user(struct bio *bio)
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
-	return ret;
-}
-
 int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio)
 {
@@ -2368,25 +2358,64 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_append_bio);
 
-static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
-			     void __user *ubuf, unsigned int len)
+static void __blk_rq_destroy_buffer(struct bio *bio)
 {
-	unsigned long uaddr;
+	if (!bio)
+		return;
+
+	if (bio_flagged(bio, BIO_USER_MAPPED))
+		bio_unmap_user(bio);
+	else
+		bioset_free_pages(bio);
+}
+
+void blk_rq_destroy_buffer(struct bio *bio)
+{
+	struct bio *mapped_bio;
+
+	while (bio) {
+		mapped_bio = bio;
+		if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
+			mapped_bio = bio->bi_private;
+
+		__blk_rq_destroy_buffer(mapped_bio);
+		mapped_bio = bio;
+		bio = bio->bi_next;
+		bio_put(mapped_bio);
+	}
+}
+EXPORT_SYMBOL(blk_rq_destroy_buffer);
+
+static int __blk_rq_setup_buffer(struct bio_set *bs, struct request *rq,
+				 void __user *ubuf, unsigned int len,
+				 gfp_t gfp_mask)
+{
+	struct request_queue *q = rq->q;
 	struct bio *bio, *orig_bio;
 	int reading, ret;
 
 	reading = rq_data_dir(rq) == READ;
 
-	/*
-	 * if alignment requirement is satisfied, map in user pages for
-	 * direct dma. else, set up kernel bounce buffers
-	 */
-	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
-		bio = bio_map_user(q, uaddr, len, reading);
-	else
-		bio = bio_copy_user(q, uaddr, len, reading);
+	if (ubuf) {
+		unsigned long map_len, end, start;
 
+		map_len = min_t(unsigned long, len, BIO_MAX_SIZE);
+		end = ((unsigned long)ubuf + map_len + PAGE_SIZE - 1)
+								>> PAGE_SHIFT;
+		start = (unsigned long)ubuf >> PAGE_SHIFT;
+		/*
+		 * A bad offset could cause us to require BIO_MAX_PAGES + 1
+		 * pages. If this happens we just lower the requested
+		 * mapping len by a page so that we can fit
+		 */
+		if (end - start > BIO_MAX_PAGES)
+			map_len -= PAGE_SIZE;
+
+		bio = bio_map_user(q, bs, (unsigned long)ubuf, map_len,
+				   reading, gfp_mask);
+	} else
+		bio = bioset_add_pages(q, bs, len, reading,
+				       gfp_mask);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
@@ -2405,100 +2434,249 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 
 	/* if it was boucned we must call the end io function */
 	bio_endio(bio, 0);
-	__blk_rq_unmap_user(orig_bio);
+	__blk_rq_destroy_buffer(orig_bio);
 	bio_put(bio);
 	return ret;
 }
 
 /**
- * blk_rq_map_user - map user data to a request, for REQ_BLOCK_PC usage
- * @q:		request queue where request should be inserted
+ * blk_rq_setup_buffer - setup buffer to bio mappings
+ * @bs:		optional bio set
  * @rq:		request structure to fill
- * @ubuf:	the user buffer
+ * @ubuf:	the user buffer (required for map)
  * @len:	length of user data
+ * @gfp_mask:	gfp flags to use for bio allocations
  *
  * Description:
  *    Data will be mapped directly for zero copy io, if possible. Otherwise
- *    a kernel bounce buffer is used.
+ *    a kernel bounce buffer is used. Callers should only use this function
+ *    if they know that the map will always be successful or they are
+ *    prepared to handle the copy part of the operation.
  *
- *    A matching blk_rq_unmap_user() must be issued at the end of io, while
+ *    A matching blk_complete_transfer must be issued at the end of io, while
  *    still in process context.
  *
- *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
- *    before being submitted to the device, as pages mapped may be out of
- *    reach. It's the callers responsibility to make sure this happens. The
- *    original bio must be passed back in to blk_rq_unmap_user() for proper
- *    unmapping.
+ *    Note: The original rq->bio must be passed back in to blk_complete_transfer
+ *    for proper unmapping.
  */
-int blk_rq_map_user(struct request_queue *q, struct request *rq,
-		    void __user *ubuf, unsigned long len)
+int blk_rq_setup_buffer(struct bio_set *bs, struct request *rq,
+			void __user *ubuf, unsigned long len, gfp_t gfp_mask)
 {
+	struct request_queue *q = rq->q;
 	unsigned long bytes_read = 0;
 	struct bio *bio = NULL;
 	int ret;
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
-	if (!len || !ubuf)
-		return -EINVAL;
 
 	while (bytes_read != len) {
-		unsigned long map_len, end, start;
-
-		map_len = min_t(unsigned long, len - bytes_read, BIO_MAX_SIZE);
-		end = ((unsigned long)ubuf + map_len + PAGE_SIZE - 1)
-								>> PAGE_SHIFT;
-		start = (unsigned long)ubuf >> PAGE_SHIFT;
-
-		/*
-		 * A bad offset could cause us to require BIO_MAX_PAGES + 1
-		 * pages. If this happens we just lower the requested
-		 * mapping len by a page so that we can fit
-		 */
-		if (end - start > BIO_MAX_PAGES)
-			map_len -= PAGE_SIZE;
-
-		ret = __blk_rq_map_user(q, rq, ubuf, map_len);
+		ret = __blk_rq_setup_buffer(bs, rq, ubuf, len - bytes_read,
+					    gfp_mask);
 		if (ret < 0)
 			goto unmap_rq;
 		if (!bio)
 			bio = rq->bio;
 		bytes_read += ret;
-		ubuf += ret;
+		if (ubuf)
+			ubuf += ret;
 	}
 
 	rq->buffer = rq->data = NULL;
 	return 0;
 unmap_rq:
-	blk_rq_unmap_user(bio);
+	blk_rq_destroy_buffer(bio);
+	rq->bio = NULL;
+	return ret;
+}
+EXPORT_SYMBOL(blk_rq_setup_buffer);
+
+static int blk_copy_user_iov(struct bio *head, struct sg_iovec *iov,
+			     int iov_count)
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
+	return 0;
+}
+
+/**
+ * blk_rq_copy_user_iov - copy user data to a request.
+ * @bs:		optional bio set
+ * @rq:		request structure to fill
+ * @iov:	sg iovec
+ * @iov_count:	number of elements in the iovec
+ * @len:	max length of data (length of buffer)
+ * @gfp_mask:	gfp flag for bio allocations
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
+int blk_rq_copy_user_iov(struct bio_set *bs, struct request *rq,
+			 struct sg_iovec *iov, int iov_count,
+			 unsigned long len, gfp_t gfp_mask)
+{
+	int ret;
+
+	ret = blk_rq_setup_buffer(bs, rq, NULL, len, gfp_mask);
+	if (ret)
+		return ret;
+
+	if (rq_data_dir(rq) == READ)
+		return 0;
+
+	ret = blk_copy_user_iov(rq->bio, iov, iov_count);
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
+		ret = blk_copy_user_iov(bio, iov, iov_count);
+	blk_rq_destroy_buffer(bio);
 	return ret;
 }
+EXPORT_SYMBOL(blk_rq_uncopy_user_iov);
 
-EXPORT_SYMBOL(blk_rq_map_user);
+/**
+ * blk_rq_setup_transfer - map or copy user data to a request.
+ * @bs:		optional bio set
+ * @rq:		request structure to fill
+ * @ubuf:	the user buffer
+ * @len:	length of user data
+ * @gfp_mask:	gfp flag for bio allocations
+ *
+ * Description:
+ *    This function is for REQ_BLOCK_PC usage.
+ *    Data will be mapped directly for zero copy io, if possible. Otherwise
+ *    a kernel bounce buffer is used. This function will try to map data
+ *    first and if that is not possible then it will try to setup buffers
+ *    to copy the data.
+ *
+ *    A matching blk_rq_complete_transfer() must be issued at the end of io,
+ *    while still in process context.
+ *
+ *    Note: The original bio must be passed back in to
+ *    blk_rq_complete_transfer() for proper unmapping.
+ */
+int blk_rq_setup_transfer(struct bio_set *bs, struct request *rq,
+			  void __user *ubuf, unsigned long len, gfp_t gfp_mask)
+{
+	int ret;
+
+	if (!ubuf)
+		return -EINVAL;
+
+	ret = blk_rq_setup_buffer(bs, rq, ubuf, len, gfp_mask);
+	if (ret) {
+		struct sg_iovec iov;
+
+		iov.iov_base = ubuf;
+		iov.iov_len = len;
+
+		ret = blk_rq_copy_user_iov(bs, rq, &iov, 1, len, gfp_mask);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(blk_rq_setup_transfer);
 
 /**
  * blk_rq_map_user_iov - map user data to a request, for REQ_BLOCK_PC usage
- * @q:		request queue where request should be inserted
+ * @bs:		optional bio set
  * @rq:		request to map data to
  * @iov:	pointer to the iovec
  * @iov_count:	number of elements in the iovec
  * @len:	I/O byte count
+ * @gfp_mask:	gfp flag for bio allocations
  *
  * Description:
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
-int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
-			struct sg_iovec *iov, int iov_count, unsigned int len)
+int blk_rq_map_user_iov(struct bio_set *bs, struct request *rq,
+			struct sg_iovec *iov, int iov_count, unsigned int len,
+			gfp_t gfp_mask)
 {
 	struct bio *bio;
 
@@ -2508,7 +2686,8 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	/* we don't allow misaligned data like bio_map_user() does.  If the
 	 * user is using sg, they're expected to know the alignment constraints
 	 * and respect them accordingly */
-	bio = bio_map_user_iov(q, iov, iov_count, rq_data_dir(rq)== READ);
+	bio = bio_map_user_iov(rq->q, bs, iov, iov_count,
+			       rq_data_dir(rq)== READ, gfp_mask);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
@@ -2519,7 +2698,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	}
 
 	bio_get(bio);
-	blk_rq_bio_prep(q, rq, bio);
+	blk_rq_bio_prep(rq->q, rq, bio);
 	rq->buffer = rq->data = NULL;
 	return 0;
 }
@@ -2527,48 +2706,49 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
- * blk_rq_unmap_user - unmap a request with user data
- * @bio:	       start of bio list
+ * blk_rq_complete_transfer - unmap a request with user data
+ * @bio:	start of bio list
+ * @ubuf:	buffer to copy to if needed
+ * @len:	number of bytes to copy if needed
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
+ * @bs:		optional bio set
  * @q:		request queue where request should be inserted
  * @rq:		request to fill
  * @kbuf:	the kernel buffer
  * @len:	length of user data
  * @gfp_mask:	memory allocation flags
  */
-int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
-		    unsigned int len, gfp_t gfp_mask)
+int blk_rq_map_kern(struct bio_set *bs, struct request_queue *q,
+		    struct request *rq, void *kbuf, unsigned int len,
+		    gfp_t gfp_mask)
 {
 	struct bio *bio;
 
@@ -2577,7 +2757,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (!len || !kbuf)
 		return -EINVAL;
 
-	bio = bio_map_kern(q, kbuf, len, gfp_mask);
+	bio = bio_map_kern(q, bs, kbuf, len, gfp_mask);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
@@ -2592,7 +2772,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 
 EXPORT_SYMBOL(blk_rq_map_kern);
 
-/**
+/*
  * blk_execute_rq_nowait - insert a request into queue for execution
  * @q:		queue to insert the request in
  * @bd_disk:	matching gendisk
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 91c7322..bf97b22 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -245,7 +245,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
  */
 static int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
 {
-	blk_rq_unmap_user(rq->bio);
+	blk_rq_complete_transfer(rq->bio, hdr->dxferp, hdr->dxfer_len);
 	blk_put_request(rq);
 	return 0;
 }
@@ -343,11 +343,12 @@ static int sg_io(struct file *file, struct request_queue *q,
 			goto out;
 		}
 
-		ret = blk_rq_map_user_iov(q, rq, iov, hdr->iovec_count,
-					  hdr->dxfer_len);
+		ret = blk_rq_map_user_iov(NULL, rq, iov, hdr->iovec_count,
+					  hdr->dxfer_len, GFP_KERNEL);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
+		ret = blk_rq_setup_transfer(NULL, rq, hdr->dxferp,
+					    hdr->dxfer_len, GFP_KERNEL);
 
 	if (ret)
 		goto out;
@@ -485,7 +486,7 @@ int sg_scsi_ioctl(struct file *file, struct request_queue *q,
 		break;
 	}
 
-	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
+	if (bytes && blk_rq_map_kern(NULL, q, rq, buffer, bytes, __GFP_WAIT)) {
 		err = DRIVER_ERROR << 24;
 		goto out;
 	}
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a8130a4..94c307b 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -760,7 +760,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 			     WRITE : READ, __GFP_WAIT);
 
 	if (cgc->buflen) {
-		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
+		if (blk_rq_map_kern(NULL, q, rq, cgc->buffer, cgc->buflen,
+				    __GFP_WAIT))
 			goto out;
 	}
 
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 7924571..5a037ff 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2122,7 +2122,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		len = nr * CD_FRAMESIZE_RAW;
 
-		ret = blk_rq_map_user(q, rq, ubuf, len);
+		ret = blk_rq_setup_transfer(NULL, rq, ubuf, len, GFP_KERNEL);
 		if (ret)
 			break;
 
@@ -2149,7 +2149,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 			cdi->last_sense = s->sense_key;
 		}
 
-		if (blk_rq_unmap_user(bio))
+		if (blk_rq_complete_transfer(bio, ubuf, len))
 			ret = -EFAULT;
 
 		if (ret)
diff --git a/drivers/md/dm-mpath-rdac.c b/drivers/md/dm-mpath-rdac.c
index 16b1613..9e71e0e 100644
--- a/drivers/md/dm-mpath-rdac.c
+++ b/drivers/md/dm-mpath-rdac.c
@@ -278,7 +278,8 @@ static struct request *get_rdac_req(struct rdac_handler *h,
 		return NULL;
 	}
 
-	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_KERNEL)) {
+	if (buflen && blk_rq_map_kern(NULL, q, rq, buffer, buflen,
+				      GFP_KERNEL)) {
 		blk_put_request(rq);
 		DMINFO("get_rdac_req: blk_rq_map_kern failed");
 		return NULL;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index aac8a02..c799e98 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -186,7 +186,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 
 	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
 
-	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
+	if (bufflen &&	blk_rq_map_kern(NULL, sdev->request_queue, req,
 					buffer, bufflen, __GFP_WAIT))
 		goto out;
 
@@ -396,7 +396,7 @@ int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
 	if (use_sg)
 		err = scsi_req_map_sg(req, buffer, use_sg, bufflen, gfp);
 	else if (bufflen)
-		err = blk_rq_map_kern(req->q, req, buffer, bufflen, gfp);
+		err = blk_rq_map_kern(NULL, req->q, req, buffer, bufflen, gfp);
 
 	if (err)
 		goto free_req;
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index a91761c..7e0189c 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -171,7 +171,7 @@ static void cmd_hashlist_del(struct scsi_cmnd *cmd)
 
 static void scsi_unmap_user_pages(struct scsi_tgt_cmd *tcmd)
 {
-	blk_rq_unmap_user(tcmd->bio);
+	blk_rq_destroy_buffer(tcmd->bio);
 }
 
 static void scsi_tgt_cmd_destroy(struct work_struct *work)
@@ -381,12 +381,11 @@ static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 			       unsigned long uaddr, unsigned int len, int rw)
 {
-	struct request_queue *q = cmd->request->q;
 	struct request *rq = cmd->request;
 	int err;
 
 	dprintk("%lx %u\n", uaddr, len);
-	err = blk_rq_map_user(q, rq, (void *)uaddr, len);
+	err = blk_rq_setup_buffer(NULL, rq, (void *)uaddr, len, GFP_KERNEL);
 	if (err) {
 		/*
 		 * TODO: need to fixup sg_tablesize, max_segment_size,
diff --git a/fs/bio.c b/fs/bio.c
index 1e8db03..df90896 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -136,7 +136,9 @@ static void bio_fs_destructor(struct bio *bio)
 
 static void bio_blk_destructor(struct bio *bio)
 {
-	bio_free(bio, blk_bio_set);
+	struct bio_set *bs = bio->bi_private;
+
+	bio_free(bio, bs);
 }
 
 void bio_init(struct bio *bio)
@@ -186,20 +188,13 @@ out:
 	return bio;
 }
 
-#if 0
-This #if is just to break up the patchset, make it easier to read
-and git bisectable.
-
-This patch extends biosets to have page pools. The next patch will replace
-bio_copy_user and friends with the the bioset version added below.
-
 struct bio_map_vec {
 	struct page *page;
-	unsigned int len;
 	void __user *userptr;
 };
 
 struct bio_map_data {
+	struct bio_set *bs;
 	struct bio_map_vec *iovecs;
 	int nr_vecs;
 };
@@ -210,14 +205,14 @@ static void bio_free_map_data(struct bio_map_data *bmd)
 	kfree(bmd);
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs)
+static struct bio_map_data *bio_alloc_map_data(int nr_segs, gfp_t gfp_mask)
 {
-	struct bio_map_data *bmd = kzalloc(sizeof(*bmd), GFP_KERNEL);
+	struct bio_map_data *bmd = kzalloc(sizeof(*bmd), gfp_mask);
 
 	if (!bmd)
 		return NULL;
 
-	bmd->iovecs = kmalloc(sizeof(struct bio_map_vec) * nr_segs, GFP_KERNEL);
+	bmd->iovecs = kzalloc(sizeof(struct bio_map_vec) * nr_segs, gfp_mask);
 	if (bmd->iovecs)
 		return bmd;
 
@@ -225,15 +220,28 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs)
 	return NULL;
 }
 
+static void bio_bmd_destructor(struct bio *bio)
+{
+	struct bio_map_data *bmd = bio->bi_private;
+	struct bio_set *bs;
+
+	if (!bmd)
+		return;
+	bs = bmd->bs;
+	bio_free_map_data(bmd);
+	bio_free(bio, bs);
+}
 
-void bioset_free_pages(struct bio_set *bs, struct bio *bio)
+void bioset_free_pages(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
+	struct bio_set *bs = bmd->bs;
 	int i;
 
-	for (i = 0; i < bmd->nr_vecs; i++)
-		mempool_free(bmd->iovecs[i].page, bs->page_pool);
-	bio_free_map_data(bmd);
+	for (i = 0; i < bmd->nr_vecs; i++) {
+		if (bmd->iovecs[i].page)
+			mempool_free(bmd->iovecs[i].page, bs->page_pool);
+	}
 	bio_put(bio);
 }
 
@@ -246,27 +254,33 @@ struct bio *bioset_add_pages(struct request_queue *q, struct bio_set *bs,
 	struct bio *bio;
 	int i = 0, ret;
 
-	bmd = bio_alloc_map_data(nr_pages);
+	bmd = bio_alloc_map_data(nr_pages, gfp_mask);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
+	if (!bs)
+		bs = blk_bio_set;
 	bio = bio_alloc_bioset(gfp_mask, nr_pages, bs);
 	if (!bio)
 		goto out_bmd;
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
+	bio->bi_destructor = bio_bmd_destructor;
+	bio->bi_private = bmd;
+	bmd->bs = bs;
 
 	ret = 0;
 	while (len) {
 		unsigned add_len;
 
 		page = mempool_alloc(bs->page_pool, q->bounce_gfp | gfp_mask);
-		if (!page)
-			goto cleanup;
-
+		if (!page) {
+			ret = -ENOMEM;
+			bioset_free_pages(bio);
+			goto fail;
+		}
 		bmd->nr_vecs++;
 		bmd->iovecs[i].page = page;
-		bmd->iovecs[i].len = 0;
 
 		add_len = min_t(unsigned int,
 			       (1 << bs->page_pool_order) << PAGE_SHIFT, len);
@@ -277,7 +291,6 @@ struct bio *bioset_add_pages(struct request_queue *q, struct bio_set *bs,
 				bytes = add_len;
 
 			added = bio_add_pc_page(q, bio, page++, bytes, 0);
-			bmd->iovecs[i].len += added;
 			if (added < bytes)
 				break;
 			add_len -= bytes;
@@ -286,17 +299,13 @@ struct bio *bioset_add_pages(struct request_queue *q, struct bio_set *bs,
 		i++;
 	}
 
-	bio->bi_private = bmd;
 	return bio;
 
-cleanup:
-	bioset_free_pages(bs, bio);
-	bio_free(bio, bs);
 out_bmd:
 	bio_free_map_data(bmd);
+fail:
 	return ERR_PTR(ret);
 }
-#endif
 
 struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 {
@@ -565,159 +574,10 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 	return __bio_add_page(q, bio, page, len, offset, q->max_sectors);
 }
 
-struct bio_map_data {
-	struct bio_vec *iovecs;
-	void __user *userptr;
-};
-
-static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio)
-{
-	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
-	bio->bi_private = bmd;
-}
-
-static void bio_free_map_data(struct bio_map_data *bmd)
-{
-	kfree(bmd->iovecs);
-	kfree(bmd);
-}
-
-static struct bio_map_data *bio_alloc_map_data(int nr_segs)
-{
-	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), GFP_KERNEL);
-
-	if (!bmd)
-		return NULL;
-
-	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, GFP_KERNEL);
-	if (bmd->iovecs)
-		return bmd;
-
-	kfree(bmd);
-	return NULL;
-}
-
-/**
- *	bio_uncopy_user	-	finish previously mapped bio
- *	@bio: bio being terminated
- *
- *	Free pages allocated from bio_copy_user() and write back data
- *	to user space in case of a read.
- */
-int bio_uncopy_user(struct bio *bio)
-{
-	struct bio_map_data *bmd = bio->bi_private;
-	const int read = bio_data_dir(bio) == READ;
-	struct bio_vec *bvec;
-	int i, ret = 0;
-
-	__bio_for_each_segment(bvec, bio, i, 0) {
-		char *addr = page_address(bvec->bv_page);
-		unsigned int len = bmd->iovecs[i].bv_len;
-
-		if (read && !ret && copy_to_user(bmd->userptr, addr, len))
-			ret = -EFAULT;
-
-		__free_page(bvec->bv_page);
-		bmd->userptr += len;
-	}
-	bio_free_map_data(bmd);
-	bio_put(bio);
-	return ret;
-}
-
-/**
- *	bio_copy_user	-	copy user data to bio
- *	@q: destination block queue
- *	@uaddr: start of user address
- *	@len: length in bytes
- *	@write_to_vm: bool indicating writing to pages or not
- *
- *	Prepares and returns a bio for indirect user io, bouncing data
- *	to/from kernel pages as necessary. Must be paired with
- *	call bio_uncopy_user() on io completion.
- */
-struct bio *bio_copy_user(struct request_queue *q, unsigned long uaddr,
-			  unsigned int len, int write_to_vm)
-{
-	unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = uaddr >> PAGE_SHIFT;
-	struct bio_map_data *bmd;
-	struct bio_vec *bvec;
-	struct page *page;
-	struct bio *bio;
-	int i, ret;
-
-	bmd = bio_alloc_map_data(end - start);
-	if (!bmd)
-		return ERR_PTR(-ENOMEM);
-
-	bmd->userptr = (void __user *) uaddr;
-
-	ret = -ENOMEM;
-	bio = bio_alloc_bioset(GFP_KERNEL, end - start, blk_bio_set);
-	if (!bio)
-		goto out_bmd;
-
-	bio->bi_rw |= (!write_to_vm << BIO_RW);
-	bio->bi_destructor = bio_blk_destructor;
-
-	ret = 0;
-	while (len) {
-		unsigned int bytes = PAGE_SIZE;
-
-		if (bytes > len)
-			bytes = len;
-
-		page = alloc_page(q->bounce_gfp | GFP_KERNEL);
-		if (!page) {
-			ret = -ENOMEM;
-			break;
-		}
-
-		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes)
-			break;
-
-		len -= bytes;
-	}
-
-	if (ret)
-		goto cleanup;
-
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
-		}
-	}
-
-	bio_set_map_data(bmd, bio);
-	return bio;
-cleanup:
-	bio_for_each_segment(bvec, bio, i)
-		__free_page(bvec->bv_page);
-
-	bio_put(bio);
-out_bmd:
-	bio_free_map_data(bmd);
-	return ERR_PTR(ret);
-}
-
 static struct bio *__bio_map_user_iov(struct request_queue *q,
-				      struct sg_iovec *iov, int iov_count,
-				      int write_to_vm)
+				      struct bio_set *bs, struct sg_iovec *iov,
+				      int iov_count, int write_to_vm,
+				      gfp_t gfp_mask)
 {
 	int i, j;
 	int nr_pages = 0;
@@ -743,13 +603,16 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!nr_pages)
 		return ERR_PTR(-EINVAL);
 
-	bio = bio_alloc_bioset(GFP_KERNEL, nr_pages, blk_bio_set);
+	if (!bs)
+		bs = blk_bio_set;
+	bio = bio_alloc_bioset(gfp_mask, nr_pages, bs);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 	bio->bi_destructor = bio_blk_destructor;
+	bio->bi_private = bs;
 
 	ret = -ENOMEM;
-	pages = kcalloc(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	pages = kcalloc(nr_pages, sizeof(struct page *), gfp_mask);
 	if (!pages)
 		goto out;
 
@@ -827,40 +690,46 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 /**
  *	bio_map_user	-	map user address into bio
  *	@q: the struct request_queue for the bio
+ *	@bs: bio set
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@gfp_mask: gfp flag
  *
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_user(struct request_queue *q, unsigned long uaddr,
-			 unsigned int len, int write_to_vm)
+struct bio *bio_map_user(struct request_queue *q, struct bio_set *bs,
+			 unsigned long uaddr, unsigned int len, int write_to_vm,
+			 gfp_t gfp_mask)
 {
 	struct sg_iovec iov;
 
 	iov.iov_base = (void __user *)uaddr;
 	iov.iov_len = len;
 
-	return bio_map_user_iov(q, &iov, 1, write_to_vm);
+	return bio_map_user_iov(q, bs, &iov, 1, write_to_vm, gfp_mask);
 }
 
 /**
  *	bio_map_user_iov - map user sg_iovec table into bio
  *	@q: the struct request_queue for the bio
+ *	@bs: bio set
  *	@iov:	the iovec.
  *	@iov_count: number of elements in the iovec
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@gfp_mask: gfp flag
  *
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_user_iov(struct request_queue *q, struct sg_iovec *iov,
-			     int iov_count, int write_to_vm)
+struct bio *bio_map_user_iov(struct request_queue *q, struct bio_set *bs,
+			     struct sg_iovec *iov, int iov_count,
+			     int write_to_vm, gfp_t gfp_mask)
 {
 	struct bio *bio;
 
-	bio = __bio_map_user_iov(q, iov, iov_count, write_to_vm);
+	bio = __bio_map_user_iov(q, bs, iov, iov_count, write_to_vm, gfp_mask);
 
 	if (IS_ERR(bio))
 		return bio;
@@ -915,8 +784,8 @@ static void bio_map_kern_endio(struct bio *bio, int err)
 }
 
 
-static struct bio *__bio_map_kern(struct request_queue *q, void *data,
-				  unsigned int len, gfp_t gfp_mask)
+static struct bio *__bio_map_kern(struct request_queue *q, struct bio_set *bs,
+				  void *data, unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long kaddr = (unsigned long)data;
 	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -925,10 +794,13 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 	int offset, i;
 	struct bio *bio;
 
-	bio = bio_alloc_bioset(gfp_mask, nr_pages, blk_bio_set);
+	if (!bs)
+		bs = blk_bio_set;
+	bio = bio_alloc_bioset(gfp_mask, nr_pages, bs);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 	bio->bi_destructor = bio_blk_destructor;
+	bio->bi_private = bs;
 
 	offset = offset_in_page(kaddr);
 	for (i = 0; i < nr_pages; i++) {
@@ -956,6 +828,7 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 /**
  *	bio_map_kern	-	map kernel address into bio
  *	@q: the struct request_queue for the bio
+ *	@bs: bio set
  *	@data: pointer to buffer to map
  *	@len: length in bytes
  *	@gfp_mask: allocation flags for bio allocation
@@ -963,12 +836,12 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
-			 gfp_t gfp_mask)
+struct bio *bio_map_kern(struct request_queue *q, struct bio_set *bs,
+			 void *data, unsigned int len, gfp_t gfp_mask)
 {
 	struct bio *bio;
 
-	bio = __bio_map_kern(q, data, len, gfp_mask);
+	bio = __bio_map_kern(q, bs, data, len, gfp_mask);
 	if (IS_ERR(bio))
 		return bio;
 
@@ -1321,7 +1194,7 @@ static int __init init_bio(void)
 	if (!fs_bio_set)
 		panic("bio: can't allocate bios\n");
 
-	blk_bio_set = bioset_create(BIO_POOL_SIZE, 2);
+	blk_bio_set = bioset_pagepool_create(BIO_POOL_SIZE, 2, 0);
 	if (!blk_bio_set)
 		panic("Failed to create blk_bio_set");
 
@@ -1351,8 +1224,6 @@ EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
 EXPORT_SYMBOL(bio_split_pool);
-EXPORT_SYMBOL(bio_copy_user);
-EXPORT_SYMBOL(bio_uncopy_user);
 EXPORT_SYMBOL(bioset_create);
 EXPORT_SYMBOL(bioset_pagepool_create);
 EXPORT_SYMBOL(bioset_free);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2d28c3b..b860448 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -317,19 +317,21 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern struct bio *bio_map_user(struct request_queue *, unsigned long,
-				unsigned int, int);
+extern struct bio *bio_map_user(struct request_queue *, struct bio_set *,
+				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
 extern struct bio *bio_map_user_iov(struct request_queue *,
-				    struct sg_iovec *, int, int);
+				    struct bio_set *, struct sg_iovec *,
+				    int, int, gfp_t);
 extern void bio_unmap_user(struct bio *);
-extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
-				gfp_t);
+extern struct bio *bio_map_kern(struct request_queue *, struct bio_set *,
+				void *, unsigned int, gfp_t);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern void bio_release_pages(struct bio *bio);
-extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
-extern int bio_uncopy_user(struct bio *);
+extern void bioset_free_pages(struct bio *);
+extern struct bio *bioset_add_pages(struct request_queue *,
+				    struct bio_set *, unsigned int, int, gfp_t);
 void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bbf906a..75f92cb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -687,11 +687,19 @@ extern void blk_sync_queue(struct request_queue *q);
 extern void __blk_stop_queue(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_start_queueing(struct request_queue *);
-extern int blk_rq_map_user(struct request_queue *, struct request *, void __user *, unsigned long);
-extern int blk_rq_unmap_user(struct bio *);
-extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
-extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
-			       struct sg_iovec *, int, unsigned int);
+extern int blk_rq_setup_transfer(struct bio_set *, struct request *,
+				 void __user *, unsigned long, gfp_t);
+extern int blk_rq_complete_transfer(struct bio *, void __user *, unsigned long);
+extern int blk_rq_setup_buffer(struct bio_set *, struct request *,
+			       void __user *, unsigned long, gfp_t);
+extern void blk_rq_destroy_buffer(struct bio *);
+extern int blk_rq_map_kern(struct bio_set *, struct request_queue *,
+			   struct request *, void *, unsigned int, gfp_t);
+extern int blk_rq_map_user_iov(struct bio_set *, struct request *,
+			       struct sg_iovec *, int, unsigned int, gfp_t);
+extern int blk_rq_copy_user_iov(struct bio_set *, struct request *,
+				struct sg_iovec *, int, unsigned long, gfp_t);
+extern int blk_rq_uncopy_user_iov(struct bio *, struct sg_iovec *, int);
 extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
-- 
1.5.1.2
