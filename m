From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: I/O write ordering
Date: Wed, 22 Sep 2004 10:50:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409221050.32314.jbarnes@engr.sgi.com>
References: <1095789421.2467.414.camel@mulgrave> <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk> <1095864049.6359.2.camel@gaston>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:49381 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S265978AbUIVOvM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 10:51:12 -0400
In-Reply-To: <1095864049.6359.2.camel@gaston>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Wednesday, September 22, 2004 10:40 am, Benjamin Herrenschmidt wrote:
> On Thu, 2004-09-23 at 00:32, Matthew Wilcox wrote:
> > I'd quite like to hear opinions from the PPC and Alpha people, they seem
> > to be the most out-of-order architectures.
>
> The more specific the barrier is, the happier we are on ppc so we can
> select the right one in our collection :)
>
> Write ordering is usually just a matter of eieio. _however_ the main
> problem we have is write ordering between two different storage classes,
> that is between cacheable space and non cacheable space. Our normal
> write ordering barrier will not order between those, thus causing all
> sorts of issues with devices mixing MMIO & DMA. We have to use a more
> heavy-weight barrier in those cases, but currently, linux lacks the
> proper abstraction for that, thus we had to clutter then normal MMIO
> writes to do the big barrier each time to be safe ...

Ok, mmiob() it is then.  Patch coming shortly (I'll post it to lkml).

As for write flushing, I guess we need to document that people should read a 
safe register (or config space if there isn't one, since that's guaranteed to 
soft fail).

Thanks,
Jesse
