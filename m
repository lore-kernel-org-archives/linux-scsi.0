From: Laurence Oberman <loberman@redhat.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Thu, 28 Jan 2016 14:21:23 -0500 (EST)
Message-ID: <77882221.9950832.1454008883494.JavaMail.zimbra@redhat.com>
References: <20151218170644.24167419@harpe.intellique.com> <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com> <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net> <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net> <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:42040 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966732AbcA1TVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 14:21:37 -0500
In-Reply-To: <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?utf-8?Q?M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: Shane M Seymour <shane.seymour@hpe.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, linux-scsi@vger.kernel.org

Hi Kai

What kernel was the last patch you attached against.

Thanks

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
To: "Shane M Seymour" <shane.seymour@hpe.com>
Cc: "Laurence Oberman" <loberman@redhat.com>, "Emmanuel Florac" <eflora=
c@intellique.com>, "Laurence Oberman" <oberman.l@gmail.com>, linux-scsi=
@vger.kernel.org
Sent: Thursday, January 28, 2016 12:04:20 PM
Subject: Re: What partition should the MTMKPART argument specify? Was: =
Re: st driver doesn't seem to grok LTO partitioning


> On 28.1.2016, at 9.36, Seymour, Shane M <shane.seymour@hpe.com> wrote=
:
>=20
> Hi Kai,
>=20
> With the changes the I get a failure partitioning a HP DAT72 drive (D=
DS-5):
>=20
> # ./mt -f /dev/st1 stsetoption debug
> # ./mt -f /dev/st1 stsetoption can-partitions
> # ./mt -f /dev/st1 mkpartition 1000
> /dev/st1: Input/output error
>=20
=2E..
> [ 3976.389605] st 6:0:3:0: [st1] Partition page length is 10 bytes.
> [ 3976.389610] st 6:0:3:0: [st1] PP: max 1, add 0, xdp 0, psum 02, po=
fmetc 0, rec 03, units 00, sizes: 0 65535
> [ 3976.389614] st 6:0:3:0: [st1] MP: 11 08 01 00 10 03 00 00 00 00 ff=
 ff
> [ 3976.389618] st 6:0:3:0: [st1] psd_cnt 2, max.parts 1, nbr_parts 0
                                                     ^^^^^^^^^
The problem is here

=2E..
> Using a slightly older kernel to partition the DAT72 drive works (sam=
e 3 commands as above):
=2E..
> [  351.584906] st 6:0:3:0: [st1] Partition page length is 10 bytes.
> [  351.584908] st 6:0:3:0: [st1] psd_cnt 1, max.parts 1, nbr_parts 0

The old driver computes the psd_cnt from the returned page length. The =
same applies
to the patched driver if the SCSI level of the device < SCSI_3. This wo=
rks correctly with
my drive that reports SCSI_2. So, the question is: what SCSI level does=
 your device
report?

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
