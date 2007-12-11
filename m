From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 30/30] blk_end_request: cleanup of request
 completion (take 4)
Date: Tue, 11 Dec 2007 17:53:24 -0500 (EST)
Message-ID: <20071211.175324.11049746.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

This patch merges complete_request() into end_that_request_last()
for cleanup.

complete_request() was introduced by earlier part of this patch-set,
not to break the existing users of end_that_request_last().

Since all users are converted to blk_end_request interfaces and
end_that_request_last() is no longer exported, the code can be
merged to end_that_request_last().

Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

Index: 2.6.24-rc4/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc4.orig/block/ll_rw_blk.c
+++ 2.6.24-rc4/block/ll_rw_blk.c
@@ -3616,6 +3616,12 @@ static void end_that_request_last(struct
 {
 	struct gendisk *disk = req->rq_disk;
 
+	if (blk_rq_tagged(req))
+		blk_queue_end_tag(req->q, req);
+
+	if (blk_queued_rq(req))
+		blkdev_dequeue_request(req);
+
 	if (unlikely(laptop_mode) && blk_fs_request(req))
 		laptop_io_completion();
 
@@ -3633,10 +3639,15 @@ static void end_that_request_last(struct
 		disk_round_stats(disk);
 		disk->in_flight--;
 	}
+
 	if (req->end_io)
 		req->end_io(req, error);
-	else
+	else {
+		if (blk_bidi_rq(req))
+			__blk_put_request(req->next_rq->q, req->next_rq);
+
 		__blk_put_request(req->q, req);
+	}
 }
 
 static inline void __end_request(struct request *rq, int uptodate,
@@ -3737,20 +3748,6 @@ void end_request(struct request *req, in
 }
 EXPORT_SYMBOL(end_request);
 
-static void complete_request(struct request *rq, int error)
-{
-	if (blk_rq_tagged(rq))
-		blk_queue_end_tag(rq->q, rq);
-
-	if (blk_queued_rq(rq))
-		blkdev_dequeue_request(rq);
-
-	if (blk_bidi_rq(rq) && !rq->end_io)
-		__blk_put_request(rq->next_rq->q, rq->next_rq);
-
-	end_that_request_last(rq, error);
-}
-
 /**
  * blk_end_io - Generic end_io function to complete a request.
  * @rq:           the request being processed
@@ -3793,7 +3790,7 @@ static int blk_end_io(struct request *rq
 	add_disk_randomness(rq->rq_disk);
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	complete_request(rq, error);
+	end_that_request_last(rq, error);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return 0;
@@ -3841,7 +3838,7 @@ int __blk_end_request(struct request *rq
 
 	add_disk_randomness(rq->rq_disk);
 
-	complete_request(rq, error);
+	end_that_request_last(rq, error);
 
 	return 0;
 }
