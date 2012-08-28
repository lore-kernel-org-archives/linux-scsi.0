From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/5] sd: Allow protection_type to be overridden
Date: Tue, 28 Aug 2012 14:29:34 -0400
Message-ID: <1346178577-28628-2-git-send-email-martin.petersen@oracle.com>
References: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:30802 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2H1SaG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 14:30:06 -0400
In-Reply-To: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

We have encountered a few devices that misbehaved when operating in T10
PI mode. Allow T10 PI protection type to be overridden from userland.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9f7fc39..e04c302 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -262,6 +262,28 @@ sd_show_protection_type(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+sd_store_protection_type(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	unsigned int val;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	err = kstrtouint(buf, 10, &val);
+
+	if (err)
+		return err;
+
+	if (val >= 0 && val <= SD_DIF_TYPE3_PROTECTION)
+		sdkp->protection_type = val;
+
+	return count;
+}
+
+static ssize_t
 sd_show_protection_mode(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
@@ -381,7 +403,8 @@ static struct device_attribute sd_disk_attrs[] = {
 	       sd_store_allow_restart),
 	__ATTR(manage_start_stop, S_IRUGO|S_IWUSR, sd_show_manage_start_stop,
 	       sd_store_manage_start_stop),
-	__ATTR(protection_type, S_IRUGO, sd_show_protection_type, NULL),
+	__ATTR(protection_type, S_IRUGO|S_IWUSR, sd_show_protection_type,
+	       sd_store_protection_type),
 	__ATTR(protection_mode, S_IRUGO, sd_show_protection_mode, NULL),
 	__ATTR(app_tag_own, S_IRUGO, sd_show_app_tag_own, NULL),
 	__ATTR(thin_provisioning, S_IRUGO, sd_show_thin_provisioning, NULL),
-- 
1.7.7.6

