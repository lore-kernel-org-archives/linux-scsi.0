From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 14:06:37 -0400
Message-ID: <1123869997.5546.98.camel@localhost.localdomain>
References: <OF33C7B841.0ED0EFDF-ON8825705B.00600DDB-8825705B.0060A40B@us.ibm.com>
	 <1123869071.3218.35.camel@laptopd505.fenrus.org>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:40411 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S1750716AbVHLSGs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 14:06:48 -0400
In-Reply-To: <1123869071.3218.35.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2005-08-12 at 19:51 +0200, Arjan van de Ven wrote:
> On Fri, 2005-08-12 at 10:35 -0700, Bryan Henderson wrote:
> > >>How much extra work does Linux have to do for each interrupt?
> > >
> > >usually 1 pci mmio read; the rest is negligible.
> > 
> > I was hoping you would cater better to my ignorance of how PCI interrupt 
> > handling works in Linux.
> > 
> > Is it the case that Linux invokes the registered interrupt handler of each 
> > of the drivers for the devices that share the interrupt, and each does an 
> > mmio read of its device to find out if it had reason to generate an 
> > interrupt?  So the waste is that extra call, and you're saying the CPU 
> > instructions involved are negligible compared to the mmio read?
> 
> yes. A function call is like half a cycle (a function pointer call is
> maybe 40) an mmio read is a lot more
 a bit off topic, but where u get these information? thx


> 
> > Are these level-sensitive interrupts, so that if both devices need service 
> > at the same time, they generate just one interrupt and neither device 
> > driver call is wasted?
> 
> ok this is more complex, but if 2 cards raise it quickly after
> eachother, before the ISR has run, then you only get the handler called
> once afaik.
so it is possible that both card raise intr quicker than isr run, then
both isr will do mmio and go ahead, but then what is

device 1 raise intr
device 2 isr run and not belong to it, so quit, but before it clear intr
and quit
device 2 raise intr
device 1 isr run and handle device 1, then clear intr and quit.

then device 2 intr lost?

or i understand this wrong. :)

ming


> 
> 
> 

