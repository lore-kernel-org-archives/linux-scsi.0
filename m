From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 3/3] hpsa: remove unneeded variable
Date: Thu, 1 Aug 2013 08:48:28 -0500
Message-ID: <20130801134828.GZ24664@beardog.cce.hp.com>
References: <51FA5E7A.9050000@redhat.com> <51FA5F4C.4080407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:44540 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3HANs3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Aug 2013 09:48:29 -0400
Content-Disposition: inline
In-Reply-To: <51FA5F4C.4080407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

On Thu, Aug 01, 2013 at 03:14:52PM +0200, Tomas Henzl wrote:
> From: Tomas Henzl <thenzl@redhat.com>
> 
> Remove unneeded variables.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> 
> ---
>  drivers/scsi/hpsa.c | 2 --
>  drivers/scsi/hpsa.h | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 48fa81e..e0f6b00 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -2668,7 +2668,6 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
>  		return NULL;
>  	}
>  	set_bit(i & (BITS_PER_LONG - 1), h->cmd_pool_bits + (i / BITS_PER_LONG));
> -	h->nr_allocs++;
>  	spin_unlock_irqrestore(&h->lock, flags);
>  
>  	c = h->cmd_pool + i;
> @@ -2740,7 +2739,6 @@ static void cmd_free(struct ctlr_info *h, struct CommandList *c)
>  	spin_lock_irqsave(&h->lock, flags);
>  	clear_bit(i & (BITS_PER_LONG - 1),
>  		  h->cmd_pool_bits + (i / BITS_PER_LONG));
> -	h->nr_frees++;
>  	spin_unlock_irqrestore(&h->lock, flags);
>  }
>  
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 9816479..bc85e72 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -98,8 +98,6 @@ struct ctlr_info {
>  	struct ErrorInfo 	*errinfo_pool;
>  	dma_addr_t		errinfo_pool_dhandle;
>  	unsigned long  		*cmd_pool_bits;
> -	int			nr_allocs;
> -	int			nr_frees;
>  	int			scan_finished;
>  	spinlock_t		scan_lock;
>  	wait_queue_head_t	scan_wait_queue;
> -- 
> 1.8.3.1

Ack.

-- steve

