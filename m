From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Sat, 5 Jan 2008 16:07:30 +1100 (EST)
Message-ID: <Pine.LNX.4.64.0801051327430.24730@loopy.telegraphics.com.au>
References: <20080103.150204.101269827.davem@davemloft.net>
 <Pine.LNX.4.64.0801041054130.27528@anakin> <Pine.LNX.4.64.0801042143001.17406@loopy.telegraphics.com.au>
 <20080104.034958.179163488.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loopy.telegraphics.com.au ([202.45.126.152]:45201 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYAEFHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 00:07:31 -0500
In-Reply-To: <20080104.034958.179163488.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: geert@linux-m68k.org, linux-m68k@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, hch@infradead.org, macro@linux-mips.org, linux-scsi@vger.kernel.org



On Fri, 4 Jan 2008, David Miller wrote:

> From: Finn Thain <fthain@telegraphics.com.au>
> Date: Fri, 4 Jan 2008 22:05:20 +1100 (EST)
> 
> > I have a partially written replacement for mac_esp. Unlike the other 
> > NCR53C9x drivers it needs PIO or pseudo DMA depending on the machine -- so 
> > it is not as straight-forward as jazz_esp. The new esp_scsi core assumes 
> > DMA and doesn't support asynch transfers. But I'll try to get it finished 
> > before 2.6.25 is released.
> 
> It does actually support such things.

Does it? When I looked at this around 2.6.22, I found that esp_scsi would 
always negotiate sync transfers if the target supported that. PIO cannot 
do sync transfers, so I had to modify esp_scsi in order that the chip's 
Synchronous Offset register was set to zero (asynch).

> You can hide it completely your ->irq_pending() handler.  Process any 
> pending pseudo DMA and return 0 until there is a pseudo DMA error or the 
> pseudo DMA is complete and the ESP is signalling an IRQ.

I didn't attempt any processing in irq_pending. I'll look into it.

Finn

> -
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
