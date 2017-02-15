From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 12/16] aacraid: Skip IOP reset on controller panic(SMART
 Family)
Date: Wed, 15 Feb 2017 18:14:48 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8C185A@avsrvexchmbx2.microsemi.net>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-13-RaghavaAditya.Renukunta@microsemi.com>
 <a94e11f2-1a59-0454-416b-8a1139cb2794@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0087.outbound.protection.outlook.com ([104.47.37.87]:37472
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751383AbdBOSPM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 13:15:12 -0500
In-Reply-To: <a94e11f2-1a59-0454-416b-8a1139cb2794@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Wednesday, February 15, 2017 12:49 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Dave Carroll <david.carroll@microsemi.com>; Gana Sridaran
> <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>; dan.carpenter@oracle.com
> Subject: Re: [PATCH 12/16] aacraid: Skip IOP reset on controller panic(SM=
ART
> Family)
>=20
> EXTERNAL EMAIL
>=20
>=20
> On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> > When the SMART family of controller panic (KERNEL_PANIC) , they do not
>                             ^ controllers?                ^ extra space
> > honor IOP resets. So better to skip it and directly perform a IWBR rese=
t.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> > ---
> >  drivers/scsi/aacraid/src.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> > index b23c818..5bb9865 100644
> > --- a/drivers/scsi/aacraid/src.c
> > +++ b/drivers/scsi/aacraid/src.c
> > @@ -714,6 +714,12 @@ static int aac_src_restart_adapter(struct aac_dev
> *dev, int bled, u8 reset_type)
> >               pr_err("%s%d: adapter kernel panic'd %x.\n",
> >                               dev->name, dev->id, bled);
> >
> > +     /*
> > +      * WHen there is a BlinkLED, IOP_RESET has not effect
>            ^ When
> > +      */
> > +     if (bled >=3D 2 && dev->sa_firmware && (reset_type & HW_IOP_RESET=
))
>                                              ^ No need for the
>                                                parenthesis
> > +             reset_type &=3D ~HW_IOP_RESET;
> > +
> >       dev->a_ops.adapter_enable_int =3D aac_src_disable_interrupt;
> >
> >       switch (reset_type) {
> >
>=20
> Apart from that,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Yes I will fix this in the next patch set.

Regards,
Raghava Aditya

> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
