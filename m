From: Eric Seppanen <eric@purestorage.com>
Subject: [PATCH 1/2] block: Fix queue_flag update when rq_affinity goes from 2 to 1
Date: Mon, 15 Aug 2011 23:02:19 -0700
Message-ID: <1313474539-5540-1-git-send-email-eric@purestorage.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Roland Dreier <roland@purestorage.com>, Eric Seppanen <eric@purestorage.com>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, Dave Jiang <dave.jiang@intel.com>, Jens Axboe <jaxboe@fusionio.com>
List-Id: linux-scsi@vger.kernel.org

From: Eric Seppanen <eric@purestorage.com>

Commit 5757a6d76cdf added the QUEUE_FLAG_SAME_FORCE flag, but fails to
clear that flag when the current state is '2' (SAME_COMP + SAME_FORCE)
and the new state is '1' (SAME_COMP).

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Reviewed-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Eric Seppanen <eric@purestorage.com>

---
 block/blk-sysfs.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0ee17b5..e681805 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -258,11 +258,13 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 
 	ret = queue_var_store(&val, page, count);
 	spin_lock_irq(q->queue_lock);
-	if (val) {
+	if (val == 2) {
 		queue_flag_set(QUEUE_FLAG_SAME_COMP, q);
-		if (val == 2)
-			queue_flag_set(QUEUE_FLAG_SAME_FORCE, q);
-	} else {
+		queue_flag_set(QUEUE_FLAG_SAME_FORCE, q);
+	} else if (val == 1) {
+		queue_flag_set(QUEUE_FLAG_SAME_COMP, q);
+		queue_flag_clear(QUEUE_FLAG_SAME_FORCE, q);
+	} else if (val == 0) {
 		queue_flag_clear(QUEUE_FLAG_SAME_COMP, q);
 		queue_flag_clear(QUEUE_FLAG_SAME_FORCE, q);
 	}
-- 
1.7.4.1
