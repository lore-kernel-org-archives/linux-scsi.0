Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F131DC43461
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6FF2080C
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:42:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uNn9oGdw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgICFmM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 01:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgICFlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 01:41:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07872C061249;
        Wed,  2 Sep 2020 22:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=uYwGVDMXHB40jgd9uVKYjeLPM/XdqdMbtHf32kGpuZo=; b=uNn9oGdwo0OWqccQ+kdfaUKpAZ
        b3FgK4Q9KIUCYXYSBrPhFCLkhSOFO7zvxp8GCc10MEga6TaeQRrJs9P8Ya95fluVt7QSZuuVOIal6
        DbhUGoPt2HqJXLbaShnw+fkBPxA5FNR7m/GRQdBVzh7ej6A6XiBV0XhCncSvC6Npj95+DQq9Ki02F
        4T3sj7BkCQIYpvmCMrX+FlTbfGgODBf0nmy9Dq5hPjy+JdxWxm8BqQGYO5VKNLyi4UtQUFQsoy0iF
        8mokLtzWbh7ytYPgSnDxQMaHKBzsJafd4xRiiaJpUNcJ3wJDzvyXyUpVyo89Lkfog3R4UnolwE3m3
        P1ZiW28w==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDhzh-0007OY-UH; Thu, 03 Sep 2020 05:41:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 4/9] md: don't detour through bd_contains for the gendisk
Date:   Thu,  3 Sep 2020 07:40:59 +0200
Message-Id: <20200903054104.228829-5-hch@lst.de>
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
 drivers/md/md.c | 2 +-
 drivers/md/md.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3f33562d10d6f5..5a0fd93769a70e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8444,7 +8444,7 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 	idle = 1;
 	rcu_read_lock();
 	rdev_for_each_rcu(rdev, mddev) {
-		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
+		struct gendisk *disk = rdev->bdev->bd_disk;
 		curr_events = (int)part_stat_read_accum(&disk->part0, sectors) -
 			      atomic_read(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f9e2ccdd22c478..2175a5ac4f7c68 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -551,7 +551,7 @@ extern void mddev_unlock(struct mddev *mddev);
 
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
 {
-	atomic_add(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
+	atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
 }
 
 static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
-- 
2.28.0

