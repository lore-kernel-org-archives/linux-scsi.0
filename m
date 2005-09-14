From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC/RFT 1/4]  add some block layer helpers
Date: Wed, 14 Sep 2005 17:19:44 -0500
Message-ID: <1126736384.16778.24.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:708 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030200AbVINWT7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 18:19:59 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8EMJvtl021623
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2005 17:19:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

add blk_rq_map_kern_iov() which takes a iovec of buffers then
maps them into bios and a request. It can make them into multiple
bios to support sg and st's large requests and avoid the BIO_MAX_PAGES
limit.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
+#include <linux/uio.h>
 #include <linux/blkdev.h>
 
 /*
@@ -2278,6 +2279,70 @@ int blk_rq_map_kern(request_queue_t *q, 
 EXPORT_SYMBOL(blk_rq_map_kern);
 
 /**
+ * blk_rq_map_kern_iov - map kernel data to a request, for REQ_BLOCK_PC usage
+ * @q:		request queue where request should be inserted
+ * @rq:		request to fill
+ * @vec:	pointer to kvec
+ * @vec_count:	number of elements in kvec
+ * @gfp_mask:	memory allocation flags
+ *
+ * blk_rq_map_kern_iov maps a kvec into a multiple bio request so that
+ * it can create very large requests.
+ *
+ * For now we assume that each element will fit in one bio
+ */
+int blk_rq_map_kern_iov(request_queue_t *q, struct request *rq,
+			struct kvec *vec, int vec_count, unsigned int gfp)
+{
+	struct bio *bio;
+	unsigned int len = 0;
+	int i, err = 0;
+
+	for (i = 0; i < vec_count; i++) {
+		bio = bio_map_kern(q, vec[i].iov_base, vec[i].iov_len, gfp);
+		if (IS_ERR(bio)) {
+			err = PTR_ERR(bio);
+			goto free_bios;
+		}
+
+		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+		blk_queue_bounce(q, &bio);
+		len += vec[i].iov_len;
+
+		if (rq_data_dir(rq) == WRITE)
+			bio->bi_rw |= (1 << BIO_RW);
+
+		if (i == 0)
+			blk_rq_bio_prep(q, rq, bio);
+		else if (!q->back_merge_fn(q, rq, bio)) {
+			goto free_bios;
+		} else {
+			rq->biotail->bi_next = bio;
+			rq->biotail = bio;
+		}
+
+		rq->nr_sectors = rq->hard_nr_sectors += bio_sectors(bio);
+	}
+
+	rq->buffer = rq->data = NULL;
+	rq->data_len = len;
+	return 0;
+
+free_bios:
+	while ((bio = rq->bio) != NULL) {
+		rq->bio = bio->bi_next;
+		/*
+		 * call endio instead of bio_put incase it was bounced
+		 */
+		bio_endio(bio, bio->bi_size, 0);
+	}
+
+	return err;
+}
+
+EXPORT_SYMBOL(blk_rq_map_kern_iov);
+
+/**
  * blk_execute_rq_nowait - insert a request into queue for execution
  * @q:		queue to insert the request in
  * @bd_disk:	matching gendisk
@@ -2302,6 +2367,8 @@ void blk_execute_rq_nowait(request_queue
 	generic_unplug_device(q);
 }
 
+EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
+
 /**
  * blk_execute_rq - insert a request into queue for execution
  * @q:		queue to insert the request in
@@ -2483,7 +2550,7 @@ void disk_round_stats(struct gendisk *di
 /*
  * queue lock must be held
  */
-static void __blk_put_request(request_queue_t *q, struct request *req)
+void __blk_put_request(request_queue_t *q, struct request *req)
 {
 	struct request_list *rl = req->rl;
 
@@ -2511,6 +2578,8 @@ static void __blk_put_request(request_qu
 	}
 }
 
+EXPORT_SYMBOL_GPL(__blk_put_request);
+
 void blk_put_request(struct request *req)
 {
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -22,6 +22,7 @@ typedef struct request_queue request_que
 struct elevator_queue;
 typedef struct elevator_queue elevator_t;
 struct request_pm_state;
+struct kvec;
 
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
@@ -548,6 +549,7 @@ extern void blk_unregister_queue(struct 
 extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
+extern void __blk_put_request(request_queue_t *, struct request *);
 extern void blk_end_sync_rq(struct request *rq);
 extern void blk_attempt_remerge(request_queue_t *, struct request *);
 extern struct request *blk_get_request(request_queue_t *, int, int);
@@ -566,9 +568,15 @@ extern void blk_queue_activity_fn(reques
 extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned int);
 extern int blk_rq_unmap_user(struct bio *, unsigned int);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, unsigned int);
+extern int blk_rq_map_kern_iov(request_queue_t *, struct request *,
+			       struct kvec *, int, unsigned int);
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


