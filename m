From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Fri, 22 Jan 2016 12:24:57 +0100
Message-ID: <20160122122457.7afae563@harpe.intellique.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:48853 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbcAVLY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2016 06:24:58 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: "Kai =?UTF-8?B?TcOka2lzYXJh?= (Kolumbus)" <kai.makisara@kolumbus.fi>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Fri, 22 Jan 2016 02:10:03 +0000
"Seymour, Shane M" <shane.seymour@hpe.com> =C3=A9crivait:

> > However, before making the final patch, we should decide which
> > partition the specified size should apply to. For the SCSI level
> > <=3D2 it applies to partition 1. For other drives we may have some
> > freedom to =E2=80=9Ctune=E2=80=9D the definition. The size should a=
pply to the
> > partition the users expect it to apply. =20
>=20
> I'd argue for consistency here in the current interface and that it
> should apply in the same way more on that below.

I agree, it would be extremely surprising (in a bad way) to see your
application behave differently when upgrading your drive, for instance.

> > Partitioning with two partitions is used for storing index in a
> > small partition and use the rest of the tape for data. In this
> > case, it is probably natural to specify the size of the index. The
> > LTFS definition supports index in any partition. The open source
> > code I have seen seem to default to index in partition 0.
> >=20
> > The HP and IBM LTO default partitioning (FDP=3D1) specifies two wra=
ps
> > (minimum) to partition 1 and the rest to 0. =20

LTFS 2.2 specifications doesn't explicitly number partitions, however
it makes it clear that the "index" partition (the smaller one) must com=
e
first. Furthermore, all LTFS tapes I've had a look at have partition 0
as index.=20
Add to this the fact that current LTO-7 tapes are 6 TB. That comes to
pretty big numbers when you want to size a partition in MB.=20

> It may be worth noting (if you're going to update any documentation)
> that isn't 100% accurate. You actually get one wrap in partition 1
> and the rest minus one wrap into partition 0. There is one wrap used
> as a guard between the two partitions. The size given to a partition
> is rounded up to the size of a wrap as well.
>=20
> See
> https://docs.oracle.com/cd/E21419_04/en/LTO5_Vol3_E5b/LTO5_Vol3_E5b.p=
df
>=20
> Page 100 where it gives examples of how partition sizes are
> calculated on HP LTO5 drives.
>=20

Ican confirm this from the tests I've made on LTO-5 and LTO-6. The size
of the partition you'll obtain may end quite different from the size
you've asked for. This is made particularly difficult when you must
convert a few TB to MB, and you don't know exactly where it'll=20

> >=20
> > There seem to be lot of arguments supporting both possible choices.
> > Should we use the existing definition (1) or change it for the
> > drives supporting SCSI level >=3D 3 (or supporting FORMAT MEDIUM)?
> > The definition can=E2=80=99t be changed later. This is why we shoul=
d make a
> > good decision.
> >=20
> > Opinions? =20
>=20
> How about using the fact the size is signed to indicate one slightly
> different thing? I'm not sure if you'd call this using or abusing the
> fact that it's signed.
>=20
> Make the default behavior for a positive size the same as the current
> behavior for SCSI-2 (size applies to partition 1). If the size is
> negative then the absolute value of the size applies to partition 0.
> That provides some flexibility in choosing which partition the size
> applies to if it worked that way for all devices.
>=20
> With that you also get consistent behavior between tape drives withou=
t
> having to know if the size will apply to partition 0 or partition 1
> based on the tape technology and you get the benefit of being able to
> set an explicit size for partition 0 or partition 1.
>=20
> You could overload the value of 0 as well to use FDP to choose the
> sizes for the partitions (assuming 0 doesn't already have a side
> effect in the code). Then you get whatever the tape drive wants to do=
=2E



--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
