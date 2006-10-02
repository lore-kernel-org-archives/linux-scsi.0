From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: GFP_DMA use in SCSI midlayer
Date: Mon, 02 Oct 2006 09:52:49 -0500
Message-ID: <1159800770.3460.11.camel@mulgrave.il.steeleye.com>
References: <200610012213.24123.ak@suse.de>
	 <1159735218.3542.16.camel@mulgrave.il.steeleye.com>
	 <200610012255.49802.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:39563 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932453AbWJBOw6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 10:52:58 -0400
In-Reply-To: <200610012255.49802.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org, Christoph Lameter <clameter@sgi.com>

On Sun, 2006-10-01 at 22:55 +0200, Andi Kleen wrote:
> This means the majority of drivers will never use it? I don't 
> claim to be a SCSI expert, but a lot of uses looked unchecked
> to me from a quick look. That is very worrying because it's
> only 16MB on x86 and 16MB run out quickly.

Yes, some cases it's used because the code can't be bothered to check to
see if it's required ... these cases can be audited and cleaned up.

> If it's never used I don't care that much, but it certainly
> doesn't look like that.
> 
> Or do you only need it because pci_map_single() on i386 doesn't
> do bouncing?  If yes we can probably fix that.

Heh, that would be the worst place to fix it. We usually have use
context for the allocation, so can sleep in the worst case.  We don't
have such context where we do pci_map_single().

> > However, what is wanted in every case is 
> > ordinary memory, not coherent memory.  They can't simply be replaced
> > with dma_alloc_coherent because
> > 
> > a) it will waste memory for platforms that only do it in page size
> > multiples
> > b) It will fail on platforms that can't do it at all.
> 
> GFP_DMA will also fail on a lot of platforms, so it's the same.

No, at the moment it succeeds on all of them (although at odd locations,
like on parisc GFP_DMA goes up to 4GB).


> > Coherent memory is really only for device drivers to use in
> mailboxes
> > and shared ring buffers.
> 
> Maybe we need a new interface then with a mask. The plan is anyways
> get rid of GFP_DMA completely because it has lots of problems. And 
> any user should declare the mask it really needs.

Well ... possibly; either that or just let the SG only paths take care
of it.

James


