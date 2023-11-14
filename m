Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3556EC4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbjKNVSY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbjKNVST (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:18:19 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE18C3;
        Tue, 14 Nov 2023 13:18:16 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1cc3bb4c307so47997685ad.0;
        Tue, 14 Nov 2023 13:18:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996696; x=1700601496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXxdMX6CRen+F1nt9soo8zhbGYJ2EAO/La69VGLccjY=;
        b=bKyqjHZKpre4rgvpuiP1XrhZSxt07mjzkfqAolgozYxmrFNNL9536bQsdOpBYfpaNJ
         POmXQQEiPb9Xv/w/X/+gCwS0JNkr5HwYWj+dqTJz+jwJROpFjc+4DMCI6O6bjcBCrU08
         4wR0cHL2Vwxnpo6GEbvHzCquHIN/cfwQ2z5ITNoIlvt0mQLzsrTt5MN7BHmASbUVjQuY
         V4Kh4nBHWpgoQYHTzlaHtbtxruAy5/yzxFOgOrxOL22LMoUfTZt1R9naSrwUbXUOieAx
         7sJq/GenLoZT2y8YMJbd3eoiSBP3qAr+59JoZ4Qag5jiM9pPQ4LVMd5qc/qUXTKceaYP
         BPuw==
X-Gm-Message-State: AOJu0Yz9I+ysPu0jd2IOI2ZJfJP/8BBXxfqTcRo/+gB4jR98i7hXv+3l
        Q6jM84Np7gijFBslSn+zsdmrsRy+PPs=
X-Google-Smtp-Source: AGHT+IEsWJ3GrKRckqCklmb9GC86ZArKHc4WpMAY3SEJcmmubp6LGwVbslDiFCFoDQ/eE9dM6s+BmQ==
X-Received: by 2002:a17:902:ec92:b0:1cc:bfb4:2dd1 with SMTP id x18-20020a170902ec9200b001ccbfb42dd1mr3736233plg.53.1699996695726;
        Tue, 14 Nov 2023 13:18:15 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:18:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v15 03/19] block: Preserve the order of requeued zoned writes
Date:   Tue, 14 Nov 2023 13:16:11 -0800
Message-ID: <20231114211804.1449162-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_mq_requeue_work() inserts requeued requests in front of other
requests. This is fine for all request types except for sequential zoned
writes. Hence this patch.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e2d11183f62e..e678edca3fa8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1484,8 +1484,12 @@ static void blk_mq_requeue_work(struct work_struct *work)
 			list_del_init(&rq->queuelist);
 			blk_mq_request_bypass_insert(rq, 0);
 		} else {
+			blk_insert_t insert_flags = BLK_MQ_INSERT_AT_HEAD;
+
 			list_del_init(&rq->queuelist);
-			blk_mq_insert_request(rq, BLK_MQ_INSERT_AT_HEAD);
+			if (blk_rq_is_seq_zoned_write(rq))
+				insert_flags = 0;
+			blk_mq_insert_request(rq, insert_flags);
 		}
 	}
 
