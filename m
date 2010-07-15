From: Dan Porat <dan.porat@gmail.com>
Subject: Re: 520 BPS data integrity vendors
Date: Thu, 15 Jul 2010 06:08:09 -0400
Message-ID: <AANLkTilqzgIav9noTYLC9cxKtntva6wQwLSUI1i8DgAe@mail.gmail.com>
References: <AANLkTilcpFgsYtEUkZ2zAU3SDs0jetiajYPzKUWgFMyD@mail.gmail.com>
	<1278093968.2856.169.camel@mulgrave.site>
	<AANLkTilWKeOAXMukh_zvXzdXkdOTk6soAEnpzFNwvBA3@mail.gmail.com>
	<yq1mxu981eg.fsf@sermon.lab.mkp.net>
	<AANLkTimI7Ke4qXw7zv8WDsWSQtBRSwSi5IZbvByjGRih@mail.gmail.com>
	<yq1630s8msu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1630s8msu.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

=46ollowing is the output with the Hitachi drive:

[root@fedora13 ~]# lsscsi -p

[0:0:0:0]=A0=A0=A0 cd/dvd=A0 hp=A0=A0=A0=A0=A0=A0 CDDVDW TS-H653R=A0 0E=
00=A0 /dev/sr0

[1:0:0:0]=A0=A0=A0 disk=A0=A0=A0 ATA=A0=A0=A0=A0=A0 ST31000528AS=A0=A0=A0=
=A0 CC38=A0 /dev/sda

[6:0:0:0]=A0=A0=A0 disk=A0=A0=A0 HITACHI=A0 HUS151473VLS300=A0 A420=A0 =
/dev/sdb

[root@fedora13 ~]# sg_inq /dev/sdb

standard INQUIRY:

=A0 PQual=3D0=A0 Device_type=3D0=A0 RMB=3D0=A0 version=3D0x05=A0 [SPC-3=
]

=A0 [AERC=3D0]=A0 [TrmTsk=3D0]=A0 NormACA=3D0=A0 HiSUP=3D0=A0 Resp_data=
_format=3D2

=A0 SCCS=3D0=A0 ACC=3D0=A0 TPGS=3D0=A0 3PC=3D0=A0 Protect=3D0=A0 BQue=3D=
0

=A0 EncServ=3D0=A0 MultiP=3D1 (VS=3D0)=A0 [MChngr=3D0]=A0 [ACKREQQ=3D0]=
=A0 Addr16=3D0

=A0 [RelAdr=3D0]=A0 WBus16=3D0=A0 Sync=3D0=A0 Linked=3D0=A0 [TranDis=3D=
0]=A0 CmdQue=3D1

=A0 [SPI: Clocking=3D0x0=A0 QAS=3D0=A0 IUS=3D0]

=A0=A0=A0 length=3D164 (0xa4)=A0=A0 Peripheral device type: disk

=A0Vendor identification: HITACHI

=A0Product identification: HUS151473VLS300=A0 Product revision level: A=
420

[root@fedora13 ~]# sg_readcap /dev/sdb

Read Capacity results:

=A0=A0 Last logical block address=3D140174231 (0x85ae397), Number of bl=
ocks=3D140174232

=A0=A0 Logical block length=3D520 bytes

Hence:

=A0=A0 Device size: 72890600640 bytes, 69513.9 MiB, 72.89 GB

[root@fedora13 ~]#


Thanks


On Tue, Jul 6, 2010 at 2:53 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> >>>>> "Dan" =3D=3D Dan Porat <dan.porat@gmail.com> writes:
>
> Dan> We checked with kernel 2.6.34 , Seagate Cheetah 15K and the
> Dan> following HBA: LSI 9212-4i4e
>
> Dan> Still , no success.
>
> Send us the output of:
>
> # lsscsi -p
> # sg_inq -x /dev/sdN
> # sg_readcap -l /dev/sdN
>
>
> Dan> Any Ideas?
>
> And you are sure that the drive is formatted with DIF? =A0Seagate's
> standard firmware doesn't support it, fwiw. =A0It's a build-to-order
> option.
>
> Hitachi drives support DIF out of the box.
>
> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering
