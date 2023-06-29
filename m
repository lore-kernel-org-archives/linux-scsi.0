Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D365EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 06:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjF2G0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jun 2023 02:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjF2G0H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2023 02:26:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDC32D5B;
        Wed, 28 Jun 2023 23:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D7C8614B2;
        Thu, 29 Jun 2023 06:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BBCC433CA;
        Thu, 29 Jun 2023 06:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688019965;
        bh=9GrsNX3cIPYwDUJ797RxS6JlvLu3++Z2w7OHomzyUNM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Yqobn8ey9rOo7HaEJQaEHVF9lfLr6ByTscptqb1DiCDNAvXIw7l5KDaNuYCo7ZtvG
         nvrVb0wCoxLxEco0QcJUwSU6u1rIc+WoQ2ANemh12/ffgED9m8oFdwhqsUNgG8d2gf
         5vPc2wjM+YuOatDHawr8yncWKuPRr7E63dhDsVwBD88DZ4G8Szgj+fMNjOZmCp9Ket
         nbybD4Q0oFU72eBPqYkibW4WAncsDoMO/5pjPC+MQutM1Q7BjAnV+uOtQrLXRySg+9
         dd+hTt+gm/ObF5jYZm0mMpXgCFizu87gzA477XS7JP+rUjLcStwon9SimhWTUzBclk
         GFVwOzAxStwZA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/5] scsi: sd_zbc: Set zone limits before revalidating zones
Date:   Thu, 29 Jun 2023 15:25:58 +0900
Message-ID: <20230629062602.234913-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629062602.234913-1-dlemoal@kernel.org>
References: <20230629062602.234913-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call blk_queue_chunk_sectors() and blk_queue_max_zone_append_sectors()
to respectively set a ZBC device zone size and maximum zone append
sector limit before executing blk_revalidate_disk_zones() to allow this
function to check zone limits.

Since blk_queue_max_zone_append_sectors() already caps the device
maximum zone append limit to the zone size and to the maximum command
size, the max_append value passed to blk_queue_max_zone_append_sectors()
is simplified to the maximum number of segments times the number of
sectors per page.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd_zbc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 22801c24ea19..a25215507668 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -831,7 +831,6 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	struct request_queue *q = disk->queue;
 	u32 zone_blocks = sdkp->early_zone_info.zone_blocks;
 	unsigned int nr_zones = sdkp->early_zone_info.nr_zones;
-	u32 max_append;
 	int ret = 0;
 	unsigned int flags;
 
@@ -876,6 +875,11 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 		goto unlock;
 	}
 
+	blk_queue_chunk_sectors(q,
+			logical_to_sectors(sdkp->device, zone_blocks));
+	blk_queue_max_zone_append_sectors(q,
+			q->limits.max_segments << PAGE_SECTORS_SHIFT);
+
 	ret = blk_revalidate_disk_zones(disk, sd_zbc_revalidate_zones_cb);
 
 	memalloc_noio_restore(flags);
@@ -888,12 +892,6 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 		goto unlock;
 	}
 
-	max_append = min_t(u32, logical_to_sectors(sdkp->device, zone_blocks),
-			   q->limits.max_segments << (PAGE_SHIFT - 9));
-	max_append = min_t(u32, max_append, queue_max_hw_sectors(q));
-
-	blk_queue_max_zone_append_sectors(q, max_append);
-
 	sd_zbc_print_zones(sdkp);
 
 unlock:
-- 
2.41.0

