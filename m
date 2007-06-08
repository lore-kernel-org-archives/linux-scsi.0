From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Sat, 09 Jun 2007 01:33:06 +0900
Message-ID: <20070609013306Z.fujita.tomonori@lab.ntt.co.jp>
References: <20070604140414.GI32105@kernel.dk>
	<200706042203.l54M3rtf031762@mbox.iij4u.or.jp>
	<20070607112309.GY4735@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:63684 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761897AbXFHQdG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jun 2007 12:33:06 -0400
In-Reply-To: <20070607112309.GY4735@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Thu, 7 Jun 2007 13:23:09 +0200

> On Tue, Jun 05 2007, FUJITA Tomonori wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
> > Date: Mon, 4 Jun 2007 16:04:15 +0200
> > 
> > > On Sun, Jun 03 2007, FUJITA Tomonori wrote:
> > > > The previous commit to fix a blocking read bug put a bug that leads a
> > > > deadlock on discarding done commands. We don't need bsg_device's lock
> > > > there.
> > > > 
> > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > ---
> > > >  block/bsg.c |    5 +----
> > > >  1 files changed, 1 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/block/bsg.c b/block/bsg.c
> > > > index 2f78d7d..9b5f6d7 100644
> > > > --- a/block/bsg.c
> > > > +++ b/block/bsg.c
> > > > @@ -466,11 +466,8 @@ static int bsg_complete_all_commands(str
> > > >  	 */
> > > >  	ret = 0;
> > > >  	do {
> > > > -		spin_lock_irq(&bd->lock);
> > > > -		if (!bd->queued_cmds) {
> > > > -			spin_unlock_irq(&bd->lock);
> > > > +		if (!bd->queued_cmds)
> > > >  			break;
> > > > -		}
> > > >  
> > > >  		bc = bsg_get_done_cmd(bd);
> > > >  		if (IS_ERR(bc))
> > > 
> > > int read should be atomic, but it probably still needs serialization.
> > > I'd be more comfortable with just adding the appropriate
> > > spin_unlock_irq() before bsg_get_done_cmd(). It's not a fast path
> > > anyway, just for device going away.
> > 
> > Ok, here's a patch though only one is accessing to a bsg device here,
> > I think. Anyway, sorry about the silly bug.
> 
> Thanks, applied.
> 
> > BTW, any chance to push bsg to mainline? The scsi mid-layer bidi is
> > not ready, but the block layer bidi is ready with the rq->next_rq
> > patch (and I have the bsg bidi patch). Then I can ask James to push
> > the SMP pass through patches to mainline.
> 
> Sure, might as well get on with it. I'll push it once 2.6.23 opens.

James, any chance that the SMP passthru patches will be got into
2.6.23?
