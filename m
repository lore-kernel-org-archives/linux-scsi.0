From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v2 5/10] megaraid_sas : Support for max_io_size 1MB
Date: Thu, 20 Aug 2015 18:44:29 +0530
Message-ID: <201508201320.t7KDK3uN028574@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([199.3.246.86]:57305 "EHLO
	sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbbHTNOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2015 09:14:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Driver will expose max sge = 256 (earlier it was 64), if firmware support 
extended IO size upto 1M. 

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Martin Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |    7 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   64 +++++++++++++++++++--------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   10 +++-
 3 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 811fc4a..5db31c6 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1239,7 +1239,8 @@ union megasas_sgl_frame {
 typedef union _MFI_CAPABILITIES {
 	struct {
 #if   defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved:24;
+		u32     reserved:23;
+		u32     support_ext_io_size:1;
 		u32	support_ext_queue_depth:1;
 		u32     security_protocol_cmds_fw:1;
 		u32     support_core_affinity:1;
@@ -1257,7 +1258,8 @@ typedef union _MFI_CAPABILITIES {
 		u32     support_core_affinity:1;
 		u32     security_protocol_cmds_fw:1;
 		u32	support_ext_queue_depth:1;
-		u32     reserved:24;
+		u32     support_ext_io_size:1;
+		u32     reserved:23;
 #endif
 	} mfi_capabilities;
 	__le32		reg;
@@ -1795,6 +1797,7 @@ struct megasas_instance {
 	char mpio;
 	u16 throttlequeuedepth;
 	u8 mask_interrupts;
+	u16 max_chain_frame_sz;
 	u8 is_imr;
 	bool dev_handle;
 };
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f82085a..d1ff580 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -316,27 +316,24 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 	u32 max_cmd;
 	struct fusion_context *fusion;
 	struct megasas_cmd_fusion *cmd;
-	u32 total_sz_chain_frame;
 
 	fusion = instance->ctrl_context;
 	max_cmd = instance->max_fw_cmds;
 
-	total_sz_chain_frame = MEGASAS_MAX_SZ_CHAIN_FRAME;
-
 	/*
 	 * Use DMA pool facility provided by PCI layer
 	 */
 
-	fusion->sg_dma_pool = pci_pool_create("megasas sg pool fusion",
-					      instance->pdev,
-					      total_sz_chain_frame, 4,
-					      0);
+	fusion->sg_dma_pool = pci_pool_create("sg_pool_fusion", instance->pdev,
+						instance->max_chain_frame_sz,
+						4, 0);
+
 	if (!fusion->sg_dma_pool) {
 		printk(KERN_DEBUG "megasas: failed to setup request pool "
 		       "fusion\n");
 		return -ENOMEM;
 	}
-	fusion->sense_dma_pool = pci_pool_create("megasas sense pool fusion",
+	fusion->sense_dma_pool = pci_pool_create("sense_pool_fusion",
 						 instance->pdev,
 						 SCSI_SENSE_BUFFERSIZE, 64, 0);
 
@@ -667,7 +664,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	drv_ops->mfi_capabilities.support_max_255lds = 1;
 	drv_ops->mfi_capabilities.support_ndrive_r1_lb = 1;
 	drv_ops->mfi_capabilities.security_protocol_cmds_fw = 1;
-	
+	if (instance->max_chain_frame_sz > MEGASAS_CHAIN_FRAME_SZ_MIN)
+		drv_ops->mfi_capabilities.support_ext_io_size = 1;
+
 	/* Convert capability to LE32 */
 	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
 
@@ -1057,7 +1056,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *reg_set;
 	struct fusion_context *fusion;
-	u32 max_cmd;
+	u32 max_cmd, scratch_pad_2;
 	int i = 0, count;
 
 	fusion = instance->ctrl_context;
@@ -1096,15 +1095,40 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE *
 		 (max_cmd + 1)); /* Extra 1 for SMID 0 */
 
+	scratch_pad_2 = readl(&instance->reg_set->outbound_scratch_pad_2);
+	/* If scratch_pad_2 & MEGASAS_MAX_CHAIN_SIZE_UNITS_MASK is set,
+	 * Firmware support extended IO chain frame which is 4 times more than
+	 * legacy Firmware.
+	 * Legacy Firmware - Frame size is (8 * 128) = 1K
+	 * 1M IO Firmware  - Frame size is (8 * 128 * 4)  = 4K
+	 */
+	if (scratch_pad_2 & MEGASAS_MAX_CHAIN_SIZE_UNITS_MASK)
+		instance->max_chain_frame_sz =
+			((scratch_pad_2 & MEGASAS_MAX_CHAIN_SIZE_MASK) >>
+			MEGASAS_MAX_CHAIN_SHIFT) * MEGASAS_1MB_IO;
+	else
+		instance->max_chain_frame_sz =
+			((scratch_pad_2 & MEGASAS_MAX_CHAIN_SIZE_MASK) >>
+			MEGASAS_MAX_CHAIN_SHIFT) * MEGASAS_256K_IO;
+
+	if (instance->max_chain_frame_sz < MEGASAS_CHAIN_FRAME_SZ_MIN) {
+		dev_warn(&instance->pdev->dev, "frame size %d invalid, fall back to legacy max frame size %d\n",
+			instance->max_chain_frame_sz,
+			MEGASAS_CHAIN_FRAME_SZ_MIN);
+		instance->max_chain_frame_sz = MEGASAS_CHAIN_FRAME_SZ_MIN;
+	}
+
 	fusion->max_sge_in_main_msg =
-	  (MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE -
-	   offsetof(struct MPI2_RAID_SCSI_IO_REQUEST, SGL))/16;
+		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE
+			- offsetof(struct MPI2_RAID_SCSI_IO_REQUEST, SGL))/16;
 
 	fusion->max_sge_in_chain =
-		MEGASAS_MAX_SZ_CHAIN_FRAME / sizeof(union MPI2_SGE_IO_UNION);
+		instance->max_chain_frame_sz
+			/ sizeof(union MPI2_SGE_IO_UNION);
 
-	instance->max_num_sge = rounddown_pow_of_two(
-		fusion->max_sge_in_main_msg + fusion->max_sge_in_chain - 2);
+	instance->max_num_sge =
+		rounddown_pow_of_two(fusion->max_sge_in_main_msg
+			+ fusion->max_sge_in_chain - 2);
 
 	/* Used for pass thru MFI frame (DCMD) */
 	fusion->chain_offset_mfi_pthru =
@@ -1330,7 +1354,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 
 			sgl_ptr =
 			  (struct MPI25_IEEE_SGE_CHAIN64 *)cmd->sg_frame;
-			memset(sgl_ptr, 0, MEGASAS_MAX_SZ_CHAIN_FRAME);
+			memset(sgl_ptr, 0, instance->max_chain_frame_sz);
 		}
 	}
 
@@ -1895,7 +1919,7 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 			struct scsi_cmnd *scp,
 			struct megasas_cmd_fusion *cmd)
 {
-	u32 sge_count;
+	u16 sge_count;
 	u8  cmd_type;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd->io_request;
 
@@ -1953,7 +1977,11 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 		return 1;
 	}
 
+	/* numSGE store lower 8 bit of sge_count.
+	 * numSGEExt store higher 8 bit of sge_count
+	 */
 	io_request->RaidContext.numSGE = sge_count;
+	io_request->RaidContext.numSGEExt = (u8)(sge_count >> 8);
 
 	io_request->SGLFlags = cpu_to_le16(MPI2_SGE_FLAGS_64_BIT_ADDRESSING);
 
@@ -2347,7 +2375,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 	mpi25_ieee_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT |
 		MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR;
 
-	mpi25_ieee_chain->Length = cpu_to_le32(MEGASAS_MAX_SZ_CHAIN_FRAME);
+	mpi25_ieee_chain->Length = cpu_to_le32(instance->max_chain_frame_sz);
 
 	return 0;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 41f3d8b..7d89c1c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -35,8 +35,13 @@
 #define _MEGARAID_SAS_FUSION_H_
 
 /* Fusion defines */
-#define MEGASAS_MAX_SZ_CHAIN_FRAME 1024
+#define MEGASAS_CHAIN_FRAME_SZ_MIN 1024
 #define MFI_FUSION_ENABLE_INTERRUPT_MASK (0x00000009)
+#define MEGASAS_MAX_CHAIN_SHIFT			5
+#define MEGASAS_MAX_CHAIN_SIZE_UNITS_MASK	0x400000
+#define MEGASAS_MAX_CHAIN_SIZE_MASK		0x3E0
+#define MEGASAS_256K_IO				128
+#define MEGASAS_1MB_IO				(MEGASAS_256K_IO * 4)
 #define MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE 256
 #define MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST   0xF0
 #define MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST         0xF1
@@ -119,7 +124,8 @@ struct RAID_CONTEXT {
 	__le16	configSeqNum;
 	u8      spanArm;
 	u8      priority;
-	u8      resvd2[2];
+	u8	numSGEExt;
+	u8      resvd2;
 };
 
 #define RAID_CTX_SPANARM_ARM_SHIFT	(0)
-- 
1.7.1

