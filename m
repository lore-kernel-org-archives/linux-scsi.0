From: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
Subject: [PATCH v3] mpt2sas: setpci reset kernel oops fix
Date: Fri, 17 Jul 2015 11:55:45 +0530
Message-ID: <20150717062545.GA28561@nagalsi.ban.indi.seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:56979 "EHLO
	mx0b-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbbGQGV0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jul 2015 02:21:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, hch@infradead.org, jthumshirn@suse.de

Patch Description:

In mpt2sas driver due to lack of synchronization between ioctl,
BRM status access through sysfs, pci resource removal kernel oops
happen as ioctl path and BRM status sysfs access path still tries
to access the removed resources

kernel: BUG: unable to handle kernel paging request at ffffc900171e0000

Oops: 0000 [#1] SMP

Two locks added to provide syncrhonization

1. pci_access_mutex: Mutex to synchronize ioctl,sysfs show path and
pci resource handling. PCI resource freeing will lead to free
vital hardware/memory resource, which might be in use by cli/sysfs
path functions resulting in Null pointer reference followed by kernel
crash. To avoid the above race condition we use mutex syncrhonization
which ensures the syncrhonization between cli/sysfs_show path

2. spinlock on list operations over IOCs

Case: when multiple warpdrive cards(IOCs) are in use
Each IOC will added to the ioc list stucture on initialization.
Watchdog threads run at regular intervals to check IOC for any
fault conditions which will trigger the dead_ioc thread to
deallocate pci resource, resulting deleting the IOC netry from list,
this deletion need to protected by spinlock to enusre that
ioc removal is syncrhonized, if not synchronized it might lead to
list_del corruption as the ioc list is traversed in cli path


>From 9e54273555d9a34d0d375b91d41318b4ac69a13b Mon Sep 17 00:00:00 2001
From: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
Date: Fri, 17 Jul 2015 11:28:27 +0530
Subject: [PATCH] mpt2sas setpci reset oops fix

setpci reset on nytro warpdrive card along with sysfs access and
cli ioctl access resulted in kernel oops

1. pci_access_mutex lock added to provide synchronization between IOCTL,
   sysfs, PCI resource handling path

2. gioc_lock spinlock to protect list operations over multiple
   controllers

Signed-off-by: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
---
* v3
- fixed lock imbalance, moved acquiring mutex lock out of if condition

* v2
- removed is_warpdrive condition for pci_access_mutex lock

* v1
- using DEFINE_SPINLOCK() to initialize the lock at compile time instead
  of using spin_lock_init

 drivers/scsi/mpt2sas/mpt2sas_base.c  |    7 +++++++
 drivers/scsi/mpt2sas/mpt2sas_base.h  |   19 ++++++++++++++++++-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c   |   33 +++++++++++++++++++++++++++++----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   15 ++++++++++++++-
 4 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 11248de..c0d36b3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -108,13 +108,17 @@ _scsih_set_fwfault_debug(const char *val, struct kernel_param *kp)
 {
 	int ret = param_set_int(val, kp);
 	struct MPT2SAS_ADAPTER *ioc;
+	unsigned long flags;
 
 	if (ret)
 		return ret;
 
+	/* global ioc spinlock to protect controller list on list operations */
 	printk(KERN_INFO "setting fwfault_debug(%d)\n", mpt2sas_fwfault_debug);
+	spin_lock_irqsave(&gioc_lock, flags);
 	list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
 		ioc->fwfault_debug = mpt2sas_fwfault_debug;
+	spin_unlock_irqrestore(&gioc_lock, flags);
 	return 0;
 }
 
@@ -4435,6 +4439,8 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 	dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
+	/* synchronizing freeing resource with pci_access_mutex lock */
+	mutex_lock(&ioc->pci_access_mutex);
 	if (ioc->chip_phys && ioc->chip) {
 		_base_mask_interrupts(ioc);
 		ioc->shost_recovery = 1;
@@ -4454,6 +4460,7 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 		pci_disable_pcie_error_reporting(pdev);
 		pci_disable_device(pdev);
 	}
+	mutex_unlock(&ioc->pci_access_mutex);
 	return;
 }
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index caff8d1..c82bdb3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -799,6 +799,12 @@ typedef void (*MPT2SAS_FLUSH_RUNNING_CMDS)(struct MPT2SAS_ADAPTER *ioc);
  * @delayed_tr_list: target reset link list
  * @delayed_tr_volume_list: volume target reset link list
  * @@temp_sensors_count: flag to carry the number of temperature sensors
+ * @pci_access_mutex: Mutex to synchronize ioctl,sysfs show path and
+ * pci resource handling. PCI resource freeing will lead to free
+ * vital hardware/memory resource, which might be in use by cli/sysfs
+ * path functions resulting in Null pointer reference followed by kernel
+ * crash. To avoid the above race condition we use mutex syncrhonization
+ * which ensures the syncrhonization between cli/sysfs_show path
  */
 struct MPT2SAS_ADAPTER {
 	struct list_head list;
@@ -1015,6 +1021,7 @@ struct MPT2SAS_ADAPTER {
 	u8		mfg_pg10_hide_flag;
 	u8		hide_drives;
 
+	struct mutex pci_access_mutex;
 };
 
 typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
@@ -1023,6 +1030,17 @@ typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 
 /* base shared API */
 extern struct list_head mpt2sas_ioc_list;
+/* spinlock on list operations over IOCs
+ * Case: when multiple warpdrive cards(IOCs) are in use
+ * Each IOC will added to the ioc list stucture on initialization.
+ * Watchdog threads run at regular intervals to check IOC for any
+ * fault conditions which will trigger the dead_ioc thread to
+ * deallocate pci resource, resulting deleting the IOC netry from list,
+ * this deletion need to protected by spinlock to enusre that
+ * ioc removal is syncrhonized, if not synchronized it might lead to
+ * list_del corruption as the ioc list is traversed in cli path
+ */
+extern spinlock_t gioc_lock;
 void mpt2sas_base_start_watchdog(struct MPT2SAS_ADAPTER *ioc);
 void mpt2sas_base_stop_watchdog(struct MPT2SAS_ADAPTER *ioc);
 
@@ -1099,7 +1117,6 @@ struct _sas_device *mpt2sas_scsih_sas_device_find_by_sas_address(
     struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
 
 void mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc);
-
 void mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
 
 /* config shared API */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 4e50960..8f8f2ad 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -427,13 +427,17 @@ static int
 _ctl_verify_adapter(int ioc_number, struct MPT2SAS_ADAPTER **iocpp)
 {
 	struct MPT2SAS_ADAPTER *ioc;
-
+	unsigned long flags;
+	/* global ioc lock to protect controller on list operations */
+	spin_lock_irqsave(&gioc_lock, flags);
 	list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
 		if (ioc->id != ioc_number)
 			continue;
+		spin_unlock_irqrestore(&gioc_lock, flags);
 		*iocpp = ioc;
 		return ioc_number;
 	}
+	spin_unlock_irqrestore(&gioc_lock, flags);
 	*iocpp = NULL;
 	return -1;
 }
@@ -519,13 +523,19 @@ static unsigned int
 _ctl_poll(struct file *filep, poll_table *wait)
 {
 	struct MPT2SAS_ADAPTER *ioc;
+	unsigned long flags;
 
 	poll_wait(filep, &ctl_poll_wait, wait);
 
+	/* global ioc lock to protect controller on list operations */
+	spin_lock_irqsave(&gioc_lock, flags);
 	list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
-		if (ioc->aen_event_read_flag)
+		if (ioc->aen_event_read_flag) {
+			spin_unlock_irqrestore(&gioc_lock, flags);
 			return POLLIN | POLLRDNORM;
+		}
 	}
+	spin_unlock_irqrestore(&gioc_lock, flags);
 	return 0;
 }
 
@@ -2168,15 +2178,22 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 
 	if (_ctl_verify_adapter(ioctl_header.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
+	/* pci_access_mutex lock acquired by ioctl path */
+	mutex_lock(&ioc->pci_access_mutex);
 	if (ioc->shost_recovery || ioc->pci_error_recovery ||
-	    ioc->is_driver_loading)
+		ioc->is_driver_loading || ioc->remove_host) {
+		mutex_unlock(&ioc->pci_access_mutex);
 		return -EAGAIN;
+	}
 
 	state = (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLOCKING;
 	if (state == NON_BLOCKING) {
-		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex)) {
+			mutex_unlock(&ioc->pci_access_mutex);
 			return -EAGAIN;
+		}
 	} else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex)) {
+		mutex_unlock(&ioc->pci_access_mutex);
 		return -ERESTARTSYS;
 	}
 
@@ -2258,6 +2275,7 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 	}
 
 	mutex_unlock(&ioc->ctl_cmds.mutex);
+	mutex_unlock(&ioc->pci_access_mutex);
 	return ret;
 }
 
@@ -2711,6 +2729,12 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
 		    "warpdrive\n", ioc->name, __func__);
 		goto out;
 	}
+	/* pci_access_mutex lock acquired by sysfs show path */
+	mutex_lock(&ioc->pci_access_mutex);
+	if (ioc->pci_error_recovery || ioc->remove_host) {
+		mutex_unlock(&ioc->pci_access_mutex);
+		return 0;
+	}
 
 	/* allocate upto GPIOVal 36 entries */
 	sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
@@ -2749,6 +2773,7 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
 
  out:
 	kfree(io_unit_pg3);
+	mutex_unlock(&ioc->pci_access_mutex);
 	return rc;
 }
 static DEVICE_ATTR(BRM_status, S_IRUGO, _ctl_BRM_status_show, NULL);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 3f26147..9f7ed0f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -79,7 +79,8 @@ static int _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time);
 
 /* global parameters */
 LIST_HEAD(mpt2sas_ioc_list);
-
+/* global ioc lock for list operations */
+DEFINE_SPINLOCK(gioc_lock);
 /* local parameters */
 static u8 scsi_io_cb_idx = -1;
 static u8 tm_cb_idx = -1;
@@ -288,13 +289,16 @@ _scsih_set_debug_level(const char *val, struct kernel_param *kp)
 {
 	int ret = param_set_int(val, kp);
 	struct MPT2SAS_ADAPTER *ioc;
+	unsigned long flags;
 
 	if (ret)
 		return ret;
 
 	printk(KERN_INFO "setting logging_level(0x%08x)\n", logging_level);
+	spin_lock_irqsave(&gioc_lock, flags);
 	list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
 		ioc->logging_level = logging_level;
+	spin_unlock_irqrestore(&gioc_lock, flags);
 	return 0;
 }
 module_param_call(logging_level, _scsih_set_debug_level, param_get_int,
@@ -7867,7 +7871,9 @@ _scsih_remove(struct pci_dev *pdev)
 	sas_remove_host(shost);
 	scsi_remove_host(shost);
 	mpt2sas_base_detach(ioc);
+	spin_lock_irqsave(&gioc_lock, flags);
 	list_del(&ioc->list);
+	spin_unlock_irqrestore(&gioc_lock, flags);
 	scsi_host_put(shost);
 }
 
@@ -8132,6 +8138,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct MPT2SAS_ADAPTER *ioc;
 	struct Scsi_Host *shost;
 	int rv;
+	unsigned long flags;
 
 	shost = scsi_host_alloc(&scsih_driver_template,
 	    sizeof(struct MPT2SAS_ADAPTER));
@@ -8142,7 +8149,9 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc = shost_priv(shost);
 	memset(ioc, 0, sizeof(struct MPT2SAS_ADAPTER));
 	INIT_LIST_HEAD(&ioc->list);
+	spin_lock_irqsave(&gioc_lock, flags);
 	list_add_tail(&ioc->list, &mpt2sas_ioc_list);
+	spin_unlock_irqrestore(&gioc_lock, flags);
 	ioc->shost = shost;
 	ioc->id = mpt_ids++;
 	sprintf(ioc->name, "%s%d", MPT2SAS_DRIVER_NAME, ioc->id);
@@ -8167,6 +8176,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->schedule_dead_ioc_flush_running_cmds = &_scsih_flush_running_cmds;
 	/* misc semaphores and spin locks */
 	mutex_init(&ioc->reset_in_progress_mutex);
+	/* initializing pci_access_mutex lock */
+	mutex_init(&ioc->pci_access_mutex);
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
 	spin_lock_init(&ioc->scsi_lookup_lock);
 	spin_lock_init(&ioc->sas_device_lock);
@@ -8269,7 +8280,9 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  out_attach_fail:
 	destroy_workqueue(ioc->firmware_event_thread);
  out_thread_fail:
+	spin_lock_irqsave(&gioc_lock, flags);
 	list_del(&ioc->list);
+	spin_unlock_irqrestore(&gioc_lock, flags);
 	scsi_host_put(shost);
 	return rv;
 }
-- 
1.7.1

