From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: mac scsi, ncr5380
Date: Mon, 29 Sep 2008 23:22:36 +1000 (EST)
Message-ID: <Pine.LNX.4.64.0809292253510.8870@loopy.telegraphics.com.au>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
 <alpine.DEB.1.00.0809270439470.19669@zirkon.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.64.0809271359460.2612@loopy.telegraphics.com.au>
 <20080927191221.GA15755@cynthia.pants.nu> <Pine.LNX.4.64.0809281231120.15326@loopy.telegraphics.com.au>
 <20080928180341.GA28413@cynthia.pants.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loopy.telegraphics.com.au ([202.45.126.152]:45610 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYI2NWj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Sep 2008 09:22:39 -0400
In-Reply-To: <20080928180341.GA28413@cynthia.pants.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brad Boyer <flar@allandria.com>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>



On Sun, 28 Sep 2008, Brad Boyer wrote:

> > The Guide to Mac Family Hardware says that IRQ and DRQ are connected 
> > to the OSS. AFAICT, DRQ is wired to VIA2 CA2 on all machines that have 
> > VIA2/RBV.
> 
> The Guide also says that the PCR bits 1-3 on VIA2 are related to DRQ. Do 
> we know if we're setting the right values there?

Well, that is partly why I tested the Mac II, PB 150 and PB 190. On the PB 
150 (RBV) there is no PCR. But on the Mac II we have all of the relevant 
schematics and data, so I'm certain that we've set that correctly. The PB 
190 has a "quadra-style" VIA, so it is most likely set correctly there too 
(or so I like to think! Macsbug says PCR is 0 on both Mac II and PB 190 
which make no sense to me.)

>...
> The odd thing about the DRQ on the IIfx going to OSS is that the list in 
> mac_oss.h has defines for all 16 interrupt bits, and there's only one 
> for SCSI. My understanding is that the list was based on the A/UX 
> headers from Apple and should be accurate. I never tried to request one 
> of the IRQs in the set that we don't have claimed by any driver to see 
> if one of them really is the DRQ.

I just checked the oss.h A/UX header file and it agrees with mac_oss.h. 
But perhaps DRQ was unused by A/UX (although the SCSI DMA chip would have 
needed it)? That might explain why oss.h lists 3 unused IRQs. Or perhaps 
DRQ and IRQ lines from the NCR5380 core share the same OSS IRQ.

Finn
