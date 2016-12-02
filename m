From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH 10/11] megaraid_sas: Implement the PD Map support for SAS3.5 Generic Megaraid Controllers
Date: Fri,  2 Dec 2016 09:07:27 -0500
Message-ID: <1480687648-36380-11-git-send-email-sasikumar.pc@broadcom.com>
References: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, sumit.saxena@broadcom.com, thenzl@redhat.com, Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Update Linux driver to use new pdTargetId field for JBOD target ID

This patch is depending on patch 9

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 106 +++++++++++++++++++++-------
 drivers/scsi/megaraid/megaraid_sas_base.c   |   5 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  11 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   3 +-
 4 files changed, 94 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 40b8295..e4bb93d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1320,7 +1320,56 @@ struct megasas_ctrl_info {
 #endif
 	} adapterOperations3;
 
-	u8          pad[0x800-0x7EC];
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8 reserved:7;
+	/* Indicates whether the CPLD image is part of
+	*  the package and stored in flash   
+	*/
+	u8 cpldInFlash:1;
+#else
+	u8 cpldInFlash:1;
+	u8 reserved:7;
+#endif
+	u8 reserved1[3];
+	/* Null terminated string. Has the version
+	*  information if cpldInFlash = FALSE 
+	*/
+	u8 userCodeDefinition[12];
+	} cpld;  /* Valid only if upgradableCPLD is TRUE */
+
+	struct {
+	#if defined(__BIG_ENDIAN_BITFIELD)
+		u16 reserved			:8;
+		u16 FWSwapsBBUVPDInfo	:1;
+		u16 supportPdMapTargetId:1;
+		u16 supportSESCtrlInMultipathCfg:1;
+		u16 imageUploadSupported:1;
+		u16 supportEncryptedMfc :1;
+		u16 supportedEncAlgo	:1;
+		u16 supportIbuttonLess	:1;
+		u16 ctrlInfoExtSupported:1;
+	#else
+
+		u16 ctrlInfoExtSupported:1;
+		u16 supportIbuttonLess	:1;
+		u16 supportedEncAlgo	:1;
+		u16 supportEncryptedMfc :1;
+		u16 imageUploadSupported:1;
+		/* FW supports LUN based association and target port based */
+		u16 supportSESCtrlInMultipathCfg:1;
+		/* association for the SES device connected in multipath mode */
+		 /* FW defines Jbod target Id within MR_PD_CFG_SEQ */
+		u16 supportPdMapTargetId:1;
+		/* FW swaps relevant fields in MR_BBU_VPD_INFO_FIXED to
+		*  provide the data in little endian order 
+		*/
+		u16 FWSwapsBBUVPDInfo	:1;
+		u16 reserved			:8;
+	#endif
+		} adapterOperations4;
+
+    u8          pad[0x800-0x7FE]; 		/* 0x7FE pad to 2K for expansion */
 } __packed;
 
 /*
@@ -1560,33 +1609,35 @@ struct megasas_header {
 typedef union _MFI_CAPABILITIES {
 	struct {
 #if   defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved:20;
-		u32     support_qd_throttling:1;
-		u32     support_fp_rlbypass:1;
-		u32     support_vfid_in_ioframe:1;
-		u32     support_ext_io_size:1;
-		u32	support_ext_queue_depth:1;
-		u32     security_protocol_cmds_fw:1;
-		u32     support_core_affinity:1;
-		u32     support_ndrive_r1_lb:1;
-		u32	support_max_255lds:1;
-		u32	support_fastpath_wb:1;
-		u32     support_additional_msix:1;
-		u32     support_fp_remote_lun:1;
+	u32     reserved:19;
+	u32		supportPdMapTargetId:1;
+	u32     support_qd_throttling:1;
+	u32     support_fp_rlbypass:1;
+	u32     support_vfid_in_ioframe:1;
+	u32     support_ext_io_size:1;
+	u32		support_ext_queue_depth:1;
+	u32     security_protocol_cmds_fw:1;
+	u32     support_core_affinity:1;
+	u32     support_ndrive_r1_lb:1;
+	u32		support_max_255lds:1;
+	u32		support_fastpath_wb:1;
+	u32     support_additional_msix:1;
+	u32     support_fp_remote_lun:1;
 #else
-		u32     support_fp_remote_lun:1;
-		u32     support_additional_msix:1;
-		u32	support_fastpath_wb:1;
-		u32	support_max_255lds:1;
-		u32     support_ndrive_r1_lb:1;
-		u32     support_core_affinity:1;
-		u32     security_protocol_cmds_fw:1;
-		u32	support_ext_queue_depth:1;
-		u32     support_ext_io_size:1;
-		u32     support_vfid_in_ioframe:1;
-		u32     support_fp_rlbypass:1;
-		u32     support_qd_throttling:1;
-		u32     reserved:20;
+	u32     support_fp_remote_lun:1;
+	u32     support_additional_msix:1;
+	u32		support_fastpath_wb:1;
+	u32		support_max_255lds:1;
+	u32     support_ndrive_r1_lb:1;
+	u32     support_core_affinity:1;
+	u32     security_protocol_cmds_fw:1;
+	u32		support_ext_queue_depth:1;
+	u32     support_ext_io_size:1;
+	u32     support_vfid_in_ioframe:1;
+	u32     support_fp_rlbypass:1;
+	u32     support_qd_throttling:1;
+	u32		supportPdMapTargetId:1;
+	u32     reserved:19;
 #endif
 	} mfi_capabilities;
 	__le32		reg;
@@ -2055,6 +2106,7 @@ struct megasas_instance {
 	u32 crash_dump_drv_support;
 	u32 crash_dump_app_support;
 	u32 secure_jbod_support;
+	u32 support_morethan256jbod; /* FW support for more than 256 PD/JBOD */
 	bool use_seqnum_jbod_fp;   /* Added for PD sequence */
 	spinlock_t crashdump_lock;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index be11e9d..eb65077 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4578,6 +4578,7 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		le32_to_cpus((u32 *)&ctrl_info->properties.OnOffProperties);
 		le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
 		le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
+		le16_to_cpus((u16 *)&ctrl_info->adapterOperations4);
 
 		/* Update the latest Ext VD info.
 		 * From Init path, store current firmware details.
@@ -4586,7 +4587,9 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		 */
 		megasas_update_ext_vd_details(instance);
 		instance->use_seqnum_jbod_fp =
-			ctrl_info->adapterOperations3.useSeqNumJbodFP;
+					ctrl_info->adapterOperations3.useSeqNumJbodFP;
+		instance->support_morethan256jbod =
+					ctrl_info->adapterOperations4.supportPdMapTargetId;
 
 		/*Check whether controller is iMR or MR */
 		instance->is_imr = (ctrl_info->memory_size ? 0 : 1);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e8016bc..7c4f7bf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -862,6 +862,9 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 		drv_ops->mfi_capabilities.support_ext_queue_depth = 1;
 
 	drv_ops->mfi_capabilities.support_qd_throttling = 1;
+
+	drv_ops->mfi_capabilities.supportPdMapTargetId = 1;
+
 	/* Convert capability to LE32 */
 	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
 
@@ -2232,8 +2235,12 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 	if (instance->use_seqnum_jbod_fp &&
 		instance->pd_list[pd_index].driveType == TYPE_DISK) {
 		/* TgtId must be incremented by 255 as jbod seq number is index
-		 * below raid map
-		 */
+		* below raid map
+		*/
+		/* More than 256 PD/JBOD support for Ventura */
+		if (instance->support_morethan256jbod)
+			pRAID_Context->VirtualDiskTgtId = pd_sync->seq[pd_index].pdTargetId;
+		else
 		pRAID_Context->VirtualDiskTgtId =
 			cpu_to_le16(device_id + (MAX_PHYSICAL_DEVICES - 1));
 		pRAID_Context->configSeqNum = pd_sync->seq[pd_index].seqNum;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index e7be042..193d119 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1183,7 +1183,8 @@ struct MR_PD_CFG_SEQ {
 		u8     reserved:7;
 #endif
 	} capability;
-	u8  reserved[3];
+	u8  reserved;
+	u16 pdTargetId;
 } __packed;
 
 struct MR_PD_CFG_SEQ_NUM_SYNC {
-- 
1.8.3.1
