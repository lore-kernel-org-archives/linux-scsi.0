From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Tue, 29 Dec 2015 18:58:41 +0100
Message-ID: <20151229185841.14d8e5f5@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<20151221134649.293a1a1e@harpe.intellique.com>
	<F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi>
	<20151221185759.38dd21d6@harpe.intellique.com>
	<3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
	<alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr>
	<20151229175859.0c2c9b91@harpe.intellique.com>
	<8BB7A0F5-0F45-48C4-AB16-1EB7F23BD565@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:62783 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbbL2R6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2015 12:58:37 -0500
In-Reply-To: <8BB7A0F5-0F45-48C4-AB16-1EB7F23BD565@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kai =?UTF-8?B?TcOka2lzYXJh?= (Kolumbus)" <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Le Tue, 29 Dec 2015 19:46:11 +0200
"Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi> =C3=A9crivait=
:

> It seems that you have not told the st driver that your drive knows
> partitions. One way to set the options is to use the stint program
> and proper definitions. You can also use mtst -f /dev/nst0
> stsetoption can-partitions
>=20

Silly me. I forgot that one.

> The st driver prints some debugging data to the kernel log if
> debugging is enabled. If the driver is compiled with debugging (it is
> nowadays default but in 3.18 you should change DEBUG to 1 in st.c).

Yup this is the output from the driver with DEBUG at 1.=20

> The debugging output can be enabled with the command: mtst
> -f /dev/nst0 stsetoption debug

Ah yes, it works!

> Regardless whether the partitioning works with your drive, your
> should see at least few lines after =E2=80=9CRewinding tape=E2=80=9D.=
 The driver
> first reads the partition mode page and (for testing) prints some
> data from the page.

So here is the result of my testings so far. Alas, it fails on the
goal line!:

# mt -f /dev/st0  stsetoption debug


Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Density 58, tape le=
ngth: 0, drv buffer: 1
Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0: Error: 8000002, cmd=
: 0 0 0 0 0 0
Dec 29 18:51:45 shakuhachi kernel: st0: Sense Key : Unit Attention [cur=
rent]=20
Dec 29 18:51:45 shakuhachi kernel: st0: Add. Sense: Not ready to ready =
change, medium may have changed
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape le=
ngth: 0, drv buffer: 1
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0: Mode 0 options: buf=
fer writes: 1, async writes: 1, read ahead: 1
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0:     can bsr: 1, two=
 FMs: 0, fast mteom: 0, auto lock: 0,
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0:     defs for wr: 0,=
 no block limits: 0, partitions: 0, s2 log: 0
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0:     sysv: 0 nowait:=
 0 sili: 0 nowait_filemark: 0
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0:     debugging: 1
Dec 29 18:51:45 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.

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

~# mt -f /dev/st0  stsetoption can-partitions

Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape le=
ngth: 0, drv buffer: 1
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0: Updating partition =
number in status.
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0: Got tape pos. blk 0=
 part 0.
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0: Mode 0 options: buf=
fer writes: 1, async writes: 1, read ahead: 1
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0:     can bsr: 1, two=
 FMs: 0, fast mteom: 0, auto lock: 0,
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0:     defs for wr: 0,=
 no block limits: 0, partitions: 1, s2 log: 0
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0:     sysv: 0 nowait:=
 0 sili: 0 nowait_filemark: 0
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0:     debugging: 1
Dec 29 18:54:04 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.

# mt -f /dev/st0  mkpartition 1
/dev/st0: Input/output error

Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape le=
ngth: 0, drv buffer: 1
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Partition page leng=
th is 16 bytes.
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 0, x=
dp 1, psum 03, pofmetc 0,rec 03 units 09, sizes: 2620 0
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: psd_cnt 2, max.part=
s 3, nbr_parts 0
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Formatting tape wit=
h two partitions (FDP).
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Sent partition page=
 length is 12 bytes. needs_format: 0
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1, x=
dp 4, psum 00, pofmetc 0,rec 03 units 00, sizes: 65535 0
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Error: 8000002, cmd=
: 15 10 0 0 18 0
Dec 29 18:55:54 shakuhachi kernel: st0: Sense Key : Illegal Request [cu=
rrent]=20
Dec 29 18:55:54 shakuhachi kernel: st0: Add. Sense: Invalid field in pa=
rameter list
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Partitioning of tap=
e failed.
Dec 29 18:55:54 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.





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
