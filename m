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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3650DC4167B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 05:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0482E22D2A
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 05:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgLFFyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 00:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgLFFyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 00:54:20 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23251C0613D0;
        Sat,  5 Dec 2020 21:53:40 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id o9so6772220pfd.10;
        Sat, 05 Dec 2020 21:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9L0GtDNu2fUqJk744rzWyv0yzJxmbFB3ZB4AjTTF2jc=;
        b=ehusSpJtnwJUk31sQfeWJneoT+tSVYKoY+ATGVszaHUw/2vM5dhTt0EIuRG2yyNME+
         YF8DR3nZVsJfroMcgvRceWxgh/KWSs7cyPSD+YOMjutd5pB/AFMKM/VJrB+Gz+SLuI/g
         f8o6tXC6GqnFjzgJLWzIgz68vG0faUoInMNyPKLxVrtcD01x/AzkNjYzz4iE16UEIfct
         1imFqED9/vKeedACnZ0akioXkbJiZEww0X3cloQ8aE6VEZotvu3w9TXqx/GEUtnEKCmi
         Az+UXSrpTxZprBOYUJbtcuRjBqaqw99dMKhdD2lpl6sYU1grLr6AQJDPqpn4L3QbeSbd
         xLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9L0GtDNu2fUqJk744rzWyv0yzJxmbFB3ZB4AjTTF2jc=;
        b=pv16WwzvJCvTN6Zz7VRSdeUD6EmRIQDcOC5jb6kvqr4ctRXsr2MCB5/3Mpahi2pmxS
         is9ymCmfZpnyafS1jwqhBTKZgJnYtpb4zFSboYnAm8l7JxqefkUdbtLDMfF30G0jJAhp
         5KpctNKJBVhfj9fvu5ll9r6svZl8LLKSvFpQyQV+TYxkBV9yAn5tIt+pYK8pyUXFDVSU
         8TXH6QAwu97BME8brZgFlZK3SgpnB3TEq89rL6zzXySgD44VUXySaRMy3aYXjo1aU3p2
         B7cZsiKo6oCYLNpeZEHXnQRiPsBjUXcRuld3+4RoVUoXjRjLBYzxABP9K9G+qnBwdPNQ
         eXow==
X-Gm-Message-State: AOAM531fBTMruTqg0qRYmCZFWaInfMuV4jL6Kn4fk3cbXFjBk0aWdZGT
        PQJzuKvhgNFk5Lmm2vElaYXaC7mWgzM=
X-Google-Smtp-Source: ABdhPJxGJ78q3nDdLEGu5CirSZLC4KB5o/g9YYvOFkV48RmdtVqsTp9q9JWcCFtW3zubabieU2MUZg==
X-Received: by 2002:a62:8708:0:b029:19d:ea95:5ac4 with SMTP id i8-20020a6287080000b029019dea955ac4mr2123976pfe.46.1607234019210;
        Sat, 05 Dec 2020 21:53:39 -0800 (PST)
Received: from archlinux.. ([161.81.68.216])
        by smtp.gmail.com with ESMTPSA id a14sm4360094pfl.141.2020.12.05.21.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 21:53:38 -0800 (PST)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 1/3] block: try one write zeroes request before going further
Date:   Sun,  6 Dec 2020 13:53:30 +0800
Message-Id: <20201206055332.3144-1-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

At least the SCSI disk driver is "benevolent" when it try to decide
whether the device actually supports write zeroes, i.e. unless the
device explicity report otherwise, it assumes it does at first.

Therefore before we pile up bios that would fail at the end, we try
the command/request once, as not doing so could trigger quite a
disaster in at least certain case. For example, the host controller
can be messed up entirely when one does `blkdiscard -z` a UAS drive.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 block/blk-lib.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e90614fd8d6a..c1e9388a8fb8 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -250,6 +250,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 	struct bio *bio = *biop;
 	unsigned int max_write_zeroes_sectors;
 	struct request_queue *q = bdev_get_queue(bdev);
+	int i = 0;
 
 	if (!q)
 		return -ENXIO;
@@ -264,7 +265,17 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		return -EOPNOTSUPP;
 
 	while (nr_sects) {
-		bio = blk_next_bio(bio, 0, gfp_mask);
+		if (i != 1) {
+			bio = blk_next_bio(bio, 0, gfp_mask);
+		} else {
+			submit_bio_wait(bio);
+			bio_put(bio);
+
+			if (bdev_write_zeroes_sectors(bdev) == 0)
+				return -EOPNOTSUPP;
+			else
+				bio = bio_alloc(gfp_mask, 0);
+		}
 		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);
 		bio->bi_opf = REQ_OP_WRITE_ZEROES;
@@ -280,6 +291,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 			nr_sects = 0;
 		}
 		cond_resched();
+		i++;
 	}
 
 	*biop = bio;
-- 
2.29.2

