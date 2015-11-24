From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Tue, 24 Nov 2015 12:21:18 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511241219430.28883@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511211401.39957.linux@rainbow-software.org> <alpine.LNX.2.00.1511221001400.7671@nippy.intranet> <201511232355.04017.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <201511232355.04017.linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 23 Nov 2015, Ondrej Zary wrote:

> 
> PDMA seems to be broken in multiple ways. NCR5380_pread cannot process 
> less than 128 bytes. In fact, 53C400 datasheet says that it's HW 
> limitation: non-modulo-128-byte transfers should use PIO.
> 
> Adding
>         transfersize = round_down(transfersize, 128);
> to generic_NCR5380_dma_xfer_len() improves the situation a bit.
> 
> After modprobe, some small reads (8, 4, 24 and 64 bytes) are done using 
> PIO, then eight 512-byte reads using PDMA and then it fails on a 
> 254-byte read. First 128 bytes are read using PDMA and the next PDMA 
> operation hangs waiting forever for the host buffer to be ready.
> 

A 128-byte PDMA receive followed by 126-byte PDMA receive? I don't see how
that is possible given round_down(126, 128) == 0. Was this the actual
'len' argument to NCR5380_pread() in g_NCR5380.c?

BTW, I presume that FLAG_NO_DMA_FIXUPS was set (which is the case if you
pass ncr_53c400=1 option with modprobe). Otherwise you could see PDMA IO
sizes like 127 etc.

-- 
