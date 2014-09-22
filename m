From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: lk 3.17-rc4 blk_mq large write problems
Date: Mon, 22 Sep 2014 19:14:41 -0400
Message-ID: <5420AD61.4030600@interlog.com>
References: <540FCB96.8000606@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57358 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbaIVXO6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2014 19:14:58 -0400
In-Reply-To: <540FCB96.8000606@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Elliott, Robert (Server Storage)" <elliott@hp.com>

On 14-09-09 11:55 PM, Douglas Gilbert wrote:
> A few days ago I was trying to create a large file
> (say 16 GB) of zeros on an ext4 file system:
>     dd if=/dev/zero bs=64k count=256k of=zero_16g.bin
>
> After about 5 seconds there was a NULL de-reference that
> crashed the machine (shown below). This was with a clean
> version of lk 3.17-rc4 (from kernel.org) where the target
> was a SATA SSD directly connected to a LSI 9300-4i SAS-3
> HBA (mpt3sas). Significantly (IMO) the kernel boot line
> contained:
>     scsi_mod.use_blk_mq=Y
>
> In all cases changing that to "N" fixed the problem. I tried
> many things, including a SAS SSD but the problem persisted when
> use_blk_mq=Y. It doesn't always oops as shown in the first
> case below. There were also:
>    - immediate reboots
>    - lock-ups without any oops on the console
>    - different oopses of a somewhat stranger nature
>      (hard to catch as logging everything on a real
>       serial port is fiddly) like double bus errors
>
> Rob Elliott has been unable to replicate this problem.
>
> Today I switched to another machine running Debian 7 (the
> first machine was Ubuntu 14.04 based); both x86_64.
> Built the same kernel on the second machine, this time
> with a LSI 9212-4i4e SAS-2 HBA (mpt2sas) and a SAS SSD
> directly connected. Roughly speaking it was the same
> test case:
>    # <create 1 partition on say /dev/sdb>
>    # mkfs.ext4 /dev/sdb1
>    # mount /dev/sdb1 /mnt/spare
>    # cd /mnt/spare
>    # dd if=/dev/zero bs=64k count=256k of=zero_16g.bin
>    # cd
>    # umount /mnt/spare
>
> Usually the dd or the umount would crash. Then after a
> crash, following a power cycle, the mount would crash.
> Changing to scsi_mod.use_blk_mq=N restored sanity.
>
> Tried some other SAS controllers: couldn't get a MR-9240-4i
> (MegaRaid) to work at all on my newer box (doesn't like
> PCIe 3 ?). Got a ARC-1882I working and it did not have
> problems with the big dd (perhaps the arcmsr driver still
> uses the host_lock to serialize commands).
>
> So it could be common, bad code in the mpt2sas and mpt3sas
> drivers. Or it could be somewhere else. Perhaps there is
> more than one problem.
>
> Testers out there are encouraged to run the above test case.
> The SATA and SAS SSDs that I used can consume writes in the
> 300 to 600 MB/sec range.
>
> Part of the strangeness of this first attached oops is that
> blk_mq_timeout_check() appears twice. The second one (typically
> from the umount) is a blown stack.

Using the block/for-linus tree that I built today,
the freeze-during-boot-up problem has gone away as
reported earlier.

That allows me to retest the problem reported in this
thread with the same disk (INTEL SSDSA2M080) and the
same configuration. Just did four cycles of the test
sequence shown above plus a shutdown. No problems seen.

Doug Gilbert

