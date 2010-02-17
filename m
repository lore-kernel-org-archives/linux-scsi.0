From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mpt2sas : Do not call sas_is_tlr_enabled for RAID volumes.
Date: Wed, 17 Feb 2010 16:08:36 +0530
Message-ID: <20100217103826.GB24075@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:47704 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223Ab0BQLIT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Feb 2010 06:08:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


For RAID volume sas_is_tlr_enabled call will hit BUG at
scsi_transport_sas.c:163, since raid volume
is not visible to sas transport layer.
Now Added check to make sure arg pass in sas_is_tlr_enabled() is not a volume.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 344a22a..4d04f57 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3062,8 +3062,9 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 
 	} else
 		mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
-
-	if (sas_is_tlr_enabled(scmd->device))
+	/* Make sure Device is not raid volume */
+	if (!_scsih_is_raid(&scmd->device->sdev_gendev) &&
+	    	sas_is_tlr_enabled(scmd->device))
 		mpi_control |= MPI2_SCSIIO_CONTROL_TLR_ON;
 
 	smid = mpt2sas_base_get_smid_scsiio(ioc, ioc->scsi_io_cb_idx, scmd);
@@ -3452,7 +3453,8 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		    le32_to_cpu(mpi_reply->ResponseInfo) & 0xFF;
 	if (!sas_device_priv_data->tlr_snoop_check) {
 		sas_device_priv_data->tlr_snoop_check++;
-		if (sas_is_tlr_enabled(scmd->device) &&
+	if (!_scsih_is_raid(&scmd->device->sdev_gendev) &&
+		sas_is_tlr_enabled(scmd->device) &&
 		    response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME) {
 			sas_disable_tlr(scmd->device);
 			sdev_printk(KERN_INFO, scmd->device, "TLR disabled\n");
