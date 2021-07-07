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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BD5C07E9C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A805461CD2
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhGGSqr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbhGGSqn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:43 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E2AC061574
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:02 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t9so3243151pgn.4
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lP9b1Oygjgq82OieErigQ+Dy8BCsov17Z5zbGNZ7w/k=;
        b=nqhcrbGYLbcGzEvqM2MQZbd5KBqpdjJ2pe6wWMDjheU2ZE4ADVIQiJC2zGFcCB54b0
         9XR/zzBb0AySLPsX+IcGL5UtBpUXfR7C9CTFY0C9O6NmmgTmsUvrtWT+Ebzg7LrcX9Z5
         cGm9ahMGG6ThuCbNzzko4kNJZURPmN+MdaSqRsmxdN963vpEhAJFg+xb4x4k7fEFDDsq
         tWE3sHroz8VqoHRIAvVvQGpkXCMVmstI/QieRmpEf54LwYz+uF1bbPFvzPeiaFI99vPN
         7OQcpQu1NAk/llwprhVbIwI0HGGaUrzAnN/powz4dVu9t0womLx57R4l+CgkAtBsJQok
         BbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lP9b1Oygjgq82OieErigQ+Dy8BCsov17Z5zbGNZ7w/k=;
        b=REjux4hd1zcB06n+A6kFeq33NjxIznSYQw0wH0cAdx6DN5UjAzL6+JXmvAA9UuheVE
         9ulP1AL1sbOeAdRO9Ap1A0uqKRa9dHR4yBLcla89xBtQ0o+mvJ1Zqn9Ue5/ol3AvQalO
         mpOwjWLlbtN+uScMtUlZpWFgZcmWZ6uYshUjiINNMFvP9blJmoS67dXxIUSn65IJnCZr
         3KTJaN96TQkRSjDbvxYJUskw9AC04zJxMyXXhC3lhVhalzUItybEoAuVwrFu15jKWZkU
         BNrUKzBYh4stFRqZxIdC82WSVMYQRADiXmKyiaSXOTSBr6bA8PWydXVbT8Lq/5jcmk7U
         Yv+g==
X-Gm-Message-State: AOAM530D+6JKZp8yNUQSFUarie7l6eAPGv4cMdC978OicGZzbUAE6GU0
        a9rrq65KyuPuqvV1swk+7KH6DNKsboM=
X-Google-Smtp-Source: ABdhPJzGlhRxAFp/7b7k3LUb17EI4nnpUjptJ8sgzKzVgH9ZuqIEGAC/N9XC+P9h3y2KChzknGQPyw==
X-Received: by 2002:a05:6a00:22c1:b029:31c:f694:6f4e with SMTP id f1-20020a056a0022c1b029031cf6946f4emr20196572pfj.65.1625683441996;
        Wed, 07 Jul 2021 11:44:01 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:01 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 10/20] lpfc: Remove REG_LOGIN check requirement to issue an ELS RDF
Date:   Wed,  7 Jul 2021 11:43:41 -0700
Message-Id: <20210707184351.67872-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the REG_LOGIN to the fabric controller happens in parallel with
SCR, it may or may not be completed by the time RDF is sent.  RDF and
SCR are sent to the fabric in parallel, so checking for a completed
REG_LOGIN in the RDF submit path is not needed.

Remove the REG_LOGI check from the RDF submission path.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3381912bf982..94dc80dc99b7 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3666,18 +3666,6 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 	if (!elsiocb)
 		return -ENOMEM;
 
-	if (phba->sli_rev == LPFC_SLI_REV4 &&
-	    !(ndlp->nlp_flag & NLP_RPI_REGISTERED)) {
-		lpfc_els_free_iocb(phba, elsiocb);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
-				 "0939 %s: FC_NODE x%x RPI x%x flag x%x "
-				 "ste x%x type x%x Not registered\n",
-				 __func__, ndlp->nlp_DID, ndlp->nlp_rpi,
-				 ndlp->nlp_flag, ndlp->nlp_state,
-				 ndlp->nlp_type);
-		return -ENODEV;
-	}
-
 	/* Configure the payload for the supported FPIN events. */
 	prdf = (struct lpfc_els_rdf_req *)
 		(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
-- 
2.26.2

