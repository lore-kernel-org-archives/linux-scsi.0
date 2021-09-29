Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9FCC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 273FE60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347098AbhI2WIj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:39 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:55223 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347125AbhI2WIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:35 -0400
Received: by mail-pj1-f43.google.com with SMTP id me1so2693748pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NKTtUUthk/ESWzz61sGzL9IS7u3Z/gvAJoKvqL5bxCw=;
        b=mYZrOGPLqzibezR0YRaZhisbDJlOPvPgimh718Ioie5nYp/GJ8gu0D8oBdj/RFeXEB
         gAXeuq/sKTJkYxKyDg9/GmmJoRMjJxij4w/HAm/HnXP1pkEUn8k725FUWdm1C9o5weX8
         BFQeB7tVWCZfZWmSKeAo510p5GCyy2UTu5/rbGsqCfRXYBHEQxA0T0fIKnboJaeS5U3q
         kdTLQfbMKTxfZOgPqm3W5yIjUrXZhyYh68Q/+FfQgHUelt1wQdCT2mpdYngJkahdMX1c
         r7TnZPr4c/Fq42RO5aOThafu+u7hvS1wRW1s9a0TtxYBFkAC8W7+wwP1kHeAPCgVjb5B
         46HQ==
X-Gm-Message-State: AOAM532QSE7YZ3sHu7K0ykM+nII3vRULamqq65bKs+EnT3HqkOOxPuqj
        S3IFQbKhBFA3tZTJKb8AXqt1ThqQ6ck=
X-Google-Smtp-Source: ABdhPJw+kbQQWXit7IkZjlwNaWF4pPS5YOyWci6JMo1ip0lwLoWmqgqFlUOh0SU/r74N6JdeGP4TDw==
X-Received: by 2002:a17:902:76c4:b0:13e:2f2c:bdaf with SMTP id j4-20020a17090276c400b0013e2f2cbdafmr936334plt.70.1632953213786;
        Wed, 29 Sep 2021 15:06:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 23/84] atp870u: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:59 -0700
Message-Id: <20210929220600.3509089-24-bvanassche@acm.org>
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
