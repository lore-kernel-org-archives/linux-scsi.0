From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Mon, 20 Sep 2004 23:45:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921064506.GA143950@sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409201540.02297.jbarnes@engr.sgi.com> <20040920232716.GD19511@colo.lackof.org> <200409201709.45008.jbarnes@engr.sgi.com> <20040921054626.GF19511@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:51105 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267464AbUIUGon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 02:44:43 -0400
Content-Disposition: inline
In-Reply-To: <20040921054626.GF19511@colo.lackof.org>
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Jesse Barnes <jbarnes@engr.sgi.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

Lots of issues covered.

I'd like to cover one of them first, since it is an underlying
principle in the discussion.

On Mon, Sep 20, 2004 at 11:46:26PM -0600, Grant Grundler wrote:
> On Mon, Sep 20, 2004 at 05:09:44PM -0700, Jesse Barnes wrote:
> > > Secondly, I don't recall hearing about problems like this
> > > on Intel or HP ia64 machines. I've only run into PCI posted write
> > > and DMA syncronization problems where the drivers aren't following
> > > all the rules quite right (missing mb() and readl()'s mostly).
> > 
> > Problems like what?
> 
> I've never heard of multiple writes from different CPUs going out of order
> to the PCI device.

It was my understanding that this could be a problem on any
MP machine where the CPUs use a write buffer (which is just
about everything today).

The question seems to be whether release semantics (or equivalent
on other chips) in the IA64 apply to MMIO writes.  I believe that
they do not.  It seems that you think that it does.

On Altix, we ran into a problem with the qla1280 driver (see
version 1.56 in the scsi-misc-2.6 bk tree) because the spinunlock
(apparently) did not imply a retirement of a previous mmio write.
In that rev, I added an mmio read to so that the mmio write would
be completed before releasing the spinlock (I believe the host
lock held during the call to queuecommand).

Before making that change, the problem was the two different CPUs
would mmio write to the Request In register, and the ordering
would flip, causing the qla1280 to think that it suddenly had
an entire request queue.  We didn't see this problem on puny
64p machines (at least not under ordinary stress testing); we
needed a 512p machine to see it, though odds are that it would
have occurred very occasionally on smaller machines.

jeremy
