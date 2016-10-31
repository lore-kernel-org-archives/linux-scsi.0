From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 3/3] NCR5380: Check for chip presence in NCR5380_init()
Date: Mon, 31 Oct 2016 20:35:00 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1610312023240.20925@nippy.intranet>
References: <1477867203-7480-1-git-send-email-linux@rainbow-software.org> <1477867203-7480-3-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1610311359080.32132@nippy.intranet> <201610310859.53758.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201610310859.53758.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 31 Oct 2016, Ondrej Zary wrote:

> On Monday 31 October 2016, Finn Thain wrote:
> > On Sun, 30 Oct 2016, Ondrej Zary wrote:
> > > Read back MODE_REG after writing it in NCR5380_init() to check if the
> > > chip is really there.
> > >
> > > This prevents hang when incorrect I/O address was specified by user.
> > >
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > > ---
> > >  drivers/scsi/NCR5380.c |    5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> > > index 01c0027..ce3156d 100644
> > > --- a/drivers/scsi/NCR5380.c
> > > +++ b/drivers/scsi/NCR5380.c
> > > @@ -495,6 +495,11 @@ static int NCR5380_init(struct Scsi_Host *instance,
> > > int flags)
> > >
> > >  	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> > >  	NCR5380_write(MODE_REG, MR_BASE);
> > > +	/* check if the chip is really there */
> > > +	if (NCR5380_read(MODE_REG) != MR_BASE) {
> > > +		NCR5380_exit(instance);
> > > +		return -ENODEV;
> > > +	}
> >
> > This doesn't belong in the core driver. Only the 5380 ISA drivers have 
> > configurable base addresses.
> >
> > Also, MR_BASE == 0, so that test is likely to be ineffectual anyway. 
> > This patch doesn't really add any value AFAICT.
> 
> This fixes the most common problem: no device present at the specified 
> I/O address, all reads result in 0xff.
> 

ISTR that's true for ISA in general, so I guess it would be okay in 
g_NCR5380.c.

Better do this before NCR5380_init() so you can probe before allocating a 
scsi host. Just write 0 to MODE_REG or SELECT_ENABLE_REG.

-- 
