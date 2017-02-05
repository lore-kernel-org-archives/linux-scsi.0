From: Willy Tarreau <w@1wt.eu>
Subject: [PATCH 3.10 141/319] scsi: mpt3sas: Fix secure erase premature termination
Date: Sun,  5 Feb 2017 20:19:23 +0100
Message-ID: <1486322541-8206-42-git-send-email-w@1wt.eu>
References: <1486322541-8206-1-git-send-email-w@1wt.eu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486322541-8206-1-git-send-email-w@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux@roeck-us.net
Cc: Andrey Grodzovsky <andrey2805@gmail.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Willy Tarreau <w@1wt.eu>
List-Id: linux-scsi@vger.kernel.org

From: Andrey Grodzovsky <andrey2805@gmail.com>

commit 18f6084a989ba1b38702f9af37a2e4049a924be6 upstream.

This is a work around for a bug with LSI Fusion MPT SAS2 when perfoming
secure erase. Due to the very long time the operation takes, commands
issued during the erase will time out and will trigger execution of the
abort hook. Even though the abort hook is called for the specific
command which timed out, this leads to entire device halt
(scsi_state terminated) and premature termination of the secure erase.

Set device state to busy while ATA passthrough commands are in progress.

[mkp: hand applied to 4.9/scsi-fixes, tweaked patch description]

Signed-off-by: Andrey Grodzovsky <andrey2805@gmail.com>
Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
Cc: <linux-scsi@vger.kernel.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index f8c4b85..e414b71 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3515,6 +3515,10 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 	    SAM_STAT_CHECK_CONDITION;
 }
 
+static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+{
+	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+}
 
 /**
  * _scsih_qcmd_lck - main scsi request entry point
@@ -3543,6 +3547,13 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		scsi_print_command(scmd);
 #endif
 
+	/*
+	 * Lock the device for any subsequent command until command is
+	 * done.
+	 */
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_block(scmd->device);
+
 	scmd->scsi_done = done;
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
@@ -4046,6 +4057,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
 	if (mpi_reply == NULL) {
-- 
2.8.0.rc2.1.gbe9624a
