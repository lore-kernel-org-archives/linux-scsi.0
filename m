From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Wed, 27 Aug 2008 11:54:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0808271138040.2498-100000@iolanthe.rowland.org>
References: <1219847626.3292.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49085 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755188AbYH0Py6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Aug 2008 11:54:58 -0400
In-Reply-To: <1219847626.3292.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>, USB list <linux-usb@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 27 Aug 2008, James Bottomley wrote:

> On Wed, 2008-08-27 at 10:21 -0400, Alan Stern wrote:
> > On Tue, 26 Aug 2008, Antonio Ospite wrote:
> > 
> > > Hi,
> > > 
> > > is the fix going to be merged? I haven't seen it in rc4-git series.
> > 
> > Sorry, it slipped my mind.  I'll submit it shortly.  However it may not 
> > be accepted right away, since it affects a very important and difficult 
> > part of the SCSI stack.
> 
> Um, it was my impression that the failure to retry hang problem was, in
> fact, fixed in USB by this:
> 
> commit 580da34847488b404218d1d7f53b156f245f5555
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Tue Aug 5 13:05:17 2008 -0400
> 
>     Fix USB storage hang on command abort

No, that commit fixed a totally different bug.

> What bug is still manifesting with the last_sector_bug flag that still
> needs fixing?

This bug occurs when the last_sector_bug flag causes a multi-sector 
request request to be broken up into multiple single-sector commands.  
If one of those commands fails then the remainder of the request never 
completes, because of bad communication between scsi_io_completion() 
and scsi_end_request().  The calling program then hangs in the kernel, 
waiting for the request to finish.

I suppose there are two possible approaches when this happens.  We 
could either fail the entire request then and there, or else just fail 
the portion corresponding to the last command and then continue on to 
try the remainder.

The existing code implicitly takes the first approach by falling
through to the end of scsi_io_completion() with result nonzero.  But 
this_count is set to the size of the current command instead of the 
remaining size of the request.  So only part of the request gets 
completed, and the request isn't added back to the queue for retrying.  
Thus it never fully completes.

Alan Stern

