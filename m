From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH] mpt2sas: mpt3sas: Fix memory corruption during initialization
Date: Mon,  4 May 2015 20:35:31 +0530
Message-ID: <1430751931-14002-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33229 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbbEDPFp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2015 11:05:45 -0400
Received: by pdbnk13 with SMTP id nk13so165362304pdb.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 May 2015 08:05:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: calvinowens@fb.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, jejb@kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, chaitra.basappa@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

I have applied this patch on the latest upstream mpt3sas driver, then I have compiled and loaded the driver.
In the driver logs I didn't see any attached drives are added to the OS, 'fdisk -l' command also doesn't list
 the drives which are actually attached to the HBA.

When I debug this issue then I see that in '_scsih_target_alloc'
 driver is searching for sas_device from the lists 'sas_device_init_list' & 'sas_device_list'
 based on the device sas address using the function mpt3sas_scsih_sas_device_find_by_sas_address(),
 since this device is not in the 'sas_device_init_list' (as it is moved it to head list) driver exit
 from this function without updating the required device addition information.

To solve the original problem (i.e memory corruption), here I have attached the patch,
 in this patch I have added one atomic flag is_on_sas_device_init_list in _sas_device_structure
 and I followed below algorithm.

1. when ever a device is added to sas_device_init_list then driver will set this atomic flag of this device to one.

2. And during the addition of this device to SCSI mid layer,
        if the device is successfully added to the OS then driver will move this device list in to sas_device_list list from sas_device_init_list list and at this time driver will reset this flag to zero.
        if device is failed to register with SCSI mid layer then also driver will reset this flag to zero in function _scsih_sas_device_remove and will remove the device entry from sas_device_init_list and will free the device structure.

3. Now when a device is removed then driver will receive target not responding event and in the function _scsih_device_remove_by_handle,
         a. driver will check whether addition of discovered devices to SML process is currently running or not,
               i. if addition (or registration) of discovered devices to SML process is running then driver will check whether device is in sas_device_init_list or not (by reading the atomic flag)?.
                    if it is in a sas_device_init_list then driver will ignore this device removal event (since device registration with SML will fail and it is removed in function _scsih_sas_device_remove as mentioned in step 2).
             ii. if the device is not in a sas_device_init_list or addition (or registration) of discovered devices to SML process is already completed then device structure is removed from this function and this device entry is removed from sas_device_list.

4. if the device removal event is received after device structure is freed due to failure of device registration with SML them in the function _scsih_device_remove_by_handle driver won't find this device in the sas_device_list or in a sas_device_init_list and so driver will ignore this  device removal event.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h  |  2 ++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 45 +++++++++++++++++++++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 43 ++++++++++++++++++++++++++--------
 4 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index caff8d1..1aa10d2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -376,6 +376,7 @@ struct _sas_device {
 	u8	phy;
 	u8	responding;
 	u8	pfa_led_on;
+	atomic_t is_on_sas_device_init_list;
 };
 
 /**
@@ -833,6 +834,7 @@ struct MPT2SAS_ADAPTER {
 	u8		broadcast_aen_busy;
 	u16		broadcast_aen_pending;
 	u8		shost_recovery;
+	u8		discovered_device_addition_on;
 
 	struct mutex	reset_in_progress_mutex;
 	spinlock_t 	ioc_reset_in_progress_lock;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 3f26147..2a61286 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -590,13 +590,20 @@ _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
     struct _sas_device *sas_device)
 {
 	unsigned long flags;
+	struct _sas_device *same_sas_device;
 
 	if (!sas_device)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	list_del(&sas_device->list);
-	kfree(sas_device);
+	same_sas_device = _scsih_sas_device_find_by_handle(ioc,
+						sas_device->handle);
+	if (same_sas_device) {
+		list_del(&same_sas_device->list);
+		if (atomic_read(&sas_device->is_on_sas_device_init_list))
+			atomic_set(&sas_device->is_on_sas_device_init_list, 0);
+		kfree(same_sas_device);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 }
 
@@ -658,6 +664,7 @@ _scsih_sas_device_init_add(struct MPT2SAS_ADAPTER *ioc,
 	    "(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
 	    sas_device->handle, (unsigned long long)sas_device->sas_address));
 
+	atomic_set(&sas_device->is_on_sas_device_init_list, 1);
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_add_tail(&sas_device->list, &ioc->sas_device_init_list);
 	_scsih_determine_boot_device(ioc, sas_device, 0);
@@ -5364,8 +5371,14 @@ _scsih_device_remove_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	if (sas_device)
-		list_del(&sas_device->list);
+	if (sas_device) {
+		if (ioc->discovered_device_addition_on &&
+		    atomic_read(&sas_device->is_on_sas_device_init_list)) {
+			spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+			return;
+		} else
+			list_del(&sas_device->list);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	if (sas_device)
 		_scsih_remove_device(ioc, sas_device);
@@ -5391,8 +5404,14 @@ mpt2sas_device_remove_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
 	    sas_address);
-	if (sas_device)
-		list_del(&sas_device->list);
+	if (sas_device) {
+		if (ioc->discovered_device_addition_on &&
+		    atomic_read(&sas_device->is_on_sas_device_init_list)) {
+			spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+			return;
+		} else
+			list_del(&sas_device->list);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	if (sas_device)
 		_scsih_remove_device(ioc, sas_device);
@@ -7978,32 +7997,36 @@ _scsih_probe_sas(struct MPT2SAS_ADAPTER *ioc)
 	struct _sas_device *sas_device, *next;
 	unsigned long flags;
 
+	ioc->discovered_device_addition_on = 1;
 	/* SAS Device List */
 	list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
 	    list) {
 
 		if (ioc->hide_drives)
 			continue;
-
+
 		if (!mpt2sas_transport_port_add(ioc, sas_device->handle,
 		    sas_device->sas_address_parent)) {
-			list_del(&sas_device->list);
-			kfree(sas_device);
+			mpt2sas_transport_port_remove(ioc,
+					sas_device->sas_address,
+					sas_device->sas_address_parent);
+			_scsih_sas_device_remove(ioc, sas_device);
 			continue;
 		} else if (!sas_device->starget) {
 			if (!ioc->is_driver_loading) {
 				mpt2sas_transport_port_remove(ioc,
 					sas_device->sas_address,
 					sas_device->sas_address_parent);
-				list_del(&sas_device->list);
-				kfree(sas_device);
+				_scsih_sas_device_remove(ioc, sas_device);
 				continue;
 			}
 		}
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		list_move_tail(&sas_device->list, &ioc->sas_device_list);
+		atomic_dec(&sas_device->is_on_sas_device_init_list);
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
+	ioc->discovered_device_addition_on = 0;
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index afa8816..6188490 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -315,6 +315,7 @@ struct _sas_device {
 	u8	responding;
 	u8	fast_path;
 	u8	pfa_led_on;
+	atomic_t is_on_sas_device_init_list;
 };
 
 /**
@@ -766,6 +767,7 @@ struct MPT3SAS_ADAPTER {
 	u8		broadcast_aen_busy;
 	u16		broadcast_aen_pending;
 	u8		shost_recovery;
+	u8		discovered_device_addition_on;
 
 	struct mutex	reset_in_progress_mutex;
 	spinlock_t	ioc_reset_in_progress_lock;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5a97e32..53cc9ea 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -582,13 +582,20 @@ _scsih_sas_device_remove(struct MPT3SAS_ADAPTER *ioc,
 	struct _sas_device *sas_device)
 {
 	unsigned long flags;
+	struct _sas_device *same_sas_device;
 
 	if (!sas_device)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	list_del(&sas_device->list);
-	kfree(sas_device);
+	same_sas_device = _scsih_sas_device_find_by_handle(ioc,
+						sas_device->handle);
+	if (same_sas_device) {
+		list_del(&same_sas_device->list);
+		if (atomic_read(&sas_device->is_on_sas_device_init_list))
+			atomic_set(&sas_device->is_on_sas_device_init_list, 0);
+		kfree(same_sas_device);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 }
 
@@ -610,8 +616,14 @@ _scsih_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	if (sas_device)
-		list_del(&sas_device->list);
+	if (sas_device) {
+		if (ioc->discovered_device_addition_on &&
+		    atomic_read(&sas_device->is_on_sas_device_init_list)) {
+			spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+			return;
+		} else
+			list_del(&sas_device->list);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	if (sas_device)
 		_scsih_remove_device(ioc, sas_device);
@@ -637,8 +649,14 @@ mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
 	    sas_address);
-	if (sas_device)
-		list_del(&sas_device->list);
+	if (sas_device) {
+		if (ioc->discovered_device_addition_on &&
+		    atomic_read(&sas_device->is_on_sas_device_init_list)) {
+			spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+			return;
+		} else
+			list_del(&sas_device->list);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	if (sas_device)
 		_scsih_remove_device(ioc, sas_device);
@@ -663,6 +681,7 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 		ioc->name, __func__, sas_device->handle,
 		(unsigned long long)sas_device->sas_address));
 
+	atomic_set(&sas_device->is_on_sas_device_init_list, 1);
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_add_tail(&sas_device->list, &ioc->sas_device_list);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
@@ -7610,14 +7629,17 @@ _scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
 	struct _sas_device *sas_device, *next;
 	unsigned long flags;
 
+	ioc->discovered_device_addition_on = 1;
 	/* SAS Device List */
 	list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
 	    list) {
 
 		if (!mpt3sas_transport_port_add(ioc, sas_device->handle,
 		    sas_device->sas_address_parent)) {
-			list_del(&sas_device->list);
-			kfree(sas_device);
+			mpt3sas_transport_port_remove(ioc,
+					sas_device->sas_address,
+					sas_device->sas_address_parent);
+			_scsih_sas_device_remove(ioc, sas_device);
 			continue;
 		} else if (!sas_device->starget) {
 			/*
@@ -7630,16 +7652,17 @@ _scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
 				mpt3sas_transport_port_remove(ioc,
 				    sas_device->sas_address,
 				    sas_device->sas_address_parent);
-				list_del(&sas_device->list);
-				kfree(sas_device);
+				_scsih_sas_device_remove(ioc, sas_device);
 				continue;
 			}
 		}
 
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		list_move_tail(&sas_device->list, &ioc->sas_device_list);
+		atomic_dec(&sas_device->is_on_sas_device_init_list);
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
+	ioc->discovered_device_addition_on = 0;
 }
 
 /**
-- 
2.0.2

