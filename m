Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0D6C43214
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E27FE61078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbhHETUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:19 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:41878 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242592AbhHETUQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:16 -0400
Received: by mail-pj1-f51.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so2732755pjy.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qjkKBA4uNCWH2mTP+yZ3vIfvVwLp3WuZYDfjgLtrzT4=;
        b=Hh3aNJoH29/aO68si+8U4y24lkdlwE+laylN/98NpRTfhytB2Obk5R8wO7lv/XLBqJ
         NQhZZBuY5Jhs/e0w1eFZk0RxCMZR4NeOZU2MQsvjub+uv2cJkdfE4v8YopJiePiISswA
         xSh5zqGbrfIV7vvxkJNVPc3WisPJ2xS/hUVfeVDx9xVXMlFoHjMd8Z6cIuuXHs4KUpUQ
         Gu7LpUW3/PYzBJO8Q4rw6Sy6dRPh9RxPJpTOzehzrdhimEiH2u4+9HkUxs5CHJXv3nJM
         +E1D4Qo2NTM3qiNfTqCd57gTbVbqMJ0u9LdNMN+JrKWvbxnMyVJ8ILMTk7wYDTErDOzv
         DITA==
X-Gm-Message-State: AOAM533N3PI9eksZvEwIrYHxKQglFTWe4nUUFywIuwUMo2xCLMSe6lBJ
        vWenRe2Twp/2SAMsxR+7DTo=
X-Google-Smtp-Source: ABdhPJxhqHbNgRkET8uLR5KqwHyVNSXLJT8yBGeYek50NqJmEzBEq8vsptEkzwnKxfDRiS1bi5NlOw==
X-Received: by 2002:a63:5815:: with SMTP id m21mr520006pgb.363.1628191200778;
        Thu, 05 Aug 2021 12:20:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:20:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 45/52] sun3_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:21 -0700
Message-Id: <20210805191828.3559897-46-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sun3_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2e3fbc2fae97..d6000a397f73 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -336,7 +336,7 @@ static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 {
 	int wanted_len = cmd->SCp.this_residual;
 
-	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(cmd->request))
+	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)))
 		return 0;
 
 	return wanted_len;
