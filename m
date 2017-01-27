From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V2 05/24] aacraid: Retrieve and update the device types
Date: Fri, 27 Jan 2017 18:24:45 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B89C04F@avsrvexchmbx2.microsemi.net>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170125180111.25401-6-RaghavaAditya.Renukunta@microsemi.com>
 <20170126085952.GG3591@linux-x5ow.site>
 <4D8E82A446BF54499747901DBDEB737A63C58906@avsrvexchmbx2.microsemi.net>
 <4D8E82A446BF54499747901DBDEB737A7B88A658@avsrvexchmbx1.microsemi.net>
 <20170127080801.GA5746@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0070.outbound.protection.outlook.com ([104.47.42.70]:14144
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750731AbdA0SZS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Jan 2017 13:25:18 -0500
In-Reply-To: <20170127080801.GA5746@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Friday, January 27, 2017 12:08 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V2 05/24] aacraid: Retrieve and update the device typ=
es
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Thu, Jan 26, 2017 at 09:00:42PM +0000, Raghava Aditya Renukunta wrote:
> >
> >
> > > -----Original Message-----
> > > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > > owner@vger.kernel.org] On Behalf Of Raghava Aditya Renukunta
> > > Sent: Thursday, January 26, 2017 10:44 AM
> > > To: Johannes Thumshirn <jthumshirn@suse.de>
> > > Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> > > scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gan=
a
> > > Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> > > <scott.benesh@microsemi.com>
> > > Subject: RE: [PATCH V2 05/24] aacraid: Retrieve and update the device
> types
> > >
> > > EXTERNAL EMAIL
> > >
> > >
> > > > -----Original Message-----
> > > > From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> > > > Sent: Thursday, January 26, 2017 1:00 AM
> > > > To: Raghava Aditya Renukunta
> > > > <RaghavaAditya.Renukunta@microsemi.com>
> > > > Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> > > > scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>;
> Gana
> > > > Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> > > > <scott.benesh@microsemi.com>
> > > > Subject: Re: [PATCH V2 05/24] aacraid: Retrieve and update the devi=
ce
> > > types
> > > >
> > > > EXTERNAL EMAIL
> > > >
> > > >
> > > > On Wed, Jan 25, 2017 at 10:00:52AM -0800, Raghava Aditya Renukunta
> > > wrote:
> > > > > This patch adds support to retrieve the type of each adapter
> connected
> > > > > device. Applicable to HBA1000 and SmartIOC2000 products
> > > > >
> > > > > Signed-off-by: Raghava Aditya Renukunta
> > > > <RaghavaAditya.Renukunta@microsemi.com>
> > > > > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> > > > >
> > > > > ---
> > > >
> > > > [...]
> > > >
> > > > >  /*
> > > > >   *   Adapter Information Block
> > > > >   *
> > > > > @@ -1056,7 +1091,28 @@ struct aac_supplement_adapter_info
> > > > >       /* StructExpansion =3D=3D 1 */
> > > > >       __le32  FeatureBits3;
> > > > >       __le32  SupportedPerformanceModes;
> > > > > -     __le32  ReservedForFutureGrowth[80];
> > > > > +     u8      HostBusType;            /* uses HOST_BUS_TYPE_xxx d=
efines */
> > > > > +     u8      HostBusWidth;           /* actual width in bits or =
links */
> > > > > +     u16     HostBusSpeed;           /* actual bus speed/link ra=
te in MHz */
> > > > > +     u8      MaxRRCDrives;           /* max. number of ITP-RRC d=
rives/pool
> */
> > > > > +     u8      MaxDiskXtasks;          /* max. possible num of Dis=
kX Tasks */
> > > > > +
> > > > > +     u8      CpldVerLoaded;
> > > > > +     u8      CpldVerInFlash;
> > > > > +
> > > > > +     __le64  MaxRRCCapacity;
> > > > > +     __le32  CompiledMaxHistLogLevel;
> > > > > +     u8      CustomBoardName[12];
> > > > > +     u16     SupportedCntlrMode;     /* identify supported contr=
oller
> mode
> > > */
> > > > > +     u16     ReservedForFuture16;
> > > > > +     __le32  SupportedOptions3;      /* reserved for future opti=
ons */
> > > > > +
> > > > > +     __le16  VirtDeviceBus;          /* virt. SCSI device for Th=
or */
> > > > > +     __le16  VirtDeviceTarget;
> > > > > +     __le16  VirtDeviceLUN;
> > > > > +     __le16  Unused;
> > > > > +     __le32  ReservedForFutureGrowth[68];
> > > > > +
> > >
> > > Same here.
> >
> > On second thought changing all of the variables here will open up
> > Pandoras  box. I will leave them as it is for now  and change the whole
> >  structure and anything attached it in one of my next patch submission
> series.
> >
> > Will that be ok?
>=20
> Yes that's something I can live with, *iff* it really happens.

I plan to make it happen, in the next set of patches that I send.
:)

Thank you,
Raghava Aditya

>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
