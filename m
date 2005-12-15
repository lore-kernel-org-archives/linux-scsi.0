From: Michael Joosten <michael.joosten@c-lab.de>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws,	PCI	coherency	problem
Date: Thu, 15 Dec 2005 02:17:38 +0100
Message-ID: <43A0C432.5060109@c-lab.de>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com>	 <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave>	 <439E0112.1030801@sgi.com>  <439ECB2E.7070103@sgi.com>	 <1134485413.3356.2.camel@mulgrave> <439F0FD6.30701@sgi.com>	 <439FA708.9070508@c-lab.de> <1134581356.3278.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailserver.c-lab.de ([131.234.80.230]:25235 "EHLO
	mailserver.c-lab.de") by vger.kernel.org with ESMTP id S932503AbVLOBYA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 20:24:00 -0500
In-Reply-To: <1134581356.3278.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Michael Reed <mdr@sgi.com>, pazke@donpac.ru, linux-scsi@vger.kernel.org

James Bottomley wrote:

>>Well, the PIII board with both a 550 and a 800 MHz proc showed no 
>>difference, the driver just *works*, no failure in 20 runs.  It looks 
>>like the problem only shows up in the VISWS. Perhaps I try it again 
>>putting the QLA1080 in the 32bit slot, which is apparently not 
>>controlled by the Lithium, but rather a plain PIIX chip. And perhaps 
>>some other platform and chipset.
>>    
>>
>
>Yes, the PIO posting issue is VISWS only, I think.  Could you confirm
>that your original bug report was on a SMP VISWS, and could you try the
>tests over using a UP kernel on the VISWS?
>
>  
>
The original tests did run on a UP VISWS (single 800MHz PIII), but with 
SMP kernel. I can try and recompile the test kernel for UP, and/or stuff 
the old dual PIII 450MHz into the 320.

After some experiments I can say that:
1) no problems on PIV 3GHz, Intel 915G, ICH6, 1GB

2) UP kernel on VISWS single CPU, some "qla1280: ISP invalid handle" 
messages even during startup, after some time the fs-bench also gets 
stuck with some of these, resetting the adapter doesn't work, and after 
a few tries it just gets stuck and oopses.

What confuses me a little now is that I've some corrupted files, at 
least one not even on the same hard disk as the place for the fs-bench. 
Hmmmm.

3) MP kernel on VISWS, single CPU: either because it has warmed up or 
b/c of SMP, now it gets even stuck during the rc scripts...

4) MP kernel on VISWS, dual CPU: once it warmed up, the driver also failed.

Sooo, I'd think this is VISWS issue only, independent of MP or UP.

>Btw, the VisWS Linux port apparently uses non-coherent DMA.  Perhaps it
>should be switched to coherent DMA, as there could be bugs in that area
>with qla1280.

Aha, so we are back at coherence, but it's not MP, but DMA one...
(I'm not sure what is meant with DMA coherence - make sure that before a DMA transfer is started at least the related CPU cache lines (in the DMA address range) are written back?)
Have I actually mentioned that I already had started a discussion with Jesse Barnes (SGI) and Jes Sorenson before I posted in linux-scsi? He said on the topic:
>>>>
Jesse> Actually implementing them might be as easy as putting PIO reads from a 
Jesse> bridge register into the DMA unmap routines--that should guarantee 
Jesse> coherence.

Me>You probably mean pci_unmap_addr/_len() macros in asm-i386/pci.h, 
Me>according to i386/kernel/pci-dma.c ??
Me>But there isn't much to be found in asm-i386/mach-visws/lithium.h .

<<<<

Given the situation that the Lithium's chip documentation is lost, its probably back 
at introducing a 
#ifdef CONFIG_X86_VISWS
#define QLA_POSTED_PCI_FLUSH(mbx)  RD_REG_WORD(mbx)
#else
#define QLA_POSTED_PCI_FLUSH(mbx)
endif

and replace the previous 
RD_REG_WORD(&reg->mailbox4)
or add where's now the mmiowb() with 
QLA_POSTED_PCI_FLUSH(&reg->mailbox4)

in qla1280_32/64bit_start_scsi().

Could this chipset deficiency also explain why I had NO luck when trying to use a PCI graphics card for X11 instead of the frame buffer? The server either gets stuck in "write recombining range" (ELSA Gloria Synergy, Permedia) (i.e. the gfx driver module in Xorg/XFree86) or does not recognize the VBIOS and leaves a Matrox G450 largely uninitialized (X server runs, but monitor stays black and unsync'ed).

So long, Michael


