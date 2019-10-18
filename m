Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F85CA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2466321925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQIpO6cz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502805AbfJRVS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:18:58 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39300 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502569AbfJRVS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:18:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id p12so4022393pgn.6
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=64MFD7vPkExH+Xw+HVAbrEfisgdYfSCoOqqojmQkeVQ=;
        b=YQIpO6cz1us8OP6+RkgreRiwGevADkOmAGMO9uysw0eVg0YTceu0S4A4T6uIE90+Py
         MncNfInU8iWQ0CoWcEfe0u84S0JOsrrXvHNdBto3cNkv9q1T2TJa7ZyDmk8yO1HyhTcv
         SUOIild88zv/I8YNnJWkNQSF8Sz38/HqWpKMDWhXBVaqXnP1oZoNM3b2IncqnLGTF9BU
         7cfYmhhTWgkIPQaeiI0dqeUX1RRpwCQT2vkgZJVASz+AzlX+P/ISa5fFJZJjUc3ta4wP
         i1QJG+S16dOA88JxN92W2GVgSPeeKEyoLXEgmrCnnWDws8/oTIpD6ZB4oSn1KN8m1II3
         JQsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=64MFD7vPkExH+Xw+HVAbrEfisgdYfSCoOqqojmQkeVQ=;
        b=ZfrCEyOA9ZNdRg1c2lKkmICM5aS3BbZ5vsyCfml5cPq+RmtXx38t/cGoWyHuSmgyii
         kTC8tBcypGzHXyKFRH99he3bQ2cEqU3GzKHBJ91NNEOXfNh019KLfAfhON6OCsxUySaj
         JpT87kvBx0B5oxUafdBrqd+iN8lMNqChDCtqnCmf86JroipuSLWU5BaAGxeMJxNev/CY
         GIOWExg3ZEeekr9g6jlmXAbrd2dKvWqKMVAAO94T9odRILHbI3Mrb3O6YF3r5Q8bxz8S
         a6TwkBA5pmOh31wHzumCJe8YM2gyrFSXG+ow3Th9enMfKm8tjWbytxpyvw/T8cooATd2
         1nKg==
X-Gm-Message-State: APjAAAUcXg5YILxjAsB7fhXvPjkyW2qsmEqWJbuGdS3JW9zquGd7YwBO
        zJ/dcbQ9hrIonKxD6B8fAWDHXRs7
X-Google-Smtp-Source: APXvYqzdPzVlj/juqnAdEnAMhOPXb0+9HAwNRjXYpa2s/CBT90PcLY3gfKHSezh26RxllDtfN8+XxA==
X-Received: by 2002:a65:638a:: with SMTP id h10mr12048091pgv.388.1571433537478;
        Fri, 18 Oct 2019 14:18:57 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.18.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:18:56 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/16] lpfc: Fix SLI3 hba in loop mode not discovering devices
Date:   Fri, 18 Oct 2019 14:18:20 -0700
Message-Id: <20191018211832.7917-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When operating in private loop mode, PLOGI exchanges are racing and
the driver tries to abort it's PLOGI. But the PLOGI abort ends up
terminating the login with the other end causing the other end to
abort its PLOGI as well. Discovery never fully completes.

Fix by disabling the PLOGI abort when private loop and letting the
state machine play out.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index cc6b1b0bae83..64b7aeeea337 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -542,8 +542,10 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	 * single discovery thread, this will cause a huge delay in
 	 * discovery. Also this will cause multiple state machines
 	 * running in parallel for this node.
+	 * This only applies to a fabric environment.
 	 */
-	if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) {
+	if ((ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) &&
+	    (vport->fc_flag & FC_FABRIC)) {
 		/* software abort outstanding PLOGI */
 		lpfc_els_abort(phba, ndlp);
 	}
-- 
2.13.7

