From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] scsi: Export blacklist flags to sysfs
Date: Tue,  8 Aug 2017 16:36:57 +0200
Message-ID: <1502203017-101403-5-git-send-email-hare@suse.de>
References: <1502203017-101403-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60627 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752526AbdHHOhE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 10:37:04 -0400
In-Reply-To: <1502203017-101403-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Each scsi device is scanned according to the found blacklist flags,
but this information is never presented to sysfs.
This makes it quite hard to figure out if blacklisting worked as
expected.
With this patch we're exporting an additional attribute 'blacklist'
containing the blacklist flags for this device.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_scan.c  |  1 +
 drivers/scsi/scsi_sysfs.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3832ba5..e4e4374 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -984,6 +984,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		scsi_attach_vpd(sdev);
 
 	sdev->max_queue_depth = sdev->queue_depth;
+	sdev->sdev_bflags = *bflags;
 
 	/*
 	 * Ok, the device is now all set up, we can
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5e8ace2..37d436b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -953,6 +953,16 @@ static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
 }
 static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
 
+static ssize_t
+sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return snprintf (buf, 20, "0x%x\n", sdev->sdev_bflags);
+}
+static DEVICE_ATTR(blacklist, S_IRUGO, sdev_show_blacklist, NULL);
+
 #ifdef CONFIG_SCSI_DH
 static ssize_t
 sdev_show_dh_state(struct device *dev, struct device_attribute *attr,
@@ -1138,6 +1148,7 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
 	&dev_attr_queue_depth.attr,
 	&dev_attr_queue_type.attr,
 	&dev_attr_wwid.attr,
+	&dev_attr_blacklist.attr,
 #ifdef CONFIG_SCSI_DH
 	&dev_attr_dh_state.attr,
 	&dev_attr_access_state.attr,
-- 
1.8.5.6
