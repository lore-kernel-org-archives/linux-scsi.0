From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 1/9] blk: Do not abort requests if queue is stopped
Date: Mon,  3 May 2010 20:37:00 -0700
Message-ID: <1272944228-30511-2-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50326 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0EDDhj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2010 23:37:39 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e3.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443P4iT005640
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:25:04 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o443bbqp1302780
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:38 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o443bbn3018824
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:37 -0400
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

If the queue is stopped it could be an indication that other recovery is
happening in this case skip the blk_abort_request.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axobe <jens.axboe@oracle.com>
---
 block/blk-timeout.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 1ba7e0a..89fbe0a 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -224,7 +224,8 @@ void blk_abort_queue(struct request_queue *q)
 	list_splice_init(&q->timeout_list, &list);
 
 	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
-		blk_abort_request(rq);
+		if (!blk_queue_stopped(q))
+			blk_abort_request(rq);
 
 	/*
 	 * Occasionally, blk_abort_request() will return without
-- 
1.6.6.1

