From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 19:51:10 +0200
Message-ID: <1123869071.3218.35.camel@laptopd505.fenrus.org>
References: <OF33C7B841.0ED0EFDF-ON8825705B.00600DDB-8825705B.0060A40B@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:25319 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750760AbVHLRvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 13:51:16 -0400
In-Reply-To: <OF33C7B841.0ED0EFDF-ON8825705B.00600DDB-8825705B.0060A40B@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, mingz@ele.uri.edu

On Fri, 2005-08-12 at 10:35 -0700, Bryan Henderson wrote:
> >>How much extra work does Linux have to do for each interrupt?
> >
> >usually 1 pci mmio read; the rest is negligible.
> 
> I was hoping you would cater better to my ignorance of how PCI interrupt 
> handling works in Linux.
> 
> Is it the case that Linux invokes the registered interrupt handler of each 
> of the drivers for the devices that share the interrupt, and each does an 
> mmio read of its device to find out if it had reason to generate an 
> interrupt?  So the waste is that extra call, and you're saying the CPU 
> instructions involved are negligible compared to the mmio read?

yes. A function call is like half a cycle (a function pointer call is
maybe 40) an mmio read is a lot more

> Are these level-sensitive interrupts, so that if both devices need service 
> at the same time, they generate just one interrupt and neither device 
> driver call is wasted?

ok this is more complex, but if 2 cards raise it quickly after
eachother, before the ISR has run, then you only get the handler called
once afaik.



