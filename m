Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D576C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7828D6140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347168AbhI2WJj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:39 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:36408 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347147AbhI2WJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:35 -0400
Received: by mail-pj1-f41.google.com with SMTP id u1-20020a17090ae00100b0019ec31d3ba2so5220892pjy.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zfxVhZCFvk45D3OUj/xVsg8PqFWL9WcofwLGfuG8Jpw=;
        b=nYSu5jNPo5S7BVZu/qBqSJ8TiM8LlAXGjP4FoCPEfSNh2ITDvY9iv7mvxaZ9ekEsXJ
         a8Pv3kj+7gggRP0NT4E71QBcVVCqtb2VmyS5vQTWaYeMxjGydjTuWCemQy8o+tlYY/lK
         P1IhLBU3Ou6Eql+EyMzXx35BMjy2khA7Io8NdGQ3Wk4L1AIjOjUf8c5Z74/5171KepOu
         xCAufv3oB49OzrXpDhBFN0WFyQMNFbxuKxeHwvNzr9EQj2RCHqeSfBG2NNdZMOvFa3tR
         byfe+m1i9sqiATyWCUiMVjH0ZLRB2t9UbVQqJC/W+2ILCet8Hip1MxsZaUfrVHR52LJP
         GN8g==
X-Gm-Message-State: AOAM533ohAjYQZVozeT69cfIfb4+xhAd4v8D2dcjbH1cP61oNgsv6Ead
        bjj8GGN4/CmgeFg2P+VjmYU=
X-Google-Smtp-Source: ABdhPJxcWRN5qcMnZni+FLT+rzES8h3rJ1848rxTtdSmIRDrbI+6Jlp9Mu4wOgxIb+UHy4XN+4nsEQ==
X-Received: by 2002:a17:90a:9908:: with SMTP id b8mr9017455pjp.203.1632953273447;
        Wed, 29 Sep 2021 15:07:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 60/84] ppa: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:36 -0700
Message-Id: <20210929220600.3509089-61-bvanassche@acm.org>
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
 drivers/scsi/ppa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 977315fdc254..799ad8562e24 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -665,7 +665,7 @@ static void ppa_interrupt(struct work_struct *work)
 
 	dev->cur_cmd = NULL;
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
@@ -798,7 +798,6 @@ static int ppa_queuecommand_lck(struct scsi_cmnd *cmd,
 	dev->failed = 0;
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
-	cmd->scsi_done = done;
 	cmd->result = DID_ERROR << 16;	/* default return code */
 	cmd->SCp.phase = 0;	/* bus free */
 
