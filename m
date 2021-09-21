Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E0AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B74461166
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhIURgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:36:41 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:44904 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhIURgk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 13:36:40 -0400
Received: by mail-pf1-f171.google.com with SMTP id 145so125991pfz.11
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 10:35:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=+v5ujaNJjXmcRXqt0UqZBXyj/iRiPSi6W3kLWeZdqW4=;
        b=Lrk9gl5eogdmFpuXJWbxicKgJP9snZvFDf1xsqtmU1/6r5genWdd5Tx4ZWIJkxjPXg
         YlgDvkgpmwY/PzatedNY0NK0/wzk/yLIUuSjdxhlkb3oAtKIYWTubMZw/AofnNRxdlyZ
         f4lQkUPpeGQxZZ7RKZEys/h1MSb7lrZpARJNlAz4c7dez5UtvOAWGBf/pp7mefasyQju
         58o05xuUMMJVghuuKxeksuEx90Vl5G6/uz03RRxzjRdWRiq6u31GpB30ZLlTZ769JmBH
         QsG+8Va7piEQc+KKPUd6WxxfR9Od4Abc6INlgUIgY9ojUTG+cdi8rY3SqaMIkkNfgxiP
         IkxA==
X-Gm-Message-State: AOAM532NnTdcH1DAzZGnvKQ70ZjUYuMJxvtV2QkqCkzUHr5nBPAJEbry
        qx9d7cgmZX5n4yfzwDfDuls/3/q/8OA0hg==
X-Google-Smtp-Source: ABdhPJwLWIxaQEQwJce4fG+CFakuOsauUxPe+A5xM1zZaoFQVXmAZK8htuSOnb6/EP0itY0/W/wQlg==
X-Received: by 2002:a62:51c6:0:b0:43d:e849:c69d with SMTP id f189-20020a6251c6000000b0043de849c69dmr31673052pfb.31.1632245711539;
        Tue, 21 Sep 2021 10:35:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3f15:8d17:800:eea3])
        by smtp.gmail.com with ESMTPSA id w22sm14561603pgc.56.2021.09.21.10.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 10:35:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mike Christie <michael.christie@oracle.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 82/84] target/tcm_loop: Call scsi_done() directly
Date:   Tue, 21 Sep 2021 10:34:34 -0700
Message-Id: <20210921173436.3533078-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210921173436.3533078-1-bvanassche@acm.org>
References: <20210921173436.3533078-1-bvanassche@acm.org>
Reply-To: 20210918000607.450448-1-bvanassche@acm.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/loopback/tcm_loop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 52db28d868d5..4407b56aa6d1 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -71,7 +71,7 @@ static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
 		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	else
-		sc->scsi_done(sc);
+		scsi_done(sc);
 }
 
 static int tcm_loop_show_info(struct seq_file *m, struct Scsi_Host *host)
@@ -165,7 +165,7 @@ static void tcm_loop_target_queue_cmd(struct tcm_loop_cmd *tl_cmd)
 	return;
 
 out_done:
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 /*
