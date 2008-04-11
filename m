From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] aic7xxx: fix MMIO for PPC 44x platforms
Date: Fri, 11 Apr 2008 17:41:09 -0400
Message-ID: <1207950070.5066.44.camel@localhost.localdomain>
References: <200804092309.32130.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59534 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177AbYDKVlP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2008 17:41:15 -0400
In-Reply-To: <200804092309.32130.sshtylyov@ru.mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

On Wed, 2008-04-09 at 23:09 +0400, Sergei Shtylyov wrote:
> The driver stores the the PCI resource address into 'u_long' variable before
> calling ioremap_nocache() on it. This warrants kernel oops when the registers
> are accessed on PPC 44x platforms which (being 32-bit) have PCI memory space
> mapped beyond 4 GB.
> 
> The arch/ppc/ kernel has a fixup in ioremap() that creates an illusion of the
> PCI I/O and memory resources are mapped below 4 GB, but arch/powerpc/ code got
> rid of this trick, having instead CONFIG_RESOURCES_64BIT enabled.
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Well, all I can say about the architecture is: yuk!

However, if this is truly a problem, you only fixed half of it:
aic79xx_osm.h and aic79xx_osm_pci.c have the same problems.

Also, your fixes don't look complete.  This statement in
ahc_pci_map_registers(struct ahc_softc *ahc)

			ahc->bsh.ioport = base;

Should be warning because bsh.ioport is still u_long and base should be
u64 (so a truncation warning).  I think the correct fix (unless you also
have a ludicrous port space?) is simply to cast to (u_long).


> -               printf("aic7xxx: PCI%d:%d:%d MEM region 0x%lx "
> +               printf("aic7xxx: PCI%d:%d:%d MEM region 0x%llx "
>                        "unavailable. Cannot memory map device.\n",
>                        ahc_get_pci_bus(ahc->dev_softc),
>                        ahc_get_pci_slot(ahc->dev_softc),
>                        ahc_get_pci_function(ahc->dev_softc),
> -                      base);
> +                      (uint64_t)base);

This isn't quite right: uint64_t is unsigned long on 64 bit platforms,
so it won't match %llx (you need it to be unsigned long long
explicitly).

> @@ -398,7 +398,7 @@ ahc_pci_map_registers(struct ahc_softc *
>                                ahc_get_pci_bus(ahc->dev_softc),
>                                ahc_get_pci_slot(ahc->dev_softc),
>                                ahc_get_pci_function(ahc->dev_softc),
> -                              base);
> +                              (u_long)base);

This also isn't right ... you need to cast it to unsigned long long and
use %llx in the printf.

James


