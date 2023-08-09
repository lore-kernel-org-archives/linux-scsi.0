Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37598C001E0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 20:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbjHIUYP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 16:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbjHIUYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 16:24:13 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DF1212A;
        Wed,  9 Aug 2023 13:24:02 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-563e21a6011so206643a12.0;
        Wed, 09 Aug 2023 13:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691612642; x=1692217442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NzQNbfaKWGkxxfv4yeJF4grPPcZ/PzSiA77GygBeEUM=;
        b=NbazEDrZbRIcy8Tn+TlCMms+zMBw0cTFhCInBycpfP+LHyVRRSmU6DN1ogsJuYwNvp
         tW6/kqnhP60TETp0uiBSk+itcu7lvcDpmd1AcoWfkYaKhaCfF3D3gvIwSpIQ58XHbZng
         6DyqSM/vBKAZbLNp/0C+nsI9V6okHLDFs6VCOG5dJXFKzCSBsccoCoOKTgOUCOQUEuAz
         Z+crraZ/BbAgTLt8o/CzP4vKSn5cdRLLnGhJlLSLV1DIUmGNpZxOMBgI/OCT38odbzjm
         9rlGU+eS5NUt4PyrKJkG7dJbDNqstZtJDqary/vD3n5r7iQkjONqyxNDZauqyRsoX5YY
         +uKQ==
X-Gm-Message-State: AOJu0YwkCRFfgkE8TNLbrcdU7VRNVfCrfJKPVQeoFBJlx87PhM/JppF7
        CXYORz94zncn815sktiOwdoUNqNcs84=
X-Google-Smtp-Source: AGHT+IEkuyPyNNldM6jHTTi5So8Smn56rSBTxODpNtAeeaUfbhfHRsuDCf6AZZQeZsG+DA4i9eouJA==
X-Received: by 2002:a17:90b:4a81:b0:263:f8e3:5a2a with SMTP id lp1-20020a17090b4a8100b00263f8e35a2amr344762pjb.36.1691612641508;
        Wed, 09 Aug 2023 13:24:01 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id gq9-20020a17090b104900b002694da8a9cdsm1868103pjb.48.2023.08.09.13.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 13:24:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v7 2/7] block/mq-deadline: Only use zone locking if necessary
Date:   Wed,  9 Aug 2023 13:23:43 -0700
Message-ID: <20230809202355.1171455-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230809202355.1171455-1-bvanassche@acm.org>
References: <20230809202355.1171455-1-bvanassche@acm.org>
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
 block/mq-deadline.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f958e79277b8..cd2504205ff8 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -338,6 +338,16 @@ static struct request *deadline_skip_seq_writes(struct deadline_data *dd,
 	return rq;
 }
 
+/*
+ * Whether or not to use zone write locking. Not using zone write locking for
+ * sequential write required zones is only safe if the block driver preserves
+ * the request order.
+ */
+static bool dd_use_zone_write_locking(struct request_queue *q)
+{
+	return q->limits.use_zone_write_lock && blk_queue_is_zoned(q);
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
@@ -934,7 +946,7 @@ static void dd_finish_request(struct request *rq)
 
 	atomic_inc(&per_prio->stats.completed);
 
-	if (blk_queue_is_zoned(q)) {
+	if (dd_use_zone_write_locking(rq->q)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
