From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 06:51:14 +1100
Message-ID: <1195501874.6539.5.camel@pasglop>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119.003802.100741794.davem@davemloft.net>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:59760 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbXKSTvp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 14:51:45 -0500
In-Reply-To: <20071119.003802.100741794.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk


On Mon, 2007-11-19 at 00:38 -0800, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Mon, 19 Nov 2007 16:35:23 +1100
> 
> > I'm not sure what is the best way to fix that. Internally, I've done
> > some test whacking some ____cacheline_aligned in the scsi_cmnd data
> > structure to verify I no longer get random SLAB corruption when using my
> > USB but that significantly bloats the size of the structure on archs
> > such as ppc64 that don't need it and have a large cache line size.
> > 
> > Unfortunately, I don't think there's any existing Kconfig symbol or arch
> > provided #define to tell us that we are on a non-coherent arch afaik
> > that could be used to make that conditional.
> > 
> > Another option would be to kmalloc the buffer (wasn't it the case before
> > btw ?) but I suppose some people will scream at the idea due to how the
> > command pools are done...
> 
> You could make a ____dma_cacheline_aligned and use that.
> It seems pretty reasonable.

I was thinking about that. What archs would need it ? arm, mips, what
else ?

Cheers,
Ben.

