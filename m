From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH RESEND] scsi: Export SCSI Inquiry data to sysfs
Date: Fri, 30 Oct 2015 13:06:36 +0100
Message-ID: <1446206796-5146-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030907AbbJ3MGj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 08:06:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@odin.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

Export the RAW SCSI Inquiry to sysfs as binfile. This way the data can be used
by userland without the need to have and ioctl or use the sg_inq tool.

Here is an example of the provided data

linux:~ # hexdump /sys/class/scsi_device/1\:0\:0\:0/device/inquiry
0000000 8005 3205 001f 0000 4551 554d 2020 2020
0000010 4551 554d 4420 4456 522d 4d4f 2020 2020
0000020 2e32 2e33
0000024

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389..fdcf0ab 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -773,6 +773,29 @@ static struct bin_attribute dev_attr_vpd_##_page = {		\
 sdev_vpd_pg_attr(pg83);
 sdev_vpd_pg_attr(pg80);
 
+static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
+			    struct bin_attribute *bin_attr,
+			    char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	if (!sdev->inquiry)
+		return -EINVAL;
+
+	return memory_read_from_buffer(buf, count, &off, sdev->inquiry,
+				       sdev->inquiry_len);
+}
+
+static struct bin_attribute dev_attr_inquiry = {
+	.attr = {
+		.name = "inquiry",
+		.mode = S_IRUGO,
+	},
+	.size = 0,
+	.read = show_inquiry,
+};
+
 static ssize_t
 show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
 			char *buf)
@@ -957,6 +980,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 static struct bin_attribute *scsi_sdev_bin_attrs[] = {
 	&dev_attr_vpd_pg83,
 	&dev_attr_vpd_pg80,
+	&dev_attr_inquiry,
 	NULL
 };
 static struct attribute_group scsi_sdev_attr_group = {
-- 
2.6.2

