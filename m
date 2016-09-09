From: Mike Krinkin <krinkin.m.u@gmail.com>
Subject: Re: [PATCH] Some drives failing on SCT Write Same
Date: Fri, 9 Sep 2016 20:52:15 +0300
Message-ID: <20160909175211.GA3978@gmail.com>
References: <CAJ48U8VJDSzQWuNgG1mnBG_6FvSx5Arc=n6YsH-vxKrt=skWqw@mail.gmail.com>
 <20160909164419.12978-1-shaun@tancheff.com>
 <CAJVOszCDZo8Ev==qNP1Umjwxqbfy1=yuymbbA15FfXmXkh5QCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:32783 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbcIIRwT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2016 13:52:19 -0400
Content-Disposition: inline
In-Reply-To: <CAJVOszCDZo8Ev==qNP1Umjwxqbfy1=yuymbbA15FfXmXkh5QCg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>

On Fri, Sep 09, 2016 at 11:48:51AM -0500, Shaun Tancheff wrote:
> Mike,
> 
> Can you confirm if this fix works for you?
> 
> I tested the patch is tested on top of next-20160909.

Works for me too, thank you.

> 
> Thanks!
> --Shaun
> 
> On Fri, Sep 9, 2016 at 11:44 AM, Shaun Tancheff <shaun@tancheff.com> wrote:
> 
> > Restrict support SCT Write Same to devices which also support ZAC where
> > support is required.
> >
> > Reported-by: Mike Krinkin <krinkin.m.u@gmail.com>
> > Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
> > ---
> >  drivers/ata/libata-scsi.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > index 2f5487f..9cceb4a 100644
> > --- a/drivers/ata/libata-scsi.c
> > +++ b/drivers/ata/libata-scsi.c
> > @@ -3562,9 +3562,9 @@ static unsigned int ata_scsiop_maint_in(struct
> > ata_scsi_args *args, u8 *rbuf)
> >                 supported = 3;
> >                 break;
> >         case WRITE_SAME_16:
> > -               if (ata_id_sct_write_same(dev->id))
> > -                       supported = 3;
> > -               break;
> > +               if (!ata_id_sct_write_same(dev->id))
> > +                       break;
> > +               /* fallthrough: if SCT ... only enable for ZBC */
> >         case ZBC_IN:
> >         case ZBC_OUT:
> >                 if (ata_id_zoned_cap(dev->id) ||
> > --
> > 2.9.3
> >
> >
> 
> 
> -- 
> Shaun Tancheff
