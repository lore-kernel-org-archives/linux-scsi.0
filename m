From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] Revert "block: all blk-mq requests are tagged"
Date: Sun, 19 Oct 2014 17:13:57 +0200
Message-ID: <1413731638-28305-2-git-send-email-hch@lst.de>
References: <1413731638-28305-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413731638-28305-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This reverts commit fb3ccb5da71273e7f0d50b50bc879e50cedd60e7.

SCSI-2/SPI actually needs the tagged/untagged flag in the request to
work properly.  Revert this patch and add a follow on to set it in
the right place.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 include/linux/blkdev.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0207a78..51d0dc2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1136,8 +1136,7 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 /*
  * tag stuff
  */
-#define blk_rq_tagged(rq) \
-	((rq)->mq_ctx || ((rq)->cmd_flags & REQ_QUEUED))
+#define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
 extern int blk_queue_start_tag(struct request_queue *, struct request *);
 extern struct request *blk_queue_find_tag(struct request_queue *, int);
 extern void blk_queue_end_tag(struct request_queue *, struct request *);
-- 
1.9.1
