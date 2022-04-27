Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D049C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 22:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiD0WZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 18:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiD0WZS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 18:25:18 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06D42B252
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 15:22:05 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 15so2485977pgf.4
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 15:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+IO7f2SIDCDTHdxng7A/a+R1OGHvWooIrBKgOfcgO8s=;
        b=broGhPI2E344O+P0zYLqtBtW+BwHD67/5IkCvorEDOj1kUE9BmSYsL72PMxI+Q8j9F
         x5S3wSkt3l27dX6nC/e9GF0Z0ZyBzhmd/4ZcCL2SLkpGzkb7aPM8b+NvixNBdicH1pi4
         mVOop/+kcL5mMDa1zTfqfxIpY1C5n9JEq/7p8Z8/OCZURgf0FacMiyKacMFn9iWd4+OU
         EGFScUiX0iVHBxiDx8mj29fDEheEXoNIfCX6NIwlYhyGWx8GQLsP9t6X8rNLYlVDuYdk
         rEymEB0yevdl1wlIuE1/AdhSyHsAPKs9AKAAhGz7tkElGyZ/AaN0U/aswxTm7Cp3YlLh
         VSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+IO7f2SIDCDTHdxng7A/a+R1OGHvWooIrBKgOfcgO8s=;
        b=cQOongme1TKpX0xph4E4+AEMZSxvjHG0NjrOJFQUlyxQbW42Zzzd9j7nOoSq/NcRcM
         rGgJO541h583g+H0pyypC+seylUyJ4pSmKm9mMimWgb19bvl9vn9uHejF5xywaE6Qi8k
         IxmOkXG3+X4o8qmU4GVf0N9IuxnryX1b3xF/vfYqgnuyO/JuenaAJ7J4mN3n/8hdeZFe
         xIQvdOpOcBUf0IzN3RYiEaoQUDofJDv97f+EaG7UV1Si/qrcYmucytOABhtdqyAaG4Qk
         9G6HYja04fsxghP8eMwXNjZXQK+Zxilm6SSbRnNFpM60sV3YH40dSaxexFnTB/470Q2l
         co+Q==
X-Gm-Message-State: AOAM530hLaINaNWKhOh2do7dMQ+ZKmWlW898WWd8po/LFEDyapQamwWB
        3cQDrBeSLGr6skY8GGS0Efn6G8j+HSk=
X-Google-Smtp-Source: ABdhPJyLVJh/gdMbsXEXR6UXA0oGwZzuLQz3OXpD4AcxFT3G8dZ02DI0/DNHE1vHnT25fpFZB5OtNw==
X-Received: by 2002:a05:6a00:8c9:b0:4fe:ecc:9bcd with SMTP id s9-20020a056a0008c900b004fe0ecc9bcdmr31853118pfu.34.1651098125249;
        Wed, 27 Apr 2022 15:22:05 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p27-20020a631e5b000000b003c14af50608sm319015pgm.32.2022.04.27.15.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 15:22:04 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Nigel Kirkland <nigel.kirkland@broadcom.com>
Subject: [PATCH] lpfc: Fix additional reference counting in lpfc_bsg_rport_els()
Date:   Wed, 27 Apr 2022 15:21:58 -0700
Message-Id: <20220427222158.57867-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Code inspection has found an additional reference is taken in
lpfc_bsg_rport_els(). Results in the ndlp not being freed thus is
leaked.

Fix by removing the redundant refcount taken before WQE submission.

Co-developed-by: Nigel Kirkland <nigel.kirkland@broadcom.com>
Signed-off-by: Nigel Kirkland <nigel.kirkland@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index ae46383b13bf..676e7d54b97a 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -740,12 +740,6 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 		readl(phba->HCregaddr); /* flush */
 	}
 
-	cmdiocbq->ndlp = lpfc_nlp_get(ndlp);
-	if (!cmdiocbq->ndlp) {
-		rc = -EIO;
-		goto linkdown_err;
-	}
-
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq, 0);
 	if (rc == IOCB_SUCCESS) {
 		spin_lock_irqsave(&phba->hbalock, flags);
-- 
2.26.2

