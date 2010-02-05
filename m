From: Audio Haven <audiohaven@gmail.com>
Subject: mvsas mvs_abort_task() disk hosed
Date: Fri, 5 Feb 2010 12:46:54 +0100
Message-ID: <333bc7e11002050346l51900c77h58640e4d31df08e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59779 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab0BELq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2010 06:46:56 -0500
Received: by bwz19 with SMTP id 19so1332225bwz.28
        for <linux-scsi@vger.kernel.org>; Fri, 05 Feb 2010 03:46:54 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I have 8 1.5T WD Green drives in a software raid6. While the initial
sync of the raid6 works well using the mvsas driver (when using the
patches from Andy Yan, without it always crashed during the initial
sync), I'm getting lots of mvs_abort_task errors when using filling up
a 9T xfs filesystem on top of the raid device /dev/md2 with large HDTV
data.

mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea77380
                 slot=ffff880093724618 slot_idx=x4
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea77700
                 slot=ffff880093724670 slot_idx=x5
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea77c40
                 slot=ffff8800937246c8 slot_idx=x6
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea778c0
                 slot=ffff880093724720 slot_idx=x7
mvs_abort_task() mvi=ffff880093700000 task=ffff8800853e78c0
                 slot=ffff880093724988 slot_idx=xe
mvs_abort_task() mvi=ffff880093700000 task=ffff8800853e78c0
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800853e7a80
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff8800853e7000
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff8800853e7380
                 slot=ffff8800937245c0 slot_idx=x3
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea77700
                 slot=ffff880093724930 slot_idx=xd
mvs_abort_task() mvi=ffff880093700000 task=ffff8800853e7540
                 slot=ffff880093724a90 slot_idx=x11
mvs_abort_task() mvi=ffff880093700000 task=ffff88007303b000
                 slot=ffff880093724ae8 slot_idx=x12
mvs_abort_task() mvi=ffff880093700000 task=ffff88007303b380
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff88007303b000
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff88007303b540
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff880025182000
                 slot=ffff8800937245c0 slot_idx=x3
mvs_abort_task() mvi=ffff880093700000 task=ffff880025182380
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff8800251828c0
                 slot=ffff8800937245c0 slot_idx=x3
mvs_abort_task() mvi=ffff880093700000 task=ffff880025182700
                 slot=ffff880093724670 slot_idx=x5
mvs_abort_task() mvi=ffff880093700000 task=ffff8800251821c0
                 slot=ffff8800937246c8 slot_idx=x6
mvs_abort_task() mvi=ffff880093700000 task=ffff8800251821c0
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800251828c0
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff880025182700
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff8800251828c0
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800251828c0
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800251828c0
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff880025182380
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff880025182000
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61de00
                 slot=ffff880093724a90 slot_idx=x11
mvs_abort_task() mvi=ffff880093700000 task=ffff88007303b000
                 slot=ffff880093724ae8 slot_idx=x12
mvs_abort_task() mvi=ffff880093700000 task=ffff88007303bc40
                 slot=ffff880093724d50 slot_idx=x19
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5a80
                 slot=ffff880093724618 slot_idx=x4
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5c40
                 slot=ffff880093724880 slot_idx=xb
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5a80
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5c40
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5540
                 slot=ffff8800937245c0 slot_idx=x3
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c51c0
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea771c0
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea77000
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea77380
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea77a80
                 slot=ffff8800937246c8 slot_idx=x6
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5000
                 slot=ffff8800937247d0 slot_idx=x9
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5540
                 slot=ffff880093724778 slot_idx=x8
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5700
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c58c0
                 slot=ffff880093724618 slot_idx=x4
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5c40
                 slot=ffff880093724670 slot_idx=x5
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5e00
                 slot=ffff8800937246c8 slot_idx=x6
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5000
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5e00
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5000
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c58c0
                 slot=ffff8800937245c0 slot_idx=x3
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5000
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5e00
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5380
                 slot=ffff880093724720 slot_idx=x7
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c51c0
                 slot=ffff880093724778 slot_idx=x8
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61de00
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61d700
                 slot=ffff8800937245c0 slot_idx=x3
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61d8c0
                 slot=ffff880093724618 slot_idx=x4
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61dc40
                 slot=ffff880093724670 slot_idx=x5
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61dc40
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61d700
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61d8c0
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61d1c0
                 slot=ffff8800937246c8 slot_idx=x6
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5700
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c58c0
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c51c0
                 slot=ffff8800937245c0 slot_idx=x3
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5540
                 slot=ffff880093724568 slot_idx=x2
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61d000
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61d540
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61d1c0
                 slot=ffff8800937245c0 slot_idx=x3
mvs_abort_task() mvi=ffff880093700000 task=ffff88004b61dc40
                 slot=ffff880093724720 slot_idx=x7
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c51c0
                 slot=ffff880093724670 slot_idx=x5
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5000
                 slot=ffff8800937246c8 slot_idx=x6
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5c40
                 slot=ffff8800937244b8 slot_idx=x0
mvs_abort_task() mvi=ffff880093700000 task=ffff8800400c5380
                 slot=ffff880093724618 slot_idx=x4
sd 13:0:6:0: [sdj] Unhandled error code
sd 13:0:6:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
sd 13:0:6:0: [sdj] CDB: Read(10): 28 00 4f 14 f4 1f 00 00 08 00
end_request: I/O error, dev sdj, sector 1326773279
raid5:md2: read error not correctable (sector 1326773216 on sdj1).
raid5: Disk failure on sdj1, disabling device.
raid5: Operation continuing on 6 devices.
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea771c0
                 slot=ffff880093724510 slot_idx=x1
mvs_abort_task() mvi=ffff880093700000 task=ffff88007ea77e00
                 slot=ffff880093724778 slot_idx=x8
mvs_abort_task() mvi=ffff880093700000 task=ffff88001b008000
                 slot=ffff8800937247d0 slot_idx=x9
sd 13:0:6:0: [sdj] Unhandled error code
sd 13:0:6:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
sd 13:0:6:0: [sdj] CDB: Read(10): 28 00 4f 14 f4 37 00 00 70 00
end_request: I/O error, dev sdj, sector 1326773303
raid5:md2: read error not correctable (sector 1326773240 on sdj1).
raid5:md2: read error not correctable (sector 1326773248 on sdj1).
raid5:md2: read error not correctable (sector 1326773256 on sdj1).

My system is Fedora 12  x86_64 using a 2.6.32.3 kernel with the
following patches from Andy Yan:

[PATCH 6/7]MVSAS: Enhanced hot plug handling
[PATCH 5/7]MVSAS:Optimization for DMA buffer
[PATCH 4/7]MVSAS:Make code more flexibe for different chip model.
[PATCH 3/7]MVSAS: bug fix with big endian
[PATCH 2/7]MVSAS:add supporting MSI feature
[PATCH 1/7]MVSAS: Update chip initialization

I did not use [PATCH 7/7]

The only solution is to reboot the system as /dev/sdj is completely
hosed. All IO to this disk is stalled. The issue also happened on
/dev/sdi. Then I just rebooted and readded /dev/sdi1 to the raid set
and it rebuild correctly. None of these disks report any smart errors
(they all report healthy) and no sector remapping occurs as the raw
value of Reallocated_Sector_Ct is zero for all of these disks.

I had a faulty 1.5 T WD green drive before which was swapped under
warranty with a high raw Reallocated_Sector_Ct count (so I know what
to expect from smartctl).

I'm not an expert but thinking in the following direction: timeouts:

Maybe the timeouts are too low in the driver ? These drives don't
feature TLER (time limited error recovery) which means IO could be
stalled for 2 minutes while the disk is doing background stuff, but
this is no reason for marking the disk dead on consumer disks. Is it
correct that the mvsas only allows 20 seconds for a task to complete ?
Shouldn't this be higher ? However I'm not seeing this background
process being triggered using smartctl.
