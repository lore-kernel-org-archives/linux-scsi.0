Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709AAC7EE26
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbjEWSWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236429AbjEWSW2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FC5119
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ae4c4ff992so5874885ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866147; x=1687458147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VvsK8o+B3tBaMWxkh2yZ/qPuEsU64oRRHoot4z1dxYo=;
        b=YQQDCvGgnrHw6B/Jz8Kly+V+yvcXZZek0vjWHPNxIU4O827C2VURZRdNn2Gmk0Mlk9
         RTDqZ3gZvfcNnMDjQ46EvwpemC973CFCnrr6lJA+/cM3fYiN01ea1OyVWb+5yhjacWK1
         vCGYGIb5rPGVntpyY14PNbUNQ0jSmBP3mN8+3Np8p8iEWnQavpaFtFDxW/f//e6jDpFE
         s4oVEGZIj6S4gL1zodLwsbTvtU1OEGEzTPUOZbKMHRMzkkaq/B6WF8PFKRwJ+5rZo6wA
         dT2np7WH3E6CjVQzPOl3YWzpM2QapwI0IxJce1lBNzgCWOBzCoQ/j12W+9p45qR9GrYZ
         ZXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866147; x=1687458147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VvsK8o+B3tBaMWxkh2yZ/qPuEsU64oRRHoot4z1dxYo=;
        b=ES/vN/N8tH9dLUXZaj3mclor3UZMckKtO4NkUJAN3psp/3qs3WQtCGdJYrdNstV0Dh
         rS8tJYJM3loWB0ufxUFGRmSPuIaNqBTWju+XMuXRc5tHB5xv1YOb67VK3miy7GbHWGQ2
         UY5LczwuBEx5eWgFkRMUl+pp8W49qNWNs5MYQqyqL5fH3CXIqQZh1b2EiB+8Xbx8njww
         r5hF7NvF4cJURSgd0jViskImjWt5gpHhFukLgmwE4J5VVsJ331mwPp/csJQIwDhnLvhN
         Hi/1XcI+5LlHOnd4n78b0U0LnunBl2Zym16VdQYItv9/6Xpi+ZzsJyWruk8CM+UOIvG6
         HoKw==
X-Gm-Message-State: AC+VfDzahPUqZ0gPCy6NKUjAsbQ/zbJLY4jwiitX/GdkfeN1ZZBqjnTK
        +D/OE21t1sCc8jI9ujGeITQXhB4oBko=
X-Google-Smtp-Source: ACHHUZ5efinVQXMPBDK/Tb3TU/4EWLSqJ8AsWhIcIStEkdQpcNFsisFU4z3i1pVFgeat7Lmn69j6qA==
X-Received: by 2002:a17:902:ecc4:b0:1af:b977:1785 with SMTP id a4-20020a170902ecc400b001afb9771785mr145377plh.0.1684866146811;
        Tue, 23 May 2023 11:22:26 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:26 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 5/9] lpfc: Change firmware upgrade logging to KERN_NOTICE instead of TRACE_EVENT
Date:   Tue, 23 May 2023 11:32:02 -0700
Message-Id: <20230523183206.7728-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A firmware upgrade does not necessitate dumping of phba->dbg_log[] to kmsg
via LOG_TRACE_EVENT.  A simple KERN_NOTICE log message should suffice to
notify the user of successful or unsuccessful firmware upgrade.  As such,
firmware upgrade log messages are updated to use KERN_NOTICE instead of
LOG_TRACE_EVENT.  Additionally, in order to notify the user of reset type
for instantiating newly downloaded firmware, lpfc_log_msg's default
KERN_LEVEL is updated to 5 or KERN_NOTICE.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c   | 24 +++++++--------
 drivers/scsi/lpfc/lpfc_logmsg.h |  4 +--
 drivers/scsi/lpfc/lpfc_sli.c    | 54 ++++++++++++++++-----------------
 3 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 088bd75fb5d7..2d9879bf298b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14747,10 +14747,10 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 	INIT_LIST_HEAD(&dma_buffer_list);
 	lpfc_decode_firmware_rev(phba, fwrev, 1);
 	if (strncmp(fwrev, image->revision, strnlen(image->revision, 16))) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"3023 Updating Firmware, Current Version:%s "
-				"New Version:%s\n",
-				fwrev, image->revision);
+		lpfc_log_msg(phba, KERN_NOTICE, LOG_INIT | LOG_SLI,
+			     "3023 Updating Firmware, Current Version:%s "
+			     "New Version:%s\n",
+			     fwrev, image->revision);
 		for (i = 0; i < LPFC_MBX_WR_CONFIG_MAX_BDE; i++) {
 			dmabuf = kzalloc(sizeof(struct lpfc_dmabuf),
 					 GFP_KERNEL);
@@ -14797,10 +14797,10 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 		}
 		rc = offset;
 	} else
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"3029 Skipped Firmware update, Current "
-				"Version:%s New Version:%s\n",
-				fwrev, image->revision);
+		lpfc_log_msg(phba, KERN_NOTICE, LOG_INIT | LOG_SLI,
+			     "3029 Skipped Firmware update, Current "
+			     "Version:%s New Version:%s\n",
+			     fwrev, image->revision);
 
 release_out:
 	list_for_each_entry_safe(dmabuf, next, &dma_buffer_list, list) {
@@ -14812,11 +14812,11 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 	release_firmware(fw);
 out:
 	if (rc < 0)
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"3062 Firmware update error, status %d.\n", rc);
+		lpfc_log_msg(phba, KERN_ERR, LOG_INIT | LOG_SLI,
+			     "3062 Firmware update error, status %d.\n", rc);
 	else
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"3024 Firmware update success: size %d.\n", rc);
+		lpfc_log_msg(phba, KERN_NOTICE, LOG_INIT | LOG_SLI,
+			     "3024 Firmware update success: size %d.\n", rc);
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index b39cefcd8703..324b865db0e1 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -55,7 +55,7 @@ void lpfc_dbg_print(struct lpfc_hba *phba, const char *fmt, ...);
 
 /* generate message by verbose log setting or severity */
 #define lpfc_vlog_msg(vport, level, mask, fmt, arg...) \
-{ if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '4')) \
+{ if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '5')) \
 	dev_printk(level, &((vport)->phba->pcidev)->dev, "%d:(%d):" \
 		   fmt, (vport)->phba->brd_no, vport->vpi, ##arg); }
 
@@ -64,7 +64,7 @@ do { \
 	{ uint32_t log_verbose = (phba)->pport ? \
 				 (phba)->pport->cfg_log_verbose : \
 				 (phba)->cfg_log_verbose; \
-	if (((mask) & log_verbose) || (level[1] <= '4')) \
+	if (((mask) & log_verbose) || (level[1] <= '5')) \
 		dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
 			   fmt, phba->brd_no, ##arg); \
 	} \
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 22708f66be64..58d10f8f75a7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20800,23 +20800,23 @@ lpfc_log_fw_write_cmpl(struct lpfc_hba *phba, u32 shdr_status,
 	if (shdr_add_status == LPFC_ADD_STATUS_INCOMPAT_OBJ) {
 		switch (shdr_add_status_2) {
 		case LPFC_ADD_STATUS_2_INCOMPAT_FLASH:
-			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
-					"4199 Firmware write failed: "
-					"image incompatible with flash x%02x\n",
-					phba->sli4_hba.flash_id);
+			lpfc_log_msg(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+				     "4199 Firmware write failed: "
+				     "image incompatible with flash x%02x\n",
+				     phba->sli4_hba.flash_id);
 			break;
 		case LPFC_ADD_STATUS_2_INCORRECT_ASIC:
-			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
-					"4200 Firmware write failed: "
-					"image incompatible with ASIC "
-					"architecture x%02x\n",
-					phba->sli4_hba.asic_rev);
+			lpfc_log_msg(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+				     "4200 Firmware write failed: "
+				     "image incompatible with ASIC "
+				     "architecture x%02x\n",
+				     phba->sli4_hba.asic_rev);
 			break;
 		default:
-			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
-					"4210 Firmware write failed: "
-					"add_status_2 x%02x\n",
-					shdr_add_status_2);
+			lpfc_log_msg(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+				     "4210 Firmware write failed: "
+				     "add_status_2 x%02x\n",
+				     shdr_add_status_2);
 			break;
 		}
 	} else if (!shdr_status && !shdr_add_status) {
@@ -20829,26 +20829,26 @@ lpfc_log_fw_write_cmpl(struct lpfc_hba *phba, u32 shdr_status,
 
 		switch (shdr_change_status) {
 		case (LPFC_CHANGE_STATUS_PHYS_DEV_RESET):
-			lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-					"3198 Firmware write complete: System "
-					"reboot required to instantiate\n");
+			lpfc_log_msg(phba, KERN_NOTICE, LOG_MBOX | LOG_SLI,
+				     "3198 Firmware write complete: System "
+				     "reboot required to instantiate\n");
 			break;
 		case (LPFC_CHANGE_STATUS_FW_RESET):
-			lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-					"3199 Firmware write complete: "
-					"Firmware reset required to "
-					"instantiate\n");
+			lpfc_log_msg(phba, KERN_NOTICE, LOG_MBOX | LOG_SLI,
+				     "3199 Firmware write complete: "
+				     "Firmware reset required to "
+				     "instantiate\n");
 			break;
 		case (LPFC_CHANGE_STATUS_PORT_MIGRATION):
-			lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-					"3200 Firmware write complete: Port "
-					"Migration or PCI Reset required to "
-					"instantiate\n");
+			lpfc_log_msg(phba, KERN_NOTICE, LOG_MBOX | LOG_SLI,
+				     "3200 Firmware write complete: Port "
+				     "Migration or PCI Reset required to "
+				     "instantiate\n");
 			break;
 		case (LPFC_CHANGE_STATUS_PCI_RESET):
-			lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-					"3201 Firmware write complete: PCI "
-					"Reset required to instantiate\n");
+			lpfc_log_msg(phba, KERN_NOTICE, LOG_MBOX | LOG_SLI,
+				     "3201 Firmware write complete: PCI "
+				     "Reset required to instantiate\n");
 			break;
 		default:
 			break;
-- 
2.38.0

