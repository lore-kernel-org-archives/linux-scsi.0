From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] aic7xxx: fix MMIO for PPC 44x platforms
Date: Sat, 12 Apr 2008 18:52:32 +0400
Message-ID: <4800CCB0.7010401@ru.mvista.com>
References: <200804092309.32130.sshtylyov@ru.mvista.com> <1207950070.5066.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h155.mvista.com ([63.81.120.155]:43886 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566AbYDLOxP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Apr 2008 10:53:15 -0400
In-Reply-To: <1207950070.5066.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

Hello.

James Bottomley wrote:

>>The driver stores the the PCI resource address into 'u_long' variable before
>>calling ioremap_nocache() on it. This warrants kernel oops when the registers
>>are accessed on PPC 44x platforms which (being 32-bit) have PCI memory space
>>mapped beyond 4 GB.

>>The arch/ppc/ kernel has a fixup in ioremap() that creates an illusion of the
>>PCI I/O and memory resources are mapped below 4 GB, but arch/powerpc/ code got

    Not I/O, just memory, of course. :-]
    Although PCI I/O space is mapped beyond 4 GB...

>>rid of this trick, having instead CONFIG_RESOURCES_64BIT enabled.

>>Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Well, all I can say about the architecture is: yuk!

    It's not alone, there's also Alchemy MIPS SOCs -- arch/mips/ still uses 
the ioremap() trick for their PCI space.

> However, if this is truly a problem, you only fixed half of it:

    A nice machine check occurs in the siimage driver on 44x due to the same 
issue.

> aic79xx_osm.h and aic79xx_osm_pci.c have the same problems.

    Yes, I can fix it in a separate patch.

> Also, your fixes don't look complete.  This statement in
> ahc_pci_map_registers(struct ahc_softc *ahc)

> 			ahc->bsh.ioport = base;

> Should be warning because bsh.ioport is still u_long and base should be
> u64 (so a truncation warning).

    No warnings, just silent truncation (as it was before the patch when the 
64-bit 'resource_size_t' result of pci_resource_start() was put into 'u_long' 
variable).  And since when C compilers warn about truncations due to implicit 
type converions? :-O

> I think the correct fix (unless you also
> have a ludicrous port space?) is simply to cast to (u_long).

    There's nothing to fix here I think. But if you insist I may add an 
explicit type cast...

>>-               printf("aic7xxx: PCI%d:%d:%d MEM region 0x%lx "
>>+               printf("aic7xxx: PCI%d:%d:%d MEM region 0x%llx "
>>                       "unavailable. Cannot memory map device.\n",
>>                       ahc_get_pci_bus(ahc->dev_softc),
>>                       ahc_get_pci_slot(ahc->dev_softc),
>>                       ahc_get_pci_function(ahc->dev_softc),
>>-                      base);
>>+                      (uint64_t)base);

> This isn't quite right: uint64_t is unsigned long on 64 bit platforms,

    However, 'unsigned long long' and 'unsigned long' are both 64-bit there.

> so it won't match %llx (you need it to be unsigned long long
> explicitly).

    OK.

>>@@ -398,7 +398,7 @@ ahc_pci_map_registers(struct ahc_softc *
>>                               ahc_get_pci_bus(ahc->dev_softc),
>>                               ahc_get_pci_slot(ahc->dev_softc),
>>                               ahc_get_pci_function(ahc->dev_softc),
>>-                              base);
>>+                              (u_long)base);

> This also isn't right ... you need to cast it to unsigned long long and
> use %llx in the printf.

    I can do that if you insist but truncation to u_long is safe for I/O ports...

> James

MBR, Sergei

