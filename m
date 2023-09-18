Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3F2CD13DA
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjIRQ5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjIRQ5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:57:36 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EF190;
        Mon, 18 Sep 2023 09:57:31 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5789de5c677so431400a12.3;
        Mon, 18 Sep 2023 09:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056251; x=1695661051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qt1sHc5t/dL7mhPeX2SDNFeaW6muSPBn8kxtGzd5CRY=;
        b=qCTOXEpJboM2Q7a9VRFvAkJqBpQqvORHf0rSUyM4i7N1ymeY7/UL9JJ2mo8yPkc69i
         LaWDCDRANuM4B3ebQLx6JHLpWEXxYqO4FdYyq8xvcnYifVkWgU+GxtlwJMUE9u5xHF/o
         DBfBdQZ26TwDiB0QUwbBeAKPkkdfTKoNkQ6jR+NQ3dZogHpOEe/perhKXXPdKUW40L7C
         RQL1dRrc19Tff/wtr2WUaxt5EKXT3DcEL3ADXQEVoj6AOhpAFOoDZAr4WSa3natlz9gv
         mn9SSIyrNP8c4+CDygYr3eWJh3T/sxEfRHCg0gMeflzZtm02DBIBCJB2iKG5EL1FbW/C
         PEig==
X-Gm-Message-State: AOJu0YwZqxbFwC+dgh2H27EBVwYxDemjdFSXhS0oI22CPL/0vTYFYcWp
        4ccvFyfV/liFomfou2Jd9LgQTxI1Q4A=
X-Google-Smtp-Source: AGHT+IGAIoOGrEdRIjJzXAMK0/fdYOiOpoL4kHo9IM/DYlhq1Cuf5GjrUfzN+i/vniX7UwVzHVUIoA==
X-Received: by 2002:a05:6a20:3cac:b0:15a:478f:9f2e with SMTP id b44-20020a056a203cac00b0015a478f9f2emr10321641pzj.1.1695056250539;
        Mon, 18 Sep 2023 09:57:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:57:29 -0700 (PDT)
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
Subject: [PATCH v12 03/16] block/mq-deadline: Only use zone locking if necessary
Date:   Mon, 18 Sep 2023 09:55:42 -0700
Message-ID: <20230918165713.1598705-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918165713.1598705-1-bvanassche@acm.org>
References: <20230918165713.1598705-1-bvanassche@acm.org>
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
