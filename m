From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt2sas: Fix secure erase premature termination.
Date: Fri, 18 Nov 2016 17:12:49 +0530
Message-ID: <1479469369-15066-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, greg@kroah.com, andrey2805@gmail.com, hch@infradead.org
Cc: jejb@kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, FusionLinux.pdl@broadcom.com, hare@suse.de, Sathya.Prakash@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Problem:
This is a work around for a bug with LSI Fusion MPT SAS2 when
pefroming secure erase. Due to the very long time the operation
takes commands issued during the erase will time out and will trigger
execution of abort hook. Even though the abort hook is called for
the specific command which timed out this leads to entire device halt
(scsi_state terminated) and premature termination of the secured erase.

Fix:
Set device state to busy while erase in progress to reject any incoming
commands until the erase is done. The device is blocked any way during
this time and cannot execute any other command.

P.S
This is a backport from the same fix for mpt3sas driver intended
for pre-4.4 stable trees.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 0ad09b2..3ab639f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3848,6 +3848,11 @@ _scsih_temp_threshold_events(struct MPT2SAS_ADAPTER *ioc,
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
@@ -3869,6 +3874,9 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
 		if (!scmd)
 			continue;
 		count++;
+		if (ata_12_16_cmd(scmd))
+			scsi_internal_device_unblock(scmd->device,
+							SDEV_RUNNING);
 		mpt2sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
@@ -4073,6 +4081,13 @@ _scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	u32 mpi_control;
 	u16 smid;
 
+	/*
+	 * Lock the device for any subsequent command until command is
+	 * done.
+	 */
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_block(scmd->device);
+
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -4621,6 +4636,9 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 
 	if (mpi_reply == NULL) {
-- 
1.9.1
