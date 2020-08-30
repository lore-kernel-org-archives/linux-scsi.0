Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F14DC433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 523F22083E
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nwNqqlkh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgH3G1N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgH3GY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 02:24:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5FAC06123A;
        Sat, 29 Aug 2020 23:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BQ4CpzfWadwZaE1eVDKbctMggquiS6KqfZ6j9IqjVrY=; b=nwNqqlkhlV7JsLrxpHUnAD85YU
        +3rhtD5LPOVFm3W2RPTJg0GnSN00cckBaW7dZZyjB/dC0BUaNscFiJZAtDSwvNV2YxxybFCPFWWWy
        9TqmemSuW4HS8Bz6Y/zelI8L8pXcVP9VqVyBD2OY05aUfpMtUsVIVyx3g931vtccPW8HxspdrRYEz
        iC3Aj+Nkx44MEv5wtVANe3nO5OAwp9bt87w+UqIzwHpplQQrNgGgh4HC+TggRf6gOEYk9mpzougaM
        mhuxfNDkNNdthtXNZNsLbj+t4viKMpuHsgNdmjR8OjDZ4F/E1zwVhmibXXMVK+gh+mgKZPCpUyOeo
        QvF4SUIw==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGll-0002MP-0s; Sun, 30 Aug 2020 06:24:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: [PATCH 03/19] block: cleanup del_gendisk a bit
Date:   Sun, 30 Aug 2020 08:24:29 +0200
Message-Id: <20200830062445.1199128-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200830062445.1199128-1-hch@lst.de>
References: <20200830062445.1199128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Merge three hidden gendisk checks into one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index cb9a51be35b053..df6485223a2c3d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -973,22 +973,22 @@ void del_gendisk(struct gendisk *disk)
 	disk->flags &= ~GENHD_FL_UP;
 	up_write(&disk->lookup_sem);
 
-	if (!(disk->flags & GENHD_FL_HIDDEN))
+	WARN_ON(!disk->queue);
+
+	if (!(disk->flags & GENHD_FL_HIDDEN)) {
 		sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
-	if (disk->queue) {
+
 		/*
 		 * Unregister bdi before releasing device numbers (as they can
 		 * get reused and we'd get clashes in sysfs).
 		 */
-		if (!(disk->flags & GENHD_FL_HIDDEN))
-			bdi_unregister(disk->queue->backing_dev_info);
+		bdi_unregister(disk->queue->backing_dev_info);
 		blk_unregister_queue(disk);
+		blk_unregister_region(disk_devt(disk), disk->minors);
 	} else {
-		WARN_ON(1);
+		blk_unregister_queue(disk);
 	}
 
-	if (!(disk->flags & GENHD_FL_HIDDEN))
-		blk_unregister_region(disk_devt(disk), disk->minors);
 	/*
 	 * Remove gendisk pointer from idr so that it cannot be looked up
 	 * while RCU period before freeing gendisk is running to prevent
-- 
2.28.0

