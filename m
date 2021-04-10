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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8855EC43603
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63D6B611AE
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhDJRbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbhDJRbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:03 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BE4C06138A
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:49 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h25so6182233pgm.3
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tkL9UstW8Nf2XCrZtSFyDr3ct2fd1eo7uTlSyDkZC7w=;
        b=lzSo7K9gNcQXJSqn5aIbV+yIYo+gcahG5OwMLJ/Ffgw8jWrOhQ/B9hNyGQU3LO2EQ9
         fQhnF6cxF1tTwETegw3gWTiaO0X+o9obU+JLy9RFEbp2oJ4BdoXR3XlpiHrSpmoAE8nc
         YtgjuMhvFqPauBpRuG5O1ccKFtU0vX8iVrFrjxt4n1IfccQ2PY88QKHilVqx3ZWz7cHM
         bJYjowj/zm4u1fTtqqLm33rDQ4RfI5CTWiaVDko5nvCwXfyIA8aj5YjPkgmtmlUfNo/7
         XDFK3SHS9r1meIgh+qroIUMfp4NwaWGFPqGfCsvgkFI3sJ1ozOLmvipf4JtOOUVdSDuo
         7wVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tkL9UstW8Nf2XCrZtSFyDr3ct2fd1eo7uTlSyDkZC7w=;
        b=Eb9UBuJb9NZbvxYBqRJ+q2kesgQpCU/XBWhqrZINKxgcUCBONAMKJsQbJrgk9kEz1r
         3RiFlBlq/Qo81Vbp0GZ7eQb5ulES3//B8u0rYhpSQeFd6K9hOqiCNIkcc2FvUVStEZYX
         KdYJXaXA0s1/YiLMHdyIhgOP+FomyKyQ/veAhTmYcmxQWRMJggCehF+3w8mlHI/7dFtB
         eYsVXCSPnNNVt2E7u0JDsXYmZunWyjsXYBehSNQJsMOC/IWsr9ldUIvsL8/DZSOT72dV
         9HzLuIDwZowz1/zQ6un6UeqVbheWhU1bNFLRFISrikGL2X2d9yk4UDXEgeXHTSvCXy+V
         Zv3w==
X-Gm-Message-State: AOAM533CUh+jXmPoyNeG3hupZ9BH5gbCuJl2TfskA+c7KY8WFSqZ7toX
        IiO/zpI5H1UHIxFTHgQBWQERDLAC6Ug=
X-Google-Smtp-Source: ABdhPJzY7MbYkFpRH+eREl3T4OJsjCA+Woyvayz7J/TE8e3Lv9laudkzVFGctVXY6+EcVenz1Y88Yg==
X-Received: by 2002:aa7:8711:0:b029:24a:3b1e:fb2d with SMTP id b17-20020aa787110000b029024a3b1efb2dmr2085366pfo.14.1618075848629;
        Sat, 10 Apr 2021 10:30:48 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:48 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 07/16] lpfc: Fix use-after-free on unused nodes after port swap
Date:   Sat, 10 Apr 2021 10:30:25 -0700
Message-Id: <20210410173034.67618-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
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
index 8a8d949979c8..e6c2699beda7 100644
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

