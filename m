From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 -mm 4/6] ide: avoid DMA on the stack for
	REQ_TYPE_ATA_PC
Date: Thu, 05 Jun 2008 11:10:48 -0500
Message-ID: <1212682248.13549.48.camel@localhost.localdomain>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1212389852-1277-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-arch-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, petkovbb@gmail.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, linux-arch@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-06-02 at 15:57 +0900, FUJITA Tomonori wrote:
> Some REQ_TYPE_ATA_PC commands uses the stack buffers for DMA, which
> leads to memory corruption on a non-coherent platform.
> 
> With regard to alignment and padding, ide-cd has the the dma safe
> check for sg requests and REQ_TYPE_ATA_PC. This adds the stack buffer
> check to that check.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-cd.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index e3f085c..e12d602 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1195,6 +1195,7 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
>  		struct request_queue *q = drive->queue;
>  		unsigned int alignment;
>  		unsigned long addr;
> +		unsigned long stack_mask = ~(THREAD_SIZE - 1);
>  
>  		if (rq->bio)
>  			addr = (unsigned long)bio_data(rq->bio);
> @@ -1212,6 +1213,10 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
>  		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
>  		if (addr & alignment || rq->data_len & alignment)
>  			info->dma = 0;
> +
> +		if (!((addr & stack_mask) ^
> +		      ((unsigned long)current->stack & stack_mask)))

That can basically become

if ((addr & stack_mask)  == ((unsigned long)current->stack & stack_mask))

to be a bit clearer, can't it?

I'm also not keen on the use of current->stack.  It looks like this
commit:

commit f7e4217b007d1f73e7e3cf10ba4fea4a608c603f
Author: Roman Zippel <zippel@linux-m68k.org>
Date:   Wed May 9 02:35:17 2007 -0700

    rename thread_info to stack

Introduced a task_stack_page() accessor to get this instead, so perhaps
we should use it (I've cc'd Roman and linux-arch for opinions).

> +			info->dma = 0;
>  	}
>  
>  	/* start sending the command to the drive */

James
