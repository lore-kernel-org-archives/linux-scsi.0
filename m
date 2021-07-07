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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAF2C11F66
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7904C61CC8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhGGSqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhGGSqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:42 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDCCC061574
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v7so3256725pgl.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ie7Q3EUThRYmD8OZDb/784xCrGi7UhZ9Y/1ovsnX6cg=;
        b=GHlnkcDyD1pa5qzLXywmcCyXl7KK+DgZmblSyajuh1Pou8Qrb43JvJABPRNkpfNoH/
         +GPCdG/ayQMqzuEUWFhYkJR0yOIt8S3Jzw/XGdizQsA57k75GGAjKssEeb/reVv1CoWl
         lTz+r2ORAXxdi0ZaY7PjAw7fwL2r3aV5tIhdPsc2kWJH3x2eIX9k7MhqMc8dIhWUpLdy
         P1DDIX5aoyt5PoZ7GdnG27jdv7K2vrCTX2o8b+5k4b5qs2mT2ForAtBdddXu9gWHL/4W
         OiwSBSr91Rj5d+Gtf+344w1kySrmmQw+XcUzw10LP7S+AhTifGB/Q/N2yVldm2srVfzB
         /PeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ie7Q3EUThRYmD8OZDb/784xCrGi7UhZ9Y/1ovsnX6cg=;
        b=QpfYB1iTtXiu2EwnPv8EyulDSDHSNiJPK8girkLD0JJuoqhorl8bLylq0uHSfFdUNX
         MiUrkarDjRVjsLgpEZp+THKQ86i6b7hm/fvgdnXVYM1t+amGcxrH2H+A5paWq3MKQYJF
         cc+hwayek9XDemC09rtHEUL97VWJcQXlbf+8EtS7JF7RMrjwI4j+HaX4xjEXIXSCYsvh
         XKn8PjeAlHLNClM9nnxOvgHln2HTYDHkxLtRtie3utfjB1nL+hy2ouhY3yVm1f76oq5s
         tZaX+GFXVtI4SAGWgX3QVrg2dKYg7BHNK6xhzqrtTqXje+2GUCEoRT9sUCgLyK5k6eZy
         Klgg==
X-Gm-Message-State: AOAM533zWIrbNnSECSYo5fgFIFr0aoauuFkS01YG2mWbs2rK5m3I6hlw
        HCegQeK3/FHsQNF9eojZBSQtcHtCvAw=
X-Google-Smtp-Source: ABdhPJzQNzZctsuKDLQr6PljW8z4XD1yiOO4yU40XHGuW/qSyVRojEcVjKB1btcIYvlh3aDuya9mbg==
X-Received: by 2002:a63:338d:: with SMTP id z135mr27619710pgz.314.1625683440133;
        Wed, 07 Jul 2021 11:44:00 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:43:59 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 07/20] lpfc: Keep ndlp reference until after freeing the iocb after els handling
Date:   Wed,  7 Jul 2021 11:43:38 -0700
Message-Id: <20210707184351.67872-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the routine that generically cleans up an els after completion, the
ndlp put is done prior to the freeing of the iocb. The iocb may reference
the ndlp.

Move the lpfc_nlp_put after freeing the iocb.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b5c224aafea0..1abf63c85c4b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11623,6 +11623,7 @@ void
 lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		     struct lpfc_iocbq *rspiocb)
 {
+	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	IOCB_t *irsp = &rspiocb->iocb;
 
 	/* ELS cmd tag <ulpIoTag> completes */
@@ -11631,11 +11632,16 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			"x%x x%x x%x\n",
 			irsp->ulpIoTag, irsp->ulpStatus,
 			irsp->un.ulpWord[4], irsp->ulpTimeout);
-	lpfc_nlp_put((struct lpfc_nodelist *)cmdiocb->context1);
+	/*
+	 * Deref the ndlp after free_iocb. sli_release_iocb will access the ndlp
+	 * if exchange is busy.
+	 */
 	if (cmdiocb->iocb.ulpCommand == CMD_GEN_REQUEST64_CR)
 		lpfc_ct_free_iocb(phba, cmdiocb);
 	else
 		lpfc_els_free_iocb(phba, cmdiocb);
+
+	lpfc_nlp_put(ndlp);
 }
 
 /**
-- 
2.26.2

