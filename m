From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 17/25] mpt3sas: setpci reset kernel oops fix
Date: Wed, 11 Nov 2015 17:30:33 +0530
Message-ID: <1447243241-10912-18-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

setpci reset on nytro warpdrive card along with sysfs access and
cli ioctl access resulted in kernel oops

1. pci_access_mutex lock added to provide synchronization between IOCTL,
   sysfs, PCI resource handling path

2. gioc_lock spinlock to protect list operations over multiple
controllers

This patch is ported from below mpt2sas driver patch,

'commit 6229b414b3adb3aac0b54e67d72d6462fc230c0d
("mpt2sas: setpci reset kernel oops fix")

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  6 ++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 20 ++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 42 +++++++++++++++++++++++++++++-------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 +++++++++++
 4 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index bec3163..f5d589e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -108,9 +108,12 @@ _scsih_set_fwfault_debug(const char *val, struct kernel_param *kp)
 	if (ret)
 		return ret;
 
+	/* global ioc spinlock to protect controller list on list operations */
 	pr_info("setting fwfault_debug(%d)\n", mpt3sas_fwfault_debug);
+	spin_lock(&gioc_lock);
 	list_for_each_entry(ioc, &mpt3sas_ioc_list, list)
 		ioc->fwfault_debug = mpt3sas_fwfault_debug;
+	spin_unlock(&gioc_lock);
 	return 0;
 }
 module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
@@ -5136,6 +5139,8 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
 
+	/* synchronizing freeing resource with pci_access_mutex lock */
+	mutex_lock(&ioc->pci_access_mutex);
 	if (ioc->chip_phys && ioc->chip) {
 		_base_mask_interrupts(ioc);
 		ioc->shost_recovery = 1;
@@ -5144,6 +5149,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	mpt3sas_base_unmap_resources(ioc);
+	mutex_unlock(&ioc->pci_access_mutex);
 	return;
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index c92be3c..6d64fa8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -916,7 +916,13 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @replyPostRegisterIndex: index of next position in Reply Desc Post Queue
  * @delayed_tr_list: target reset link list
  * @delayed_tr_volume_list: volume target reset link list
- * @@temp_sensors_count: flag to carry the number of temperature sensors
+ * @temp_sensors_count: flag to carry the number of temperature sensors
+ * @pci_access_mutex: Mutex to synchronize ioctl,sysfs show path and
+ *	pci resource handling. PCI resource freeing will lead to free
+ *	vital hardware/memory resource, which might be in use by cli/sysfs
+ *	path functions resulting in Null pointer reference followed by kernel
+ *	crash. To avoid the above race condition we use mutex syncrhonization
+ *	which ensures the syncrhonization between cli/sysfs_show path.
  */
 struct MPT3SAS_ADAPTER {
 	struct list_head list;
@@ -1131,6 +1137,7 @@ struct MPT3SAS_ADAPTER {
 	struct list_head delayed_tr_list;
 	struct list_head delayed_tr_volume_list;
 	u8		temp_sensors_count;
+	struct mutex pci_access_mutex;
 
 	/* diag buffer support */
 	u8		*diag_buffer[MPI2_DIAG_BUF_TYPE_COUNT];
@@ -1161,6 +1168,17 @@ typedef u8 (*MPT_CALLBACK)(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 /* base shared API */
 extern struct list_head mpt3sas_ioc_list;
 extern char    driver_name[MPT_NAME_LENGTH];
+/* spinlock on list operations over IOCs
+ * Case: when multiple warpdrive cards(IOCs) are in use
+ * Each IOC will added to the ioc list structure on initialization.
+ * Watchdog threads run at regular intervals to check IOC for any
+ * fault conditions which will trigger the dead_ioc thread to
+ * deallocate pci resource, resulting deleting the IOC netry from list,
+ * this deletion need to protected by spinlock to enusre that
+ * ioc removal is syncrhonized, if not synchronized it might lead to
+ * list_del corruption as the ioc list is traversed in cli path.
+ */
+extern spinlock_t gioc_lock;
 
 void mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_base_stop_watchdog(struct MPT3SAS_ADAPTER *ioc);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 1c62db8..f257c96 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -416,13 +416,16 @@ static int
 _ctl_verify_adapter(int ioc_number, struct MPT3SAS_ADAPTER **iocpp)
 {
 	struct MPT3SAS_ADAPTER *ioc;
-
+	/* global ioc lock to protect controller on list operations */
+	spin_lock(&gioc_lock);
 	list_for_each_entry(ioc, &mpt3sas_ioc_list, list) {
 		if (ioc->id != ioc_number)
 			continue;
+		spin_unlock(&gioc_lock);
 		*iocpp = ioc;
 		return ioc_number;
 	}
+	spin_unlock(&gioc_lock);
 	*iocpp = NULL;
 	return -1;
 }
@@ -511,10 +514,15 @@ ctl_poll(struct file *filep, poll_table *wait)
 
 	poll_wait(filep, &ctl_poll_wait, wait);
 
+	/* global ioc lock to protect controller on list operations */
+	spin_lock(&gioc_lock);
 	list_for_each_entry(ioc, &mpt3sas_ioc_list, list) {
-		if (ioc->aen_event_read_flag)
+		if (ioc->aen_event_read_flag) {
+			spin_unlock(&gioc_lock);
 			return POLLIN | POLLRDNORM;
+		}
 	}
+	spin_unlock(&gioc_lock);
 	return 0;
 }
 
@@ -2211,16 +2219,25 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 	if (_ctl_verify_adapter(ioctl_header.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
+	/* pci_access_mutex lock acquired by ioctl path */
+	mutex_lock(&ioc->pci_access_mutex);
+
 	if (ioc->shost_recovery || ioc->pci_error_recovery ||
-	    ioc->is_driver_loading)
-		return -EAGAIN;
+	    ioc->is_driver_loading || ioc->remove_host) {
+		ret = -EAGAIN;
+		goto out_unlock_pciaccess;
+	}
 
 	state = (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLOCKING;
 	if (state == NON_BLOCKING) {
-		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
-			return -EAGAIN;
-	} else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
-		return -ERESTARTSYS;
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex)) {
+			ret = -EAGAIN;
+			goto out_unlock_pciaccess;
+		}
+	} else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex)) {
+		ret = -ERESTARTSYS;
+		goto out_unlock_pciaccess;
+	}
 
 
 	switch (cmd) {
@@ -2301,6 +2318,8 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 	}
 
 	mutex_unlock(&ioc->ctl_cmds.mutex);
+out_unlock_pciaccess:
+	mutex_unlock(&ioc->pci_access_mutex);
 	return ret;
 }
 
@@ -2748,6 +2767,12 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
 		    " warpdrive\n", ioc->name, __func__);
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
@@ -2786,6 +2811,7 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
 
  out:
 	kfree(io_unit_pg3);
+	mutex_unlock(&ioc->pci_access_mutex);
 	return rc;
 }
 static DEVICE_ATTR(BRM_status, S_IRUGO, _ctl_BRM_status_show, NULL);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 436e65e..d0ab002 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -90,6 +90,8 @@ _scsih_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 /* global parameters */
 LIST_HEAD(mpt3sas_ioc_list);
 char    driver_name[MPT_NAME_LENGTH];
+/* global ioc lock for list operations */
+DEFINE_SPINLOCK(gioc_lock);
 
 /* local parameters */
 static u8 scsi_io_cb_idx = -1;
@@ -294,8 +296,10 @@ _scsih_set_debug_level(const char *val, struct kernel_param *kp)
 		return ret;
 
 	pr_info("setting logging_level(0x%08x)\n", logging_level);
+	spin_lock(&gioc_lock);
 	list_for_each_entry(ioc, &mpt3sas_ioc_list, list)
 		ioc->logging_level = logging_level;
+	spin_unlock(&gioc_lock);
 	return 0;
 }
 module_param_call(logging_level, _scsih_set_debug_level, param_get_int,
@@ -7997,7 +8001,9 @@ void scsih_remove(struct pci_dev *pdev)
 	sas_remove_host(shost);
 	scsi_remove_host(shost);
 	mpt3sas_base_detach(ioc);
+	spin_lock(&gioc_lock);
 	list_del(&ioc->list);
+	spin_unlock(&gioc_lock);
 	scsi_host_put(shost);
 }
 
@@ -8384,7 +8390,9 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 	ioc = shost_priv(shost);
 	memset(ioc, 0, sizeof(struct MPT3SAS_ADAPTER));
 	INIT_LIST_HEAD(&ioc->list);
+	spin_lock(&gioc_lock);
 	list_add_tail(&ioc->list, &mpt3sas_ioc_list);
+	spin_unlock(&gioc_lock);
 	ioc->shost = shost;
 	ioc->id = mpt_ids++;
 	ioc->pdev = pdev;
@@ -8403,6 +8411,8 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 	ioc->schedule_dead_ioc_flush_running_cmds = &_scsih_flush_running_cmds;
 	/* misc semaphores and spin locks */
 	mutex_init(&ioc->reset_in_progress_mutex);
+	/* initializing pci_access_mutex lock */
+	mutex_init(&ioc->pci_access_mutex);
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
 	spin_lock_init(&ioc->scsi_lookup_lock);
 	spin_lock_init(&ioc->sas_device_lock);
@@ -8510,7 +8520,9 @@ out_add_shost_fail:
  out_attach_fail:
 	destroy_workqueue(ioc->firmware_event_thread);
  out_thread_fail:
+	spin_lock(&gioc_lock);
 	list_del(&ioc->list);
+	spin_unlock(&gioc_lock);
 	scsi_host_put(shost);
 	return rv;
 }
-- 
2.0.2
