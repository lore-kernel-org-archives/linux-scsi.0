From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/8] block: Add 'zoned' sysfs queue attribute
Date: Fri, 31 Jul 2015 15:36:18 +0200
Message-ID: <1438349780-116429-7-git-send-email-hare@suse.de>
References: <1438349780-116429-1-git-send-email-hare@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438349780-116429-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Add a sysfs queue attribute 'zoned' to display the zone layout
for zoned devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-sysfs.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e419f1f..5e2ba53 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -211,6 +211,43 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static ssize_t queue_zoned_show(struct request_queue *q, char *page)
+{
+	struct rb_node *node;
+	struct blk_zone *zone;
+	ssize_t offset = 0, end = 0;
+	int size = 0, num = 0;
+	enum blk_zone_type type = BLK_ZONE_TYPE_UNKNOWN;
+
+	for (node = rb_first(&q->zones); node; node = rb_next(node)) {
+		zone = rb_entry(node, struct blk_zone, node);
+		if (zone->type != type ||
+		    zone->len != size ||
+		    end != zone->start) {
+			if (size != 0)
+				offset += sprintf(page + offset, "%u\n", num);
+			/* We can only store one page ... */
+			if (offset + 42 > PAGE_SIZE) {
+				offset += sprintf(page + offset, "...\n");
+				return offset;
+			}
+			size = zone->len;
+			type = zone->type;
+			offset += sprintf(page + offset, "%llu %u %d ",
+					  zone->start, size, type);
+			num = 0;
+			end = zone->start + size;
+		} else
+			end += zone->len;
+		num++;
+	}
+	if (num > 0)
+		offset += sprintf(page + offset, "%u\n", num);
+	return offset > 0 ? offset : -EINVAL;
+}
+#endif
+
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
 static ssize_t								\
 queue_show_##name(struct request_queue *q, char *page)			\
@@ -401,6 +438,13 @@ static struct queue_sysfs_entry queue_write_same_max_entry = {
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
@@ -451,6 +495,9 @@ static struct attribute *default_attrs[] = {
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
1.8.5.2
