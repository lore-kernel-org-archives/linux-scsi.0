From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] block queue dma alignment zero
Date: Thu, 1 Mar 2007 17:18:12 -0500
Message-ID: <20070301221812.GA20922@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:52378 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030447AbXCAWSN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Mar 2007 17:18:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

Make queue_dma_alignment return 0 if it was specifically set to
0.  Set it to the default 511 to keep the old behavior when it
was not explicitly set.  This permits devices with no particular
alignment restrictions to use direct IO from arbitrary addresses.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/ll_rw_blk.c      |    2 ++
 include/linux/blkdev.h |    7 +------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index fb67897..ef1d1a8 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1925,6 +1925,8 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
 	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
 
+	blk_queue_dma_alignment(q, 511);
+
 	/*
 	 * all done
 	 */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 36a6eac..f416c2a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -819,12 +819,7 @@ static inline int bdev_hardsect_size(struct block_device *bdev)
 
 static inline int queue_dma_alignment(request_queue_t *q)
 {
-	int retval = 511;
-
-	if (q && q->dma_alignment)
-		retval = q->dma_alignment;
-
-	return retval;
+	return q ? q->dma_alignment : 511;
 }
 
 /* assumes size > 256 */
-- 
1.5.0.2

