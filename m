From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] osduld: Add osdname & systemid sysfs at scsi_osd class
Date: Wed, 24 Oct 2012 14:51:41 -0700
Message-ID: <508862ED.1070600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:41926 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161224Ab2JXVv5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2012 17:51:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>


This patch adds the support for the following two read-only sysfs attributes
to scsi_osd class members : osdname & systemid

These attributes will show up as below in sysfs class hierarchy:
/sys/class/scsi_osd/osdX/osdname
/sys/class/scsi_osd/osdX/systemid

The osdname & systemid are OSD device attributes which uniquely
identify a device on the network, while it's IP and certainly
it's /dev/osdX device path might change.
Userspace utilities (e.g. mkfs.exofs) can parse these attributes to
identify the correct OSD in safer and faster way.

(Today osd apps open each device in the system and send a
 attributes query for these, in order to access the user
 requested device)

Signed-off-by: Sachin Bhamare <sbhamare@panasas.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_uld.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index d4ed9eb..4375417 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -97,9 +97,37 @@ struct osd_dev_handle {
 
 static DEFINE_IDA(osd_minor_ida);
 
+/*
+ * scsi sysfs attribute operations
+ */
+static ssize_t osdname_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct osd_uld_device *ould = container_of(dev, struct osd_uld_device,
+						   class_dev);
+	return sprintf(buf, "%s\n", ould->odi.osdname);
+}
+
+static ssize_t systemid_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct osd_uld_device *ould = container_of(dev, struct osd_uld_device,
+						   class_dev);
+
+	memcpy(buf, ould->odi.systemid, ould->odi.systemid_len);
+	return ould->odi.systemid_len;
+}
+
+static struct device_attribute osd_uld_attrs[] = {
+	__ATTR(osdname, S_IRUGO, osdname_show, NULL),
+	__ATTR(systemid, S_IRUGO, systemid_show, NULL),
+	__ATTR_NULL,
+};
+
 static struct class osd_uld_class = {
 	.owner		= THIS_MODULE,
 	.name		= "scsi_osd",
+	.dev_attrs	= osd_uld_attrs,
 };
 
 /*
-- 
1.7.6.5

