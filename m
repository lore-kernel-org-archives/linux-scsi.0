From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] block: export blk_finish_request
Date: Wed, 16 Apr 2014 09:44:59 +0200
Message-ID: <1397634299-7466-9-git-send-email-hch@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397634299-7466-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This allows to mirror the blk-mq code flow for more a more readable I/O
completion handler in SCSI.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       |    3 ++-
 include/linux/blkdev.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 90b6e63..c426970 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2497,7 +2497,7 @@ EXPORT_SYMBOL_GPL(blk_unprep_request);
 /*
  * queue lock must be held
  */
-static void blk_finish_request(struct request *req, int error)
+void blk_finish_request(struct request *req, int error)
 {
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(req->q, req);
@@ -2523,6 +2523,7 @@ static void blk_finish_request(struct request *req, int error)
 		__blk_put_request(req->q, req);
 	}
 }
+EXPORT_SYMBOL(blk_finish_request);
 
 /**
  * blk_end_bidi_request - Complete a bidi request
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7128808..20b26d4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -936,6 +936,7 @@ extern struct request *blk_fetch_request(struct request_queue *q);
  */
 extern bool blk_update_request(struct request *rq, int error,
 			       unsigned int nr_bytes);
+extern void blk_finish_request(struct request *rq, int error);
 extern bool blk_end_request(struct request *rq, int error,
 			    unsigned int nr_bytes);
 extern void blk_end_request_all(struct request *rq, int error);
-- 
1.7.10.4
