From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and
 usb-storage
Date: Thu, 20 Nov 2003 10:20:15 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311201015030.878-100000@ida.rowland.org>
References: <20031120065353.GW1106@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3332 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261898AbTKTPUQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 10:20:16 -0500
In-Reply-To: <20031120065353.GW1106@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Thu, 20 Nov 2003, Jens Axboe wrote:

> Then you just cannot do zero-copy dma, if the buffer isn't aligned
> properly. It's as simple as that. And surely that wont kill you
> performance wise.
> 
> Doing bounce buffering to just maintain the use of mapping user pages
> into the kernel ls out right silly.
> 
> So no, I still don't think we have to add anything. Just don't do_dio if
> the alignment doesn't allow it. Ditto for sg.

The answer seems very simple.  There should be a host template entry for
dma buffer alignment (there's already a dma_boundary member).  It would be
copied into the device's request queue stucture if it is nonzero,
overriding the default value of 512.  sg and st should check the user
buffer against the request queue's dma_alignment mask and avoid doing
direct I/O if the alignment is wrong -- just fall back to normal I/O.

Any objections to this scheme?

Alan Stern

