From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Thu, 28 Jan 2016 18:39:54 +0100
Message-ID: <20160128183954.61a63c5c@harpe.intellique.com>
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
	<20160122125045.0a432e53@harpe.intellique.com>
	<DDB9C85B850785449757F9914A034FCB44520BDB@G9W0766.americas.hpqcorp.net>
	<29BBF79F-C32C-479C-9ED1-31E647B98A9E@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:25609 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbcA1Rjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 12:39:51 -0500
In-Reply-To: <29BBF79F-C32C-479C-9ED1-31E647B98A9E@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kai =?UTF-8?B?TcOka2lzYXJh?= (Kolumbus)" <kai.makisara@kolumbus.fi>
Cc: "Seymour, Shane M" <shane.seymour@hpe.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Thu, 28 Jan 2016 19:31:10 +0200
"Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi> =C3=A9crivait=
:

> > On 27.1.2016, at 1.35, Seymour, Shane M <shane.seymour@hpe.com>
> > wrote:
> >=20
> > Hi Emmanuel,
> >  =20
> >> Hmm in fact if we keep using MB we'll be stuck when tapes reach ~2
> >> PB which leaves some time to think about it, until LTO-15 circa
> >> 2036 :) =20
> >=20
> > There will be other issues to solve before then (by LTO-9 2 with
> > compression or LTO-10 without compression and we're at LTO-7 now).
> > Take tar format archives with a standard block size of 10k can take
> > this much data to get to 2^32 blocks and cause the current 32bit
> > block number to wrap:
> >=20
> > 43,980,465,111,040 (2^32 * 10240)
> >  =20
> This is a somewhat theoretic example. In the 1990s no reasonable
> person used block size below 32 kB. Now the limit is probably higher.
> But, eventually we have to enlarge the block position and count
> variables.

You'd be surprised. In fact current LTO drive performance maxes out
between 32k and 256k. Most people would use 64k. Default for LTFS is
512k. Many, many people just use tar with the default block size, not
knowing any better (yay, shoeshine).
=20
> > That's probably the correct time to also look at adding support for
> > more partitions. Not sure when the extended block id form of READ
> > POSITION got added but it may mean only supporting the wider values
> > only with tape drives that support REPORT SUPPORTED OPCODES (if
> > that can indicate that it supports READ POSITION with extended
> > block ids and anything else required to support block numbers
> > larger than 2^32).=20

> The current driver supports using up to ST_NBR_PARTITIONS (in the
> source set to 4). Support for using partitions must be in the driver.
> I am still not sure if partitioning the tape should be in the driver.

As a "normal" user, I pretty much don't want to ever have to look at
these atrocious SCSI reference docs :) So I'm all for as many things as
possible to be exposed through the driver instead. I'm pretty confident
that I'm expressing the ordinary developer/admin point of view here :)


> > The 0x91 version of SPACE needs to be used as well (the 32bit
> > version 0x11 Is currently used) to allow tape movement with counts
> > >2^32. That requires a new ioctl call. I haven't looked at what
> > >else may need to change but there's
> > likely to be more. The alternate version of SPACE is from page 220
> > of the above HP LTO5 tape reference.
> >  =20
> The first step is to make the internal counters 64 bits. Then the
> code should be changed so that it can handle the large addresses.
> Note that this is necessary for handling partition changes even if no
> positioning commands are exposed to the user. The last step is to
> introduce the new positioning methods.
>=20
> The new positioning methods should perhaps be defined so that both
> the partition number and the block number are specified together. A
> proper tape address needs both.
>=20

Sounds good.

> But I think we should first fix the existing partitioning command so
> that it works for current drives.

Definitely :)

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
