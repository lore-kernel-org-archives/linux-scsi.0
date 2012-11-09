From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v9 07/10] block: add a new interface to block events
Date: Fri,  9 Nov 2012 14:51:59 +0800
Message-ID: <1352443922-13734-8-git-send-email-aaron.lu@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

A new interface to block disk events is added, this interface is
meant to eliminate a race between PM runtime callback and disk events
checking.

Suppose the following device tree:
device_sata_port  (the parent)
  device_ODD      (the child)

When ODD is runtime suspended, sata port will have a chance to enter
runtime suspended state. And in sata port's runtime suspend callback,
it will check if it is OK to omit the power of the ODD. And if yes, the
periodically running events checking work will be stopped, as the ODD
will be waken up by that check and cancel it can make the ODD stay in
zero power state much longer(no worry about how the ODD gets media
change event in ZPODD's case).

I used disk_block_events to do the events blocking, but there is a race
and can lead to a deadlock: when I call disk_block_events in sata port's
runtime suspend callback, the events checking work may already be running
and it will resume the ODD synchronously, and PM core will try to resume
its parent, the sata port first. The PM core makes sure that runtime
resume callback does not run concurrently with runtime suspend callback,
and if the runtime suspend callback is running, the runtime resume
callback will wait for it done. So the events checking work will wait
for sata port's runtime suspend callback, while the sata port's runtime
suspend callback is waiting for the disk events work to finish. Deadlock.

ODD_suspend                        disk_events_workfn
  ata_port_suspend                   check_events
    disk_block_events                  resume ODD
      cancel_delayed_work_sync           resume parent
      (waiting for disk_events_workfn)   (waiting for suspend callback)

So a new function disk_try_block_events is added, it will try to
cancel the delayed work if it is pending. If succeed, disk_block_events
will be called and we are done; if failed, false is returned without
doing anything. In this way, the race can be avoided.

The newly added interface and the disk_unblock_events are exported, as
sr driver will need to use them to block/unblock disk events.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 block/genhd.c         | 26 ++++++++++++++++++++++++++
 include/linux/genhd.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 6cace66..8632fd3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1469,6 +1469,31 @@ void disk_block_events(struct gendisk *disk)
 	mutex_unlock(&ev->block_mutex);
 }
 
+/*
+ * Under some circumstances, there is a race between the calling thread
+ * of disk_block_events and the events checking function. To avoid such a race,
+ * this function will check if the delayed work is pending. If not, it means
+ * the work is either not queued or is already running, false is returned.
+ * And if yes, try to cancel the delayed work. If succedded, disk_block_events
+ * will be called and there is no worry that cancel_delayed_work_sync will
+ * deadlock the events checking function. And if failed, false is returned.
+ */
+bool disk_try_block_events(struct gendisk *disk)
+{
+	struct disk_events *ev = disk->ev;
+
+	if (!ev)
+		return false;
+
+	if (cancel_delayed_work(&disk->ev->dwork)) {
+		disk_block_events(disk);
+		return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(disk_try_block_events);
+
 static void __disk_unblock_events(struct gendisk *disk, bool check_now)
 {
 	struct disk_events *ev = disk->ev;
@@ -1512,6 +1537,7 @@ void disk_unblock_events(struct gendisk *disk)
 	if (disk->ev)
 		__disk_unblock_events(disk, false);
 }
+EXPORT_SYMBOL(disk_unblock_events);
 
 /**
  * disk_flush_events - schedule immediate event checking and flushing
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 4f440b3..b67247f 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -420,6 +420,7 @@ static inline int get_disk_ro(struct gendisk *disk)
 }
 
 extern void disk_block_events(struct gendisk *disk);
+extern bool disk_try_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
 extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
-- 
1.7.12.4

