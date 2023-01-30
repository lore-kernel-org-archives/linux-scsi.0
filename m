Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8387FC636D7
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 21:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjA3V1P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbjA3V1N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 16:27:13 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A63730E9D;
        Mon, 30 Jan 2023 13:27:11 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id k13so13104651plg.0;
        Mon, 30 Jan 2023 13:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gT/65YVqsvhlObcz45anS+pTHdEkcxX0FR157j8sKeY=;
        b=uHgwowCYxClqPFHpAd6aIrYcXcZZ99C7yI2uIvV/RvuWdD8qTLR7UJDDXWfXXNtGxq
         eL1K7cH6/En646uo1PDKw4EEOmDhn59t+9HAHptby/qWgn2u8frfCnl3kSbHxq/5dvMe
         j700VeNcHBpFNMlpYncsd4H/+zQRjyKZh57MULW0bD5mdg9xWTWH+/8fhEfhhd/WsD4K
         jJAHeTR+IZq8JwwL55owQwQbHd1s6YzxBEtpVYuvg3+KpWrHAYt6DHwy7fqIO4piYY36
         YIrf06g29FeC8NKaw+A/UpbLB6UsL9hfIgzhAH+7BX5WfrVmxOAw1EOS7qn1EHmXW2Kc
         vIgQ==
X-Gm-Message-State: AO0yUKVeqUIOC7OpIzAkky/eRXAXKhiupb/uFP8Cf8Pqfo03Brj1BxiX
        zay1v6I5GUwu+8ACbMSJ+wA=
X-Google-Smtp-Source: AK7set/9cHggGNQt5QzonjVmO87KdHLRhB+xC0XkUH9ljN8l+RHD5WMOQMeuY9ZRZtnfBjQJbjHeGA==
X-Received: by 2002:a17:902:f0d4:b0:196:56ae:ed19 with SMTP id v20-20020a170902f0d400b0019656aeed19mr11311882pla.2.1675114031060;
        Mon, 30 Jan 2023 13:27:11 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b00196087a3d7csm7425613plf.77.2023.01.30.13.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:27:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v4 4/7] block: Add support for filesystem requests and small segments
Date:   Mon, 30 Jan 2023 13:26:53 -0800
Message-Id: <20230130212656.876311-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230130212656.876311-1-bvanassche@acm.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
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
 block/blk-merge.c |  7 +++++--
 block/blk-mq.c    |  2 ++
 block/blk.h       | 11 +++++------
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index b7c193d67185..bf21475e8a13 100644
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
@@ -543,7 +544,9 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 			    __blk_segment_map_sg_merge(q, &bvec, &bvprv, sg))
 				goto next_bvec;
 
-			if (bvec.bv_offset + bvec.bv_len <= PAGE_SIZE)
+			if (bvec.bv_offset + bvec.bv_len <= PAGE_SIZE &&
+			    (!blk_queue_sub_page_limits(&q->limits) ||
+			     bvec.bv_len <= q->limits.max_segment_size))
 				nsegs += __blk_bvec_map_sg(bvec, sglist, sg);
 			else
 				nsegs += blk_bvec_map_sg(q, &bvec, sglist, sg);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9c8dc70020bc..a62b79e97a30 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2959,6 +2959,8 @@ void blk_mq_submit_bio(struct bio *bio)
 		bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
 		if (!bio)
 			return;
+	} else if (bio->bi_vcnt == 1) {
+		nr_segs = blk_segments(&q->limits, bio->bi_io_vec[0].bv_len);
 	}
 
 	if (!bio_integrity_prep(bio))
diff --git a/block/blk.h b/block/blk.h
index b39938255d13..5c248b80a218 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -333,13 +333,12 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
 	}
 
 	/*
-	 * All drivers must accept single-segments bios that are <= PAGE_SIZE.
-	 * This is a quick and dirty check that relies on the fact that
-	 * bi_io_vec[0] is always valid if a bio has data.  The check might
-	 * lead to occasional false negatives when bios are cloned, but compared
-	 * to the performance impact of cloned bios themselves the loop below
-	 * doesn't matter anyway.
+	 * Check whether bio splitting should be performed. This check may
+	 * trigger the bio splitting code even if splitting is not necessary.
 	 */
+	if (blk_queue_sub_page_limits(lim) &&
+	    bio->bi_io_vec && bio->bi_io_vec->bv_len > lim->max_segment_size)
+		return true;
 	return lim->chunk_sectors || bio->bi_vcnt != 1 ||
 		bio->bi_io_vec->bv_len + bio->bi_io_vec->bv_offset > PAGE_SIZE;
 }
