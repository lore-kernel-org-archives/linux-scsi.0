From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 10:13:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040229091350.GC3149@suse.de>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:62122 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262020AbUB2JOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 04:14:42 -0500
Content-Disposition: inline
In-Reply-To: <4041292C.3090700@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sat, Feb 28 2004, Jeff Garzik wrote:
> Jens Axboe wrote:
> >The only nasty right now is that you cannot unconditionally call
> >blk_stop_queue(), it requires a manual blk_start_queue() on io
> >completion which will only happen if io is pending of course. I just got
> >an idea on how to do that properly, I'll make sure it works in any case.
> 
> hmmm...  I thought the model was to call blk_stop_queue() when you can 
> accept no more requests, and call blk_start_queue() once you can start 
> accepting more requests.
> 
> That would imply that blk_start_queue() is OK when there is no more I/O 
> pending...

That is the model. The problem is that you don't have an opportunitty to
call blk_start_queue() if there's no more IO pending (you typicall do it
from io completion). There's no problem with doing that.

-- 
Jens Axboe

