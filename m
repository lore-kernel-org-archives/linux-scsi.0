From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 11/14] lpfc 8.3.0 :  Add BlockGuard support (T10-DIF) Part 1
Date: Thu, 4 Dec 2008 22:39:46 -0500
Message-ID: <1228448386.19053.55.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45974 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYLEOnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:50 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5Eho98004284
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Add BlockGuard support (T10-DIF) Part 1

Update struct definitions, #defines, sysfs entries, and initialization
to support BlockGuard.


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc.h        |   14 ++-
 drivers/scsi/lpfc/lpfc_attr.c   |  119 ++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_crtn.h   |   12 ++
 drivers/scsi/lpfc/lpfc_hw.h     |  207 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_init.c   |   89 +++++++++++++++++
 drivers/scsi/lpfc/lpfc_logmsg.h |    1 
 6 files changed, 432 insertions(+), 10 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -29,8 +29,10 @@ struct lpfc_sli2_slim;
 #define LPFC_MAX_NS_RETRY	3	/* Number of retry attempts to contact
 					   the NameServer  before giving up. */
 #define LPFC_CMD_PER_LUN	3	/* max outstanding cmds per lun */
-#define LPFC_DEFAULT_SG_SEG_CNT	64	/* sg element count per scsi cmnd */
-#define LPFC_MAX_SG_SEG_CNT	256	/* sg element count per scsi cmnd */
+#define LPFC_DEFAULT_SG_SEG_CNT 64	/* sg element count per scsi cmnd */
+#define LPFC_DEFAULT_PROT_SG_SEG_CNT 4096 /* sg protection elements count */
+#define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
+#define LPFC_MAX_PROT_SG_SEG_CNT 4096	/* prot sg element count per scsi cmd*/
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
 #define LPFC_Q_RAMP_UP_INTERVAL 120     /* lun q_depth ramp up interval */
 #define LPFC_VNAME_LEN		100	/* vport symbolic name length */
@@ -426,6 +428,7 @@ struct lpfc_hba {
 #define LPFC_SLI3_VPORT_TEARDOWN	0x04
 #define LPFC_SLI3_CRP_ENABLED		0x08
 #define LPFC_SLI3_INB_ENABLED		0x10
+#define LPFC_SLI3_BG_ENABLED		0x20
 	uint32_t iocb_cmd_size;
 	uint32_t iocb_rsp_size;
 
@@ -499,12 +502,14 @@ struct lpfc_hba {
 	uint32_t cfg_poll_tmo;
 	uint32_t cfg_use_msi;
 	uint32_t cfg_sg_seg_cnt;
+	uint32_t cfg_prot_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
 	uint64_t cfg_soft_wwnn;
 	uint64_t cfg_soft_wwpn;
 	uint32_t cfg_hba_queue_depth;
 	uint32_t cfg_enable_hba_reset;
 	uint32_t cfg_enable_hba_heartbeat;
+	uint32_t cfg_enable_bg;
 
 	lpfc_vpd_t vpd;		/* vital product data */
 
@@ -570,6 +575,9 @@ struct lpfc_hba {
 	uint64_t fc4InputRequests;
 	uint64_t fc4OutputRequests;
 	uint64_t fc4ControlRequests;
+	uint64_t bg_guard_err_cnt;
+	uint64_t bg_apptag_err_cnt;
+	uint64_t bg_reftag_err_cnt;
 
 	struct lpfc_sysfs_mbox sysfs_mbox;
 
@@ -619,6 +627,8 @@ struct lpfc_hba {
 	struct dentry *debug_hbqinfo;
 	struct dentry *debug_dumpHostSlim;
 	struct dentry *debug_dumpHBASlim;
+	struct dentry *debug_dumpData;   /* BlockGuard BPL*/
+	struct dentry *debug_dumpDif;    /* BlockGuard BPL*/
 	struct dentry *debug_slow_ring_trc;
 	struct lpfc_debugfs_trc *slow_ring_trc;
 	atomic_t slow_ring_trc_cnt;
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -96,6 +96,58 @@ lpfc_drvr_version_show(struct device *dev, struct device_attribute *attr,
 	return snprintf(buf, PAGE_SIZE, LPFC_MODULE_DESC "\n");
 }
 
+static ssize_t
+lpfc_bg_info_show(struct device *dev, struct device_attribute *attr,
+		  char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	if (phba->cfg_enable_bg)
+		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
+			return snprintf(buf, PAGE_SIZE, "BlockGuard Enabled\n");
+		else
+			return snprintf(buf, PAGE_SIZE,
+					"BlockGuard Not Supported\n");
+	else
+			return snprintf(buf, PAGE_SIZE,
+					"BlockGuard Disabled\n");
+}
+
+static ssize_t
+lpfc_bg_guard_err_show(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", phba->bg_guard_err_cnt);
+}
+
+static ssize_t
+lpfc_bg_apptag_err_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", phba->bg_apptag_err_cnt);
+}
+
+static ssize_t
+lpfc_bg_reftag_err_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", phba->bg_reftag_err_cnt);
+}
+
 /**
  * lpfc_info_show: Return some pci info about the host in ascii.
  * @dev: class converted to a Scsi_host structure.
@@ -1485,6 +1537,10 @@ lpfc_vport_param_store(name)\
 static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
 		   lpfc_##name##_show, lpfc_##name##_store)
 
+static DEVICE_ATTR(bg_info, S_IRUGO, lpfc_bg_info_show, NULL);
+static DEVICE_ATTR(bg_guard_err, S_IRUGO, lpfc_bg_guard_err_show, NULL);
+static DEVICE_ATTR(bg_apptag_err, S_IRUGO, lpfc_bg_apptag_err_show, NULL);
+static DEVICE_ATTR(bg_reftag_err, S_IRUGO, lpfc_bg_reftag_err_show, NULL);
 static DEVICE_ATTR(info, S_IRUGO, lpfc_info_show, NULL);
 static DEVICE_ATTR(serialnum, S_IRUGO, lpfc_serialnum_show, NULL);
 static DEVICE_ATTR(modeldesc, S_IRUGO, lpfc_modeldesc_show, NULL);
@@ -1970,6 +2026,7 @@ static DEVICE_ATTR(lpfc_devloss_tmo, S_IRUGO | S_IWUSR,
 # LOG_LINK_EVENT                0x10       Link events
 # LOG_FCP                       0x40       FCP traffic history
 # LOG_NODE                      0x80       Node table events
+# LOG_BG                        0x200      BlockBuard events
 # LOG_MISC                      0x400      Miscellaneous events
 # LOG_SLI                       0x800      SLI events
 # LOG_FCP_ERROR                 0x1000     Only log FCP errors
@@ -2769,6 +2826,42 @@ LPFC_ATTR_R(enable_hba_reset, 1, 0, 1, "Enable HBA resets from the driver.");
 LPFC_ATTR_R(enable_hba_heartbeat, 1, 0, 1, "Enable HBA Heartbeat.");
 
 /*
+# lpfc_enable_bg: Enable BlockGuard (Emulex's Implementation of T10-DIF)
+#       0  = BlockGuard disabled (default)
+#       1  = BlockGuard enabled
+# Value range is [0,1]. Default value is 0.
+*/
+LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable BlockGuard Support");
+
+
+/*
+# lpfc_prot_mask: i
+#	- Bit mask of host protection capabilities used to register with the
+#	  SCSI mid-layer
+# 	- Only meaningful if BG is turned on (lpfc_enable_bg=1).
+#	- Allows you to ultimately specify which profiles to use
+#	- Default will result in registering capabilities for all profiles.
+#
+*/
+unsigned int lpfc_prot_mask =   SHOST_DIX_TYPE0_PROTECTION;
+
+module_param(lpfc_prot_mask, uint, 0);
+MODULE_PARM_DESC(lpfc_prot_mask, "host protection mask");
+
+/*
+# lpfc_prot_guard: i
+#	- Bit mask of protection guard types to register with the SCSI mid-layer
+# 	- Guard types are currently either 1) IP checksum 2) T10-DIF CRC
+#	- Allows you to ultimately specify which profiles to use
+#	- Default will result in registering capabilities for all guard types
+#
+*/
+unsigned char lpfc_prot_guard = SHOST_DIX_GUARD_IP;
+module_param(lpfc_prot_guard, byte, 0);
+MODULE_PARM_DESC(lpfc_prot_guard, "host protection guard type");
+
+
+/*
  * lpfc_sg_seg_cnt: Initial Maximum DMA Segment Count
  * This value can be set to values between 64 and 256. The default value is
  * 64, but may be increased to allow for larger Max I/O sizes. The scsi layer
@@ -2777,7 +2870,15 @@ LPFC_ATTR_R(enable_hba_heartbeat, 1, 0, 1, "Enable HBA Heartbeat.");
 LPFC_ATTR_R(sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT, LPFC_DEFAULT_SG_SEG_CNT,
 	    LPFC_MAX_SG_SEG_CNT, "Max Scatter Gather Segment Count");
 
+LPFC_ATTR_R(prot_sg_seg_cnt, LPFC_DEFAULT_PROT_SG_SEG_CNT,
+		LPFC_DEFAULT_PROT_SG_SEG_CNT, LPFC_MAX_PROT_SG_SEG_CNT,
+		"Max Protection Scatter Gather Segment Count");
+
 struct device_attribute *lpfc_hba_attrs[] = {
+	&dev_attr_bg_info,
+	&dev_attr_bg_guard_err,
+	&dev_attr_bg_apptag_err,
+	&dev_attr_bg_reftag_err,
 	&dev_attr_info,
 	&dev_attr_serialnum,
 	&dev_attr_modeldesc,
@@ -2825,6 +2926,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_poll,
 	&dev_attr_lpfc_poll_tmo,
 	&dev_attr_lpfc_use_msi,
+	&dev_attr_lpfc_enable_bg,
 	&dev_attr_lpfc_soft_wwnn,
 	&dev_attr_lpfc_soft_wwpn,
 	&dev_attr_lpfc_soft_wwn_enable,
@@ -2833,6 +2935,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_sg_seg_cnt,
 	&dev_attr_lpfc_max_scsicmpl_time,
 	&dev_attr_lpfc_stat_data_ctrl,
+	&dev_attr_lpfc_prot_sg_seg_cnt,
 	NULL,
 };
 
@@ -3961,13 +4064,12 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_use_msi_init(phba, lpfc_use_msi);
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
+	lpfc_enable_bg_init(phba, lpfc_enable_bg);
 	phba->cfg_poll = lpfc_poll;
 	phba->cfg_soft_wwnn = 0L;
 	phba->cfg_soft_wwpn = 0L;
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
-	/* Also reinitialize the host templates with new values. */
-	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
-	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
+	lpfc_prot_sg_seg_cnt_init(phba, lpfc_prot_sg_seg_cnt);
 	/*
 	 * Since the sg_tablesize is module parameter, the sg_dma_buf_size
 	 * used to create the sg_dma_buf_pool must be dynamically calculated.
@@ -3976,6 +4078,17 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
 			sizeof(struct fcp_rsp) +
 			((phba->cfg_sg_seg_cnt + 2) * sizeof(struct ulp_bde64));
+
+	if (phba->cfg_enable_bg) {
+		phba->cfg_sg_seg_cnt = LPFC_MAX_SG_SEG_CNT;
+		phba->cfg_sg_dma_buf_size +=
+			phba->cfg_prot_sg_seg_cnt * sizeof(struct ulp_bde64);
+	}
+
+	/* Also reinitialize the host templates with new values. */
+	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
+	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
+
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 	return;
 }
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -285,6 +285,18 @@ extern void lpfc_debugfs_slow_ring_trc(struct lpfc_hba *, char *, uint32_t,
 	uint32_t, uint32_t);
 extern struct lpfc_hbq_init *lpfc_hbq_defs[];
 
+/* externs BlockGuard */
+extern char *_dump_buf_data;
+extern unsigned long _dump_buf_data_order;
+extern char *_dump_buf_dif;
+extern unsigned long _dump_buf_dif_order;
+extern spinlock_t _dump_buf_lock;
+extern int _dump_buf_done;
+extern spinlock_t pgcnt_lock;
+extern unsigned int pgcnt;
+extern unsigned int lpfc_prot_mask;
+extern unsigned char lpfc_prot_guard;
+
 /* Interface exported by fabric iocb scheduler */
 void lpfc_fabric_abort_nport(struct lpfc_nodelist *);
 void lpfc_fabric_abort_hba(struct lpfc_hba *);
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1544,6 +1544,108 @@ typedef struct ULP_BDL {	/* SLI-2 */
 	uint32_t ulpIoTag32;	/* Can be used for 32 bit I/O Tag */
 } ULP_BDL;
 
+/*
+ * BlockGuard Definitions
+ */
+
+enum lpfc_protgrp_type {
+	LPFC_PG_TYPE_INVALID = 0, /* used to indicate errors                  */
+	LPFC_PG_TYPE_NO_DIF,	  /* no DIF data pointed to by prot grp       */
+	LPFC_PG_TYPE_EMBD_DIF,	  /* DIF is embedded (inline) with data       */
+	LPFC_PG_TYPE_DIF_BUF	  /* DIF has its own scatter/gather list      */
+};
+
+/* PDE Descriptors */
+#define LPFC_PDE1_DESCRIPTOR		0x81
+#define LPFC_PDE2_DESCRIPTOR		0x82
+#define LPFC_PDE3_DESCRIPTOR		0x83
+
+/* BlockGuard Profiles */
+enum lpfc_bg_prof_codes {
+	LPFC_PROF_INVALID,
+	LPFC_PROF_A1	= 128,	/* Full Protection			      */
+	LPFC_PROF_A2,		/* Disabled Protection Checks:A2~A4           */
+	LPFC_PROF_A3,
+	LPFC_PROF_A4,
+	LPFC_PROF_B1,		/* Embedded DIFs: B1~B3	                      */
+	LPFC_PROF_B2,
+	LPFC_PROF_B3,
+	LPFC_PROF_C1,		/* Separate DIFs: C1~C3                       */
+	LPFC_PROF_C2,
+	LPFC_PROF_C3,
+	LPFC_PROF_D1,		/* Full Protection                            */
+	LPFC_PROF_D2,		/* Partial Protection & Check Disabling       */
+	LPFC_PROF_D3,
+	LPFC_PROF_E1,		/* E1~E4:out - check-only, in - update apptag */
+	LPFC_PROF_E2,
+	LPFC_PROF_E3,
+	LPFC_PROF_E4,
+	LPFC_PROF_F1,		/* Full Translation - F1 Prot Descriptor      */
+				/* F1 Translation BDE                         */
+	LPFC_PROF_ANT1,		/* TCP checksum, DIF inline with data buffers */
+	LPFC_PROF_AST1,		/* TCP checksum, DIF split from data buffer   */
+	LPFC_PROF_ANT2,
+	LPFC_PROF_AST2
+};
+
+/* BlockGuard error-control defines */
+#define BG_EC_STOP_ERR			0x00
+#define BG_EC_CONT_ERR			0x01
+#define BG_EC_IGN_UNINIT_STOP_ERR	0x10
+#define BG_EC_IGN_UNINIT_CONT_ERR	0x11
+
+/* PDE (Protection Descriptor Entry) word 0 bit masks and shifts */
+#define PDE_DESC_TYPE_MASK		0xff000000
+#define PDE_DESC_TYPE_SHIFT		24
+#define PDE_BG_PROFILE_MASK		0x00ff0000
+#define PDE_BG_PROFILE_SHIFT		16
+#define PDE_BLOCK_LEN_MASK		0x0000fffc
+#define PDE_BLOCK_LEN_SHIFT		2
+#define PDE_ERR_CTRL_MASK		0x00000003
+#define PDE_ERR_CTRL_SHIFT		0
+/* PDE word 1 bit masks and shifts */
+#define PDE_APPTAG_MASK_MASK		0xffff0000
+#define PDE_APPTAG_MASK_SHIFT		16
+#define PDE_APPTAG_VAL_MASK		0x0000ffff
+#define PDE_APPTAG_VAL_SHIFT		0
+struct lpfc_pde {
+	uint32_t parms;     /* bitfields of descriptor, prof, len, and ec */
+	uint32_t apptag;    /* bitfields of app tag maskand app tag value */
+	uint32_t reftag;    /* reference tag occupying all 32 bits        */
+};
+
+/* inline function to set fields in parms of PDE */
+static inline void
+lpfc_pde_set_bg_parms(struct lpfc_pde *p, u8 desc, u8 prof, u16 len, u8 ec)
+{
+	uint32_t *wp = &p->parms;
+
+	/* spec indicates that adapter appends two 0's to length field */
+	len = len >> 2;
+
+	*wp &= 0;
+	*wp |= ((desc << PDE_DESC_TYPE_SHIFT) & PDE_DESC_TYPE_MASK);
+	*wp |= ((prof << PDE_BG_PROFILE_SHIFT) & PDE_BG_PROFILE_MASK);
+	*wp |= ((len << PDE_BLOCK_LEN_SHIFT) & PDE_BLOCK_LEN_MASK);
+	*wp |= ((ec << PDE_ERR_CTRL_SHIFT) & PDE_ERR_CTRL_MASK);
+	*wp = le32_to_cpu(*wp);
+}
+
+/* inline function to set apptag and reftag fields of PDE */
+static inline void
+lpfc_pde_set_dif_parms(struct lpfc_pde *p, u16 apptagmask, u16 apptagval,
+		u32 reftag)
+{
+	uint32_t *wp = &p->apptag;
+	*wp &= 0;
+	*wp |= ((apptagmask << PDE_APPTAG_MASK_SHIFT) & PDE_APPTAG_MASK_MASK);
+	*wp |= ((apptagval << PDE_APPTAG_VAL_SHIFT) & PDE_APPTAG_VAL_MASK);
+	*wp = le32_to_cpu(*wp);
+	wp = &p->reftag;
+	*wp = le32_to_cpu(reftag);
+}
+
+
 /* Structure for MB Command LOAD_SM and DOWN_LOAD */
 
 typedef struct {
@@ -2595,8 +2697,9 @@ typedef struct {
 #endif
 
 #ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd1     : 24;  /* Reserved                             */
-	uint32_t cmv	   :  1;  /* Configure Max VPIs                   */
+	uint32_t rsvd1     : 23;  /* Reserved                             */
+	uint32_t cbg       :  1;  /* Configure BlockGuard                 */
+	uint32_t cmv       :  1;  /* Configure Max VPIs                   */
 	uint32_t ccrp      :  1;  /* Config Command Ring Polling          */
 	uint32_t csah      :  1;  /* Configure Synchronous Abort Handling */
 	uint32_t chbs      :  1;  /* Cofigure Host Backing store          */
@@ -2613,10 +2716,12 @@ typedef struct {
 	uint32_t csah      :  1;  /* Configure Synchronous Abort Handling */
 	uint32_t ccrp      :  1;  /* Config Command Ring Polling          */
 	uint32_t cmv	   :  1;  /* Configure Max VPIs                   */
-	uint32_t rsvd1     : 24;  /* Reserved                             */
+	uint32_t cbg       :  1;  /* Configure BlockGuard                 */
+	uint32_t rsvd1     : 23;  /* Reserved                             */
 #endif
 #ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd2     : 24;  /* Reserved                             */
+	uint32_t rsvd2     : 23;  /* Reserved                             */
+	uint32_t gbg       :  1;  /* Grant BlockGuard                     */
 	uint32_t gmv	   :  1;  /* Grant Max VPIs                       */
 	uint32_t gcrp	   :  1;  /* Grant Command Ring Polling           */
 	uint32_t gsah	   :  1;  /* Grant Synchronous Abort Handling     */
@@ -2634,7 +2739,8 @@ typedef struct {
 	uint32_t gsah	   :  1;  /* Grant Synchronous Abort Handling     */
 	uint32_t gcrp	   :  1;  /* Grant Command Ring Polling           */
 	uint32_t gmv	   :  1;  /* Grant Max VPIs                       */
-	uint32_t rsvd2     : 24;  /* Reserved                             */
+	uint32_t gbg       :  1;  /* Grant BlockGuard                     */
+	uint32_t rsvd2     : 23;  /* Reserved                             */
 #endif
 
 #ifdef __BIG_ENDIAN_BITFIELD
@@ -3254,6 +3360,94 @@ struct que_xri64cx_ext_fields {
 	struct lpfc_hbq_entry	buff[5];
 };
 
+struct sli3_bg_fields {
+	uint32_t filler[6];	/* word 8-13 in IOCB */
+	uint32_t bghm;		/* word 14 - BlockGuard High Water Mark */
+/* Bitfields for bgstat (BlockGuard Status - word 15 of IOCB) */
+#define BGS_BIDIR_BG_PROF_MASK		0xff000000
+#define BGS_BIDIR_BG_PROF_SHIFT		24
+#define BGS_BIDIR_ERR_COND_FLAGS_MASK	0x003f0000
+#define BGS_BIDIR_ERR_COND_SHIFT	16
+#define BGS_BG_PROFILE_MASK		0x0000ff00
+#define BGS_BG_PROFILE_SHIFT		8
+#define BGS_INVALID_PROF_MASK		0x00000020
+#define BGS_INVALID_PROF_SHIFT		5
+#define BGS_UNINIT_DIF_BLOCK_MASK	0x00000010
+#define BGS_UNINIT_DIF_BLOCK_SHIFT	4
+#define BGS_HI_WATER_MARK_PRESENT_MASK	0x00000008
+#define BGS_HI_WATER_MARK_PRESENT_SHIFT	3
+#define BGS_REFTAG_ERR_MASK		0x00000004
+#define BGS_REFTAG_ERR_SHIFT		2
+#define BGS_APPTAG_ERR_MASK		0x00000002
+#define BGS_APPTAG_ERR_SHIFT		1
+#define BGS_GUARD_ERR_MASK		0x00000001
+#define BGS_GUARD_ERR_SHIFT		0
+	uint32_t bgstat;	/* word 15 - BlockGuard Status */
+};
+
+static inline uint32_t
+lpfc_bgs_get_bidir_bg_prof(uint32_t bgstat)
+{
+	return (le32_to_cpu(bgstat) & BGS_BIDIR_BG_PROF_MASK) >>
+				BGS_BIDIR_BG_PROF_SHIFT;
+}
+
+static inline uint32_t
+lpfc_bgs_get_bidir_err_cond(uint32_t bgstat)
+{
+	return (le32_to_cpu(bgstat) & BGS_BIDIR_ERR_COND_FLAGS_MASK) >>
+				BGS_BIDIR_ERR_COND_SHIFT;
+}
+
+static inline uint32_t
+lpfc_bgs_get_bg_prof(uint32_t bgstat)
+{
+	return (le32_to_cpu(bgstat) & BGS_BG_PROFILE_MASK) >>
+				BGS_BG_PROFILE_SHIFT;
+}
+
+static inline uint32_t
+lpfc_bgs_get_invalid_prof(uint32_t bgstat)
+{
+	return (le32_to_cpu(bgstat) & BGS_INVALID_PROF_MASK) >>
+				BGS_INVALID_PROF_SHIFT;
+}
+
+static inline uint32_t
+lpfc_bgs_get_uninit_dif_block(uint32_t bgstat)
+{
+	return (le32_to_cpu(bgstat) & BGS_UNINIT_DIF_BLOCK_MASK) >>
+				BGS_UNINIT_DIF_BLOCK_SHIFT;
+}
+
+static inline uint32_t
+lpfc_bgs_get_hi_water_mark_present(uint32_t bgstat)
+{
+	return (le32_to_cpu(bgstat) & BGS_HI_WATER_MARK_PRESENT_MASK) >>
+				BGS_HI_WATER_MARK_PRESENT_SHIFT;
+}
+
+static inline uint32_t
+lpfc_bgs_get_reftag_err(uint32_t bgstat)
+{
+	return (le32_to_cpu(bgstat) & BGS_REFTAG_ERR_MASK) >>
+				BGS_REFTAG_ERR_SHIFT;
+}
+
+static inline uint32_t
+lpfc_bgs_get_apptag_err(uint32_t bgstat)
+{
+	return (le32_to_cpu(bgstat) & BGS_APPTAG_ERR_MASK) >>
+				BGS_APPTAG_ERR_SHIFT;
+}
+
+static inline uint32_t
+lpfc_bgs_get_guard_err(uint32_t bgstat)
+{
+	return (le32_to_cpu(bgstat) & BGS_GUARD_ERR_MASK) >>
+				BGS_GUARD_ERR_SHIFT;
+}
+
 #define LPFC_EXT_DATA_BDE_COUNT 3
 struct fcp_irw_ext {
 	uint32_t	io_tag64_low;
@@ -3362,6 +3556,9 @@ typedef struct _IOCB {	/* IOCB structure */
 		struct que_xri64cx_ext_fields que_xri64cx_ext_words;
 		struct fcp_irw_ext fcp_ext;
 		uint32_t sli3Words[24]; /* 96 extra bytes for SLI-3 */
+
+		/* words 8-15 for BlockGuard */
+		struct sli3_bg_fields sli3_bg;
 	} unsli3;
 
 #define ulpCt_h ulpXS
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -45,6 +45,12 @@
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
 
+char *_dump_buf_data;
+unsigned long _dump_buf_data_order;
+char *_dump_buf_dif;
+unsigned long _dump_buf_dif_order;
+spinlock_t _dump_buf_lock;
+
 static int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 static int lpfc_post_rcv_buf(struct lpfc_hba *);
@@ -2037,6 +2043,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	shost->max_lun = vport->cfg_max_luns;
 	shost->this_id = -1;
 	shost->max_cmd_len = 16;
+
 	/*
 	 * Set initial can_queue value since 0 is no longer supported and
 	 * scsi_add_host will fail. This will be adjusted later based on the
@@ -2864,6 +2871,75 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 	 * the value of can_queue.
 	 */
 	shost->can_queue = phba->cfg_hba_queue_depth - 10;
+	if (phba->sli3_options & LPFC_SLI3_BG_ENABLED) {
+
+		if (lpfc_prot_mask && lpfc_prot_guard) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"1478 Registering BlockGuard with the "
+					"SCSI layer\n");
+
+			scsi_host_set_prot(shost, lpfc_prot_mask);
+			scsi_host_set_guard(shost, lpfc_prot_guard);
+		}
+	}
+
+	if (!_dump_buf_data) {
+		int pagecnt = 10;
+		while (pagecnt) {
+			spin_lock_init(&_dump_buf_lock);
+			_dump_buf_data =
+				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
+			if (_dump_buf_data) {
+				printk(KERN_ERR "BLKGRD allocated %d pages for "
+						"_dump_buf_data at 0x%p\n",
+						(1 << pagecnt), _dump_buf_data);
+				_dump_buf_data_order = pagecnt;
+				memset(_dump_buf_data, 0, ((1 << PAGE_SHIFT)
+							   << pagecnt));
+				break;
+			} else {
+				--pagecnt;
+			}
+
+		}
+
+		if (!_dump_buf_data_order)
+			printk(KERN_ERR "BLKGRD ERROR unable to allocate "
+					"memory for hexdump\n");
+
+	} else {
+		printk(KERN_ERR "BLKGRD already allocated _dump_buf_data=0x%p"
+		       "\n", _dump_buf_data);
+	}
+
+
+	if (!_dump_buf_dif) {
+		int pagecnt = 10;
+		while (pagecnt) {
+			_dump_buf_dif =
+				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
+			if (_dump_buf_dif) {
+				printk(KERN_ERR "BLKGRD allocated %d pages for "
+						"_dump_buf_dif at 0x%p\n",
+						(1 << pagecnt), _dump_buf_dif);
+				_dump_buf_dif_order = pagecnt;
+				memset(_dump_buf_dif, 0, ((1 << PAGE_SHIFT)
+							  << pagecnt));
+				break;
+			} else {
+				--pagecnt;
+			}
+
+		}
+
+		if (!_dump_buf_dif_order)
+			printk(KERN_ERR "BLKGRD ERROR unable to allocate "
+					"memory for hexdump\n");
+
+	} else {
+		printk(KERN_ERR "BLKGRD already allocated _dump_buf_dif=0x%p\n",
+				_dump_buf_dif);
+	}
 
 	lpfc_host_attrib_init(shost);
 
@@ -3408,6 +3484,19 @@ lpfc_exit(void)
 	fc_release_transport(lpfc_transport_template);
 	if (lpfc_enable_npiv)
 		fc_release_transport(lpfc_vport_transport_template);
+	if (_dump_buf_data) {
+		printk(KERN_ERR "BLKGRD freeing %lu pages for _dump_buf_data "
+				"at 0x%p\n",
+				(1L << _dump_buf_data_order), _dump_buf_data);
+		free_pages((unsigned long)_dump_buf_data, _dump_buf_data_order);
+	}
+
+	if (_dump_buf_dif) {
+		printk(KERN_ERR "BLKGRD freeing %lu pages for _dump_buf_dif "
+				"at 0x%p\n",
+				(1L << _dump_buf_dif_order), _dump_buf_dif);
+		free_pages((unsigned long)_dump_buf_dif, _dump_buf_dif_order);
+	}
 }
 
 module_init(lpfc_init);
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -27,6 +27,7 @@
 #define LOG_FCP                       0x40	/* FCP traffic history */
 #define LOG_NODE                      0x80	/* Node table events */
 #define LOG_TEMP                      0x100	/* Temperature sensor events */
+#define LOG_BG			      0x200	/* BlockBuard events */
 #define LOG_MISC                      0x400	/* Miscellaneous events */
 #define LOG_SLI                       0x800	/* SLI events */
 #define LOG_FCP_ERROR                 0x1000	/* log errors, not underruns */


