From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 17:39:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040229163922.GE31904@suse.de>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <40421190.2030008@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:35508 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262071AbUB2Qja (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 11:39:30 -0500
Content-Disposition: inline
In-Reply-To: <40421190.2030008@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sun, Feb 29 2004, Jeff Garzik wrote:
> Jens Axboe wrote:
> >On Sat, Feb 28 2004, Jeff Garzik wrote:
> >
> >>Jens Axboe wrote:
> >>
> >>>The only nasty right now is that you cannot unconditionally call
> >>>blk_stop_queue(), it requires a manual blk_start_queue() on io
> >>>completion which will only happen if io is pending of course. I just got
> >>>an idea on how to do that properly, I'll make sure it works in any case.
> >>
> >>hmmm...  I thought the model was to call blk_stop_queue() when you can 
> >>accept no more requests, and call blk_start_queue() once you can start 
> >>accepting more requests.
> >>
> >>That would imply that blk_start_queue() is OK when there is no more I/O 
> >>pending...
> >
> >
> >That is the model. The problem is that you don't have an opportunitty to
> >call blk_start_queue() if there's no more IO pending (you typicall do it
> >from io completion). There's no problem with doing that.
> 
> Help me out here, I must be dumb :)

It's probably my fault, I didn't list all the conditions carefully
enough...

> If you call blk_start_queue() from io completion -- as you should -- 
> then it gets called unconditionally, regardless of whether there is IO 
> pending or not.  The LLD should only care if it can accept more 
> requests.  The opportunity seems to be there, to me...

You are still assuming you have io pending when you call
blk_stop_queue(). If some condition prevents you from queueing the first
request, you call blk_stop_queue() without having anything to start the
queue again.

-- 
Jens Axboe

