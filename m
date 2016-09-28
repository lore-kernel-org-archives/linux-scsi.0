From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH v3 2/7] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Wed, 28 Sep 2016 10:22:32 +0900
Message-ID: <1475025757-6340-3-git-send-email-damien.lemoal@hgst.com>
References: <1475025757-6340-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31916 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933226AbcI1BW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 21:22:57 -0400
In-Reply-To: <1475025757-6340-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Damien Le Moal <damien.lemoal@hgst.com>

From: Hannes Reinecke <hare@suse.de>

The queue limits already have a 'chunk_sectors' setting, so
we should be presenting it via sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 block/blk-sysfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index ff9cd9c..488c2e2 100644
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

