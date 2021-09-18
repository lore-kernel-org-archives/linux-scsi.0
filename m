Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0A8C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E5061164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345038AbhIRAJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:21 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:38740 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344976AbhIRAJK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:10 -0400
Received: by mail-pg1-f179.google.com with SMTP id w8so11117028pgf.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bc2hHq3UHgHOKwsd4O7CY40azxenFfvLTOrXTmqo+58=;
        b=dY7ZcKdi/zNw/M3XG0f82e/YHMQOl0fqxvHI5qyJfHJV6bZzA49C3oWst/87mpVQ4r
         Cj0rVATApIFNhessxH4cglcITUY6nhqhbA6Y1w36l0ocx67a3aELbCR5d7M5Z+rTXYgh
         7bWyOvmmFaOu4PbJpvcBWOKt2YnEd4EMevzjpLDiQdFcw2LKXdb/CrnqHUAWILdun8l3
         vVmBZf3nv65mIkph0w4+HrQij8MJ5OZorvSN18VDRFW0XZ5NdZ+j2G3ZETIT5SRej4Pf
         wdyPgquSKgC/7I3ZiNlyTgl6jEBwVi6/RLF79m7W296MLFJtEAw8TKe41SlpCd2VgtvK
         SWXw==
X-Gm-Message-State: AOAM532dNMKvAR5dBerR2YleZ9yLOGrm5Zr9E7uLTlDSx51f2oz4XorY
        uVm8B+GBqpLvrwK4jzlbLY8=
X-Google-Smtp-Source: ABdhPJzHakc3t3j6/Mk5+6WD6Dm6GFSr1Q8pm1IpMXo3YNm93yrUH1xFHw2wzpSCUHfAx6qoB2QyAg==
X-Received: by 2002:a62:bd15:0:b029:31c:a584:5f97 with SMTP id a21-20020a62bd150000b029031ca5845f97mr13468425pff.33.1631923667576;
        Fri, 17 Sep 2021 17:07:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 56/84] ncr53c8xx: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:39 -0700
Message-Id: <20210918000607.450448-57-bvanassche@acm.org>
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
 drivers/scsi/ncr53c8xx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 7a4f5d4dd670..6c6cf111be5f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4006,7 +4006,7 @@ static inline void ncr_flush_done_cmds(struct scsi_cmnd *lcmd)
 	while (lcmd) {
 		cmd = lcmd;
 		lcmd = (struct scsi_cmnd *) cmd->host_scribble;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 }
 
@@ -7865,7 +7865,6 @@ static int ncr53c8xx_queue_command_lck (struct scsi_cmnd *cmd, void (*done)(stru
 printk("ncr53c8xx_queue_command\n");
 #endif
 
-     cmd->scsi_done     = done;
      cmd->host_scribble = NULL;
      cmd->__data_mapped = 0;
      cmd->__data_mapping = 0;
