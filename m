From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
Date: Tue, 20 May 2008 13:58:31 +0900
Message-ID: <1211259514-9131-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, akpm@linux-foundation.org, davem@davemloft.net, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

This sets the default dma pad mask to ARCH_KMALLOC_MINALIGN in
blk_queue_make_request(). It affects only non-coherent platforms.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-settings.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8dd8641..781d1bf 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -84,6 +84,11 @@ EXPORT_SYMBOL(blk_queue_softirq_done);
  **/
 void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 {
+#ifndef ARCH_KMALLOC_MINALIGN
+#define ARCH_KMALLOC_MINALIGN 1
+#endif
+	unsigned int min_align = ARCH_KMALLOC_MINALIGN;
+
 	/*
 	 * set defaults
 	 */
@@ -98,6 +103,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
 	blk_queue_hardsect_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
+	blk_queue_dma_pad(q, min_align - 1);
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
 
-- 
1.5.4.2

