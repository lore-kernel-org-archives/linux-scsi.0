From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 04/16] aacraid: Prevent E3 lockup when deleting units
Date: Wed, 15 Feb 2017 18:08:06 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8C17BA@avsrvexchmbx2.microsemi.net>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-5-RaghavaAditya.Renukunta@microsemi.com>
 <20bffbde-6a46-96f3-f0ee-889d9a029721@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0069.outbound.protection.outlook.com ([104.47.37.69]:51472
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752247AbdBOSIn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 13:08:43 -0500
In-Reply-To: <20bffbde-6a46-96f3-f0ee-889d9a029721@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Wednesday, February 15, 2017 12:20 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Dave Carroll <david.carroll@microsemi.com>; Gana Sridaran
> <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>; dan.carpenter@oracle.com
> Subject: Re: [PATCH 04/16] aacraid: Prevent E3 lockup when deleting units
>=20
> EXTERNAL EMAIL
>=20
>=20
> On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> > Arrconf management utility at times sends fibs with AdapterProcessed se=
t
> > in its fibs. This causes the controller to panic and lockup.
> >
> > Fixed by failing the commands that have AdapterProcessed set in its fla=
g.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> > ---
> >  drivers/scsi/aacraid/commsup.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/scsi/aacraid/commsup.c
> b/drivers/scsi/aacraid/commsup.c
> > index 6220b47..f7a3bcb 100644
> > --- a/drivers/scsi/aacraid/commsup.c
> > +++ b/drivers/scsi/aacraid/commsup.c
> > @@ -522,6 +522,10 @@ int aac_fib_send(u16 command, struct fib *fibptr,
> unsigned long size,
> >
> >       if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
> >               return -EBUSY;
> > +
> > +     if (hw_fib->header.XferState & cpu_to_le32(AdapterProcessed))
> > +             return -EINVAL;
> > +
>=20
> As far as I can see the fib_xfer_state enum isn't an exported as an
> official ABI, so it's a good candidate (whole of aacraid.h actually) for
> the next round of camel case removals.
>=20
> Anyways, this can wait:
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

I will put in the queue for the next set of patch submissions and chip away
 at it bit by bit.

Thank you,
Raghava Aditya Renukunta

>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
