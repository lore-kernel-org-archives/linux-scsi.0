From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/14] blk-mq: add 'type' attribute to the sysfs hctx directory
Date: Mon, 29 Oct 2018 10:37:30 -0600
Message-ID: <20181029163738.10172-7-axboe@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-1-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

It can be useful for a user to verify what type a given hardware
queue is, expose this information in sysfs.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq-sysfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index aafb44224c89..2d737f9e7ba7 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -161,6 +161,11 @@ static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char *page)
 	return ret;
 }
 
+static ssize_t blk_mq_hw_sysfs_type_show(struct blk_mq_hw_ctx *hctx, char *page)
+{
+	return sprintf(page, "%u\n", hctx->type);
+}
+
 static struct attribute *default_ctx_attrs[] = {
 	NULL,
 };
@@ -177,11 +182,16 @@ static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_cpus = {
 	.attr = {.name = "cpu_list", .mode = 0444 },
 	.show = blk_mq_hw_sysfs_cpus_show,
 };
+static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_type = {
+	.attr = {.name = "type", .mode = 0444 },
+	.show = blk_mq_hw_sysfs_type_show,
+};
 
 static struct attribute *default_hw_ctx_attrs[] = {
 	&blk_mq_hw_sysfs_nr_tags.attr,
 	&blk_mq_hw_sysfs_nr_reserved_tags.attr,
 	&blk_mq_hw_sysfs_cpus.attr,
+	&blk_mq_hw_sysfs_type.attr,
 	NULL,
 };
 
-- 
2.17.1
