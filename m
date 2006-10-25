From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: garbled usb storage scsi vendor & model
 in 2.6.19-rc1
Date: Wed, 25 Oct 2006 11:11:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610251108440.6229-100000@iolanthe.rowland.org>
References: <20061024231816.GD9511@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:20745 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932455AbWJYPL4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Oct 2006 11:11:56 -0400
In-Reply-To: <20061024231816.GD9511@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Phil Dibowitz <phil@ipom.com>, Andrew Morton <akpm@osdl.org>, Meelis Roos <mroos@linux.ee>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 24 Oct 2006, Matthew Dharm wrote:

> On Tue, Oct 24, 2006 at 02:43:22PM -0700, Phil Dibowitz wrote:
> > Alan Stern wrote:
> > > There's a comment about this in the source code, asking what should be
> > > done if the INQUIRY response is too short (as it is here).  Maybe the best
> > > approach would be always to assume the first 36 bytes are valid, even when
> > > the device says they aren't.  It ought to solve your problem, and it's
> > > no worse than what we're doing now.
> > > 
> > > The patch is below.  This replaces the patch I sent earlier.
> > 
> > Perhaps a better approach might be to set the product and vendor to some
> > specific string if the device says it isn't providing one? In the new model,
> > can't we still have the chance of showing garbage if the device really isn't
> > setting anything useful? So what if we show "Unknown" and "Unknown" or
> > something similar in the event that the device sets the 'invalid' bit?
> 
> US_FL_FIX_INQUIRY used to do this; I don't remember what it does currently.

It uses whatever strings are given in the unusual_devs entry.

> Regardless, the SCSI core should probably blank those data buffers before
> deciding if any data is going to be copied into them.

That isn't the problem.  The problem is the allocated size of the inquiry 
buffer.  The SCSI core allocates just enough memory to hold the actual 
inquiry data and copies only that much into it.  If the device says there 
are only 5 valid bytes of data, then that's how large the buffer is.  But 
nevertheless the core uses the bytes at offsets 8, 16, and 32 for the 
vendor, product, and revision strings.  They aren't even in the allocated 
region, never mind not being blanked!

Alan Stern

