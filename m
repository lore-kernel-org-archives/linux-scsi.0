From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/5] mpt2sas: T10 DIF Support
Date: Mon, 18 May 2009 12:59:41 -0600
Message-ID: <20090518185939.GB26609@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:51135 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZERSxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2009 14:53:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

This add support for type 1 and 3 DIF support per the Oracle API.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-05-18 12:23:24.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-05-18 12:23:24.000000000 -0600
@@ -61,6 +61,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_sas.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
 
 #include "mpt2sas_debug.h"
 
diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-05-18 12:23:24.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-05-18 12:23:24.000000000 -0600
@@ -2390,6 +2390,106 @@ mpt2sas_scsih_reset_handler(struct MPT2S
 }
 
 /**
+ * _scsih_setup_eedp - setup MPI request for EEDP transfer
+ * @scmd: pointer to scsi command object
+ * @mpi_request: pointer to the SCSI_IO reqest message frame
+ *
+ * Supporting protection 1 and 3.
+ *
+ * Returns nothing
+ */
+static void
+_scsih_setup_eedp(struct scsi_cmnd *scmd, Mpi2SCSIIORequest_t *mpi_request)
+{
+	u16 eedp_flags;
+	unsigned char prot_op = scsi_get_prot_op(scmd);
+	unsigned char prot_type = scsi_get_prot_type(scmd);
+
+	if (prot_type == SCSI_PROT_DIF_TYPE0 ||
+	   prot_type == SCSI_PROT_DIF_TYPE2 ||
+	   prot_op == SCSI_PROT_NORMAL)
+		return;
+
+	if (prot_op ==  SCSI_PROT_READ_STRIP)
+		eedp_flags = MPI2_SCSIIO_EEDPFLAGS_CHECK_REMOVE_OP;
+	else if (prot_op ==  SCSI_PROT_WRITE_INSERT)
+		eedp_flags = MPI2_SCSIIO_EEDPFLAGS_INSERT_OP;
+	else
+		return;
+
+	mpi_request->EEDPBlockSize = scmd->device->sector_size;
+
+	switch (prot_type) {
+	case SCSI_PROT_DIF_TYPE1:
+
+		/*
+		* enable ref/guard checking
+		* auto increment ref tag
+		*/
+		mpi_request->EEDPFlags = eedp_flags |
+		    MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
+		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
+		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
+		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
+		    cpu_to_be32(scsi_get_lba(scmd));
+
+		break;
+
+	case SCSI_PROT_DIF_TYPE3:
+
+		/*
+		* enable guard checking
+		*/
+		mpi_request->EEDPFlags = eedp_flags |
+		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
+
+		break;
+	}
+}
+
+/**
+ * _scsih_eedp_error_handling - return sense code for EEDP errors
+ * @scmd: pointer to scsi command object
+ * @ioc_status: ioc status
+ *
+ * Returns nothing
+ */
+static void
+_scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
+{
+	u8 ascq;
+	u8 sk;
+	u8 host_byte;
+
+	switch (ioc_status) {
+	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
+		ascq = 0x01;
+		break;
+	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
+		ascq = 0x02;
+		break;
+	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
+		ascq = 0x03;
+		break;
+	default:
+		ascq = 0x00;
+		break;
+	}
+
+	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
+		sk = ILLEGAL_REQUEST;
+		host_byte = DID_ABORT;
+	} else {
+		sk = ABORTED_COMMAND;
+		host_byte = DID_OK;
+	}
+
+	scsi_build_sense_buffer(0, scmd->sense_buffer, sk, 0x10, ascq);
+	scmd->result = DRIVER_SENSE << 24 | (host_byte << 16) |
+	    SAM_STAT_CHECK_CONDITION;
+}
+
+/**
  * scsih_qcmd - main scsi request entry point
  * @scmd: pointer to scsi command object
  * @done: function pointer to be invoked on completion
@@ -2470,6 +2570,7 @@ scsih_qcmd(struct scsi_cmnd *scmd, void
 	}
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 	memset(mpi_request, 0, sizeof(Mpi2SCSIIORequest_t));
+	_scsih_setup_eedp(scmd, mpi_request);
 	mpi_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
 	if (sas_device_priv_data->sas_target->flags &
 	    MPT_TARGET_FLAGS_RAID_COMPONENT)
@@ -2604,6 +2705,15 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAP
 	case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
 		desc_ioc_state = "scsi ext terminated";
 		break;
+	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
+		desc_ioc_state = "eedp guard error";
+		break;
+	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
+		desc_ioc_state = "eedp ref tag error";
+		break;
+	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
+		desc_ioc_state = "eedp app tag error";
+		break;
 	default:
 		desc_ioc_state = "unknown";
 		break;
@@ -2939,6 +3049,11 @@ scsih_io_done(struct MPT2SAS_ADAPTER *io
 			scmd->result = DID_RESET << 16;
 		break;
 
+	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
+	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
+	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
+		_scsih_eedp_error_handling(scmd, ioc_status);
+		break;
 	case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
 	case MPI2_IOCSTATUS_INVALID_FUNCTION:
 	case MPI2_IOCSTATUS_INVALID_SGL:
@@ -5503,6 +5618,9 @@ scsih_probe(struct pci_dev *pdev, const
 		goto out_add_shost_fail;
 	}
 
+	scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
+	    | SHOST_DIF_TYPE3_PROTECTION);
+
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
 	    "fw_event%d", ioc->id);
