From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sat, 28 Feb 2004 10:25:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040228092512.GD923@suse.de>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:30175 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261158AbUB1JZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2004 04:25:25 -0500
Content-Disposition: inline
In-Reply-To: <403FFF86.90302@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Fri, Feb 27 2004, Jeff Garzik wrote:
> Justin T. Gibbs wrote:
> >1) The mid-layer doesn't correctly handle this situation.  The mid-layer
> >   uses blk_plug_device() to implement this behavior rather than
> >   blk_stop_queue().  The leaves the implementation vulnerable to
> >   any code that does a manual unplug (e.g. the SCSI scan code) or a
> >   blk_run_queues() (e.g. MD) which can alter the duration of the delay.
> 
> 
> hum.
> 
> Long term we definitely want to use blk_{start,stop}_queue().  I had to 
> work on Jens for a little while before he was kind enough to add it :) 
> so let's put it to use.

The only nasty right now is that you cannot unconditionally call
blk_stop_queue(), it requires a manual blk_start_queue() on io
completion which will only happen if io is pending of course. I just got
an idea on how to do that properly, I'll make sure it works in any case.

-- 
Jens Axboe

