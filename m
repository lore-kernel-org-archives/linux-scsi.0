From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Tue, 24 Nov 2015 20:13:17 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511241932130.7196@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511232355.04017.linux@rainbow-software.org> <alpine.LNX.2.00.1511241219430.28883@nippy.intranet> <201511240904.55085.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <201511240904.55085.linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 24 Nov 2015, Ondrej Zary wrote:

> On Tuesday 24 November 2015, Finn Thain wrote:
> > 
> > On Mon, 23 Nov 2015, Ondrej Zary wrote:
> > 
> > > 
> > > PDMA seems to be broken in multiple ways. NCR5380_pread cannot 
> > > process less than 128 bytes. In fact, 53C400 datasheet says that 
> > > it's HW limitation: non-modulo-128-byte transfers should use PIO.
> > > 
> > > Adding
> > >         transfersize = round_down(transfersize, 128);
> > > to generic_NCR5380_dma_xfer_len() improves the situation a bit.
> > > 
> > > After modprobe, some small reads (8, 4, 24 and 64 bytes) are done 
> > > using PIO, then eight 512-byte reads using PDMA and then it fails on 
> > > a 254-byte read. First 128 bytes are read using PDMA and the next 
> > > PDMA operation hangs waiting forever for the host buffer to be 
> > > ready.
> > > 
> > 
> > A 128-byte PDMA receive followed by 126-byte PDMA receive? I don't see 
> > how that is possible given round_down(126, 128) == 0. Was this the 
> > actual 'len' argument to NCR5380_pread() in g_NCR5380.c?
> 
> No 126-byte PDMA. The 126 bytes were probably lost (or mixed with the 
> next read?).

When you said, the "PDMA operation hangs waiting forever", I figured that 
you had hit an infinite loop in NCR5380_pread()... but now I'm lost.

My main concern here is to confirm that I didn't break anything e.g. with 
patch 24 or 41. It would be nice to know that this hang is not the result 
of a new bug.

> The next read was also 254 bytes so another 128-byte PDMA transfer.
> 
> Then modified NCR5380_information_transfer() to transfer the remaining 
> data (126 bytes in this case) using PIO. It did not help, the next PDMA 
> transfer failed too.
> 

AFAICT, no change to NCR5380_information_transfer() should be needed. It 
was always meant to cope with the need to split a transfer between (P)DMA 
and PIO.

If the target is expecting the remaining 126 bytes, it will keep the bus 
in DATA OUT phase, and the next iteration of the loop
	while ((cmd = hostdata->connected)) { }
will call NCR5380_transfer_pio() for the remaining bytes. If the target 
never asserts REQ, that transfer will never happen, but then the command 
should timeout and get aborted, to handle the possibility that a "PDMA 
operation hangs waiting forever".

A protocol analyzer would be useful to debug this. I get a lot of value 
from a bus terminator block that has LEDs for the various control signals.
Failing that, you might need to place,
#define NDEBUG (NDEBUG_INFORMATION | NDEBUG_HANDSHAKE | NDEBUG_PIO | NDEBUG_DMA | NDEBUG_MAIN)
at the top of g_NCR5380.c.

-- 
