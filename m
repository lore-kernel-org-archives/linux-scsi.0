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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A20C43470
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4026D61027
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhDLBc1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236564AbhDLBcW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F1BC061342
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:05 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t22so8184787pgu.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e14H//ZExwZjjG3XlbWrBxfMo9QPyT+IgqonFSeGhWg=;
        b=KYNhy2JTvvYXgT+erDGP3rpBaM9BfRwmlQCChLCgK581YEYit/DB/u/k3YKxhDgiNK
         4hw/SzzceY4R32LUOcuqnEgcD1MGQF1nYrFfNK8oS3uiqEpwneJbacIAC4+QgnRMHsT/
         bvEtF/grmAA6tWQGBnCee0NmcX7nNQogBLqTWdo5mMcaxQxTR6wWVVU1pMv7+Mi6w6KM
         PvYA2bUZqevYtVyLAjI5h44neeC93Wo61cI3Iql5Aek6vsaoBdH1dkKoT/4wfv194DMA
         fiO4Hy+fU8nw6cKavcKJH4E4Qa15XTTe65xyaxNtHyjwIFcnCfwASRqZgmUasceF/Qq5
         4yHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e14H//ZExwZjjG3XlbWrBxfMo9QPyT+IgqonFSeGhWg=;
        b=SiWV5rGzjG+H+NSsNZjT+oEb+r1WPjEAGhbJb97BdJP/chvhF5rrQMXY8lR+2K9Q4A
         SmDc/0QQ0r4obkzJpi2jGVMRcp0Lh9VrT/nHJSNjdecMiJXQhit6Ss1jdzU36+3WmpD6
         k1+FH/SVzb2ZPBtFvRZDWyEEmOaemKqv5sMT7okPxphmPl6KEbd6y6WKorBQQ4eW+7sr
         VFUnNzq9PWR03PK+ttffEN5mWCqFeyhsTXx/bZC4v+qWsbmx7dXja36NRQ60I7+gTBAj
         CW83rDWt30++O9dNVCrCdNFialf6lmUvBzeiDAXydm00A0O3RReaQCR5CNJeVbBsiFI0
         wRaQ==
X-Gm-Message-State: AOAM532V3XUrdWcJ3womDNSab6vS11MfZ8yO0yavoOsBgUvIE8WafWsJ
        PnPpP+mDccsu9dcXtoo4VtqyU71Vmxc=
X-Google-Smtp-Source: ABdhPJzXAegeSVpn91e2n2OhZi3J7MCCVxyL0NZr0ZX0lzKyym62N0BnjyregjFwOXgJzPqVzNVx1w==
X-Received: by 2002:a05:6a00:1585:b029:203:6bc9:3ca6 with SMTP id u5-20020a056a001585b02902036bc93ca6mr22792178pfk.79.1618191124797;
        Sun, 11 Apr 2021 18:32:04 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:04 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 08/16] lpfc: Fix silent memory allocation failure in lpfc_sli4_bsg_link_diag_test()
Date:   Sun, 11 Apr 2021 18:31:19 -0700
Message-Id: <20210412013127.2387-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the unlikely case of a failure to allocate an LPFC_MBOXQ_t structure,
no return status is set, thus the routine never logs an error and
returns success to the callee.

Fix by setting a return code on failure.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 503540cf2041..48a6b0cc58ef 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2435,8 +2435,10 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 		goto job_error;
 
 	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!pmboxq)
+	if (!pmboxq) {
+		rc = -ENOMEM;
 		goto link_diag_test_exit;
+	}
 
 	req_len = (sizeof(struct lpfc_mbx_set_link_diag_state) -
 		   sizeof(struct lpfc_sli4_cfg_mhdr));
-- 
2.26.2

