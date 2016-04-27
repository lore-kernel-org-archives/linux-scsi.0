From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 08/10] aacraid: Remove code to needlessly complete fib
Date: Wed, 27 Apr 2016 16:34:35 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A1635319F@avsrvexchmbx2.microsemi.net>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
 <20160426063226.28402.37546.stgit@pmcuser-System-Product-Name>
 <20160427092403.GE2820@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:36287
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752520AbcD0Qe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2016 12:34:56 -0400
In-Reply-To: <20160427092403.GE2820@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthmshirn@suse.de>
Cc: "JBottomley@odin.com" <JBottomley@odin.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Vishal Jose Mannanal <vishal.josemannanal@microsemi.com>


Hello Johannes,

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthmshirn@suse.de]
> Sent: Wednesday, April 27, 2016 2:24 AM
> To: Raghava Aditya Renukunta
> Cc: JBottomley@odin.com; linux-scsi@vger.kernel.org;
> martin.petersen@oracle.com; aacraid@pmc-sierra.com; Gana Sridaran; Sc=
ott
> Benesh; Vishal Jose Mannanal
> Subject: Re: [PATCH 08/10] aacraid: Remove code to needlessly complet=
e fib
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Mon, Apr 25, 2016 at 11:32:26PM -0700, Raghava Aditya Renukunta wr=
ote:
> > Currently driver completes double completed or spurious interrupted=
 fibs.
> > This  is not necessary and causes the SCSI mid layer to issue abort=
s and
> > resets, since completing a fib  prematurely might trigger a race co=
ndition
> > resulting in the driver not calling the scsi_done callback.
> >
> > Fixed by removing the call to fib complete.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > ---
> >  drivers/scsi/aacraid/dpcsup.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/d=
pcsup.c
> > index d677b52..7e83620 100644
> > --- a/drivers/scsi/aacraid/dpcsup.c
> > +++ b/drivers/scsi/aacraid/dpcsup.c
> > @@ -392,9 +392,10 @@ unsigned int aac_intr_normal(struct aac_dev *d=
ev,
> u32 index,
> >                       if (likely(fib->callback && fib->callback_dat=
a)) {
> >                               fib->flags &=3D FIB_CONTEXT_FLAG_FAST=
RESP;
> >                               fib->callback(fib->callback_data, fib=
);
> > -                     } else {
> > -                             aac_fib_complete(fib);
> > -                     }
> > +                     } else
> > +                             dev_info(&dev->pdev->dev,
> > +                             "Invalid callback_fib[%d] (*%p)(%p)\n=
",
> > +                             index, fib->callback, fib->callback_d=
ata);
>=20
> I'm not sure INFO is the right logging level for this. WARN or ERROR =
might be
> more suited.

I intended it be an acknowledgement that we ran into this issue. That w=
as why I used info,
It should not impact the flow of the driver.

Regards,
Raghava Aditya

>=20
> >               } else {
> >                       unsigned long flagv;
> >                       dprintk((KERN_INFO "event_wait up\n"));
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
