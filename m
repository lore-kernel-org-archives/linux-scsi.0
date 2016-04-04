From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/9] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Mon,  4 Apr 2016 12:00:12 +0200
Message-ID: <1459764020-126038-2-git-send-email-hare@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbcDDKAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 06:00:44 -0400
In-Reply-To: <1459764020-126038-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

The queue limits already have a 'chunk_sectors' setting, so
we should be presenting it via sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-sysfs.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index dd93763..ff97091 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -130,6 +130,26 @@ static ssize_t queue_physical_block_size_show(struct request_queue *q, char *pag
 	return queue_var_show(queue_physical_block_size(q), page);
 }
 
+static ssize_t queue_chunk_sectors_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.chunk_sectors, page);
+}
+
+static ssize_t
+queue_chunk_sectors_store(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long chunk_sectors;
+
+	ssize_t ret = queue_var_store(&chunk_sectors, page, count);
+	if (ret < 0)
+		return ret;
+	spin_lock_irq(q->queue_lock);
+	blk_queue_chunk_sectors(q, chunk_sectors);
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
+
 static ssize_t queue_io_min_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(queue_io_min(q), page);
@@ -406,6 +426,12 @@ static struct queue_sysfs_entry queue_physical_block_size_entry = {
 	.show = queue_physical_block_size_show,
 };
 
+static struct queue_sysfs_entry queue_chunk_sectors_entry = {
+	.attr = {.name = "chunk_sectors", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_chunk_sectors_show,
+	.store = queue_chunk_sectors_store,
+};
+
 static struct queue_sysfs_entry queue_io_min_entry = {
 	.attr = {.name = "minimum_io_size", .mode = S_IRUGO },
 	.show = queue_io_min_show,
@@ -490,6 +516,7 @@ static struct attribute *default_attrs[] = {
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
 	&queue_physical_block_size_entry.attr,
+	&queue_chunk_sectors_entry.attr,
 	&queue_io_min_entry.attr,
 	&queue_io_opt_entry.attr,
 	&queue_discard_granularity_entry.attr,
-- 
1.8.5.6

