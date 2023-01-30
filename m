Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D93C636D6
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 21:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjA3V1O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjA3V1K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 16:27:10 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E9E485A7;
        Mon, 30 Jan 2023 13:27:10 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so16957511pjq.0;
        Mon, 30 Jan 2023 13:27:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=idfcEYfQnXda9MtyBSs+vCtAqmQuKIMEL+tvI67zHT4=;
        b=CYUGwHJjHOdyqdJpHoTPbLpBV5xn+h+U5bJoS/bMdcZPdGoItDYlsskq3aInsKKZSJ
         Q4xhL559Sizq8cdNNFXuQ//eusGZz7sljr/LVtAxfqcqcmfwJYcUfoQWrbdVjMZb5+Fd
         WX6cvpY5kisDiqtC9k81beX9OA8UnnwENohBLTmeg0gqaSYD1e5XGxm+iF0G/JfYnWGZ
         dZpTBASl7uIqqEJxYgEUEoqT4Sw7ua+MHARXAVaxj83fypg4RSR+yUJioseSBdh5hITu
         N6QBJqvaArz+V8U4BkYsVoaofMFRVVZsbnodcjPKw/VKxct2uEQMaliIQfQNJ36MZAne
         vXpg==
X-Gm-Message-State: AO0yUKWN2Ld+PeytkzfBGtOXfp3pQ+luPCW05Q7JIBYQkqHSlYOqtEnz
        kS7jefsjGl/B1fU6v/xKsyQ=
X-Google-Smtp-Source: AK7set9yBb5kiXQ8NbiLhcIuk9sp63h3wbmDzuyqRDEXkfNmNx3bMFqDe2LHwBDOg4/bS7nPPeQUcQ==
X-Received: by 2002:a17:903:32c1:b0:196:82d2:93a with SMTP id i1-20020a17090332c100b0019682d2093amr6168491plr.11.1675114029446;
        Mon, 30 Jan 2023 13:27:09 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b00196087a3d7csm7425613plf.77.2023.01.30.13.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:27:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v4 3/7] block: Support submitting passthrough requests with small segments
Date:   Mon, 30 Jan 2023 13:26:52 -0800
Message-Id: <20230130212656.876311-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230130212656.876311-1-bvanassche@acm.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
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
 block/blk-map.c |  2 +-
 block/blk.h     | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 9ee4be4ba2f1..eb059d3a1be2 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -534,7 +534,7 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 	unsigned int nr_segs = 0;
 
 	bio_for_each_bvec(bv, bio, iter)
-		nr_segs++;
+		nr_segs += blk_segments(&rq->q->limits, bv.bv_len);
 
 	if (!rq->bio) {
 		blk_rq_bio_prep(rq, bio, nr_segs);
diff --git a/block/blk.h b/block/blk.h
index 9a56d7002efc..b39938255d13 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -86,6 +86,24 @@ struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
 		gfp_t gfp_mask);
 void bvec_free(mempool_t *pool, struct bio_vec *bv, unsigned short nr_vecs);
 
+/* Number of DMA segments required to transfer @bytes data. */
+static inline unsigned int blk_segments(const struct queue_limits *limits,
+					unsigned int bytes)
+{
+	if (!blk_queue_sub_page_limits(limits))
+		return 1;
+
+	{
+		const unsigned int mss = limits->max_segment_size;
+
+		if (bytes <= mss)
+			return 1;
+		if (is_power_of_2(mss))
+			return round_up(bytes, mss) >> ilog2(mss);
+		return (bytes + mss - 1) / mss;
+	}
+}
+
 static inline bool biovec_phys_mergeable(struct request_queue *q,
 		struct bio_vec *vec1, struct bio_vec *vec2)
 {
