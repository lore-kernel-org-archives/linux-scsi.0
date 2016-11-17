From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Fix for SATA drive in blocked state, after diag reset while ATA Passthrough command is outstanding.
Date: Thu, 17 Nov 2016 16:15:58 +0530
Message-ID: <1479379558-1780-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37240 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941543AbcKQKqg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2016 05:46:36 -0500
Received: by mail-wm0-f43.google.com with SMTP id t79so136267245wmt.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2016 02:46:35 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

While issuing any ATA Pass-through command to Firmware,
driver will block the device, it will unblock the device only if that
IO completes through ISR path. But if in-between any host reset
occurs then driver won't unblock the device and
device will be in blocked state.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a250cfd..5c8f752 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3899,6 +3899,11 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 	}
 }
 
+static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+{
+	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+}
+
 /**
  * _scsih_flush_running_cmds - completing outstanding commands.
  * @ioc: per adapter object
@@ -3920,6 +3925,9 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		if (!scmd)
 			continue;
 		count++;
+		if (ata_12_16_cmd(scmd))
+			scsi_internal_device_unblock(scmd->device,
+							SDEV_RUNNING);
 		mpt3sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
@@ -4027,11 +4035,6 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 	    SAM_STAT_CHECK_CONDITION;
 }
 
-static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
-{
-	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
-}
-
 /**
  * scsih_qcmd - main scsi request entry point
  * @scmd: pointer to scsi command object
-- 
2.4.3

