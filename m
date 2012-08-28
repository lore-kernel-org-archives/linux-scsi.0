From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] block/scsi: Allow request and error handling timeouts to be specified
Date: Tue, 28 Aug 2012 14:01:51 -0400
Message-ID: <yq1ehmqsxo0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:21926 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2H1SB7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 14:01:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>, James.Bottomley@hansenpartnership.com


Export rq_timeout in sysfs for block devices since it is a request_queue
property. Until now it has only been possible to explicitly set this for
SCSI class devices.

Also introduce eh_timeout which can be used for error handling
purposes. This was previously hardcoded to 10 seconds in the SCSI error
handling code. However, for some fast-fail scenarios it is necessary to
be able to tune this as it can take several iterations (bus device,
target, bus, controller) before we give up.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index c1eb41c..0ad8442 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -129,6 +129,29 @@ Description:
 		throughput is desired.  If no optimal I/O size is
 		reported this file contains 0.
 
+What:		/sys/block/<disk>/queue/rq_timeout_secs
+Date:		June 2012
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		This is the timeout in seconds for regular filesystem
+		I/O requests.  If the disk device has not completed the
+		request in this many seconds the kernel will fail the
+		I/O and initiate the subsystem-specific error handling
+		process.
+
+What:		/sys/block/<disk>/queue/eh_timeout_secs
+Date:		June 2012
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		If a device has timed out while processing regular
+		filesystem I/O the kernel will attempt to bring the
+		device back online.  This typically involves an
+		escalating set of approaches (device reset, bus reset,
+		controller reset).  eh_timeout_secs describes how many
+		seconds should be spent waiting for response after each
+		recovery attempt before moving on to the next step in
+		the error handling process.
+
 What:		/sys/block/<disk>/queue/nomerges
 Date:		January 2010
 Contact:
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 565a678..7cc6066 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -87,6 +87,12 @@ void blk_queue_rq_timeout(struct request_queue *q, unsigned int timeout)
 }
 EXPORT_SYMBOL_GPL(blk_queue_rq_timeout);
 
+void blk_queue_eh_timeout(struct request_queue *q, unsigned int timeout)
+{
+	q->eh_timeout = timeout;
+}
+EXPORT_SYMBOL_GPL(blk_queue_eh_timeout);
+
 void blk_queue_rq_timed_out(struct request_queue *q, rq_timed_out_fn *fn)
 {
 	q->rq_timed_out_fn = fn;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9628b29..7725c84 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -280,6 +280,42 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
+static ssize_t
+queue_rq_timeout_store(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long rq_timeout;
+	ssize_t ret = queue_var_store(&rq_timeout, page, count);
+
+	q->rq_timeout = rq_timeout * HZ;
+
+	return ret;
+}
+
+static ssize_t queue_rq_timeout_show(struct request_queue *q, char *page)
+{
+	int rq_timeout = q->rq_timeout / HZ;
+
+	return queue_var_show(rq_timeout, (page));
+}
+
+static ssize_t
+queue_eh_timeout_store(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long eh_timeout;
+	ssize_t ret = queue_var_store(&eh_timeout, page, count);
+
+	q->eh_timeout = eh_timeout * HZ;
+
+	return ret;
+}
+
+static ssize_t queue_eh_timeout_show(struct request_queue *q, char *page)
+{
+	int eh_timeout = q->eh_timeout / HZ;
+
+	return queue_var_show(eh_timeout, (page));
+}
+
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -394,6 +430,18 @@ static struct queue_sysfs_entry queue_random_entry = {
 	.store = queue_store_random,
 };
 
+static struct queue_sysfs_entry queue_rq_timeout_entry = {
+	.attr = {.name = "rq_timeout_secs", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_rq_timeout_show,
+	.store = queue_rq_timeout_store,
+};
+
+static struct queue_sysfs_entry queue_eh_timeout_entry = {
+	.attr = {.name = "eh_timeout_secs", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_eh_timeout_show,
+	.store = queue_eh_timeout_store,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -416,6 +464,8 @@ static struct attribute *default_attrs[] = {
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
 	&queue_random_entry.attr,
+	&queue_rq_timeout_entry.attr,
+	&queue_eh_timeout_entry.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4a6381c..22e5480 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -42,8 +42,6 @@
 
 #include <trace/events/scsi.h>
 
-#define SENSE_TIMEOUT		(10*HZ)
-
 /*
  * These should *probably* be handled by the host itself.
  * Since it is allowed to sleep, it probably should.
@@ -852,7 +850,8 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
  */
 static int scsi_request_sense(struct scsi_cmnd *scmd)
 {
-	return scsi_send_eh_cmnd(scmd, NULL, 0, SENSE_TIMEOUT, ~0);
+	return scsi_send_eh_cmnd(scmd, NULL, 0,
+				 scmd->device->request_queue->eh_timeout, ~0);
 }
 
 /**
@@ -953,7 +952,8 @@ static int scsi_eh_tur(struct scsi_cmnd *scmd)
 	int retry_cnt = 1, rtn;
 
 retry_tur:
-	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6, SENSE_TIMEOUT, 0);
+	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6,
+				scmd->device->request_queue->eh_timeout, 0);
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
 		__func__, scmd, rtn));
@@ -1065,12 +1065,13 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 {
 	static unsigned char stu_command[6] = {START_STOP, 0, 0, 0, 1, 0};
+	unsigned int tmo = scmd->device->request_queue->rq_timeout;
 
 	if (scmd->device->allow_restart) {
 		int i, rtn = NEEDS_RETRY;
 
 		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
-			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
+			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, tmo, 0);
 
 		if (rtn == SUCCESS)
 			return 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..3a4f5f1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1696,6 +1696,9 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	 */
 	blk_queue_dma_alignment(q, 0x03);
 
+	blk_queue_rq_timeout(q, SCSI_DEFAULT_RQ_TIMEOUT);
+	blk_queue_eh_timeout(q, SCSI_DEFAULT_EH_TIMEOUT);
+
 	return q;
 }
 EXPORT_SYMBOL(__scsi_alloc_queue);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4a2ab7c..608e220 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -379,6 +379,7 @@ struct request_queue {
 	unsigned int		in_flight[2];
 
 	unsigned int		rq_timeout;
+	unsigned int		eh_timeout;
 	struct timer_list	timeout;
 	struct list_head	timeout_list;
 
@@ -889,6 +890,7 @@ extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
+extern void blk_queue_eh_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_flush(struct request_queue *q, unsigned int flush);
 extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..3a01dd1 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -10,9 +10,15 @@
 
 #include <linux/types.h>
 #include <linux/scatterlist.h>
+#include <linux/kernel.h>
 
 struct scsi_cmnd;
 
+enum scsi_timeouts {
+	SCSI_DEFAULT_RQ_TIMEOUT		= 30 * HZ,
+	SCSI_DEFAULT_EH_TIMEOUT		= 10 * HZ,
+};
+
 /*
  * The maximum number of SG segments that we will put inside a
  * scatterlist (unless chaining is used). Should ideally fit inside a
