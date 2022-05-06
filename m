Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C207DC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388863AbiEFD70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388848AbiEFD7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:22 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB2EE081
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k1so6241086pll.4
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ImEs3MtGPJm05uXAkraOHBIjk/i143u5sGN6prQhn08=;
        b=d/gFxna4N4wjok27U5TbNXlzg6nc6mcqnNwWyN/yzEt0drmH1O3d60uNxf0gnKOU4q
         bKXwhEmV7pTOLnU7zW6XCsrUYZoZNMXmQx15ghuOD6ZZT6r6zWPk5jEQZMY0pcvRZJ8I
         mrevVdAn2PJfc4wqjvXzghT501xi5ClkNnIBOrerWvTpYcKCr2WPo94geAtm/wyrn4yz
         w14w7jVQwjVGz1qEYMHunnCu2SAPOdTE0AQmCgrwryyNf3sBh10CMIxHdC5IMAqTQtEH
         XWzjKkD6JRRpS44LBjfXM71T7a92QLzl3axXc+b1xU2BUzODCbcDOia/ISNsCwOwIe1U
         J1Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ImEs3MtGPJm05uXAkraOHBIjk/i143u5sGN6prQhn08=;
        b=7mgbilaPJ2KsopFmUtzBSnRZKL1C/8NXITWreQrAe09/Bn27Nr/hzD7SyNgR5X7yU3
         jFlQjlUOBGPRoRmkImJaTS7JgD9+DPtxOsS75AlowVc/ZIomu44UuigHdzWi/Pyh1djJ
         jfnLdm82Ioi2TzvcxB3KZOcOUbTieHdxXhGsCP6WgzoA6Nhs79LP+YvI67wHuA8AvG7O
         toa1SEzYpP9564tY48/NMAfKtlt9NLZwHHLf8o1BG8KN0sqzY7+oi/ljXFAmITMLewRC
         2U6dNVWMF+BghXCx2RKcyzpbvqms8dt24/T9BPM4OCI0afQu3zD3iqChFH5mJUAtEVzi
         yPbw==
X-Gm-Message-State: AOAM5336mpUXsdbld5iu3Wn4za2DJtQZPqM/HU4v8/YPKU8Ud1xpvYc9
        73lN1sVc62JjaiKWAfV4/MkIBQrfiEY=
X-Google-Smtp-Source: ABdhPJzW3k5QXGPKcq0aVB1eWEfy27CoJ5vC4WG+OeaVCiUwCZ1qA5ezlp7a9151eCX0x1o6NqOtww==
X-Received: by 2002:a17:902:bf0a:b0:15c:df1b:f37d with SMTP id bi10-20020a170902bf0a00b0015cdf1bf37dmr1562570plb.90.1651809335054;
        Thu, 05 May 2022 20:55:35 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:34 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 09/12] lpfc: Rework FDMI initialization after link up
Date:   Thu,  5 May 2022 20:55:16 -0700
Message-Id: <20220506035519.50908-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After a link up, it's possible for the switch to change FDMI support (e.g.
FDMI1 vs FDMI2 vs SmartSAN).  If the switch reverts to FDMI1, then the
revert is currently not detected.

Additionally, when NPIV is configured, it's possible the physical port's
RHBA is unprocessed by the switch before reciept of an NPIV port issued
RPRT.  This causes some switches vendors to reject the NPIV's RPRT.

Fix by reinitializing base FDMI mode on link up, and defer FDMI vport RPRT
submission until after confirming physical port's RHBA is completed.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  2 +
 drivers/scsi/lpfc/lpfc_crtn.h    |  1 +
 drivers/scsi/lpfc/lpfc_ct.c      | 98 +++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  5 +-
 drivers/scsi/lpfc/lpfc_init.c    | 43 ++++++++++----
 5 files changed, 129 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index f8f5b4a2d523..da9070cdad91 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -612,6 +612,7 @@ struct lpfc_vport {
 #define FC_CT_RSNN_NN		0x4	 /* RSNN_NN accepted by switch */
 #define FC_CT_RSPN_ID		0x8	 /* RSPN_ID accepted by switch */
 #define FC_CT_RFT_ID		0x10	 /* RFT_ID accepted by switch */
+#define FC_CT_RPRT_DEFER	0x20	 /* Defer issuing FDMI RPRT */
 
 	struct list_head fc_nodes;
 
@@ -1059,6 +1060,7 @@ struct lpfc_hba {
 #define HBA_HBEAT_INP		0x4000000 /* mbox HBEAT is in progress */
 #define HBA_HBEAT_TMO		0x8000000 /* HBEAT initiated after timeout */
 #define HBA_FLOGI_OUTSTANDING	0x10000000 /* FLOGI is outstanding */
+#define HBA_RHBA_CMPL		0x20000000 /* RHBA FDMI command is successful */
 
 	struct completion *fw_dump_cmpl; /* cmpl event tracker for fw_dump */
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 6f88fd0df8b0..b0775be31d5c 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -434,6 +434,7 @@ void lpfc_nvmet_buf_free(struct lpfc_hba *phba, void *virtp, dma_addr_t dma);
 
 void lpfc_in_buf_free(struct lpfc_hba *, struct lpfc_dmabuf *);
 void lpfc_rq_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp);
+void lpfc_setup_fdmi_mask(struct lpfc_vport *vport);
 int lpfc_link_reset(struct lpfc_vport *vport);
 
 /* Function prototypes. */
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 094199d1006a..9d36b20fb878 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2167,6 +2167,41 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	return 1;
 }
 
+/**
+ * lpfc_fdmi_rprt_defer - Check for any deferred FDMI RPRT commands
+ * @phba: Pointer to HBA context object.
+ * @mask: Initial port attributes mask
+ *
+ * This function checks to see if any vports have deferred their FDMI RPRT.
+ * A vports RPRT may be deferred if it is issued before the primary ports
+ * RHBA completes.
+ */
+static void
+lpfc_fdmi_rprt_defer(struct lpfc_hba *phba, uint32_t mask)
+{
+	struct lpfc_vport **vports;
+	struct lpfc_vport *vport;
+	struct lpfc_nodelist *ndlp;
+	int i;
+
+	phba->hba_flag |= HBA_RHBA_CMPL;
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+			vport = vports[i];
+			ndlp = lpfc_findnode_did(phba->pport, FDMI_DID);
+			if (!ndlp)
+				continue;
+			if (vport->ct_flags & FC_CT_RPRT_DEFER) {
+				vport->ct_flags &= ~FC_CT_RPRT_DEFER;
+				vport->fdmi_port_mask = mask;
+				lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPRT, 0);
+			}
+		}
+	}
+	lpfc_destroy_vport_work_array(phba, vports);
+}
+
 /**
  * lpfc_cmpl_ct_disc_fdmi - Handle a discovery FDMI completion
  * @phba: Pointer to HBA context object.
@@ -2255,8 +2290,12 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		switch (cmd) {
 		case SLI_MGMT_RHBA:
 			if (vport->fdmi_hba_mask == LPFC_FDMI2_HBA_ATTR) {
-				/* Fallback to FDMI-1 */
+				/* Fallback to FDMI-1 for HBA attributes */
 				vport->fdmi_hba_mask = LPFC_FDMI1_HBA_ATTR;
+
+				/* If HBA attributes are FDMI1, so should
+				 * port attributes be for consistency.
+				 */
 				vport->fdmi_port_mask = LPFC_FDMI1_PORT_ATTR;
 				/* Start over */
 				lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA, 0);
@@ -2264,6 +2303,11 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			return;
 
 		case SLI_MGMT_RPRT:
+			if (vport->port_type != LPFC_PHYSICAL_PORT) {
+				ndlp = lpfc_findnode_did(phba->pport, FDMI_DID);
+				if (!ndlp)
+					return;
+			}
 			if (vport->fdmi_port_mask == LPFC_FDMI2_PORT_ATTR) {
 				/* Fallback to FDMI-1 */
 				vport->fdmi_port_mask = LPFC_FDMI1_PORT_ATTR;
@@ -2313,6 +2357,9 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 */
 	switch (cmd) {
 	case SLI_MGMT_RHBA:
+		/* Check for any RPRTs deferred till after RHBA completes */
+		lpfc_fdmi_rprt_defer(phba, vport->fdmi_port_mask);
+
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPA, 0);
 		break;
 
@@ -2321,10 +2368,26 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		break;
 
 	case SLI_MGMT_DPRT:
-		if (vport->port_type == LPFC_PHYSICAL_PORT)
+		if (vport->port_type == LPFC_PHYSICAL_PORT) {
 			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RHBA, 0);
-		else
-			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPRT, 0);
+		} else {
+			ndlp = lpfc_findnode_did(phba->pport, FDMI_DID);
+			if (!ndlp)
+				return;
+
+			/* Only issue a RPRT for the vport if the RHBA
+			 * for the physical port completes successfully.
+			 * We may have to defer the RPRT accordingly.
+			 */
+			if (phba->hba_flag & HBA_RHBA_CMPL) {
+				lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPRT, 0);
+			} else {
+				lpfc_printf_vlog(vport, KERN_INFO,
+						 LOG_DISCOVERY,
+						 "6078 RPRT deferred\n");
+				vport->ct_flags |= FC_CT_RPRT_DEFER;
+			}
+		}
 		break;
 	case SLI_MGMT_RPA:
 		if (vport->port_type == LPFC_PHYSICAL_PORT &&
@@ -2339,7 +2402,8 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				break;
 			}
 
-			lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+			lpfc_printf_log(phba, KERN_INFO,
+					LOG_DISCOVERY | LOG_CGN_MGMT,
 					"6210 Issue Vendor MI FDMI %x\n",
 					phba->sli4_hba.pc_sli4_params.mi_ver);
 
@@ -2408,6 +2472,9 @@ lpfc_fdmi_change_check(struct lpfc_vport *vport)
 			phba->link_flag &= ~LS_CT_VEN_RPA;
 			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA, 0);
 		} else {
+			ndlp = lpfc_findnode_did(phba->pport, FDMI_DID);
+			if (!ndlp)
+				return;
 			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DPRT, 0);
 		}
 
@@ -2429,6 +2496,9 @@ lpfc_fdmi_change_check(struct lpfc_vport *vport)
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPA,
 			      LPFC_FDMI_PORT_ATTR_num_disc);
 	} else {
+		ndlp = lpfc_findnode_did(phba->pport, FDMI_DID);
+		if (!ndlp)
+			return;
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPRT,
 			      LPFC_FDMI_PORT_ATTR_num_disc);
 	}
@@ -3501,8 +3571,10 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	/* FDMI request */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-			 "0218 FDMI Request Data: x%x x%x x%x\n",
-			 vport->fc_flag, vport->port_state, cmdcode);
+			 "0218 FDMI Request x%x mask x%x Data: x%x x%x x%x\n",
+			 cmdcode, new_mask, vport->fdmi_port_mask,
+			 vport->fc_flag, vport->port_state);
+
 	CtReq = (struct lpfc_sli_ct_request *)mp->virt;
 
 	/* First populate the CT_IU preamble */
@@ -3571,6 +3643,12 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		break;
 
 	case SLI_MGMT_RPRT:
+		if (vport->port_type != LPFC_PHYSICAL_PORT) {
+			ndlp = lpfc_findnode_did(phba->pport, FDMI_DID);
+			if (!ndlp)
+				return 0;
+		}
+		fallthrough;
 	case SLI_MGMT_RPA:
 		pab = (struct lpfc_fdmi_reg_portattr *)&CtReq->un.PortID;
 		if (cmdcode == SLI_MGMT_RPRT) {
@@ -3635,6 +3713,12 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		rsp_size = FC_MAX_NS_RSP;
 		fallthrough;
 	case SLI_MGMT_DPRT:
+		if (vport->port_type != LPFC_PHYSICAL_PORT) {
+			ndlp = lpfc_findnode_did(phba->pport, FDMI_DID);
+			if (!ndlp)
+				return 0;
+		}
+		fallthrough;
 	case SLI_MGMT_DPA:
 		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un.PortID;
 		memcpy((uint8_t *)&pe->PortName,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 3ab22ac49e49..fb36f26170e4 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1359,6 +1359,7 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 	vport->fc_flag |= FC_NDISC_ACTIVE;
 	vport->fc_ns_retry = 0;
 	spin_unlock_irq(shost->host_lock);
+	lpfc_setup_fdmi_mask(vport);
 
 	lpfc_linkup_cleanup_nodes(vport);
 }
@@ -1390,8 +1391,8 @@ lpfc_linkup(struct lpfc_hba *phba)
 	phba->pport->rcv_flogi_cnt = 0;
 	spin_unlock_irq(shost->host_lock);
 
-	/* reinitialize initial FLOGI flag */
-	phba->hba_flag &= ~(HBA_FLOGI_ISSUED);
+	/* reinitialize initial HBA flag */
+	phba->hba_flag &= ~(HBA_FLOGI_ISSUED | HBA_RHBA_CMPL);
 	phba->defer_flogi_acc_flag = false;
 
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 39267016f339..0dedb7cf621b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9002,6 +9002,36 @@ lpfc_hba_free(struct lpfc_hba *phba)
 	return;
 }
 
+/**
+ * lpfc_setup_fdmi_mask - Setup initial FDMI mask for HBA and Port attributes
+ * @vport: pointer to lpfc vport data structure.
+ *
+ * This routine is will setup initial FDMI attribute masks for
+ * FDMI2 or SmartSAN depending on module parameters. The driver will attempt
+ * to get these attributes first before falling back, the attribute
+ * fallback hierarchy is SmartSAN -> FDMI2 -> FMDI1
+ **/
+void
+lpfc_setup_fdmi_mask(struct lpfc_vport *vport)
+{
+	struct lpfc_hba *phba = vport->phba;
+
+	vport->load_flag |= FC_ALLOW_FDMI;
+	if (phba->cfg_enable_SmartSAN ||
+	    phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT) {
+		/* Setup appropriate attribute masks */
+		vport->fdmi_hba_mask = LPFC_FDMI2_HBA_ATTR;
+		if (phba->cfg_enable_SmartSAN)
+			vport->fdmi_port_mask = LPFC_FDMI2_SMART_ATTR;
+		else
+			vport->fdmi_port_mask = LPFC_FDMI2_PORT_ATTR;
+	}
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
+			"6077 Setup FDMI mask: hba x%x port x%x\n",
+			vport->fdmi_hba_mask, vport->fdmi_port_mask);
+}
+
 /**
  * lpfc_create_shost - Create hba physical port with associated scsi host.
  * @phba: pointer to lpfc hba data structure.
@@ -9045,21 +9075,12 @@ lpfc_create_shost(struct lpfc_hba *phba)
 	/* Put reference to SCSI host to driver's device private data */
 	pci_set_drvdata(phba->pcidev, shost);
 
+	lpfc_setup_fdmi_mask(vport);
+
 	/*
 	 * At this point we are fully registered with PSA. In addition,
 	 * any initial discovery should be completed.
 	 */
-	vport->load_flag |= FC_ALLOW_FDMI;
-	if (phba->cfg_enable_SmartSAN ||
-	    (phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT)) {
-
-		/* Setup appropriate attribute masks */
-		vport->fdmi_hba_mask = LPFC_FDMI2_HBA_ATTR;
-		if (phba->cfg_enable_SmartSAN)
-			vport->fdmi_port_mask = LPFC_FDMI2_SMART_ATTR;
-		else
-			vport->fdmi_port_mask = LPFC_FDMI2_PORT_ATTR;
-	}
 	return 0;
 }
 
-- 
2.26.2

