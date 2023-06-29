Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D24FEB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 06:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjF2G0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jun 2023 02:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjF2G0K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2023 02:26:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF702D62;
        Wed, 28 Jun 2023 23:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED85614CF;
        Thu, 29 Jun 2023 06:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AAFC433C0;
        Thu, 29 Jun 2023 06:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688019967;
        bh=iwBl29tNxXNIsNWLUVnJCMDPgmC2XkOQIOPgLE1r9Yg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OVwrYydYI/I2k+/del815xw2PgWv9avP8KzVHqLZqmoC52ikaWOvcejWOCbfbzsaY
         Ek4irfm8XwkLzBMKRQxBlUUvWTprGkRhjLIm2e83PzhwkOwTq1z+WxFh4N+AldBCK8
         E36xBdoTlPuFm7ZKAic/7X6YU1oqAx5tCOaT3UN+tyo/+zk2k6/N+JytTB0v7dKobl
         G70LhFYbyPKns4gE4+xbUagWb4Tyv6Gz9x0jsLFpObtn+6WDw/GFzv5eSBU7I82z+S
         4e1QvwEPrjV+/glTnIwOlgAmPOM//p2brOQCmhQOKOd+uaDUq8iyV3LsC0fj0qW6WC
         HzriTMtG5NQOA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/5] block: nullblk: Set zone limits before revalidating zones
Date:   Thu, 29 Jun 2023 15:26:00 +0900
Message-ID: <20230629062602.234913-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629062602.234913-1-dlemoal@kernel.org>
References: <20230629062602.234913-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In null_register_zoned_dev(), call blk_queue_chunk_sectors() and
blk_queue_max_zone_append_sectors() to respectively set the device zone
size and maximum zone append sector limit before executing
blk_revalidate_disk_zones() to allow this function to check zone limits.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/null_blk/zoned.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 635ce0648133..84fe0d92087f 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -160,22 +160,17 @@ int null_register_zoned_dev(struct nullb *nullb)
 	struct request_queue *q = nullb->q;
 
 	disk_set_zoned(nullb->disk, BLK_ZONED_HM);
+	disk_set_max_open_zones(nullb->disk, dev->zone_max_open);
+	disk_set_max_active_zones(nullb->disk, dev->zone_max_active);
+
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
 	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
-	disk_set_max_open_zones(nullb->disk, dev->zone_max_open);
-	disk_set_max_active_zones(nullb->disk, dev->zone_max_active);
+	nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
+
+	if (queue_is_mq(q))
+		return blk_revalidate_disk_zones(nullb->disk, NULL);
 
 	return 0;
 }
-- 
2.41.0

