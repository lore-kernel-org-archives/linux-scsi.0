From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v2 7/7] block: genhd: add an interface to set disk's poll interval
Date: Tue, 24 Jul 2012 17:37:45 +0800
Message-ID: <1343122665-18711-8-git-send-email-aaron.lu@amd.com>
References: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Wu <jeff.wu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

Set the ODD's in kernel poll interval to 2s for the user in case the
user is using an old distro on which udev will not set the system wide
block parameter events_dfl_poll_msecs.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 block/genhd.c         | 23 +++++++++++++++++------
 drivers/scsi/sr.c     |  1 +
 include/linux/genhd.h |  1 +
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index bdb3682..de9b9d9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1619,6 +1619,19 @@ static void disk_events_workfn(struct work_struct *work)
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
@@ -1675,16 +1688,14 @@ static ssize_t disk_events_poll_msecs_store(struct device *dev,
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
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 466ff8e..d0c3084 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -863,6 +863,7 @@ static int sr_probe(struct device *dev)
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
+	disk_events_set_poll_msecs(disk, 2000);
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 017a7fb..7414fb5 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -418,6 +418,7 @@ extern void disk_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
 extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
+extern int disk_events_set_poll_msecs(struct gendisk *disk, long intv);
 
 /* drivers/char/random.c */
 extern void add_disk_randomness(struct gendisk *disk);
-- 
1.7.11.3
