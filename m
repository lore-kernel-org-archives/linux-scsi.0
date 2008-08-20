From: akpm@linux-foundation.org
Subject: [patch 03/18] aic7xxx: update *_shipped files
Date: Wed, 20 Aug 2008 16:55:25 -0700
Message-ID: <200808202355.m7KNtPv1006188@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756180AbYHTX4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2008 19:56:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, vda.linux@googlemail.com, James.Bottomley@HansenPartnership.com, hare@suse.de

From: Denys Vlasenko <vda.linux@googlemail.com>

Update *_shipped files

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_reg.h_shipped       |  567 ---
 drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped | 1981 -------------
 drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped       |  875 -----
 drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped | 1325 --------
 4 files changed, 342 insertions(+), 4406 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_reg.h_shipped~aic7xxx-update-_shipped-files drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
--- a/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped~aic7xxx-update-_shipped-files
+++ a/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
@@ -34,13 +34,6 @@ ahd_reg_print_t ahd_seqintcode_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrint_print;
-#else
-#define ahd_clrint_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRINT", 0x03, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_error_print;
 #else
 #define ahd_error_print(regvalue, cur_col, wrap) \
@@ -48,20 +41,6 @@ ahd_reg_print_t ahd_error_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hcntrl_print;
-#else
-#define ahd_hcntrl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HCNTRL", 0x05, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hnscb_qoff_print;
-#else
-#define ahd_hnscb_qoff_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HNSCB_QOFF", 0x06, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_hescb_qoff_print;
 #else
 #define ahd_hescb_qoff_print(regvalue, cur_col, wrap) \
@@ -97,13 +76,6 @@ ahd_reg_print_t ahd_swtimer_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_snscb_qoff_print;
-#else
-#define ahd_snscb_qoff_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SNSCB_QOFF", 0x10, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sescb_qoff_print;
 #else
 #define ahd_sescb_qoff_print(regvalue, cur_col, wrap) \
@@ -111,20 +83,6 @@ ahd_reg_print_t ahd_sescb_qoff_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sdscb_qoff_print;
-#else
-#define ahd_sdscb_qoff_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SDSCB_QOFF", 0x14, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_qoff_ctlsta_print;
-#else
-#define ahd_qoff_ctlsta_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "QOFF_CTLSTA", 0x16, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_intctl_print;
 #else
 #define ahd_intctl_print(regvalue, cur_col, wrap) \
@@ -139,13 +97,6 @@ ahd_reg_print_t ahd_dfcntrl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dscommand0_print;
-#else
-#define ahd_dscommand0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DSCOMMAND0", 0x19, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dfstatus_print;
 #else
 #define ahd_dfstatus_print(regvalue, cur_col, wrap) \
@@ -160,13 +111,6 @@ ahd_reg_print_t ahd_sg_cache_shadow_prin
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sg_cache_pre_print;
-#else
-#define ahd_sg_cache_pre_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SG_CACHE_PRE", 0x1b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqin_print;
 #else
 #define ahd_lqin_print(regvalue, cur_col, wrap) \
@@ -293,13 +237,6 @@ ahd_reg_print_t ahd_sxfrctl0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sxfrctl1_print;
-#else
-#define ahd_sxfrctl1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SXFRCTL1", 0x3d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dffstat_print;
 #else
 #define ahd_dffstat_print(regvalue, cur_col, wrap) \
@@ -314,13 +251,6 @@ ahd_reg_print_t ahd_multargid_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsisigo_print;
-#else
-#define ahd_scsisigo_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSISIGO", 0x40, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scsisigi_print;
 #else
 #define ahd_scsisigi_print(regvalue, cur_col, wrap) \
@@ -363,13 +293,6 @@ ahd_reg_print_t ahd_selid_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_optionmode_print;
-#else
-#define ahd_optionmode_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OPTIONMODE", 0x4a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sblkctl_print;
 #else
 #define ahd_sblkctl_print(regvalue, cur_col, wrap) \
@@ -391,13 +314,6 @@ ahd_reg_print_t ahd_simode0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrsint0_print;
-#else
-#define ahd_clrsint0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRSINT0", 0x4b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sstat1_print;
 #else
 #define ahd_sstat1_print(regvalue, cur_col, wrap) \
@@ -405,13 +321,6 @@ ahd_reg_print_t ahd_sstat1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrsint1_print;
-#else
-#define ahd_clrsint1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRSINT1", 0x4c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sstat2_print;
 #else
 #define ahd_sstat2_print(regvalue, cur_col, wrap) \
@@ -461,17 +370,17 @@ ahd_reg_print_t ahd_lqistat0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqimode0_print;
+ahd_reg_print_t ahd_clrlqiint0_print;
 #else
-#define ahd_lqimode0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQIMODE0", 0x50, regvalue, cur_col, wrap)
+#define ahd_clrlqiint0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "CLRLQIINT0", 0x50, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrlqiint0_print;
+ahd_reg_print_t ahd_lqimode0_print;
 #else
-#define ahd_clrlqiint0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRLQIINT0", 0x50, regvalue, cur_col, wrap)
+#define ahd_lqimode0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "LQIMODE0", 0x50, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -629,17 +538,17 @@ ahd_reg_print_t ahd_seqintsrc_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqimode_print;
+ahd_reg_print_t ahd_currscb_print;
 #else
-#define ahd_seqimode_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQIMODE", 0x5c, regvalue, cur_col, wrap)
+#define ahd_currscb_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "CURRSCB", 0x5c, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_currscb_print;
+ahd_reg_print_t ahd_seqimode_print;
 #else
-#define ahd_currscb_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CURRSCB", 0x5c, regvalue, cur_col, wrap)
+#define ahd_seqimode_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SEQIMODE", 0x5c, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -657,13 +566,6 @@ ahd_reg_print_t ahd_lastscb_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_shaddr_print;
-#else
-#define ahd_shaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SHADDR", 0x60, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_negoaddr_print;
 #else
 #define ahd_negoaddr_print(regvalue, cur_col, wrap) \
@@ -748,27 +650,6 @@ ahd_reg_print_t ahd_seloid_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_haddr_print;
-#else
-#define ahd_haddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HADDR", 0x70, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hcnt_print;
-#else
-#define ahd_hcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HCNT", 0x78, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sghaddr_print;
-#else
-#define ahd_sghaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGHADDR", 0x7c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scbhaddr_print;
 #else
 #define ahd_scbhaddr_print(regvalue, cur_col, wrap) \
@@ -776,10 +657,10 @@ ahd_reg_print_t ahd_scbhaddr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sghcnt_print;
+ahd_reg_print_t ahd_sghaddr_print;
 #else
-#define ahd_sghcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGHCNT", 0x84, regvalue, cur_col, wrap)
+#define ahd_sghaddr_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SGHADDR", 0x7c, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -790,10 +671,10 @@ ahd_reg_print_t ahd_scbhcnt_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dff_thrsh_print;
+ahd_reg_print_t ahd_sghcnt_print;
 #else
-#define ahd_dff_thrsh_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFF_THRSH", 0x88, regvalue, cur_col, wrap)
+#define ahd_sghcnt_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SGHCNT", 0x84, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -867,13 +748,6 @@ ahd_reg_print_t ahd_targpcistat_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scbptr_print;
-#else
-#define ahd_scbptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCBPTR", 0xa8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scbautoptr_print;
 #else
 #define ahd_scbautoptr_print(regvalue, cur_col, wrap) \
@@ -881,13 +755,6 @@ ahd_reg_print_t ahd_scbautoptr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccsgaddr_print;
-#else
-#define ahd_ccsgaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSGADDR", 0xac, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_ccscbaddr_print;
 #else
 #define ahd_ccscbaddr_print(regvalue, cur_col, wrap) \
@@ -909,13 +776,6 @@ ahd_reg_print_t ahd_ccsgctl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccsgram_print;
-#else
-#define ahd_ccsgram_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSGRAM", 0xb0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_ccscbram_print;
 #else
 #define ahd_ccscbram_print(regvalue, cur_col, wrap) \
@@ -930,13 +790,6 @@ ahd_reg_print_t ahd_brddat_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_brdctl_print;
-#else
-#define ahd_brdctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "BRDCTL", 0xb9, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seeadr_print;
 #else
 #define ahd_seeadr_print(regvalue, cur_col, wrap) \
@@ -972,13 +825,6 @@ ahd_reg_print_t ahd_dspdatactl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfdat_print;
-#else
-#define ahd_dfdat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFDAT", 0xc4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dspselect_print;
 #else
 #define ahd_dspselect_print(regvalue, cur_col, wrap) \
@@ -1000,13 +846,6 @@ ahd_reg_print_t ahd_seqctl0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_flags_print;
-#else
-#define ahd_flags_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FLAGS", 0xd8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seqintctl_print;
 #else
 #define ahd_seqintctl_print(regvalue, cur_col, wrap) \
@@ -1014,13 +853,6 @@ ahd_reg_print_t ahd_seqintctl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqram_print;
-#else
-#define ahd_seqram_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQRAM", 0xda, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_prgmcnt_print;
 #else
 #define ahd_prgmcnt_print(regvalue, cur_col, wrap) \
@@ -1028,41 +860,6 @@ ahd_reg_print_t ahd_prgmcnt_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_accum_print;
-#else
-#define ahd_accum_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ACCUM", 0xe0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sindex_print;
-#else
-#define ahd_sindex_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SINDEX", 0xe2, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dindex_print;
-#else
-#define ahd_dindex_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DINDEX", 0xe4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_allones_print;
-#else
-#define ahd_allones_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ALLONES", 0xe8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_allzeros_print;
-#else
-#define ahd_allzeros_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ALLZEROS", 0xea, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_none_print;
 #else
 #define ahd_none_print(regvalue, cur_col, wrap) \
@@ -1070,27 +867,6 @@ ahd_reg_print_t ahd_none_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sindir_print;
-#else
-#define ahd_sindir_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SINDIR", 0xec, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dindir_print;
-#else
-#define ahd_dindir_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DINDIR", 0xed, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_stack_print;
-#else
-#define ahd_stack_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "STACK", 0xf2, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_intvec1_addr_print;
 #else
 #define ahd_intvec1_addr_print(regvalue, cur_col, wrap) \
@@ -1126,17 +902,17 @@ ahd_reg_print_t ahd_accum_save_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sram_base_print;
+ahd_reg_print_t ahd_waiting_scb_tails_print;
 #else
-#define ahd_sram_base_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SRAM_BASE", 0x100, regvalue, cur_col, wrap)
+#define ahd_waiting_scb_tails_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "WAITING_SCB_TAILS", 0x100, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_waiting_scb_tails_print;
+ahd_reg_print_t ahd_sram_base_print;
 #else
-#define ahd_waiting_scb_tails_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "WAITING_SCB_TAILS", 0x100, regvalue, cur_col, wrap)
+#define ahd_sram_base_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SRAM_BASE", 0x100, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -1224,13 +1000,6 @@ ahd_reg_print_t ahd_msg_out_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dmaparams_print;
-#else
-#define ahd_dmaparams_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DMAPARAMS", 0x138, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seq_flags_print;
 #else
 #define ahd_seq_flags_print(regvalue, cur_col, wrap) \
@@ -1238,20 +1007,6 @@ ahd_reg_print_t ahd_seq_flags_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_saved_scsiid_print;
-#else
-#define ahd_saved_scsiid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SAVED_SCSIID", 0x13a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_saved_lun_print;
-#else
-#define ahd_saved_lun_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SAVED_LUN", 0x13b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lastphase_print;
 #else
 #define ahd_lastphase_print(regvalue, cur_col, wrap) \
@@ -1273,20 +1028,6 @@ ahd_reg_print_t ahd_kernel_tqinpos_print
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_tqinpos_print;
-#else
-#define ahd_tqinpos_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "TQINPOS", 0x13f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_shared_data_addr_print;
-#else
-#define ahd_shared_data_addr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SHARED_DATA_ADDR", 0x140, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_qoutfifo_next_addr_print;
 #else
 #define ahd_qoutfifo_next_addr_print(regvalue, cur_col, wrap) \
@@ -1294,20 +1035,6 @@ ahd_reg_print_t ahd_qoutfifo_next_addr_p
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_arg_1_print;
-#else
-#define ahd_arg_1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ARG_1", 0x148, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_arg_2_print;
-#else
-#define ahd_arg_2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ARG_2", 0x149, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_last_msg_print;
 #else
 #define ahd_last_msg_print(regvalue, cur_col, wrap) \
@@ -1406,13 +1133,6 @@ ahd_reg_print_t ahd_mk_message_scsiid_pr
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_residual_datacnt_print;
-#else
-#define ahd_scb_residual_datacnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_RESIDUAL_DATACNT", 0x180, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scb_base_print;
 #else
 #define ahd_scb_base_print(regvalue, cur_col, wrap) \
@@ -1420,17 +1140,10 @@ ahd_reg_print_t ahd_scb_base_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_residual_sgptr_print;
-#else
-#define ahd_scb_residual_sgptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_RESIDUAL_SGPTR", 0x184, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_scsi_status_print;
+ahd_reg_print_t ahd_scb_residual_datacnt_print;
 #else
-#define ahd_scb_scsi_status_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_SCSI_STATUS", 0x188, regvalue, cur_col, wrap)
+#define ahd_scb_residual_datacnt_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCB_RESIDUAL_DATACNT", 0x180, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -1476,13 +1189,6 @@ ahd_reg_print_t ahd_scb_task_attribute_p
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_cdb_len_print;
-#else
-#define ahd_scb_cdb_len_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_CDB_LEN", 0x196, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scb_task_management_print;
 #else
 #define ahd_scb_task_management_print(regvalue, cur_col, wrap) \
@@ -1518,13 +1224,6 @@ ahd_reg_print_t ahd_scb_busaddr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_next_print;
-#else
-#define ahd_scb_next_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_NEXT", 0x1ac, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scb_next2_print;
 #else
 #define ahd_scb_next2_print(regvalue, cur_col, wrap) \
@@ -1717,10 +1416,10 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	SG_CACHE_PRE    		0x1b
 
-#define	TYPEPTR         		0x20
-
 #define	LQIN            		0x20
 
+#define	TYPEPTR         		0x20
+
 #define	TAGPTR          		0x21
 
 #define	LUNPTR          		0x22
@@ -1780,6 +1479,14 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		SINGLECMD       	0x02
 #define		ABORTPENDING    	0x01
 
+#define	SCSBIST0        		0x39
+#define		GSBISTERR       	0x40
+#define		GSBISTDONE      	0x20
+#define		GSBISTRUN       	0x10
+#define		OSBISTERR       	0x04
+#define		OSBISTDONE      	0x02
+#define		OSBISTRUN       	0x01
+
 #define	LQCTL2          		0x39
 #define		LQIRETRY        	0x80
 #define		LQICONTINUE     	0x40
@@ -1790,13 +1497,10 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		LQOTOIDLE       	0x02
 #define		LQOPAUSE        	0x01
 
-#define	SCSBIST0        		0x39
-#define		GSBISTERR       	0x40
-#define		GSBISTDONE      	0x20
-#define		GSBISTRUN       	0x10
-#define		OSBISTERR       	0x04
-#define		OSBISTDONE      	0x02
-#define		OSBISTRUN       	0x01
+#define	SCSBIST1        		0x3a
+#define		NTBISTERR       	0x04
+#define		NTBISTDONE      	0x02
+#define		NTBISTRUN       	0x01
 
 #define	SCSISEQ0        		0x3a
 #define		TEMODEO         	0x80
@@ -1805,15 +1509,8 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		FORCEBUSFREE    	0x10
 #define		SCSIRSTO        	0x01
 
-#define	SCSBIST1        		0x3a
-#define		NTBISTERR       	0x04
-#define		NTBISTDONE      	0x02
-#define		NTBISTRUN       	0x01
-
 #define	SCSISEQ1        		0x3b
 
-#define	BUSINITID       		0x3c
-
 #define	SXFRCTL0        		0x3c
 #define		DFON            	0x80
 #define		DFPEXP          	0x40
@@ -1822,6 +1519,8 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	DLCOUNT         		0x3c
 
+#define	BUSINITID       		0x3c
+
 #define	SXFRCTL1        		0x3d
 #define		BITBUCKET       	0x80
 #define		ENSACHK         	0x40
@@ -1846,8 +1545,6 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		CURRFIFO_1      	0x01
 #define		CURRFIFO_0      	0x00
 
-#define	MULTARGID       		0x40
-
 #define	SCSISIGO        		0x40
 #define		CDO             	0x80
 #define		IOO             	0x40
@@ -1858,6 +1555,8 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		REQO            	0x02
 #define		ACKO            	0x01
 
+#define	MULTARGID       		0x40
+
 #define	SCSISIGI        		0x41
 #define		ATNI            	0x10
 #define		SELI            	0x08
@@ -1904,6 +1603,15 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		ENAB20          	0x04
 #define		SELWIDE         	0x02
 
+#define	CLRSINT0        		0x4b
+#define		CLRSELDO        	0x40
+#define		CLRSELDI        	0x20
+#define		CLRSELINGO      	0x10
+#define		CLRIOERR        	0x08
+#define		CLROVERRUN      	0x04
+#define		CLRSPIORDY      	0x02
+#define		CLRARBDO        	0x01
+
 #define	SSTAT0          		0x4b
 #define		TARGET          	0x80
 #define		SELDO           	0x40
@@ -1923,14 +1631,14 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		ENSPIORDY       	0x02
 #define		ENARBDO         	0x01
 
-#define	CLRSINT0        		0x4b
-#define		CLRSELDO        	0x40
-#define		CLRSELDI        	0x20
-#define		CLRSELINGO      	0x10
-#define		CLRIOERR        	0x08
-#define		CLROVERRUN      	0x04
-#define		CLRSPIORDY      	0x02
-#define		CLRARBDO        	0x01
+#define	CLRSINT1        		0x4c
+#define		CLRSELTIMEO     	0x80
+#define		CLRATNO         	0x40
+#define		CLRSCSIRSTI     	0x20
+#define		CLRBUSFREE      	0x08
+#define		CLRSCSIPERR     	0x04
+#define		CLRSTRB2FAST    	0x02
+#define		CLRREQINIT      	0x01
 
 #define	SSTAT1          		0x4c
 #define		SELTO           	0x80
@@ -1942,15 +1650,6 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		STRB2FAST       	0x02
 #define		REQINIT         	0x01
 
-#define	CLRSINT1        		0x4c
-#define		CLRSELTIMEO     	0x80
-#define		CLRATNO         	0x40
-#define		CLRSCSIRSTI     	0x20
-#define		CLRBUSFREE      	0x08
-#define		CLRSCSIPERR     	0x04
-#define		CLRSTRB2FAST    	0x02
-#define		CLRREQINIT      	0x01
-
 #define	SSTAT2          		0x4d
 #define		BUSFREETIME     	0xc0
 #define		NONPACKREQ      	0x20
@@ -1998,14 +1697,6 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		LQIATNLQ        	0x02
 #define		LQIATNCMD       	0x01
 
-#define	LQIMODE0        		0x50
-#define		ENLQIATNQASK    	0x20
-#define		ENLQICRCT1      	0x10
-#define		ENLQICRCT2      	0x08
-#define		ENLQIBADLQT     	0x04
-#define		ENLQIATNLQ      	0x02
-#define		ENLQIATNCMD     	0x01
-
 #define	CLRLQIINT0      		0x50
 #define		CLRLQIATNQAS    	0x20
 #define		CLRLQICRCT1     	0x10
@@ -2014,6 +1705,14 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		CLRLQIATNLQ     	0x02
 #define		CLRLQIATNCMD    	0x01
 
+#define	LQIMODE0        		0x50
+#define		ENLQIATNQASK    	0x20
+#define		ENLQICRCT1      	0x10
+#define		ENLQICRCT2      	0x08
+#define		ENLQIBADLQT     	0x04
+#define		ENLQIATNLQ      	0x02
+#define		ENLQIATNCMD     	0x01
+
 #define	LQIMODE1        		0x51
 #define		ENLQIPHASE_LQ   	0x80
 #define		ENLQIPHASE_NLQ  	0x40
@@ -2160,6 +1859,8 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		CFG4ICMD        	0x02
 #define		CFG4TCMD        	0x01
 
+#define	CURRSCB         		0x5c
+
 #define	SEQIMODE        		0x5c
 #define		ENCTXTDONE      	0x40
 #define		ENSAVEPTRS      	0x20
@@ -2169,8 +1870,6 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		ENCFG4ICMD      	0x02
 #define		ENCFG4TCMD      	0x01
 
-#define	CURRSCB         		0x5c
-
 #define	MDFFSTAT        		0x5d
 #define		SHCNTNEGATIVE   	0x40
 #define		SHCNTMINUS1     	0x20
@@ -2185,29 +1884,29 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	DFFTAG          		0x5e
 
+#define	LASTSCB         		0x5e
+
 #define	SCSITEST        		0x5e
 #define		CNTRTEST        	0x08
 #define		SEL_TXPLL_DEBUG 	0x04
 
-#define	LASTSCB         		0x5e
-
 #define	IOPDNCTL        		0x5f
 #define		DISABLE_OE      	0x80
 #define		PDN_IDIST       	0x04
 #define		PDN_DIFFSENSE   	0x01
 
-#define	DGRPCRCI        		0x60
-
 #define	SHADDR          		0x60
 
 #define	NEGOADDR        		0x60
 
-#define	NEGPERIOD       		0x61
+#define	DGRPCRCI        		0x60
 
-#define	NEGOFFSET       		0x62
+#define	NEGPERIOD       		0x61
 
 #define	PACKCRCI        		0x62
 
+#define	NEGOFFSET       		0x62
+
 #define	NEGPPROPTS      		0x63
 #define		PPROPT_PACE     	0x08
 #define		PPROPT_QAS      	0x04
@@ -2253,8 +1952,6 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	SELOID          		0x6b
 
-#define	FAIRNESS        		0x6c
-
 #define	PLL400CTL0      		0x6c
 #define		PLL_VCOSEL      	0x80
 #define		PLL_PWDN        	0x40
@@ -2264,6 +1961,8 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		PLL_DLPF        	0x02
 #define		PLL_ENFBM       	0x01
 
+#define	FAIRNESS        		0x6c
+
 #define	PLL400CTL1      		0x6d
 #define		PLL_CNTEN       	0x80
 #define		PLL_CNTCLR      	0x40
@@ -2275,25 +1974,25 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	HADDR           		0x70
 
-#define	HODMAADR        		0x70
-
 #define	PLLDELAY        		0x70
 #define		SPLIT_DROP_REQ  	0x80
 
-#define	HCNT            		0x78
+#define	HODMAADR        		0x70
 
 #define	HODMACNT        		0x78
 
-#define	HODMAEN         		0x7a
+#define	HCNT            		0x78
 
-#define	SGHADDR         		0x7c
+#define	HODMAEN         		0x7a
 
 #define	SCBHADDR        		0x7c
 
-#define	SGHCNT          		0x84
+#define	SGHADDR         		0x7c
 
 #define	SCBHCNT         		0x84
 
+#define	SGHCNT          		0x84
+
 #define	DFF_THRSH       		0x88
 #define		WR_DFTHRSH      	0x70
 #define		RD_DFTHRSH      	0x07
@@ -2326,10 +2025,6 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	CMCRXMSG0       		0x90
 
-#define	OVLYRXMSG0      		0x90
-
-#define	DCHRXMSG0       		0x90
-
 #define	ROENABLE        		0x90
 #define		MSIROEN         	0x20
 #define		OVLYROEN        	0x10
@@ -2338,11 +2033,11 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		DCH1ROEN        	0x02
 #define		DCH0ROEN        	0x01
 
-#define	OVLYRXMSG1      		0x91
+#define	OVLYRXMSG0      		0x90
 
-#define	CMCRXMSG1       		0x91
+#define	DCHRXMSG0       		0x90
 
-#define	DCHRXMSG1       		0x91
+#define	OVLYRXMSG1      		0x91
 
 #define	NSENABLE        		0x91
 #define		MSINSEN         	0x20
@@ -2352,6 +2047,10 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		DCH1NSEN        	0x02
 #define		DCH0NSEN        	0x01
 
+#define	CMCRXMSG1       		0x91
+
+#define	DCHRXMSG1       		0x91
+
 #define	DCHRXMSG2       		0x92
 
 #define	CMCRXMSG2       		0x92
@@ -2375,24 +2074,24 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		TSCSERREN       	0x02
 #define		CMPABCDIS       	0x01
 
-#define	CMCSEQBCNT      		0x94
-
 #define	OVLYSEQBCNT     		0x94
 
 #define	DCHSEQBCNT      		0x94
 
+#define	CMCSEQBCNT      		0x94
+
+#define	CMCSPLTSTAT0    		0x96
+
 #define	DCHSPLTSTAT0    		0x96
 
 #define	OVLYSPLTSTAT0   		0x96
 
-#define	CMCSPLTSTAT0    		0x96
+#define	CMCSPLTSTAT1    		0x97
 
 #define	OVLYSPLTSTAT1   		0x97
 
 #define	DCHSPLTSTAT1    		0x97
 
-#define	CMCSPLTSTAT1    		0x97
-
 #define	SGRXMSG0        		0x98
 #define		CDNUM           	0xf8
 #define		CFNUM           	0x07
@@ -2420,15 +2119,18 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		TAG_NUM         	0x1f
 #define		RLXORD          	0x10
 
+#define	SGSEQBCNT       		0x9c
+
 #define	SLVSPLTOUTATTR0 		0x9c
 #define		LOWER_BCNT      	0xff
 
-#define	SGSEQBCNT       		0x9c
-
 #define	SLVSPLTOUTATTR1 		0x9d
 #define		CMPLT_DNUM      	0xf8
 #define		CMPLT_FNUM      	0x07
 
+#define	SLVSPLTOUTATTR2 		0x9e
+#define		CMPLT_BNUM      	0xff
+
 #define	SGSPLTSTAT0     		0x9e
 #define		STAETERM        	0x80
 #define		SCBCERR         	0x40
@@ -2439,9 +2141,6 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		RXSCEMSG        	0x02
 #define		RXSPLTRSP       	0x01
 
-#define	SLVSPLTOUTATTR2 		0x9e
-#define		CMPLT_BNUM      	0xff
-
 #define	SGSPLTSTAT1     		0x9f
 #define		RXDATABUCKET    	0x01
 
@@ -2497,10 +2196,10 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	CCSGADDR        		0xac
 
-#define	CCSCBADDR       		0xac
-
 #define	CCSCBADR_BK     		0xac
 
+#define	CCSCBADDR       		0xac
+
 #define	CMC_RAMBIST     		0xad
 #define		SG_ELEMENT_SIZE 	0x80
 #define		SCBRAMBIST_FAIL 	0x40
@@ -2554,9 +2253,9 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define	SEEDAT          		0xbc
 
 #define	SEECTL          		0xbe
-#define		SEEOP_EWDS      	0x40
 #define		SEEOP_WALL      	0x40
 #define		SEEOP_EWEN      	0x40
+#define		SEEOP_EWDS      	0x40
 #define		SEEOPCODE       	0x70
 #define		SEERST          	0x02
 #define		SEESTART        	0x01
@@ -2573,25 +2272,25 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	SCBCNT          		0xbf
 
+#define	DFWADDR         		0xc0
+
 #define	DSPFLTRCTL      		0xc0
 #define		FLTRDISABLE     	0x20
 #define		EDGESENSE       	0x10
 #define		DSPFCNTSEL      	0x0f
 
-#define	DFWADDR         		0xc0
-
 #define	DSPDATACTL      		0xc1
 #define		BYPASSENAB      	0x80
 #define		DESQDIS         	0x10
 #define		RCVROFFSTDIS    	0x04
 #define		XMITOFFSTDIS    	0x02
 
+#define	DFRADDR         		0xc2
+
 #define	DSPREQCTL       		0xc2
 #define		MANREQCTL       	0xc0
 #define		MANREQDLY       	0x3f
 
-#define	DFRADDR         		0xc2
-
 #define	DSPACKCTL       		0xc3
 #define		MANACKCTL       	0xc0
 #define		MANACKDLY       	0x3f
@@ -2612,14 +2311,14 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	WRTBIASCALC     		0xc7
 
-#define	DFPTRS          		0xc8
-
 #define	RCVRBIASCALC    		0xc8
 
-#define	DFBKPTR         		0xc9
+#define	DFPTRS          		0xc8
 
 #define	SKEWCALC        		0xc9
 
+#define	DFBKPTR         		0xc9
+
 #define	DFDBCTL         		0xcb
 #define		DFF_CIO_WR_RDY  	0x20
 #define		DFF_CIO_RD_RDY  	0x10
@@ -2704,12 +2403,12 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	ACCUM_SAVE      		0xfa
 
+#define	WAITING_SCB_TAILS		0x100
+
 #define	AHD_PCI_CONFIG_BASE		0x100
 
 #define	SRAM_BASE       		0x100
 
-#define	WAITING_SCB_TAILS		0x100
-
 #define	WAITING_TID_HEAD		0x120
 
 #define	WAITING_TID_TAIL		0x122
@@ -2738,8 +2437,8 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define		PRELOADEN       	0x80
 #define		WIDEODD         	0x40
 #define		SCSIEN          	0x20
-#define		SDMAENACK       	0x10
 #define		SDMAEN          	0x10
+#define		SDMAENACK       	0x10
 #define		HDMAEN          	0x08
 #define		HDMAENACK       	0x08
 #define		DIRECTION       	0x04
@@ -2837,12 +2536,12 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 
 #define	MK_MESSAGE_SCSIID		0x162
 
+#define	SCB_BASE        		0x180
+
 #define	SCB_RESIDUAL_DATACNT		0x180
 #define	SCB_CDB_STORE   		0x180
 #define	SCB_HOST_CDB_PTR		0x180
 
-#define	SCB_BASE        		0x180
-
 #define	SCB_RESIDUAL_SGPTR		0x184
 #define		SG_ADDR_MASK    	0xf8
 #define		SG_OVERRUN_RESID	0x02
@@ -2910,17 +2609,6 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define	SCB_DISCONNECTED_LISTS		0x1b8
 
 
-#define	CMD_GROUP_CODE_SHIFT	0x05
-#define	STIMESEL_MIN	0x18
-#define	STIMESEL_SHIFT	0x03
-#define	INVALID_ADDR	0x80
-#define	AHD_PRECOMP_MASK	0x07
-#define	TARGET_DATA_IN	0x01
-#define	CCSCBADDR_MAX	0x80
-#define	NUMDSPS 	0x14
-#define	SEEOP_EWEN_ADDR	0xc0
-#define	AHD_ANNEXCOL_PER_DEV0	0x04
-#define	DST_MODE_SHIFT	0x04
 #define	AHD_TIMER_MAX_US	0x18ffe7
 #define	AHD_TIMER_MAX_TICKS	0xffff
 #define	AHD_SENSE_BUFSIZE	0x100
@@ -2955,32 +2643,43 @@ ahd_reg_print_t ahd_scb_disconnected_lis
 #define	LUNLEN_SINGLE_LEVEL_LUN	0x0f
 #define	NVRAM_SCB_OFFSET	0x2c
 #define	STATUS_PKT_SENSE	0xff
+#define	CMD_GROUP_CODE_SHIFT	0x05
 #define	MAX_OFFSET_PACED_BUG	0x7f
 #define	STIMESEL_BUG_ADJ	0x08
+#define	STIMESEL_MIN	0x18
+#define	STIMESEL_SHIFT	0x03
 #define	CCSGRAM_MAXSEGS	0x10
+#define	INVALID_ADDR	0x80
 #define	SEEOP_ERAL_ADDR	0x80
 #define	AHD_SLEWRATE_DEF_REVB	0x08
 #define	AHD_PRECOMP_CUTBACK_17	0x04
+#define	AHD_PRECOMP_MASK	0x07
 #define	SRC_MODE_SHIFT	0x00
 #define	PKT_OVERRUN_BUFSIZE	0x200
 #define	SCB_TRANSFER_SIZE_1BYTE_LUN	0x30
+#define	TARGET_DATA_IN	0x01
 #define	HOST_MSG	0xff
 #define	MAX_OFFSET	0xfe
 #define	BUS_16_BIT	0x01
+#define	CCSCBADDR_MAX	0x80
+#define	NUMDSPS 	0x14
+#define	SEEOP_EWEN_ADDR	0xc0
+#define	AHD_ANNEXCOL_PER_DEV0	0x04
+#define	DST_MODE_SHIFT	0x04
 
 
 /* Downloaded Constant Definitions */
-#define	SG_SIZEOF	0x04
-#define	SG_PREFETCH_ALIGN_MASK	0x02
-#define	SG_PREFETCH_CNT_LIMIT	0x01
 #define	CACHELINE_MASK	0x07
 #define	SCB_TRANSFER_SIZE	0x06
 #define	PKT_OVERRUN_BUFOFFSET	0x05
+#define	SG_SIZEOF	0x04
 #define	SG_PREFETCH_ADDR_MASK	0x03
+#define	SG_PREFETCH_ALIGN_MASK	0x02
+#define	SG_PREFETCH_CNT_LIMIT	0x01
 #define	SG_PREFETCH_CNT	0x00
 #define	DOWNLOAD_CONST_COUNT	0x08
 
 
 /* Exported Labels */
-#define	LABEL_timer_isr	0x28b
 #define	LABEL_seq_isr 	0x28f
+#define	LABEL_timer_isr	0x28b
diff -puN drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped~aic7xxx-update-_shipped-files drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
--- a/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped~aic7xxx-update-_shipped-files
+++ a/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
@@ -8,18 +8,6 @@
 
 #include "aic79xx_osm.h"
 
-static const ahd_reg_parse_entry_t MODE_PTR_parse_table[] = {
-	{ "SRC_MODE",		0x07, 0x07 },
-	{ "DST_MODE",		0x70, 0x70 }
-};
-
-int
-ahd_mode_ptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(MODE_PTR_parse_table, 2, "MODE_PTR",
-	    0x00, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t INTSTAT_parse_table[] = {
 	{ "SPLTINT",		0x01, 0x01 },
 	{ "CMDCMPLT",		0x02, 0x02 },
@@ -39,110 +27,6 @@ ahd_intstat_print(u_int regvalue, u_int 
 	    0x01, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t SEQINTCODE_parse_table[] = {
-	{ "NO_SEQINT",		0x00, 0xff },
-	{ "BAD_PHASE",		0x01, 0xff },
-	{ "SEND_REJECT",	0x02, 0xff },
-	{ "PROTO_VIOLATION",	0x03, 0xff },
-	{ "NO_MATCH",		0x04, 0xff },
-	{ "IGN_WIDE_RES",	0x05, 0xff },
-	{ "PDATA_REINIT",	0x06, 0xff },
-	{ "HOST_MSG_LOOP",	0x07, 0xff },
-	{ "BAD_STATUS",		0x08, 0xff },
-	{ "DATA_OVERRUN",	0x09, 0xff },
-	{ "MKMSG_FAILED",	0x0a, 0xff },
-	{ "MISSED_BUSFREE",	0x0b, 0xff },
-	{ "DUMP_CARD_STATE",	0x0c, 0xff },
-	{ "ILLEGAL_PHASE",	0x0d, 0xff },
-	{ "INVALID_SEQINT",	0x0e, 0xff },
-	{ "CFG4ISTAT_INTR",	0x0f, 0xff },
-	{ "STATUS_OVERRUN",	0x10, 0xff },
-	{ "CFG4OVERRUN",	0x11, 0xff },
-	{ "ENTERING_NONPACK",	0x12, 0xff },
-	{ "TASKMGMT_FUNC_COMPLETE",0x13, 0xff },
-	{ "TASKMGMT_CMD_CMPLT_OKAY",0x14, 0xff },
-	{ "TRACEPOINT0",	0x15, 0xff },
-	{ "TRACEPOINT1",	0x16, 0xff },
-	{ "TRACEPOINT2",	0x17, 0xff },
-	{ "TRACEPOINT3",	0x18, 0xff },
-	{ "SAW_HWERR",		0x19, 0xff },
-	{ "BAD_SCB_STATUS",	0x1a, 0xff }
-};
-
-int
-ahd_seqintcode_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQINTCODE_parse_table, 27, "SEQINTCODE",
-	    0x02, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t CLRINT_parse_table[] = {
-	{ "CLRSPLTINT",		0x01, 0x01 },
-	{ "CLRCMDINT",		0x02, 0x02 },
-	{ "CLRSEQINT",		0x04, 0x04 },
-	{ "CLRSCSIINT",		0x08, 0x08 },
-	{ "CLRPCIINT",		0x10, 0x10 },
-	{ "CLRSWTMINT",		0x20, 0x20 },
-	{ "CLRBRKADRINT",	0x40, 0x40 },
-	{ "CLRHWERRINT",	0x80, 0x80 }
-};
-
-int
-ahd_clrint_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRINT_parse_table, 8, "CLRINT",
-	    0x03, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t ERROR_parse_table[] = {
-	{ "DSCTMOUT",		0x02, 0x02 },
-	{ "ILLOPCODE",		0x04, 0x04 },
-	{ "SQPARERR",		0x08, 0x08 },
-	{ "DPARERR",		0x10, 0x10 },
-	{ "MPARERR",		0x20, 0x20 },
-	{ "CIOACCESFAIL",	0x40, 0x40 },
-	{ "CIOPARERR",		0x80, 0x80 }
-};
-
-int
-ahd_error_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(ERROR_parse_table, 7, "ERROR",
-	    0x04, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t HCNTRL_parse_table[] = {
-	{ "CHIPRST",		0x01, 0x01 },
-	{ "CHIPRSTACK",		0x01, 0x01 },
-	{ "INTEN",		0x02, 0x02 },
-	{ "PAUSE",		0x04, 0x04 },
-	{ "SWTIMER_START_B",	0x08, 0x08 },
-	{ "SWINT",		0x10, 0x10 },
-	{ "POWRDN",		0x40, 0x40 },
-	{ "SEQ_RESET",		0x80, 0x80 }
-};
-
-int
-ahd_hcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(HCNTRL_parse_table, 8, "HCNTRL",
-	    0x05, regvalue, cur_col, wrap));
-}
-
-int
-ahd_hnscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "HNSCB_QOFF",
-	    0x06, regvalue, cur_col, wrap));
-}
-
-int
-ahd_hescb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "HESCB_QOFF",
-	    0x08, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
 	{ "ENINT_COALESCE",	0x40, 0x40 },
 	{ "HOST_TQINPOS",	0x80, 0x80 }
@@ -170,77 +54,6 @@ ahd_seqintstat_print(u_int regvalue, u_i
 	    0x0c, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t CLRSEQINTSTAT_parse_table[] = {
-	{ "CLRSEQ_SPLTINT",	0x01, 0x01 },
-	{ "CLRSEQ_PCIINT",	0x02, 0x02 },
-	{ "CLRSEQ_SCSIINT",	0x04, 0x04 },
-	{ "CLRSEQ_SEQINT",	0x08, 0x08 },
-	{ "CLRSEQ_SWTMRTO",	0x10, 0x10 }
-};
-
-int
-ahd_clrseqintstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSEQINTSTAT_parse_table, 5, "CLRSEQINTSTAT",
-	    0x0c, regvalue, cur_col, wrap));
-}
-
-int
-ahd_swtimer_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SWTIMER",
-	    0x0e, regvalue, cur_col, wrap));
-}
-
-int
-ahd_snscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SNSCB_QOFF",
-	    0x10, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sescb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SESCB_QOFF",
-	    0x12, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sdscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SDSCB_QOFF",
-	    0x14, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
-	{ "SCB_QSIZE_4",	0x00, 0x0f },
-	{ "SCB_QSIZE_8",	0x01, 0x0f },
-	{ "SCB_QSIZE_16",	0x02, 0x0f },
-	{ "SCB_QSIZE_32",	0x03, 0x0f },
-	{ "SCB_QSIZE_64",	0x04, 0x0f },
-	{ "SCB_QSIZE_128",	0x05, 0x0f },
-	{ "SCB_QSIZE_256",	0x06, 0x0f },
-	{ "SCB_QSIZE_512",	0x07, 0x0f },
-	{ "SCB_QSIZE_1024",	0x08, 0x0f },
-	{ "SCB_QSIZE_2048",	0x09, 0x0f },
-	{ "SCB_QSIZE_4096",	0x0a, 0x0f },
-	{ "SCB_QSIZE_8192",	0x0b, 0x0f },
-	{ "SCB_QSIZE_16384",	0x0c, 0x0f },
-	{ "SCB_QSIZE",		0x0f, 0x0f },
-	{ "HS_MAILBOX_ACT",	0x10, 0x10 },
-	{ "SDSCB_ROLLOVR",	0x20, 0x20 },
-	{ "NEW_SCB_AVAIL",	0x40, 0x40 },
-	{ "EMPTY_SCB_AVAIL",	0x80, 0x80 }
-};
-
-int
-ahd_qoff_ctlsta_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(QOFF_CTLSTA_parse_table, 18, "QOFF_CTLSTA",
-	    0x16, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t INTCTL_parse_table[] = {
 	{ "SPLTINTEN",		0x01, 0x01 },
 	{ "SEQINTEN",		0x02, 0x02 },
@@ -280,22 +93,6 @@ ahd_dfcntrl_print(u_int regvalue, u_int 
 	    0x19, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
-	{ "CIOPARCKEN",		0x01, 0x01 },
-	{ "DISABLE_TWATE",	0x02, 0x02 },
-	{ "EXTREQLCK",		0x10, 0x10 },
-	{ "MPARCKEN",		0x20, 0x20 },
-	{ "DPARCKEN",		0x40, 0x40 },
-	{ "CACHETHEN",		0x80, 0x80 }
-};
-
-int
-ahd_dscommand0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DSCOMMAND0_parse_table, 6, "DSCOMMAND0",
-	    0x19, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t DFSTATUS_parse_table[] = {
 	{ "FIFOEMP",		0x01, 0x01 },
 	{ "FIFOFULL",		0x02, 0x02 },
@@ -327,146 +124,6 @@ ahd_sg_cache_shadow_print(u_int regvalue
 	    0x1b, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
-	{ "LAST_SEG",		0x02, 0x02 },
-	{ "ODD_SEG",		0x04, 0x04 },
-	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
-};
-
-int
-ahd_sg_cache_pre_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SG_CACHE_PRE_parse_table, 3, "SG_CACHE_PRE",
-	    0x1b, regvalue, cur_col, wrap));
-}
-
-int
-ahd_lqin_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LQIN",
-	    0x20, regvalue, cur_col, wrap));
-}
-
-int
-ahd_lunptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LUNPTR",
-	    0x22, regvalue, cur_col, wrap));
-}
-
-int
-ahd_cmdlenptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CMDLENPTR",
-	    0x25, regvalue, cur_col, wrap));
-}
-
-int
-ahd_attrptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ATTRPTR",
-	    0x26, regvalue, cur_col, wrap));
-}
-
-int
-ahd_flagptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "FLAGPTR",
-	    0x27, regvalue, cur_col, wrap));
-}
-
-int
-ahd_cmdptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CMDPTR",
-	    0x28, regvalue, cur_col, wrap));
-}
-
-int
-ahd_qnextptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "QNEXTPTR",
-	    0x29, regvalue, cur_col, wrap));
-}
-
-int
-ahd_abrtbyteptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ABRTBYTEPTR",
-	    0x2b, regvalue, cur_col, wrap));
-}
-
-int
-ahd_abrtbitptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ABRTBITPTR",
-	    0x2c, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t LUNLEN_parse_table[] = {
-	{ "ILUNLEN",		0x0f, 0x0f },
-	{ "TLUNLEN",		0xf0, 0xf0 }
-};
-
-int
-ahd_lunlen_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LUNLEN_parse_table, 2, "LUNLEN",
-	    0x30, regvalue, cur_col, wrap));
-}
-
-int
-ahd_cdblimit_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CDBLIMIT",
-	    0x31, regvalue, cur_col, wrap));
-}
-
-int
-ahd_maxcmd_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MAXCMD",
-	    0x32, regvalue, cur_col, wrap));
-}
-
-int
-ahd_maxcmdcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MAXCMDCNT",
-	    0x33, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t LQCTL1_parse_table[] = {
-	{ "ABORTPENDING",	0x01, 0x01 },
-	{ "SINGLECMD",		0x02, 0x02 },
-	{ "PCI2PCI",		0x04, 0x04 }
-};
-
-int
-ahd_lqctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQCTL1_parse_table, 3, "LQCTL1",
-	    0x38, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t LQCTL2_parse_table[] = {
-	{ "LQOPAUSE",		0x01, 0x01 },
-	{ "LQOTOIDLE",		0x02, 0x02 },
-	{ "LQOCONTINUE",	0x04, 0x04 },
-	{ "LQORETRY",		0x08, 0x08 },
-	{ "LQIPAUSE",		0x10, 0x10 },
-	{ "LQITOIDLE",		0x20, 0x20 },
-	{ "LQICONTINUE",	0x40, 0x40 },
-	{ "LQIRETRY",		0x80, 0x80 }
-};
-
-int
-ahd_lqctl2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQCTL2_parse_table, 8, "LQCTL2",
-	    0x39, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t SCSISEQ0_parse_table[] = {
 	{ "SCSIRSTO",		0x01, 0x01 },
 	{ "FORCEBUSFREE",	0x10, 0x10 },
@@ -498,37 +155,6 @@ ahd_scsiseq1_print(u_int regvalue, u_int
 	    0x3b, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t SXFRCTL0_parse_table[] = {
-	{ "SPIOEN",		0x08, 0x08 },
-	{ "BIOSCANCELEN",	0x10, 0x10 },
-	{ "DFPEXP",		0x40, 0x40 },
-	{ "DFON",		0x80, 0x80 }
-};
-
-int
-ahd_sxfrctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SXFRCTL0_parse_table, 4, "SXFRCTL0",
-	    0x3c, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SXFRCTL1_parse_table[] = {
-	{ "STPWEN",		0x01, 0x01 },
-	{ "ACTNEGEN",		0x02, 0x02 },
-	{ "ENSTIMER",		0x04, 0x04 },
-	{ "STIMESEL",		0x18, 0x18 },
-	{ "ENSPCHK",		0x20, 0x20 },
-	{ "ENSACHK",		0x40, 0x40 },
-	{ "BITBUCKET",		0x80, 0x80 }
-};
-
-int
-ahd_sxfrctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SXFRCTL1_parse_table, 7, "SXFRCTL1",
-	    0x3d, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t DFFSTAT_parse_table[] = {
 	{ "CURRFIFO_0",		0x00, 0x03 },
 	{ "CURRFIFO_1",		0x01, 0x03 },
@@ -545,40 +171,6 @@ ahd_dffstat_print(u_int regvalue, u_int 
 	    0x3f, regvalue, cur_col, wrap));
 }
 
-int
-ahd_multargid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MULTARGID",
-	    0x40, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCSISIGO_parse_table[] = {
-	{ "P_DATAOUT",		0x00, 0xe0 },
-	{ "P_DATAOUT_DT",	0x20, 0xe0 },
-	{ "P_DATAIN",		0x40, 0xe0 },
-	{ "P_DATAIN_DT",	0x60, 0xe0 },
-	{ "P_COMMAND",		0x80, 0xe0 },
-	{ "P_MESGOUT",		0xa0, 0xe0 },
-	{ "P_STATUS",		0xc0, 0xe0 },
-	{ "P_MESGIN",		0xe0, 0xe0 },
-	{ "ACKO",		0x01, 0x01 },
-	{ "REQO",		0x02, 0x02 },
-	{ "BSYO",		0x04, 0x04 },
-	{ "SELO",		0x08, 0x08 },
-	{ "ATNO",		0x10, 0x10 },
-	{ "MSGO",		0x20, 0x20 },
-	{ "IOO",		0x40, 0x40 },
-	{ "CDO",		0x80, 0x80 },
-	{ "PHASE_MASK",		0xe0, 0xe0 }
-};
-
-int
-ahd_scsisigo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSISIGO_parse_table, 17, "SCSISIGO",
-	    0x40, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "P_DATAOUT",		0x00, 0xe0 },
 	{ "P_DATAOUT_DT",	0x20, 0xe0 },
@@ -624,31 +216,12 @@ ahd_scsiphase_print(u_int regvalue, u_in
 }
 
 int
-ahd_scsidat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCSIDAT",
-	    0x44, regvalue, cur_col, wrap));
-}
-
-int
 ahd_scsibus_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SCSIBUS",
 	    0x46, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t TARGIDIN_parse_table[] = {
-	{ "TARGID",		0x0f, 0x0f },
-	{ "CLKOUT",		0x80, 0x80 }
-};
-
-int
-ahd_targidin_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(TARGIDIN_parse_table, 2, "TARGIDIN",
-	    0x48, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t SELID_parse_table[] = {
 	{ "ONEBIT",		0x08, 0x08 },
 	{ "SELID_MASK",		0xf0, 0xf0 }
@@ -661,38 +234,6 @@ ahd_selid_print(u_int regvalue, u_int *c
 	    0x49, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t OPTIONMODE_parse_table[] = {
-	{ "AUTO_MSGOUT_DE",	0x02, 0x02 },
-	{ "ENDGFORMCHK",	0x04, 0x04 },
-	{ "BUSFREEREV",		0x10, 0x10 },
-	{ "BIASCANCTL",		0x20, 0x20 },
-	{ "AUTOACKEN",		0x40, 0x40 },
-	{ "BIOSCANCTL",		0x80, 0x80 },
-	{ "OPTIONMODE_DEFAULTS",0x02, 0x02 }
-};
-
-int
-ahd_optionmode_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(OPTIONMODE_parse_table, 7, "OPTIONMODE",
-	    0x4a, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SBLKCTL_parse_table[] = {
-	{ "SELWIDE",		0x02, 0x02 },
-	{ "ENAB20",		0x04, 0x04 },
-	{ "ENAB40",		0x08, 0x08 },
-	{ "DIAGLEDON",		0x40, 0x40 },
-	{ "DIAGLEDEN",		0x80, 0x80 }
-};
-
-int
-ahd_sblkctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SBLKCTL_parse_table, 5, "SBLKCTL",
-	    0x4a, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t SSTAT0_parse_table[] = {
 	{ "ARBDO",		0x01, 0x01 },
 	{ "SPIORDY",		0x02, 0x02 },
@@ -728,23 +269,6 @@ ahd_simode0_print(u_int regvalue, u_int 
 	    0x4b, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t CLRSINT0_parse_table[] = {
-	{ "CLRARBDO",		0x01, 0x01 },
-	{ "CLRSPIORDY",		0x02, 0x02 },
-	{ "CLROVERRUN",		0x04, 0x04 },
-	{ "CLRIOERR",		0x08, 0x08 },
-	{ "CLRSELINGO",		0x10, 0x10 },
-	{ "CLRSELDI",		0x20, 0x20 },
-	{ "CLRSELDO",		0x40, 0x40 }
-};
-
-int
-ahd_clrsint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSINT0_parse_table, 7, "CLRSINT0",
-	    0x4b, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "REQINIT",		0x01, 0x01 },
 	{ "STRB2FAST",		0x02, 0x02 },
@@ -763,23 +287,6 @@ ahd_sstat1_print(u_int regvalue, u_int *
 	    0x4c, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t CLRSINT1_parse_table[] = {
-	{ "CLRREQINIT",		0x01, 0x01 },
-	{ "CLRSTRB2FAST",	0x02, 0x02 },
-	{ "CLRSCSIPERR",	0x04, 0x04 },
-	{ "CLRBUSFREE",		0x08, 0x08 },
-	{ "CLRSCSIRSTI",	0x20, 0x20 },
-	{ "CLRATNO",		0x40, 0x40 },
-	{ "CLRSELTIMEO",	0x80, 0x80 }
-};
-
-int
-ahd_clrsint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSINT1_parse_table, 7, "CLRSINT1",
-	    0x4c, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t SSTAT2_parse_table[] = {
 	{ "BUSFREE_LQO",	0x40, 0xc0 },
 	{ "BUSFREE_DFF0",	0x80, 0xc0 },
@@ -800,20 +307,6 @@ ahd_sstat2_print(u_int regvalue, u_int *
 	    0x4d, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t CLRSINT2_parse_table[] = {
-	{ "CLRDMADONE",		0x01, 0x01 },
-	{ "CLRSDONE",		0x02, 0x02 },
-	{ "CLRWIDE_RES",	0x04, 0x04 },
-	{ "CLRNONPACKREQ",	0x20, 0x20 }
-};
-
-int
-ahd_clrsint2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSINT2_parse_table, 4, "CLRSINT2",
-	    0x4d, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t PERRDIAG_parse_table[] = {
 	{ "DTERR",		0x01, 0x01 },
 	{ "DGFORMERR",		0x02, 0x02 },
@@ -833,26 +326,12 @@ ahd_perrdiag_print(u_int regvalue, u_int
 }
 
 int
-ahd_lqistate_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LQISTATE",
-	    0x4e, regvalue, cur_col, wrap));
-}
-
-int
 ahd_soffcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SOFFCNT",
 	    0x4f, regvalue, cur_col, wrap));
 }
 
-int
-ahd_lqostate_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LQOSTATE",
-	    0x4f, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t LQISTAT0_parse_table[] = {
 	{ "LQIATNCMD",		0x01, 0x01 },
 	{ "LQIATNLQ",		0x02, 0x02 },
@@ -869,56 +348,6 @@ ahd_lqistat0_print(u_int regvalue, u_int
 	    0x50, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t LQIMODE0_parse_table[] = {
-	{ "ENLQIATNCMD",	0x01, 0x01 },
-	{ "ENLQIATNLQ",		0x02, 0x02 },
-	{ "ENLQIBADLQT",	0x04, 0x04 },
-	{ "ENLQICRCT2",		0x08, 0x08 },
-	{ "ENLQICRCT1",		0x10, 0x10 },
-	{ "ENLQIATNQASK",	0x20, 0x20 }
-};
-
-int
-ahd_lqimode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQIMODE0_parse_table, 6, "LQIMODE0",
-	    0x50, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t CLRLQIINT0_parse_table[] = {
-	{ "CLRLQIATNCMD",	0x01, 0x01 },
-	{ "CLRLQIATNLQ",	0x02, 0x02 },
-	{ "CLRLQIBADLQT",	0x04, 0x04 },
-	{ "CLRLQICRCT2",	0x08, 0x08 },
-	{ "CLRLQICRCT1",	0x10, 0x10 },
-	{ "CLRLQIATNQAS",	0x20, 0x20 }
-};
-
-int
-ahd_clrlqiint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRLQIINT0_parse_table, 6, "CLRLQIINT0",
-	    0x50, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t LQIMODE1_parse_table[] = {
-	{ "ENLQIOVERI_NLQ",	0x01, 0x01 },
-	{ "ENLQIOVERI_LQ",	0x02, 0x02 },
-	{ "ENLQIBADLQI",	0x04, 0x04 },
-	{ "ENLQICRCI_NLQ",	0x08, 0x08 },
-	{ "ENLQICRCI_LQ",	0x10, 0x10 },
-	{ "ENLIQABORT",		0x20, 0x20 },
-	{ "ENLQIPHASE_NLQ",	0x40, 0x40 },
-	{ "ENLQIPHASE_LQ",	0x80, 0x80 }
-};
-
-int
-ahd_lqimode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQIMODE1_parse_table, 8, "LQIMODE1",
-	    0x51, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t LQISTAT1_parse_table[] = {
 	{ "LQIOVERI_NLQ",	0x01, 0x01 },
 	{ "LQIOVERI_LQ",	0x02, 0x02 },
@@ -937,24 +366,6 @@ ahd_lqistat1_print(u_int regvalue, u_int
 	    0x51, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t CLRLQIINT1_parse_table[] = {
-	{ "CLRLQIOVERI_NLQ",	0x01, 0x01 },
-	{ "CLRLQIOVERI_LQ",	0x02, 0x02 },
-	{ "CLRLQIBADLQI",	0x04, 0x04 },
-	{ "CLRLQICRCI_NLQ",	0x08, 0x08 },
-	{ "CLRLQICRCI_LQ",	0x10, 0x10 },
-	{ "CLRLIQABORT",	0x20, 0x20 },
-	{ "CLRLQIPHASE_NLQ",	0x40, 0x40 },
-	{ "CLRLQIPHASE_LQ",	0x80, 0x80 }
-};
-
-int
-ahd_clrlqiint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRLQIINT1_parse_table, 8, "CLRLQIINT1",
-	    0x51, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t LQISTAT2_parse_table[] = {
 	{ "LQIGSAVAIL",		0x01, 0x01 },
 	{ "LQISTOPCMD",		0x02, 0x02 },
@@ -985,30 +396,6 @@ ahd_sstat3_print(u_int regvalue, u_int *
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t SIMODE3_parse_table[] = {
-	{ "ENOSRAMPERR",	0x01, 0x01 },
-	{ "ENNTRAMPERR",	0x02, 0x02 }
-};
-
-int
-ahd_simode3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SIMODE3_parse_table, 2, "SIMODE3",
-	    0x53, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t CLRSINT3_parse_table[] = {
-	{ "CLROSRAMPERR",	0x01, 0x01 },
-	{ "CLRNTRAMPERR",	0x02, 0x02 }
-};
-
-int
-ahd_clrsint3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSINT3_parse_table, 2, "CLRSINT3",
-	    0x53, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t LQOSTAT0_parse_table[] = {
 	{ "LQOTCRC",		0x01, 0x01 },
 	{ "LQOATNPKT",		0x02, 0x02 },
@@ -1024,51 +411,6 @@ ahd_lqostat0_print(u_int regvalue, u_int
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t CLRLQOINT0_parse_table[] = {
-	{ "CLRLQOTCRC",		0x01, 0x01 },
-	{ "CLRLQOATNPKT",	0x02, 0x02 },
-	{ "CLRLQOATNLQ",	0x04, 0x04 },
-	{ "CLRLQOSTOPT2",	0x08, 0x08 },
-	{ "CLRLQOTARGSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_clrlqoint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRLQOINT0_parse_table, 5, "CLRLQOINT0",
-	    0x54, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t LQOMODE0_parse_table[] = {
-	{ "ENLQOTCRC",		0x01, 0x01 },
-	{ "ENLQOATNPKT",	0x02, 0x02 },
-	{ "ENLQOATNLQ",		0x04, 0x04 },
-	{ "ENLQOSTOPT2",	0x08, 0x08 },
-	{ "ENLQOTARGSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_lqomode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQOMODE0_parse_table, 5, "LQOMODE0",
-	    0x54, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t LQOMODE1_parse_table[] = {
-	{ "ENLQOPHACHGINPKT",	0x01, 0x01 },
-	{ "ENLQOBUSFREE",	0x02, 0x02 },
-	{ "ENLQOBADQAS",	0x04, 0x04 },
-	{ "ENLQOSTOPI2",	0x08, 0x08 },
-	{ "ENLQOINITSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_lqomode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQOMODE1_parse_table, 5, "LQOMODE1",
-	    0x55, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t LQOSTAT1_parse_table[] = {
 	{ "LQOPHACHGINPKT",	0x01, 0x01 },
 	{ "LQOBUSFREE",		0x02, 0x02 },
@@ -1084,21 +426,6 @@ ahd_lqostat1_print(u_int regvalue, u_int
 	    0x55, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t CLRLQOINT1_parse_table[] = {
-	{ "CLRLQOPHACHGINPKT",	0x01, 0x01 },
-	{ "CLRLQOBUSFREE",	0x02, 0x02 },
-	{ "CLRLQOBADQAS",	0x04, 0x04 },
-	{ "CLRLQOSTOPI2",	0x08, 0x08 },
-	{ "CLRLQOINITSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_clrlqoint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRLQOINT1_parse_table, 5, "CLRLQOINT1",
-	    0x55, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t LQOSTAT2_parse_table[] = {
 	{ "LQOSTOP0",		0x01, 0x01 },
 	{ "LQOPHACHGOUTPKT",	0x02, 0x02 },
@@ -1113,13 +440,6 @@ ahd_lqostat2_print(u_int regvalue, u_int
 	    0x56, regvalue, cur_col, wrap));
 }
 
-int
-ahd_os_space_cnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "OS_SPACE_CNT",
-	    0x56, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t SIMODE1_parse_table[] = {
 	{ "ENREQINIT",		0x01, 0x01 },
 	{ "ENSTRB2FAST",	0x02, 0x02 },
@@ -1138,13 +458,6 @@ ahd_simode1_print(u_int regvalue, u_int 
 	    0x57, regvalue, cur_col, wrap));
 }
 
-int
-ahd_gsfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "GSFIFO",
-	    0x58, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t DFFSXFRCTL_parse_table[] = {
 	{ "RSTCHN",		0x01, 0x01 },
 	{ "CLRCHN",		0x02, 0x02 },
@@ -1159,44 +472,6 @@ ahd_dffsxfrctl_print(u_int regvalue, u_i
 	    0x5a, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t LQOSCSCTL_parse_table[] = {
-	{ "LQONOCHKOVER",	0x01, 0x01 },
-	{ "LQONOHOLDLACK",	0x02, 0x02 },
-	{ "LQOBUSETDLY",	0x40, 0x40 },
-	{ "LQOH2A_VERSION",	0x80, 0x80 }
-};
-
-int
-ahd_lqoscsctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQOSCSCTL_parse_table, 4, "LQOSCSCTL",
-	    0x5a, regvalue, cur_col, wrap));
-}
-
-int
-ahd_nextscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NEXTSCB",
-	    0x5a, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t CLRSEQINTSRC_parse_table[] = {
-	{ "CLRCFG4TCMD",	0x01, 0x01 },
-	{ "CLRCFG4ICMD",	0x02, 0x02 },
-	{ "CLRCFG4TSTAT",	0x04, 0x04 },
-	{ "CLRCFG4ISTAT",	0x08, 0x08 },
-	{ "CLRCFG4DATA",	0x10, 0x10 },
-	{ "CLRSAVEPTRS",	0x20, 0x20 },
-	{ "CLRCTXTDONE",	0x40, 0x40 }
-};
-
-int
-ahd_clrseqintsrc_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSEQINTSRC_parse_table, 7, "CLRSEQINTSRC",
-	    0x5b, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t SEQINTSRC_parse_table[] = {
 	{ "CFG4TCMD",		0x01, 0x01 },
 	{ "CFG4ICMD",		0x02, 0x02 },
@@ -1231,13 +506,6 @@ ahd_seqimode_print(u_int regvalue, u_int
 	    0x5c, regvalue, cur_col, wrap));
 }
 
-int
-ahd_currscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CURRSCB",
-	    0x5c, regvalue, cur_col, wrap));
-}
-
 static const ahd_reg_parse_entry_t MDFFSTAT_parse_table[] = {
 	{ "FIFOFREE",		0x01, 0x01 },
 	{ "DATAINFIFO",		0x02, 0x02 },
@@ -1256,1213 +524,222 @@ ahd_mdffstat_print(u_int regvalue, u_int
 }
 
 int
-ahd_lastscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LASTSCB",
-	    0x5e, regvalue, cur_col, wrap));
-}
-
-int
-ahd_shaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SHADDR",
-	    0x60, regvalue, cur_col, wrap));
-}
-
-int
-ahd_negoaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NEGOADDR",
-	    0x60, regvalue, cur_col, wrap));
-}
-
-int
-ahd_negperiod_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NEGPERIOD",
-	    0x61, regvalue, cur_col, wrap));
-}
-
-int
-ahd_negoffset_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_seloid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "NEGOFFSET",
-	    0x62, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "SELOID",
+	    0x6b, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t NEGPPROPTS_parse_table[] = {
-	{ "PPROPT_IUT",		0x01, 0x01 },
-	{ "PPROPT_DT",		0x02, 0x02 },
-	{ "PPROPT_QAS",		0x04, 0x04 },
-	{ "PPROPT_PACE",	0x08, 0x08 }
+static const ahd_reg_parse_entry_t SG_STATE_parse_table[] = {
+	{ "SEGS_AVAIL",		0x01, 0x01 },
+	{ "LOADING_NEEDED",	0x02, 0x02 },
+	{ "FETCH_INPROG",	0x04, 0x04 }
 };
 
 int
-ahd_negppropts_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_sg_state_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NEGPPROPTS_parse_table, 4, "NEGPPROPTS",
-	    0x63, regvalue, cur_col, wrap));
+	return (ahd_print_register(SG_STATE_parse_table, 3, "SG_STATE",
+	    0xa6, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t NEGCONOPTS_parse_table[] = {
-	{ "WIDEXFER",		0x01, 0x01 },
-	{ "ENAUTOATNO",		0x02, 0x02 },
-	{ "ENAUTOATNI",		0x04, 0x04 },
-	{ "ENSLOWCRC",		0x08, 0x08 },
-	{ "RTI_OVRDTRN",	0x10, 0x10 },
-	{ "RTI_WRTDIS",		0x20, 0x20 },
-	{ "ENSNAPSHOT",		0x40, 0x40 }
+static const ahd_reg_parse_entry_t CCSCBCTL_parse_table[] = {
+	{ "CCSCBRESET",		0x01, 0x01 },
+	{ "CCSCBDIR",		0x04, 0x04 },
+	{ "CCSCBEN",		0x08, 0x08 },
+	{ "CCARREN",		0x10, 0x10 },
+	{ "ARRDONE",		0x40, 0x40 },
+	{ "CCSCBDONE",		0x80, 0x80 }
 };
 
 int
-ahd_negconopts_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NEGCONOPTS_parse_table, 7, "NEGCONOPTS",
-	    0x64, regvalue, cur_col, wrap));
-}
-
-int
-ahd_annexcol_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ANNEXCOL",
-	    0x65, regvalue, cur_col, wrap));
-}
-
-int
-ahd_annexdat_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_ccscbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "ANNEXDAT",
-	    0x66, regvalue, cur_col, wrap));
+	return (ahd_print_register(CCSCBCTL_parse_table, 6, "CCSCBCTL",
+	    0xad, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t SCSCHKN_parse_table[] = {
-	{ "LSTSGCLRDIS",	0x01, 0x01 },
-	{ "SHVALIDSTDIS",	0x02, 0x02 },
-	{ "DFFACTCLR",		0x04, 0x04 },
-	{ "SDONEMSKDIS",	0x08, 0x08 },
-	{ "WIDERESEN",		0x10, 0x10 },
-	{ "CURRFIFODEF",	0x20, 0x20 },
-	{ "STSELSKIDDIS",	0x40, 0x40 },
-	{ "BIDICHKDIS",		0x80, 0x80 }
+static const ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
+	{ "CCSGRESET",		0x01, 0x01 },
+	{ "SG_FETCH_REQ",	0x02, 0x02 },
+	{ "CCSGENACK",		0x08, 0x08 },
+	{ "SG_CACHE_AVAIL",	0x10, 0x10 },
+	{ "CCSGDONE",		0x80, 0x80 },
+	{ "CCSGEN",		0x0c, 0x0c }
 };
 
 int
-ahd_scschkn_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_ccsgctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(SCSCHKN_parse_table, 8, "SCSCHKN",
-	    0x66, regvalue, cur_col, wrap));
+	return (ahd_print_register(CCSGCTL_parse_table, 6, "CCSGCTL",
+	    0xad, regvalue, cur_col, wrap));
 }
 
-int
-ahd_iownid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "IOWNID",
-	    0x67, regvalue, cur_col, wrap));
-}
+static const ahd_reg_parse_entry_t SEQCTL0_parse_table[] = {
+	{ "LOADRAM",		0x01, 0x01 },
+	{ "SEQRESET",		0x02, 0x02 },
+	{ "STEP",		0x04, 0x04 },
+	{ "BRKADRINTEN",	0x08, 0x08 },
+	{ "FASTMODE",		0x10, 0x10 },
+	{ "FAILDIS",		0x20, 0x20 },
+	{ "PAUSEDIS",		0x40, 0x40 },
+	{ "PERRORDIS",		0x80, 0x80 }
+};
 
 int
-ahd_shcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_seqctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "SHCNT",
-	    0x68, regvalue, cur_col, wrap));
+	return (ahd_print_register(SEQCTL0_parse_table, 8, "SEQCTL0",
+	    0xd6, regvalue, cur_col, wrap));
 }
 
-int
-ahd_townid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "TOWNID",
-	    0x69, regvalue, cur_col, wrap));
-}
+static const ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
+	{ "IRET",		0x01, 0x01 },
+	{ "INTMASK1",		0x02, 0x02 },
+	{ "INTMASK2",		0x04, 0x04 },
+	{ "SCS_SEQ_INT1M0",	0x08, 0x08 },
+	{ "SCS_SEQ_INT1M1",	0x10, 0x10 },
+	{ "INT1_CONTEXT",	0x20, 0x20 },
+	{ "INTVEC1DSL",		0x80, 0x80 }
+};
 
 int
-ahd_seloid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_seqintctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "SELOID",
-	    0x6b, regvalue, cur_col, wrap));
+	return (ahd_print_register(SEQINTCTL_parse_table, 7, "SEQINTCTL",
+	    0xd9, regvalue, cur_col, wrap));
 }
 
 int
-ahd_haddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "HADDR",
-	    0x70, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "SRAM_BASE",
+	    0x100, regvalue, cur_col, wrap));
 }
 
 int
-ahd_hcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "HCNT",
-	    0x78, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "QFREEZE_COUNT",
+	    0x132, regvalue, cur_col, wrap));
 }
 
 int
-ahd_sghaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_kernel_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "SGHADDR",
-	    0x7c, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT",
+	    0x134, regvalue, cur_col, wrap));
 }
 
 int
-ahd_scbhaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_saved_mode_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "SCBHADDR",
-	    0x7c, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "SAVED_MODE",
+	    0x136, regvalue, cur_col, wrap));
 }
 
-int
-ahd_sghcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SGHCNT",
-	    0x84, regvalue, cur_col, wrap));
-}
+static const ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
+	{ "NO_DISCONNECT",	0x01, 0x01 },
+	{ "SPHASE_PENDING",	0x02, 0x02 },
+	{ "DPHASE_PENDING",	0x04, 0x04 },
+	{ "CMDPHASE_PENDING",	0x08, 0x08 },
+	{ "TARG_CMD_PENDING",	0x10, 0x10 },
+	{ "DPHASE",		0x20, 0x20 },
+	{ "NO_CDB_SENT",	0x40, 0x40 },
+	{ "TARGET_CMD_IS_TAGGED",0x40, 0x40 },
+	{ "NOT_IDENTIFIED",	0x80, 0x80 }
+};
 
 int
-ahd_scbhcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_seq_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "SCBHCNT",
-	    0x84, regvalue, cur_col, wrap));
+	return (ahd_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
+	    0x139, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t DFF_THRSH_parse_table[] = {
-	{ "WR_DFTHRSH_MIN",	0x00, 0x70 },
-	{ "RD_DFTHRSH_MIN",	0x00, 0x07 },
-	{ "RD_DFTHRSH_25",	0x01, 0x07 },
-	{ "RD_DFTHRSH_50",	0x02, 0x07 },
-	{ "RD_DFTHRSH_63",	0x03, 0x07 },
-	{ "RD_DFTHRSH_75",	0x04, 0x07 },
-	{ "RD_DFTHRSH_85",	0x05, 0x07 },
-	{ "RD_DFTHRSH_90",	0x06, 0x07 },
-	{ "RD_DFTHRSH_MAX",	0x07, 0x07 },
-	{ "WR_DFTHRSH_25",	0x10, 0x70 },
-	{ "WR_DFTHRSH_50",	0x20, 0x70 },
-	{ "WR_DFTHRSH_63",	0x30, 0x70 },
-	{ "WR_DFTHRSH_75",	0x40, 0x70 },
-	{ "WR_DFTHRSH_85",	0x50, 0x70 },
-	{ "WR_DFTHRSH_90",	0x60, 0x70 },
-	{ "WR_DFTHRSH_MAX",	0x70, 0x70 },
-	{ "RD_DFTHRSH",		0x07, 0x07 },
-	{ "WR_DFTHRSH",		0x70, 0x70 }
+static const ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
+	{ "P_DATAOUT",		0x00, 0xe0 },
+	{ "P_DATAOUT_DT",	0x20, 0xe0 },
+	{ "P_DATAIN",		0x40, 0xe0 },
+	{ "P_DATAIN_DT",	0x60, 0xe0 },
+	{ "P_COMMAND",		0x80, 0xe0 },
+	{ "P_MESGOUT",		0xa0, 0xe0 },
+	{ "P_STATUS",		0xc0, 0xe0 },
+	{ "P_MESGIN",		0xe0, 0xe0 },
+	{ "P_BUSFREE",		0x01, 0x01 },
+	{ "MSGI",		0x20, 0x20 },
+	{ "IOI",		0x40, 0x40 },
+	{ "CDI",		0x80, 0x80 },
+	{ "PHASE_MASK",		0xe0, 0xe0 }
 };
 
 int
-ahd_dff_thrsh_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_lastphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(DFF_THRSH_parse_table, 18, "DFF_THRSH",
-	    0x88, regvalue, cur_col, wrap));
+	return (ahd_print_register(LASTPHASE_parse_table, 13, "LASTPHASE",
+	    0x13c, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t PCIXCTL_parse_table[] = {
-	{ "CMPABCDIS",		0x01, 0x01 },
-	{ "TSCSERREN",		0x02, 0x02 },
-	{ "SRSPDPEEN",		0x04, 0x04 },
-	{ "SPLTSTADIS",		0x08, 0x08 },
-	{ "SPLTSMADIS",		0x10, 0x10 },
-	{ "UNEXPSCIEN",		0x20, 0x20 },
-	{ "SERRPULSE",		0x80, 0x80 }
+static const ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
+	{ "PENDING_MK_MESSAGE",	0x01, 0x01 },
+	{ "TARGET_MSG_PENDING",	0x02, 0x02 },
+	{ "SELECTOUT_QFROZEN",	0x04, 0x04 }
 };
 
 int
-ahd_pcixctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_seq_flags2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(PCIXCTL_parse_table, 7, "PCIXCTL",
-	    0x93, regvalue, cur_col, wrap));
+	return (ahd_print_register(SEQ_FLAGS2_parse_table, 3, "SEQ_FLAGS2",
+	    0x14d, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t DCHSPLTSTAT0_parse_table[] = {
-	{ "RXSPLTRSP",		0x01, 0x01 },
-	{ "RXSCEMSG",		0x02, 0x02 },
-	{ "RXOVRUN",		0x04, 0x04 },
-	{ "CNTNOTCMPLT",	0x08, 0x08 },
-	{ "SCDATBUCKET",	0x10, 0x10 },
-	{ "SCADERR",		0x20, 0x20 },
-	{ "SCBCERR",		0x40, 0x40 },
-	{ "STAETERM",		0x80, 0x80 }
-};
-
 int
-ahd_dchspltstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_mk_message_scb_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(DCHSPLTSTAT0_parse_table, 8, "DCHSPLTSTAT0",
-	    0x96, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCB",
+	    0x160, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t DCHSPLTSTAT1_parse_table[] = {
-	{ "RXDATABUCKET",	0x01, 0x01 }
-};
-
 int
-ahd_dchspltstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_mk_message_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(DCHSPLTSTAT1_parse_table, 1, "DCHSPLTSTAT1",
-	    0x97, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCSIID",
+	    0x162, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t SGSPLTSTAT0_parse_table[] = {
-	{ "RXSPLTRSP",		0x01, 0x01 },
-	{ "RXSCEMSG",		0x02, 0x02 },
-	{ "RXOVRUN",		0x04, 0x04 },
-	{ "CNTNOTCMPLT",	0x08, 0x08 },
-	{ "SCDATBUCKET",	0x10, 0x10 },
-	{ "SCADERR",		0x20, 0x20 },
-	{ "SCBCERR",		0x40, 0x40 },
-	{ "STAETERM",		0x80, 0x80 }
-};
-
 int
-ahd_sgspltstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(SGSPLTSTAT0_parse_table, 8, "SGSPLTSTAT0",
-	    0x9e, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "SCB_BASE",
+	    0x180, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t SGSPLTSTAT1_parse_table[] = {
-	{ "RXDATABUCKET",	0x01, 0x01 }
+static const ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+	{ "SCB_TAG_TYPE",	0x03, 0x03 },
+	{ "DISCONNECTED",	0x04, 0x04 },
+	{ "STATUS_RCVD",	0x08, 0x08 },
+	{ "MK_MESSAGE",		0x10, 0x10 },
+	{ "TAG_ENB",		0x20, 0x20 },
+	{ "DISCENB",		0x40, 0x40 },
+	{ "TARGET_SCB",		0x80, 0x80 }
 };
 
 int
-ahd_sgspltstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(SGSPLTSTAT1_parse_table, 1, "SGSPLTSTAT1",
-	    0x9f, regvalue, cur_col, wrap));
+	return (ahd_print_register(SCB_CONTROL_parse_table, 7, "SCB_CONTROL",
+	    0x192, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t DF0PCISTAT_parse_table[] = {
-	{ "DPR",		0x01, 0x01 },
-	{ "TWATERR",		0x02, 0x02 },
-	{ "RDPERR",		0x04, 0x04 },
-	{ "SCAAPERR",		0x08, 0x08 },
-	{ "RTA",		0x10, 0x10 },
-	{ "RMA",		0x20, 0x20 },
-	{ "SSE",		0x40, 0x40 },
-	{ "DPE",		0x80, 0x80 }
+static const ahd_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
+	{ "OID",		0x0f, 0x0f },
+	{ "TID",		0xf0, 0xf0 }
 };
 
 int
-ahd_df0pcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DF0PCISTAT_parse_table, 8, "DF0PCISTAT",
-	    0xa0, regvalue, cur_col, wrap));
-}
-
-int
-ahd_reg0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "REG0",
-	    0xa0, regvalue, cur_col, wrap));
-}
-
-int
-ahd_reg_isr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "REG_ISR",
-	    0xa4, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SG_STATE_parse_table[] = {
-	{ "SEGS_AVAIL",		0x01, 0x01 },
-	{ "LOADING_NEEDED",	0x02, 0x02 },
-	{ "FETCH_INPROG",	0x04, 0x04 }
-};
-
-int
-ahd_sg_state_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SG_STATE_parse_table, 3, "SG_STATE",
-	    0xa6, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t TARGPCISTAT_parse_table[] = {
-	{ "TWATERR",		0x02, 0x02 },
-	{ "STA",		0x08, 0x08 },
-	{ "SSE",		0x40, 0x40 },
-	{ "DPE",		0x80, 0x80 }
-};
-
-int
-ahd_targpcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(TARGPCISTAT_parse_table, 4, "TARGPCISTAT",
-	    0xa7, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCBPTR",
-	    0xa8, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCBAUTOPTR_parse_table[] = {
-	{ "SCBPTR_OFF",		0x07, 0x07 },
-	{ "SCBPTR_ADDR",	0x38, 0x38 },
-	{ "AUSCBPTR_EN",	0x80, 0x80 }
-};
-
-int
-ahd_scbautoptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCBAUTOPTR_parse_table, 3, "SCBAUTOPTR",
-	    0xab, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ccsgaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSGADDR",
-	    0xac, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ccscbaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSCBADDR",
-	    0xac, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t CCSCBCTL_parse_table[] = {
-	{ "CCSCBRESET",		0x01, 0x01 },
-	{ "CCSCBDIR",		0x04, 0x04 },
-	{ "CCSCBEN",		0x08, 0x08 },
-	{ "CCARREN",		0x10, 0x10 },
-	{ "ARRDONE",		0x40, 0x40 },
-	{ "CCSCBDONE",		0x80, 0x80 }
-};
-
-int
-ahd_ccscbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CCSCBCTL_parse_table, 6, "CCSCBCTL",
-	    0xad, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
-	{ "CCSGRESET",		0x01, 0x01 },
-	{ "SG_FETCH_REQ",	0x02, 0x02 },
-	{ "CCSGENACK",		0x08, 0x08 },
-	{ "SG_CACHE_AVAIL",	0x10, 0x10 },
-	{ "CCSGDONE",		0x80, 0x80 },
-	{ "CCSGEN",		0x0c, 0x0c }
-};
-
-int
-ahd_ccsgctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CCSGCTL_parse_table, 6, "CCSGCTL",
-	    0xad, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ccsgram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSGRAM",
-	    0xb0, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ccscbram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSCBRAM",
-	    0xb0, regvalue, cur_col, wrap));
-}
-
-int
-ahd_brddat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "BRDDAT",
-	    0xb8, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t BRDCTL_parse_table[] = {
-	{ "BRDSTB",		0x01, 0x01 },
-	{ "BRDRW",		0x02, 0x02 },
-	{ "BRDEN",		0x04, 0x04 },
-	{ "BRDADDR",		0x38, 0x38 },
-	{ "FLXARBREQ",		0x40, 0x40 },
-	{ "FLXARBACK",		0x80, 0x80 }
-};
-
-int
-ahd_brdctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(BRDCTL_parse_table, 6, "BRDCTL",
-	    0xb9, regvalue, cur_col, wrap));
-}
-
-int
-ahd_seeadr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SEEADR",
-	    0xba, regvalue, cur_col, wrap));
-}
-
-int
-ahd_seedat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SEEDAT",
-	    0xbc, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SEECTL_parse_table[] = {
-	{ "SEEOP_ERAL",		0x40, 0x70 },
-	{ "SEEOP_WRITE",	0x50, 0x70 },
-	{ "SEEOP_READ",		0x60, 0x70 },
-	{ "SEEOP_ERASE",	0x70, 0x70 },
-	{ "SEESTART",		0x01, 0x01 },
-	{ "SEERST",		0x02, 0x02 },
-	{ "SEEOPCODE",		0x70, 0x70 },
-	{ "SEEOP_EWEN",		0x40, 0x40 },
-	{ "SEEOP_WALL",		0x40, 0x40 },
-	{ "SEEOP_EWDS",		0x40, 0x40 }
-};
-
-int
-ahd_seectl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEECTL_parse_table, 10, "SEECTL",
-	    0xbe, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SEESTAT_parse_table[] = {
-	{ "SEESTART",		0x01, 0x01 },
-	{ "SEEBUSY",		0x02, 0x02 },
-	{ "SEEARBACK",		0x04, 0x04 },
-	{ "LDALTID_L",		0x08, 0x08 },
-	{ "SEEOPCODE",		0x70, 0x70 },
-	{ "INIT_DONE",		0x80, 0x80 }
-};
-
-int
-ahd_seestat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEESTAT_parse_table, 6, "SEESTAT",
-	    0xbe, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t DSPDATACTL_parse_table[] = {
-	{ "XMITOFFSTDIS",	0x02, 0x02 },
-	{ "RCVROFFSTDIS",	0x04, 0x04 },
-	{ "DESQDIS",		0x10, 0x10 },
-	{ "BYPASSENAB",		0x80, 0x80 }
-};
-
-int
-ahd_dspdatactl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DSPDATACTL_parse_table, 4, "DSPDATACTL",
-	    0xc1, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dfdat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DFDAT",
-	    0xc4, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t DSPSELECT_parse_table[] = {
-	{ "DSPSEL",		0x1f, 0x1f },
-	{ "AUTOINCEN",		0x80, 0x80 }
-};
-
-int
-ahd_dspselect_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DSPSELECT_parse_table, 2, "DSPSELECT",
-	    0xc4, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t WRTBIASCTL_parse_table[] = {
-	{ "XMITMANVAL",		0x3f, 0x3f },
-	{ "AUTOXBCDIS",		0x80, 0x80 }
-};
-
-int
-ahd_wrtbiasctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(WRTBIASCTL_parse_table, 2, "WRTBIASCTL",
-	    0xc5, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SEQCTL0_parse_table[] = {
-	{ "LOADRAM",		0x01, 0x01 },
-	{ "SEQRESET",		0x02, 0x02 },
-	{ "STEP",		0x04, 0x04 },
-	{ "BRKADRINTEN",	0x08, 0x08 },
-	{ "FASTMODE",		0x10, 0x10 },
-	{ "FAILDIS",		0x20, 0x20 },
-	{ "PAUSEDIS",		0x40, 0x40 },
-	{ "PERRORDIS",		0x80, 0x80 }
-};
-
-int
-ahd_seqctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQCTL0_parse_table, 8, "SEQCTL0",
-	    0xd6, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t FLAGS_parse_table[] = {
-	{ "CARRY",		0x01, 0x01 },
-	{ "ZERO",		0x02, 0x02 }
-};
-
-int
-ahd_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(FLAGS_parse_table, 2, "FLAGS",
-	    0xd8, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
-	{ "IRET",		0x01, 0x01 },
-	{ "INTMASK1",		0x02, 0x02 },
-	{ "INTMASK2",		0x04, 0x04 },
-	{ "SCS_SEQ_INT1M0",	0x08, 0x08 },
-	{ "SCS_SEQ_INT1M1",	0x10, 0x10 },
-	{ "INT1_CONTEXT",	0x20, 0x20 },
-	{ "INTVEC1DSL",		0x80, 0x80 }
-};
-
-int
-ahd_seqintctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQINTCTL_parse_table, 7, "SEQINTCTL",
-	    0xd9, regvalue, cur_col, wrap));
-}
-
-int
-ahd_seqram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SEQRAM",
-	    0xda, regvalue, cur_col, wrap));
-}
-
-int
-ahd_prgmcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "PRGMCNT",
-	    0xde, regvalue, cur_col, wrap));
-}
-
-int
-ahd_accum_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ACCUM",
-	    0xe0, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sindex_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SINDEX",
-	    0xe2, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dindex_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DINDEX",
-	    0xe4, regvalue, cur_col, wrap));
-}
-
-int
-ahd_allones_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ALLONES",
-	    0xe8, regvalue, cur_col, wrap));
-}
-
-int
-ahd_allzeros_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ALLZEROS",
-	    0xea, regvalue, cur_col, wrap));
-}
-
-int
-ahd_none_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NONE",
-	    0xea, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SINDIR",
-	    0xec, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DINDIR",
-	    0xed, regvalue, cur_col, wrap));
-}
-
-int
-ahd_stack_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "STACK",
-	    0xf2, regvalue, cur_col, wrap));
-}
-
-int
-ahd_intvec1_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "INTVEC1_ADDR",
-	    0xf4, regvalue, cur_col, wrap));
-}
-
-int
-ahd_curaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CURADDR",
-	    0xf4, regvalue, cur_col, wrap));
-}
-
-int
-ahd_intvec2_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "INTVEC2_ADDR",
-	    0xf6, regvalue, cur_col, wrap));
-}
-
-int
-ahd_longjmp_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LONGJMP_ADDR",
-	    0xf8, regvalue, cur_col, wrap));
-}
-
-int
-ahd_accum_save_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ACCUM_SAVE",
-	    0xfa, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SRAM_BASE",
-	    0x100, regvalue, cur_col, wrap));
-}
-
-int
-ahd_waiting_scb_tails_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "WAITING_SCB_TAILS",
-	    0x100, regvalue, cur_col, wrap));
-}
-
-int
-ahd_waiting_tid_head_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "WAITING_TID_HEAD",
-	    0x120, regvalue, cur_col, wrap));
-}
-
-int
-ahd_waiting_tid_tail_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "WAITING_TID_TAIL",
-	    0x122, regvalue, cur_col, wrap));
-}
-
-int
-ahd_next_queued_scb_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NEXT_QUEUED_SCB_ADDR",
-	    0x124, regvalue, cur_col, wrap));
-}
-
-int
-ahd_complete_scb_head_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "COMPLETE_SCB_HEAD",
-	    0x128, regvalue, cur_col, wrap));
-}
-
-int
-ahd_complete_scb_dmainprog_head_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "COMPLETE_SCB_DMAINPROG_HEAD",
-	    0x12a, regvalue, cur_col, wrap));
-}
-
-int
-ahd_complete_dma_scb_head_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "COMPLETE_DMA_SCB_HEAD",
-	    0x12c, regvalue, cur_col, wrap));
-}
-
-int
-ahd_complete_dma_scb_tail_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "COMPLETE_DMA_SCB_TAIL",
-	    0x12e, regvalue, cur_col, wrap));
-}
-
-int
-ahd_complete_on_qfreeze_head_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "COMPLETE_ON_QFREEZE_HEAD",
-	    0x130, regvalue, cur_col, wrap));
-}
-
-int
-ahd_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "QFREEZE_COUNT",
-	    0x132, regvalue, cur_col, wrap));
-}
-
-int
-ahd_kernel_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT",
-	    0x134, regvalue, cur_col, wrap));
-}
-
-int
-ahd_saved_mode_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SAVED_MODE",
-	    0x136, regvalue, cur_col, wrap));
-}
-
-int
-ahd_msg_out_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MSG_OUT",
-	    0x137, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t DMAPARAMS_parse_table[] = {
-	{ "FIFORESET",		0x01, 0x01 },
-	{ "FIFOFLUSH",		0x02, 0x02 },
-	{ "DIRECTION",		0x04, 0x04 },
-	{ "HDMAEN",		0x08, 0x08 },
-	{ "HDMAENACK",		0x08, 0x08 },
-	{ "SDMAEN",		0x10, 0x10 },
-	{ "SDMAENACK",		0x10, 0x10 },
-	{ "SCSIEN",		0x20, 0x20 },
-	{ "WIDEODD",		0x40, 0x40 },
-	{ "PRELOADEN",		0x80, 0x80 }
-};
-
-int
-ahd_dmaparams_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DMAPARAMS_parse_table, 10, "DMAPARAMS",
-	    0x138, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
-	{ "NO_DISCONNECT",	0x01, 0x01 },
-	{ "SPHASE_PENDING",	0x02, 0x02 },
-	{ "DPHASE_PENDING",	0x04, 0x04 },
-	{ "CMDPHASE_PENDING",	0x08, 0x08 },
-	{ "TARG_CMD_PENDING",	0x10, 0x10 },
-	{ "DPHASE",		0x20, 0x20 },
-	{ "NO_CDB_SENT",	0x40, 0x40 },
-	{ "TARGET_CMD_IS_TAGGED",0x40, 0x40 },
-	{ "NOT_IDENTIFIED",	0x80, 0x80 }
-};
-
-int
-ahd_seq_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
-	    0x139, regvalue, cur_col, wrap));
-}
-
-int
-ahd_saved_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SAVED_SCSIID",
-	    0x13a, regvalue, cur_col, wrap));
-}
-
-int
-ahd_saved_lun_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SAVED_LUN",
-	    0x13b, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
-	{ "P_DATAOUT",		0x00, 0xe0 },
-	{ "P_DATAOUT_DT",	0x20, 0xe0 },
-	{ "P_DATAIN",		0x40, 0xe0 },
-	{ "P_DATAIN_DT",	0x60, 0xe0 },
-	{ "P_COMMAND",		0x80, 0xe0 },
-	{ "P_MESGOUT",		0xa0, 0xe0 },
-	{ "P_STATUS",		0xc0, 0xe0 },
-	{ "P_MESGIN",		0xe0, 0xe0 },
-	{ "P_BUSFREE",		0x01, 0x01 },
-	{ "MSGI",		0x20, 0x20 },
-	{ "IOI",		0x40, 0x40 },
-	{ "CDI",		0x80, 0x80 },
-	{ "PHASE_MASK",		0xe0, 0xe0 }
-};
-
-int
-ahd_lastphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LASTPHASE_parse_table, 13, "LASTPHASE",
-	    0x13c, regvalue, cur_col, wrap));
-}
-
-int
-ahd_qoutfifo_entry_valid_tag_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "QOUTFIFO_ENTRY_VALID_TAG",
-	    0x13d, regvalue, cur_col, wrap));
-}
-
-int
-ahd_kernel_tqinpos_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "KERNEL_TQINPOS",
-	    0x13e, regvalue, cur_col, wrap));
-}
-
-int
-ahd_tqinpos_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "TQINPOS",
-	    0x13f, regvalue, cur_col, wrap));
-}
-
-int
-ahd_shared_data_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SHARED_DATA_ADDR",
-	    0x140, regvalue, cur_col, wrap));
-}
-
-int
-ahd_qoutfifo_next_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "QOUTFIFO_NEXT_ADDR",
-	    0x144, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t ARG_1_parse_table[] = {
-	{ "CONT_MSG_LOOP_TARG",	0x02, 0x02 },
-	{ "CONT_MSG_LOOP_READ",	0x03, 0x03 },
-	{ "CONT_MSG_LOOP_WRITE",0x04, 0x04 },
-	{ "EXIT_MSG_LOOP",	0x08, 0x08 },
-	{ "MSGOUT_PHASEMIS",	0x10, 0x10 },
-	{ "SEND_REJ",		0x20, 0x20 },
-	{ "SEND_SENSE",		0x40, 0x40 },
-	{ "SEND_MSG",		0x80, 0x80 }
-};
-
-int
-ahd_arg_1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(ARG_1_parse_table, 8, "ARG_1",
-	    0x148, regvalue, cur_col, wrap));
-}
-
-int
-ahd_arg_2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ARG_2",
-	    0x149, regvalue, cur_col, wrap));
-}
-
-int
-ahd_last_msg_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LAST_MSG",
-	    0x14a, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
-	{ "ALTSTIM",		0x01, 0x01 },
-	{ "ENAUTOATNP",		0x02, 0x02 },
-	{ "MANUALP",		0x0c, 0x0c },
-	{ "ENRSELI",		0x10, 0x10 },
-	{ "ENSELI",		0x20, 0x20 },
-	{ "MANUALCTL",		0x40, 0x40 }
-};
-
-int
-ahd_scsiseq_template_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSISEQ_TEMPLATE_parse_table, 6, "SCSISEQ_TEMPLATE",
-	    0x14b, regvalue, cur_col, wrap));
-}
-
-int
-ahd_initiator_tag_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "INITIATOR_TAG",
-	    0x14c, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
-	{ "PENDING_MK_MESSAGE",	0x01, 0x01 },
-	{ "TARGET_MSG_PENDING",	0x02, 0x02 },
-	{ "SELECTOUT_QFROZEN",	0x04, 0x04 }
-};
-
-int
-ahd_seq_flags2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQ_FLAGS2_parse_table, 3, "SEQ_FLAGS2",
-	    0x14d, regvalue, cur_col, wrap));
-}
-
-int
-ahd_allocfifo_scbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ALLOCFIFO_SCBPTR",
-	    0x14e, regvalue, cur_col, wrap));
-}
-
-int
-ahd_int_coalescing_timer_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "INT_COALESCING_TIMER",
-	    0x150, regvalue, cur_col, wrap));
-}
-
-int
-ahd_int_coalescing_maxcmds_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "INT_COALESCING_MAXCMDS",
-	    0x152, regvalue, cur_col, wrap));
-}
-
-int
-ahd_int_coalescing_mincmds_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "INT_COALESCING_MINCMDS",
-	    0x153, regvalue, cur_col, wrap));
-}
-
-int
-ahd_cmds_pending_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CMDS_PENDING",
-	    0x154, regvalue, cur_col, wrap));
-}
-
-int
-ahd_int_coalescing_cmdcount_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "INT_COALESCING_CMDCOUNT",
-	    0x156, regvalue, cur_col, wrap));
-}
-
-int
-ahd_local_hs_mailbox_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LOCAL_HS_MAILBOX",
-	    0x157, regvalue, cur_col, wrap));
-}
-
-int
-ahd_cmdsize_table_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CMDSIZE_TABLE",
-	    0x158, regvalue, cur_col, wrap));
-}
-
-int
-ahd_mk_message_scb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCB",
-	    0x160, regvalue, cur_col, wrap));
-}
-
-int
-ahd_mk_message_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCSIID",
-	    0x162, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_residual_datacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_RESIDUAL_DATACNT",
-	    0x180, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_BASE",
-	    0x180, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCB_RESIDUAL_SGPTR_parse_table[] = {
-	{ "SG_LIST_NULL",	0x01, 0x01 },
-	{ "SG_OVERRUN_RESID",	0x02, 0x02 },
-	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
-};
-
-int
-ahd_scb_residual_sgptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCB_RESIDUAL_SGPTR_parse_table, 3, "SCB_RESIDUAL_SGPTR",
-	    0x184, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_scsi_status_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_SCSI_STATUS",
-	    0x188, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_sense_busaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_SENSE_BUSADDR",
-	    0x18c, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_tag_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_TAG",
-	    0x190, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
-	{ "SCB_TAG_TYPE",	0x03, 0x03 },
-	{ "DISCONNECTED",	0x04, 0x04 },
-	{ "STATUS_RCVD",	0x08, 0x08 },
-	{ "MK_MESSAGE",		0x10, 0x10 },
-	{ "TAG_ENB",		0x20, 0x20 },
-	{ "DISCENB",		0x40, 0x40 },
-	{ "TARGET_SCB",		0x80, 0x80 }
-};
-
-int
-ahd_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCB_CONTROL_parse_table, 7, "SCB_CONTROL",
-	    0x192, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
-	{ "OID",		0x0f, 0x0f },
-	{ "TID",		0xf0, 0xf0 }
-};
-
-int
-ahd_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(SCB_SCSIID_parse_table, 2, "SCB_SCSIID",
 	    0x193, regvalue, cur_col, wrap));
 }
 
-static const ahd_reg_parse_entry_t SCB_LUN_parse_table[] = {
-	{ "LID",		0xff, 0xff }
-};
-
-int
-ahd_scb_lun_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCB_LUN_parse_table, 1, "SCB_LUN",
-	    0x194, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCB_TASK_ATTRIBUTE_parse_table[] = {
-	{ "SCB_XFERLEN_ODD",	0x01, 0x01 }
-};
-
-int
-ahd_scb_task_attribute_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCB_TASK_ATTRIBUTE_parse_table, 1, "SCB_TASK_ATTRIBUTE",
-	    0x195, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCB_CDB_LEN_parse_table[] = {
-	{ "SCB_CDB_LEN_PTR",	0x80, 0x80 }
-};
-
-int
-ahd_scb_cdb_len_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCB_CDB_LEN_parse_table, 1, "SCB_CDB_LEN",
-	    0x196, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_task_management_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_TASK_MANAGEMENT",
-	    0x197, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_dataptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_DATAPTR",
-	    0x198, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
-	{ "SG_HIGH_ADDR_BITS",	0x7f, 0x7f },
-	{ "SG_LAST_SEG",	0x80, 0x80 }
-};
-
-int
-ahd_scb_datacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCB_DATACNT_parse_table, 2, "SCB_DATACNT",
-	    0x1a0, regvalue, cur_col, wrap));
-}
-
-static const ahd_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
-	{ "SG_LIST_NULL",	0x01, 0x01 },
-	{ "SG_FULL_RESID",	0x02, 0x02 },
-	{ "SG_STATUS_VALID",	0x04, 0x04 }
-};
-
-int
-ahd_scb_sgptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCB_SGPTR_parse_table, 3, "SCB_SGPTR",
-	    0x1a4, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_busaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_BUSADDR",
-	    0x1a8, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_next_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_NEXT",
-	    0x1ac, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_next2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_NEXT2",
-	    0x1ae, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_disconnected_lists_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_DISCONNECTED_LISTS",
-	    0x1b8, regvalue, cur_col, wrap));
-}
-
diff -puN drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped~aic7xxx-update-_shipped-files drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped
--- a/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped~aic7xxx-update-_shipped-files
+++ a/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped
@@ -27,20 +27,6 @@ ahc_reg_print_t ahc_sxfrctl0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sxfrctl1_print;
-#else
-#define ahc_sxfrctl1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SXFRCTL1", 0x02, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsisigo_print;
-#else
-#define ahc_scsisigo_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSISIGO", 0x03, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scsisigi_print;
 #else
 #define ahc_scsisigi_print(regvalue, cur_col, wrap) \
@@ -55,55 +41,6 @@ ahc_reg_print_t ahc_scsirate_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiid_print;
-#else
-#define ahc_scsiid_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIID", 0x05, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsidatl_print;
-#else
-#define ahc_scsidatl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIDATL", 0x06, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsidath_print;
-#else
-#define ahc_scsidath_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIDATH", 0x07, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_stcnt_print;
-#else
-#define ahc_stcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "STCNT", 0x08, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_optionmode_print;
-#else
-#define ahc_optionmode_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "OPTIONMODE", 0x08, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_targcrccnt_print;
-#else
-#define ahc_targcrccnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "TARGCRCCNT", 0x0a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_clrsint0_print;
-#else
-#define ahc_clrsint0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CLRSINT0", 0x0b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_sstat0_print;
 #else
 #define ahc_sstat0_print(regvalue, cur_col, wrap) \
@@ -111,13 +48,6 @@ ahc_reg_print_t ahc_sstat0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_clrsint1_print;
-#else
-#define ahc_clrsint1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CLRSINT1", 0x0c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_sstat1_print;
 #else
 #define ahc_sstat1_print(regvalue, cur_col, wrap) \
@@ -139,13 +69,6 @@ ahc_reg_print_t ahc_sstat3_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiid_ultra2_print;
-#else
-#define ahc_scsiid_ultra2_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIID_ULTRA2", 0x0f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_simode0_print;
 #else
 #define ahc_simode0_print(regvalue, cur_col, wrap) \
@@ -167,76 +90,6 @@ ahc_reg_print_t ahc_scsibusl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsibush_print;
-#else
-#define ahc_scsibush_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIBUSH", 0x13, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sxfrctl2_print;
-#else
-#define ahc_sxfrctl2_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SXFRCTL2", 0x13, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_shaddr_print;
-#else
-#define ahc_shaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SHADDR", 0x14, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seltimer_print;
-#else
-#define ahc_seltimer_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SELTIMER", 0x18, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_selid_print;
-#else
-#define ahc_selid_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SELID", 0x19, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scamctl_print;
-#else
-#define ahc_scamctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCAMCTL", 0x1a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_targid_print;
-#else
-#define ahc_targid_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "TARGID", 0x1b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_spiocap_print;
-#else
-#define ahc_spiocap_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SPIOCAP", 0x1b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_brdctl_print;
-#else
-#define ahc_brdctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "BRDCTL", 0x1d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seectl_print;
-#else
-#define ahc_seectl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEECTL", 0x1e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_sblkctl_print;
 #else
 #define ahc_sblkctl_print(regvalue, cur_col, wrap) \
@@ -244,62 +97,6 @@ ahc_reg_print_t ahc_sblkctl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_busy_targets_print;
-#else
-#define ahc_busy_targets_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "BUSY_TARGETS", 0x20, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ultra_enb_print;
-#else
-#define ahc_ultra_enb_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ULTRA_ENB", 0x30, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_disc_dsb_print;
-#else
-#define ahc_disc_dsb_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DISC_DSB", 0x32, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_cmdsize_table_tail_print;
-#else
-#define ahc_cmdsize_table_tail_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CMDSIZE_TABLE_TAIL", 0x34, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_mwi_residual_print;
-#else
-#define ahc_mwi_residual_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "MWI_RESIDUAL", 0x38, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_next_queued_scb_print;
-#else
-#define ahc_next_queued_scb_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "NEXT_QUEUED_SCB", 0x39, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_msg_out_print;
-#else
-#define ahc_msg_out_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "MSG_OUT", 0x3a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dmaparams_print;
-#else
-#define ahc_dmaparams_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DMAPARAMS", 0x3b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_seq_flags_print;
 #else
 #define ahc_seq_flags_print(regvalue, cur_col, wrap) \
@@ -307,20 +104,6 @@ ahc_reg_print_t ahc_seq_flags_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_saved_scsiid_print;
-#else
-#define ahc_saved_scsiid_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SAVED_SCSIID", 0x3d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_saved_lun_print;
-#else
-#define ahc_saved_lun_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SAVED_LUN", 0x3e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_lastphase_print;
 #else
 #define ahc_lastphase_print(regvalue, cur_col, wrap) \
@@ -328,153 +111,6 @@ ahc_reg_print_t ahc_lastphase_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_waiting_scbh_print;
-#else
-#define ahc_waiting_scbh_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "WAITING_SCBH", 0x40, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_disconnected_scbh_print;
-#else
-#define ahc_disconnected_scbh_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DISCONNECTED_SCBH", 0x41, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_free_scbh_print;
-#else
-#define ahc_free_scbh_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "FREE_SCBH", 0x42, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_complete_scbh_print;
-#else
-#define ahc_complete_scbh_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "COMPLETE_SCBH", 0x43, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hscb_addr_print;
-#else
-#define ahc_hscb_addr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HSCB_ADDR", 0x44, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_shared_data_addr_print;
-#else
-#define ahc_shared_data_addr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SHARED_DATA_ADDR", 0x48, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_kernel_qinpos_print;
-#else
-#define ahc_kernel_qinpos_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "KERNEL_QINPOS", 0x4c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qinpos_print;
-#else
-#define ahc_qinpos_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QINPOS", 0x4d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qoutpos_print;
-#else
-#define ahc_qoutpos_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QOUTPOS", 0x4e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_kernel_tqinpos_print;
-#else
-#define ahc_kernel_tqinpos_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "KERNEL_TQINPOS", 0x4f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_tqinpos_print;
-#else
-#define ahc_tqinpos_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "TQINPOS", 0x50, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_arg_1_print;
-#else
-#define ahc_arg_1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ARG_1", 0x51, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_arg_2_print;
-#else
-#define ahc_arg_2_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ARG_2", 0x52, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_last_msg_print;
-#else
-#define ahc_last_msg_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "LAST_MSG", 0x53, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiseq_template_print;
-#else
-#define ahc_scsiseq_template_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSISEQ_TEMPLATE", 0x54, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ha_274_biosglobal_print;
-#else
-#define ahc_ha_274_biosglobal_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HA_274_BIOSGLOBAL", 0x56, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seq_flags2_print;
-#else
-#define ahc_seq_flags2_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQ_FLAGS2", 0x57, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiconf_print;
-#else
-#define ahc_scsiconf_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSICONF", 0x5a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_intdef_print;
-#else
-#define ahc_intdef_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "INTDEF", 0x5c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hostconf_print;
-#else
-#define ahc_hostconf_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HOSTCONF", 0x5d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ha_274_biosctrl_print;
-#else
-#define ahc_ha_274_biosctrl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HA_274_BIOSCTRL", 0x5f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_seqctl_print;
 #else
 #define ahc_seqctl_print(regvalue, cur_col, wrap) \
@@ -482,111 +118,6 @@ ahc_reg_print_t ahc_seqctl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seqram_print;
-#else
-#define ahc_seqram_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQRAM", 0x61, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seqaddr0_print;
-#else
-#define ahc_seqaddr0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQADDR0", 0x62, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seqaddr1_print;
-#else
-#define ahc_seqaddr1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQADDR1", 0x63, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_accum_print;
-#else
-#define ahc_accum_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ACCUM", 0x64, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sindex_print;
-#else
-#define ahc_sindex_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SINDEX", 0x65, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dindex_print;
-#else
-#define ahc_dindex_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DINDEX", 0x66, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_allones_print;
-#else
-#define ahc_allones_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ALLONES", 0x69, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_allzeros_print;
-#else
-#define ahc_allzeros_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ALLZEROS", 0x6a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_none_print;
-#else
-#define ahc_none_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "NONE", 0x6a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_flags_print;
-#else
-#define ahc_flags_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "FLAGS", 0x6b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sindir_print;
-#else
-#define ahc_sindir_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SINDIR", 0x6c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dindir_print;
-#else
-#define ahc_dindir_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DINDIR", 0x6d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_function1_print;
-#else
-#define ahc_function1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "FUNCTION1", 0x6e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_stack_print;
-#else
-#define ahc_stack_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "STACK", 0x6f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_targ_offset_print;
-#else
-#define ahc_targ_offset_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "TARG_OFFSET", 0x70, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_sram_base_print;
 #else
 #define ahc_sram_base_print(regvalue, cur_col, wrap) \
@@ -594,97 +125,6 @@ ahc_reg_print_t ahc_sram_base_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_bctl_print;
-#else
-#define ahc_bctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "BCTL", 0x84, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dscommand0_print;
-#else
-#define ahc_dscommand0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DSCOMMAND0", 0x84, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_bustime_print;
-#else
-#define ahc_bustime_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "BUSTIME", 0x85, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dscommand1_print;
-#else
-#define ahc_dscommand1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DSCOMMAND1", 0x85, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_busspd_print;
-#else
-#define ahc_busspd_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "BUSSPD", 0x86, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hs_mailbox_print;
-#else
-#define ahc_hs_mailbox_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HS_MAILBOX", 0x86, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dspcistatus_print;
-#else
-#define ahc_dspcistatus_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DSPCISTATUS", 0x86, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hcntrl_print;
-#else
-#define ahc_hcntrl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HCNTRL", 0x87, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_haddr_print;
-#else
-#define ahc_haddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HADDR", 0x88, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hcnt_print;
-#else
-#define ahc_hcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HCNT", 0x8c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scbptr_print;
-#else
-#define ahc_scbptr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCBPTR", 0x90, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_intstat_print;
-#else
-#define ahc_intstat_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "INTSTAT", 0x91, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_clrint_print;
-#else
-#define ahc_clrint_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CLRINT", 0x92, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_error_print;
 #else
 #define ahc_error_print(regvalue, cur_col, wrap) \
@@ -706,69 +146,6 @@ ahc_reg_print_t ahc_dfstatus_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfwaddr_print;
-#else
-#define ahc_dfwaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFWADDR", 0x95, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfraddr_print;
-#else
-#define ahc_dfraddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFRADDR", 0x97, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfdat_print;
-#else
-#define ahc_dfdat_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFDAT", 0x99, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scbcnt_print;
-#else
-#define ahc_scbcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCBCNT", 0x9a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qinfifo_print;
-#else
-#define ahc_qinfifo_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QINFIFO", 0x9b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qincnt_print;
-#else
-#define ahc_qincnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QINCNT", 0x9c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qoutfifo_print;
-#else
-#define ahc_qoutfifo_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QOUTFIFO", 0x9d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_crccontrol1_print;
-#else
-#define ahc_crccontrol1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CRCCONTROL1", 0x9d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qoutcnt_print;
-#else
-#define ahc_qoutcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QOUTCNT", 0x9e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scsiphase_print;
 #else
 #define ahc_scsiphase_print(regvalue, cur_col, wrap) \
@@ -776,13 +153,6 @@ ahc_reg_print_t ahc_scsiphase_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sfunct_print;
-#else
-#define ahc_sfunct_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SFUNCT", 0x9f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scb_base_print;
 #else
 #define ahc_scb_base_print(regvalue, cur_col, wrap) \
@@ -790,69 +160,6 @@ ahc_reg_print_t ahc_scb_base_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_cdb_ptr_print;
-#else
-#define ahc_scb_cdb_ptr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_CDB_PTR", 0xa0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_residual_sgptr_print;
-#else
-#define ahc_scb_residual_sgptr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_RESIDUAL_SGPTR", 0xa4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_scsi_status_print;
-#else
-#define ahc_scb_scsi_status_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_SCSI_STATUS", 0xa8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_target_phases_print;
-#else
-#define ahc_scb_target_phases_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_TARGET_PHASES", 0xa9, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_target_data_dir_print;
-#else
-#define ahc_scb_target_data_dir_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_TARGET_DATA_DIR", 0xaa, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_target_itag_print;
-#else
-#define ahc_scb_target_itag_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_TARGET_ITAG", 0xab, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_dataptr_print;
-#else
-#define ahc_scb_dataptr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_DATAPTR", 0xac, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_datacnt_print;
-#else
-#define ahc_scb_datacnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_DATACNT", 0xb0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_sgptr_print;
-#else
-#define ahc_scb_sgptr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_SGPTR", 0xb4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scb_control_print;
 #else
 #define ahc_scb_control_print(regvalue, cur_col, wrap) \
@@ -880,188 +187,6 @@ ahc_reg_print_t ahc_scb_tag_print;
     ahc_print_register(NULL, 0, "SCB_TAG", 0xbb, regvalue, cur_col, wrap)
 #endif
 
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_cdb_len_print;
-#else
-#define ahc_scb_cdb_len_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_CDB_LEN", 0xbc, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_scsirate_print;
-#else
-#define ahc_scb_scsirate_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_SCSIRATE", 0xbd, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_scsioffset_print;
-#else
-#define ahc_scb_scsioffset_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_SCSIOFFSET", 0xbe, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_next_print;
-#else
-#define ahc_scb_next_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_NEXT", 0xbf, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_64_spare_print;
-#else
-#define ahc_scb_64_spare_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_64_SPARE", 0xc0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seectl_2840_print;
-#else
-#define ahc_seectl_2840_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEECTL_2840", 0xc0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_status_2840_print;
-#else
-#define ahc_status_2840_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "STATUS_2840", 0xc1, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_64_btt_print;
-#else
-#define ahc_scb_64_btt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_64_BTT", 0xd0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_cchaddr_print;
-#else
-#define ahc_cchaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCHADDR", 0xe0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_cchcnt_print;
-#else
-#define ahc_cchcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCHCNT", 0xe8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccsgram_print;
-#else
-#define ahc_ccsgram_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSGRAM", 0xe9, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccsgaddr_print;
-#else
-#define ahc_ccsgaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSGADDR", 0xea, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccsgctl_print;
-#else
-#define ahc_ccsgctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSGCTL", 0xeb, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbram_print;
-#else
-#define ahc_ccscbram_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBRAM", 0xec, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbaddr_print;
-#else
-#define ahc_ccscbaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBADDR", 0xed, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbctl_print;
-#else
-#define ahc_ccscbctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBCTL", 0xee, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbcnt_print;
-#else
-#define ahc_ccscbcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBCNT", 0xef, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scbbaddr_print;
-#else
-#define ahc_scbbaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCBBADDR", 0xf0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbptr_print;
-#else
-#define ahc_ccscbptr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBPTR", 0xf1, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hnscb_qoff_print;
-#else
-#define ahc_hnscb_qoff_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HNSCB_QOFF", 0xf4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_snscb_qoff_print;
-#else
-#define ahc_snscb_qoff_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SNSCB_QOFF", 0xf6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sdscb_qoff_print;
-#else
-#define ahc_sdscb_qoff_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SDSCB_QOFF", 0xf8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qoff_ctlsta_print;
-#else
-#define ahc_qoff_ctlsta_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QOFF_CTLSTA", 0xfa, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dff_thrsh_print;
-#else
-#define ahc_dff_thrsh_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFF_THRSH", 0xfb, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sg_cache_shadow_print;
-#else
-#define ahc_sg_cache_shadow_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SG_CACHE_SHADOW", 0xfc, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sg_cache_pre_print;
-#else
-#define ahc_sg_cache_pre_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SG_CACHE_PRE", 0xfc, regvalue, cur_col, wrap)
-#endif
-
 
 #define	SCSISEQ         		0x00
 #define		TEMODE          	0x80
diff -puN drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped~aic7xxx-update-_shipped-files drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
--- a/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped~aic7xxx-update-_shipped-files
+++ a/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
@@ -43,48 +43,6 @@ ahc_sxfrctl0_print(u_int regvalue, u_int
 	    0x01, regvalue, cur_col, wrap));
 }
 
-static const ahc_reg_parse_entry_t SXFRCTL1_parse_table[] = {
-	{ "STPWEN",		0x01, 0x01 },
-	{ "ACTNEGEN",		0x02, 0x02 },
-	{ "ENSTIMER",		0x04, 0x04 },
-	{ "ENSPCHK",		0x20, 0x20 },
-	{ "SWRAPEN",		0x40, 0x40 },
-	{ "BITBUCKET",		0x80, 0x80 },
-	{ "STIMESEL",		0x18, 0x18 }
-};
-
-int
-ahc_sxfrctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SXFRCTL1_parse_table, 7, "SXFRCTL1",
-	    0x02, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SCSISIGO_parse_table[] = {
-	{ "ACKO",		0x01, 0x01 },
-	{ "REQO",		0x02, 0x02 },
-	{ "BSYO",		0x04, 0x04 },
-	{ "SELO",		0x08, 0x08 },
-	{ "ATNO",		0x10, 0x10 },
-	{ "MSGO",		0x20, 0x20 },
-	{ "IOO",		0x40, 0x40 },
-	{ "CDO",		0x80, 0x80 },
-	{ "P_DATAOUT",		0x00, 0x00 },
-	{ "P_DATAIN",		0x40, 0x40 },
-	{ "P_COMMAND",		0x80, 0x80 },
-	{ "P_MESGOUT",		0xa0, 0xa0 },
-	{ "P_STATUS",		0xc0, 0xc0 },
-	{ "PHASE_MASK",		0xe0, 0xe0 },
-	{ "P_MESGIN",		0xe0, 0xe0 }
-};
-
-int
-ahc_scsisigo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSISIGO_parse_table, 15, "SCSISIGO",
-	    0x03, regvalue, cur_col, wrap));
-}
-
 static const ahc_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "ACKI",		0x01, 0x01 },
 	{ "REQI",		0x02, 0x02 },
@@ -128,77 +86,6 @@ ahc_scsirate_print(u_int regvalue, u_int
 	    0x04, regvalue, cur_col, wrap));
 }
 
-static const ahc_reg_parse_entry_t SCSIID_parse_table[] = {
-	{ "TWIN_CHNLB",		0x80, 0x80 },
-	{ "OID",		0x0f, 0x0f },
-	{ "TWIN_TID",		0x70, 0x70 },
-	{ "SOFS_ULTRA2",	0x7f, 0x7f },
-	{ "TID",		0xf0, 0xf0 }
-};
-
-int
-ahc_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSIID_parse_table, 5, "SCSIID",
-	    0x05, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scsidatl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCSIDATL",
-	    0x06, regvalue, cur_col, wrap));
-}
-
-int
-ahc_stcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "STCNT",
-	    0x08, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t OPTIONMODE_parse_table[] = {
-	{ "DIS_MSGIN_DUALEDGE",	0x01, 0x01 },
-	{ "AUTO_MSGOUT_DE",	0x02, 0x02 },
-	{ "SCSIDATL_IMGEN",	0x04, 0x04 },
-	{ "EXPPHASEDIS",	0x08, 0x08 },
-	{ "BUSFREEREV",		0x10, 0x10 },
-	{ "ATNMGMNTEN",		0x20, 0x20 },
-	{ "AUTOACKEN",		0x40, 0x40 },
-	{ "AUTORATEEN",		0x80, 0x80 },
-	{ "OPTIONMODE_DEFAULTS",0x03, 0x03 }
-};
-
-int
-ahc_optionmode_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(OPTIONMODE_parse_table, 9, "OPTIONMODE",
-	    0x08, regvalue, cur_col, wrap));
-}
-
-int
-ahc_targcrccnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "TARGCRCCNT",
-	    0x0a, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t CLRSINT0_parse_table[] = {
-	{ "CLRSPIORDY",		0x02, 0x02 },
-	{ "CLRSWRAP",		0x08, 0x08 },
-	{ "CLRIOERR",		0x08, 0x08 },
-	{ "CLRSELINGO",		0x10, 0x10 },
-	{ "CLRSELDI",		0x20, 0x20 },
-	{ "CLRSELDO",		0x40, 0x40 }
-};
-
-int
-ahc_clrsint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CLRSINT0_parse_table, 6, "CLRSINT0",
-	    0x0b, regvalue, cur_col, wrap));
-}
-
 static const ahc_reg_parse_entry_t SSTAT0_parse_table[] = {
 	{ "DMADONE",		0x01, 0x01 },
 	{ "SPIORDY",		0x02, 0x02 },
@@ -218,23 +105,6 @@ ahc_sstat0_print(u_int regvalue, u_int *
 	    0x0b, regvalue, cur_col, wrap));
 }
 
-static const ahc_reg_parse_entry_t CLRSINT1_parse_table[] = {
-	{ "CLRREQINIT",		0x01, 0x01 },
-	{ "CLRPHASECHG",	0x02, 0x02 },
-	{ "CLRSCSIPERR",	0x04, 0x04 },
-	{ "CLRBUSFREE",		0x08, 0x08 },
-	{ "CLRSCSIRSTI",	0x20, 0x20 },
-	{ "CLRATNO",		0x40, 0x40 },
-	{ "CLRSELTIMEO",	0x80, 0x80 }
-};
-
-int
-ahc_clrsint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CLRSINT1_parse_table, 7, "CLRSINT1",
-	    0x0c, regvalue, cur_col, wrap));
-}
-
 static const ahc_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "REQINIT",		0x01, 0x01 },
 	{ "PHASECHG",		0x02, 0x02 },
@@ -284,18 +154,6 @@ ahc_sstat3_print(u_int regvalue, u_int *
 	    0x0e, regvalue, cur_col, wrap));
 }
 
-static const ahc_reg_parse_entry_t SCSIID_ULTRA2_parse_table[] = {
-	{ "OID",		0x0f, 0x0f },
-	{ "TID",		0xf0, 0xf0 }
-};
-
-int
-ahc_scsiid_ultra2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSIID_ULTRA2_parse_table, 2, "SCSIID_ULTRA2",
-	    0x0f, regvalue, cur_col, wrap));
-}
-
 static const ahc_reg_parse_entry_t SIMODE0_parse_table[] = {
 	{ "ENDMADONE",		0x01, 0x01 },
 	{ "ENSPIORDY",		0x02, 0x02 },
@@ -339,107 +197,6 @@ ahc_scsibusl_print(u_int regvalue, u_int
 	    0x12, regvalue, cur_col, wrap));
 }
 
-int
-ahc_shaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SHADDR",
-	    0x14, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SELTIMER_parse_table[] = {
-	{ "STAGE1",		0x01, 0x01 },
-	{ "STAGE2",		0x02, 0x02 },
-	{ "STAGE3",		0x04, 0x04 },
-	{ "STAGE4",		0x08, 0x08 },
-	{ "STAGE5",		0x10, 0x10 },
-	{ "STAGE6",		0x20, 0x20 }
-};
-
-int
-ahc_seltimer_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SELTIMER_parse_table, 6, "SELTIMER",
-	    0x18, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SELID_parse_table[] = {
-	{ "ONEBIT",		0x08, 0x08 },
-	{ "SELID_MASK",		0xf0, 0xf0 }
-};
-
-int
-ahc_selid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SELID_parse_table, 2, "SELID",
-	    0x19, regvalue, cur_col, wrap));
-}
-
-int
-ahc_targid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "TARGID",
-	    0x1b, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SPIOCAP_parse_table[] = {
-	{ "SSPIOCPS",		0x01, 0x01 },
-	{ "ROM",		0x02, 0x02 },
-	{ "EEPROM",		0x04, 0x04 },
-	{ "SEEPROM",		0x08, 0x08 },
-	{ "EXT_BRDCTL",		0x10, 0x10 },
-	{ "SOFTCMDEN",		0x20, 0x20 },
-	{ "SOFT0",		0x40, 0x40 },
-	{ "SOFT1",		0x80, 0x80 }
-};
-
-int
-ahc_spiocap_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SPIOCAP_parse_table, 8, "SPIOCAP",
-	    0x1b, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t BRDCTL_parse_table[] = {
-	{ "BRDCTL0",		0x01, 0x01 },
-	{ "BRDSTB_ULTRA2",	0x01, 0x01 },
-	{ "BRDCTL1",		0x02, 0x02 },
-	{ "BRDRW_ULTRA2",	0x02, 0x02 },
-	{ "BRDRW",		0x04, 0x04 },
-	{ "BRDDAT2",		0x04, 0x04 },
-	{ "BRDCS",		0x08, 0x08 },
-	{ "BRDDAT3",		0x08, 0x08 },
-	{ "BRDSTB",		0x10, 0x10 },
-	{ "BRDDAT4",		0x10, 0x10 },
-	{ "BRDDAT5",		0x20, 0x20 },
-	{ "BRDDAT6",		0x40, 0x40 },
-	{ "BRDDAT7",		0x80, 0x80 }
-};
-
-int
-ahc_brdctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(BRDCTL_parse_table, 13, "BRDCTL",
-	    0x1d, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SEECTL_parse_table[] = {
-	{ "SEEDI",		0x01, 0x01 },
-	{ "SEEDO",		0x02, 0x02 },
-	{ "SEECK",		0x04, 0x04 },
-	{ "SEECS",		0x08, 0x08 },
-	{ "SEERDY",		0x10, 0x10 },
-	{ "SEEMS",		0x20, 0x20 },
-	{ "EXTARBREQ",		0x40, 0x40 },
-	{ "EXTARBACK",		0x80, 0x80 }
-};
-
-int
-ahc_seectl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEECTL_parse_table, 8, "SEECTL",
-	    0x1e, regvalue, cur_col, wrap));
-}
-
 static const ahc_reg_parse_entry_t SBLKCTL_parse_table[] = {
 	{ "XCVR",		0x01, 0x01 },
 	{ "SELWIDE",		0x02, 0x02 },
@@ -458,68 +215,6 @@ ahc_sblkctl_print(u_int regvalue, u_int 
 	    0x1f, regvalue, cur_col, wrap));
 }
 
-int
-ahc_busy_targets_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "BUSY_TARGETS",
-	    0x20, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ultra_enb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "ULTRA_ENB",
-	    0x30, regvalue, cur_col, wrap));
-}
-
-int
-ahc_disc_dsb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DISC_DSB",
-	    0x32, regvalue, cur_col, wrap));
-}
-
-int
-ahc_mwi_residual_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "MWI_RESIDUAL",
-	    0x38, regvalue, cur_col, wrap));
-}
-
-int
-ahc_next_queued_scb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "NEXT_QUEUED_SCB",
-	    0x39, regvalue, cur_col, wrap));
-}
-
-int
-ahc_msg_out_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "MSG_OUT",
-	    0x3a, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t DMAPARAMS_parse_table[] = {
-	{ "FIFORESET",		0x01, 0x01 },
-	{ "FIFOFLUSH",		0x02, 0x02 },
-	{ "DIRECTION",		0x04, 0x04 },
-	{ "HDMAEN",		0x08, 0x08 },
-	{ "HDMAENACK",		0x08, 0x08 },
-	{ "SDMAEN",		0x10, 0x10 },
-	{ "SDMAENACK",		0x10, 0x10 },
-	{ "SCSIEN",		0x20, 0x20 },
-	{ "WIDEODD",		0x40, 0x40 },
-	{ "PRELOADEN",		0x80, 0x80 }
-};
-
-int
-ahc_dmaparams_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DMAPARAMS_parse_table, 10, "DMAPARAMS",
-	    0x3b, regvalue, cur_col, wrap));
-}
-
 static const ahc_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
 	{ "NO_DISCONNECT",	0x01, 0x01 },
 	{ "SPHASE_PENDING",	0x02, 0x02 },
@@ -539,20 +234,6 @@ ahc_seq_flags_print(u_int regvalue, u_in
 	    0x3c, regvalue, cur_col, wrap));
 }
 
-int
-ahc_saved_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SAVED_SCSIID",
-	    0x3d, regvalue, cur_col, wrap));
-}
-
-int
-ahc_saved_lun_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SAVED_LUN",
-	    0x3e, regvalue, cur_col, wrap));
-}
-
 static const ahc_reg_parse_entry_t LASTPHASE_parse_table[] = {
 	{ "MSGI",		0x20, 0x20 },
 	{ "IOI",		0x40, 0x40 },
@@ -574,721 +255,120 @@ ahc_lastphase_print(u_int regvalue, u_in
 	    0x3f, regvalue, cur_col, wrap));
 }
 
-int
-ahc_waiting_scbh_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "WAITING_SCBH",
-	    0x40, regvalue, cur_col, wrap));
-}
-
-int
-ahc_disconnected_scbh_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DISCONNECTED_SCBH",
-	    0x41, regvalue, cur_col, wrap));
-}
+static const ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
+	{ "LOADRAM",		0x01, 0x01 },
+	{ "SEQRESET",		0x02, 0x02 },
+	{ "STEP",		0x04, 0x04 },
+	{ "BRKADRINTEN",	0x08, 0x08 },
+	{ "FASTMODE",		0x10, 0x10 },
+	{ "FAILDIS",		0x20, 0x20 },
+	{ "PAUSEDIS",		0x40, 0x40 },
+	{ "PERRORDIS",		0x80, 0x80 }
+};
 
 int
-ahc_free_scbh_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahc_seqctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahc_print_register(NULL, 0, "FREE_SCBH",
-	    0x42, regvalue, cur_col, wrap));
+	return (ahc_print_register(SEQCTL_parse_table, 8, "SEQCTL",
+	    0x60, regvalue, cur_col, wrap));
 }
 
 int
-ahc_hscb_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahc_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahc_print_register(NULL, 0, "HSCB_ADDR",
-	    0x44, regvalue, cur_col, wrap));
+	return (ahc_print_register(NULL, 0, "SRAM_BASE",
+	    0x70, regvalue, cur_col, wrap));
 }
 
-int
-ahc_shared_data_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SHARED_DATA_ADDR",
-	    0x48, regvalue, cur_col, wrap));
-}
+static const ahc_reg_parse_entry_t ERROR_parse_table[] = {
+	{ "ILLHADDR",		0x01, 0x01 },
+	{ "ILLSADDR",		0x02, 0x02 },
+	{ "ILLOPCODE",		0x04, 0x04 },
+	{ "SQPARERR",		0x08, 0x08 },
+	{ "DPARERR",		0x10, 0x10 },
+	{ "MPARERR",		0x20, 0x20 },
+	{ "PCIERRSTAT",		0x40, 0x40 },
+	{ "CIOPARERR",		0x80, 0x80 }
+};
 
 int
-ahc_kernel_qinpos_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahc_error_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahc_print_register(NULL, 0, "KERNEL_QINPOS",
-	    0x4c, regvalue, cur_col, wrap));
+	return (ahc_print_register(ERROR_parse_table, 8, "ERROR",
+	    0x92, regvalue, cur_col, wrap));
 }
 
-int
-ahc_qinpos_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "QINPOS",
-	    0x4d, regvalue, cur_col, wrap));
-}
+static const ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
+	{ "FIFORESET",		0x01, 0x01 },
+	{ "FIFOFLUSH",		0x02, 0x02 },
+	{ "DIRECTION",		0x04, 0x04 },
+	{ "HDMAEN",		0x08, 0x08 },
+	{ "HDMAENACK",		0x08, 0x08 },
+	{ "SDMAEN",		0x10, 0x10 },
+	{ "SDMAENACK",		0x10, 0x10 },
+	{ "SCSIEN",		0x20, 0x20 },
+	{ "WIDEODD",		0x40, 0x40 },
+	{ "PRELOADEN",		0x80, 0x80 }
+};
 
 int
-ahc_qoutpos_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahc_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahc_print_register(NULL, 0, "QOUTPOS",
-	    0x4e, regvalue, cur_col, wrap));
+	return (ahc_print_register(DFCNTRL_parse_table, 10, "DFCNTRL",
+	    0x93, regvalue, cur_col, wrap));
 }
 
-int
-ahc_kernel_tqinpos_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "KERNEL_TQINPOS",
-	    0x4f, regvalue, cur_col, wrap));
-}
+static const ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
+	{ "FIFOEMP",		0x01, 0x01 },
+	{ "FIFOFULL",		0x02, 0x02 },
+	{ "DFTHRESH",		0x04, 0x04 },
+	{ "HDONE",		0x08, 0x08 },
+	{ "MREQPEND",		0x10, 0x10 },
+	{ "FIFOQWDEMP",		0x20, 0x20 },
+	{ "DFCACHETH",		0x40, 0x40 },
+	{ "PRELOAD_AVAIL",	0x80, 0x80 }
+};
 
 int
-ahc_tqinpos_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahc_dfstatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahc_print_register(NULL, 0, "TQINPOS",
-	    0x50, regvalue, cur_col, wrap));
+	return (ahc_print_register(DFSTATUS_parse_table, 8, "DFSTATUS",
+	    0x94, regvalue, cur_col, wrap));
 }
 
-static const ahc_reg_parse_entry_t ARG_1_parse_table[] = {
-	{ "CONT_TARG_SESSION",	0x02, 0x02 },
-	{ "CONT_MSG_LOOP",	0x04, 0x04 },
-	{ "EXIT_MSG_LOOP",	0x08, 0x08 },
-	{ "MSGOUT_PHASEMIS",	0x10, 0x10 },
-	{ "SEND_REJ",		0x20, 0x20 },
-	{ "SEND_SENSE",		0x40, 0x40 },
-	{ "SEND_MSG",		0x80, 0x80 }
+static const ahc_reg_parse_entry_t SCSIPHASE_parse_table[] = {
+	{ "DATA_OUT_PHASE",	0x01, 0x01 },
+	{ "DATA_IN_PHASE",	0x02, 0x02 },
+	{ "MSG_OUT_PHASE",	0x04, 0x04 },
+	{ "MSG_IN_PHASE",	0x08, 0x08 },
+	{ "COMMAND_PHASE",	0x10, 0x10 },
+	{ "STATUS_PHASE",	0x20, 0x20 },
+	{ "DATA_PHASE_MASK",	0x03, 0x03 }
 };
 
 int
-ahc_arg_1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(ARG_1_parse_table, 7, "ARG_1",
-	    0x51, regvalue, cur_col, wrap));
-}
-
-int
-ahc_arg_2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahc_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahc_print_register(NULL, 0, "ARG_2",
-	    0x52, regvalue, cur_col, wrap));
+	return (ahc_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
+	    0x9e, regvalue, cur_col, wrap));
 }
 
 int
-ahc_last_msg_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahc_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahc_print_register(NULL, 0, "LAST_MSG",
-	    0x53, regvalue, cur_col, wrap));
+	return (ahc_print_register(NULL, 0, "SCB_BASE",
+	    0xa0, regvalue, cur_col, wrap));
 }
 
-static const ahc_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
-	{ "ENAUTOATNP",		0x02, 0x02 },
-	{ "ENAUTOATNI",		0x04, 0x04 },
-	{ "ENAUTOATNO",		0x08, 0x08 },
-	{ "ENRSELI",		0x10, 0x10 },
-	{ "ENSELI",		0x20, 0x20 },
-	{ "ENSELO",		0x40, 0x40 }
-};
-
-int
-ahc_scsiseq_template_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSISEQ_TEMPLATE_parse_table, 6, "SCSISEQ_TEMPLATE",
-	    0x54, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t HA_274_BIOSGLOBAL_parse_table[] = {
-	{ "HA_274_EXTENDED_TRANS",0x01, 0x01 }
-};
-
-int
-ahc_ha_274_biosglobal_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(HA_274_BIOSGLOBAL_parse_table, 1, "HA_274_BIOSGLOBAL",
-	    0x56, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
-	{ "SCB_DMA",		0x01, 0x01 },
-	{ "TARGET_MSG_PENDING",	0x02, 0x02 }
-};
-
-int
-ahc_seq_flags2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEQ_FLAGS2_parse_table, 2, "SEQ_FLAGS2",
-	    0x57, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SCSICONF_parse_table[] = {
-	{ "ENSPCHK",		0x20, 0x20 },
-	{ "RESET_SCSI",		0x40, 0x40 },
-	{ "TERM_ENB",		0x80, 0x80 },
-	{ "HSCSIID",		0x07, 0x07 },
-	{ "HWSCSIID",		0x0f, 0x0f }
-};
-
-int
-ahc_scsiconf_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSICONF_parse_table, 5, "SCSICONF",
-	    0x5a, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t INTDEF_parse_table[] = {
-	{ "EDGE_TRIG",		0x80, 0x80 },
-	{ "VECTOR",		0x0f, 0x0f }
-};
-
-int
-ahc_intdef_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(INTDEF_parse_table, 2, "INTDEF",
-	    0x5c, regvalue, cur_col, wrap));
-}
-
-int
-ahc_hostconf_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "HOSTCONF",
-	    0x5d, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t HA_274_BIOSCTRL_parse_table[] = {
-	{ "CHANNEL_B_PRIMARY",	0x08, 0x08 },
-	{ "BIOSMODE",		0x30, 0x30 },
-	{ "BIOSDISABLED",	0x30, 0x30 }
-};
-
-int
-ahc_ha_274_biosctrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(HA_274_BIOSCTRL_parse_table, 3, "HA_274_BIOSCTRL",
-	    0x5f, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
-	{ "LOADRAM",		0x01, 0x01 },
-	{ "SEQRESET",		0x02, 0x02 },
-	{ "STEP",		0x04, 0x04 },
-	{ "BRKADRINTEN",	0x08, 0x08 },
-	{ "FASTMODE",		0x10, 0x10 },
-	{ "FAILDIS",		0x20, 0x20 },
-	{ "PAUSEDIS",		0x40, 0x40 },
-	{ "PERRORDIS",		0x80, 0x80 }
-};
-
-int
-ahc_seqctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEQCTL_parse_table, 8, "SEQCTL",
-	    0x60, regvalue, cur_col, wrap));
-}
-
-int
-ahc_seqram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SEQRAM",
-	    0x61, regvalue, cur_col, wrap));
-}
-
-int
-ahc_seqaddr0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SEQADDR0",
-	    0x62, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SEQADDR1_parse_table[] = {
-	{ "SEQADDR1_MASK",	0x01, 0x01 }
-};
-
-int
-ahc_seqaddr1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEQADDR1_parse_table, 1, "SEQADDR1",
-	    0x63, regvalue, cur_col, wrap));
-}
-
-int
-ahc_accum_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "ACCUM",
-	    0x64, regvalue, cur_col, wrap));
-}
-
-int
-ahc_sindex_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SINDEX",
-	    0x65, regvalue, cur_col, wrap));
-}
-
-int
-ahc_dindex_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DINDEX",
-	    0x66, regvalue, cur_col, wrap));
-}
-
-int
-ahc_allones_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "ALLONES",
-	    0x69, regvalue, cur_col, wrap));
-}
-
-int
-ahc_allzeros_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "ALLZEROS",
-	    0x6a, regvalue, cur_col, wrap));
-}
-
-int
-ahc_none_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "NONE",
-	    0x6a, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t FLAGS_parse_table[] = {
-	{ "CARRY",		0x01, 0x01 },
-	{ "ZERO",		0x02, 0x02 }
-};
-
-int
-ahc_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(FLAGS_parse_table, 2, "FLAGS",
-	    0x6b, regvalue, cur_col, wrap));
-}
-
-int
-ahc_sindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SINDIR",
-	    0x6c, regvalue, cur_col, wrap));
-}
-
-int
-ahc_dindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DINDIR",
-	    0x6d, regvalue, cur_col, wrap));
-}
-
-int
-ahc_stack_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "STACK",
-	    0x6f, regvalue, cur_col, wrap));
-}
-
-int
-ahc_targ_offset_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "TARG_OFFSET",
-	    0x70, regvalue, cur_col, wrap));
-}
-
-int
-ahc_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SRAM_BASE",
-	    0x70, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
-	{ "CIOPARCKEN",		0x01, 0x01 },
-	{ "USCBSIZE32",		0x02, 0x02 },
-	{ "RAMPS",		0x04, 0x04 },
-	{ "INTSCBRAMSEL",	0x08, 0x08 },
-	{ "EXTREQLCK",		0x10, 0x10 },
-	{ "MPARCKEN",		0x20, 0x20 },
-	{ "DPARCKEN",		0x40, 0x40 },
-	{ "CACHETHEN",		0x80, 0x80 }
-};
-
-int
-ahc_dscommand0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DSCOMMAND0_parse_table, 8, "DSCOMMAND0",
-	    0x84, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t BUSTIME_parse_table[] = {
-	{ "BON",		0x0f, 0x0f },
-	{ "BOFF",		0xf0, 0xf0 }
-};
-
-int
-ahc_bustime_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(BUSTIME_parse_table, 2, "BUSTIME",
-	    0x85, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t DSCOMMAND1_parse_table[] = {
-	{ "HADDLDSEL0",		0x01, 0x01 },
-	{ "HADDLDSEL1",		0x02, 0x02 },
-	{ "DSLATT",		0xfc, 0xfc }
-};
-
-int
-ahc_dscommand1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DSCOMMAND1_parse_table, 3, "DSCOMMAND1",
-	    0x85, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t BUSSPD_parse_table[] = {
-	{ "STBON",		0x07, 0x07 },
-	{ "STBOFF",		0x38, 0x38 },
-	{ "DFTHRSH_75",		0x80, 0x80 },
-	{ "DFTHRSH",		0xc0, 0xc0 },
-	{ "DFTHRSH_100",	0xc0, 0xc0 }
-};
-
-int
-ahc_busspd_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(BUSSPD_parse_table, 5, "BUSSPD",
-	    0x86, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
-	{ "SEQ_MAILBOX",	0x0f, 0x0f },
-	{ "HOST_TQINPOS",	0x80, 0x80 },
-	{ "HOST_MAILBOX",	0xf0, 0xf0 }
-};
-
-int
-ahc_hs_mailbox_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(HS_MAILBOX_parse_table, 3, "HS_MAILBOX",
-	    0x86, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t DSPCISTATUS_parse_table[] = {
-	{ "DFTHRSH_100",	0xc0, 0xc0 }
-};
-
-int
-ahc_dspcistatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DSPCISTATUS_parse_table, 1, "DSPCISTATUS",
-	    0x86, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t HCNTRL_parse_table[] = {
-	{ "CHIPRST",		0x01, 0x01 },
-	{ "CHIPRSTACK",		0x01, 0x01 },
-	{ "INTEN",		0x02, 0x02 },
-	{ "PAUSE",		0x04, 0x04 },
-	{ "IRQMS",		0x08, 0x08 },
-	{ "SWINT",		0x10, 0x10 },
-	{ "POWRDN",		0x40, 0x40 }
-};
-
-int
-ahc_hcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(HCNTRL_parse_table, 7, "HCNTRL",
-	    0x87, regvalue, cur_col, wrap));
-}
-
-int
-ahc_haddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "HADDR",
-	    0x88, regvalue, cur_col, wrap));
-}
-
-int
-ahc_hcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "HCNT",
-	    0x8c, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCBPTR",
-	    0x90, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t INTSTAT_parse_table[] = {
-	{ "SEQINT",		0x01, 0x01 },
-	{ "CMDCMPLT",		0x02, 0x02 },
-	{ "SCSIINT",		0x04, 0x04 },
-	{ "BRKADRINT",		0x08, 0x08 },
-	{ "BAD_PHASE",		0x01, 0x01 },
-	{ "INT_PEND",		0x0f, 0x0f },
-	{ "SEND_REJECT",	0x11, 0x11 },
-	{ "PROTO_VIOLATION",	0x21, 0x21 },
-	{ "NO_MATCH",		0x31, 0x31 },
-	{ "IGN_WIDE_RES",	0x41, 0x41 },
-	{ "PDATA_REINIT",	0x51, 0x51 },
-	{ "HOST_MSG_LOOP",	0x61, 0x61 },
-	{ "BAD_STATUS",		0x71, 0x71 },
-	{ "PERR_DETECTED",	0x81, 0x81 },
-	{ "DATA_OVERRUN",	0x91, 0x91 },
-	{ "MKMSG_FAILED",	0xa1, 0xa1 },
-	{ "MISSED_BUSFREE",	0xb1, 0xb1 },
-	{ "SCB_MISMATCH",	0xc1, 0xc1 },
-	{ "NO_FREE_SCB",	0xd1, 0xd1 },
-	{ "OUT_OF_RANGE",	0xe1, 0xe1 },
-	{ "SEQINT_MASK",	0xf1, 0xf1 }
-};
-
-int
-ahc_intstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(INTSTAT_parse_table, 21, "INTSTAT",
-	    0x91, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t CLRINT_parse_table[] = {
-	{ "CLRSEQINT",		0x01, 0x01 },
-	{ "CLRCMDINT",		0x02, 0x02 },
-	{ "CLRSCSIINT",		0x04, 0x04 },
-	{ "CLRBRKADRINT",	0x08, 0x08 },
-	{ "CLRPARERR",		0x10, 0x10 }
-};
-
-int
-ahc_clrint_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CLRINT_parse_table, 5, "CLRINT",
-	    0x92, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t ERROR_parse_table[] = {
-	{ "ILLHADDR",		0x01, 0x01 },
-	{ "ILLSADDR",		0x02, 0x02 },
-	{ "ILLOPCODE",		0x04, 0x04 },
-	{ "SQPARERR",		0x08, 0x08 },
-	{ "DPARERR",		0x10, 0x10 },
-	{ "MPARERR",		0x20, 0x20 },
-	{ "PCIERRSTAT",		0x40, 0x40 },
-	{ "CIOPARERR",		0x80, 0x80 }
-};
-
-int
-ahc_error_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(ERROR_parse_table, 8, "ERROR",
-	    0x92, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
-	{ "FIFORESET",		0x01, 0x01 },
-	{ "FIFOFLUSH",		0x02, 0x02 },
-	{ "DIRECTION",		0x04, 0x04 },
-	{ "HDMAEN",		0x08, 0x08 },
-	{ "HDMAENACK",		0x08, 0x08 },
-	{ "SDMAEN",		0x10, 0x10 },
-	{ "SDMAENACK",		0x10, 0x10 },
-	{ "SCSIEN",		0x20, 0x20 },
-	{ "WIDEODD",		0x40, 0x40 },
-	{ "PRELOADEN",		0x80, 0x80 }
-};
-
-int
-ahc_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DFCNTRL_parse_table, 10, "DFCNTRL",
-	    0x93, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
-	{ "FIFOEMP",		0x01, 0x01 },
-	{ "FIFOFULL",		0x02, 0x02 },
-	{ "DFTHRESH",		0x04, 0x04 },
-	{ "HDONE",		0x08, 0x08 },
-	{ "MREQPEND",		0x10, 0x10 },
-	{ "FIFOQWDEMP",		0x20, 0x20 },
-	{ "DFCACHETH",		0x40, 0x40 },
-	{ "PRELOAD_AVAIL",	0x80, 0x80 }
-};
-
-int
-ahc_dfstatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DFSTATUS_parse_table, 8, "DFSTATUS",
-	    0x94, regvalue, cur_col, wrap));
-}
-
-int
-ahc_dfwaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DFWADDR",
-	    0x95, regvalue, cur_col, wrap));
-}
-
-int
-ahc_dfdat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DFDAT",
-	    0x99, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SCBCNT_parse_table[] = {
-	{ "SCBAUTO",		0x80, 0x80 },
-	{ "SCBCNT_MASK",	0x1f, 0x1f }
-};
-
-int
-ahc_scbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCBCNT_parse_table, 2, "SCBCNT",
-	    0x9a, regvalue, cur_col, wrap));
-}
-
-int
-ahc_qinfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "QINFIFO",
-	    0x9b, regvalue, cur_col, wrap));
-}
-
-int
-ahc_qoutfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "QOUTFIFO",
-	    0x9d, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t CRCCONTROL1_parse_table[] = {
-	{ "TARGCRCCNTEN",	0x04, 0x04 },
-	{ "TARGCRCENDEN",	0x08, 0x08 },
-	{ "CRCREQCHKEN",	0x10, 0x10 },
-	{ "CRCENDCHKEN",	0x20, 0x20 },
-	{ "CRCVALCHKEN",	0x40, 0x40 },
-	{ "CRCONSEEN",		0x80, 0x80 }
-};
-
-int
-ahc_crccontrol1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CRCCONTROL1_parse_table, 6, "CRCCONTROL1",
-	    0x9d, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SCSIPHASE_parse_table[] = {
-	{ "DATA_OUT_PHASE",	0x01, 0x01 },
-	{ "DATA_IN_PHASE",	0x02, 0x02 },
-	{ "MSG_OUT_PHASE",	0x04, 0x04 },
-	{ "MSG_IN_PHASE",	0x08, 0x08 },
-	{ "COMMAND_PHASE",	0x10, 0x10 },
-	{ "STATUS_PHASE",	0x20, 0x20 },
-	{ "DATA_PHASE_MASK",	0x03, 0x03 }
-};
-
-int
-ahc_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
-	    0x9e, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SFUNCT_parse_table[] = {
-	{ "ALT_MODE",		0x80, 0x80 }
-};
-
-int
-ahc_sfunct_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SFUNCT_parse_table, 1, "SFUNCT",
-	    0x9f, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_BASE",
-	    0xa0, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_cdb_ptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_CDB_PTR",
-	    0xa0, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_residual_sgptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_RESIDUAL_SGPTR",
-	    0xa4, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_scsi_status_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_SCSI_STATUS",
-	    0xa8, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_target_phases_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_TARGET_PHASES",
-	    0xa9, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_target_data_dir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_TARGET_DATA_DIR",
-	    0xaa, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_target_itag_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_TARGET_ITAG",
-	    0xab, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_dataptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_DATAPTR",
-	    0xac, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
-	{ "SG_LAST_SEG",	0x80, 0x80 },
-	{ "SG_HIGH_ADDR_BITS",	0x7f, 0x7f }
-};
-
-int
-ahc_scb_datacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCB_DATACNT_parse_table, 2, "SCB_DATACNT",
-	    0xb0, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
-	{ "SG_LIST_NULL",	0x01, 0x01 },
-	{ "SG_FULL_RESID",	0x02, 0x02 },
-	{ "SG_RESID_VALID",	0x04, 0x04 }
-};
-
-int
-ahc_scb_sgptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCB_SGPTR_parse_table, 3, "SCB_SGPTR",
-	    0xb4, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
-	{ "DISCONNECTED",	0x04, 0x04 },
-	{ "ULTRAENB",		0x08, 0x08 },
-	{ "MK_MESSAGE",		0x10, 0x10 },
-	{ "TAG_ENB",		0x20, 0x20 },
-	{ "DISCENB",		0x40, 0x40 },
-	{ "TARGET_SCB",		0x80, 0x80 },
-	{ "STATUS_RCVD",	0x80, 0x80 },
-	{ "SCB_TAG_TYPE",	0x03, 0x03 }
+static const ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+	{ "DISCONNECTED",	0x04, 0x04 },
+	{ "ULTRAENB",		0x08, 0x08 },
+	{ "MK_MESSAGE",		0x10, 0x10 },
+	{ "TAG_ENB",		0x20, 0x20 },
+	{ "DISCENB",		0x40, 0x40 },
+	{ "TARGET_SCB",		0x80, 0x80 },
+	{ "STATUS_RCVD",	0x80, 0x80 },
+	{ "SCB_TAG_TYPE",	0x03, 0x03 }
 };
 
 int
@@ -1331,248 +411,3 @@ ahc_scb_tag_print(u_int regvalue, u_int 
 	    0xbb, regvalue, cur_col, wrap));
 }
 
-int
-ahc_scb_cdb_len_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_CDB_LEN",
-	    0xbc, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_scsirate_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_SCSIRATE",
-	    0xbd, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_scsioffset_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_SCSIOFFSET",
-	    0xbe, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_next_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_NEXT",
-	    0xbf, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SEECTL_2840_parse_table[] = {
-	{ "DO_2840",		0x01, 0x01 },
-	{ "CK_2840",		0x02, 0x02 },
-	{ "CS_2840",		0x04, 0x04 }
-};
-
-int
-ahc_seectl_2840_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEECTL_2840_parse_table, 3, "SEECTL_2840",
-	    0xc0, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t STATUS_2840_parse_table[] = {
-	{ "DI_2840",		0x01, 0x01 },
-	{ "EEPROM_TF",		0x80, 0x80 },
-	{ "ADSEL",		0x1e, 0x1e },
-	{ "BIOS_SEL",		0x60, 0x60 }
-};
-
-int
-ahc_status_2840_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(STATUS_2840_parse_table, 4, "STATUS_2840",
-	    0xc1, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scb_64_btt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_64_BTT",
-	    0xd0, regvalue, cur_col, wrap));
-}
-
-int
-ahc_cchaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCHADDR",
-	    0xe0, regvalue, cur_col, wrap));
-}
-
-int
-ahc_cchcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCHCNT",
-	    0xe8, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccsgram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSGRAM",
-	    0xe9, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccsgaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSGADDR",
-	    0xea, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t CCSGCTL_parse_table[] = {
-	{ "CCSGRESET",		0x01, 0x01 },
-	{ "SG_FETCH_NEEDED",	0x02, 0x02 },
-	{ "CCSGEN",		0x08, 0x08 },
-	{ "CCSGDONE",		0x80, 0x80 }
-};
-
-int
-ahc_ccsgctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CCSGCTL_parse_table, 4, "CCSGCTL",
-	    0xeb, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccscbram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSCBRAM",
-	    0xec, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccscbaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSCBADDR",
-	    0xed, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t CCSCBCTL_parse_table[] = {
-	{ "CCSCBRESET",		0x01, 0x01 },
-	{ "CCSCBDIR",		0x04, 0x04 },
-	{ "CCSCBEN",		0x08, 0x08 },
-	{ "CCARREN",		0x10, 0x10 },
-	{ "ARRDONE",		0x40, 0x40 },
-	{ "CCSCBDONE",		0x80, 0x80 }
-};
-
-int
-ahc_ccscbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CCSCBCTL_parse_table, 6, "CCSCBCTL",
-	    0xee, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccscbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSCBCNT",
-	    0xef, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scbbaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCBBADDR",
-	    0xf0, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccscbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSCBPTR",
-	    0xf1, regvalue, cur_col, wrap));
-}
-
-int
-ahc_hnscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "HNSCB_QOFF",
-	    0xf4, regvalue, cur_col, wrap));
-}
-
-int
-ahc_snscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SNSCB_QOFF",
-	    0xf6, regvalue, cur_col, wrap));
-}
-
-int
-ahc_sdscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SDSCB_QOFF",
-	    0xf8, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
-	{ "SDSCB_ROLLOVER",	0x10, 0x10 },
-	{ "SNSCB_ROLLOVER",	0x20, 0x20 },
-	{ "SCB_AVAIL",		0x40, 0x40 },
-	{ "SCB_QSIZE_256",	0x06, 0x06 },
-	{ "SCB_QSIZE",		0x07, 0x07 }
-};
-
-int
-ahc_qoff_ctlsta_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(QOFF_CTLSTA_parse_table, 5, "QOFF_CTLSTA",
-	    0xfa, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t DFF_THRSH_parse_table[] = {
-	{ "RD_DFTHRSH_MIN",	0x00, 0x00 },
-	{ "WR_DFTHRSH_MIN",	0x00, 0x00 },
-	{ "RD_DFTHRSH_25",	0x01, 0x01 },
-	{ "RD_DFTHRSH_50",	0x02, 0x02 },
-	{ "RD_DFTHRSH_63",	0x03, 0x03 },
-	{ "RD_DFTHRSH_75",	0x04, 0x04 },
-	{ "RD_DFTHRSH_85",	0x05, 0x05 },
-	{ "RD_DFTHRSH_90",	0x06, 0x06 },
-	{ "RD_DFTHRSH",		0x07, 0x07 },
-	{ "RD_DFTHRSH_MAX",	0x07, 0x07 },
-	{ "WR_DFTHRSH_25",	0x10, 0x10 },
-	{ "WR_DFTHRSH_50",	0x20, 0x20 },
-	{ "WR_DFTHRSH_63",	0x30, 0x30 },
-	{ "WR_DFTHRSH_75",	0x40, 0x40 },
-	{ "WR_DFTHRSH_85",	0x50, 0x50 },
-	{ "WR_DFTHRSH_90",	0x60, 0x60 },
-	{ "WR_DFTHRSH",		0x70, 0x70 },
-	{ "WR_DFTHRSH_MAX",	0x70, 0x70 }
-};
-
-int
-ahc_dff_thrsh_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DFF_THRSH_parse_table, 18, "DFF_THRSH",
-	    0xfb, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
-	{ "LAST_SEG_DONE",	0x01, 0x01 },
-	{ "LAST_SEG",		0x02, 0x02 },
-	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
-};
-
-int
-ahc_sg_cache_shadow_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SG_CACHE_SHADOW_parse_table, 3, "SG_CACHE_SHADOW",
-	    0xfc, regvalue, cur_col, wrap));
-}
-
-static const ahc_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
-	{ "LAST_SEG_DONE",	0x01, 0x01 },
-	{ "LAST_SEG",		0x02, 0x02 },
-	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
-};
-
-int
-ahc_sg_cache_pre_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SG_CACHE_PRE_parse_table, 3, "SG_CACHE_PRE",
-	    0xfc, regvalue, cur_col, wrap));
-}
-
_
