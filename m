From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 10/12] scsi/ncr5380: Expedite register polling
Date: Tue, 11 Oct 2016 09:57:47 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1610110924160.8220@nippy.intranet>
References: <cover.1476051961.git.fthain@telegraphics.com.au> <2806ba151f6983923fa0aae700245dfeb4cfaf38.1476051962.git.fthain@telegraphics.com.au> <20161010091709.GY1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161010091709.GY1041@n2100.armlinux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-kernel@lists.infradead.org, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 10 Oct 2016, Russell King - ARM Linux wrote:

> On Mon, Oct 10, 2016 at 12:46:53AM -0400, Finn Thain wrote:
> > Avoid the call to NCR5380_poll_politely2() when possible. The call is 
> > easily short-circuited on the PIO fast path, using the inline wrapper. 
> > This requires that the NCR5380_read macro be made available before any 
> > #include "NCR5380.h" so a few declarations have to be moved too.
> > 
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > Reviewed-by: Hannes Reinecke <hare@suse.com>
> > Tested-by: Ondrej Zary <linux@rainbow-software.org>
> > Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> > ---
> 
> > diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
> > index ae1d4c6..fb7600d 100644
> > --- a/drivers/scsi/arm/cumana_1.c
> > +++ b/drivers/scsi/arm/cumana_1.c
> > @@ -29,6 +29,10 @@
> >  #define NCR5380_implementation_fields	\
> >  	unsigned ctrl
> >  
> > +struct NCR5380_hostdata;
> > +static u8 cumanascsi_read(struct NCR5380_hostdata *, unsigned int);
> > +static void cumanascsi_write(struct NCR5380_hostdata *, unsigned int, u8);
> > +
> >  #include "../NCR5380.h"
> >  
> >  #define CTRL	0x16fc
> 
> This seems to be non-obviously unrelated to this commit - should it be 
> in some other commit?
> 

The source of the problem here is the #include "../NCR5380.h", because 
that header file both declares struct NCR5380_hostdata and (with this 
patch) it also calls cumanascsi_read(). That means cumanascsi_read() has 
to be declared earlier, and that in turn requires an incomplete definition 
of struct NCR5380_hostdata. The commit log alludes to the problem but 
could be made more explicit if you would like (?).

BTW, this problem doesn't arise in the other six 5380 drivers because each 
one implements NCR5380_read() as a macro. It would be nice to get rid of 
the macros in favour of an ops struct (in the course of converting the 
driver to a library module) but I doubt that this is feasible now that 
I've seen the performance benefit of this patch series.

In the absence of link time optimization, the library module design would 
prevent the inlining of functions like cumanascsi_read(). Since every byte 
transfered by the 5380 in a PIO transfer requires at least 5 chip register 
accesses, function calls would be prohibitively expensive. So I think we 
are stuck with inline accessors or macros.

-- 
