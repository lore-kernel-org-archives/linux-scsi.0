From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 21:06:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040229200636.GI31904@suse.de>
References: <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <137982704.1078081053@aslan.btc.adaptec.com> <404236C1.5000001@pobox.com> <156412704.1078082931@aslan.btc.adaptec.com> <40423F7B.4020102@pobox.com> <162922704.1078083749@aslan.btc.adaptec.com> <4042410C.7070701@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:46468 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262128AbUB2UGk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 15:06:40 -0500
Content-Disposition: inline
In-Reply-To: <4042410C.7070701@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sun, Feb 29 2004, Jeff Garzik wrote:
> Justin T. Gibbs wrote:
> >>>Exactly.  The block layer shouldn't be involved in this at all.  In the
> >>>particular case I was talking about, busy or queue full with no I/O 
> >>>pending,
> >
> >                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> >
> >>Agreed for busy.
> >>
> >>But queue full?
> >
> >
> >Some SCSI devices send Queue Full instead of Busy in the case of
> >a "busy" condition with no I/O pending.
> 
> 
> Gotcha, thanks.

Don't forget that this isn't the only condition. What about pci dma
mapping failures?

-- 
Jens Axboe

