From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re:
	+block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patchadded
	 to -mm tree
Date: Thu, 12 Jun 2008 20:17:37 +0900
Message-ID: <20080612201737J.fujita.tomonori@lab.ntt.co.jp>
References: <200806032155.m53LtGxK021677@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:41477 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbYFLLUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2008 07:20:02 -0400
In-Reply-To: <200806032155.m53LtGxK021677@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Tue, 03 Jun 2008 14:55:15 -0700
akpm@linux-foundation.org wrote:

> 
> The patch titled
>      block: blk_rq_map_kern uses the bounce buffers for stack buffers
> has been added to the -mm tree.  Its filename is
>      block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: block: blk_rq_map_kern uses the bounce buffers for stack buffers
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> blk_rq_map_kern is used for kernel internal I/Os. Some callers use
> this function with stack buffers but DMA to/from the stack buffers
> leads to memory corruption on a non-coherent platform.
> 
> This patch make blk_rq_map_kern uses the bounce buffers if a caller
> passes a stack buffer (on the all platforms for simplicity).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Tejun Heo <htejun@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  block/blk-map.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff -puN block/blk-map.c~block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers block/blk-map.c
> --- a/block/blk-map.c~block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers
> +++ a/block/blk-map.c
> @@ -268,6 +268,7 @@ int blk_rq_map_kern(struct request_queue
>  	int reading = rq_data_dir(rq) == READ;
>  	int do_copy = 0;
>  	struct bio *bio;
> +	unsigned long stack_mask = ~(THREAD_SIZE - 1);
>  
>  	if (len > (q->max_hw_sectors << 9))
>  		return -EINVAL;
> @@ -278,6 +279,10 @@ int blk_rq_map_kern(struct request_queue
>  	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
>  	do_copy = ((kaddr & alignment) || (len & alignment));
>  
> +	if (!((kaddr & stack_mask) ^
> +	      ((unsigned long)current->stack & stack_mask)))
> +		do_copy = 1;
> +
>  	if (do_copy)
>  		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
>  	else

Here's an updated version.

A helper function to test if an object is on the stack was added into
-mm. We can use it to simplify this patch.

http://marc.info/?l=linux-kernel&m=121315043731994&w=2

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: blk_rq_map_kern uses the bounce buffers for stack buffers

blk_rq_map_kern is used for kernel internal I/Os. Some callers use
this function with stack buffers but DMA to/from the stack buffers
leads to memory corruption on a non-coherent platform.

This patch make blk_rq_map_kern uses the bounce buffers if a caller
passes a stack buffer (on the all platforms for simplicity).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-map.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 0b1af5a..3cec2b1 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -276,7 +276,8 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 
 	kaddr = (unsigned long)kbuf;
 	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-	do_copy = ((kaddr & alignment) || (len & alignment));
+	do_copy = ((kaddr & alignment) || (len & alignment) ||
+		   object_is_on_stack(kbuf));
 
 	if (do_copy)
 		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
-- 
1.5.5.GIT

