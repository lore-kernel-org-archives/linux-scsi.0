From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH] mpt3sas: Proper handling of set/clear of "ATA command pending" flag.
Date: Wed, 27 Dec 2017 23:09:11 -0800
Message-ID: <1514444951-9502-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:41229 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbdL1HJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Dec 2017 02:09:44 -0500
Received: by mail-qk0-f195.google.com with SMTP id a8so11402029qkb.8
        for <linux-scsi@vger.kernel.org>; Wed, 27 Dec 2017 23:09:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-nvme@lists.infradead.org, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

1.In IO path, setting of "ATA command pending" flag early before device
 removal, invalid device handle etc., checks causes any new commands to be
 always returned with SAM_STAT_BUSY and when the driver removes the drive
 the SML issues SYNC Cache command and that command is always returned with
 SAM_STAT_BUSY and thus making SYNC Cache command to requeued.

2.If the driver gets an ATA PT command for a SATA drive then the driver set
 "ATA command pending" flag in device specific data structure not to allow
 any further commands until the ATA PT command is completed. However, after
 setting the flag if the driver decides to return the command back to upper
 layers without actually issuing to the firmware(I,e., returns from qcmd
 failure return paths) then the corresponding flag is not cleared and this
 prevents the driver from sending any new commands to the drive.

 This patch fixes above two issues by setting of "ATA command pending" flag
 after checking for whether device deleted, invalid device handle, device
 busy with task management. And by setting "ATA command pending" flag to
 false in all of the qcmd failure return paths after setting the flag.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 82d5612..74fca18 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4600,19 +4600,6 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		return 0;
 	}
 
-	/*
-	 * Bug work around for firmware SATL handling.  The loop
-	 * is based on atomic operations and ensures consistency
-	 * since we're lockless at this point
-	 */
-	do {
-		if (test_bit(0, &sas_device_priv_data->ata_command_pending)) {
-			scmd->result = SAM_STAT_BUSY;
-			scmd->scsi_done(scmd);
-			return 0;
-		}
-	} while (_scsih_set_satl_pending(scmd, true));
-
 	sas_target_priv_data = sas_device_priv_data->sas_target;
 
 	/* invalid device handle */
@@ -4638,6 +4625,19 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	    sas_device_priv_data->block)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
+	/*
+	 * Bug work around for firmware SATL handling.  The loop
+	 * is based on atomic operations and ensures consistency
+	 * since we're lockless at this point
+	 */
+	do {
+		if (test_bit(0, &sas_device_priv_data->ata_command_pending)) {
+			scmd->result = SAM_STAT_BUSY;
+			scmd->scsi_done(scmd);
+			return 0;
+		}
+	} while (_scsih_set_satl_pending(scmd, true));
+
 	if (scmd->sc_data_direction == DMA_FROM_DEVICE)
 		mpi_control = MPI2_SCSIIO_CONTROL_READ;
 	else if (scmd->sc_data_direction == DMA_TO_DEVICE)
@@ -4665,6 +4665,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	if (!smid) {
 		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
+		_scsih_set_satl_pending(scmd, false);
 		goto out;
 	}
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
@@ -4696,6 +4697,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		pcie_device = sas_target_priv_data->pcie_dev;
 		if (ioc->build_sg_scmd(ioc, scmd, smid, pcie_device)) {
 			mpt3sas_base_free_smid(ioc, smid);
+			_scsih_set_satl_pending(scmd, false);
 			goto out;
 		}
 	} else
-- 
1.7.1
