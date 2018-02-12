From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH] mpt3sas: Do not use 32-bit atomic request descriptor for Ventura controllers
Date: Sun, 11 Feb 2018 21:47:50 -0800
Message-ID: <1518414470-2056-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:39104 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbeBLFsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 00:48:14 -0500
Received: by mail-qk0-f193.google.com with SMTP id z197so302029qkb.6
        for <linux-scsi@vger.kernel.org>; Sun, 11 Feb 2018 21:48:14 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com, kashyap.desai@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Problem Statement:
Sending I/O through 32 bit descriptors to Ventura series of controller
results in IO timeout on certain conditions.
 
This error only occurs on systems with high I/O activity on
Ventura series controllers.
  
Changes in this patch will prevent driver from using 32 bit descriptor
and use 64 bit Descriptors.

Cc: <stable@vger.kernel.org>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 121 ------------------------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |   1 -
 2 files changed, 122 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 13d6e4e..6051469 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3108,116 +3108,6 @@ _base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 }
 
 /**
-* _base_put_smid_scsi_io_atomic - send SCSI_IO request to firmware using
-*   Atomic Request Descriptor
-* @ioc: per adapter object
-* @smid: system request message index
-* @handle: device handle, unused in this function, for function type match
-*
-* Return nothing.
-*/
-static void
-_base_put_smid_scsi_io_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
-	u16 handle)
-{
-	Mpi26AtomicRequestDescriptor_t descriptor;
-	u32 *request = (u32 *)&descriptor;
-
-	descriptor.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
-	descriptor.MSIxIndex = _base_get_msix_index(ioc);
-	descriptor.SMID = cpu_to_le16(smid);
-
-	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
-}
-
-/**
- * _base_put_smid_fast_path_atomic - send fast path request to firmware
- * using Atomic Request Descriptor
- * @ioc: per adapter object
- * @smid: system request message index
- * @handle: device handle, unused in this function, for function type match
- * Return nothing
- */
-static void
-_base_put_smid_fast_path_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
-	u16 handle)
-{
-	Mpi26AtomicRequestDescriptor_t descriptor;
-	u32 *request = (u32 *)&descriptor;
-
-	descriptor.RequestFlags = MPI25_REQ_DESCRIPT_FLAGS_FAST_PATH_SCSI_IO;
-	descriptor.MSIxIndex = _base_get_msix_index(ioc);
-	descriptor.SMID = cpu_to_le16(smid);
-
-	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
-}
-
-/**
- * _base_put_smid_hi_priority_atomic - send Task Management request to
- * firmware using Atomic Request Descriptor
- * @ioc: per adapter object
- * @smid: system request message index
- * @msix_task: msix_task will be same as msix of IO incase of task abort else 0
- *
- * Return nothing.
- */
-static void
-_base_put_smid_hi_priority_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
-	u16 msix_task)
-{
-	Mpi26AtomicRequestDescriptor_t descriptor;
-	u32 *request = (u32 *)&descriptor;
-
-	descriptor.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY;
-	descriptor.MSIxIndex = msix_task;
-	descriptor.SMID = cpu_to_le16(smid);
-
-	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
-}
-
-/**
- * _base_put_smid_nvme_encap_atomic - send NVMe encapsulated request to
- *   firmware using Atomic Request Descriptor
- * @ioc: per adapter object
- * @smid: system request message index
- *
- * Return nothing.
- */
-static void
-_base_put_smid_nvme_encap_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid)
-{
-	Mpi26AtomicRequestDescriptor_t descriptor;
-	u32 *request = (u32 *)&descriptor;
-
-	descriptor.RequestFlags = MPI26_REQ_DESCRIPT_FLAGS_PCIE_ENCAPSULATED;
-	descriptor.MSIxIndex = _base_get_msix_index(ioc);
-	descriptor.SMID = cpu_to_le16(smid);
-
-	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
-}
-
-/**
- * _base_put_smid_default - Default, primarily used for config pages
- * use Atomic Request Descriptor
- * @ioc: per adapter object
- * @smid: system request message index
- *
- * Return nothing.
- */
-static void
-_base_put_smid_default_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid)
-{
-	Mpi26AtomicRequestDescriptor_t descriptor;
-	u32 *request = (u32 *)&descriptor;
-
-	descriptor.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
-	descriptor.MSIxIndex = _base_get_msix_index(ioc);
-	descriptor.SMID = cpu_to_le16(smid);
-
-	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
-}
-
-/**
  * _base_display_OEMs_branding - Display branding string
  * @ioc: per adapter object
  *
@@ -5071,8 +4961,6 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 	if ((facts->IOCCapabilities &
 	      MPI2_IOCFACTS_CAPABILITY_RDPQ_ARRAY_CAPABLE) && (!reset_devices))
 		ioc->rdpq_array_capable = 1;
-	if (facts->IOCCapabilities & MPI26_IOCFACTS_CAPABILITY_ATOMIC_REQ)
-		ioc->atomic_desc_capable = 1;
 	facts->FWVersion.Word = le32_to_cpu(mpi_reply.FWVersion.Word);
 	facts->IOCRequestFrameSize =
 	    le16_to_cpu(mpi_reply.IOCRequestFrameSize);
@@ -6006,20 +5894,11 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		break;
 	}
 
-	if (ioc->atomic_desc_capable) {
-		ioc->put_smid_default = &_base_put_smid_default_atomic;
-		ioc->put_smid_scsi_io = &_base_put_smid_scsi_io_atomic;
-		ioc->put_smid_fast_path = &_base_put_smid_fast_path_atomic;
-		ioc->put_smid_hi_priority = &_base_put_smid_hi_priority_atomic;
-		ioc->put_smid_nvme_encap = &_base_put_smid_nvme_encap_atomic;
-	} else {
 		ioc->put_smid_default = &_base_put_smid_default;
 		ioc->put_smid_scsi_io = &_base_put_smid_scsi_io;
 		ioc->put_smid_fast_path = &_base_put_smid_fast_path;
 		ioc->put_smid_hi_priority = &_base_put_smid_hi_priority;
 		ioc->put_smid_nvme_encap = &_base_put_smid_nvme_encap;
-	}
-
 
 	/*
 	 * These function pointers for other requests that don't
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 789bc42..3324392 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1348,7 +1348,6 @@ struct MPT3SAS_ADAPTER {
 	void		*device_remove_in_progress;
 	u16		device_remove_in_progress_sz;
 	u8		is_gen35_ioc;
-	u8		atomic_desc_capable;
 	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
 	PUT_SMID_IO_FP_HIP put_smid_fast_path;
 	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
-- 
2.5.5
