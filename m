From: Jens Axboe <axboe@suse.de>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and usb-storage
Date: Thu, 20 Nov 2003 16:30:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120153026.GB1106@suse.de>
References: <20031120065353.GW1106@suse.de> <Pine.LNX.4.44L0.0311201015030.878-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:31874 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261938AbTKTPbb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 10:31:31 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311201015030.878-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Thu, Nov 20 2003, Alan Stern wrote:
> On Thu, 20 Nov 2003, Jens Axboe wrote:
> 
> > Then you just cannot do zero-copy dma, if the buffer isn't aligned
> > properly. It's as simple as that. And surely that wont kill you
> > performance wise.
> > 
> > Doing bounce buffering to just maintain the use of mapping user pages
> > into the kernel ls out right silly.
> > 
> > So no, I still don't think we have to add anything. Just don't do_dio if
> > the alignment doesn't allow it. Ditto for sg.
> 
> The answer seems very simple.  There should be a host template entry for
> dma buffer alignment (there's already a dma_boundary member).  It would be
> copied into the device's request queue stucture if it is nonzero,
> overriding the default value of 512.  sg and st should check the user
> buffer against the request queue's dma_alignment mask and avoid doing
> direct I/O if the alignment is wrong -- just fall back to normal I/O.
> 
> Any objections to this scheme?

Well yes, that's what my objection is against - adding that member. Did
you not read any of my mails? And it's quite simple why - basically
noone will add it, so it'll end up being 512 anyways.

I just don't see the point. It's a miniscule optimization. If you need
that last bit of performance, then align your buffers and noone loses.
See?

-- 
Jens Axboe

