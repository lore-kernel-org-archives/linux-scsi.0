From: Christos Gkekas <chris.gekas@gmail.com>
Subject: Re: [PATCH] scsi: hpsa: simplify hpsa_set_local_logical_count()
Date: Mon, 16 Oct 2017 20:06:28 +0100
Message-ID: <20171016190628.GC2656@inspiron>
References: <1508096103-6751-1-git-send-email-chris.gekas@gmail.com>
 <4993A297653ECB4581FA5C3C31323D19672184FC@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4993A297653ECB4581FA5C3C31323D19672184FC@avsrvexchmbx2.microsemi.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "esc.storagedev" <esc.storagedev@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 16/10/17 18:55:11 +0000, Don Brace wrote:
> > -----Original Message-----
> > From: Christos Gkekas [mailto:chris.gekas@gmail.com]
> > Sent: Sunday, October 15, 2017 2:35 PM
> > To: Don Brace <don.brace@microsemi.com>; James E.J. Bottomley
> > <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> > <martin.petersen@oracle.com>; esc.storagedev
> > <esc.storagedev@microsemi.com>; linux-scsi@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Cc: Christos Gkekas <chris.gekas@gmail.com>
> > Subject: [PATCH] scsi: hpsa: simplify hpsa_set_local_logical_count()
> > 
> > EXTERNAL EMAIL
> > 
> > 
> > Variable configured_logical_drive_count is defined as u8 and thus the
> > nested if statement always evaluates to true. Remove it and simplify.
> > 
> > Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
> > ---
> >  drivers/scsi/hpsa.c | 9 +--------
> >  1 file changed, 1 insertion(+), 8 deletions(-)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 9abe810..7d4f139 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -4090,14 +4090,7 @@ static int hpsa_set_local_logical_count(struct
> > ctlr_info *h,
> >         }
> >         memset(id_ctlr, 0, sizeof(*id_ctlr));
> >         rc = hpsa_bmic_id_controller(h, id_ctlr, sizeof(*id_ctlr));
> > -       if (!rc)
> > -               if (id_ctlr->configured_logical_drive_count < 256)
> > -                       *nlocals = id_ctlr->configured_logical_drive_count;
> > -               else
> > -                       *nlocals = le16_to_cpu(
> > -                                       id_ctlr->extended_logical_unit_count);
> > -       else
> > -               *nlocals = -1;
> > +       *nlocals = rc ? -1 : id_ctlr->configured_logical_drive_count;
> >         return rc;
> >  }
> > 
> 
> Thanks for your attention to the hpsa driver.
> 
> The actual check should be:
> -               if (id_ctlr->configured_logical_drive_count < 255)
> We need to return id_ctlr->extended_logical_unit_count otherwise.
> 
> Good catch.
> 
> Thanks,
> Don Brace
> ESC - Smart Storage
> Microsemi Corporation
> 
> 
> > --
> > 2.7.4
> 

Thanks for reviewing this change, will send an updated patch today.

Thanks,
Christos
