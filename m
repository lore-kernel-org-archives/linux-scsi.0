Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DD5C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D59C2610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344969AbhIRAJW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:22 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:36470 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345015AbhIRAJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:11 -0400
Received: by mail-pf1-f174.google.com with SMTP id m26so10677047pff.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jT07YcNAYpM/yjLcB8hRpPTWU3XSM5z6Yr+Nf87OGNE=;
        b=GC8WsFJJsI/9AE38fXkpZSeDXr3HPBuXxKC9h8VTzHfNbaizocmFah74h14nSAZOZB
         kZEkSQM8rihYp3VFbUZ78CqcpqUzxxm2fkWfPEWuxknY5ElGw4rAOAXxpGYBltuD+OIk
         Hi7v2QKX+bYVb6IqKJl08uUfCn1TDy0K2ahJgwU2mmZvzZgPlyaxrJolBcEqIZ8aLiRL
         llXX6v4v6JRxFjM6e5VA6T0zLL+1KZ9Xsp25U3qlrY84DV3ujKvWJTOaH1vtkyrpqofq
         4o8hZTwKweSlhowIwbc+0UQiHmZEnEopAJQXnOBPsKOqBeyc1kFetTk888tkupSy7At6
         96bA==
X-Gm-Message-State: AOAM530sNwBwgePkrRMyO8dgbQrbtBvKcVYrHeED0OazfojpERo0jVF0
        xK2XV5UoSiVG4QjAzza/8hE=
X-Google-Smtp-Source: ABdhPJyPCewwkbV7062nKZcfxXemvHKzYpM6iSfr61TK6eyC3NbyP5hNHhDaDsdULWqGryZgr9LCBA==
X-Received: by 2002:aa7:9ac2:0:b0:443:a477:6684 with SMTP id x2-20020aa79ac2000000b00443a4776684mr9623731pfp.25.1631923668969;
        Fri, 17 Sep 2021 17:07:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 57/84] nsp32: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:40 -0700
Message-Id: <20210918000607.450448-58-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/nsp32.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index bc9d29e5fdba..1057b6fd7569 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -945,7 +945,6 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt,
 
 	show_command(SCpnt);
 
-	SCpnt->scsi_done     = done;
 	data->CurrentSC      = SCpnt;
 	SCpnt->SCp.Status    = SAM_STAT_CHECK_CONDITION;
 	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
@@ -1546,7 +1545,7 @@ static void nsp32_scsi_done(struct scsi_cmnd *SCpnt)
 	/*
 	 * call scsi_done
 	 */
-	(*SCpnt->scsi_done)(SCpnt);
+	scsi_done(SCpnt);
 
 	/*
 	 * reset parameters
