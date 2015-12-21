From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Mon, 21 Dec 2015 19:25:27 +0200
Message-ID: <F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <20151221134649.293a1a1e@harpe.intellique.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs17.mail.saunalahti.fi ([62.142.117.198]:54697 "EHLO
	vs17.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbLURZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 12:25:32 -0500
In-Reply-To: <20151221134649.293a1a1e@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org


> On 21.12.2015, at 14.46, Emmanuel Florac <eflorac@intellique.com> wro=
te:
>=20
> Le Fri, 18 Dec 2015 17:06:44 +0100
> Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:
>=20
>>=20
>> I'm trying to use mt to work with LTO-5 and bigger tapes. Switching
>> partitions works:
>>=20
>> # tapeinfo -f /dev/sg1
>> Product Type: Tape Drive
>> Vendor ID: 'HP      '
>> Product ID: 'Ultrium 5-SCSI  '
>> Revision: 'Z61U'
>> Attached Changer API: No
>> SerialNumber: 'HU1249TP88'
>> MinBlock: 1
>> MaxBlock: 16777215
>> SCSI ID: 1
>> SCSI LUN: 0
>> Ready: yes
>> BufferedMode: yes
>> Medium Type: Not Loaded
>> Density Code: 0x58
>> BlockSize: 0
>> DataCompEnabled: yes
>> DataCompCapable: yes
>> DataDeCompEnabled: yes
>> CompType: 0x1
>> DeCompType: 0x1
>> BOP: yes
>> Block Position: 0
>> Partition 0 Remaining Kbytes: 1459056
>> Partition 0 Size in Kbytes: 1459056
>> ActivePartition: 0
>> EarlyWarningSize: 0
>> NumPartitions: 1
>> MaxPartitions: 1
>> Partition0: 38
>> Partition1: 1453
>>=20
>> # mt -f /dev/nst0 setpartition 1
>>=20
>>=20
>> However "mt mkpartition" fails miserably:
>>=20
>> # mt -f /dev/nst0 mkpartition 1453
>> /dev/nst0: Input/output error
>>=20
>> # dmesg | tail
>> st 6:0:1:0: st0: Failed to read 65536 byte block with 256 byte
>> transfer. st0: Sense Key : Illegal Request [current]=20
>> st0: Add. Sense: Invalid field in parameter list
>>=20
>> Is this a limitation of mt or the st driver?
>>=20
>=20
> I'm replying to myself: this is very obviously a limitation of the st
> driver. Checking st.c partition_tape() function, it looks like it onl=
y
> knows of hardware from past century=E2=80=A6=20
>=20
True, it does support only the methods supported by the drives availabl=
e
to the developers at that time :-) However, I am not any more convinced=
 that
partitioning a tape should be done by the kernel driver. A more flexibl=
e
method would be a user space program using sg (or bsg) driver.

> OTOH it seems that Cygwin does that properly... by using
> CreateTapePartition, a windows kernel32.dll function. Argh. We'll hav=
e
> to do the heavy lifting of SCSI commands by hand, then.
>=20
> Where should we post an eventual patch, given that the linux-tape ML
> looks like a ghost town? It would also be great to be able to support
> more than 2 partitions (LTO-6 and 7 support 4), but that would requir=
e
> patching the mt utility too, but I don't where it currently lives :)
> Any hints welcome.
>=20
This (linux-scsi) is the correct mailing list.

The correct source code of your mt depends on the version you are
using (check the distribution). Not also that the ioctl method for crea=
ting
partitions available in the kernel supports only up to two partitions. =
If
you want more, you should design a new interface.

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
