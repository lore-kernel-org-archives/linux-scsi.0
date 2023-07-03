Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0809C001DB
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jul 2023 02:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjGCCsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jul 2023 22:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjGCCsT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jul 2023 22:48:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1746E44;
        Sun,  2 Jul 2023 19:48:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4654660D42;
        Mon,  3 Jul 2023 02:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20BEC433D9;
        Mon,  3 Jul 2023 02:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688352496;
        bh=aQz14JDPpfYBy7pNRQoQLYD4d3slnZtaCXTLLik5g6U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oOGR1CKLB2WfEy4CtDVZPIwBmxIG7WiKDObbpsX9WlnsU5bKQbbSninmibwhvbyHY
         prf8CgkapsEuu2SxeiKfYNWYNGJWO6wx14nC8NPwmbD76/mTx7JiTDaErw16IhoJl3
         qu+PZB2QOUQ3GBxA6XUKR/mZatbQekHNhezzLq/4YdgPJBZ8lZDXHOV4nxfZPVszFo
         ZHAoVPsE9zg+2j5JTguUnV15o62dwt60AhI3JfKqHE4SWFvjH6gcIOPGTRV7pX1w/Y
         R7gwMHZHW8q/ooZpuo8rqozdnDl6aTtlJSyUcKwjxGEU/E31kGWmK1Sc+8PAeTRvxn
         nH/6xwykrMU8w==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 2/5] nvme: zns: Set zone limits before revalidating zones
Date:   Mon,  3 Jul 2023 11:48:09 +0900
Message-ID: <20230703024812.76778-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703024812.76778-1-dlemoal@kernel.org>
References: <20230703024812.76778-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In nvme_revalidate_zones(), execute blk_queue_chunk_sectors() and
blk_queue_max_zone_append_sectors() to respectively set a ZNS namespace
zone size and maximum zone append sector limit before executing
blk_revalidate_disk_zones(). This is to allow the block layer zone
reavlidation to check these device characteristics prior to checking all
zones of the device.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/nvme/host/zns.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 12316ab51bda..ec8557810c21 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -10,12 +10,11 @@
 int nvme_revalidate_zones(struct nvme_ns *ns)
 {
 	struct request_queue *q = ns->queue;
-	int ret;
 
-	ret = blk_revalidate_disk_zones(ns->disk, NULL);
-	if (!ret)
-		blk_queue_max_zone_append_sectors(q, ns->ctrl->max_zone_append);
-	return ret;
+	blk_queue_chunk_sectors(q, ns->zsze);
+	blk_queue_max_zone_append_sectors(q, ns->ctrl->max_zone_append);
+
+	return blk_revalidate_disk_zones(ns->disk, NULL);
 }
 
 static int nvme_set_max_append(struct nvme_ctrl *ctrl)
-- 
2.41.0

