From: Brian King <brking@us.ibm.com>
Subject: [PATCH] scsi_timeout_mod
Date: Mon, 03 May 2004 10:47:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <409669AB.7030207@us.ibm.com>
References: <3356669BBE90C448AD4645C843E2BF2802C016E3@xbl.ma.emulex.com> <40883CF6.8050808@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010506000607040102070001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:25221 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263761AbUECPr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2004 11:47:59 -0400
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: "Smart, James" <James.Smart@Emulex.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010506000607040102070001
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The following patch replaces the sd_timeout_mod patch I submitted earlier.
I renamed the field to simply "timeout" and exposed in in sysfs.




-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------010506000607040102070001
Content-Type: text/plain;
 name="scsi_timeout_mod.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_timeout_mod.patch"


This patch allows LLDs to override the default timeout used for scsi devices
and exposes it in sysfs. The default timeout value used is too short for
many RAID array devices, such as those created by the ipr driver.


---


diff -puN include/scsi/scsi_device.h~scsi_timeout_mod include/scsi/scsi_device.h
--- linux-2.6.6-rc3/include/scsi/scsi_device.h~scsi_timeout_mod	Fri Apr 30 09:51:49 2004
+++ linux-2.6.6-rc3-bjking1/include/scsi/scsi_device.h	Fri Apr 30 09:52:16 2004
@@ -111,6 +111,8 @@ struct scsi_device {
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
+	int timeout;
+
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 
diff -puN drivers/scsi/scsi_sysfs.c~scsi_timeout_mod drivers/scsi/scsi_sysfs.c
--- linux-2.6.6-rc3/drivers/scsi/scsi_sysfs.c~scsi_timeout_mod	Fri Apr 30 09:52:43 2004
+++ linux-2.6.6-rc3-bjking1/drivers/scsi/scsi_sysfs.c	Fri Apr 30 09:53:56 2004
@@ -302,6 +302,26 @@ sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
 
 static ssize_t
+sdev_show_timeout (struct device *dev, char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf (buf, 20, "%d\n", sdev->timeout / HZ);
+}
+
+static ssize_t
+sdev_store_timeout (struct device *dev, const char *buf, size_t count)
+{
+	struct scsi_device *sdev;
+	int timeout;
+	sdev = to_scsi_device(dev);
+	sscanf (buf, "%d\n", &timeout);
+	sdev->timeout = timeout * HZ;
+	return count;
+}
+static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout)
+
+static ssize_t
 store_rescan_field (struct device *dev, const char *buf, size_t count) 
 {
 	scsi_rescan_device(dev);
@@ -367,6 +387,7 @@ static struct device_attribute *scsi_sys
 	&dev_attr_rescan,
 	&dev_attr_delete,
 	&dev_attr_state,
+	&dev_attr_timeout,
 	NULL
 };
 
diff -puN drivers/scsi/sd.c~scsi_timeout_mod drivers/scsi/sd.c
--- linux-2.6.6-rc3/drivers/scsi/sd.c~scsi_timeout_mod	Fri Apr 30 09:54:04 2004
+++ linux-2.6.6-rc3-bjking1/drivers/scsi/sd.c	Fri Apr 30 09:55:42 2004
@@ -207,9 +207,7 @@ static int sd_init_command(struct scsi_c
 	sector_t block;
 	struct scsi_device *sdp = SCpnt->device;
 
-	timeout = SD_TIMEOUT;
-	if (SCpnt->device->type != TYPE_DISK)
-		timeout = SD_MOD_TIMEOUT;
+	timeout = sdp->timeout;
 
 	/*
 	 * these are already setup, just copy cdb basically
@@ -1382,6 +1380,13 @@ static int sd_probe(struct device *dev)
 	sdkp->index = index;
 	sdkp->openers = 0;
 
+	if (!sdp->timeout) {
+		if (sdp->type == TYPE_DISK)
+			sdp->timeout = SD_TIMEOUT;
+		else
+			sdp->timeout = SD_MOD_TIMEOUT;
+	}
+
 	devno = make_sd_dev(index, 0);
 	gd->major = MAJOR(devno);
 	gd->first_minor = MINOR(devno);

_

--------------010506000607040102070001--

