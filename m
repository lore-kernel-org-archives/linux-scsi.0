Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4685EE499D
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379816AbjHRTpj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379851AbjHRTpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:45:23 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C3C421F;
        Fri, 18 Aug 2023 12:44:47 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1bbff6b2679so10022125ad.1;
        Fri, 18 Aug 2023 12:44:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387793; x=1692992593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GjGIaWCkHD/AcFvunDs8CWF2fnVsmWJz6tsJCh5ZAlo=;
        b=VkNnq8fTEM5yoJPJGi17esCP6Wx6H4e6dCp/PqyleCZQKzYOcl3myrlq/S0ZDNV4L9
         FMf+/Vc6TFfM7oNRoyiYhSEPibhM4hTluyUEA5xlfYbJ6EPbpsz+qMdAWHcjI2qgoiTt
         L1wjFrR25zxB3JE33gyOj9LSpj6nKE8vkkSX0hoeP3+LWLW/fNPhsI2BzXqLoZCkmHs+
         zNCTfOQMLz76SnVtzNSDnMyYKg+wSjcInsSOrVOmNeTk9Pf56b0YUYPhNwv8VQo9tLeL
         ilHClz9otA+BWz6FBrl6T9PMwJmH0PX+YJWDDnClqxCu8ObSMTxHa1Vh0q96zgjCGHS5
         7A7A==
X-Gm-Message-State: AOJu0Yzr9fUd5rIPmMOhyRCu7ptNqkF5VFSBdMJW1pE70B/GtPSN7L41
        OMXzYLysbMX8aIDcfmOPDN8=
X-Google-Smtp-Source: AGHT+IEw87tUMoU5iuJ22C/MT/AysykN2kqpsa9IYh9braGioKT5selEp4HQs8whvbLP/HhdfwSecw==
X-Received: by 2002:a17:902:f54a:b0:1b8:a2af:fe23 with SMTP id h10-20020a170902f54a00b001b8a2affe23mr228076plf.2.1692387792604;
        Fri, 18 Aug 2023 12:43:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:43:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v10 03/18] block/mq-deadline: Only use zone locking if necessary
Date:   Fri, 18 Aug 2023 12:34:06 -0700
Message-ID: <20230818193546.2014874-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
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
