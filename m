From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Tue, 19 Jul 2016 15:20:37 +0200
Message-ID: <1468934439-93579-5-git-send-email-hare@suse.de>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbcGSNUp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 09:20:45 -0400
In-Reply-To: <1468934439-93579-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>

Add a sysfs queue attribute 'zoned' to display the zone layout
for zoned devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-sysfs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 73200b8..7ffbc44 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -229,6 +229,42 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
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
+	offset += sprintf(page + offset, "%zu\n", num);
+	return offset;
+}
+#endif
+
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
 static ssize_t								\
 queue_show_##name(struct request_queue *q, char *page)			\
@@ -484,6 +520,13 @@ static struct queue_sysfs_entry queue_write_same_max_entry = {
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
@@ -547,6 +590,9 @@ static struct attribute *default_attrs[] = {
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

