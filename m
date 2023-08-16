Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3A3C25B5F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345919AbjHPTzW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345907AbjHPTzD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:03 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15648198E;
        Wed, 16 Aug 2023 12:55:02 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-564b8e60ce9so4078648a12.2;
        Wed, 16 Aug 2023 12:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215701; x=1692820501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b8soXFjhbaqMNIvZK3ljDXn5iJDlvOmt84AIDipCptw=;
        b=hdt7em/mtzNyOn6JIQVHe8KnzOuHwg64y7F3vnken0/t7pdcWX5x6sU5v8lro/UifV
         vGyzfKg7mycUuMRMVs95q0EqEOcYL5SnPTH7q620dTKK2ELL2nvKgluQxNGK9TGOBZHk
         gaMiNGpBg9pbld2MVVqC7R3K60uKRFC54dFo8rkE2vTjnACIrG62ViY2FU+JPAZxtDXv
         h6cObPvVMEBUGM3WfObBRrhtJH6/+jQQxNwxE3fgfp3mKWsrldTuRpb3clX+gbaAhbNU
         73COdU//B0rtwMZmL6OhAh8m3qyDhFUdSN2gdmmziZZbUz4Cr761jeQtOQtL72AHLOeu
         FTFw==
X-Gm-Message-State: AOJu0YzQ5mX25s4iOBPa/CmDSjVXu8/a7MJ/TvwkLuaY5Akv3cJokBGU
        1GqyMEG2yo92RNbli5xwXezZ4+LJ3n4=
X-Google-Smtp-Source: AGHT+IE/p+obXzCwXtyPgArb6nhlCM5x/1jZTEMziMUspvydIk5hij6MyTiGw0HSHRjIfv4wasi2oA==
X-Received: by 2002:a05:6a21:35c9:b0:140:a273:db48 with SMTP id ba9-20020a056a2135c900b00140a273db48mr2534507pzc.62.1692215701388;
        Wed, 16 Aug 2023 12:55:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v9 01/17] block: Introduce more member variables related to zone write locking
Date:   Wed, 16 Aug 2023 12:53:13 -0700
Message-ID: <20230816195447.3703954-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Many but not all storage controllers require serialization of zoned writes.
Introduce two new request queue limit member variables related to write
serialization. 'driver_preserves_write_order' allows block drivers to
indicate that the order of write commands is preserved and hence that
serialization of writes per zone is not required. 'use_zone_write_lock' is
set by disk_set_zoned() if and only if the block device has zones and if
the block driver does not preserve the order of write requests.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-settings.c   | 15 +++++++++++++++
 block/blk-zoned.c      |  1 +
 include/linux/blkdev.h | 10 ++++++++++
 3 files changed, 26 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 0046b447268f..4c776c08f190 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -56,6 +56,8 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->alignment_offset = 0;
 	lim->io_opt = 0;
 	lim->misaligned = 0;
+	lim->driver_preserves_write_order = false;
+	lim->use_zone_write_lock = false;
 	lim->zoned = BLK_ZONED_NONE;
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
@@ -82,6 +84,8 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_zeroes_sectors = UINT_MAX;
 	lim->max_zone_append_sectors = UINT_MAX;
+	/* Request-based stacking drivers do not reorder requests. */
+	lim->driver_preserves_write_order = true;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -685,6 +689,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 						   b->max_secure_erase_sectors);
 	t->zone_write_granularity = max(t->zone_write_granularity,
 					b->zone_write_granularity);
+	t->driver_preserves_write_order = t->driver_preserves_write_order &&
+		b->driver_preserves_write_order;
+	t->use_zone_write_lock = t->use_zone_write_lock ||
+		b->use_zone_write_lock;
 	t->zoned = max(t->zoned, b->zoned);
 	return ret;
 }
@@ -949,6 +957,13 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 	}
 
 	q->limits.zoned = model;
+	/*
+	 * Use the zone write lock only for zoned block devices and only if
+	 * the block driver does not preserve the order of write commands.
+	 */
+	q->limits.use_zone_write_lock = model != BLK_ZONED_NONE &&
+		!q->limits.driver_preserves_write_order;
+
 	if (model != BLK_ZONED_NONE) {
 		/*
 		 * Set the zone write granularity to the device logical block
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 619ee41a51cc..112620985bff 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -631,6 +631,7 @@ void disk_clear_zone_settings(struct gendisk *disk)
 	q->limits.chunk_sectors = 0;
 	q->limits.zone_write_granularity = 0;
 	q->limits.max_zone_append_sectors = 0;
+	q->limits.use_zone_write_lock = false;
 
 	blk_mq_unfreeze_queue(q);
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4feed1fc141f..e6d5450c8488 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -316,6 +316,16 @@ struct queue_limits {
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
+	/*
+	 * Whether or not the block driver preserves the order of write
+	 * requests. Set by the block driver.
+	 */
+	bool			driver_preserves_write_order;
+	/*
+	 * Whether or not zone write locking should be used. Set by
+	 * disk_set_zoned().
+	 */
+	bool			use_zone_write_lock;
 	enum blk_zoned_model	zoned;
 
 	/*
