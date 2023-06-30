Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A06EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jun 2023 08:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjF3Ijo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jun 2023 04:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbjF3Ijk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2023 04:39:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303961BDB;
        Fri, 30 Jun 2023 01:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A6361689;
        Fri, 30 Jun 2023 08:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68273C433C9;
        Fri, 30 Jun 2023 08:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688114379;
        bh=oZUH+aGuaNokG6mpzJLFGf85p884Ot0RaMjfhyYrdWo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=K18N30Pg7RNQQHd8gGMn5peSb+1f8rzmv7CCyUZpoM3MkMidAF2WaBarW9N2JcpYx
         bMtZtrIFUA9dE0dfHBHdg33evHsbpKuRUTPKTEnw4mGwr3b6CDDeVYoMFNCNDToVfS
         81bzBPyM01RhEiowyTYeqSDpHHLovixLIbS3rLHToguthUoOKLW/Prq87n8KC25esH
         bRb/uEcexRd2SDdnXymD9SD0FTE648Yc/Y06rhO35k+Ecxr1+QIuW1bmHR9wf4jqk4
         6APvM2OPO8IHXFz+Xucy58P9PZQZElibQg9seigv/rZ0PTndmoQkys4vjZxDsFP3gw
         NpS3tqxdp69lA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 2/5] nvme: zns: Set zone limits before revalidating zones
Date:   Fri, 30 Jun 2023 17:39:32 +0900
Message-ID: <20230630083935.433334-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230630083935.433334-1-dlemoal@kernel.org>
References: <20230630083935.433334-1-dlemoal@kernel.org>
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

