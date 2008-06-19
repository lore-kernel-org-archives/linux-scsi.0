From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] libata support for rotation speed
Date: Thu, 19 Jun 2008 12:31:13 -0600
Message-ID: <20080619183113.GM4392@parisc-linux.org>
References: <20080619160216.GH4392@parisc-linux.org> <20080619175904.GK4392@parisc-linux.org> <1213899895.3501.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1213899895.3501.45.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 19, 2008 at 01:24:55PM -0500, James Bottomley wrote:
> On Thu, 2008-06-19 at 11:59 -0600, Matthew Wilcox wrote:
> > Version 2, Jeff pointed out I was missing a check for a sufficiently
> > recent version of the specification.
> > 
> > Add support for VPD page b1 to libata
> > 
> > SCSI VPD page b1 reports the nominal rotation speed of the device.
> > ATA devices return this information in word 217 of the identify data.
> > b1 can also report the physical size of the device (5.25", 3.5", etc)
> > but that doesn't currently seem to be defined in the ATA specification.
> > 
> > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > 
> > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > index 2e6e162..07512d4 100644
> > --- a/drivers/ata/libata-scsi.c
> > +++ b/drivers/ata/libata-scsi.c
> > @@ -1899,6 +1901,18 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
> >  	return 0;
> >  }
> >  
> > +static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
> > +{
> > +	rbuf[1] = 0xb1;
> 
> This looks like it can be called for ATA_DEV_ATAPI as well, in which
> case it's an illegal page to ask for.

I was under the impression that this entire file is only used for
non-atapi devices.  At least, the VPD is supposed to have PQ/PDT filled
in, which would be 0x5 instead of 0.

> Also, shouldn't this be added to
> VPD page 0 (which shows the list of available VPD pages ... although it
> looks like the supported 0x89 is missing too)?

You even quoted the bit where I did that:

> > @@ -1778,7 +1778,9 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
> >  	const u8 pages[] = {
> >  		0x00,	/* page 0x00, this page */
> >  		0x80,	/* page 0x80, unit serial no page */
> > -		0x83	/* page 0x83, device ident page */
> > +		0x83,	/* page 0x83, device ident page */
> > +		0x89,	/* page 0x89, ata info page */
> > +		0xb1,	/* page 0xb1, block device characteristics page */
> >  	};
> >  
> >  	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
> 
> This would currently set device nominal form factor to unreported.  It's
> actually available in identify word 168 (bits 0:3) in an identical
> format to the one the VPD inquiry is expecting, so why not use it?

The version of ATA-ACS 8 I have doesn't have it ;-)

I'll go and download a more recent one and respin with it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
