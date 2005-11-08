From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/10] export block layer helpers
Date: Tue, 08 Nov 2005 04:06:31 -0600
Message-ID: <1131444392.23111.60.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:5535 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932499AbVKHKGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 05:06:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

To send async requests we need these two functions exported.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
index 2747741..f9b83d2 100644
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -2309,6 +2309,8 @@ void blk_execute_rq_nowait(request_queue
 	generic_unplug_device(q);
 }
 
+EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
+
 /**
  * blk_execute_rq - insert a request into queue for execution
  * @q:		queue to insert the request in
@@ -2447,7 +2449,7 @@ void disk_round_stats(struct gendisk *di
 /*
  * queue lock must be held
  */
-static void __blk_put_request(request_queue_t *q, struct request *req)
+void __blk_put_request(request_queue_t *q, struct request *req)
 {
 	struct request_list *rl = req->rl;
 
@@ -2476,6 +2478,8 @@ static void __blk_put_request(request_qu
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


