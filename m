From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: fix blk_queue_dma_pad comment
Date: Sat, 19 Apr 2008 21:12:40 +0900
Message-ID: <20080419211232Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56605 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbYDSMMy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Apr 2008 08:12:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, htejun@gmail.com

This is against Jens' for-2.6.26 branch.

==
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: fix blk_queue_dma_pad comment

rq->data_len is always equal to the true data length.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-settings.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 5713f7e..74f53ed 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -299,9 +299,8 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  *
  * Set pad mask.  Direct IO requests are padded to the mask specified.
  *
- * Appending pad buffer to a request modifies ->data_len such that it
- * includes the pad buffer.  The original requested data length can be
- * obtained using blk_rq_raw_data_len().
+ * Appending pad buffer to a request modifies the last entry of a
+ * scatter list such that it includes the pad buffer.
  **/
 void blk_queue_dma_pad(struct request_queue *q, unsigned int mask)
 {
-- 
1.5.4.2

