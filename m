From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH 2/9] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Tue, 20 Sep 2016 06:27:27 +0900
Message-ID: <1474320454-5264-3-git-send-email-damien.lemoal@hgst.com>
References: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

The queue limits already have a 'chunk_sectors' setting, so
we should be presenting it via sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 block/blk-sysfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 31ecff9..15e5baf 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -130,6 +130,11 @@ static ssize_t queue_physical_block_size_show(struct request_queue *q, char *pag
 	return queue_var_show(queue_physical_block_size(q), page);
 }
 
+static ssize_t queue_chunk_sectors_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.chunk_sectors, page);
+}
+
 static ssize_t queue_io_min_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(queue_io_min(q), page);
@@ -455,6 +460,11 @@ static struct queue_sysfs_entry queue_physical_block_size_entry = {
 	.show = queue_physical_block_size_show,
 };
 
+static struct queue_sysfs_entry queue_chunk_sectors_entry = {
+	.attr = {.name = "chunk_sectors", .mode = S_IRUGO },
+	.show = queue_chunk_sectors_show,
+};
+
 static struct queue_sysfs_entry queue_io_min_entry = {
 	.attr = {.name = "minimum_io_size", .mode = S_IRUGO },
 	.show = queue_io_min_show,
@@ -555,6 +565,7 @@ static struct attribute *default_attrs[] = {
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
 	&queue_physical_block_size_entry.attr,
+	&queue_chunk_sectors_entry.attr,
 	&queue_io_min_entry.attr,
 	&queue_io_opt_entry.attr,
 	&queue_discard_granularity_entry.attr,
-- 
2.7.4

