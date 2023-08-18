Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF300EE499E
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379783AbjHRTpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379919AbjHRTpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:45:34 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB8E4684;
        Fri, 18 Aug 2023 12:45:12 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1bc3d94d40fso10692775ad.3;
        Fri, 18 Aug 2023 12:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387790; x=1692992590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0wk1xa90VnYAyPUoUN4zedZwQDxNHF4MtXWEOIMiWM=;
        b=bgzdamJIIrI7Tz0mnbPud/KLhqu3iw19owxqH6wugbCKVumeZL96ZygzorwKbFZQ+V
         TKTxs/syf4EUSrog5lg5qJ+UAYH/1Wqm2Hqp/fN2wiiRMQMORHtKCgCC/0kyh20HkmO4
         t6Oq0ELKTElWreD8bkvapE5dulal13T/TLZaQ6NqmSG955DeiFly35nVS6gq+pK02zVN
         wcHHGkF106siEY4VlQyhOaCxiq2bCdbF17D/FjGaJhuzw5R7e/S9VQup4wOtOWnLlL6g
         nKj96QOFhzm1idGvys9VMcE76rU1j0efuAaF+kbIe+qejBMGSpZvrYPzvvWEuavYnG53
         w3FA==
X-Gm-Message-State: AOJu0Yw98k2X9f4hLyMWXw7hhO4ZOIDExHhB/jrxXD4HNcGx7smKWAQH
        ei0wK69af2zEQfXtxDwGNUo=
X-Google-Smtp-Source: AGHT+IGnCDxz1tQlpiy7M2N5WUTK9mPo33ZafgMMWUjR1b6pbtgoL87mgKTCtQMPozbcH92qYmIdZw==
X-Received: by 2002:a17:902:d4c9:b0:1b8:a88c:4dc6 with SMTP id o9-20020a170902d4c900b001b8a88c4dc6mr194814plg.45.1692387789982;
        Fri, 18 Aug 2023 12:43:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:43:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v10 01/18] block: Introduce more member variables related to zone write locking
Date:   Fri, 18 Aug 2023 12:34:04 -0700
Message-ID: <20230818193546.2014874-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
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
index c1421da8d45e..38a1a71b2bcc 100644
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
