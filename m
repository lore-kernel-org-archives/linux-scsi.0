Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C1DC001B0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 21:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbjHKVgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 17:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbjHKVgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 17:36:10 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C36A268C;
        Fri, 11 Aug 2023 14:36:10 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1bc6535027aso21041525ad.2;
        Fri, 11 Aug 2023 14:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691789770; x=1692394570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5q+IWn4ek8qUOXLGwDyPCO3ru0XE1sUcjJbkQBMhNLw=;
        b=ZaIIDwXeIsbv+IUo5n0beD0WJXpr8yxnJwVv3HAIotlZmVRzDnIL1zkczFBk+itORj
         7dYzDhDXuQriNrAlRYnvcfDR8MTnQ5JDwKOBg4GHPwEGo8irdMv6flD3u9fdWTjKVkVF
         TEJ5p1guy6UDAG3k6AZhxQScdXH0TnXF8QRboKT2c/tcRLXPlf1jEa7SkaKy7gCPvOXm
         WcZ0tjv/ao1m+SHtDsAd9+yQKiRv0HvEXW6NmWqG55iZkr4xEDQuUo0ezGFUKqbzw76b
         E6YdQ6quwvcI5PpFh4XACKnWtoh8T+yvDE0If1SfSNIVFPb/S05nPXi9c1E3bwOma+A1
         5vfg==
X-Gm-Message-State: AOJu0YzV9aJ74nNFiMzu1vhNZlcter5cDumTNFhonUiFbVgEJNmiBJUy
        Tg7z/lhx6f5vdNXJCrpz6sA=
X-Google-Smtp-Source: AGHT+IGnGNkoTePbWqEwM7nJ7yC2s8Nxe0/3+t1aL4MSTt59xW0qm39OplLw8wQpXtVYWfxUnTm20A==
X-Received: by 2002:a17:902:f68d:b0:1bc:14f0:b76c with SMTP id l13-20020a170902f68d00b001bc14f0b76cmr3398899plg.65.1691789769789;
        Fri, 11 Aug 2023 14:36:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001b89c313185sm4394865plh.205.2023.08.11.14.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 14:36:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v8 1/9] block: Introduce more member variables related to zone write locking
Date:   Fri, 11 Aug 2023 14:35:35 -0700
Message-ID: <20230811213604.548235-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230811213604.548235-1-bvanassche@acm.org>
References: <20230811213604.548235-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Many but not all storage controllers require serialization of zoned writes.
Introduce a new request queue limit member variable
(driver_preserves_write_order) that allows block drivers to indicate that
the order of write commands is preserved and hence that serialization of
writes per zone is not required.

Make disk_set_zoned() set 'use_zone_write_lock' only if the block device
has zones and if the block driver does not preserve the order of write
requests.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-settings.c   |  7 +++++++
 include/linux/blkdev.h | 10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 0046b447268f..3a7748af1bef 100644
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
@@ -685,6 +687,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 						   b->max_secure_erase_sectors);
 	t->zone_write_granularity = max(t->zone_write_granularity,
 					b->zone_write_granularity);
+	/* Request-based stacking drivers do not reorder requests. */
+	t->driver_preserves_write_order = b->driver_preserves_write_order;
+	t->use_zone_write_lock = b->use_zone_write_lock;
 	t->zoned = max(t->zoned, b->zoned);
 	return ret;
 }
@@ -949,6 +954,8 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 	}
 
 	q->limits.zoned = model;
+	q->limits.use_zone_write_lock = model != BLK_ZONED_NONE &&
+		!q->limits.driver_preserves_write_order;
 	if (model != BLK_ZONED_NONE) {
 		/*
 		 * Set the zone write granularity to the device logical block
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2f5371b8482c..2c090a28ec78 100644
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
