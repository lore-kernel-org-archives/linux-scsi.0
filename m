From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Tue, 29 Dec 2015 19:18:37 +0200
Message-ID: <BEAEABAA-F701-4FCD-B231-4A9D02E166A2@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <20151221134649.293a1a1e@harpe.intellique.com> <F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi> <20151221185759.38dd21d6@harpe.intellique.com> <3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi> <alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr> <20151229175959.634d9eb5@harpe.intellique.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:46262 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbbL2RSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2015 12:18:41 -0500
In-Reply-To: <20151229175959.634d9eb5@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org


> On 29.12.2015, at 18.59, Emmanuel Florac <eflorac@intellique.com> wro=
te:
>=20
> Le Fri, 25 Dec 2015 17:53:46 +0200 (EET)
> Kai Makisara <Kai.Makisara@kolumbus.fi> =C3=A9crivait:
>=20
>> the patch implements the following: if the=20
>> size is 1, the driver tells the drive to use default partitioning fo=
r=20
>> two partitions. For the HP Ultrium this should result in partition 0
>> of 1425 GB and 1 of 37.5 GB. I don't know if this is a useful
>> addition.
>=20
> Oh BTW I didn't check what's happening in code, but actual values
> should be 37.5 GB for partition 0 and 1425 GB for partition 1, not th=
e
> other way around.
>=20

What I quoted is from the HP manual. The driver tells the drive to form=
at
the tape according to the default of the drive (i.e., sets the FDP bit =
in the
mode page).

The order of partitions is an interesting question. The usual use case =
is
to have a small partition for the index and a large partition for the d=
ata.
The small partition should positioned so that it can be accessed fast. =
=46or
the old really linear drives this means the beginning. It was decided t=
hat
the first partition on the tape was given number one and the second
partition had the number zero. The HP LTO seems to use this numbering
for the default.

The SCSI standard does not specify how the partitions should be numbere=
d.
Many drives use physically sequential numbering nowadays. LTO uses
wrap-wise partitioning and I don=E2=80=99t think locations of the parti=
tions have any
effect on access speed.

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
