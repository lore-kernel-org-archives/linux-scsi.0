From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 5/6] mpt3sas: Introduce function to clone mpi request.
Date: Fri, 19 Jan 2018 04:37:41 -0800
Message-ID: <1516365462-14708-6-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1516365462-14708-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:40488 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755197AbeASMiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jan 2018 07:38:14 -0500
Received: by mail-qt0-f195.google.com with SMTP id s39so3395931qth.7
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2018 04:38:14 -0800 (PST)
In-Reply-To: <1516365462-14708-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

1) Added function _base_clone_mpi_to_sys_mem to clone
MPI request into system BAR0 mapped region.

2) Seperate out MPI Endpoint IO submissions to function
_base_put_smid_mpi_ep_scsi_io.

3) MPI EP requests are submitted in two 32 bit MMIO writes.
from _base_mpi_ep_writeq.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 131 +++++++++++++++++++++++++++++++++---
 1 file changed, 123 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 40a1806..0248058 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -126,6 +126,24 @@ module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
 	param_get_int, &mpt3sas_fwfault_debug, 0644);
 
 /**
+ * _base_clone_mpi_to_sys_mem - Writes/copies MPI frames
+ *				to system/BAR0 region.
+ *
+ * @dst_iomem: Pointer to the destinaltion location in BAR0 space.
+ * @src: Pointer to the Source data.
+ * @size: Size of data to be copied.
+ */
+static void
+_base_clone_mpi_to_sys_mem(void *dst_iomem, void *src, u32 size)
+{
+	int i;
+	__le32 *src_virt_mem = (__le32 *)src;
+
+	for (i = 0; i < size/4; i++)
+		writel(cpu_to_le32(src_virt_mem[i]), dst_iomem + (i * 4));
+}
+
+/**
  * _base_clone_to_sys_mem - Writes/copies data to system/BAR0 region
  *
  * @dst_iomem: Pointer to the destinaltion location in BAR0 space.
@@ -3265,6 +3283,29 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 }
 
 /**
+ * _base_mpi_ep_writeq - 32 bit write to MMIO
+ * @b: data payload
+ * @addr: address in MMIO space
+ * @writeq_lock: spin lock
+ *
+ * This special handling for MPI EP to take care of 32 bit
+ * environment where its not quarenteed to send the entire word
+ * in one transfer.
+ */
+static inline void
+_base_mpi_ep_writeq(__u64 b, volatile void __iomem *addr,
+					spinlock_t *writeq_lock)
+{
+	unsigned long flags;
+	__u64 data_out = cpu_to_le64(b);
+
+	spin_lock_irqsave(writeq_lock, flags);
+	writel((u32)(data_out), addr);
+	writel((u32)(data_out >> 32), (addr + 4));
+	spin_unlock_irqrestore(writeq_lock, flags);
+}
+
+/**
  * _base_writeq - 64 bit write to MMIO
  * @ioc: per adapter object
  * @b: data payload
@@ -3296,6 +3337,36 @@ _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
 #endif
 
 /**
+ * _base_put_smid_mpi_ep_scsi_io - send SCSI_IO request to firmware
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @handle: device handle
+ *
+ * Return nothing.
+ */
+static void
+_base_put_smid_mpi_ep_scsi_io(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 handle)
+{
+	Mpi2RequestDescriptorUnion_t descriptor;
+	u64 *request = (u64 *)&descriptor;
+	void *mpi_req_iomem;
+	__le32 *mfp = (__le32 *)mpt3sas_base_get_msg_frame(ioc, smid);
+
+	_clone_sg_entries(ioc, (void *) mfp, smid);
+	mpi_req_iomem = (void *)ioc->chip +
+			MPI_FRAME_START_OFFSET + (smid * ioc->request_sz);
+	_base_clone_mpi_to_sys_mem(mpi_req_iomem, (void *)mfp,
+					ioc->request_sz);
+	descriptor.SCSIIO.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
+	descriptor.SCSIIO.MSIxIndex =  _base_get_msix_index(ioc);
+	descriptor.SCSIIO.SMID = cpu_to_le16(smid);
+	descriptor.SCSIIO.DevHandle = cpu_to_le16(handle);
+	descriptor.SCSIIO.LMID = 0;
+	_base_mpi_ep_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
+	    &ioc->scsi_lookup_lock);
+}
+
+/**
  * _base_put_smid_scsi_io - send SCSI_IO request to firmware
  * @ioc: per adapter object
  * @smid: system request message index
@@ -3356,7 +3427,23 @@ _base_put_smid_hi_priority(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	u16 msix_task)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
-	u64 *request = (u64 *)&descriptor;
+	void *mpi_req_iomem;
+	u64 *request;
+
+	if (ioc->is_mcpu_endpoint) {
+		MPI2RequestHeader_t *request_hdr;
+
+		__le32 *mfp = (__le32 *)mpt3sas_base_get_msg_frame(ioc, smid);
+
+		request_hdr = (MPI2RequestHeader_t *)mfp;
+		/* TBD 256 is offset within sys register. */
+		mpi_req_iomem = (void *)ioc->chip + MPI_FRAME_START_OFFSET
+					+ (smid * ioc->request_sz);
+		_base_clone_mpi_to_sys_mem(mpi_req_iomem, (void *)mfp,
+							ioc->request_sz);
+	}
+
+	request = (u64 *)&descriptor;
 
 	descriptor.HighPriority.RequestFlags =
 	    MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY;
@@ -3364,8 +3451,13 @@ _base_put_smid_hi_priority(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	descriptor.HighPriority.SMID = cpu_to_le16(smid);
 	descriptor.HighPriority.LMID = 0;
 	descriptor.HighPriority.Reserved1 = 0;
-	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
-	    &ioc->scsi_lookup_lock);
+	if (ioc->is_mcpu_endpoint)
+		_base_mpi_ep_writeq(*request,
+				&ioc->chip->RequestDescriptorPostLow,
+				&ioc->scsi_lookup_lock);
+	else
+		_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
+		    &ioc->scsi_lookup_lock);
 }
 
 /**
@@ -3403,15 +3495,35 @@ static void
 _base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
-	u64 *request = (u64 *)&descriptor;
+	void *mpi_req_iomem;
+	u64 *request;
+	MPI2RequestHeader_t *request_hdr;
 
+	if (ioc->is_mcpu_endpoint) {
+		__le32 *mfp = (__le32 *)mpt3sas_base_get_msg_frame(ioc, smid);
+
+		request_hdr = (MPI2RequestHeader_t *)mfp;
+
+		_clone_sg_entries(ioc, (void *) mfp, smid);
+		/* TBD 256 is offset within sys register */
+		mpi_req_iomem = (void *)ioc->chip +
+			MPI_FRAME_START_OFFSET + (smid * ioc->request_sz);
+		_base_clone_mpi_to_sys_mem(mpi_req_iomem, (void *)mfp,
+							ioc->request_sz);
+	}
+	request = (u64 *)&descriptor;
 	descriptor.Default.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
 	descriptor.Default.MSIxIndex =  _base_get_msix_index(ioc);
 	descriptor.Default.SMID = cpu_to_le16(smid);
 	descriptor.Default.LMID = 0;
 	descriptor.Default.DescriptorTypeDependent = 0;
-	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
-	    &ioc->scsi_lookup_lock);
+	if (ioc->is_mcpu_endpoint)
+		_base_mpi_ep_writeq(*request,
+				&ioc->chip->RequestDescriptorPostLow,
+				&ioc->scsi_lookup_lock);
+	else
+		_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
+				&ioc->scsi_lookup_lock);
 }
 
 /**
@@ -3505,7 +3617,7 @@ _base_put_smid_nvme_encap_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 
 /**
  * _base_put_smid_default - Default, primarily used for config pages
- *				use Atomic Request Descriptor
+ * use Atomic Request Descriptor
  * @ioc: per adapter object
  * @smid: system request message index
  *
@@ -6330,7 +6442,10 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		ioc->put_smid_nvme_encap = &_base_put_smid_nvme_encap_atomic;
 	} else {
 		ioc->put_smid_default = &_base_put_smid_default;
-		ioc->put_smid_scsi_io = &_base_put_smid_scsi_io;
+		if (ioc->is_mcpu_endpoint)
+			ioc->put_smid_scsi_io = &_base_put_smid_mpi_ep_scsi_io;
+		else
+			ioc->put_smid_scsi_io = &_base_put_smid_scsi_io;
 		ioc->put_smid_fast_path = &_base_put_smid_fast_path;
 		ioc->put_smid_hi_priority = &_base_put_smid_hi_priority;
 		ioc->put_smid_nvme_encap = &_base_put_smid_nvme_encap;
-- 
2.5.5
