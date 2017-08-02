From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 19/21] lpfc: Add Buffer to Buffer credit recovery support
Date: Wed,  2 Aug 2017 16:36:46 -0700
Message-ID: <20170802233648.4573-20-jsmart2021@gmail.com>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33234 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbdHBXiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 19:38:22 -0400
Received: by mail-qt0-f193.google.com with SMTP id u19so6165695qtc.0
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 16:38:21 -0700 (PDT)
In-Reply-To: <20170802233648.4573-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Add Buffer to buffer credit recovery support to the driver.
This is a negotiated feature with the peer that allows for both
sides to detect dropped RRDY's and FC Frames and recover credit.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  3 ++-
 drivers/scsi/lpfc/lpfc_attr.c    | 41 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_attr.h    | 10 ++++++++++
 drivers/scsi/lpfc/lpfc_els.c     | 14 +++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 ++++++++++--
 drivers/scsi/lpfc/lpfc_hw.h      | 18 +++++++++++++++---
 drivers/scsi/lpfc/lpfc_hw4.h     | 23 ++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_init.c    |  5 +++++
 drivers/scsi/lpfc/lpfc_mbox.c    | 35 +++++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_sli4.h    | 15 +++++++++++++++
 10 files changed, 162 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 562dc0139735..50aaae3d966e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -733,7 +733,6 @@ struct lpfc_hba {
 	uint32_t fc_rttov;	/* R_T_TOV timer value */
 	uint32_t fc_altov;	/* AL_TOV timer value */
 	uint32_t fc_crtov;	/* C_R_TOV timer value */
-	uint32_t fc_citov;	/* C_I_TOV timer value */
 
 	struct serv_parm fc_fabparam;	/* fabric service parameters buffer */
 	uint8_t alpa_map[128];	/* AL_PA map from READ_LA */
@@ -757,6 +756,7 @@ struct lpfc_hba {
 #define LPFC_NVMET_MAX_PORTS	32
 	uint8_t  mds_diags_support;
 	uint32_t initial_imax;
+	uint8_t  bbcredit_support;
 
 	/* HBA Config Parameters */
 	uint32_t cfg_ack0;
@@ -836,6 +836,7 @@ struct lpfc_hba {
 	uint32_t cfg_enable_SmartSAN;
 	uint32_t cfg_enable_mds_diags;
 	uint32_t cfg_enable_fc4_type;
+	uint32_t cfg_enable_bbcr;	/*Enable BB Credit Recovery*/
 	uint32_t cfg_xri_split;
 #define LPFC_ENABLE_FCP  1
 #define LPFC_ENABLE_NVME 2
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index d3d01ff44423..0806323829e6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1889,6 +1889,36 @@ static inline bool lpfc_rangecheck(uint val, uint min, uint max)
 }
 
 /**
+ * lpfc_enable_bbcr_set: Sets an attribute value.
+ * @phba: pointer the the adapter structure.
+ * @val: integer attribute value.
+ *
+ * Description:
+ * Validates the min and max values then sets the
+ * adapter config field if in the valid range. prints error message
+ * and does not set the parameter if invalid.
+ *
+ * Returns:
+ * zero on success
+ * -EINVAL if val is invalid
+ */
+static ssize_t
+lpfc_enable_bbcr_set(struct lpfc_hba *phba, uint val)
+{
+	if (lpfc_rangecheck(val, 0, 1) && phba->sli_rev == LPFC_SLI_REV4) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3068 %s_enable_bbcr changed from %d to %d\n",
+				LPFC_DRIVER_NAME, phba->cfg_enable_bbcr, val);
+		phba->cfg_enable_bbcr = val;
+		return 0;
+	}
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"0451 %s_enable_bbcr cannot set to %d, range is 0, 1\n",
+			LPFC_DRIVER_NAME, val);
+	return -EINVAL;
+}
+
+/**
  * lpfc_param_show - Return a cfg attribute value in decimal
  *
  * Description:
@@ -5111,6 +5141,14 @@ LPFC_ATTR_R(sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT, LPFC_DEFAULT_SG_SEG_CNT,
  */
 LPFC_ATTR_R(enable_mds_diags, 0, 0, 1, "Enable MDS Diagnostics");
 
+/*
+ * lpfc_enable_bbcr: Enable BB Credit Recovery
+ *       0  = BB Credit Recovery disabled
+ *       1  = BB Credit Recovery enabled (default)
+ * Value range is [0,1]. Default value is 1.
+ */
+LPFC_BBCR_ATTR_RW(enable_bbcr, 1, 0, 1, "Enable BBC Recovery");
+
 struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_nvme_info,
 	&dev_attr_bg_info,
@@ -5218,6 +5256,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_protocol,
 	&dev_attr_lpfc_xlane_supported,
 	&dev_attr_lpfc_enable_mds_diags,
+	&dev_attr_lpfc_enable_bbcr,
 	NULL,
 };
 
@@ -6229,11 +6268,13 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_nvmet_fb_size_init(phba, lpfc_nvmet_fb_size);
 	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
 	lpfc_nvme_io_channel_init(phba, lpfc_nvme_io_channel);
+	lpfc_enable_bbcr_init(phba, lpfc_enable_bbcr);
 
 	if (phba->sli_rev != LPFC_SLI_REV4) {
 		/* NVME only supported on SLI4 */
 		phba->nvmet_support = 0;
 		phba->cfg_enable_fc4_type = LPFC_ENABLE_FCP;
+		phba->cfg_enable_bbcr = 0;
 	} else {
 		/* We MUST have FCP support */
 		if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
diff --git a/drivers/scsi/lpfc/lpfc_attr.h b/drivers/scsi/lpfc/lpfc_attr.h
index d56dafcdd563..931db52692f5 100644
--- a/drivers/scsi/lpfc/lpfc_attr.h
+++ b/drivers/scsi/lpfc/lpfc_attr.h
@@ -46,6 +46,16 @@ lpfc_param_store(name)\
 static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
 		   lpfc_##name##_show, lpfc_##name##_store)
 
+#define LPFC_BBCR_ATTR_RW(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0444);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_param_show(name)\
+lpfc_param_init(name, defval, minval, maxval)\
+lpfc_param_store(name)\
+static DEVICE_ATTR(lpfc_##name, 0444 | 0644,\
+		   lpfc_##name##_show, lpfc_##name##_store)
+
 #define LPFC_ATTR_HEX_R(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
 module_param(lpfc_##name, uint, S_IRUGO);\
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f97d578ea6bd..0193b144599b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2033,6 +2033,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 
 	sp->cmn.valid_vendor_ver_level = 0;
 	memset(sp->un.vendorVersion, 0, sizeof(sp->un.vendorVersion));
+	sp->cmn.bbRcvSizeMsb &= 0xF;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue PLOGI:     did:x%x",
@@ -3456,8 +3457,18 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				maxretry = 3;
 				delay = 1000;
 				retry = 1;
-				break;
+			} else if (cmd == ELS_CMD_FLOGI &&
+				   stat.un.b.lsRjtRsnCodeExp ==
+						LSEXP_NOTHING_MORE) {
+				vport->fc_sparam.cmn.bbRcvSizeMsb &= 0xf;
+				retry = 1;
+				lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+						 "0820 FLOGI Failed (x%x). "
+						 "BBCredit Not Supported\n",
+						 stat.un.lsRjtError);
 			}
+			break;
+
 		case LSRJT_PROTOCOL_ERR:
 			if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 			  (cmd == ELS_CMD_FDISC) &&
@@ -4209,6 +4220,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			sp->cmn.valid_vendor_ver_level = 0;
 			memset(sp->un.vendorVersion, 0,
 			       sizeof(sp->un.vendorVersion));
+			sp->cmn.bbRcvSizeMsb &= 0xF;
 
 			/* If our firmware supports this feature, convey that
 			 * info to the target using the vendor specific field.
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index aa5e5ff56dfb..20808349a80e 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1108,6 +1108,7 @@ void
 lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
+	uint8_t bbscn = 0;
 
 	if (pmb->u.mb.mbxStatus)
 		goto out;
@@ -1134,10 +1135,17 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	/* Start discovery by sending a FLOGI. port_state is identically
 	 * LPFC_FLOGI while waiting for FLOGI cmpl
 	 */
-	if (vport->port_state != LPFC_FLOGI)
+	if (vport->port_state != LPFC_FLOGI) {
+		if (phba->bbcredit_support && phba->cfg_enable_bbcr) {
+			bbscn = bf_get(lpfc_bbscn_def,
+				       &phba->sli4_hba.bbscn_params);
+			vport->fc_sparam.cmn.bbRcvSizeMsb &= 0xf;
+			vport->fc_sparam.cmn.bbRcvSizeMsb |= (bbscn << 4);
+		}
 		lpfc_initial_flogi(vport);
-	else if (vport->fc_flag & FC_PT2PT)
+	} else if (vport->fc_flag & FC_PT2PT) {
 		lpfc_disc_start(vport);
+	}
 	return;
 
 out:
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 26a5647e057e..bdc1f184f67a 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -2293,15 +2293,27 @@ typedef struct {
 	uint32_t rttov;
 	uint32_t altov;
 	uint32_t crtov;
-	uint32_t citov;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t rsvd4:19;
+	uint32_t cscn:1;
+	uint32_t bbscn:4;
+	uint32_t rsvd3:8;
+#else	/*  __LITTLE_ENDIAN_BITFIELD */
+	uint32_t rsvd3:8;
+	uint32_t bbscn:4;
+	uint32_t cscn:1;
+	uint32_t rsvd4:19;
+#endif
+
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint32_t rrq_enable:1;
 	uint32_t rrq_immed:1;
-	uint32_t rsvd4:29;
+	uint32_t rsvd5:29;
 	uint32_t ack0_enable:1;
 #else	/*  __LITTLE_ENDIAN_BITFIELD */
 	uint32_t ack0_enable:1;
-	uint32_t rsvd4:29;
+	uint32_t rsvd5:29;
 	uint32_t rrq_immed:1;
 	uint32_t rrq_enable:1;
 #endif
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index bb4715705fa3..1db0a38683f4 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2217,9 +2217,15 @@ struct lpfc_mbx_reg_vfi {
 	uint32_t e_d_tov;
 	uint32_t r_a_tov;
 	uint32_t word10;
-#define lpfc_reg_vfi_nport_id_SHIFT		0
-#define lpfc_reg_vfi_nport_id_MASK		0x00FFFFFF
-#define lpfc_reg_vfi_nport_id_WORD		word10
+#define lpfc_reg_vfi_nport_id_SHIFT	0
+#define lpfc_reg_vfi_nport_id_MASK	0x00FFFFFF
+#define lpfc_reg_vfi_nport_id_WORD	word10
+#define lpfc_reg_vfi_bbcr_SHIFT		27
+#define lpfc_reg_vfi_bbcr_MASK		0x00000001
+#define lpfc_reg_vfi_bbcr_WORD		word10
+#define lpfc_reg_vfi_bbscn_SHIFT	28
+#define lpfc_reg_vfi_bbscn_MASK		0x0000000F
+#define lpfc_reg_vfi_bbscn_WORD		word10
 };
 
 struct lpfc_mbx_init_vpi {
@@ -2646,7 +2652,16 @@ struct lpfc_mbx_read_config {
 #define lpfc_mbx_rd_conf_link_speed_MASK	0x0000FFFF
 #define lpfc_mbx_rd_conf_link_speed_WORD	word6
 	uint32_t rsvd_7;
-	uint32_t rsvd_8;
+	uint32_t word8;
+#define lpfc_mbx_rd_conf_bbscn_min_SHIFT	0
+#define lpfc_mbx_rd_conf_bbscn_min_MASK		0x0000000F
+#define lpfc_mbx_rd_conf_bbscn_min_WORD		word8
+#define lpfc_mbx_rd_conf_bbscn_max_SHIFT	4
+#define lpfc_mbx_rd_conf_bbscn_max_MASK		0x0000000F
+#define lpfc_mbx_rd_conf_bbscn_max_WORD		word8
+#define lpfc_mbx_rd_conf_bbscn_def_SHIFT	8
+#define lpfc_mbx_rd_conf_bbscn_def_MASK		0x0000000F
+#define lpfc_mbx_rd_conf_bbscn_def_WORD		word8
 	uint32_t word9;
 #define lpfc_mbx_rd_conf_lmt_SHIFT		0
 #define lpfc_mbx_rd_conf_lmt_MASK		0x0000FFFF
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 659662777b65..19af7e2c2ac0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7630,6 +7630,11 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 					"3082 Mailbox (x%x) returned ldv:x0\n",
 					bf_get(lpfc_mqe_command, &pmb->u.mqe));
+		if (bf_get(lpfc_mbx_rd_conf_bbscn_def, rd_config)) {
+			phba->bbcredit_support = 1;
+			phba->sli4_hba.bbscn_params.word0 = rd_config->word8;
+		}
+
 		phba->sli4_hba.extents_in_use =
 			bf_get(lpfc_mbx_rd_conf_extnts_inuse, rd_config);
 		phba->sli4_hba.max_cfg_param.max_xri =
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index ce25a18367b5..81fb92967b11 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -376,7 +376,12 @@ lpfc_config_link(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 	mb->un.varCfgLnk.rttov = phba->fc_rttov;
 	mb->un.varCfgLnk.altov = phba->fc_altov;
 	mb->un.varCfgLnk.crtov = phba->fc_crtov;
-	mb->un.varCfgLnk.citov = phba->fc_citov;
+	mb->un.varCfgLnk.cscn = 0;
+	if (phba->bbcredit_support && phba->cfg_enable_bbcr) {
+		mb->un.varCfgLnk.cscn = 1;
+		mb->un.varCfgLnk.bbscn = bf_get(lpfc_bbscn_def,
+						 &phba->sli4_hba.bbscn_params);
+	}
 
 	if (phba->cfg_ack0 && (phba->sli_rev < LPFC_SLI_REV4))
 		mb->un.varCfgLnk.ack0_enable = 1;
@@ -2139,6 +2144,7 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport, dma_addr_t phys)
 {
 	struct lpfc_mbx_reg_vfi *reg_vfi;
 	struct lpfc_hba *phba = vport->phba;
+	uint8_t bbscn_fabric = 0, bbscn_max = 0, bbscn_def = 0;
 
 	memset(mbox, 0, sizeof(*mbox));
 	reg_vfi = &mbox->u.mqe.un.reg_vfi;
@@ -2168,16 +2174,39 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport, dma_addr_t phys)
 		bf_set(lpfc_reg_vfi_vp, reg_vfi, 0);
 		bf_set(lpfc_reg_vfi_upd, reg_vfi, 1);
 	}
+
+	bf_set(lpfc_reg_vfi_bbcr, reg_vfi, 0);
+	bf_set(lpfc_reg_vfi_bbscn, reg_vfi, 0);
+	bbscn_fabric = (phba->fc_fabparam.cmn.bbRcvSizeMsb >> 4) & 0xF;
+
+	if (phba->bbcredit_support && phba->cfg_enable_bbcr  &&
+	    bbscn_fabric != 0) {
+		bbscn_max = bf_get(lpfc_bbscn_max,
+				   &phba->sli4_hba.bbscn_params);
+		if (bbscn_fabric <= bbscn_max) {
+			bbscn_def = bf_get(lpfc_bbscn_def,
+					   &phba->sli4_hba.bbscn_params);
+
+			if (bbscn_fabric > bbscn_def)
+				bf_set(lpfc_reg_vfi_bbscn, reg_vfi,
+				       bbscn_fabric);
+			else
+				bf_set(lpfc_reg_vfi_bbscn, reg_vfi, bbscn_def);
+
+			bf_set(lpfc_reg_vfi_bbcr, reg_vfi, 1);
+		}
+	}
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_MBOX,
 			"3134 Register VFI, mydid:x%x, fcfi:%d, "
 			" vfi:%d, vpi:%d, fc_pname:%x%x fc_flag:x%x"
-			" port_state:x%x topology chg:%d\n",
+			" port_state:x%x topology chg:%d bbscn_fabric :%d\n",
 			vport->fc_myDID,
 			phba->fcf.fcfi,
 			phba->sli4_hba.vfi_ids[vport->vfi],
 			phba->vpi_ids[vport->vpi],
 			reg_vfi->wwn[0], reg_vfi->wwn[1], vport->fc_flag,
-			vport->port_state, phba->fc_topology_changed);
+			vport->port_state, phba->fc_topology_changed,
+			bbscn_fabric);
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 7dc8c73b5903..60200385fe00 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -420,6 +420,20 @@ struct lpfc_hba_eq_hdl {
 #define LPFC_MULTI_CPU_AFFINITY 0xffffffff
 };
 
+/*BB Credit recovery value*/
+struct lpfc_bbscn_params {
+	uint32_t word0;
+#define lpfc_bbscn_min_SHIFT		0
+#define lpfc_bbscn_min_MASK		0x0000000F
+#define lpfc_bbscn_min_WORD		word0
+#define lpfc_bbscn_max_SHIFT		4
+#define lpfc_bbscn_max_MASK		0x0000000F
+#define lpfc_bbscn_max_WORD		word0
+#define lpfc_bbscn_def_SHIFT		8
+#define lpfc_bbscn_def_MASK		0x0000000F
+#define lpfc_bbscn_def_WORD		word0
+};
+
 /* Port Capabilities for SLI4 Parameters */
 struct lpfc_pc_sli4_params {
 	uint32_t supported;
@@ -551,6 +565,7 @@ struct lpfc_sli4_hba {
 	uint32_t ue_to_rp;
 	struct lpfc_register sli_intf;
 	struct lpfc_pc_sli4_params pc_sli4_params;
+	struct lpfc_bbscn_params bbscn_params;
 	struct lpfc_hba_eq_hdl *hba_eq_hdl; /* HBA per-WQ handle */
 
 	/* Pointers to the constructed SLI4 queues */
-- 
2.13.1
