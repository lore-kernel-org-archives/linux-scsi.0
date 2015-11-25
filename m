From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Wed, 25 Nov 2015 10:04:10 +0100
Message-ID: <201511251004.10449.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <201511242240.24959.linux@rainbow-software.org> <alpine.LNX.2.00.1511251246130.24439@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511251246130.24439@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 25 November 2015, Finn Thain wrote:
> 
> On Tue, 24 Nov 2015, Ondrej Zary wrote:
> 
> > On Tuesday 24 November 2015 10:13:17 Finn Thain wrote:
> > > 
> > > On Tue, 24 Nov 2015, Ondrej Zary wrote:
> > > 
> > > > On Tuesday 24 November 2015, Finn Thain wrote:
> > > > > 
> > > > > On Mon, 23 Nov 2015, Ondrej Zary wrote:
> > > > > 
> > > > > > 
> > > > > > PDMA seems to be broken in multiple ways. NCR5380_pread cannot 
> > > > > > process less than 128 bytes. In fact, 53C400 datasheet says that 
> > > > > > it's HW limitation: non-modulo-128-byte transfers should use 
> > > > > > PIO.
> > > > > > 
> > > > > > Adding
> > > > > >         transfersize = round_down(transfersize, 128);
> > > > > > to generic_NCR5380_dma_xfer_len() improves the situation a bit.
> > > > > > 
> > > > > > After modprobe, some small reads (8, 4, 24 and 64 bytes) are 
> > > > > > done using PIO, then eight 512-byte reads using PDMA and then it 
> > > > > > fails on a 254-byte read. First 128 bytes are read using PDMA 
> > > > > > and the next PDMA operation hangs waiting forever for the host 
> > > > > > buffer to be ready.
> > > > > > 
> > > > > 
> > > > > A 128-byte PDMA receive followed by 126-byte PDMA receive? I don't 
> > > > > see how that is possible given round_down(126, 128) == 0. Was this 
> > > > > the actual 'len' argument to NCR5380_pread() in g_NCR5380.c?
> > > > 
> > > > No 126-byte PDMA. The 126 bytes were probably lost (or mixed with 
> > > > the next read?).
> > > [...]
> > > > The next read was also 254 bytes so another 128-byte PDMA transfer.
> > > > 
> > > > Then modified NCR5380_information_transfer() to transfer the 
> > > > remaining data (126 bytes in this case) using PIO. It did not help, 
> > > > the next PDMA transfer failed too.
> > > > 
> > > 
> > > AFAICT, no change to NCR5380_information_transfer() should be needed. 
> > > It was always meant to cope with the need to split a transfer between 
> > > (P)DMA and PIO.
> > 
> > Instead of fixing split transfers, simply forced everything 
> > non-modulo-128 to PIO:
> 
> The need to split a transfer arises from early chip errata relating to DMA 
> and the workarounds for them (see the comments in the source). That's why 
> I believe that the driver was meant to be cope with this. But I don't have 
> any experimental evidence for it.
> 
> I'm almost certain that these errata aren't applicable to your hardware. 
> So I don't have any reason to think that your card will allow part of a 
> transfer to be performed with PDMA and the rest with PIO. So I don't 
> really object to the patch.
> 
> But I don't understand the need for it either: I have no idea what state 
> the driver, chip and scsi bus were in when the 126-byte PIO transfer 
> failed. If the PIO transfer didn't succeed then the entire command should 
> have failed.

The patch was just a quick hack to confirm that PDMA is not completely broken.
Now we know that it mostly works so I can investigate the partial PIO problem.

> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -703,6 +703,10 @@ static int generic_NCR5380_dma_xfer_len(struct scsi_cmnd *cmd)
> >  	    !(cmd->SCp.this_residual % transfersize))
> >  		transfersize = 32 * 1024;
> > 
> > +	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
> 
> Do you have a download link for this datasheet?

http://bitsavers.trailing-edge.com/pdf/ncr/scsi/NCR_53C400.pdf

53C400A datasheet would be great too but haven't found any.
I think that PDMA should work with 53C400A too but seems that the driver was
never able to do it.

Although there is code for port-mapped transfer in NCR5380_pread(),
NCR53C400_register_offset is defined to 0 in the port-mapped case. The C400_
register offsets are thus defined with negative offset:

#define C400_CONTROL_STATUS_REG NCR53C400_register_offset-8
#define C400_BLOCK_COUNTER_REG   NCR53C400_register_offset-7
#define C400_RESUME_TRANSFER_REG NCR53C400_register_offset-6
#define C400_HOST_BUFFER         NCR53C400_register_offset-4

This is probably OK for a port-mapped 53C400 (such card must have some glue
decoding logic as the 53C400 chip itself can do memory-mapping only) because:

                /*
                 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
                 * the base address.
                 */
                if (overrides[current_override].board == BOARD_NCR53C400)
                        instance->io_port += 8;

This means that on a 53C400, first 5380 register will be at base+8 and first
C400_ register at base.

But on a 53C400A, the 5380 registers are mapped on the base address so the
C400_ registers would be below the base, which is obviously wrong. I hope that
PDMA will work if I fix the C400_ registers mapping.

> > +	if (transfersize % 128)
> > +		transfersize = 0;
> > +
> >  	return transfersize;
> >  }
> > 
> > It seems to work and greatly improves performance:
> > # hdparm -t --direct /dev/sdb
> > 
> > /dev/sdb:
> >  Timing O_DIRECT disk reads:   4 MB in  4.84 seconds = 846.15 kB/sec
> > 
> 
> Sounds about right...
> 

-- 
Ondrej Zary
