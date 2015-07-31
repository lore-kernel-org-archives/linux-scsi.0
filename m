From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/8] block: Introduce BLKPREP_DONE
Date: Fri, 31 Jul 2015 15:36:19 +0200
Message-ID: <1438349780-116429-8-git-send-email-hare@suse.de>
References: <1438349780-116429-1-git-send-email-hare@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438349780-116429-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Add a new blkprep return code BLKPREP_DONE to signal completion
without I/O error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c        | 8 ++++++++
 drivers/scsi/scsi_lib.c | 3 ++-
 include/linux/blkdev.h  | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 82d8ce9..ecdfe1a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2359,6 +2359,14 @@ struct request *blk_peek_request(struct request_queue *q)
 			 */
 			blk_start_request(rq);
 			__blk_end_request_all(rq, -EIO);
+		} else if (ret == BLKPREP_DONE) {
+			rq->cmd_flags |= REQ_QUIET;
+			/*
+			 * Mark this request as started so we don't trigger
+			 * any debug logic in the end I/O path.
+			 */
+			blk_start_request(rq);
+			__blk_end_request_all(rq, 0);
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
 			break;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b1a2631..830a70b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1342,8 +1342,9 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 	struct scsi_device *sdev = q->queuedata;
 
 	switch (ret) {
+	case BLKPREP_DONE:
 	case BLKPREP_KILL:
-		req->errors = DID_NO_CONNECT << 16;
+		req->errors = (ret == BLKPREP_KILL) ? DID_NO_CONNECT << 16 : 0;
 		/* release the command and kill it */
 		if (req->special) {
 			struct scsi_cmnd *cmd = req->special;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 746ea82..86d787d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -728,6 +728,7 @@ static inline bool blk_write_same_mergeable(struct bio *a, struct bio *b)
 #define BLKPREP_OK		0	/* serve it */
 #define BLKPREP_KILL		1	/* fatal error, kill */
 #define BLKPREP_DEFER		2	/* leave on queue */
+#define BLKPREP_DONE		3	/* complete w/o error */
 
 extern unsigned long blk_max_low_pfn, blk_max_pfn;
 
-- 
1.8.5.2
