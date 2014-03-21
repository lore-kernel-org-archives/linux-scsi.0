From: Andrey Zonov <andrey.zonov@gmail.com>
Subject: SCSI: race condition between scsi_remove_target and scsi_probe_and_add_lun
Date: Thu, 20 Mar 2014 22:12:17 -0700
Message-ID: <532BCA31.20902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37853 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaCUFMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Mar 2014 01:12:20 -0400
Received: by mail-pd0-f180.google.com with SMTP id v10so1878520pde.25
        for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2014 22:12:19 -0700 (PDT)
Received: from zont-osx.local (c-50-136-243-235.hsd1.ca.comcast.net. [50.136.243.235])
        by mx.google.com with ESMTPSA id xk3sm7336819pbb.65.2014.03.20.22.12.18
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 20 Mar 2014 22:12:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I've got kernel panic on my box which works as FibreChannel initiator.
I was able to reproduce this panic by setting dev_loss_tmo=2 and
enabling/disabling ports every 5 seconds on the switch in 5 minutes.  I
added some debug points in the kernel code and that's what I've got so far:

1. system is inserting new device into __devices list

DEBUG: scsi_sysfs_device_initialize(): sdev=ffff88046a931000 7:0:5:0
Pid: 910, comm: kworker/u:2 Tainted: P           O 3.2.48-swt9004 #33
Call Trace:
[<ffffffff81245c42>] ? scsi_alloc_sdev+0x1d2/0x240
[<ffffffff8123d4bd>] ? scsi_device_lookup_by_target+0x8d/0xc0
[<ffffffff8124623a>] ? scsi_probe_and_add_lun+0x42a/0xb20
[<ffffffff811acb7d>] ? kobject_set_name_vargs+0x6d/0x80
[<ffffffff81230b4f>] ? dev_set_name+0x3f/0x50
[<ffffffff811ac782>] ? kobject_get+0x12/0x20
[<ffffffffa000b3e4>] ? fc_host_match+0x14/0x70 [scsi_transport_fc]
[<ffffffff8123726f>] ? attribute_container_add_device+0x4f/0x160
[<ffffffff811ac782>] ? kobject_get+0x12/0x20
[<ffffffff812304e4>] ? get_device+0x14/0x20
[<ffffffff812459c5>] ? scsi_alloc_target+0x295/0x2d0
[<ffffffff81230bca>] ? device_release+0x1a/0x80
[<ffffffff81246bce>] ? __scsi_scan_target+0xce/0x5f0
[<ffffffff8102ec22>] ? dequeue_task_fair+0x52/0x150
[<ffffffff8139a91d>] ? __schedule+0x25d/0x7d0
[<ffffffff812477b6>] ? scsi_scan_target+0xc6/0xe0
[<ffffffffa000e75f>] ? fc_scsi_scan_rport+0xaf/0xc0 [scsi_transport_fc]
[<ffffffff8104eb06>] ? process_one_work+0x116/0x3a0
[<ffffffff8104f1ec>] ? worker_thread+0x14c/0x400
[<ffffffff8104f0a0>] ? rescuer_thread+0x310/0x310
[<ffffffff8104f0a0>] ? rescuer_thread+0x310/0x310
[<ffffffff81052f06>] ? kthread+0x96/0xa0
[<ffffffff8139f134>] ? kernel_thread_helper+0x4/0x10
[<ffffffff81052e70>] ? kthread_worker_fn+0x120/0x120
[<ffffffff8139f130>] ? gs_change+0xb/0xb

2. later in scsi_probe_and_add_lun() this device is removing

DEBUG: __scsi_remove_device(): sdev=ffff88046a931000 7:0:5:0
Pid: 910, comm: kworker/u:2 Tainted: P           O 3.2.48-swt9004 #33
Call Trace:
[<ffffffff81248c66>] ? __scsi_remove_device+0x46/0x110
[<ffffffff81246268>] ? scsi_probe_and_add_lun+0x458/0xb20
[<ffffffff81230b4f>] ? dev_set_name+0x3f/0x50
[<ffffffff811ac782>] ? kobject_get+0x12/0x20
[<ffffffff812459c5>] ? scsi_alloc_target+0x295/0x2d0
[<ffffffff81230bca>] ? device_release+0x1a/0x80
[<ffffffff81246bce>] ? __scsi_scan_target+0xce/0x5f0
[<ffffffff8102ec22>] ? dequeue_task_fair+0x52/0x150
[<ffffffff8139a91d>] ? __schedule+0x25d/0x7d0
[<ffffffff812477b6>] ? scsi_scan_target+0xc6/0xe0
[<ffffffffa000e75f>] ? fc_scsi_scan_rport+0xaf/0xc0 [scsi_transport_fc]
[<ffffffff8104eb06>] ? process_one_work+0x116/0x3a0
[<ffffffff8104f1ec>] ? worker_thread+0x14c/0x400
[<ffffffff8104f0a0>] ? rescuer_thread+0x310/0x310
[<ffffffff8104f0a0>] ? rescuer_thread+0x310/0x310
[<ffffffff81052f06>] ? kthread+0x96/0xa0
[<ffffffff8139f134>] ? kernel_thread_helper+0x4/0x10
[<ffffffff81052e70>] ? kthread_worker_fn+0x120/0x120
[<ffffffff8139f130>] ? gs_change+0xb/0xb

3. another thread is trying to remove this device because of timeout

DEBUG: __scsi_remove_device(): sdev=ffff88046a931000 7:0:5:0
Pid: 4, comm: kworker/0:0 Tainted: P           O 3.2.48-swt9004 #33
Call Trace:
[<ffffffff81248c66>] ? __scsi_remove_device+0x46/0x110
[<ffffffff8139b63a>] ? mutex_lock+0x1a/0x40
[<ffffffff81248d58>] ? scsi_remove_device+0x28/0x40
[<ffffffff81242a00>] ? scsi_kmap_atomic_sg+0x180/0x180
[<ffffffff81248ed1>] ? scsi_remove_target+0x141/0x1e0
[<ffffffff8104eb06>] ? process_one_work+0x116/0x3a0
[<ffffffff8104f1ec>] ? worker_thread+0x14c/0x400
[<ffffffff8104f0a0>] ? rescuer_thread+0x310/0x310
[<ffffffff8104f0a0>] ? rescuer_thread+0x310/0x310
[<ffffffff81052f06>] ? kthread+0x96/0xa0
[<ffffffff8139f134>] ? kernel_thread_helper+0x4/0x10
[<ffffffff81052e70>] ? kthread_worker_fn+0x120/0x120
[<ffffffff8139f130>] ? gs_change+0xb/0xb

and it's got dead sdev object.  I don't understand how this can happen
because __scsi_remove_target() iterating over __devices and getting sdev
reference under host_lock and that should be enough.

DEBUG: kref_put(): kref=ffff88046a9312e0 val=-1
------------[ cut here ]------------
WARNING: at lib/kref.c:61 kref_put+0x88/0xc0()
Hardware name: X9DRi-LN4+/X9DR3-LN4+
Modules linked in: qla2xxx(O) igb ehci_hcd scsi_transport_fc
Pid: 4, comm: kworker/0:0 Tainted: P           O 3.2.48-swt9004 #33
Call Trace:
[<ffffffff81037bfb>] ? warn_slowpath_common+0x7b/0xc0
[<ffffffff811ac6c0>] ? kobject_del+0x30/0x30
[<ffffffff811adb08>] ? kref_put+0x88/0xc0
[<ffffffff81248cac>] ? __scsi_remove_device+0x8c/0x110
[<ffffffff8139b63a>] ? mutex_lock+0x1a/0x40
[<ffffffff81248d58>] ? scsi_remove_device+0x28/0x40
[<ffffffff81242a00>] ? scsi_kmap_atomic_sg+0x180/0x180
[<ffffffff81248ed1>] ? scsi_remove_target+0x141/0x1e0
[<ffffffff8104eb06>] ? process_one_work+0x116/0x3a0
[<ffffffff8104f1ec>] ? worker_thread+0x14c/0x400
[<ffffffff8104f0a0>] ? rescuer_thread+0x310/0x310
[<ffffffff8104f0a0>] ? rescuer_thread+0x310/0x310
[<ffffffff81052f06>] ? kthread+0x96/0xa0
[<ffffffff8139f134>] ? kernel_thread_helper+0x4/0x10
[<ffffffff81052e70>] ? kthread_worker_fn+0x120/0x120
[<ffffffff8139f130>] ? gs_change+0xb/0xb

Here is the patch which helped me:

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9117d0b..676e5ff 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1094,6 +1094,7 @@ static void __scsi_remove_target(struct
scsi_target *starget)
        unsigned long flags;
        struct scsi_device *sdev;

+       mutex_lock(&shost->scan_mutex);
        spin_lock_irqsave(shost->host_lock, flags);
  restart:
        list_for_each_entry(sdev, &shost->__devices, siblings) {
@@ -1102,12 +1103,13 @@ static void __scsi_remove_target(struct
scsi_target *starget)
                    scsi_device_get(sdev))
                        continue;
                spin_unlock_irqrestore(shost->host_lock, flags);
-               scsi_remove_device(sdev);
+               __scsi_remove_device(sdev);
                scsi_device_put(sdev);
                spin_lock_irqsave(shost->host_lock, flags);
                goto restart;
        }
        spin_unlock_irqrestore(shost->host_lock, flags);
+       mutex_unlock(&shost->scan_mutex);
 }

 /**

I'm not sure about the fix is correct, but I was not able to reproduce
the panic.


P.S. Here is another patch which help to detect reference count underflow

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 484604d..05dd2b3 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -68,9 +68,13 @@ static inline void kref_get(struct kref *kref)
 static inline int kref_sub(struct kref *kref, unsigned int count,
             void (*release)(struct kref *kref))
 {
+       long refs;
+
        WARN_ON(release == NULL);

-       if (atomic_sub_and_test((int) count, &kref->refcount)) {
+       refs = atomic_sub_return((int) count, &kref->refcount);
+       WARN_ON(refs < 0);
+       if (refs == 0) {
                release(kref);
                return 1;
        }

-- 
Andrey Zonov
