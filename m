From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/5] export block layer functions and add a bio helper
Date: Thu, 15 Sep 2005 23:39:37 -0500
Message-ID: <1126845578.9276.41.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36298 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751229AbVIPEjk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 00:39:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi, dougg@torque.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

SCSI wants to do async request so export blk_execute_rq_nowait and
__blk_put_request.

And add bio_map_pages() which maps X bytes from a pages pointer
array into a bio. This is useful for mapping a block of pages
allocated from __get_free_pages/alloc_pages into a bio.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -2302,6 +2302,8 @@ void blk_execute_rq_nowait(request_queue
 	generic_unplug_device(q);
 }
 
+EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
+
 /**
  * blk_execute_rq - insert a request into queue for execution
  * @q:		queue to insert the request in
@@ -2483,7 +2485,7 @@ void disk_round_stats(struct gendisk *di
 /*
  * queue lock must be held
  */
-static void __blk_put_request(request_queue_t *q, struct request *req)
+void __blk_put_request(request_queue_t *q, struct request *req)
 {
 	struct request_list *rl = req->rl;
 
@@ -2511,6 +2513,8 @@ static void __blk_put_request(request_qu
 	}
 }
 
+EXPORT_SYMBOL_GPL(__blk_put_request);
+
 void blk_put_request(struct request *req)
 {
 	/*
diff --git a/fs/bio.c b/fs/bio.c
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -843,6 +843,49 @@ struct bio *bio_map_kern(request_queue_t
 	return ERR_PTR(-EINVAL);
 }
 
+/**
+ *	bio_map_pages	-	map array of pages into bio
+ *	@q: the request_queue_t for the bio
+ *	@page: pages to be mapped
+ *	@len: number of bytes to map from page array
+ *	@offset: offset in first page
+ *	@gfp_mask: allocation flags for bio allocation
+ *
+ *	Map @len bytes from @page array into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_map_pages(request_queue_t *q, struct page *page,
+			  unsigned int len, unsigned int offset,
+			  unsigned int gfp_mask)
+{
+	int nr_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	struct bio *bio;
+
+	bio = bio_alloc(gfp_mask, nr_pages);
+	if (!bio)
+		return ERR_PTR(-ENOMEM);
+
+	while (len) {
+		unsigned int bytes = PAGE_SIZE - offset;
+
+		if (bytes > len)
+			bytes = len;
+
+		if (__bio_add_page(q, bio, page, bytes, offset) < bytes)
+			goto free_bio;
+
+		offset = 0;
+		len -= bytes;
+		page++;
+	}
+
+	return bio;
+
+free_bio:
+	bio_put(bio);
+	return ERR_PTR(-EINVAL);
+}
+
 /*
  * bio_set_pages_dirty() and bio_check_pages_dirty() are support functions
  * for performing direct-IO in BIOs.
diff --git a/include/linux/bio.h b/include/linux/bio.h
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -302,6 +302,8 @@ extern struct bio *bio_map_user_iov(stru
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 				unsigned int);
+extern struct bio *bio_map_pages(struct request_queue *, struct page *,
+				 unsigned int, unsigned int, unsigned int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -548,6 +548,7 @@ extern void blk_unregister_queue(struct 
 extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
+extern void __blk_put_request(request_queue_t *, struct request *);
 extern void blk_end_sync_rq(struct request *rq);
 extern void blk_attempt_remerge(request_queue_t *, struct request *);
 extern struct request *blk_get_request(request_queue_t *, int, int);
@@ -569,6 +570,10 @@ extern int blk_rq_map_kern(request_queue
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


