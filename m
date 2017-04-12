From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 13/17] cxlflash: Fix warnings/errors
Date: Wed, 12 Apr 2017 14:15:20 -0500
Message-ID: <1492024520-56101-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44607 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752643AbdDLTPi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:15:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ99es131865
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:37 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29spb4415u-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:37 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:15:36 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

As a general cleanup, address all reasonable checkpatch warnings and
errors. These include enforcement of comment styles and including named
identifiers in function prototypes.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h    | 27 ++++++++++-----------
 drivers/scsi/cxlflash/sislite.h   | 27 +++++++++++----------
 drivers/scsi/cxlflash/superpipe.h | 51 ++++++++++++++++++++++-----------------
 drivers/scsi/cxlflash/vlun.h      |  2 +-
 4 files changed, 57 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 455fd4d..c69cdcf 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -36,20 +36,19 @@ extern const struct file_operations cxlflash_cxl_fops;
 #define PORTMASK2CHAN(_x)	(ilog2((_x)))	/* port mask to channel */
 #define PORTNUM2CHAN(_x)	((_x) - 1)	/* port number to channel */
 
-#define CXLFLASH_BLOCK_SIZE	4096	/* 4K blocks */
+#define CXLFLASH_BLOCK_SIZE	4096		/* 4K blocks */
 #define CXLFLASH_MAX_XFER_SIZE	16777216	/* 16MB transfer */
 #define CXLFLASH_MAX_SECTORS	(CXLFLASH_MAX_XFER_SIZE/512)	/* SCSI wants
-								   max_sectors
-								   in units of
-								   512 byte
-								   sectors
-								*/
+								 * max_sectors
+								 * in units of
+								 * 512 byte
+								 * sectors
+								 */
 
 #define MAX_RHT_PER_CONTEXT (PAGE_SIZE / sizeof(struct sisl_rht_entry))
 
 /* AFU command retry limit */
-#define MC_RETRY_CNT         5	/* sufficient for SCSI check and
-				   certain AFU errors */
+#define MC_RETRY_CNT	5	/* Sufficient for SCSI and certain AFU errors */
 
 /* Command management definitions */
 #define CXLFLASH_MAX_CMDS               256
@@ -262,14 +261,14 @@ static inline __be64 __iomem *get_fc_port_luns(struct cxlflash_cfg *cfg, int i)
 	return &fcpb->fc_port_luns[CHAN2BANKPORT(i)][0];
 }
 
-int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
+int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t c, res_hndl_t r, u8 mode);
 void cxlflash_list_init(void);
 void cxlflash_term_global_luns(void);
 void cxlflash_free_errpage(void);
-int cxlflash_ioctl(struct scsi_device *, int, void __user *);
-void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *);
-int cxlflash_mark_contexts_error(struct cxlflash_cfg *);
-void cxlflash_term_local_luns(struct cxlflash_cfg *);
-void cxlflash_restore_luntable(struct cxlflash_cfg *);
+int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg);
+void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg);
+int cxlflash_mark_contexts_error(struct cxlflash_cfg *cfg);
+void cxlflash_term_local_luns(struct cxlflash_cfg *cfg);
+void cxlflash_restore_luntable(struct cxlflash_cfg *cfg);
 
 #endif /* ifndef _CXLFLASH_COMMON_H */
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index 0e52bbb..a768360 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -90,15 +90,15 @@ struct sisl_rc {
 #define SISL_AFU_RC_RHT_UNALIGNED         0x02U	/* should never happen */
 #define SISL_AFU_RC_RHT_OUT_OF_BOUNDS     0x03u	/* user error */
 #define SISL_AFU_RC_RHT_DMA_ERR           0x04u	/* see afu_extra
-						   may retry if afu_retry is off
-						   possible on master exit
+						 * may retry if afu_retry is off
+						 * possible on master exit
 						 */
 #define SISL_AFU_RC_RHT_RW_PERM           0x05u	/* no RW perms, user error */
 #define SISL_AFU_RC_LXT_UNALIGNED         0x12U	/* should never happen */
 #define SISL_AFU_RC_LXT_OUT_OF_BOUNDS     0x13u	/* user error */
 #define SISL_AFU_RC_LXT_DMA_ERR           0x14u	/* see afu_extra
-						   may retry if afu_retry is off
-						   possible on master exit
+						 * may retry if afu_retry is off
+						 * possible on master exit
 						 */
 #define SISL_AFU_RC_LXT_RW_PERM           0x15u	/* no RW perms, user error */
 
@@ -111,11 +111,11 @@ struct sisl_rc {
 	 */
 #define SISL_AFU_RC_NO_CHANNELS           0x20U	/* see afu_extra, may retry */
 #define SISL_AFU_RC_CAP_VIOLATION         0x21U	/* either user error or
-						   afu reset/master restart
+						 * afu reset/master restart
 						 */
 #define SISL_AFU_RC_OUT_OF_DATA_BUFS      0x30U	/* always retry */
 #define SISL_AFU_RC_DATA_DMA_ERR          0x31U	/* see afu_extra
-						   may retry if afu_retry is off
+						 * may retry if afu_retry is off
 						 */
 
 	u8 scsi_rc;		/* SCSI status byte, retry as appropriate */
@@ -149,8 +149,9 @@ struct sisl_rc {
 #define SISL_FC_RC_ABORTFAIL	0x59	/* pending abort completed w/fail */
 #define SISL_FC_RC_RESID	0x5A	/* ioasa underrun/overrun flags set */
 #define SISL_FC_RC_RESIDERR	0x5B	/* actual data len does not match SCSI
-					   reported len, possibly due to dropped
-					   frames */
+					 * reported len, possibly due to dropped
+					 * frames
+					 */
 #define SISL_FC_RC_TGTABORT	0x5C	/* command aborted by target */
 };
 
@@ -227,10 +228,10 @@ struct sisl_ioasa {
 
 /* per context host transport MMIO  */
 struct sisl_host_map {
-	__be64 endian_ctrl;     /* Per context Endian Control. The AFU will
-			      * operate on whatever the context is of the
-			      * host application.
-			      */
+	__be64 endian_ctrl;	/* Per context Endian Control. The AFU will
+				 * operate on whatever the context is of the
+				 * host application.
+				 */
 
 	__be64 intr_status;	/* this sends LISN# programmed in ctx_ctrl.
 				 * Only recovery in a PERM_ERR is a context
@@ -435,7 +436,7 @@ struct sisl_global_map {
  *	|         64 KB Global          |
  *	|   Trusted Process accessible  |
  *	+-------------------------------+
-*/
+ */
 struct cxlflash_afu_map {
 	union {
 		struct sisl_host_map host;
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 8269ff8..0b59768 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -24,8 +24,8 @@ extern struct cxlflash_global global;
  */
 
 /* Chunk size parms: note sislite minimum chunk size is
-   0x10000 LBAs corresponding to a NMASK or 16.
-*/
+ * 0x10000 LBAs corresponding to a NMASK or 16.
+ */
 #define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs */
 
 #define CMD_TIMEOUT 30  /* 30 secs */
@@ -89,7 +89,8 @@ enum ctx_ctrl {
 struct ctx_info {
 	struct sisl_ctrl_map __iomem *ctrl_map; /* initialized at startup */
 	struct sisl_rht_entry *rht_start; /* 1 page (req'd for alignment),
-					     alloc/free on attach/detach */
+					   * alloc/free on attach/detach
+					   */
 	u32 rht_out;		/* Number of checked out RHT entries */
 	u32 rht_perms;		/* User-defined permissions for RHT entries */
 	struct llun_info **rht_lun;       /* Mapping of RHT entries to LUNs */
@@ -117,34 +118,40 @@ struct cxlflash_global {
 	struct page *err_page; /* One page of all 0xF for error notification */
 };
 
-int cxlflash_vlun_resize(struct scsi_device *, struct dk_cxlflash_resize *);
-int _cxlflash_vlun_resize(struct scsi_device *, struct ctx_info *,
-			  struct dk_cxlflash_resize *);
+int cxlflash_vlun_resize(struct scsi_device *sdev,
+			 struct dk_cxlflash_resize *resize);
+int _cxlflash_vlun_resize(struct scsi_device *sdev, struct ctx_info *ctxi,
+			  struct dk_cxlflash_resize *resize);
 
-int cxlflash_disk_release(struct scsi_device *, struct dk_cxlflash_release *);
-int _cxlflash_disk_release(struct scsi_device *, struct ctx_info *,
-			   struct dk_cxlflash_release *);
+int cxlflash_disk_release(struct scsi_device *sdev,
+			  struct dk_cxlflash_release *release);
+int _cxlflash_disk_release(struct scsi_device *sdev, struct ctx_info *ctxi,
+			   struct dk_cxlflash_release *release);
 
-int cxlflash_disk_clone(struct scsi_device *, struct dk_cxlflash_clone *);
+int cxlflash_disk_clone(struct scsi_device *sdev,
+			struct dk_cxlflash_clone *clone);
 
-int cxlflash_disk_virtual_open(struct scsi_device *, void *);
+int cxlflash_disk_virtual_open(struct scsi_device *sdev, void *arg);
 
-int cxlflash_lun_attach(struct glun_info *, enum lun_mode, bool);
-void cxlflash_lun_detach(struct glun_info *);
+int cxlflash_lun_attach(struct glun_info *gli, enum lun_mode mode, bool locked);
+void cxlflash_lun_detach(struct glun_info *gli);
 
-struct ctx_info *get_context(struct cxlflash_cfg *, u64, void *, enum ctx_ctrl);
-void put_context(struct ctx_info *);
+struct ctx_info *get_context(struct cxlflash_cfg *cfg, u64 rctxit, void *arg,
+			     enum ctx_ctrl ctrl);
+void put_context(struct ctx_info *ctxi);
 
-struct sisl_rht_entry *get_rhte(struct ctx_info *, res_hndl_t,
-				struct llun_info *);
+struct sisl_rht_entry *get_rhte(struct ctx_info *ctxi, res_hndl_t rhndl,
+				struct llun_info *lli);
 
-struct sisl_rht_entry *rhte_checkout(struct ctx_info *, struct llun_info *);
-void rhte_checkin(struct ctx_info *, struct sisl_rht_entry *);
+struct sisl_rht_entry *rhte_checkout(struct ctx_info *ctxi,
+				     struct llun_info *lli);
+void rhte_checkin(struct ctx_info *ctxi, struct sisl_rht_entry *rhte);
 
-void cxlflash_ba_terminate(struct ba_lun *);
+void cxlflash_ba_terminate(struct ba_lun *ba_lun);
 
-int cxlflash_manage_lun(struct scsi_device *, struct dk_cxlflash_manage_lun *);
+int cxlflash_manage_lun(struct scsi_device *sdev,
+			struct dk_cxlflash_manage_lun *manage);
 
-int check_state(struct cxlflash_cfg *);
+int check_state(struct cxlflash_cfg *cfg);
 
 #endif /* ifndef _CXLFLASH_SUPERPIPE_H */
diff --git a/drivers/scsi/cxlflash/vlun.h b/drivers/scsi/cxlflash/vlun.h
index 8b29a74..27a63a0 100644
--- a/drivers/scsi/cxlflash/vlun.h
+++ b/drivers/scsi/cxlflash/vlun.h
@@ -47,7 +47,7 @@
  * not stored anywhere.
  *
  * The LXT table is re-allocated whenever it needs to cross into another group.
-*/
+ */
 #define LXT_GROUP_SIZE          8
 #define LXT_NUM_GROUPS(lxt_cnt) (((lxt_cnt) + 7)/8)	/* alloc'ed groups */
 #define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
-- 
2.1.0
