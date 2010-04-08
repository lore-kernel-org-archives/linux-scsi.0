From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 01/03] mpt2sas: Reworked scmd->result priority for _scsih_qcmd.
Date: Thu, 8 Apr 2010 17:54:32 +0530
Message-ID: <20100408122421.GB17543@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:42125 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717Ab0DHM4d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2010 08:56:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

we added support to set the deleted flag prior to device scan,
then clear the flag for responding devices, leaving the deleted flag only
set for missing devices.  The problem is for internal generated host resets,
IO queues are not blocked at scsi mid layer level.  IO will be continued
sent to driver, and driver  will return SCSI_MLQUEUE_HOST_BUSY.  The problem
is the driver checks for the deleted flag before it checks for the
controller being in reset, so there is a window where the driver would be
returning DID_NO_CONNECT for responding devices.  This occurs during  the
time between calling  _scsih_prep_device_scan, and
_scsih_mark_responding_sas_device & _scsih_mark_responding_raid_device.

Fix the queuecommand entry point so ioc->shost_recovery flag sanity check is
given higher presidence then the device "deleted flag" check.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index d19c32c..8f594b7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2956,25 +2956,32 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 
 	scmd->scsi_done = done;
 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
 
 	sas_target_priv_data = sas_device_priv_data->sas_target;
-	if (!sas_target_priv_data || sas_target_priv_data->handle ==
-	    MPT2SAS_INVALID_DEVICE_HANDLE || sas_target_priv_data->deleted) {
+	/* invalid device handle */
+	if (sas_target_priv_data->handle == MPT2SAS_INVALID_DEVICE_HANDLE) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
 
-	/* see if we are busy with task managment stuff */
-	if (sas_device_priv_data->block || sas_target_priv_data->tm_busy)
-		return SCSI_MLQUEUE_DEVICE_BUSY;
-	else if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
+	/* host recovery or link resets sent via IOCTLs */
+	if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
 		return SCSI_MLQUEUE_HOST_BUSY;
+	/* device busy with task managment */
+	else if (sas_device_priv_data->block || sas_target_priv_data->tm_busy)
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+	/* device has been deleted */
+	else if (sas_target_priv_data->deleted) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		return 0;
+	}
 
 	if (scmd->sc_data_direction == DMA_FROM_DEVICE)
 		mpi_control = MPI2_SCSIIO_CONTROL_READ;
