From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 28/30] swap: do not send discards as barriers
Date: Wed, 25 Aug 2010 17:47:45 +0200
Message-ID: <1282751267-3530-29-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

The swap code already uses synchronous discards, no need to add I/O barriers.

tj: superflous newlines removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hugh Dickins <hughd@google.com>
Tested-by: Nigel Cunningham <nigel@tuxonice.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/swapfile.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1f3f9c5..68cda16 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -141,8 +141,7 @@ static int discard_swap(struct swap_info_struct *si)
 	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
 	if (nr_blocks) {
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			return err;
 		cond_resched();
@@ -153,8 +152,7 @@ static int discard_swap(struct swap_info_struct *si)
 		nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
 
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			break;
 
@@ -193,8 +191,7 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT |
-							BLKDEV_IFL_BARRIER))
+				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT))
 				break;
 		}
 
-- 
1.7.1

