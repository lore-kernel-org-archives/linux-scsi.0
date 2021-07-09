Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D57C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 627AB613C7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhGIIOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 04:14:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231493AbhGIIOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 04:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625818287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2pWtjFqz4jcPDiQr4SNjA0YIVAycnQdj9d42Z4ShVyU=;
        b=ItSE0U0mrYa+2llLr7uIkin7GGrlZVWqbceCsPgh6YVVYtXIPFJ0PgPkQYsoc4i91twF7w
        18JQMyuC2F1b1JVIAHR4CZvLDgzEQJZo1eSUPPdyG692fvzzcMhDhxQZXYwsRoJWonvNoG
        nGWdwBrT9zt7Le4d/XRZzbfiNJflxzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-9u95PXq0PKmRu83R5m5DqA-1; Fri, 09 Jul 2021 04:11:23 -0400
X-MC-Unique: 9u95PXq0PKmRu83R5m5DqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD89C8042FE;
        Fri,  9 Jul 2021 08:11:21 +0000 (UTC)
Received: from localhost (ovpn-13-13.pek2.redhat.com [10.72.13.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E73B5D6D3;
        Fri,  9 Jul 2021 08:11:20 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 08/10] nvme: rdma: replace blk_mq_rdma_map_queues with blk_mq_dev_map_queues
Date:   Fri,  9 Jul 2021 16:10:03 +0800
Message-Id: <20210709081005.421340-9-ming.lei@redhat.com>
In-Reply-To: <20210709081005.421340-1-ming.lei@redhat.com>
References: <20210709081005.421340-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace blk_mq_virtio_map_queues with blk_mq_dev_map_queues which is more
generic from blk-mq viewpoint, so we can unify all map queue
implementation.

Meantime we can pass 'use_manage_irq' info to blk-mq via
blk_mq_dev_map_queues(), this info needn't be 100% accurate, and what
we need is that true has to be passed in if the hba really uses managed
irq.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/nvme/host/rdma.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index a9e70cefd7ed..dc47df03a39a 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -2169,6 +2169,14 @@ static void nvme_rdma_complete_rq(struct request *rq)
 	nvme_complete_rq(rq);
 }
 
+static const struct cpumask *nvme_rdma_get_queue_affinity(
+		void *dev_data, int offset, int queue)
+{
+	struct ib_device *dev = dev_data;
+
+	return ib_get_vector_affinity(dev, offset + queue);
+}
+
 static int nvme_rdma_map_queues(struct blk_mq_tag_set *set)
 {
 	struct nvme_rdma_ctrl *ctrl = set->driver_data;
@@ -2192,10 +2200,12 @@ static int nvme_rdma_map_queues(struct blk_mq_tag_set *set)
 			ctrl->io_queues[HCTX_TYPE_DEFAULT];
 		set->map[HCTX_TYPE_READ].queue_offset = 0;
 	}
-	blk_mq_rdma_map_queues(&set->map[HCTX_TYPE_DEFAULT],
-			ctrl->device->dev, 0);
-	blk_mq_rdma_map_queues(&set->map[HCTX_TYPE_READ],
-			ctrl->device->dev, 0);
+	blk_mq_dev_map_queues(&set->map[HCTX_TYPE_DEFAULT],
+			ctrl->device->dev, 0, nvme_rdma_get_queue_affinity,
+			true, false);
+	blk_mq_dev_map_queues(&set->map[HCTX_TYPE_READ],
+			ctrl->device->dev, 0, nvme_rdma_get_queue_affinity,
+			true, false);
 
 	if (opts->nr_poll_queues && ctrl->io_queues[HCTX_TYPE_POLL]) {
 		/* map dedicated poll queues only if we have queues left */
-- 
2.31.1

