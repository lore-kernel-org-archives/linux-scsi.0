Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49EAC4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 11:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F9B223D57
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 11:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389268AbgLJLiF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 06:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732645AbgLJLhx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 06:37:53 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D54FC0613CF;
        Thu, 10 Dec 2020 03:37:13 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id v29so3942250pgk.12;
        Thu, 10 Dec 2020 03:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HDS4fIMqhEAFVnsVd2AJL7TzeDDoCzgo5yTz8yHF/Wg=;
        b=LX+XHI3mYnJVgP16vrem9UWPkbvp5yjyBHa/eL9tjHgUE7zYF5YPfda3S4gjWKQzQo
         5k0NSyWT37YbVPDhwlBrEqdzcgbDQ7w/kqwxHu5n/naIrpPCqpaaFAWZUKDc5/vlovXU
         nnIrig2u2JzVVFuu4stetMO034Rzr9lIons3MRDeEANm3xqU/rCJf20LKexW+N1TOe7Z
         DBsKMUGYMnXWZByC9juz1DBjEPpunDHDfbcFifZPPeEuPx47iIPVpnXQqmzVq/LVihb6
         IuTNvDfecmb+sy40saWyPt/9fuFAVbmAdPtT2Qu42oC32+mNL3OmZXyx/7GmdyXJSdP/
         v6rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HDS4fIMqhEAFVnsVd2AJL7TzeDDoCzgo5yTz8yHF/Wg=;
        b=KyUrk/Ucc6YP4y5xinWYMTh9yOVGLtgK3Lhn2aY6RcVl5EvW5zdExFOb/n/zVxpOaj
         ZToy91+yDeM5+m55ORqmQzC29Yqe3ed1EyADLfGvHQk7gdNICsTH62kGcQMO8yicrIyT
         wDX5L7X1KxByTCptf9qziyC4oboR5t+HzNEDRE2TQFB6en7kTfK/fcnjF8glz6Fxc9Ak
         5t4iO2xozLTsOyNVQVJKZ9I2AttPkw6xOp2mrOrOZIWpGZpr05EM+/noc0TJVENk8u6v
         w87ei5ZQhjjZgxtHkGgcDns56MBMvoOHrBS7di2iBg5y8ge4ns46aWd3uQzd362GBVKs
         JluQ==
X-Gm-Message-State: AOAM531wu+CG5jhatcPj1gPH61y8Cwlbl7NZmOpeQhs0Y4iHbqTPSS2q
        6XSG7BdKQ7Nn4kafa5GDGFqEFn/IrKI=
X-Google-Smtp-Source: ABdhPJyPie2lURdhGHeS3lcGqfeXdbqpoShKMIIcQLf+sesGMnZqlpq9VfqDKuwsQ1exQ+LzGCUCPw==
X-Received: by 2002:a63:4509:: with SMTP id s9mr6117139pga.316.1607600232201;
        Thu, 10 Dec 2020 03:37:12 -0800 (PST)
Received: from archlinux.. ([161.81.68.216])
        by smtp.gmail.com with ESMTPSA id p127sm6038623pfp.93.2020.12.10.03.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 03:37:11 -0800 (PST)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-block@vger.kernel.org, sergei.shtylyov@gmail.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Tom Yan <tom.ty89@gmail.com>
Subject: [RFC v2] block: avoid the unnecessary blk_bio_discard_split()
Date:   Thu, 10 Dec 2020 19:37:04 +0800
Message-Id: <20201210113704.1395-1-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <55e0b8be-a16b-9895-fde5-b325773ae0e7@gmail.com>
References: <55e0b8be-a16b-9895-fde5-b325773ae0e7@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It doesn't seem necessary to have the redundant layer of splitting.
The request size will even be more consistent / aligned to the cap.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 block/blk-lib.c   | 7 +++++--
 block/blk-merge.c | 2 +-
 block/blk.h       | 8 ++++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e90614fd8d6a..3b75c1c4ba17 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -85,12 +85,15 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		 *   is split in device drive, the split ones are very probably
 		 *   to be aligned to discard_granularity of the device's queue.
 		 */
-		if (granularity_aligned_lba == sector_mapped)
+		if (granularity_aligned_lba == sector_mapped) {
 			req_sects = min_t(sector_t, nr_sects,
 					  bio_aligned_discard_max_sectors(q));
-		else
+			if (!req_sects)
+				return -EOPNOTSUPP;
+		} else {
 			req_sects = min_t(sector_t, nr_sects,
 					  granularity_aligned_lba - sector_mapped);
+		}
 
 		WARN_ON_ONCE((req_sects << 9) > UINT_MAX);
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 97b7c2821565..f4e030fe6399 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -59,6 +59,7 @@ static inline bool req_gap_front_merge(struct request *req, struct bio *bio)
 	return bio_will_gap(req->q, NULL, bio, req->bio);
 }
 
+/* deprecated */
 static struct bio *blk_bio_discard_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs,
@@ -303,7 +304,6 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 	switch (bio_op(*bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
-		split = blk_bio_discard_split(q, *bio, &q->bio_split, nr_segs);
 		break;
 	case REQ_OP_WRITE_ZEROES:
 		split = blk_bio_write_zeroes_split(q, *bio, &q->bio_split,
diff --git a/block/blk.h b/block/blk.h
index dfab98465db9..e7e31a8c4930 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -281,8 +281,12 @@ static inline unsigned int bio_allowed_max_sectors(struct request_queue *q)
 static inline unsigned int bio_aligned_discard_max_sectors(
 					struct request_queue *q)
 {
-	return round_down(UINT_MAX, q->limits.discard_granularity) >>
-			SECTOR_SHIFT;
+	unsigned int discard_max_sectors, granularity;
+	discard_max_sectors = min(q->limits.max_discard_sectors,
+				  bio_allowed_max_sectors(q));
+	/* Zero-sector (unknown) and one-sector granularities are the same.  */
+	granularity = max(q->limits.discard_granularity >> SECTOR_SHIFT, 1U)
+	return round_down(max, granularity);
 }
 
 /*
-- 
2.29.2

