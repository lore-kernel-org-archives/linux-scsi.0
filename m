From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Allow error handling timeout to be specified
Date: Thu, 09 May 2013 23:11:37 -0400
Message-ID: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17283 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3EJDL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 23:11:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu


Introduce eh_timeout which can be used for error handling purposes. This
was previously hardcoded to 10 seconds in the SCSI error handling
code. However, for some fast-fail scenarios it is necessary to be able
to tune this as it can take several iterations (bus device, target, bus,
controller) before we give up.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..91adc52 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -44,8 +44,6 @@
 
 static void scsi_eh_done(struct scsi_cmnd *scmd);
 
-#define SENSE_TIMEOUT		(10*HZ)
-
 /*
  * These should *probably* be handled by the host itself.
  * Since it is allowed to sleep, it probably should.
@@ -864,7 +862,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
  */
 static int scsi_request_sense(struct scsi_cmnd *scmd)
 {
-	return scsi_send_eh_cmnd(scmd, NULL, 0, SENSE_TIMEOUT, ~0);
+	return scsi_send_eh_cmnd(scmd, NULL, 0, scmd->device->eh_timeout, ~0);
 }
 
 /**
@@ -965,7 +963,8 @@ static int scsi_eh_tur(struct scsi_cmnd *scmd)
 	int retry_cnt = 1, rtn;
 
 retry_tur:
-	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6, SENSE_TIMEOUT, 0);
+	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6,
+				scmd->device->eh_timeout, 0);
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
 		__func__, scmd, rtn));
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b9e39e0..7f7bd1f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -945,6 +945,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	}
 
 	sdev->max_queue_depth = sdev->queue_depth;
+	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
 	/*
 	 * Ok, the device is now all set up, we can
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..38db310 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -560,6 +560,35 @@ sdev_store_timeout (struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
 
 static ssize_t
+sdev_show_eh_timeout (struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "%u\n", sdev->eh_timeout / HZ);
+}
+
+static ssize_t
+sdev_store_eh_timeout (struct device *dev, struct device_attribute *attr,
+		    const char *buf, size_t count)
+{
+	struct scsi_device *sdev;
+	unsigned int eh_timeout;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	sdev = to_scsi_device(dev);
+	err = kstrtouint(buf, 10, &eh_timeout);
+	if (err)
+		return err;
+	sdev->eh_timeout = eh_timeout * HZ;
+
+	return count;
+}
+static DEVICE_ATTR(eh_timeout, S_IRUGO | S_IWUSR, sdev_show_eh_timeout, sdev_store_eh_timeout);
+
+static ssize_t
 store_rescan_field (struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
 {
@@ -723,6 +752,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_delete.attr,
 	&dev_attr_state.attr,
 	&dev_attr_timeout.attr,
+	&dev_attr_eh_timeout.attr,
 	&dev_attr_iocounterbits.attr,
 	&dev_attr_iorequest_cnt.attr,
 	&dev_attr_iodone_cnt.attr,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..4b87d99 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -10,9 +10,14 @@
 
 #include <linux/types.h>
 #include <linux/scatterlist.h>
+#include <linux/kernel.h>
 
 struct scsi_cmnd;
 
+enum scsi_timeouts {
+	SCSI_DEFAULT_EH_TIMEOUT		= 10 * HZ,
+};
+
 /*
  * The maximum number of SG segments that we will put inside a
  * scatterlist (unless chaining is used). Should ideally fit inside a
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a7f9cba..7eb9b20 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -113,6 +113,7 @@ struct scsi_device {
 				 * scsi_devinfo.[hc]. For now used only to
 				 * pass settings from slave_alloc to scsi
 				 * core. */
+	unsigned int eh_timeout; /* Error handling timeout */
 	unsigned writeable:1;
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
