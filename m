Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495BFC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 20:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiKWU63 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239268AbiKWU6M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 15:58:12 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AACF02D;
        Wed, 23 Nov 2022 12:58:11 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id x13-20020a17090a46cd00b00218f611b6e9so1276941pjg.1;
        Wed, 23 Nov 2022 12:58:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pLbbN/1qbe+HxyJXe7G2OJd9lUGhOuHPJTNebNcpj5I=;
        b=0Ew7oUNov/C4LPwoR9i4zEM32v5rTM+Kb3ZOMqune2amhErCLPYrRunEBFQpD/qJA2
         91cEprlK1FvCzPRWihL65fLWvzuBWr/CpmtDOpDbPWf4WSfUpq/GST+7FhB4OT7LTUdS
         mhhv2ikBmzN4KBei14EjjyAQrDDGjhmwh1/9NhAKPjYuptYgo+elRGQcjd1HB3cvx8X7
         t+MDc5De5WIihrk4Ylf3u+EC+AeohBau3fv5HX4mra43l/zcuiXeWtTEX4wEjc2TwKoA
         900jtQ8E+cH/Zz/TT7D7qrqmcFznADIQgy0yPdTBmXzddPHqi7ZDUCknOVolMMDUF7+/
         nVog==
X-Gm-Message-State: ANoB5pkwd/y3b6W2jybUvhfCvtWjDSI+9daB1NZ1ogOg/jhnrgJEVERq
        +OejhYBWKNI9mEwSGMW5MVg=
X-Google-Smtp-Source: AA0mqf6Jl8uOa4Rz1+yh5/7zZycqw7TPxBJCyJ7DCDV8obZokSAlOtp2ltoe5u1/pUfxbhCMra5Pqw==
X-Received: by 2002:a17:902:ea91:b0:186:880c:1680 with SMTP id x17-20020a170902ea9100b00186880c1680mr12576845plb.164.1669237090934;
        Wed, 23 Nov 2022 12:58:10 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([2601:642:4c02:686d:4311:4764:eee7:ac6d])
        by smtp.gmail.com with ESMTPSA id i89-20020a17090a3de200b0020b2082e0acsm1858809pjc.0.2022.11.23.12.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:58:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH v2 4/8] block: Add support for filesystem requests and small segments
Date:   Wed, 23 Nov 2022 12:57:36 -0800
Message-Id: <20221123205740.463185-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221123205740.463185-1-bvanassche@acm.org>
References: <20221123205740.463185-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support in the bio splitting code and also in the bio submission code
for bios with segments smaller than the page size.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-merge.c | 6 ++++--
 block/blk-mq.c    | 2 ++
 block/blk.h       | 3 ++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 35a8f75cc45d..7badfbed09fc 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -294,7 +294,8 @@ static struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 		if (nsegs < lim->max_segments &&
 		    bytes + bv.bv_len <= max_bytes &&
 		    bv.bv_offset + bv.bv_len <= PAGE_SIZE) {
-			nsegs++;
+			/* single-page bvec optimization */
+			nsegs += blk_segments(lim, bv.bv_len);
 			bytes += bv.bv_len;
 		} else {
 			if (bvec_split_segs(lim, &bv, &nsegs, &bytes,
@@ -531,7 +532,8 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 			    __blk_segment_map_sg_merge(q, &bvec, &bvprv, sg))
 				goto next_bvec;
 
-			if (bvec.bv_offset + bvec.bv_len <= PAGE_SIZE)
+			if (bvec.bv_offset + bvec.bv_len <= PAGE_SIZE &&
+			    bvec.bv_len <= q->limits.max_segment_size)
 				nsegs += __blk_bvec_map_sg(bvec, sglist, sg);
 			else
 				nsegs += blk_bvec_map_sg(q, &bvec, sglist, sg);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f72164429446..1560e4f76f2d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2953,6 +2953,8 @@ void blk_mq_submit_bio(struct bio *bio)
 	bio = blk_queue_bounce(bio, q);
 	if (bio_may_exceed_limits(bio, &q->limits))
 		bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
+	else if (bio->bi_vcnt == 1)
+		nr_segs = blk_segments(&q->limits, bio->bi_io_vec[0].bv_len);
 
 	if (!bio_integrity_prep(bio))
 		return;
diff --git a/block/blk.h b/block/blk.h
index fb486eff3eef..c45f86b74b1d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -320,7 +320,7 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
 	}
 
 	/*
-	 * All drivers must accept single-segments bios that are <= PAGE_SIZE.
+	 * Check whether bio splitting should be performed.
 	 * This is a quick and dirty check that relies on the fact that
 	 * bi_io_vec[0] is always valid if a bio has data.  The check might
 	 * lead to occasional false negatives when bios are cloned, but compared
@@ -328,6 +328,7 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
 	 * doesn't matter anyway.
 	 */
 	return lim->chunk_sectors || bio->bi_vcnt != 1 ||
+		bio->bi_io_vec->bv_len > lim->max_segment_size ||
 		bio->bi_io_vec->bv_len + bio->bi_io_vec->bv_offset > PAGE_SIZE;
 }
 
