From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 09/11] mpt3sas: Use the new MPI 2.6 32-bit Atomic Request  Descriptors for SAS35 devices.
Date: Wed, 26 Oct 2016 13:34:40 +0530
Message-ID: <1477469082-32395-10-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Sathya Prakash <sathya.prakash@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Support Atomic Request Descriptors for Ventura/SAS35 devices.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 141 +++++++++++++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  18 ++--
 drivers/scsi/mpt3sas/mpt3sas_config.c    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  22 ++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     |  24 +++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |   8 +-
 6 files changed, 161 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 43cdc02..f00ef88 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -849,7 +849,7 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 	ack_request->EventContext = mpi_reply->EventContext;
 	ack_request->VF_ID = 0;  /* TODO */
 	ack_request->VP_ID = 0;
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 
  out:
 
@@ -2464,15 +2464,15 @@ _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
 #endif
 
 /**
- * mpt3sas_base_put_smid_scsi_io - send SCSI_IO request to firmware
+ * _base_put_smid_scsi_io - send SCSI_IO request to firmware
  * @ioc: per adapter object
  * @smid: system request message index
  * @handle: device handle
  *
  * Return nothing.
  */
-void
-mpt3sas_base_put_smid_scsi_io(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 handle)
+static void
+_base_put_smid_scsi_io(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 handle)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
@@ -2488,15 +2488,15 @@ mpt3sas_base_put_smid_scsi_io(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 handle)
 }
 
 /**
- * mpt3sas_base_put_smid_fast_path - send fast path request to firmware
+ * _base_put_smid_fast_path - send fast path request to firmware
  * @ioc: per adapter object
  * @smid: system request message index
  * @handle: device handle
  *
  * Return nothing.
  */
-void
-mpt3sas_base_put_smid_fast_path(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+static void
+_base_put_smid_fast_path(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	u16 handle)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
@@ -2513,14 +2513,14 @@ mpt3sas_base_put_smid_fast_path(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 }
 
 /**
- * mpt3sas_base_put_smid_hi_priority - send Task Managment request to firmware
+ * _base_put_smid_hi_priority - send Task Management request to firmware
  * @ioc: per adapter object
  * @smid: system request message index
  * @msix_task: msix_task will be same as msix of IO incase of task abort else 0.
  * Return nothing.
  */
-void
-mpt3sas_base_put_smid_hi_priority(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+static void
+_base_put_smid_hi_priority(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	u16 msix_task)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
@@ -2537,14 +2537,14 @@ mpt3sas_base_put_smid_hi_priority(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 }
 
 /**
- * mpt3sas_base_put_smid_default - Default, primarily used for config pages
+ * _base_put_smid_default - Default, primarily used for config pages
  * @ioc: per adapter object
  * @smid: system request message index
  *
  * Return nothing.
  */
-void
-mpt3sas_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+static void
+_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
@@ -2559,6 +2559,95 @@ mpt3sas_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 }
 
 /**
+* _base_put_smid_scsi_io_atomic - send SCSI_IO request to firmware using
+*   Atomic Request Descriptor
+* @ioc: per adapter object
+* @smid: system request message index
+* @handle: device handle, unused in this function, for function type match
+*
+* Return nothing.
+*/
+static void
+_base_put_smid_scsi_io_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+	u16 handle)
+{
+	Mpi26AtomicRequestDescriptor_t descriptor;
+	u32 *request = (u32 *)&descriptor;
+
+	descriptor.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
+	descriptor.MSIxIndex = _base_get_msix_index(ioc);
+	descriptor.SMID = cpu_to_le16(smid);
+
+	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
+}
+
+/**
+ * _base_put_smid_fast_path_atomic - send fast path request to firmware
+ * using Atomic Request Descriptor
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @handle: device handle, unused in this function, for function type match
+ * Return nothing
+ */
+static void
+_base_put_smid_fast_path_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+	u16 handle)
+{
+	Mpi26AtomicRequestDescriptor_t descriptor;
+	u32 *request = (u32 *)&descriptor;
+
+	descriptor.RequestFlags = MPI25_REQ_DESCRIPT_FLAGS_FAST_PATH_SCSI_IO;
+	descriptor.MSIxIndex = _base_get_msix_index(ioc);
+	descriptor.SMID = cpu_to_le16(smid);
+
+	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
+}
+
+/**
+ * _base_put_smid_hi_priority_atomic - send Task Management request to
+ * firmware using Atomic Request Descriptor
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_task: msix_task will be same as msix of IO incase of task abort else 0
+ *
+ * Return nothing.
+ */
+static void
+_base_put_smid_hi_priority_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+	u16 msix_task)
+{
+	Mpi26AtomicRequestDescriptor_t descriptor;
+	u32 *request = (u32 *)&descriptor;
+
+	descriptor.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY;
+	descriptor.MSIxIndex = msix_task;
+	descriptor.SMID = cpu_to_le16(smid);
+
+	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
+}
+
+/**
+ * _base_put_smid_default - Default, primarily used for config pages
+ * use Atomic Request Descriptor
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Return nothing.
+ */
+static void
+_base_put_smid_default_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	Mpi26AtomicRequestDescriptor_t descriptor;
+	u32 *request = (u32 *)&descriptor;
+
+	descriptor.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
+	descriptor.MSIxIndex = _base_get_msix_index(ioc);
+	descriptor.SMID = cpu_to_le16(smid);
+
+	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
+}
+
+/**
  * _base_display_OEMs_branding - Display branding string
  * @ioc: per adapter object
  *
@@ -4072,7 +4161,7 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 	    mpi_request->Operation == MPI2_SAS_OP_PHY_LINK_RESET)
 		ioc->ioc_link_reset_in_progress = 1;
 	init_completion(&ioc->base_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if ((mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
@@ -4172,7 +4261,7 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 	ioc->base_cmds.smid = smid;
 	memcpy(request, mpi_request, sizeof(Mpi2SepReply_t));
 	init_completion(&ioc->base_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -4357,6 +4446,8 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 	if ((facts->IOCCapabilities &
 	      MPI2_IOCFACTS_CAPABILITY_RDPQ_ARRAY_CAPABLE))
 		ioc->rdpq_array_capable = 1;
+	if (facts->IOCCapabilities & MPI26_IOCFACTS_CAPABILITY_ATOMIC_REQ)
+		ioc->atomic_desc_capable = 1;
 	facts->FWVersion.Word = le32_to_cpu(mpi_reply.FWVersion.Word);
 	facts->IOCRequestFrameSize =
 	    le16_to_cpu(mpi_reply.IOCRequestFrameSize);
@@ -4584,7 +4675,7 @@ _base_send_port_enable(struct MPT3SAS_ADAPTER *ioc)
 	mpi_request->Function = MPI2_FUNCTION_PORT_ENABLE;
 
 	init_completion(&ioc->port_enable_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->port_enable_cmds.done, 300*HZ);
 	if (!(ioc->port_enable_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
@@ -4647,7 +4738,7 @@ mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc)
 	memset(mpi_request, 0, sizeof(Mpi2PortEnableRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_PORT_ENABLE;
 
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	return 0;
 }
 
@@ -4766,7 +4857,7 @@ _base_event_notification(struct MPT3SAS_ADAPTER *ioc)
 		mpi_request->EventMasks[i] =
 		    cpu_to_le32(ioc->event_masks[i]);
 	init_completion(&ioc->base_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
@@ -5282,9 +5373,23 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		ioc->build_sg = &_base_build_sg_ieee;
 		ioc->build_zero_len_sge = &_base_build_zero_len_sge_ieee;
 		ioc->sge_size_ieee = sizeof(Mpi2IeeeSgeSimple64_t);
+
 		break;
 	}
 
+	if (ioc->atomic_desc_capable) {
+		ioc->put_smid_default = &_base_put_smid_default_atomic;
+		ioc->put_smid_scsi_io = &_base_put_smid_scsi_io_atomic;
+		ioc->put_smid_fast_path = &_base_put_smid_fast_path_atomic;
+		ioc->put_smid_hi_priority = &_base_put_smid_hi_priority_atomic;
+	} else {
+		ioc->put_smid_default = &_base_put_smid_default;
+		ioc->put_smid_scsi_io = &_base_put_smid_scsi_io;
+		ioc->put_smid_fast_path = &_base_put_smid_fast_path;
+		ioc->put_smid_hi_priority = &_base_put_smid_hi_priority;
+	}
+
+
 	/*
 	 * These function pointers for other requests that don't
 	 * the require IEEE scatter gather elements.
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index acb4106..5d9ae15 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -736,7 +736,10 @@ typedef void (*MPT_BUILD_SG)(struct MPT3SAS_ADAPTER *ioc, void *psge,
 typedef void (*MPT_BUILD_ZERO_LEN_SGE)(struct MPT3SAS_ADAPTER *ioc,
 		void *paddr);
 
-
+/* To support atomic and non atomic descriptors*/
+typedef void (*PUT_SMID_IO_FP_HIP) (struct MPT3SAS_ADAPTER *ioc, u16 smid,
+	u16 funcdep);
+typedef void (*PUT_SMID_DEFAULT) (struct MPT3SAS_ADAPTER *ioc, u16 smid);
 
 /* IOC Facts and Port Facts converted from little endian to cpu */
 union mpi3_version_union {
@@ -1194,6 +1197,12 @@ struct MPT3SAS_ADAPTER {
 	void		*device_remove_in_progress;
 	u16		device_remove_in_progress_sz;
 	u8		is_gen35_ioc;
+	u8		atomic_desc_capable;
+	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
+	PUT_SMID_IO_FP_HIP put_smid_fast_path;
+	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
+	PUT_SMID_DEFAULT put_smid_default;
+
 };
 
 typedef u8 (*MPT_CALLBACK)(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
@@ -1239,13 +1248,6 @@ u16 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 
 u16 mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid);
-void mpt3sas_base_put_smid_scsi_io(struct MPT3SAS_ADAPTER *ioc, u16 smid,
-	u16 handle);
-void mpt3sas_base_put_smid_fast_path(struct MPT3SAS_ADAPTER *ioc, u16 smid,
-	u16 handle);
-void mpt3sas_base_put_smid_hi_priority(struct MPT3SAS_ADAPTER *ioc,
-	u16 smid, u16 msix_task);
-void mpt3sas_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 void mpt3sas_base_initialize_callback_handler(void);
 u8 mpt3sas_base_register_callback_handler(MPT_CALLBACK cb_func);
 void mpt3sas_base_release_callback_handler(u8 cb_idx);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index cebfd73..dd62701 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -384,7 +384,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	memcpy(config_request, mpi_request, sizeof(Mpi2ConfigRequest_t));
 	_config_display_some_debug(ioc, smid, "config_request", NULL);
 	init_completion(&ioc->config_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->config_cmds.done, timeout*HZ);
 	if (!(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index a287bfb..050bd78 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -812,9 +812,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz,
 		    data_in_dma, data_in_sz);
 		if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)
-			mpt3sas_base_put_smid_scsi_io(ioc, smid, device_handle);
+			ioc->put_smid_scsi_io(ioc, smid, device_handle);
 		else
-			mpt3sas_base_put_smid_default(ioc, smid);
+			ioc->put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SCSI_TASK_MGMT:
@@ -849,7 +849,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		    tm_request->DevHandle));
 		ioc->build_sg_mpi(ioc, psge, data_out_dma, data_out_sz,
 		    data_in_dma, data_in_sz);
-		mpt3sas_base_put_smid_hi_priority(ioc, smid, 0);
+		ioc->put_smid_hi_priority(ioc, smid, 0);
 		break;
 	}
 	case MPI2_FUNCTION_SMP_PASSTHROUGH:
@@ -880,7 +880,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		}
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz, data_in_dma,
 		    data_in_sz);
-		mpt3sas_base_put_smid_default(ioc, smid);
+		ioc->put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SATA_PASSTHROUGH:
@@ -895,7 +895,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		}
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz, data_in_dma,
 		    data_in_sz);
-		mpt3sas_base_put_smid_default(ioc, smid);
+		ioc->put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_FW_DOWNLOAD:
@@ -903,7 +903,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	{
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz, data_in_dma,
 		    data_in_sz);
-		mpt3sas_base_put_smid_default(ioc, smid);
+		ioc->put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_TOOLBOX:
@@ -918,7 +918,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			ioc->build_sg_mpi(ioc, psge, data_out_dma, data_out_sz,
 				data_in_dma, data_in_sz);
 		}
-		mpt3sas_base_put_smid_default(ioc, smid);
+		ioc->put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SAS_IO_UNIT_CONTROL:
@@ -937,7 +937,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	default:
 		ioc->build_sg_mpi(ioc, psge, data_out_dma, data_out_sz,
 		    data_in_dma, data_in_sz);
-		mpt3sas_base_put_smid_default(ioc, smid);
+		ioc->put_smid_default(ioc, smid);
 		break;
 	}
 
@@ -1526,7 +1526,7 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 			cpu_to_le32(ioc->product_specific[buffer_type][i]);
 
 	init_completion(&ioc->ctl_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -1873,7 +1873,7 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	mpi_request->VP_ID = 0;
 
 	init_completion(&ioc->ctl_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -2140,7 +2140,7 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	mpi_request->VP_ID = 0;
 
 	init_completion(&ioc->ctl_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c58f326..6d17f66 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2285,7 +2285,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 		msix_task = scsi_lookup->msix_io;
 	else
 		msix_task = 0;
-	mpt3sas_base_put_smid_hi_priority(ioc, smid, msix_task);
+	ioc->put_smid_hi_priority(ioc, smid, msix_task);
 	wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
 	if (!(ioc->tm_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
@@ -3201,7 +3201,7 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
 	set_bit(handle, ioc->device_remove_in_progress);
-	mpt3sas_base_put_smid_hi_priority(ioc, smid, 0);
+	ioc->put_smid_hi_priority(ioc, smid, 0);
 	mpt3sas_trigger_master(ioc, MASTER_TRIGGER_DEVICE_REMOVAL);
 
 out:
@@ -3300,7 +3300,7 @@ _scsih_tm_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
 	mpi_request->Operation = MPI2_SAS_OP_REMOVE_DEVICE;
 	mpi_request->DevHandle = mpi_request_tm->DevHandle;
-	mpt3sas_base_put_smid_default(ioc, smid_sas_ctrl);
+	ioc->put_smid_default(ioc, smid_sas_ctrl);
 
 	return _scsih_check_for_pending_tm(ioc, smid);
 }
@@ -3395,7 +3395,7 @@ _scsih_tm_tr_volume_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
-	mpt3sas_base_put_smid_hi_priority(ioc, smid, 0);
+	ioc->put_smid_hi_priority(ioc, smid, 0);
 }
 
 /**
@@ -3487,7 +3487,7 @@ _scsih_issue_delayed_event_ack(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 event,
 	ack_request->EventContext = event_context;
 	ack_request->VF_ID = 0;  /* TODO */
 	ack_request->VP_ID = 0;
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 }
 
 /**
@@ -3544,7 +3544,7 @@ _scsih_issue_delayed_sas_io_unit_ctrl(struct MPT3SAS_ADAPTER *ioc,
 	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
 	mpi_request->Operation = MPI2_SAS_OP_REMOVE_DEVICE;
 	mpi_request->DevHandle = handle;
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 }
 
 /**
@@ -4158,12 +4158,12 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
 			mpi_request->IoFlags = cpu_to_le16(scmd->cmd_len |
 			    MPI25_SCSIIO_IOFLAGS_FAST_PATH);
-			mpt3sas_base_put_smid_fast_path(ioc, smid, handle);
+			ioc->put_smid_fast_path(ioc, smid, handle);
 		} else
-			mpt3sas_base_put_smid_scsi_io(ioc, smid,
+			ioc->put_smid_scsi_io(ioc, smid,
 			    le16_to_cpu(mpi_request->DevHandle));
 	} else
-		mpt3sas_base_put_smid_default(ioc, smid);
+		ioc->put_smid_default(ioc, smid);
 	return 0;
 
  out:
@@ -4659,7 +4659,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 		mpi_request->DevHandle =
 		    cpu_to_le16(sas_device_priv_data->sas_target->handle);
-		mpt3sas_base_put_smid_scsi_io(ioc, smid,
+		ioc->put_smid_scsi_io(ioc, smid,
 		    sas_device_priv_data->sas_target->handle);
 		return 0;
 	}
@@ -6273,7 +6273,7 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 	    handle, phys_disk_num));
 
 	init_completion(&ioc->scsih_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
 
 	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -8122,7 +8122,7 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
 	if (!ioc->hide_ir_msg)
 		pr_info(MPT3SAS_FMT "IR shutdown (sending)\n", ioc->name);
 	init_completion(&ioc->scsih_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
 
 	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index b74faf1..7f1d578 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -392,7 +392,7 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 		"report_manufacture - send to sas_addr(0x%016llx)\n",
 		ioc->name, (unsigned long long)sas_address));
 	init_completion(&ioc->transport_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -1198,7 +1198,7 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 		ioc->name, (unsigned long long)phy->identify.sas_address,
 		phy->number));
 	init_completion(&ioc->transport_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -1514,7 +1514,7 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 		ioc->name, (unsigned long long)phy->identify.sas_address,
 		phy->number, phy_operation));
 	init_completion(&ioc->transport_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -2032,7 +2032,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		"%s - sending smp request\n", ioc->name, __func__));
 
 	init_completion(&ioc->transport_cmds.done);
-	mpt3sas_base_put_smid_default(ioc, smid);
+	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
-- 
2.4.3
