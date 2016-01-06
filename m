From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Wed, 6 Jan 2016 17:10:15 +0100
Message-ID: <20160106171015.4edacf41@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<20151221134649.293a1a1e@harpe.intellique.com>
	<F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi>
	<20151221185759.38dd21d6@harpe.intellique.com>
	<3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
	<alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr>
	<20151229175859.0c2c9b91@harpe.intellique.com>
	<8BB7A0F5-0F45-48C4-AB16-1EB7F23BD565@kolumbus.fi>
	<20151229191347.2e0e5f0e@harpe.intellique.com>
	<alpine.LSU.2.11.1512301947150.1713@xnv.znxvfnen.cevingr>
	<20151230193309.0df94c88@harpe.intellique.com>
	<D1FDE9A6-D190-4ABC-B935-56A65200956A@kolumbus.fi>
	<20151230222418.03e40cf7@harpe.intellique.com>
	<AC6651F8-0642-42DF-A3B1-72C5A8D8E665@kolumbus.fi>
	<alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr>
	<20160104124626.3112e8c0@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:52297 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbcAFQKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 11:10:12 -0500
In-Reply-To: <20160104124626.3112e8c0@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Le Mon, 4 Jan 2016 12:46:26 +0100
Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:

> That works fine for me. I'm going to do some testing with other drive=
s
> I have (LTO-3 -- should fail -- and LTO-5).
>=20

Works OK with LTO-5 (HP). Sizing the partitions is quite difficult, as
you can see. To get one "wrap" in the first partition, "1400000" and
"1424000" work, but "1450000" doesn't. Same for LTO-6 (I'm still
looking for the proper size).

# mt -f /dev/st0 mkpartition 1


Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Updating partition numbe=
r in status.
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Got tape pos. blk 0 part=
 0.
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Loading tape.
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Partition page length is=
 12 bytes.
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 0, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 1529 0
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 00 3c 03 09=
 00 05 f9 00 00
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: psd_cnt 2, max.parts 1, =
nbr_parts 0
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Formatting tape with two=
 partitions (FDP).
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Sent partition page leng=
th is 12 bytes. needs_format: 1
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 4,=
 psum 03, pofmetc 4, rec 03, units 00, sizes: 65535 0
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 9c 03 00=
 00 ff ff 00 00
Jan  6 16:38:42 taiko kernel: st 6:0:0:0: st0: Sending FORMAT MEDIUM
Jan  6 16:38:56 taiko kernel: st 6:0:0:0: st0: Rewinding tape.


# tapeinfo -f /dev/sg1
Product Type: Tape Drive
Vendor ID: 'HP      '
Product ID: 'Ultrium 5-SCSI  '
Revision: 'Z61U'
Attached Changer API: No
SerialNumber: 'HU1249TP88'
MinBlock: 1
MaxBlock: 16777215
SCSI ID: 0
SCSI LUN: 0
Ready: yes
BufferedMode: yes
Medium Type: Not Loaded
Density Code: 0x58
BlockSize: 0
DataCompEnabled: yes
DataCompCapable: yes
DataDeCompEnabled: yes
CompType: 0x1
DeCompType: 0x1
BOP: yes
Block Position: 0
Partition 0 Remaining Kbytes: 1459056
Partition 0 Size in Kbytes: 1459056
ActivePartition: 0
EarlyWarningSize: 0
NumPartitions: 1
MaxPartitions: 1
Partition0: 1453
Partition1: 38

# mt -f /dev/st0 setpartition 1

Jan  6 16:40:20 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:40:20 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:40:20 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:40:20 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:40:20 taiko kernel: st 6:0:0:0: st0: Setting block to 0 and p=
artition to 1.
Jan  6 16:40:20 taiko kernel: st 6:0:0:0: st0: Got tape pos. blk 0 part=
 0.
Jan  6 16:40:20 taiko kernel: st 6:0:0:0: st0: Visited block 0 for part=
ition 0 saved.
Jan  6 16:40:20 taiko kernel: st 6:0:0:0: st0: Trying to change partiti=
on from 0 to 1
Jan  6 16:40:25 taiko kernel: st 6:0:0:0: st0: Rewinding tape.

# mt -f /dev/st0 mkpartition 1453

Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Loading tape.
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Partition page length is=
 12 bytes.
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 1453 38
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 3c 03 09=
 00 05 ad 00 26
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: psd_cnt 2, max.parts 1, =
nbr_parts 1
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Formatting tape with two=
 partitions (1 =3D 1453 MB).
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Sent partition page leng=
th is 12 bytes. needs_format: 1
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 1,=
 psum 02, pofmetc 4, rec 03, units 00, sizes: 65535 1453
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 34 03 00=
 00 ff ff 05 ad
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Error: 8000002, cmd: 15 =
10 0 0 18 0
Jan  6 16:42:22 taiko kernel: st0: Sense Key : Illegal Request [current=
]=20
Jan  6 16:42:22 taiko kernel: st0: Add. Sense: Invalid field in paramet=
er list
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Partitioning of tape fai=
led.
Jan  6 16:42:22 taiko kernel: st 6:0:0:0: st0: Rewinding tape.

# mt -f /dev/st0 setpartition 0

Jan  6 16:42:36 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:42:36 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:42:36 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:42:36 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:42:36 taiko kernel: st 6:0:0:0: st0: Setting block to 0 and p=
artition to 0.
Jan  6 16:42:36 taiko kernel: st 6:0:0:0: st0: Got tape pos. blk 0 part=
 0.
Jan  6 16:42:36 taiko kernel: st 6:0:0:0: st0: Visited block 0 for part=
ition 1 saved.
Jan  6 16:42:36 taiko kernel: st 6:0:0:0: st0: Trying to change partiti=
on from 1 to 0
Jan  6 16:42:41 taiko kernel: st 6:0:0:0: st0: Rewinding tape.


# mt -f /dev/st0 mkpartition 1487872


Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Loading tape.
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Partition page length is=
 12 bytes.
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 1453 38
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 3c 03 09=
 00 05 ad 00 26
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: psd_cnt 2, max.parts 1, =
nbr_parts 1
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Formatting tape with two=
 partitions (1 =3D 1487000 MB).
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Sent partition page leng=
th is 12 bytes. needs_format: 1
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 65535 1487
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 3c 03 09=
 00 ff ff 05 cf
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Sending FORMAT MEDIUM
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Error: 8000002, cmd: 4 0=
 1 0 0 0
Jan  6 16:44:25 taiko kernel: st0: Sense Key : Illegal Request [current=
]=20
Jan  6 16:44:25 taiko kernel: st0: Add. Sense: Parameter value invalid
Jan  6 16:44:25 taiko kernel: st 6:0:0:0: st0: Rewinding tape.

# mt -f /dev/st0 mkpartition 77824


Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Loading tape.
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Partition page length is=
 12 bytes.
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 0, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 1529 0
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 00 3c 03 09=
 00 05 f9 00 00
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: psd_cnt 2, max.parts 1, =
nbr_parts 0
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Formatting tape with two=
 partitions (1 =3D 77000 MB).
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Sent partition page leng=
th is 12 bytes. needs_format: 1
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 65535 77
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 3c 03 09=
 00 ff ff 00 4d
Jan  6 16:48:35 taiko kernel: st 6:0:0:0: st0: Sending FORMAT MEDIUM
Jan  6 16:48:45 taiko kernel: st 6:0:0:0: st0: Rewinding tape.

# tapeinfo -f /dev/sg1
Product Type: Tape Drive
Vendor ID: 'HP      '
Product ID: 'Ultrium 5-SCSI  '
Revision: 'Z61U'
Attached Changer API: No
SerialNumber: 'HU1249TP88'
MinBlock: 1
MaxBlock: 16777215
SCSI ID: 0
SCSI LUN: 0
Ready: yes
BufferedMode: yes
Medium Type: Not Loaded
Density Code: 0x58
BlockSize: 0
DataCompEnabled: yes
DataCompCapable: yes
DataDeCompEnabled: yes
CompType: 0x1
DeCompType: 0x1
BOP: yes
Block Position: 0
Partition 0 Remaining Kbytes: 1459056
Partition 0 Size in Kbytes: 1459056
ActivePartition: 0
EarlyWarningSize: 0
NumPartitions: 1
MaxPartitions: 1
Partition0: 1376
Partition1: 114

# mt -f /dev/st0 mkpartition 228000


Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Loading tape.
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Partition page length is=
 12 bytes.
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 1376 114
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 3c 03 09=
 00 05 60 00 72
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: psd_cnt 2, max.parts 1, =
nbr_parts 1
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Formatting tape with two=
 partitions (1 =3D 228000 MB).
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Sent partition page leng=
th is 12 bytes. needs_format: 1
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 65535 228
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 3c 03 09=
 00 ff ff 00 e4
Jan  6 16:50:26 taiko kernel: st 6:0:0:0: st0: Sending FORMAT MEDIUM
Jan  6 16:50:37 taiko kernel: st 6:0:0:0: st0: Rewinding tape.

# tapeinfo -f /dev/sg1
Product Type: Tape Drive
Vendor ID: 'HP      '
Product ID: 'Ultrium 5-SCSI  '
Revision: 'Z61U'
Attached Changer API: No
SerialNumber: 'HU1249TP88'
MinBlock: 1
MaxBlock: 16777215
SCSI ID: 0
SCSI LUN: 0
Ready: yes
BufferedMode: yes
Medium Type: Not Loaded
Density Code: 0x58
BlockSize: 0
DataCompEnabled: yes
DataCompCapable: yes
DataDeCompEnabled: yes
CompType: 0x1
DeCompType: 0x1
BOP: yes
Block Position: 0
Partition 0 Remaining Kbytes: 1459056
Partition 0 Size in Kbytes: 1459056
ActivePartition: 0
EarlyWarningSize: 0
NumPartitions: 1
MaxPartitions: 1
Partition0: 1223
Partition1: 267

# mt -f /dev/st0 mkpartition 1400000

Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Loading tape.
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Block limits 1 - 1677721=
5 bytes.
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Mode sense. Length 11, m=
edium 0, WBS 10, BLL 8
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Density 58, tape length:=
 0, drv buffer: 1
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Block size: 0, buffer si=
ze: 4096 (1 blocks).
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Partition page length is=
 12 bytes.
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 1223 267
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 3c 03 09=
 00 04 c7 01 0b
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: psd_cnt 2, max.parts 1, =
nbr_parts 1
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Formatting tape with two=
 partitions (1 =3D 1400000 MB).
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Sent partition page leng=
th is 12 bytes. needs_format: 1
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: PP: max 1, add 1, xdp 1,=
 psum 03, pofmetc 4, rec 03, units 09, sizes: 65535 1400
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: MP: 11 0a 01 01 3c 03 09=
 00 ff ff 05 78
Jan  6 16:52:16 taiko kernel: st 6:0:0:0: st0: Sending FORMAT MEDIUM
Jan  6 16:52:25 taiko kernel: st 6:0:0:0: st0: Rewinding tape.

# tapeinfo -f /dev/sg1
Product Type: Tape Drive
Vendor ID: 'HP      '
Product ID: 'Ultrium 5-SCSI  '
Revision: 'Z61U'
Attached Changer API: No
SerialNumber: 'HU1249TP88'
MinBlock: 1
MaxBlock: 16777215
SCSI ID: 0
SCSI LUN: 0
Ready: yes
BufferedMode: yes
Medium Type: Not Loaded
Density Code: 0x58
BlockSize: 0
DataCompEnabled: yes
DataCompCapable: yes
DataDeCompEnabled: yes
CompType: 0x1
DeCompType: 0x1
BOP: yes
Block Position: 0
Partition 0 Remaining Kbytes: 1459056
Partition 0 Size in Kbytes: 1459056
ActivePartition: 0
EarlyWarningSize: 0
NumPartitions: 1
MaxPartitions: 1
Partition0: 38
Partition1: 1453


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
