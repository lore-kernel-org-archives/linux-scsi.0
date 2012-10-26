From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/7] block: Avoid that blk_drain_queue() finishes early
Date: Fri, 26 Oct 2012 14:01:23 +0200
Message-ID: <508A7B93.4090409@acm.org>
References: <508A7B63.60608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:37594 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2JZMBY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 08:01:24 -0400
In-Reply-To: <508A7B63.60608@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

Code like "drain |= q->nr_rqs[i]" might result in blk_drain_queue()
to finish early if the expression at the RHS is a multiple of 256
since the drain variable is only eight bits wide. Avoid this by
changing the type of the drain variable from bool into unsigned.

Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Chanho Min <chanho.min@lge.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a33870b..ef2e045 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -362,7 +362,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 	int i;
 
 	while (true) {
-		bool drain = false;
+		unsigned drain = 0;
 
 		spin_lock_irq(q->queue_lock);
 
-- 
1.7.10.4

