Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0AFC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B2264EE3
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355663AbhCDAc1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359668AbhCCOuX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:50:23 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6FDC0613BC
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:28 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id v15so23983587wrx.4
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IDE9Hso9rTWT1GYUBR1hNJUg1ULbOjkFaTyN9Yx/tJU=;
        b=Ay4gpWRdV55KCDG5yeY+hI0q+5Y4Fa/UHNNLmN9p+xw6ttt7Od+kE21YM2LRh0rhwR
         GDyRAWBbJ9SFTJ8VYueqVHNtBqaFns7eS1Xvj7/s9DpkE1ucIgvp0GwCfDRDTeXUb9WR
         iCzK0Vo2pMUpOgKvDqIqhJUMi0kC1C7XtHzx63HC57Oc9kKSgys7yo/GOJmBk7ZvGWG1
         KcWocQ4VjLi5aeh7bcnsBRA04tSITnca0pR8TeC7ZwNoploKJQ6CzZGnT+eepODpPhNE
         O4NSiVSDOvM3ilEDpTpIax2oB3UR3KNDAGP+WgddgBqFg2SHOeq11xISLOHJDGvOy/c9
         cUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IDE9Hso9rTWT1GYUBR1hNJUg1ULbOjkFaTyN9Yx/tJU=;
        b=a5EQr+llNiqwg50mR/aEqYKS9N+DlMdDxHS25qqFn/9ToDRHOkLzW8xDpnQQzFBPMu
         hSfS1vJFOc/M7HY6TYQ87f2F0vxhEQ5rbQLBZ2WI279BAJZsIr8kU5Yyv4oWtjhbnmzZ
         G+2japiWB9NInlkdvPC0uO6/t/z09y44kWbbjCowcEfuDeK6+knyxbKMjf8T33DiJvTW
         qIB64VmlR1DXI1ucV7aaYICVmBvn85E1Mw7Sr4TbfsGejULrXkxsfx7Aja+lcUDP8P6b
         pq5kWvphNjyJ/Mb1E7L6TEzjQaOwJvqxOsNmySwGzH6fQpaQBWcKhqCFlrZDfHAmXLkA
         kBKA==
X-Gm-Message-State: AOAM530uzIy2stQmw2AObQHsTNNHSpvavpKqhBsV3DidbWFxj89BMYLk
        F+dFBaCbo+wNlSE4s+opH+nIIg==
X-Google-Smtp-Source: ABdhPJxGkO2wN5DSSua5V4AC/FHxC3IVSL/vCIJa5Px6KbB1NQlcTLKWka4biT2QL1cGujHEIE6dqg==
X-Received: by 2002:adf:c101:: with SMTP id r1mr27901092wre.38.1614782847631;
        Wed, 03 Mar 2021 06:47:27 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:27 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Prakash Gollapudi <bprakash@broadcom.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 20/30] scsi: bnx2fc: bnx2fc_tgt: Fix misnaming of bnx2fc_free_session_resc()
Date:   Wed,  3 Mar 2021 14:46:21 +0000
Message-Id: <20210303144631.3175331-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bnx2fc/bnx2fc_tgt.c:831: warning: expecting prototype for bnx2i_free_session_resc(). Prototype was for bnx2fc_free_session_resc() instead

Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Javed Hasan <jhasan@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Prakash Gollapudi <bprakash@broadcom.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index a3e2a38aabf2f..9200b718085c4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -819,7 +819,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 }
 
 /**
- * bnx2i_free_session_resc - free qp resources for the session
+ * bnx2fc_free_session_resc - free qp resources for the session
  *
  * @hba:	adapter structure pointer
  * @tgt:	bnx2fc_rport structure pointer
-- 
2.27.0

