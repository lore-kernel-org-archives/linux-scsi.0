From: Laurence Oberman <loberman@redhat.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Tue, 5 Jan 2016 16:55:04 -0500 (EST)
Message-ID: <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com>
References: <20151218170644.24167419@harpe.intellique.com> <20151230193309.0df94c88@harpe.intellique.com> <D1FDE9A6-D190-4ABC-B935-56A65200956A@kolumbus.fi> <20151230222418.03e40cf7@harpe.intellique.com> <AC6651F8-0642-42DF-A3B1-72C5A8D8E665@kolumbus.fi> <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr> <20160104124626.3112e8c0@harpe.intellique.com> <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:47100 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbcAEVzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2016 16:55:17 -0500
In-Reply-To: <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <oberman.l@gmail.com>oberman.l@gmail.com, eflorac@intellique.com, Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org

Testing the patch here in the lab, it seems my firmware will need to be=
 updated to support more than 1 partition.
Looking into that now.

[  193.647807] st: Version 20160104, fixed bufsize 32768, s/g segs 256
[  193.648992] st: Debugging enabled debug_flag =3D 1
[  193.650907] st 0:0:0:0: Attached scsi tape st0
[  193.652046] st 0:0:0:0: st0: try direct i/o: yes (alignment 4 B)

[  280.069260] st 0:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[  280.070543] st 0:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 1=
0, BLL 8
[  280.073068] st 0:0:0:0: [st0] Density 58, tape length: 0, drv buffer=
: 1
[  280.073725] st 0:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 bl=
ocks).

 mt -f /dev/st0  stsetoption can-partitions

[  676.835972] st 0:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[  676.837403] st 0:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 1=
0, BLL 8
[  676.838404] st 0:0:0:0: [st0] Density 58, tape length: 0, drv buffer=
: 1
[  676.838880] st 0:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 bl=
ocks).
[  676.840383] st 0:0:0:0: [st0] Mode 0 options: buffer writes: 1, asyn=
c writes: 1, read ahead: 1
[  676.840880] st 0:0:0:0: [st0]     can bsr: 1, two FMs: 0, fast mteom=
: 0, auto lock: 0,
[  676.842424] st 0:0:0:0: [st0]     defs for wr: 0, no block limits: 0=
, partitions: 1, s2 log: 0
[  676.842937] st 0:0:0:0: [st0]     sysv: 0 nowait: 0 sili: 0 nowait_f=
ilemark: 0
[  676.844524] st 0:0:0:0: [st0]     debugging: 1
[  676.845042] st 0:0:0:0: [st0] Rewinding tape.

mt -f /dev/nst0  mkpartition 1

[  798.711408] st 0:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[  798.712799] st 0:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 1=
0, BLL 8
[  798.713948] st 0:0:0:0: [st0] Density 58, tape length: 0, drv buffer=
: 1
[  798.714504] st 0:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 bl=
ocks).
[  798.716227] st 0:0:0:0: [st0] Loading tape.
[  798.731230] st 0:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[  798.732874] st 0:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 1=
0, BLL 8
[  798.734269] st 0:0:0:0: [st0] Density 58, tape length: 0, drv buffer=
: 1
[  798.734971] st 0:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 bl=
ocks).
[  798.737572] st 0:0:0:0: [st0] Partition page length is 10 bytes.
[  798.739162] st 0:0:0:0: [st0] PP: max 0, add 0, xdp 0, psum 03, pofm=
etc 0,rec 03, units 09, sizes: 1541 65535
[  798.739974] st 0:0:0:0: [st0] MP: 11 08 00 00 18 03 09 00 06 05 ff f=
f
[  798.740810] st 0:0:0:0: [st0] psd_cnt 2, max.parts 0, nbr_parts 0
[  798.744194] st 0:0:0:0: [st0] Formatting tape with two partitions (F=
DP).
[  798.745045] st 0:0:0:0: [st0] Sent partition page length is 12 bytes=
=2E  needs_format: 0
[  798.747718] st 0:0:0:0: [st0] PP: max 0, add 1, xdp 4, psum 03, pofm=
etc 0 rec 03, units 00, sizes: 65535 65535
[  798.748558] st 0:0:0:0: [st0] MP: 11 0a 00 01 98 03 00 00 ff ff ff f=
f
[  798.752622] st 0:0:0:0: [st0] Error: 8000002, cmd: 15 10 0 0 18 0
[  798.753465] st 0:0:0:0: [st0] Sense Key : Illegal Request [current]=20
[  798.754289] st 0:0:0:0: [st0] Add. Sense: Invalid field in parameter=
 list
[  798.757546] st 0:0:0:0: [st0] Partitioning of tape failed.



Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services


=46rom: Emmanuel Florac <eflorac@intellique.com>
Date: Mon, Jan 4, 2016 at 6:46 AM
Subject: Re: st driver doesn't seem to grok LTO partitioning
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org


Le Mon, 4 Jan 2016 12:22:34 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> =C3=A9crivait:

> Here is again a new version of the patch. This does load before
> partitioning. The code performing default partitioning (FDP=3D1) has
> also been slightly modified (two more bits of the original mode page
> retained).
>
> The patch has been tested with my DDS-4 drive.

That works fine for me. I'm going to do some testing with other drives
I have (LTO-3 -- should fail -- and LTO-5).

# modprobe st

Jan  4 12:31:53 shakuhachi kernel: st: Version 20160104, fixed bufsize
32768, s/g segs 256
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: Attached scsi tape st0
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: st0: try direct i/o: yes
(alignment 512 B)
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 -
16777215 bytes.
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11,
medium 0, WBS 10, BLL 8
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape
length: 0, drv buffer: 1
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er
size: 4096 (1 blocks).
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 -
16777215 bytes.
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11,
medium 0, WBS 10, BLL 8
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape
length: 0, drv buffer: 1
Jan  4 12:31:53 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er
size: 4096 (1 blocks).


# mt -f /dev/st0  stsetoption debug

Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 -
16777215 bytes.
Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11,
medium 0, WBS 10, BLL 8
Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape
length: 0, drv buffer: 1
Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er
size: 4096 (1 blocks).
Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0: Mode 0 options: buf=
fer
writes: 1, async writes: 1, read ahead: 1
Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0:     can bsr: 1, two
=46Ms: 0, fast mteom: 0, auto lock: 0,
Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0:     defs for wr: 0,=
 no
block limits: 0, partitions: 0, s2 log: 0
Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0:     sysv: 0 nowait:=
 0
sili: 0 nowait_filemark: 0
Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0:     debugging: 1
Jan  4 12:32:04 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.

# mt -f /dev/st0  stsetoption can-partitions


Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 -
16777215 bytes.
Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11,
medium 0, WBS 10, BLL 8
Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape
length: 0, drv buffer: 1
Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er
size: 4096 (1 blocks).
Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0: Mode 0 options: buf=
fer
writes: 1, async writes: 1, read ahead: 1
Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0:     can bsr: 1, two
=46Ms: 0, fast mteom: 0, auto lock: 0,
Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0:     defs for wr: 0,=
 no
block limits: 0, partitions: 1, s2 log: 0
Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0:     sysv: 0 nowait:=
 0
sili: 0 nowait_filemark: 0
Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0:     debugging: 1
Jan  4 12:39:38 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.

# mt -f /dev/nst0  mkpartition 1


Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 -
16777215 bytes.
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11,
medium 0, WBS 10, BLL 8
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape
length: 0, drv buffer: 1
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er
size: 4096 (1 blocks).
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Updating partition
number in status.
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Got tape pos. blk 0
part 0.
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Loading tape.
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 -
16777215 bytes.
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11,
medium 0, WBS 10, BLL 8
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape
length: 0, drv buffer: 1
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er
size: 4096 (1 blocks).
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Partition page leng=
th
is 16 bytes.
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 0, x=
dp
1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2620 0
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: MP: 11 0e 03 00 3c =
03
09 00 0a 3c 00 00
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: psd_cnt 2, max.part=
s 3,
nbr_parts 0
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Formatting tape wit=
h
two partitions (FDP).
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Sent partition page
length is 12 bytes. needs_format: 1
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1, x=
dp
4, psum 03, pofmetc 4, rec 03, units 00, sizes: 65535 0
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: MP: 11 0a 03 01 9c =
03
00 00 ff ff 00 00
Jan  4 12:40:01 shakuhachi kernel: st 7:0:0:0: st0: Sending FORMAT MEDI=
UM


# mt -f /dev/nst0 status
SCSI 2 tape drive:
=46ile number=3D0, block number=3D0, partition=3D0.
Tape block size 0 bytes. Density code 0x5a (no translation).
Soft error count since last status=3D0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN

Jan  4 12:40:28 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 -
16777215 bytes.
Jan  4 12:40:28 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11,
medium 0, WBS 10, BLL 8
Jan  4 12:40:28 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape
length: 0, drv buffer: 1
Jan  4 12:40:28 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er
size: 4096 (1 blocks).

# mt -f /dev/nst0 setpartition 1
# mt -f /dev/nst0 status
SCSI 2 tape drive:
=46ile number=3D0, block number=3D0, partition=3D1.
Tape block size 0 bytes. Density code 0x5a (no translation).
Soft error count since last status=3D0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN

# mt -f /dev/nst0 mkpartition 0


Jan  4 12:42:15 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 -
16777215 bytes.
Jan  4 12:42:15 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11,
medium 0, WBS 10, BLL 8
Jan  4 12:42:15 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape
length: 0, drv buffer: 1
Jan  4 12:42:15 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er
size: 4096 (1 blocks).
Jan  4 12:42:15 shakuhachi kernel: st 7:0:0:0: st0: Loading tape.
Jan  4 12:42:18 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 -
16777215 bytes.
Jan  4 12:42:18 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11,
medium 0, WBS 10, BLL 8
Jan  4 12:42:18 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape
length: 0, drv buffer: 1
Jan  4 12:42:18 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er
size: 4096 (1 blocks).
Jan  4 12:42:18 shakuhachi kernel: st 7:0:0:0: st0: Partition page leng=
th
is 16 bytes.
Jan  4 12:42:18 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1, x=
dp
1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2543 38
Jan  4 12:42:18 shakuhachi kernel: st 7:0:0:0: st0: MP: 11 0e 03 01 3c =
03
09 00 09 ef 00 26
Jan  4 12:42:18 shakuhachi kernel: st 7:0:0:0: st0: Sending FORMAT MEDI=
UM

# tapeinfo -f /dev/sg6
Product Type: Tape Drive
Vendor ID: 'HP      '
Product ID: 'Ultrium 6-SCSI  '
Revision: '329U'
Attached Changer API: No
SerialNumber: 'HU1302U4RC'
MinBlock: 1
MaxBlock: 16777215
SCSI ID: 0
SCSI LUN: 0
Ready: yes
BufferedMode: yes
Medium Type: Not Loaded
Density Code: 0x5a
BlockSize: 0
DataCompEnabled: yes
DataCompCapable: yes
DataDeCompEnabled: yes
CompType: 0x1
DeCompType: 0x1
BOP: yes
Block Position: 0
ActivePartition: 0
EarlyWarningSize: 0
NumPartitions: 0
MaxPartitions: 3



--
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |   <eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
