From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: I/O write ordering
Date: 22 Sep 2004 11:43:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095867824.2295.13.camel@mulgrave>
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
	<1095866530.2295.8.camel@mulgrave>  <1095866930.6340.11.camel@gaston>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54193 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266170AbUIVPoF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 11:44:05 -0400
In-Reply-To: <1095866930.6340.11.camel@gaston>
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Wed, 2004-09-22 at 11:28, Benjamin Herrenschmidt wrote:
>  - consistent memory is either cacheable or non-cacheable depending on
> the CPU type (some embedded CPUs who don't implement cache coherency
> will map consistent memory as non-cacheable, most desktop CPUs and all
> 64 bits CPU don't mind and will map it cacheable).

Yes, this was what I feared, since streaming memory has exact ownership
and handoff paradigms for handling it.

Your problem case is consistent memory access vs readX/writeX then.

Could you not just make consistent memory always uncacheable ... then
you'd look identical to everyone else...

The alternative in I/O terms is to implement an ownership model for
consistent PCI memory itself...which is sort of what I had to do in the
dma_noncoherent_alloc() API, but to make that more general would be
quite a bit of work.

James


