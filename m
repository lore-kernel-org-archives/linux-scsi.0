Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9E6C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0861361164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344951AbhIRAJQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:16 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:45595 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344626AbhIRAJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:06 -0400
Received: by mail-pl1-f171.google.com with SMTP id n2so4625036plk.12
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=raghMrXmrq+nxI9vNhRRAV3vPKh2ubpRSJoXmk7pkFQ=;
        b=8B0w0oSfRiuld1Rt7OI8Yb1D707eBYuzzI1jrL1yFasmmUSQF59OA64D2Tdug007ri
         f2iQTlVlbShaI5rHd0tkxUGS8Oz1plCceNMfii9ulzezxc3FHkTGo9fj25KYbv6Q12OJ
         Obq6Us8DfWqI0wZlM4SKIrMl3Ygs6RWDg2Fw2FNEJzLnnnURkMwxfefF9XML3aoJZy5e
         fWf/sdkE/cPYZBGFj7Cj5wcb6oMv5GlzzyUHhNjVtztKO2GplvX2UbOG/2t+8kO493iy
         rDXcvEMMQHeKn6H0QHhf0BoK3VZwAIPjYImF90yUGjqBrUcTJ8UdaqTsnZfuudzW0dvx
         bpDA==
X-Gm-Message-State: AOAM533YAAkYVx0BnbwySejZ8fqfBoTBh3gc0F3cr2FnRgXYFCeAOJyn
        JpcOzDSx2dTUorD8way6qzBv0zoMkoZqiQ==
X-Google-Smtp-Source: ABdhPJzlU9bruVwGOIOPZJ1ajMxe2E9Iz4cX4D++rNHzcQTv6BOzgcHfFOi06Vnvt3iTpN835O5Pew==
X-Received: by 2002:a17:902:7b98:b0:138:c171:c1af with SMTP id w24-20020a1709027b9800b00138c171c1afmr12035749pll.70.1631923663424;
        Fri, 17 Sep 2021 17:07:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 53/84] mvumi: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:36 -0700
Message-Id: <20210918000607.450448-54-bvanassche@acm.org>
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
