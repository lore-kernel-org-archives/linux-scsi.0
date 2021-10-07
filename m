Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5F2C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A63360E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242227AbhJGUcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:14 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:38596 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242239AbhJGUcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:09 -0400
Received: by mail-pj1-f50.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so7797147pjc.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NKTtUUthk/ESWzz61sGzL9IS7u3Z/gvAJoKvqL5bxCw=;
        b=Jya9yf6LjEDUDslIJuqwB+t4csbNOo7E7jeSnqjtRwOZEOd/PkxYKR5fWFzmrFJG+3
         bCroQTe/UuKzJRBJdrDmGa1+DLgcC6C4QsN+ZhmRS4LW1Pq1ctNix55lVowgBmrGiRti
         CD+O81AAm877Rnmxt4rDTjaIZNVwatx+9d+RPnBJ2ZG3qwRgTgVD1vFy3txYh+IFX49s
         yAR9EMS/5ZYY2+zYfipBIszK/sXY7tjEDJwUlbHoo38QQm85zwenXk1oeUF+L1rwZgPz
         Fm/MQNe9larAJ3JofXniaiJhEeA8Oy1v12tU7rl9RzA+TI6c87rZb0JMCHKjDqc5kWqG
         pN/g==
X-Gm-Message-State: AOAM532lU50K/S3zE89Gjaa1CUqsVcWhBFcc6JEs/Smb2gw1Ua3UcdoS
        FOHWvv+QYHgrNGstUg2uKAk=
X-Google-Smtp-Source: ABdhPJyTQhugjg3vgznCE/sJlpz+lzrr3GS9TRRQvbd3mRFxXyi5QEzADUgS1y5WF7ytQfedY7mdlw==
X-Received: by 2002:a17:90b:1bc3:: with SMTP id oa3mr7131959pjb.75.1633638614708;
        Thu, 07 Oct 2021 13:30:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 23/88] atp870u: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:18 -0700
Message-Id: <20211007202923.2174984-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
