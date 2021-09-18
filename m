Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBF9C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82073610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345008AbhIRAKY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:24 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:41684 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345078AbhIRAJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:28 -0400
Received: by mail-pf1-f176.google.com with SMTP id x7so10593279pfa.8
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EogJeHd60KWPM8Bgj6GzNq3078KvLLq17w1D0M4dPnU=;
        b=60SWxSNxhSYz6hKe3+ZS7bwjtQS8JAQyv5MEDyJvgft03qaZOZ+5y3sZ/ciu31XOnq
         tMH90BTzc4wtz4N6Ae/i4OE/+uFgbO1oT2iP36xi22xu5HjkrPHrJZL5YwrXrz6nSFaU
         q/ywcLmPc27sr9E6M5DvGmT1O3OsjnW7RD6k82sQ8XAso/ARXhqLI5CUInYw74l+KOSP
         tFDENI6oWSgL8HL3B76MvA1HjUSs60PHPFc1G7Ay0leMCtK9Lz6RWxuUzdDlKf3CNEHO
         6UmlsHpW10+yj1lRbmWUUOR/NC5Fx7GE+hcaSRuPDmqWHRGj1/Vlqf6IEWZMaYGXjP0A
         tNXA==
X-Gm-Message-State: AOAM531zjQdqx57cOPlEFM/GThIJdD6Jx1xzte3R/O3t3lURJqgH1Yif
        NOACPuD5WwtGRH6cRV7d7w8=
X-Google-Smtp-Source: ABdhPJxBKk4qZf7eUMe7m9aoWM3vUJXISD+HLm0gVz7OZdoYGZoLgtFVingChvEwphQ4ufWdM+PODA==
X-Received: by 2002:a63:e64a:: with SMTP id p10mr12236306pgj.263.1631923685130;
        Fri, 17 Sep 2021 17:08:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 66/84] qlogicfas408: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:49 -0700
Message-Id: <20210918000607.450448-67-bvanassche@acm.org>
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
 drivers/scsi/qlogicfas408.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 3bbe0b5545d9..5471c046a4b7 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -442,7 +442,7 @@ static void ql_ihandl(void *dev_id)
 	 *	If result is CHECK CONDITION done calls qcommand to request
 	 *	sense
 	 */
-	(icmd->scsi_done) (icmd);
+	scsi_done(icmd);
 }
 
 irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id)
@@ -473,7 +473,6 @@ static int qlogicfas408_queuecommand_lck(struct scsi_cmnd *cmd,
 		return 0;
 	}
 
-	cmd->scsi_done = done;
 	/* wait for the last command's interrupt to finish */
 	while (priv->qlcmd != NULL) {
 		barrier();
