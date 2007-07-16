From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 17/33] ll_rw_blk: temporarily enable max_segments tweaking
Date: Mon, 16 Jul 2007 11:47:31 +0200
Message-ID: <11845792682141-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9331 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758887AbXGPJsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:36 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>

Expose this setting for now, so that users can play with enabling
large commands without defaulting it to on globally. This is a debug
patch, it will be dropped for the final versions.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/ll_rw_blk.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index ab71087..3b85461 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3980,7 +3980,23 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_max_segments_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->max_phys_segments, page);
+}
+
+static ssize_t queue_max_segments_store(struct request_queue *q,
+					const char *page, size_t count)
+{
+	unsigned long segments;
+	ssize_t ret = queue_var_store(&segments, page, count);
 
+	spin_lock_irq(q->queue_lock);
+	q->max_phys_segments = segments;
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -4004,6 +4020,12 @@ static struct queue_sysfs_entry queue_max_hw_sectors_entry = {
 	.show = queue_max_hw_sectors_show,
 };
 
+static struct queue_sysfs_entry queue_max_segments_entry = {
+	.attr = {.name = "max_segments", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_max_segments_show,
+	.store = queue_max_segments_store,
+};
+
 static struct queue_sysfs_entry queue_iosched_entry = {
 	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
 	.show = elv_iosched_show,
@@ -4015,6 +4037,7 @@ static struct attribute *default_attrs[] = {
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
+	&queue_max_segments_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };
-- 
1.5.3.rc0.90.gbaa79

