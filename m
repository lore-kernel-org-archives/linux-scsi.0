From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2] mpt2sas: mpt3sas: Fix memory corruption during initialization
Date: Tue, 12 May 2015 16:45:52 +0530
Message-ID: <1431429352-40723-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: calvinowens@fb.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, jejb@kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, chaitra.basappa@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Added mutex lock 'probe_devices_in_progress_mutex' to protect from corruption
of sas_device_init_list list while adding the device's saved in the sas_device_init_list
list to SML.

In the _scsih_device_remove_by_handle() function, firmware event handling thread will
be waiting for the other thread to complete it's work of registering the sas device's saved
in the sas_device_init_list list with the SML before it free's the removal device's data (if
the device's data is alread freed then this thread will simple exit from this function).

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h  | 1 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 7 +++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 7 +++++++
 4 files changed, 16 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index caff8d1..283c59f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -835,6 +835,7 @@ struct MPT2SAS_ADAPTER {
 	u8		shost_recovery;
 
 	struct mutex	reset_in_progress_mutex;
+	struct mutex    probe_devices_in_progress_mutex;
 	spinlock_t 	ioc_reset_in_progress_lock;
 	u8		ioc_link_reset_in_progress;
 	u8		ioc_reset_in_progress_status;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 3f26147..498767a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5362,6 +5362,8 @@ _scsih_device_remove_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	if (ioc->shost_recovery)
 		return;
 
+	mutex_lock(&ioc->probe_devices_in_progress_mutex);
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
 	if (sas_device)
@@ -5369,6 +5371,8 @@ _scsih_device_remove_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	if (sas_device)
 		_scsih_remove_device(ioc, sas_device);
+
+	mutex_unlock(&ioc->probe_devices_in_progress_mutex);
 }
 
 /**
@@ -8020,6 +8024,7 @@ _scsih_probe_devices(struct MPT2SAS_ADAPTER *ioc)
 	if (!(ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR))
 		return;  /* return when IOC doesn't support initiator mode */
 
+	mutex_lock(&ioc->probe_devices_in_progress_mutex);
 	_scsih_probe_boot_devices(ioc);
 
 	if (ioc->ir_firmware) {
@@ -8036,6 +8041,7 @@ _scsih_probe_devices(struct MPT2SAS_ADAPTER *ioc)
 		}
 	} else
 		_scsih_probe_sas(ioc);
+	mutex_unlock(&ioc->probe_devices_in_progress_mutex);
 }
 
 
@@ -8167,6 +8173,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->schedule_dead_ioc_flush_running_cmds = &_scsih_flush_running_cmds;
 	/* misc semaphores and spin locks */
 	mutex_init(&ioc->reset_in_progress_mutex);
+	mutex_init(&ioc->probe_devices_in_progress_mutex);
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
 	spin_lock_init(&ioc->scsi_lookup_lock);
 	spin_lock_init(&ioc->sas_device_lock);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index afa8816..ce0090a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -768,6 +768,7 @@ struct MPT3SAS_ADAPTER {
 	u8		shost_recovery;
 
 	struct mutex	reset_in_progress_mutex;
+	struct mutex    probe_devices_in_progress_mutex;
 	spinlock_t	ioc_reset_in_progress_lock;
 	u8		ioc_link_reset_in_progress;
 	u8		ioc_reset_in_progress_status;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5a97e32..b1bec24 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -608,6 +608,8 @@ _scsih_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	if (ioc->shost_recovery)
 		return;
 
+	mutex_lock(&ioc->probe_devices_in_progress_mutex);
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
 	if (sas_device)
@@ -615,6 +617,8 @@ _scsih_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	if (sas_device)
 		_scsih_remove_device(ioc, sas_device);
+
+	mutex_unlock(&ioc->probe_devices_in_progress_mutex);
 }
 
 /**
@@ -7656,6 +7660,7 @@ _scsih_probe_devices(struct MPT3SAS_ADAPTER *ioc)
 	if (!(ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR))
 		return;  /* return when IOC doesn't support initiator mode */
 
+	mutex_lock(&ioc->probe_devices_in_progress_mutex);
 	_scsih_probe_boot_devices(ioc);
 
 	if (ioc->ir_firmware) {
@@ -7672,6 +7677,7 @@ _scsih_probe_devices(struct MPT3SAS_ADAPTER *ioc)
 		}
 	} else
 		_scsih_probe_sas(ioc);
+	mutex_unlock(&ioc->probe_devices_in_progress_mutex);
 }
 
 /**
@@ -7797,6 +7803,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->schedule_dead_ioc_flush_running_cmds = &_scsih_flush_running_cmds;
 	/* misc semaphores and spin locks */
 	mutex_init(&ioc->reset_in_progress_mutex);
+	mutex_init(&ioc->probe_devices_in_progress_mutex);
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
 	spin_lock_init(&ioc->scsi_lookup_lock);
 	spin_lock_init(&ioc->sas_device_lock);
-- 
2.0.2
