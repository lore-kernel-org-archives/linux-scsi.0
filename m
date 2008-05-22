From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/4] revert the commit 22a9189f (cdrom: use kmalloced
 buffers instead of buffers on stack)
Date: Thu, 22 May 2008 10:13:31 +0900
Message-ID: <20080522095506E.tomof@acm.org>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080521221113.GA12695@alpha.franken.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:51078 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513AbYEVBOn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 21:14:43 -0400
In-Reply-To: <20080521221113.GA12695@alpha.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tsbogend@alpha.franken.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, akpm@linux-foundation.org, davem@davemloft.net

On Thu, 22 May 2008 00:11:13 +0200
tsbogend@alpha.franken.de (Thomas Bogendoerfer) wrote:

> On Tue, May 20, 2008 at 01:58:30PM +0900, FUJITA Tomonori wrote:
> > The goal of this patchset is reverting the commit
> > 22a9189fd073db3d03a4cf8b8c098aa207602de1 (cdrom: use kmalloced buffers
> > instead of buffers on stack).
> > 
> > http://lkml.org/lkml/2008/4/21/634
> > 
> > The commit is using kmalloced buffers for cdrom packet commands to
> > avoid stack corruption on non coherent platforms. But allocating a
> > small buffer like this is not nice (unnecessary complicity):
> > 
> > +	buffer = kmalloc(8, GFP_KERNEL);
> 
> If I read the bio code correctly with your patch non coherent system will
> be punished a lot more. bio_copy_kern will allocate a whole page for this
> 8 bytes. Please correct me, if I'm wrong otherwise I tend to NAK that 
> approach.

You read the block layer code correctly, but I don't think allocating
one page frame is expensive.

We still have many places to do DMA on stack and need to fix them.

There are still many places (scsi_execute users) in the scsi mid-layer
that uses stack addresses for DMA.

drivers/block/pktcdvd.c always uses stack addresses for DMA for
generic packets.

I don't think that using kmalloc/kfree all over the place is a good
idea. We have a mechanism to do I/Os via a temporary buffer for a
buffer that we can't do DMA against. This patch just uses the mechnism
instead of spreading kmalloc/kfree everywhere. Note that of course
this patch fixes the problems that I explained above.


> > If some architectures can't do DMA on stack, we also need to a new
> > queue_flag like QUEUE_FLAG_NO_DMA_ON_STACK in addtion of this
> > patchset.
> 
> DMA-mapping.txt tells that DMA on stack is forbidden. IMHO we either need
> to revoke that first or deal with it. 

Yeah, it would be better to postpone the 4th patch until we finish
this issue. But I guess that we have enough time to do that until the
next merge window.

DMA on stack is forbidden because of non coherent architecutes and
architectures can't uses stack addresses for DMA? What architectures
can't uses stack addresses for DMA? Would it be better to just forbid
using stack addresses for DMA on all the architectures at all times?
