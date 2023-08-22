Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD7BEE4993
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjHVTSu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjHVTSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:18:47 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D251BE;
        Tue, 22 Aug 2023 12:18:46 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1bc0d39b52cso32077185ad.2;
        Tue, 22 Aug 2023 12:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692731926; x=1693336726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FvsjixjHprGJoE6zHlkCW2HQWi6Q2BrxOyZzjpL+qb0=;
        b=O3ODTaQEWKz/gkevgSKtLLENR4kPyET+LZ3h5byRKhDdnTfPeBoSF6s/IA/EJmyWJQ
         AuVY/zGvGrXfgbo7rmmgE43WtwFWh8hgpuUg+5I2UD9M/YHao1u+e9r0QPWz/va0iCUu
         jHJ3pjApEAzLbxpZmuF2CMtoINzbWZhZrxo7sGwYHPX9Q9G18sJ6qO+vVbF0Qxp50E0J
         uscncfPHIM61QfEMeqgfoQNSh+O8XZpVxlYXJgu6amZ9gM7OoiIW2akbBo42wuWxRO8N
         q08i4x39dRZWqwYoPtxor4FdlATWegoxxqzRkcrXYjvBEBVyXetmbyle4y1cjcBVREVR
         o2tQ==
X-Gm-Message-State: AOJu0Yxd8TZ2cUvCw+gClP4FqE4x0C1qR+B3+u1bWt7WxLB4TTzJCg5J
        aU6lRfnbFWA6wE8uefMwwxA=
X-Google-Smtp-Source: AGHT+IF6kBVUhdKgw8R4Fbt6wyB7bJhtfIYMpch7uULpfhly52qJlpNXtJ+F+N2i86XJXEjo1X2c2g==
X-Received: by 2002:a17:903:1c4:b0:1b8:4ec2:5200 with SMTP id e4-20020a17090301c400b001b84ec25200mr9121886plh.2.1692731925898;
        Tue, 22 Aug 2023 12:18:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:18:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v11 02/16] block: Only use write locking if necessary
Date:   Tue, 22 Aug 2023 12:16:57 -0700
Message-ID: <20230822191822.337080-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230822191822.337080-1-bvanassche@acm.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make blk_req_needs_zone_write_lock() return false if
q->limits.use_zone_write_lock is false.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 112620985bff..d8a80cce832f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -53,11 +53,16 @@ const char *blk_zone_cond_str(enum blk_zone_cond zone_cond)
 EXPORT_SYMBOL_GPL(blk_zone_cond_str);
 
 /*
- * Return true if a request is a write requests that needs zone write locking.
+ * Return true if a request is a write request that needs zone write locking.
  */
 bool blk_req_needs_zone_write_lock(struct request *rq)
 {
-	if (!rq->q->disk->seq_zones_wlock)
+	struct request_queue *q = rq->q;
+
+	if (!q->limits.use_zone_write_lock)
+		return false;
+
+	if (!q->disk->seq_zones_wlock)
 		return false;
 
 	return blk_rq_is_seq_zoned_write(rq);
