From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 14/20] mpt2sas: Return DID_TRANSPORT_DISRUPTED in nexus loss,SCSI_MLQUEUE_DEVICE_BUSY if device is busy
Date: Wed, 23 Sep 2009 17:33:14 +0530
Message-ID: <20090923120314.GS6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:48950 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbZIWM0d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:26:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


1 Its observed that the OS was sending request to the driver after it had been
put into blocking state, so the driver was modified to return
SCSI_MLQUEUE_DEVICE_BUSY.
2. Driver will return DID_TRANSPORT_DISRUPTED when sdev is haivng nexus loss.
This occurrs when sdev is blocked, between the
MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING and
MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING events.


Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 7ac8ac6..2fd620e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2885,7 +2885,7 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	}
 
 	/* see if we are busy with task managment stuff */
-	if (sas_target_priv_data->tm_busy)
+	if (sas_device_priv_data->block || sas_target_priv_data->tm_busy)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	else if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -3351,10 +3351,9 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 
 	case MPI2_IOCSTATUS_SCSI_IOC_TERMINATED:
 		if (sas_device_priv_data->block) {
-			scmd->result = (DID_BUS_BUSY << 16);
-			break;
+			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
+			goto out;
 		}
-
 	case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
 	case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
 		scmd->result = DID_RESET << 16;
