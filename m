From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 2/9] blk: In elv_abort_queue skip requests with REQ_DONTPREP set
Date: Mon,  3 May 2010 20:37:01 -0700
Message-ID: <1272944228-30511-3-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51333 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab0EDDhk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2010 23:37:40 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e2.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443PuPV002842
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:25:56 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o443bdSb140568
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:39 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o443bd48018862
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:39 -0400
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

Having REQ_DONTPREP set on a request can indicated that resources have been
allocated for this request. In elv_abort_queue skip requests with
REQ_DONTPREP set to avoid leaking resources.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axobe <jens.axboe@oracle.com>
---
 block/elevator.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index df75676..ac98008 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -807,10 +807,18 @@ int elv_may_queue(struct request_queue *q, int rw)
 
 void elv_abort_queue(struct request_queue *q)
 {
-	struct request *rq;
+	struct request *rq, *tmp;
+	LIST_HEAD(list);
 
-	while (!list_empty(&q->queue_head)) {
-		rq = list_entry_rq(q->queue_head.next);
+	/*
+	 * Splice entries to local list, in case the list contains some
+	 * requests marked REQ_DONTPREP.
+	 */
+	list_splice_init(&q->queue_head, &list);
+
+	list_for_each_entry_safe(rq, tmp, &list, queuelist) {
+		if (rq->cmd_flags & REQ_DONTPREP)
+			continue;
 		rq->cmd_flags |= REQ_QUIET;
 		trace_block_rq_abort(q, rq);
 		/*
@@ -820,6 +828,13 @@ void elv_abort_queue(struct request_queue *q)
 		blk_start_request(rq);
 		__blk_end_request_all(rq, -EIO);
 	}
+
+	/*
+	 * In case requests with REQ_DONTPREP where skipped splice the
+	 * local list back.
+	 */
+	list_splice(&list, &q->queue_head);
+
 }
 EXPORT_SYMBOL(elv_abort_queue);
 
-- 
1.6.6.1

