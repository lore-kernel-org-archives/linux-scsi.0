From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v5 10/14] mpt3as: Add-Task-management-debug-info-for-NVMe-drives.
Date: Wed, 30 Aug 2017 19:38:34 +0530
Message-ID: <1504102118-7152-11-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:38859 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbdH3OKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 10:10:05 -0400
Received: by mail-wr0-f176.google.com with SMTP id 40so18327277wrv.5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2017 07:10:05 -0700 (PDT)
In-Reply-To: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>

Added debug information for NVMe/PCIe drives in target rest path.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 83 ++++++++++++++++++++++++++++++------
 1 file changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a6bb65c..8754ade 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2903,6 +2903,7 @@ _scsih_tm_display_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
 	struct scsi_target *starget = scmd->device->sdev_target;
 	struct MPT3SAS_TARGET *priv_target = starget->hostdata;
 	struct _sas_device *sas_device = NULL;
+	struct _pcie_device *pcie_device = NULL;
 	unsigned long flags;
 	char *device_str = NULL;
 
@@ -2919,6 +2920,31 @@ _scsih_tm_display_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
 			"%s handle(0x%04x), %s wwid(0x%016llx)\n",
 			device_str, priv_target->handle,
 		    device_str, (unsigned long long)priv_target->sas_address);
+
+	} else if (priv_target->flags & MPT_TARGET_FLAGS_PCIE_DEVICE) {
+		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+		pcie_device = __mpt3sas_get_pdev_from_target(ioc, priv_target);
+		if (pcie_device) {
+			starget_printk(KERN_INFO, starget,
+				"handle(0x%04x), wwid(0x%016llx), port(%d)\n",
+				pcie_device->handle,
+				(unsigned long long)pcie_device->wwid,
+				pcie_device->port_num);
+			if (pcie_device->enclosure_handle != 0)
+				starget_printk(KERN_INFO, starget,
+					"enclosure logical id(0x%016llx), slot(%d)\n",
+					(unsigned long long)
+					pcie_device->enclosure_logical_id,
+					pcie_device->slot);
+			if (pcie_device->connector_name[0] != '\0')
+				starget_printk(KERN_INFO, starget,
+					"enclosure level(0x%04x), connector name( %s)\n",
+					pcie_device->enclosure_level,
+					pcie_device->connector_name);
+			pcie_device_put(pcie_device);
+		}
+		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+
 	} else {
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		sas_device = __mpt3sas_get_sdev_from_target(ioc, priv_target);
@@ -3662,6 +3688,7 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	u16 smid;
 	struct _sas_device *sas_device = NULL;
+	struct _pcie_device *pcie_device = NULL;
 	struct MPT3SAS_TARGET *sas_target_priv_data = NULL;
 	u64 sas_address = 0;
 	unsigned long flags;
@@ -3704,24 +3731,52 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		sas_address = sas_device->sas_address;
 	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-
+	if (!sas_device) {
+		spin_lock_irqsave(&ioc->pcie_device_lock, flags);
+		pcie_device = __mpt3sas_get_pdev_by_handle(ioc, handle);
+		if (pcie_device && pcie_device->starget &&
+			pcie_device->starget->hostdata) {
+			sas_target_priv_data = pcie_device->starget->hostdata;
+			sas_target_priv_data->deleted = 1;
+			sas_address = pcie_device->wwid;
+		}
+		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
+	}
 	if (sas_target_priv_data) {
 		dewtprintk(ioc, pr_info(MPT3SAS_FMT
 			"setting delete flag: handle(0x%04x), sas_addr(0x%016llx)\n",
 			ioc->name, handle,
 		    (unsigned long long)sas_address));
-		if (sas_device->enclosure_handle != 0)
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			 "setting delete flag:enclosure logical id(0x%016llx),"
-			 " slot(%d)\n", ioc->name, (unsigned long long)
-			  sas_device->enclosure_logical_id,
-			  sas_device->slot));
-		if (sas_device->connector_name[0] != '\0')
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			 "setting delete flag: enclosure level(0x%04x),"
-			 " connector name( %s)\n", ioc->name,
-			  sas_device->enclosure_level,
-			  sas_device->connector_name));
+		if (sas_device) {
+			if (sas_device->enclosure_handle != 0)
+				dewtprintk(ioc, pr_info(MPT3SAS_FMT
+				    "setting delete flag:enclosure logical "
+				    "id(0x%016llx), slot(%d)\n", ioc->name,
+				    (unsigned long long)
+				    sas_device->enclosure_logical_id,
+				    sas_device->slot));
+			if (sas_device->connector_name[0] != '\0')
+				dewtprintk(ioc, pr_info(MPT3SAS_FMT
+				    "setting delete flag: enclosure "
+				    "level(0x%04x), connector name( %s)\n",
+				    ioc->name, sas_device->enclosure_level,
+				    sas_device->connector_name));
+		} else if (pcie_device) {
+			if (pcie_device->enclosure_handle != 0)
+				dewtprintk(ioc, pr_info(MPT3SAS_FMT
+				    "setting delete flag: logical "
+				    "id(0x%016llx), slot(%d)\n", ioc->name,
+				    (unsigned long long)
+				    pcie_device->enclosure_logical_id,
+				    pcie_device->slot));
+			if (pcie_device->connector_name[0] != '\0')
+				dewtprintk(ioc, pr_info(MPT3SAS_FMT
+				    "setting delete flag:, enclosure "
+				    "level(0x%04x), "
+				    "connector name( %s)\n", ioc->name,
+				    pcie_device->enclosure_level,
+				    pcie_device->connector_name));
+		}
 		_scsih_ublock_io_device(ioc, sas_address);
 		sas_target_priv_data->handle = MPT3SAS_INVALID_DEVICE_HANDLE;
 	}
@@ -3756,6 +3811,8 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 out:
 	if (sas_device)
 		sas_device_put(sas_device);
+	if (pcie_device)
+		pcie_device_put(pcie_device);
 }
 
 /**
-- 
2.5.5
