From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH, RESEND] Avoid that SCSI device removal through sysfs triggers a deadlock
Date: Wed, 25 Jul 2018 10:38:28 -0700
Message-ID: <20180725173828.2227-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch avoids that self-removal triggers the following deadlock:

======================================================
WARNING: possible circular locking dependency detected
4.18.0-rc2-dbg+ #5 Not tainted
------------------------------------------------------
modprobe/6539 is trying to acquire lock:
000000008323c4cd (kn->count#202){++++}, at: kernfs_remove_by_name_ns+0x45/0x90

but task is already holding lock:
00000000a6ec2c69 (&shost->scan_mutex){+.+.}, at: scsi_remove_host+0x21/0x150 [scsi_mod]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&shost->scan_mutex){+.+.}:
       __mutex_lock+0xfe/0xc70
       mutex_lock_nested+0x1b/0x20
       scsi_remove_device+0x26/0x40 [scsi_mod]
       sdev_store_delete+0x27/0x30 [scsi_mod]
       dev_attr_store+0x3e/0x50
       sysfs_kf_write+0x87/0xa0
       kernfs_fop_write+0x190/0x230
       __vfs_write+0xd2/0x3b0
       vfs_write+0x101/0x270
       ksys_write+0xab/0x120
       __x64_sys_write+0x43/0x50
       do_syscall_64+0x77/0x230
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (kn->count#202){++++}:
       lock_acquire+0xd2/0x260
       __kernfs_remove+0x424/0x4a0
       kernfs_remove_by_name_ns+0x45/0x90
       remove_files.isra.1+0x3a/0x90
       sysfs_remove_group+0x5c/0xc0
       sysfs_remove_groups+0x39/0x60
       device_remove_attrs+0x82/0xb0
       device_del+0x251/0x580
       __scsi_remove_device+0x19f/0x1d0 [scsi_mod]
       scsi_forget_host+0x37/0xb0 [scsi_mod]
       scsi_remove_host+0x9b/0x150 [scsi_mod]
       sdebug_driver_remove+0x4b/0x150 [scsi_debug]
       device_release_driver_internal+0x241/0x360
       device_release_driver+0x12/0x20
       bus_remove_device+0x1bc/0x290
       device_del+0x259/0x580
       device_unregister+0x1a/0x70
       sdebug_remove_adapter+0x8b/0xf0 [scsi_debug]
       scsi_debug_exit+0x76/0xe8 [scsi_debug]
       __x64_sys_delete_module+0x1c1/0x280
       do_syscall_64+0x77/0x230
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&shost->scan_mutex);
                               lock(kn->count#202);
                               lock(&shost->scan_mutex);
  lock(kn->count#202);

 *** DEADLOCK ***

2 locks held by modprobe/6539:
 #0: 00000000efaf9298 (&dev->mutex){....}, at: device_release_driver_internal+0x68/0x360
 #1: 00000000a6ec2c69 (&shost->scan_mutex){+.+.}, at: scsi_remove_host+0x21/0x150 [scsi_mod]

stack backtrace:
CPU: 10 PID: 6539 Comm: modprobe Not tainted 4.18.0-rc2-dbg+ #5
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
Call Trace:
 dump_stack+0xa4/0xf5
 print_circular_bug.isra.34+0x213/0x221
 __lock_acquire+0x1a7e/0x1b50
 lock_acquire+0xd2/0x260
 __kernfs_remove+0x424/0x4a0
 kernfs_remove_by_name_ns+0x45/0x90
 remove_files.isra.1+0x3a/0x90
 sysfs_remove_group+0x5c/0xc0
 sysfs_remove_groups+0x39/0x60
 device_remove_attrs+0x82/0xb0
 device_del+0x251/0x580
 __scsi_remove_device+0x19f/0x1d0 [scsi_mod]
 scsi_forget_host+0x37/0xb0 [scsi_mod]
 scsi_remove_host+0x9b/0x150 [scsi_mod]
 sdebug_driver_remove+0x4b/0x150 [scsi_debug]
 device_release_driver_internal+0x241/0x360
 device_release_driver+0x12/0x20
 bus_remove_device+0x1bc/0x290
 device_del+0x259/0x580
 device_unregister+0x1a/0x70
 sdebug_remove_adapter+0x8b/0xf0 [scsi_debug]
 scsi_debug_exit+0x76/0xe8 [scsi_debug]
 __x64_sys_delete_module+0x1c1/0x280
 do_syscall_64+0x77/0x230
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

See also https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg54525.html.

Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Fixes: ac0ece9174ac ("scsi: use device_remove_file_self() instead of device_schedule_callback()")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 48 +++++++++++++++++++++++++++++++++++----
 kernel/task_work.c        |  1 +
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index de122354d09a..c43f645900d4 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
+#include <linux/task_work.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -718,14 +719,53 @@ store_rescan_field (struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
+struct remove_dev_work {
+	struct callback_head	head;
+	struct scsi_device	*sdev;
+};
+
+static void delete_sdev(struct callback_head *head)
+{
+	struct remove_dev_work *work = container_of(head, typeof(*work), head);
+	struct scsi_device *sdev = work->sdev;
+
+	scsi_remove_device(sdev);
+	kfree(work);
+	scsi_device_put(sdev);
+}
+
 static ssize_t
 sdev_store_delete(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	if (device_remove_file_self(dev, attr))
-		scsi_remove_device(to_scsi_device(dev));
-	return count;
-};
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct remove_dev_work *work;
+	int ret;
+
+	ret = scsi_device_get(sdev);
+	if (ret < 0)
+		goto out;
+	ret = -ENOMEM;
+	work = kmalloc(sizeof(*work), GFP_KERNEL);
+	if (!work)
+		goto put;
+	work->head.func = delete_sdev;
+	work->sdev = sdev;
+	ret = task_work_add(current, &work->head, false);
+	if (ret < 0)
+		goto free;
+	ret = count;
+
+out:
+	return ret;
+
+free:
+	kfree(work);
+
+put:
+	scsi_device_put(sdev);
+	goto out;
+}
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
 
 static ssize_t
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 0fef395662a6..75dc496b9997 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -40,6 +40,7 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 		set_notify_resume(task);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(task_work_add);
 
 /**
  * task_work_cancel - cancel a pending work added by task_work_add()
-- 
2.18.0
