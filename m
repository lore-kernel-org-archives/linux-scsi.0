From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: g_NCR5380 PDMA, was Re: [PATCH 0/6] ncr5380: Miscellaneous minor
 patches
Date: Sun, 19 Feb 2017 10:27:55 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1702191026310.7094@nippy.intranet>
References: <cover.1484523085.git.fthain@telegraphics.com.au> <201702162318.52483.linux@rainbow-software.org> <alpine.LNX.2.00.1702180934190.13115@nippy.intranet> <201702181210.08593.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40364 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdBRXZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Feb 2017 18:25:49 -0500
In-Reply-To: <201702181210.08593.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Sat, 18 Feb 2017, Ondrej Zary wrote:

> On Friday 17 February 2017 23:38:12 Finn Thain wrote:
> > On Thu, 16 Feb 2017, Ondrej Zary wrote:
> > > On Tuesday 31 January 2017 02:31:45 Finn Thain wrote:
> > > [...]
> > >
> > > > Are you trying to figure out which commands are going to 
> > > > disconnect during a transfer? This is really a function of the 
> > > > firmware in the target; there are no good heuristics AFAICT, so 
> > > > the PDMA algorithm has to be robust. mac_scsi has to cope with 
> > > > this too.
> > > >
> > > > Does the problem go away when you assign no IRQ? When 
> > > > instance->irq == NO_IRQ, the core driver will inhibit disconnect 
> > > > privileges.
> > >
> > > Yes, it seems to run fine with IRQ/disconnect disabled. With IRQ 
> > > enabled, "dd if=/dev/sr0 of=anything" stops after a while.
> >
> > When you say "stops", do you mean an infinite loop in 
> > generic_NCR5380_pread or does the loop complete (which would 
> > presumably leave the target stuck in DATA IN phase, and a scsi command 
> > timeout would probably follow after 30 seconds...)
> 
> I've added timeouts to the possibly-infinite loops. It times out waiting 
> for the host buffer to become ready.

In mac_scsi you'll find that the PDMA loop exploits the 15ms poll_politely 
time limit to give the target device time to catch up. You might want to 
do something similar.

> Then everything breaks. Now I found why: pread() returns without waiting 
> for the 53C80 registers to be ready.

Ouch! You can't return control to the core driver when the 53C80 core is 
unavailable. That would need special handling: the core driver would have 
to fail the scsi command and reset the device (and bus), based on the 
result you return from NCR5380_dma_recv_setup/NCR5380_dma_send_setup.

> Adding the wait allows to continue in PIO mode with "tag#0 switching to 
> slow handshake".
> 

I don't think this is the code path you want. The target isn't really 
broken. But yes, we could use PIO as a slow workaround for fragile PDMA 
logic.

> > > I get gated 53C80 IRQ, BASR=0x10, MODE=0x0e, STATUS=0x7c.
> >
> > You can use NCR5380_print() to get a decoded register dump.
> >
> > When I decode the above values I get,
> >
> > BASR   = 0x10 = BASR_IRQ
> > MODE   = 0x0e = MR_ENABLE_EOP_INTR | MR_MONITOR_BSY | MR_DMA_MODE
> > STATUS = 0x7c = SR_BSY | SR_REQ | SR_MSG | SR_CD | SR_IO
> >
> > Since BASR_PHASE_MATCH is not set, the interrupt is almost certainly a 
> > phase mismatch. The new phase is SR_MSG | SR_CD | SR_IO = PHASE_MSGIN, 
> > which shows that the target has given up on the DATA IN phase and is 
> > presumably trying to send a DISCONNECT message.
> 
> Looks you're right. The transfersize is 4096, i.e. 2 CD-ROM sectors. 
> When the 2nd sector is not ready in the drive internal buffer, the drive 
> probably disconnects which breaks the fragile pdma transfer. When the 
> transfersize is limited to 2048 bytes, the problem goes away.
> 

OK.

> The problem also went away with enabled interrupts because I had some 
> debug printks added which were slowing down the transfer enough for the 
> drive (SONY CDU-55S) to keep up and not disconnect. Got the same result 
> by inserting udelay(100) after each 128 byte block trasnferred in 
> pread().
> 

Well, yeah, if you change the timing and omit to mention that, as well as 
changing the spinlock_irq_save/restore pairs, then it's going to be 
difficult for me to make sense of your results. Anyway, I'm glad that you 
got to the bottom of this mystery.

> > > When I enable interrupts during PDMA (like the removed UNSAFE macro 
> > > did), the problems go away. I see an IRQ after each pread call.
> >

-- 
