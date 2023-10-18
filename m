Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0DCCDB484
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjJRR4T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjJRR4Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:56:16 -0400
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A02118;
        Wed, 18 Oct 2023 10:56:15 -0700 (PDT)
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-581b6b93bd1so2102591eaf.1;
        Wed, 18 Oct 2023 10:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651774; x=1698256574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTMw0a7/Uh2Lje80+tulC82TkA3w3+NwQr1GUTziZqE=;
        b=XHdu4rBn69nZ1+abZQGGbbaFBhwmCVsKaBVEIyYeAxCvndH3SaGDhD/KPUITWSQgZz
         N8xrjwiCG60iI5jahx2o2EI7YTd0cl+/iL9u4UAeTfGz6jqMa+gp8uJM9Z+8wpMkFAUp
         ukXfjKABrQfCiNhzU5VPjZ1yaxHNkigBItT2UllznspZhCEHVb2cMPYUUfk+zEmMnIkJ
         h/B3/+aYyBNg4hgVOyLeF1trV3TtOn9zf+FrVZHtuMkAA/aLoJ+8Bb0Yc48+2Kus7h/k
         kVzCX/iZvuZPSOhKURDME876ymw0excukiqjOwSKj/X72YIbLAV/hS5JT6LWDuD84uJ7
         hSAQ==
X-Gm-Message-State: AOJu0YyXNwLEzJHgtaF4F4uwEh1XFFiSVy76Zi6DTyWHu9TznakEdjwY
        7YF8tnM2VVr9AzyCMXIyN5s=
X-Google-Smtp-Source: AGHT+IHAAJWegbEpKLHxvYRYKvPrN/M2dsvCCMfgshZ6aRKOJU+bA+c/s0Gpk0OQ5aGLV/mvOlVoqw==
X-Received: by 2002:a05:6358:c62a:b0:166:ce95:7122 with SMTP id fd42-20020a056358c62a00b00166ce957122mr6438938rwb.14.1697651774122;
        Wed, 18 Oct 2023 10:56:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:56:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v13 01/18] block: Introduce more member variables related to zone write locking
Date:   Wed, 18 Oct 2023 10:54:23 -0700
Message-ID: <20231018175602.2148415-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
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

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
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
index eef450f25982..b67bd8433225 100644
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
