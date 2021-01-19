Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BE7C43381
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 20:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AB5922CE3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 20:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbhASUwI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404382AbhASUvL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 15:51:11 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2594EC061575;
        Tue, 19 Jan 2021 12:50:31 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id c5so21039749wrp.6;
        Tue, 19 Jan 2021 12:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vH6HUy38oMUJplJNeKlr7VopL4Mea1KWW8m/wPDj6uM=;
        b=QQfLVY7DDyNmFBsVJSzaqhxrYiPYNfVxkhGXR/ZQ8sTrc8xc8mxhSwm6yRy6ODFeyD
         ox+hZSAYHz6OUNDalYclpenoHrUpz+jAdo/GLrjDg794JaCrTePf6dIdsr7g4erZh233
         clu5tVppJldjZ6tS7YKvVB3RNcP7XwmgjKrOPCh5LndbxmvFPWvGPCUzOMLgzpUk4AjH
         +fBuBnsQuHM764SRKeuaBLYT7+i8s9+2ja2iZnkgjRW9EB6hHPcQjDBbBvxStkQHN3p/
         D9iaRW9uI6fOEz+Ju+ESBa6KRV4vACWYjz9NhXKQ8bv6IvwQh8ZPgR+GUtgD5dWLDW2P
         DAxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vH6HUy38oMUJplJNeKlr7VopL4Mea1KWW8m/wPDj6uM=;
        b=tO6OymZRGXeVk0GyTdHvhOHblSMvQqZl8bGoOfQVkRU4HWOlamDBUF0GyP5q9IBrUl
         yfUNTXpUvFgy5Xk8nW1eq+SgPRzrVJ16UOoLonb+Wc57/YKmYuHktKKHHThKfwwVjYYK
         PQlEH1lzwjQ2iEChNeB2INjrYbMwAWXeX4fr5gU7HQ/L2Qu0gndIkJem4WQXbK/+0Wr2
         mbgIOuChlesvHMaUHePFvs5tNcDXgR4fU/oQ76qAqdLVbdzvB+1bfKyPagLyQbKq0axW
         fRdvIYncRZdv950gbc7rhHCs8gmKj3dw2Zc68GzTvIFMSVTNfvYx8ntypay2er//QUIa
         m/2w==
X-Gm-Message-State: AOAM530FDlFkW7IOJdCmPv74QTSSBr2AbPnQJ04CHe33OzI3gikDsUSQ
        OxXRodlEKsL63c6c3OI+pA8=
X-Google-Smtp-Source: ABdhPJyg9255+bek8/LJIAHk5pbX9Mu2jpCiaCO+VW3sT28GwkycQ8pif/Ly49fLL3NaJkXC9rYVfA==
X-Received: by 2002:adf:bbc1:: with SMTP id z1mr2985222wrg.95.1611089429912;
        Tue, 19 Jan 2021 12:50:29 -0800 (PST)
Received: from curtine-Aspire-A515-55.lan ([2001:818:e279:2100:e157:80a8:2e2e:c679])
        by smtp.googlemail.com with ESMTPSA id x128sm6681248wmb.29.2021.01.19.12.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 12:50:29 -0800 (PST)
From:   Eric Curtin <ericcurtin17@gmail.com>
Cc:     ericcurtin17@gmail.com, James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:EMULEX/BROADCOM LPFC FC/FCOE SCSI
        DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] rename lpfc_sli4_dump_page_a0 to lpfc_sli4_dump_sfp_pagea0
Date:   Tue, 19 Jan 2021 20:50:22 +0000
Message-Id: <20210119205022.40000-1-ericcurtin17@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Comment did not match function signature.

Signed-off-by: Eric Curtin <ericcurtin17@gmail.com>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 3414ffcb26fe..c03a7f12dd65 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2409,7 +2409,7 @@ lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 
 
 /*
- * lpfc_sli4_dump_sfp_pagea0 - Dump sli4 read SFP Diagnostic.
+ * lpfc_sli4_dump_page_a0 - Dump sli4 read SFP Diagnostic.
  * @phba: pointer to the hba structure containing.
  * @mbox: pointer to lpfc mbox command to initialize.
  *
-- 
2.25.1

