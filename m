From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 11:55:01 +1100
Message-ID: <1195520101.6970.28.camel@pasglop>
References: <1195501874.6539.5.camel@pasglop>
	 <20071119.143115.251022325.davem@davemloft.net>
	 <1195518864.6970.23.camel@pasglop>
	 <20071119.164611.64664648.davem@davemloft.net>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:34221 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbXKTAzV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 19:55:21 -0500
In-Reply-To: <20071119.164611.64664648.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk


On Mon, 2007-11-19 at 16:46 -0800, David Miller wrote:
> 
> 1) Require that entire buffers are commited by call sites,
>    and thus "embedding" DMA'd within non-DMA stuff isn't allowed
> 
> 2) Add the __dma_cacheline_aligned tag.
> 
> But note that with #2 it could get quite ugly because the
> alignment and size both have a minimum that needs to be
> enforced, not just the alignment alone.  So either:

Yup.

> struct foo {
>         unsigned int other_unrelated_stuff;
> 
>         struct object dma_thing __dma_cacheline_aligned;
> 
>         unsigned int more_nondma_stuff __dma_cacheline_aligned;
> };

In my tests, I had used a "fuckton_t" object defined to be an empty
thing with alignment constraint, seemed to work :-) But I'd rather
require #1.

BTW. What is the status nowadays with skb's ?

Cheers,
Ben.

