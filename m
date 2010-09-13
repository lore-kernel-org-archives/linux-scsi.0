From: Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH] block: fix blk_rq_map_kern bio direction flag
Date: Mon, 13 Sep 2010 21:08:27 +0200
Message-ID: <1284404907-14599-1-git-send-email-bhalevy@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:15583 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755079Ab0IMTIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2010 15:08:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>, Boaz Harrosh <bharrosh@panasas.com>

This bug was introduced in 7b6d91daee5cac6402186ff224c3af39d79f4a0e
"block: unify flags for struct bio and struct request"

Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 block/blk-map.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index c65d759..ade0a08 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -307,7 +307,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		return PTR_ERR(bio);
 
 	if (rq_data_dir(rq) == WRITE)
-		bio->bi_rw |= (1 << REQ_WRITE);
+		bio->bi_rw |= REQ_WRITE;
 
 	if (do_copy)
 		rq->cmd_flags |= REQ_COPY_USER;
-- 
1.7.2.2

