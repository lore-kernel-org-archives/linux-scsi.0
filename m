From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/9] block: Add 'zoned' sysfs queue attribute
Date: Mon,  4 Apr 2016 12:00:17 +0200
Message-ID: <1459764020-126038-7-git-send-email-hare@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbcDDKAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 06:00:44 -0400
In-Reply-To: <1459764020-126038-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

Add a sysfs queue attribute 'zoned' to display the zone layout
for zoned devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-sysfs.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index ff97091..748bb27 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -244,6 +244,43 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static ssize_t queue_zoned_show(struct request_queue *q, char *page)
+{
+	struct rb_node *node;
+	struct blk_zone *zone;
+	ssize_t offset = 0, end = 0;
+	size_t size = 0, num = 0;
+	enum blk_zone_type type = BLK_ZONE_TYPE_UNKNOWN;
+
+	for (node = rb_first(&q->zones); node; node = rb_next(node)) {
+		zone = rb_entry(node, struct blk_zone, node);
+		if (zone->type != type ||
+		    zone->len != size ||
+		    end != zone->start) {
+			if (size != 0)
+				offset += sprintf(page + offset, "%zu\n", num);
+			/* We can only store one page ... */
+			if (offset + 42 > PAGE_SIZE) {
+				offset += sprintf(page + offset, "...\n");
+				return offset;
+			}
+			size = zone->len;
+			type = zone->type;
+			offset += sprintf(page + offset, "%zu %zu %d ",
+					  zone->start, size, type);
+			num = 0;
+			end = zone->start + size;
+		} else
+			end += zone->len;
+		num++;
+	}
+	if (num > 0)
+		offset += sprintf(page + offset, "%zu\n", num);
+	return offset > 0 ? offset : -EINVAL;
+}
+#endif
+
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
 static ssize_t								\
 queue_show_##name(struct request_queue *q, char *page)			\
@@ -468,6 +505,13 @@ static struct queue_sysfs_entry queue_write_same_max_entry = {
 	.show = queue_write_same_max_show,
 };
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static struct queue_sysfs_entry queue_zoned_entry = {
+	.attr = {.name = "zoned", .mode = S_IRUGO },
+	.show = queue_zoned_show,
+};
+#endif
+
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_show_nonrot,
@@ -525,6 +569,9 @@ static struct attribute *default_attrs[] = {
 	&queue_discard_zeroes_data_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_nonrot_entry.attr,
+#ifdef CONFIG_BLK_DEV_ZONED
+	&queue_zoned_entry.attr,
+#endif
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
-- 
1.8.5.6

