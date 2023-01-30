Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E462FC54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 21:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjA3V13 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjA3V1T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 16:27:19 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F1744BD6;
        Mon, 30 Jan 2023 13:27:17 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id 5so13059211plo.3;
        Mon, 30 Jan 2023 13:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AAt+l10ON2vRWznkQT8USZE8dWAuuKP2YrkJ5a3o/kc=;
        b=EWZwVMtH7/KVj9y6j/SOTGZpYIeC2I6EKbmCG7w4Q6/e3U0R8Nx/qGOgPlLoxkw4de
         YjqbZ+xTpxJzdg8E4Ben9j1FPMc0BQ2bAzLq6Q6zwuKakqD0rbS7S1byqSkIwItrCj2k
         +o/7tqS7FsFe4oOSwkYCRRdAdnmhTkRIPSfDgDCnwF6vYl14Q5kzVx4wyR/CSpsA3tKD
         VW1l/jhL+2Rk7OgQs1h28CkyFYKjprD0h5Td0A6E4+qP4ucNvm+z1GRZ4RuIpjK4817j
         WLMIOFyIDXKqTkhRxM/4VyxOehVyLEaWVfvIGWY1vr6LgWASdLNzYEksW386YZHOvZy5
         1u4w==
X-Gm-Message-State: AO0yUKVM231MRe/jc9w69pJm3dJ//A/rnDdPbg3OEBqBAgYWUs2r9Bew
        CrtPg5T/kJmK4ZXN8q78HbZBI2txfEQ5YA==
X-Google-Smtp-Source: AK7set9ugoOtK1jnZ+tp5EBVD4ZwPVgZ98Jxl5DFNlP/KfTLtBzZ6oTq6u3fyuklqII69bFWXTJQUQ==
X-Received: by 2002:a17:902:d4cc:b0:196:3ae3:4ffe with SMTP id o12-20020a170902d4cc00b001963ae34ffemr23578957plg.41.1675114037031;
        Mon, 30 Jan 2023 13:27:17 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b00196087a3d7csm7425613plf.77.2023.01.30.13.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:27:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v4 7/7] null_blk: Support configuring the maximum segment size
Date:   Mon, 30 Jan 2023 13:26:56 -0800
Message-Id: <20230130212656.876311-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230130212656.876311-1-bvanassche@acm.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support for configuring the maximum segment size.

Add support for segments smaller than the page size.

This patch enables testing segments smaller than the page size with a
driver that does not call blk_rq_map_sg().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/block/null_blk/main.c     | 19 ++++++++++++++++---
 drivers/block/null_blk/null_blk.h |  1 +
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 4c601ca9552a..06eaa7ff4a86 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -157,6 +157,10 @@ static int g_max_sectors;
 module_param_named(max_sectors, g_max_sectors, int, 0444);
 MODULE_PARM_DESC(max_sectors, "Maximum size of a command (in 512B sectors)");
 
+static unsigned int g_max_segment_size = BLK_MAX_SEGMENT_SIZE;
+module_param_named(max_segment_size, g_max_segment_size, int, 0444);
+MODULE_PARM_DESC(max_segment_size, "Maximum size of a segment in bytes");
+
 static unsigned int nr_devices = 1;
 module_param(nr_devices, uint, 0444);
 MODULE_PARM_DESC(nr_devices, "Number of devices to register");
@@ -409,6 +413,7 @@ NULLB_DEVICE_ATTR(home_node, uint, NULL);
 NULLB_DEVICE_ATTR(queue_mode, uint, NULL);
 NULLB_DEVICE_ATTR(blocksize, uint, NULL);
 NULLB_DEVICE_ATTR(max_sectors, uint, NULL);
+NULLB_DEVICE_ATTR(max_segment_size, uint, NULL);
 NULLB_DEVICE_ATTR(irqmode, uint, NULL);
 NULLB_DEVICE_ATTR(hw_queue_depth, uint, NULL);
 NULLB_DEVICE_ATTR(index, uint, NULL);
@@ -550,6 +555,7 @@ static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_queue_mode,
 	&nullb_device_attr_blocksize,
 	&nullb_device_attr_max_sectors,
+	&nullb_device_attr_max_segment_size,
 	&nullb_device_attr_irqmode,
 	&nullb_device_attr_hw_queue_depth,
 	&nullb_device_attr_index,
@@ -630,7 +636,8 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
 	return snprintf(page, PAGE_SIZE,
 			"badblocks,blocking,blocksize,cache_size,"
 			"completion_nsec,discard,home_node,hw_queue_depth,"
-			"irqmode,max_sectors,mbps,memory_backed,no_sched,"
+			"irqmode,max_sectors,max_segment_size,mbps,"
+			"memory_backed,no_sched,"
 			"poll_queues,power,queue_mode,shared_tag_bitmap,size,"
 			"submit_queues,use_per_node_hctx,virt_boundary,zoned,"
 			"zone_capacity,zone_max_active,zone_max_open,"
@@ -693,6 +700,7 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->queue_mode = g_queue_mode;
 	dev->blocksize = g_bs;
 	dev->max_sectors = g_max_sectors;
+	dev->max_segment_size = g_max_segment_size;
 	dev->irqmode = g_irqmode;
 	dev->hw_queue_depth = g_hw_queue_depth;
 	dev->blocking = g_blocking;
@@ -1234,6 +1242,8 @@ static int null_transfer(struct nullb *nullb, struct page *page,
 	unsigned int valid_len = len;
 	int err = 0;
 
+	WARN_ONCE(len > dev->max_segment_size, "%u > %u\n", len,
+		  dev->max_segment_size);
 	if (!is_write) {
 		if (dev->zoned)
 			valid_len = null_zone_valid_read_len(nullb,
@@ -1269,7 +1279,8 @@ static int null_handle_rq(struct nullb_cmd *cmd)
 
 	spin_lock_irq(&nullb->lock);
 	rq_for_each_segment(bvec, rq, iter) {
-		len = bvec.bv_len;
+		len = min(bvec.bv_len, nullb->dev->max_segment_size);
+		bvec.bv_len = len;
 		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
 				     op_is_write(req_op(rq)), sector,
 				     rq->cmd_flags & REQ_FUA);
@@ -1296,7 +1307,8 @@ static int null_handle_bio(struct nullb_cmd *cmd)
 
 	spin_lock_irq(&nullb->lock);
 	bio_for_each_segment(bvec, bio, iter) {
-		len = bvec.bv_len;
+		len = min(bvec.bv_len, nullb->dev->max_segment_size);
+		bvec.bv_len = len;
 		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
 				     op_is_write(bio_op(bio)), sector,
 				     bio->bi_opf & REQ_FUA);
@@ -2125,6 +2137,7 @@ static int null_add_dev(struct nullb_device *dev)
 		dev->max_sectors = queue_max_hw_sectors(nullb->q);
 	dev->max_sectors = min(dev->max_sectors, BLK_DEF_MAX_SECTORS);
 	blk_queue_max_hw_sectors(nullb->q, dev->max_sectors);
+	blk_queue_max_segment_size(nullb->q, dev->max_segment_size);
 
 	if (dev->virt_boundary)
 		blk_queue_virt_boundary(nullb->q, PAGE_SIZE - 1);
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index eb5972c50be8..8cb73fe05fa3 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -102,6 +102,7 @@ struct nullb_device {
 	unsigned int queue_mode; /* block interface */
 	unsigned int blocksize; /* block size */
 	unsigned int max_sectors; /* Max sectors per command */
+	unsigned int max_segment_size; /* Max size of a single DMA segment. */
 	unsigned int irqmode; /* IRQ completion handler */
 	unsigned int hw_queue_depth; /* queue depth */
 	unsigned int index; /* index of the disk, only valid with a disk */
