Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49CFC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE529610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbhIRAKf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:35 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:38768 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242339AbhIRAJh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:37 -0400
Received: by mail-pg1-f177.google.com with SMTP id w8so11117969pgf.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bb7RMcS6aWofjbIJF92wtw8NtOHtJtd4jm47r/Gt/Jg=;
        b=pE+rHWNWhbH+e0IBkUFEijKrCceNeP0FCxEoH2KXqPgaAa2zwIJSCy9nwzUSgkNgu5
         Yr5sie9rxwsDgEP96Mvkj5yu2VLasETU/xYW1+WUYkA9Vj3kpqI06q9SCEUPfq23/yJ2
         ZZaFuXrNdPV0VzZb19PbcOe+AWhdsHU1eTR3pHNF4pjhMeHo2fyWPztA23s2kbqPog2u
         lNvio/gxquQlp7s/30/kJpusriJ34Dg/Ca7TH0gudRor4Gp0Xn/6TtraaP/dix76bjoM
         ABLu6vnd34G+mZlmNou9UvShWFf49/Ant+wRTFoiOEkCTtRHjreTOIJUah+wkeyR6TEJ
         lkWA==
X-Gm-Message-State: AOAM532e1wFVhAurn58IbdUgMFpS6dVT6jZZhWOVNEKU9YlSQMOcpMqn
        LgA+k098aYGEUP0dPzeHlCU=
X-Google-Smtp-Source: ABdhPJzSQfEp8FkQIvgBkEmOf1wXXPEWI+pTn5lepxkMxUpSsLhmt+hAm63NehjnzyFD4JclJPkqWA==
X-Received: by 2002:a62:ea0a:0:b0:412:444e:f602 with SMTP id t10-20020a62ea0a000000b00412444ef602mr13589050pfh.85.1631923694837;
        Fri, 17 Sep 2021 17:08:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 73/84] sym53c8xx_2: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:56 -0700
Message-Id: <20210918000607.450448-74-bvanassche@acm.org>
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
 drivers/scsi/sym53c8xx_2/sym_glue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 6d0b07b9cb31..76747e180b17 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -133,7 +133,7 @@ void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
 		complete(ucmd->eh_done);
 
 	scsi_dma_unmap(cmd);
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /*
@@ -493,7 +493,6 @@ static int sym53c8xx_queue_command_lck(struct scsi_cmnd *cmd,
 	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
 	int sts = 0;
 
-	cmd->scsi_done = done;
 	memset(ucp, 0, sizeof(*ucp));
 
 	/*
