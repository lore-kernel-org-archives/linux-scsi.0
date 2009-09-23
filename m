From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 15/20] mpt2sas: mpt2sas_base_get_sense_buffer_dma should be returning little endian
Date: Wed, 23 Sep 2009 17:34:13 +0530
Message-ID: <20090923120413.GT6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:51071 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbZIWM1b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:27:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


>From the function mpt2sas_base_get_sense_buffer_dma add support to call
cpu_to_le64 when calculating the physical dma address. This will properly
handle endianess on big endian systems.  The return value of this function
was changed from dma_addr_t to __le64. Remove the typecasting of u32 when
setting the SenseBufferLowAddress, since its already in __le32 format.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ecd96ed..d91291a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1328,12 +1328,13 @@ mpt2sas_base_get_sense_buffer(struct MPT2SAS_ADAPTER *ioc, u16 smid)
  * @ioc: per adapter object
  * @smid: system request message index
  *
- * Returns phys pointer to sense buffer.
+ * Returns phys pointer to the low 32bit address of the sense buffer.
  */
-dma_addr_t
+__le32
 mpt2sas_base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
-	return ioc->sense_dma + ((smid - 1) * SCSI_SENSE_BUFFERSIZE);
+	return cpu_to_le32(ioc->sense_dma +
+			((smid - 1) * SCSI_SENSE_BUFFERSIZE));
 }
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 879fd70..7efb6ab 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -771,7 +771,7 @@ int mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 void *mpt2sas_base_get_msg_frame(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void *mpt2sas_base_get_sense_buffer(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_build_zero_len_sge(struct MPT2SAS_ADAPTER *ioc, void *paddr);
-dma_addr_t mpt2sas_base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc,
+__le32 mpt2sas_base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc,
     u16 smid);
 
 /* hi-priority queue */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 8dfc5f6..afdb4f3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -740,7 +740,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		Mpi2SCSIIORequest_t *scsiio_request =
 		    (Mpi2SCSIIORequest_t *)mpi_request;
 		scsiio_request->SenseBufferLowAddress =
-		    (u32)mpt2sas_base_get_sense_buffer_dma(ioc, smid);
+		    mpt2sas_base_get_sense_buffer_dma(ioc, smid);
 		priv_sense = mpt2sas_base_get_sense_buffer(ioc, smid);
 		memset(priv_sense, 0, SCSI_SENSE_BUFFERSIZE);
 		mpt2sas_base_put_smid_scsi_io(ioc, smid,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 2fd620e..9f75a5d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2939,7 +2939,7 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	mpi_request->MsgFlags = MPI2_SCSIIO_MSGFLAGS_SYSTEM_SENSE_ADDR;
 	mpi_request->SenseBufferLength = SCSI_SENSE_BUFFERSIZE;
 	mpi_request->SenseBufferLowAddress =
-	    (u32)mpt2sas_base_get_sense_buffer_dma(ioc, smid);
+	    mpt2sas_base_get_sense_buffer_dma(ioc, smid);
 	mpi_request->SGLOffset0 = offsetof(Mpi2SCSIIORequest_t, SGL) / 4;
 	mpi_request->SGLFlags = cpu_to_le16(MPI2_SCSIIO_SGLFLAGS_TYPE_MPI +
 	    MPI2_SCSIIO_SGLFLAGS_SYSTEM_ADDR);
