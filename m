Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A5DC4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbhKVNJx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239473AbhKVNJv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28F5C061574;
        Mon, 22 Nov 2021 05:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=mjWk40L5MTwPTWbglDDHC/epyxkAS29x9jk3tEii7c8=; b=kmZEeN9i2ahXtj5UJEYNITDDfI
        56RV45cOJly96iKQtfFgokvsAuWxAq30kODh+RW9H+yicHCk4Hnsey5oIrGrXTzgfNraZVSPh33ex
        dfNonVoPyj37avKW7rFH6FcDEFrDx63YZ59AONwRIDeWCwW4TYTf1q9/xpABC75AUqOjEz7gj1iuP
        s2GEzVCKZBztOo37DrSqLztorRmD5rjLkpXl7iyahoL36jpna8ic0yof5AkMzXezaTbClyjXGFeGE
        NjhJJdaWaGqeyol6NA3fs8bqR85LEfQAT2L8V4W9Bjsc0wx9TfsOJLk0RMVfcb93qWm+QzcGUiPCC
        81zWKULg==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91t-00Crsl-NT; Mon, 22 Nov 2021 13:06:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 12/14] block: don't set GENHD_FL_NO_PART for hidden gendisks
Date:   Mon, 22 Nov 2021 14:06:23 +0100
Message-Id: <20211122130625.1136848-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hidden gendisks can't be opened using blkdev_get_*, so we can't really
reach any of the partition scanning paths or partitioning ioctls except
for the initial partition scan from add_disk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e9346fae48ad4..b1c194813e22f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -376,7 +376,7 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device *bdev;
 
-	if (disk->flags & GENHD_FL_NO_PART)
+	if (disk->flags & (GENHD_FL_NO_PART | GENHD_FL_HIDDEN))
 		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
@@ -493,12 +493,7 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	if (ret)
 		goto out_put_slave_dir;
 
-	if (disk->flags & GENHD_FL_HIDDEN) {
-		/*
-		 * Don't bother scanning for partitions.
-		 */
-		disk->flags |= GENHD_FL_NO_PART;
-	} else {
+	if (!(disk->flags & GENHD_FL_HIDDEN)) {
 		ret = bdi_register(disk->bdi, "%u:%u",
 				   disk->major, disk->first_minor);
 		if (ret)
-- 
2.30.2

