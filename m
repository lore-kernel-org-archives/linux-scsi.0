From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: mac scsi, ncr5380
Date: Sun, 28 Sep 2008 21:28:38 +1000 (EST)
Message-ID: <Pine.LNX.4.64.0809281231120.15326@loopy.telegraphics.com.au>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
 <alpine.DEB.1.00.0809270439470.19669@zirkon.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.64.0809271359460.2612@loopy.telegraphics.com.au>
 <20080927191221.GA15755@cynthia.pants.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loopy.telegraphics.com.au ([202.45.126.152]:44515 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYI1L2l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Sep 2008 07:28:41 -0400
In-Reply-To: <20080927191221.GA15755@cynthia.pants.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brad Boyer <flar@allandria.com>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>



On Sat, 27 Sep 2008, Brad Boyer wrote:

> .. the ideal situation would be to get the real DMA working (the IIfx is 
> the only Mac using a 5380 chip that has real DMA) which would mean 
> treating it as a separate machine anyway. If you want the details, doing 
> PDMA on the IIfx requires poking the DMA engine to get it out of the 
> way. I have the docs someplace.

Docs would be nice... although I can't test anything as I don't have that 
hardware. But aside from yourself, there's a user on the debian-68k list 
who has a IIfx.

> > > What are these unknown interrupts? DRQ? PDMA stalling?
> > 
> > The schematics say that only the NCR5380 drives that VIA input (VIA2 
> > CB2 aka IRQ_MAC_SCSI), so IRQ 19 is definitely the IRQ line from the 
> > chip (and not the DRQ line). The DRQ interrupt was/is never registered 
> > (BTW, I found that it doesn't fire on one of the PowerBooks).
> 
> I don't think we really know where the DRQ line is connected, if at all.

The Guide to Mac Family Hardware says that IRQ and DRQ are connected to 
the OSS. AFAICT, DRQ is wired to VIA2 CA2 on all machines that have 
VIA2/RBV.

>From looking at the NetBSD driver and The Guide, I think perhaps we're 
using the wrong address for PDMA I/O on the particular powerbook that 
didn't raise a DRQ interrupt. (The IIci memory map in The Guide shows 
several different SCSI memory regions including "pseudo-DMA with DRQ" and 
"pseudo-DMA, no DRQ".) Worst case, we'd have to poll DRQ in the status 
register as per existing code.

> That's actually the problem I had with getting the DMA on the IIfx 
> working. I never got the EOT interrupt from the DMA engine.

... that doesn't sound very promising.

The Guide says, "Using the SCSI DMA IC, only data transfers are handled by 
the DMA channel; SCSI bus protocol is under the control of software 
running on the main processor, just as it is on other Macintosh models. 
The SCSI DMA IC on the Macintosh IIfx can also function as a conventional 
SCSI interface and transfer data under the control of the main processor 
... Existing drivers that don't use hardware handshaking will run on the 
Macintosh IIfx as is. Drivers that do use hardware handshaking must be 
modified to set up the SCSI DMA for hardware handshaking in order to run 
on the Macintosh IIfx ... To initiate a DMA transfer, the SCSI driver 
writes control information to the DMA address counter and DMA Byte Count 
register on the SCSI DMA IC and then writes to one of the IC's start 
registers."

There is no detailed programming information unfortunately. But to me, it 
sounds like PDMA is not possible on the IIfx (there's also a comment in 
mac_scsi.c to that effect) so it seems we either attempt DMA again or use 
PIO (yuck).

Finn
