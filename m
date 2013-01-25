From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH v3] mpt2sas/mpt3sas: prevent double free on error path
Date: Fri, 25 Jan 2013 14:20:39 -0500
Message-ID: <20130125192039.GE22141@logfs.org>
References: <20130123212033.GA15800@logfs.org>
 <87k3r310jr.fsf@nemi.mork.no>
 <20130125171255.GA22141@logfs.org>
 <20130125180044.GC22141@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:58397 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3AYUmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jan 2013 15:42:37 -0500
Content-Disposition: inline
In-Reply-To: <20130125180044.GC22141@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Changes since v1:
- Adds another missing put_sas_device to _scsih_probe_boot_devices,
  proving the need for more coffee before sending out patches.

I noticed this one when list_del was called with poisoned list
pointers, but the real problem is a double-free (and a use-after-free
just before that).

Both _scsih_probe_boot_devices() and _scsih_sas_device_add() put the
sas_device onto a list, thereby giving up control.  Next they call
mpt2sas_transport_port_add() and will list_del and free the object on
errors.  If some other function already did the list_del and free, it
will happen again.

This patch adds reference counting to prevent the double free.  One
reference count goes to the caller of mpt2sas_transport_port_add(), the
second to the list.  Whoever removes the object from the list gets to
drop one reference count.  _scsih_probe_boot_devices() and
_scsih_sas_device_add() get a second reference count to ensure the
object is not freed while they are still accessing it.

To prevent the double list_del(), I changed the code to list_del_init()
and added a list_empty() check before that.  Since the
list_empty/list_del_init is always called under a lock, this should be
safe.

I hate the complexity this patch adds, but see no alternative to it.

mpt2sas0: failure at drivers/scsi/mpt2sas/mpt2sas_transport.c:708/mpt2sas_transport_port_add()!
general protection fault: 0000 [#1] SMP
CPU 9
Pid: 3097, comm: kworker/u:11 Tainted: G        W  O 3.6.10+ #31392.trunk    /0JP31P
RIP: 0010:[<ffffffffa0309744>]  [<ffffffffa0309744>] _scsih_sas_device_remove+0x54/0x90 [mpt2sas]
RSP: 0018:ffff881fed4d7ab0  EFLAGS: 00010046
RAX: dead000000200200 RBX: ffff881ff6a5cd88 RCX: 00000000000010e8
RDX: ffff881ff7dab800 RSI: ffff881ff7daba00 RDI: dead000000100100
RBP: ffff881fed4d7ad0 R08: dead000000200200 R09: ffff880fff802200
R10: ffffffffa0317980 R11: 0000000000000000 R12: ffff881ff7daba00
R13: 0000000000000286 R14: 500605ba006c9d09 R15: ffff881ff7daba00
FS:  0000000000000000(0000) GS:ffff88203fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f8ac89ec458 CR3: 0000001ff4c5c000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/u:11 (pid: 3097, threadinfo ffff881fed4d6000, task ffff881402f3d9c0)
Stack:
 0000000000000401 ffff881ff6a5c6b0 0000000000000401 0000000000000016
 ffff881fed4d7bb0 ffffffffa030f93e 0000000000000000 ffff881ff6a5cd88
 0012000e0f000008 006c9d090002000b 00180009500605ba 0000040100000016
Call Trace:
 [<ffffffffa030f93e>] _scsih_add_device.clone.32+0x2fe/0x420 [mpt2sas]
 [<ffffffffa03126e5>] _scsih_sas_topology_change_event.clone.38+0x285/0x620 [mpt2sas]
 [<ffffffff81078c90>] ? load_balance+0x100/0x7a0
 [<ffffffffa0312a80>] ? _scsih_sas_topology_change_event.clone.38+0x620/0x620 [mpt2sas]
 [<ffffffffa0312d8a>] _firmware_event_work+0x30a/0xfc0 [mpt2sas]
 [<ffffffff810015cc>] ? __switch_to+0x14c/0x410
 [<ffffffff8106dfdb>] ? finish_task_switch+0x4b/0xf0
 [<ffffffffa0312a80>] ? _scsih_sas_topology_change_event.clone.38+0x620/0x620 [mpt2sas]
 [<ffffffff8105bf40>] process_one_work+0x140/0x500
 [<ffffffff8105d354>] worker_thread+0x194/0x510
 [<ffffffff8106dfdb>] ? finish_task_switch+0x4b/0xf0
 [<ffffffff8105d1c0>] ? manage_workers+0x320/0x320
 [<ffffffff8106282e>] kthread+0x9e/0xb0
 [<ffffffff815bef44>] kernel_thread_helper+0x4/0x10
 [<ffffffff815b5e5d>] ? retint_restore_args+0x13/0x13
 [<ffffffff81062790>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815bef40>] ? gs_change+0x13/0x13

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    1 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   57 ++++++++++++++++++++++++++++------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   57 ++++++++++++++++++++++++++++------
 4 files changed, 98 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 543d8d6..ceb7d41 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -367,6 +367,7 @@ struct _sas_device {
 	u16	slot;
 	u8	phy;
 	u8	responding;
+	struct kref kref;
 };
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c6bdc92..217660c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -570,6 +570,19 @@ _scsih_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	return NULL;
 }
 
+static void free_sas_device(struct kref *kref)
+{
+	struct _sas_device *sas_device = container_of(kref, struct _sas_device,
+			kref);
+
+	kfree(sas_device);
+}
+
+static void put_sas_device(struct _sas_device *sas_device)
+{
+	kref_put(&sas_device->kref, free_sas_device);
+}
+
 /**
  * _scsih_sas_device_remove - remove sas_device from list.
  * @ioc: per adapter object
@@ -583,14 +596,19 @@ _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
     struct _sas_device *sas_device)
 {
 	unsigned long flags;
+	int was_on_list = 0;
 
 	if (!sas_device)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	list_del(&sas_device->list);
-	kfree(sas_device);
+	if (!list_empty(&sas_device->list)) {
+		list_del_init(&sas_device->list);
+		was_on_list = 1;
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	if (was_on_list)
+		put_sas_device(sas_device);
 }
 
 
@@ -612,6 +630,8 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
 	    "(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
 	    sas_device->handle, (unsigned long long)sas_device->sas_address));
 
+	/* Get an extra refcount... */
+	kref_get(&sas_device->kref);
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_add_tail(&sas_device->list, &ioc->sas_device_list);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
@@ -630,6 +650,12 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
 			sas_device->sas_address_parent);
 		_scsih_sas_device_remove(ioc, sas_device);
 	}
+	/*
+	 * ...and drop it again.  If an error already happend, this is the
+	 * final put and we free the object now.  Otherwise whoever removes
+	 * the object from the list will do the final put and free.
+	 */
+	put_sas_device(sas_device);
 }
 
 /**
@@ -5270,6 +5296,7 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 		return -1;
 	}
 
+	kref_init(&sas_device->kref);
 	sas_device->handle = handle;
 	if (_scsih_get_sas_address(ioc, le16_to_cpu
 		(sas_device_pg0.ParentDevHandle),
@@ -5341,7 +5368,7 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc,
 	    "handle(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
 	    sas_device->handle, (unsigned long long)
 	    sas_device->sas_address));
-	kfree(sas_device);
+	put_sas_device(sas_device);
 }
 /**
  * _scsih_device_remove_by_handle - removing device object by handle
@@ -5355,16 +5382,21 @@ _scsih_device_remove_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 {
 	struct _sas_device *sas_device;
 	unsigned long flags;
+	int was_on_list = 0;
 
 	if (ioc->shost_recovery)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	if (sas_device)
-		list_del(&sas_device->list);
+	if (sas_device) {
+		if (!list_empty(&sas_device->list)) {
+			list_del_init(&sas_device->list);
+			was_on_list = 1;
+		}
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	if (sas_device)
+	if (was_on_list)
 		_scsih_remove_device(ioc, sas_device);
 }
 
@@ -5381,6 +5413,7 @@ mpt2sas_device_remove_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
 {
 	struct _sas_device *sas_device;
 	unsigned long flags;
+	int was_on_list = 0;
 
 	if (ioc->shost_recovery)
 		return;
@@ -5388,10 +5421,14 @@ mpt2sas_device_remove_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
 	    sas_address);
-	if (sas_device)
-		list_del(&sas_device->list);
+	if (sas_device) {
+		if (!list_empty(&sas_device->list)) {
+			list_del_init(&sas_device->list);
+			was_on_list = 1;
+		}
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	if (sas_device)
+	if (was_on_list)
 		_scsih_remove_device(ioc, sas_device);
 }
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
@@ -7805,6 +7842,7 @@ _scsih_probe_boot_devices(struct MPT2SAS_ADAPTER *ioc)
 		handle = sas_device->handle;
 		sas_address_parent = sas_device->sas_address_parent;
 		sas_address = sas_device->sas_address;
+		kref_get(&sas_device->kref);
 		list_move_tail(&sas_device->list, &ioc->sas_device_list);
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
@@ -7819,6 +7857,7 @@ _scsih_probe_boot_devices(struct MPT2SAS_ADAPTER *ioc)
 					sas_address_parent);
 			_scsih_sas_device_remove(ioc, sas_device);
 		}
+		put_sas_device(sas_device);
 	}
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 994656c..fff7fe7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -293,6 +293,7 @@ struct _sas_device {
 	u8	phy;
 	u8	responding;
 	u8	fast_path;
+	struct kref kref;
 };
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6421a06..54fdd7c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -569,6 +569,19 @@ _scsih_sas_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	return NULL;
 }
 
+static void free_sas_device(struct kref *kref)
+{
+	struct _sas_device *sas_device = container_of(kref, struct _sas_device,
+			kref);
+
+	kfree(sas_device);
+}
+
+static void put_sas_device(struct _sas_device *sas_device)
+{
+	kref_put(&sas_device->kref, free_sas_device);
+}
+
 /**
  * _scsih_sas_device_remove - remove sas_device from list.
  * @ioc: per adapter object
@@ -582,14 +595,19 @@ _scsih_sas_device_remove(struct MPT3SAS_ADAPTER *ioc,
 	struct _sas_device *sas_device)
 {
 	unsigned long flags;
+	int was_on_list = 0;
 
 	if (!sas_device)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	list_del(&sas_device->list);
-	kfree(sas_device);
+	if (!list_empty(&sas_device->list)) {
+		list_del_init(&sas_device->list);
+		was_on_list = 1;
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	if (was_on_list)
+		put_sas_device(sas_device);
 }
 
 /**
@@ -604,16 +622,21 @@ _scsih_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 {
 	struct _sas_device *sas_device;
 	unsigned long flags;
+	int was_on_list = 0;
 
 	if (ioc->shost_recovery)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	if (sas_device)
-		list_del(&sas_device->list);
+	if (sas_device) {
+		if (!list_empty(&sas_device->list)) {
+			list_del_init(&sas_device->list);
+			was_on_list = 1;
+		}
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	if (sas_device)
+	if (was_on_list)
 		_scsih_remove_device(ioc, sas_device);
 }
 
@@ -630,6 +653,7 @@ mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
 {
 	struct _sas_device *sas_device;
 	unsigned long flags;
+	int was_on_list = 0;
 
 	if (ioc->shost_recovery)
 		return;
@@ -637,10 +661,14 @@ mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
 	    sas_address);
-	if (sas_device)
-		list_del(&sas_device->list);
+	if (sas_device) {
+		if (!list_empty(&sas_device->list)) {
+			list_del_init(&sas_device->list);
+			was_on_list = 1;
+		}
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	if (sas_device)
+	if (was_on_list)
 		_scsih_remove_device(ioc, sas_device);
 }
 
@@ -663,6 +691,8 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 		ioc->name, __func__, sas_device->handle,
 		(unsigned long long)sas_device->sas_address));
 
+	/* Get an extra refcount... */
+	kref_get(&sas_device->kref);
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_add_tail(&sas_device->list, &ioc->sas_device_list);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
@@ -682,6 +712,12 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 			    sas_device->sas_address_parent);
 		_scsih_sas_device_remove(ioc, sas_device);
 	}
+	/*
+	 * ...and drop it again.  If an error already happend, this is the
+	 * final put and we free the object now.  Otherwise whoever removes
+	 * the object from the list will do the final put and free.
+	 */
+	put_sas_device(sas_device);
 }
 
 /**
@@ -4859,6 +4895,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 		return 0;
 	}
 
+	kref_init(&sas_device->kref);
 	sas_device->handle = handle;
 	if (_scsih_get_sas_address(ioc,
 	    le16_to_cpu(sas_device_pg0.ParentDevHandle),
@@ -4935,7 +4972,7 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 	    sas_device->handle, (unsigned long long)
 	    sas_device->sas_address));
 
-	kfree(sas_device);
+	put_sas_device(sas_device);
 }
 
 #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
@@ -7521,6 +7558,7 @@ _scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
 		handle = sas_device->handle;
 		sas_address_parent = sas_device->sas_address_parent;
 		sas_address = sas_device->sas_address;
+		kref_get(&sas_device->kref);
 		list_move_tail(&sas_device->list, &ioc->sas_device_list);
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
@@ -7533,6 +7571,7 @@ _scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
 				    sas_address_parent);
 			_scsih_sas_device_remove(ioc, sas_device);
 		}
+		put_sas_device(sas_device);
 	}
 }
 
-- 
1.7.10.4

