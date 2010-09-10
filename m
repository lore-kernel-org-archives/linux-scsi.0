From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] Consolidate min_not_zero
Date: Fri, 10 Sep 2010 01:32:09 -0400
Message-ID: <1284096730-13147-2-git-send-email-martin.petersen@oracle.com>
References: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:41421 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab0IJFdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 01:33:00 -0400
In-Reply-To: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, christof.schmitt@de.ibm.com
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

We have several users of min_not_zero, each of them using their own
definition.  Move the define to kernel.h.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-settings.c               |    5 -----
 drivers/block/drbd/drbd_receiver.c |    1 -
 drivers/md/dm-snap.c               |    2 --
 drivers/md/dm-table.c              |    5 -----
 include/linux/kernel.h             |    6 ++++++
 5 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a234f4b..8d592b5 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -455,11 +455,6 @@ void blk_queue_io_opt(struct request_queue *q, unsigned int opt)
 }
 EXPORT_SYMBOL(blk_queue_io_opt);
 
-/*
- * Returns the minimum that is _not_ zero, unless both are zero.
- */
-#define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
-
 /**
  * blk_queue_stack_limits - inherit underlying queue limits for stacked drivers
  * @t:	the stacking driver (top)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 20abef5..704a617 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2972,7 +2972,6 @@ static int receive_sizes(struct drbd_conf *mdev, struct p_header *h)
 	 * we still need to figure out whether we accept that. */
 	mdev->p_size = p_size;
 
-#define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
 	if (get_ldev(mdev)) {
 		warn_if_differ_considerably(mdev, "lower level device sizes",
 			   p_size, drbd_get_max_capacity(mdev->ldev));
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5485377..0e172e6 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -700,8 +700,6 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 	return 0;
 }
 
-#define min_not_zero(l, r) (((l) == 0) ? (r) : (((r) == 0) ? (l) : min(l, r)))
-
 /*
  * Return a minimum chunk size of all snapshots that have the specified origin.
  * Return zero if the origin has no snapshots.
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..7de9081 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -483,11 +483,6 @@ static int __table_get_device(struct dm_table *t, struct dm_target *ti,
 	return 0;
 }
 
-/*
- * Returns the minimum that is _not_ zero, unless both are zero.
- */
-#define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
-
 int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 			 sector_t start, sector_t len, void *data)
 {
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..c2b3879 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -636,6 +636,12 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+/*
+ * Returns the minimum that is _not_ zero, unless both are zero.
+ */
+#define min_not_zero(__x, __y) ({		\
+	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
-- 
1.7.2.2

