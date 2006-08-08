From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Add Promise SuperTrak EX 'stex' driver
Date: Tue, 08 Aug 2006 18:26:16 -0500
Message-ID: <1155079576.26517.91.camel@mulgrave.il.steeleye.com>
References: <20060808120507.GA20032@havoc.gtf.org>
	 <1155053479.26517.20.camel@mulgrave.il.steeleye.com>
	 <44D91667.8030000@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:58516 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965075AbWHHX0h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Aug 2006 19:26:37 -0400
In-Reply-To: <44D91667.8030000@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, promise_linux@promise.com, akpm@osdl.org

On Tue, 2006-08-08 at 18:55 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > On Tue, 2006-08-08 at 08:05 -0400, Jeff Garzik wrote:
> >> Adds the 'stex' driver for Promise SuperTrak EX storage controllers.
> >> These controllers present themselves as SCSI, though like 3ware,
> >> megaraid and others, the underlying storage may or may not be SCSI.
> >>
> >> As discussed, the block tagging stuff is a post-merge todo item.
> > 
> > That's not exactly my recollection of the discussion:  I thought we were
> > still discussing the chicken and egg issue (which is we have APIs to do
> > this per host tagging which stex duplicates on the grounds no-one's
> > using the current APIs).  Jens and I seem to be in agreement that stex
> > should try the API's and well make any changes that become necessary to
> > block or SCSI happen.
> 
> Please re-read the end of the thread.  The last word was "ok, let's go 
> ahead and get this merged."

Those weren't my last words ...

However, I'll take on some of this ... I'll convert the aic7xxx driver
which is our current shared host tag driver ... then you only need copy
it to do stex.

> > The error return here looks like it shouldn't be DID_ERROR either.  I
> > assume the error is a format one and uncorrectable by a retry?
> 
> There is only one 'case INQUIRY' in the entire driver, so I assume you 
> accidentally responded to the same code segment twice.

No, sorry, misquoted ... the above comment applies to the case
PASSTHRU_CMD, which has the same problem (it would repeat a malformed
command).

> > This should be dma_alloc_coherent, not pci_alloc_consistent.
> 
> This is perfectly normal and proper in a PCI-only driver.  pci_xxx is 
> not a deprecated API, it is a convenience API.
> 
> Using dma_xxx only causes needless work.

What work?  it's an exact drop in replacement.  However, the only usage
of pci_xxx I'm requiring to be fixed is the pci_alloc_consistent,
primarily because pci_alloc_consistent *is* deprecated: it forces a
GFP_ATOMIC allocation of a potentially large amount of data.
dma_alloc_coherent allows you to specify gfp flags, which, in this case,
should be GFP_KERNEL.

James


