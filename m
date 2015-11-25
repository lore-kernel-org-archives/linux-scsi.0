From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Wed, 25 Nov 2015 13:10:49 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511251246130.24439@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511240904.55085.linux@rainbow-software.org> <alpine.LNX.2.00.1511241932130.7196@nippy.intranet> <201511242240.24959.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <201511242240.24959.linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 24 Nov 2015, Ondrej Zary wrote:

> On Tuesday 24 November 2015 10:13:17 Finn Thain wrote:
> > 
> > On Tue, 24 Nov 2015, Ondrej Zary wrote:
> > 
> > > On Tuesday 24 November 2015, Finn Thain wrote:
> > > > 
> > > > On Mon, 23 Nov 2015, Ondrej Zary wrote:
> > > > 
> > > > > 
> > > > > PDMA seems to be broken in multiple ways. NCR5380_pread cannot 
> > > > > process less than 128 bytes. In fact, 53C400 datasheet says that 
> > > > > it's HW limitation: non-modulo-128-byte transfers should use 
> > > > > PIO.
> > > > > 
> > > > > Adding
> > > > >         transfersize = round_down(transfersize, 128);
> > > > > to generic_NCR5380_dma_xfer_len() improves the situation a bit.
> > > > > 
> > > > > After modprobe, some small reads (8, 4, 24 and 64 bytes) are 
> > > > > done using PIO, then eight 512-byte reads using PDMA and then it 
> > > > > fails on a 254-byte read. First 128 bytes are read using PDMA 
> > > > > and the next PDMA operation hangs waiting forever for the host 
> > > > > buffer to be ready.
> > > > > 
> > > > 
> > > > A 128-byte PDMA receive followed by 126-byte PDMA receive? I don't 
> > > > see how that is possible given round_down(126, 128) == 0. Was this 
> > > > the actual 'len' argument to NCR5380_pread() in g_NCR5380.c?
> > > 
> > > No 126-byte PDMA. The 126 bytes were probably lost (or mixed with 
> > > the next read?).
> > [...]
> > > The next read was also 254 bytes so another 128-byte PDMA transfer.
> > > 
> > > Then modified NCR5380_information_transfer() to transfer the 
> > > remaining data (126 bytes in this case) using PIO. It did not help, 
> > > the next PDMA transfer failed too.
> > > 
> > 
> > AFAICT, no change to NCR5380_information_transfer() should be needed. 
> > It was always meant to cope with the need to split a transfer between 
> > (P)DMA and PIO.
> 
> Instead of fixing split transfers, simply forced everything 
> non-modulo-128 to PIO:

The need to split a transfer arises from early chip errata relating to DMA 
and the workarounds for them (see the comments in the source). That's why 
I believe that the driver was meant to be cope with this. But I don't have 
any experimental evidence for it.

I'm almost certain that these errata aren't applicable to your hardware. 
So I don't have any reason to think that your card will allow part of a 
transfer to be performed with PDMA and the rest with PIO. So I don't 
really object to the patch.

But I don't understand the need for it either: I have no idea what state 
the driver, chip and scsi bus were in when the 126-byte PIO transfer 
failed. If the PIO transfer didn't succeed then the entire command should 
have failed.

> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -703,6 +703,10 @@ static int generic_NCR5380_dma_xfer_len(struct scsi_cmnd *cmd)
>  	    !(cmd->SCp.this_residual % transfersize))
>  		transfersize = 32 * 1024;
> 
> +	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */

Do you have a download link for this datasheet?

> +	if (transfersize % 128)
> +		transfersize = 0;
> +
>  	return transfersize;
>  }
> 
> It seems to work and greatly improves performance:
> # hdparm -t --direct /dev/sdb
> 
> /dev/sdb:
>  Timing O_DIRECT disk reads:   4 MB in  4.84 seconds = 846.15 kB/sec
> 

Sounds about right...

-- 
