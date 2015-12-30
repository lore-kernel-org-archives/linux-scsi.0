From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Wed, 30 Dec 2015 22:24:18 +0100
Message-ID: <20151230222418.03e40cf7@harpe.intellique.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:34336 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbbL3VYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2015 16:24:13 -0500
In-Reply-To: <D1FDE9A6-D190-4ABC-B935-56A65200956A@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kai =?UTF-8?B?TcOka2lzYXJh?= (Kolumbus)" <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Le Wed, 30 Dec 2015 21:21:47 +0200
"Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi> =C3=A9crivait=
:

> This happens if the position is not at the beginning of partition 0.
> Could you try to switch to partition 0:
> mt -f /dev/nst0 setpartition 0
> mt -f /dev/nst0 status
>=20
> and the retry partitioning.

Alas, no dice:

# mt -f /dev/nst0 setpartition 0


Dec 30 22:19:33 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 30 22:19:33 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 30 22:19:33 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape le=
ngth: 0, drv buffer: 1
Dec 30 22:19:33 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).

# mt -f /dev/nst0 status
SCSI 2 tape drive:
=46ile number=3D0, block number=3D0, partition=3D0.
Tape block size 0 bytes. Density code 0x5a (no translation).
Soft error count since last status=3D0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN

Dec 30 22:19:49 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 30 22:19:49 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 30 22:19:49 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape le=
ngth: 0, drv buffer: 1
Dec 30 22:19:49 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).

# mt -f /dev/nst0 mkpartition 0

Dec 30 22:22:21 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 30 22:22:21 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 30 22:22:21 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape le=
ngth: 0, drv buffer: 1
Dec 30 22:22:21 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).
Dec 30 22:22:21 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.
Dec 30 22:22:21 shakuhachi kernel: st 7:0:0:0: st0: Partition page leng=
th is 16 bytes.
Dec 30 22:22:21 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1, x=
dp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2543 38
Dec 30 22:22:21 shakuhachi kernel: st 7:0:0:0: st0: Sending FORMAT MEDI=
UM
Dec 30 22:22:21 shakuhachi kernel: st 7:0:0:0: st0: Error: 8000002, cmd=
: 4 0 0 0 0 0
Dec 30 22:22:21 shakuhachi kernel: st0: Sense Key : Illegal Request [cu=
rrent]=20
Dec 30 22:22:21 shakuhachi kernel: st0: Add. Sense: Position past begin=
ning of medium



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
