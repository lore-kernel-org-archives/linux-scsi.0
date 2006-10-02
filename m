From: Andi Kleen <ak@suse.de>
Subject: Re: GFP_DMA use in SCSI midlayer
Date: Mon, 2 Oct 2006 21:18:46 +0200
Message-ID: <200610022118.46830.ak@suse.de>
References: <200610012213.24123.ak@suse.de> <200610012255.49802.ak@suse.de> <1159800770.3460.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58798 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S965355AbWJBTSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:18:51 -0400
In-Reply-To: <1159800770.3460.11.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Christoph Lameter <clameter@sgi.com>

On Monday 02 October 2006 16:52, James Bottomley wrote:
> On Sun, 2006-10-01 at 22:55 +0200, Andi Kleen wrote:
> > This means the majority of drivers will never use it? I don't 
> > claim to be a SCSI expert, but a lot of uses looked unchecked
> > to me from a quick look. That is very worrying because it's
> > only 16MB on x86 and 16MB run out quickly.
> 
> Yes, some cases it's used because the code can't be bothered to check to
> see if it's required ... these cases can be audited and cleaned up.

That would be useful.

> > If it's never used I don't care that much, but it certainly
> > doesn't look like that.
> > 
> > Or do you only need it because pci_map_single() on i386 doesn't
> > do bouncing?  If yes we can probably fix that.
> 
> Heh, that would be the worst place to fix it. We usually have use
> context for the allocation, so can sleep in the worst case.  We don't
> have such context where we do pci_map_single().

Ok then you'll likely want a new function that does this.

Do you always have a device or is a mask enough? 



> > > However, what is wanted in every case is 
> > > ordinary memory, not coherent memory.  They can't simply be replaced
> > > with dma_alloc_coherent because
> > > 
> > > a) it will waste memory for platforms that only do it in page size
> > > multiples
> > > b) It will fail on platforms that can't do it at all.
> > 
> > GFP_DMA will also fail on a lot of platforms, so it's the same.
> 
> No, at the moment it succeeds on all of them (although at odd locations,
> like on parisc GFP_DMA goes up to 4GB).

Not after Christoph's patchkit went in.

-Andi
