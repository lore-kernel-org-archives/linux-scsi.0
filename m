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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930B0C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 17:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B42423DC2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 17:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393442AbgLKQOd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 11:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393314AbgLKQOG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 11:14:06 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4608CC0613CF;
        Fri, 11 Dec 2020 08:13:26 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n7so7444696pgg.2;
        Fri, 11 Dec 2020 08:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+VatYUp/CbzFRRkDcJgIRWVA106s7Q3bUbotDUN/Irg=;
        b=r9jTAsRjqBVRzzeXPhcEs4Dj6N5Mc52REuHzSdt0Mmx2USOTiyS24u+vmup3m3J7tj
         GEWmsz5zANtPTKMASQqjw4lDH3NVg8M/btQ+o1tk7jbhG7AHdnYL/XDrCW632lWSPTRv
         RpNWFx6/Kucny4o05PCN6Zw+jFiZEXdktr2kH/WWAxYLG6wIq8TVl3JlZuKVE/yqoo2G
         m8xzxQQNBusyuFo8wr6sc26N97PjpyfQwTWZ3fyc8SBA/3XotYOumi+ir4XIAuH9i27q
         Wr3IQveEnrxGSyTjrcNotZ/Nn+QfPuqbwgTlpSveqFfqaomCmHBgivJMg8jnQtoffHl/
         zzQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+VatYUp/CbzFRRkDcJgIRWVA106s7Q3bUbotDUN/Irg=;
        b=i46Q0wH99q3c9bpk0WNfmUn9tTmrrl+gRME94Ir/dgSiNs+HMDlZrZXO7g+gyeGTkr
         QxcndRthqQgSkirU6fmEVvGAVuLmbMT4RULbPdgwK/HjDHAdEGdT27rbPOXr58Y9F0sJ
         MZgiUs+ZPq8zjWj+RatCMCf/ZEVN7LYaH2WGuoaNV66QZeD44pFggWXVkphu27WJ2zVn
         M/4jmvx8Osvkmazq8uWaqtRNJ3ETBq5RG5jHzWMxm3gLfFY20plQXdUIfRUQ4L7gpP+o
         0ml+IItM6+2acgYJK3V+15PPb0DO844NZocKqgayE1PhZhro23yx1TNr8GcOok5gjErg
         EfQQ==
X-Gm-Message-State: AOAM531Sh7aA9yhIjaU1aY8T50N1wkNPFqwwU5KCmC+ofVsUdqYuftiI
        Pkf7kOVitGCuhBVg7gsExUtyFRAGyAA=
X-Google-Smtp-Source: ABdhPJxhkIdnRpbXwuRsbMgm4Rz0tiigFIv0FQwhqZlyMcRfKSnW/cqMn4WWRCbFouvA28HzZYrqSg==
X-Received: by 2002:a62:c505:0:b029:19d:c3fe:6d92 with SMTP id j5-20020a62c5050000b029019dc3fe6d92mr12280366pfg.47.1607703205524;
        Fri, 11 Dec 2020 08:13:25 -0800 (PST)
Received: from archlinux.. ([161.81.68.216])
        by smtp.gmail.com with ESMTPSA id k21sm10498396pfu.77.2020.12.11.08.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 08:13:24 -0800 (PST)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Tom Yan <tom.ty89@gmail.com>
Subject: [RFC v3] block: avoid the unnecessary blk_bio_discard_split()
Date:   Sat, 12 Dec 2020 00:13:19 +0800
Message-Id: <20201211161319.1767-1-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210113704.1395-1-tom.ty89@gmail.com>
References: <20201210113704.1395-1-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It doesn't seem necessary to have the redundant layer of splitting.
The request size will even be more consistent / aligned to the cap.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 block/blk-lib.c   | 11 +++++++++--
 block/blk-merge.c |  2 +-
 block/blk.h       |  8 ++++++--
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e90614fd8d6a..cbf55c9f0d6f 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -85,12 +85,19 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
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
+
+		/* Zero-sector (unknown) and one-sector granularities are the same.  */
+		granularity = max(q->limits.discard_granularity >> SECTOR_SHIFT, 1U);
+		req_sects = round_down(req_sects, granularity);
 
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
index dfab98465db9..508371fafdf3 100644
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
+	granularity = max(q->limits.discard_granularity >> SECTOR_SHIFT, 1U);
+	return round_down(discard_max_sectors, granularity);
 }
 
 /*
-- 
2.29.2

