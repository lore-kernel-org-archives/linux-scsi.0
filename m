Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3969C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD75061423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347129AbhI2WJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:10 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:43794 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346209AbhI2WJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:01 -0400
Received: by mail-pg1-f169.google.com with SMTP id r2so4127927pgl.10
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZKOwJEfK2W3RLsiewHHTr3TAHecYRQgSmAIibHOLf7o=;
        b=tFXY5T4yJTfyz/KFzS7yZnQKh6RYsyBzhT484K5cn5u+nbO1HPpkEEvrdNa2VCkrSZ
         NSOatwCDUtFct42Ec9CpGZlj8HADdEuFtSoiauyj2oUWtINKjxUEKMD3hNZwPb4opIlA
         M05MX0W6x0YRYFyCDkVLusjQJOH5jDk1pCrRt46k7R8ni4ZepCZ+Fs75AlnhsLENnFGa
         ViNbsd6k3tHzFNcQYrRnRsYwpjcV6q3bxDgQmVoExum+47/Ddktz+md7oTjwzTJEDH/D
         Ps3p3tZN52Rcx9zNinITPluqTfg6W1FtvSXtAWh8lwNz8QlPXyIh45p+fTGdPOOFmgbQ
         AXaQ==
X-Gm-Message-State: AOAM53141Q2UWfo2VQToECDSmPrvvfQs5Eks97YCwKwVmrHvaAnE2Q15
        klizpZ+NSLgrk36uDYCxIgnjMm3SDWc=
X-Google-Smtp-Source: ABdhPJxf2Hcz80U+qqJkGDU76Y8XYlwmJXx1EkVK5tW2lEvFXJZ2yLNqiiu4cSx5Y/fzuGyrZOWtKw==
X-Received: by 2002:a62:60c2:0:b0:448:7376:20c4 with SMTP id u185-20020a6260c2000000b00448737620c4mr959364pfb.11.1632953240133;
        Wed, 29 Sep 2021 15:07:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 40/84] initio: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:16 -0700
Message-Id: <20210929220600.3509089-41-bvanassche@acm.org>
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
 drivers/scsi/initio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 9b75e19a9bab..183f95758636 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2615,8 +2615,6 @@ static int i91u_queuecommand_lck(struct scsi_cmnd *cmd,
 	struct initio_host *host = (struct initio_host *) cmd->device->host->hostdata;
 	struct scsi_ctrl_blk *cmnd;
 
-	cmd->scsi_done = done;
-
 	cmnd = initio_alloc_scb(host);
 	if (!cmnd)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -2788,7 +2786,7 @@ static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
 
 	cmnd->result = cblk->tastat | (cblk->hastat << 16);
 	i91u_unmap_scb(host->pci_dev, cmnd);
-	cmnd->scsi_done(cmnd);	/* Notify system DONE           */
+	scsi_done(cmnd);	/* Notify system DONE           */
 	initio_release_scb(host, cblk);	/* Release SCB for current channel */
 }
 
