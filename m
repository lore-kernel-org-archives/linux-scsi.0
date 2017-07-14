From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 11/13] mpt3sas: NVMe drive support for BTDHMAPPING ioctl command and log info
Date: Fri, 14 Jul 2017 18:52:38 +0530
Message-ID: <1500038560-11231-12-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

* Added debug prints for pcie devices in ioctl debug path. Which
will be helpful for debugging.
* Added PCIe device support for ioctl BTDHMAPPING ioctl.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c |   88 +++++++++++++++++++++++------------
 1 files changed, 58 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 6362d60..99147ad 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -79,32 +79,6 @@ enum block_state {
 };
 
 /**
- * _ctl_sas_device_find_by_handle - sas device search
- * @ioc: per adapter object
- * @handle: sas device handle (assigned by firmware)
- * Context: Calling function should acquire ioc->sas_device_lock
- *
- * This searches for sas_device based on sas_address, then return sas_device
- * object.
- */
-static struct _sas_device *
-_ctl_sas_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
-{
-	struct _sas_device *sas_device, *r;
-
-	r = NULL;
-	list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
-		if (sas_device->handle != handle)
-			continue;
-		r = sas_device;
-		goto out;
-	}
-
- out:
-	return r;
-}
-
-/**
  * _ctl_display_some_debug - debug routine
  * @ioc: per adapter object
  * @smid: system request message index
@@ -229,10 +203,9 @@ _ctl_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 		Mpi2SCSIIOReply_t *scsi_reply =
 		    (Mpi2SCSIIOReply_t *)mpi_reply;
 		struct _sas_device *sas_device = NULL;
-		unsigned long flags;
+		struct _pcie_device *pcie_device = NULL;
 
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = _ctl_sas_device_find_by_handle(ioc,
+		sas_device = mpt3sas_get_sdev_by_handle(ioc,
 		    le16_to_cpu(scsi_reply->DevHandle));
 		if (sas_device) {
 			pr_warn(MPT3SAS_FMT "\tsas_address(0x%016llx), phy(%d)\n",
@@ -242,8 +215,25 @@ _ctl_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 			    "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
 			    ioc->name, (unsigned long long)
 			    sas_device->enclosure_logical_id, sas_device->slot);
+			sas_device_put(sas_device);
+		}
+		if (!sas_device) {
+			pcie_device = mpt3sas_get_pdev_by_handle(ioc,
+				le16_to_cpu(scsi_reply->DevHandle));
+			if (pcie_device) {
+				pr_warn(MPT3SAS_FMT
+				    "\tWWID(0x%016llx), port(%d)\n", ioc->name,
+				    (unsigned long long)pcie_device->wwid,
+				    pcie_device->port_num);
+				if (pcie_device->enclosure_handle != 0)
+					pr_warn(MPT3SAS_FMT
+					    "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
+					    ioc->name, (unsigned long long)
+					    pcie_device->enclosure_logical_id,
+					    pcie_device->slot);
+				pcie_device_put(pcie_device);
+			}
 		}
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 		if (scsi_reply->SCSIState || scsi_reply->SCSIStatus)
 			pr_info(MPT3SAS_FMT
 			    "\tscsi_state(0x%02x), scsi_status"
@@ -1353,6 +1343,42 @@ _ctl_btdh_search_sas_device(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
+ * _ctl_btdh_search_pcie_device - searching for pcie device
+ * @ioc: per adapter object
+ * @btdh: btdh ioctl payload
+ */
+static int
+_ctl_btdh_search_pcie_device(struct MPT3SAS_ADAPTER *ioc,
+	struct mpt3_ioctl_btdh_mapping *btdh)
+{
+	struct _pcie_device *pcie_device;
+	unsigned long flags;
+	int rc = 0;
+
+	if (list_empty(&ioc->pcie_device_list))
+		return rc;
+
+	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+	list_for_each_entry(pcie_device, &ioc->pcie_device_list, list) {
+		if (btdh->bus == 0xFFFFFFFF && btdh->id == 0xFFFFFFFF &&
+			   btdh->handle == pcie_device->handle) {
+			btdh->bus = pcie_device->channel;
+			btdh->id = pcie_device->id;
+			rc = 1;
+			goto out;
+		} else if (btdh->bus == pcie_device->channel && btdh->id ==
+			   pcie_device->id && btdh->handle == 0xFFFF) {
+			btdh->handle = pcie_device->handle;
+			rc = 1;
+			goto out;
+		}
+	}
+ out:
+	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+	return rc;
+}
+
+/**
  * _ctl_btdh_search_raid_device - searching for raid device
  * @ioc: per adapter object
  * @btdh: btdh ioctl payload
@@ -1410,6 +1436,8 @@ _ctl_btdh_mapping(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 
 	rc = _ctl_btdh_search_sas_device(ioc, &karg);
 	if (!rc)
+		rc = _ctl_btdh_search_pcie_device(ioc, &karg);
+	if (!rc)
 		_ctl_btdh_search_raid_device(ioc, &karg);
 
 	if (copy_to_user(arg, &karg, sizeof(karg))) {
-- 
1.7.1
