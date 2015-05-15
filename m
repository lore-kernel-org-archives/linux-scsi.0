From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH 2/6] Refactor code to use new sas_device refcount
Date: Thu, 14 May 2015 20:41:58 -0700
Message-ID: <1431661322-3097935-3-git-send-email-calvinowens@fb.com>
References: <20150506184852.GA1007288@mail.thefacebook.com>
 <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, calvinowens@fb.com, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

This patch refactors the code in the driver to use the new reference
count on the sas_device struct.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h      |   4 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 329 ++++++++++++++++++++-----------
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  12 +-
 3 files changed, 220 insertions(+), 125 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 2e7dc33..dac0e8a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -1111,7 +1111,9 @@ struct _sas_node *mpt2sas_scsih_expander_find_by_handle(struct MPT2SAS_ADAPTER *
     u16 handle);
 struct _sas_node *mpt2sas_scsih_expander_find_by_sas_address(struct MPT2SAS_ADAPTER
     *ioc, u64 sas_address);
-struct _sas_device *mpt2sas_scsih_sas_device_find_by_sas_address(
+struct _sas_device *mpt2sas_scsih_sas_device_get_by_sas_address(
+    struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
+struct _sas_device *mpt2sas_scsih_sas_device_get_by_sas_address_nolock(
     struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
 
 void mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 3f26147..ad6ceb7e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -526,8 +526,31 @@ _scsih_determine_boot_device(struct MPT2SAS_ADAPTER *ioc,
 	}
 }
 
+struct _sas_device *
+mpt2sas_scsih_sas_device_get_by_sas_address_nolock(struct MPT2SAS_ADAPTER *ioc,
+    u64 sas_address)
+{
+	struct _sas_device *sas_device;
+
+	BUG_ON(!spin_is_locked(&ioc->sas_device_lock));
+
+	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
+		if (sas_device->sas_address == sas_address)
+			goto found_device;
+
+	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
+		if (sas_device->sas_address == sas_address)
+			goto found_device;
+
+	return NULL;
+
+found_device:
+	sas_device_get(sas_device);
+	return sas_device;
+}
+
 /**
- * mpt2sas_scsih_sas_device_find_by_sas_address - sas device search
+ * mpt2sas_scsih_sas_device_get_by_sas_address - sas device search
  * @ioc: per adapter object
  * @sas_address: sas address
  * Context: Calling function should acquire ioc->sas_device_lock
@@ -536,24 +559,44 @@ _scsih_determine_boot_device(struct MPT2SAS_ADAPTER *ioc,
  * object.
  */
 struct _sas_device *
-mpt2sas_scsih_sas_device_find_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
+mpt2sas_scsih_sas_device_get_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
     u64 sas_address)
 {
 	struct _sas_device *sas_device;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
+			sas_address);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	return sas_device;
+}
+
+static struct _sas_device *
+_scsih_sas_device_get_by_handle_nolock(struct MPT2SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _sas_device *sas_device;
+
+	BUG_ON(!spin_is_locked(&ioc->sas_device_lock));
 
 	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
-		if (sas_device->sas_address == sas_address)
-			return sas_device;
+		if (sas_device->handle == handle)
+			goto found_device;
 
 	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
-		if (sas_device->sas_address == sas_address)
-			return sas_device;
+		if (sas_device->handle == handle)
+			goto found_device;
 
 	return NULL;
+
+found_device:
+	sas_device_get(sas_device);
+	return sas_device;
 }
 
 /**
- * _scsih_sas_device_find_by_handle - sas device search
+ * _scsih_sas_device_get_by_handle - sas device search
  * @ioc: per adapter object
  * @handle: sas device handle (assigned by firmware)
  * Context: Calling function should acquire ioc->sas_device_lock
@@ -562,19 +605,16 @@ mpt2sas_scsih_sas_device_find_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
  * object.
  */
 static struct _sas_device *
-_scsih_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
+_scsih_sas_device_get_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 {
 	struct _sas_device *sas_device;
+	unsigned long flags;
 
-	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
-		if (sas_device->handle == handle)
-			return sas_device;
-
-	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
-		if (sas_device->handle == handle)
-			return sas_device;
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_get_by_handle_nolock(ioc, handle);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
-	return NULL;
+	return sas_device;
 }
 
 /**
@@ -583,7 +623,7 @@ _scsih_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
  * @sas_device: the sas_device object
  * Context: This function will acquire ioc->sas_device_lock.
  *
- * Removing object and freeing associated memory from the ioc->sas_device_list.
+ * If sas_device is on the list, remove it and decrement its reference count.
  */
 static void
 _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
@@ -594,9 +634,15 @@ _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
 	if (!sas_device)
 		return;
 
+	/*
+	 * The lock serializes access to the list, but we still need to verify
+	 * that nobody removed the entry while we were waiting on the lock.
+	 */
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	list_del(&sas_device->list);
-	kfree(sas_device);
+	if (!list_empty(&sas_device->list)) {
+		list_del_init(&sas_device->list);
+		sas_device_put(sas_device);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 }
 
@@ -620,6 +666,7 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
 	    sas_device->handle, (unsigned long long)sas_device->sas_address));
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device_get(sas_device);
 	list_add_tail(&sas_device->list, &ioc->sas_device_list);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
@@ -659,6 +706,7 @@ _scsih_sas_device_init_add(struct MPT2SAS_ADAPTER *ioc,
 	    sas_device->handle, (unsigned long long)sas_device->sas_address));
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device_get(sas_device);
 	list_add_tail(&sas_device->list, &ioc->sas_device_init_list);
 	_scsih_determine_boot_device(ioc, sas_device, 0);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
@@ -1208,12 +1256,15 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 		goto not_sata;
 	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))
 		goto not_sata;
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 	   sas_device_priv_data->sas_target->sas_address);
-	if (sas_device && sas_device->device_info &
-	    MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
+	if (sas_device && sas_device->device_info
+			& MPI2_SAS_DEVICE_INFO_SATA_DEVICE) {
 		max_depth = MPT2SAS_SATA_QUEUE_DEPTH;
+		sas_device_put(sas_device);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
  not_sata:
@@ -1271,7 +1322,7 @@ _scsih_target_alloc(struct scsi_target *starget)
 	/* sas/sata devices */
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	rphy = dev_to_rphy(starget->dev.parent);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 	   rphy->identify.sas_address);
 
 	if (sas_device) {
@@ -1283,6 +1334,8 @@ _scsih_target_alloc(struct scsi_target *starget)
 		if (test_bit(sas_device->handle, ioc->pd_handles))
 			sas_target_priv_data->flags |=
 			    MPT_TARGET_FLAGS_RAID_COMPONENT;
+
+		sas_device_put(sas_device);
 	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
@@ -1324,13 +1377,15 @@ _scsih_target_destroy(struct scsi_target *starget)
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	rphy = dev_to_rphy(starget->dev.parent);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 	   rphy->identify.sas_address);
 	if (sas_device && (sas_device->starget == starget) &&
 	    (sas_device->id == starget->id) &&
 	    (sas_device->channel == starget->channel))
 		sas_device->starget = NULL;
 
+	if (sas_device)
+		sas_device_put(sas_device);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
  out:
@@ -1386,7 +1441,7 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 
 	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+		sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 				sas_target_priv_data->sas_address);
 		if (sas_device && (sas_device->starget == NULL)) {
 			sdev_printk(KERN_INFO, sdev,
@@ -1394,6 +1449,10 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 			     __func__, __LINE__);
 			sas_device->starget = starget;
 		}
+
+		if (sas_device)
+			sas_device_put(sas_device);
+
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
 
@@ -1428,10 +1487,13 @@ _scsih_slave_destroy(struct scsi_device *sdev)
 
 	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+		sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 		   sas_target_priv_data->sas_address);
 		if (sas_device && !sas_target_priv_data->num_luns)
 			sas_device->starget = NULL;
+
+		if (sas_device)
+			sas_device_put(sas_device);
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
 
@@ -2078,7 +2140,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 	}
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 	   sas_device_priv_data->sas_target->sas_address);
 	if (!sas_device) {
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
@@ -2116,13 +2178,14 @@ _scsih_slave_configure(struct scsi_device *sdev)
 	if (!ssp_target)
 		_scsih_display_sata_capabilities(ioc, handle, sdev);
 
-
 	_scsih_change_queue_depth(sdev, qdepth);
 
 	if (ssp_target) {
 		sas_read_port_mode_page(sdev);
 		_scsih_enable_tlr(ioc, sdev);
 	}
+
+	sas_device_put(sas_device);
 	return 0;
 }
 
@@ -2509,7 +2572,7 @@ _scsih_tm_display_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
 		    device_str, (unsigned long long)priv_target->sas_address);
 	} else {
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+		sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 		    priv_target->sas_address);
 		if (sas_device) {
 			if (priv_target->flags &
@@ -2529,6 +2592,8 @@ _scsih_tm_display_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
 			    "enclosure_logical_id(0x%016llx), slot(%d)\n",
 			   (unsigned long long)sas_device->enclosure_logical_id,
 			    sas_device->slot);
+
+			sas_device_put(sas_device);
 		}
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
@@ -2604,8 +2669,7 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
-	struct _sas_device *sas_device;
-	unsigned long flags;
+	struct _sas_device *sas_device = NULL;
 	u16	handle;
 	int r;
 
@@ -2629,12 +2693,10 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
 	handle = 0;
 	if (sas_device_priv_data->sas_target->flags &
 	    MPT_TARGET_FLAGS_RAID_COMPONENT) {
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = _scsih_sas_device_find_by_handle(ioc,
+		sas_device = _scsih_sas_device_get_by_handle(ioc,
 		   sas_device_priv_data->sas_target->handle);
 		if (sas_device)
 			handle = sas_device->volume_handle;
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	} else
 		handle = sas_device_priv_data->sas_target->handle;
 
@@ -2651,6 +2713,10 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
 	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+
+	if (sas_device)
+		sas_device_put(sas_device);
+
 	return r;
 }
 
@@ -2665,8 +2731,7 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
-	struct _sas_device *sas_device;
-	unsigned long flags;
+	struct _sas_device *sas_device = NULL;
 	u16	handle;
 	int r;
 	struct scsi_target *starget = scmd->device->sdev_target;
@@ -2689,12 +2754,10 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
 	handle = 0;
 	if (sas_device_priv_data->sas_target->flags &
 	    MPT_TARGET_FLAGS_RAID_COMPONENT) {
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = _scsih_sas_device_find_by_handle(ioc,
+		sas_device = _scsih_sas_device_get_by_handle(ioc,
 		   sas_device_priv_data->sas_target->handle);
 		if (sas_device)
 			handle = sas_device->volume_handle;
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	} else
 		handle = sas_device_priv_data->sas_target->handle;
 
@@ -2711,6 +2774,10 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
  out:
 	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
 	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+
+	if (sas_device)
+		sas_device_put(sas_device);
+
 	return r;
 }
 
@@ -3002,15 +3069,15 @@ _scsih_block_io_to_children_attached_to_ex(struct MPT2SAS_ADAPTER *ioc,
 
 	list_for_each_entry(mpt2sas_port,
 	   &sas_expander->sas_port_list, port_list) {
-		if (mpt2sas_port->remote_identify.device_type ==
-		    SAS_END_DEVICE) {
+		if (mpt2sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 			spin_lock_irqsave(&ioc->sas_device_lock, flags);
-			sas_device =
-			    mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
-			   mpt2sas_port->remote_identify.sas_address);
-			if (sas_device)
+			sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
+					mpt2sas_port->remote_identify.sas_address);
+			if (sas_device) {
 				set_bit(sas_device->handle,
-				    ioc->blocking_handles);
+						ioc->blocking_handles);
+				sas_device_put(sas_device);
+			}
 			spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 		}
 	}
@@ -3080,7 +3147,7 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 {
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	u16 smid;
-	struct _sas_device *sas_device;
+	struct _sas_device *sas_device = NULL;
 	struct MPT2SAS_TARGET *sas_target_priv_data = NULL;
 	u64 sas_address = 0;
 	unsigned long flags;
@@ -3110,7 +3177,7 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	sas_device = _scsih_sas_device_get_by_handle_nolock(ioc, handle);
 	if (sas_device && sas_device->starget &&
 	     sas_device->starget->hostdata) {
 		sas_target_priv_data = sas_device->starget->hostdata;
@@ -3131,14 +3198,14 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	if (!smid) {
 		delayed_tr = kzalloc(sizeof(*delayed_tr), GFP_ATOMIC);
 		if (!delayed_tr)
-			return;
+			goto out;
 		INIT_LIST_HEAD(&delayed_tr->list);
 		delayed_tr->handle = handle;
 		list_add_tail(&delayed_tr->list, &ioc->delayed_tr_list);
 		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
 		    "DELAYED:tr:handle(0x%04x), (open)\n",
 		    ioc->name, handle));
-		return;
+		goto out;
 	}
 
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "tr_send:handle(0x%04x), "
@@ -3150,6 +3217,9 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
 	mpt2sas_base_put_smid_hi_priority(ioc, smid);
+out:
+	if (sas_device)
+		sas_device_put(sas_device);
 }
 
 
@@ -4068,7 +4138,6 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	char *desc_scsi_state = ioc->tmp_string;
 	u32 log_info = le32_to_cpu(mpi_reply->IOCLogInfo);
 	struct _sas_device *sas_device = NULL;
-	unsigned long flags;
 	struct scsi_target *starget = scmd->device->sdev_target;
 	struct MPT2SAS_TARGET *priv_target = starget->hostdata;
 	char *device_str = NULL;
@@ -4200,8 +4269,7 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		printk(MPT2SAS_WARN_FMT "\t%s wwid(0x%016llx)\n", ioc->name,
 		    device_str, (unsigned long long)priv_target->sas_address);
 	} else {
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+		sas_device = mpt2sas_scsih_sas_device_get_by_sas_address(ioc,
 		    priv_target->sas_address);
 		if (sas_device) {
 			printk(MPT2SAS_WARN_FMT "\tsas_address(0x%016llx), "
@@ -4211,8 +4279,9 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 			    "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
 			    ioc->name, sas_device->enclosure_logical_id,
 			    sas_device->slot);
+
+			sas_device_put(sas_device);
 		}
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
 
 	printk(MPT2SAS_WARN_FMT "\thandle(0x%04x), ioc_status(%s)(0x%04x), "
@@ -4259,7 +4328,7 @@ _scsih_turn_on_pfa_led(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	Mpi2SepRequest_t mpi_request;
 	struct _sas_device *sas_device;
 
-	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	sas_device = _scsih_sas_device_get_by_handle(ioc, handle);
 	if (!sas_device)
 		return;
 
@@ -4274,7 +4343,7 @@ _scsih_turn_on_pfa_led(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	    &mpi_request)) != 0) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n", ioc->name,
 		__FILE__, __LINE__, __func__);
-		return;
+		goto out;
 	}
 	sas_device->pfa_led_on = 1;
 
@@ -4284,8 +4353,10 @@ _scsih_turn_on_pfa_led(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		 "enclosure_processor: ioc_status (0x%04x), loginfo(0x%08x)\n",
 		 ioc->name, le16_to_cpu(mpi_reply.IOCStatus),
 		 le32_to_cpu(mpi_reply.IOCLogInfo)));
-		return;
+		goto out;
 	}
+out:
+	sas_device_put(sas_device);
 }
 
 /**
@@ -4370,19 +4441,17 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 
 	/* only handle non-raid devices */
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	sas_device = _scsih_sas_device_get_by_handle_nolock(ioc, handle);
 	if (!sas_device) {
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		return;
+		goto out_unlock;
 	}
 	starget = sas_device->starget;
 	sas_target_priv_data = starget->hostdata;
 
 	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_RAID_COMPONENT) ||
-	   ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))) {
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		return;
-	}
+	   ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)))
+		goto out_unlock;
+
 	starget_printk(KERN_WARNING, starget, "predicted fault\n");
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
@@ -4396,7 +4465,7 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	if (!event_reply) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
-		return;
+		goto out;
 	}
 
 	event_reply->Function = MPI2_FUNCTION_EVENT_NOTIFICATION;
@@ -4413,6 +4482,14 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	event_data->SASAddress = cpu_to_le64(sas_target_priv_data->sas_address);
 	mpt2sas_ctl_add_to_event_log(ioc, event_reply);
 	kfree(event_reply);
+out:
+	if (sas_device)
+		sas_device_put(sas_device);
+	return;
+
+out_unlock:
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	goto out;
 }
 
 /**
@@ -5148,14 +5225,13 @@ _scsih_check_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 	    sas_address);
 
 	if (!sas_device) {
 		printk(MPT2SAS_ERR_FMT "device is not present "
 		    "handle(0x%04x), no sas_device!!!\n", ioc->name, handle);
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		return;
+		goto out_unlock;
 	}
 
 	if (unlikely(sas_device->handle != handle)) {
@@ -5172,19 +5248,22 @@ _scsih_check_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	    MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)) {
 		printk(MPT2SAS_ERR_FMT "device is not present "
 		    "handle(0x%04x), flags!!!\n", ioc->name, handle);
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		return;
+		goto out_unlock;
 	}
 
 	/* check if there were any issues with discovery */
 	if (_scsih_check_access_status(ioc, sas_address, handle,
-	    sas_device_pg0.AccessStatus)) {
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		return;
-	}
+	    sas_device_pg0.AccessStatus))
+		goto out_unlock;
+
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	_scsih_ublock_io_device(ioc, sas_address);
+	return;
 
+out_unlock:
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	if (sas_device)
+		sas_device_put(sas_device);
 }
 
 /**
@@ -5208,7 +5287,6 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 	u32 ioc_status;
 	__le64 sas_address;
 	u32 device_info;
-	unsigned long flags;
 
 	if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
@@ -5250,14 +5328,13 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 		return -1;
 	}
 
-
-	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address(ioc,
 	    sas_address);
-	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
-	if (sas_device)
+	if (sas_device) {
+		sas_device_put(sas_device);
 		return 0;
+	}
 
 	sas_device = kzalloc(sizeof(struct _sas_device),
 	    GFP_KERNEL);
@@ -5267,6 +5344,7 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 		return -1;
 	}
 
+	kref_init(&sas_device->refcount);
 	sas_device->handle = handle;
 	if (_scsih_get_sas_address(ioc, le16_to_cpu
 		(sas_device_pg0.ParentDevHandle),
@@ -5344,7 +5422,6 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc,
 	    "handle(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
 	    sas_device->handle, (unsigned long long)
 	    sas_device->sas_address));
-	kfree(sas_device);
 }
 /**
  * _scsih_device_remove_by_handle - removing device object by handle
@@ -5363,12 +5440,17 @@ _scsih_device_remove_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	if (sas_device)
-		list_del(&sas_device->list);
+	sas_device = _scsih_sas_device_get_by_handle_nolock(ioc, handle);
+	if (sas_device) {
+		list_del_init(&sas_device->list);
+		sas_device_put(sas_device);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	if (sas_device)
+
+	if (sas_device) {
 		_scsih_remove_device(ioc, sas_device);
+		sas_device_put(sas_device);
+	}
 }
 
 /**
@@ -5389,13 +5471,17 @@ mpt2sas_device_remove_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
-	    sas_address);
-	if (sas_device)
-		list_del(&sas_device->list);
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc, sas_address);
+	if (sas_device) {
+		list_del_init(&sas_device->list);
+		sas_device_put(sas_device);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	if (sas_device)
+
+	if (sas_device) {
 		_scsih_remove_device(ioc, sas_device);
+		sas_device_put(sas_device);
+	}
 }
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 /**
@@ -5716,26 +5802,28 @@ _scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_address = le64_to_cpu(event_data->SASAddress);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 	    sas_address);
 
-	if (!sas_device || !sas_device->starget) {
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		return;
-	}
+	if (!sas_device || !sas_device->starget)
+		goto out;
 
 	target_priv_data = sas_device->starget->hostdata;
-	if (!target_priv_data) {
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		return;
-	}
+	if (!target_priv_data)
+		goto out;
 
 	if (event_data->ReasonCode ==
 	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET)
 		target_priv_data->tm_busy = 1;
 	else
 		target_priv_data->tm_busy = 0;
+
+out:
+	if (sas_device)
+		sas_device_put(sas_device);
+
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
 }
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
@@ -6123,7 +6211,7 @@ _scsih_sas_pd_expose(struct MPT2SAS_ADAPTER *ioc,
 	u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	sas_device = _scsih_sas_device_get_by_handle_nolock(ioc, handle);
 	if (sas_device) {
 		sas_device->volume_handle = 0;
 		sas_device->volume_wwid = 0;
@@ -6142,6 +6230,8 @@ _scsih_sas_pd_expose(struct MPT2SAS_ADAPTER *ioc,
 	/* exposing raid component */
 	if (starget)
 		starget_for_each_device(starget, NULL, _scsih_reprobe_lun);
+
+	sas_device_put(sas_device);
 }
 
 /**
@@ -6170,7 +6260,7 @@ _scsih_sas_pd_hide(struct MPT2SAS_ADAPTER *ioc,
 		    &volume_wwid);
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	sas_device = _scsih_sas_device_get_by_handle_nolock(ioc, handle);
 	if (sas_device) {
 		set_bit(handle, ioc->pd_handles);
 		if (sas_device->starget && sas_device->starget->hostdata) {
@@ -6189,6 +6279,8 @@ _scsih_sas_pd_hide(struct MPT2SAS_ADAPTER *ioc,
 	/* hiding raid component */
 	if (starget)
 		starget_for_each_device(starget, (void *)1, _scsih_reprobe_lun);
+
+	sas_device_put(sas_device);
 }
 
 /**
@@ -6221,7 +6313,6 @@ _scsih_sas_pd_add(struct MPT2SAS_ADAPTER *ioc,
     Mpi2EventIrConfigElement_t *element)
 {
 	struct _sas_device *sas_device;
-	unsigned long flags;
 	u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasDevicePage0_t sas_device_pg0;
@@ -6231,11 +6322,11 @@ _scsih_sas_pd_add(struct MPT2SAS_ADAPTER *ioc,
 
 	set_bit(handle, ioc->pd_handles);
 
-	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	if (sas_device)
+	sas_device = _scsih_sas_device_get_by_handle(ioc, handle);
+	if (sas_device) {
+		sas_device_put(sas_device);
 		return;
+	}
 
 	if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
@@ -6509,7 +6600,6 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc,
 	u16 handle, parent_handle;
 	u32 state;
 	struct _sas_device *sas_device;
-	unsigned long flags;
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasDevicePage0_t sas_device_pg0;
 	u32 ioc_status;
@@ -6542,12 +6632,11 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc,
 		if (!ioc->is_warpdrive)
 			set_bit(handle, ioc->pd_handles);
 
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-
-		if (sas_device)
+		sas_device = _scsih_sas_device_get_by_handle(ioc, handle);
+		if (sas_device) {
+			sas_device_put(sas_device);
 			return;
+		}
 
 		if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply,
 		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
@@ -7179,11 +7268,11 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		}
 		phys_disk_num = pd_pg0.PhysDiskNum;
 		handle = le16_to_cpu(pd_pg0.DevHandle);
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		if (sas_device)
+		sas_device = _scsih_sas_device_get_by_handle(ioc, handle);
+		if (sas_device) {
+			sas_device_put(sas_device);
 			continue;
+		}
 		if (mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply,
 		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
 		    handle) != 0)
@@ -7302,12 +7391,12 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		if (!(_scsih_is_end_device(
 		    le32_to_cpu(sas_device_pg0.DeviceInfo))))
 			continue;
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+		sas_device = mpt2sas_scsih_sas_device_get_by_sas_address(ioc,
 		    le64_to_cpu(sas_device_pg0.SASAddress));
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		if (sas_device)
+		if (sas_device) {
+			sas_device_put(sas_device);
 			continue;
+		}
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address)) {
 			printk(MPT2SAS_INFO_FMT "\tBEFORE adding end device: "
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index ff2500a..ebfc827 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1323,15 +1323,17 @@ _transport_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
 	int rc;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 	    rphy->identify.sas_address);
 	if (sas_device) {
 		*identifier = sas_device->enclosure_logical_id;
 		rc = 0;
+		sas_device_put(sas_device);
 	} else {
 		*identifier = 0;
 		rc = -ENXIO;
 	}
+
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	return rc;
 }
@@ -1351,12 +1353,14 @@ _transport_get_bay_identifier(struct sas_rphy *rphy)
 	int rc;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	sas_device = mpt2sas_scsih_sas_device_get_by_sas_address_nolock(ioc,
 	    rphy->identify.sas_address);
-	if (sas_device)
+	if (sas_device) {
 		rc = sas_device->slot;
-	else
+		sas_device_put(sas_device);
+	} else {
 		rc = -ENXIO;
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	return rc;
 }
-- 
1.8.1
