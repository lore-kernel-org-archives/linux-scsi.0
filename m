From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 02/13] mpt3sas: Add nvme device support in slave alloc, target alloc and probe
Date: Tue,  8 Aug 2017 14:33:44 +0530
Message-ID: <1502183035-7441-3-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1502183035-7441-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502183035-7441-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

1) Added support for probing pcie device and adding NVMe drives to
SML and driver's internal list pcie_device_list.

2) Added support for determing NVMe as boot device.

3) Added nvme device support for call back functions scan_finished
target_alloc,slave_alloc,target destroy and slave destroy.

 a) During scan, pcie devices are probed and added to SML to drivers
internal list.

 b) target_alloc & slave alloc API's allocates resources for
(MPT3SAS_TARGET & MPT3SAS_DEVICE) private datas and holds
information like handle, target_id etc.

 c) slave_destroy & target_destroy are called when driver unregisters
or removes device. Also frees allocated resources and info.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  110 ++++++++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  431 +++++++++++++++++++++++++++++++---
 2 files changed, 507 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 099ab4c..c522057 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -159,6 +159,7 @@
 #define MPT_TARGET_FLAGS_VOLUME		0x02
 #define MPT_TARGET_FLAGS_DELETED	0x04
 #define MPT_TARGET_FASTPATH_IO		0x08
+#define MPT_TARGET_FLAGS_PCIE_DEVICE	0x10
 
 #define SAS2_PCI_DEVICE_B0_REVISION	(0x01)
 #define SAS3_PCI_DEVICE_C0_REVISION	(0x02)
@@ -357,7 +358,8 @@ struct Mpi2ManufacturingPage11_t {
  * @flags: MPT_TARGET_FLAGS_XXX flags
  * @deleted: target flaged for deletion
  * @tm_busy: target is busy with TM request.
- * @sdev: The sas_device associated with this target
+ * @sas_dev: The sas_device associated with this target
+ * @pcie_dev: The pcie device associated with this target
  */
 struct MPT3SAS_TARGET {
 	struct scsi_target *starget;
@@ -368,7 +370,8 @@ struct MPT3SAS_TARGET {
 	u32	flags;
 	u8	deleted;
 	u8	tm_busy;
-	struct _sas_device *sdev;
+	struct _sas_device *sas_dev;
+	struct _pcie_device *pcie_dev;
 };
 
 
@@ -508,6 +511,89 @@ static inline void sas_device_put(struct _sas_device *s)
 	kref_put(&s->refcount, sas_device_free);
 }
 
+/*
+ * struct _pcie_device - attached PCIe device information
+ * @list: pcie device list
+ * @starget: starget object
+ * @wwid: device WWID
+ * @handle: device handle
+ * @device_info: bitfield provides detailed info about the device
+ * @id: target id
+ * @channel: target channel
+ * @slot: slot number
+ * @port_num: port number
+ * @responding: used in _scsih_pcie_device_mark_responding
+ * @fast_path: fast path feature enable bit
+ * @nvme_mdts: MaximumDataTransferSize from PCIe Device Page 2 for
+ *		NVMe device only
+ * @enclosure_handle: enclosure handle
+ * @enclosure_logical_id: enclosure logical identifier
+ * @enclosure_level: The level of device's enclosure from the controller
+ * @connector_name: ASCII value of the Connector's name
+ * @serial_number: pointer of serial number string allocated runtime
+ * @refcount: reference count for deletion
+ */
+struct _pcie_device {
+	struct list_head list;
+	struct scsi_target *starget;
+	u64	wwid;
+	u16	handle;
+	u32	device_info;
+	int	id;
+	int	channel;
+	u16	slot;
+	u8	port_num;
+	u8	responding;
+	u8	fast_path;
+	u32	nvme_mdts;
+	u16	enclosure_handle;
+	u64	enclosure_logical_id;
+	u8	enclosure_level;
+	u8	connector_name[4];
+	u8	*serial_number;
+	struct kref refcount;
+};
+/**
+ * pcie_device_get - Increment the pcie device reference count
+ *
+ * @p: pcie_device object
+ *
+ * When ever this function called it will increment the
+ * reference count of the pcie device for which this function called.
+ *
+ */
+static inline void pcie_device_get(struct _pcie_device *p)
+{
+	kref_get(&p->refcount);
+}
+
+/**
+ * pcie_device_free - Release the pcie device object
+ * @r - kref object
+ *
+ * Free's the pcie device object. It will be called when reference count
+ * reaches to zero.
+ */
+static inline void pcie_device_free(struct kref *r)
+{
+	kfree(container_of(r, struct _pcie_device, refcount));
+}
+
+/**
+ * pcie_device_put - Decrement the pcie device reference count
+ *
+ * @p: pcie_device object
+ *
+ * When ever this function called it will decrement the
+ * reference count of the pcie device for which this function called.
+ *
+ * When refernce count reaches to Zero, this will call pcie_device_free to the
+ * pcie_device object.
+ */
+static inline void pcie_device_put(struct _pcie_device *p)
+{
+	kref_put(&p->refcount, pcie_device_free);
+}
 /**
  * struct _raid_device - raid volume link list
  * @list: sas device list
@@ -556,12 +642,13 @@ struct _raid_device {
 
 /**
  * struct _boot_device - boot device info
- * @is_raid: flag to indicate whether this is volume
- * @device: holds pointer for either struct _sas_device or
- *     struct _raid_device
+ *
+ * @channel: sas, raid, or pcie channel
+ * @device: holds pointer for struct _sas_device, struct _raid_device or
+ *     struct _pcie_device
  */
 struct _boot_device {
-	u8 is_raid;
+	int channel;
 	void *device;
 };
 
@@ -825,6 +912,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @bars: bitmask of BAR's that must be configured
  * @mask_interrupts: ignore interrupt
  * @dma_mask: used to set the consistent dma mask
+ * @pci_access_mutex: Mutex to synchronize ioctl,sysfs show path and
+ *			pci resource handling
  * @fault_reset_work_q_name: fw fault work queue
  * @fault_reset_work_q: ""
  * @fault_reset_work: ""
@@ -888,9 +977,13 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @sas_device_list: sas device object list
  * @sas_device_init_list: sas device object list (used only at init time)
  * @sas_device_lock:
+ * @pcie_device_list: pcie device object list
+ * @pcie_device_init_list: pcie device object list (used only at init time)
+ * @pcie_device_lock:
  * @io_missing_delay: time for IO completed by fw when PDR enabled
  * @device_missing_delay: time for device missing by fw when PDR enabled
  * @sas_id : used for setting volume target IDs
+ * @pcie_target_id: used for setting pcie target IDs
  * @blocking_handles: bitmask used to identify which devices need blocking
  * @pd_handles : bitmask for PD handles
  * @pd_handles_sz : size of pd_handle bitmask
@@ -1086,11 +1179,16 @@ struct MPT3SAS_ADAPTER {
 	struct list_head sas_device_list;
 	struct list_head sas_device_init_list;
 	spinlock_t	sas_device_lock;
+	struct list_head pcie_device_list;
+	struct list_head pcie_device_init_list;
+	spinlock_t      pcie_device_lock;
+
 	struct list_head raid_device_list;
 	spinlock_t	raid_device_lock;
 	u8		io_missing_delay;
 	u16		device_missing_delay;
 	int		sas_id;
+	int		pcie_target_id;
 
 	void		*blocking_handles;
 	void		*pd_handles;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 22998cb..4b6b0fa 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -60,6 +60,9 @@
 #include "mpt3sas_base.h"
 
 #define RAID_CHANNEL 1
+
+#define PCIE_CHANNEL 2
+
 /* forward proto's */
 static void _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 	struct _sas_node *sas_expander);
@@ -439,21 +442,22 @@ _scsih_get_sas_address(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 /**
  * _scsih_determine_boot_device - determine boot device.
  * @ioc: per adapter object
- * @device: either sas_device or raid_device object
- * @is_raid: [flag] 1 = raid object, 0 = sas object
+ * @device: sas_device or pcie_device object
+ * @channel: SAS or PCIe channel
  *
  * Determines whether this device should be first reported device to
  * to scsi-ml or sas transport, this purpose is for persistent boot device.
  * There are primary, alternate, and current entries in bios page 2. The order
  * priority is primary, alternate, then current.  This routine saves
- * the corresponding device object and is_raid flag in the ioc object.
+ * the corresponding device object.
  * The saved data to be used later in _scsih_probe_boot_devices().
  */
 static void
-_scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc,
-	void *device, u8 is_raid)
+_scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc, void *device,
+	u32 channel)
 {
 	struct _sas_device *sas_device;
+	struct _pcie_device *pcie_device;
 	struct _raid_device *raid_device;
 	u64 sas_address;
 	u64 device_name;
@@ -468,18 +472,24 @@ _scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc,
 	if (!ioc->bios_pg3.BiosVersion)
 		return;
 
-	if (!is_raid) {
-		sas_device = device;
-		sas_address = sas_device->sas_address;
-		device_name = sas_device->device_name;
-		enclosure_logical_id = sas_device->enclosure_logical_id;
-		slot = sas_device->slot;
-	} else {
+	if (channel == RAID_CHANNEL) {
 		raid_device = device;
 		sas_address = raid_device->wwid;
 		device_name = 0;
 		enclosure_logical_id = 0;
 		slot = 0;
+	} else if (channel == PCIE_CHANNEL) {
+		pcie_device = device;
+		sas_address = pcie_device->wwid;
+		device_name = 0;
+		enclosure_logical_id = 0;
+		slot = 0;
+	} else {
+		sas_device = device;
+		sas_address = sas_device->sas_address;
+		device_name = sas_device->device_name;
+		enclosure_logical_id = sas_device->enclosure_logical_id;
+		slot = sas_device->slot;
 	}
 
 	if (!ioc->req_boot_device.device) {
@@ -493,7 +503,7 @@ _scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc,
 			    ioc->name, __func__,
 			    (unsigned long long)sas_address));
 			ioc->req_boot_device.device = device;
-			ioc->req_boot_device.is_raid = is_raid;
+			ioc->req_boot_device.channel = channel;
 		}
 	}
 
@@ -508,7 +518,7 @@ _scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc,
 			    ioc->name, __func__,
 			    (unsigned long long)sas_address));
 			ioc->req_alt_boot_device.device = device;
-			ioc->req_alt_boot_device.is_raid = is_raid;
+			ioc->req_alt_boot_device.channel = channel;
 		}
 	}
 
@@ -523,7 +533,7 @@ _scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc,
 			    ioc->name, __func__,
 			    (unsigned long long)sas_address));
 			ioc->current_boot_device.device = device;
-			ioc->current_boot_device.is_raid = is_raid;
+			ioc->current_boot_device.channel = channel;
 		}
 	}
 }
@@ -536,7 +546,7 @@ __mpt3sas_get_sdev_from_target(struct MPT3SAS_ADAPTER *ioc,
 
 	assert_spin_locked(&ioc->sas_device_lock);
 
-	ret = tgt_priv->sdev;
+	ret = tgt_priv->sas_dev;
 	if (ret)
 		sas_device_get(ret);
 
@@ -557,6 +567,44 @@ mpt3sas_get_sdev_from_target(struct MPT3SAS_ADAPTER *ioc,
 	return ret;
 }
 
+static struct _pcie_device *
+__mpt3sas_get_pdev_from_target(struct MPT3SAS_ADAPTER *ioc,
+	struct MPT3SAS_TARGET *tgt_priv)
+{
+	struct _pcie_device *ret;
+
+	assert_spin_locked(&ioc->pcie_device_lock);
+
+	ret = tgt_priv->pcie_dev;
+	if (ret)
+		pcie_device_get(ret);
+
+	return ret;
+}
+
+/**
+ * mpt3sas_get_pdev_from_target - pcie device search
+ * @ioc: per adapter object
+ * @tgt_priv: starget private object
+ *
+ * Context: This function will acquire ioc->pcie_device_lock and will release
+ * before returning the pcie_device object.
+ *
+ * This searches for pcie_device from target, then return pcie_device object.
+ */
+struct _pcie_device *
+mpt3sas_get_pdev_from_target(struct MPT3SAS_ADAPTER *ioc,
+	struct MPT3SAS_TARGET *tgt_priv)
+{
+	struct _pcie_device *ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	ret = __mpt3sas_get_pdev_from_target(ioc, tgt_priv);
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+
+	return ret;
+}
 
 struct _sas_device *
 __mpt3sas_get_sdev_by_addr(struct MPT3SAS_ADAPTER *ioc,
@@ -851,6 +899,146 @@ _scsih_sas_device_init_add(struct MPT3SAS_ADAPTER *ioc,
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 }
 
+
+struct _pcie_device *
+__mpt3sas_get_pdev_by_wwid(struct MPT3SAS_ADAPTER *ioc, u64 wwid)
+{
+	struct _pcie_device *pcie_device;
+
+	assert_spin_locked(&ioc->pcie_device_lock);
+
+	list_for_each_entry(pcie_device, &ioc->pcie_device_list, list)
+		if (pcie_device->wwid == wwid)
+			goto found_device;
+
+	list_for_each_entry(pcie_device, &ioc->pcie_device_init_list, list)
+		if (pcie_device->wwid == wwid)
+			goto found_device;
+
+	return NULL;
+
+found_device:
+	pcie_device_get(pcie_device);
+	return pcie_device;
+}
+
+
+/**
+ * mpt3sas_get_pdev_by_wwid - pcie device search
+ * @ioc: per adapter object
+ * @wwid: wwid
+ *
+ * Context: This function will acquire ioc->pcie_device_lock and will release
+ * before returning the pcie_device object.
+ *
+ * This searches for pcie_device based on wwid, then return pcie_device object.
+ */
+struct _pcie_device *
+mpt3sas_get_pdev_by_wwid(struct MPT3SAS_ADAPTER *ioc, u64 wwid)
+{
+	struct _pcie_device *pcie_device;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	pcie_device = __mpt3sas_get_pdev_by_wwid(ioc, wwid);
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+
+	return pcie_device;
+}
+
+
+struct _pcie_device *
+__mpt3sas_get_pdev_by_idchannel(struct MPT3SAS_ADAPTER *ioc, int id,
+	int channel)
+{
+	struct _pcie_device *pcie_device;
+
+	assert_spin_locked(&ioc->pcie_device_lock);
+
+	list_for_each_entry(pcie_device, &ioc->pcie_device_list, list)
+		if (pcie_device->id == id && pcie_device->channel == channel)
+			goto found_device;
+
+	list_for_each_entry(pcie_device, &ioc->pcie_device_init_list, list)
+		if (pcie_device->id == id && pcie_device->channel == channel)
+			goto found_device;
+
+	return NULL;
+
+found_device:
+	pcie_device_get(pcie_device);
+	return pcie_device;
+}
+
+
+/**
+ * mpt3sas_get_pdev_by_idchannel - pcie device search
+ * @ioc: per adapter object
+ * @id: Target ID
+ * @channel: Channel ID
+ *
+ * Context: This function will acquire ioc->pcie_device_lock and will release
+ * before returning the pcie_device object.
+ *
+ * This searches for pcie_device based on id and channel, then return
+ * pcie_device object.
+ */
+struct _pcie_device *
+mpt3sas_get_pdev_by_idchannel(struct MPT3SAS_ADAPTER *ioc, int id, int channel)
+{
+	struct _pcie_device *pcie_device;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	pcie_device = __mpt3sas_get_pdev_by_idchannel(ioc, id, channel);
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+
+	return pcie_device;
+}
+/**
+ * _scsih_pcie_device_remove - remove pcie_device from list.
+ * @ioc: per adapter object
+ * @pcie_device: the pcie_device object
+ * Context: This function will acquire ioc->pcie_device_lock.
+ *
+ * If pcie_device is on the list, remove it and decrement its reference count.
+ */
+static void
+_scsih_pcie_device_remove(struct MPT3SAS_ADAPTER *ioc,
+	struct _pcie_device *pcie_device)
+{
+	unsigned long flags;
+	int was_on_pcie_device_list = 0;
+
+	if (!pcie_device)
+		return;
+	pr_info(MPT3SAS_FMT
+		"removing handle(0x%04x), wwid(0x%016llx)\n",
+		ioc->name, pcie_device->handle,
+		(unsigned long long) pcie_device->wwid);
+	if (pcie_device->enclosure_handle != 0)
+		pr_info(MPT3SAS_FMT
+			"removing enclosure logical id(0x%016llx), slot(%d)\n",
+			ioc->name,
+			(unsigned long long)pcie_device->enclosure_logical_id,
+		pcie_device->slot);
+	if (pcie_device->connector_name[0] != '\0')
+		pr_info(MPT3SAS_FMT
+			"removing enclosure level(0x%04x), connector name( %s)\n",
+			ioc->name, pcie_device->enclosure_level,
+			pcie_device->connector_name);
+
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	if (!list_empty(&pcie_device->list)) {
+		list_del_init(&pcie_device->list);
+		was_on_pcie_device_list = 1;
+	}
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+	if (was_on_pcie_device_list) {
+		kfree(pcie_device->serial_number);
+		pcie_device_put(pcie_device);
+	}
+}
 /**
  * _scsih_raid_device_find_by_id - raid device search
  * @ioc: per adapter object
@@ -1278,6 +1466,7 @@ scsih_target_alloc(struct scsi_target *starget)
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct _sas_device *sas_device;
 	struct _raid_device *raid_device;
+	struct _pcie_device *pcie_device;
 	unsigned long flags;
 	struct sas_rphy *rphy;
 
@@ -1307,6 +1496,28 @@ scsih_target_alloc(struct scsi_target *starget)
 		return 0;
 	}
 
+	/* PCIe devices */
+	if (starget->channel == PCIE_CHANNEL) {
+		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+		pcie_device = __mpt3sas_get_pdev_by_idchannel(ioc, starget->id,
+			starget->channel);
+		if (pcie_device) {
+			sas_target_priv_data->handle = pcie_device->handle;
+			sas_target_priv_data->sas_address = pcie_device->wwid;
+			sas_target_priv_data->pcie_dev = pcie_device;
+			pcie_device->starget = starget;
+			pcie_device->id = starget->id;
+			pcie_device->channel = starget->channel;
+			sas_target_priv_data->flags |=
+				MPT_TARGET_FLAGS_PCIE_DEVICE;
+			if (pcie_device->fast_path)
+				sas_target_priv_data->flags |=
+					MPT_TARGET_FASTPATH_IO;
+		}
+		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+		return 0;
+	}
+
 	/* sas/sata devices */
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	rphy = dev_to_rphy(starget->dev.parent);
@@ -1316,7 +1527,7 @@ scsih_target_alloc(struct scsi_target *starget)
 	if (sas_device) {
 		sas_target_priv_data->handle = sas_device->handle;
 		sas_target_priv_data->sas_address = sas_device->sas_address;
-		sas_target_priv_data->sdev = sas_device;
+		sas_target_priv_data->sas_dev = sas_device;
 		sas_device->starget = starget;
 		sas_device->id = starget->id;
 		sas_device->channel = starget->channel;
@@ -1324,7 +1535,8 @@ scsih_target_alloc(struct scsi_target *starget)
 			sas_target_priv_data->flags |=
 			    MPT_TARGET_FLAGS_RAID_COMPONENT;
 		if (sas_device->fast_path)
-			sas_target_priv_data->flags |= MPT_TARGET_FASTPATH_IO;
+			sas_target_priv_data->flags |=
+					MPT_TARGET_FASTPATH_IO;
 	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
@@ -1345,7 +1557,9 @@ scsih_target_destroy(struct scsi_target *starget)
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct _sas_device *sas_device;
 	struct _raid_device *raid_device;
+	struct _pcie_device *pcie_device;
 	unsigned long flags;
+	struct sas_rphy *rphy;
 
 	sas_target_priv_data = starget->hostdata;
 	if (!sas_target_priv_data)
@@ -1363,7 +1577,29 @@ scsih_target_destroy(struct scsi_target *starget)
 		goto out;
 	}
 
+	if (starget->channel == PCIE_CHANNEL) {
+		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+		pcie_device = __mpt3sas_get_pdev_from_target(ioc,
+							sas_target_priv_data);
+		if (pcie_device && (pcie_device->starget == starget) &&
+			(pcie_device->id == starget->id) &&
+			(pcie_device->channel == starget->channel))
+			pcie_device->starget = NULL;
+
+		if (pcie_device) {
+			/*
+			 * Corresponding get() is in _scsih_target_alloc()
+			 */
+			sas_target_priv_data->pcie_dev = NULL;
+			pcie_device_put(pcie_device);
+			pcie_device_put(pcie_device);
+		}
+		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+		goto out;
+	}
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	rphy = dev_to_rphy(starget->dev.parent);
 	sas_device = __mpt3sas_get_sdev_from_target(ioc, sas_target_priv_data);
 	if (sas_device && (sas_device->starget == starget) &&
 	    (sas_device->id == starget->id) &&
@@ -1374,7 +1610,7 @@ scsih_target_destroy(struct scsi_target *starget)
 		/*
 		 * Corresponding get() is in _scsih_target_alloc()
 		 */
-		sas_target_priv_data->sdev = NULL;
+		sas_target_priv_data->sas_dev = NULL;
 		sas_device_put(sas_device);
 
 		sas_device_put(sas_device);
@@ -1403,6 +1639,7 @@ scsih_slave_alloc(struct scsi_device *sdev)
 	struct scsi_target *starget;
 	struct _raid_device *raid_device;
 	struct _sas_device *sas_device;
+	struct _pcie_device *pcie_device;
 	unsigned long flags;
 
 	sas_device_priv_data = kzalloc(sizeof(*sas_device_priv_data),
@@ -1431,8 +1668,22 @@ scsih_slave_alloc(struct scsi_device *sdev)
 			raid_device->sdev = sdev; /* raid is single lun */
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 	}
+	if (starget->channel == PCIE_CHANNEL) {
+		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+		pcie_device = __mpt3sas_get_pdev_by_wwid(ioc,
+				sas_target_priv_data->sas_address);
+		if (pcie_device && (pcie_device->starget == NULL)) {
+			sdev_printk(KERN_INFO, sdev,
+			    "%s : pcie_device->starget set to starget @ %d\n",
+			    __func__, __LINE__);
+			pcie_device->starget = starget;
+		}
+
+		if (pcie_device)
+			pcie_device_put(pcie_device);
+		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 
-	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
+	} else  if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		sas_device = __mpt3sas_get_sdev_by_addr(ioc,
 					sas_target_priv_data->sas_address);
@@ -1466,6 +1717,7 @@ scsih_slave_destroy(struct scsi_device *sdev)
 	struct Scsi_Host *shost;
 	struct MPT3SAS_ADAPTER *ioc;
 	struct _sas_device *sas_device;
+	struct _pcie_device *pcie_device;
 	unsigned long flags;
 
 	if (!sdev->hostdata)
@@ -1478,7 +1730,19 @@ scsih_slave_destroy(struct scsi_device *sdev)
 	shost = dev_to_shost(&starget->dev);
 	ioc = shost_priv(shost);
 
-	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
+	if (sas_target_priv_data->flags & MPT_TARGET_FLAGS_PCIE_DEVICE) {
+		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+		pcie_device = __mpt3sas_get_pdev_from_target(ioc,
+				sas_target_priv_data);
+		if (pcie_device && !sas_target_priv_data->num_luns)
+			pcie_device->starget = NULL;
+
+		if (pcie_device)
+			pcie_device_put(pcie_device);
+
+		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+
+	} else if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		sas_device = __mpt3sas_get_sdev_from_target(ioc,
 				sas_target_priv_data);
@@ -1581,6 +1845,7 @@ scsih_get_resync(struct device *dev)
 
 	percent_complete = 0;
 	handle = 0;
+
 	if (ioc->is_warpdrive)
 		goto out;
 
@@ -8330,42 +8595,52 @@ scsih_shutdown(struct pci_dev *pdev)
 static void
 _scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
 {
-	u8 is_raid;
+	u32 channel;
 	void *device;
 	struct _sas_device *sas_device;
 	struct _raid_device *raid_device;
+	struct _pcie_device *pcie_device;
 	u16 handle;
 	u64 sas_address_parent;
 	u64 sas_address;
 	unsigned long flags;
 	int rc;
+	int tid;
 
 	 /* no Bios, return immediately */
 	if (!ioc->bios_pg3.BiosVersion)
 		return;
 
 	device = NULL;
-	is_raid = 0;
 	if (ioc->req_boot_device.device) {
 		device =  ioc->req_boot_device.device;
-		is_raid = ioc->req_boot_device.is_raid;
+		channel = ioc->req_boot_device.channel;
 	} else if (ioc->req_alt_boot_device.device) {
 		device =  ioc->req_alt_boot_device.device;
-		is_raid = ioc->req_alt_boot_device.is_raid;
+		channel = ioc->req_alt_boot_device.channel;
 	} else if (ioc->current_boot_device.device) {
 		device =  ioc->current_boot_device.device;
-		is_raid = ioc->current_boot_device.is_raid;
+		channel = ioc->current_boot_device.channel;
 	}
 
 	if (!device)
 		return;
 
-	if (is_raid) {
+	if (channel == RAID_CHANNEL) {
 		raid_device = device;
 		rc = scsi_add_device(ioc->shost, RAID_CHANNEL,
 		    raid_device->id, 0);
 		if (rc)
 			_scsih_raid_device_remove(ioc, raid_device);
+	} else if (channel == PCIE_CHANNEL) {
+		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+		pcie_device = device;
+		tid = pcie_device->id;
+		list_move_tail(&pcie_device->list, &ioc->pcie_device_list);
+		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+		rc = scsi_add_device(ioc->shost, PCIE_CHANNEL, tid, 0);
+		if (rc)
+			_scsih_pcie_device_remove(ioc, pcie_device);
 	} else {
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		sas_device = device;
@@ -8498,6 +8773,101 @@ _scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
+ * get_next_pcie_device - Get the next pcie device
+ * @ioc: per adapter object
+ *
+ * Get the next pcie device from pcie_device_init_list list.
+ *
+ * Returns pcie device structure if pcie_device_init_list list is not empty
+ * otherwise returns NULL
+ */
+static struct _pcie_device *get_next_pcie_device(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct _pcie_device *pcie_device = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	if (!list_empty(&ioc->pcie_device_init_list)) {
+		pcie_device = list_first_entry(&ioc->pcie_device_init_list,
+				struct _pcie_device, list);
+		pcie_device_get(pcie_device);
+	}
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+
+	return pcie_device;
+}
+
+/**
+ * pcie_device_make_active - Add pcie device to pcie_device_list list
+ * @ioc: per adapter object
+ * @pcie_device: pcie device object
+ *
+ * Add the pcie device which has registered with SCSI Transport Later to
+ * pcie_device_list list
+ */
+static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
+		struct _pcie_device *pcie_device)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+
+	if (!list_empty(&pcie_device->list)) {
+		list_del_init(&pcie_device->list);
+		pcie_device_put(pcie_device);
+	}
+	pcie_device_get(pcie_device);
+	list_add_tail(&pcie_device->list, &ioc->pcie_device_list);
+
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+}
+
+/**
+ * _scsih_probe_pcie - reporting PCIe devices to scsi-ml
+ * @ioc: per adapter object
+ *
+ * Called during initial loading of the driver.
+ */
+static void
+_scsih_probe_pcie(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct _pcie_device *pcie_device;
+	int rc;
+
+	/* PCIe Device List */
+	while ((pcie_device = get_next_pcie_device(ioc))) {
+		if (pcie_device->starget) {
+			pcie_device_put(pcie_device);
+			continue;
+		}
+		rc = scsi_add_device(ioc->shost, PCIE_CHANNEL,
+			pcie_device->id, 0);
+		if (rc) {
+			_scsih_pcie_device_remove(ioc, pcie_device);
+			pcie_device_put(pcie_device);
+			continue;
+		} else if (!pcie_device->starget) {
+			/* CQ 206770:
+			 * When asyn scanning is enabled, its not possible to
+			 * remove devices while scanning is turned on due to an
+			 * oops in scsi_sysfs_add_sdev()->add_device()->
+			 * sysfs_addrm_start()
+			 */
+			if (!ioc->is_driver_loading) {
+			/* TODO-- Need to find out whether this condition will
+			 * occur or not
+			 */
+				_scsih_pcie_device_remove(ioc, pcie_device);
+				pcie_device_put(pcie_device);
+				continue;
+			}
+		}
+		pcie_device_make_active(ioc, pcie_device);
+		pcie_device_put(pcie_device);
+	}
+}
+
+/**
  * _scsih_probe_devices - probing for devices
  * @ioc: per adapter object
  *
@@ -8525,8 +8895,10 @@ _scsih_probe_devices(struct MPT3SAS_ADAPTER *ioc)
 			_scsih_probe_sas(ioc);
 			_scsih_probe_raid(ioc);
 		}
-	} else
+	} else {
 		_scsih_probe_sas(ioc);
+		_scsih_probe_pcie(ioc);
+	}
 }
 
 /**
@@ -8867,11 +9239,14 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->sas_node_lock);
 	spin_lock_init(&ioc->fw_event_lock);
 	spin_lock_init(&ioc->raid_device_lock);
+	spin_lock_init(&ioc->pcie_device_lock);
 	spin_lock_init(&ioc->diag_trigger_lock);
 
 	INIT_LIST_HEAD(&ioc->sas_device_list);
 	INIT_LIST_HEAD(&ioc->sas_device_init_list);
 	INIT_LIST_HEAD(&ioc->sas_expander_list);
+	INIT_LIST_HEAD(&ioc->pcie_device_list);
+	INIT_LIST_HEAD(&ioc->pcie_device_init_list);
 	INIT_LIST_HEAD(&ioc->fw_event_list);
 	INIT_LIST_HEAD(&ioc->raid_device_list);
 	INIT_LIST_HEAD(&ioc->sas_hba.sas_port_list);
-- 
1.7.1
