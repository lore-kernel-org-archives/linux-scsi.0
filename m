From: Jens Axboe <axboe@suse.de>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and usb-storage
Date: Thu, 20 Nov 2003 07:53:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120065353.GW1106@suse.de>
References: <20031119084729.GA1106@suse.de> <200311191401.34540.oliver@neukum.org> <20031119130400.GG1106@suse.de> <1069252642.10768.7.camel@mulgrave> <20031119143901.GI1106@suse.de> <1069253904.10768.13.camel@mulgrave> <20031119150011.GJ1106@suse.de> <Pine.LNX.4.58.0311191854560.2166@kai.makisara.local> <20031119201952.GT1106@suse.de> <Pine.LNX.4.58.0311192331370.2166@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:59356 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261538AbTKTGyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 01:54:20 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0311192331370.2166@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Thu, Nov 20 2003, Kai Makisara wrote:
> On Wed, 19 Nov 2003, Jens Axboe wrote:
> 
> > On Wed, Nov 19 2003, Kai Makisara wrote:
> ..
> > > As usual, I am against this 512-byte alignment (thinking as st
> > > maintainer). Don't default to more strict aligment requirements than is
> > > necessary. It creates hidden performance problems for character device
> > > drivers.
> >
> > But you have to honor hardware restrictions, though. Where is the
> > performance impact?
> >
> Yes, I agree that we must not try to do things the hardware does not
> allow. On i386, most SCSI adapter accept any alignment. It is a waste to
> require 512-byte alignment with these adapters just because USB requires
> that. I think there should be a way for the high-level drivers to know
> about the absolutely necessary alignment requirements for the actual
> adapter being used with a device.
> 
> If the user buffer is not aligned according to the required rules, the
> driver must copy the data into a temporary buffer for i/o. This consumes
> bandwidth and with the current faster tape drives this leads to
> significant waste of cpu cycles (according to measurements).
> 
> The software using tapes tends to malloc() the buffers and then the
> alignment is not guaranteed to 512 byte boundaries. Other Unices don't
> have alignment requirements for tape buffers and I think we should avoid
> requiring this in Linux if possible.

Then you just cannot do zero-copy dma, if the buffer isn't aligned
properly. It's as simple as that. And surely that wont kill you
performance wise.

Doing bounce buffering to just maintain the use of mapping user pages
into the kernel ls out right silly.

So no, I still don't think we have to add anything. Just don't do_dio if
the alignment doesn't allow it. Ditto for sg.

-- 
Jens Axboe

