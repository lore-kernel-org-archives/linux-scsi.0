From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: I/O write ordering
Date: 22 Sep 2004 10:47:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095864485.2143.1.camel@mulgrave>
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
Received: from stat16.steeleye.com ([209.192.50.48]:2018 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265970AbUIVOsx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 10:48:53 -0400
In-Reply-To: <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Wed, 2004-09-22 at 10:32, Matthew Wilcox wrote:
> I think the only disagreement is whether we have it implicit or explicit.
> I see three potential solutions:
> 
> 1. iomb() [we have mb(), rmb(), wmb() already.  Does mb() imply iomb()?
>    Vice versa?]
> 2. io_spin_unlock() which is an io barrier as well as a memory barrier.
> 3. Make spin_unlock an io barrier.  Expensive.
> 
> I'd quite like to hear opinions from the PPC and Alpha people, they seem to
> be the most out-of-order architectures.

I favour 1. iomb; I think, since I/O barriers can be either heavyweight
or non-existent depending on the architecture, iomb() should imply mb()
but not vice versa.

James


