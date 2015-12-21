From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Mon, 21 Dec 2015 20:57:42 +0200
Message-ID: <3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <20151221134649.293a1a1e@harpe.intellique.com> <F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi> <20151221185759.38dd21d6@harpe.intellique.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:47604 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbbLUS5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 13:57:46 -0500
In-Reply-To: <20151221185759.38dd21d6@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org


> On 21.12.2015, at 19.57, Emmanuel Florac <eflorac@intellique.com> wro=
te:
>=20
> Le Mon, 21 Dec 2015 19:25:27 +0200
> "Kai M=C3=A4kisara (Kolumbus)"  <kai.makisara@kolumbus.fi> =C3=A9criv=
ait:
>=20
>>>=20
>>> I'm replying to myself: this is very obviously a limitation of the
>>> st driver. Checking st.c partition_tape() function, it looks like
>>> it only knows of hardware from past century=E2=80=A6=20
>>>=20
>> True, it does support only the methods supported by the drives
>> available to the developers at that time :-) However, I am not any
>> more convinced that partitioning a tape should be done by the kernel
>> driver. A more flexible method would be a user space program using s=
g
>> (or bsg) driver.
>=20
> Yes, that's the way the LTFS utility works. That makes the code of th=
e
> application quite hard to read, though, as partitioning on modern
> drives is pretty complex and requires understanding ugly, unholy SCSI
> commands magic. Then Windows/Cygwin, IBM AIX and maybe others seem to
> implement partitioning at the kernel level.
>=20
> Do you suggest the current mkpartition/setpartition scheme should be
> removed instead of enhanced ? :)
>=20
I don=E2=80=99t suggest that it should be removed. I just pointed out a=
nother possibility
to implement the more complex formatting cases. I think that SCSI is we=
ll defined,
but it offers too many ways to do one thing :-) In user space one can i=
mplement
several alternatives but the kernel driver has to choose only one (or m=
ove the
complexity to the interface). On the other hand, the kernel driver can =
allow
anyone (who can access the st device) to partition the tape. A user spa=
ce
program needs more rights.

If the current interface (MTMKPART) is acceptable, we could enhance the=
 driver
so that it handles properly more drives. I looked at the HP Ultrium SCS=
I reference
and it may not be too complicated (for instance, it needs a separate FO=
RMAT MEDIUM
command) . I have also found an IBM reference and others can probably b=
e found.
I can look at the manuals during Christmas holidays and try to think ab=
out a suggestion.
All other suggestions are, of course, welcome. My view may be somewhat =
theoretical
because I don=E2=80=99t have access to current hardware.

>>> OTOH it seems that Cygwin does that properly... by using
>>> CreateTapePartition, a windows kernel32.dll function. Argh. We'll
>>> have to do the heavy lifting of SCSI commands by hand, then.
>>>=20
>>> Where should we post an eventual patch, given that the linux-tape M=
L
>>> looks like a ghost town? It would also be great to be able to
>>> support more than 2 partitions (LTO-6 and 7 support 4), but that
>>> would require patching the mt utility too, but I don't where it
>>> currently lives :) Any hints welcome.
>>>=20
>> This (linux-scsi) is the correct mailing list.
>>=20
>=20
> OK. As I mentioned, the bizarre IBM lin_tape driver (what use is it?)
> implements the complete scheme properly apparently, in a nice GPL2 co=
de.
> Why they didn't contribute it directly to the st driver is mysterious=
=2E
>=20
I will look at the driver. HP also seems to have an implementation (for=
 LTFS) but
I did not find the code because their web links don=E2=80=99t seem to b=
e uptodate.

>> The correct source code of your mt depends on the version you are
>> using (check the distribution). Not also that the ioctl method for
>> creating partitions available in the kernel supports only up to two
>> partitions. If you want more, you should design a new interface.
>=20
> I'm using mt-st on debian, the one that seems to go hand in hand with
> the st driver. Both carry your copyright :)
>=20
OK. Then the mt part will not be a problem. I have not updated it =E2=80=
=9Crecently=E2=80=9D
because the kernel interface has not changed.

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
