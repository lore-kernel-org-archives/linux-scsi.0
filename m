Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D56EEB64DC
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 06:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjF2G0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jun 2023 02:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjF2G0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2023 02:26:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50F42D60;
        Wed, 28 Jun 2023 23:26:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A122614AC;
        Thu, 29 Jun 2023 06:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00616C433C8;
        Thu, 29 Jun 2023 06:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688019966;
        bh=joAVWS+EMFJrm0FZ1gSAlMHImF7ENXf6lPvgI0U1N6E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=q5jZqlIVQSNV5RPB7hvQq+PNYSeDDeyiCigy1pKttWz5iAKN6JxqztU4c72DqoA5M
         AMGhk7k8Gogr2Ts4y2J3HSY8OkK1LwUqQpzHqk9mFkLb50CmDa4hqSuHQr8Rl3DlTq
         Uy8DD42lFZiw9AFTY71KPk4QBnpULPwFTplz5DgygTBIyIJx6zuRFTC8OcRTGjtzNV
         QWIZwiRh2WIdyGE54Kl1qVRw6xmoo2txkRwbPO9uyAkwSmw2zZZb681WmJpM6onizF
         IZYxD9Jj6uR1s65U/6Kh+lAKtAC0IAN6Nifj/3b16wLCssZuuvxOVrpd9qp9b/31ew
         xcvjrXTPqCjvQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/5] nvme: zns: Set zone limits before revalidating zones
Date:   Thu, 29 Jun 2023 15:25:59 +0900
Message-ID: <20230629062602.234913-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629062602.234913-1-dlemoal@kernel.org>
References: <20230629062602.234913-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In nvme_revalidate_zones(), call blk_queue_chunk_sectors() and
blk_queue_max_zone_append_sectors() to respectively set a ZNS device
zone size and maximum zone append sector limit before executing
blk_revalidate_disk_zones() to allow this function to check zone limits.

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

