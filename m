From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Mon, 27 Oct 2008 00:09:14 -0400
Message-ID: <49053EEA.2030601@interlog.com>
References: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp> <0F5B06BAB751E047AB5C87D1F77A77884C01B0C584@GVW0547EXC.americas.hpqcorp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46890 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYJ0EJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 00:09:30 -0400
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77884C01B0C584@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Lawler, Tom" <Tom.Lawler@hp.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Jens.Axboe@oracle.com" <Jens.Axboe@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bruce Allen <ballen@gravity.phys.uwm.edu>

Miller, Mike (OS Dev) wrote:
> Tomo wrote:
> 
>> My scsi driver is still in an early stage (I tried to keep
>> the changes minimum). I can detect logical units, mount a
>> file system, do lots of I/Os, however, there are lots of
>> TODOs in the management features.
>>
>> If I can get an ACK from HP about the long-term migration of
>> cciss to SCSI, I'm happy to keep working on the SCSI cciss
>> driver and maintain it until HP takes over the driver.
> 
> Just a brief update. HP has developed a scsi version of cciss. It was originally done for another environment but we have decided to use it as the base for Linux. It was authored by Tom Lawler of HP. We are currently in the process of getting the Open Source Review Board approval to release the code to the community.
> 
> It's unclear right now as to who will be the maintainer.
> 
> -- mikem
> 
>>
>> The patch is available at:
>>
>> http://www.kernel.org/pub/linux/kernel/people/tomo/ciss/0001-a
>> dd-HP-Compaq-Smart-Array-5xxx-controller-SCSI-dri.patch
>>
>> clover:/home/fujita# insmod ciss.ko
>> clover:/home/fujita# lsscsi
>> (snip)
>> [1:0:0:0]    disk    HP       LOGICAL VOLUME   1.66  /dev/sde
>> [1:0:0:1]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdf
>> [1:0:0:2]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdg
>> [1:0:0:3]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdh
>>
>> Yeah, it just works as SCSI disk, the dmesg says:
>>
>> sd 1:0:0:0: [sde] Attached SCSI disk
>> sd 1:0:0:1: [sdf] 143305920 512-byte hardware sectors (73373
>> MB) sd 1:0:0:1: [sdf] Write Protect is off sd 1:0:0:1: [sdf]
>> Mode Sense: 5b 00 00 08 sd 1:0:0:1: [sdf] Write cache:
>> disabled, read cache: enabled, doesn't support DPO or FUA
>>
>> I needed a different name and just stole 'ciss' from *BSD.
>> But any names (like hpciss) works for me.

My interest in SAS/SATA RAID controllers (e.g. cciss and megaraid)
is to get to the physical drives and let smartmontools query
them. The first difficulty is addressing physical drives within
the logical drive presented to the OS. Then there are SATA drives:
I have yet to see a SAT implementation good enough to fetch
useful SMART data using "pure" SCSI commands; that leaves the
SAT ATA PASS-THROUGH commands.

Testing I did today on a HP E200 controller with version 1.80
firmware and the cciss driver in lk 2.6.27 showed this command
failed (as it has in the past):
     smartctl -a -d cciss,0 /dev/cciss/c0d0
when c0d0 was a SATA disk.

Yes, I know the documentation says it won't work and I've been told
not to hold my breadth.
So if a true SCSI cciss driver might appear, could SAT with
ATA pass-through support be added to the wish list?


BTW We now have the equivalent working on megaraid controllers.
Whether to let "SCSI" commands through that alter the state
of a SATA disk is an interesting dilemma for the driver.
WRITEs are obviously a no-no but the current megaraid/smartctl
code ignored my attempts to do a self-test.

Doug Gilbert

