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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE5D0C43461
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82712611C1
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhDJRbH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhDJRbF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:05 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E24C06138A
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:50 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l123so6364005pfl.8
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CuOK/zBaEnVVdGmIefjj3o+dvgCyOXYDZJlw+s5a920=;
        b=aU/6M5O+UtG4OLDJbgJ6KnMz6v3Otj212o5vnoHwb18/hTqKEbTYuFmOBk/TVqkNEn
         x6oW0nFDFkxmsgFrImIG0CXvjyVZ5er122+QhJBRF37wZwLVfYRmCyKCz1YQffkEbC7O
         cAlBGBNm2UUMc8wo6YaZrmKt5y0p2wERXlIFknC3wZ7kM/vvb9uL3FnfaVPGu/TEVW0Z
         ILNDbICHzF2qrG5cz73w9R4E/Br6HhF3vu1PXVKIYaoju/X5RRLY7iXhSxUFsjOUa7PC
         y1SxekJihQjtKb2G8LuTVaPm6I3H8zrKZvLYLR5gNuaNLUUy3ztgZgL3SwszRfmGaaCu
         x5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CuOK/zBaEnVVdGmIefjj3o+dvgCyOXYDZJlw+s5a920=;
        b=llNRsMqOgDRLgxE5Xm2PgM9BeCo8K31WJFfuMnDlEOqGnIxDkmSS2MbMvhyabFv5eV
         P/RvfWc7RtfKFYlsPL3kp53+EFiFHczARA4cgyv/GUphvyC3rkHaVQqYAmWP7RCD7G/5
         inq14SaJe4uU/hAzz0GBaYJof+eVs2JqVnZ167VtNPPAXS/NzEw5vqNP3a1uUaQa1+iG
         500vy+I88NMikitkGBJ92FSOQ/LxAZAFV4lqK0bCOwarRa6cu0bMJLojnOei8RP0j4RX
         ZUtpO8EaFJnfw9V9b5hZ3EUK/6tRmcvwNFjEZDC16/H2xJqudGBmyNUXbysj6ksHc16O
         bJFg==
X-Gm-Message-State: AOAM530h49M2RsQYftUZr9oYdh78SyAT5AvW/PtmDg4CPXwDutFxPezC
        pJ77nrNrq4tzMNgvfnEg4W32LxPmQ20=
X-Google-Smtp-Source: ABdhPJxoFjxKOHShmyCm4lVqG7O0aK0MKlcpxlfDBVD1yPsInjR34yvo/3hRFESguH9dIepS/kCqCw==
X-Received: by 2002:a63:5d6:: with SMTP id 205mr18163056pgf.278.1618075850429;
        Sat, 10 Apr 2021 10:30:50 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:50 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 10/16] lpfc: Fix lpfc_hdw_queue attribute being ignored
Date:   Sat, 10 Apr 2021 10:30:28 -0700
Message-Id: <20210410173034.67618-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
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

