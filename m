Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B82AC43600
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CF1761027
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbhDLBc3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236573AbhDLBcX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F57BC061574
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d17so211666plg.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CuOK/zBaEnVVdGmIefjj3o+dvgCyOXYDZJlw+s5a920=;
        b=YrakYJ4tuMClWTVXS4p5wIkDZIyD06OaUvQWRh8mQLbCGH2SBSChYS6d0WGVvqnuk+
         1A5IF9pw5qrYYE7Ck65EqYqrupMTDcwebYaETqMSvyHpSZ6FwBzd/yz8wc3iTGK7k1wK
         4rygGCIPIQBWxWLuyTA2iftgypF1Ft/tKdjapCmGrVLCJTYwg27IgAJo2Bvm0s0bnfAZ
         tJqKj3dSpyBRq/Bfzif93fJm3GijtmAfQTARVE/CU/zdDCdgJiYRhmVNdzNkAnvTyiGD
         r1eIVubzmhC3qixHelVh0JaB5HTx9tdxxbMT25XNLC6dlX5bi2Jz42sOI2ouG9R42GHy
         +N4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CuOK/zBaEnVVdGmIefjj3o+dvgCyOXYDZJlw+s5a920=;
        b=h3ZygIFtHW5DHyduxTE8znVh15Qj4DzAPvNDNSuFN+amzJBYP1rgZiv4l7XUM4Ivxt
         NDe2D5a2RowgLrEkIq943FIukuc+nesfnwgoJo4iCXe6+b27eIzTeGdGtafHHi1C1njM
         rz20IxanbUm/4EdmlTKE+nzVOW7zzreCmjuOBzneN4TZaWiet+ZqVyG+GJ3R6wl3rmrN
         Lb3SO2Yg06EccwjUl8DKIve7yGY1ig9/sQ9JKjysJq6WB6u2uk1nRJXMCnl+bua4Mu2Z
         UxEOe17Mt3IufL7/hF4jEKkadaLMJnuNmfrr0XVVTGDvGkAVqw4ielWxkUhmEJadJAkb
         CeuQ==
X-Gm-Message-State: AOAM531sNRZbok+ZytpUF2SByKvhARDz1xVb5xIMoAbfBzNz7JSArCw5
        TKXCPiAbQEREJEY7ct6157jgbND7oV0=
X-Google-Smtp-Source: ABdhPJxfsboz7lQMhH8U7N9HAwPdYzBaWgAyGwxW8yMo0rUG6kGdly+QmP6GJ+B9CqgGJmw6aLmHRw==
X-Received: by 2002:a17:902:8344:b029:ea:fc89:fa72 with SMTP id z4-20020a1709028344b02900eafc89fa72mr2354091pln.45.1618191126000;
        Sun, 11 Apr 2021 18:32:06 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:05 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 10/16] lpfc: Fix lpfc_hdw_queue attribute being ignored
Date:   Sun, 11 Apr 2021 18:31:21 -0700
Message-Id: <20210412013127.2387-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The lpfc_hdw_queue attribute is to set the number of hardware queues
to be created on the adapter. Normally, the value is set to a default,
which allows the hw queue count to be sized dynamically based on
adapter capabilities, cpu/platform architecture, or cpu type. Currently,
when lpfc_hdw_queue is set to a specific value, is has no effect and
the dynamic sizing occurs.

The routine checking whether parameters are default or not ignores the
lpfc_hdw_queue setting and invokes the dynamic logic.

Fix the routine to additionally check the lpfc_hdw_queue attribute value
before using dynamic scaling. Additionally, SLI-3 supports only a small
number of queues with dedicated functions, thus it needs to be exempted
from the variable scaling and set to the expected values.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b253be355b4f..b703fe3b606e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5815,7 +5815,9 @@ lpfc_irq_chann_init(struct lpfc_hba *phba, uint32_t val)
 	}
 
 	/* Check if default setting was passed */
-	if (val == LPFC_IRQ_CHANN_DEF)
+	if (val == LPFC_IRQ_CHANN_DEF &&
+	    phba->cfg_hdw_queue == LPFC_HBA_HDWQ_DEF &&
+	    phba->sli_rev == LPFC_SLI_REV4)
 		lpfc_assign_default_irq_chann(phba);
 
 	if (phba->irq_chann_mode != NORMAL_MODE) {
@@ -5854,7 +5856,12 @@ lpfc_irq_chann_init(struct lpfc_hba *phba, uint32_t val)
 			phba->cfg_irq_chann = LPFC_IRQ_CHANN_DEF;
 			return -EINVAL;
 		}
-		phba->cfg_irq_chann = val;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			phba->cfg_irq_chann = val;
+		} else {
+			phba->cfg_irq_chann = 2;
+			phba->cfg_hdw_queue = 1;
+		}
 	}
 
 	return 0;
@@ -7411,7 +7418,8 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 		phba->cfg_hdw_queue = phba->sli4_hba.num_present_cpu;
 	if (phba->cfg_irq_chann == 0)
 		phba->cfg_irq_chann = phba->sli4_hba.num_present_cpu;
-	if (phba->cfg_irq_chann > phba->cfg_hdw_queue)
+	if (phba->cfg_irq_chann > phba->cfg_hdw_queue &&
+	    phba->sli_rev == LPFC_SLI_REV4)
 		phba->cfg_irq_chann = phba->cfg_hdw_queue;
 
 	phba->cfg_soft_wwnn = 0L;
-- 
2.26.2

