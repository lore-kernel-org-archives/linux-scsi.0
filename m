Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91F5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D54DC60E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbhJGUdE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:04 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:42563 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242428AbhJGUdD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:03 -0400
Received: by mail-pf1-f175.google.com with SMTP id m14so6297590pfc.9
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kN0F5K9QDlkRAbNNppOPinsr2YjHrE1twOJBxSeRcWk=;
        b=axk5MczpLR7kG3J/P1upRWVyh4sG2mSSWMvFt7yKpVOFM07NuUieeMklpYMZQGrumb
         bjnst1j2REfe8n49cgcPG0rV53KTwj61526BPXufNBld7Z1rU6IMyqAQZVmMMB4zyp1U
         DPl773BKbQHCoB3OY8/OyFWPaVvlgNZ8iUs4uF+RatW8mCdowtgEXYbs9NkYXPDim4I3
         UZafOQfDFp9/dok/rBhW0ZicOY5SGREQX6Lccv4LNtQws9fa81JvDMark6L5eVg6lVQe
         gsvKjnakzVDa0Nn/sz3OEX4M0Y9oTfz8AoOtgavFxZv+pjAUG+xJ9j6jgf8iepwXxaX0
         FibQ==
X-Gm-Message-State: AOAM530E02dmcnYFU3YwyytGD/qer/LT5c9zHONqPM7oFUfNsZI0In0r
        KiQJc6O1dsc64GkHai6tArE=
X-Google-Smtp-Source: ABdhPJwctMURg4f+QJtly9heUasmho1jtRi+xP2aLcnYayUHsbxvPhKiLQbhK9Rxas4Lad2wa6/bJA==
X-Received: by 2002:a63:1656:: with SMTP id 22mr1391238pgw.20.1633638668703;
        Thu, 07 Oct 2021 13:31:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 57/88] ncr53c8xx: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:52 -0700
Message-Id: <20211007202923.2174984-58-bvanassche@acm.org>
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
 drivers/scsi/ncr53c8xx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 2b8c6fa5e775..6ad43a98409c 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4003,7 +4003,7 @@ static inline void ncr_flush_done_cmds(struct scsi_cmnd *lcmd)
 	while (lcmd) {
 		cmd = lcmd;
 		lcmd = (struct scsi_cmnd *) cmd->host_scribble;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 }
 
@@ -7862,7 +7862,6 @@ static int ncr53c8xx_queue_command_lck (struct scsi_cmnd *cmd, void (*done)(stru
 printk("ncr53c8xx_queue_command\n");
 #endif
 
-     cmd->scsi_done     = done;
      cmd->host_scribble = NULL;
      cmd->__data_mapped = 0;
      cmd->__data_mapping = 0;
