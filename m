From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] WARN_ON if blk_put_request leaks BIOs
Date: Thu, 19 Mar 2009 18:29:02 +0200
Message-ID: <49C272CE.1070408@panasas.com>
References: <49C21C5A.6030105@panasas.com> <20090319113343.GF27476@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:22801 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754664AbZCSQaR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 12:30:17 -0400
In-Reply-To: <20090319113343.GF27476@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>


Put a WARN_ON in __blk_put_request if it is about to
leak bio(s). This is a serious bug that can happen in error
handling code paths.

For this to work I have fixed a couple of places in block/ where
request->bio != NULL ownership was not honored. And a small cleanup
at sg_io() while at it.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c   |    3 +++
 block/blk-merge.c  |    2 ++
 block/scsi_ioctl.c |   21 ++++-----------------
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f9118c0..b3aabdd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1031,6 +1031,9 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 
 	elv_completed_request(q, req);
 
+	/* this is a bio leak */
+	WARN_ON(req->bio != NULL);
+
 	/*
 	 * Request may not have originated from ll_rw_blk. if not,
 	 * it didn't come out of our reserved rq pools
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5a244f0..e39cb24 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -403,6 +403,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (blk_rq_cpu_valid(next))
 		req->cpu = next->cpu;
 
+	/* owner-ship of bio passed from next to req */
+	next->bio = NULL;
 	__blk_put_request(q, next);
 	return 1;
 }
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index ee9c67d..626ee27 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -214,21 +214,10 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 	return 0;
 }
 
-/*
- * unmap a request that was previously mapped to this sg_io_hdr. handles
- * both sg and non-sg sg_io_hdr.
- */
-static int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
-{
-	blk_rq_unmap_user(rq->bio);
-	blk_put_request(rq);
-	return 0;
-}
-
 static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 				 struct bio *bio)
 {
-	int r, ret = 0;
+	int ret = 0;
 
 	/*
 	 * fill in all the output members
@@ -253,12 +242,10 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 			ret = -EFAULT;
 	}
 
-	rq->bio = bio;
-	r = blk_unmap_sghdr_rq(rq, hdr);
-	if (ret)
-		r = ret;
+	blk_rq_unmap_user(bio);
+	blk_put_request(rq);
 
-	return r;
+	return ret;
 }
 
 static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
-- 
1.6.2.1

