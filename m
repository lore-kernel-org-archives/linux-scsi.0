Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851DFC25B4B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbjJWV46 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjJWV4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:56:54 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD2610E;
        Mon, 23 Oct 2023 14:56:52 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-27d3c886671so3329866a91.3;
        Mon, 23 Oct 2023 14:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098212; x=1698703012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qt1sHc5t/dL7mhPeX2SDNFeaW6muSPBn8kxtGzd5CRY=;
        b=TdqNuVLL6VrQ9KOSCYOR+vKXp/S7w5ng/RVNdvF+880d3xYLbUQfUa1OYVK6nbLyo9
         5pvsc0ryslU+RliKkEHRmB7aTIMlz0E9ZVWsWN0t/ld4TlCybxlGQBg5hvEOA01ZlC9B
         9UjmC9Zvjuo73dQNr2pYAmwpE3iNQ0H+CpOmN/53pd63GRhxByJKadonK7Ai66TPZ5Wq
         Pos34g3UTVolj8WFEPhEYcB10K9khdQnHJwRGoZLaXIDXIER+5PnDRvQN9wul1yAl6Gs
         mE5JetuJRP5khcKT3mRJSYMynCKAwXUgPjyET7C+M73Voay3ZCAb/7Y4kEXe4+JebkUA
         jNHA==
X-Gm-Message-State: AOJu0YxhpYshXB6LrvvE4VN9wXkNTMitvjjrlebme4T6z2iGxEcxE9wS
        3e8A2Yw7w8WjyDHpAbhC9jw=
X-Google-Smtp-Source: AGHT+IH1Rj0B2kHqJCvWhJpX9pUviXCQEmLz6WcrJB5/DFcQVYnfaZIHYJedQuxoiqusWC8dCSl+hw==
X-Received: by 2002:a17:90a:8d86:b0:27d:4d0:d79b with SMTP id d6-20020a17090a8d8600b0027d04d0d79bmr11321960pjo.23.1698098211962;
        Mon, 23 Oct 2023 14:56:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:56:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v14 04/19] block/mq-deadline: Only use zone locking if necessary
Date:   Mon, 23 Oct 2023 14:53:55 -0700
Message-ID: <20231023215638.3405959-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
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
