From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] scsi_sysfs: add 'is_bin_visible' callback
Date: Thu,  3 Mar 2016 07:41:24 +0100
Message-ID: <1456987284-78634-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbcCCGle (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Mar 2016 01:41:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add 'is_bin_visible' callback to blank out unsupported vpd pages.

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.com>

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 00bc721..7e57800 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1023,6 +1023,22 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 	return attr->mode;
 }
 
+static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
+					     struct bin_attribute *attr, int i)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+
+	if (attr == &dev_attr_vpd_pg80 && !sdev->vpd_pg80)
+		return 0;
+
+	if (attr == &dev_attr_vpd_pg83 && sdev->vpd_pg83)
+		return 0;
+
+	return S_IRUGO;
+}
+
 /* Default template for device attributes.  May NOT be modified */
 static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_device_blocked.attr,
@@ -1068,6 +1084,7 @@ static struct attribute_group scsi_sdev_attr_group = {
 	.attrs =	scsi_sdev_attrs,
 	.bin_attrs =	scsi_sdev_bin_attrs,
 	.is_visible =	scsi_sdev_attr_is_visible,
+	.is_bin_visible = scsi_sdev_bin_attr_is_visible,
 };
 
 static const struct attribute_group *scsi_sdev_attr_groups[] = {
