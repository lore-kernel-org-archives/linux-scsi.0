From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/2] dont always try zero copy for blk_rq_map_user
Date: Mon, 08 Aug 2005 23:38:17 -0500
Message-ID: <1123562297.6090.12.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:62609 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932374AbVHIGiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2005 02:38:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, linux-scsi@vger.kernel.org

Modify blk_rq_map_user so that is does not always try
to do zero copy. This is needed becuase the sg driver's
old interface  can do a sg_write to send the command to
the driver then later do a sg_read and pass a pointer to 
a buffer to transfer the data to. For SG_IO we
know the detination buffer at sg_write time, so we
can set everything up at blk_rq_map_user time.

Also export some functions and add some wrappers for
struct request handling.

I am still working on these patches and I thought
I saw Jens was going on vacation so I left him off the
cc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -2107,6 +2107,7 @@ EXPORT_SYMBOL(blk_insert_request);
  * @rw:		READ or WRITE data
  * @ubuf:	the user buffer
  * @len:	length of user data
+ * @zero_copy:	1 to try zero copy, 0 for kernel bounce buffer
  *
  * Description:
  *    Data will be mapped directly for zero copy io, if possible. Otherwise
@@ -2122,7 +2123,7 @@ EXPORT_SYMBOL(blk_insert_request);
  *    unmapping.
  */
 int blk_rq_map_user(request_queue_t *q, struct request *rq, void __user *ubuf,
-		    unsigned int len)
+		    unsigned int len, int zero_copy)
 {
 	unsigned long uaddr;
 	struct bio *bio;
@@ -2140,7 +2141,8 @@ int blk_rq_map_user(request_queue_t *q, 
 	 * direct dma. else, set up kernel bounce buffers
 	 */
 	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
+	if (zero_copy &&
+	   !(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
 		bio = bio_map_user(q, NULL, uaddr, len, reading);
 	else
 		bio = bio_copy_user(q, uaddr, len, reading);
@@ -2210,12 +2212,13 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
  * blk_rq_unmap_user - unmap a request with user data
  * @rq:		request to be unmapped
  * @bio:	bio for the request
+ * @ubuf:	buffer to copy data to for the kernel bounce buffer case
  * @ulen:	length of user buffer
  *
  * Description:
  *    Unmap a request previously mapped by blk_rq_map_user().
  */
-int blk_rq_unmap_user(struct bio *bio, unsigned int ulen)
+int blk_rq_unmap_user(struct bio *bio, void __user *ubuf, unsigned int ulen)
 {
 	int ret = 0;
 
@@ -2223,7 +2226,7 @@ int blk_rq_unmap_user(struct bio *bio, u
 		if (bio_flagged(bio, BIO_USER_MAPPED))
 			bio_unmap_user(bio);
 		else
-			ret = bio_uncopy_user(bio);
+			ret = bio_uncopy_user(bio, ubuf);
 	}
 
 	return 0;
@@ -2278,6 +2281,8 @@ void blk_execute_rq_nowait(request_queue
 	generic_unplug_device(q);
 }
 
+EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
+
 /**
  * blk_execute_rq - insert a request into queue for execution
  * @q:		queue to insert the request in
@@ -2421,7 +2426,7 @@ void disk_round_stats(struct gendisk *di
 /*
  * queue lock must be held
  */
-static void __blk_put_request(request_queue_t *q, struct request *req)
+void __blk_put_request(request_queue_t *q, struct request *req)
 {
 	struct request_list *rl = req->rl;
 
@@ -2449,6 +2454,8 @@ static void __blk_put_request(request_qu
 	}
 }
 
+EXPORT_SYMBOL_GPL(__blk_put_request);
+
 void blk_put_request(struct request *req)
 {
 	/*
diff --git a/drivers/block/scsi_ioctl.c b/drivers/block/scsi_ioctl.c
--- a/drivers/block/scsi_ioctl.c
+++ b/drivers/block/scsi_ioctl.c
@@ -269,7 +269,7 @@ static int sg_io(struct file *file, requ
 		ret = blk_rq_map_user_iov(q, rq, iov, hdr->iovec_count);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
+		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len, 1);
 
 	if (ret)
 		goto out;
@@ -330,7 +330,7 @@ static int sg_io(struct file *file, requ
 			hdr->sb_len_wr = len;
 	}
 
-	if (blk_rq_unmap_user(bio, hdr->dxfer_len))
+	if (blk_rq_unmap_user(bio, hdr->dxferp, hdr->dxfer_len))
 		ret = -EFAULT;
 
 	/* may not have succeeded, but output values written to control
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2112,7 +2112,7 @@ static int cdrom_read_cdda_bpc(struct cd
 
 		len = nr * CD_FRAMESIZE_RAW;
 
-		ret = blk_rq_map_user(q, rq, ubuf, len);
+		ret = blk_rq_map_user(q, rq, ubuf, len, 1);
 		if (ret)
 			break;
 
@@ -2142,7 +2142,7 @@ static int cdrom_read_cdda_bpc(struct cd
 			cdi->last_sense = s->sense_key;
 		}
 
-		if (blk_rq_unmap_user(bio, len))
+		if (blk_rq_unmap_user(bio, ubuf, len))
 			ret = -EFAULT;
 
 		if (ret)
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1267,6 +1267,16 @@ void scsi_print_sense(const char *devcla
 }
 EXPORT_SYMBOL(scsi_print_sense);
 
+void scsi_print_rq_sense(const char *devclass, struct request *rq)
+{
+	const char *name = devclass;
+
+	if (rq->rq_disk)
+		name = rq->rq_disk->disk_name;
+	__scsi_print_sense(name, rq->sense, sizeof(rq->sense));
+}
+EXPORT_SYMBOL_GPL(scsi_print_rq_sense);
+
 void scsi_print_req_sense(const char *devclass, struct scsi_request *sreq)
 {
 	const char *name = devclass;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1896,6 +1896,12 @@ int scsi_request_normalize_sense(struct 
 }
 EXPORT_SYMBOL(scsi_request_normalize_sense);
 
+int scsi_rq_normalize_sense(struct request *rq, struct scsi_sense_hdr *sshdr)
+{
+	return scsi_normalize_sense(rq->sense, sizeof(rq->sense), sshdr);
+}
+EXPORT_SYMBOL_GPL(scsi_rq_normalize_sense);
+
 int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
 				 struct scsi_sense_hdr *sshdr)
 {
diff --git a/fs/bio.c b/fs/bio.c
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -401,7 +401,6 @@ int bio_add_page(struct bio *bio, struct
 
 struct bio_map_data {
 	struct bio_vec *iovecs;
-	void __user *userptr;
 };
 
 static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio)
@@ -434,11 +433,12 @@ static struct bio_map_data *bio_alloc_ma
 /**
  *	bio_uncopy_user	-	finish previously mapped bio
  *	@bio: bio being terminated
+ *	@userptr: user addr to copy data to
  *
  *	Free pages allocated from bio_copy_user() and write back data
  *	to user space in case of a read.
  */
-int bio_uncopy_user(struct bio *bio)
+int bio_uncopy_user(struct bio *bio, void __user *userptr)
 {
 	struct bio_map_data *bmd = bio->bi_private;
 	const int read = bio_data_dir(bio) == READ;
@@ -449,11 +449,11 @@ int bio_uncopy_user(struct bio *bio)
 		char *addr = page_address(bvec->bv_page);
 		unsigned int len = bmd->iovecs[i].bv_len;
 
-		if (read && !ret && copy_to_user(bmd->userptr, addr, len))
+		if (read && !ret && copy_to_user(userptr, addr, len))
 			ret = -EFAULT;
 
 		__free_page(bvec->bv_page);
-		bmd->userptr += len;
+		userptr += len;
 	}
 	bio_free_map_data(bmd);
 	bio_put(bio);
@@ -463,7 +463,7 @@ int bio_uncopy_user(struct bio *bio)
 /**
  *	bio_copy_user	-	copy user data to bio
  *	@q: destination block queue
- *	@uaddr: start of user address
+ *	@uaddr: for writes start of user address and undefined for reads
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
  *
@@ -486,8 +486,6 @@ struct bio *bio_copy_user(request_queue_
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
-	bmd->userptr = (void __user *) uaddr;
-
 	ret = -ENOMEM;
 	bio = bio_alloc(GFP_KERNEL, end - start);
 	if (!bio)
diff --git a/include/linux/bio.h b/include/linux/bio.h
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -305,7 +305,7 @@ extern struct bio *bio_map_kern(struct r
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
-extern int bio_uncopy_user(struct bio *);
+extern int bio_uncopy_user(struct bio *, void __user *);
 void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -547,6 +547,7 @@ extern void blk_unregister_queue(struct 
 extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
+extern void __blk_put_request(request_queue_t *, struct request *);
 extern void blk_end_sync_rq(struct request *rq);
 extern void blk_attempt_remerge(request_queue_t *, struct request *);
 extern struct request *blk_get_request(request_queue_t *, int, int);
@@ -562,12 +563,16 @@ extern void blk_sync_queue(struct reques
 extern void __blk_stop_queue(request_queue_t *q);
 extern void blk_run_queue(request_queue_t *);
 extern void blk_queue_activity_fn(request_queue_t *, activity_fn *, void *);
-extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned int);
-extern int blk_rq_unmap_user(struct bio *, unsigned int);
+extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned int, int);
+extern int blk_rq_unmap_user(struct bio *, void __user *, unsigned int);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, unsigned int);
 extern int blk_rq_map_user_iov(request_queue_t *, struct request *, struct sg_iovec *, int);
 extern int blk_execute_rq(request_queue_t *, struct gendisk *,
 			  struct request *, int);
+extern void blk_execute_rq_nowait(request_queue_t *, struct gendisk *,
+				  struct request *, int,
+				  void (*done)(struct request *));
+
 static inline request_queue_t *bdev_get_queue(struct block_device *bdev)
 {
 	return bdev->bd_disk->queue;
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -10,6 +10,7 @@ extern void scsi_print_sense_hdr(const c
 extern void __scsi_print_command(unsigned char *);
 extern void scsi_print_sense(const char *, struct scsi_cmnd *);
 extern void scsi_print_req_sense(const char *, struct scsi_request *);
+extern void scsi_print_rq_sense(const char *, struct request *);
 extern void __scsi_print_sense(const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -47,6 +47,7 @@ extern int scsi_request_normalize_sense(
 		struct scsi_sense_hdr *sshdr);
 extern int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
 		struct scsi_sense_hdr *sshdr);
+extern int scsi_rq_normalize_sense(struct request *, struct scsi_sense_hdr *);
 
 static inline int scsi_sense_is_deferred(struct scsi_sense_hdr *sshdr)
 {


