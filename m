From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 -mm 3/6] block: blk_rq_map_kern uses the bounce buffers for stack buffers
Date: Mon,  2 Jun 2008 15:57:29 +0900
Message-ID: <1212389852-1277-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46907 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbYFBHlI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2008 03:41:08 -0400
In-Reply-To: <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, petkovbb@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp

blk_rq_map_kern is used for kernel internal I/Os. Some callers use
this function with stack buffers but DMA to/from the stack buffers
leads to memory corruption on a non-coherent platform.

This patch make blk_rq_map_kern uses the bounce buffers if a caller
passes a stack buffer (on the all platforms for simplicity).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-map.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 0b1af5a..6b0142b 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -268,6 +268,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	int reading = rq_data_dir(rq) == READ;
 	int do_copy = 0;
 	struct bio *bio;
+	unsigned long stack_mask = ~(THREAD_SIZE - 1);
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
@@ -278,6 +279,10 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 	do_copy = ((kaddr & alignment) || (len & alignment));
 
+	if (!((kaddr & stack_mask) ^
+	      ((unsigned long)current->stack & stack_mask)))
+		do_copy = 1;
+
 	if (do_copy)
 		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
 	else
-- 
1.5.4.2

