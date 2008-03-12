From: "Gwendal Grignou" <gwendal@google.com>
Subject: [2.6.25] scsi mid layer: add a time threshold to force device to completed command queued for a long time.
Date: Tue, 11 Mar 2008 17:41:44 -0700
Message-ID: <e7510f760803111741h71de33b0i3764b7759a340803@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Please ignore the patch I sent earlier, it was out of context.
[scsi_sysfs: Fix cut and paste errors]
This patch allows to throttle command queuing to a device, if
older commands are outstanding for too long already.
I added a new sysfs parameter [per scsi device] req_pending_time_thres.
If a command is still outstanding after req_pending_time_thres ms, no
new command will be sent to the device.
This mechanism is enabled only when req_pending_time_thres!=0 and
the device queue uses tagging defined in blk_tag.c

The rational for this patch is I noticed that some SATA hard drives with NCQ
enabled have tendency to leave some commands in the back of their queue
when they received a lot of outstanding commands. This is not a problem
for synthetic read random test, like iometer, but it hurts performance of
real-life applications: the deviation of the latency increase significantly
when NCQ is enabled.

This patch slightly decrease performance during synthetic test when
req_pending_time_thres != 0 [it is still better than when NCQ is not enabled]
but it improves the deviation.

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 block/blk-tag.c            |    2 +-
 drivers/scsi/scsi_lib.c    |   37 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c  |    9 ++++++---
 include/linux/blkdev.h     |    4 ++++
 include/scsi/scsi_device.h |    2 ++
 5 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index 4780a46..49e4f24 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -364,7 +364,7 @@ int blk_queue_start_tag(struct request_q
 	rq->tag = tag;
 	bqt->tag_index[tag] = rq;
 	blkdev_dequeue_request(rq);
-	list_add(&rq->queuelist, &q->tag_busy_list);
+	list_add_tail(&rq->queuelist, &q->tag_busy_list);
 	bqt->busy++;
 	return 0;
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..b17a896 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1296,6 +1296,36 @@ static inline int scsi_dev_queue_ready(s
 }

 /*
+ * scsi_cmd_thres_check: if requests are in the drive too long,
+ * return 0 else return 1.
+ *
+ * Called with the queue_lock held.
+ */
+static inline int scsi_cmd_thres_check(struct request *req,
+				       struct request_queue *q,
+				       struct scsi_device *sdev)
+{
+	struct request *oldest_req;
+	if (blk_queue_tagged(q) &&
+	    (sdev->req_pending_time_thres != 0)) {
+		if (!list_empty(&q->tag_busy_list)) {
+			oldest_req = list_entry_rq(q->tag_busy_list.next);
+			if (time_after(jiffies,
+				       oldest_req->timeout_time_thres)) {
+				/*
+				 * oldest command is not completed yet,
+				 * don't queue until processed
+				 */
+				return 0;
+			}
+		}
+		req->timeout_time_thres = jiffies +
+			sdev->req_pending_time_thres * (HZ/1000);
+	}
+	return 1;
+}
+
+/*
  * scsi_host_queue_ready: if we can send requests to shost, return 1 else
  * return 0. We must end up running the queue again whenever 0 is
  * returned, else IO can hang.
@@ -1451,6 +1481,13 @@ static void scsi_request_fn(struct reque
 		if (!req || !scsi_dev_queue_ready(q, sdev))
 			break;

+		/*
+		 * If the device is busy processing a request for too long,
+		 * Don't send anything.
+		 */
+		if (!scsi_cmd_thres_check(req, q, sdev))
+			break;
+
 		if (unlikely(!scsi_device_online(sdev))) {
 			sdev_printk(KERN_ERR, sdev,
 				    "rejecting I/O to offline device\n");
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ed83cdb..7921cda 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -441,7 +441,7 @@ static DEVICE_ATTR(field, S_IRUGO, sdev_


 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr: create a function and attribute variable for a
  * read/write field.
  */
 #define sdev_rw_attr(field, format_string)				\
@@ -452,7 +452,7 @@ sdev_store_##field (struct device *dev,
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	snscanf (buf, 20, format_string, &sdev->field);			\
+	sscanf (buf, format_string, &sdev->field);			\
 	return count;							\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field,
sdev_store_##field);
@@ -461,7 +461,7 @@ static DEVICE_ATTR(field, S_IRUGO | S_IW
  * so leave this code in */
 #if 0
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr_bit: create a function and attribute variable for a
  * read/write bit field.
  */
 #define sdev_rw_attr_bit(field)						\
@@ -510,6 +510,8 @@ sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");

+sdev_rw_attr (req_pending_time_thres, "%d\n");
+
 static ssize_t
 sdev_show_timeout (struct device *dev, struct device_attribute *attr,
char *buf)
 {
@@ -689,6 +691,7 @@ static struct attribute *scsi_sdev_attrs
 	&dev_attr_delete.attr,
 	&dev_attr_state.attr,
 	&dev_attr_timeout.attr,
+	&dev_attr_req_pending_time_thres.attr,
 	&dev_attr_iocounterbits.attr,
 	&dev_attr_iorequest_cnt.attr,
 	&dev_attr_iodone_cnt.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f79d40..8191e67 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -188,6 +188,10 @@ struct request {
 	struct gendisk *rq_disk;
 	unsigned long start_time;

+	/* when it should complete when req_pending_time_thres is enabled
+	 */
+	unsigned long timeout_time_thres;
+
 	/* Number of scatter-gather DMA addr+len pairs after
 	 * physical address coalescing is performed.
 	 */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ab7acbe..aa57d6d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -83,6 +83,8 @@ struct scsi_device {
 	unsigned long last_queue_full_time;/* don't let QUEUE_FULLs on the same
 					   jiffie count on our counter, they
 					   could all be from the same event. */
+	unsigned int req_pending_time_thres; /* time a request must complete for
+					      * another request to be queued. */

 	unsigned int id, lun, channel;
