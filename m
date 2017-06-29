From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 05/13] mpt3sas: Set NVMe device queue depth as 128
Date: Thu, 29 Jun 2017 19:49:06 +0530
Message-ID: <1498745954-7907-6-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1498745954-7907-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34192 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753409AbdF2OVI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 10:21:08 -0400
Received: by mail-wr0-f171.google.com with SMTP id 77so190405094wrb.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2017 07:21:07 -0700 (PDT)
In-Reply-To: <1498745954-7907-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

Sets nvme device queue depth, name and displays device capabilities.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   40 ++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 26239ec..0f07b16 100644
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
index 2a6a8e6..e4e35c1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1962,6 +1962,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct _sas_device *sas_device;
+	struct _pcie_device *pcie_device;
 	struct _raid_device *raid_device;
 	unsigned long flags;
 	int qdepth;
@@ -2092,6 +2093,45 @@ scsih_slave_configure(struct scsi_device *sdev)
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
+		/*TODO-right Queue Depth?*/
+		qdepth = MPT3SAS_NVME_QUEUE_DEPTH;
+		ds = "NVMe";
+		/*TODO-Add device name when defined*/
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
+		return 0;
+	}
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
 	   sas_device_priv_data->sas_target->sas_address);
-- 
1.7.1
