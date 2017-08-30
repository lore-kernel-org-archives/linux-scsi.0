From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v5 08/14] mpt3sas: Set NVMe device queue depth as 128
Date: Wed, 30 Aug 2017 19:38:32 +0530
Message-ID: <1504102118-7152-9-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Sets nvme device queue depth, name and displays device capabilities

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 50 ++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 09ad823..51d2668 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -115,7 +115,7 @@
 
 #define MPT3SAS_RAID_MAX_SECTORS	8192
 #define MPT3SAS_HOST_PAGE_SIZE_4K	12
-
+#define MPT3SAS_NVME_QUEUE_DEPTH	128
 #define MPT_NAME_LENGTH			32	/* generic length of strings */
 #define MPT_STRING_LENGTH		64
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 344f946..8834919 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2290,6 +2290,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct _sas_device *sas_device;
+	struct _pcie_device *pcie_device;
 	struct _raid_device *raid_device;
 	unsigned long flags;
 	int qdepth;
@@ -2420,6 +2421,55 @@ scsih_slave_configure(struct scsi_device *sdev)
 		}
 	}
 
+	/* PCIe handling */
+	if (sas_target_priv_data->flags & MPT_TARGET_FLAGS_PCIE_DEVICE) {
+		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+		pcie_device = __mpt3sas_get_pdev_by_wwid(ioc,
+				sas_device_priv_data->sas_target->sas_address);
+		if (!pcie_device) {
+			spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+				"failure at %s:%d/%s()!\n", ioc->name, __FILE__,
+				__LINE__, __func__));
+			return 1;
+		}
+
+		qdepth = MPT3SAS_NVME_QUEUE_DEPTH;
+		ds = "NVMe";
+		sdev_printk(KERN_INFO, sdev,
+			"%s: handle(0x%04x), wwid(0x%016llx), port(%d)\n",
+			ds, handle, (unsigned long long)pcie_device->wwid,
+			pcie_device->port_num);
+		if (pcie_device->enclosure_handle != 0)
+			sdev_printk(KERN_INFO, sdev,
+			"%s: enclosure logical id(0x%016llx), slot(%d)\n",
+			ds,
+			(unsigned long long)pcie_device->enclosure_logical_id,
+			pcie_device->slot);
+		if (pcie_device->connector_name[0] != '\0')
+			sdev_printk(KERN_INFO, sdev,
+				"%s: enclosure level(0x%04x),"
+				"connector name( %s)\n", ds,
+				pcie_device->enclosure_level,
+				pcie_device->connector_name);
+		pcie_device_put(pcie_device);
+		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+		scsih_change_queue_depth(sdev, qdepth);
+
+		if (pcie_device->nvme_mdts)
+			blk_queue_max_hw_sectors(sdev->request_queue,
+					pcie_device->nvme_mdts/512);
+		/* Enable QUEUE_FLAG_NOMERGES flag, so that IOs won't be
+		 ** merged and can eliminate holes created during merging
+		 ** operation.
+		 **/
+		queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES,
+				sdev->request_queue);
+		blk_queue_virt_boundary(sdev->request_queue,
+				ioc->page_size - 1);
+		return 0;
+	}
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
 	   sas_device_priv_data->sas_target->sas_address);
-- 
2.5.5
