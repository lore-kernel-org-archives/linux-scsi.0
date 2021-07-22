Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3836C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E6A360EB0
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhGVVhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 17:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbhGVVhE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 17:37:04 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911EBC06175F
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:38 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e14so944096plh.8
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S6L5JoLm7ERfQzYreo0rw0ybPp7foqqDbX/XALrv3ns=;
        b=Q4IQH0qbWhdgZLzD44A836Lzqmdy9iCI+Cwn0e3tHj3IP7FUJAOQc7FgrnjrBlEQ4t
         olJLA7RK65gD+tfOL2bMACGx1dliiW2kgGoAr1DImvm8X4/PSiaYtoayOKwPNSpSeuuT
         D0tq0xfNP8puUzFX6CCYR1AirvYniIaO5Xx2dLTt+iP64DZVO5vtHTdUXexVFTbwCG9R
         +7paNTEZRmcUASXLpN0pcQ8xJ0TfI4Rvbrxt3fWxWwiVCzlz0LmUOGKJEeV2KpUdQ/lU
         OPn4t/l0ot/w/VRnbjkdzNFepFqj6Y6paGfao/g9qw3riJYlTnXYb6Rh4oi9lGpppat4
         S47A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S6L5JoLm7ERfQzYreo0rw0ybPp7foqqDbX/XALrv3ns=;
        b=MzxJs74dWaz22i2zYPJUjRzVYBiKDIN2kp+3QCBlAPe9dFh3T2O+IG2mzwaKw4eIAl
         CoVDDHG/NXtbgCWFJUPrTQGVgTTG/iNOyc5EZRl2Cr63ibDmb0LQLw6IUkyoC8n/AsUI
         fG8yf8kFXaMAxgZO5iCxtVxfmkfc78hF8w1AXVXaVKw9UQLUnTd6TAsnmGodpA7ot7yc
         8fWv7zWCUugXs5o1F6HxiKdpvMPV+A6wsE+eqaBzW7ZHkajG2o2ftklPpUjFJ0KCEFMo
         fKE6REJ33qArauAtrGi8WAJl0pa/GHCFjQ8kDH7WfdfPSTqJoanLwMZqG9kXiMloasTd
         VDbg==
X-Gm-Message-State: AOAM532cqAyyDxqMRHAf+tqmeY0DExI6AFLURegDQ8I2ZAB4spI8gpk3
        mCKCTmCS9zkj80DQdKWAxF1PLwlFSC8=
X-Google-Smtp-Source: ABdhPJxVRNg7vVfPWHdo6FJxkRi8OlA73BrESum1o5BR4HurT7lBbUh31B7s7HDVZHQHytj+cw6+0w==
X-Received: by 2002:a63:a42:: with SMTP id z2mr1969220pgk.245.1626992258068;
        Thu, 22 Jul 2021 15:17:38 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a18sm31374460pfi.6.2021.07.22.15.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:17:37 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 3/6] lpfc: Revise Topology and RAS support checks for new adapters
Date:   Thu, 22 Jul 2021 15:17:18 -0700
Message-Id: <20210722221721.74388-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210722221721.74388-1-jsmart2021@gmail.com>
References: <20210722221721.74388-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support for Topology and RAS logging capabilities were qualified by pcie
device id checks necessitating additional driver changes for new device
ids.

Reduce reliance on specific pcie device ids by substituting checks for
sli family information. This automatically picks up support on the newest
hardware.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 14 +++++++++-----
 drivers/scsi/lpfc/lpfc_hw4.h  |  4 ++++
 drivers/scsi/lpfc/lpfc_init.c | 34 ++++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_mbox.c |  5 +++--
 drivers/scsi/lpfc/lpfc_scsi.c |  8 ++------
 5 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 457989cfc0b7..a5154856bc0f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4038,6 +4038,7 @@ lpfc_topology_store(struct device *dev, struct device_attribute *attr,
 	const char *val_buf = buf;
 	int err;
 	uint32_t prev_val;
+	u8 sli_family, if_type;
 
 	if (!strncmp(buf, "nolip ", strlen("nolip "))) {
 		nolip = 1;
@@ -4061,13 +4062,16 @@ lpfc_topology_store(struct device *dev, struct device_attribute *attr,
 		/*
 		 * The 'topology' is not a configurable parameter if :
 		 *   - persistent topology enabled
-		 *   - G7/G6 with no private loop support
+		 *   - ASIC_GEN_NUM >= 0xC, with no private loop support
 		 */
-
+		sli_family = bf_get(lpfc_sli_intf_sli_family,
+				    &phba->sli4_hba.sli_intf);
+		if_type = bf_get(lpfc_sli_intf_if_type,
+				 &phba->sli4_hba.sli_intf);
 		if ((phba->hba_flag & HBA_PERSISTENT_TOPO ||
-		     (!phba->sli4_hba.pc_sli4_params.pls &&
-		     (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC ||
-		     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC))) &&
+		    (!phba->sli4_hba.pc_sli4_params.pls &&
+		     (sli_family == LPFC_SLI_INTF_FAMILY_G6 ||
+		      if_type == LPFC_SLI_INTF_IF_TYPE_6))) &&
 		    val == 4) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				"3114 Loop mode not supported\n");
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index c31a0cbcc208..aadbb0de629d 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -94,6 +94,9 @@ struct lpfc_sli_intf {
 #define LPFC_SLI_INTF_FAMILY_BE3	0x1
 #define LPFC_SLI_INTF_FAMILY_LNCR_A0	0xa
 #define LPFC_SLI_INTF_FAMILY_LNCR_B0	0xb
+#define LPFC_SLI_INTF_FAMILY_G6		0xc
+#define LPFC_SLI_INTF_FAMILY_G7		0xd
+#define LPFC_SLI_INTF_FAMILY_G7P	0xe
 #define lpfc_sli_intf_slirev_SHIFT		4
 #define lpfc_sli_intf_slirev_MASK		0x0000000F
 #define lpfc_sli_intf_slirev_WORD		word0
@@ -4719,6 +4722,7 @@ union lpfc_wqe128 {
 
 #define MAGIC_NUMBER_G6 0xFEAA0003
 #define MAGIC_NUMBER_G7 0xFEAA0005
+#define MAGIC_NUMBER_G7P 0xFEAA0020
 
 struct lpfc_grp_hdr {
 	uint32_t size;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f08129c67a2e..ead8e91e8625 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8550,9 +8550,12 @@ lpfc_map_topology(struct lpfc_hba *phba, struct lpfc_mbx_read_config *rd_config)
 	}
 	/* FW supports persistent topology - override module parameter value */
 	phba->hba_flag |= HBA_PERSISTENT_TOPO;
-	switch (phba->pcidev->device) {
-	case PCI_DEVICE_ID_LANCER_G7_FC:
-	case PCI_DEVICE_ID_LANCER_G6_FC:
+
+	/* if ASIC_GEN_NUM >= 0xC) */
+	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+		    LPFC_SLI_INTF_IF_TYPE_6) ||
+	    (bf_get(lpfc_sli_intf_sli_family, &phba->sli4_hba.sli_intf) ==
+		    LPFC_SLI_INTF_FAMILY_G6)) {
 		if (!tf) {
 			phba->cfg_topology = ((pt == LINK_FLAGS_LOOP)
 					? FLAGS_TOPOLOGY_MODE_LOOP
@@ -8560,8 +8563,7 @@ lpfc_map_topology(struct lpfc_hba *phba, struct lpfc_mbx_read_config *rd_config)
 		} else {
 			phba->hba_flag &= ~HBA_PERSISTENT_TOPO;
 		}
-		break;
-	default:	/* G5 */
+	} else { /* G5 */
 		if (tf) {
 			/* If topology failover set - pt is '0' or '1' */
 			phba->cfg_topology = (pt ? FLAGS_TOPOLOGY_MODE_PT_LOOP :
@@ -8571,7 +8573,6 @@ lpfc_map_topology(struct lpfc_hba *phba, struct lpfc_mbx_read_config *rd_config)
 					? FLAGS_TOPOLOGY_MODE_PT_PT
 					: FLAGS_TOPOLOGY_MODE_LOOP);
 		}
-		break;
 	}
 	if (phba->hba_flag & HBA_PERSISTENT_TOPO) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
@@ -12991,7 +12992,9 @@ lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
 	const struct firmware *fw)
 {
 	int rc;
+	u8 sli_family;
 
+	sli_family = bf_get(lpfc_sli_intf_sli_family, &phba->sli4_hba.sli_intf);
 	/* Three cases:  (1) FW was not supported on the detected adapter.
 	 * (2) FW update has been locked out administratively.
 	 * (3) Some other error during FW update.
@@ -12999,10 +13002,12 @@ lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
 	 * for admin diagnosis.
 	 */
 	if (offset == ADD_STATUS_FW_NOT_SUPPORTED ||
-	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC &&
+	    (sli_family == LPFC_SLI_INTF_FAMILY_G6 &&
 	     magic_number != MAGIC_NUMBER_G6) ||
-	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC &&
-	     magic_number != MAGIC_NUMBER_G7)) {
+	    (sli_family == LPFC_SLI_INTF_FAMILY_G7 &&
+	     magic_number != MAGIC_NUMBER_G7) ||
+	    (sli_family == LPFC_SLI_INTF_FAMILY_G7P &&
+	     magic_number != MAGIC_NUMBER_G7P)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3030 This firmware version is not supported on"
 				" this HBA model. Device:%x Magic:%x Type:%x "
@@ -14053,17 +14058,18 @@ lpfc_sli4_oas_verify(struct lpfc_hba *phba)
 void
 lpfc_sli4_ras_init(struct lpfc_hba *phba)
 {
-	switch (phba->pcidev->device) {
-	case PCI_DEVICE_ID_LANCER_G6_FC:
-	case PCI_DEVICE_ID_LANCER_G7_FC:
+	/* if ASIC_GEN_NUM >= 0xC) */
+	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+		    LPFC_SLI_INTF_IF_TYPE_6) ||
+	    (bf_get(lpfc_sli_intf_sli_family, &phba->sli4_hba.sli_intf) ==
+		    LPFC_SLI_INTF_FAMILY_G6)) {
 		phba->ras_fwlog.ras_hwsupport = true;
 		if (phba->cfg_ras_fwlog_func == PCI_FUNC(phba->pcidev->devfn) &&
 		    phba->cfg_ras_fwlog_buffsize)
 			phba->ras_fwlog.ras_enabled = true;
 		else
 			phba->ras_fwlog.ras_enabled = false;
-		break;
-	default:
+	} else {
 		phba->ras_fwlog.ras_hwsupport = false;
 	}
 }
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 84bc373190d8..6c754ee96bee 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -513,8 +513,9 @@ lpfc_init_link(struct lpfc_hba * phba,
 		break;
 	}
 
-	if ((phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC ||
-	     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC) &&
+	/* Topology handling for ASIC_GEN_NUM 0xC and later */
+	if ((phba->sli4_hba.pc_sli4_params.sli_family == LPFC_SLI_INTF_FAMILY_G6 ||
+	     phba->sli4_hba.pc_sli4_params.if_type == LPFC_SLI_INTF_IF_TYPE_6) &&
 	    !(phba->sli4_hba.pc_sli4_params.pls) &&
 	    mb->un.varInitLnk.link_flags & FLAGS_TOPOLOGY_MODE_LOOP) {
 		mb->un.varInitLnk.link_flags = FLAGS_TOPOLOGY_MODE_PT_PT;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 10002a13c5c6..ee4ff4855866 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5029,12 +5029,8 @@ lpfc_check_pci_resettable(struct lpfc_hba *phba)
 		}
 
 		/* Check for valid Emulex Device ID */
-		switch (ptr->device) {
-		case PCI_DEVICE_ID_LANCER_FC:
-		case PCI_DEVICE_ID_LANCER_G6_FC:
-		case PCI_DEVICE_ID_LANCER_G7_FC:
-			break;
-		default:
+		if (phba->sli_rev != LPFC_SLI_REV4 ||
+		    phba->hba_flag & HBA_FCOE_MODE) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 					"8347 Incapable PCI reset device: "
 					"0x%04x\n", ptr->device);
-- 
2.26.2

