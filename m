Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CADC4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B1FF6112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242614AbhHETUA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:00 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:55135 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242775AbhHETT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:58 -0400
Received: by mail-pj1-f50.google.com with SMTP id a8so11290885pjk.4
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8ZrZxpFyLWC/b8TX2g9suyIzirLulmQYWjh1aPwWLg=;
        b=LZixOy7KUulW1LP9c8QBUk4QBJOIfd2LSKdgHNF3EhT+o9A8g7L/GvAg6Kx+KYLTQO
         xvFaqftDQxBLxJzd9vip0/Xc47uyylQWhn5BnlE00hVbGgYwHnjxe7iikNyvdbc6aK5S
         BM0W/BpzpRwmBZ3e0AYgYBxN6dGnXxN7WHZqa5PfqC2pomi6C/8A0vpFTokJS0RgrbOl
         vWmpmjz5iPf2tlb64hwvqUradv6ZOxqhJ3BDmrYNiWmbKRaCzucl/+95wy+7boOkd5Hg
         qeo79KdzkNvwvcLUAZNBV1cT34dIOWU7CXtG5t4g8OSui27GQgdex/B9gtWXFfgdqmcI
         v8mQ==
X-Gm-Message-State: AOAM531h50YzPodIBYjkgR6JtPqS7betNS4cy1WRMHoufG9YAb8g1LVH
        AwDr3pTJWbO+UEu8LaTaoG4=
X-Google-Smtp-Source: ABdhPJwZ9arwezNvLdisqdgDHKvHIboaAnWehJ/6fe4BDpPE1FPLscgivRPSCap8EYE4bu/NgfAb3Q==
X-Received: by 2002:a17:902:d50d:b029:12c:80c1:3f29 with SMTP id b13-20020a170902d50db029012c80c13f29mr5485648plg.70.1628191183688;
        Thu, 05 Aug 2021 12:19:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 34/52] ncr53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:10 -0700
Message-Id: <20210805191828.3559897-35-bvanassche@acm.org>
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
 drivers/scsi/ncr53c8xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c76e9f05d042..09958f78b70f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4164,8 +4164,8 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	**
 	**----------------------------------------------------
 	*/
-	if (np->settle_time && cmd->request->timeout >= HZ) {
-		u_long tlimit = jiffies + cmd->request->timeout - HZ;
+	if (np->settle_time && scsi_cmd_to_rq(cmd)->timeout >= HZ) {
+		u_long tlimit = jiffies + scsi_cmd_to_rq(cmd)->timeout - HZ;
 		if (time_after(np->settle_time, tlimit))
 			np->settle_time = tlimit;
 	}
