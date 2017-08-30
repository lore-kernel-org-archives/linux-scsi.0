From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v5 06/14] mpt3sas: API's to remove nvme drive from sml
Date: Wed, 30 Aug 2017 19:38:30 +0530
Message-ID: <1504102118-7152-7-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Below API's are included in nvme drive remove path.
_scsih_pcie_device_remove_by_handle
_scsih_pcie_device_remove_from_sml

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 148 ++++++++++++++++++++++++++++++++++-
 1 file changed, 145 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2f257e1..710ea63 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -73,6 +73,8 @@ static void _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	u8 retry_count, u8 is_pd);
 static int _scsih_pcie_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle);
+static void _scsih_pcie_device_remove_from_sml(struct MPT3SAS_ADAPTER *ioc,
+	struct _pcie_device *pcie_device);
 static u8 _scsih_check_for_pending_tm(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 
 /* global parameters */
@@ -1092,6 +1094,41 @@ _scsih_pcie_device_remove(struct MPT3SAS_ADAPTER *ioc,
 		pcie_device_put(pcie_device);
 	}
 }
+
+
+/**
+ * _scsih_pcie_device_remove_by_handle - removing pcie device object by handle
+ * @ioc: per adapter object
+ * @handle: device handle
+ *
+ * Return nothing.
+ */
+static void
+_scsih_pcie_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _pcie_device *pcie_device;
+	unsigned long flags;
+	int was_on_pcie_device_list = 0;
+
+	if (ioc->shost_recovery)
+		return;
+
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	pcie_device = __mpt3sas_get_pdev_by_handle(ioc, handle);
+	if (pcie_device) {
+		if (!list_empty(&pcie_device->list)) {
+			list_del_init(&pcie_device->list);
+			was_on_pcie_device_list = 1;
+			pcie_device_put(pcie_device);
+		}
+	}
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+	if (was_on_pcie_device_list) {
+		_scsih_pcie_device_remove_from_sml(ioc, pcie_device);
+		pcie_device_put(pcie_device);
+	}
+}
+
 /**
  * _scsih_pcie_device_add - add pcie_device object
  * @ioc: per adapter object
@@ -6533,6 +6570,83 @@ _scsih_check_pcie_access_status(struct MPT3SAS_ADAPTER *ioc, u64 wwid,
 			(unsigned long long)wwid, handle);
 	return rc;
 }
+
+/**
+ * _scsih_pcie_device_remove_from_sml -  removing pcie device
+ * from SML and free up associated memory
+ * @ioc: per adapter object
+ * @pcie_device: the pcie_device object
+ *
+ * Return nothing.
+ */
+static void
+_scsih_pcie_device_remove_from_sml(struct MPT3SAS_ADAPTER *ioc,
+	struct _pcie_device *pcie_device)
+{
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+	    "%s: enter: handle(0x%04x), wwid(0x%016llx)\n", ioc->name, __func__,
+	    pcie_device->handle, (unsigned long long)
+	    pcie_device->wwid));
+	if (pcie_device->enclosure_handle != 0)
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: enter: enclosure logical id(0x%016llx), slot(%d)\n",
+		    ioc->name, __func__,
+		    (unsigned long long)pcie_device->enclosure_logical_id,
+		    pcie_device->slot));
+	if (pcie_device->connector_name[0] != '\0')
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: enter: enclosure level(0x%04x), connector name( %s)\n",
+		    ioc->name, __func__,
+		    pcie_device->enclosure_level,
+		    pcie_device->connector_name));
+
+	if (pcie_device->starget && pcie_device->starget->hostdata) {
+		sas_target_priv_data = pcie_device->starget->hostdata;
+		sas_target_priv_data->deleted = 1;
+		_scsih_ublock_io_device(ioc, pcie_device->wwid);
+		sas_target_priv_data->handle = MPT3SAS_INVALID_DEVICE_HANDLE;
+	}
+
+	pr_info(MPT3SAS_FMT
+		"removing handle(0x%04x), wwid (0x%016llx)\n",
+		ioc->name, pcie_device->handle,
+		(unsigned long long) pcie_device->wwid);
+	if (pcie_device->enclosure_handle != 0)
+		pr_info(MPT3SAS_FMT
+		    "removing : enclosure logical id(0x%016llx), slot(%d)\n",
+		    ioc->name,
+		    (unsigned long long)pcie_device->enclosure_logical_id,
+		    pcie_device->slot);
+	if (pcie_device->connector_name[0] != '\0')
+		pr_info(MPT3SAS_FMT
+		    "removing: enclosure level(0x%04x), connector name( %s)\n",
+		    ioc->name, pcie_device->enclosure_level,
+		    pcie_device->connector_name);
+
+	if (pcie_device->starget)
+		scsi_remove_target(&pcie_device->starget->dev);
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+	    "%s: exit: handle(0x%04x), wwid(0x%016llx)\n", ioc->name, __func__,
+	    pcie_device->handle, (unsigned long long)
+	    pcie_device->wwid));
+	if (pcie_device->enclosure_handle != 0)
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: exit: enclosure logical id(0x%016llx), slot(%d)\n",
+			ioc->name, __func__,
+			(unsigned long long)pcie_device->enclosure_logical_id,
+			pcie_device->slot));
+	if (pcie_device->connector_name[0] != '\0')
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: exit: enclosure level(0x%04x), connector name( %s)\n",
+		    ioc->name, __func__, pcie_device->enclosure_level,
+		    pcie_device->connector_name));
+
+	kfree(pcie_device->serial_number);
+}
+
+
 /**
  * _scsih_pcie_check_device - checking device responsiveness
  * @ioc: per adapter object
@@ -8127,17 +8241,18 @@ _scsih_search_responding_expanders(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * _scsih_remove_unresponding_sas_devices - removing unresponding devices
+ * _scsih_remove_unresponding_devices - removing unresponding devices
  * @ioc: per adapter object
  *
  * Return nothing.
  */
 static void
-_scsih_remove_unresponding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
+_scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct _sas_device *sas_device, *sas_device_next;
 	struct _sas_node *sas_expander, *sas_expander_next;
 	struct _raid_device *raid_device, *raid_device_next;
+	struct _pcie_device *pcie_device, *pcie_device_next;
 	struct list_head tmp_list;
 	unsigned long flags;
 	LIST_HEAD(head);
@@ -8171,6 +8286,26 @@ _scsih_remove_unresponding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
 		sas_device_put(sas_device);
 	}
 
+	pr_info(MPT3SAS_FMT
+		" Removing unresponding devices: pcie end-devices\n"
+		, ioc->name);
+	INIT_LIST_HEAD(&head);
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	list_for_each_entry_safe(pcie_device, pcie_device_next,
+	    &ioc->pcie_device_list, list) {
+		if (!pcie_device->responding)
+			list_move_tail(&pcie_device->list, &head);
+		else
+			pcie_device->responding = 0;
+	}
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+
+	list_for_each_entry_safe(pcie_device, pcie_device_next, &head, list) {
+		_scsih_pcie_device_remove_from_sml(ioc, pcie_device);
+		list_del_init(&pcie_device->list);
+		pcie_device_put(pcie_device);
+	}
+
 	/* removing unresponding volumes */
 	if (ioc->ir_firmware) {
 		pr_info(MPT3SAS_FMT "removing unresponding devices: volumes\n",
@@ -8573,7 +8708,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 				goto out;
 			ssleep(1);
 		}
-		_scsih_remove_unresponding_sas_devices(ioc);
+		_scsih_remove_unresponding_devices(ioc);
 		_scsih_scan_for_devices_after_reset(ioc);
 		break;
 	case MPT3SAS_PORT_ENABLE_COMPLETE:
@@ -8955,6 +9090,7 @@ static void scsih_remove(struct pci_dev *pdev)
 	struct _sas_port *mpt3sas_port, *next_port;
 	struct _raid_device *raid_device, *next;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct _pcie_device *pcie_device, *pcienext;
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 
@@ -8983,6 +9119,12 @@ static void scsih_remove(struct pci_dev *pdev)
 		    (unsigned long long) raid_device->wwid);
 		_scsih_raid_device_remove(ioc, raid_device);
 	}
+	list_for_each_entry_safe(pcie_device, pcienext, &ioc->pcie_device_list,
+		list) {
+		_scsih_pcie_device_remove_from_sml(ioc, pcie_device);
+		list_del_init(&pcie_device->list);
+		pcie_device_put(pcie_device);
+	}
 
 	/* free ports attached to the sas_host */
 	list_for_each_entry_safe(mpt3sas_port, next_port,
-- 
2.5.5
