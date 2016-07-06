From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 07/21] lpfc: Add MDS Diagnostics Support
Date: Wed, 06 Jul 2016 12:36:00 -0700
Message-ID: <577d5da0.TMt6yjHe/yCTv5fJ%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37332 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbcGFTgG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:06 -0400
Received: by mail-wm0-f47.google.com with SMTP id a66so5729933wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:05 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id d137sm1271553wmd.12.2016.07.06.12.36.02
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add MDS Diagnostics Support

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  4 ++-
 drivers/scsi/lpfc/lpfc_attr.c | 10 +++++++
 drivers/scsi/lpfc/lpfc_els.c  |  7 +++++
 drivers/scsi/lpfc/lpfc_hw4.h  | 14 +++++++++-
 drivers/scsi/lpfc/lpfc_init.c | 28 +++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c  | 65 ++++++++++++++++++++++++++++---------------
 6 files changed, 103 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 64d6e33..69da16d 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -695,7 +695,8 @@ struct lpfc_hba {
 	uint8_t  wwnn[8];
 	uint8_t  wwpn[8];
 	uint32_t RandomData[7];
-	uint32_t fcp_embed_io;
+	uint8_t  fcp_embed_io;
+	uint8_t  mds_diags_support;
 
 	/* HBA Config Parameters */
 	uint32_t cfg_ack0;
@@ -760,6 +761,7 @@ struct lpfc_hba {
 #define LPFC_FDMI_NO_SUPPORT	0	/* FDMI not supported */
 #define LPFC_FDMI_SUPPORT	1	/* FDMI supported? */
 	uint32_t cfg_enable_SmartSAN;
+	uint32_t cfg_enable_mds_diags;
 	lpfc_vpd_t vpd;		/* vital product data */
 
 	struct pci_dev *pcidev;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index cfec2ec..cde7da6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4780,6 +4780,14 @@ LPFC_ATTR_R(prot_sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT,
 	    LPFC_DEFAULT_SG_SEG_CNT, LPFC_MAX_SG_SEG_CNT,
 	    "Max Protection Scatter Gather Segment Count");
 
+/*
+ * lpfc_enable_mds_diags: Enable MDS Diagnostics
+ *       0  = MDS Diagnostics disabled (default)
+ *       1  = MDS Diagnostics enabled
+ * Value range is [0,1]. Default value is 0.
+ */
+LPFC_ATTR_R(enable_mds_diags, 0, 0, 1, "Enable MDS Diagnostics");
+
 struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_bg_info,
 	&dev_attr_bg_guard_err,
@@ -4876,6 +4884,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_sriov_hw_max_virtfn,
 	&dev_attr_protocol,
 	&dev_attr_lpfc_xlane_supported,
+	&dev_attr_lpfc_enable_mds_diags,
 	NULL,
 };
 
@@ -5867,6 +5876,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
 	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
 	phba->cfg_enable_dss = 1;
+	lpfc_enable_mds_diags_init(phba, lpfc_enable_mds_diags);
 	return;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 861270e..5afbf4d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3299,6 +3299,12 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 						     FC_VPORT_FABRIC_REJ_WWN);
 			}
 			break;
+		case LSRJT_VENDOR_UNIQUE:
+			if ((stat.un.b.vendorUnique == 0x45) &&
+			    (cmd == ELS_CMD_FLOGI)) {
+				goto out_retry;
+			}
+			break;
 		}
 		break;
 
@@ -3344,6 +3350,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if ((vport->load_flag & FC_UNLOADING) != 0)
 		retry = 0;
 
+out_retry:
 	if (retry) {
 		if ((cmd == ELS_CMD_PLOGI) || (cmd == ELS_CMD_FDISC)) {
 			/* Stop retrying PLOGI and FDISC if in FCF discovery */
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 8738b3d..ee80227 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2888,9 +2888,13 @@ struct lpfc_sli4_parameters {
 #define cfg_ext_embed_cb_SHIFT			0
 #define cfg_ext_embed_cb_MASK			0x00000001
 #define cfg_ext_embed_cb_WORD			word19
+#define cfg_mds_diags_SHIFT			1
+#define cfg_mds_diags_MASK			0x00000001
+#define cfg_mds_diags_WORD			word19
 };
 
-#define LPFC_SET_UE_RECOVERY            0x10
+#define LPFC_SET_UE_RECOVERY		0x10
+#define LPFC_SET_MDS_DIAGS		0x11
 struct lpfc_mbx_set_feature {
 	struct mbox_header header;
 	uint32_t feature;
@@ -2899,6 +2903,12 @@ struct lpfc_mbx_set_feature {
 #define lpfc_mbx_set_feature_UER_SHIFT  0
 #define lpfc_mbx_set_feature_UER_MASK   0x00000001
 #define lpfc_mbx_set_feature_UER_WORD   word6
+#define lpfc_mbx_set_feature_mds_SHIFT  0
+#define lpfc_mbx_set_feature_mds_MASK   0x00000001
+#define lpfc_mbx_set_feature_mds_WORD   word6
+#define lpfc_mbx_set_feature_mds_deep_loopbk_SHIFT  1
+#define lpfc_mbx_set_feature_mds_deep_loopbk_MASK   0x00000001
+#define lpfc_mbx_set_feature_mds_deep_loopbk_WORD   word6
 	uint32_t word7;
 #define lpfc_mbx_set_feature_UERP_SHIFT 0
 #define lpfc_mbx_set_feature_UERP_MASK  0x0000ffff
@@ -3464,6 +3474,8 @@ struct lpfc_acqe_fc_la {
 #define LPFC_FC_LA_TYPE_LINK_UP		0x1
 #define LPFC_FC_LA_TYPE_LINK_DOWN	0x2
 #define LPFC_FC_LA_TYPE_NO_HARD_ALPA	0x3
+#define LPFC_FC_LA_TYPE_MDS_LINK_DOWN	0x4
+#define LPFC_FC_LA_TYPE_MDS_LOOPBACK	0x5
 #define lpfc_acqe_fc_la_port_type_SHIFT		6
 #define lpfc_acqe_fc_la_port_type_MASK		0x00000003
 #define lpfc_acqe_fc_la_port_type_WORD		word0
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f11e33e..bb514d2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4040,6 +4040,8 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 {
 	struct lpfc_dmabuf *mp;
 	LPFC_MBOXQ_t *pmb;
+	MAILBOX_t *mb;
+	struct lpfc_mbx_read_top *la;
 	int rc;
 
 	if (bf_get(lpfc_trailer_type, acqe_fc) !=
@@ -4110,6 +4112,24 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_topology;
 	pmb->vport = phba->pport;
 
+	if (phba->sli4_hba.link_state.status != LPFC_FC_LA_TYPE_LINK_UP) {
+		/* Parse and translate status field */
+		mb = &pmb->u.mb;
+		mb->mbxStatus = lpfc_sli4_parse_latt_fault(phba,
+							   (void *)acqe_fc);
+
+		/* Parse and translate link attention fields */
+		la = (struct lpfc_mbx_read_top *)&pmb->u.mb.un.varReadTop;
+		la->eventTag = acqe_fc->event_tag;
+		bf_set(lpfc_mbx_read_top_att_type, la,
+		       LPFC_FC_LA_TYPE_LINK_DOWN);
+
+		/* Invoke the mailbox command callback function */
+		lpfc_mbx_cmpl_read_topology(phba, pmb);
+
+		return;
+	}
+
 	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED)
 		goto out_free_dmabuf;
@@ -9585,6 +9605,14 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		phba->fcp_embed_io = 1;
 	else
 		phba->fcp_embed_io = 0;
+
+	/*
+	 * Check if the SLI port supports MDS Diagnostics
+	 */
+	if (bf_get(cfg_mds_diags, mbx_sli4_parameters))
+		phba->mds_diags_support = 1;
+	else
+		phba->mds_diags_support = 0;
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b3a781d..6eef972 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5691,37 +5691,35 @@ lpfc_sli4_dealloc_extent(struct lpfc_hba *phba, uint16_t type)
 }
 
 void
-lpfc_set_features(struct lpfc_hba *phba)
+lpfc_set_features(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox,
+		  uint32_t feature)
 {
-	LPFC_MBOXQ_t *mbox = NULL;
 	uint32_t len;
-	int rc;
 
-	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mbox)
-		return;
 	len = sizeof(struct lpfc_mbx_set_feature) -
 		sizeof(struct lpfc_sli4_cfg_mhdr);
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
 			 LPFC_MBOX_OPCODE_SET_FEATURES, len,
 			 LPFC_SLI4_MBX_EMBED);
-	bf_set(lpfc_mbx_set_feature_UER,
-	       &mbox->u.mqe.un.set_feature, 1);
-	mbox->u.mqe.un.set_feature.feature = LPFC_SET_UE_RECOVERY;
-	mbox->u.mqe.un.set_feature.param_len = 8;
-	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 
-	if (rc != MBX_SUCCESS) {
-		mempool_free(mbox, phba->mbox_mem_pool);
-		return;
+	switch (feature) {
+	case LPFC_SET_UE_RECOVERY:
+		bf_set(lpfc_mbx_set_feature_UER,
+		       &mbox->u.mqe.un.set_feature, 1);
+		mbox->u.mqe.un.set_feature.feature = LPFC_SET_UE_RECOVERY;
+		mbox->u.mqe.un.set_feature.param_len = 8;
+		break;
+	case LPFC_SET_MDS_DIAGS:
+		bf_set(lpfc_mbx_set_feature_mds,
+		       &mbox->u.mqe.un.set_feature, 1);
+		bf_set(lpfc_mbx_set_feature_mds_deep_loopbk,
+		       &mbox->u.mqe.un.set_feature, 0);
+		mbox->u.mqe.un.set_feature.feature = LPFC_SET_MDS_DIAGS;
+		mbox->u.mqe.un.set_feature.param_len = 8;
+		break;
 	}
-	phba->hba_flag |= HBA_RECOVERABLE_UE;
-	phba->eratt_poll_interval = 1;  /* Set 1Sec interval to detect UE */
-	phba->sli4_hba.ue_to_sr = bf_get(lpfc_mbx_set_feature_UESR,
-					 &mbox->u.mqe.un.set_feature);
-	phba->sli4_hba.ue_to_rp = bf_get(lpfc_mbx_set_feature_UERP,
-					 &mbox->u.mqe.un.set_feature);
-	mempool_free(mbox, phba->mbox_mem_pool);
+
+	return;
 }
 
 /**
@@ -6449,8 +6447,29 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	}
 
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
-	    LPFC_SLI_INTF_IF_TYPE_0)
-		lpfc_set_features(phba);
+	    LPFC_SLI_INTF_IF_TYPE_0) {
+		lpfc_set_features(phba, mboxq, LPFC_SET_UE_RECOVERY);
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+		if (rc == MBX_SUCCESS) {
+			phba->hba_flag |= HBA_RECOVERABLE_UE;
+			/* Set 1Sec interval to detect UE */
+			phba->eratt_poll_interval = 1;
+			phba->sli4_hba.ue_to_sr = bf_get(
+					lpfc_mbx_set_feature_UESR,
+					&mboxq->u.mqe.un.set_feature);
+			phba->sli4_hba.ue_to_rp = bf_get(
+					lpfc_mbx_set_feature_UERP,
+					&mboxq->u.mqe.un.set_feature);
+		}
+	}
+
+	if (phba->cfg_enable_mds_diags && phba->mds_diags_support) {
+		/* Enable MDS Diagnostics only if the SLI Port supports it */
+		lpfc_set_features(phba, mboxq, LPFC_SET_MDS_DIAGS);
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+		if (rc != MBX_SUCCESS)
+			phba->mds_diags_support = 0;
+	}
 
 	/*
 	 * Discover the port's supported feature set and match it against the
-- 
2.5.0

