Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36451EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jun 2023 08:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjF3Ijr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jun 2023 04:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjF3Ijm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2023 04:39:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433C01FCD;
        Fri, 30 Jun 2023 01:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4EF6616F7;
        Fri, 30 Jun 2023 08:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B966C433C8;
        Fri, 30 Jun 2023 08:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688114380;
        bh=bbajuzLvUWwwdTbld5XYYfeTrAfvglhYfafdpdararM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MvH5007mYb1dbvaGIRHyVq/UeUPYh2bGPJR4iycz3+9AkjKKFuufzOuI1Pe//M7Wg
         2+cxs6U0CHDZZTrt9eN7cJqQOrbVNXBlsr3dVPRoNlWbl2n9BUUXYcdmATXjUe514h
         5yTP+lCqaaFtFCtI1Y1jgEgSyCQqLmmdkDvKYeBTViL50nlNf8WmFiqzJ7rQBWt8xc
         u0Jx9p4oi6FCJo4u7pkjVZeA7wMelxip2C0J3GsSGKDBhEs1IrPVudCmhh7ZMsWrQ9
         AdPEa2Gt+dE5ewF+osf5Hb8QbnnwiAZ9Q6C8I2wuH6MbTKtwB6ZEGnwYuZ+EYrWB8u
         WIGaOaQTzW5tw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 3/5] block: nullblk: Set zone limits before revalidating zones
Date:   Fri, 30 Jun 2023 17:39:33 +0900
Message-ID: <20230630083935.433334-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230630083935.433334-1-dlemoal@kernel.org>
References: <20230630083935.433334-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In null_register_zoned_dev(), execute blk_queue_chunk_sectors() and
blk_queue_max_zone_append_sectors() to respectively set the zoned device
zone size and maximum zone append sector limit before executing
blk_revalidate_disk_zones(). This is to allow the block layer zone
reavlidation to check these device characteristics prior to checking all
zones of the device.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/null_blk/zoned.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 635ce0648133..55c5b48bc276 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -162,21 +162,15 @@ int null_register_zoned_dev(struct nullb *nullb)
 	disk_set_zoned(nullb->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
-
-	if (queue_is_mq(q)) {
-		int ret = blk_revalidate_disk_zones(nullb->disk, NULL);
-
-		if (ret)
-			return ret;
-	} else {
-		blk_queue_chunk_sectors(q, dev->zone_size_sects);
-		nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
-	}
-
+	blk_queue_chunk_sectors(q, dev->zone_size_sects);
+	nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
 	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
 	disk_set_max_open_zones(nullb->disk, dev->zone_max_open);
 	disk_set_max_active_zones(nullb->disk, dev->zone_max_active);
 
+	if (queue_is_mq(q))
+		return blk_revalidate_disk_zones(nullb->disk, NULL);
+
 	return 0;
 }
 
-- 
2.41.0

