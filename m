From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH] Introduce the parameter to limit scsi timeout count
Date: Mon, 01 Jun 2009 15:15:01 -0400
Message-ID: <4A2428B5.9000701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36800 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZFATMH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jun 2009 15:12:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Hi,

I would like to solve an issue related to scsi timeout.

A storage can break down in the way that it does not respond to
scsi commands such as read/write, while a storage successfully
respond to scsi commands such as test unit ready.
(It may depend on implementation of storage.)

When this type of a device trouble happens, the scsi-mid layer
detects timeout for the device and the scsi-mid layer tries to
recover the error. Then, scsi-mid layer detects that the device
has been recovered by the result of Test Unit Ready.

Therefore, the state of the device is not changed to offline
and user application can continue to issue I/Os to the device.
This may cause timeout errors repeatedly on the same device,
and application can not do proper actions quickly.

To solve this issue, let me propose the sysfs parameter to
limit scsi timeout count in scsi-mid layer. This parameter
is tunable as a module parameter to address the issue at
system boot.

* example

 - Limit a scsi timout count to 1
    # echo 1 > /sys/block/<sdX>/device/max_timeout_cnt

 - Display a current timeout count
    # cat /sys/block/<sdX>/device/iotimeout_cnt

 - Load scsi module with a default scsi timeout count (5)
    # insmod scsi_mod.ko max_timeout_count=5

I appreciate your comments and suggestions.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/scsi/scsi.c        |    6 ++++++
 drivers/scsi/scsi_error.c  |   12 +++++++++++-
 drivers/scsi/scsi_sysfs.c  |   26 ++++++++++++++++++++++++++
 include/scsi/scsi.h        |    2 ++
 include/scsi/scsi_device.h |   14 ++++++++++++++
 5 files changed, 59 insertions(+), 1 deletion(-)

Index: linux-2.6.29/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/scsi.c
+++ linux-2.6.29/drivers/scsi/scsi.c
@@ -87,6 +87,8 @@ unsigned int scsi_logging_level;
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
 
+unsigned int max_timeout_count;
+
 /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
  * You may not alter any existing entry (although adding new ones is
  * encouraged once assigned by ANSI/INCITS T10
@@ -1208,6 +1210,10 @@ MODULE_LICENSE("GPL");
 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
 
+module_param(max_timeout_count, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(max_timeout_count,
+		 "a timeout count before a device is offlined");
+
 static int __init init_scsi(void)
 {
 	int error;
Index: linux-2.6.29/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/scsi_error.c
+++ linux-2.6.29/drivers/scsi/scsi_error.c
@@ -1570,10 +1570,20 @@ void scsi_eh_flush_done_q(struct list_he
 			 * set, do not set DRIVER_TIMEOUT.
 			 */
 			if (!scmd->result)
-				scmd->result |= (DRIVER_TIMEOUT << 24);
+				set_driver_byte(scmd, DRIVER_TIMEOUT);
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
 							" cmd: %p\n",
 							current->comm, scmd));
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
Index: linux-2.6.29/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6.29/drivers/scsi/scsi_sysfs.c
@@ -586,6 +586,29 @@ sdev_store_timeout (struct device *dev, 
 static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
 
 static ssize_t
+sdev_show_max_timeout_cnt(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "0x%x\n", sdev->max_timeout_cnt);
+}
+
+static ssize_t
+sdev_store_max_timeout_cnt(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct scsi_device *sdev;
+	int val;
+	sdev = to_scsi_device(dev);
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
@@ -692,6 +715,7 @@ static DEVICE_ATTR(field, S_IRUGO, show_
 show_sdev_iostat(iorequest_cnt);
 show_sdev_iostat(iodone_cnt);
 show_sdev_iostat(ioerr_cnt);
+show_sdev_iostat(iotimeout_cnt);
 
 static ssize_t
 sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
@@ -753,6 +777,8 @@ static struct attribute *scsi_sdev_attrs
 	&dev_attr_iorequest_cnt.attr,
 	&dev_attr_iodone_cnt.attr,
 	&dev_attr_ioerr_cnt.attr,
+	&dev_attr_iotimeout_cnt.attr,
+	&dev_attr_max_timeout_cnt.attr,
 	&dev_attr_modalias.attr,
 	REF_EVT(media_change),
 	NULL
Index: linux-2.6.29/include/scsi/scsi.h
===================================================================
--- linux-2.6.29.orig/include/scsi/scsi.h
+++ linux-2.6.29/include/scsi/scsi.h
@@ -533,4 +533,6 @@ static inline __u32 scsi_to_u32(__u8 *pt
 	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
 }
 
+extern unsigned int max_timeout_count;
+
 #endif /* _SCSI_SCSI_H */
Index: linux-2.6.29/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.29.orig/include/scsi/scsi_device.h
+++ linux-2.6.29/include/scsi/scsi_device.h
@@ -155,9 +155,12 @@ struct scsi_device {
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
+	unsigned int max_timeout_cnt;	/* timeout count before offlined */
+
 	atomic_t iorequest_cnt;
 	atomic_t iodone_cnt;
 	atomic_t ioerr_cnt;
+	atomic_t iotimeout_cnt;
 
 	struct device		sdev_gendev,
 				sdev_dev;
@@ -454,6 +457,17 @@ static inline int scsi_device_protection
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



