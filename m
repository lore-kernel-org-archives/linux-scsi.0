From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH 6/9] block: Add 'BLKPREP_DONE' return value
Date: Tue, 20 Sep 2016 06:27:31 +0900
Message-ID: <1474320454-5264-7-git-send-email-damien.lemoal@hgst.com>
References: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34625 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932654AbcISV2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 17:28:44 -0400
In-Reply-To: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com, Damien Le Moal <damien.lemoal@hgst.com>

From: Hannes Reinecke <hare@suse.de>

Add a new blkprep return code BLKPREP_DONE to signal completion
without I/O error.

Signed-off-by: Hannes Reinecke <hare@suse.de>

Changelog (Damien):
Rewrite adding blk_prep_end_request as suggested by Christoph Hellwig

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 block/blk-core.c        | 42 ++++++++++++++++++++++++++----------------
 drivers/scsi/scsi_lib.c |  1 +
 include/linux/blkdev.h  |  1 +
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2c5d069d..8dbbb1a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2341,6 +2341,17 @@ void blk_account_io_start(struct request *rq, bool new_io)
 	part_stat_unlock();
 }
 
+static void blk_prep_end_request(struct request *rq, int error)
+{
+	/*
+	 * Mark this request as started so we don't trigger
+	 * any debug logic in the end I/O path.
+	 */
+        rq->cmd_flags |= REQ_QUIET;
+        blk_start_request(rq);
+        __blk_end_request_all(rq, error);
+}
+
 /**
  * blk_peek_request - peek at the top of a request queue
  * @q: request queue to peek at
@@ -2408,9 +2419,10 @@ struct request *blk_peek_request(struct request_queue *q)
 			break;
 
 		ret = q->prep_rq_fn(q, rq);
-		if (ret == BLKPREP_OK) {
-			break;
-		} else if (ret == BLKPREP_DEFER) {
+		switch(ret) {
+		case BLKPREP_OK:
+			goto out;
+		case BLKPREP_DEFER:
 			/*
 			 * the request may have been (partially) prepped.
 			 * we need to keep this request in the front to
@@ -2425,25 +2437,23 @@ struct request *blk_peek_request(struct request_queue *q)
 				 */
 				--rq->nr_phys_segments;
 			}
-
 			rq = NULL;
+			goto out;
+		case BLKPREP_KILL:
+			blk_prep_end_request(rq, -EIO);
 			break;
-		} else if (ret == BLKPREP_KILL || ret == BLKPREP_INVALID) {
-			int err = (ret == BLKPREP_INVALID) ? -EREMOTEIO : -EIO;
-
-			rq->cmd_flags |= REQ_QUIET;
-			/*
-			 * Mark this request as started so we don't trigger
-			 * any debug logic in the end I/O path.
-			 */
-			blk_start_request(rq);
-			__blk_end_request_all(rq, err);
-		} else {
+		case BLKPREP_INVALID:
+			blk_prep_end_request(rq, -EREMOTEIO);
+			break;
+		case BLKPREP_DONE:
+			blk_prep_end_request(rq, 0);
+			break;
+		default:
 			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
 			break;
 		}
 	}
-
+out:
 	return rq;
 }
 EXPORT_SYMBOL(blk_peek_request);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c71344a..f99504d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1260,6 +1260,7 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 	case BLKPREP_KILL:
 	case BLKPREP_INVALID:
 		req->errors = DID_NO_CONNECT << 16;
+	case BLKPREP_DONE:
 		/* release the command and kill it */
 		if (req->special) {
 			struct scsi_cmnd *cmd = req->special;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1165594..a85f95b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -819,6 +819,7 @@ enum {
 	BLKPREP_KILL,		/* fatal error, kill, return -EIO */
 	BLKPREP_DEFER,		/* leave on queue */
 	BLKPREP_INVALID,	/* invalid command, kill, return -EREMOTEIO */
+	BLKPREP_DONE,           /* complete w/o error */
 };
 
 extern unsigned long blk_max_low_pfn, blk_max_pfn;
-- 
2.7.4

