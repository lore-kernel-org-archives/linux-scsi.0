From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 3/20] mpt2sas: Add support in the driver to check for valid response info
Date: Wed, 23 Sep 2009 17:23:07 +0530
Message-ID: <20090923115307.GH6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:53755 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbZIWMew (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:34:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Add support in the driver to check for valid response info in the scsi
state, then check to see if the response code is
MPI2_SCSITASKMGMT_RSP_INVALID_FRAME; when this condition occurrs, the driver
will return DID_SOFT_ERROR.  A return code of DID_SOFT_ERROR will result in
a retry at the scsi-mid layer level.  An additional change added to obtain
the response code from the 1st byte of the response info instead of last.


Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 13e90e3..a5809d9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3111,7 +3111,7 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) {
 		response_info = le32_to_cpu(mpi_reply->ResponseInfo);
 		response_bytes = (u8 *)&response_info;
-		_scsih_response_code(ioc, response_bytes[3]);
+		_scsih_response_code(ioc, response_bytes[0]);
 	}
 }
 #endif
@@ -3229,7 +3229,7 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	u8 scsi_status;
 	u32 log_info;
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
-	u32 response_code;
+	u32 response_code = 0;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	scmd = _scsih_scsi_lookup_get(ioc, smid);
@@ -3251,16 +3251,16 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	}
 
 	/* turning off TLR */
+	scsi_state = mpi_reply->SCSIState;
+	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID)
+		response_code =
+		    le32_to_cpu(mpi_reply->ResponseInfo) & 0xFF;
 	if (!sas_device_priv_data->tlr_snoop_check) {
 		sas_device_priv_data->tlr_snoop_check++;
-		if (sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) {
-			response_code = (le32_to_cpu(mpi_reply->ResponseInfo)
-			    >> 24);
-			if (response_code ==
-			    MPI2_SCSITASKMGMT_RSP_INVALID_FRAME)
-				sas_device_priv_data->flags &=
-				    ~MPT_DEVICE_TLR_ON;
-		}
+		if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
+		    response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME)
+			sas_device_priv_data->flags &=
+			    ~MPT_DEVICE_TLR_ON;
 	}
 
 	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
@@ -3271,7 +3271,6 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	else
 		log_info = 0;
 	ioc_status &= MPI2_IOCSTATUS_MASK;
-	scsi_state = mpi_reply->SCSIState;
 	scsi_status = mpi_reply->SCSIStatus;
 
 	if (ioc_status == MPI2_IOCSTATUS_SCSI_DATA_UNDERRUN && xfer_cnt == 0 &&
@@ -3356,8 +3355,10 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	case MPI2_IOCSTATUS_SCSI_RECOVERED_ERROR:
 	case MPI2_IOCSTATUS_SUCCESS:
 		scmd->result = (DID_OK << 16) | scsi_status;
-		if (scsi_state & (MPI2_SCSI_STATE_AUTOSENSE_FAILED |
-		     MPI2_SCSI_STATE_NO_SCSI_STATUS))
+		if (response_code ==
+		    MPI2_SCSITASKMGMT_RSP_INVALID_FRAME ||
+		    (scsi_state & (MPI2_SCSI_STATE_AUTOSENSE_FAILED |
+		     MPI2_SCSI_STATE_NO_SCSI_STATUS)))
 			scmd->result = DID_SOFT_ERROR << 16;
 		else if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
 			scmd->result = DID_RESET << 16;
