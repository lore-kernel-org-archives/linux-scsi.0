From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: garbled usb storage scsi vendor & model
 in 2.6.19-rc1
Date: Wed, 25 Oct 2006 11:08:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610251103540.6229-100000@iolanthe.rowland.org>
References: <453E88FA.3070304@ipom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:19716 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932453AbWJYPI0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Oct 2006 11:08:26 -0400
In-Reply-To: <453E88FA.3070304@ipom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phil Dibowitz <phil@ipom.com>
Cc: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@osdl.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 24 Oct 2006, Phil Dibowitz wrote:

> Alan Stern wrote:
> > There's a comment about this in the source code, asking what should be
> > done if the INQUIRY response is too short (as it is here).  Maybe the best
> > approach would be always to assume the first 36 bytes are valid, even when
> > the device says they aren't.  It ought to solve your problem, and it's
> > no worse than what we're doing now.
> > 
> > The patch is below.  This replaces the patch I sent earlier.
> 
> Perhaps a better approach might be to set the product and vendor to some
> specific string if the device says it isn't providing one? In the new model,
> can't we still have the chance of showing garbage if the device really isn't
> setting anything useful? So what if we show "Unknown" and "Unknown" or
> something similar in the event that the device sets the 'invalid' bit?
> 
> Just a thought...

The vendor and product names are used to identify the device for blacklist
purposes, so using fixed names like "Unknown" for all devices which don't
seem to have their own valid name isn't a good idea.  Besides, in this
case (and probably lots of others) it turned out that the device really
_did_ provide usable data, even though it said the data wasn't valid.

If a device doesn't provide usable data, we still won't end up displaying 
garbage.  That is, we will display whatever the device sends, in a 
sanitized form.  As opposed to what we display now, which is whatever data 
happens to be sitting in memory beyond the end of the allocated area.  
That really _is_ garbage.

Alan Stern

