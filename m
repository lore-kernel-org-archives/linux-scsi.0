From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Sun, 14 Dec 2008 01:23:46 +0900
Message-ID: <1229185427-4130-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229185427-4130-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:40844 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYLMQZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 11:25:09 -0500
In-Reply-To: <1229185427-4130-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Now we can unexport blk_rq_append_bio and remove 'SCSI-ml does
something wrong' comment in blkdev.h. :)

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-map.c        |    5 ++---
 include/linux/blkdev.h |    6 ------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index e1bb727..a70f7d8 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -9,8 +9,8 @@
 
 #include "blk.h"
 
-int blk_rq_append_bio(struct request_queue *q, struct request *rq,
-		      struct bio *bio)
+static int blk_rq_append_bio(struct request_queue *q, struct request *rq,
+			     struct bio *bio)
 {
 	if (!rq->bio)
 		blk_rq_bio_prep(q, rq, bio);
@@ -24,7 +24,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(blk_rq_append_bio);
 
 static int __blk_rq_unmap_user(struct bio *bio)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8922c25..bbd481f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -725,12 +725,6 @@ extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
 /*
- * Temporary export, until SCSI gets fixed up.
- */
-extern int blk_rq_append_bio(struct request_queue *q, struct request *rq,
-			     struct bio *bio);
-
-/*
  * A queue has just exitted congestion.  Note this in the global counter of
  * congested queues, and wake up anyone who was waiting for requests to be
  * put back.
-- 
1.5.5.GIT

