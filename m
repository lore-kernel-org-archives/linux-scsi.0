From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Tue, 29 Dec 2015 19:46:11 +0200
Message-ID: <8BB7A0F5-0F45-48C4-AB16-1EB7F23BD565@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <20151221134649.293a1a1e@harpe.intellique.com> <F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi> <20151221185759.38dd21d6@harpe.intellique.com> <3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi> <alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr> <20151229175859.0c2c9b91@harpe.intellique.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs14.mail.saunalahti.fi ([62.142.117.201]:33086 "EHLO
	vs14.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbbL2RqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2015 12:46:15 -0500
In-Reply-To: <20151229175859.0c2c9b91@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org


> On 29.12.2015, at 18.58, Emmanuel Florac <eflorac@intellique.com> wro=
te:
>=20
> Le Fri, 25 Dec 2015 17:53:46 +0200 (EET)
> Kai Makisara <Kai.Makisara@kolumbus.fi> =C3=A9crivait:
>=20
>> The patch uses the scsi level of the device to separate processing.
>> The FORMAT MEDIUM command is defined in SCSI-3 and I suppose that no
>> current drive is still SCSI-2. In addition to the "sane" changes
>> using the method to specify partitions, the patch implements the
>> following: if the size is 1, the driver tells the drive to use
>> default partitioning for two partitions. For the HP Ultrium this
>> should result in partition 0 of 1425 GB and 1 of 37.5 GB. I don't
>> know if this is a useful addition.
>=20
> Still testing, with another, LTO-5 tape:
>=20
> ~# mt -f /dev/nst0 mkpartition 0
> /dev/nst0: Invalid argument
>=20
It seems that you have not told the st driver that your drive knows par=
titions. One way to set the
options is to use the stint program and proper definitions. You can als=
o use
mtst -f /dev/nst0 stsetoption can-partitions

> Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - =
16777215 bytes.
> Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Lengt=
h 11, medium 0, WBS 10, BLL 8
> Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Density 58, tape =
length: 0, drv buffer: 1
> Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, bu=
ffer size: 4096 (1 blocks).
>=20
The st driver prints some debugging data to the kernel log if debugging=
 is enabled. If the driver
is compiled with debugging (it is nowadays default but in 3.18 you shou=
ld change DEBUG to 1
in st.c). The debugging output can be enabled with the command:
mtst -f /dev/nst0 stsetoption debug

Here is the debugging output when I make a 10 MB partition with my driv=
e:
[ 2199.572546] st 4:0:5:0: [st0] Block limits 1 - 16777215 bytes.
[ 2199.573367] st 4:0:5:0: [st0] Mode sense. Length 11, medium 0, WBS 1=
0, BLL 8
[ 2199.573375] st 4:0:5:0: [st0] Density 26, tape length: 0, drv buffer=
: 1
[ 2199.573380] st 4:0:5:0: [st0] Block size: 0, buffer size: 4096 (1 bl=
ocks).
[ 2199.573403] st 4:0:5:0: [st0] Rewinding tape.
[ 2199.575319] st 4:0:5:0: [st0] Partition page length is 10 bytes.
[ 2199.575328] st 4:0:5:0: [st0] PP: max 1, add 1, xdp 0, psum 02, pofm=
etc 0,rec 03 units 00, sizes: 100 65535
[ 2199.575333] st 4:0:5:0: [st0] psd_cnt 1, max.parts 1, nbr_parts 1
[ 2199.575338] st 4:0:5:0: [st0] Formatting tape with two partitions (1=
 =3D 10 MB).
[ 2199.575342] st 4:0:5:0: [st0] Sent partition page length is 10 bytes=
=2E needs_format: 0
[ 2199.575348] st 4:0:5:0: [st0] PP: max 1, add 1, xdp 1, psum 02, pofm=
etc 0,rec 03 units 00, sizes: 10 65535

Regardless whether the partitioning works with your drive, your should =
see at least few lines after =E2=80=9CRewinding tape=E2=80=9D.
The driver first reads the partition mode page and (for testing) prints=
 some data from the page.

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
