Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BAE3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002BB613B6
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347085AbhDMRHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:07:46 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:34484 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347074AbhDMRHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:44 -0400
Received: by mail-pl1-f171.google.com with SMTP id t22so8252188ply.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BbsHqAvEVr9VbDf2IgwsYK0bUo+eQhPGe0xVCw3XxEM=;
        b=QizS3za0RJMfw4j1uQqija54Ci6H9VFKfrKR8bKgw61CAU2vHiX1DOnbIttaR2DMx0
         ZHoouPcx2ytxigiX9jjvNtG8F7+2E4UVyaw6ZvlmCR/NCPX5ucDQNQA8x+Bmx3ow+mkL
         4K7t+JNepMZicNf9gqgl2kVxcAPPoVZvLJxWY8hgX2nS+ryybpGNtPgAtOuceq5zKUmI
         8MGiyMMtEk2K+jvaQoNGdvljzC/3NR/cL5qs3h7R4VyqrCa3xqs0BWqrfLW2WYicCJH2
         b/4BH6EIVv1C5ocqVinvOYde1J25er0UKDrhp5fxsGp2KlGFZF3F0B0G8TGKyrGMjqYa
         vnpg==
X-Gm-Message-State: AOAM533jO9N2Oo7r+sQYohzx2kAW1wjGrtVUhDjNrsps9Mrnh0cLUCBR
        iMoXv+kL9bh4JxLTH0OqIK8=
X-Google-Smtp-Source: ABdhPJzsO797x7VYuKEyiJoLEuexqAA0t4fgsf4OMKmMXu6lwnl6K9X5LtPM+0EDa1hUmQTqCE8cZw==
X-Received: by 2002:a17:90a:588b:: with SMTP id j11mr1040962pji.170.1618333644532;
        Tue, 13 Apr 2021 10:07:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 03/20] Rename scsi_softirq_done() into scsi_complete()
Date:   Tue, 13 Apr 2021 10:06:57 -0700
Message-Id: <20210413170714.2119-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
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
