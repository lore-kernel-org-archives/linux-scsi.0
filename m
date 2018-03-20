From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH] mpt3sas: Cache enclosure pages during enclosure add.
Date: Tue, 20 Mar 2018 06:15:56 -0400
Message-ID: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: Bart.VanAssche@wdc.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

In function _scsih_add_device,
for each device connected to a enclosure, driver reads the
enclosure page.(To get details like enclosure handle,
enclosure logical ID, enclosure level etc.)

With this patch, Instead of reading enclosure page everytime,
driver maintains a list for enclosure device.(During enclosure
add event, enclosure device is added to the list and removed
from the list on delete events). and uses the enclosure
page from the list.

1) Enclosure page is read during enclosure add event and
added to the enclosure device list.
2) Introduced function "mpt3sas_scsih_enclosure_find_by_handle",
to get enclosure device and "mpt3sas_free_enclosure_list"
frees the list.
3) And "_scsih_create_enclosure_list_after_reset" reconstructs
the list after reset.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  22 +++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  14 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 299 +++++++++++++++++++++++------------
 3 files changed, 238 insertions(+), 97 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0a0e7aa..fa438e7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4082,6 +4082,27 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
+ * mpt3sas_free_enclosure_list - release memory
+ * @ioc: per adapter object
+ *
+ * Free memory allocated during encloure add.
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_free_enclosure_list(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct _enclosure_node *enclosure_dev, *enclosure_dev_next;
+
+	/* Free enclosure list */
+	list_for_each_entry_safe(enclosure_dev,
+			enclosure_dev_next, &ioc->enclosure_list, list) {
+		list_del(&enclosure_dev->list);
+		kfree(enclosure_dev);
+	}
+}
+
+/**
  * _base_release_memory_pools - release memory
  * @ioc: per adapter object
  *
@@ -6555,6 +6576,7 @@ mpt3sas_base_detach(struct MPT3SAS_ADAPTER *ioc)
 	mpt3sas_base_stop_watchdog(ioc);
 	mpt3sas_base_free_resources(ioc);
 	_base_release_memory_pools(ioc);
+	mpt3sas_free_enclosure_list(ioc);
 	pci_set_drvdata(ioc->pdev, NULL);
 	kfree(ioc->cpu_msix_table);
 	if (ioc->is_warpdrive)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4de0251..35252c6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -741,6 +741,17 @@ struct _sas_node {
 	struct list_head sas_port_list;
 };
 
+
+/**
+ * struct _enclosure_node - enclosure information
+ * @list: list of enclosures
+ * @pg0: enclosure pg0;
+ */
+struct _enclosure_node {
+	struct list_head list;
+	Mpi2SasEnclosurePage0_t pg0;
+};
+
 /**
  * enum reset_type - reset state
  * @FORCE_BIG_HAMMER: issue diagnostic reset
@@ -1009,6 +1020,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @iounit_pg8: static iounit page 8
  * @sas_hba: sas host object
  * @sas_expander_list: expander object list
+ * @enclosure_list: enclosure object list
  * @sas_node_lock:
  * @sas_device_list: sas device object list
  * @sas_device_init_list: sas device object list (used only at init time)
@@ -1214,6 +1226,7 @@ struct MPT3SAS_ADAPTER {
 	/* sas hba, expander, and device list */
 	struct _sas_node sas_hba;
 	struct list_head sas_expander_list;
+	struct list_head enclosure_list;
 	spinlock_t	sas_node_lock;
 	struct list_head sas_device_list;
 	struct list_head sas_device_init_list;
@@ -1384,6 +1397,7 @@ int mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_base_detach(struct MPT3SAS_ADAPTER *ioc);
 int mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_free_enclosure_list(struct MPT3SAS_ADAPTER *ioc);
 int mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	enum reset_type type);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 50efccd..2c03873 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1362,6 +1362,30 @@ mpt3sas_scsih_expander_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 }
 
 /**
+ * mpt3sas_scsih_enclosure_find_by_handle - exclosure device search
+ * @ioc: per adapter object
+ * @handle: enclosure handle (assigned by firmware)
+ * Context: Calling function should acquire ioc->sas_device_lock
+ *
+ * This searches for enclosure device based on handle, then returns the
+ * enclosure object.
+ */
+struct _enclosure_node *
+mpt3sas_scsih_enclosure_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _enclosure_node *enclosure_dev, *r;
+
+	r = NULL;
+	list_for_each_entry(enclosure_dev, &ioc->enclosure_list, list) {
+		if (le16_to_cpu(enclosure_dev->pg0.EnclosureHandle) != handle)
+			continue;
+		r = enclosure_dev;
+		goto out;
+	}
+out:
+	return r;
+}
+/**
  * mpt3sas_scsih_expander_find_by_sas_address - expander device search
  * @ioc: per adapter object
  * @sas_address: sas address
@@ -5615,10 +5639,10 @@ static int
 _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 {
 	struct _sas_node *sas_expander;
+	struct _enclosure_node *enclosure_dev;
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2ExpanderPage0_t expander_pg0;
 	Mpi2ExpanderPage1_t expander_pg1;
-	Mpi2SasEnclosurePage0_t enclosure_pg0;
 	u32 ioc_status;
 	u16 parent_handle;
 	u64 sas_address, sas_address_parent = 0;
@@ -5740,11 +5764,12 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	}
 
 	if (sas_expander->enclosure_handle) {
-		if (!(mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
-		    &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
-		   sas_expander->enclosure_handle)))
+		enclosure_dev =
+			mpt3sas_scsih_enclosure_find_by_handle(ioc,
+						sas_expander->enclosure_handle);
+		if (enclosure_dev)
 			sas_expander->enclosure_logical_id =
-			    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
+			    le64_to_cpu(enclosure_dev->pg0.EnclosureLogicalID);
 	}
 
 	_scsih_expander_node_add(ioc, sas_expander);
@@ -5888,52 +5913,6 @@ _scsih_check_access_status(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 }
 
 /**
- * _scsih_get_enclosure_logicalid_chassis_slot - get device's
- *			EnclosureLogicalID and ChassisSlot information.
- * @ioc: per adapter object
- * @sas_device_pg0: SAS device page0
- * @sas_device: per sas device object
- *
- * Returns nothing.
- */
-static void
-_scsih_get_enclosure_logicalid_chassis_slot(struct MPT3SAS_ADAPTER *ioc,
-	Mpi2SasDevicePage0_t *sas_device_pg0, struct _sas_device *sas_device)
-{
-	Mpi2ConfigReply_t mpi_reply;
-	Mpi2SasEnclosurePage0_t enclosure_pg0;
-
-	if (!sas_device_pg0 || !sas_device)
-		return;
-
-	sas_device->enclosure_handle =
-	    le16_to_cpu(sas_device_pg0->EnclosureHandle);
-	sas_device->is_chassis_slot_valid = 0;
-
-	if (!le16_to_cpu(sas_device_pg0->EnclosureHandle))
-		return;
-
-	if (mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
-	    &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
-	    le16_to_cpu(sas_device_pg0->EnclosureHandle))) {
-		pr_err(MPT3SAS_FMT
-		    "Enclosure Pg0 read failed for handle(0x%04x)\n",
-		    ioc->name, le16_to_cpu(sas_device_pg0->EnclosureHandle));
-		return;
-	}
-
-	sas_device->enclosure_logical_id =
-	    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
-
-	if (le16_to_cpu(enclosure_pg0.Flags) &
-	    MPI2_SAS_ENCLS0_FLAGS_CHASSIS_SLOT_VALID) {
-		sas_device->is_chassis_slot_valid = 1;
-		sas_device->chassis_slot = enclosure_pg0.ChassisSlot;
-	}
-}
-
-
-/**
  * _scsih_check_device - checking device responsiveness
  * @ioc: per adapter object
  * @parent_sas_address: sas address of parent expander or sas host
@@ -5950,6 +5929,7 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasDevicePage0_t sas_device_pg0;
 	struct _sas_device *sas_device;
+	struct _enclosure_node *enclosure_dev = NULL;
 	u32 ioc_status;
 	unsigned long flags;
 	u64 sas_address;
@@ -6004,8 +5984,21 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 			sas_device->connector_name[0] = '\0';
 		}
 
-		_scsih_get_enclosure_logicalid_chassis_slot(ioc,
-		    &sas_device_pg0, sas_device);
+		sas_device->enclosure_handle =
+				le16_to_cpu(sas_device_pg0.EnclosureHandle);
+		sas_device->is_chassis_slot_valid = 0;
+		enclosure_dev = mpt3sas_scsih_enclosure_find_by_handle(ioc,
+						sas_device->enclosure_handle);
+		if (enclosure_dev) {
+			sas_device->enclosure_logical_id =
+			    le64_to_cpu(enclosure_dev->pg0.EnclosureLogicalID);
+			if (le16_to_cpu(enclosure_dev->pg0.Flags) &
+			    MPI2_SAS_ENCLS0_FLAGS_CHASSIS_SLOT_VALID) {
+				sas_device->is_chassis_slot_valid = 1;
+				sas_device->chassis_slot =
+					enclosure_dev->pg0.ChassisSlot;
+			}
+		}
 	}
 
 	/* check if device is present */
@@ -6052,12 +6045,11 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 {
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasDevicePage0_t sas_device_pg0;
-	Mpi2SasEnclosurePage0_t enclosure_pg0;
 	struct _sas_device *sas_device;
+	struct _enclosure_node *enclosure_dev = NULL;
 	u32 ioc_status;
 	u64 sas_address;
 	u32 device_info;
-	int encl_pg0_rc = -1;
 
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
@@ -6103,13 +6095,13 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	}
 
 	if (sas_device_pg0.EnclosureHandle) {
-		encl_pg0_rc = mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
-		    &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
-		    sas_device_pg0.EnclosureHandle);
-		if (encl_pg0_rc)
-			pr_info(MPT3SAS_FMT
-			    "Enclosure Pg0 read failed for handle(0x%04x)\n",
-			    ioc->name, sas_device_pg0.EnclosureHandle);
+		enclosure_dev =
+			mpt3sas_scsih_enclosure_find_by_handle(ioc,
+						sas_device_pg0.EnclosureHandle);
+		if (enclosure_dev == NULL)
+			pr_info(MPT3SAS_FMT "Enclosure handle(0x%04x)"
+			       "doesn't match with enclosure device!\n",
+			       ioc->name, sas_device_pg0.EnclosureHandle);
 	}
 
 	sas_device = kzalloc(sizeof(struct _sas_device),
@@ -6149,18 +6141,16 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 		sas_device->enclosure_level = 0;
 		sas_device->connector_name[0] = '\0';
 	}
-
-	/* get enclosure_logical_id & chassis_slot */
+	/* get enclosure_logical_id & chassis_slot*/
 	sas_device->is_chassis_slot_valid = 0;
-	if (encl_pg0_rc == 0) {
+	if (enclosure_dev) {
 		sas_device->enclosure_logical_id =
-		    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
-
-		if (le16_to_cpu(enclosure_pg0.Flags) &
+		    le64_to_cpu(enclosure_dev->pg0.EnclosureLogicalID);
+		if (le16_to_cpu(enclosure_dev->pg0.Flags) &
 		    MPI2_SAS_ENCLS0_FLAGS_CHASSIS_SLOT_VALID) {
 			sas_device->is_chassis_slot_valid = 1;
 			sas_device->chassis_slot =
-			    enclosure_pg0.ChassisSlot;
+					enclosure_dev->pg0.ChassisSlot;
 		}
 	}
 
@@ -6842,8 +6832,8 @@ _scsih_pcie_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	Mpi26PCIeDevicePage0_t pcie_device_pg0;
 	Mpi26PCIeDevicePage2_t pcie_device_pg2;
 	Mpi2ConfigReply_t mpi_reply;
-	Mpi2SasEnclosurePage0_t enclosure_pg0;
 	struct _pcie_device *pcie_device;
+	struct _enclosure_node *enclosure_dev;
 	u32 pcie_device_type;
 	u32 ioc_status;
 	u64 wwid;
@@ -6925,13 +6915,14 @@ _scsih_pcie_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	}
 
 	/* get enclosure_logical_id */
-	if (pcie_device->enclosure_handle &&
-		!(mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
-			&enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
-			pcie_device->enclosure_handle)))
-		pcie_device->enclosure_logical_id =
-			le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
-
+	if (pcie_device->enclosure_handle) {
+		enclosure_dev =
+			mpt3sas_scsih_enclosure_find_by_handle(ioc,
+						pcie_device->enclosure_handle);
+		if (enclosure_dev)
+			pcie_device->enclosure_logical_id =
+			    le64_to_cpu(enclosure_dev->pg0.EnclosureLogicalID);
+	}
 	/* TODO -- Add device name once FW supports it */
 	if (mpt3sas_config_get_pcie_device_pg2(ioc, &mpi_reply,
 		&pcie_device_pg2, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle)) {
@@ -7317,10 +7308,61 @@ static void
 _scsih_sas_enclosure_dev_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 	struct fw_event_work *fw_event)
 {
+	Mpi2ConfigReply_t mpi_reply;
+	struct _enclosure_node *enclosure_dev = NULL;
+	Mpi2EventDataSasEnclDevStatusChange_t *event_data =
+		(Mpi2EventDataSasEnclDevStatusChange_t *)fw_event->event_data;
+	int rc;
+
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_enclosure_dev_status_change_event_debug(ioc,
 		     (Mpi2EventDataSasEnclDevStatusChange_t *)
 		     fw_event->event_data);
+	if (ioc->shost_recovery)
+		return;
+
+	event_data->EnclosureHandle = le16_to_cpu(event_data->EnclosureHandle);
+
+	if (event_data->EnclosureHandle)
+		enclosure_dev =
+			mpt3sas_scsih_enclosure_find_by_handle(ioc,
+						event_data->EnclosureHandle);
+	switch (event_data->ReasonCode) {
+	case MPI2_EVENT_SAS_ENCL_RC_ADDED:
+		if (!enclosure_dev) {
+			enclosure_dev =
+				kzalloc(sizeof(struct _enclosure_node),
+					GFP_KERNEL);
+			if (!enclosure_dev) {
+				pr_info(MPT3SAS_FMT
+					"failure at %s:%d/%s()!\n", ioc->name,
+					__FILE__, __LINE__, __func__);
+				return;
+			}
+			rc = mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
+				&enclosure_dev->pg0,
+				MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
+				event_data->EnclosureHandle);
+
+			if (rc || (le16_to_cpu(mpi_reply.IOCStatus) &
+						MPI2_IOCSTATUS_MASK)) {
+				kfree(enclosure_dev);
+				return;
+			}
+
+			list_add_tail(&enclosure_dev->list,
+							&ioc->enclosure_list);
+		}
+		break;
+	case MPI2_EVENT_SAS_ENCL_RC_NOT_RESPONDING:
+		if (enclosure_dev) {
+			list_del(&enclosure_dev->list);
+			kfree(enclosure_dev);
+		}
+		break;
+	default:
+		break;
+	}
 }
 
 /**
@@ -8357,8 +8399,18 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
 	struct MPT3SAS_TARGET *sas_target_priv_data = NULL;
 	struct scsi_target *starget;
 	struct _sas_device *sas_device = NULL;
+	struct _enclosure_node *enclosure_dev = NULL;
 	unsigned long flags;
 
+	if (sas_device_pg0->EnclosureHandle) {
+		enclosure_dev =
+			mpt3sas_scsih_enclosure_find_by_handle(ioc,
+					sas_device_pg0->EnclosureHandle);
+		if (enclosure_dev == NULL)
+			pr_info(MPT3SAS_FMT "Enclosure handle(0x%04x)"
+			    "doesn't match with enclosure device!\n",
+			    ioc->name, sas_device_pg0->EnclosureHandle);
+	}
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
 		if ((sas_device->sas_address == sas_device_pg0->SASAddress) &&
@@ -8397,8 +8449,19 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
 				sas_device->connector_name[0] = '\0';
 			}
 
-			_scsih_get_enclosure_logicalid_chassis_slot(ioc,
-			    sas_device_pg0, sas_device);
+			sas_device->enclosure_handle =
+				le16_to_cpu(sas_device_pg0->EnclosureHandle);
+			sas_device->is_chassis_slot_valid = 0;
+			if (enclosure_dev) {
+				sas_device->enclosure_logical_id = le64_to_cpu(
+					enclosure_dev->pg0.EnclosureLogicalID);
+				if (le16_to_cpu(enclosure_dev->pg0.Flags) &
+				    MPI2_SAS_ENCLS0_FLAGS_CHASSIS_SLOT_VALID) {
+					sas_device->is_chassis_slot_valid = 1;
+					sas_device->chassis_slot =
+						enclosure_dev->pg0.ChassisSlot;
+				}
+			}
 
 			if (sas_device->handle == sas_device_pg0->DevHandle)
 				goto out;
@@ -8416,6 +8479,52 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
 }
 
 /**
+ * _scsih_create_enclosure_list_after_reset - Free Existing list,
+ *	And create enclosure list by scanning all Enclosure Page(0)s
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_scsih_create_enclosure_list_after_reset(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct _enclosure_node *enclosure_dev;
+	Mpi2ConfigReply_t mpi_reply;
+	u16 enclosure_handle;
+	int rc;
+
+	/* Free existing enclosure list */
+	mpt3sas_free_enclosure_list(ioc);
+
+	/* Re constructing enclosure list after reset*/
+	enclosure_handle = 0xFFFF;
+	do {
+		enclosure_dev =
+			kzalloc(sizeof(struct _enclosure_node), GFP_KERNEL);
+		if (!enclosure_dev) {
+			pr_err(MPT3SAS_FMT
+				"failure at %s:%d/%s()!\n", ioc->name,
+				__FILE__, __LINE__, __func__);
+			return;
+		}
+		rc = mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
+				&enclosure_dev->pg0,
+				MPI2_SAS_ENCLOS_PGAD_FORM_GET_NEXT_HANDLE,
+				enclosure_handle);
+
+		if (rc || (le16_to_cpu(mpi_reply.IOCStatus) &
+						MPI2_IOCSTATUS_MASK)) {
+			kfree(enclosure_dev);
+			return;
+		}
+		list_add_tail(&enclosure_dev->list,
+						&ioc->enclosure_list);
+		enclosure_handle =
+			le16_to_cpu(enclosure_dev->pg0.EnclosureHandle);
+	} while (1);
+}
+
+/**
  * _scsih_search_responding_sas_devices -
  * @ioc: per adapter object
  *
@@ -8733,22 +8842,16 @@ _scsih_mark_responding_expander(struct MPT3SAS_ADAPTER *ioc,
 {
 	struct _sas_node *sas_expander = NULL;
 	unsigned long flags;
-	int i, encl_pg0_rc = -1;
-	Mpi2ConfigReply_t mpi_reply;
-	Mpi2SasEnclosurePage0_t enclosure_pg0;
+	int i;
+	struct _enclosure_node *enclosure_dev = NULL;
 	u16 handle = le16_to_cpu(expander_pg0->DevHandle);
+	u16 enclosure_handle = le16_to_cpu(expander_pg0->EnclosureHandle);
 	u64 sas_address = le64_to_cpu(expander_pg0->SASAddress);
 
-	if (le16_to_cpu(expander_pg0->EnclosureHandle)) {
-		encl_pg0_rc = mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
-		    &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
-		    le16_to_cpu(expander_pg0->EnclosureHandle));
-		if (encl_pg0_rc)
-			pr_info(MPT3SAS_FMT
-			    "Enclosure Pg0 read failed for handle(0x%04x)\n",
-			    ioc->name,
-			    le16_to_cpu(expander_pg0->EnclosureHandle));
-	}
+	if (enclosure_handle)
+		enclosure_dev =
+			mpt3sas_scsih_enclosure_find_by_handle(ioc,
+							enclosure_handle);
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	list_for_each_entry(sas_expander, &ioc->sas_expander_list, list) {
@@ -8756,12 +8859,12 @@ _scsih_mark_responding_expander(struct MPT3SAS_ADAPTER *ioc,
 			continue;
 		sas_expander->responding = 1;
 
-		if (!encl_pg0_rc)
+		if (enclosure_dev) {
 			sas_expander->enclosure_logical_id =
-			    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
-
-		sas_expander->enclosure_handle =
-		    le16_to_cpu(expander_pg0->EnclosureHandle);
+			    le64_to_cpu(enclosure_dev->pg0.EnclosureLogicalID);
+			sas_expander->enclosure_handle =
+			    le16_to_cpu(expander_pg0->EnclosureHandle);
+		}
 
 		if (sas_expander->handle == handle)
 			goto out;
@@ -9283,6 +9386,7 @@ mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
 		if ((!ioc->is_driver_loading) && !(disable_discovery > 0 &&
 		    !ioc->sas_hba.num_phys)) {
 			_scsih_prep_device_scan(ioc);
+			_scsih_create_enclosure_list_after_reset(ioc);
 			_scsih_search_responding_sas_devices(ioc);
 			_scsih_search_responding_pcie_devices(ioc);
 			_scsih_search_responding_raid_devices(ioc);
@@ -10502,6 +10606,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->sas_device_list);
 	INIT_LIST_HEAD(&ioc->sas_device_init_list);
 	INIT_LIST_HEAD(&ioc->sas_expander_list);
+	INIT_LIST_HEAD(&ioc->enclosure_list);
 	INIT_LIST_HEAD(&ioc->pcie_device_list);
 	INIT_LIST_HEAD(&ioc->pcie_device_init_list);
 	INIT_LIST_HEAD(&ioc->fw_event_list);
-- 
1.8.3.1
