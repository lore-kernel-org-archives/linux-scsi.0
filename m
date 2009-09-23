From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 16/20] mpt2sas: PPC (power pc) endian bug fix's
Date: Wed, 23 Sep 2009 17:35:08 +0530
Message-ID: <20090923120508.GU6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:57478 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbZIWM20 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:28:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


(1) EEDP(End to End data protection) was not working. This was due to not
setting EEDP BlockSize and Flags to little endian format in the message
frame.
(2) Some expander sysfs attributes were not getting set properly.  The sas
format was not getting set due to endian issues with sas_format field in the
struct rep_manu_reply. Since sas_format was not set properly, the
component_vendor_id, component_revision_id, and component_id were not set.
(3) In _transport_smp_handler: we don't need to convert the smid from little
endian to cpu prior to calling mpt2sas_base_free_smid, because its allready
in cpu format. (4) Some loginfos and ioc status were not xonverted from
little endian to cpu.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index d91291a..db1b41c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2949,6 +2949,7 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	Mpi2IOCInitReply_t mpi_reply;
 	int r;
 	struct timeval current_time;
+	u16 ioc_status;
 
 	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
@@ -3028,7 +3029,8 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		return r;
 	}
 
-	if (mpi_reply.IOCStatus != MPI2_IOCSTATUS_SUCCESS ||
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS ||
 	    mpi_reply.IOCLogInfo) {
 		printk(MPT2SAS_ERR_FMT "%s: failed\n", ioc->name, __func__);
 		r = -EIO;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index afdb4f3..84a124f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -848,8 +848,9 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		printk(MPT2SAS_DEBUG_FMT "TASK_MGMT: "
 		    "IOCStatus(0x%04x), IOCLogInfo(0x%08x), "
 		    "TerminationCount(0x%08x)\n", ioc->name,
-		    tm_reply->IOCStatus, tm_reply->IOCLogInfo,
-		    tm_reply->TerminationCount);
+		    le16_to_cpu(tm_reply->IOCStatus),
+		    le32_to_cpu(tm_reply->IOCLogInfo),
+		    le32_to_cpu(tm_reply->TerminationCount));
 	}
 #endif
 	/* copy out xdata to user */
@@ -1411,7 +1412,7 @@ _ctl_diag_register_2(struct MPT2SAS_ADAPTER *ioc,
 	} else {
 		printk(MPT2SAS_DEBUG_FMT "%s: ioc_status(0x%04x) "
 		    "log_info(0x%08x)\n", ioc->name, __func__,
-		    ioc_status, mpi_reply->IOCLogInfo);
+		    ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
 		rc = -EFAULT;
 	}
 
@@ -1756,7 +1757,7 @@ _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 	} else {
 		printk(MPT2SAS_DEBUG_FMT "%s: ioc_status(0x%04x) "
 		    "log_info(0x%08x)\n", ioc->name, __func__,
-		    ioc_status, mpi_reply->IOCLogInfo);
+		    ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
 		rc = -EFAULT;
 	}
 
@@ -2017,7 +2018,7 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	} else {
 		printk(MPT2SAS_DEBUG_FMT "%s: ioc_status(0x%04x) "
 		    "log_info(0x%08x)\n", ioc->name, __func__,
-		    ioc_status, mpi_reply->IOCLogInfo);
+		    ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
 		rc = -EFAULT;
 	}
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 9f75a5d..f62c75c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2775,8 +2775,6 @@ _scsih_setup_eedp(struct scsi_cmnd *scmd, Mpi2SCSIIORequest_t *mpi_request)
 	else
 		return;
 
-	mpi_request->EEDPBlockSize = scmd->device->sector_size;
-
 	switch (prot_type) {
 	case SCSI_PROT_DIF_TYPE1:
 
@@ -2784,8 +2782,7 @@ _scsih_setup_eedp(struct scsi_cmnd *scmd, Mpi2SCSIIORequest_t *mpi_request)
 		* enable ref/guard checking
 		* auto increment ref tag
 		*/
-		mpi_request->EEDPFlags = eedp_flags |
-		    MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
@@ -2798,11 +2795,11 @@ _scsih_setup_eedp(struct scsi_cmnd *scmd, Mpi2SCSIIORequest_t *mpi_request)
 		/*
 		* enable guard checking
 		*/
-		mpi_request->EEDPFlags = eedp_flags |
-		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
-
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 		break;
 	}
+	mpi_request->EEDPBlockSize = cpu_to_le32(scmd->device->sector_size);
+	mpi_request->EEDPFlags = cpu_to_le16(eedp_flags);
 }
 
 /**
@@ -4393,6 +4390,7 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
 	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
+	u16 ioc_status;
 
 	dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "broadcast primative: "
 	    "phy number(%d), width(%d)\n", ioc->name, event_data->PhyNum,
@@ -4428,8 +4426,9 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 		mpt2sas_scsih_issue_tm(ioc, handle, lun,
 		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30);
 		ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
-
-		if ((mpi_reply->IOCStatus == MPI2_IOCSTATUS_SUCCESS) &&
+		ioc_status = le16_to_cpu(mpi_reply->IOCStatus)
+		    & MPI2_IOCSTATUS_MASK;
+		if ((ioc_status == MPI2_IOCSTATUS_SUCCESS) &&
 		    (mpi_reply->ResponseCode ==
 		     MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
 		     mpi_reply->ResponseCode ==
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 32e4cd3..c984857 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -258,8 +258,7 @@ struct rep_manu_reply{
 	u8 response_length;
 	u16 expander_change_count;
 	u8 reserved0[2];
-	u8 sas_format:1;
-	u8 reserved1:7;
+	u8 sas_format;
 	u8 reserved2[3];
 	u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
 	u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN];
@@ -374,7 +373,8 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request->VP_ID = 0;
 	sas_address_le = (u64 *)&mpi_request->SASAddress;
 	*sas_address_le = cpu_to_le64(sas_address);
-	mpi_request->RequestDataLength = sizeof(struct rep_manu_request);
+	mpi_request->RequestDataLength =
+	    cpu_to_le16(sizeof(struct rep_manu_request));
 	psge = &mpi_request->SGL;
 
 	/* WRITE sgel first */
@@ -437,8 +437,8 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 		     SAS_EXPANDER_PRODUCT_ID_LEN);
 		strncpy(edev->product_rev, manufacture_reply->product_rev,
 		     SAS_EXPANDER_PRODUCT_REV_LEN);
-		edev->level = manufacture_reply->sas_format;
-		if (manufacture_reply->sas_format) {
+		edev->level = manufacture_reply->sas_format & 1;
+		if (edev->level) {
 			strncpy(edev->component_vendor_id,
 			    manufacture_reply->component_vendor_id,
 			     SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
@@ -1116,7 +1116,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	dma_addr_out = pci_map_single(ioc->pdev, bio_data(req->bio),
 		blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_out) {
-		mpt2sas_base_free_smid(ioc, le16_to_cpu(smid));
+		mpt2sas_base_free_smid(ioc, smid);
 		goto unmap;
 	}
 
@@ -1134,7 +1134,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	dma_addr_in = pci_map_single(ioc->pdev, bio_data(rsp->bio),
 				     blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_in) {
-		mpt2sas_base_free_smid(ioc, le16_to_cpu(smid));
+		mpt2sas_base_free_smid(ioc, smid);
 		goto unmap;
 	}
 
