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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854B5C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70BA261CCD
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhGGSqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbhGGSqn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:43 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD753C06175F
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 145so3082433pfv.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IBBGqilqsoY3KWB5nmZAVsYzQTTL8XNkKqSSRvVOtP8=;
        b=RmMI0Bvo5Vyad/FWdWJC3UBhKmuTeUkAqGXE+us+Xo/kaYN0HTpGjhQkvSdwF6GuLE
         95KaOMyJjsEN+W7fbiWHk3dgutSSjPB2qDtuYngx1Se99nQLwXlg2OSZZHuXvz3zjvlU
         dSYdjrjnvMdOvdOy/RXiL0p+myFGEDkpWC8gleyKbpzpdzLNroKKtI2UvIX7APRN2mH0
         sKb7RHsxZ5n+R2BtvPkxAaxEVs85bVvLWB85TiPIqYtutRlQ7zrcB1tTfFCvrb5t8WTS
         mdOh94/i7Tvms+xUhGNOpF9HnD3OEyhU1ZYRIT2JQFqd3+h99ZyQtwi3gor47u1nqzbo
         kxZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IBBGqilqsoY3KWB5nmZAVsYzQTTL8XNkKqSSRvVOtP8=;
        b=UUs8/rjzsuQ3wqpxwuN5dWgO+5dHubYxyTZZzmXB+u7RptPw6Gx6g9bVKIoJlAMoSL
         zWsJJgytudCVkhksE1ianRy0pByQi5S+CsPaGPh2v1SO36XggN0k0CsZEZ8GwgHuS8hi
         l2oU5rK8YBSrkyDln9oy6jvAIbmTM6gNMHWGHk/+k074YlCOe1NGf7XGZTaUg7VUjVcr
         IhJIjL6iXt7w1hnCdma3r+TtCjmymKfsUKfpNv/8fmua4tzwXvHyOLJV65nz6JdnUBIe
         FMFdAPDbM7PKBQzC6Co+oXRaJQ3cgofT6OjtDEXtjVArMqzuHGsHe27lRndYXnBmTIsQ
         c1oQ==
X-Gm-Message-State: AOAM532tqZQsH/mDmfFLIm7z8hWeVxF99aMMJ4r23/AAgbgX3gre2E69
        lB2bRIsYzyOhD0q0p9w2K/L0122nmuE=
X-Google-Smtp-Source: ABdhPJw+nAHD9Y0wShIY4DPERs0pQbCjU0XCs33Q1PF69iMbGn5n4CIg29gSwC8f9nutjFBHVhDc1g==
X-Received: by 2002:a63:505d:: with SMTP id q29mr18817313pgl.137.1625683441332;
        Wed, 07 Jul 2021 11:44:01 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:01 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 09/20] lpfc: Fix memory leaks in error paths while issuing ELS RDF/SCR request
Date:   Wed,  7 Jul 2021 11:43:40 -0700
Message-Id: <20210707184351.67872-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The els job request structure, that is allocated while issuing els rdf/scr
requests path, is not being released in an error path causing a memory leak
message on driver unload.

Free the els job structure in the error paths.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b1ca6f8e5970..3381912bf982 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3375,6 +3375,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		rc = lpfc_reg_fab_ctrl_node(vport, ndlp);
 		if (rc) {
+			lpfc_els_free_iocb(phba, elsiocb);
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
 					 "0937 %s: Failed to reg fc node, rc %d\n",
 					 __func__, rc);
@@ -3667,6 +3668,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
 	    !(ndlp->nlp_flag & NLP_RPI_REGISTERED)) {
+		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
 				 "0939 %s: FC_NODE x%x RPI x%x flag x%x "
 				 "ste x%x type x%x Not registered\n",
-- 
2.26.2

