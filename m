Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D76C43460
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EF09610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhDOWJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:04 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:43983 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbhDOWJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:03 -0400
Received: by mail-pg1-f170.google.com with SMTP id p12so17851460pgj.10
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BbsHqAvEVr9VbDf2IgwsYK0bUo+eQhPGe0xVCw3XxEM=;
        b=e5D0886spHiqkz8L8P2PrJY3bPp1DKe+QQsCMRzjG1WuFbARCvDMaDvzC+vBw6t6Vx
         tDO59Ym7gF/P6k19HDYfHidxFEeWzgQOdlJIzkeFg7Gt+WyQXUjx3anxF7h5izTBnb/k
         KgTjxULK15Jz/A+NsfgcUt2wiD5ReIKaOlGvniZsHPft4D1J1ebhXGEKu1Sh5WR/n4Xx
         S+hser2i433gXKf3zKutLiyQUxBKs1TgxPpkuX2jdbaEazs6+AXq6HjgyBGVgyYcJ65x
         PTAFUY21ZsyjG2wpRGzEgWgbZTUL+lBL07GcfMiY4Y8fZwDZlCPjxMe8eMFnYSlf7z0X
         ObLw==
X-Gm-Message-State: AOAM533h8AxnrJ32A9ZFHEpukFl6TzlEYUonLYOZYd5Wdsn38z/uUVri
        ONeBd44PDxt2wTp/6IT1lFs=
X-Google-Smtp-Source: ABdhPJzaVthBRClr+OHEjfPhIFDKtgWUp27LshxHR6oVco7R4IBVvTPPExaZPnFPlAVWqXljYNfsIw==
X-Received: by 2002:a63:5214:: with SMTP id g20mr5440294pgb.158.1618524519349;
        Thu, 15 Apr 2021 15:08:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 03/20] Rename scsi_softirq_done() into scsi_complete()
Date:   Thu, 15 Apr 2021 15:08:09 -0700
Message-Id: <20210415220826.29438-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 320ae51feed5 ("blk-mq: new multi-queue block IO queueing mechanism";
v3.13) introduced a code path that calls the blk-mq completion function from
interrupt context. scsi-mq was introduced by commit d285203cf647 ("scsi:
add support for a blk-mq based I/O path."; v3.17). Since the introduction of
scsi-mq scsi_softirq_done() can be called from interrupt context. Because
that made the name of that function misleading, rename it into
scsi_complete().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 985ed427445f..c4d6157e8051 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1434,7 +1434,11 @@ static bool scsi_mq_lld_busy(struct request_queue *q)
 	return false;
 }
 
-static void scsi_softirq_done(struct request *rq)
+/*
+ * Block layer request completion callback. May be called from interrupt
+ * context.
+ */
+static void scsi_complete(struct request *rq)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 	int disposition;
@@ -1889,7 +1893,7 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit = {
 	.get_budget	= scsi_mq_get_budget,
 	.put_budget	= scsi_mq_put_budget,
 	.queue_rq	= scsi_queue_rq,
-	.complete	= scsi_softirq_done,
+	.complete	= scsi_complete,
 	.timeout	= scsi_timeout,
 #ifdef CONFIG_BLK_DEBUG_FS
 	.show_rq	= scsi_show_rq,
@@ -1919,7 +1923,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.put_budget	= scsi_mq_put_budget,
 	.queue_rq	= scsi_queue_rq,
 	.commit_rqs	= scsi_commit_rqs,
-	.complete	= scsi_softirq_done,
+	.complete	= scsi_complete,
 	.timeout	= scsi_timeout,
 #ifdef CONFIG_BLK_DEBUG_FS
 	.show_rq	= scsi_show_rq,
