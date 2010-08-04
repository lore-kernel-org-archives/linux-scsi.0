From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/3] lpfc 8.3.16: SLI Additions, updates, and code cleanup
Date: Wed, 4 Aug 2010 16:11:18 -0400
Message-ID: <1280952698.32588.12.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:22849 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759190Ab0HDUMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2010 16:12:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

SLI Additions, updates, and code cleanup

- Remove unneeded Endian swap for Block Guard IOCB response
- Add a check for mailbox active before issuing the heartbeat command
- Correct heartbeat last_completion updates to avoid unneeded heartbeats
- Add Security crypto support to CONFIG_PORT mailbox command
- Add fips level and fips spec revision sysfs parameters
- Remove duplicate setting of ext_byte_len fields in lpfc_bsg_issue_mbox
- Switch call to memcpy_toio to __write32_copy to prevent unaligned 64 bit copy
- Change log message 0318 from an error to a warning as it is not an error
- Patch an incorrect call to lpfc_drain_txq on SLI-3 functions

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    3 +++
 lpfc_attr.c    |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 lpfc_bsg.c     |    9 ---------
 lpfc_compat.h  |    3 +--
 lpfc_hbadisc.c |    2 +-
 lpfc_hw.h      |   26 +++++++++++++++-----------
 lpfc_init.c    |   55 +++++++++++++++++++++++++++++++++++++------------------
 lpfc_scsi.c    |    8 ++++----
 lpfc_sli.c     |   29 +++++++++++++++++++++++------
 9 files changed, 129 insertions(+), 52 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-08-04 15:31:02.000000000 -0400
@@ -1239,6 +1239,44 @@ lpfc_poll_store(struct device *dev, stru
 }
 
 /**
+ * lpfc_fips_level_show - Return the current FIPS level for the HBA
+ * @dev: class unused variable.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the module description text.
+ *
+ * Returns: size of formatted string.
+ **/
+static ssize_t
+lpfc_fips_level_show(struct device *dev,  struct device_attribute *attr,
+		     char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", phba->fips_level);
+}
+
+/**
+ * lpfc_fips_rev_show - Return the FIPS Spec revision for the HBA
+ * @dev: class unused variable.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the module description text.
+ *
+ * Returns: size of formatted string.
+ **/
+static ssize_t
+lpfc_fips_rev_show(struct device *dev,  struct device_attribute *attr,
+		   char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", phba->fips_spec_rev);
+}
+
+/**
  * lpfc_param_show - Return a cfg attribute value in decimal
  *
  * Description:
@@ -1676,6 +1714,8 @@ static DEVICE_ATTR(max_xri, S_IRUGO, lpf
 static DEVICE_ATTR(used_xri, S_IRUGO, lpfc_used_xri_show, NULL);
 static DEVICE_ATTR(npiv_info, S_IRUGO, lpfc_npiv_info_show, NULL);
 static DEVICE_ATTR(lpfc_temp_sensor, S_IRUGO, lpfc_temp_sensor_show, NULL);
+static DEVICE_ATTR(lpfc_fips_level, S_IRUGO, lpfc_fips_level_show, NULL);
+static DEVICE_ATTR(lpfc_fips_rev, S_IRUGO, lpfc_fips_rev_show, NULL);
 

 static char *lpfc_soft_wwn_key = "C99G71SL8032A";
@@ -3280,7 +3320,7 @@ LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable 
 #	- Default will result in registering capabilities for all profiles.
 #
 */
-unsigned int lpfc_prot_mask =   SHOST_DIX_TYPE0_PROTECTION;
+unsigned int lpfc_prot_mask = SHOST_DIF_TYPE1_PROTECTION;
 
 module_param(lpfc_prot_mask, uint, 0);
 MODULE_PARM_DESC(lpfc_prot_mask, "host protection mask");
@@ -3385,6 +3425,8 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_iocb_hw,
 	&dev_attr_txq_hw,
 	&dev_attr_txcmplq_hw,
+	&dev_attr_lpfc_fips_level,
+	&dev_attr_lpfc_fips_rev,
 	NULL,
 };
 
@@ -3411,6 +3453,8 @@ struct device_attribute *lpfc_vport_attr
 	&dev_attr_lpfc_max_scsicmpl_time,
 	&dev_attr_lpfc_stat_data_ctrl,
 	&dev_attr_lpfc_static_vport,
+	&dev_attr_lpfc_fips_level,
+	&dev_attr_lpfc_fips_rev,
 	NULL,
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-08-04 15:31:02.000000000 -0400
@@ -2724,15 +2724,6 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 
 		pmboxq->context2 = ext;
 		pmboxq->in_ext_byte_len =
-			mbox_req->inExtWLen *
-			sizeof(uint32_t);
-		pmboxq->out_ext_byte_len =
-			mbox_req->outExtWLen *
-			sizeof(uint32_t);
-		pmboxq->mbox_offset_word =
-			mbox_req->mbOffset;
-		pmboxq->context2 = ext;
-		pmboxq->in_ext_byte_len =
 			mbox_req->inExtWLen * sizeof(uint32_t);
 		pmboxq->out_ext_byte_len =
 			mbox_req->outExtWLen * sizeof(uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_compat.h b/drivers/scsi/lpfc/lpfc_compat.h
--- a/drivers/scsi/lpfc/lpfc_compat.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_compat.h	2010-08-04 15:31:02.000000000 -0400
@@ -82,8 +82,7 @@ lpfc_memcpy_from_slim( void *dest, void 
 static inline void
 lpfc_memcpy_to_slim( void __iomem *dest, void *src, unsigned int bytes)
 {
-	/* actually returns 1 byte past dest */
-	memcpy_toio( dest, src, bytes);
+	__iowrite32_copy(dest, src, bytes);
 }
 
 static inline void
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2010-08-04 15:31:02.000000000 -0400
@@ -775,6 +775,7 @@ struct lpfc_hba {
 	uint8_t temp_sensor_support;
 	/* Fields used for heart beat. */
 	unsigned long last_completion_time;
+	unsigned long skipped_hb;
 	struct timer_list hb_tmofunc;
 	uint8_t hb_outstanding;
 	enum hba_temp_state over_temp_state;
@@ -817,6 +818,8 @@ struct lpfc_hba {
 	uint32_t iocb_cnt;
 	uint32_t iocb_max;
 	atomic_t sdev_cnt;
+	uint8_t fips_spec_rev;
+	uint8_t fips_level;
 };
 
 static inline struct Scsi_Host *
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-08-04 15:31:09.000000000 -0400
@@ -588,7 +588,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 							(status &
 							 HA_RXMASK));
 		}
-		if (pring->txq_cnt)
+		if ((phba->sli_rev == LPFC_SLI_REV4) && pring->txq_cnt)
 			lpfc_drain_txq(phba);
 		/*
 		 * Turn on Ring interrupts
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-08-04 15:31:02.000000000 -0400
@@ -2806,11 +2806,15 @@ typedef struct {
 	uint32_t rsvd6;           /* Reserved                             */
 
 #ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd7      : 16;  /* Reserved                             */
+	uint32_t fips_rev   : 3;   /* FIPS Spec Revision                   */
+	uint32_t fips_level : 4;   /* FIPS Level                           */
+	uint32_t sec_err    : 9;   /* security crypto error                */
 	uint32_t max_vpi    : 16;  /* Max number of virt N-Ports           */
 #else	/*  __LITTLE_ENDIAN */
 	uint32_t max_vpi    : 16;  /* Max number of virt N-Ports           */
-	uint32_t rsvd7      : 16;  /* Reserved                             */
+	uint32_t sec_err    : 9;   /* security crypto error                */
+	uint32_t fips_level : 4;   /* FIPS Level                           */
+	uint32_t fips_rev   : 3;   /* FIPS Spec Revision                   */
 #endif
 
 } CONFIG_PORT_VAR;
@@ -3441,63 +3445,63 @@ struct sli3_bg_fields {
 static inline uint32_t
 lpfc_bgs_get_bidir_bg_prof(uint32_t bgstat)
 {
-	return (le32_to_cpu(bgstat) & BGS_BIDIR_BG_PROF_MASK) >>
+	return (bgstat & BGS_BIDIR_BG_PROF_MASK) >>
 				BGS_BIDIR_BG_PROF_SHIFT;
 }
 
 static inline uint32_t
 lpfc_bgs_get_bidir_err_cond(uint32_t bgstat)
 {
-	return (le32_to_cpu(bgstat) & BGS_BIDIR_ERR_COND_FLAGS_MASK) >>
+	return (bgstat & BGS_BIDIR_ERR_COND_FLAGS_MASK) >>
 				BGS_BIDIR_ERR_COND_SHIFT;
 }
 
 static inline uint32_t
 lpfc_bgs_get_bg_prof(uint32_t bgstat)
 {
-	return (le32_to_cpu(bgstat) & BGS_BG_PROFILE_MASK) >>
+	return (bgstat & BGS_BG_PROFILE_MASK) >>
 				BGS_BG_PROFILE_SHIFT;
 }
 
 static inline uint32_t
 lpfc_bgs_get_invalid_prof(uint32_t bgstat)
 {
-	return (le32_to_cpu(bgstat) & BGS_INVALID_PROF_MASK) >>
+	return (bgstat & BGS_INVALID_PROF_MASK) >>
 				BGS_INVALID_PROF_SHIFT;
 }
 
 static inline uint32_t
 lpfc_bgs_get_uninit_dif_block(uint32_t bgstat)
 {
-	return (le32_to_cpu(bgstat) & BGS_UNINIT_DIF_BLOCK_MASK) >>
+	return (bgstat & BGS_UNINIT_DIF_BLOCK_MASK) >>
 				BGS_UNINIT_DIF_BLOCK_SHIFT;
 }
 
 static inline uint32_t
 lpfc_bgs_get_hi_water_mark_present(uint32_t bgstat)
 {
-	return (le32_to_cpu(bgstat) & BGS_HI_WATER_MARK_PRESENT_MASK) >>
+	return (bgstat & BGS_HI_WATER_MARK_PRESENT_MASK) >>
 				BGS_HI_WATER_MARK_PRESENT_SHIFT;
 }
 
 static inline uint32_t
 lpfc_bgs_get_reftag_err(uint32_t bgstat)
 {
-	return (le32_to_cpu(bgstat) & BGS_REFTAG_ERR_MASK) >>
+	return (bgstat & BGS_REFTAG_ERR_MASK) >>
 				BGS_REFTAG_ERR_SHIFT;
 }
 
 static inline uint32_t
 lpfc_bgs_get_apptag_err(uint32_t bgstat)
 {
-	return (le32_to_cpu(bgstat) & BGS_APPTAG_ERR_MASK) >>
+	return (bgstat & BGS_APPTAG_ERR_MASK) >>
 				BGS_APPTAG_ERR_SHIFT;
 }
 
 static inline uint32_t
 lpfc_bgs_get_guard_err(uint32_t bgstat)
 {
-	return (le32_to_cpu(bgstat) & BGS_GUARD_ERR_MASK) >>
+	return (bgstat & BGS_GUARD_ERR_MASK) >>
 				BGS_GUARD_ERR_SHIFT;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-08-04 15:31:02.000000000 -0400
@@ -1032,27 +1032,46 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
 	/* If there is no heart beat outstanding, issue a heartbeat command */
 	if (phba->cfg_enable_hba_heartbeat) {
 		if (!phba->hb_outstanding) {
-			pmboxq = mempool_alloc(phba->mbox_mem_pool,GFP_KERNEL);
-			if (!pmboxq) {
-				mod_timer(&phba->hb_tmofunc,
-					  jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
-				return;
-			}
+			if ((!(psli->sli_flag & LPFC_SLI_MBOX_ACTIVE)) &&
+				(list_empty(&psli->mboxq))) {
+				pmboxq = mempool_alloc(phba->mbox_mem_pool,
+							GFP_KERNEL);
+				if (!pmboxq) {
+					mod_timer(&phba->hb_tmofunc,
+						 jiffies +
+						 HZ * LPFC_HB_MBOX_INTERVAL);
+					return;
+				}
+
+				lpfc_heart_beat(phba, pmboxq);
+				pmboxq->mbox_cmpl = lpfc_hb_mbox_cmpl;
+				pmboxq->vport = phba->pport;
+				retval = lpfc_sli_issue_mbox(phba, pmboxq,
+						MBX_NOWAIT);
+
+				if (retval != MBX_BUSY &&
+					retval != MBX_SUCCESS) {
+					mempool_free(pmboxq,
+							phba->mbox_mem_pool);
+					mod_timer(&phba->hb_tmofunc,
+						jiffies +
+						HZ * LPFC_HB_MBOX_INTERVAL);
+					return;
+				}
+				phba->skipped_hb = 0;
+				phba->hb_outstanding = 1;
+			} else if (time_before_eq(phba->last_completion_time,
+					phba->skipped_hb)) {
+				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2857 Last completion time not "
+					" updated in %d ms\n",
+					jiffies_to_msecs(jiffies
+						 - phba->last_completion_time));
+			} else
+				phba->skipped_hb = jiffies;
 
-			lpfc_heart_beat(phba, pmboxq);
-			pmboxq->mbox_cmpl = lpfc_hb_mbox_cmpl;
-			pmboxq->vport = phba->pport;
-			retval = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
-
-			if (retval != MBX_BUSY && retval != MBX_SUCCESS) {
-				mempool_free(pmboxq, phba->mbox_mem_pool);
-				mod_timer(&phba->hb_tmofunc,
-					  jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
-				return;
-			}
 			mod_timer(&phba->hb_tmofunc,
 				  jiffies + HZ * LPFC_HB_MBOX_TIMEOUT);
-			phba->hb_outstanding = 1;
 			return;
 		} else {
 			/*
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-08-04 15:31:02.000000000 -0400
@@ -1325,7 +1325,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 	bf_set(pde5_type, pde5, LPFC_PDE5_DESCRIPTOR);
 	pde5->reftag = reftag;
 
-	/* Endian convertion if necessary for PDE5 */
+	/* Endianness conversion if necessary for PDE5 */
 	pde5->word0 = cpu_to_le32(pde5->word0);
 	pde5->reftag = cpu_to_le32(pde5->reftag);
 
@@ -1347,7 +1347,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 	bf_set(pde6_ai, pde6, 1);
 	bf_set(pde6_apptagval, pde6, apptagval);
 
-	/* Endian convertion if necessary for PDE6 */
+	/* Endianness conversion if necessary for PDE6 */
 	pde6->word0 = cpu_to_le32(pde6->word0);
 	pde6->word1 = cpu_to_le32(pde6->word1);
 	pde6->word2 = cpu_to_le32(pde6->word2);
@@ -1459,7 +1459,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		bf_set(pde5_type, pde5, LPFC_PDE5_DESCRIPTOR);
 		pde5->reftag = reftag;
 
-		/* Endian convertion if necessary for PDE5 */
+		/* Endianness conversion if necessary for PDE5 */
 		pde5->word0 = cpu_to_le32(pde5->word0);
 		pde5->reftag = cpu_to_le32(pde5->reftag);
 
@@ -1479,7 +1479,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		bf_set(pde6_ai, pde6, 1);
 		bf_set(pde6_apptagval, pde6, apptagval);
 
-		/* Endian convertion if necessary for PDE6 */
+		/* Endianness conversion if necessary for PDE6 */
 		pde6->word0 = cpu_to_le32(pde6->word0);
 		pde6->word1 = cpu_to_le32(pde6->word1);
 		pde6->word2 = cpu_to_le32(pde6->word2);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-08-04 15:31:02.000000000 -0400
@@ -1046,7 +1046,7 @@ lpfc_sli_next_iotag(struct lpfc_hba *phb
 	} else
 		spin_unlock_irq(&phba->hbalock);
 
-	lpfc_printf_log(phba, KERN_ERR,LOG_SLI,
+	lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 			"0318 Failed to allocate IOTAG.last IOTAG is %d\n",
 			psli->last_iotag);
 
@@ -3914,7 +3914,8 @@ lpfc_sli_config_port(struct lpfc_hba *ph
 		phba->sli3_options &= ~(LPFC_SLI3_NPIV_ENABLED |
 					LPFC_SLI3_HBQ_ENABLED |
 					LPFC_SLI3_CRP_ENABLED |
-					LPFC_SLI3_BG_ENABLED);
+					LPFC_SLI3_BG_ENABLED |
+					LPFC_SLI3_DSS_ENABLED);
 		if (rc != MBX_SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0442 Adapter failed to init, mbxCmd x%x "
@@ -3949,8 +3950,23 @@ lpfc_sli_config_port(struct lpfc_hba *ph
 
 		} else
 			phba->max_vpi = 0;
-		if (pmb->u.mb.un.varCfgPort.gdss)
+		phba->fips_level = 0;
+		phba->fips_spec_rev = 0;
+		if (pmb->u.mb.un.varCfgPort.gdss) {
 			phba->sli3_options |= LPFC_SLI3_DSS_ENABLED;
+			phba->fips_level = pmb->u.mb.un.varCfgPort.fips_level;
+			phba->fips_spec_rev = pmb->u.mb.un.varCfgPort.fips_rev;
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2850 Security Crypto Active. FIPS x%d "
+					"(Spec Rev: x%d)",
+					phba->fips_level, phba->fips_spec_rev);
+		}
+		if (pmb->u.mb.un.varCfgPort.sec_err) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2856 Config Port Security Crypto "
+					"Error: x%x ",
+					pmb->u.mb.un.varCfgPort.sec_err);
+		}
 		if (pmb->u.mb.un.varCfgPort.gerbm)
 			phba->sli3_options |= LPFC_SLI3_HBQ_ENABLED;
 		if (pmb->u.mb.un.varCfgPort.gcrp)
@@ -9040,6 +9056,7 @@ lpfc_sli4_sp_handle_cqe(struct lpfc_hba 
 	switch (bf_get(lpfc_cqe_code, &cqevt)) {
 	case CQE_CODE_COMPL_WQE:
 		/* Process the WQ/RQ complete event */
+		phba->last_completion_time = jiffies;
 		workposted = lpfc_sli4_sp_handle_els_wcqe(phba,
 				(struct lpfc_wcqe_complete *)&cqevt);
 		break;
@@ -9050,11 +9067,13 @@ lpfc_sli4_sp_handle_cqe(struct lpfc_hba 
 		break;
 	case CQE_CODE_XRI_ABORTED:
 		/* Process the WQ XRI abort event */
+		phba->last_completion_time = jiffies;
 		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
 				(struct sli4_wcqe_xri_aborted *)&cqevt);
 		break;
 	case CQE_CODE_RECEIVE:
 		/* Process the RQ event */
+		phba->last_completion_time = jiffies;
 		workposted = lpfc_sli4_sp_handle_rcqe(phba,
 				(struct lpfc_rcqe *)&cqevt);
 		break;
@@ -9276,7 +9295,6 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba
 {
 	struct lpfc_wcqe_release wcqe;
 	bool workposted = false;
-	unsigned long iflag;
 
 	/* Copy the work queue CQE and convert endian order if needed */
 	lpfc_sli_pcimem_bcopy(cqe, &wcqe, sizeof(struct lpfc_cqe));
@@ -9285,9 +9303,7 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba
 	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
 	case CQE_CODE_COMPL_WQE:
 		/* Process the WQ complete event */
-		spin_lock_irqsave(&phba->hbalock, iflag);
 		phba->last_completion_time = jiffies;
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		lpfc_sli4_fp_handle_fcp_wcqe(phba,
 				(struct lpfc_wcqe_complete *)&wcqe);
 		break;
@@ -9298,6 +9314,7 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba
 		break;
 	case CQE_CODE_XRI_ABORTED:
 		/* Process the WQ XRI abort event */
+		phba->last_completion_time = jiffies;
 		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
 				(struct sli4_wcqe_xri_aborted *)&wcqe);
 		break;


