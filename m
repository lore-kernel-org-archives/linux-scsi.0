From: Audio Haven <audiohaven@gmail.com>
Subject: Re: mvsas mvs_abort_task() disk hosed
Date: Mon, 8 Feb 2010 11:17:16 +0100
Message-ID: <333bc7e11002080217s74c69505p7bd47dcc5fb72265@mail.gmail.com>
References: <333bc7e11002050346l51900c77h58640e4d31df08e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:45609 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0BHKRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2010 05:17:18 -0500
Received: by bwz23 with SMTP id 23so947151bwz.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Feb 2010 02:17:16 -0800 (PST)
In-Reply-To: <333bc7e11002050346l51900c77h58640e4d31df08e4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

It seems some of the WD green disks have a really high Load_Cycle_Count=
:

        Model Number:       WDC WD15EADS-00P8B0
        Serial Number:      WD-WCAVU0220972
        Firmware Revision:  01.00A01
193 Load_Cycle_Count        0x0032   167   167   000    Old_age
Always -       99576

They park their heads after only 8 secs, which was also reported here:
http://kerneltrap.org/mailarchive/linux-kernel/2008/4/10/1396844

When software raid is doing a recovery and the XFS fs on top of the
raid6 is populated with big HDTV files, the Load_Cycle_Count seems to
go up. It appears the drive parks the heads quicker than the interval
before a flush.

Version 00P8B0 of the drive also seems to be blacklisted at synology:
http://forum.synology.com/enu/viewtopic.php?f=3D124&t=3D9412

WD15EADS-00P8B0 1.5TB -- NOT SUGGESTED

Three of my drives are WD15EADS-00S2B0 and do not seem affected.

I'm currently testing with
hdparm -S 252 /dev/sdx

on all of my WD drives it seems to solve my problems for the moment
(but longer stress testing should take place to be 100% sure).

Is it normal behavior that the Marvell driver will timeout after a
high Load_Cycle_Count increment ? Or is the disk going nuts by
continously doing a load cycle ?


On Fri, Feb 5, 2010 at 12:46 PM, Audio Haven <audiohaven@gmail.com> wro=
te:
> I have 8 1.5T WD Green drives in a software raid6. While the initial
> sync of the raid6 works well using the mvsas driver (when using the
> patches from Andy Yan, without it always crashed during the initial
> sync), I'm getting lots of mvs_abort_task errors when using filling u=
p
> a 9T xfs filesystem on top of the raid device /dev/md2 with large HDT=
V
> data.
>
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea77380
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724618 slot_idx=3Dx4
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea77700
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724670 slot_idx=3Dx5
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea77c40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937246c8 slot_idx=3Dx6
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea778c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724720 slot_idx=3Dx7
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800853e78c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724988 slot_idx=3Dxe
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800853e78c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800853e7a80
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800853e7000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800853e7380
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937245c0 slot_idx=3Dx3
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea77700
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724930 slot_idx=3Dxd
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800853e7540
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724a90 slot_idx=3Dx1=
1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007303b000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724ae8 slot_idx=3Dx1=
2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007303b380
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007303b000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007303b540
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff880025182000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937245c0 slot_idx=3Dx3
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff880025182380
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800251828c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937245c0 slot_idx=3Dx3
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff880025182700
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724670 slot_idx=3Dx5
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800251821c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937246c8 slot_idx=3Dx6
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800251821c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800251828c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff880025182700
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800251828c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800251828c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800251828c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff880025182380
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff880025182000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61de00
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724a90 slot_idx=3Dx1=
1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007303b000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724ae8 slot_idx=3Dx1=
2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007303bc40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724d50 slot_idx=3Dx1=
9
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5a80
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724618 slot_idx=3Dx4
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5c40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724880 slot_idx=3Dxb
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5a80
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5c40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5540
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937245c0 slot_idx=3Dx3
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c51c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea771c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea77000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea77380
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea77a80
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937246c8 slot_idx=3Dx6
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937247d0 slot_idx=3Dx9
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5540
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724778 slot_idx=3Dx8
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5700
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c58c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724618 slot_idx=3Dx4
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5c40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724670 slot_idx=3Dx5
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5e00
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937246c8 slot_idx=3Dx6
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5e00
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c58c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937245c0 slot_idx=3Dx3
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5e00
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5380
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724720 slot_idx=3Dx7
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c51c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724778 slot_idx=3Dx8
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61de00
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61d700
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937245c0 slot_idx=3Dx3
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61d8c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724618 slot_idx=3Dx4
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61dc40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724670 slot_idx=3Dx5
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61dc40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61d700
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61d8c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61d1c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937246c8 slot_idx=3Dx6
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5700
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c58c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c51c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937245c0 slot_idx=3Dx3
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5540
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724568 slot_idx=3Dx2
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61d000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61d540
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61d1c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937245c0 slot_idx=3Dx3
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88004b61dc40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724720 slot_idx=3Dx7
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c51c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724670 slot_idx=3Dx5
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937246c8 slot_idx=3Dx6
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5c40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937244b8 slot_idx=3Dx0
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff8800400c5380
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724618 slot_idx=3Dx4
> sd 13:0:6:0: [sdj] Unhandled error code
> sd 13:0:6:0: [sdj] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_TIME=
OUT
> sd 13:0:6:0: [sdj] CDB: Read(10): 28 00 4f 14 f4 1f 00 00 08 00
> end_request: I/O error, dev sdj, sector 1326773279
> raid5:md2: read error not correctable (sector 1326773216 on sdj1).
> raid5: Disk failure on sdj1, disabling device.
> raid5: Operation continuing on 6 devices.
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea771c0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724510 slot_idx=3Dx1
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88007ea77e00
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff880093724778 slot_idx=3Dx8
> mvs_abort_task() mvi=3Dffff880093700000 task=3Dffff88001b008000
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 slot=3Dffff8800937247d0 slot_idx=3Dx9
> sd 13:0:6:0: [sdj] Unhandled error code
> sd 13:0:6:0: [sdj] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_TIME=
OUT
> sd 13:0:6:0: [sdj] CDB: Read(10): 28 00 4f 14 f4 37 00 00 70 00
> end_request: I/O error, dev sdj, sector 1326773303
> raid5:md2: read error not correctable (sector 1326773240 on sdj1).
> raid5:md2: read error not correctable (sector 1326773248 on sdj1).
> raid5:md2: read error not correctable (sector 1326773256 on sdj1).
>
> My system is Fedora 12 =A0x86_64 using a 2.6.32.3 kernel with the
> following patches from Andy Yan:
>
> [PATCH 6/7]MVSAS: Enhanced hot plug handling
> [PATCH 5/7]MVSAS:Optimization for DMA buffer
> [PATCH 4/7]MVSAS:Make code more flexibe for different chip model.
> [PATCH 3/7]MVSAS: bug fix with big endian
> [PATCH 2/7]MVSAS:add supporting MSI feature
> [PATCH 1/7]MVSAS: Update chip initialization
>
> I did not use [PATCH 7/7]
>
> The only solution is to reboot the system as /dev/sdj is completely
> hosed. All IO to this disk is stalled. The issue also happened on
> /dev/sdi. Then I just rebooted and readded /dev/sdi1 to the raid set
> and it rebuild correctly. None of these disks report any smart errors
> (they all report healthy) and no sector remapping occurs as the raw
> value of Reallocated_Sector_Ct is zero for all of these disks.
>
> I had a faulty 1.5 T WD green drive before which was swapped under
> warranty with a high raw Reallocated_Sector_Ct count (so I know what
> to expect from smartctl).
>
> I'm not an expert but thinking in the following direction: timeouts:
>
> Maybe the timeouts are too low in the driver ? These drives don't
> feature TLER (time limited error recovery) which means IO could be
> stalled for 2 minutes while the disk is doing background stuff, but
> this is no reason for marking the disk dead on consumer disks. Is it
> correct that the mvsas only allows 20 seconds for a task to complete =
?
> Shouldn't this be higher ? However I'm not seeing this background
> process being triggered using smartctl.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
