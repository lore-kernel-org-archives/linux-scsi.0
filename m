Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E71C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 20:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6BD522247
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 20:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Vx6fdNiT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438477AbgJTU1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 16:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438446AbgJTU1g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 16:27:36 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D404CC0613CE
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 13:27:36 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e7so72326pfn.12
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 13:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=etGCXL6nd2ijFKHChOpGatDc1dhTgv3Dh5tUHGxfuCI=;
        b=Vx6fdNiT48f/Kqgnvg7Ji1SZ6YcVTuztYq8M6XRYiJpKfBtQ9iXiqp4hDWWmP7Mixy
         ZiWfN6CJq8N1oJ4EF2LEbwsEp7WQWyUjYIJ7qptByfcUDl3i0yc+d14SVt/YaopoDgOn
         ysXqhUlylCz1cSdC5ieJnH/Xm3hbHesluHyKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=etGCXL6nd2ijFKHChOpGatDc1dhTgv3Dh5tUHGxfuCI=;
        b=MCOvr9+kq5w8/gp6KuFJLjpYbinGYlJK1HL5TeA6HHvEgtZauYlcK+oW8qZH+EPGxV
         qrvJeEFlneZm0YzqHhQ5kLyK8G/m5SCwHAQX/hWoSYJJJ7dX8fjoGE80XKoMRsQRGQm1
         JQanLTH5GDqaRGfeuvJ8kyP7rTYUliyG8JGmdcwn41dwF2o3BdkyTSvjW1Sw5Bd/e1Ij
         i6OnGDOcZ2JpZIzyY+McZlhHQ7lGpm5qMInX1f3eM148eurZpwieMPWkad8DVgPpVoB5
         fEHHL9behsiQFmOSvZMiux5KPrJPD8ZpDWQ/qqhtzOIQDrLN/g6voOY9CkIg266U7Wsf
         2N/Q==
X-Gm-Message-State: AOAM531a5cKWkQElYNpSEkQPl4i2ghxvE69r6yf7qQHiq2O2HWY6nD5Q
        ThzDz56Bz3eY1D3ZRbUEhbFryPUkpuSNy+ivCPJKyRNLUIMVUcVYiS+InCR4KyutbcjOY/RZ3Ja
        kuYt92egTDTHVReNPsEt9FwsZqYiBDQZ39oodntoHmKZNiO3pMpeDa7dwNWsxvTe0VMSZEQGlDy
        pqnvs=
X-Google-Smtp-Source: ABdhPJzbMEamViqJ2lPdzCdOMLaJH0BuXe1/zcADgM+znbLtqEoR9CU00868TAS8TCRG6Cqq17ZsFw==
X-Received: by 2002:a63:4546:: with SMTP id u6mr59085pgk.311.1603225655499;
        Tue, 20 Oct 2020 13:27:35 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b16sm2871404pfp.195.2020.10.20.13.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:27:34 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 7/9] lpfc: Add FDMI Vendor MIB support
Date:   Tue, 20 Oct 2020 13:27:17 -0700
Message-Id: <20201020202719.54726-8-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020202719.54726-1-james.smart@broadcom.com>
References: <20201020202719.54726-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bafce405b2200f3a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000bafce405b2200f3a
Content-Transfer-Encoding: 8bit

Add vendor-specific MIB support

Created new attribute lpfc_enable_mi, which by default is enabled.

Add command definition bits for sli-4 parameters that recognize whether
the adapter has MIB information support and what revision of MIB data.
Using the adapter information, register vendor-specific MIB support with
FDMI.  The registration will be done every link up.

During FDMI registration, encountered a couple of errors when reverting
to FDMI rev1. Code needed to exist once reverting. Fixed these.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  4 ++-
 drivers/scsi/lpfc/lpfc_attr.c    | 10 ++++++
 drivers/scsi/lpfc/lpfc_ct.c      | 60 ++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_els.c     |  6 ++++
 drivers/scsi/lpfc/lpfc_hbadisc.c |  6 ++--
 drivers/scsi/lpfc/lpfc_hw.h      |  4 ++-
 drivers/scsi/lpfc/lpfc_hw4.h     | 10 ++++--
 drivers/scsi/lpfc/lpfc_init.c    | 15 ++++++++
 drivers/scsi/lpfc/lpfc_sli4.h    |  8 +++++
 9 files changed, 117 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 93e507677bdc..3c77e02d36b0 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -744,7 +744,8 @@ struct lpfc_hba {
 #define LS_NPIV_FAB_SUPPORTED 0x2	/* Fabric supports NPIV */
 #define LS_IGNORE_ERATT       0x4	/* intr handler should ignore ERATT */
 #define LS_MDS_LINK_DOWN      0x8	/* MDS Diagnostics Link Down */
-#define LS_MDS_LOOPBACK      0x10	/* MDS Diagnostics Link Up (Loopback) */
+#define LS_MDS_LOOPBACK       0x10	/* MDS Diagnostics Link Up (Loopback) */
+#define LS_CT_VEN_RPA         0x20	/* Vendor RPA sent to switch */
 
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
@@ -922,6 +923,7 @@ struct lpfc_hba {
 #define LPFC_ENABLE_NVME 2
 #define LPFC_ENABLE_BOTH 3
 	uint32_t cfg_enable_pbde;
+	uint32_t cfg_enable_mi;
 	struct nvmet_fc_target_port *targetport;
 	lpfc_vpd_t vpd;		/* vital product data */
 
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 2d810474875c..0673d944c2a8 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6134,6 +6134,14 @@ LPFC_BBCR_ATTR_RW(enable_bbcr, 1, 0, 1, "Enable BBC Recovery");
  */
 LPFC_ATTR_RW(enable_dpp, 1, 0, 1, "Enable Direct Packet Push");
 
+/*
+ * lpfc_enable_mi: Enable FDMI MIB
+ *       0  = disabled
+ *       1  = enabled (default)
+ * Value range is [0,1].
+ */
+LPFC_ATTR_R(enable_mi, 1, 0, 1, "Enable MI");
+
 struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_nvme_info,
 	&dev_attr_scsi_stat,
@@ -6251,6 +6259,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_ras_fwlog_func,
 	&dev_attr_lpfc_enable_bbcr,
 	&dev_attr_lpfc_enable_dpp,
+	&dev_attr_lpfc_enable_mi,
 	NULL,
 };
 
@@ -7355,6 +7364,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_irq_chann_init(phba, lpfc_irq_chann);
 	lpfc_enable_bbcr_init(phba, lpfc_enable_bbcr);
 	lpfc_enable_dpp_init(phba, lpfc_enable_dpp);
+	lpfc_enable_mi_init(phba, lpfc_enable_mi);
 
 	if (phba->sli_rev != LPFC_SLI_REV4) {
 		/* NVME only supported on SLI4 */
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c201686d3815..bff7d0b3ce7b 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1959,6 +1959,7 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				vport->fdmi_port_mask = LPFC_FDMI1_PORT_ATTR;
 				/* Start over */
 				lpfc_fdmi_cmd(vport, ndlp, cmd, 0);
+				return;
 			}
 			if (vport->fdmi_port_mask == LPFC_FDMI2_SMART_ATTR) {
 				vport->fdmi_port_mask = LPFC_FDMI2_PORT_ATTR;
@@ -1968,12 +1969,21 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			return;
 
 		case SLI_MGMT_RPA:
+			/* No retry on Vendor RPA */
+			if (phba->link_flag & LS_CT_VEN_RPA) {
+				lpfc_printf_vlog(vport, KERN_ERR,
+						 LOG_DISCOVERY | LOG_ELS,
+						 "6460 VEN FDMI RPA failure\n");
+				phba->link_flag &= ~LS_CT_VEN_RPA;
+				return;
+			}
 			if (vport->fdmi_port_mask == LPFC_FDMI2_PORT_ATTR) {
 				/* Fallback to FDMI-1 */
 				vport->fdmi_hba_mask = LPFC_FDMI1_HBA_ATTR;
 				vport->fdmi_port_mask = LPFC_FDMI1_PORT_ATTR;
 				/* Start over */
 				lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA, 0);
+				return;
 			}
 			if (vport->fdmi_port_mask == LPFC_FDMI2_SMART_ATTR) {
 				vport->fdmi_port_mask = LPFC_FDMI2_PORT_ATTR;
@@ -2004,6 +2014,33 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		else
 			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPRT, 0);
 		break;
+	case SLI_MGMT_RPA:
+		if (vport->port_type == LPFC_PHYSICAL_PORT &&
+		    phba->cfg_enable_mi &&
+		    phba->sli4_hba.pc_sli4_params.mi_ver > LPFC_MIB1_SUPPORT) {
+			/* mi is only for the phyical port, no vports */
+			if (phba->link_flag & LS_CT_VEN_RPA) {
+				lpfc_printf_vlog(vport, KERN_INFO,
+						 LOG_DISCOVERY | LOG_ELS,
+						 "6449 VEN RPA Success\n");
+				break;
+			}
+
+			if (lpfc_fdmi_cmd(vport, ndlp, cmd,
+					  LPFC_FDMI_VENDOR_ATTR_mi) == 0)
+				phba->link_flag |= LS_CT_VEN_RPA;
+			lpfc_printf_vlog(vport, KERN_INFO,
+					LOG_DISCOVERY | LOG_ELS,
+					"6458 Send MI FDMI:%x Flag x%x\n",
+					phba->sli4_hba.pc_sli4_params.mi_value,
+					phba->link_flag);
+		} else {
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_DISCOVERY | LOG_ELS,
+					 "6459 No FDMI VEN MI support - "
+					 "RPA Success\n");
+		}
+		break;
 	}
 	return;
 }
@@ -2974,6 +3011,28 @@ lpfc_fdmi_smart_attr_security(struct lpfc_vport *vport,
 	return size;
 }
 
+int
+lpfc_fdmi_vendor_attr_mi(struct lpfc_vport *vport,
+			  struct lpfc_fdmi_attr_def *ad)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_fdmi_attr_entry *ae;
+	uint32_t len, size;
+	char mibrevision[16];
+
+	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	memset(ae, 0, 256);
+	sprintf(mibrevision, "ELXE2EM:%04d",
+		phba->sli4_hba.pc_sli4_params.mi_value);
+	strncpy(ae->un.AttrString, &mibrevision[0], sizeof(ae->un.AttrString));
+	len = strnlen(ae->un.AttrString, sizeof(ae->un.AttrString));
+	len += (len & 3) ? (4 - (len & 3)) : 4;
+	size = FOURBYTES + len;
+	ad->AttrLen = cpu_to_be16(size);
+	ad->AttrType = cpu_to_be16(RPRT_VENDOR_MI);
+	return size;
+}
+
 /* RHBA attribute jump table */
 int (*lpfc_fdmi_hba_action[])
 	(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad) = {
@@ -3025,6 +3084,7 @@ int (*lpfc_fdmi_port_action[])
 	lpfc_fdmi_smart_attr_port_info,     /* bit20  RPRT_SMART_PORT_INFO    */
 	lpfc_fdmi_smart_attr_qos,           /* bit21  RPRT_SMART_QOS          */
 	lpfc_fdmi_smart_attr_security,      /* bit22  RPRT_SMART_SECURITY     */
+	lpfc_fdmi_vendor_attr_mi,           /* bit23  RPRT_VENDOR_MI          */
 };
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f4e274eb6c9c..e24c0b92e992 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3335,6 +3335,12 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
+
+	/* Only keep the ndlp if RDF is being sent */
+	if (!phba->cfg_enable_mi ||
+	    phba->sli4_hba.pc_sli4_params.mi_ver < LPFC_MIB3_SUPPORT)
+		return 0;
+
 	/* This will cause the callback-function lpfc_cmpl_els_cmd to
 	 * trigger the release of node.
 	 */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 68563f717adf..e37660895fef 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3171,7 +3171,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 	}
 
 	phba->fc_topology = bf_get(lpfc_mbx_read_top_topology, la);
-	phba->link_flag &= ~LS_NPIV_FAB_SUPPORTED;
+	phba->link_flag &= ~(LS_NPIV_FAB_SUPPORTED | LS_CT_VEN_RPA);
 
 	shost = lpfc_shost_from_vport(vport);
 	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
@@ -4105,7 +4105,9 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		/* Issue SCR just before NameServer GID_FT Query */
 		lpfc_issue_els_scr(vport, 0);
 
-		lpfc_issue_els_rdf(vport, 0);
+		if (!phba->cfg_enable_mi ||
+		    phba->sli4_hba.pc_sli4_params.mi_ver < LPFC_MIB3_SUPPORT)
+			lpfc_issue_els_rdf(vport, 0);
 	}
 
 	vport->fc_ns_retry = 0;
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index c20034b3101c..28b8a394f796 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1465,7 +1465,7 @@ struct lpfc_fdmi_reg_portattr {
 #define LPFC_FDMI2_HBA_ATTR			0x0002efff
 
 /*
- * Port Attrubute Types
+ * Port Attribute Types
  */
 #define  RPRT_SUPPORTED_FC4_TYPES     0x1 /* 32 byte binary array */
 #define  RPRT_SUPPORTED_SPEED         0x2 /* 32-bit unsigned int */
@@ -1483,6 +1483,7 @@ struct lpfc_fdmi_reg_portattr {
 #define  RPRT_PORT_STATE              0x101 /* 32-bit unsigned int */
 #define  RPRT_DISC_PORT               0x102 /* 32-bit unsigned int */
 #define  RPRT_PORT_ID                 0x103 /* 32-bit unsigned int */
+#define  RPRT_VENDOR_MI               0xf047 /* vendor ascii string */
 #define  RPRT_SMART_SERVICE           0xf100 /* 4 to 256 byte ASCII string */
 #define  RPRT_SMART_GUID              0xf101 /* 8 byte WWNN + 8 byte WWPN */
 #define  RPRT_SMART_VERSION           0xf102 /* 4 to 256 byte ASCII string */
@@ -1515,6 +1516,7 @@ struct lpfc_fdmi_reg_portattr {
 #define LPFC_FDMI_SMART_ATTR_port_info		0x00100000 /* Vendor specific */
 #define LPFC_FDMI_SMART_ATTR_qos		0x00200000 /* Vendor specific */
 #define LPFC_FDMI_SMART_ATTR_security		0x00400000 /* Vendor specific */
+#define LPFC_FDMI_VENDOR_ATTR_mi		0x00800000 /* Vendor specific */
 
 /* Bit mask for FDMI-1 defined PORT attributes */
 #define LPFC_FDMI1_PORT_ATTR			0x0000003f
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 12e4e76233e6..49f5559f5fed 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3506,8 +3506,14 @@ struct lpfc_sli4_parameters {
 #define cfg_max_tow_xri_MASK			0x0000ffff
 #define cfg_max_tow_xri_WORD			word20
 
-	uint32_t word21;                        /* RESERVED */
-	uint32_t word22;                        /* RESERVED */
+	uint32_t word21;
+#define cfg_mib_bde_cnt_SHIFT			16
+#define cfg_mib_bde_cnt_MASK			0x000000ff
+#define cfg_mib_bde_cnt_WORD			word21
+#define cfg_mi_ver_SHIFT			0
+#define cfg_mi_ver_MASK				0x0000ffff
+#define cfg_mi_ver_WORD				word21
+	uint32_t mib_size;
 	uint32_t word23;                        /* RESERVED */
 
 	uint32_t word24;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d2c172348065..7dd980999e32 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12315,6 +12315,21 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	else
 		phba->nsler = 0;
 
+	/* Save PB info for use during HBA setup */
+	sli4_params->mi_ver = bf_get(cfg_mi_ver, mbx_sli4_parameters);
+	sli4_params->mib_bde_cnt = bf_get(cfg_mib_bde_cnt, mbx_sli4_parameters);
+	sli4_params->mib_size = mbx_sli4_parameters->mib_size;
+	sli4_params->mi_value = LPFC_DFLT_MIB_VAL;
+
+	/* Next we check for Vendor MIB support */
+	if (sli4_params->mi_ver && phba->cfg_enable_mi)
+		phba->cfg_fdmi_on = LPFC_FDMI_SUPPORT;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"6461 MIB attr %d  enable %d  FDMI %d buf %d:%d\n",
+			sli4_params->mi_ver, phba->cfg_enable_mi,
+			sli4_params->mi_value, sli4_params->mib_bde_cnt,
+			sli4_params->mib_size);
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 100cb1a94811..26f19c95380f 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -549,6 +549,14 @@ struct lpfc_pc_sli4_params {
 	uint32_t hdr_pp_align;
 	uint32_t sgl_pages_max;
 	uint32_t sgl_pp_align;
+	uint32_t mib_size;
+	uint16_t mi_ver;
+#define LPFC_MIB1_SUPPORT	1
+#define LPFC_MIB2_SUPPORT	2
+#define LPFC_MIB3_SUPPORT	3
+	uint16_t mi_value;
+#define LPFC_DFLT_MIB_VAL	2
+	uint8_t mib_bde_cnt;
 	uint8_t cqv;
 	uint8_t mqv;
 	uint8_t wqv;
-- 
2.26.2


--000000000000bafce405b2200f3a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgxvV3ByhykQyGTmIP
9VxkRHyRSs7khzTiBKVm+P2NxKQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDIwMjAyNzM2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIVDhKnkSwxnLCx7s8ZieG3n82h5I/V+ymMi
iSrRYtLS/0v/LwS3quNr1k4UWFOMAIXQMJOzh7cSA/yYTbzJg45hixsOMycjUX91tvef11+fma4v
jmGBV8clnHJA472KlRFP+lai+9HEFlur5xXGKZIj7s7qS+vLIDLcgeYfuvB4iu6CEfTz++hfveeF
e0WAGMrAaryzXPT1EzPqZOsXqWLjsVcP2cowFaIK8+99sx9hCe7rE4CeX72481RUY8p0cqkw9w+h
tFvHHoaoxDPldHyJ1tt3qnZAmHkWX4ssRnqg1ZfGLO9hv2AmHAdnigp1sR3Qx72tHE9+35dUfFZQ
nzE=
--000000000000bafce405b2200f3a--
