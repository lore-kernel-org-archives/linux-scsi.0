From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: I/O write ordering
Date: Wed, 22 Sep 2004 22:26:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040923042631.GA17910@colo.lackof.org>
References: <1095864709.6297.5.camel@gaston> <1095865892.1715.5.camel@mulgrave> <1095865863.6340.7.camel@gaston> <1095866530.2295.8.camel@mulgrave> <1095866930.6340.11.camel@gaston> <1095867824.2295.13.camel@mulgrave> <1095898796.6359.18.camel@gaston> <20040923015819.GU16153@parcelfarce.linux.theplanet.co.uk> <1095908479.2295.53.camel@mulgrave> <1095910802.21753.1.camel@gaston>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:7586 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S268251AbUIWE0d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2004 00:26:33 -0400
Content-Disposition: inline
In-Reply-To: <1095910802.21753.1.camel@gaston>
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Thu, Sep 23, 2004 at 01:40:02PM +1000, Benjamin Herrenschmidt wrote:
> Sounds good, though may be a bit tricky to deal with for things where
> both the kernel and the device are fiddling at the same time, like
> the USB OHCI shared area, or ethernet descriptors...

Normally, "ownership" determines access to particular chunks
of shared data.  Ie the programming model makes it clear when the
CPU can modify data and when the CPU is done modifying data.
At a minimum, the host and/or device has to know when it
lost a race to modify or access data.
If there are race conditions in the programming model, iomb()
will not fix them.

> But it makes
> sense. Could probably be built on top of the dma_consistent_sync... &
> friends actually if driver used the properly (which they don't as
> nobody really understand their semantics).

Or maybe the other way around?
ie find a better replacement for dma_consistent_sync()?
But that's a different rat hole that needs to be hashed out
on linux-ppc list...or some other place far away from me. :^)

thanks,
grant
