From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 22/71] ncr5380: Eliminate selecting state
Date: Sun, 29 Nov 2015 11:46:03 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511291034460.18868@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511262035.40920.linux@rainbow-software.org> <alpine.LNX.2.00.1511270930280.723@nippy.intranet> <201511290013.06581.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201511290013.06581.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 29 Nov 2015, Ondrej Zary wrote:

> > [...] I think that this should solve the problem:
> 
> Yes, it does!
> 
> [   48.119367] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_DMA_FIXUP }, options { AUTOPROBE_IRQ PSEUDO_DMA }
> [   49.715388] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS

That still takes about 1.6 seconds to scan a vacant bus ID. It should be 
more like 0.25 seconds. Did you have the entire patch series applied?

The code presently in mainline spins for 500 iterations in the relevant 
busy-wait loop, with the comment, "8uS a cycle for the cpu access". That 
doesn't help me much. Does that refer to an ISA bus cycle? Or one 
iteration of the loop? Electrical conductance?

If we knew how many loops_per_jiffy your machine gets, and your CONFIG_HZ 
value, we could figure out how long a chip register access takes (which 
might be 8 us).

I'll try to figure out a similar timing for my Domex PCI card to see if 
there is some sort of compromise to be found.

-- 
