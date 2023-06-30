Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC59EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jun 2023 08:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbjF3Ijs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jun 2023 04:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbjF3Ijn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2023 04:39:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDCD1BDB;
        Fri, 30 Jun 2023 01:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECCD061703;
        Fri, 30 Jun 2023 08:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6D2C433C0;
        Fri, 30 Jun 2023 08:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688114381;
        bh=CLkjUwaBY5FTvL02K2/nJwMOM3vPLIrW0Ksmnah+OcM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oCMZIzanjtlyQlIY/vh8hI/DvRMYDUBke1c3WlYevpIBRvwG/lKwHuNEVY79RZubJ
         Ddn7B8gOh6ukNRQ3riAp6j7WeLBnaNuwk3+X0XTQv3o+ketGY+CR+dFZw+3j5qPGDj
         0tvMJqPn+qcz3WARY556WRBcP2K1jsbNcSjAifn784fvANkorRtU0iNABZujiiH0Zi
         KRBMQUFAIAtw8vfdu/3xmTHaoa4wbezoqY43yRSEsBwyftqF2vPXjkdF16mAmZtUPU
         ngOjsalZFQyCTR/YTIXLRv8XOfexkzhnKgBIbmmoP38Lvq71WVZ25yeaATogsWm3HS
         6xGAqDBKtQW2Q==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 4/5] block: virtio_blk: Set zone limits before revalidating zones
Date:   Fri, 30 Jun 2023 17:39:34 +0900
Message-ID: <20230630083935.433334-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230630083935.433334-1-dlemoal@kernel.org>
References: <20230630083935.433334-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In virtblk_probe_zoned_device(), execute blk_queue_chunk_sectors() and
blk_queue_max_zone_append_sectors() to respectively set the zoned device
zone size and maximum zone append sector limit before executing
blk_revalidate_disk_zones(). This is to allow the block layer zone
reavlidation to check these device characteristics prior to checking all
zones of the device.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/virtio_blk.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index b47358da92a2..1fe011676d07 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -751,7 +751,6 @@ static int virtblk_probe_zoned_device(struct virtio_device *vdev,
 {
 	u32 v, wg;
 	u8 model;
-	int ret;
 
 	virtio_cread(vdev, struct virtio_blk_config,
 		     zoned.model, &model);
@@ -806,6 +805,7 @@ static int virtblk_probe_zoned_device(struct virtio_device *vdev,
 			vblk->zone_sectors);
 		return -ENODEV;
 	}
+	blk_queue_chunk_sectors(q, vblk->zone_sectors);
 	dev_dbg(&vdev->dev, "zone sectors = %u\n", vblk->zone_sectors);
 
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_DISCARD)) {
@@ -814,26 +814,22 @@ static int virtblk_probe_zoned_device(struct virtio_device *vdev,
 		blk_queue_max_discard_sectors(q, 0);
 	}
 
-	ret = blk_revalidate_disk_zones(vblk->disk, NULL);
-	if (!ret) {
-		virtio_cread(vdev, struct virtio_blk_config,
-			     zoned.max_append_sectors, &v);
-		if (!v) {
-			dev_warn(&vdev->dev, "zero max_append_sectors reported\n");
-			return -ENODEV;
-		}
-		if ((v << SECTOR_SHIFT) < wg) {
-			dev_err(&vdev->dev,
-				"write granularity %u exceeds max_append_sectors %u limit\n",
-				wg, v);
-			return -ENODEV;
-		}
-
-		blk_queue_max_zone_append_sectors(q, v);
-		dev_dbg(&vdev->dev, "max append sectors = %u\n", v);
+	virtio_cread(vdev, struct virtio_blk_config,
+		     zoned.max_append_sectors, &v);
+	if (!v) {
+		dev_warn(&vdev->dev, "zero max_append_sectors reported\n");
+		return -ENODEV;
+	}
+	if ((v << SECTOR_SHIFT) < wg) {
+		dev_err(&vdev->dev,
+			"write granularity %u exceeds max_append_sectors %u limit\n",
+			wg, v);
+		return -ENODEV;
 	}
+	blk_queue_max_zone_append_sectors(q, v);
+	dev_dbg(&vdev->dev, "max append sectors = %u\n", v);
 
-	return ret;
+	return blk_revalidate_disk_zones(vblk->disk, NULL);
 }
 
 #else
-- 
2.41.0

