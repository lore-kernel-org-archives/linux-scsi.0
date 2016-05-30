From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] block: don't check request size in blk_cloned_rq_check_limits()
Date: Mon, 30 May 2016 09:24:53 +0200
Message-ID: <1464593093-93527-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbcE3HY6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2016 03:24:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When checking a cloned request there is no need to check
the overall request size; this won't have changed even
when resubmitting to another queue.
Without this patch ppc64le on ibmvfc fails to boot.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2475b1c7..e108bf0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2160,11 +2160,6 @@ EXPORT_SYMBOL(submit_bio);
 static int blk_cloned_rq_check_limits(struct request_queue *q,
 				      struct request *rq)
 {
-	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->cmd_flags)) {
-		printk(KERN_ERR "%s: over max size limit.\n", __func__);
-		return -EIO;
-	}
-
 	/*
 	 * queue's settings related to segment counting like q->bounce_pfn
 	 * may differ from that of other stacking queues.
-- 
1.8.5.6

