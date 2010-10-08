From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Export effective protection mode in sysfs
Date: Fri, 08 Oct 2010 01:36:24 -0400
Message-ID: <yq14ocxs0tj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:44255 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0JHFi2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2010 01:38:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org


Create a sysfs entry that reports the negotiated DIX/DIF protection mode
for a SCSI disk. This depends on the protection type the disk is
formatted with as well as the protection capabilities advertised by the
controller.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c158e61..ca0ffc3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -259,6 +259,28 @@ sd_show_protection_type(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+sd_show_protection_mode(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = sdkp->device;
+	unsigned int dif, dix;
+
+	dif = scsi_host_dif_capable(sdp->host, sdkp->protection_type);
+	dix = scsi_host_dix_capable(sdp->host, sdkp->protection_type);
+
+	if (!dix && scsi_host_dix_capable(sdp->host, SD_DIF_TYPE0_PROTECTION)) {
+		dif = 0;
+		dix = 1;
+	}
+
+	if (!dif && !dix)
+		return snprintf(buf, 20, "none\n");
+
+	return snprintf(buf, 20, "%s%u\n", dix ? "dix" : "dif", dif);
+}
+
+static ssize_t
 sd_show_app_tag_own(struct device *dev, struct device_attribute *attr,
 		    char *buf)
 {
@@ -285,6 +307,7 @@ static struct device_attribute sd_disk_attrs[] = {
 	__ATTR(manage_start_stop, S_IRUGO|S_IWUSR, sd_show_manage_start_stop,
 	       sd_store_manage_start_stop),
 	__ATTR(protection_type, S_IRUGO, sd_show_protection_type, NULL),
+	__ATTR(protection_mode, S_IRUGO, sd_show_protection_mode, NULL),
 	__ATTR(app_tag_own, S_IRUGO, sd_show_app_tag_own, NULL),
 	__ATTR(thin_provisioning, S_IRUGO, sd_show_thin_provisioning, NULL),
 	__ATTR_NULL,
