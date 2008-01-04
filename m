From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Fri, 04 Jan 2008 03:49:58 -0800 (PST)
Message-ID: <20080104.034958.179163488.davem@davemloft.net>
References: <20080103.150204.101269827.davem@davemloft.net>
	<Pine.LNX.4.64.0801041054130.27528@anakin>
	<Pine.LNX.4.64.0801042143001.17406@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59105
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbYADLt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2008 06:49:59 -0500
In-Reply-To: <Pine.LNX.4.64.0801042143001.17406@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fthain@telegraphics.com.au
Cc: geert@linux-m68k.org, linux-m68k@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, hch@infradead.org, macro@linux-mips.org, linux-scsi@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Fri, 4 Jan 2008 22:05:20 +1100 (EST)

> I have a partially written replacement for mac_esp. Unlike the other 
> NCR53C9x drivers it needs PIO or pseudo DMA depending on the machine -- so 
> it is not as straight-forward as jazz_esp. The new esp_scsi core assumes 
> DMA and doesn't support asynch transfers. But I'll try to get it finished 
> before 2.6.25 is released.

It does actually support such things.

You can hide it completely your ->irq_pending() handler.  Process any
pending pseudo DMA and return 0 until there is a pseudo DMA error or
the pseudo DMA is complete and the ESP is signalling an IRQ.
