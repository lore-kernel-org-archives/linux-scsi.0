From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/18] xsysace: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:05 +0900
Message-ID: <1241751256-17435-8-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36195 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZEHC4N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2009 22:56:13 -0400
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>

xsysace already tracks in-flight request using ace->req.  Converting
to dequeueing model is mostly a matter of adding dequeueing call after
request fetching.  The only tricky part is handling CF removal which
should complete both in flight and on queue requests.  Convert to
dequeueing model.

While at it, remove explicit blk_rq_cur_bytes() and use
__blk_end_request_cur() instead.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/block/xsysace.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 97c99b4..edf137b 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -466,7 +466,8 @@ struct request *ace_get_next_request(struct request_queue * q)
 	while ((req = elv_next_request(q)) != NULL) {
 		if (blk_fs_request(req))
 			break;
-		__blk_end_request_cur(req, -EIO);
+		blkdev_dequeue_request(req);
+		__blk_end_request_all(req, -EIO);
 	}
 	return req;
 }
@@ -492,9 +493,15 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		set_capacity(ace->gd, 0);
 		dev_info(ace->dev, "No CF in slot\n");
 
-		/* Drop all pending requests */
-		while ((req = elv_next_request(ace->queue)) != NULL)
-			__blk_end_request_cur(req, -EIO);
+		/* Drop all in-flight and pending requests */
+		if (ace->req) {
+			__blk_end_request_all(ace->req, -EIO);
+			ace->req = NULL;
+		}
+		while ((req = elv_next_request(ace->queue)) != NULL) {
+			blkdev_dequeue_request(req);
+			__blk_end_request_all(req, -EIO);
+		}
 
 		/* Drop back to IDLE state and notify waiters */
 		ace->fsm_state = ACE_FSM_STATE_IDLE;
@@ -642,6 +649,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			ace->fsm_state = ACE_FSM_STATE_IDLE;
 			break;
 		}
+		blkdev_dequeue_request(req);
 
 		/* Okay, it's a data request, set it up for transfer */
 		dev_dbg(ace->dev,
@@ -718,8 +726,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		}
 
 		/* bio finished; is there another one? */
-		if (__blk_end_request(ace->req, 0,
-					blk_rq_cur_bytes(ace->req))) {
+		if (__blk_end_request_cur(ace->req, 0)) {
 			/* dev_dbg(ace->dev, "next block; h=%u c=%u\n",
 			 *      blk_rq_sectors(ace->req),
 			 *      blk_rq_cur_sectors(ace->req));
-- 
1.6.0.2

