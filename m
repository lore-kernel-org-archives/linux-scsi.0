From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: I/O write ordering
Date: 22 Sep 2004 23:01:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095908479.2295.53.camel@mulgrave>
References: <20040922025805.GA148414@sgi.com>
	<20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
	<1095864485.2143.1.camel@mulgrave> <1095864709.6297.5.camel@gaston>
	<1095865892.1715.5.camel@mulgrave> <1095865863.6340.7.camel@gaston>
	<1095866530.2295.8.camel@mulgrave> <1095866930.6340.11.camel@gaston>
	<1095867824.2295.13.camel@mulgrave> <1095898796.6359.18.camel@gaston>
	<20040923015819.GU16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:65417 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268155AbUIWDBz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 23:01:55 -0400
In-Reply-To: <20040923015819.GU16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Wed, 2004-09-22 at 21:58, Matthew Wilcox wrote:
> On Thu, Sep 23, 2004 at 10:19:57AM +1000, Benjamin Herrenschmidt wrote:
> > And that wouldn't help vs. spinlocks which are in real RAM
> > (we have a similar issue with IO leaking potentially out of locks, 
> > if we don't use some heavy barriers there too).
> 
> Yep, that was the problem that SGI wanted to solve.

Yes, but the ppc introduces an additional issue with the consistent
memory problem.

The io memory barrier is used to prevent writes to PCI space leaking
around synchronisation primitives.  However, there's also the ordering
of writes to consistent memory vs writes to PCI space.

The ownership model for consistent memory solves this.

Think of it this way: writes to consistent memory are normal memory
writes (they don't trigger actions in the device), it's the writes to
the device space that trigger actions.  All you want to ensure is that
all the consistent memory writes are issued before the device is
triggered into action.

So, in the ownership model you transfer the ownership of the consistent
memory area to the device (which would be the heavyweight barrier on
ppc) then write to the device space to trigger it.

synchronisation of consistent memory accesses can be done via normal
spin locks; synchronisation of device space needs the the iomb() to
prevent reordering leaks around the spinlock.

James


