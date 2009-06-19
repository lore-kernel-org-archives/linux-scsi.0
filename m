From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 1/2] Introduce the parameter to limit scsi timeout count
 (take 2)
Date: Fri, 19 Jun 2009 18:38:50 -0400
Message-ID: <4A3C137A.7060904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51652 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760775AbZFSWgQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2009 18:36:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Limit a timeout count per device. Add two parameters in scsi_device
structure, iotimeout_cnt and max_timeout_cnt. When timeout happens
on a device and returns the DRIVER_TIMEOUT error, iotimeout_cnt is
incremented. And the device is offlined when its value reaches to
max_timeout_cnt. max_timeout_cnt can be set through sysfs. 

Example:

 * Limit a scsi timout count to 1
    # echo 1 > /sys/block/<sdX>/device/max_timeout_cnt
    # cat  /sys/block/<sdX>/device/max_timeout_cnt
    1

 * Display a current timeout count
    # cat /sys/block/<sdX>/device/iotimeout_cnt
    0


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/scsi/scsi_error.c  |   16 +++++++++++++---
 drivers/scsi/scsi_scan.c   |    3 +++
 drivers/scsi/scsi_sysfs.c  |   24 ++++++++++++++++++++++++
 include/scsi/scsi_device.h |   14 ++++++++++++++
 4 files changed, 54 insertions(+), 3 deletions(-)

Index: linux-2.6.30/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.30.orig/drivers/scsi/scsi_error.c
+++ linux-2.6.30/drivers/scsi/scsi_error.c
@@ -1584,10 +1584,20 @@ void scsi_eh_flush_done_q(struct list_he
 			 * set, do not set DRIVER_TIMEOUT.
 			 */
 			if (!scmd->result)
-				scmd->result |= (DRIVER_TIMEOUT << 24);
+				set_driver_byte(scmd, DRIVER_TIMEOUT);
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
-							" cmd: %p\n",
-							current->comm, scmd));
+							  " cmd: %p\n",
+							  current->comm, scmd));
+			if (scsi_device_online(scmd->device) &&
+			    (driver_byte(scmd->result) & DRIVER_TIMEOUT) &&
+			    scsi_check_timeout_limit(scmd->device)) {
+				sdev_printk(KERN_INFO, scmd->device,
+					    "Device offlined - "
+					    "reached max timeout count\n");
+				scsi_device_set_state(scmd->device,
+						      SDEV_OFFLINE);
+				scsi_reset_timeout_limit(scmd->device);
+			}
 			scsi_finish_command(scmd);
 		}
 	}
Index: linux-2.6.30/drivers/scsi/scsi_scan.c
===================================================================
--- linux-2.6.30.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.30/drivers/scsi/scsi_scan.c
@@ -273,6 +273,9 @@ static struct scsi_device *scsi_alloc_sd
 	 * slave_configure function */
 	sdev->max_device_blocked = SCSI_DEFAULT_DEVICE_BLOCKED;
 
+	/* set the default timeout count (no limit) */
+	sdev->max_timeout_cnt = 0;
+
 	/*
 	 * Some low level driver could use device->type
 	 */
Index: linux-2.6.30/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.30.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6.30/drivers/scsi/scsi_sysfs.c
@@ -586,6 +586,27 @@ sdev_store_timeout (struct device *dev, 
 static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
 
 static ssize_t
+sdev_show_max_timeout_cnt(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "%d\n", sdev->max_timeout_cnt);
+}
+
+static ssize_t
+sdev_store_max_timeout_cnt(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int val;
+	sscanf(buf, "%d\n", &val);
+	sdev->max_timeout_cnt = val;
+	return count;
+}
+static DEVICE_ATTR(max_timeout_cnt, S_IRUGO | S_IWUSR,
+		   sdev_show_max_timeout_cnt, sdev_store_max_timeout_cnt);
+
+static ssize_t
 store_rescan_field (struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
 {
@@ -692,6 +713,7 @@ static DEVICE_ATTR(field, S_IRUGO, show_
 show_sdev_iostat(iorequest_cnt);
 show_sdev_iostat(iodone_cnt);
 show_sdev_iostat(ioerr_cnt);
+show_sdev_iostat(iotimeout_cnt);
 
 static ssize_t
 sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
@@ -753,6 +775,8 @@ static struct attribute *scsi_sdev_attrs
 	&dev_attr_iorequest_cnt.attr,
 	&dev_attr_iodone_cnt.attr,
 	&dev_attr_ioerr_cnt.attr,
+	&dev_attr_iotimeout_cnt.attr,
+	&dev_attr_max_timeout_cnt.attr,
 	&dev_attr_modalias.attr,
 	REF_EVT(media_change),
 	NULL
Index: linux-2.6.30/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.30.orig/include/scsi/scsi_device.h
+++ linux-2.6.30/include/scsi/scsi_device.h
@@ -155,9 +155,12 @@ struct scsi_device {
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
+	unsigned int max_timeout_cnt;	/* max timeout count for each device */
+
 	atomic_t iorequest_cnt;
 	atomic_t iodone_cnt;
 	atomic_t ioerr_cnt;
+	atomic_t iotimeout_cnt;
 
 	struct device		sdev_gendev,
 				sdev_dev;
@@ -450,6 +453,17 @@ static inline int scsi_device_protection
 	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
+static inline int scsi_check_timeout_limit(struct scsi_device *sdev)
+{
+	return atomic_inc_return(&sdev->iotimeout_cnt) ==
+		sdev->max_timeout_cnt;
+}
+
+static inline void scsi_reset_timeout_limit(struct scsi_device *sdev)
+{
+	atomic_set(&sdev->iotimeout_cnt, 0);
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"


