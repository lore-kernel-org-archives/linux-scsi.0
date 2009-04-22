From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: add check_capacity flag and sd_read_last_sector()
Date: Wed, 22 Apr 2009 13:17:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0904221315340.3405-100000@iolanthe.rowland.org>
References: <20090422145116.GH1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54868 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754066AbZDVRR3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 13:17:29 -0400
In-Reply-To: <20090422145116.GH1926@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Wed, 22 Apr 2009, Matthew Wilcox wrote:

> On Wed, Apr 22, 2009 at 10:42:36AM -0400, Alan Stern wrote:
> > +	/* If the capacity is unknown, we can't test anything */
> > +	if (sdkp->capacity <= 0)
> > +		return rc;
> 
> sector_t is unsigned, so this should be just == 0.

It doesn't make any difference.

> > +	/* One test should be enough (unless it's inconclusive) */
> > +	sdp->check_capacity = 0;
> > +
> > +	/* If the device doesn't use READ(10), assume we're okay */
> > +	if (!sdp->use_10_for_rw)
> > +		return rc;
> > +
> > +	/* If the capacity is too big for READ(10), assume we're okay */
> > +	if (sdkp->capacity > 0xffffffff)
> > +		return rc;
> 
> Won't gcc warn about this when sector_t is 32 bits?

My version of gcc doesn't emit a warning (and I don't have CONFIG_LBD 
defined).  Maybe other versions will.

Alan Stern

