From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/3] mpt2sas: Adding enclosure/slot sorting logic
Date: Wed, 4 Aug 2010 14:05:39 +0530
Message-ID: <20100804083531.GC13442@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:56361 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756972Ab0HDJNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2010 05:13:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Adding sorting support to driver so that during driver load time it will
sort devices using enclosure/slot mapping algorithm prior to reporting
devices to OS.  This is only done when ioc page 8 says to sort
enclosure/slot mode.  The driver will handle sorting by enclosure handle
and slot when available. If that is not available, then it will sort by
parent device handle and phy number. For persistent device mapping mode
the driver will not sort.

This patch is for sorting devices. The customer desire is for devices to be
reported to OS to be consistent manner across reboots and across multiple
systems with similar topology. Current design in the driver is to report
devices in the order of firmware discovery, which can change due to
variations in device spin up time. The suggested change in the driver is to
prepare a sorted list prior to reporting devices to the OS. This algorithm
will be based on Enclosure/Slot order algorithm.

For this algorithm to be implemented in the controller firmware, the
firmware needs memory space to account for several hundreds of devices
that could potentially be supported.  This specific version of the
controller hardware does not have the necessary memory to implement
this logic.  Hence the logic is implemented in the driver.

Here is overview of this patch:

(a) Check IOC Page 8. If the MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING bit
is not set in the flags field, then don't sort devices. When the flag is
cleared, then devices are added to list in the order of controller discovery.

(b) If the Enclosure/Slot mapping bit is set, then proceed to sort devices
as follows.

This is the Enclosure/SlotID mapping algorithm:

(1)If the list is empty, add the first device.

(2)If the new device has a Enclosure Handle set to zero, then proceed to the
Expander /Phy Number mapping algorithm (see next section).

(3)Traverse through the list. If the Enclosure Handle is zero, loop to the
next device. If we made it thru the entire list and didn't insert the new
device and then proceed to the Expander /Phy Number mapping algorithm. (see
next section)

(4)If Enclosure Handle less than the searched Enclosure Handle, then insert
new device before the searched device.

(5)If the Enclosure Handle is the same as the searched device Enclosure
Handle, then check the Slot ID. If the Slot ID is smaller than the searched
Slot ID, then insert new device before the searched device.

(6)If both Enclosure Handle and Slot ID are the same as searched devices,
then check Phy Number. If the PhyNumber is smaller than the searched device
PhyNumber, then insert new device before the searched device.

(7)If we hit the last entry in the list, then append new device to the tail.


This is the Expander /Phy Number mapping algorithm:

(1)Traverse through the list from the start. If the Parent Handle is less
than the search Parent Handle, then insert new device before the searched
device. Please note that the Parent Handle is parent of the attached device,
it would be either an host controller or expander.

(2)If the Parent Handle is the same as the searched device Parent Handle,
then check PhyNumber. If the PhyNumber is less than the searched PhyNumber,
then insert the new device before the searched device.

(3)If we made it through the entire list without adding the new device, then
append new device to tail of the list.


Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 3c1b088..3f390de 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -268,6 +268,7 @@ struct _internal_cmd {
  * @sas_address: device sas address
  * @device_name: retrieved from the SAS IDENTIFY frame.
  * @handle: device handle
+ * @parent_handle: handle to parent device
  * @sas_address_parent: sas address of parent expander or sas host
  * @enclosure_handle: enclosure handle
  * @enclosure_logical_id: enclosure logical identifier
@@ -286,6 +287,7 @@ struct _sas_device {
 	u64	sas_address;
 	u64	device_name;
 	u16	handle;
+	u16	parent_handle;
 	u64	sas_address_parent;
 	u16	enclosure_handle;
 	u64	enclosure_logical_id;
@@ -387,6 +389,7 @@ struct _sas_phy {
  * @num_phys: number phys belonging to this sas_host/expander
  * @sas_address: sas address of this sas_host/expander
  * @handle: handle for this sas_host/expander
+ * @parent_handle: handle to parent device
  * @sas_address_parent: sas address of parent expander or sas host
  * @enclosure_handle: handle for this a member of an enclosure
  * @device_info: bitwise defining capabilities of this sas_host/expander
@@ -400,6 +403,7 @@ struct _sas_node {
 	u8	num_phys;
 	u64	sas_address;
 	u16	handle;
+	u16	parent_handle;
 	u64	sas_address_parent;
 	u16	enclosure_handle;
 	u64	enclosure_logical_id;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 0e82863..a575961 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -583,6 +583,91 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
+ * _scsih_sort_by_expanders - insert sas_device based on expander sorting
+ * @ioc: per adapter object
+ * @sas_device: the sas_device object
+ *
+ */
+static void
+_scsih_sort_by_expanders(struct MPT2SAS_ADAPTER *ioc,
+    struct _sas_device *sas_device)
+{
+	struct _sas_device *curr;
+
+	list_for_each_entry(curr, &ioc->sas_device_init_list, list) {
+		if (sas_device->parent_handle < curr->parent_handle) {
+			__list_add(&sas_device->list, curr->list.prev,
+			   &curr->list);
+			return;
+		}
+		if (sas_device->parent_handle == curr->parent_handle &&
+		    sas_device->phy < curr->phy) {
+			__list_add(&sas_device->list, curr->list.prev,
+			   &curr->list);
+			return;
+		}
+	}
+	list_add_tail(&sas_device->list, &ioc->sas_device_init_list);
+}
+
+/**
+ * _scsih_sort_by_enclosures - insert sas_device based on enclosure sorting
+ * @ioc: per adapter object
+ * @sas_device: the sas_device object
+ *
+ */
+static void
+_scsih_sort_by_enclosures(struct MPT2SAS_ADAPTER *ioc,
+    struct _sas_device *sas_device)
+{
+	struct _sas_device *curr;
+	u16 flags;
+
+	flags = le16_to_cpu(ioc->ioc_pg8.Flags);
+	if (!(flags & MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING)) {
+		list_add_tail(&sas_device->list, &ioc->sas_device_init_list);
+		return;
+	}
+
+	if (list_empty(&ioc->sas_device_init_list)) {
+		list_add(&sas_device->list, &ioc->sas_device_init_list);
+		return;
+	}
+
+	if (!sas_device->enclosure_handle)
+		goto out;
+
+	list_for_each_entry(curr, &ioc->sas_device_init_list, list) {
+		if (!curr->enclosure_handle)
+			continue;
+		if (sas_device->enclosure_handle < curr->enclosure_handle) {
+			__list_add(&sas_device->list, curr->list.prev,
+			   &curr->list);
+			return;
+		}
+		if (sas_device->enclosure_handle == curr->enclosure_handle) {
+			if (sas_device->slot < curr->slot) {
+				__list_add(&sas_device->list, curr->list.prev,
+				   &curr->list);
+				return;
+			} else if (sas_device->slot == curr->slot &&
+				sas_device->phy < curr->phy) {
+					__list_add(&sas_device->list,
+					    curr->list.prev, &curr->list);
+					return;
+			}
+		}
+		if (list_is_last(&curr->list, &ioc->sas_device_init_list)) {
+			list_add_tail(&sas_device->list,
+			    &ioc->sas_device_init_list);
+			return;
+		}
+	}
+ out:
+	_scsih_sort_by_expanders(ioc, sas_device);
+}
+
+/**
  * _scsih_sas_device_init_add - insert sas_device to the list.
  * @ioc: per adapter object
  * @sas_device: the sas_device object
@@ -596,12 +681,17 @@ _scsih_sas_device_init_add(struct MPT2SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
-	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: handle"
-	    "(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
-	    sas_device->handle, (unsigned long long)sas_device->sas_address));
+	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
+	   "sas_addr(0x%016llx/0x%04x), "
+	   "enclosure_logical_id(0x%016llx/0x%04x/0x%04x), slot(%d), phy(%d)\n",
+	    ioc->name, __func__,
+	    (unsigned long long)sas_device->sas_address, sas_device->handle,
+	    (unsigned long long)sas_device->enclosure_logical_id,
+	    sas_device->enclosure_handle, sas_device->parent_handle,
+	    sas_device->slot, sas_device->phy));
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	list_add_tail(&sas_device->list, &ioc->sas_device_init_list);
+	_scsih_sort_by_enclosures(ioc, sas_device);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	_scsih_determine_boot_device(ioc, sas_device, 0);
 }
@@ -1758,9 +1848,11 @@ _scsih_slave_configure(struct scsi_device *sdev)
 		    sas_device->phy,
 		    (unsigned long long)sas_device->device_name);
 		sdev_printk(KERN_INFO, sdev, "%s: "
-		    "enclosure_logical_id(0x%016llx), slot(%d)\n", ds,
-		    (unsigned long long) sas_device->enclosure_logical_id,
-		    sas_device->slot);
+		    "enclosure_logical_id(0x%016llx/0x%04x), slot(%d), "
+		    "phy(%d)\n", ds,
+		    (unsigned long long)sas_device->enclosure_logical_id,
+		    sas_device->enclosure_handle,
+		    sas_device->slot, sas_device->phy);
 
 		if (!ssp_target)
 			_scsih_display_sata_capabilities(ioc, sas_device, sdev);
@@ -4227,6 +4319,7 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 
 	sas_expander->handle = handle;
 	sas_expander->num_phys = expander_pg0.NumPhys;
+	sas_expander->parent_handle = parent_handle;
 	sas_expander->sas_address_parent = sas_address_parent;
 	sas_expander->sas_address = sas_address;
 
@@ -4570,6 +4663,8 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 		&sas_device->sas_address_parent) != 0)
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+	sas_device->parent_handle =
+			le16_to_cpu(sas_device_pg0.ParentDevHandle);
 	sas_device->enclosure_handle =
 	    le16_to_cpu(sas_device_pg0.EnclosureHandle);
 	sas_device->slot =
@@ -4577,6 +4672,7 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 	sas_device->device_info = device_info;
 	sas_device->sas_address = sas_address;
 	sas_device->phy = sas_device_pg0.PhyNum;
+	INIT_LIST_HEAD(&sas_device->list);
 
 	/* get enclosure_logical_id */
 	if (sas_device->enclosure_handle && !(mpt2sas_config_get_enclosure_pg0(
@@ -6838,6 +6934,22 @@ _scsih_probe_sas(struct MPT2SAS_ADAPTER *ioc)
 	struct _sas_device *sas_device, *next;
 	unsigned long flags;
 
+#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
+	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
+		list_for_each_entry(sas_device, &ioc->sas_device_init_list,
+		 list) {
+		printk(MPT2SAS_INFO_FMT "%s: sas_addr(0x%016llx/0x%04x), "
+		    "enclosure_logical_id(0x%016llx/0x%04x/0x%04x),"
+		    " slot(%d), phy(%d)\n",
+		    ioc->name, __func__, (unsigned long long)
+		    sas_device->sas_address, sas_device->handle,
+		    (unsigned long long)sas_device->enclosure_logical_id,
+		    sas_device->enclosure_handle, sas_device->parent_handle,
+		    sas_device->slot, sas_device->phy);
+		}
+	}
+#endif
+
 	/* SAS Device List */
 	list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
 	    list) {
