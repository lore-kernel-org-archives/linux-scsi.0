From: Brad Boyer <flar@allandria.com>
Subject: Re: mac scsi, ncr5380
Date: Sun, 28 Sep 2008 11:03:41 -0700
Message-ID: <20080928180341.GA28413@cynthia.pants.nu>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au> <alpine.DEB.1.00.0809270439470.19669@zirkon.biophys.uni-duesseldorf.de> <Pine.LNX.4.64.0809271359460.2612@loopy.telegraphics.com.au> <20080927191221.GA15755@cynthia.pants.nu> <Pine.LNX.4.64.0809281231120.15326@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [76.245.85.235] ([76.245.85.235]:58793 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYI1SEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Sep 2008 14:04:11 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809281231120.15326@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>

On Sun, Sep 28, 2008 at 09:28:38PM +1000, Finn Thain wrote:
> On Sat, 27 Sep 2008, Brad Boyer wrote:
> > .. the ideal situation would be to get the real DMA working (the IIfx is 
> > the only Mac using a 5380 chip that has real DMA) which would mean 
> > treating it as a separate machine anyway. If you want the details, doing 
> > PDMA on the IIfx requires poking the DMA engine to get it out of the 
> > way. I have the docs someplace.
> 
> Docs would be nice... although I can't test anything as I don't have that 
> hardware. But aside from yourself, there's a user on the debian-68k list 
> who has a IIfx.

The document on the SCSI-DMA chip for the IIfx is a pdf file that is
almost 3Meg. I can send you a copy if you want. I have a IIfx to test,
just not the time to spend writing the code.

> > > The schematics say that only the NCR5380 drives that VIA input (VIA2 
> > > CB2 aka IRQ_MAC_SCSI), so IRQ 19 is definitely the IRQ line from the 
> > > chip (and not the DRQ line). The DRQ interrupt was/is never registered 
> > > (BTW, I found that it doesn't fire on one of the PowerBooks).
> > 
> > I don't think we really know where the DRQ line is connected, if at all.
> 
> The Guide to Mac Family Hardware says that IRQ and DRQ are connected to 
> the OSS. AFAICT, DRQ is wired to VIA2 CA2 on all machines that have 
> VIA2/RBV.

The Guide also says that the PCR bits 1-3 on VIA2 are related to DRQ. Do
we know if we're setting the right values there? It doesn't document
what the individual settings of the bits do, but the Rockwell R6522 VIA
chip document has a chart for what the bits mean. It basically sets
if the line is really treated as an interrupt, and what type if so.
The comments in the code (via.c) suggest that different models use
different trigger types for these lines.

The odd thing about the DRQ on the IIfx going to OSS is that the list
in mac_oss.h has defines for all 16 interrupt bits, and there's only
one for SCSI. My understanding is that the list was based on the A/UX
headers from Apple and should be accurate. I never tried to request
one of the IRQs in the set that we don't have claimed by any driver
to see if one of them really is the DRQ.

> From looking at the NetBSD driver and The Guide, I think perhaps we're 
> using the wrong address for PDMA I/O on the particular powerbook that 
> didn't raise a DRQ interrupt. (The IIci memory map in The Guide shows 
> several different SCSI memory regions including "pseudo-DMA with DRQ" and 
> "pseudo-DMA, no DRQ".) Worst case, we'd have to poll DRQ in the status 
> register as per existing code.

Quite possible. We have 3 memory ranges for the 5380 chip on all systems.
Maybe they switched which one asserted DRQ on some models.

> > That's actually the problem I had with getting the DMA on the IIfx 
> > working. I never got the EOT interrupt from the DMA engine.
> 
> ... that doesn't sound very promising.
> 
> The Guide says, "Using the SCSI DMA IC, only data transfers are handled by 
> the DMA channel; SCSI bus protocol is under the control of software 
> running on the main processor, just as it is on other Macintosh models. 
> The SCSI DMA IC on the Macintosh IIfx can also function as a conventional 
> SCSI interface and transfer data under the control of the main processor 
> ... Existing drivers that don't use hardware handshaking will run on the 
> Macintosh IIfx as is. Drivers that do use hardware handshaking must be 
> modified to set up the SCSI DMA for hardware handshaking in order to run 
> on the Macintosh IIfx ... To initiate a DMA transfer, the SCSI driver 
> writes control information to the DMA address counter and DMA Byte Count 
> register on the SCSI DMA IC and then writes to one of the IC's start 
> registers."
> 
> There is no detailed programming information unfortunately. But to me, it 
> sounds like PDMA is not possible on the IIfx (there's also a comment in 
> mac_scsi.c to that effect) so it seems we either attempt DMA again or use 
> PIO (yuck).

Everything I've read says that regular MacOS uses PDMA on the IIfx. Only
A/UX had a proper driver to use the DMA. The document I have is pretty
detailed, although it's hard to be sure how complete it is. There definitely
are parts of the document that mention PDMA, so it should be possible with
some IIfx specific code. It might be easier to get the real DMA working
since finding the DRQ is likely to be the real issue either way.

	Brad Boyer
	flar@allandria.com

