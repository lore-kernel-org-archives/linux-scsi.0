From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v5 04/14] mpt3sas: Added support for nvme encapsulated request  message.
Date: Wed, 30 Aug 2017 19:38:28 +0530
Message-ID: <1504102118-7152-5-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

* Mpt3sas driver uses the NVMe Encapsulated Request message to
send an NVMe command to an NVMe device attached to the IOC.

* Normal I/O commands like reads and writes are passed to the
controller as SCSI commands and the controller has the ability
to translate the commands to NVMe equivalent.

* This encapsulated NVMe command is used by applications to send
direct NVMe commands to NVMe drives or for handling unmap where
the translation at controller/firmware level is having
performance issues.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 56 +++++++++++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h |  1 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 69 +++++++++++++++++++++++++++++++++----
 3 files changed, 119 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index dcf5157..9653cfa 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -557,6 +557,11 @@ _base_sas_ioc_info(struct MPT3SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
 		frame_sz = sizeof(Mpi2SmpPassthroughRequest_t) + ioc->sge_size;
 		func_str = "smp_passthru";
 		break;
+	case MPI2_FUNCTION_NVME_ENCAPSULATED:
+		frame_sz = sizeof(Mpi26NVMeEncapsulatedRequest_t) +
+		    ioc->sge_size;
+		func_str = "nvme_encapsulated";
+		break;
 	default:
 		frame_sz = 32;
 		func_str = "unknown";
@@ -985,7 +990,9 @@ _base_interrupt(int irq, void *bus_id)
 		if (request_desript_type ==
 		    MPI25_RPY_DESCRIPT_FLAGS_FAST_PATH_SCSI_IO_SUCCESS ||
 		    request_desript_type ==
-		    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) {
+		    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS ||
+		    request_desript_type ==
+		    MPI26_RPY_DESCRIPT_FLAGS_PCIE_ENCAPSULATED_SUCCESS) {
 			cb_idx = _base_get_cb_idx(ioc, smid);
 			if ((likely(cb_idx < MPT_MAX_CALLBACKS)) &&
 			    (likely(mpt_callbacks[cb_idx] != NULL))) {
@@ -3046,6 +3053,30 @@ _base_put_smid_hi_priority(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 }
 
 /**
+ * _base_put_smid_nvme_encap - send NVMe encapsulated request to
+ *  firmware
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Return nothing.
+ */
+static void
+_base_put_smid_nvme_encap(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	Mpi2RequestDescriptorUnion_t descriptor;
+	u64 *request = (u64 *)&descriptor;
+
+	descriptor.Default.RequestFlags =
+		MPI26_REQ_DESCRIPT_FLAGS_PCIE_ENCAPSULATED;
+	descriptor.Default.MSIxIndex =  _base_get_msix_index(ioc);
+	descriptor.Default.SMID = cpu_to_le16(smid);
+	descriptor.Default.LMID = 0;
+	descriptor.Default.DescriptorTypeDependent = 0;
+	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
+	    &ioc->scsi_lookup_lock);
+}
+
+/**
  * _base_put_smid_default - Default, primarily used for config pages
  * @ioc: per adapter object
  * @smid: system request message index
@@ -3136,6 +3167,27 @@ _base_put_smid_hi_priority_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 }
 
 /**
+ * _base_put_smid_nvme_encap_atomic - send NVMe encapsulated request to
+ *   firmware using Atomic Request Descriptor
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Return nothing.
+ */
+static void
+_base_put_smid_nvme_encap_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	Mpi26AtomicRequestDescriptor_t descriptor;
+	u32 *request = (u32 *)&descriptor;
+
+	descriptor.RequestFlags = MPI26_REQ_DESCRIPT_FLAGS_PCIE_ENCAPSULATED;
+	descriptor.MSIxIndex = _base_get_msix_index(ioc);
+	descriptor.SMID = cpu_to_le16(smid);
+
+	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
+}
+
+/**
  * _base_put_smid_default - Default, primarily used for config pages
  * use Atomic Request Descriptor
  * @ioc: per adapter object
@@ -5968,11 +6020,13 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		ioc->put_smid_scsi_io = &_base_put_smid_scsi_io_atomic;
 		ioc->put_smid_fast_path = &_base_put_smid_fast_path_atomic;
 		ioc->put_smid_hi_priority = &_base_put_smid_hi_priority_atomic;
+		ioc->put_smid_nvme_encap = &_base_put_smid_nvme_encap_atomic;
 	} else {
 		ioc->put_smid_default = &_base_put_smid_default;
 		ioc->put_smid_scsi_io = &_base_put_smid_scsi_io;
 		ioc->put_smid_fast_path = &_base_put_smid_fast_path;
 		ioc->put_smid_hi_priority = &_base_put_smid_hi_priority;
+		ioc->put_smid_nvme_encap = &_base_put_smid_nvme_encap;
 	}
 
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4caa91e..c4be9ad 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1351,6 +1351,7 @@ struct MPT3SAS_ADAPTER {
 	PUT_SMID_IO_FP_HIP put_smid_fast_path;
 	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
 	PUT_SMID_DEFAULT put_smid_default;
+	PUT_SMID_DEFAULT put_smid_nvme_encap;
 
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 0c18831..6362d60 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -272,6 +272,7 @@ mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 {
 	MPI2DefaultReply_t *mpi_reply;
 	Mpi2SCSIIOReply_t *scsiio_reply;
+	Mpi26NVMeEncapsulatedErrorReply_t *nvme_error_reply;
 	const void *sense_data;
 	u32 sz;
 
@@ -298,6 +299,18 @@ mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 				memcpy(ioc->ctl_cmds.sense, sense_data, sz);
 			}
 		}
+		/*
+		 * Get Error Response data for NVMe device. The ctl_cmds.sense
+		 * buffer is used to store the Error Response data.
+		 */
+		if (mpi_reply->Function == MPI2_FUNCTION_NVME_ENCAPSULATED) {
+			nvme_error_reply =
+			    (Mpi26NVMeEncapsulatedErrorReply_t *)mpi_reply;
+			sz = min_t(u32, NVME_ERROR_RESPONSE_SIZE,
+			    le32_to_cpu(nvme_error_reply->ErrorResponseCount));
+			sense_data = mpt3sas_base_get_sense_buffer(ioc, smid);
+			memcpy(ioc->ctl_cmds.sense, sense_data, sz);
+		}
 	}
 
 	_ctl_display_some_debug(ioc, smid, "ctl_done", mpi_reply);
@@ -641,11 +654,12 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 {
 	MPI2RequestHeader_t *mpi_request = NULL, *request;
 	MPI2DefaultReply_t *mpi_reply;
+	Mpi26NVMeEncapsulatedRequest_t *nvme_encap_request = NULL;
 	u32 ioc_state;
 	u16 smid;
 	unsigned long timeout;
 	u8 issue_reset;
-	u32 sz;
+	u32 sz, sz_arg;
 	void *psge;
 	void *data_out = NULL;
 	dma_addr_t data_out_dma = 0;
@@ -742,7 +756,8 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
 	    mpi_request->Function == MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH ||
 	    mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT ||
-	    mpi_request->Function == MPI2_FUNCTION_SATA_PASSTHROUGH) {
+	    mpi_request->Function == MPI2_FUNCTION_SATA_PASSTHROUGH ||
+	    mpi_request->Function == MPI2_FUNCTION_NVME_ENCAPSULATED) {
 
 		device_handle = le16_to_cpu(mpi_request->FunctionDependent1);
 		if (!device_handle || (device_handle >
@@ -793,6 +808,38 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 
 	init_completion(&ioc->ctl_cmds.done);
 	switch (mpi_request->Function) {
+	case MPI2_FUNCTION_NVME_ENCAPSULATED:
+	{
+		nvme_encap_request = (Mpi26NVMeEncapsulatedRequest_t *)request;
+		/*
+		 * Get the Physical Address of the sense buffer.
+		 * Use Error Response buffer address field to hold the sense
+		 * buffer address.
+		 * Clear the internal sense buffer, which will potentially hold
+		 * the Completion Queue Entry on return, or 0 if no Entry.
+		 * Build the PRPs and set direction bits.
+		 * Send the request.
+		 */
+		nvme_encap_request->ErrorResponseBaseAddress = ioc->sense_dma &
+		    0xFFFFFFFF00000000;
+		nvme_encap_request->ErrorResponseBaseAddress |=
+		    (U64)mpt3sas_base_get_sense_buffer_dma(ioc, smid);
+		nvme_encap_request->ErrorResponseAllocationLength =
+						NVME_ERROR_RESPONSE_SIZE;
+		memset(ioc->ctl_cmds.sense, 0, NVME_ERROR_RESPONSE_SIZE);
+		ioc->build_nvme_prp(ioc, smid, nvme_encap_request,
+		    data_out_dma, data_out_sz, data_in_dma, data_in_sz);
+		if (test_bit(device_handle, ioc->device_remove_in_progress)) {
+			dtmprintk(ioc, pr_info(MPT3SAS_FMT "handle(0x%04x) :"
+			    "ioctl failed due to device removal in progress\n",
+			    ioc->name, device_handle));
+			mpt3sas_base_free_smid(ioc, smid);
+			ret = -EINVAL;
+			goto out;
+		}
+		ioc->put_smid_nvme_encap(ioc, smid);
+		break;
+	}
 	case MPI2_FUNCTION_SCSI_IO_REQUEST:
 	case MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH:
 	{
@@ -1008,15 +1055,25 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		}
 	}
 
-	/* copy out sense to user */
+	/* copy out sense/NVMe Error Response to user */
 	if (karg.max_sense_bytes && (mpi_request->Function ==
 	    MPI2_FUNCTION_SCSI_IO_REQUEST || mpi_request->Function ==
-	    MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {
-		sz = min_t(u32, karg.max_sense_bytes, SCSI_SENSE_BUFFERSIZE);
+	    MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH || mpi_request->Function ==
+	    MPI2_FUNCTION_NVME_ENCAPSULATED)) {
+		if (karg.sense_data_ptr == NULL) {
+			pr_info(MPT3SAS_FMT "Response buffer provided"
+			    " by application is NULL; Response data will"
+			    " not be returned.\n", ioc->name);
+			goto out;
+		}
+		sz_arg = (mpi_request->Function ==
+		MPI2_FUNCTION_NVME_ENCAPSULATED) ? NVME_ERROR_RESPONSE_SIZE :
+							SCSI_SENSE_BUFFERSIZE;
+		sz = min_t(u32, karg.max_sense_bytes, sz_arg);
 		if (copy_to_user(karg.sense_data_ptr, ioc->ctl_cmds.sense,
 		    sz)) {
 			pr_err("failure at %s:%d/%s()!\n", __FILE__,
-			    __LINE__, __func__);
+				__LINE__, __func__);
 			ret = -ENODATA;
 			goto out;
 		}
-- 
2.5.5
