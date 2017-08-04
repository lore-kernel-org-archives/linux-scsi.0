From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/2] block: Zoned block device single-threaded submission
Date: Fri,  4 Aug 2017 16:52:36 +0900
Message-ID: <20170804075237.2089-2-damien.lemoal@wdc.com>
References: <20170804075237.2089-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19626 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbdHDHym (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 03:54:42 -0400
In-Reply-To: <20170804075237.2089-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>

From: Hannes Reinecke <hare@suse.de>

The scsi_request_fn() dispatch function internally unlocks the request
queue before submitting a request to the underlying LLD. This can
potentially lead to write request reordering if the context executing
scsi_request_fn() is preempted before the request is submitted to the
LLD and another context start the same function execution.

This is not a problem for regular disks but leads to write I/O errors
on host managed zoned block devices and reduce the effectivness of
sequential write optimizations for host aware disks.
(Note: the zone write lock in place in the scsi command init code will
prevent multiple writes from being issued simultaneously to the same
zone to avoid HBA level reordering issues, but this locking mechanism
is ineffective to prevent reordering at the dispatch level)

Prevent this from happening by limiting the number of context that can
simultaneously execute the queue request_fn() function to a single
thread.

A similar patch was originally proposed by Hannes Reinecke in a first
set of patches implementing ZBC support but ultimately not included in
the final support implementation. See commit 92f5e2a295
"block: add flag for single-threaded submission" in the tree
https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git/log/?h=zac.v3

Authorship thus goes to Hannes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index dbecbf4a64e0..cf590cbddcfd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -371,7 +371,14 @@ inline void __blk_run_queue_uncond(struct request_queue *q)
 	 * running such a request function concurrently. Keep track of the
 	 * number of active request_fn invocations such that blk_drain_queue()
 	 * can wait until all these request_fn calls have finished.
+	 *
+	 * For zoned block devices, do not allow multiple threads to
+	 * dequeue requests as this can lead to write request reordering
+	 * during the time the queue is unlocked.
 	 */
+	if (blk_queue_is_zoned(q) && q->request_fn_active)
+		return;
+
 	q->request_fn_active++;
 	q->request_fn(q);
 	q->request_fn_active--;
-- 
2.13.3
