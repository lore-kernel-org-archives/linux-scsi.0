From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 7/9] blk: Mark requests aborted
Date: Mon,  3 May 2010 20:37:06 -0700
Message-ID: <1272944228-30511-8-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47347 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819Ab0EDDht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2010 23:37:49 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e1.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443WXEm004833
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:32:33 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o443bmMo158586
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:48 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o443blNv019103
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:48 -0400
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

Mark requests aborted using blk_mark_rq_aborted to assist lower levels in
identifying aborted requests.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axobe <jens.axboe@oracle.com>
---
 block/blk-timeout.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index ad45b44..d8610c1 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -229,9 +229,17 @@ void blk_abort_queue(struct request_queue *q)
 	 */
 	list_splice_init(&q->timeout_list, &list);
 
-	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
+	list_for_each_entry_safe(rq, tmp, &list, timeout_list) {
+                /*
+                 * Mark all requests even if we are unable to abort. The
+                 * aborted flag can used by lower levels to indicate that
+                 * the request should finished as soon as possible.
+                 */
+		blk_mark_rq_aborted(rq);
+
 		if (!blk_queue_stopped(q))
 			blk_abort_request(rq);
+	}
 
 	/*
 	 * Occasionally, blk_abort_request() will return without
-- 
1.6.6.1

