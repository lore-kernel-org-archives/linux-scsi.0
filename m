From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 15:10:15 -0600
Message-ID: <1195593015.17601.10.camel@localhost.localdomain>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119.003802.100741794.davem@davemloft.net>
	 <1195501874.6539.5.camel@pasglop> <20071120082927.GA8856@alpha.franken.de>
	 <1195569362.3131.3.camel@localhost.localdomain> <adaabp8wuma.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:41056 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbXKTVKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 16:10:20 -0500
In-Reply-To: <adaabp8wuma.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk


On Tue, 2007-11-20 at 12:05 -0800, Roland Dreier wrote:
> > Actually, we already established on IRC that the lasi700 driver doesn't
>  > need this, principally because the parisc architecture doesn't do an
>  > invalidate for DMA_FROM_DEVICE but a flush and invalidate
>  > (architecturally, if you read our manuals, even pdc is entitled to write
>  > back dirty lines, so it's not clear there's actually an invalidate
>  > instruction we can use).   This is also one possible temporary fix for
>  > the other architectures if we can't get a different method to work
>  > nicely.
> 
> I think doing a writeback and invalidate is a very fragile way to deal
> with DMA into the middle of a data structure.  It may work OK for now,
> but you have to make sure forever into the future that no codepath
> anywhere else ever touches the cacheline that you're DMAing into while
> the DMA is pending.  It just leaves a hidden trap that is too easy to
> step on, because the architectures that get pretty much all testing
> all have cache-coherent DMA.
> 
> Reviving my ancient __dma_buffer patch seems far preferable to me.

We're talking about trying to fix this for 2.4; which is already at
-rc3 ... Is an entire arch change for dma alignment really a merge
candidate at this stage?

James


