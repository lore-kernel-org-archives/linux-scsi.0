From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Fri, 22 Jan 2016 12:50:45 +0100
Message-ID: <20160122125045.0a432e53@harpe.intellique.com>
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
Received: from mail1.g1.pair.com ([66.39.3.162]:37693 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbcAVLuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2016 06:50:44 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: "Kai =?UTF-8?B?TcOka2lzYXJh?= (Kolumbus)" <kai.makisara@kolumbus.fi>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Ooops, fat finger posting before I've finished answering...

Le Fri, 22 Jan 2016 02:10:03 +0000
"Seymour, Shane M" <shane.seymour@hpe.com> =C3=A9crivait:

> >=20
> > There seem to be lot of arguments supporting both possible choices.
> > Should we use the existing definition (1) or change it for the
> > drives supporting SCSI level >=3D 3 (or supporting FORMAT MEDIUM)?
> > The definition can=E2=80=99t be changed later. This is why we shoul=
d make a
> > good decision.
> >=20
> > Opinions? =20
>
> How about using the fact the size is signed to indicate one slightly
> different thing? I'm not sure if you'd call this using or abusing the
> fact that it's signed.
>=20

I find the idea of using negative number as "interesting". I'm afraid
of what will happen as tape size grows? Don't we risk overflowing at
some point, and ending with very unexpected results?

Hmm in fact if we keep using MB we'll be stuck when tapes reach ~2 PB
which leaves some time to think about it, until LTO-15 circa 2036 :)

I have a different proposition: what about adding a new ioctl named
MTMKADVPART that takes a struct to define many different partitions at
once? So that we'd be able to create 2 partitions with the existing
MTMKPART, and also create several partitions for newer drives?

Added bonus a corresponding ioctl to read the media configuration as
specified in mode sense page 11h (see LTO SCSI reference) and present
it back so that we could know how the tape is actually partitioned :)


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
