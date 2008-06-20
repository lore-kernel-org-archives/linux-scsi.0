From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Fri, 20 Jun 2008 15:56:04 -0500
Message-ID: <1213995364.3443.46.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0806201619010.2133-300000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53422 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbYFTU4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2008 16:56:09 -0400
In-Reply-To: <Pine.LNX.4.44L0.0806201619010.2133-300000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2008-06-20 at 16:22 -0400, Alan Stern wrote:
> On Sat, 14 Jun 2008, Maciej Rutecki wrote:
> 
> > 2008/6/13 Alan Stern <stern@rowland.harvard.edu>:
> > 
> > [...]
> > 
> > >
> > > That patch wasn't meant to help; it wasn't complete.  It was meant to
> > > stimulate conversation -- and clearly it failed.
> > >
> > > Below is a complete patch.  It's very ugly and isn't likely to get
> > > accepted, but maybe it will convince people to start talking about the
> > > problem.  Maybe it will offend people's sensibilities so that they will
> > > just _have_ to chime in, if only to complain about how bad the patch
> > > is...
> > 
> > [...]
> > 
> > Tested with 2.6.26-rc2 and works fine. Thanks.
> 
> Not having received any comments on that earlier patch, I wrote a new
> version.  Actually it's a pair of patches, and they have to be applied
> in order.  They don't look as ugly as the old one and they have a
> decent chance of being accepted.

Actually, just looking at this, what you're really trying to do is
enforce an underrun detection, which is a concept built in to the
command structure but not necessarily well implemented by all drivers.

However, I had a tick on this one to go back and look at it.

Your initial contention was that the garbage value was "left over data"
in the sense command.  However, I don't see how we're getting this into
the buffer; scsi_mode_sense() clears the buffer up to the length it's
expecting before it executes the request.  How is this getting garbage
data if nothing's returned ... surely it should still be all zeros?

James


