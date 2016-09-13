From: "Gurunath, Vasundhara" <vasundhara.gurunath@hpe.com>
Subject: [PATCH] scsi:Prevent deletion of SCSI block device in use
Date: Tue, 13 Sep 2016 22:08:05 +0530
Message-ID: <1473784685-2194-1-git-send-email-vasundhara.gurunath@hpe.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:49374 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755204AbcIMQk4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2016 12:40:56 -0400
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id AE6FF6252E
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2016 16:40:54 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, paulose.kuriakose.arackal@hpe.com, jasminder.kaur@hpe.com, "Gurunath, Vasundhara" <vasundhara.gurunath@hpe.com>

From: "Gurunath, Vasundhara" <vasundhara.gurunath@hpe.com>

SCSI block device can be removed, using write to sysfs
delete file as below:
echo 1 > /sys/block/sdX/device/delete
If the device is in use by applications, or part of
system configuration such as boot device, removal can
result in application disruptions or system down time.

An additional write option ? is added to SCSI sysfs
interface as below, in order to prevent accidental
deletion of devices in use.
echo ? > /sys/block/sdX/device/delete

In the absence of any usage, this option proceeds with
device deletion.  If the device is open, deletion is
prevented, and active Open and IO counts at the time of
deletion is logged. Information logged during latest
delete attempt can be obtained by issuing a read to the
delete file as below:
cat  /sys/block/sdX/device/delete

Signed-off-by: Vasundhara Gurunath <vasundhara.gurunath@hpe.com>
---
 drivers/scsi/scsi_sysfs.c  | 52 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.c          |  4 ++++
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0734927..b0cbfbb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -12,6 +12,8 @@
 #include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
+#include <linux/time.h>
+#include <linux/timer.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -457,6 +459,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	kfree(sdev->vpd_pg83);
 	kfree(sdev->vpd_pg80);
 	kfree(sdev->inquiry);
+	if (sdev->delete_msg_buf != NULL)
+		kfree(sdev->delete_msg_buf);
 	kfree(sdev);
 
 	if (parent)
@@ -709,11 +713,57 @@ static ssize_t
 sdev_store_delete(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct timeval tv;
+	struct tm tms;
+
+	if (buf[0] == '?')  {
+		if (sdev->usage_count) {
+			/*
+			* Buffer to hold I/O statistics on delete attempt.
+			*/
+			if (sdev->delete_msg_buf == NULL) {
+				sdev->delete_msg_buf =
+				kmalloc(128, GFP_KERNEL);
+				memset(sdev->delete_msg_buf, 0, 128);
+			}
+			do_gettimeofday(&tv);
+			time_to_tm(tv.tv_sec, 0, &tms);
+			sprintf(sdev->delete_msg_buf,
+				"Last delete attempt: %d:%d:%ld %02d:%02d\n"
+				"Open Count : %d\n"
+				"IO Active Count : %d\n"
+				"IO Done Count : %d\n",
+				tms.tm_mday, tms.tm_mon + 1,
+				tms.tm_year + 1900,
+				tms.tm_hour, tms.tm_min,
+				sdev->usage_count,
+				sdev->iorequest_cnt.counter,
+				sdev->iodone_cnt.counter);
+
+			return count;
+		}
+	}
+
+
 	if (device_remove_file_self(dev, attr))
 		scsi_remove_device(to_scsi_device(dev));
 	return count;
 };
-static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
+
+static ssize_t sdev_show_delete(struct device *dev,
+	struct device_attribute *attr, char *buf) {
+
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	if (sdev->delete_msg_buf != NULL)
+		return sprintf(buf, "%s", sdev->delete_msg_buf);
+	else
+		return 0;
+}
+
+static DEVICE_ATTR(delete, S_IRUGO | S_IWUSR,
+	sdev_show_delete, sdev_store_delete);
 
 static ssize_t
 store_state_field(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d3e852a..67d3406 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1235,6 +1235,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	}
+	sdev->usage_count = sdkp->openers.counter;
 
 	return 0;
 
@@ -1267,6 +1268,7 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	}
+	sdev->usage_count = sdkp->openers.counter;
 
 	/*
 	 * XXX and what if there are packets in flight and this close()
@@ -3082,6 +3084,8 @@ static int sd_probe(struct device *dev)
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
 
+	sdp->usage_count = sdkp->openers.counter;
+
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
 			blk_queue_rq_timeout(sdp->request_queue, SD_TIMEOUT);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8a95631..ab79675 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -208,6 +208,8 @@ struct scsi_device {
 
 	unsigned char		access_state;
 	enum scsi_device_state sdev_state;
+	char                    *delete_msg_buf;
+	int                     usage_count;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
 
-- 
1.8.3.1

