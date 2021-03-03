Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798A4C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1EF64EBA
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352003AbhCDAdJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244746AbhCCPLo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 10:11:44 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43225C0613DB
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:46:39 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id w11so23945017wrr.10
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hMTcPdE33rA73xW40/obaAvyxI/BmbG2/vcK9AyPiS4=;
        b=mS2POgFSLO40xsinsRY3MMKCXhGYf1A11/5sMXF7zxv2nHlnPJxPysD4ylhjcVQ8kh
         A70Rm6aFdiUirop6xa9cLvaG4VrN+ecdZILgN87YY9sv0v/j4QVQzM8TtV+h6oO7EqZB
         XFJ4x/veAixASCCXlr0osy5PY7oAItmTxoctKYBtzd14H7Ygkbvs7OKeS6cDVEb+A9Xd
         XaMYTl7lk7IkPQ4aR8UfeoPG8uQ2Vs155Fb9cJiUhsa2HIx4JyJ9UoVC0ZEExucHkKPO
         qLN1J3tzCBRWDx0MEfydPpm5vmIphA+ukdogi4hfk3l7B507yhLQTFHHhA+uMBzE/vqZ
         SNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hMTcPdE33rA73xW40/obaAvyxI/BmbG2/vcK9AyPiS4=;
        b=elF2QoPLF/eTqjqrv5v6irzsrVgZ1+GIlONm2HcFRUVyQQAv7g7wy2HwdkPCAEnqnz
         4MHTsx/QmeyXsGgIl5wMb4Cf/8hLPTtBdQNb/QctU1PCjzAUIC+vCnEv+IsPhNO3gcyl
         xk+hig71g0lDONuCC2/nCbUAAtP1yE6PmseMX+88cQfS6F4gcAw23x88RbFcFXw0ArkW
         7kthpNzqtzS5G1l2nf1wISgRryheRyOQ6Yol/qSaameeYiZIyDG86AdZXOQjV80aS3GY
         yYbipyVkjdx65jGQ96QjUPSB92tzNYQf8P55eMwV76PyBaZHIJs2NyjEZ2ZLtRE2OPY+
         uzZA==
X-Gm-Message-State: AOAM532EHR4K5RY0d0Cr0z5m0TpcocDvlMAGqM5WK7UJW9kl+7+Y0RZZ
        p9wTbCdzktSwLsKiigW2SK1ArQ==
X-Google-Smtp-Source: ABdhPJxzl2S/6mPsCSWDdqebFn02H0GPE34h99eBG9YNUF/tAqgELGiZ7hv7lNiNulAIUzRwM1GR+Q==
X-Received: by 2002:adf:8445:: with SMTP id 63mr28128128wrf.222.1614782797914;
        Wed, 03 Mar 2021 06:46:37 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:46:36 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 01/30] scsi: megaraid: megaraid_mm: Fix incorrect function name in header
Date:   Wed,  3 Mar 2021 14:46:02 +0000
Message-Id: <20210303144631.3175331-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/megaraid/megaraid_mm.c:505: warning: expecting prototype for mraid_mm_attch_buf(). Prototype was for mraid_mm_attach_buf() instead

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/megaraid/megaraid_mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 8df53446641ac..abf7b401f5b90 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -490,7 +490,7 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
 }
 
 /**
- * mraid_mm_attch_buf - Attach a free dma buffer for required size
+ * mraid_mm_attach_buf - Attach a free dma buffer for required size
  * @adp		: Adapter softstate
  * @kioc	: kioc that the buffer needs to be attached to
  * @xferlen	: required length for buffer
-- 
2.27.0

