Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707C0C41513
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 15:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjHDPsh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 11:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbjHDPsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 11:48:32 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAF52D71;
        Fri,  4 Aug 2023 08:48:31 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-686f1240a22so2059036b3a.0;
        Fri, 04 Aug 2023 08:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691164110; x=1691768910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/dgxEXFnorII/KCLaOV4R9mvcBZp+FsMdRey1KII0Yw=;
        b=ak8HBgVYIjMGaCC5XR/UVRLaOs3pM60VRHsNpZBZ7gBiAvP4oNzAJwP4s8bRs+4trf
         Bh0YqU8Ss9vbxybGi+6FKNpwEBIuEnCElvaCyExmBNbrxbV3xCC6qpbs4zjmYgAyA+OQ
         euPs/r9b6pOYL+al9mY0AIk6PXKills9tJj4xLPEorZugVpatQQV5N7BQtT3NW12CgtJ
         rrJeOY5/aVKKILepNqaDX5j6DmRlq20AbyS6XtdIDOSZCqeYYCZ/BSCpS+YDbdyqnX+y
         HZ60MzMnYqxjUb8YxH5dSkLRr2D09wmGxRarBxCVqtaHShDOypRKFtMbrrgUEtYZ73Po
         Rvnw==
X-Gm-Message-State: AOJu0YxcJyX7tfNWi+Cd5cfZQvn1RGS8Kut4fw97D5ijyZ/Lkexdakkh
        ItArraQaYue12k9UFc8scHQ=
X-Google-Smtp-Source: AGHT+IFWBWo9WoVkeoqVtei66Au+rXkw/bmznip5BJsQzjlXJa+HYw6p7t4RGUdRjnh+gEap6Ym9pQ==
X-Received: by 2002:a05:6a20:6a28:b0:135:293b:9b14 with SMTP id p40-20020a056a206a2800b00135293b9b14mr2587253pzk.55.1691164110488;
        Fri, 04 Aug 2023 08:48:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4af5:d063:a66d:403b])
        by smtp.gmail.com with ESMTPSA id h8-20020a62b408000000b00640ddad2e0dsm1760839pfn.47.2023.08.04.08.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 08:48:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v6 2/7] block/mq-deadline: Only use zone locking if necessary
Date:   Fri,  4 Aug 2023 08:48:00 -0700
Message-ID: <20230804154821.3232094-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230804154821.3232094-1-bvanassche@acm.org>
References: <20230804154821.3232094-1-bvanassche@acm.org>
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
 block/mq-deadline.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 02a916ba62ee..1f4124dd4a0b 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -338,6 +338,16 @@ static struct request *deadline_skip_seq_writes(struct deadline_data *dd,
 	return rq;
 }
 
+/*
+ * Use write locking if either QUEUE_FLAG_NO_ZONE_WRITE_LOCK has not been set.
+ * Not using zone write locking is only safe if the block driver preserves the
+ * request order.
+ */
+static bool dd_use_zone_write_locking(struct request_queue *q)
+{
+	return blk_queue_is_zoned(q) && !blk_queue_no_zone_write_lock(q);
+}
+
 /*
  * For the specified data direction, return the next request to
  * dispatch using arrival ordered lists.
@@ -353,7 +363,7 @@ deadline_fifo_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 		return NULL;
 
 	rq = rq_entry_fifo(per_prio->fifo_list[data_dir].next);
-	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
+	if (data_dir == DD_READ || !dd_use_zone_write_locking(rq->q))
 		return rq;
 
 	/*
@@ -398,7 +408,7 @@ deadline_next_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 	if (!rq)
 		return NULL;
 
-	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
+	if (data_dir == DD_READ || !dd_use_zone_write_locking(rq->q))
 		return rq;
 
 	/*
@@ -526,8 +536,9 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
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
@@ -552,7 +563,8 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 	/*
 	 * If the request needs its target zone locked, do it.
 	 */
-	blk_req_zone_write_lock(rq);
+	if (dd_use_zone_write_locking(rq->q))
+		blk_req_zone_write_lock(rq);
 	rq->rq_flags |= RQF_STARTED;
 	return rq;
 }
@@ -933,7 +945,7 @@ static void dd_finish_request(struct request *rq)
 
 	atomic_inc(&per_prio->stats.completed);
 
-	if (blk_queue_is_zoned(q)) {
+	if (dd_use_zone_write_locking(rq->q)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
