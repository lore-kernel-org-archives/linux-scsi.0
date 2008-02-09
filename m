From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 5/7] block: clear drain buffer if draining for write command
Date: Sat,  9 Feb 2008 10:40:24 +0900
Message-ID: <12025212272956-git-send-email-htejun@gmail.com>
References: <12025212262892-git-send-email-htejun@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <12025212262892-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Clear drain buffer before chaining if the command in question is a
write.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 block/blk-merge.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index d50cfc8..d0b9031 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -221,6 +221,9 @@ new_segment:
 	} /* segments in rq */
 
 	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
+		if (rq->cmd_flags & REQ_RW)
+			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
+
 		sg->page_link &= ~0x02;
 		sg = sg_next(sg);
 		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
-- 
1.5.2.4

