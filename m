From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 18:57:59 +0200
Message-ID: <20080625165759.GC20851@kernel.dk>
References: <20080619160342.GJ4392@parisc-linux.org> <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com> <48627184.9010609@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:3435 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYFYQ6C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 12:58:02 -0400
Content-Disposition: inline
In-Reply-To: <48627184.9010609@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Wed, Jun 25 2008, Boaz Harrosh wrote:
> Ric Wheeler wrote:
> > Jens Axboe wrote:
> >> On Thu, Jun 19 2008, Matthew Wilcox wrote:
> >>   
> >>> Use the noop elevator by default for drives that do not spin
> >>>
> >>> [Not for applying]
> >>>
> >>> SSDs do not benefit from the elevator.  It just wastes precious CPU cycles.
> >>> By selecting the noop elevator by default, we can shave a few microseconds
> >>> off each IO.
> >>>
> >>> I've brazenly stolen sd_vpd_inquiry from mkp's patch here:
> >>>
> >>> http://marc.info/?l=linux-scsi&m=121264354724277&w=2
> >>>
> >>> No need to have two copies of that ... but this will conflict with his code.
> >>>
> >>> On to the self-criticism:
> >>>
> >>> I don't intend the final version of this patch to include a printk for
> >>> the RPM or even a printk to say we switched IO elevator.  I think we're
> >>> too verbose in SCSI as it is.
> >>>
> >>> I think there's an opportunity to improve sd_vpd_inquiry() to remove
> >>> some of the duplicate code between sd_set_elevator() and sd_block_limits,
> >>> but it's not terribly important.
> >>>
> >>> The switching of the elevators isn't particularly nice.  I assume that
> >>> elevator_init("noop") cannot fail, which isn't true.  It would be nice
> >>> to use the #if 0 block instead, but that causes a null ptr dereference
> >>> inside sysfs -- I suspect something isn't set up correctly.
> >>>     
> >> I disagree with this approach. For now, lets just add a queue flag that
> >> says the device doesn't have a seek penalty and let the io schedulers do
> >> what they need to avoid that (it'd be a one-liner change to cfq and as).
> >> There's more to io scheduling than just seek reduction, so this is the
> >> wrong direction to take imo.
> >>
> >>   
> > Very true - you still will get a significant win by coalescing IO's (say 
> > for example, to do larger, aligned writes to flash devices).
> > 
> > ric
> > 
> And to not let HUGE writers hug the machine. A scheduler ...

Precisely, merging and fairness is a big part of it. Plus, doing this in
sd is just a blatant layer violation.

-- 
Jens Axboe

