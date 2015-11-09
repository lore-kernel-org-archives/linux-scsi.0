From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/18] scsi: export 'device_id' to sysfs
Date: Mon,  9 Nov 2015 16:08:21 +0100
Message-ID: <1447081703-110552-17-git-send-email-hare@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbbKIPI3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 10:08:29 -0500
In-Reply-To: <1447081703-110552-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Use scsi_vpd_lun_id() to export the device id to sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7b41b2c..aaa38c2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -903,6 +903,22 @@ sdev_show_function(queue_depth, "%d\n");
 static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
 		   sdev_store_queue_depth);
 
+static ssize_t
+sdev_show_device_id(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t count;
+
+	count = scsi_vpd_lun_id(sdev, buf, PAGE_SIZE);
+	if (count > 0) {
+		buf[count] = '\n';
+		count++;
+	}
+	return count;
+}
+static DEVICE_ATTR(device_id, S_IRUGO, sdev_show_device_id, NULL);
+
 #ifdef CONFIG_SCSI_DH
 static ssize_t
 sdev_show_dh_state(struct device *dev, struct device_attribute *attr,
@@ -1026,6 +1042,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_modalias.attr,
 	&dev_attr_queue_depth.attr,
 	&dev_attr_queue_type.attr,
+	&dev_attr_device_id.attr,
 #ifdef CONFIG_SCSI_DH
 	&dev_attr_dh_state.attr,
 #endif
-- 
1.8.5.6

