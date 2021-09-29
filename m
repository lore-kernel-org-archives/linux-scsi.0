Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06752C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E17CA6134F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhI2WN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:13:29 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:40838 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347311AbhI2WN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:13:27 -0400
Received: by mail-pg1-f174.google.com with SMTP id h3so4154436pgb.7
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tk1iMfDg8FJsNJNO4AOwwGjgSN3v5RCO/M89yAZxYH8=;
        b=WVi2x0dLr+1LzlBMT0rzehfEmD1E2m0i6TVNBiaB0kIa08v4SHdtzR+FV5HzHhbylz
         iuCs3YkAhb4jKZoyWkGpctTkhP/pbWH+dIumNfJRHgmm0P9XnsirQGHBgt7xRmtLuDWI
         1Z7qpo47ykJ2cKz/ETkoTW1eBecoN4zCGZ/HtdWexe+TUD4OQuC3TdvgtnjO03AQ4bUK
         lqsRkRTQQFCu3H+h8cPIMPU/CJzuCqxFUnJOxl26ORrnz4tAhOBJ2V5rv5lPnHxVTJFG
         uxC/knLMjlQsFYp+/JIwaD+pRoaJXFIhhHLbL8r67sekzzQ7gLjqBRBKK2GKP7TAGMEz
         ljiQ==
X-Gm-Message-State: AOAM533Uc1EYq4BfIFNPc5Gi49SrcrT126PVdJgJNOiqhiFz3/KAJ17O
        mdiRj/wm6tXbgxe1Kz6veKo=
X-Google-Smtp-Source: ABdhPJxPs+/rCImmZbfVNpv+BMOgEe6HKI30WH09lSootz1p95Q5HeLQm3TBpmzwd37sa8GsZoyIOg==
X-Received: by 2002:a63:b64e:: with SMTP id v14mr1895303pgt.245.1632953505853;
        Wed, 29 Sep 2021 15:11:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id 139sm706461pfz.35.2021.09.29.15.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:11:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 80/84] staging: rts5208: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:11:31 -0700
Message-Id: <20210929221138.3511208-1-bvanassche@acm.org>
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

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/staging/rts5208/rtsx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 898add4d1fc8..f1136f6bcee2 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -140,7 +140,6 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	}
 
 	/* enqueue the command and wake up the control thread */
-	srb->scsi_done = done;
 	chip->srb = srb;
 	complete(&dev->cmnd_ready);
 
@@ -423,7 +422,7 @@ static int rtsx_control_thread(void *__dev)
 
 		/* indicate that the command is done */
 		else if (chip->srb->result != DID_ABORT << 16) {
-			chip->srb->scsi_done(chip->srb);
+			scsi_done(chip->srb);
 		} else {
 skip_for_abort:
 			dev_err(&dev->pci->dev, "scsi command aborted\n");
@@ -635,7 +634,7 @@ static void quiesce_and_remove_host(struct rtsx_dev *dev)
 	if (chip->srb) {
 		chip->srb->result = DID_NO_CONNECT << 16;
 		scsi_lock(host);
-		chip->srb->scsi_done(dev->chip->srb);
+		scsi_done(dev->chip->srb);
 		chip->srb = NULL;
 		scsi_unlock(host);
 	}
