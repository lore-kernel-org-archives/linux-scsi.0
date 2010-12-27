From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/8] [SCSI] scst: Split sysfs type attribute
Date: Mon, 27 Dec 2010 14:36:37 +0100
Message-ID: <201012271436.37229.bvanassche@acm.org>
References: <201012271435.33778.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:51727 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab0L0Ngp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 08:36:45 -0500
In-Reply-To: <201012271435.33778.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

The device 'type' sysfs attribute contains two values: the SCSI
peripheral device type as a number and its textual description. Split
this sysfs attribute into two attributes such that both satisfy the
"one value per file" rule. Also, fix a potential out-of-bounds access
of the array scst_dev_handler_types.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
---
 .../ABI/stable/sysfs-devices-scst_tgt_dev          |    8 +++-
 Documentation/ABI/stable/sysfs-driver-scst_tgt_dev |   12 +++--
 drivers/scst/scst_sysfs.c                          |   46 ++++++++++++++-----
 3 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
index cfa791e..a7d5070 100644
--- a/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
+++ b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
@@ -118,7 +118,13 @@ What:		/sys/bus/scst_tgt_dev/device/*/type
 Date:		December 2010
 Contact:	Bart Van Assche <bvanassche@acm.org>
 Description:
-		SCSI type of this device. Read-only.
+		SCSI type of this device as a number. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/type_description
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		SCSI type of this device as a textual description. Read-only.
 
 What:		/sys/bus/scst_tgt_dev/device/*/usn
 Date:		December 2010
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
index c79aee0..2787c4d 100644
--- a/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
+++ b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
@@ -20,8 +20,12 @@ What:		/sys/bus/scst_tgt_dev/drivers/*/type
 Date:		December 2010
 Contact:	Bart Van Assche <bvanassche@acm.org>
 Description:
-		SCSI type of the devices managed by this driver. Read-only.
-		An example:
+		SCSI type of the devices managed by this driver as a number.
+		Read-only.
 
-		$ cat /sys/bus/scst_tgt_dev/drivers/vcdrom/type
-		5 - CD-ROM device
+What:		/sys/bus/scst_tgt_dev/drivers/*/type_description
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		SCSI type of the devices managed by this driver as a textual
+		description. Read-only.
diff --git a/drivers/scst/scst_sysfs.c b/drivers/scst/scst_sysfs.c
index 3901f20..23cba83 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -1091,16 +1091,22 @@ void scst_tgt_sysfs_put(struct scst_tgt *tgt)
 static ssize_t scst_dev_sysfs_type_show(struct device *device,
 				struct device_attribute *attr, char *buf)
 {
-	int pos;
 	struct scst_device *dev;
 
 	dev = scst_dev_to_dev(device);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", dev->type);
+}
 
-	pos = sprintf(buf, "%d - %s\n", dev->type,
-		(unsigned)dev->type > ARRAY_SIZE(scst_dev_handler_types) ?
-		      "unknown" : scst_dev_handler_types[dev->type]);
+static ssize_t scst_dev_sysfs_type_description_show(struct device *device,
+				struct device_attribute *attr, char *buf)
+{
+	struct scst_device *dev;
+	const char *descr;
 
-	return pos;
+	dev = scst_dev_to_dev(device);
+	descr = (unsigned)dev->type < ARRAY_SIZE(scst_dev_handler_types) ?
+		scst_dev_handler_types[dev->type] : "unknown";
+	return scnprintf(buf, PAGE_SIZE, "%s\n", descr);
 }
 
 static int scst_process_dev_sysfs_threads_data_store(
@@ -1265,8 +1271,13 @@ static const struct device_attribute *dev_thread_attr[] = {
 static const struct device_attribute scst_dev_sysfs_type_attr =
 	__ATTR(type, S_IRUGO, scst_dev_sysfs_type_show, NULL);
 
+static const struct device_attribute scst_dev_sysfs_type_description_attr =
+	__ATTR(type_description, S_IRUGO, scst_dev_sysfs_type_description_show,
+	       NULL);
+
 static const struct device_attribute *scst_devt_dev_attrs[] = {
 	&scst_dev_sysfs_type_attr,
+	&scst_dev_sysfs_type_description_attr,
 	NULL
 };
 
@@ -2852,23 +2863,34 @@ out:
 
 static ssize_t scst_devt_type_show(struct device_driver *drv, char *buf)
 {
-	int pos;
 	struct scst_dev_type *devt;
 
 	devt = scst_drv_to_devt(drv);
-
-	pos = sprintf(buf, "%d - %s\n", devt->type,
-		(unsigned)devt->type > ARRAY_SIZE(scst_dev_handler_types) ?
-			"unknown" : scst_dev_handler_types[devt->type]);
-
-	return pos;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", devt->type);
 }
 
 static const struct driver_attribute scst_devt_type_attr =
 	__ATTR(type, S_IRUGO, scst_devt_type_show, NULL);
 
+static ssize_t scst_devt_type_description_show(struct device_driver *drv,
+					       char *buf)
+{
+	struct scst_dev_type *devt;
+	const char *descr;
+
+	devt = scst_drv_to_devt(drv);
+	descr = (unsigned)devt->type < ARRAY_SIZE(scst_dev_handler_types) ?
+		scst_dev_handler_types[devt->type] : "unknown";
+	return scnprintf(buf, PAGE_SIZE, "%s\n", descr);
+}
+
+static const struct driver_attribute scst_devt_type_description_attr =
+	__ATTR(type_description, S_IRUGO, scst_devt_type_description_show,
+	       NULL);
+
 static const struct driver_attribute *scst_devt_default_attrs[] = {
 	&scst_devt_type_attr,
+	&scst_devt_type_description_attr,
 	NULL
 };
 
-- 
1.7.1

