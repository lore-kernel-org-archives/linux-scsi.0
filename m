Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16987C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 027E960FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347158AbhI2WJ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:26 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:33669 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347159AbhI2WJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:22 -0400
Received: by mail-pf1-f177.google.com with SMTP id s16so3196819pfk.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=raghMrXmrq+nxI9vNhRRAV3vPKh2ubpRSJoXmk7pkFQ=;
        b=Mim1w7Lf2NP0ThcZNUvvWnZwc8AG0RPJu7WYVnv5opvKa1PAl8h+pbRwEJScbCgjbq
         fJmkTfAmCT9A3kWfbsXQrmL4NXY23aBQATQ90PERJMPwshkf/MjP1aaMe1QnQFiNLi7l
         mmwvGC3mb8uP7TrSbwdvIou+FkdHE5wqzsBu0TBM+SIS9dcsviKGDs+le2IFtJbo6FAh
         z9p7VLW9mK06ZzKTflBxHqJTnu3pT83HbL8LLpwhE0LChocI1NInIWuEAi2SCKCak/6O
         9d8u20Oh3Z0nNaOEWhBpJ5wdyPVZL8HY0PF2dovB6qmeczSLj0r9LknLzbXhzJQzFTwA
         hBXw==
X-Gm-Message-State: AOAM532KyD4g3nuqVfWItKvC2vpIhu4bYcmNViAeXYF0ylqwzV6aQyzs
        eVDrQ5nD0uL9LoZMd9LUpG0=
X-Google-Smtp-Source: ABdhPJz1cqS9Lf+XMugf21q6iRMD/xaRiRZHgCqgNofdrLJMe4qY3ELL4Vx4eCiHYDt51KvYeYWo5g==
X-Received: by 2002:a63:5b56:: with SMTP id l22mr1927456pgm.170.1632953261077;
        Wed, 29 Sep 2021 15:07:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 53/84] mvumi: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:29 -0700
Message-Id: <20210929220600.3509089-54-bvanassche@acm.org>
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
 drivers/scsi/mvumi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 4d251bf630a3..904de62c974c 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1328,7 +1328,7 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 		dma_unmap_sg(&mhba->pdev->dev, scsi_sglist(scmd),
 			     scsi_sg_count(scmd),
 			     scmd->sc_data_direction);
-	cmd->scmd->scsi_done(scmd);
+	scsi_done(scmd);
 	mvumi_return_cmd(mhba, cmd);
 }
 
@@ -2104,7 +2104,7 @@ static int mvumi_queue_command(struct Scsi_Host *shost,
 
 out_return_cmd:
 	mvumi_return_cmd(mhba, cmd);
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 	spin_unlock_irqrestore(shost->host_lock, irq_flags);
 	return 0;
 }
