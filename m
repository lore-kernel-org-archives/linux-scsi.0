From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: I/O write ordering
Date: Thu, 23 Sep 2004 00:40:49 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095864049.6359.2.camel@gaston>
References: <1095789421.2467.414.camel@mulgrave>
	 <200409211409.11095.jbarnes@engr.sgi.com>
	 <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com>
	 <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk>
	 <20040921214302.GG146363@sgi.com>
	 <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk>
	 <20040922011652.GD147856@sgi.com> <20040922014428.GD20053@colo.lackof.org>
	 <20040922025805.GA148414@sgi.com>
	 <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:17874 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S265996AbUIVOoc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 10:44:32 -0400
In-Reply-To: <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Thu, 2004-09-23 at 00:32, Matthew Wilcox wrote:

> I'd quite like to hear opinions from the PPC and Alpha people, they seem to
> be the most out-of-order architectures.

The more specific the barrier is, the happier we are on ppc so we can
select the right one in our collection :)

Write ordering is usually just a matter of eieio. _however_ the main
problem we have is write ordering between two different storage classes,
that is between cacheable space and non cacheable space. Our normal
write ordering barrier will not order between those, thus causing all
sorts of issues with devices mixing MMIO & DMA. We have to use a more
heavy-weight barrier in those cases, but currently, linux lacks the
proper abstraction for that, thus we had to clutter then normal MMIO
writes to do the big barrier each time to be safe ...

Ben.


