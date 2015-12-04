From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [RFC PATCH 76/71] ncr5380: Enable PDMA for DTC chips
Date: Fri, 4 Dec 2015 10:32:34 +0100
Message-ID: <201512041032.34466.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <1449183781-2163-1-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1512041951470.13680@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1512041951470.13680@nippy.intranet>
Content-Disposition: inline
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 04 December 2015, Finn Thain wrote:
> 
> On Fri, 4 Dec 2015, Ondrej Zary wrote:
> 
> > Add I/O register mapping for DTC chips and enable PDMA mode.
> > 
> > These chips have 16-bit wide HOST BUFFER register (counter register at 
> > offset 0x0d increments by 2 on each HOST BUFFER read).
> > 
> > Large PIO transfers crash at least the DTCT-436P chip (all reads result 
> > in 0xFF) so this patch actually makes it work.
> > 
> > The chip also crashes when we bang the C400 host status register too
> > heavily after PDMA write - a small udelay is needed.
> > 
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> > # hdparm -t --direct /dev/sdb
> > 
> > /dev/sdb:
> >  Timing O_DIRECT disk reads:   4 MB in  3.78 seconds =   1.06 MB/sec
> > 
> > 
> >  drivers/scsi/NCR5380.h   |    1 +
> >  drivers/scsi/g_NCR5380.c |   47 +++++++++++++++++++++++-----------------------
> >  2 files changed, 25 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> > index 5092580..e3b8149 100644
> > --- a/drivers/scsi/NCR5380.h
> > +++ b/drivers/scsi/NCR5380.h
> > @@ -222,6 +222,7 @@
> >  
> >  #define FLAG_NO_DMA_FIXUP		1	/* No DMA errata workarounds */
> >  #define FLAG_NO_PSEUDO_DMA		8	/* Inhibit DMA */
> > +#define FLAG_16BIT			16	/* 16-bit PDMA */
> 
> Can we give this a better name? FLAG_16BIT could be taken to mean "16-bit 
> ISA card" but do we really want a flag for that? How about 
> FLAG_16BIT_BUF_REG or FLAG_WORD_IO_BUF?
> 
> All active flags appear in the console log, thanks to prepare_info(). It 
> might be helpful to include this one; FLAG_DTC3181E is likely to 
> disappear.

Thinking more about this, we can probably detect the host buffer register
width instead of adding another flag. Read the counter, then read once from
the host buffer and read the counter again to see if it increments by 1 or 2.
Or maybe even 4 for PCI cards.

-- 
Ondrej Zary
