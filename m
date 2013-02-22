From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/2] block: Avoid invoking blk_run_queue() recursively
Date: Fri, 22 Feb 2013 11:46:14 +0100
Message-ID: <51274C76.8080007@acm.org>
References: <51274C2F.6070500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:60515 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab3BVKqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 05:46:15 -0500
In-Reply-To: <51274C2F.6070500@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>

Some block drivers, e.g. dm and SCSI, need to trigger a queue
run from inside functions that may be invoked by their request_fn()
implementation. Make sure that invoking blk_run_queue() instead
of blk_run_queue_async() from such functions does not trigger
recursion. Making blk_run_queue() skip queue processing when
invoked recursively is safe because the only two affected
request_fn() implementations (dm and SCSI) guarantee that the
request queue will be reexamined sooner or later before returning
from their request_fn() implementation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: <stable@vger.kernel.org>
---
 block/blk-core.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c973249..cf26e3a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -304,19 +304,24 @@ EXPORT_SYMBOL(blk_sync_queue);
  *    This variant runs the queue whether or not the queue has been
  *    stopped. Must be called with the queue lock held and interrupts
  *    disabled. See also @blk_run_queue.
+ *
+ * Note:
+ *    Request handling functions are allowed to invoke __blk_run_queue() or
+ *    blk_run_queue() directly or indirectly. This will not result in a
+ *    recursive call of the request handler. However, such request handling
+ *    functions must, before they return, either reexamine the request queue
+ *    or invoke blk_delay_queue() to avoid that queue processing stops.
+ *
+ *    Some request handler implementations, e.g. scsi_request_fn() and
+ *    dm_request_fn(), unlock the queue lock internally. Returning immediately
+ *    if q->request_fn_active > 0 avoids that for the same queue multiple
+ *    threads execute the request handling function concurrently.
  */
 inline void __blk_run_queue_uncond(struct request_queue *q)
 {
-	if (unlikely(blk_queue_dead(q)))
+	if (unlikely(blk_queue_dead(q) || q->request_fn_active))
 		return;
 
-	/*
-	 * Some request_fn implementations, e.g. scsi_request_fn(), unlock
-	 * the queue lock internally. As a result multiple threads may be
-	 * running such a request function concurrently. Keep track of the
-	 * number of active request_fn invocations such that blk_drain_queue()
-	 * can wait until all these request_fn calls have finished.
-	 */
 	q->request_fn_active++;
 	q->request_fn(q);
 	q->request_fn_active--;
-- 
1.7.10.4

