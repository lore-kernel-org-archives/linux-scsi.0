From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] block: add flush timeout
Date: Mon, 19 Jul 2010 16:09:45 -0500
Message-ID: <1279573785-16432-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966407Ab0GSVG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jul 2010 17:06:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@kernel.dk
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We have been seeing the flush requests time out, so this patch
adds a new setting, /sys/block/$name/queue/flush_timeout, that
controls the time out for the flush request.

The patch was made and tested over the linux-2.6-block tree's
for-2.6.36 branch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/blk-barrier.c    |    3 +++
 block/blk-sysfs.c      |   30 ++++++++++++++++++++++++++++++
 drivers/scsi/sd.c      |    4 ++--
 include/linux/blkdev.h |    2 ++
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 557f693..61fe561 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -36,6 +36,7 @@ int blk_queue_ordered(struct request_queue *q, unsigned ordered)
 
 	q->ordered = ordered;
 	q->next_ordered = ordered;
+	q->flush_timeout = BLKDEV_DEF_FLUSH_TIMEOUT;
 
 	return 0;
 }
@@ -137,6 +138,8 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
+	if (q->rq_timed_out_fn)
+		rq->timeout = q->flush_timeout;
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 001ab18..94604b5 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -260,6 +260,35 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
+static ssize_t queue_flush_timeout_show(struct request_queue *q, char *page)
+{
+	if (!q->rq_timed_out_fn)
+		return -EINVAL;
+
+	return queue_var_show(q->flush_timeout / HZ, page);
+}
+
+static ssize_t
+queue_flush_timeout_store(struct request_queue *q, const char *page,
+			  size_t count)
+{
+	unsigned long timeout;
+	int ret;
+
+	if (!q->rq_timed_out_fn)
+		return -EINVAL;
+
+	ret = queue_var_store(&timeout, page, count);
+	q->flush_timeout = timeout * HZ;
+	return ret;
+}
+
+static struct queue_sysfs_entry queue_flush_timeout_entry = {
+	.attr = {.name = "flush_timeout", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_flush_timeout_show,
+	.store = queue_flush_timeout_store,
+};
+
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -370,6 +399,7 @@ static struct queue_sysfs_entry queue_random_entry = {
 };
 
 static struct attribute *default_attrs[] = {
+	&queue_flush_timeout_entry.attr,
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fc5d69a..77af48d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -480,7 +480,6 @@ static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 {
 	/* for now, we use REQ_TYPE_BLOCK_PC. */
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->timeout = SD_TIMEOUT;
 	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
@@ -1067,7 +1066,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * flush everything.
 		 */
 		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+				       sdp->request_queue->flush_timeout,
+				       SD_MAX_RETRIES, NULL);
 		if (res == 0)
 			break;
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a8b05fc..477101a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -361,6 +361,7 @@ struct request_queue
 	int			orderr, ordcolor;
 	struct request		pre_flush_rq, bar_rq, post_flush_rq;
 	struct request		*orig_bar_rq;
+	unsigned int		flush_timeout;
 
 	struct mutex		sysfs_lock;
 
@@ -922,6 +923,7 @@ enum{
 };
 #define BLKDEV_IFL_WAIT		(1 << BLKDEV_WAIT)
 #define BLKDEV_IFL_BARRIER	(1 << BLKDEV_BARRIER)
+#define BLKDEV_DEF_FLUSH_TIMEOUT	30 * HZ
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
 			unsigned long);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-- 
1.6.6.1

