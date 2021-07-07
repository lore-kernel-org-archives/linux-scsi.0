Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96177C07E9E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 826A061CC8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhGGSqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhGGSqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87C7C061765
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:43:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cs1-20020a17090af501b0290170856e1a8aso4296004pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AoyCoWLBNuAAqv1pxCWCuErdMEQijUUmN2t9fUpp0y0=;
        b=ctW8T4wUnHLzp7O4C3uTGJRK+vwoWLtVM7Xkp2gsf+Nti9PYxD0OhZfHo6iwlnDmy8
         Sk8nHVL27wyJcdB64M5QNTwS5MWf2daWtSUmT839IRCWYc0qrfbSF84AKw52GCCg3jBq
         jCox6TDLDsHWLxhhiwwLezdVN8tPj7mzkp0QDyf1Pgl44MpZXokxZsciSXuOdmsckMmh
         WniXEdBNc+7+zM4iNBzhXLNqxAkbyEsBlCn/9C5uQ4+GqTy2Qzh9yVrkTT2a19jpJMCl
         DanSB4r2mcw2Q6eBBc+tv6rG9tFOxjfsse3Nh+bvHdKOp/+StncoyNLH75xp6aOIJ0Dw
         /JGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AoyCoWLBNuAAqv1pxCWCuErdMEQijUUmN2t9fUpp0y0=;
        b=J8rQgdiqAsfoOHhetyu3o7NPxOdWEmNmaMSFfclCNgLTrY1aV6vnxnN53i6iz8EJuP
         ZG9/S8Tw9qSUYTYMOCh+jVMXnqkdLz2qleOzCM+MYotYImQ/vfnkDQAg/CT6fZWsy0/L
         rhNETGgTznE1HRkMTW6XhwsSRm2HynKWtUTA++ZUhEcBH532Oy3kfQC+2Dh4s0OY+ChF
         NV3OLFSKtZ/feecDNaTTqwnvlE2AmpVV/Nhj55BZMBtk5CNLPKQUzw7O4duzfT0h7Jfe
         ht6/vM3Rdi5U/HKeKUnjq3h9/xb5NXOnIfm6ThvkSWfQkezTXYU6IDPk4Ymn76+8Rr2P
         3dzA==
X-Gm-Message-State: AOAM5304TpEdOAlj/YErT+296vV+KS/ASjg0ZR+fhibWKan3WxZ+TC5z
        6HsctN9lUS677fIHE+BfTEIId+moobY=
X-Google-Smtp-Source: ABdhPJxgcw9O4jyRXkXmgfJ7Tmnebxth1HD7EyX0sSI9ZaMDbQam15Hs/DLk0KZ0bnBpRFnwPliinA==
X-Received: by 2002:a17:902:bcc3:b029:11c:5ffb:61fb with SMTP id o3-20020a170902bcc3b029011c5ffb61fbmr22350365pls.18.1625683437376;
        Wed, 07 Jul 2021 11:43:57 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:43:57 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/20] lpfc: Improve firmware download logging
Date:   Wed,  7 Jul 2021 11:43:34 -0700
Message-Id: <20210707184351.67872-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Define additional status fields in mailbox commands to help provide
additional information when downloading new firmware.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |   9 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 152 ++++++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_sli4.h |   2 +
 3 files changed, 121 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index eb8c735a243b..7d4d179fb534 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -959,6 +959,12 @@ union lpfc_sli4_cfg_shdr {
 #define lpfc_mbox_hdr_add_status_SHIFT		8
 #define lpfc_mbox_hdr_add_status_MASK		0x000000FF
 #define lpfc_mbox_hdr_add_status_WORD		word7
+#define LPFC_ADD_STATUS_INCOMPAT_OBJ		0xA2
+#define lpfc_mbox_hdr_add_status_2_SHIFT	16
+#define lpfc_mbox_hdr_add_status_2_MASK		0x000000FF
+#define lpfc_mbox_hdr_add_status_2_WORD		word7
+#define LPFC_ADD_STATUS_2_INCOMPAT_FLASH	0x01
+#define LPFC_ADD_STATUS_2_INCORRECT_ASIC	0x02
 		uint32_t response_length;
 		uint32_t actual_response_length;
 	} response;
@@ -3603,6 +3609,9 @@ struct lpfc_controller_attribute {
 #define lpfc_cntl_attr_eprom_ver_hi_SHIFT	8
 #define lpfc_cntl_attr_eprom_ver_hi_MASK	0x000000ff
 #define lpfc_cntl_attr_eprom_ver_hi_WORD	word17
+#define lpfc_cntl_attr_flash_id_SHIFT		16
+#define lpfc_cntl_attr_flash_id_MASK		0x000000ff
+#define lpfc_cntl_attr_flash_id_WORD		word17
 	uint32_t mbx_da_struct_ver;
 	uint32_t ep_fw_da_struct_ver;
 	uint32_t ncsi_ver_str[3];
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 993f9c0dd006..b5c224aafea0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5674,16 +5674,20 @@ lpfc_sli4_get_ctl_attr(struct lpfc_hba *phba)
 		bf_get(lpfc_cntl_attr_lnk_type, cntl_attr);
 	phba->sli4_hba.lnk_info.lnk_no =
 		bf_get(lpfc_cntl_attr_lnk_numb, cntl_attr);
+	phba->sli4_hba.flash_id = bf_get(lpfc_cntl_attr_flash_id, cntl_attr);
+	phba->sli4_hba.asic_rev = bf_get(lpfc_cntl_attr_asic_rev, cntl_attr);
 
 	memset(phba->BIOSVersion, 0, sizeof(phba->BIOSVersion));
 	strlcat(phba->BIOSVersion, (char *)cntl_attr->bios_ver_str,
 		sizeof(phba->BIOSVersion));
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"3086 lnk_type:%d, lnk_numb:%d, bios_ver:%s\n",
+			"3086 lnk_type:%d, lnk_numb:%d, bios_ver:%s, "
+			"flash_id: x%02x, asic_rev: x%02x\n",
 			phba->sli4_hba.lnk_info.lnk_tp,
 			phba->sli4_hba.lnk_info.lnk_no,
-			phba->BIOSVersion);
+			phba->BIOSVersion, phba->sli4_hba.flash_id,
+			phba->sli4_hba.asic_rev);
 out_free_mboxq:
 	if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
 		lpfc_sli4_mbox_cmd_free(phba, mboxq);
@@ -20020,6 +20024,91 @@ lpfc_sli_read_link_ste(struct lpfc_hba *phba)
 	return;
 }
 
+/**
+ * lpfc_log_fw_write_cmpl - logs firmware write completion status
+ * @phba: pointer to lpfc hba data structure
+ * @shdr_status: wr_object rsp's status field
+ * @shdr_add_status: wr_object rsp's add_status field
+ * @shdr_add_status_2: wr_object rsp's add_status_2 field
+ * @shdr_change_status: wr_object rsp's change_status field
+ * @shdr_csf: wr_object rsp's csf bit
+ *
+ * This routine is intended to be called after a firmware write completes.
+ * It will log next action items to be performed by the user to instantiate
+ * the newly downloaded firmware or reason for incompatibility.
+ **/
+static void
+lpfc_log_fw_write_cmpl(struct lpfc_hba *phba, u32 shdr_status,
+		       u32 shdr_add_status, u32 shdr_add_status_2,
+		       u32 shdr_change_status, u32 shdr_csf)
+{
+	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+			"4198 %s: flash_id x%02x, asic_rev x%02x, "
+			"status x%02x, add_status x%02x, add_status_2 x%02x, "
+			"change_status x%02x, csf %01x\n", __func__,
+			phba->sli4_hba.flash_id, phba->sli4_hba.asic_rev,
+			shdr_status, shdr_add_status, shdr_add_status_2,
+			shdr_change_status, shdr_csf);
+
+	if (shdr_add_status == LPFC_ADD_STATUS_INCOMPAT_OBJ) {
+		switch (shdr_add_status_2) {
+		case LPFC_ADD_STATUS_2_INCOMPAT_FLASH:
+			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+					"4199 Firmware write failed: "
+					"image incompatible with flash x%02x\n",
+					phba->sli4_hba.flash_id);
+			break;
+		case LPFC_ADD_STATUS_2_INCORRECT_ASIC:
+			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+					"4200 Firmware write failed: "
+					"image incompatible with ASIC "
+					"architecture x%02x\n",
+					phba->sli4_hba.asic_rev);
+			break;
+		default:
+			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+					"4210 Firmware write failed: "
+					"add_status_2 x%02x\n",
+					shdr_add_status_2);
+			break;
+		}
+	} else if (!shdr_status && !shdr_add_status) {
+		if (shdr_change_status == LPFC_CHANGE_STATUS_FW_RESET ||
+		    shdr_change_status == LPFC_CHANGE_STATUS_PORT_MIGRATION) {
+			if (shdr_csf)
+				shdr_change_status =
+						   LPFC_CHANGE_STATUS_PCI_RESET;
+		}
+
+		switch (shdr_change_status) {
+		case (LPFC_CHANGE_STATUS_PHYS_DEV_RESET):
+			lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+					"3198 Firmware write complete: System "
+					"reboot required to instantiate\n");
+			break;
+		case (LPFC_CHANGE_STATUS_FW_RESET):
+			lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+					"3199 Firmware write complete: "
+					"Firmware reset required to "
+					"instantiate\n");
+			break;
+		case (LPFC_CHANGE_STATUS_PORT_MIGRATION):
+			lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+					"3200 Firmware write complete: Port "
+					"Migration or PCI Reset required to "
+					"instantiate\n");
+			break;
+		case (LPFC_CHANGE_STATUS_PCI_RESET):
+			lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+					"3201 Firmware write complete: PCI "
+					"Reset required to instantiate\n");
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 /**
  * lpfc_wr_object - write an object to the firmware
  * @phba: HBA structure that indicates port to create a queue on.
@@ -20046,7 +20135,8 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 	struct lpfc_mbx_wr_object *wr_object;
 	LPFC_MBOXQ_t *mbox;
 	int rc = 0, i = 0;
-	uint32_t shdr_status, shdr_add_status, shdr_change_status, shdr_csf;
+	uint32_t shdr_status, shdr_add_status, shdr_add_status_2;
+	uint32_t shdr_change_status = 0, shdr_csf = 0;
 	uint32_t mbox_tmo;
 	struct lpfc_dmabuf *dmabuf;
 	uint32_t written = 0;
@@ -20100,58 +20190,36 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 			     &wr_object->header.cfg_shdr.response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
 				 &wr_object->header.cfg_shdr.response);
+	shdr_add_status_2 = bf_get(lpfc_mbox_hdr_add_status_2,
+				   &wr_object->header.cfg_shdr.response);
 	if (check_change_status) {
 		shdr_change_status = bf_get(lpfc_wr_object_change_status,
 					    &wr_object->u.response);
-
-		if (shdr_change_status == LPFC_CHANGE_STATUS_FW_RESET ||
-		    shdr_change_status == LPFC_CHANGE_STATUS_PORT_MIGRATION) {
-			shdr_csf = bf_get(lpfc_wr_object_csf,
-					  &wr_object->u.response);
-			if (shdr_csf)
-				shdr_change_status =
-						   LPFC_CHANGE_STATUS_PCI_RESET;
-		}
-
-		switch (shdr_change_status) {
-		case (LPFC_CHANGE_STATUS_PHYS_DEV_RESET):
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"3198 Firmware write complete: System "
-					"reboot required to instantiate\n");
-			break;
-		case (LPFC_CHANGE_STATUS_FW_RESET):
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"3199 Firmware write complete: Firmware"
-					" reset required to instantiate\n");
-			break;
-		case (LPFC_CHANGE_STATUS_PORT_MIGRATION):
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"3200 Firmware write complete: Port "
-					"Migration or PCI Reset required to "
-					"instantiate\n");
-			break;
-		case (LPFC_CHANGE_STATUS_PCI_RESET):
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"3201 Firmware write complete: PCI "
-					"Reset required to instantiate\n");
-			break;
-		default:
-			break;
-		}
+		shdr_csf = bf_get(lpfc_wr_object_csf,
+				  &wr_object->u.response);
 	}
+
 	if (!phba->sli4_hba.intr_enable)
 		mempool_free(mbox, phba->mbox_mem_pool);
 	else if (rc != MBX_TIMEOUT)
 		mempool_free(mbox, phba->mbox_mem_pool);
-	if (shdr_status || shdr_add_status || rc) {
+	if (shdr_status || shdr_add_status || shdr_add_status_2 || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3025 Write Object mailbox failed with "
-				"status x%x add_status x%x, mbx status x%x\n",
-				shdr_status, shdr_add_status, rc);
+				"status x%x add_status x%x, add_status_2 x%x, "
+				"mbx status x%x\n",
+				shdr_status, shdr_add_status, shdr_add_status_2,
+				rc);
 		rc = -ENXIO;
 		*offset = shdr_add_status;
-	} else
+	} else {
 		*offset += wr_object->u.response.actual_write_length;
+	}
+
+	if (rc || check_change_status)
+		lpfc_log_fw_write_cmpl(phba, shdr_status, shdr_add_status,
+				       shdr_add_status_2, shdr_change_status,
+				       shdr_csf);
 	return rc;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 26f19c95380f..021edbfbbca5 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -978,6 +978,8 @@ struct lpfc_sli4_hba {
 #define lpfc_conf_trunk_port3_nd_WORD	conf_trunk
 #define lpfc_conf_trunk_port3_nd_SHIFT	7
 #define lpfc_conf_trunk_port3_nd_MASK	0x1
+	uint8_t flash_id;
+	uint8_t asic_rev;
 };
 
 enum lpfc_sge_type {
-- 
2.26.2

