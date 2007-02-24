From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] mv sg features to the block layer v4
Date: Sat, 24 Feb 2007 12:05:13 -0500
Message-ID: <1172336713.2589.6.camel@max>
References: <1172314280.5437.4.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33765 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933526AbXBXSFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Feb 2007 13:05:44 -0500
In-Reply-To: <1172314280.5437.4.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Sat, 2007-02-24 at 05:51 -0500, Mike Christie wrote:
> v4.
> 
> mv sg.c features to the block layer helper code, so that tape, scsi_tgt,
> and maybe bsg or block/scsi_ioctl.c can use them.
> 
> This patches moves the sg features and converts blk_rq_map_user and
> bio_map_user callers to the new API.
> 
> Previously, we did blk_rq_map_user() to map or copy date to a buffer. Then
> called blk_rq_unmap_user to unmap or copy back data. sg and st want finer
> control over when to use DIO vs indirect IO, and for sg mmap we want to
> use the code that sets up a bio buffer which is also used by indirect IO.
> 
> Now, if the caller does not care how we transfer data they can call
> blk_rq_init_transfer() to setup the buffers (this does what blk_rq_map_user()
> did before where it would try DIO first then fall back to indirect IO)
> and then call blk_rq_complete_transfer() when the IO is done (this
> does what blk_rq_unmap_user did before). block/scsi_ioctl.c, cdrom,
> and bsg use these functions.
> 
> If the callers wants to try to do DIO, then they can call blk_rq_map_user()
> to set up the buffer. When the IO is done you can then call
> blk_rq_destroy_buffer(). You could also call blk_rq_complete_transfer() is
> just a smart wrapper.
> 
> To do indirect IO, we now have blk_rq_copy_user_iov(). When that IO
> is done, you then call blk_rq_uncopy_user_iov().
> 
> For sg mmap, there are some helpers:
> - blk_rq_mmap - does some checks to makre sure the reserved buf is
> large enough.
> - blk_rq_vma_nopage - traverses the reserved buffer and does get_page()
> 
> To setup and teardown the request and bio reserved buffer mappings for
> the sg mmap operation you call blk_rq_setup_buffer() and
> blk_rq_destroy_buffer().
> 
> Finally, there is a bio_reserved_buf structure, which holds mutlple
> segments that can be mapped into BIOs. This replaces sg's reserved
> buffer code, and can be used for tape (I think we need some reserved buffer
> growing code for that, but that should not be too difficult to add).
> It can also be used for scsi_tgt, so we gaurantee a certain IO size will
> always be executable.
> 
> One interesting suggestion from Doug and I think Christoph mentioned it,
> is that if we implement common behavior (when to try DIO vs indirect and
> supporting the sg.c features in block/scsi_ioct.c) for block/scsi_ioctl
> SG_IO and sg.c SG_IO, we could merge up more code and sg.c could just
> call something like block/scsi_ioctl.c:sg_io_write() and sg_io_read().
> The synchronous block/scsi_ioctl.c:sg_io() could then call those functions
> too. Not sure if we want to keep them different for some reason. And one other
> odd item is that block/scsi_ioctl.c does DIO for iovecs, but sg.c
> does indirect IO for iovecs and many apps do not aling the buffers
> correctly so they do not use the block/scsi_ioctl.c path.
> 
> The next patch coverts sg. I did not covert st. Christoph has some
> patches for this. I need to update them and test them.
> I wanted to make sure this API is ok before tackling tape though.
> I was not sure where things should go. I think maybe a new file to hold
> all the pass through code might be niced. I am also not sure if
> the reserved buffer code should be living in bio.c
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 

Here is a patch that compiles. Sorry about that. I goofed and merged two
patches into one and retested the wrong patch before sending.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

v5

Changes from v3 to v4
- Fix bio map user bdev reference compile error.

Changes from v1 - v3.
- sg iovec support. sg.c supported indirect IO iovecs, but for some
reason the block layer SG IO code support direct IO iovec support.
- Move reserved buffer code to bio.c and seperate from q, so that
sg and others can support mutiple reserved buffers


diff --git a/block/bsg.c b/block/bsg.c
index c85d961..b4a9b14 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -320,7 +320,7 @@ bsg_map_hdr(struct bsg_device *bd, struc
 		dxfer_len = 0;
 
 	if (dxfer_len) {
-		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
+		ret = blk_rq_init_transfer(q, rq, dxferp, dxfer_len);
 		if (ret) {
 			dprintk("failed map at %d\n", ret);
 			blk_put_request(rq);
@@ -459,7 +459,8 @@ static int blk_complete_sgv4_hdr_rq(stru
 			ret = -EFAULT;
 	}
 
-	blk_rq_unmap_user(bio);
+	blk_rq_complete_transfer(bio, (void __user *)hdr->din_xferp,
+				 hdr->din_xfer_len);
 	blk_put_request(rq);
 
 	return ret;
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index a08e9ca..981b838 100644
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
@@ -2314,138 +2318,379 @@ void blk_insert_request(request_queue_t 
 
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
+ * @write_to_vm: bool indicating writing to pages or not
+ * @rbuf:	reserve buf to use
+ *
+ * Description:
+ *    The caller must call blk_rq_destroy_buffer when the IO is completed.
+ */
+int blk_rq_setup_buffer(struct request *rq, void __user *ubuf,
+			unsigned long len, int write_to_vm,
+			struct bio_reserve_buf *rbuf)
 {
-	unsigned long uaddr;
+	struct request_queue *q = rq->q;
+	unsigned long bytes_read = 0;
 	struct bio *bio, *orig_bio;
 	int reading, ret;
 
-	reading = rq_data_dir(rq) == READ;
+	if (!len || len > (q->max_hw_sectors << 9))
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
+			bio = bio_map_user(q, uaddr, map_len, write_to_vm);
+		} else
+			bio = bio_setup_user_buffer(q, map_len, write_to_vm,
+						    rbuf);
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
+ * blk_rq_mmap - alloc and setup buffers for REQ_BLOCK_PC mmap
+ * @rbuf:	reserve buffer
+ * @vma:	vm struct
+ *
+ * Description:
+ *    A the caller must also call blk_rq_setup_buffer on the request and
+ *    blk_rq_destroy_buffer() must be issued at the end of io.
+ *    It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_destroy_buffer() for
+ *    proper unmapping.
+ *
+ *    The block layer mmap functions implement the old sg.c behavior
+ *    where they can be only one sg mmap command outstanding.
+ */
+int blk_rq_mmap(struct bio_reserve_buf *rbuf, struct vm_area_struct *vma)
+{
+	unsigned long len;
+
+	if (vma->vm_pgoff)
+		return -EINVAL; /* want no offset */
+
+	if (!rbuf)
+		return -ENOMEM;
+
+	len = vma->vm_end - vma->vm_start;
+	if (len > rbuf->buf_size)
+		return -ENOMEM;
+
+	vma->vm_flags |= VM_RESERVED;
+	return 0;
+}
+EXPORT_SYMBOL(blk_rq_mmap);
+
+struct page *blk_rq_vma_nopage(struct bio_reserve_buf *rbuf,
+			       struct vm_area_struct *vma, unsigned long addr,
+			       int *type)
+{
+	struct page *pg = NOPAGE_SIGBUS;
+	unsigned long offset, bytes = 0, sg_offset;
+	struct scatterlist *sg;
+	int i;
+
+	if (!rbuf)
+		return pg;
+
+	offset = addr - vma->vm_start;
+	if (offset >= rbuf->buf_size)
+		return pg;
+
+	for (i = 0; i < rbuf->sg_count; i++) {
+		sg = &rbuf->sg[i];
+
+		bytes += sg->length;
+		if (bytes > offset) {
+			sg_offset = sg->length - (bytes - offset);
+			pg = &sg->page[sg_offset >> PAGE_SHIFT];
+			get_page(pg);
+			break;
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
+ *    A matching blk_rq_destroy_buffer() must be issued at the end of io,
+ *    while still in process context.
+ *
+ *    It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_destroy_buffer() for
+ *    proper unmapping.
+ */
+int blk_rq_map_user(request_queue_t *q, struct request *rq,
+		     void __user *ubuf, unsigned long len, int write_to_vm)
+{
+	return blk_rq_setup_buffer(rq, ubuf, len, write_to_vm, NULL);
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
+ * @rbuf:	reserve buffer
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
+			 int iov_count, unsigned long len,
+			 struct bio_reserve_buf *rbuf)
+{
+	int ret;
+
+	ret = blk_rq_setup_buffer(rq, NULL, len, -1, rbuf);
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
+	if (!ubuf)
 		return -EINVAL;
-	if (!len || !ubuf)
-		return -EINVAL;
-
-	while (bytes_read != len) {
-		unsigned long map_len, end, start;
 
-		map_len = min_t(unsigned long, len - bytes_read, BIO_MAX_SIZE);
-		end = ((unsigned long)ubuf + map_len + PAGE_SIZE - 1)
-								>> PAGE_SHIFT;
-		start = (unsigned long)ubuf >> PAGE_SHIFT;
+	ret = blk_rq_map_user(q, rq, ubuf, len, -1);
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
+		ret = blk_rq_copy_user_iov(rq, &iov, 1, len, NULL);
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
@@ -2459,14 +2704,14 @@ EXPORT_SYMBOL(blk_rq_map_user);
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
@@ -2479,7 +2724,7 @@ int blk_rq_map_user_iov(request_queue_t 
 	/* we don't allow misaligned data like bio_map_user() does.  If the
 	 * user is using sg, they're expected to know the alignment constraints
 	 * and respect them accordingly */
-	bio = bio_map_user_iov(q, NULL, iov, iov_count, rq_data_dir(rq)== READ);
+	bio = bio_map_user_iov(q, iov, iov_count, rq_data_dir(rq)== READ);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
@@ -2498,37 +2743,37 @@ int blk_rq_map_user_iov(request_queue_t 
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
index 18e935f..c947647 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -244,7 +244,7 @@ EXPORT_SYMBOL_GPL(blk_fill_sghdr_rq);
  */
 int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
 {
-	blk_rq_unmap_user(rq->bio);
+	blk_rq_complete_transfer(rq->bio, hdr->dxferp, hdr->dxfer_len);
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
index 3105ddd..e2ec75a 100644
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
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index d402aff..4539e96 100644
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
@@ -159,18 +155,8 @@ EXPORT_SYMBOL_GPL(scsi_host_put_command)
 
 static void scsi_unmap_user_pages(struct scsi_tgt_cmd *tcmd)
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
+	blk_rq_complete_transfer(tcmd->bio, NULL, 0);
 }
 
 static void cmd_hashlist_del(struct scsi_cmnd *cmd)
@@ -419,52 +405,34 @@ static int scsi_map_user_pages(struct sc
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
+		 *
+		 * TODO2: we can alloc a reserve buffer of max size
+		 * we can handle and do the slow copy path for really large
+		 * IO.
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
+	scsi_unmap_user_pages(tcmd);
 	return err;
 }
 
@@ -473,12 +441,10 @@ static int scsi_tgt_transfer_data(struct
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
@@ -490,34 +456,8 @@ send_uspace_err:
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
index 7618bcb..66e72b0 100644
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
+	struct bio_reserve_buf *rbuf;
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
 
@@ -483,117 +484,333 @@ static struct bio_map_data *bio_alloc_ma
 	return NULL;
 }
 
+/*
+ * This is only a esitmation. Drivers, like MD/DM RAID could have strange
+ * boundaries not expresses in a q limit.
+ *
+ * This should only be used by bio helpers, because we cut off the max
+ * segment size at BIO_MAX_SIZE. There is hw that can do larger segments,
+ * but there is no current need and aligning the segments to fit in
+ * a single BIO makes the code simple.
+ */
+static unsigned int bio_estimate_max_segment_size(struct request_queue *q)
+{
+	unsigned int bytes;
+
+	if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER)))
+		return PAGE_SIZE;
+	bytes = min(q->max_segment_size, q->max_hw_sectors << 9);
+	if (bytes > BIO_MAX_SIZE)
+		bytes = BIO_MAX_SIZE;
+	return bytes;
+}
+
+/* This should only be used by block layer helpers */
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
+
+static void free_reserve_buf(struct bio_reserve_buf *rbuf)
+{
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
+}
+
+/**
+ * bio_free_reserve_buf - free reserve buffer
+ * @q: the request queue for the device
+ *
+ * It is the responsibility of the caller to make sure it is
+ * no longer processing requests that may be using the reserved
+ * buffer.
+ **/
+int bio_free_reserve_buf(struct bio_reserve_buf *rbuf)
+{
+	if (!rbuf)
+		return 0;
+
+	if (test_and_set_bit(BIO_RESERVE_BUF_IN_USE, &rbuf->flags))
+		return -EBUSY;
+
+	free_reserve_buf(rbuf);
+	return 0;
+}
+
+/**
+ * bio_alloc_reserve_buf - allocate a buffer for pass through
+ * @q: the request queue for the device
+ * @buf_size: size of reserve buffer to allocate
+ *
+ * This is very simple for now. It is copied from sg.c because it is only
+ * meant to support what sg had supported.
+ **/
+struct bio_reserve_buf *bio_alloc_reserve_buf(struct request_queue *q,
+					      unsigned long buf_size)
+{
+	struct bio_reserve_buf *rbuf;
+	struct page *pg;
+	struct scatterlist *sg;
+	int order, i, remainder, allocated;
+	unsigned int segment_size;
+
+	rbuf = kzalloc(sizeof(*rbuf), GFP_KERNEL);
+	if (!rbuf)
+		return NULL;
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
+		sg->page = pg;
+		sg->length = (1 << order) << PAGE_SHIFT;
+		allocated = sg->length;
+	}
+	/* set to how mnay elements we are using */
+	rbuf->sg_count = i;
+
+	if (remainder > 0)
+		goto free_buf;
+	return rbuf;
+
+free_buf:
+	free_reserve_buf(rbuf);
+	return NULL;
+}
+
 /**
- *	bio_uncopy_user	-	finish previously mapped bio
- *	@bio: bio being terminated
+ * get_reserve_seg - get pages from the reserve buffer
+ * @rbuf:	reserve buffer
+ * @len:	len of segment returned
  *
- *	Free pages allocated from bio_copy_user() and write back data
- *	to user space in case of a read.
+ * This assumes that caller is serializing access to the buffer.
+ **/
+static struct page *get_reserve_seg(struct bio_reserve_buf *rbuf,
+				    unsigned int *len)
+{
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
+
+/*
+ * sg only allowed one command to use the reserve buf at a time.
+ * We assume the block layer and sg, will always do a put() for a get(),
+ * and will continue to only allow one command to the use the buffer
+ * at a time, so we just decrement the sg_index here.
  */
-int bio_uncopy_user(struct bio *bio)
+static void put_reserve_seg(struct bio_reserve_buf *rbuf)
 {
-	struct bio_map_data *bmd = bio->bi_private;
-	const int read = bio_data_dir(bio) == READ;
-	struct bio_vec *bvec;
-	int i, ret = 0;
+	if (!rbuf || rbuf->sg_index == 0) {
+		BUG();
+		return;
+	}
+	rbuf->sg_index--;
+}
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
-		char *addr = page_address(bvec->bv_page);
-		unsigned int len = bmd->iovecs[i].bv_len;
+int bio_claim_reserve_buf(struct bio_reserve_buf *rbuf, unsigned long len)
+{
+	if (!rbuf)
+		return -ENOMEM;
 
-		if (read && !ret && copy_to_user(bmd->userptr, addr, len))
-			ret = -EFAULT;
+	if (test_and_set_bit(BIO_RESERVE_BUF_IN_USE, &rbuf->flags))
+		return -EBUSY;
 
-		__free_page(bvec->bv_page);
-		bmd->userptr += len;
+	if (len > rbuf->buf_size) {
+		clear_bit(BIO_RESERVE_BUF_IN_USE, &rbuf->flags);
+		return -ENOMEM;
 	}
+	return 0;
+}
+
+void bio_release_reserve_buf(struct bio_reserve_buf *rbuf)
+{
+	if (!rbuf)
+		return;
+
+	if (rbuf->sg_index != 0)
+		BUG();
+
+	rbuf->sg_index = 0;
+	clear_bit(BIO_RESERVE_BUF_IN_USE, &rbuf->flags);
+}
+
+static void bio_destroy_map_vec(struct bio *bio, struct bio_map_data *bmd,
+				struct bio_map_vec *vec)
+{
+	if (bio_flagged(bio, BIO_USED_RESERVE))
+		put_reserve_seg(bmd->rbuf);
+	else
+		__free_pages(vec->page, vec->order);
+}
+
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
+ *	@rbuf: reserve buf to use
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
+				  int write_to_vm, struct bio_reserve_buf *rbuf)
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
+	bmd->rbuf = rbuf;
 
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
+	if (rbuf)
+		bio->bi_flags |= (1 << BIO_USED_RESERVE);
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
 
 	ret = 0;
 	while (len) {
-		unsigned int bytes = PAGE_SIZE;
+		unsigned add_len;
+		int order = 0;
 
-		if (bytes > len)
-			bytes = len;
+		if (rbuf) {
+			int seg_len = 0;
 
-		page = alloc_page(q->bounce_gfp | GFP_KERNEL);
-		if (!page) {
-			ret = -ENOMEM;
-			break;
-		}
+			page = get_reserve_seg(rbuf, &seg_len);
+			if (!page) {
+				ret = -ENOMEM;
+				goto cleanup;
+			}
 
-		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes)
-			break;
+			/*
+			 * segments may not fit nicely in bios - caller
+			 * will handle this
+			 */
+			if (bio->bi_size + seg_len > BIO_MAX_SIZE) {
+				put_reserve_seg(rbuf);
+				break;
+			}
+			order = get_order(seg_len);
 
-		len -= bytes;
-	}
+		} else {
+			page = bio_alloc_pages(q, len, &order);
+			if (!page) {
+				ret = -ENOMEM;
+				goto cleanup;
+			}
+		}
 
-	if (ret)
-		goto cleanup;
+		bmd->nr_vecs++;
+		bmd->iovecs[i].page = page;
+		bmd->iovecs[i].order = order;
+		bmd->iovecs[i].len = 0;
 
-	/*
-	 * success
-	 */
-	if (!write_to_vm) {
-		char __user *p = (char __user *) uaddr;
+		add_len = min_t(unsigned int, (1 << order) << PAGE_SHIFT, len);
+		while (add_len) {
+			unsigned int added, bytes = PAGE_SIZE;
 
-		/*
-		 * for a write, copy in data to kernel pages
-		 */
-		ret = -EFAULT;
-		bio_for_each_segment(bvec, bio, i) {
-			char *addr = page_address(bvec->bv_page);
+			if (bytes > add_len)
+				bytes = add_len;
 
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
@@ -601,7 +818,6 @@ out_bmd:
 }
 
 static struct bio *__bio_map_user_iov(request_queue_t *q,
-				      struct block_device *bdev,
 				      struct sg_iovec *iov, int iov_count,
 				      int write_to_vm)
 {
@@ -694,7 +910,6 @@ static struct bio *__bio_map_user_iov(re
 	if (!write_to_vm)
 		bio->bi_rw |= (1 << BIO_RW);
 
-	bio->bi_bdev = bdev;
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
 	return bio;
 
@@ -713,7 +928,6 @@ static struct bio *__bio_map_user_iov(re
 /**
  *	bio_map_user	-	map user address into bio
  *	@q: the request_queue_t for the bio
- *	@bdev: destination block device
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
@@ -721,21 +935,20 @@ static struct bio *__bio_map_user_iov(re
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_user(request_queue_t *q, struct block_device *bdev,
-			 unsigned long uaddr, unsigned int len, int write_to_vm)
+struct bio *bio_map_user(request_queue_t *q, unsigned long uaddr,
+			 unsigned int len, int write_to_vm)
 {
 	struct sg_iovec iov;
 
 	iov.iov_base = (void __user *)uaddr;
 	iov.iov_len = len;
 
-	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm);
+	return bio_map_user_iov(q, &iov, 1, write_to_vm);
 }
 
 /**
  *	bio_map_user_iov - map user sg_iovec table into bio
  *	@q: the request_queue_t for the bio
- *	@bdev: destination block device
  *	@iov:	the iovec.
  *	@iov_count: number of elements in the iovec
  *	@write_to_vm: bool indicating writing to pages or not
@@ -743,13 +956,12 @@ struct bio *bio_map_user(request_queue_t
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_user_iov(request_queue_t *q, struct block_device *bdev,
-			     struct sg_iovec *iov, int iov_count,
-			     int write_to_vm)
+struct bio *bio_map_user_iov(request_queue_t *q, struct sg_iovec *iov,
+			     int iov_count, int write_to_vm)
 {
 	struct bio *bio;
 
-	bio = __bio_map_user_iov(q, bdev, iov, iov_count, write_to_vm);
+	bio = __bio_map_user_iov(q, iov, iov_count, write_to_vm);
 
 	if (IS_ERR(bio))
 		return bio;
@@ -1259,8 +1471,12 @@ EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
 EXPORT_SYMBOL(bio_split_pool);
-EXPORT_SYMBOL(bio_copy_user);
-EXPORT_SYMBOL(bio_uncopy_user);
+EXPORT_SYMBOL(bio_setup_user_buffer);
+EXPORT_SYMBOL(bio_destroy_user_buffer);
+EXPORT_SYMBOL(bio_free_reserve_buf);
+EXPORT_SYMBOL(bio_alloc_reserve_buf);
+EXPORT_SYMBOL(bio_claim_reserve_buf);
+EXPORT_SYMBOL(bio_release_reserve_buf);
 EXPORT_SYMBOL(bioset_create);
 EXPORT_SYMBOL(bioset_free);
 EXPORT_SYMBOL(bio_alloc_bioset);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 08daf32..a14f72b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -51,6 +51,18 @@ #define BIO_MAX_PAGES		256
 #define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
 #define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)
 
+struct scatterlist;
+
+#define BIO_RESERVE_BUF_IN_USE 0
+
+struct bio_reserve_buf {
+	unsigned long flags;		/* state bits */
+	struct scatterlist *sg;		/* sg to hold pages */
+	unsigned buf_size;		/* size of reserve buffer */
+	int sg_count;			/* number of sg entries in use */
+	int sg_index;			/* index of sg in list */
+};
+
 /*
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
  */
@@ -125,6 +137,7 @@ #define BIO_CLONED	4	/* doesn't own data
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
+#define BIO_USED_RESERVE 8	/* using reserve buffer */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
@@ -298,11 +311,15 @@ extern int bio_add_page(struct bio *, st
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
-				unsigned long, unsigned int, int);
+extern int bio_free_reserve_buf(struct bio_reserve_buf *);
+extern struct bio_reserve_buf *bio_alloc_reserve_buf(struct request_queue *,
+						    unsigned long);
+extern int bio_claim_reserve_buf(struct bio_reserve_buf *, unsigned long);
+extern void bio_release_reserve_buf(struct bio_reserve_buf *);
+extern struct bio *bio_map_user(struct request_queue *, unsigned long,
+				unsigned int, int);
 struct sg_iovec;
 extern struct bio *bio_map_user_iov(struct request_queue *,
-				    struct block_device *,
 				    struct sg_iovec *, int, int);
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
@@ -310,8 +327,9 @@ extern struct bio *bio_map_kern(struct r
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern void bio_release_pages(struct bio *bio);
-extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
-extern int bio_uncopy_user(struct bio *);
+extern struct bio *bio_setup_user_buffer(struct request_queue *, unsigned int,
+					 int, struct bio_reserve_buf *);
+extern void bio_destroy_user_buffer(struct bio *bio);
 void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aa000d2..a916b55 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -358,6 +358,13 @@ struct blk_queue_tag {
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
@@ -677,8 +684,20 @@ extern void blk_sync_queue(struct reques
 extern void __blk_stop_queue(request_queue_t *q);
 extern void blk_run_queue(request_queue_t *);
 extern void blk_start_queueing(request_queue_t *);
-extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned long);
-extern int blk_rq_unmap_user(struct bio *);
+extern struct page *blk_rq_vma_nopage(struct bio_reserve_buf *,
+				      struct vm_area_struct *, unsigned long,
+				      int *);
+extern int blk_rq_mmap(struct bio_reserve_buf *, struct vm_area_struct *);
+extern int blk_rq_init_transfer(request_queue_t *, struct request *, void __user *, unsigned long);
+extern int blk_rq_map_user(request_queue_t *, struct request *,
+			   void __user *, unsigned long, int);
+extern int blk_rq_setup_buffer(struct request *, void __user *, unsigned long,
+				int, struct bio_reserve_buf *);
+extern void blk_rq_destroy_buffer(struct bio *);
+extern int blk_rq_copy_user_iov(struct request *, struct sg_iovec *,
+				int, unsigned long, struct bio_reserve_buf *);
+extern int blk_rq_uncopy_user_iov(struct bio *, struct sg_iovec *, int);
+extern int blk_rq_complete_transfer(struct bio *, void __user *, unsigned long);
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
 


