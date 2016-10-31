From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 3/3] NCR5380: Check for chip presence in NCR5380_init()
Date: Mon, 31 Oct 2016 08:59:53 +0100
Message-ID: <201610310859.53758.linux@rainbow-software.org>
References: <1477867203-7480-1-git-send-email-linux@rainbow-software.org> <1477867203-7480-3-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1610311359080.32132@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:41923 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761929AbcJaIAC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2016 04:00:02 -0400
In-Reply-To: <alpine.LNX.2.00.1610311359080.32132@nippy.intranet>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Monday 31 October 2016, Finn Thain wrote:
> On Sun, 30 Oct 2016, Ondrej Zary wrote:
> > Read back MODE_REG after writing it in NCR5380_init() to check if the
> > chip is really there.
> >
> > This prevents hang when incorrect I/O address was specified by user.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> >  drivers/scsi/NCR5380.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> > index 01c0027..ce3156d 100644
> > --- a/drivers/scsi/NCR5380.c
> > +++ b/drivers/scsi/NCR5380.c
> > @@ -495,6 +495,11 @@ static int NCR5380_init(struct Scsi_Host *instance,
> > int flags)
> >
> >  	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> >  	NCR5380_write(MODE_REG, MR_BASE);
> > +	/* check if the chip is really there */
> > +	if (NCR5380_read(MODE_REG) != MR_BASE) {
> > +		NCR5380_exit(instance);
> > +		return -ENODEV;
> > +	}
>
> This doesn't belong in the core driver. Only the 5380 ISA drivers have
> configurable base addresses.
>
> Also, MR_BASE == 0, so that test is likely to be ineffectual anyway. This
> patch doesn't really add any value AFAICT.

This fixes the most common problem: no device present at the specified I/O 
address, all reads result in 0xff.

-- 
Ondrej Zary
