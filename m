From: Brad Boyer <flar@allandria.com>
Subject: Re: mac scsi, ncr5380
Date: Sat, 27 Sep 2008 12:12:21 -0700
Message-ID: <20080927191221.GA15755@cynthia.pants.nu>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au> <alpine.DEB.1.00.0809270439470.19669@zirkon.biophys.uni-duesseldorf.de> <Pine.LNX.4.64.0809271359460.2612@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [76.245.85.235] ([76.245.85.235]:43454 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbYI0TMp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2008 15:12:45 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809271359460.2612@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>

On Sat, Sep 27, 2008 at 06:00:10PM +1000, Finn Thain wrote:
> On Sat, 27 Sep 2008, Michael Schmitz wrote:
> > > The fall back succeeds only on the powerbook 190 and only if the code 
> > > was compiled with gcc-3. It just hangs on the PB 150 and Mac II, 
> > > though PIO works on those machines too when PDMA is disabled. So I 
> > > think there's a race there somewhere. And PIO doesn't work anywhere 
> > > once debugging printks are enabled.
> > 
> > I've worked around that in the past by hooking into the Mac level 7 
> > interrupt, listing the driver state from the NMI post-mortem. (Actually 
> > I did that on the old Mac ESP driver, but the same sort of hack should 
> > apply. ESP was a lot more debug friendly though ...)
> 
> OK. But PIO shouldn't be timing sensitive, right? Anyway, I don't want to 
> get sidetracked with PIO.. unless there are macs that can't do PDMA.

As usual, there are exceptions. However, it's not as bad as it could
be. The IIfx can do PDMA, but it doesn't do it in exactly the same
way. Like so much else on the IIfx, the SCSI chip isn't quite like
the others. The ideal situation would be to get the real DMA working
(the IIfx is the only Mac using a 5380 chip that has real DMA) which
would mean treating it as a separate machine anyway. If you want the
details, doing PDMA on the IIfx requires poking the DMA engine to
get it out of the way. I have the docs someplace.

> > What are these unknown interrupts? DRQ? PDMA stalling?
> 
> The schematics say that only the NCR5380 drives that VIA input (VIA2 CB2 
> aka IRQ_MAC_SCSI), so IRQ 19 is definitely the IRQ line from the chip (and 
> not the DRQ line). The DRQ interrupt was/is never registered (BTW, I found 
> that it doesn't fire on one of the PowerBooks).

I don't think we really know where the DRQ line is connected, if at all.
That's actually the problem I had with getting the DMA on the IIfx
working. I never got the EOT interrupt from the DMA engine.

> Thanks. I don't know if PIO will be needed though?

My understanding of the NCR5380.c driver is that there are some cases
that use PIO even in the presence of DMA or PDMA support.

	Brad Boyer
	flar@allandria.com

