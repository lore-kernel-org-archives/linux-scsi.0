From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/1] scsi: Add allow_restart sysfs class attribute
Date: Tue, 27 Jun 2006 11:10:31 -0500
Message-ID: <200606271610.k5RGAXcT005333@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:50851 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1161139AbWF0QKf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 12:10:35 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k5RGAYBE024865
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2006 12:10:34 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k5RGA3dh291712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2006 10:10:03 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k5RGAXHN005362
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2006 10:10:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, parasietje@gmail.com, brking@us.ibm.com


This is a resend of a patch I generated in response to an email sent
by Ruben Faelens <parasietje@gmail.com>. His original email to
linux-scsi requested a method in which he could spin down a scsi disk
when not in use and have the kernel automatically spin it back up when
an I/O was generated to the disk. The infrastructure to automatically
spin a disk up has been in the scsi error handler for some time now,
but it is not enabled by default. This patch adds an sd sysfs attribute
which allows userspace to enable this behavior.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/sd.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+)

diff -puN drivers/scsi/sd.c~sd_allow_restart_sysfs_attr drivers/scsi/sd.c
--- linux-2.6/drivers/scsi/sd.c~sd_allow_restart_sysfs_attr	2006-06-26 14:07:59.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/sd.c	2006-06-26 14:07:59.000000000 -0500
@@ -208,6 +208,23 @@ static ssize_t sd_store_cache_type(struc
 	return count;
 }
 
+static ssize_t sd_store_allow_restart(struct class_device *cdev, const char *buf,
+				      size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
+	struct scsi_device *sdp = sdkp->device;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (sdp->type != TYPE_DISK)
+		return -EINVAL;
+
+	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
+
+	return count;
+}
+
 static ssize_t sd_show_cache_type(struct class_device *cdev, char *buf)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(cdev);
@@ -223,10 +240,19 @@ static ssize_t sd_show_fua(struct class_
 	return snprintf(buf, 20, "%u\n", sdkp->DPOFUA);
 }
 
+static ssize_t sd_show_allow_restart(struct class_device *cdev, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
+
+	return snprintf(buf, 40, "%d\n", sdkp->device->allow_restart);
+}
+
 static struct class_device_attribute sd_disk_attrs[] = {
 	__ATTR(cache_type, S_IRUGO|S_IWUSR, sd_show_cache_type,
 	       sd_store_cache_type),
 	__ATTR(FUA, S_IRUGO, sd_show_fua, NULL),
+	__ATTR(allow_restart, S_IRUGO|S_IWUSR, sd_show_allow_restart,
+	       sd_store_allow_restart),
 	__ATTR_NULL,
 };
 
_
