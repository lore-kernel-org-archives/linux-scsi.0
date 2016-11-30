From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.8 11/37] scsi: mpt3sas: Fix secure erase premature termination
Date: Wed, 30 Nov 2016 10:29:48 +0100
Message-ID: <20161130092730.337406282@linuxfoundation.org>
References: <20161130092729.623248210@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161130092729.623248210@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Andrey Grodzovsky <andrey2805@gmail.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

4.8-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4019,7 +4019,10 @@ _scsih_eedp_error_handling(struct scsi_c
 	    SAM_STAT_CHECK_CONDITION;
 }
 
-
+static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+{
+	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+}
 
 /**
  * scsih_qcmd - main scsi request entry point
@@ -4047,6 +4050,13 @@ scsih_qcmd(struct Scsi_Host *shost, stru
 	if (ioc->logging_level & MPT_DEBUG_SCSI)
 		scsi_print_command(scmd);
 
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
@@ -4622,6 +4632,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *i
 	if (scmd == NULL)
 		return 1;
 
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
 	if (mpi_reply == NULL) {
