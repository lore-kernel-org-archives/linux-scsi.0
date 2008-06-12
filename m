From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: + ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch addedto
	-mm tree
Date: Thu, 12 Jun 2008 20:17:27 +0900
Message-ID: <20080612201727U.fujita.tomonori@lab.ntt.co.jp>
References: <200806032155.m53LtMZR021684@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200806032155.m53LtMZR021684@imap1.linux-foundation.org>
Sender: linux-ide-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, petkovbb@gmail.com, tsbogend@alpha.franken.de, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 03 Jun 2008 14:55:17 -0700
akpm@linux-foundation.org wrote:

> 
> The patch titled
>      ide: avoid DMA on the stack for REQ_TYPE_ATA_PC
> has been added to the -mm tree.  Its filename is
>      ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
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
> Subject: ide: avoid DMA on the stack for REQ_TYPE_ATA_PC
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Some REQ_TYPE_ATA_PC commands uses the stack buffers for DMA, which
> leads to memory corruption on a non-coherent platform.
> 
> With regard to alignment and padding, ide-cd has the the dma safe
> check for sg requests and REQ_TYPE_ATA_PC. This adds the stack buffer
> check to that check.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Acked-by: Borislav Petkov <petkovbb@gmail.com>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Tejun Heo <htejun@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/ide/ide-cd.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff -puN drivers/ide/ide-cd.c~ide-avoid-dma-on-the-stack-for-req_type_ata_pc drivers/ide/ide-cd.c
> --- a/drivers/ide/ide-cd.c~ide-avoid-dma-on-the-stack-for-req_type_ata_pc
> +++ a/drivers/ide/ide-cd.c
> @@ -1195,6 +1195,7 @@ static ide_startstop_t cdrom_do_block_pc
>  		struct request_queue *q = drive->queue;
>  		unsigned int alignment;
>  		unsigned long addr;
> +		unsigned long stack_mask = ~(THREAD_SIZE - 1);
>  
>  		if (rq->bio)
>  			addr = (unsigned long)bio_data(rq->bio);
> @@ -1212,6 +1213,10 @@ static ide_startstop_t cdrom_do_block_pc
>  		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
>  		if (addr & alignment || rq->data_len & alignment)
>  			info->dma = 0;
> +
> +		if (!((addr & stack_mask) ^
> +		      ((unsigned long)current->stack & stack_mask)))
> +			info->dma = 0;
>  	}
>  
>  	/* start sending the command to the drive */

Here's an updated version.

A helper function to test if an object is on the stack was added to
-mm. We can use it to simplify this patch.

http://marc.info/?l=linux-kernel&m=121315043731994&w=2

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ide: avoid DMA on the stack for REQ_TYPE_ATA_PC

Some REQ_TYPE_ATA_PC commands uses the stack buffers for DMA, which
leads to memory corruption on a non-coherent platform.

With regard to alignment and padding, ide-cd has the the dma safe
check for sg requests and REQ_TYPE_ATA_PC. This adds the stack buffer
check to that check.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ide/ide-cd.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index e3f085c..f3a4442 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1194,12 +1194,12 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
 		struct request_queue *q = drive->queue;
 		unsigned int alignment;
-		unsigned long addr;
+		char *buf;
 
 		if (rq->bio)
-			addr = (unsigned long)bio_data(rq->bio);
+			buf = bio_data(rq->bio);
 		else
-			addr = (unsigned long)rq->data;
+			buf = rq->data;
 
 		info->dma = drive->using_dma;
 
@@ -1210,7 +1210,8 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		 * separate masks.
 		 */
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-		if (addr & alignment || rq->data_len & alignment)
+		if ((unsigned long)buf & alignment || rq->data_len & alignment
+		    || object_is_on_stack(buf))
 			info->dma = 0;
 	}
 
-- 
1.5.5.GIT


