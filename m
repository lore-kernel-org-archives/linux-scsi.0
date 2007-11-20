From: Roland Dreier <rdreier@cisco.com>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Mon, 19 Nov 2007 18:10:14 -0800
Message-ID: <ada8x4ty8e1.fsf@cisco.com>
References: <1195501874.6539.5.camel@pasglop>
	<20071119.143115.251022325.davem@davemloft.net>
	<1195518864.6970.23.camel@pasglop>
	<20071119.164611.64664648.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56912 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760625AbXKTCKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 21:10:22 -0500
In-Reply-To: <20071119.164611.64664648.davem@davemloft.net> (David Miller's message of "Mon, 19 Nov 2007 16:46:11 -0800 (PST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

 > 2) Add the __dma_cacheline_aligned tag.
 > 
 > But note that with #2 it could get quite ugly because the
 > alignment and size both have a minimum that needs to be
 > enforced, not just the alignment alone.  So either:
 > 
 > struct foo {
 > 	unsigned int other_unrelated_stuff;
 > 
 > 	struct object dma_thing __dma_cacheline_aligned;
 > 
 > 	unsigned int more_nondma_stuff __dma_cacheline_aligned;
 > };
 > 
 > or:
 > 
 > struct foo {
 > 	unsigned int other_unrelated_stuff;
 > 
 > 	union {
 > 		struct object dma_thing __dma_cacheline_aligned;
 > 		char __pad[(sizeof(object) + DMA_CACHELINE_SIZE &
 > 			   ~DMA_CACHELINE_SIZE)];
 > 	} u;
 > 
 > 	unsigned int more_nondma_stuff __dma_cacheline_aligned;
 > };

I wrapped this ugliness up inside the macro back in what I posted in
2002 (http://lkml.org/lkml/2002/6/12/234):

#define __dma_buffer __dma_buffer_line(__LINE__)
#define __dma_buffer_line(line) __dma_buffer_expand_line(line)
#define __dma_buffer_expand_line(line) \
	__attribute__ ((aligned(L1_CACHE_BYTES))); \
	char __dma_pad_ ## line [0] __attribute__ ((aligned(L1_CACHE_BYTES)))

then you just need to tag the actual member like:

	char foo[3] __dma_buffer;

 - R.
