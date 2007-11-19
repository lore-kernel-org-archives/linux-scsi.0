From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 08:55:20 +1100
Message-ID: <1195509320.6970.9.camel@pasglop>
References: <1195450523.7022.37.camel@pasglop>  <adapry5ykps.fsf@cisco.com>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:49196 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXKSVz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 16:55:56 -0500
In-Reply-To: <adapry5ykps.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>


On Mon, 2007-11-19 at 13:43 -0800, Roland Dreier wrote:
> > I've been debugging various issues on the PowerPC 44x embedded
>  > architecture which happens to have non-coherent PCI DMA.
>  > 
>  > One of the problem I'm hitting is that one really need to enforce
>  > kmalloc alignement to cache lines or bad things will happen (among
>  > others with USB), for some reasons, powerpc failed to do so, I fixed it.
> 
> Heh... I hit the same problem literally 5 years ago:
>     http://lwn.net/Articles/1783/
> 
> I implemented the __dma_buffer annotation:
>     http://lwn.net/Articles/2269/
> 
> But DaveM said we should just use the PCI pool code instead:
>     http://lwn.net/Articles/2270/

Heh, well... 

In this case, DaveM just proposed something akin to your
__dma_buffer :-)

On the other hand, after discussing with James, it looks like we'll just
be reverting the patch that removed the kmalloc of the sense buffer
since non cache-coherent archs are supposed to enforce kmalloc alignment
to cache lines.

__dma_buffer still seems like a good thing to have if too many other
drivers are hitting that but for this specific problem, it's not the
approach that we'll be taking.

Cheers,
Ben.


