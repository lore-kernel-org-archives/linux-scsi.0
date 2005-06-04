From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 1/4] add blk_rq_map_kern function
Date: Fri, 03 Jun 2005 18:27:52 -0700
Message-ID: <1117848472.23706.1.camel@mina>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

add blk_rq_map_kern which takes a kernel buffer and maps it into
a request and bio. This can be used by the dm hw_handlers, old
sg_scsi_ioctl, and one day scsi special requests so all requests
comming into scsi will have bios. All requests having bios
should allow scsi to use scatter lists for all IO and allow it
to use block layer functions.

This patch was made against 2.6.12-rc5 but also works against
scsi-misc.


diff -uarp linux-2.6.12-rc5.patch/drivers/block/ll_rw_blk.c linux-2.6.12-rc5/drivers/block/ll_rw_blk.c
--- linux-2.6.12-rc5.patch/drivers/block/ll_rw_blk.c	2005-06-03 16:00:47.000000000 -0700
+++ linux-2.6.12-rc5/drivers/block/ll_rw_blk.c	2005-06-03 15:08:07.000000000 -0700
@@ -281,6 +281,7 @@ static inline void rq_init(request_queue
 	rq->special = NULL;
 	rq->data_len = 0;
 	rq->data = NULL;
+	rq->nr_phys_segments = 0;
 	rq->sense = NULL;
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
@@ -2184,6 +2185,60 @@ int blk_rq_unmap_user(struct request *rq
 
 EXPORT_SYMBOL(blk_rq_unmap_user);
 
+static int blk_rq_map_kern_endio(struct bio *bio, unsigned int bytes_done,
+				 int error)
+{
+	if (bio->bi_size)
+		return 1;
+	bio_put(bio);
+	return 0;
+}
+
+/**
+ * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
+ * @q:		request queue where request should be inserted
+ * @rw:		READ or WRITE data
+ * @kbuf:	the kernel buffer
+ * @len:	length of user data
+ */
+struct request *blk_rq_map_kern(request_queue_t *q, int rw, void *kbuf,
+				unsigned int len, unsigned int gfp_mask)
+{
+	struct request *rq;
+	struct bio *bio;
+
+	if (len > (q->max_sectors << 9))
+		return ERR_PTR(-EINVAL);
+	if ((!len && kbuf) || (len && !kbuf))
+		return ERR_PTR(-EINVAL);
+
+	rq = blk_get_request(q, rw, gfp_mask);
+	if (!rq)
+		return ERR_PTR(-ENOMEM);
+
+	bio = bio_map_kern(q, kbuf, len, gfp_mask);
+	if (!IS_ERR(bio)) {
+		if (rw)
+			bio->bi_rw |= (1 << BIO_RW);
+		bio->bi_end_io = blk_rq_map_kern_endio;
+
+		rq->bio = rq->biotail = bio;
+		blk_rq_bio_prep(q, rq, bio);
+
+		rq->buffer = rq->data = NULL;
+		rq->data_len = len;
+		return rq;
+	}
+
+	/*
+	 * bio is the err-ptr
+	 */
+	blk_put_request(rq);
+	return (struct request *) bio;
+}
+
+EXPORT_SYMBOL(blk_rq_map_kern);
+
 /**
  * blk_execute_rq - insert a request into queue for execution
  * @q:		queue to insert the request in
diff -uarp linux-2.6.12-rc5.patch/fs/bio.c linux-2.6.12-rc5/fs/bio.c
--- linux-2.6.12-rc5.patch/fs/bio.c	2005-06-03 16:00:07.000000000 -0700
+++ linux-2.6.12-rc5/fs/bio.c	2005-06-03 14:31:41.000000000 -0700
@@ -701,6 +701,71 @@ void bio_unmap_user(struct bio *bio)
 	bio_put(bio);
 }
 
+static struct bio *__bio_map_kern(request_queue_t *q, void *data,
+				  unsigned int len, unsigned int gfp_mask)
+{
+	unsigned long kaddr = (unsigned long)data;
+	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	unsigned long start = kaddr >> PAGE_SHIFT;
+	const int nr_pages = end - start;
+	int offset, i;
+	struct bio *bio;
+
+	bio = bio_alloc(gfp_mask, nr_pages);
+	if (!bio)
+		return ERR_PTR(-ENOMEM);
+
+	offset = offset_in_page(kaddr);
+	for (i = 0; i < nr_pages; i++) {
+		unsigned int bytes = PAGE_SIZE - offset;
+
+		if (len <= 0)
+			break;
+
+		if (bytes > len)
+			bytes = len;
+
+		if (__bio_add_page(q, bio, virt_to_page(data), bytes,
+				   offset) < bytes)
+			break;
+
+		data += bytes;
+		len -= bytes;
+		offset = 0;
+	}
+
+	return bio;
+}
+
+/**
+ *	bio_map_kern	-	map kernel address into bio
+ *	@q: the request_queue_t for the bio
+ *	@data: pointer to buffer to map
+ *	@len: length in bytes
+ *	@gfp_mask: allocation flags for bio allocation
+ *
+ *	Map the kernel address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_map_kern(request_queue_t *q, void *data, unsigned int len,
+			 unsigned int gfp_mask)
+{
+	struct bio *bio;
+
+	bio = __bio_map_kern(q, data, len, gfp_mask);
+	if (IS_ERR(bio))
+		return bio;
+
+	if (bio->bi_size == len)
+		return bio;
+
+	/*
+	 * Don't support partial mappings.
+	 */
+	bio_put(bio);
+	return ERR_PTR(-EINVAL);
+}
+
 /*
  * bio_set_pages_dirty() and bio_check_pages_dirty() are support functions
  * for performing direct-IO in BIOs.
@@ -1088,6 +1153,7 @@ EXPORT_SYMBOL(bio_add_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
 EXPORT_SYMBOL(bio_map_user);
 EXPORT_SYMBOL(bio_unmap_user);
+EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
 EXPORT_SYMBOL(bio_split_pool);
diff -uarp linux-2.6.12-rc5.patch/include/linux/bio.h linux-2.6.12-rc5/include/linux/bio.h
--- linux-2.6.12-rc5.patch/include/linux/bio.h	2005-06-03 15:59:38.000000000 -0700
+++ linux-2.6.12-rc5/include/linux/bio.h	2005-06-03 14:31:41.000000000 -0700
@@ -282,6 +282,8 @@ extern int bio_get_nr_vecs(struct block_
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int);
 extern void bio_unmap_user(struct bio *);
+extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
+				unsigned int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
diff -uarp linux-2.6.12-rc5.patch/include/linux/blkdev.h linux-2.6.12-rc5/include/linux/blkdev.h
--- linux-2.6.12-rc5.patch/include/linux/blkdev.h	2005-06-03 15:59:38.000000000 -0700
+++ linux-2.6.12-rc5/include/linux/blkdev.h	2005-06-03 15:08:01.000000000 -0700
@@ -560,6 +560,8 @@ extern void blk_run_queue(request_queue_
 extern void blk_queue_activity_fn(request_queue_t *, activity_fn *, void *);
 extern struct request *blk_rq_map_user(request_queue_t *, int, void __user *, unsigned int);
 extern int blk_rq_unmap_user(struct request *, struct bio *, unsigned int);
+extern struct request *blk_rq_map_kern(request_queue_t *, int, void *,
+					unsigned int, unsigned int);
 extern int blk_execute_rq(request_queue_t *, struct gendisk *, struct request *);
 
 static inline request_queue_t *bdev_get_queue(struct block_device *bdev)
