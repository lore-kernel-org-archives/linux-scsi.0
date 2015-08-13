From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: Export SCSI Inquiry data to sysfs
Date: Thu, 13 Aug 2015 13:50:08 +0200
Message-ID: <1439466608-31577-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Export the RAW SCSI Inquiry to sysfs as binfile. This way the data can be
used by userlang without the need to have and ioctl or use the sg_inq tool.

Here is an example of the provided data

linux:~ # hexdump /sys/class/scsi_device/1\:0\:0\:0/device/inquiry
0000000 8005 3205 001f 0000 4551 554d 2020 2020
0000010 4551 554d 4420 4456 522d 4d4f 2020 2020
0000020 2e32 2e33
0000024

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9ad4116..5ecb65d 100644
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
2.5.0
