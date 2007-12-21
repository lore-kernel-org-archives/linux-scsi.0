From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] DMA buffer alignment annotations
Date: Sat, 22 Dec 2007 08:25:41 +1100
Message-ID: <1198272341.6737.12.camel@pasglop>
References: <20071221023010.C56B7DDDF3@ozlabs.org>
	 <20071221093905.GB31115@flint.arm.linux.org.uk>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:55446 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbXLUV2j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 16:28:39 -0500
In-Reply-To: <20071221093905.GB31115@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org


On Fri, 2007-12-21 at 09:39 +0000, Russell King wrote:

> > +#ifndef ARCH_MIN_DMA_ALIGNMENT
> > +#define __dma_aligned
> > +#define __dma_buffer
> > +#else
> > +#define __dma_aligned	  	__attribute__((aligned(ARCH_MIN_DMA_ALIGNMENT)))
> > +#define __dma_buffer		__dma_buffer_line(__LINE__)
> > +#define __dma_buffer_line(line)	__dma_aligned;\
> > +				char __dma_pad_##line[0] __dma_aligned
> 
> You introduce __dma_buffer_line() if ARCH_MIN_DMA_ALIGNMENT is set but
> not if it isn't...

Yup, it's not meant to be used outside of __dma_buffer...

 .../...

> > +then dev->buffer will be safe for DMA on all architectures.  On a
> > +cache-coherent architecture the members of dev will be aligned exactly
> > +as they would have been without __dma_buffer; on a non-cache-coherent
> > +architecture buffer and field2 will be aligned so that buffer does not
> > +share a cache line with any other data.
> > +
> 
> ... but it's not described.  What's the purpose of it, and why would it
> only be used on CPUs with ARCH_MIN_DMA_ALIGNMENT set?

Hrm, I'm not the best at writing exlanations, care to send a patch ? :-)

Cheers,
Ben


