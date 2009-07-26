From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Patch RFC 14/37] scsi: aacraid semaphore cleanup
Date: Sun, 26 Jul 2009 16:11:31 -0400
Message-ID: <1248639091.4766.4.camel@mulgrave.site>
References: <20090726081459.455111897@linutronix.de>
	 <20090726081555.073502498@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57000 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214AbZGZULg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2009 16:11:36 -0400
In-Reply-To: <20090726081555.073502498@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

cc linux-scsi added

On Sun, 2009-07-26 at 08:18 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (driver-scsi-aacraid-sema-cleanup.patch)
> The usage of these "mutex"es is non obvious and probably completions
> in some places. Make it them semaphores.

-ENOCONTEXT on this ... I assume this is just a global
s/init_MUTEX/semaphore_init/?

I think both are really just mutexes; no need for a counting semaphore.
There's no stack declaration issues (the fibs are long lived entities)
that would necessitate a completion.

James


> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/aacraid/commctrl.c |    2 +-
>  drivers/scsi/aacraid/commsup.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-tip/drivers/scsi/aacraid/commctrl.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/scsi/aacraid/commctrl.c
> +++ linux-2.6-tip/drivers/scsi/aacraid/commctrl.c
> @@ -190,7 +190,7 @@ static int open_getadapter_fib(struct aa
>  		/*
>  		 *	Initialize the mutex used to wait for the next AIF.
>  		 */
> -		init_MUTEX_LOCKED(&fibctx->wait_sem);
> +		semaphore_init_locked(&fibctx->wait_sem);
>  		fibctx->wait = 0;
>  		/*
>  		 *	Initialize the fibs and set the count of fibs on
> Index: linux-2.6-tip/drivers/scsi/aacraid/commsup.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/scsi/aacraid/commsup.c
> +++ linux-2.6-tip/drivers/scsi/aacraid/commsup.c
> @@ -124,7 +124,7 @@ int aac_fib_setup(struct aac_dev * dev)
>  		fibptr->hw_fib_va = hw_fib;
>  		fibptr->data = (void *) fibptr->hw_fib_va->data;
>  		fibptr->next = fibptr+1;	/* Forward chain the fibs */
> -		init_MUTEX_LOCKED(&fibptr->event_wait);
> +		semaphore_init_locked(&fibptr->event_wait);
>  		spin_lock_init(&fibptr->event_lock);
>  		hw_fib->header.XferState = cpu_to_le32(0xffffffff);
>  		hw_fib->header.SenderSize = cpu_to_le16(dev->max_fib_size);
> 

