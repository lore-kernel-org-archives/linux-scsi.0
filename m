Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3287C25B46
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjJWV44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjJWV4x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:56:53 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E65FD;
        Mon, 23 Oct 2023 14:56:51 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-27d1aee5aa1so2762332a91.0;
        Mon, 23 Oct 2023 14:56:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098210; x=1698703010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Z4rDL2TyIbEkp8fI7s0C+IPERBnhnxV2g5mRuTAQjE=;
        b=CRo1BeJNJUTr9H8HwGCM3WXnkNnFXu9/sdtj9YG33vYVDGMzV2moiDSQZ7VDbYS8nb
         nsa/JlQ6woOunljPbyoM9mlbBiJCzOCA36Mc7JJEuPJFyNSvtgL0Id9XbSGlOCzqfOAB
         /niIJAk64vXiDusi85R/Tmz79yCqtJ20JxF8WMIH2rxMsrIK5AjDQ1hQXMHOk/4C/hwj
         9Px1ORfbMGJfTvwAu1cROClwTMR9RBlWVQcyCR1NR0TWYuZc/KCYKOGpZx+QJI2na+n6
         J9pU0pEPNXcDHkAZhjBQjBSUgRZzX31I6FAg1nITaohSgkxOsSva6svyhfciDR7H1eKx
         KYqQ==
X-Gm-Message-State: AOJu0Yy96cqs62JdHmsuGhgpAFXBUFk0PH/+JZC3bW7QkcIizaJJZ0yo
        uq1DlKJee3J7tvnzxvAHUjo=
X-Google-Smtp-Source: AGHT+IHslL8JuKlMJzYNPkDlEGnm1ND7/6d+zbhFyMjawYmHx8z+9bDz1o68UDSfIFC/8983LctCIw==
X-Received: by 2002:a17:90a:f184:b0:27d:306d:71cb with SMTP id bv4-20020a17090af18400b0027d306d71cbmr18504509pjb.10.1698098210559;
        Mon, 23 Oct 2023 14:56:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:56:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v14 03/19] block: Preserve the order of requeued zoned writes
Date:   Mon, 23 Oct 2023 14:53:54 -0700
Message-ID: <20231023215638.3405959-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_mq_requeue_work() inserts requeued requests in front of other
requests. This is fine for all request types except for sequential zoned
writes. Hence this patch.

Note: moving this functionality into the mq-deadline I/O scheduler is
not an option because we want to be able to use zoned storage without
I/O scheduler.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
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
 
