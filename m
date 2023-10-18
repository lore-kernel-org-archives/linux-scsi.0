Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D10CDB483
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjJRR4Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjJRR4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:56:18 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64545118;
        Wed, 18 Oct 2023 10:56:17 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3af957bd7e9so4533720b6e.3;
        Wed, 18 Oct 2023 10:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651776; x=1698256576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YRTmtbNb958+HOpWsWyPv7WMdLRsuClrQv5UmN5LTCA=;
        b=NWY4dMFRH7p5yT4uagBKmpPy5RRZzpZxOzpJtmybpQVUVqdsYpwFzWjO7kMqc8hZNi
         XdfOfVOnDhscYtDeGPPfnChGqPiLJ0aLMXS+J2Qtc4lEgL+i3loDjGn4nU2HVwb696qw
         PiJ8eiJcoDxQngweFNcyIcpCY2hPF8W55jNXlsiqW+XZHlxUM3jYfg4l939nKy8w1OCF
         bTFlrOTcPGzB+BjGYl27Pyg7/OLMKQJeOC2CjCpZjyhq63noWFVaI5X3mSnwnUtuxmw7
         SRSQmh5CFZIt93VFFUjC5YB++aG1ocTcR1ppCGB1SXidDVJAKFDo6KWnCeTV7D2m3HLy
         aJxw==
X-Gm-Message-State: AOJu0YyJsokhM6qAIz6+bsoJA+7jaSbkhQLF4yIz4tNm/0Uy9jxv+2FW
        XiBOUIN7DHhg2JqPaEeLZOw=
X-Google-Smtp-Source: AGHT+IEzEftZmMwd3uy8c4jFlRWiCMNewtVViUO8x56NGgTVIs1Slkt0YnO3C+U1f2T7BU7P13kVMQ==
X-Received: by 2002:a05:6808:1710:b0:3ac:aae1:6d64 with SMTP id bc16-20020a056808171000b003acaae16d64mr7629540oib.2.1697651776618;
        Wed, 18 Oct 2023 10:56:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:56:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v13 03/18] block: Preserve the order of requeued zoned writes
Date:   Wed, 18 Oct 2023 10:54:25 -0700
Message-ID: <20231018175602.2148415-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
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
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 502dafa76716..ce6ddb249959 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1485,7 +1485,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
 			blk_mq_request_bypass_insert(rq, 0);
 		} else {
 			list_del_init(&rq->queuelist);
-			blk_mq_insert_request(rq, BLK_MQ_INSERT_AT_HEAD);
+			blk_mq_insert_request(rq,
+					      !blk_rq_is_seq_zoned_write(rq) ?
+					      BLK_MQ_INSERT_AT_HEAD : 0);
 		}
 	}
 
