Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6400EC433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 439AC61964
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhC3QSS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhC3QRz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:17:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B56C061574;
        Tue, 30 Mar 2021 09:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fx9ipDNB8QCJwEpZSdFltGaNtDhKrZaNZLShscDG/iw=; b=rrdgMTcGdw7+3aotjkdCc98+ld
        5rvxhpirkXotysTVdC4+asorCLAnEuZiLfUKI/tbq8YFylitozuutsHfmqz4+JC0CoUQSc11Soear
        qMe9c3sRMNci3i6xwlBwqbYyUY+0j8HhPXDdYXse5pwVDqx66l4v6VfwfSnQ52dm+IwQoXBzcM6nY
        hyPxHv/YBvmsbjOBoZ3CHwQLoAqZaUhMmtwdrEIN4BaQgWyobNxw6HPAHDA2wdwijf80a4vbr0aYL
        NDxxx2Tv9jD2kX03MpMmcHS9HU6toBtu28WiXRb79c4jlglwhI7fhUfR1B+BI80At8XP9hV4m3tpC
        V6kOvVgQ==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH3u-008aKi-CW; Tue, 30 Mar 2021 16:17:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 07/15] block: remove the -ERESTARTSYS handling in blkdev_get_by_dev
Date:   Tue, 30 Mar 2021 18:17:19 +0200
Message-Id: <20210330161727.2297292-8-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that md has been cleaned up we can get rid of this hack.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 535d29fa06fa47..0c09b6517b20b7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1430,10 +1430,6 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 	if (ret)
 		return ERR_PTR(ret);
 
-	/*
-	 * If we lost a race with 'disk' being deleted, try again.  See md.c.
-	 */
-retry:
 	bdev = blkdev_get_no_open(dev);
 	if (!bdev)
 		return ERR_PTR(-ENXIO);
@@ -1480,8 +1476,6 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 	disk_unblock_events(disk);
 put_blkdev:
 	blkdev_put_no_open(bdev);
-	if (ret == -ERESTARTSYS)
-		goto retry;
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(blkdev_get_by_dev);
-- 
2.30.1

