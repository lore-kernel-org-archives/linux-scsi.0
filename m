Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA148C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 21:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbjHKVgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 17:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236948AbjHKVgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 17:36:12 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E592213F;
        Fri, 11 Aug 2023 14:36:11 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1bdbbede5d4so7499025ad.2;
        Fri, 11 Aug 2023 14:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691789771; x=1692394571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n06oYeoYQM0v3vn2nA9IswRTL3X/Y5HU1qarWU54XEo=;
        b=TvAW2jrG5Yj2uV6KCM50EeSiuani/rjhPPa8he1XJaisIc20s4NeOjx+mkNSkb11ld
         vDDUcYv3kiDYeN/lr4d7qsFsKhh1xvJaW+lXvqThXkrKpYJJTHWvhsnN97acsVTbmMhi
         +L4qGkv0WAbVQa3NQver/45VnNGsX2UrYc7v4AAWeyi6OZs0dceZvcJiozTWN8SF2Byi
         kVibm3vX1NogzxTQWuLruMIEJ7x2T7w7NgzrqD20SJDV/wcAj6GYz1ep+JLwdiihrjNz
         NgxY24Ak+TQzQ3LfwALN0WJW6VHcu1yy4qgWYa/kmZfAzS0M/26BuhySmfDvqeZR8yX1
         q/jQ==
X-Gm-Message-State: AOJu0YzTNDtrnKKA6HdyzLw83lG2TXTlVwo0f+zA/Ikch6TImTdi7epq
        nJ14+9AfqeHffcsViDnTm8Q=
X-Google-Smtp-Source: AGHT+IE53t3cLEXbln8ILW+YTdF+jl3iSJDR/tcOotTM+KJ2FcaMUy2kmC1ywmCI41q6a0YY/SEyUg==
X-Received: by 2002:a17:903:444:b0:1b8:53b5:8518 with SMTP id iw4-20020a170903044400b001b853b58518mr2829779plb.63.1691789770961;
        Fri, 11 Aug 2023 14:36:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001b89c313185sm4394865plh.205.2023.08.11.14.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 14:36:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v8 2/9] block/mq-deadline: Only use zone locking if necessary
Date:   Fri, 11 Aug 2023 14:35:36 -0700
Message-ID: <20230811213604.548235-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230811213604.548235-1-bvanassche@acm.org>
References: <20230811213604.548235-1-bvanassche@acm.org>
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
 block/mq-deadline.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f958e79277b8..5c2fc4003bc0 100644
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
@@ -552,7 +553,8 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 	/*
 	 * If the request needs its target zone locked, do it.
 	 */
-	blk_req_zone_write_lock(rq);
+	if (rq->q->limits.use_zone_write_lock)
+		blk_req_zone_write_lock(rq);
 	rq->rq_flags |= RQF_STARTED;
 	return rq;
 }
@@ -934,7 +936,7 @@ static void dd_finish_request(struct request *rq)
 
 	atomic_inc(&per_prio->stats.completed);
 
-	if (blk_queue_is_zoned(q)) {
+	if (rq->q->limits.use_zone_write_lock) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
