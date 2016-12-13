From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 14/38] scsi: mpt3sas: Fix secure erase premature termination
Date: Tue, 13 Dec 2016 20:52:40 +0100
Message-ID: <940aeba5f936112e02425e5bf0ca32f7264ba0b3.1481658746.git.jslaby@suse.cz>
References: <15034b96ec06ee859b67c6cd4e3be569a4ef286b.1481658746.git.jslaby@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <15034b96ec06ee859b67c6cd4e3be569a4ef286b.1481658746.git.jslaby@suse.cz>
In-Reply-To: <cover.1481658746.git.jslaby@suse.cz>
References: <cover.1481658746.git.jslaby@suse.cz>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrey Grodzovsky <andrey2805@gmail.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jiri Slaby <jslaby@suse.cz>
List-Id: linux-scsi@vger.kernel.org

From: Andrey Grodzovsky <andrey2805@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe11b527..ae1db5499ca6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3516,6 +3516,10 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 	    SAM_STAT_CHECK_CONDITION;
 }
 
+static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+{
+	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+}
 
 /**
  * _scsih_qcmd_lck - main scsi request entry point
@@ -3544,6 +3548,13 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
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
@@ -4047,6 +4058,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
 	if (mpi_reply == NULL) {
-- 
2.11.0
