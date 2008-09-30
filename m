From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: mac scsi, ncr5380
Date: Tue, 30 Sep 2008 18:40:25 +1000 (EST)
Message-ID: <Pine.LNX.4.64.0809301618510.22728@loopy.telegraphics.com.au>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
 <alpine.DEB.1.00.0809270439470.19669@zirkon.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.64.0809271359460.2612@loopy.telegraphics.com.au>
 <20080927191221.GA15755@cynthia.pants.nu> <Pine.LNX.4.64.0809281231120.15326@loopy.telegraphics.com.au>
 <20080928180341.GA28413@cynthia.pants.nu> <Pine.LNX.4.64.0809292253510.8870@loopy.telegraphics.com.au>
 <20080929231826.GB12252@cynthia.pants.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loopy.telegraphics.com.au ([202.45.126.152]:37555 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbYI3Ik1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 04:40:27 -0400
In-Reply-To: <20080929231826.GB12252@cynthia.pants.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brad Boyer <flar@allandria.com>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>



On Mon, 29 Sep 2008, Brad Boyer wrote:

> It's possible that macsbug isn't generating the right size load request 
> to make the chip happy. The 6522 is really just an 8 bit chip, and I 
> think the address decoder gets unhappy if you do a 16 or 32 bit 
> load/store.

I see.

> If [IRQ and DRQ] are really are wired to the same IRQ line on OSS, it 
> should have worked.

Right. From looking at the SCSI DMA ASIC datasheet, it's clear that DRQ 
never leaves the chip. So for PDMA we'd have to poll the status register 
in the NCR5380 logic cell. Same for models where IRQ_MAC_SCSIDRQ can't be 
made to work.

> ...I would have thought that using DMA without the DRQ would be 
> pointless.

The DRQ signal is wired internally to the DMA state machine. But yeah, if 
you couldn't get it to raise an EOP interrupt, it is pointless.

Finn
