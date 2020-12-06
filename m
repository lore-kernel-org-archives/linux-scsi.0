Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4B3C19425
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 05:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FE96230FA
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 05:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgLFFyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 00:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgLFFyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 00:54:22 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AC9C0613D1;
        Sat,  5 Dec 2020 21:53:42 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id s21so6770918pfu.13;
        Sat, 05 Dec 2020 21:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6eSXOV4bceIVLvD3mBDcQt09QEEaRRGrlPLz+3Rl92M=;
        b=IG3XWfSq1T49jj3UASunoVAmIJPCMuPAfYCnONCc6QBpIT66IyXTx2AGgykru8QVRK
         wfS8T/pd4LEIpVeHvGkr8NdWyTI9rgUqSsZQyRq5I4NFbGy1h/sSAP+mqFFuwFsqZxJA
         LFk/fb6fMYvQNyngGUtOpu3AuTp2qCBGeJL0vJU9Wvg1ovpkxyIlVhS5G1Pd/oiwgPtU
         cjja0jcqzTWNk6pqnXjHOc2Ur4dxj9/Zb2obui9P4ag/LKXv8/yy9Kll6+QNmaEaPKK1
         zd+IRjObgrebSP3sKVtNnVm4FRYWejg5jkQPWWONm6Supze7vdjttUULh2aRHVaQ3A7h
         voTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6eSXOV4bceIVLvD3mBDcQt09QEEaRRGrlPLz+3Rl92M=;
        b=L2DM9q6486YSWhIPzghV9KO57LwB5xZhrOIeDnhUUtaZc8bmSi6myUvR5bzzl+rts4
         HspgERRnSZjLFOFGXmqdI82IXa6qJxrpfWWqngIwFFO09vi5TWPQHUGq667WkMgW87Rg
         eneeI+pEdkP/tMDHUoa8dwHU8pVDHBWUXlpcErLQFDgdJRAQdTGJlbcOSqPAy+Sw/cho
         ISkvrGNaYHWJt3jeBgBzm3z9NChRizkSmVUl6efhkc5mdztMR8dklXI2ty6HESJLjILq
         jb8JKfociEcJ+PXGtQ4hsQ4g2CD+xCm4gdOS2UPpV/MXYgR8Gmp+p/M2Da/CE37kIchj
         FOsQ==
X-Gm-Message-State: AOAM533/QgckS8nM9iA1JQ8JJdlCsWUvd0+vi6pylSpEw1PaJc5sRx0w
        nE1sBmA5SEc1ubecWFTuNUUHiM4EmBo=
X-Google-Smtp-Source: ABdhPJz3emla1vmSPTrWHQS6ll66TPvn9tJSW6jaAdGOBLdyPzdBwSV4vuEgAvqF7qoAfeTBm8PUOw==
X-Received: by 2002:a05:6a00:84a:b029:19e:4cc:dc6f with SMTP id q10-20020a056a00084ab029019e04ccdc6fmr401740pfk.33.1607234021932;
        Sat, 05 Dec 2020 21:53:41 -0800 (PST)
Received: from archlinux.. ([161.81.68.216])
        by smtp.gmail.com with ESMTPSA id a14sm4360094pfl.141.2020.12.05.21.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 21:53:41 -0800 (PST)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 2/3] block: make __blkdev_issue_zero_pages() less confusing
Date:   Sun,  6 Dec 2020 13:53:31 +0800
Message-Id: <20201206055332.3144-2-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206055332.3144-1-tom.ty89@gmail.com>
References: <20201206055332.3144-1-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using the same check for the two layers of loops, count
bio pages in the inner loop instead.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 block/blk-lib.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index c1e9388a8fb8..354dcab760c7 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -318,7 +318,7 @@ static int __blkdev_issue_zero_pages(struct block_device *bdev,
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct bio *bio = *biop;
 	int bi_size = 0;
-	unsigned int sz;
+	unsigned int sz, bio_nr_pages;
 
 	if (!q)
 		return -ENXIO;
@@ -327,19 +327,18 @@ static int __blkdev_issue_zero_pages(struct block_device *bdev,
 		return -EPERM;
 
 	while (nr_sects != 0) {
-		bio = blk_next_bio(bio, __blkdev_sectors_to_bio_pages(nr_sects),
-				   gfp_mask);
+		bio_nr_pages = __blkdev_sectors_to_bio_pages(nr_sects);
+		bio = blk_next_bio(bio, bio_nr_pages, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
-		while (nr_sects != 0) {
+		while (bio_nr_pages != 0) {
 			sz = min((sector_t) PAGE_SIZE, nr_sects << 9);
 			bi_size = bio_add_page(bio, ZERO_PAGE(0), sz, 0);
 			nr_sects -= bi_size >> 9;
 			sector += bi_size >> 9;
-			if (bi_size < sz)
-				break;
+			bio_nr_pages--;
 		}
 		cond_resched();
 	}
-- 
2.29.2

