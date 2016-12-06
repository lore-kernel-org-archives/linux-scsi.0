From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V4 10/11] megaraid_sas: Implement the PD Map support for SAS3.5 Generic Megaraid Controllers
Date: Tue,  6 Dec 2016 18:00:19 -0500
Message-ID: <1481065220-18431-11-git-send-email-sasikumar.pc@broadcom.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35058 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbcLFXA4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 18:00:56 -0500
Received: by mail-qk0-f169.google.com with SMTP id n204so396520146qke.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2016 15:00:54 -0800 (PST)
In-Reply-To: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com

Update Linux driver to use new pdTargetId field for JBOD target ID

This patch is depending on patch 9

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 105 +++++++++++++++++++++-------
 drivers/scsi/megaraid/megaraid_sas_base.c   |   3 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   1 +
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   3 +-
 4 files changed, 84 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index eb5be2b..7334e07 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1317,7 +1317,55 @@ struct megasas_ctrl_info {
 #endif
 	} adapterOperations3;
 
-	u8          pad[0x800-0x7EC];
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8 reserved:7;
+	/* Indicates whether the CPLD image is part of
+	*  the package and stored in flash
+	*/
+	u8 cpld_in_flash:1;
+#else
+	u8 cpld_in_flash:1;
+	u8 reserved:7;
+#endif
+	u8 reserved1[3];
+	/* Null terminated string. Has the version
+	*  information if cpld_in_flash = FALSE
+	*/
+	u8 userCodeDefinition[12];
+	} cpld;  /* Valid only if upgradableCPLD is TRUE */
+
+	struct {
+	#if defined(__BIG_ENDIAN_BITFIELD)
+		u16 reserved:8;
+		u16 fw_swaps_bbu_vpd_info:1;
+		u16 support_pd_map_target_id:1;
+		u16 support_ses_ctrl_in_multipathcfg:1;
+		u16 image_upload_supported:1;
+		u16 support_encrypted_mfc:1;
+		u16 supported_enc_algo:1;
+		u16 support_ibutton_less:1;
+		u16 ctrl_info_ext_supported:1;
+	#else
+
+		u16 ctrl_info_ext_supported:1;
+		u16 support_ibutton_less:1;
+		u16 supported_enc_algo:1;
+		u16 support_encrypted_mfc:1;
+		u16 image_upload_supported:1;
+		/* FW supports LUN based association and target port based */
+		u16 support_ses_ctrl_in_multipathcfg:1;
+		/* association for the SES device connected in multipath mode */
+		 /* FW defines Jbod target Id within MR_PD_CFG_SEQ */
+		u16 support_pd_map_target_id:1;
+		/* FW swaps relevant fields in MR_BBU_VPD_INFO_FIXED to
+		*  provide the data in little endian order
+		*/
+		u16 fw_swaps_bbu_vpd_info:1;
+		u16 reserved:8;
+	#endif
+		} adapter_operations4;
+	u8 pad[0x800-0x7FE]; /* 0x7FE pad to 2K for expansion */
 } __packed;
 
 /*
@@ -1557,33 +1605,35 @@ struct megasas_header {
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
+	u32 support_pd_map_target_id:1;
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
+	u32	support_pd_map_target_id:1;
+	u32     reserved:19;
 #endif
 	} mfi_capabilities;
 	__le32		reg;
@@ -2052,6 +2102,7 @@ struct megasas_instance {
 	u32 crash_dump_drv_support;
 	u32 crash_dump_app_support;
 	u32 secure_jbod_support;
+	u32 support_morethan256jbod; /* FW support for more than 256 PD/JBOD */
 	bool use_seqnum_jbod_fp;   /* Added for PD sequence */
 	spinlock_t crashdump_lock;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 899d25c..9e24d18 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4577,6 +4577,7 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		le32_to_cpus((u32 *)&ctrl_info->properties.OnOffProperties);
 		le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
 		le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
+		le16_to_cpus((u16 *)&ctrl_info->adapter_operations4);
 
 		/* Update the latest Ext VD info.
 		 * From Init path, store current firmware details.
@@ -4586,6 +4587,8 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		megasas_update_ext_vd_details(instance);
 		instance->use_seqnum_jbod_fp =
 			ctrl_info->adapterOperations3.useSeqNumJbodFP;
+		instance->support_morethan256jbod =
+			ctrl_info->adapter_operations4.support_pd_map_target_id;
 
 		/*Check whether controller is iMR or MR */
 		instance->is_imr = (ctrl_info->memory_size ? 0 : 1);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 3598590..dc56dd8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -864,6 +864,7 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 		drv_ops->mfi_capabilities.support_ext_queue_depth = 1;
 
 	drv_ops->mfi_capabilities.support_qd_throttling = 1;
+	drv_ops->mfi_capabilities.support_pd_map_target_id = 1;
 	/* Convert capability to LE32 */
 	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index da05790..3b66727 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1189,7 +1189,8 @@ struct MR_PD_CFG_SEQ {
 		u8     reserved:7;
 #endif
 	} capability;
-	u8  reserved[3];
+	u8  reserved;
+	u16 pd_target_id;
 } __packed;
 
 struct MR_PD_CFG_SEQ_NUM_SYNC {
-- 
1.8.3.1

