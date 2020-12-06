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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE39C4361B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 924FB22D0B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgLFGQd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 01:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgLFGQb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 01:16:31 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A16C0613D0;
        Sat,  5 Dec 2020 22:15:45 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id f17so6262673pge.6;
        Sat, 05 Dec 2020 22:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3iY7xWUkkJgoMW+4AR8JwjKubekss48iTys3v/kd3eg=;
        b=uAPLklUdTtDmd1EI4fXfEPcS4Sm25nW916e0AcBZ0vyuENbF5MBosqUQFQwOL/QYAe
         VQlUgOuxa3IH6Bxk/uXpeNzO/eWXbKZehzstNV+YefL//GfIsb3QFoxJAgQxE1q71YZ5
         21KJuThudJMkC3c/E/rAPwgitxR/u+yDLeAHLLP0nETRmlapjsuzgRQhMn2kGh5zyGSk
         KW0GaCvclaOTqJwBGJ/FNPHBa5kL4ghjN/o9vUJgiWPwyWc1oux9tOE9Qf0ZL0lzs1ct
         wCdC6uGqfRhUsa8OHJyf8E2v4GBBTCjYFCL8jDeN4WHHWBnRA/n4OyS++z0g1nSYsFKX
         IbvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3iY7xWUkkJgoMW+4AR8JwjKubekss48iTys3v/kd3eg=;
        b=Qvty+p72wwi37IfxHQuPfsCWjOE4thX5wbET5Lpe4bKSJCDHlODU/WWxdx5MgveVhR
         hI3TASo7GiILNT3v5tnSESY0JErM7bYnH9GSJ2X3AVoSDpKMZpQp8kKWcUibaowRozwa
         kQEAqidd2g66yJtYDqf+ZChHfKtYzoWetIlqMAJd32aAR+jcG9Fgt/b80R+XuR6nDicD
         5X7+N36mroiJ1yrud4gDn0gtB3RIa8jWC9e57tFI3wMSNxXynPVfhwQoo7+mCMC2NBwE
         +SJzbSJBLQHo97S2NyX9Af7QcpBONHVak03EPt/3xqPW0/MhYZDg8LMG7HjemykYaJ0r
         C8Yw==
X-Gm-Message-State: AOAM530xWefA/dPkt9ZHKN1Tx6PP70/TI1m5KXV0eHfx0A/YdWHfaoCv
        xDslKxRhvc1qJ9Fd35BGEO+MhhfzKnE=
X-Google-Smtp-Source: ABdhPJyLxwBKfnwMw/t8/hJx8muCnThR0g5TgM7L8uYFFgMxcUTEfa5p0Ruq+1kA2OB5BPhAe30x+Q==
X-Received: by 2002:a62:1a47:0:b029:19b:c093:2766 with SMTP id a68-20020a621a470000b029019bc0932766mr11252370pfa.10.1607235344811;
        Sat, 05 Dec 2020 22:15:44 -0800 (PST)
Received: from archlinux.. ([161.81.68.216])
        by smtp.gmail.com with ESMTPSA id c205sm10110250pfc.160.2020.12.05.22.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 22:15:44 -0800 (PST)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Tom Yan <tom.ty89@gmail.com>
Subject: [RFC] block: avoid the unnecessary blk_bio_discard_split()
Date:   Sun,  6 Dec 2020 14:15:37 +0800
Message-Id: <20201206061537.3870-1-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It doesn't seem necessary to have the redundant layer of splitting.
The request size will even be more consistent / aligned to the cap.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 block/blk-lib.c   | 5 ++++-
 block/blk-merge.c | 2 +-
 block/blk.h       | 8 ++++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e90614fd8d6a..f606184a9050 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -85,9 +85,12 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		 *   is split in device drive, the split ones are very probably
 		 *   to be aligned to discard_granularity of the device's queue.
 		 */
-		if (granularity_aligned_lba == sector_mapped)
+		if (granularity_aligned_lba == sector_mapped) {
 			req_sects = min_t(sector_t, nr_sects,
 					  bio_aligned_discard_max_sectors(q));
+			if (!req_sects)
+				return -EOPNOTSUPP;
+		}
 		else
 			req_sects = min_t(sector_t, nr_sects,
 					  granularity_aligned_lba - sector_mapped);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index bcf5e4580603..2439216585d9 100644
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

