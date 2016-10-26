From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Wed, 26 Oct 2016 11:44:51 -0700
Message-ID: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0046.outbound.protection.outlook.com ([104.47.38.46]:51836
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753064AbcJZSpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 14:45:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The solution I prefer is to modify the SCSI scanning code such that
the scan_mutex is only held while performing the actual LUN scanning
and while ensuring that no SCSI device has been created yet for a
certain LUN number but not while the Linux device and its sysfs
attributes are created. Since that approach would require extensive
changes in the SCSI scanning code, another approach has been chosen,
namely to make self-removal asynchronous. This patch avoids that
self-removal triggers the following deadlock:

======================================================
[ INFO: possible circular locking dependency detected ]
4.9.0-rc1-dbg+ #4 Not tainted
-------------------------------------------------------
test_02_sdev_de/12586 is trying to acquire lock:
 (&shost->scan_mutex){+.+.+.}, at: [<ffffffff8148cc5e>] scsi_remove_device+0x1e/0x40
but task is already holding lock:
 (s_active#336){++++.+}, at: [<ffffffff812633fe>] kernfs_remove_self+0xde/0x140
which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:
-> #1 (s_active#336){++++.+}:
[<ffffffff810bd8b9>] lock_acquire+0xe9/0x1d0
[<ffffffff8126275a>] __kernfs_remove+0x24a/0x310
[<ffffffff812634a0>] kernfs_remove_by_name_ns+0x40/0x90
[<ffffffff81265cc0>] remove_files.isra.1+0x30/0x70
[<ffffffff8126605f>] sysfs_remove_group+0x3f/0x90
[<ffffffff81266159>] sysfs_remove_groups+0x29/0x40
[<ffffffff81450689>] device_remove_attrs+0x59/0x80
[<ffffffff81450f75>] device_del+0x125/0x240
[<ffffffff8148cc03>] __scsi_remove_device+0x143/0x180
[<ffffffff8148ae24>] scsi_forget_host+0x64/0x70
[<ffffffff8147e3f5>] scsi_remove_host+0x75/0x120
[<ffffffffa035dbbb>] 0xffffffffa035dbbb
[<ffffffff81082a65>] process_one_work+0x1f5/0x690
[<ffffffff81082f49>] worker_thread+0x49/0x490
[<ffffffff810897eb>] kthread+0xeb/0x110
[<ffffffff8163ef07>] ret_from_fork+0x27/0x40

-> #0 (&shost->scan_mutex){+.+.+.}:
[<ffffffff810bd31c>] __lock_acquire+0x10fc/0x1270
[<ffffffff810bd8b9>] lock_acquire+0xe9/0x1d0
[<ffffffff8163a49f>] mutex_lock_nested+0x5f/0x360
[<ffffffff8148cc5e>] scsi_remove_device+0x1e/0x40
[<ffffffff8148cca2>] sdev_store_delete+0x22/0x30
[<ffffffff814503a3>] dev_attr_store+0x13/0x20
[<ffffffff81264d60>] sysfs_kf_write+0x40/0x50
[<ffffffff812640c7>] kernfs_fop_write+0x137/0x1c0
[<ffffffff811dd9b3>] __vfs_write+0x23/0x140
[<ffffffff811de080>] vfs_write+0xb0/0x190
[<ffffffff811df374>] SyS_write+0x44/0xa0
[<ffffffff8163ecaa>] entry_SYSCALL_64_fastpath+0x18/0xad

other info that might help us debug this:

 Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(s_active#336);
                               lock(&shost->scan_mutex);
                               lock(s_active#336);
  lock(&shost->scan_mutex);

 *** DEADLOCK ***
3 locks held by test_02_sdev_de/12586:
 #0:  (sb_writers#4){.+.+.+}, at: [<ffffffff811de148>] vfs_write+0x178/0x190
 #1:  (&of->mutex){+.+.+.}, at: [<ffffffff81264091>] kernfs_fop_write+0x101/0x1c0
 #2:  (s_active#336){++++.+}, at: [<ffffffff812633fe>] kernfs_remove_self+0xde/0x140

stack backtrace:
CPU: 4 PID: 12586 Comm: test_02_sdev_de Not tainted 4.9.0-rc1-dbg+ #4
Call Trace:
 [<ffffffff813296c5>] dump_stack+0x68/0x93
 [<ffffffff810baafe>] print_circular_bug+0x1be/0x210
 [<ffffffff810bd31c>] __lock_acquire+0x10fc/0x1270
 [<ffffffff810bd8b9>] lock_acquire+0xe9/0x1d0
 [<ffffffff8163a49f>] mutex_lock_nested+0x5f/0x360
 [<ffffffff8148cc5e>] scsi_remove_device+0x1e/0x40
 [<ffffffff8148cca2>] sdev_store_delete+0x22/0x30
 [<ffffffff814503a3>] dev_attr_store+0x13/0x20
 [<ffffffff81264d60>] sysfs_kf_write+0x40/0x50
 [<ffffffff812640c7>] kernfs_fop_write+0x137/0x1c0
 [<ffffffff811dd9b3>] __vfs_write+0x23/0x140
 [<ffffffff811de080>] vfs_write+0xb0/0x190
 [<ffffffff811df374>] SyS_write+0x44/0xa0
 [<ffffffff8163ecaa>] entry_SYSCALL_64_fastpath+0x18/0xad

References: http://www.spinics.net/lists/linux-scsi/msg86551.html
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_priv.h   |  1 +
 drivers/scsi/scsi_scan.c   |  1 +
 drivers/scsi/scsi_sysfs.c  | 19 ++++++++++++++++++-
 include/scsi/scsi_device.h |  2 ++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 77bf611..66646c7 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -142,6 +142,7 @@ extern void scsi_sysfs_device_initialize(struct scsi_device *);
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
+extern void scsi_remove_device_work(struct work_struct *work);
 
 extern struct bus_type scsi_bus_type;
 extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6f7128f..2b11061 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -241,6 +241,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	mutex_init(&sdev->inquiry_mutex);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
+	INIT_WORK(&sdev->remove_work, scsi_remove_device_work);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0af9c91..d5a7a92 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -705,12 +705,20 @@ store_rescan_field (struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
+static void scsi_remove_device_async(struct scsi_device *sdev)
+{
+	if (scsi_device_get(sdev) < 0)
+		return;
+	if (!schedule_work(&sdev->remove_work))
+		scsi_device_put(sdev);
+}
+
 static ssize_t
 sdev_store_delete(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
 	if (device_remove_file_self(dev, attr))
-		scsi_remove_device(to_scsi_device(dev));
+		scsi_remove_device_async(to_scsi_device(dev));
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
@@ -1327,6 +1335,15 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	put_device(dev);
 }
 
+void scsi_remove_device_work(struct work_struct *work)
+{
+	struct scsi_device *sdev = container_of(work, typeof(*sdev),
+						remove_work);
+
+	scsi_remove_device(sdev);
+	scsi_device_put(sdev);
+}
+
 /**
  * scsi_remove_device - unregister a device from the scsi bus
  * @sdev:	scsi_device to unregister
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 840030a..dd43d79 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -203,6 +203,8 @@ struct scsi_device {
 	struct execute_work	ew; /* used to get process context on put */
 	struct work_struct	requeue_work;
 
+	struct work_struct	remove_work;
+
 	struct scsi_device_handler *handler;
 	void			*handler_data;
 
-- 
2.10.1

