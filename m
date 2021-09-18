Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F17CC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E7D760F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbhIRAIg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:36 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:39473 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344119AbhIRAId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:33 -0400
Received: by mail-pj1-f42.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso11125534pji.4
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8sXeHFJRxXdzWki0mpWTS9mlx4GmBzLM1LoZGQUiDCM=;
        b=bZoiaCAuhbb+c6yVH5IxtwEoTRHT7aUQRDE0WzdspQaVVQiylA46YZOX78thkGCQaA
         T2Ccew2T1kdTpJ+sR6nUf+NIvoDNY+/2QbsAMDON+8Ya8onCEWpNpKDJ8yaJRF/j5CDL
         3l/ukoslSDNE83D1oBjhwjYBVymwqvQ712c5+OmX7JDpF9Tr8NEhV07po1A31xCHbTsr
         iAUmVzqd+DX52jEEimZTAlBvLa4LQ9Ag+p3u9Joly2rUWxAlLGwSkLeBd5jHfaAyWeR0
         D9y/wNdauyUojg/FaAJ6uBjOwazY7J6/V9pzo1UbCTwAxMcCNgDPkfb4judaHExi4lnk
         ikkA==
X-Gm-Message-State: AOAM531rISojlWTQQDFZdmuGiRV70ncQWts929xVVDHBhRbDS+R+oVf2
        zpvQqsqyOAwOl1gASdG8Uy0=
X-Google-Smtp-Source: ABdhPJzPa3cIZFloKwuZF9ayX78MdZOhuJrC0vtLptsizma1CKZJHjK7pYHV+1vKPFJsDo+uutkjAg==
X-Received: by 2002:a17:90a:16:: with SMTP id 22mr24463441pja.25.1631923630850;
        Fri, 17 Sep 2021 17:07:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 33/84] fas216: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:16 -0700
Message-Id: <20210918000607.450448-34-bvanassche@acm.org>
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
 drivers/scsi/arm/fas216.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 9c4458a99025..170ec40a3ce7 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2027,7 +2027,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 	 * correctly by fas216_std_done.
 	 */
 	scsi_eh_restore_cmnd(SCpnt, &info->ses);
-	SCpnt->scsi_done(SCpnt);
+	scsi_done(SCpnt);
 }
 
 /**
@@ -2098,14 +2098,8 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 	}
 
 done:
-	if (SCpnt->scsi_done) {
-		SCpnt->scsi_done(SCpnt);
-		return;
-	}
-
-	panic("scsi%d.H: null scsi_done function in fas216_done",
-		info->host->host_no);
-
+	scsi_done(SCpnt);
+	return;
 
 request_sense:
 	if (SCpnt->cmnd[0] == REQUEST_SENSE)
@@ -2216,7 +2210,6 @@ static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
 	fas216_log_command(info, LOG_CONNECT, SCpnt,
 			   "received command (%p)", SCpnt);
 
-	SCpnt->scsi_done = done;
 	SCpnt->host_scribble = (void *)fas216_std_done;
 	SCpnt->result = 0;
 
