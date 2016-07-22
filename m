From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: HDD Unrecovered readerror issue
Date: Fri, 22 Jul 2016 09:51:33 -0400
Message-ID: <x494m7hhjbu.fsf@segfault.boston.devel.redhat.com>
References: <87twfkn0mz.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbcGVNve (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2016 09:51:34 -0400
In-Reply-To: <87twfkn0mz.fsf@openvz.org> (Dmitry Monakhov's message of "Wed,
	20 Jul 2016 12:01:56 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-scsi@vger.kernel.org

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> But once I rewrite this block, problem goes away.
> #xfs_io -c "pwrite -S 0x0 $((80069000/2))k 4k" -d  /dev/sda
>
> Now I can read it w/o any errors and smartctl is happy
> #smartctl -t short /dev/sda
> #smartctl -l selftest /dev/sda
> Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> # 1  Short offline       Completed without error       00%      4683 -
>
> So my disk is not dead right?

Correct.

> Why the hell HDD fail read from very beginning
> Is this because HDD firmware detect internal crcXX sum corruption?

Yes.

> How this can happen? Is this because of power failure?

Could be.  If power was cut in the middle of a write, this can happen.
There are other causes, though (bit rot, for example).

> AFAIK standard guarantees that sector will be updated atomically.

No, the SCSI and ATA standards most certainly do not guarantee that!
NVMe is the only standard I know of that requires Atomic Write Unit
Power Fail to be at lest one sector.

> But it happens! Please guide me how to fix such problems in general.

You fixed it.  Overwriting the sector will clear the error.

Cheers,
Jeff
