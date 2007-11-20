From: David Miller <davem@davemloft.net>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Mon, 19 Nov 2007 16:46:11 -0800 (PST)
Message-ID: <20071119.164611.64664648.davem@davemloft.net>
References: <1195501874.6539.5.camel@pasglop>
	<20071119.143115.251022325.davem@davemloft.net>
	<1195518864.6970.23.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54231
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbXKTAqL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 19:46:11 -0500
In-Reply-To: <1195518864.6970.23.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: benh@kernel.crashing.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 20 Nov 2007 11:34:24 +1100

> Do you still think we should introduce this __dma_cacheline_aligned ? Do
> you see other cases of drivers where it would be useful ? It tend to
> agree with your earlier statement that drivers doing that are broken and
> should be using a separate allocator for DMA'ble objects (in fact, on
> non-cache coherent archs, kmalloc is just fine).

I don't care either way.

If we say that the DMA api works on "DMA cacheline boundaries"
(and in reality it does) we do need to either:

1) Require that entire buffers are commited by call sites,
   and thus "embedding" DMA'd within non-DMA stuff isn't allowed

2) Add the __dma_cacheline_aligned tag.

But note that with #2 it could get quite ugly because the
alignment and size both have a minimum that needs to be
enforced, not just the alignment alone.  So either:

struct foo {
	unsigned int other_unrelated_stuff;

	struct object dma_thing __dma_cacheline_aligned;

	unsigned int more_nondma_stuff __dma_cacheline_aligned;
};

or:

struct foo {
	unsigned int other_unrelated_stuff;

	union {
		struct object dma_thing __dma_cacheline_aligned;
		char __pad[(sizeof(object) + DMA_CACHELINE_SIZE &
			   ~DMA_CACHELINE_SIZE)];
	} u;

	unsigned int more_nondma_stuff __dma_cacheline_aligned;
};

I hope you see what I'm trying to say.
