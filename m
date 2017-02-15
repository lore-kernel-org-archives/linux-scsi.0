From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.16 226/306] scsi: mpt3sas: Fix secure erase premature
 termination
Date: Wed, 15 Feb 2017 22:41:40 +0000
Message-ID: <lsq.1487198500.941983510@decadent.org.uk>
References: <lsq.1487198498.99718322@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <lsq.1487198498.99718322@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Andrey Grodzovsky <andrey2805@gmail.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

3.16.40-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1625,7 +1625,10 @@ _scsih_get_volume_capabilities(struct MP
 	return 0;
 }
 
-
+static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+{
+	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+}
 
 /**
  * _scsih_enable_tlr - setting TLR flags
@@ -3541,6 +3544,13 @@ _scsih_qcmd(struct Scsi_Host *shost, str
 		scsi_print_command(scmd);
 #endif
 
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
@@ -4041,6 +4051,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *i
 	if (scmd == NULL)
 		return 1;
 
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
 	if (mpi_reply == NULL) {
