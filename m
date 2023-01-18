Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E3CC38147
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 22:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjARWz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjARWzD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 17:55:03 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3F43C14;
        Wed, 18 Jan 2023 14:55:02 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id v23so613610plo.1;
        Wed, 18 Jan 2023 14:55:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/RZDuzsMWMDJVFdLKnQsMNBF2kHeHMM55tNHIuU+tqE=;
        b=Q0OH0n7VBUeKpqU4UEowfmrlPhFuksOLF4tLTUlNbjg2aTQgzfM5fPfOE2WurL4sca
         QGmOScgGWA0E954toT1ObZcRXl3j9UNsOrBLODyzNfm95TJ+OJwS1JFzYJdvklrv4i97
         ndBcGst2F2XH9nKdt+YiEslGn8a2gVgFwQXFyaqLWBs037ejwyh93c4priIUW508tHAR
         Csy3DzXPPeFYBhdWg6eSDNThJLzUQr96r1Y8yvxCkxNkP/+U1yLiFUis/P/QJNo63ELN
         8DbVQXYueBXwoQvFcdgIWqNzy0hfyH4ABDyT07Vnp5iV1DPb+GTeSthjVrPHK32FsW2P
         5alQ==
X-Gm-Message-State: AFqh2kpgOw2OnjgkfU/Symzs+ZxZ1podJOMjemXexplT1wggyPRidBhc
        o03D6u6IIYpB0cQ/JCMU+nk=
X-Google-Smtp-Source: AMrXdXs6ckHlyNDzitSnUlzG8Vr+RRJj9xORGPo4FS7GXOITkCjTy5q/LwdE/dGw47O6JSKn0XUVNA==
X-Received: by 2002:a17:902:7049:b0:194:c241:f604 with SMTP id h9-20020a170902704900b00194c241f604mr2303944plt.57.1674082502046;
        Wed, 18 Jan 2023 14:55:02 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186e34524e3sm23649466ple.136.2023.01.18.14.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:55:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v3 4/9] block: Add support for filesystem requests and small segments
Date:   Wed, 18 Jan 2023 14:54:42 -0800
Message-Id: <20230118225447.2809787-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
In-Reply-To: <20230118225447.2809787-1-bvanassche@acm.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
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
 block/blk-merge.c |  6 ++++--
 block/blk-mq.c    |  2 ++
 block/blk.h       | 11 +++++------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index b7c193d67185..bf727f67473d 100644
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
@@ -543,7 +544,8 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 			    __blk_segment_map_sg_merge(q, &bvec, &bvprv, sg))
 				goto next_bvec;
 
-			if (bvec.bv_offset + bvec.bv_len <= PAGE_SIZE)
+			if (bvec.bv_offset + bvec.bv_len <= PAGE_SIZE &&
+			    bvec.bv_len <= q->limits.max_segment_size)
 				nsegs += __blk_bvec_map_sg(bvec, sglist, sg);
 			else
 				nsegs += blk_bvec_map_sg(q, &bvec, sglist, sg);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9d463f7563bc..947cae2def76 100644
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
index 8f5e749ad73b..c3dd332ba618 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -316,14 +316,13 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
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
 	return lim->chunk_sectors || bio->bi_vcnt != 1 ||
+#ifdef CONFIG_BLK_SUB_PAGE_SEGMENTS
+		bio->bi_io_vec->bv_len > lim->max_segment_size ||
+#endif
 		bio->bi_io_vec->bv_len + bio->bi_io_vec->bv_offset > PAGE_SIZE;
 }
 
