From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 21:04:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040229200437.GH31904@suse.de>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <137982704.1078081053@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:12676 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262127AbUB2UEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 15:04:45 -0500
Content-Disposition: inline
In-Reply-To: <137982704.1078081053@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sun, Feb 29 2004, Justin T. Gibbs wrote:
> >> That would imply that blk_start_queue() is OK when there is no more I/O 
> >> pending...
> > 
> > That is the model. The problem is that you don't have an opportunitty to
> > call blk_start_queue() if there's no more IO pending (you typicall do it
> > from io completion). There's no problem with doing that.
> 
> You just need to schedule a timer to do the blk_start_queue() call.
> The point of doing this is so that the delay is deterministic.

There is no good pre-determined delay... If you plug the device when you
cannot simply use blk_stop_queue() (or prefer not to), then you get the
usual q->unplug_delay delay (3ms).

-- 
Jens Axboe

