Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91E4C3A59F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 20:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiKWU61 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiKWU6K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 15:58:10 -0500
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BF9F02D;
        Wed, 23 Nov 2022 12:58:09 -0800 (PST)
Received: by mail-pg1-f182.google.com with SMTP id q71so17748137pgq.8;
        Wed, 23 Nov 2022 12:58:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/TsybekEubKHyQUK6eV+iAAL5xeGQVyeA/isuI9nLY=;
        b=ZRZKWSimsv5E2sYWVuUZN4D72PHIe/e/qHesajpFfxBy7kQCkrMKVswlk9n1g8Tl2k
         fPjS1L+BwUf6hnsfwfiXWmmk6XVz/KNx+yWdtv301m4Xxuy2yX378ZW2S/ACTHgN4o3f
         BEpGUNCOz7iIhc6gdiYrmR2jqU5i77U22+E3T1jU+BW4EE4eCMrDJByYoJcIkTUp9Vja
         q7DxsdOm9ndLA6CvBVWOxLcYMU75mPVmLNRh+374XuhJ8aKlvxQeC8giNpCc29lWUi5n
         i8dPbo4tizcTLkSXizWqG6C7684OgTIC53uYz09JlVZylF1hzmMrWSass/Wq+DlL45Bc
         rDLg==
X-Gm-Message-State: ANoB5png55PXzce7bauq2c79kS2pnOld+aFl5RoKR1QWnT+/QpEXJJI3
        tLg++03rdxjQXn6ZQkS9gYE=
X-Google-Smtp-Source: AA0mqf7APCgI6nlqyOOHzYLhP4ztkxEwCdOPlgdjAeFusBIRXA2M/Bh3idKagRwBuc0kgMu5j1+AVg==
X-Received: by 2002:a63:dd43:0:b0:45c:5a74:9a92 with SMTP id g3-20020a63dd43000000b0045c5a749a92mr9452347pgj.473.1669237088627;
        Wed, 23 Nov 2022 12:58:08 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([2601:642:4c02:686d:4311:4764:eee7:ac6d])
        by smtp.gmail.com with ESMTPSA id i89-20020a17090a3de200b0020b2082e0acsm1858809pjc.0.2022.11.23.12.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:58:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH v2 3/8] block: Support submitting passthrough requests with small segments
Date:   Wed, 23 Nov 2022 12:57:35 -0800
Message-Id: <20221123205740.463185-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221123205740.463185-1-bvanassche@acm.org>
References: <20221123205740.463185-1-bvanassche@acm.org>
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
index 19940c978c73..d2d6ee098514 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -524,6 +524,20 @@ static struct bio *bio_copy_kern(struct request_queue *q, void *data,
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
@@ -535,7 +549,7 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 	unsigned int nr_segs = 0;
 
 	bio_for_each_bvec(bv, bio, iter)
-		nr_segs++;
+		nr_segs += blk_segments(&rq->q->limits, bv.bv_len);
 
 	if (!rq->bio) {
 		blk_rq_bio_prep(rq, bio, nr_segs);
diff --git a/block/blk.h b/block/blk.h
index 5929559acd71..fb486eff3eef 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -80,6 +80,17 @@ struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
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
