Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE53C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AB8161423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347185AbhI2WJr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:47 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:45744 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347188AbhI2WJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:44 -0400
Received: by mail-pl1-f177.google.com with SMTP id n2so2510021plk.12
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=urS2XjYsdGd+sO9di0sTi7CmC+0ofkzpdFIqCfBC0cc=;
        b=ioSQ59D16S05JrUIM3xwlwmtwNw6ozfoOe3jFr4ovQhaUXaljXRT7gcg78VG8WQ2wm
         PT8gd9+Mn/PNHJxCtR0mhkElPwQw8zTG6p1drn+jw5YY5dlFFJPLwJ4j6wH2kmSfplR1
         x40lS9KoMwZRqvmwXJAXaILJbq8kzQUZiNhWcZ1XyYBzACnNCTsuQj/uGA2ckDZZ9Ie/
         UMDkFCxZWudXQJs0uRVfwLthBedXfZTubrzfsy7dDyI5/DdcvGPcz5zi3N4TgYIJLLx3
         qDzmpWpC1uQN3vXhS5PYwCBetbbDhMdmdCqP+Assu6mkzjNn1Yfo/zNQu8wMPS7wC1SN
         lQoQ==
X-Gm-Message-State: AOAM530FKSfJkSAIWYP/a02YN8W/fNzJn2P8hPIKkgTgA9Q62nIZ2pwi
        i7necvcQ3rjJISOWpMY11EA=
X-Google-Smtp-Source: ABdhPJzQfAL4/SkpDu3s9C2jfT4hdwUz6i4fZ1v8IPZbTdZo4uJYJnAOM3PzaWsEOtzEcrcpWQQUwQ==
X-Received: by 2002:a17:902:8206:b0:13e:19b2:af4b with SMTP id x6-20020a170902820600b0013e19b2af4bmr907967pln.82.1632953282877;
        Wed, 29 Sep 2021 15:08:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 67/84] qlogicpti: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:43 -0700
Message-Id: <20210929220600.3509089-68-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qlogicpti.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 8e7e833a36cc..30b5e98b5de0 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1021,8 +1021,6 @@ static int qlogicpti_queuecommand_lck(struct scsi_cmnd *Cmnd, void (*done)(struc
 	u_int out_ptr;
 	int in_ptr;
 
-	Cmnd->scsi_done = done;
-
 	in_ptr = qpti->req_in_ptr;
 	cmd = (struct Command_Entry *) &qpti->req_cpu[in_ptr];
 	out_ptr = sbus_readw(qpti->qregs + MBOX4);
@@ -1214,7 +1212,7 @@ static irqreturn_t qpti_intr(int irq, void *dev_id)
 			struct scsi_cmnd *next;
 
 			next = (struct scsi_cmnd *) dq->host_scribble;
-			dq->scsi_done(dq);
+			scsi_done(dq);
 			dq = next;
 		} while (dq != NULL);
 	}
