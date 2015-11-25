From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Wed, 25 Nov 2015 22:50:32 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511252132580.23266@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511242240.24959.linux@rainbow-software.org> <alpine.LNX.2.00.1511251246130.24439@nippy.intranet> <201511251004.10449.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:51408 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbbKYLum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2015 06:50:42 -0500
In-Reply-To: <201511251004.10449.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Wed, 25 Nov 2015, Ondrej Zary wrote:

> On Wednesday 25 November 2015, Finn Thain wrote:
> > 
> > On Tue, 24 Nov 2015, Ondrej Zary wrote:
> > 
> > > Instead of fixing split transfers, simply forced everything 
> > > non-modulo-128 to PIO:
> > 
> > [...]
> > I don't have any reason to think that your card will allow part of 
> > a transfer to be performed with PDMA and the rest with PIO. So I don't 
> > really object to the patch.
> > 

>From looking at the datasheet, I think your patch is correct.

Your patch needs to be applied after mine, so if you will sign-off, I'll 
include it in the series with your Signed-off-by and "From:" header.

> > But I don't understand the need for it either: I have no idea what 
> > state the driver, chip and scsi bus were in when the 126-byte PIO 
> > transfer failed. If the PIO transfer didn't succeed then the entire 
> > command should have failed.
> 
> The patch was just a quick hack to confirm that PDMA is not completely 
> broken.
> Now we know that it mostly works so I can investigate the partial PIO 
> problem.
> 

There may not be any problem to investigate. Because this 53C80 core is 
embedded in other logic, it's hard to say whether or not the partial PIO 
algorithm could be expected to work at all.

Besides, the DMA errata don't apply to this core. And large transfers will 
always be divisible by 128 bytes so there's very little to be gained.

> [...]
> 
> 53C400A datasheet would be great too but haven't found any.

I don't have one either.

-- 
