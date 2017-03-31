From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/25] rbd: remove the discard_zeroes_data flag
Date: Fri, 31 Mar 2017 18:33:07 +0200
Message-ID: <20170331163313.31821-20-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45413 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933291AbdCaQeN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:34:13 -0400
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

rbd only supports discarding on large alignments, so the zeroing code
would always fall back to explicit writings of zeroes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rbd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 517838b65964..0ec3b430e81d 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4380,7 +4380,6 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	q->limits.discard_granularity = segment_size;
 	q->limits.discard_alignment = segment_size;
 	blk_queue_max_discard_sectors(q, segment_size / SECTOR_SIZE);
-	q->limits.discard_zeroes_data = 1;
 
 	if (!ceph_test_opt(rbd_dev->rbd_client->client, NOCRC))
 		q->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
-- 
2.11.0
