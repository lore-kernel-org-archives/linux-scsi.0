From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Thu, 28 Jan 2016 23:12:41 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net>
References: <20151218170644.24167419@harpe.intellique.com>
 <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr>
 <20160104124626.3112e8c0@harpe.intellique.com>
 <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com>
 <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com>
 <20160106161049.34f29973@harpe.intellique.com>
 <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com>
 <20160106170720.61db9e86@harpe.intellique.com>
 <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
 <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net>
 <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi>
 <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
 <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr>
 <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net>
 <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5008.houston.hp.com ([15.240.92.66]:60308 "EHLO
	g9t5008.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbcA1XNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 18:13:12 -0500
In-Reply-To: <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>
Cc: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Kai,

$ pwd
/sys/class/scsi_tape/st1/device
$ cat scsi_level
4

Thanks
Shane

> -----Original Message-----
> From: "Kai M=E4kisara (Kolumbus)" [mailto:kai.makisara@kolumbus.fi]
> Sent: Friday, January 29, 2016 4:04 AM
> To: Seymour, Shane M
> Cc: Laurence Oberman; Emmanuel Florac; Laurence Oberman; linux-
> scsi@vger.kernel.org
> Subject: Re: What partition should the MTMKPART argument specify? Was=
:
> Re: st driver doesn't seem to grok LTO partitioning
>=20
>=20
> > On 28.1.2016, at 9.36, Seymour, Shane M <shane.seymour@hpe.com>
> wrote:
> >
> > Hi Kai,
> >
> > With the changes the I get a failure partitioning a HP DAT72 drive =
(DDS-5):
> >
> > # ./mt -f /dev/st1 stsetoption debug
> > # ./mt -f /dev/st1 stsetoption can-partitions # ./mt -f /dev/st1
> > mkpartition 1000
> > /dev/st1: Input/output error
> >
> ...
> > [ 3976.389605] st 6:0:3:0: [st1] Partition page length is 10 bytes.
> > [ 3976.389610] st 6:0:3:0: [st1] PP: max 1, add 0, xdp 0, psum 02,
> > pofmetc 0, rec 03, units 00, sizes: 0 65535 [ 3976.389614] st 6:0:3=
:0:
> > [st1] MP: 11 08 01 00 10 03 00 00 00 00 ff ff [ 3976.389618] st
> > 6:0:3:0: [st1] psd_cnt 2, max.parts 1, nbr_parts 0
>                                                      ^^^^^^^^^ The pr=
oblem is here
>=20
> ...
> > Using a slightly older kernel to partition the DAT72 drive works (s=
ame 3
> commands as above):
> ...
> > [  351.584906] st 6:0:3:0: [st1] Partition page length is 10 bytes.
> > [  351.584908] st 6:0:3:0: [st1] psd_cnt 1, max.parts 1, nbr_parts =
0
>=20
> The old driver computes the psd_cnt from the returned page length. Th=
e
> same applies to the patched driver if the SCSI level of the device < =
SCSI_3.
> This works correctly with my drive that reports SCSI_2. So, the quest=
ion is:
> what SCSI level does your device report?
>=20
> Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
