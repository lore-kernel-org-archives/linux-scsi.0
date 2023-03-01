Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4197AC678D4
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCAXH3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCAXHZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:25 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A426B51FB0
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:23 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id d7so16190134qtr.12
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+FbzE3d4VkAbn1mH30ojxXllj1qg8tDcoBi1dQjlTQ=;
        b=Ol5vv3xVw9lj2S7kRjFZURkL8Bykla0Jka3PzI11Kay65JYlT69vdjcDephFqWdA4l
         RHootngGgqRRDuIP+oadPGYVSO0QR+h7CYAl03YhlDTbNriLRCwkvO8imFtd9bcc3XyM
         zinqYk3/lFmaVtc4IEir3gpBKWz1ixv8DTO2bd4Bwxs5H2vjxEx23H8NxHBdZImunPwr
         Xd3G/LkW3F3moUrXZ/W/qlsneRmRQqLhTkW9r2z97sCKCbAtBoYIx2FEa4bQq6cS9zxp
         wvMGMqd2yl3ZLcEKIFqvBal0UBSEk13Wenr4E2TZMJIPC5/HS6EImcsDPyWXWsZGkpxk
         UXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+FbzE3d4VkAbn1mH30ojxXllj1qg8tDcoBi1dQjlTQ=;
        b=wznCeUr7xfuDco/GPZj/8FKwisgBCPyI2bvF7XO6eQ9QiqahcQunYSh+DMm7UM2N49
         tNkraOgHx7C5N6YXyqZcdelTjRE0uYZMKZsgI4m32X2EulAepanF/MScDIw1LP66Df0G
         uGoh+wh5UzPwOkEecjJUvvMk90redQVp8TND+IViBX/YaFQGBVCtbISe5JapEvvGSe3K
         fIZmBOkyO5QeQdykMkj3Yfm/sFc0LXq4bK1Op9GwnFcOPf1liFuMRNBLrSvKl4DL/Pj/
         yVTdxqlU54KdtUaLrhwlQjC8x0+KvNMzDOBSuR03bAAe6qwjk9tk9yJW61NkzQVQ3q5J
         oeBw==
X-Gm-Message-State: AO0yUKVzU+qFswz+7x3e9yCN72spUvYHJD3aoaTnKW6WYmnWjEX1cY9v
        yrgX9UNL4HKaxYEdzjSNpRcSQqpCVjw=
X-Google-Smtp-Source: AK7set8bdhVGD/oiJsq9dtWiTBQa9QoDm1YFiMd3422cJnHj3IjtSc9LLTwbThupf00L3wOmDCRT3w==
X-Received: by 2002:a05:622a:1a2a:b0:3bd:d8f:2da9 with SMTP id f42-20020a05622a1a2a00b003bd0d8f2da9mr16395330qtb.2.1677712043201;
        Wed, 01 Mar 2023 15:07:23 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:22 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/10] lpfc: Defer issuing new PLOGI if received RSCN before completing REG_LOGIN
Date:   Wed,  1 Mar 2023 15:16:21 -0800
Message-Id: <20230301231626.9621-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When mapped to a target with multiple virtual ports, a link bounce
sometimes results in unsuccessful rediscovery of all of the target's
virtual ports.  This is because a succession of repeat RSCNs for the
virtual target ports leaves ndlps in the REG_LOGIN state with the
NLP_REG_LOGIN_SEND flag set.  With NLP_REG_LOGIN_SEND set, during the next
PLOGI, the driver will UNREG_RPI.  When UNREG_RPI is processed, the driver
can be in the middle of PRLI_ISSUE or MAPPED state resulting in an
illegal state transition by the discovery engine and stalling.

Fix by calling the discovery state machine with DEVICE_RECOVERY event
during RSCN processing.  This will set the NLP_IGNR_REG_CMPL bit and
prevent the old REG_LOGIN state from advancing.  Then for the new PLOGI
issue, add the check for the NLP_IGNR_REG_CMPL bit to delay issuing the new
PLOGI until the queued REG_LOGIN and UNREG_LOGIN have been processed.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 7 ++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 459e50836853..0342e8cdcc9e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2208,14 +2208,15 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	 * outstanding UNREG_RPI mbox command completes, unless we
 	 * are going offline. This logic does not apply for Fabric DIDs
 	 */
-	if ((ndlp->nlp_flag & NLP_UNREG_INP) &&
+	if ((ndlp->nlp_flag & (NLP_IGNR_REG_CMPL | NLP_UNREG_INP)) &&
 	    ((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
 	    !(vport->fc_flag & FC_OFFLINE_MODE)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "4110 Issue PLOGI x%x deferred "
-				 "on NPort x%x rpi x%x Data: x%px\n",
+				 "on NPort x%x rpi x%x flg x%x Data:"
+				 " x%px\n",
 				 ndlp->nlp_defer_did, ndlp->nlp_DID,
-				 ndlp->nlp_rpi, ndlp);
+				 ndlp->nlp_rpi, ndlp->nlp_flag, ndlp);
 
 		/* We can only defer 1st PLOGI */
 		if (ndlp->nlp_defer_did == NLP_EVT_NOTHING_PENDING)
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 66cd0b1dbbd0..11ba26ac495a 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5755,8 +5755,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			     (NLP_FCP_TARGET | NLP_NVME_TARGET)))
 				return NULL;
 
-			ndlp->nlp_prev_state = ndlp->nlp_state;
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+						NLP_EVT_DEVICE_RECOVERY);
 
 			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-- 
2.38.0

