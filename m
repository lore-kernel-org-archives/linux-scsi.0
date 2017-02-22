From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 1/3] mpt3sas: Use 'msix_index' as argument for put_smid functions
Date: Wed, 22 Feb 2017 11:33:33 +0100
Message-ID: <1487759615-3989-2-git-send-email-hare@suse.de>
References: <1487759615-3989-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932116AbdBVKdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:33:39 -0500
In-Reply-To: <1487759615-3989-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Use msix_index as explicit argument for the various put_smid
callbacks.
No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 56 +++++++++++++++++---------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      | 18 ++++++++--
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 21 ++++++------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 21 ++++++------
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  8 ++---
 6 files changed, 71 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 966a775..7125296 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -849,7 +849,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	ack_request->EventContext = mpi_reply->EventContext;
 	ack_request->VF_ID = 0;  /* TODO */
 	ack_request->VP_ID = 0;
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 
  out:
 
@@ -2306,12 +2306,6 @@ struct scsiio_tracker *
 	return ioc->reply + (phys_addr - (u32)ioc->reply_dma);
 }
 
-static inline u8
-_base_get_msix_index(struct MPT3SAS_ADAPTER *ioc)
-{
-	return ioc->cpu_msix_table[raw_smp_processor_id()];
-}
-
 /**
  * mpt3sas_base_get_smid - obtain a free smid from internal queue
  * @ioc: per adapter object
@@ -2361,7 +2355,7 @@ struct scsiio_tracker *
 
 	smid = tag + 1;
 	request->cb_idx = cb_idx;
-	request->msix_io = _base_get_msix_index(ioc);
+	request->msix_io = mpt3sas_base_get_msix_index(ioc);
 	request->smid = smid;
 	INIT_LIST_HEAD(&request->chain_list);
 	return smid;
@@ -2503,18 +2497,20 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
  * @ioc: per adapter object
  * @smid: system request message index
  * @handle: device handle
+ * @msix_index: MSI-X index
  *
  * Return nothing.
  */
 static void
-_base_put_smid_scsi_io(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 handle)
+_base_put_smid_scsi_io(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+		       u16 handle, u16 msix_index)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 
 	descriptor.SCSIIO.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
-	descriptor.SCSIIO.MSIxIndex =  _base_get_msix_index(ioc);
+	descriptor.SCSIIO.MSIxIndex =  cpu_to_le16(msix_index);
 	descriptor.SCSIIO.SMID = cpu_to_le16(smid);
 	descriptor.SCSIIO.DevHandle = cpu_to_le16(handle);
 	descriptor.SCSIIO.LMID = 0;
@@ -2527,19 +2523,20 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
  * @ioc: per adapter object
  * @smid: system request message index
  * @handle: device handle
+ * @msix_index: MSI-X index
  *
  * Return nothing.
  */
 static void
 _base_put_smid_fast_path(struct MPT3SAS_ADAPTER *ioc, u16 smid,
-	u16 handle)
+	u16 handle, u16 msix_index)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 	descriptor.SCSIIO.RequestFlags =
 	    MPI25_REQ_DESCRIPT_FLAGS_FAST_PATH_SCSI_IO;
-	descriptor.SCSIIO.MSIxIndex = _base_get_msix_index(ioc);
+	descriptor.SCSIIO.MSIxIndex = cpu_to_le16(msix_index);
 	descriptor.SCSIIO.SMID = cpu_to_le16(smid);
 	descriptor.SCSIIO.DevHandle = cpu_to_le16(handle);
 	descriptor.SCSIIO.LMID = 0;
@@ -2563,7 +2560,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 
 	descriptor.HighPriority.RequestFlags =
 	    MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY;
-	descriptor.HighPriority.MSIxIndex =  msix_task;
+	descriptor.HighPriority.MSIxIndex =  cpu_to_le16(msix_task);
 	descriptor.HighPriority.SMID = cpu_to_le16(smid);
 	descriptor.HighPriority.LMID = 0;
 	descriptor.HighPriority.Reserved1 = 0;
@@ -2575,17 +2572,18 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
  * _base_put_smid_default - Default, primarily used for config pages
  * @ioc: per adapter object
  * @smid: system request message index
+ * @msix_index: MSI-X index
  *
  * Return nothing.
  */
 static void
-_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 msix_index)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 	descriptor.Default.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
-	descriptor.Default.MSIxIndex =  _base_get_msix_index(ioc);
+	descriptor.Default.MSIxIndex =  cpu_to_le16(msix_index);
 	descriptor.Default.SMID = cpu_to_le16(smid);
 	descriptor.Default.LMID = 0;
 	descriptor.Default.DescriptorTypeDependent = 0;
@@ -2599,18 +2597,19 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 * @ioc: per adapter object
 * @smid: system request message index
 * @handle: device handle, unused in this function, for function type match
+* @msix_index: MSI-X index
 *
 * Return nothing.
 */
 static void
 _base_put_smid_scsi_io_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
-	u16 handle)
+	u16 handle, u16 msix_index)
 {
 	Mpi26AtomicRequestDescriptor_t descriptor;
 	u32 *request = (u32 *)&descriptor;
 
 	descriptor.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
-	descriptor.MSIxIndex = _base_get_msix_index(ioc);
+	descriptor.MSIxIndex = cpu_to_le16(msix_index);
 	descriptor.SMID = cpu_to_le16(smid);
 
 	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
@@ -2622,17 +2621,18 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
  * @ioc: per adapter object
  * @smid: system request message index
  * @handle: device handle, unused in this function, for function type match
+ * @msix_index: MSI-X index
  * Return nothing
  */
 static void
 _base_put_smid_fast_path_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
-	u16 handle)
+	u16 handle, u16 msix_index)
 {
 	Mpi26AtomicRequestDescriptor_t descriptor;
 	u32 *request = (u32 *)&descriptor;
 
 	descriptor.RequestFlags = MPI25_REQ_DESCRIPT_FLAGS_FAST_PATH_SCSI_IO;
-	descriptor.MSIxIndex = _base_get_msix_index(ioc);
+	descriptor.MSIxIndex = cpu_to_le16(msix_index);
 	descriptor.SMID = cpu_to_le16(smid);
 
 	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
@@ -2655,7 +2655,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	u32 *request = (u32 *)&descriptor;
 
 	descriptor.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY;
-	descriptor.MSIxIndex = msix_task;
+	descriptor.MSIxIndex = cpu_to_le16(msix_task);
 	descriptor.SMID = cpu_to_le16(smid);
 
 	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
@@ -2666,17 +2666,19 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
  * use Atomic Request Descriptor
  * @ioc: per adapter object
  * @smid: system request message index
+ * @msix_index: MSI-X index
  *
  * Return nothing.
  */
 static void
-_base_put_smid_default_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+_base_put_smid_default_atomic(struct MPT3SAS_ADAPTER *ioc,
+	u16 smid, u16 msix_index)
 {
 	Mpi26AtomicRequestDescriptor_t descriptor;
 	u32 *request = (u32 *)&descriptor;
 
 	descriptor.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
-	descriptor.MSIxIndex = _base_get_msix_index(ioc);
+	descriptor.MSIxIndex = cpu_to_le16(msix_index);
 	descriptor.SMID = cpu_to_le16(smid);
 
 	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
@@ -4182,7 +4184,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	    mpi_request->Operation == MPI2_SAS_OP_PHY_LINK_RESET)
 		ioc->ioc_link_reset_in_progress = 1;
 	init_completion(&ioc->base_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if ((mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
@@ -4282,7 +4284,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	ioc->base_cmds.smid = smid;
 	memcpy(request, mpi_request, sizeof(Mpi2SepReply_t));
 	init_completion(&ioc->base_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -4696,7 +4698,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	mpi_request->Function = MPI2_FUNCTION_PORT_ENABLE;
 
 	init_completion(&ioc->port_enable_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->port_enable_cmds.done, 300*HZ);
 	if (!(ioc->port_enable_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
@@ -4759,7 +4761,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	memset(mpi_request, 0, sizeof(Mpi2PortEnableRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_PORT_ENABLE;
 
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	return 0;
 }
 
@@ -4878,7 +4880,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 		mpi_request->EventMasks[i] =
 		    cpu_to_le32(ioc->event_masks[i]);
 	init_completion(&ioc->base_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 08ddf08..a6dcb67 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -736,8 +736,9 @@ typedef void (*MPT_BUILD_ZERO_LEN_SGE)(struct MPT3SAS_ADAPTER *ioc,
 
 /* To support atomic and non atomic descriptors*/
 typedef void (*PUT_SMID_IO_FP_HIP) (struct MPT3SAS_ADAPTER *ioc, u16 smid,
-	u16 funcdep);
-typedef void (*PUT_SMID_DEFAULT) (struct MPT3SAS_ADAPTER *ioc, u16 smid);
+				    u16 funcdep, u16 msix_index);
+typedef void (*PUT_SMID_DEFAULT) (struct MPT3SAS_ADAPTER *ioc, u16 smid,
+				  u16 msix_index);
 
 /* IOC Facts and Port Facts converted from little endian to cpu */
 union mpi3_version_union {
@@ -1196,7 +1197,7 @@ struct MPT3SAS_ADAPTER {
 	u8		atomic_desc_capable;
 	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
 	PUT_SMID_IO_FP_HIP put_smid_fast_path;
-	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
+	PUT_SMID_DEFAULT put_smid_hi_priority;
 	PUT_SMID_DEFAULT put_smid_default;
 
 };
@@ -1276,6 +1277,17 @@ void mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 
 int mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc);
 
+static inline u8
+mpt3sas_base_get_msix_index(struct MPT3SAS_ADAPTER *ioc)
+{
+	return ioc->cpu_msix_table[raw_smp_processor_id()];
+}
+
+static inline void
+mpt3sas_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	ioc->put_smid_default(ioc, smid, mpt3sas_base_get_msix_index(ioc));
+}
 
 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index dd62701..cebfd73 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -384,7 +384,7 @@ struct config_request {
 	memcpy(config_request, mpi_request, sizeof(Mpi2ConfigRequest_t));
 	_config_display_some_debug(ioc, smid, "config_request", NULL);
 	init_completion(&ioc->config_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->config_cmds.done, timeout*HZ);
 	if (!(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 7bbc5b1..24695ec 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -805,9 +805,10 @@ enum block_state {
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz,
 		    data_in_dma, data_in_sz);
 		if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)
-			ioc->put_smid_scsi_io(ioc, smid, device_handle);
+			ioc->put_smid_scsi_io(ioc, smid, device_handle,
+					      mpt3sas_base_get_msix_index(ioc));
 		else
-			ioc->put_smid_default(ioc, smid);
+			mpt3sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SCSI_TASK_MGMT:
@@ -875,7 +876,7 @@ enum block_state {
 		}
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz, data_in_dma,
 		    data_in_sz);
-		ioc->put_smid_default(ioc, smid);
+		mpt3sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SATA_PASSTHROUGH:
@@ -890,7 +891,7 @@ enum block_state {
 		}
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz, data_in_dma,
 		    data_in_sz);
-		ioc->put_smid_default(ioc, smid);
+		mpt3sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_FW_DOWNLOAD:
@@ -898,7 +899,7 @@ enum block_state {
 	{
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz, data_in_dma,
 		    data_in_sz);
-		ioc->put_smid_default(ioc, smid);
+		mpt3sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_TOOLBOX:
@@ -913,7 +914,7 @@ enum block_state {
 			ioc->build_sg_mpi(ioc, psge, data_out_dma, data_out_sz,
 				data_in_dma, data_in_sz);
 		}
-		ioc->put_smid_default(ioc, smid);
+		mpt3sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SAS_IO_UNIT_CONTROL:
@@ -932,7 +933,7 @@ enum block_state {
 	default:
 		ioc->build_sg_mpi(ioc, psge, data_out_dma, data_out_sz,
 		    data_in_dma, data_in_sz);
-		ioc->put_smid_default(ioc, smid);
+		mpt3sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 
@@ -1521,7 +1522,7 @@ enum block_state {
 			cpu_to_le32(ioc->product_specific[buffer_type][i]);
 
 	init_completion(&ioc->ctl_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -1868,7 +1869,7 @@ enum block_state {
 	mpi_request->VP_ID = 0;
 
 	init_completion(&ioc->ctl_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -2135,7 +2136,7 @@ enum block_state {
 	mpi_request->VP_ID = 0;
 
 	init_completion(&ioc->ctl_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8177519..f19f324 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3159,7 +3159,7 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
 	mpi_request->Operation = MPI2_SAS_OP_REMOVE_DEVICE;
 	mpi_request->DevHandle = mpi_request_tm->DevHandle;
-	ioc->put_smid_default(ioc, smid_sas_ctrl);
+	ioc->put_smid_default(ioc, smid_sas_ctrl, msix_index);
 
 	return _scsih_check_for_pending_tm(ioc, smid);
 }
@@ -3254,7 +3254,7 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
-	ioc->put_smid_hi_priority(ioc, smid, 0);
+	ioc->put_smid_hi_priority(ioc, smid, mpt3sas_base_get_msix_index(ioc));
 }
 
 /**
@@ -3346,7 +3346,7 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 	ack_request->EventContext = event_context;
 	ack_request->VF_ID = 0;  /* TODO */
 	ack_request->VP_ID = 0;
-	ioc->put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid, mpt3sas_base_get_msix_index(ioc));
 }
 
 /**
@@ -3403,7 +3403,7 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
 	mpi_request->Operation = MPI2_SAS_OP_REMOVE_DEVICE;
 	mpi_request->DevHandle = handle;
-	ioc->put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid, mpt3sas_base_get_msix_index(ioc));
 }
 
 /**
@@ -3920,6 +3920,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	u32 mpi_control;
 	u16 smid;
 	u16 handle;
+	u16 msix_task = mpt3sas_base_get_msix_index(ioc);
 
 	if (ioc->logging_level & MPT_DEBUG_SCSI)
 		scsi_print_command(scmd);
@@ -4038,12 +4039,12 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
 			mpi_request->IoFlags = cpu_to_le16(scmd->cmd_len |
 			    MPI25_SCSIIO_IOFLAGS_FAST_PATH);
-			ioc->put_smid_fast_path(ioc, smid, handle);
+			ioc->put_smid_fast_path(ioc, smid, handle, msix_task);
 		} else
 			ioc->put_smid_scsi_io(ioc, smid,
-			    le16_to_cpu(mpi_request->DevHandle));
+				le16_to_cpu(mpi_request->DevHandle), msix_task);
 	} else
-		ioc->put_smid_default(ioc, smid);
+		ioc->put_smid_default(ioc, smid, msix_task);
 	return 0;
 
  out:
@@ -4542,7 +4543,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 		mpi_request->DevHandle =
 		    cpu_to_le16(sas_device_priv_data->sas_target->handle);
 		ioc->put_smid_scsi_io(ioc, smid,
-		    sas_device_priv_data->sas_target->handle);
+			sas_device_priv_data->sas_target->handle, msix_index);
 		return 0;
 	}
 	/* turning off TLR */
@@ -6159,7 +6160,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	    handle, phys_disk_num));
 
 	init_completion(&ioc->scsih_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
 
 	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -8018,7 +8019,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	if (!ioc->hide_ir_msg)
 		pr_info(MPT3SAS_FMT "IR shutdown (sending)\n", ioc->name);
 	init_completion(&ioc->scsih_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid, mpt3sas_base_get_msix_index(ioc));
 	wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
 
 	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 7f1d578..b74faf1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -392,7 +392,7 @@ struct rep_manu_reply {
 		"report_manufacture - send to sas_addr(0x%016llx)\n",
 		ioc->name, (unsigned long long)sas_address));
 	init_completion(&ioc->transport_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -1198,7 +1198,7 @@ struct phy_error_log_reply {
 		ioc->name, (unsigned long long)phy->identify.sas_address,
 		phy->number));
 	init_completion(&ioc->transport_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -1514,7 +1514,7 @@ struct phy_control_reply {
 		ioc->name, (unsigned long long)phy->identify.sas_address,
 		phy->number, phy_operation));
 	init_completion(&ioc->transport_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -2032,7 +2032,7 @@ struct phy_control_reply {
 		"%s - sending smp request\n", ioc->name, __func__));
 
 	init_completion(&ioc->transport_cmds.done);
-	ioc->put_smid_default(ioc, smid);
+	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
-- 
1.8.5.6
