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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E640FC43461
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F5D61025
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbhDLBc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbhDLBcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23D1C06138F
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:04 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso6172198pjh.2
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5vRobdnpZluxJTk6UdxYGceuRCeU43Gs6G/oYigCUvE=;
        b=e6rI+iqZ34qgzJHNrSxkDG/7gUp/HAGSjlx2UW5bg8MBP+u5JnAI5G1/5yH+ZEWq/G
         ee4Xfmd5ltjtOrIsHoNRy2pjfe60Me3ckMD+Xwwl0hlJiv3IACsK4C+3Yqc2VEWEPOgM
         GP+BAvyVfWrHoTUvIGC2Te8k4EcSlT4FhoBtacftrKyh88JXrBLPlDdYytjE9dP5qHdY
         0EjL2+YZHUwjXXDwPqpWbPUsVvAEGkjyjgP3qzx9HS+knmC1g/5hqYpXlhRIRKGf9d2w
         XxsGu4TTeRg2m/zT/7Y9deMhjk0LeV3602MzCfQwyZf3VLkXrSc90ALCIsxVwhBefuR/
         hqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5vRobdnpZluxJTk6UdxYGceuRCeU43Gs6G/oYigCUvE=;
        b=d2LCmlrd8dojv4ZXwXAWS1z0w4gJtLRAE8sOY8/dCpHwnA6szKW4oGyypFJHUectRd
         dIsd3fTNNxBMWE5VFYQSTNkseXga6PGo/QerK/tgZP2yKqdd8k+NVEJsFGRt/WbUB0lJ
         iGAgBZ1SapjzZ2/0sjPiQsZv+O27ywiB8RoUi/lR4kIm1fRPS13HcdJgmg7AxIA8kx55
         Z53aClgmWaculvPbzoii3ktk5XVNkMRiaFr8G05Jttpwegld/5TGofZd1lsFam1607Aw
         +JMLAs5ZSjMOsGZOPZ6Oq//YU57PrGSYL6bUuCXba1wk5S21O+A95CkRlAspRqPfGUCX
         C9rQ==
X-Gm-Message-State: AOAM533Kft9r1d6ZW3iVRmaZPsdaK3MhFCHJDSGRjEoHJ/qr6wXRoBCF
        eFWUi5pcbGkKPX+re8aNjN6NTgjJQqU=
X-Google-Smtp-Source: ABdhPJxnnlvloLU3oh4dUhzZjDKkHWlfVcOpzKhuDzXdNVNdndwFykzVf2jRa6QbkKgMB+WL4AmMIw==
X-Received: by 2002:a17:902:e2d1:b029:e9:ec4:e0da with SMTP id l17-20020a170902e2d1b02900e90ec4e0damr24223520plc.85.1618191124212;
        Sun, 11 Apr 2021 18:32:04 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:04 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 07/16] lpfc: Fix use-after-free on unused nodes after port swap
Date:   Sun, 11 Apr 2021 18:31:18 -0700
Message-Id: <20210412013127.2387-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During target port swap, the swap logic ignores the DROPPED flag in
the nodes. As a node then moves into the UNUSED state, the reference
count will be dropped. If a node is later reused and moved out of the
UNUSED state, an access can result in a use-after-free assert.

Fix by having the port swap logic propagate the DROPPED flag when
switching nodes. This will avoid reference from being dropped.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ed57d92e96e1..c919bedd931c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1691,6 +1691,15 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	else
 		new_ndlp->nlp_flag &= ~NLP_RPI_REGISTERED;
 
+	/*
+	 * Retain the DROPPED flag. This will take care of the init
+	 * refcount when affecting the state change
+	 */
+	if (keep_new_nlp_flag & NLP_DROPPED)
+		new_ndlp->nlp_flag |= NLP_DROPPED;
+	else
+		new_ndlp->nlp_flag &= ~NLP_DROPPED;
+
 	ndlp->nlp_flag = keep_new_nlp_flag;
 
 	/* if ndlp had NLP_UNREG_INP set, keep it */
@@ -1705,6 +1714,15 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	else
 		ndlp->nlp_flag &= ~NLP_RPI_REGISTERED;
 
+	/*
+	 * Retain the DROPPED flag. This will take care of the init
+	 * refcount when affecting the state change
+	 */
+	if (keep_nlp_flag & NLP_DROPPED)
+		ndlp->nlp_flag |= NLP_DROPPED;
+	else
+		ndlp->nlp_flag &= ~NLP_DROPPED;
+
 	spin_unlock_irq(&new_ndlp->lock);
 	spin_unlock_irq(&ndlp->lock);
 
-- 
2.26.2

