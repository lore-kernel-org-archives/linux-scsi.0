Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36143C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0295C20784
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbhADSDg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhADSDg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:03:36 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E3EC061794
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:02:55 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id n25so19563300pgb.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T5LrTJTp4nEpZV9RVTThS89YsVXbEXL2stXCB+IhZgM=;
        b=UHWscO+XST1woyG0iTQIWWgL7A33jzF/VNC95gnnyCSiE+1pRFDaxGrwIr5q57aPaG
         9qWEK21ok0oFhSErraPpFlHotiAU5ort9iUFEYwexkeDZh2LcHBhNcN8GyS7uUT4RzY2
         CuPokm5v8ipM3eAKcWdw8rfikqqDZahVjLZcnxP4KIJzbfVhzuXEp33NauIuxciUboK2
         PIrlZV93oQYGncHvs3/ShDk2drZCbHZ9DOB0sBRY6JQnathMw8i2zUHBmf4jgWU88xTq
         fDtGwRh2lsfzCiCRuOp+LXhBHEN7MUabPTqEbGtcIakBow40EluB00LBcPqHJQOEBzeV
         jJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T5LrTJTp4nEpZV9RVTThS89YsVXbEXL2stXCB+IhZgM=;
        b=tAkG1HEjCxyazbnMCxFff2Zu9NBOHsfkEdhTjUEA5GrQLzSYzZI4zelkn5Yfr+z7kO
         HtiBGNrHq2A+475wtzi/Q046+On7C8jYSVUkUXBm4rIDkA8o/U1VI7DMUohE+dccdg8J
         RkEUKBUosC56lvi3np54Aa3KY/56EeM2zk9j1e1LDNI8mw/WKtYiZ8faU6MwwiLUPQd9
         Tkj5EA5BYf5v7u00FyH0zS6eh9o5c6woeh864TqRBRM7NPi8xk8MrvW8V8HWme8Fggfj
         FuBlOROX4eLYuw9EkI9w8xgEJ4huqA94JBrq1d9SwI3/o6N50wzH4XoInsvAzNzoe4Hf
         hA2A==
X-Gm-Message-State: AOAM531ixgEumAvKRGVLaJ/Zii/qm9Li5Bw+twzf7mffabZrCC9QZOeY
        8y9/Cw3S/dhzNuz6wcvHMrRO0Yvz1lk=
X-Google-Smtp-Source: ABdhPJxI2aMzQvN0Vqk/pgy2PWfKgBvkHNXJfOuh82JnyMEdsIzZsv9NgfTvC79LaoSX8v0vayItGA==
X-Received: by 2002:a63:521e:: with SMTP id g30mr32663861pgb.369.1609783375288;
        Mon, 04 Jan 2021 10:02:55 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:02:54 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 02/15] lpfc: Fix auto sli_mode and its effect on CONFIG_PORT for SLI3
Date:   Mon,  4 Jan 2021 10:02:27 -0800
Message-Id: <20210104180240.46824-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A very long time ago, there was a feature: auto sli mode. It gave the
user the ability to auto select the SLI mode (SLI2 or SLI3) to run the
port in, or even force SLI2 mode if configured.  Because of the
convoluted logic, the CONFIG_PORT mbox command ends up being called 2 or
3 times. It should have been called only once.  Additionally, the driver
no longer supports SLI-2, so only SLI-3 mode should be allowed.

The following changes were made:
- Force module parameter to SLI3 only.
- Rip out redundant CONFIG_PORT mbox commands.
- Force CONFIG_PORT mbox command to be in beginning of enable ISR routine.
- Added changes for offline to online behavior

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c |  7 ++----
 drivers/scsi/lpfc/lpfc_init.c | 20 ++++++++-------
 drivers/scsi/lpfc/lpfc_sli.c  | 46 +++++++++--------------------------
 4 files changed, 26 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index a54c8da30273..7875552c07d3 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -779,6 +779,7 @@ struct lpfc_hba {
 					 */
 #define HBA_FLOGI_ISSUED	0x100000 /* FLOGI was issued */
 #define HBA_DEFER_FLOGI		0x800000 /* Defer FLOGI till read_sparm cmpl */
+#define HBA_NEEDS_CFG_PORT	0x2000000 /* SLI3 - needs a CONFIG_PORT mbox */
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 4528166dee36..f8bb6a4f780c 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3441,11 +3441,8 @@ unsigned long lpfc_no_hba_reset[MAX_HBAS_NO_RESET] = {
 module_param_array(lpfc_no_hba_reset, ulong, &lpfc_no_hba_reset_cnt, 0444);
 MODULE_PARM_DESC(lpfc_no_hba_reset, "WWPN of HBAs that should not be reset");
 
-LPFC_ATTR(sli_mode, 0, 0, 3,
-	"SLI mode selector:"
-	" 0 - auto (SLI-3 if supported),"
-	" 2 - select SLI-2 even on SLI-3 capable HBAs,"
-	" 3 - select SLI-3");
+LPFC_ATTR(sli_mode, 3, 3, 3,
+	"SLI mode selector: 3 - select SLI-3");
 
 LPFC_ATTR_R(enable_npiv, 1, 0, 1,
 	"Enable NPIV functionality");
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ac67f420ec26..1f0a62ecfad8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10728,17 +10728,19 @@ lpfc_sli_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 	uint32_t intr_mode = LPFC_INTR_ERROR;
 	int retval;
 
+	/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
+	retval = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
+	if (retval)
+		return intr_mode;
+	phba->hba_flag &= ~HBA_NEEDS_CFG_PORT;
+
 	if (cfg_mode == 2) {
-		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
-		retval = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
+		/* Now, try to enable MSI-X interrupt mode */
+		retval = lpfc_sli_enable_msix(phba);
 		if (!retval) {
-			/* Now, try to enable MSI-X interrupt mode */
-			retval = lpfc_sli_enable_msix(phba);
-			if (!retval) {
-				/* Indicate initialization to MSI-X mode */
-				phba->intr_type = MSIX;
-				intr_mode = 2;
-			}
+			/* Indicate initialization to MSI-X mode */
+			phba->intr_type = MSIX;
+			intr_mode = 2;
 		}
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 95caad764fb7..735fa1d484eb 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4359,6 +4359,8 @@ lpfc_sli_brdready_s3(struct lpfc_hba *phba, uint32_t mask)
 	if (lpfc_readl(phba->HSregaddr, &status))
 		return 1;
 
+	phba->hba_flag |= HBA_NEEDS_CFG_PORT;
+
 	/*
 	 * Check status register every 100ms for 5 retries, then every
 	 * 500ms for 5, then every 2.5 sec for 5, then reset board and
@@ -4687,6 +4689,7 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 	/* perform board reset */
 	phba->fc_eventTag = 0;
 	phba->link_events = 0;
+	phba->hba_flag |= HBA_NEEDS_CFG_PORT;
 	if (phba->pport) {
 		phba->pport->fc_myDID = 0;
 		phba->pport->fc_prevDID = 0;
@@ -5020,6 +5023,8 @@ lpfc_sli_chipset_init(struct lpfc_hba *phba)
 		return -EIO;
 	}
 
+	phba->hba_flag |= HBA_NEEDS_CFG_PORT;
+
 	/* Clear all interrupt enable conditions */
 	writel(0, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
@@ -5316,45 +5321,18 @@ int
 lpfc_sli_hba_setup(struct lpfc_hba *phba)
 {
 	uint32_t rc;
-	int  mode = 3, i;
+	int  i;
 	int longs;
 
-	switch (phba->cfg_sli_mode) {
-	case 2:
-		if (phba->cfg_enable_npiv) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"1824 NPIV enabled: Override sli_mode "
-				"parameter (%d) to auto (0).\n",
-				phba->cfg_sli_mode);
-			break;
-		}
-		mode = 2;
-		break;
-	case 0:
-	case 3:
-		break;
-	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"1819 Unrecognized sli_mode parameter: %d.\n",
-				phba->cfg_sli_mode);
-
-		break;
+	/* Enable ISR already does config_port because of config_msi mbx */
+	if (phba->hba_flag & HBA_NEEDS_CFG_PORT) {
+		rc = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
+		if (rc)
+			return -EIO;
+		phba->hba_flag &= ~HBA_NEEDS_CFG_PORT;
 	}
 	phba->fcp_embed_io = 0;	/* SLI4 FC support only */
 
-	rc = lpfc_sli_config_port(phba, mode);
-
-	if (rc && phba->cfg_sli_mode == 3)
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"1820 Unable to select SLI-3.  "
-				"Not supported by adapter.\n");
-	if (rc && mode != 2)
-		rc = lpfc_sli_config_port(phba, 2);
-	else if (rc && mode == 2)
-		rc = lpfc_sli_config_port(phba, 3);
-	if (rc)
-		goto lpfc_sli_hba_setup_error;
-
 	/* Enable PCIe device Advanced Error Reporting (AER) if configured */
 	if (phba->cfg_aer_support == 1 && !(phba->hba_flag & HBA_AER_ENABLED)) {
 		rc = pci_enable_pcie_error_reporting(phba->pcidev);
-- 
2.26.2

