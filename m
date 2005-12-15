From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws,	PCI	coherency	problem
Date: Wed, 14 Dec 2005 18:20:21 -0800
Message-ID: <20051215022021.GC192359@sgi.com>
References: <439A17BE.5000904@sgi.com> <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave> <439E0112.1030801@sgi.com> <439ECB2E.7070103@sgi.com> <1134485413.3356.2.camel@mulgrave> <439F0FD6.30701@sgi.com> <439FA708.9070508@c-lab.de> <1134581356.3278.1.camel@mulgrave> <43A0C432.5060109@c-lab.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:4292 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030290AbVLOCUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 21:20:38 -0500
Content-Disposition: inline
In-Reply-To: <43A0C432.5060109@c-lab.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Joosten <michael.joosten@c-lab.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Michael Reed <mdr@sgi.com>, pazke@donpac.ru, linux-scsi@vger.kernel.org

On Thu, Dec 15, 2005 at 02:17:38AM +0100, Michael Joosten wrote:
> >Btw, the VisWS Linux port apparently uses non-coherent DMA.  Perhaps it
> >should be switched to coherent DMA, as there could be bugs in that area
> >with qla1280.
> 
> Aha, so we are back at coherence, but it's not MP, but DMA one...
> (I'm not sure what is meant with DMA coherence - make sure that before a 
> DMA transfer is started at least the related CPU cache lines (in the DMA 
> address range) are written back?)

For a start.  You need to invalidate before read into memory and write
back before write to disk.  You also need to make sure that the memory
stays out of the CPU cache during the DMA (so you need to make sure that
when you DMA into memory that nothing is loading or storing to a cacheline
that you're DMA'ing into.  On a speculative execution CPU, this is really
hard.

> Have I actually mentioned that I already had started a discussion with 
> Jesse Barnes (SGI) and Jes Sorenson before I posted in linux-scsi? He said 
> on the topic:
> >>>>
> Jesse> Actually implementing them might be as easy as putting PIO reads 
> from a Jesse> bridge register into the DMA unmap routines--that should 
> guarantee Jesse> coherence.

That's a different problem.  The interrupt doesn't guarantee a PCI
DMA completion.  The PIO read will, however (according to Lithium
spec).

> Me>You probably mean pci_unmap_addr/_len() macros in asm-i386/pci.h, 
> Me>according to i386/kernel/pci-dma.c ??
> Me>But there isn't much to be found in asm-i386/mach-visws/lithium.h .

No.  There is a Device Control register for each PCI device.  Bit
10 controls whether DMA for that device is coherent.  If 0 it's
not coherent.  If 1, coherent.

> <<<<
> 
> Given the situation that the Lithium's chip documentation is lost, its 
> probably back at introducing a 
> #ifdef CONFIG_X86_VISWS
> #define QLA_POSTED_PCI_FLUSH(mbx)  RD_REG_WORD(mbx)
> #else
> #define QLA_POSTED_PCI_FLUSH(mbx)
> endif
> 
> and replace the previous 
> RD_REG_WORD(&reg->mailbox4)
> or add where's now the mmiowb() with 
> QLA_POSTED_PCI_FLUSH(&reg->mailbox4)
> 
> in qla1280_32/64bit_start_scsi().

We're going to work on an API change to mmiowb() instead.

> Could this chipset deficiency also explain why I had NO luck when trying to 
> use a PCI graphics card for X11 instead of the frame buffer? The server 
> either gets stuck in "write recombining range" (ELSA Gloria Synergy, 
> Permedia) (i.e. the gfx driver module in Xorg/XFree86) or does not 
> recognize the VBIOS and leaves a Matrox G450 largely uninitialized (X 
> server runs, but monitor stays black and unsync'ed).

It's possible.

> So long, Michael

jeremy
