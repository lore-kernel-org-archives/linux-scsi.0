From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [6/21] Remove unchecked_isa_dma in advansys.c
Date: Mon, 17 Nov 2008 20:32:01 +0900
Message-ID: <1226921521.8582.3.camel@localhost.localdomain>
References: <200811161211.212948789@firstfloor.org>
	 <20081115231106.686F43E661A@basil.firstfloor.org>
	 <1226854581.3556.14.camel@localhost.localdomain>
	 <20081116223308.GF6703@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37647 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303AbYKQLcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2008 06:32:07 -0500
In-Reply-To: <20081116223308.GF6703@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org

On Sun, 2008-11-16 at 23:33 +0100, Andi Kleen wrote:
> On Sun, Nov 16, 2008 at 11:56:21AM -0500, James Bottomley wrote:
> > > v2: use dma api for all allocations
> > 
> > Just a minute:  this is another driver where you allocate coherent
> > memory for the host structure but fail to use it for I/O as far as I can
> > tell.
> > 
> > What's going on here?  If this is just a ploy to get GFP_DMA memory,
> > then this isn't the way to do it.  Firstly, it doesn't seem to be needed
> 
> It's just that the structure was in GFP_DMA before due to unchecked_isa_dma
> so I wanted to do a equivalent convertion
> 
> > and secondly, coherent memory is hard (or impossible) to manufacture on
> > certain platforms.  You should only use it for DMA mailboxes and other
> > register exchanges between the device and main memory ... expanding its
> > use is asking for resource exhaustion.
> 
> It's not expanding it, in fact it lowers it because they allocate
> less in GFP_DMA now than with unchecked_isa_dma (e.g. no more commands
> and sense buffers)

but dma_alloc_coherent() isn't equivalent to an allocator with the
dma_mask on most platforms.  It is on x86 because that platform is fully
coherent, but on most others it's taking memory from a special coherent
pool.  This is the resource which can exhaust easily.

James


