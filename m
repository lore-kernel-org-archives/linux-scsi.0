From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Wed, 30 Dec 2015 21:21:47 +0200
Message-ID: <D1FDE9A6-D190-4ABC-B935-56A65200956A@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <20151221134649.293a1a1e@harpe.intellique.com> <F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi> <20151221185759.38dd21d6@harpe.intellique.com> <3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi> <alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr> <20151229175859.0c2c9b91@harpe.intellique.com> <8BB7A0F5-0F45-48C4-AB16-1EB7F23BD565@kolumbus.fi> <20151229191347.2e0e5f0e@harpe.intellique.com> <alpine.LSU.2.11.1512301947150.1713@xnv.znxvfnen.cevingr> <20151230193309.0df94c88@harpe.intellique.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:55925 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbbL3TVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2015 14:21:52 -0500
In-Reply-To: <20151230193309.0df94c88@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org


> On 30.12.2015, at 20.33, Emmanuel Florac <eflorac@intellique.com> wro=
te:
>=20
> Le Wed, 30 Dec 2015 19:54:01 +0200 (EET)
> Kai Makisara <Kai.Makisara@kolumbus.fi> =C3=A9crivait:
>=20
>> I think I found out why it did not work with the default format. At
>> the end of this message you find a new patch that should correct
>> that. There are also other changes:
>> - some changes when specifying the size in the mode page; needed for
>> the IBM 3592 drives but should not change results with LTO
>> - formatting with one partition is done directly with FORMAT MEDIUM =
if
>>  the drive requires that command
>> - some other bugs fixed
>=20
> Hum, I can't seem to be able to go back to 1 partition, or to reforma=
t
> the tape (didn't change it since yesterday), am I missing something?
>=20
> Dec 30 19:21:29 shakuhachi kernel: st: Version 20151230, fixed bufsiz=
e 32768, s/g segs 256
> Dec 30 19:21:29 shakuhachi kernel: st 7:0:0:0: Attached scsi tape st0
> Dec 30 19:21:29 shakuhachi kernel: st 7:0:0:0: st0: try direct i/o: y=
es (alignment 512 B)
>=20
> ~# mt -f /dev/nst0  mkpartition 0
>=20
> Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - =
16777215 bytes.
> Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Lengt=
h 11, medium 0, WBS 10, BLL 8
> Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape =
length: 0, drv buffer: 1
> Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, bu=
ffer size: 4096 (1 blocks).
> Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.
> Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Partition page le=
ngth is 16 bytes.
> Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1,=
 xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2543 38
> Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Sending FORMAT ME=
DIUM
> Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Error: 8000002, c=
md: 4 0 0 0 0 0
> Dec 30 19:24:41 shakuhachi kernel: st0: Sense Key : Illegal Request [=
current]=20
> Dec 30 19:24:41 shakuhachi kernel: st0: Add. Sense: Position past beg=
inning of medium

This happens if the position is not at the beginning of partition 0. Co=
uld you try
to switch to partition 0:
mt -f /dev/nst0 setpartition 0
mt -f /dev/nst0 status

and the retry partitioning.

> ~# mt -f /dev/nst0  mkpartition 1
>=20
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - =
16777215 bytes.
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Lengt=
h 11, medium 0, WBS 10, BLL 8
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape =
length: 0, drv buffer: 1
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, bu=
ffer size: 4096 (1 blocks).
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Partition page le=
ngth is 16 bytes.
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1,=
 xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2543 38
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: psd_cnt 2, max.pa=
rts 3, nbr_parts 1
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Formatting tape w=
ith two partitions (FDP).
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Sent partition pa=
ge length is 12 bytes. needs_format: 1
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1,=
 xdp 4, psum 00, pofmetc 4, rec 03, units 00, sizes: 65535 0
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Error: 8000002, c=
md: 15 10 0 0 18 0
> Dec 30 19:26:12 shakuhachi kernel: st0: Sense Key : Illegal Request [=
current]=20
> Dec 30 19:26:12 shakuhachi kernel: st0: Add. Sense: Invalid field in =
parameter list
> Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Partitioning of t=
ape failed.
>=20
I have to recheck what it set into the mode page. It is still not corre=
ct in this case.

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
