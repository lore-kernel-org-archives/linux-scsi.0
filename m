From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and
 usb-storage
Date: Thu, 20 Nov 2003 11:09:30 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311201059130.878-100000@ida.rowland.org>
References: <20031120153026.GB1106@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5636 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262034AbTKTQJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 11:09:31 -0500
In-Reply-To: <20031120153026.GB1106@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Thu, 20 Nov 2003, Jens Axboe wrote:

> Well yes, that's what my objection is against - adding that member. Did
> you not read any of my mails? And it's quite simple why - basically
> noone will add it, so it'll end up being 512 anyways.

All right, fine.  Host adapter drivers have the option of setting the 
dma_alignment mask in their slave_configure() routines.  Doing it there 
won't add anything to the host template, will leave the value at its 
default 512 for host drivers that don't care, and will let drivers that do 
care set it to the optimal value.

The important thing is that sg and st should check the alignment of the 
actual buffer against the dma_alignment mask, which they currently don't 
do.

> I just don't see the point. It's a miniscule optimization. If you need
> that last bit of performance, then align your buffers and noone loses.
> See?

I'm not sure -- was that "you" directed at me personally or at userspace 
program writers in general?  Telling me to align the user buffers won't 
help anything; it's the program writers who need to be informed of the 
restrictions.  And it's the host-driver writers who need to loosen those 
restrictions where applicable.

Alan Stern

