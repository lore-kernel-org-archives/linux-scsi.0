From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: I/O write ordering
Date: Thu, 23 Sep 2004 01:28:50 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095866930.6340.11.camel@gaston>
References: <1095789421.2467.414.camel@mulgrave>
	 <200409211409.11095.jbarnes@engr.sgi.com>
	 <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com>
	 <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk>
	 <20040921214302.GG146363@sgi.com>
	 <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk>
	 <20040922011652.GD147856@sgi.com> <20040922014428.GD20053@colo.lackof.org>
	 <20040922025805.GA148414@sgi.com>
	 <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
	 <1095864485.2143.1.camel@mulgrave>  <1095864709.6297.5.camel@gaston>
	 <1095865892.1715.5.camel@mulgrave>  <1095865863.6340.7.camel@gaston>
	 <1095866530.2295.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:48594 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S266149AbUIVPdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 11:33:46 -0400
In-Reply-To: <1095866530.2295.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Thu, 2004-09-23 at 01:22, James Bottomley wrote:
> On Wed, 2004-09-22 at 11:11, Benjamin Herrenschmidt wrote:
> > Set by the CPU as non-cacheable.
> 
> I know that ... but that definition is architecture specific and not
> helpful.
> 
> I mean when for I/O transactions does the CPU mark memory as
> uncacheable.  Is it for the PCI spaces only or for consistent PCI memory
> as well?  We need to ascertain in generic I/O terms exactly what it is
> that you want synchronising.

Ok, so as far as we are concerned, synchronization issue is between cacheable
vs. non-cacheable as mapped by the CPU MMU. (synchronisation between various
accesses of the same kind is already correctly handled either by the existing
barriers for cacheable space or by the MMIO accessors themselves).

This includes:

 - MMIO space is always non-cacheable (wether it is PCI or other sorts
of IOs)

 - consistent memory is either cacheable or non-cacheable depending on
the CPU type (some embedded CPUs who don't implement cache coherency
will map consistent memory as non-cacheable, most desktop CPUs and all
64 bits CPU don't mind and will map it cacheable).

Ben.


