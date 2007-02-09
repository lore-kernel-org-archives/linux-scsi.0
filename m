From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/2] mv sg.c features to the block layer
Date: Fri, 09 Feb 2007 03:34:42 -0500
Message-ID: <1171010082.3713.27.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35464 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946265AbXBIJfK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 04:35:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, dougg@torque.net, linux-scsi@vger.kernel.org

This patch moves the reserve buffer, large segment allocations, and mmap
to the block layer. This patches also converts bsg, tgt, cdrom, and
scsi_ioctl.c to the change in the blk_rq_map_user api. A side affect of
coverting tgt to the new api, is that I killed the scsi_cmnd->offset
field which was supposed to be removed before merging but snuck in. It
also kills the tgt bio layer violations.

The mmap code and reserve buffer code is very simple. It should behave
and work like sg where we have one command using the reserve buffer at a
time. If it does not and will affect users, let me know and I will fix.
The bsg and scsi_ioctl code does not use the reserve buffer or mmap
code, and that should behave like it did before, except for the copy
path we allocated multiple pages at a time so we can get very large IOs.

The patches have been lightly tested. I ran sg utils over a block
device. I did not test cdrom, tgt or bsg.

If you guys want me to try and break up the patches to make it easier to
review I will. Then I can resend them in a git bisect friendly way.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/block/bsg.c b/block/bsg.c
index e97e3ec..0bc819d 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -321,7 +321,7 @@ bsg_map_hdr(struct bsg_device *bd, struc
 		dxfer_len = 0;
 
 	if (dxfer_len) {
-		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
+		ret = blk_rq_init_transfer(q, rq, dxferp, dxfer_len);
 		if (ret) {
 			dprintk("failed map at %d\n", ret);
 			blk_put_request(rq);
@@ -460,7 +460,8 @@ static int blk_complete_sgv4_hdr_rq(stru
 			ret = -EFAULT;
 	}
 
-	blk_rq_unmap_user(bio);
+	blk_rq_complete_transfer(rq->q, bio, (void __user *)hdr->din_xferp,
+				 hdr->din_xfer_len);
 	blk_put_request(rq);
 
 	return ret;
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 45bbf8b..d1b9799 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2314,138 +2314,456 @@ void blk_insert_request(request_queue_t 
 
 EXPORT_SYMBOL(blk_insert_request);
 
-static int __blk_rq_unmap_user(struct bio *bio)
+static void free_reserve_buf(struct request_queue *q)
 {
-	int ret = 0;
+	struct blk_reserve_buf *rbuf = q->reserve_buf;
+	struct scatterlist *sg;
+	int i;
+
+	for (i = 0; i < rbuf->sg_count; i++) {
+		sg = &rbuf->sg[i];
+		if (sg->page)
+			__free_pages(sg->page, get_order(sg->length));
+	}
+
+	kfree(rbuf->sg);
+	kfree(rbuf);
+	q->reserve_buf = NULL;
+}
+
+/**
+ * blk_queue_free_reserve_buf - free reserve buffer
+ * @q: the request queue for the device
+ *
+ * It is the responsibility of the caller to make sure it is
+ * no longer processing requests that may be using the reserved
+ * buffer.
+ **/
+int blk_queue_free_reserve_buf(request_queue_t *q)
+{
+	if (!q->reserve_buf)
+		return -EINVAL;
+
+	if (test_and_set_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags))
+		return -EBUSY;
 
+	free_reserve_buf(q);
+	clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
+	return 0;
+}
+EXPORT_SYMBOL(blk_queue_free_reserve_buf);
+
+/**
+ * blk_queue_alloc_reserve_buf - allocate a buffer for pass through
+ * @q: the request queue for the device
+ * @buf_size: size of reserve buffer to allocate
+ *
+ * This is very simple for now. It is copied from sg.c because it is only
+ * meant to support what sg had supported.
+ **/
+int blk_queue_alloc_reserve_buf(request_queue_t *q, unsigned long buf_size)
+{
+	struct blk_reserve_buf *rbuf;
+	struct page *pg;
+	struct scatterlist *sg;
+	int order, i, remainder, allocated;
+	unsigned int segment_size;
+
+	if (q->reserve_buf)
+		return -EEXIST;
+
+	if (test_and_set_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags))
+		return -EBUSY;
+
+	rbuf = kzalloc(sizeof(*rbuf), GFP_KERNEL);
+	if (!rbuf)
+		goto clear_use;
+	q->reserve_buf = rbuf;
+	rbuf->buf_size = buf_size;
+	rbuf->sg_count = min(q->max_phys_segments, q->max_hw_segments);
+
+	rbuf->sg = kzalloc(rbuf->sg_count * sizeof(struct scatterlist),
+			  GFP_KERNEL);
+	if (!rbuf->sg)
+		goto free_buf;
+
+	segment_size = bio_estimate_max_segment_size(q);
+	for (i = 0, remainder = buf_size;
+	     (remainder > 0) && (i < rbuf->sg_count);
+	      ++i, remainder -= allocated) {
+		unsigned int requested_size;
+
+		sg = &rbuf->sg[i];
+
+		requested_size = remainder;
+		if (requested_size > segment_size)
+			requested_size = segment_size;
+
+		pg = bio_alloc_pages(q, requested_size, &order);
+		if (!pg)
+			goto free_buf;
+
+		sg->page = pg;
+		sg->length = (1 << order) << PAGE_SHIFT;
+		allocated = sg->length;
+	}
+
+	if (remainder > 0)
+		goto free_buf;
+
+	rbuf->sg_count = i;
+	clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
+	return 0;
+
+free_buf:
+	free_reserve_buf(q);
+clear_use:
+	clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(blk_queue_alloc_reserve_buf);
+
+/**
+ * blk_get_reserve_seg - get pages from the reserve buffer
+ * @q:		the request queue for the device
+ * @len:	len of segment returned
+ *
+ * This assumes that caller is serializing access to the buffer.
+ **/
+struct page *blk_get_reserve_seg(request_queue_t *q, unsigned int *len)
+{
+	struct blk_reserve_buf *rbuf = q->reserve_buf;
+	struct scatterlist *sg;
+
+	*len = 0;
+	if (!rbuf || rbuf->sg_index >= rbuf->sg_count) {
+		BUG();
+		return NULL;
+	}
+
+	sg = &rbuf->sg[rbuf->sg_index++];
+	*len = sg->length;
+	return sg->page;
+}
+EXPORT_SYMBOL(blk_get_reserve_seg);
+
+/*
+ * sg only allowed one command to use the reserve buf at a time.
+ * We assume the block layer and sg, will always do a put() for a get(),
+ * and will continue to only allow one command to the use the buffer
+ * at a time, so we just decrement the sg_index here.
+ */
+void blk_put_reserve_seg(request_queue_t *q)
+{
+	struct blk_reserve_buf *rbuf = q->reserve_buf;
+
+	if (!rbuf || rbuf->sg_index == 0) {
+		BUG();
+		return;
+	}
+	rbuf->sg_index--;
+}
+EXPORT_SYMBOL(blk_put_reserve_seg);
+
+static int __blk_rq_complete_transfer(struct bio *bio, void __user *ubuf,
+				      unsigned long len, int *err)
+{
+	int bytes = 0;
+
+	*err = 0;
 	if (bio) {
 		if (bio_flagged(bio, BIO_USER_MAPPED))
 			bio_unmap_user(bio);
 		else
-			ret = bio_uncopy_user(bio);
+			bytes = bio_uncopy_user(bio, ubuf, len, err);
 	}
 
-	return ret;
+	return bytes;
 }
 
-static int __blk_rq_map_user(request_queue_t *q, struct request *rq,
-			     void __user *ubuf, unsigned int len)
+static int
+__blk_rq_transfer_from_user(request_queue_t *q, struct request *rq,
+			    void __user *ubuf, unsigned int len,
+			    int write_to_vm, int dio, int use_reserve,
+			    struct bio *(*transfer_fn)(struct request_queue *,
+					unsigned long, unsigned int, int, int))
 {
-	unsigned long uaddr;
+	unsigned long bytes_read = 0;
 	struct bio *bio, *orig_bio;
-	int reading, ret;
+	int reading, ret, tmp = 0;
 
-	reading = rq_data_dir(rq) == READ;
+	if (len > (q->max_hw_sectors << 9))
+		return -EINVAL;
+	if (!len)
+		return -EINVAL;
 
-	/*
-	 * if alignment requirement is satisfied, map in user pages for
-	 * direct dma. else, set up kernel bounce buffers
-	 */
-	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
-		bio = bio_map_user(q, NULL, uaddr, len, reading);
-	else
-		bio = bio_copy_user(q, uaddr, len, reading);
+	reading = write_to_vm;
+	if (reading < 0)
+		reading = rq_data_dir(rq) == READ;
 
-	if (IS_ERR(bio))
-		return PTR_ERR(bio);
+	while (bytes_read != len) {
+		unsigned long map_len, end, start, uaddr = 0;
 
-	orig_bio = bio;
-	blk_queue_bounce(q, &bio);
+		map_len = min_t(unsigned long, len - bytes_read, BIO_MAX_SIZE);
+		if (ubuf && dio) {
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
+		}
 
-	/*
-	 * We link the bounce buffer in and could have to traverse it
-	 * later so we have to get a ref to prevent it from being freed
-	 */
-	bio_get(bio);
+		bio = transfer_fn(q, uaddr, map_len, write_to_vm, use_reserve);
+		if (IS_ERR(bio)) {
+			ret = PTR_ERR(bio);
+			goto unmap_rq;
+		}
 
-	if (!rq->bio)
-		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio)) {
-		ret = -EINVAL;
-		goto unmap_bio;
-	} else {
-		rq->biotail->bi_next = bio;
-		rq->biotail = bio;
+		orig_bio = bio;
+		blk_queue_bounce(q, &bio);
+		/*
+		 * We link the bounce buffer in and could have to traverse it
+		 * later so we have to get a ref to prevent it from being freed
+		 */
+		bio_get(bio);
 
-		rq->data_len += bio->bi_size;
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
+
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
+	__blk_rq_complete_transfer(orig_bio, NULL, 0, &tmp);
 	bio_put(bio);
+unmap_rq:
+	blk_rq_complete_transfer(q, rq->bio, NULL, 0);
+	rq->bio = NULL;
 	return ret;
 }
 
+int blk_claim_reserve_buf(struct request_queue *q, unsigned long len)
+{
+	if (!q->reserve_buf)
+		return -EINVAL;
+
+	if (test_and_set_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags))
+		return -EBUSY;
+
+	if (len > q->reserve_buf->buf_size) {
+		clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+void blk_release_reserve_buf(struct request_queue *q)
+{
+	if (!q->reserve_buf)
+		return;
+
+	if (q->reserve_buf->sg_index != 0)
+		BUG();
+
+	clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
+}
+
 /**
- * blk_rq_map_user - map user data to a request, for REQ_BLOCK_PC usage
+ * blk_rq_mmap - alloc and setup buffers for REQ_BLOCK_PC mmap
+ * @q:		request queue where request should be inserted
+ * @rq:		request structure to fill
+ * @vma:	vm struct
+ * Description:
+ *    A matching blk_rq_complete_transfer() must be issued at the end of io.
+ *    It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_complete_transfer() for
+ *    proper unmapping.
+ *
+ *    The block layer mmap functions implement the old sg.c behavior
+ *    where they can be only one sg mmap command outstanding.
+ */
+int blk_rq_mmap(struct request_queue *q, struct request *rq,
+		struct vm_area_struct *vma)
+{
+	unsigned long len;
+	int ret;
+
+	if (vma->vm_pgoff)
+		return -EINVAL; /* want no offset */
+
+	len = vma->vm_end - vma->vm_start;
+
+	/*
+	 * Need to rename bio_copy/uncopy_user - if addr is NULL it just
+	 * sets up the buffers which makes it handy for mmap.
+	 */
+	ret = blk_rq_copy_user(q, rq, NULL, len, 1);
+	if (ret)
+		return ret;
+
+	vma->vm_flags |= VM_RESERVED;
+	return 0;
+}
+EXPORT_SYMBOL(blk_rq_mmap);
+
+struct page *blk_rq_vma_nopage(struct request_queue *q, struct request *rq,
+			       struct vm_area_struct *vma, unsigned long addr,
+			       int *type)
+{
+	struct page *pg = NOPAGE_SIGBUS;
+	unsigned long offset;
+	struct bio_vec *bvec;
+	struct bio *bio;
+	int i;
+
+	offset = addr - vma->vm_start;
+	if (offset >= rq->data_len)
+		return pg;
+
+	rq_for_each_bio(bio, rq) {
+		bio_for_each_segment(bvec, bio, i) {
+			if (offset == 0) {
+				pg = bvec->bv_page;
+				get_page(pg);
+				break;
+			}
+			offset -= bvec->bv_len;
+		}
+	}
+
+	if (type)
+		*type = VM_FAULT_MINOR;
+	return pg;
+}
+EXPORT_SYMBOL(blk_rq_vma_nopage);
+
+/**
+ * blk_rq_map_user - map user data to a request.
+ * @q:		request queue where request should be inserted
+ * @rq:		request structure to fill
+ * @ubuf:	the user buffer
+ * @len:	length of user data
+ * @write_to_vm: bool indicating writing to pages or not
+ * Description:
+ *    This function is for REQ_BLOCK_PC usage.
+
+ *    Data will be mapped directly for zero copy io.
+ *
+ *    A matching blk_rq_complete_transfer() must be issued at the end of io,
+ *    while still in process context.
+ *
+ *    It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_complete_transfer() for
+ *    proper unmapping.
+ */
+int blk_rq_map_user(request_queue_t *q, struct request *rq,
+		     void __user *ubuf, unsigned long len, int write_to_vm)
+{
+	return __blk_rq_transfer_from_user(q, rq, ubuf, len, write_to_vm,
+					   1, 0, bio_map_user);
+}
+EXPORT_SYMBOL(blk_rq_map_user);
+
+/**
+ * blk_rq_copy_user - copy user data to a request.
+ * @q:		request queue where request should be inserted
+ * @rq:		request structure to fill
+ * @ubuf:	the user buffer
+ * @len:	length of user data
+ * @use_reserve: bool to indicate if the reserve buffer should be used
+ *
+ * Description:
+ *    This function is for REQ_BLOCK_PC usage.
+ *
+ *    A matching blk_rq_complete_transfer() must be issued at the end of io,
+ *    while still in process context.
+ *
+ *    It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_complete_transfer() for
+ *    proper unmapping.
+ */
+int blk_rq_copy_user(request_queue_t *q, struct request *rq,
+		     void __user *ubuf, unsigned long len, int use_reserve)
+{
+	int ret;
+
+	if (use_reserve) {
+		ret = blk_claim_reserve_buf(q, len); 
+		if (ret) {
+			/*
+			 * stupid hack - if ubuf is null, this is getting
+			 * called by mmap so we must use the reserve buffer.
+			 * For other uses we can drop down to __get_free_pages.
+			 */
+			if (!ubuf)
+				return -ENOMEM;
+			use_reserve = 0;
+		}
+	}
+	return  __blk_rq_transfer_from_user(q, rq, ubuf, len, -1, 0,
+					    use_reserve, bio_copy_user);
+}
+EXPORT_SYMBOL(blk_rq_copy_user);
+
+/**
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
+	if (!ubuf)
 		return -EINVAL;
-	if (!len || !ubuf)
-		return -EINVAL;
-
-	while (bytes_read != len) {
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
-		if (ret < 0)
-			goto unmap_rq;
-		if (!bio)
-			bio = rq->bio;
-		bytes_read += ret;
-		ubuf += ret;
-	}
 
-	rq->buffer = rq->data = NULL;
-	return 0;
-unmap_rq:
-	blk_rq_unmap_user(bio);
+	ret = blk_rq_map_user(q, rq, ubuf, len, -1);
+	if (ret)
+		ret = blk_rq_copy_user(q, rq, ubuf, len, 0);
 	return ret;
 }
 
-EXPORT_SYMBOL(blk_rq_map_user);
+EXPORT_SYMBOL(blk_rq_init_transfer);
 
 /**
  * blk_rq_map_user_iov - map user data to a request, for REQ_BLOCK_PC usage
@@ -2498,37 +2816,50 @@ int blk_rq_map_user_iov(request_queue_t 
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
+ *    Unmap a rq mapped with blk_rq_transfer_from_user(). The caller must
+ *    supply the original rq->bio from the blk_rq_transfer_from_user()
+ *    return, since the io completion may have changed rq->bio.
  */
-int blk_rq_unmap_user(struct bio *bio)
+int blk_rq_complete_transfer(struct request_queue *q, struct bio *bio,
+			     void __user *ubuf, unsigned long len)
 {
 	struct bio *mapped_bio;
-	int ret = 0, ret2;
+	int ret = 0, bytes = 0, ret2, used_reserve = 0;
 
 	while (bio) {
+		if (bio_flagged(bio, BIO_USED_RESERVE))
+			used_reserve = 1;
+
 		mapped_bio = bio;
 		if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
 			mapped_bio = bio->bi_private;
 
-		ret2 = __blk_rq_unmap_user(mapped_bio);
+		bytes = __blk_rq_complete_transfer(mapped_bio, ubuf,
+						   len, &ret2);
 		if (ret2 && !ret)
 			ret = ret2;
-
+		if (ubuf) {
+			ubuf += bytes;
+			len -= bytes;
+		}
 		mapped_bio = bio;
 		bio = bio->bi_next;
 		bio_put(mapped_bio);
 	}
 
+	if (used_reserve)
+		blk_release_reserve_buf(q);
 	return ret;
 }
 
-EXPORT_SYMBOL(blk_rq_unmap_user);
+EXPORT_SYMBOL(blk_rq_complete_transfer);
 
 /**
  * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 18e935f..33c54a0 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -244,7 +244,7 @@ EXPORT_SYMBOL_GPL(blk_fill_sghdr_rq);
  */
 int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
 {
-	blk_rq_unmap_user(rq->bio);
+	blk_rq_complete_transfer(rq->q, rq->bio, hdr->dxferp, hdr->dxfer_len);
 	blk_put_request(rq);
 	return 0;
 }
@@ -348,7 +348,7 @@ static int sg_io(struct file *file, requ
 					  hdr->dxfer_len);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
+		ret = blk_rq_init_transfer(q, rq, hdr->dxferp, hdr->dxfer_len);
 
 	if (ret)
 		goto out;
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 3105ddd..0ea8374 100644
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
+		if (blk_rq_complete_transfer(q, bio, ubuf, len))
 			ret = -EFAULT;
 
 		if (ret)
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index d402aff..ffd4abf 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -28,7 +28,6 @@ #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tgt.h>
-#include <../drivers/md/dm-bio-list.h>
 
 #include "scsi_tgt_priv.h"
 
@@ -42,9 +41,8 @@ static struct kmem_cache *scsi_tgt_cmd_c
 struct scsi_tgt_cmd {
 	/* TODO replace work with James b's code */
 	struct work_struct work;
-	/* TODO replace the lists with a large bio */
-	struct bio_list xfer_done_list;
-	struct bio_list xfer_list;
+	/* TODO fix limits of some drivers */
+	struct bio *bio;
 
 	struct list_head hash_list;
 	struct request *rq;
@@ -111,8 +109,6 @@ struct scsi_cmnd *scsi_host_get_command(
 	rq->cmd_flags |= REQ_TYPE_BLOCK_PC;
 	rq->end_io_data = tcmd;
 
-	bio_list_init(&tcmd->xfer_list);
-	bio_list_init(&tcmd->xfer_done_list);
 	tcmd->rq = rq;
 
 	return cmd;
@@ -157,20 +153,11 @@ void scsi_host_put_command(struct Scsi_H
 }
 EXPORT_SYMBOL_GPL(scsi_host_put_command);
 
-static void scsi_unmap_user_pages(struct scsi_tgt_cmd *tcmd)
+static void scsi_unmap_user_pages(struct request_queue *q,
+				  struct scsi_tgt_cmd *tcmd)
 {
-	struct bio *bio;
-
-	/* must call bio_endio in case bio was bounced */
-	while ((bio = bio_list_pop(&tcmd->xfer_done_list))) {
-		bio_endio(bio, bio->bi_size, 0);
-		bio_unmap_user(bio);
-	}
-
-	while ((bio = bio_list_pop(&tcmd->xfer_list))) {
-		bio_endio(bio, bio->bi_size, 0);
-		bio_unmap_user(bio);
-	}
+	/* we currently only support mapping */
+	blk_rq_complete_transfer(q, tcmd->bio, NULL, 0);
 }
 
 static void cmd_hashlist_del(struct scsi_cmnd *cmd)
@@ -203,7 +190,7 @@ static void scsi_tgt_cmd_destroy(struct 
 	else
 		cmd->request->cmd_flags &= ~REQ_RW;
 
-	scsi_unmap_user_pages(tcmd);
+	scsi_unmap_user_pages(cmd->request->q, tcmd);
 	scsi_host_put_command(scsi_tgt_cmd_to_host(cmd), cmd);
 }
 
@@ -419,52 +406,30 @@ static int scsi_map_user_pages(struct sc
 	struct request *rq = cmd->request;
 	void *uaddr = tcmd->buffer;
 	unsigned int len = tcmd->bufflen;
-	struct bio *bio;
 	int err;
 
-	while (len > 0) {
-		dprintk("%lx %u\n", (unsigned long) uaddr, len);
-		bio = bio_map_user(q, NULL, (unsigned long) uaddr, len, rw);
-		if (IS_ERR(bio)) {
-			err = PTR_ERR(bio);
-			dprintk("fail to map %lx %u %d %x\n",
-				(unsigned long) uaddr, len, err, cmd->cmnd[0]);
-			goto unmap_bios;
-		}
-
-		uaddr += bio->bi_size;
-		len -= bio->bi_size;
-
+	dprintk("%lx %u\n", (unsigned long) uaddr, len);
+	err = blk_rq_map_user(q, rq, uaddr, len, rw);
+	if (err) {
 		/*
-		 * The first bio is added and merged. We could probably
-		 * try to add others using scsi_merge_bio() but for now
-		 * we keep it simple. The first bio should be pretty large
-		 * (either hitting the 1 MB bio pages limit or a queue limit)
-		 * already but for really large IO we may want to try and
-		 * merge these.
+		 * TODO: need to fixup sg_tablesize, max_segment_size,
+		 * max_sectors, etc for modern HW and software drivers
+		 * where this value is bogus.
 		 */
-		if (!rq->bio) {
-			blk_rq_bio_prep(q, rq, bio);
-			rq->data_len = bio->bi_size;
-		} else
-			/* put list of bios to transfer in next go around */
-			bio_list_add(&tcmd->xfer_list, bio);
+		eprintk("Could not handle of request size %u.\n", len);
+		BUG();
+		return err;
 	}
 
-	cmd->offset = 0;
+	tcmd->bio = rq->bio;
 	err = scsi_tgt_init_cmd(cmd, GFP_KERNEL);
 	if (err)
-		goto unmap_bios;
+		goto unmap_rq;
 
 	return 0;
 
-unmap_bios:
-	if (rq->bio) {
-		bio_unmap_user(rq->bio);
-		while ((bio = bio_list_pop(&tcmd->xfer_list)))
-			bio_unmap_user(bio);
-	}
-
+unmap_rq:
+	scsi_unmap_user_pages(cmd->request->q, tcmd);
 	return err;
 }
 
@@ -473,12 +438,10 @@ static int scsi_tgt_transfer_data(struct
 static void scsi_tgt_data_transfer_done(struct scsi_cmnd *cmd)
 {
 	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
-	struct bio *bio;
 	int err;
 
 	/* should we free resources here on error ? */
 	if (cmd->result) {
-send_uspace_err:
 		err = scsi_tgt_uspace_send_status(cmd, tcmd->tag);
 		if (err <= 0)
 			/* the tgt uspace eh will have to pick this up */
@@ -490,34 +453,8 @@ send_uspace_err:
 		cmd, cmd->request_bufflen, tcmd->bufflen);
 
 	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
-	bio_list_add(&tcmd->xfer_done_list, cmd->request->bio);
-
 	tcmd->buffer += cmd->request_bufflen;
-	cmd->offset += cmd->request_bufflen;
-
-	if (!tcmd->xfer_list.head) {
-		scsi_tgt_transfer_response(cmd);
-		return;
-	}
-
-	dprintk("cmd2 %p request_bufflen %u bufflen %u\n",
-		cmd, cmd->request_bufflen, tcmd->bufflen);
-
-	bio = bio_list_pop(&tcmd->xfer_list);
-	BUG_ON(!bio);
-
-	blk_rq_bio_prep(cmd->request->q, cmd->request, bio);
-	cmd->request->data_len = bio->bi_size;
-	err = scsi_tgt_init_cmd(cmd, GFP_ATOMIC);
-	if (err) {
-		cmd->result = DID_ERROR << 16;
-		goto send_uspace_err;
-	}
-
-	if (scsi_tgt_transfer_data(cmd)) {
-		cmd->result = DID_NO_CONNECT << 16;
-		goto send_uspace_err;
-	}
+	scsi_tgt_transfer_response(cmd);
 }
 
 static int scsi_tgt_transfer_data(struct scsi_cmnd *cmd)
diff --git a/fs/bio.c b/fs/bio.c
index 7618bcb..6f0a491 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -451,16 +451,17 @@ int bio_add_page(struct bio *bio, struct
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
+	struct request_queue *q;
+	struct bio_map_vec *iovecs;
+	int nr_vecs;
+};
 
 static void bio_free_map_data(struct bio_map_data *bmd)
 {
@@ -470,12 +471,12 @@ static void bio_free_map_data(struct bio
 
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
 
@@ -483,33 +484,193 @@ static struct bio_map_data *bio_alloc_ma
 	return NULL;
 }
 
+static void bio_destroy_map_vec(struct bio *bio, struct bio_map_data *bmd,
+				struct bio_map_vec *vec)
+{
+	if (bio_flagged(bio, BIO_USED_RESERVE))
+		blk_put_reserve_seg(bmd->q);
+	else
+		__free_pages(vec->page, vec->order);
+}
+
 /**
- *	bio_uncopy_user	-	finish previously mapped bio
- *	@bio: bio being terminated
+ *	bio_uncopy_user -	finish previously mapped bio
+ *	@bio:		bio being terminated
+ *	@ubuf:		buffer to copy data back to
+ *	@ubuf_len:	bytes left in ubuf to copy back
+ *
+ *	Free pages allocated from bio_setup_map_data() and write back data
+ *	to user space in case of a read and if ubuf is set.
  *
- *	Free pages allocated from bio_copy_user() and write back data
- *	to user space in case of a read.
+ *	Returns number of bytes traversed in bio (not necessarily number of
+ *      bytes copied). Sets err to zero on success, else -Exyz on error.
  */
-int bio_uncopy_user(struct bio *bio)
+int bio_uncopy_user(struct bio *bio, void __user *ubuf, unsigned long ubuf_len,
+		    int *err)
 {
 	struct bio_map_data *bmd = bio->bi_private;
 	const int read = bio_data_dir(bio) == READ;
-	struct bio_vec *bvec;
-	int i, ret = 0;
+	int bytes_copied = 0;
+	int i;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
-		char *addr = page_address(bvec->bv_page);
-		unsigned int len = bmd->iovecs[i].bv_len;
+	*err = 0;
+	for (i = 0; i < bmd->nr_vecs; i++) {
+		char *addr;
+		unsigned int len;
 
-		if (read && !ret && copy_to_user(bmd->userptr, addr, len))
-			ret = -EFAULT;
+		if (ubuf) {
+			addr = page_address(bmd->iovecs[i].page);
+			len = bmd->iovecs[i].len;
+
+			/*
+			 * Check if usersapce gave us a short buffer. If it
+			 * did just free resources.
+			 */
+			if (read && !(*err) && (ubuf_len - bytes_copied > 0) &&
+			    copy_to_user(ubuf, addr, len))
+				*err = -EFAULT;
+			ubuf += len;
+			bytes_copied += len;
+		}
 
-		__free_page(bvec->bv_page);
-		bmd->userptr += len;
+		bio_destroy_map_vec(bio, bmd, &bmd->iovecs[i]);
 	}
 	bio_free_map_data(bmd);
 	bio_put(bio);
-	return ret;
+	return bytes_copied;
+}
+
+/*
+ * This is only a esitmation. Drivers, like MD/DM RAID could have strange
+ * boundaries not expresses in a q limit.
+ *
+ * This should only be used by block layer helpers
+ */
+unsigned int bio_estimate_max_segment_size(struct request_queue *q)
+{
+	unsigned int bytes;
+
+	if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER)))
+		return PAGE_SIZE;
+	/*
+	 * should this be multiplied by hardsect size? (other sg code
+	 * assumes 512
+	 */
+	bytes = min(q->max_segment_size, q->max_hw_sectors << 9);
+	if (bytes > BIO_MAX_SIZE)
+		bytes = BIO_MAX_SIZE;
+	return bytes;
+}
+
+/* This should only be used by block layer helpers */
+struct page *bio_alloc_pages(struct request_queue *q, unsigned int len,
+			     int *ret_order)
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
+
+/**
+ * bio_setup_map_data - alloc and setup buffers for a mmap or user copy sg io
+ * @q:		request queue
+ * @bmd:	bio map data to store mappings
+ * @nr_segs:	estmiate of number of segs needed in bio
+ * @len:	len of buffer to setup
+ * @use_reserve:bool to indicate if the reserve buffer should be used
+ */
+static struct bio *bio_setup_map_data(request_queue_t *q,
+				      struct bio_map_data *bmd, int nr_segs,
+				      unsigned int len, int use_reserve)
+{
+	struct page *page;
+	struct bio *bio;
+	int i = 0, ret;
+
+	bio = bio_alloc(GFP_KERNEL, nr_segs);
+	if (!bio)
+		return ERR_PTR(-ENOMEM);
+	if (use_reserve)
+		bio->bi_flags |= (1 << BIO_USED_RESERVE);
+
+	ret = 0;
+	while (len) {
+		unsigned add_len;
+		int order = 0;
+
+		if (use_reserve) {
+			int seg_len = 0;
+
+			page = blk_get_reserve_seg(q, &seg_len);
+			if (!page) {
+				ret = -ENOMEM;
+				goto cleanup;
+			}
+
+			/*
+			 * segments may not fit nicely in bios - caller
+			 * will handle this
+			 */
+			if (bio->bi_size + seg_len > BIO_MAX_SIZE) {
+				blk_put_reserve_seg(q);
+				break;
+			}
+			order = get_order(seg_len);
+
+		} else {
+			page = bio_alloc_pages(q, len, &order);
+			if (!page) {
+				ret = -ENOMEM;
+				goto cleanup;
+			}
+		}
+
+		bmd->nr_vecs++;
+		bmd->iovecs[i].page = page;
+		bmd->iovecs[i].order = order;
+		bmd->iovecs[i].len = 0;
+
+		add_len = min_t(unsigned int, (1 << order) << PAGE_SHIFT, len);
+		while (add_len) {
+			unsigned int added, bytes = PAGE_SIZE;
+
+			if (bytes > add_len)
+				bytes = add_len;
+
+			added = bio_add_pc_page(q, bio, page++, bytes, 0);
+			bmd->iovecs[i].len += added;
+			if (added < bytes)
+				break;
+			add_len -= bytes;
+			len -= bytes;
+		}
+		i++;
+	}
+
+	bio->bi_private = bmd;
+	return bio;
+cleanup:
+	for (i = 0; i < bmd->nr_vecs; i++)
+		bio_destroy_map_vec(bio, bmd, &bmd->iovecs[i]);
+	bio_put(bio);
+	return ERR_PTR(ret);
 }
 
 /**
@@ -518,61 +679,42 @@ int bio_uncopy_user(struct bio *bio)
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@use_reserve: bool to indicate if the reserve buffer should be used
  *
  *	Prepares and returns a bio for indirect user io, bouncing data
  *	to/from kernel pages as necessary. Must be paired with
  *	call bio_uncopy_user() on io completion.
+ *
+ *      If uaddr is 0, then only the bio and kernel buffers are setup.
+ *      This is useful for sg io mmap. (TODO: think of new name for fn).
  */
 struct bio *bio_copy_user(request_queue_t *q, unsigned long uaddr,
-			  unsigned int len, int write_to_vm)
+			  unsigned int len, int write_to_vm, int use_reserve)
 {
 	unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned long start = uaddr >> PAGE_SHIFT;
 	struct bio_map_data *bmd;
 	struct bio_vec *bvec;
-	struct page *page;
 	struct bio *bio;
-	int i, ret;
+	int i = 0, ret;
 
 	bmd = bio_alloc_map_data(end - start);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
+	bmd->q = q;
 
-	bmd->userptr = (void __user *) uaddr;
-
-	ret = -ENOMEM;
-	bio = bio_alloc(GFP_KERNEL, end - start);
-	if (!bio)
+	bio = bio_setup_map_data(q, bmd, end - start, len, use_reserve);
+	if (IS_ERR(bio)) {
+		ret = PTR_ERR(bio);
 		goto out_bmd;
-
-	bio->bi_rw |= (!write_to_vm << BIO_RW);
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
 	}
-
-	if (ret)
-		goto cleanup;
+	bio->bi_rw |= (!write_to_vm << BIO_RW);
 
 	/*
 	 * success
 	 */
-	if (!write_to_vm) {
+	i = 0;
+	if (uaddr && !write_to_vm) {
 		char __user *p = (char __user *) uaddr;
 
 		/*
@@ -588,12 +730,10 @@ struct bio *bio_copy_user(request_queue_
 		}
 	}
 
-	bio_set_map_data(bmd, bio);
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
@@ -713,23 +853,23 @@ static struct bio *__bio_map_user_iov(re
 /**
  *	bio_map_user	-	map user address into bio
  *	@q: the request_queue_t for the bio
- *	@bdev: destination block device
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@use_reserve: bool to indicate if the reserve buffer should be used
  *
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_user(request_queue_t *q, struct block_device *bdev,
-			 unsigned long uaddr, unsigned int len, int write_to_vm)
+struct bio *bio_map_user(request_queue_t *q, unsigned long uaddr,
+			 unsigned int len, int write_to_vm, int use_reserve)
 {
 	struct sg_iovec iov;
 
 	iov.iov_base = (void __user *)uaddr;
 	iov.iov_len = len;
 
-	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm);
+	return bio_map_user_iov(q, NULL, &iov, 1, write_to_vm);
 }
 
 /**
@@ -1264,3 +1404,5 @@ EXPORT_SYMBOL(bio_uncopy_user);
 EXPORT_SYMBOL(bioset_create);
 EXPORT_SYMBOL(bioset_free);
 EXPORT_SYMBOL(bio_alloc_bioset);
+EXPORT_SYMBOL(bio_estimate_max_segment_size);
+EXPORT_SYMBOL(bio_alloc_pages);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 08daf32..f3160a4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -125,6 +125,7 @@ #define BIO_CLONED	4	/* doesn't own data
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
+#define BIO_USED_RESERVE 8	/* using reserve buffer */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
@@ -298,8 +299,8 @@ extern int bio_add_page(struct bio *, st
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
-				unsigned long, unsigned int, int);
+extern struct bio *bio_map_user(struct request_queue *, unsigned long,
+				unsigned int, int, int);
 struct sg_iovec;
 extern struct bio *bio_map_user_iov(struct request_queue *,
 				    struct block_device *,
@@ -310,8 +311,11 @@ extern struct bio *bio_map_kern(struct r
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern void bio_release_pages(struct bio *bio);
-extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
-extern int bio_uncopy_user(struct bio *);
+extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int, int);
+extern int bio_uncopy_user(struct bio *, void __user *, unsigned long, int *);
+extern unsigned int bio_estimate_max_segment_size(struct request_queue *);
+extern struct page *bio_alloc_pages(struct request_queue *, unsigned int,
+				    int *);
 void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9c55749..0b76c1d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -359,6 +359,13 @@ struct blk_queue_tag {
 	atomic_t refcnt;		/* map can be shared */
 };
 
+struct blk_reserve_buf {
+	struct scatterlist *sg;		/* sg to hold pages */
+	unsigned buf_size;		/* size of reserve buffer */
+	int sg_count;			/* number of sg entries in use */
+	int sg_index;			/* index pf sg in list */
+};
+
 struct request_queue
 {
 	/*
@@ -454,6 +461,7 @@ struct request_queue
 	/*
 	 * sg stuff
 	 */
+	struct blk_reserve_buf *reserve_buf;
 	unsigned int		sg_timeout;
 	unsigned int		sg_reserved_size;
 	int			node;
@@ -481,6 +489,7 @@ #define QUEUE_FLAG_DEAD		5	/* queue bein
 #define QUEUE_FLAG_REENTER	6	/* Re-entrancy avoidance */
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
+#define QUEUE_FLAG_RESERVE_USED 9	/* sg reserve buffer in use */
 
 enum {
 	/*
@@ -526,6 +535,7 @@ #define blk_queue_plugged(q)	test_bit(QU
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
+#define blk_queue_reserve_in_use(q) test_bit(QUEUE_FLAG_RESERVE_USED, &(q)->queue_flags)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
@@ -678,8 +688,22 @@ extern void blk_sync_queue(struct reques
 extern void __blk_stop_queue(request_queue_t *q);
 extern void blk_run_queue(request_queue_t *);
 extern void blk_start_queueing(request_queue_t *);
-extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned long);
-extern int blk_rq_unmap_user(struct bio *);
+extern struct page *blk_rq_vma_nopage(struct request_queue *, struct request *,
+				      struct vm_area_struct *, unsigned long,
+				      int *);
+extern int blk_rq_mmap(struct request_queue *, struct request *,
+			struct vm_area_struct *);
+extern int blk_queue_free_reserve_buf(struct request_queue *);
+extern int blk_queue_alloc_reserve_buf(struct request_queue *, unsigned long);
+extern struct page *blk_get_reserve_seg(struct request_queue *, unsigned int *);
+extern void blk_put_reserve_seg(request_queue_t *);
+extern int blk_rq_init_transfer(request_queue_t *, struct request *, void __user *, unsigned long);
+extern int blk_rq_map_user(request_queue_t *, struct request *,
+			   void __user *, unsigned long, int);
+extern int blk_rq_copy_user(request_queue_t *, struct request *,
+			    void __user *, unsigned long, int);
+extern int blk_rq_complete_transfer(struct request_queue *, struct bio *,
+				    void __user *, unsigned long);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(request_queue_t *, struct request *,
 			       struct sg_iovec *, int, unsigned int);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index d6948d0..a2e0c10 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -73,9 +73,6 @@ #define MAX_COMMAND_SIZE	16
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
 	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
 
-	/* offset in cmd we are at (for multi-transfer tgt cmds) */
-	unsigned offset;
-
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
-- 
1.4.1.1



