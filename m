Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01865EE49B2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjHVTSv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjHVTSt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:18:49 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A88BCD2;
        Tue, 22 Aug 2023 12:18:48 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1bba48b0bd2so31905205ad.3;
        Tue, 22 Aug 2023 12:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692731927; x=1693336727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GjGIaWCkHD/AcFvunDs8CWF2fnVsmWJz6tsJCh5ZAlo=;
        b=aRRSRiAxRQXrzF2ojYqr7c7NpqFzVZXPPCrGa6W9fL2bEjK3wyQCMO3rTUwNWBJJa9
         ackU5I9FXhoq+1VnU10pWrOqu5a5XlcajnPXCu6lWPF0Fp07SCAY35hSJHOpYmlcoRkT
         leQ7v5bwTjShSdoW2no55iEpdntGmyu9I+61Q7n5AMZDTlY2/jWIZQ1WalPNiqa9q85R
         3HqDzznMpZhx93ceWMvk7W1OP7HMs7ZoOzZwvaCwHWI7cdWhJMcJ0MzR4QQn7IDxSRIU
         tztjhOIV6Cep0nVuxeXpIRvtkOQEV6dH3F+FAr0tUJYbtjTW0SHkfh50+9uZ3f/0IlQp
         RKuw==
X-Gm-Message-State: AOJu0YyETRna3oBeUOyUs6aH+XUzVWl+qbfaM4QtB01HdcMe9sBQtv4M
        evzyaQFmAtf6Ae+z27LqgCs=
X-Google-Smtp-Source: AGHT+IFp4rKL94syCqeyxdde3LzcMvKtXB0GQpl8gqaA9KAFa++Cby+oYs/2is4/oRPHHDIg0+xiOw==
X-Received: by 2002:a17:903:18a:b0:1c0:774d:9342 with SMTP id z10-20020a170903018a00b001c0774d9342mr5840909plg.25.1692731927438;
        Tue, 22 Aug 2023 12:18:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:18:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v11 03/16] block/mq-deadline: Only use zone locking if necessary
Date:   Tue, 22 Aug 2023 12:16:58 -0700
Message-ID: <20230822191822.337080-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230822191822.337080-1-bvanassche@acm.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Measurements have shown that limiting the queue depth to one per zone for
zoned writes has a significant negative performance impact on zoned UFS
devices. Hence this patch that disables zone locking by the mq-deadline
scheduler if the storage controller preserves the command order. This
patch is based on the following assumptions:
- It happens infrequently that zoned write requests are reordered by the
  block layer.
- The I/O priority of all write requests is the same per zone.
- Either no I/O scheduler is used or an I/O scheduler is used that
  serializes write requests per zone.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/mq-deadline.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f958e79277b8..082ccf3186f4 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -353,7 +353,7 @@ deadline_fifo_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 		return NULL;
 
 	rq = rq_entry_fifo(per_prio->fifo_list[data_dir].next);
-	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
+	if (data_dir == DD_READ || !rq->q->limits.use_zone_write_lock)
 		return rq;
 
 	/*
@@ -398,7 +398,7 @@ deadline_next_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 	if (!rq)
 		return NULL;
 
-	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
+	if (data_dir == DD_READ || !rq->q->limits.use_zone_write_lock)
 		return rq;
 
 	/*
@@ -526,8 +526,9 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 	}
 
 	/*
-	 * For a zoned block device, if we only have writes queued and none of
-	 * them can be dispatched, rq will be NULL.
+	 * For a zoned block device that requires write serialization, if we
+	 * only have writes queued and none of them can be dispatched, rq will
+	 * be NULL.
 	 */
 	if (!rq)
 		return NULL;
@@ -934,7 +935,7 @@ static void dd_finish_request(struct request *rq)
 
 	atomic_inc(&per_prio->stats.completed);
 
-	if (blk_queue_is_zoned(q)) {
+	if (rq->q->limits.use_zone_write_lock) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
