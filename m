From: Andi Kleen <ak@suse.de>
Subject: Re: GFP_DMA use in SCSI midlayer
Date: Sun, 1 Oct 2006 22:55:49 +0200
Message-ID: <200610012255.49802.ak@suse.de>
References: <200610012213.24123.ak@suse.de> <1159735218.3542.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:49105 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932330AbWJAUzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Oct 2006 16:55:55 -0400
In-Reply-To: <1159735218.3542.16.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Christoph Lameter <clameter@sgi.com>

On Sunday 01 October 2006 22:40, James Bottomley wrote:
> On Sun, 2006-10-01 at 22:13 +0200, Andi Kleen wrote:
> > GFP_DMA in general is deprecated and should be replaced by appropiate
> > dma_alloc_coherent()
> 
> Um, no it shouldn't
> 
> All of the places where we use GFP_DMA are because we might be
> addressing an ISA card or other strange mask limited card (gated usually
> by unchecked_isa_dma).  

This means the majority of drivers will never use it? I don't 
claim to be a SCSI expert, but a lot of uses looked unchecked
to me from a quick look. That is very worrying because it's
only 16MB on x86 and 16MB run out quickly.

If it's never used I don't care that much, but it certainly
doesn't look like that.

Or do you only need it because pci_map_single() on i386 doesn't
do bouncing?  If yes we can probably fix that.

> However, what is wanted in every case is 
> ordinary memory, not coherent memory.  They can't simply be replaced
> with dma_alloc_coherent because
> 
> a) it will waste memory for platforms that only do it in page size
> multiples
> b) It will fail on platforms that can't do it at all.

GFP_DMA will also fail on a lot of platforms, so it's the same.

> Coherent memory is really only for device drivers to use in mailboxes
> and shared ring buffers.

Maybe we need a new interface then with a mask. The plan is anyways
get rid of GFP_DMA completely because it has lots of problems. And 
any user should declare the mask it really needs.

-Andi
