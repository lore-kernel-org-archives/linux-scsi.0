Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52962C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A36D2071B
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JDPQt27x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgICFll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 01:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbgICFlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 01:41:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C62AC061245;
        Wed,  2 Sep 2020 22:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=R89HA/uWAzWh6mtQM1R1smd1gWJ/i0uHfxn68DDq4hk=; b=JDPQt27x9LDzHp3xHz5NEZKPPl
        cg1EuiWRYukdFbZy4VN0mNfxDjHr2RuHNXqMZSpVkHrCFOOUK7lWRrWYvFSKb5v1SQDEucgnVvWRp
        OH9f7clF3zLQZ9eYl4A9tqYjWbQycwP+lP8x9/dj2iOe4uYHYLadmg1u4sZMa7dzCawvf0H82LJk7
        452refCRAhb0ETWQkqawIq4z14k21fUyJhOBHTQ5tlySjIIw7a0MwidGgHSCQkgEAMhCfMmNrWMcA
        kaFhWxbtpnA4ok/mow9izl06HmyEUW2LVJ/ZMki1gmDNIsby/OhJNkibEBkuRoZ0B+jFdIYyewx33
        vlr6NPKw==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDhzj-0007Op-VV; Thu, 03 Sep 2020 05:41:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 6/9] drbd: don't set ->bd_contains
Date:   Thu,  3 Sep 2020 07:41:01 +0200
Message-Id: <20200903054104.228829-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903054104.228829-1-hch@lst.de>
References: <20200903054104.228829-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ->bd_contains field is set by __blkdev_get and drivers have no
business manipulating it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 04b6bde9419d2a..bd8b129196d49a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2766,8 +2766,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	disk->private_data = device;
 
 	device->this_bdev = bdget(MKDEV(DRBD_MAJOR, minor));
-	/* we have no partitions. we contain only ourselves. */
-	device->this_bdev->bd_contains = device->this_bdev;
 
 	blk_queue_write_cache(q, true, true);
 	/* Setting the max_hw_sectors to an odd value of 8kibyte here
-- 
2.28.0

