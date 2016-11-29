From: <gregkh@linuxfoundation.org>
Subject: Patch "scsi: mpt3sas: Fix secure erase premature termination" has been added to the 4.8-stable tree
Date: Tue, 29 Nov 2016 16:34:58 +0100
Message-ID: <1480433698247236@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934103AbcK2Pft (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 10:35:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrey2805@gmail.com, Sreekanth.Reddy@broadcom.com, chaitra.basappa@broadcom.com, gregkh@linuxfoundation.org, hare@suse.de, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    scsi: mpt3sas: Fix secure erase premature termination

to the 4.8-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     scsi-mpt3sas-fix-secure-erase-premature-termination.patch
and it can be found in the queue-4.8 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From 18f6084a989ba1b38702f9af37a2e4049a924be6 Mon Sep 17 00:00:00 2001
From: Andrey Grodzovsky <andrey2805@gmail.com>
Date: Thu, 10 Nov 2016 09:35:27 -0500
Subject: scsi: mpt3sas: Fix secure erase premature termination

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


Patches currently in stable-queue which might be from andrey2805@gmail.com are

queue-4.8/scsi-mpt3sas-fix-secure-erase-premature-termination.patch
