From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 18:55:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040229175501.GF31904@suse.de>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <40421190.2030008@pobox.com> <20040229163922.GE31904@suse.de> <4042214F.90705@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:32460 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262093AbUB2RzI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 12:55:08 -0500
Content-Disposition: inline
In-Reply-To: <4042214F.90705@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sun, Feb 29 2004, Jeff Garzik wrote:
> Jens Axboe wrote:
> >On Sun, Feb 29 2004, Jeff Garzik wrote:
> >>If you call blk_start_queue() from io completion -- as you should -- 
> >>then it gets called unconditionally, regardless of whether there is IO 
> >>pending or not.  The LLD should only care if it can accept more 
> >>requests.  The opportunity seems to be there, to me...
> >
> >
> >You are still assuming you have io pending when you call
> >blk_stop_queue(). If some condition prevents you from queueing the first
> >request, you call blk_stop_queue() without having anything to start the
> >queue again.
> 
> ok, I got it.  I thought your "io pending" was referring to requests in 
> the request_queue, not requests active in the LLD.
> 
> Still, this is the responsibility of the LLD, right?  For example, 
> before any requests are ever sent to the request_queue, the LLD may 
> choose to call blk_stop_queue() to prevent queueing while it probes or 
> resets the bus.  That would be a case where there is no io pending, for 
> both definitions of the phrase :)  And it would be up to the LLD to call 
> blk_start_queue() again.  Right?

Yeah that's precisely right. So right now it means that the LLD has to
arm some sort of timer to trigger a blk_start_queue(), _or_ call
blk_plug_device() instead of blk_stop_queue() for this particular case.

-- 
Jens Axboe

