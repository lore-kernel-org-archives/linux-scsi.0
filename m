From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] block: fix oops with block tag queueing
Date: Wed, 20 May 2009 17:06:26 +0000
Message-ID: <1242839186.2881.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33112 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755939AbZETRGX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 13:06:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, Jens Axboe <Jens.Axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

commit e8939a50466fd963eb1ba9118c34b9ffb7ff6aa6
Author: Tejun Heo <tj@kernel.org>
Date:   Fri May 8 11:54:16 2009 +0900

    block: implement and enforce request peek/start/fetch

Added a BUG_ON(blk_queued_rq(req)) to the top of blk_finish_req().
Unfortunately, this checks whether req->queuelist is empty.  This list
is doing double duty both as the queue list and the tag list, so tagged
requests come in here with this not empty and boom (the tag list is
emptied by blk_queue_end_tag() lower down).

Fix this by moving the BUG_ON to below the end tag we also seem
vulnerable to this in blk_requeue_request() as well.  I think all uses
of blk_queued_rq() need auditing because the check is clearly wrong in
the tagged case.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---
You might like to combine this with the above commit.  Otherwise we'll
have a bisect panic with adaptec and other drivers in the interval
between the two commits.

diff --git a/block/blk-core.c b/block/blk-core.c
index 05c2520..3ea7242 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -956,8 +956,6 @@ EXPORT_SYMBOL(blk_make_request);
  */
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
-	BUG_ON(blk_queued_rq(rq));
-
 	blk_delete_timer(rq);
 	blk_clear_rq_complete(rq);
 	trace_block_rq_requeue(q, rq);
@@ -965,6 +963,8 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
 
+	BUG_ON(blk_queued_rq(rq));
+
 	elv_requeue_request(q, rq);
 }
 EXPORT_SYMBOL(blk_requeue_request);
@@ -2042,11 +2042,11 @@ static bool blk_update_bidi_request(struct request *rq, int error,
  */
 static void blk_finish_request(struct request *req, int error)
 {
-	BUG_ON(blk_queued_rq(req));
-
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(req->q, req);
 
+	BUG_ON(blk_queued_rq(req));
+
 	if (unlikely(laptop_mode) && blk_fs_request(req))
 		laptop_io_completion();
 


