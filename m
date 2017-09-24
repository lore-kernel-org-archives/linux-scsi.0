From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 11/16] block: mq-deadline: Introduce zones_wlock attribute
Date: Sun, 24 Sep 2017 16:02:42 +0900
Message-ID: <20170924070247.25560-12-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22595 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbdIXHDF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 03:03:05 -0400
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Zone write locking is mandatory for host managed zoned block devices so
that sequential write order can be maintained. This is however optional
for host aware devices as the device firmware can handle random writes.

The default initialization always enable zones write locking for any
zoned block device. Introduce the zones_wlock sysfs attribute to allow
users to change this default setting for host aware disks. Changes to
zones write locking state are not allowed for host managed disks (zones
write locking is always enabled) and for regular disks (zones write
locking is always disabled).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/mq-deadline.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 53b1d16179ad..fb88fee0fb54 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -339,8 +339,7 @@ static void dd_exit_queue(struct elevator_queue *e)
 static int deadline_zoned_init_queue(struct request_queue *q,
 				     struct deadline_data *dd)
 {
-	if (!blk_queue_is_zoned(q) ||
-	    !blk_queue_nr_zones(q)) {
+	if (!blk_queue_is_zoned(q) || !blk_queue_nr_zones(q)) {
 		/*
 		 * Regular drive, or non-conforming zoned block device.
 		 * Do not use zone write locking.
@@ -559,6 +558,45 @@ STORE_FUNCTION(deadline_front_merges_store, &dd->front_merges, 0, 1, 0);
 STORE_FUNCTION(deadline_fifo_batch_store, &dd->fifo_batch, 0, INT_MAX, 0);
 #undef STORE_FUNCTION
 
+static ssize_t deadline_zones_wlock_show(struct elevator_queue *e, char *page)
+{
+	struct deadline_data *dd = e->elevator_data;
+
+	return deadline_var_show(dd->zones_wlock ? 1 : 0, page);
+}
+
+static ssize_t deadline_zones_wlock_store(struct elevator_queue *e,
+					  const char *page, size_t count)
+{
+	struct deadline_data *dd = e->elevator_data;
+	int ret, enable_zones_wlock;
+
+	deadline_var_store(&enable_zones_wlock, page);
+	if (enable_zones_wlock != 0 && enable_zones_wlock != 1)
+		return -EINVAL;
+
+	if ((enable_zones_wlock && dd->zones_wlock) ||
+	    (!enable_zones_wlock && !dd->zones_wlock))
+		return count;
+
+	/* Changes are allowed only for host-aware disks */
+	if (blk_queue_zoned_model(dd->q) != BLK_ZONED_HA)
+		return -EPERM;
+
+	blk_mq_freeze_queue(dd->q);
+
+	if (enable_zones_wlock) {
+		ret = deadline_enable_zones_wlock(dd, GFP_NOIO);
+	} else {
+		deadline_disable_zones_wlock(dd);
+		ret = 0;
+	}
+
+	blk_mq_unfreeze_queue(dd->q);
+
+	return ret ? ret : count;
+}
+
 #define DD_ATTR(name) \
 	__ATTR(name, S_IRUGO|S_IWUSR, deadline_##name##_show, \
 				      deadline_##name##_store)
@@ -569,6 +607,7 @@ static struct elv_fs_entry deadline_attrs[] = {
 	DD_ATTR(writes_starved),
 	DD_ATTR(front_merges),
 	DD_ATTR(fifo_batch),
+	DD_ATTR(zones_wlock),
 	__ATTR_NULL
 };
 
-- 
2.13.5
