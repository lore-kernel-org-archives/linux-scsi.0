Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1920BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbiGDMpS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbiGDMpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87E8EE30;
        Mon,  4 Jul 2022 05:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wNQtyfRXZcvIkmsMqQTlsOMSKBr77f7qSQM5+q+ESrM=; b=eVwTLmPgpmoLN9ssGG+ev7tqmW
        5efjvOtPd5NN+x5BkbFrkTKrHo9DdsWjWylPVd7fN7QNeXOOQcz3qjpxK8+g59vx9d8ku/WHv9AKZ
        shvkycsa4wP1en+/WbI9t8We5/4+eVGbkOakBxITZOt6jNbQB9wk38n/8z4uUHTSYFUDkIysy+MvA
        pVJ1xv2qfbxMep95F9o3Xco2I3BV2Lg31TEenR7r8wqqZK8td8AQVfXG+whubiJIgbfxkVYcWb66h
        m+gis6GGVKqtpNcMQnuHaUa4rb+PvZGP9heCllalXSzJY5MtN0/vt3mIoFhaXv2kQB6+FPAA1i5GA
        RecBEnyg==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LRr-008sAh-HI; Mon, 04 Jul 2022 12:45:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 02/17] block: call blk_queue_free_zone_bitmaps from disk_release
Date:   Mon,  4 Jul 2022 14:44:45 +0200
Message-Id: <20220704124500.155247-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The zone bitmaps are only used for non-passthrough I/O, so free them as
soon as the disk is released.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-sysfs.c | 2 --
 block/genhd.c     | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 58cb9cb9f48cd..7590810cf13fc 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -776,8 +776,6 @@ static void blk_release_queue(struct kobject *kobj)
 	blk_free_queue_stats(q->stats);
 	kfree(q->poll_stat);
 
-	blk_queue_free_zone_bitmaps(q);
-
 	if (queue_is_mq(q))
 		blk_mq_release(q);
 
diff --git a/block/genhd.c b/block/genhd.c
index b1fb7e058b9cc..d0bdeb93e922c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1165,6 +1165,7 @@ static void disk_release(struct device *dev)
 
 	disk_release_events(disk);
 	kfree(disk->random);
+	blk_queue_free_zone_bitmaps(disk->queue);
 	xa_destroy(&disk->part_tbl);
 
 	disk->queue->disk = NULL;
-- 
2.30.2

