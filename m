From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] blk_rq_map_user_iov: fix error override
Date: Sun, 14 Jan 2018 17:00:48 -0500
Message-ID: <20180114220048.8114-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59055 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751128AbeANWBC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 14 Jan 2018 17:01:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk, bart.vanassche@wdc.com, dvyukov@google.com

During stress tests by syzkaller on the sg driver the block layer
infrequently returns EINVAL. Closer inspection shows the block
layer was trying to return ENOMEM (which is much more
understandable) but for some reason overroad that useful error.

Patch below does not show this (unchanged) line:
   ret =__blk_rq_map_user_iov(rq, map_data, &i, gfp_mask, copy);
That 'ret' was being overridden when that function failed.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 block/blk-map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index d3a94719f03f..db9373bd31ac 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -119,7 +119,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
 	struct bio *bio = NULL;
 	struct iov_iter i;
-	int ret;
+	int ret = -EINVAL;
 
 	if (!iter_is_iovec(iter))
 		goto fail;
@@ -148,7 +148,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	__blk_rq_unmap_user(bio);
 fail:
 	rq->bio = NULL;
-	return -EINVAL;
+	return ret;
 }
 EXPORT_SYMBOL(blk_rq_map_user_iov);
 
-- 
2.14.1
