From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/18] scsi: export 'wwid' to sysfs
Date: Tue,  1 Dec 2015 10:16:56 +0100
Message-ID: <1448961418-29013-17-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbbLAJRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:12 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Use scsi_vpd_lun_id() to export the world-wide unique id (wwid) to sysfs.
Note that this is the 'best' wwid according to the rules in
scsi_vpd_lun_id(), not every possible wwid presented by the drive.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d015374..ef36053 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -905,6 +905,22 @@ sdev_show_function(queue_depth, "%d\n");
 static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
 		   sdev_store_queue_depth);
 
+static ssize_t
+sdev_show_wwid(struct device *dev, struct device_attribute *attr,
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
+static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
+
 #ifdef CONFIG_SCSI_DH
 static ssize_t
 sdev_show_dh_state(struct device *dev, struct device_attribute *attr,
@@ -1028,6 +1044,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_modalias.attr,
 	&dev_attr_queue_depth.attr,
 	&dev_attr_queue_type.attr,
+	&dev_attr_wwid.attr,
 #ifdef CONFIG_SCSI_DH
 	&dev_attr_dh_state.attr,
 #endif
-- 
1.8.5.6

