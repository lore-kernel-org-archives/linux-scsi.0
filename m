From: malahal@us.ibm.com
Subject: Re: next-20081119: general protection fault:
	get_next_timer_interrupt()
Date: Mon, 24 Nov 2008 18:08:52 -0800
Message-ID: <20081125020852.GA27280@us.ibm.com>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com> <alpine.LFD.2.00.0811191308030.3119@localhost.localdomain> <a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com> <alpine.LFD.2.00.0811241816120.3301@localhost.localdomain> <1227554117.25499.46.camel@localhost.localdomain> <alpine.LFD.2.00.0811242018370.3235@localhost.localdomain> <20081124213517.GA25898@linux.vnet.ibm.com> <alpine.LFD.2.00.0811242327130.3235@localhost.localdomain> <20081125000902.GA24251@us.ibm.com> <20081125115710.6c249f32.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081125115710.6c249f32.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Beregalov <a.beregalov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Stephen Rothwell [sfr@canb.auug.org.au] wrote:
> > The block timer code calls del_timer(), should it call del_timer_sync()?
> > It is possible although unlikely that you are hitting del_timer_sync vs
> > del_timer problem in the block timeout code. Can only be seen on SMP
> > systems though!
> 
> Is this still a problem in next-20081121? In that tree, the block commit
> "block: leave the request timeout timer running even on an empty list"
> was changed to add this:
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 04267d6..44f547c 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -391,6 +391,7 @@ EXPORT_SYMBOL(blk_stop_queue);
>  void blk_sync_queue(struct request_queue *q)
>  {
>  	del_timer_sync(&q->unplug_timer);
> +	del_timer_sync(&q->timeout);
>  	kblockd_flush_work(&q->unplug_work);
>  }
>  EXPORT_SYMBOL(blk_sync_queue);

I was looking at the Linux tree. Clearly same problem doesn't exist with
the above commit! I wonder why kblockd_flush_work() is called after the
del_timer_sync(). It makes sense to cancel the work and then shutdown
the timer(s). I doubt if you are running into this problem though.

-Malahal.
