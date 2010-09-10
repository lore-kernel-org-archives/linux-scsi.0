From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] Consolidate min_not_zero
Date: Fri, 10 Sep 2010 12:13:52 -0400
Message-ID: <yq1fwxhr2yn.fsf@sermon.lab.mkp.net>
References: <1284095925-12841-1-git-send-email-martin.petersen@oracle.com>
	<1284095925-12841-2-git-send-email-martin.petersen@oracle.com>
	<201009101014.00667.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:26866 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab0IJQP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 12:15:29 -0400
In-Reply-To: <201009101014.00667.eike-kernel@sf-tec.de> (Rolf Eike Beer's
	message of "Fri, 10 Sep 2010 10:13:51 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, christof.schmitt@de.ibm.com, linux-scsi@vger.kernel.org


We have several users of min_not_zero, each of them using their own
definition.  Move the define to kernel.h.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

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
index 8317ec4..3901c08 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -637,6 +637,16 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	_max1 > _max2 ? _max1 : _max2; })
 
 /**
+ * min_not_zero - return the minimum that is _not_ zero, unless both are zero
+ * @x: value1
+ * @y: value2
+ */
+#define min_not_zero(x, y) ({			\
+	typeof(x) __x = (x);			\
+	typeof(y) __y = (y);			\
+	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
+
+/**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
  * @min: minimum allowable value
