From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Wed, 30 Dec 2015 19:33:09 +0100
Message-ID: <20151230193309.0df94c88@harpe.intellique.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:46894 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbbL3SdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2015 13:33:07 -0500
In-Reply-To: <alpine.LSU.2.11.1512301947150.1713@xnv.znxvfnen.cevingr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Le Wed, 30 Dec 2015 19:54:01 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> =C3=A9crivait:

> I think I found out why it did not work with the default format. At
> the end of this message you find a new patch that should correct
> that. There are also other changes:
> - some changes when specifying the size in the mode page; needed for
> the IBM 3592 drives but should not change results with LTO
> - formatting with one partition is done directly with FORMAT MEDIUM i=
f
>   the drive requires that command
> - some other bugs fixed

Hum, I can't seem to be able to go back to 1 partition, or to reformat
the tape (didn't change it since yesterday), am I missing something?

Dec 30 19:21:29 shakuhachi kernel: st: Version 20151230, fixed bufsize =
32768, s/g segs 256
Dec 30 19:21:29 shakuhachi kernel: st 7:0:0:0: Attached scsi tape st0
Dec 30 19:21:29 shakuhachi kernel: st 7:0:0:0: st0: try direct i/o: yes=
 (alignment 512 B)

~# mt -f /dev/nst0  mkpartition 0

Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape le=
ngth: 0, drv buffer: 1
Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).
Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.
Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Partition page leng=
th is 16 bytes.
Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1, x=
dp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2543 38
Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Sending FORMAT MEDI=
UM
Dec 30 19:24:41 shakuhachi kernel: st 7:0:0:0: st0: Error: 8000002, cmd=
: 4 0 0 0 0 0
Dec 30 19:24:41 shakuhachi kernel: st0: Sense Key : Illegal Request [cu=
rrent]=20
Dec 30 19:24:41 shakuhachi kernel: st0: Add. Sense: Position past begin=
ning of medium

~# mt -f /dev/nst0  mkpartition 1

Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Density 5a, tape le=
ngth: 0, drv buffer: 1
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Rewinding tape.
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Partition page leng=
th is 16 bytes.
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1, x=
dp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2543 38
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: psd_cnt 2, max.part=
s 3, nbr_parts 1
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Formatting tape wit=
h two partitions (FDP).
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Sent partition page=
 length is 12 bytes. needs_format: 1
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: PP: max 3, add 1, x=
dp 4, psum 00, pofmetc 4, rec 03, units 00, sizes: 65535 0
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Error: 8000002, cmd=
: 15 10 0 0 18 0
Dec 30 19:26:12 shakuhachi kernel: st0: Sense Key : Illegal Request [cu=
rrent]=20
Dec 30 19:26:12 shakuhachi kernel: st0: Add. Sense: Invalid field in pa=
rameter list
Dec 30 19:26:12 shakuhachi kernel: st 7:0:0:0: st0: Partitioning of tap=
e failed.







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
