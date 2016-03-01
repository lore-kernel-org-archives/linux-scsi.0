From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH][RESEND] scsi_sysfs: add 'is_bin_visible' callback
Date: Tue,  1 Mar 2016 05:52:25 +0100
Message-ID: <1456807945-88857-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbcCAEwc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 23:52:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add 'is_bin_visible' callback to blank out unsupported vpd pages.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_sysfs.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 00bc721..d8b275b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1023,6 +1023,28 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 	return attr->mode;
 }
 
+static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
+					     struct bin_attribute *attr, int i)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+
+	rcu_read_lock();
+	if (attr == &dev_attr_vpd_pg80 &&
+	    !rcu_dereference(sdev->vpd_pg80)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	if (attr == &dev_attr_vpd_pg83 &&
+	    !rcu_dereference(sdev->vpd_pg83)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
+	return S_IRUGO;
+}
+
 /* Default template for device attributes.  May NOT be modified */
 static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_device_blocked.attr,
@@ -1068,6 +1090,7 @@ static struct attribute_group scsi_sdev_attr_group = {
 	.attrs =	scsi_sdev_attrs,
 	.bin_attrs =	scsi_sdev_bin_attrs,
 	.is_visible =	scsi_sdev_attr_is_visible,
+	.is_bin_visible = scsi_sdev_bin_attr_is_visible,
 };
 
 static const struct attribute_group *scsi_sdev_attr_groups[] = {
-- 
2.6.2

