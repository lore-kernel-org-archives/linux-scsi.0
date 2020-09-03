Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E11C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2242080C
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:42:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eK9nvduJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgICFmD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 01:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgICFlN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 01:41:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181BEC061244;
        Wed,  2 Sep 2020 22:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=lCOMSP4uMUJ3uIKDrmMJjxXVc+8ZTxkt+4XjQNLywdE=; b=eK9nvduJBsF3+cFTg4gaoVitAF
        +ngsBu/GQmjN2Kkei/TQJDAdcxbgEbcowO4oUhDKz/X+MpdHJ9JSsYzNgq/WuQyFdrbm6GJHZWwq4
        JrgcgyQJCGU5rIQYbwNwassLYxu40btDFlRANV2x8rC8vLwjpbiUEIdGJGVogvw/S9NBPejBnQisG
        WCF1SMA+9B/Rbj+9uxsq98RHEWSZSmNQO1U/69CerajafRbz56F/KrD4fETqj37nQXCChnxJsMFXI
        mGhsLBpRMs0vHulWMhQd5QEVMpgR1AWbiyszmK+fSirDb+Zn+WKblR08rDNIIHmvtGk5RoGT2sAyA
        4jmNJ4wA==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDhzi-0007Oh-UY; Thu, 03 Sep 2020 05:41:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 5/9] drbd: don't detour through bd_contains for the gendisk
Date:   Thu,  3 Sep 2020 07:41:00 +0200
Message-Id: <20200903054104.228829-6-hch@lst.de>
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

bd_disk is set on all block devices, including those for partitions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_receiver.c | 2 +-
 drivers/block/drbd/drbd_worker.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 422363daa6180b..2d16fb0905999d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2789,7 +2789,7 @@ bool drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector,
 
 bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
 {
-	struct gendisk *disk = device->ldev->backing_bdev->bd_contains->bd_disk;
+	struct gendisk *disk = device->ldev->backing_bdev->bd_disk;
 	unsigned long db, dt, dbdt;
 	unsigned int c_min_rate;
 	int curr_events;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 7c903de5c4e103..9107b109ba7bcb 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1672,7 +1672,7 @@ void drbd_resync_after_changed(struct drbd_device *device)
 
 void drbd_rs_controller_reset(struct drbd_device *device)
 {
-	struct gendisk *disk = device->ldev->backing_bdev->bd_contains->bd_disk;
+	struct gendisk *disk = device->ldev->backing_bdev->bd_disk;
 	struct fifo_buffer *plan;
 
 	atomic_set(&device->rs_sect_in, 0);
-- 
2.28.0

