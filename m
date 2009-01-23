From: Daniel Persson <dpersson@gmail.com>
Subject: Fusion - LSISAS1068 - disk disappears
Date: Fri, 23 Jan 2009 11:15:05 +0100
Message-ID: <ba8efde90901230215u6b2c538crf47a88bd88dc505e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:21578 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbZAWKPG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2009 05:15:06 -0500
Received: by yw-out-2324.google.com with SMTP id 9so2121768ywe.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 02:15:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi
I'm using linux-2.6.26.1 and the mptsas driver included in the
mainline tree. I have two LSISAS1068 with 14 disks on them totally.
Using 10 of those disks I am trying to build a raid 5 array on. But
everytime the reshaping of the raid array has been going on for some
time devices start to fail. Its not always the same device(its
random?) and the device always reappear at a later time. I thought
there was some problem with the disks so I decided to try one of the
disks seperately with no raid and just a plain xfs filesystem. And
then the disk seem fine. No error.

When it fails with the raid array I get this in my dmesg:

[68145.893997] sd 1:0:1:0: [sdi] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[68145.893997] sd 1:0:1:0: [sdi] Sense Key : Medium Error [current]
[68145.893997] Info fld=0xe0f3b05
[68145.893997] sd 1:0:1:0: [sdi] Add. Sense: Unrecovered read error
[68145.893997] end_request: I/O error, dev sdi, sector 235879173
[68145.893997] __ratelimit: 19 messages suppressed
[68145.893997] raid5:md4: read error not correctable (sector 235879104 on sdi1).
[68145.893997] raid5: Disk failure on sdi1, disabling device.
[68145.893997] raid5: Operation continuing on 8 devices.
[68145.893997] raid5:md4: read error not correctable (sector 235879112 on sdi1).
[68145.893997] raid5:md4: read error not correctable (sector 235879120 on sdi1).
[68145.893997] raid5:md4: read error not correctable (sector 235879128 on sdi1).
[68145.893998] raid5:md4: read error not correctable (sector 235879136 on sdi1).
[68145.893998] raid5:md4: read error not correctable (sector 235879144 on sdi1).
[68145.893998] raid5:md4: read error not correctable (sector 235879152 on sdi1).
[68145.893998] raid5:md4: read error not correctable (sector 235879160 on sdi1).
[68146.384001] md: md4: recovery done.

cat /proc/scsi/mptsas/0
ioc0: LSISAS1068 B0, FwRev=011a0000h, Ports=1, MaxQ=266

cat /proc/scsi/mptsas/1
ioc1: LSISAS1068 B0, FwRev=011a0000h, Ports=1, MaxQ=266

It only seems to fail when its under heavy I/O load.

Do you have any idea on what the problem could be?

/Best regards Daniel
