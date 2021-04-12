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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92844C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D42361027
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbhDLBcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbhDLBcS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:18 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD275C061574
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:01 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id i190so8139223pfc.12
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wdBkbtYzW6nob1I+F3ny5IoY4vgoUxoBfRznJfF1Lf4=;
        b=beM0nh83P01vpLwct1weh/iyuX8hFAaZj37I+OrMI6FvzfiIe3XgcOQEd13D/jzjB1
         zWj6PXGmWiUyVOtT3dlwrpW6RLLrziI4I1PURKNCcwzisn6JeVji0WcKxWAejTJsXn8M
         kOVX+/4xeeitVf17ye8fGHlea0mSGCYiERgsvawsxzqT215J9gqNSwYCYzMVwhZFy9UJ
         1TJs292MVh4QsYD+wJzSQhbgZO4UT5sCWqdcuhFLO9WpTsYGNZnWOlPAfAik7SyxtnxU
         fW3VTMgu/fGaMt/Ez97lHGFycfj5Oj4eXUqIy0iSD81vM9Ocj2zPy2srOIdqqXMUvK74
         jcUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wdBkbtYzW6nob1I+F3ny5IoY4vgoUxoBfRznJfF1Lf4=;
        b=DoomCbX8Z7HGD6eQ7k/YzCFFyfKzfV8olPRGQctoNwtjLA7TM3gfLz+d1+nAiRhnVI
         YfYfY/AV6StuVkhzs38nH0UPePfk4HSX9+A8y7zggepZzrccL9bWhd3QauycvWgVxWxI
         oa0w0/wbjRTuOXam1s8v3cfi5Vlfk93bS+cWRIncrU0iWr8qPT+AN7WuPn93sszPd2iK
         3XJVbdqTcIhaUWdmMLmQBnlh9v4Pjw4u2TOxC895F4emHKFjB1HqMDvleqyOR8iGrhYG
         IMqjYzKka1WHo4x/QOo2HbLRhA6Fnkw3P93/f3hO17hG6/nvmHx1AOvwuRMxLrJwMmLF
         D5LA==
X-Gm-Message-State: AOAM531JjJYORd0hEcLtLMJyCF+48MIX/+h540ImHQjJCiT6tj4aalmO
        AjPO4wKIcM8EOBPLWUTbsqtR9isZ0Zo=
X-Google-Smtp-Source: ABdhPJyB5Yls8QffkxnIWVy+D8TMXUz0fjpWaY6NR6ZlHTCKoAVVDwnTeUZx/IFQ5sdxa3KLl+MNWw==
X-Received: by 2002:a62:db43:0:b029:244:3c4c:6b90 with SMTP id f64-20020a62db430000b02902443c4c6b90mr18743741pfg.59.1618191121215;
        Sun, 11 Apr 2021 18:32:01 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:01 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 02/16] lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
Date:   Sun, 11 Apr 2021 18:31:13 -0700
Message-Id: <20210412013127.2387-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a crash caused by a double put on the node when the driver
completed an ACC for an unsolicted abort on the same node.  The
second put was executed by lpfc_nlp_not_used and is wrong because
the completion routine executes the nlp_put when the iocbq was
released.  Additionally, the driver is issuing a LOGO then
immediately calls lpfc_nlp_set_state to put the node into NPR.
This call does nothing.

Remove the lpfc_nlp_not_used call and additional set_state in the
  completion routine.
Remove the lpfc_nlp_set_state post issue_logo.  Isn't necessary.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 --
 drivers/scsi/lpfc/lpfc_sli.c       | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8472c5e716db..fd3d0197d155 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1901,8 +1901,6 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 
 		lpfc_issue_els_logo(vport, ndlp, 0);
-		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		return ndlp->nlp_state;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7832f8470667..cd9943f91eff 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18071,7 +18071,6 @@ lpfc_sli4_seq_abort_rsp_cmpl(struct lpfc_hba *phba,
 	if (cmd_iocbq) {
 		ndlp = (struct lpfc_nodelist *)cmd_iocbq->context1;
 		lpfc_nlp_put(ndlp);
-		lpfc_nlp_not_used(ndlp);
 		lpfc_sli_release_iocbq(phba, cmd_iocbq);
 	}
 
-- 
2.26.2

