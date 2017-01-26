From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V2 03/24] aacraid: added support for init_struct_8
Date: Thu, 26 Jan 2017 18:42:55 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A63C588D6@avsrvexchmbx2.microsemi.net>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170125180111.25401-4-RaghavaAditya.Renukunta@microsemi.com>
 <20170126083700.GE3591@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0078.outbound.protection.outlook.com ([104.47.36.78]:11424
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751747AbdAZSm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 13:42:59 -0500
In-Reply-To: <20170126083700.GE3591@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Thursday, January 26, 2017 12:37 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V2 03/24] aacraid: added support for init_struct_8
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Wed, Jan 25, 2017 at 10:00:50AM -0800, Raghava Aditya Renukunta wrote:
> > This  patch lays the groundwork for supporting the new HBA-1000
> controller
> > family.A new INIT structure INIT_STRUCT_8 has been added which allows
> for a
> > variable size for MSI-x vectors among other things,  and is used for bo=
th
> > Series-8, HBA-1000 and SmartIOC-2000.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <raghavaaditya.renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
>=20
> [...]
>=20
> > -struct aac_init
> > +union aac_init
> >  {
> > -     __le32  InitStructRevision;
> > -     __le32  Sa_MSIXVectors;
> > -     __le32  fsrev;
> > -     __le32  CommHeaderAddress;
> > -     __le32  FastIoCommAreaAddress;
> > -     __le32  AdapterFibsPhysicalAddress;
> > -     __le32  AdapterFibsVirtualAddress;
> > -     __le32  AdapterFibsSize;
> > -     __le32  AdapterFibAlign;
> > -     __le32  printfbuf;
> > -     __le32  printfbufsiz;
> > -     __le32  HostPhysMemPages;   /* number of 4k pages of host
> > -                                    physical memory */
> > -     __le32  HostElapsedSeconds; /* number of seconds since 1970. */
> > -     /*
> > -      * ADAPTER_INIT_STRUCT_REVISION_4 begins here
> > -      */
> > -     __le32  InitFlags;      /* flags for supported features */
> > +     struct _r7 {
> > +             __le32  InitStructRevision;
> > +             __le32  NoOfMSIXVectors;
> > +             __le32  fsrev;
> > +             __le32  CommHeaderAddress;
> > +             __le32  FastIoCommAreaAddress;
> > +             __le32  AdapterFibsPhysicalAddress;
> > +             __le32  AdapterFibsVirtualAddress;
> > +             __le32  AdapterFibsSize;
> > +             __le32  AdapterFibAlign;
> > +             __le32  printfbuf;
> > +             __le32  printfbufsiz;
> > +             /* number of 4k pages of host phys. mem. */
> > +             __le32  HostPhysMemPages;
> > +             /* number of seconds since 1970. */
> > +             __le32  HostElapsedSeconds;
> > +             /* ADAPTER_INIT_STRUCT_REVISION_4 begins here */
> > +             __le32  InitFlags;      /* flags for supported features *=
/
> >  #define INITFLAGS_NEW_COMM_SUPPORTED 0x00000001
> >  #define INITFLAGS_DRIVER_USES_UTC_TIME       0x00000010
> >  #define INITFLAGS_DRIVER_SUPPORTS_PM 0x00000020
> >  #define INITFLAGS_NEW_COMM_TYPE1_SUPPORTED   0x00000040
> >  #define INITFLAGS_FAST_JBOD_SUPPORTED        0x00000080
> >  #define INITFLAGS_NEW_COMM_TYPE2_SUPPORTED   0x00000100
> > -     __le32  MaxIoCommands;  /* max outstanding commands */
> > -     __le32  MaxIoSize;      /* largest I/O command */
> > -     __le32  MaxFibSize;     /* largest FIB to adapter */
> > -     /* ADAPTER_INIT_STRUCT_REVISION_5 begins here */
> > -     __le32  MaxNumAif;      /* max number of aif */
> > -     /* ADAPTER_INIT_STRUCT_REVISION_6 begins here */
> > -     __le32  HostRRQ_AddrLow;
> > -     __le32  HostRRQ_AddrHigh;       /* Host RRQ (response queue) for =
SRC
> */
> > +#define INITFLAGS_DRIVER_SUPPORTS_HBA_MODE  0x00000400
> > +             __le32  MaxIoCommands;  /* max outstanding commands */
> > +             __le32  MaxIoSize;      /* largest I/O command */
> > +             __le32  MaxFibSize;     /* largest FIB to adapter */
> > +             /* ADAPTER_INIT_STRUCT_REVISION_5 begins here */
> > +             __le32  MaxNumAif;      /* max number of aif */
> > +             /* ADAPTER_INIT_STRUCT_REVISION_6 begins here */
> > +             /* Host RRQ (response queue) for SRC */
> > +             __le32  HostRRQ_AddrLow;
> > +             __le32  HostRRQ_AddrHigh;
> > +     } r7;
> > +     struct _r8 {
> > +             /* ADAPTER_INIT_STRUCT_REVISION_8 */
> > +             __le32  InitStructRevision;
> > +             __le32  RRQueueCount;
> > +             __le32  HostElapsedSeconds; /* number of seconds since 19=
70. */
> > +             __le32  InitFlags;
> > +             __le32  MaxIoSize;      /* largest I/O command */
> > +             __le32  MaxNumAif;      /* max number of aif */
> > +             __le32  Reserved1;
> > +             __le32  Reserved2;
> > +             struct _rrq {
> > +                     __le32  Host_AddrLow;
> > +                     __le32  Host_AddrHigh;
> > +                     __le16  MSIX_Id;
> > +                     __le16  ElementCount;
> > +                     __le16  Comp_Thresh;
> > +                     __le16  Unused;
> > +             } rrq[1];               /* up to 64 RRQ addresses */
> > +     } r8;
> >  };
>=20
> Is this CamelCase pollution really needed? You're touching it anyways, so
> wouldn't it be a great chance to run
> sed -e 's/\([A-Z]\)/_\l\1/g' -e 's/^_\([a-z]\)/\1/g'
> on the new structures?
>=20

I missed that, but I agree I will remove it in the next patch series.
Thank for pointing that out.


Regards,
Raghava Aditya

