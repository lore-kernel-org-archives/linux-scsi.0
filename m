From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/5] export blk layer functions needed for
	blk_execute_rq_nowait
Date: Fri, 11 Nov 2005 05:30:24 -0600
Message-ID: <1131708625.3066.19.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:28086 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750720AbVKKLag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 06:30:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

To send async requests we need these two functions exported.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 5f52e30..48d355b 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2308,6 +2308,8 @@ void blk_execute_rq_nowait(request_queue
 	generic_unplug_device(q);
 }
 
+EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
+
 /**
  * blk_execute_rq - insert a request into queue for execution
  * @q:		queue to insert the request in
@@ -2446,7 +2448,7 @@ void disk_round_stats(struct gendisk *di
 /*
  * queue lock must be held
  */
-static void __blk_put_request(request_queue_t *q, struct request *req)
+void __blk_put_request(request_queue_t *q, struct request *req)
 {
 	struct request_list *rl = req->rl;
 
@@ -2475,6 +2477,8 @@ static void __blk_put_request(request_qu
 	}
 }
 
+EXPORT_SYMBOL_GPL(__blk_put_request);
+
 void blk_put_request(struct request *req)
 {
 	unsigned long flags;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 025a7f0..46e927b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -557,6 +557,7 @@ extern void blk_unregister_queue(struct 
 extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
+extern void __blk_put_request(request_queue_t *, struct request *);
 extern void blk_end_sync_rq(struct request *rq);
 extern void blk_attempt_remerge(request_queue_t *, struct request *);
 extern struct request *blk_get_request(request_queue_t *, int, gfp_t);
@@ -578,6 +579,10 @@ extern int blk_rq_map_kern(request_queue
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


