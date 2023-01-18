Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C847C38159
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 22:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjARWz1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjARWzB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 17:55:01 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1153C14;
        Wed, 18 Jan 2023 14:55:01 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id y1so607028plb.2;
        Wed, 18 Jan 2023 14:55:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNPNN968lQVNmCKl7FcUYv4jbSVa/pUDUUKlr0wb41Y=;
        b=Spc+6dgJTs4vA8JhbVl5SantWZ2q/EGEWNr6kUH/rtZfaDCKRKBZnL4cLmGx3D1klI
         F7jY6NbEfb7iuzX8v8D1+GWI2086fo84ZNHfFGqDtW6ofwwOj1GN5gz3uGQWXrO4JHYb
         8TvXAed8tBEQmSAqWW13Fb7uNU5WUW2YJb9xPFgvzCy1rZZ2+B1J9DclY4E8yphrTiFO
         ZLdmqO/obbYQI93FvSjK7ez9azQPhdSdz9cDlnb+3HiNQWx2rDAnqX20mQvEFOALfrSe
         trzPNFaWEAfQGYNf0/O95wGHFv3rLGSjo3ONBtLVsIYrm2hKlbnGMhmi5ENgYBJZ16Nv
         camg==
X-Gm-Message-State: AFqh2kqCEjh5tqQMaz7goDln8whEDLWWQRN5YieRqpgRzv0vB93OO38F
        adUWufHz1L1NrDIjUWU+fMw=
X-Google-Smtp-Source: AMrXdXtIqTdFH/pDhwBM+d3zV5uB/gg6omJRCsVt8HUyeMsSL0gZ4jjhIJOfg+gk5wh5QLzvHZJSVw==
X-Received: by 2002:a17:902:9a86:b0:194:4196:7dae with SMTP id w6-20020a1709029a8600b0019441967daemr8026329plp.3.1674082500490;
        Wed, 18 Jan 2023 14:55:00 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186e34524e3sm23649466ple.136.2023.01.18.14.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:54:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v3 3/9] block: Support submitting passthrough requests with small segments
Date:   Wed, 18 Jan 2023 14:54:41 -0800
Message-Id: <20230118225447.2809787-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
In-Reply-To: <20230118225447.2809787-1-bvanassche@acm.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the segment size is smaller than the page size there may be multiple
segments per bvec even if a bvec only contains a single page. Hence this
patch.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-map.c | 16 +++++++++++++++-
 block/blk.h     | 11 +++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 9ee4be4ba2f1..4270db88e2c2 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -523,6 +523,20 @@ static struct bio *bio_copy_kern(struct request_queue *q, void *data,
 	return ERR_PTR(-ENOMEM);
 }
 
+#ifdef CONFIG_BLK_SUB_PAGE_SEGMENTS
+/* Number of DMA segments required to transfer @bytes data. */
+unsigned int blk_segments(const struct queue_limits *limits, unsigned int bytes)
+{
+	const unsigned int mss = limits->max_segment_size;
+
+	if (bytes <= mss)
+		return 1;
+	if (is_power_of_2(mss))
+		return round_up(bytes, mss) >> ilog2(mss);
+	return (bytes + mss - 1) / mss;
+}
+#endif
+
 /*
  * Append a bio to a passthrough request.  Only works if the bio can be merged
  * into the request based on the driver constraints.
@@ -534,7 +548,7 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 	unsigned int nr_segs = 0;
 
 	bio_for_each_bvec(bv, bio, iter)
-		nr_segs++;
+		nr_segs += blk_segments(&rq->q->limits, bv.bv_len);
 
 	if (!rq->bio) {
 		blk_rq_bio_prep(rq, bio, nr_segs);
diff --git a/block/blk.h b/block/blk.h
index 4c3b3325219a..8f5e749ad73b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -76,6 +76,17 @@ struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
 		gfp_t gfp_mask);
 void bvec_free(mempool_t *pool, struct bio_vec *bv, unsigned short nr_vecs);
 
+#ifdef CONFIG_BLK_SUB_PAGE_SEGMENTS
+unsigned int blk_segments(const struct queue_limits *limits,
+			  unsigned int bytes);
+#else
+static inline unsigned int blk_segments(const struct queue_limits *limits,
+					unsigned int bytes)
+{
+	return 1;
+}
+#endif
+
 static inline bool biovec_phys_mergeable(struct request_queue *q,
 		struct bio_vec *vec1, struct bio_vec *vec2)
 {
