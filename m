Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D33C25B49
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbjJWV4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjJWV4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:56:50 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FEFDE;
        Mon, 23 Oct 2023 14:56:48 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-27d18475ed4so2785549a91.0;
        Mon, 23 Oct 2023 14:56:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098208; x=1698703008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTMw0a7/Uh2Lje80+tulC82TkA3w3+NwQr1GUTziZqE=;
        b=g9nOgpuE6QUZj3EfRGG3NGqbVZWwxKLmyUA/II1uTbBu6v19MBenjzk+QLzKUd7Bj2
         Yoqzm/ZvuputGPu4eHSy3yyQ/FfQB2U/8lXx/D0IK8zZrrfFhW4S4Bam4M12I5SaCxtX
         L/Nb0Ndh4GulGFPQ6LGPHForjCzNUlHx3aSOVXW1yKLXhwbJsbGqQFnPTGivTKRVDXtD
         YUvMDEzcdrJA9t/8qn7InJM2WiEimAC8Kjge7WFimbg9NaeLrCdtBFHzlwBrUM4cSGan
         aiaOBVkWzKXu5lNuVmjcD+HWLuniX8lNCZArdIq7R4bAojjD7aOx5s2MG/V71cDvNWHk
         OipA==
X-Gm-Message-State: AOJu0Yx5IV3Tru27R7R6XY0qTS5jCmJ37g3SsFPqtIlMoo9OBo8jNiS3
        F00DDjQVy4aLWXtN4EGgx84=
X-Google-Smtp-Source: AGHT+IF/kM2h/DfPvHLxlHnJ/jky6/+RCZRPKHEbnln4JlMS+8VZ30sPYvXvW3i7Mnk/FI0XsgD1rQ==
X-Received: by 2002:a17:90b:1490:b0:27c:edd5:6137 with SMTP id js16-20020a17090b149000b0027cedd56137mr8088074pjb.25.1698098207924;
        Mon, 23 Oct 2023 14:56:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:56:47 -0700 (PDT)
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
Subject: [PATCH v14 01/19] block: Introduce more member variables related to zone write locking
Date:   Mon, 23 Oct 2023 14:53:52 -0700
Message-ID: <20231023215638.3405959-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
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
