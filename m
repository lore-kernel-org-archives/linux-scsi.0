From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Tue, 24 Nov 2015 09:04:54 +0100
Message-ID: <201511240904.55085.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <201511232355.04017.linux@rainbow-software.org> <alpine.LNX.2.00.1511241219430.28883@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511241219430.28883@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 24 November 2015, Finn Thain wrote:
> 
> On Mon, 23 Nov 2015, Ondrej Zary wrote:
> 
> > 
> > PDMA seems to be broken in multiple ways. NCR5380_pread cannot process 
> > less than 128 bytes. In fact, 53C400 datasheet says that it's HW 
> > limitation: non-modulo-128-byte transfers should use PIO.
> > 
> > Adding
> >         transfersize = round_down(transfersize, 128);
> > to generic_NCR5380_dma_xfer_len() improves the situation a bit.
> > 
> > After modprobe, some small reads (8, 4, 24 and 64 bytes) are done using 
> > PIO, then eight 512-byte reads using PDMA and then it fails on a 
> > 254-byte read. First 128 bytes are read using PDMA and the next PDMA 
> > operation hangs waiting forever for the host buffer to be ready.
> > 
> 
> A 128-byte PDMA receive followed by 126-byte PDMA receive? I don't see how
> that is possible given round_down(126, 128) == 0. Was this the actual
> 'len' argument to NCR5380_pread() in g_NCR5380.c?

No 126-byte PDMA. The 126 bytes were probably lost (or mixed with the next
read?). The next read was also 254 bytes so another 128-byte PDMA transfer.

Then modified NCR5380_information_transfer() to transfer the remaining data
(126 bytes in this case) using PIO. It did not help, the next PDMA transfer
failed too.

> BTW, I presume that FLAG_NO_DMA_FIXUPS was set (which is the case if you
> pass ncr_53c400=1 option with modprobe). Otherwise you could see PDMA IO
> sizes like 127 etc.

Yes, the flag was set.

-- 
Ondrej Zary
