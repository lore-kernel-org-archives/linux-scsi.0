From: ian <spyro@f2s.com>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Thu, 01 Nov 2007 09:48:46 +0000
Message-ID: <1193910526.25899.278.camel@wirenth>
References: <1193864605.25899.253.camel@wirenth>
	 <20071031213447.GF15111@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outmail1.freedom2surf.net ([194.106.33.237]:42655 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbXKAJvc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2007 05:51:32 -0400
In-Reply-To: <20071031213447.GF15111@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org

On Wed, 2007-10-31 at 15:34 -0600, Matthew Wilcox wrote:
> On Wed, Oct 31, 2007 at 09:03:24PM +0000, ian wrote:

> It's been three years since this API was introduced, and the only
> *merged* user is the one that James wrote.

Yes I appreciate that.

>   Now it's in the way of some
> performance improvements I want to make.  I can't possibly go round every
> little platform tree looking for users

Agreed - hence why Im taking the trouble to writ e to you now to let you
know the code is in use.

>  -- you need to get your drivers
> into mainline.  Yes, it's not necessarily a quick process, but equally,
> you've had three years.

I've been quite ill, which I admit is not anyone elses fault. Anyhow, to
business...

> Now, what driver is it that's going to consume this coherent memory?

all the TMIO based ASICs that have USB will need this support - thats
three different chips alone.

I believe the mediaQ chipset has similar constraints on its USB and
(IIRC) other devices.

Part of the problem is that these chips are multi-function devices and
as such it takes a lot longer to get all the drivers polished up to a
good state than it would for a single-function chip. I suppose
individual functions could be submitted seperately though.

> Does it use the dma_pool interface, or does it use dma_alloc_coherent
> directly?

At this point, I'd have to check - which I will be doing shortly - I've
jusrt started work on my toshiba devices again, although I started with
AC97, so it wont be right away.

>   If the latter, I can retain the dma_declare_coherent_memory
> interface.  If the former, then we have to come to a decision between
> supporting some drivers that are so unimportant that they haven't been
> merged in three years and making a performance win for drivers that are
> used every day.

As its the OHCI driver doing the allocation, I'd imagine the dma_pool
interface is the one in use.

> Admittedly, I haven't finished the work to make dma_pool use slub, thus
> I don't know what the performance win will turn out to be.

The specific problem for these devices is that they can only DMA to
their internal memory, and cant decode the 32 bit addresses of the bus
they sit on - so whilst they might be mapped at 0x800xxxxx , they see
their address space as being 0x00000 - 0xfffff (for example).

What might work would be if the dma pool interface could use a
device-specified allocator to service its requests, thus most stuff
would use slub (by default) and our devices could specify their own
allocator

>   It may not
> be significant, so it would be an easy decision to keep the interface.
> But if the decision is going to be to keep the interface despite the
> lack of users and no matter what the performance win, then I don't need
> to finish this work.

I dont mind what the interface is as long as we can support devices that
can only DMA from their own local RAM as described above...

:-)

