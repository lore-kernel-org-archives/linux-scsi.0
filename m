From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 19:44:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922014428.GD20053@colo.lackof.org>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211346.58267.jbarnes@engr.sgi.com> <1095789421.2467.414.camel@mulgrave> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com> <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk> <20040921214302.GG146363@sgi.com> <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk> <20040922011652.GD147856@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:26250 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S267595AbUIVBoa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 21:44:30 -0400
Content-Disposition: inline
In-Reply-To: <20040922011652.GD147856@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 06:16:52PM -0700, Jeremy Higdon wrote:
> First let's make sure that we like it best.
> 
> The other alternative is an explicit I/O barrier.
> 
> 	writel(high-water, request-in)
> 	mmiob()  /* memory-mapped I/O barrier */
> 	spin_unlock(hostlock)

I strongly prefer a seperate function call.

I'm wondering if one for write posting and a different for write ordering
would be called for. These are really distinct uses but I'm not sure
it's a distinction that's clear to most folks and they will get misused.
If not, then io_mwb() would be my preference.

> versus
> 
> 	writel(high-water, request-in)
> 	spin_unlock_iob(hostlock)

More variants of spinlocks?
When to use and how to implement it become even less clear.

thanks,
grant
