From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 5/5] Un-export blk_rq_append_bio
Date: Sun, 17 May 2009 19:00:01 +0300
Message-ID: <4A103481.7000200@panasas.com>
References: <4A1032B0.5000003@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:15644 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751499AbZEQQAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2009 12:00:05 -0400
In-Reply-To: <4A1032B0.5000003@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


OSD was the last in-tree user of blk_rq_append_bio(). Now
that it is fixed blk_rq_append_bio is un-exported and
is only used internally by block layer.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-map.c        |    1 -
 block/blk.h            |    2 ++
 include/linux/blkdev.h |    6 ------
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index caa05a6..ef2492a 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -24,7 +24,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(blk_rq_append_bio);
 
 static int __blk_rq_unmap_user(struct bio *bio)
 {
diff --git a/block/blk.h b/block/blk.h
index 9e0042c..c863ec2 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -13,6 +13,8 @@ extern struct kobj_type blk_queue_ktype;
 void init_request_from_bio(struct request *req, struct bio *bio);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
+int blk_rq_append_bio(struct request_queue *q, struct request *rq,
+		      struct bio *bio);
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 88a83e1..564445b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -758,12 +758,6 @@ extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
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
1.6.2.1


