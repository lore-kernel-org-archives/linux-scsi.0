Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E3AC25B77
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345910AbjHPTzW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345921AbjHPTzF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:05 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E071BE8;
        Wed, 16 Aug 2023 12:55:04 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-688731c6331so1414907b3a.3;
        Wed, 16 Aug 2023 12:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215704; x=1692820504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=buz7yG1gH/FErqP7TNn0hyeyJ8/RFoYWVgESu90bQm4=;
        b=IcYCz/zM7HhTekSUS5KMyls1MLUE5JZaUgZ6752Cxn2oim/SSyyAN2h13ZBug4ajQU
         S/EW2LPX3sn94fkQ8bgKCsNIcbuNZJtpbWV9RMu4tOt0DsMb9YEKDzY+2vOBevHeigu3
         kxiBqsmpDtsn7FmKxADorL69caOXQb9kHhc7TGEvgmRaCQs48m3J46JMqYM8lvjpcoHI
         B0HH6ReS3lWWHlDRwKvtEGvutOyielTlnTVbRoiNq3jLUmsbSPwKgvM4/pN1g4GTxLLz
         PfWVzlFbq/TUrdmVv4+km986yj+ejsx9XnAzOfR0IdKT1zAWAu5/0xe/FKMaSKdFwSju
         bD4g==
X-Gm-Message-State: AOJu0YzyPS+to+kUCUMPvOwGTxeBSsncT9vFEct+8Ihd4PVEoZfrA7hu
        9XFePDKIaNhaBfs+Aa4yhgE=
X-Google-Smtp-Source: AGHT+IGwjZopgZO6O5VKQZLlXIj8gkZLt/kCZCLpW9pgzDH1/vpW75h8eUOF0QD5ThxaYpg3i7j60w==
X-Received: by 2002:a05:6a00:84b:b0:666:81ae:fec0 with SMTP id q11-20020a056a00084b00b0066681aefec0mr3258142pfk.25.1692215703782;
        Wed, 16 Aug 2023 12:55:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v9 03/17] block/mq-deadline: Only use zone locking if necessary
Date:   Wed, 16 Aug 2023 12:53:15 -0700
Message-ID: <20230816195447.3703954-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
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

Cc: Damien Le Moal <dlemoal@kernel.org>
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
