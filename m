From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Fusion - LSISAS1068 - disk disappears
Date: Fri, 23 Jan 2009 09:00:29 -0600
Message-ID: <1232722829.3250.17.camel@localhost.localdomain>
References: <ba8efde90901230215u6b2c538crf47a88bd88dc505e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56976 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbZAWPA2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 10:00:28 -0500
In-Reply-To: <ba8efde90901230215u6b2c538crf47a88bd88dc505e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Persson <dpersson@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2009-01-23 at 11:15 +0100, Daniel Persson wrote:
> Hi
> I'm using linux-2.6.26.1 and the mptsas driver included in the
> mainline tree. I have two LSISAS1068 with 14 disks on them totally.
> Using 10 of those disks I am trying to build a raid 5 array on. But
> everytime the reshaping of the raid array has been going on for some
> time devices start to fail. Its not always the same device(its
> random?) and the device always reappear at a later time. I thought
> there was some problem with the disks so I decided to try one of the
> disks seperately with no raid and just a plain xfs filesystem. And
> then the disk seem fine. No error.
> 
> When it fails with the raid array I get this in my dmesg:
> 
> [68145.893997] sd 1:0:1:0: [sdi] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE,SUGGEST_OK
> [68145.893997] sd 1:0:1:0: [sdi] Sense Key : Medium Error [current]

This comes from the device and it's reporting that it has a bad block.
a RAIDx system has no way to do bad block exclusion.  I could see an LVM
remapping working underneath, but it really wouldn't be advisable.  Once
bad block show up on modern media they only multiply.

> [68145.893997] Info fld=0xe0f3b05
> [68145.893997] sd 1:0:1:0: [sdi] Add. Sense: Unrecovered read error
> [68145.893997] end_request: I/O error, dev sdi, sector 235879173
> [68145.893997] __ratelimit: 19 messages suppressed
> [68145.893997] raid5:md4: read error not correctable (sector 235879104 on sdi1).

Since this is a read error, you can try force writing the sector:
sometimes that will correct the problem, but, as I said, it's a bad idea
because the disk is now suspect and not suitable for the storage of
valuable data.

> [68145.893997] raid5: Disk failure on sdi1, disabling device.
> [68145.893997] raid5: Operation continuing on 8 devices.
> [68145.893997] raid5:md4: read error not correctable (sector 235879112 on sdi1).
> [68145.893997] raid5:md4: read error not correctable (sector 235879120 on sdi1).
> [68145.893997] raid5:md4: read error not correctable (sector 235879128 on sdi1).
> [68145.893998] raid5:md4: read error not correctable (sector 235879136 on sdi1).
> [68145.893998] raid5:md4: read error not correctable (sector 235879144 on sdi1).
> [68145.893998] raid5:md4: read error not correctable (sector 235879152 on sdi1).
> [68145.893998] raid5:md4: read error not correctable (sector 235879160 on sdi1).
> [68146.384001] md: md4: recovery done.
> 
> cat /proc/scsi/mptsas/0
> ioc0: LSISAS1068 B0, FwRev=011a0000h, Ports=1, MaxQ=266
> 
> cat /proc/scsi/mptsas/1
> ioc1: LSISAS1068 B0, FwRev=011a0000h, Ports=1, MaxQ=266
> 
> It only seems to fail when its under heavy I/O load.
> 
> Do you have any idea on what the problem could be?

James


