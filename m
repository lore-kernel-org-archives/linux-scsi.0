Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C054C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44BA260F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244132AbhIRAIS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:18 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:37696 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245505AbhIRAIR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:17 -0400
Received: by mail-pg1-f170.google.com with SMTP id 17so11120846pgp.4
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NKTtUUthk/ESWzz61sGzL9IS7u3Z/gvAJoKvqL5bxCw=;
        b=V75yQjdTyQ4xwbpE/owMCxpJ97+rz+xxpzuZVOPEr5QPaF4I/XZaDFkWoCa6EuNnXN
         A/bj7761mbt9BFx7PV0S0vUj/Uqg4/P9rQ+zPafK3jOaV42UtNOJ1LfCsRpnKLPJgUHm
         GQDesFpP/dLDSZDKYrQ0mT517s1Kl0TfXRQwSzhhusvfbSABB9GJZVjhzBkNCaHFsNtq
         SX+NIRn9T6q9biM2btvx5twKipJcZqwQWYBxCnZ7MeMBIpU3natTqAydYVyjgx4kS0pe
         YgTkAdHbfxQvv+ymM9GUFTdlp+7N6uRn1+oUBMvi4O8HknZG/CPDZAqSz96FLkMWOyXW
         A6bQ==
X-Gm-Message-State: AOAM5302lhb8bAQ0b8Rj2+ABp6BZc+8PU+44YdMRRdsSAVLvURFivcpy
        D+E5hZbV0po9hYprT2ew+UYuq3jjZDo=
X-Google-Smtp-Source: ABdhPJx3wKlndUM/P+qnHvyvprRKY0YbS+M54wzCWMWuVZK9FMSSB8QWauVHhVWP7/x6kWkUQ4ZIYQ==
X-Received: by 2002:a05:6a00:d4b:b0:444:9854:2ee6 with SMTP id n11-20020a056a000d4b00b0044498542ee6mr6710106pfv.13.1631923614603;
        Fri, 17 Sep 2021 17:06:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 24/84] atp870u: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:07 -0700
Message-Id: <20210918000607.450448-25-bvanassche@acm.org>
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
 drivers/scsi/atp870u.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 9d179cd15bb8..6e1595b32bc0 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -512,7 +512,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			scsi_dma_unmap(workreq);
 
 			spin_lock_irqsave(dev->host->host_lock, flags);
-			(*workreq->scsi_done) (workreq);
+			scsi_done(workreq);
 #ifdef ED_DBGP
 			   printk("workreq->scsi_done\n");
 #endif
@@ -654,17 +654,6 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 		return 0;
 	}
 
-	if (done) {
-		req_p->scsi_done = done;
-	} else {
-#ifdef ED_DBGP
-		printk( "atp870u_queuecommand: done can't be NULL\n");
-#endif
-		req_p->result = 0;
-		done(req_p);
-		return 0;
-	}
-
 	/*
 	 *	Count new command
 	 */
