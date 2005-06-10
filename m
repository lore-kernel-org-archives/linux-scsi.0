From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] Add user scatter gather I/O to SG_IO
Date: Fri, 10 Jun 2005 18:59:28 -0500
Message-ID: <1118447969.5031.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15054 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261481AbVFJX7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 19:59:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This should be the last in the series of patches implementing
scsi_wait_req and scsi_do_req in the block layer.  It adds
scatter/gather I/O from the user as a new feature of SG_IO.  It also
exports the API for this which can now be used by the sg driver.

The patch is lightly tested, but appears to work fine.

James

diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -2152,6 +2152,61 @@ struct request *blk_rq_map_user(request_
 EXPORT_SYMBOL(blk_rq_map_user);
 
 /**
+ * blk_rq_map_user - map user data to a request, for REQ_BLOCK_PC usage
+ * @q:		request queue where request should be inserted
+ * @rw:		READ or WRITE data
+ * @iov:	pointer to the iovec
+ * @iov_count:	number of elements in the iovec
+ *
+ * Description:
+ *    Data will be mapped directly for zero copy io, if possible. Otherwise
+ *    a kernel bounce buffer is used.
+ *
+ *    A matching blk_rq_unmap_user() must be issued at the end of io, while
+ *    still in process context.
+ *
+ *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
+ *    before being submitted to the device, as pages mapped may be out of
+ *    reach. It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_unmap_user() for proper
+ *    unmapping.
+ */
+struct request *blk_rq_map_user_iov(request_queue_t *q, int rw,
+				    struct sg_iovec *iov, int iov_count)
+{
+	struct request *rq;
+	struct bio *bio;
+
+	if (!iov || iov_count <= 0)
+		return ERR_PTR(-EINVAL);
+
+	rq = blk_get_request(q, rw, __GFP_WAIT);
+	if (!rq)
+		return ERR_PTR(-ENOMEM);
+
+	/* we don't allow misaligned data like bio_map_user() does.  If the
+	 * user is using sg, they're expected to know the alignment constraints
+	 * and respect them accordingly */
+	bio = bio_map_user_iov(q, NULL, iov, iov_count, rw == READ);
+
+	if (!IS_ERR(bio)) {
+		rq->bio = rq->biotail = bio;
+		blk_rq_bio_prep(q, rq, bio);
+
+		rq->buffer = rq->data = NULL;
+		rq->data_len = bio->bi_size;
+		return rq;
+	}
+
+	/*
+	 * bio is the err-ptr
+	 */
+	blk_put_request(rq);
+	return (struct request *) bio;
+}
+EXPORT_SYMBOL(blk_rq_map_user_iov);
+
+/**
  * blk_rq_unmap_user - unmap a request with user data
  * @rq:		request to be unmapped
  * @bio:	bio for the request
@@ -2231,6 +2286,21 @@ struct request *blk_rq_map_kern(request_
 
 EXPORT_SYMBOL(blk_rq_map_kern);
 
+void blk_execute_rq_nowait(request_queue_t *q, struct gendisk *bd_disk,
+			   struct request *rq, int at_head,
+			   void (*done)(struct request *))
+{
+	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
+
+	rq->rq_disk = bd_disk;
+
+
+	rq->flags |= REQ_NOMERGE;
+	rq->end_io = done;
+	elv_add_request(q, rq, where, 1);
+	generic_unplug_device(q);
+}
+
 /**
  * blk_execute_rq - insert a request into queue for execution
  * @q:		queue to insert the request in
@@ -2245,13 +2315,10 @@ EXPORT_SYMBOL(blk_rq_map_kern);
 int blk_execute_rq(request_queue_t *q, struct gendisk *bd_disk,
 		   struct request *rq, int at_head)
 {
-	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 	DECLARE_COMPLETION(wait);
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	int err = 0;
 
-	rq->rq_disk = bd_disk;
-
 	/*
 	 * we need an extra reference to the request, so we can look at
 	 * it after io completion
@@ -2264,11 +2331,8 @@ int blk_execute_rq(request_queue_t *q, s
 		rq->sense_len = 0;
 	}
 
-	rq->flags |= REQ_NOMERGE;
 	rq->waiting = &wait;
-	rq->end_io = blk_end_sync_rq;
-	elv_add_request(q, rq, where, 1);
-	generic_unplug_device(q);
+	blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
 	wait_for_completion(&wait);
 	rq->waiting = NULL;
 
diff --git a/drivers/block/scsi_ioctl.c b/drivers/block/scsi_ioctl.c
--- a/drivers/block/scsi_ioctl.c
+++ b/drivers/block/scsi_ioctl.c
@@ -231,9 +231,6 @@ static int sg_io(struct file *file, requ
 	if (verify_command(file, cmd))
 		return -EPERM;
 
-	/*
-	 * we'll do that later
-	 */
 	if (hdr->iovec_count)
 		return -EOPNOTSUPP;
 
@@ -241,7 +238,7 @@ static int sg_io(struct file *file, requ
 		return -EIO;
 
 	reading = writing = 0;
-	if (hdr->dxfer_len) {
+	if (hdr->dxfer_len)
 		switch (hdr->dxfer_direction) {
 		default:
 			return -EINVAL;
@@ -256,14 +253,29 @@ static int sg_io(struct file *file, requ
 			break;
 		}
 
+	if (hdr->iovec_count) {
+		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
+		struct sg_iovec *iov = kmalloc(size, GFP_KERNEL);
+		if (!iov)
+			return -ENOMEM;
+
+		if (copy_from_user(iov, hdr->dxferp, size)) {
+			kfree(iov);
+			return -EFAULT;
+		}
+		rq = blk_rq_map_user_iov(q, writing ? WRITE : READ, iov,
+					 hdr->iovec_count);
+		kfree(iov);
+	} else if (hdr->dxfer_len) {
 		rq = blk_rq_map_user(q, writing ? WRITE : READ, hdr->dxferp,
 				     hdr->dxfer_len);
 
-		if (IS_ERR(rq))
-			return PTR_ERR(rq);
 	} else
 		rq = blk_get_request(q, READ, __GFP_WAIT);
 
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
+
 	/*
 	 * fill in request structure
 	 */
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1230,6 +1230,9 @@ static void scsi_eh_offline_sdevs(struct
 				scmd->device->channel,
 				scmd->device->id,
 				scmd->device->lun);
+		/* try to reset the bus and the card to a sane state */
+		scsi_try_bus_reset(scmd);
+		scsi_try_host_reset(scmd);
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
 		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {
 			/*
diff --git a/fs/bio.c b/fs/bio.c
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
+#include <scsi/sg.h>		/* for struct sg_iovec */
 
 #define BIO_POOL_SIZE 256
 
@@ -549,22 +550,34 @@ out_bmd:
 	return ERR_PTR(ret);
 }
 
-static struct bio *__bio_map_user(request_queue_t *q, struct block_device *bdev,
-				  unsigned long uaddr, unsigned int len,
-				  int write_to_vm)
+static struct bio *__bio_map_user_iov(request_queue_t *q,
+				      struct block_device *bdev,
+				      struct sg_iovec *iov, int iov_count,
+				      int write_to_vm)
 {
-	unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = uaddr >> PAGE_SHIFT;
-	const int nr_pages = end - start;
-	int ret, offset, i;
+	int i, j;
+	int nr_pages = 0;
 	struct page **pages;
 	struct bio *bio;
+	int cur_page = 0;
+	int ret, offset;
 
-	/*
-	 * transfer and buffer must be aligned to at least hardsector
-	 * size for now, in the future we can relax this restriction
-	 */
-	if ((uaddr & queue_dma_alignment(q)) || (len & queue_dma_alignment(q)))
+	for (i = 0; i < iov_count; i++) {
+		unsigned long uaddr = (unsigned long)iov[i].iov_base;
+		unsigned long len = iov[i].iov_len;
+		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		unsigned long start = uaddr >> PAGE_SHIFT;
+
+		nr_pages += end - start;
+		/*
+		 * transfer and buffer must be aligned to at least hardsector
+		 * size for now, in the future we can relax this restriction
+		 */
+		if ((uaddr & queue_dma_alignment(q)) || (len & queue_dma_alignment(q)))
+			return ERR_PTR(-EINVAL);
+	}
+
+	if (!nr_pages)
 		return ERR_PTR(-EINVAL);
 
 	bio = bio_alloc(GFP_KERNEL, nr_pages);
@@ -576,42 +589,54 @@ static struct bio *__bio_map_user(reques
 	if (!pages)
 		goto out;
 
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(current, current->mm, uaddr, nr_pages,
-						write_to_vm, 0, pages, NULL);
-	up_read(&current->mm->mmap_sem);
+	memset(pages, 0, nr_pages * sizeof(struct page *));
 
-	if (ret < nr_pages)
-		goto out;
-
-	bio->bi_bdev = bdev;
+	for (i = 0; i < iov_count; i++) {
+		unsigned long uaddr = (unsigned long)iov[i].iov_base;
+		unsigned long len = iov[i].iov_len;
+		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		unsigned long start = uaddr >> PAGE_SHIFT;
+		const int local_nr_pages = end - start;
+		const int page_limit = cur_page + local_nr_pages;
+		
+		down_read(&current->mm->mmap_sem);
+		ret = get_user_pages(current, current->mm, uaddr,
+				     local_nr_pages,
+				     write_to_vm, 0, &pages[cur_page], NULL);
+		up_read(&current->mm->mmap_sem);
+
+		if (ret < local_nr_pages)
+			goto out_unmap;
+
+
+		offset = uaddr & ~PAGE_MASK;
+		for (j = cur_page; j < page_limit; j++) {
+			unsigned int bytes = PAGE_SIZE - offset;
+
+			if (len <= 0)
+				break;
+			
+			if (bytes > len)
+				bytes = len;
+
+			/*
+			 * sorry...
+			 */
+			if (__bio_add_page(q, bio, pages[j], bytes, offset) < bytes)
+				break;
 
-	offset = uaddr & ~PAGE_MASK;
-	for (i = 0; i < nr_pages; i++) {
-		unsigned int bytes = PAGE_SIZE - offset;
-
-		if (len <= 0)
-			break;
-
-		if (bytes > len)
-			bytes = len;
+			len -= bytes;
+			offset = 0;
+		}
 
+		cur_page = j;
 		/*
-		 * sorry...
+		 * release the pages we didn't map into the bio, if any
 		 */
-		if (__bio_add_page(q, bio, pages[i], bytes, offset) < bytes)
-			break;
-
-		len -= bytes;
-		offset = 0;
+		while (j < page_limit)
+			page_cache_release(pages[j++]);
 	}
 
-	/*
-	 * release the pages we didn't map into the bio, if any
-	 */
-	while (i < nr_pages)
-		page_cache_release(pages[i++]);
-
 	kfree(pages);
 
 	/*
@@ -620,9 +645,17 @@ static struct bio *__bio_map_user(reques
 	if (!write_to_vm)
 		bio->bi_rw |= (1 << BIO_RW);
 
+	bio->bi_bdev = bdev;
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
 	return bio;
-out:
+
+ out_unmap:
+	for (i = 0; i < nr_pages; i++) {
+		if(!pages[i])
+			break;
+		page_cache_release(pages[i]);
+	}
+ out:
 	kfree(pages);
 	bio_put(bio);
 	return ERR_PTR(ret);
@@ -642,9 +675,33 @@ out:
 struct bio *bio_map_user(request_queue_t *q, struct block_device *bdev,
 			 unsigned long uaddr, unsigned int len, int write_to_vm)
 {
+	struct sg_iovec iov;
+
+	iov.iov_base = (__user void *)uaddr;
+	iov.iov_len = len;
+
+	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm);
+}
+
+/**
+ *	bio_map_user_iov - map user sg_iovec table into bio
+ *	@q: the request_queue_t for the bio
+ *	@bdev: destination block device
+ *	@iov:	the iovec.
+ *	@iov_count: number of elements in the iovec
+ *	@write_to_vm: bool indicating writing to pages or not
+ *
+ *	Map the user space address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_map_user_iov(request_queue_t *q, struct block_device *bdev,
+			     struct sg_iovec *iov, int iov_count,
+			     int write_to_vm)
+{
 	struct bio *bio;
+	int len = 0, i;
 
-	bio = __bio_map_user(q, bdev, uaddr, len, write_to_vm);
+	bio = __bio_map_user_iov(q, bdev, iov, iov_count, write_to_vm);
 
 	if (IS_ERR(bio))
 		return bio;
@@ -657,6 +714,9 @@ struct bio *bio_map_user(request_queue_t
 	 */
 	bio_get(bio);
 
+	for (i = 0; i < iov_count; i++)
+		len += iov[i].iov_len;
+
 	if (bio->bi_size == len)
 		return bio;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -281,6 +281,10 @@ extern int bio_add_page(struct bio *, st
 extern int bio_get_nr_vecs(struct block_device *);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int);
+struct sg_iovec;
+extern struct bio *bio_map_user_iov(struct request_queue *,
+				    struct block_device *,
+				    struct sg_iovec *, int, int);
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 				unsigned int);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -559,6 +559,8 @@ extern void __blk_stop_queue(request_que
 extern void blk_run_queue(request_queue_t *);
 extern void blk_queue_activity_fn(request_queue_t *, activity_fn *, void *);
 extern struct request *blk_rq_map_user(request_queue_t *, int, void __user *, unsigned int);
+struct sg_iovec;
+extern struct request *blk_rq_map_user_iov(request_queue_t *, int, struct sg_iovec *, int);
 extern int blk_rq_unmap_user(struct request *, struct bio *, unsigned int);
 extern struct request *blk_rq_map_kern(request_queue_t *, int, void *,
 					unsigned int, unsigned int);



