From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V2 04/24] aacraid: Added sa firmware support
Date: Thu, 26 Jan 2017 18:43:38 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A63C588F7@avsrvexchmbx2.microsemi.net>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170125180111.25401-5-RaghavaAditya.Renukunta@microsemi.com>
 <20170126085142.GF3591@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:14752
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751747AbdAZSnv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 13:43:51 -0500
In-Reply-To: <20170126085142.GF3591@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Thursday, January 26, 2017 12:55 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V2 04/24] aacraid: Added sa firmware support
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Wed, Jan 25, 2017 at 10:00:51AM -0800, Raghava Aditya Renukunta wrote:
> > sa_firmware adds the capability to differentiate the new SmartIOC famil=
y
> > of adapters from the series 8 and below.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
>=20
> [...]
>=20
> > @@ -465,9 +473,13 @@ void aac_define_int_mode(struct aac_dev *dev)
> >               if (dev->max_msix > msi_count)
> >                       dev->max_msix =3D msi_count;
> >       }
> > -     dev->vector_cap =3D
> > -             (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) /
> > -             msi_count;
> > +     if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE_TYPE3 && dev-
> >sa_firmware)
> > +             dev->vector_cap =3D (dev->scsi_host_ptr->can_queue +
> > +                             AAC_NUM_MGT_FIB);
>=20
> '+' has precedence before '=3D' and you do no multiplication here, so no
> brackets
> needed.

Noted , will remove it in the next patch series.=20
=20

> [...]
>=20
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
