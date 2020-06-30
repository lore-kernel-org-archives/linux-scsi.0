Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAACC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 556072074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t5A01xPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgF3Vub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729932AbgF3Vu3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:29 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87054C03E979
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:29 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so21034311wmh.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DmS9U2cMBAKRIt3/+rDZoSoQlaUcwXtxHhxZHoTAiaQ=;
        b=t5A01xPlCDA+AGNl4a0r0l6G0cP7mxLwvsPh037YVnGeTOX5CyQUBojTk//G892FEp
         xJK3VBGBGF1Nbh+/5cqv/uOGmWUQadG15Sfny4ZmxAgGNK24sPar/TWxqaJGdzZXxBoT
         pUd/H5+TvOKgxLrZNMn/6JMaYCKFoCAjHz+r3/fFebrfYfCuUNq1z+akVSC14GclOSZD
         hvGuEvYWi2CfvyKuhO1sbLEWtPsW5Lcg/fSp+D+exEpU97d0gmfJnkSdG0cCJZisZ+G7
         EbP3ilKANBhFf291omHQBgV/Kxn1Ume8m+DV7FisALWKe9bn1a4Vsix07wusb4WbHn35
         T6xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DmS9U2cMBAKRIt3/+rDZoSoQlaUcwXtxHhxZHoTAiaQ=;
        b=lLtjf+HJ8q+f/m/lrQu6EmWJPNInphBS9IWFedYIfKKoVjxJPCZcFeWP8ScYEWOMrf
         e+8CBNw79spnmJSfpsoP/zQY0E7/eenK9L8BcH/ECczA+Pc76UKMv/8uRroFkE5LytmS
         q7Y9cSejp8T02WBIxXJiEMGwSVDSCsajcownVUe6m1hHqccWetcGkovOoGzeMpK0S5VA
         1L0xlhZQArwzQ/y7GqDJ91+K8F6fYBGQoOhpqOJK2dO6ETH8fWXp86FPO/xaygtz/+nk
         BtRWJ96BLT0Vbs2d4M9eM6ADOfxvbw8jOlet+B/s0J85+bJ2jGQUPBuI2fVWAwP2LNpz
         HiRA==
X-Gm-Message-State: AOAM530GOcSx8na8vIqCcmGyyWO49dANjB0X2n/i6JX2141sSooAAqez
        R3zHpGpewP90/koVPmaukOvoQjQp
X-Google-Smtp-Source: ABdhPJwbd5AywMo9WqkpO7PsU5NA4BCI4iM9v4PSx5g+PXxLYlyKKdwNdmNqvmrmlbwoLYKp4LwuBQ==
X-Received: by 2002:a1c:7f87:: with SMTP id a129mr24427237wmd.10.1593553827957;
        Tue, 30 Jun 2020 14:50:27 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/14] lpfc: Allow applications to issue Common Set Features mailbox command
Date:   Tue, 30 Jun 2020 14:49:57 -0700
Message-Id: <20200630215001.70793-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently the driver validates command codes received from the
application. COMMON_SET_FEATURES is not currently being approved.

Add definition of the missing command and allow it to be issued
by applications.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c |  1 +
 drivers/scsi/lpfc/lpfc_bsg.h | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index e91466aa1673..1d88fedaf3f0 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -4304,6 +4304,7 @@ lpfc_bsg_handle_sli_cfg_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 			case COMN_OPCODE_GET_CNTL_ADDL_ATTRIBUTES:
 			case COMN_OPCODE_GET_CNTL_ATTRIBUTES:
 			case COMN_OPCODE_GET_PROFILE_CONFIG:
+			case COMN_OPCODE_SET_FEATURES:
 				lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 						"3106 Handled SLI_CONFIG "
 						"subsys_comn, opcode:x%x\n",
diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index d1708133fd54..2dc71243775d 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -225,6 +225,10 @@ struct lpfc_sli_config_hdr {
 	uint32_t reserved5;
 };
 
+#define LPFC_CSF_BOOT_DEV		0x1D
+#define LPFC_CSF_QUERY			0
+#define LPFC_CSF_SAVE			1
+
 struct lpfc_sli_config_emb0_subsys {
 	struct lpfc_sli_config_hdr	sli_config_hdr;
 #define LPFC_MBX_SLI_CONFIG_MAX_MSE     19
@@ -243,6 +247,15 @@ struct lpfc_sli_config_emb0_subsys {
 #define FCOE_OPCODE_ADD_FCF		0x09
 #define FCOE_OPCODE_SET_DPORT_MODE	0x27
 #define FCOE_OPCODE_GET_DPORT_RESULTS	0x28
+	uint32_t timeout;		/* comn_set_feature timeout */
+	uint32_t request_length;	/* comn_set_feature request len */
+	uint32_t version;		/* comn_set_feature version */
+	uint32_t csf_feature;		/* comn_set_feature feature */
+	uint32_t word69;		/* comn_set_feature parameter len */
+	uint32_t word70;		/* comn_set_feature parameter val0 */
+#define lpfc_emb0_subcmnd_csf_p0_SHIFT	0
+#define lpfc_emb0_subcmnd_csf_p0_MASK	0x3
+#define lpfc_emb0_subcmnd_csf_p0_WORD	word70
 };
 
 struct lpfc_sli_config_emb1_subsys {
@@ -261,6 +274,7 @@ struct lpfc_sli_config_emb1_subsys {
 #define COMN_OPCODE_WRITE_OBJECT	0xAC
 #define COMN_OPCODE_READ_OBJECT_LIST	0xAD
 #define COMN_OPCODE_DELETE_OBJECT	0xAE
+#define COMN_OPCODE_SET_FEATURES	0xBF
 #define COMN_OPCODE_GET_CNTL_ADDL_ATTRIBUTES	0x79
 #define COMN_OPCODE_GET_CNTL_ATTRIBUTES	0x20
 	uint32_t timeout;
-- 
2.25.0

