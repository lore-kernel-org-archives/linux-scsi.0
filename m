Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447D4C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B4A96140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347180AbhI2WJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:40 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:36419 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347053AbhI2WJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:36 -0400
Received: by mail-pj1-f51.google.com with SMTP id u1-20020a17090ae00100b0019ec31d3ba2so5220930pjy.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dKE9o/+g4929dyCq2nGwYGFLUetIkYpKTXBeXH0/mTc=;
        b=LOeuVDN7YGAOBn7Pz48IYQROsnfIyUGEmiCrhQtYzGL+WCNb/L/wIOr4+NBSQGTFKY
         +BDI6LK2DVnDLg+bYjpLwqYBxM0NBmf3V5nVPzNOEYSslXTX3pZygs755fFKkCKXe0ty
         MesJUA+gFxHrFNr+Mv2RSiSahf1LsEe4P57Er4Rwp5SmGAMMWonx/bxnNOImtpSCauIN
         Dk8K4m77FLjTvUgoJM300lhnvck/io1dGf9pGAJ1yWCAq3NcQxp9DQH2/vmAteeUklFY
         DsqDlyWAOa4fc7CQcq13rJVD2m/dFdNY3S/r8Cl4KHN3dNbIZL42bUBn4v118jVsyHQK
         8xDA==
X-Gm-Message-State: AOAM533PPbUwBguMmiYMlXXKObBMjQkq3bZiY/fTND+gvIuZOUt1nZFW
        FlgLN20DjcQHpeqr7AmLK7cOpeZPOq4=
X-Google-Smtp-Source: ABdhPJypnXFvhd/hZyiXvZ+hOOMniGIFbY4Jxuksc79RnlkOgwILea/CjC64slxIRAR/cJwdnxrYLw==
X-Received: by 2002:a17:902:b286:b0:13e:1a30:ebc6 with SMTP id u6-20020a170902b28600b0013e1a30ebc6mr936731plr.72.1632953274811;
        Wed, 29 Sep 2021 15:07:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Geoff Levand <geoff@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2 61/84] ps3rom: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:37 -0700
Message-Id: <20210929220600.3509089-62-bvanassche@acm.org>
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
 drivers/scsi/ps3rom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 0f4b99d92f12..08e970300b3f 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -209,7 +209,6 @@ static int ps3rom_queuecommand_lck(struct scsi_cmnd *cmd,
 	int res;
 
 	priv->curr_cmd = cmd;
-	cmd->scsi_done = done;
 
 	opcode = cmd->cmnd[0];
 	/*
@@ -237,7 +236,7 @@ static int ps3rom_queuecommand_lck(struct scsi_cmnd *cmd,
 		scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0, 0);
 		cmd->result = res;
 		priv->curr_cmd = NULL;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 
 	return 0;
@@ -321,7 +320,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 
 done:
 	priv->curr_cmd = NULL;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return IRQ_HANDLED;
 }
 
