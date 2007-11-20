From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 11:34:24 +1100
Message-ID: <1195518864.6970.23.camel@pasglop>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119.003802.100741794.davem@davemloft.net>
	 <1195501874.6539.5.camel@pasglop>
	 <20071119.143115.251022325.davem@davemloft.net>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:58834 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbXKTAey (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 19:34:54 -0500
In-Reply-To: <20071119.143115.251022325.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk


On Mon, 2007-11-19 at 14:31 -0800, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 20 Nov 2007 06:51:14 +1100
> 
> > On Mon, 2007-11-19 at 00:38 -0800, David Miller wrote:
> > > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Date: Mon, 19 Nov 2007 16:35:23 +1100
> > > 
> > > You could make a ____dma_cacheline_aligned and use that.
> > > It seems pretty reasonable.
> > 
> > I was thinking about that. What archs would need it ? arm, mips, what
> > else ?
> 
> The sparc32 port would need it too.

James preference seem to go for a revert of the patch that removed the
kmalloc of the buffer instead. Sounds definitely like an easier plan
for .24 (and maybe even backport to stable).

I'll produce a patch for that later today or tomorrow.

Do you still think we should introduce this __dma_cacheline_aligned ? Do
you see other cases of drivers where it would be useful ? It tend to
agree with your earlier statement that drivers doing that are broken and
should be using a separate allocator for DMA'ble objects (in fact, on
non-cache coherent archs, kmalloc is just fine).

Cheers,
Ben.


