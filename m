From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 13:35:55 +1100
Message-ID: <1195526155.6970.32.camel@pasglop>
References: <1195501874.6539.5.camel@pasglop>
	 <20071119.143115.251022325.davem@davemloft.net>
	 <1195518864.6970.23.camel@pasglop>
	 <20071119.164611.64664648.davem@davemloft.net>  <ada8x4ty8e1.fsf@cisco.com>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:35714 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXKTCgW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 21:36:22 -0500
In-Reply-To: <ada8x4ty8e1.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk


On Mon, 2007-11-19 at 18:10 -0800, Roland Dreier wrote:
> 
> I wrapped this ugliness up inside the macro back in what I posted in
> 2002 (http://lkml.org/lkml/2002/6/12/234):
> 
> #define __dma_buffer __dma_buffer_line(__LINE__)
> #define __dma_buffer_line(line) __dma_buffer_expand_line(line)
> #define __dma_buffer_expand_line(line) \
>         __attribute__ ((aligned(L1_CACHE_BYTES))); \
>         char __dma_pad_ ## line [0] __attribute__
> ((aligned(L1_CACHE_BYTES)))
> 
> then you just need to tag the actual member like:
> 
>         char foo[3] __dma_buffer;

That's actually not too bad ... 

I'm having a problem with reverting SCSI to use an allocation for the
sense buffer, because it can fail and the new scso_eh_prep_cmnd() isn't
supposed to return a failure. I've changed that but now I get into
trying to fix the various drivers that use it without checking the
result code and it's becoming much more complicated than initially
thought.

So I may do the above instead and revive your patch.

Any objection ? James ? David ?

Cheers,
Ben.


