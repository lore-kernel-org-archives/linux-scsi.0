From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v7 1/6] block: genhd: add an interface to set disk poll interval
Date: Wed, 12 Sep 2012 16:29:52 +0800
Message-ID: <1347438597-5903-2-git-send-email-aaron.lu@intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab2ILIaH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Sep 2012 04:30:07 -0400
In-Reply-To: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 block/genhd.c         | 23 +++++++++++++++++------
 include/linux/genhd.h |  1 +
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index cac7366..4244256 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1627,6 +1627,19 @@ static void disk_events_workfn(struct work_struct *work)
 		kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
 }
 
+int disk_events_set_poll_msecs(struct gendisk *disk, long intv)
+{
+	if (intv < 0 && intv != -1)
+		return -EINVAL;
+
+	disk_block_events(disk);
+	disk->ev->poll_msecs = intv;
+	__disk_unblock_events(disk, true);
+
+	return 0;
+}
+EXPORT_SYMBOL(disk_events_set_poll_msecs);
+
 /*
  * A disk events enabled device has the following sysfs nodes under
  * its /sys/block/X/ directory.
@@ -1683,16 +1696,14 @@ static ssize_t disk_events_poll_msecs_store(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	long intv;
+	int ret;
 
 	if (!count || !sscanf(buf, "%ld", &intv))
 		return -EINVAL;
 
-	if (intv < 0 && intv != -1)
-		return -EINVAL;
-
-	disk_block_events(disk);
-	disk->ev->poll_msecs = intv;
-	__disk_unblock_events(disk, true);
+	ret = disk_events_set_poll_msecs(disk, intv);
+	if (ret)
+		return ret;
 
 	return count;
 }
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 4f440b3..63409e5 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -423,6 +423,7 @@ extern void disk_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
 extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
+extern int disk_events_set_poll_msecs(struct gendisk *disk, long intv);
 
 /* drivers/char/random.c */
 extern void add_disk_randomness(struct gendisk *disk);
-- 
1.7.12.21.g871e293

