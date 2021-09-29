Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45849C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D8DB60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347121AbhI2WJL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:11 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:36389 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347142AbhI2WJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:03 -0400
Received: by mail-pf1-f171.google.com with SMTP id m26so3172444pff.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MQERA3T4j1mewJlnCoSDIbhMa8LyGqwprFKISLrkUiY=;
        b=ER9p6miRgtOjT/Y2Hkh2oa4oFrNmtJBnrce+7/eLGEoADGFGK809OXC91/gme/B+7E
         0sd2pLNab7W5+4XG4fVYfZHpaWvk7UbWcuj1v/Isc5A2f1gh4h+NQUIgTNkoEGRA6PCz
         gnysZ7rwB5B3d7M20uBzwbLn6k5TQeNon2asmIdFWnCxGd5NuNrZtE0d04E2koWeKxAj
         cEq4nwxmwNqdbowIiYyNUPYstc5YH4B3YZJ8OnzFr5SfrL03f1NSNQge9ahLduQV2Q+f
         sXDAkFtejJk9IMOJm06KarJ5dGoOLhdRILEYwvQL3Mrem20HbUVvQnvkEXyYVKSCuwMV
         F/Qg==
X-Gm-Message-State: AOAM5312BaLSneB4krl2W5cojiIO+UXRPFk5sBvMRLapKzwsJ1RQFLe4
        U1R/XDOb8BXjtmm263KxZZouqaVR7n0=
X-Google-Smtp-Source: ABdhPJydbBGCvoNcoJsaF+RSb//tdpDW8cLvq4u1bkew1wO2bCjU3Fw2aNPl1IGbGHPMJ3Rqo/ZxSA==
X-Received: by 2002:aa7:9ac2:0:b0:443:a477:6684 with SMTP id x2-20020aa79ac2000000b00443a4776684mr2113160pfp.25.1632953241466;
        Wed, 29 Sep 2021 15:07:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 41/84] ipr: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:17 -0700
Message-Id: <20210929220600.3509089-42-bvanassche@acm.org>
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
 drivers/scsi/ipr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5d78f7e939a3..aa44216dcf9a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -866,7 +866,7 @@ static void __ipr_scsi_eh_done(struct ipr_cmnd *ipr_cmd)
 	scsi_cmd->result |= (DID_ERROR << 16);
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	if (ipr_cmd->eh_comp)
 		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6065,7 +6065,7 @@ static void __ipr_erp_done(struct ipr_cmnd *ipr_cmd)
 		res->in_erp = 0;
 	}
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	if (ipr_cmd->eh_comp)
 		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6502,7 +6502,7 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
 	}
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	if (ipr_cmd->eh_comp)
 		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6531,7 +6531,7 @@ static void ipr_scsi_done(struct ipr_cmnd *ipr_cmd)
 		scsi_dma_unmap(scsi_cmd);
 
 		spin_lock_irqsave(ipr_cmd->hrrq->lock, lock_flags);
-		scsi_cmd->scsi_done(scsi_cmd);
+		scsi_done(scsi_cmd);
 		if (ipr_cmd->eh_comp)
 			complete(ipr_cmd->eh_comp);
 		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6685,7 +6685,7 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	spin_lock_irqsave(hrrq->lock, hrrq_flags);
 	memset(scsi_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	scsi_cmd->result = (DID_NO_CONNECT << 16);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
 	return 0;
 }
