Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028E7CDB485
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjJRR4W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjJRR4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:56:17 -0400
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3666B115;
        Wed, 18 Oct 2023 10:56:16 -0700 (PDT)
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-57f02eeabcaso4353675eaf.0;
        Wed, 18 Oct 2023 10:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651775; x=1698256575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aH5XPQQCiAVF4r+XWGxE/2XmtFY/9NCJod7T1V555TM=;
        b=lFNtni6kIw4tl5KWaj+2yGFuVZ8Z4NB8b3u3555bdIyT38gKhw2pmztO9mn5BgcAoZ
         44yMMIyp6yvW8/k4FHj6bHHgEHQJZ2g6p5TbZcfjTyikxgUZl9O9d4YE+hCT47ShS4H2
         D94vtK1514dgFcq+M+7aQVSuYff2n6xpgLPIepZ/XlnJIiQaxBfCc4w0E/Y7RVCzDhyV
         QKQ2QDaKSU5atgiVQ9rehMEs0yQMBWZWIFuTLj6qFyOooJHvybkCvJ+sImxoDpZ9dlti
         rbVejTfydPZuZO7duNleD3kAz60ialuDagaPvuFks+act9doFH/OrGXXL2mwJSq3XB0k
         VK4w==
X-Gm-Message-State: AOJu0Yw8rjSROPKPKRMn4311Kwq+ZTFmcxf3AKPy7MMPM1RVQEqJXGV4
        j2NETv9wQ1t4jABEOe9tQ7YA0hc4uhQ=
X-Google-Smtp-Source: AGHT+IH6CojMHFjCbI8d/JAhHQzcOiVFOjDlhE6WMOAHvIU5rkIWR/nuHJKnh/8G26WdsJ/tsq77tw==
X-Received: by 2002:a05:6359:c87:b0:143:383e:5b22 with SMTP id go7-20020a0563590c8700b00143383e5b22mr6342514rwb.28.1697651775378;
        Wed, 18 Oct 2023 10:56:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:56:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v13 02/18] block: Only use write locking if necessary
Date:   Wed, 18 Oct 2023 10:54:24 -0700
Message-ID: <20231018175602.2148415-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make blk_req_needs_zone_write_lock() return false if
q->limits.use_zone_write_lock is false.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
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
