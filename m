From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: HDD Unrecovered readerror issue
Date: Fri, 22 Jul 2016 07:33:59 -0700
Message-ID: <1469198039.2382.11.camel@HansenPartnership.com>
References: <87twfkn0mz.fsf@openvz.org>
	 <x494m7hhjbu.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52114 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbcGVOeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2016 10:34:03 -0400
In-Reply-To: <x494m7hhjbu.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 2016-07-22 at 09:51 -0400, Jeff Moyer wrote:
> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> 
> > But once I rewrite this block, problem goes away.
> > #xfs_io -c "pwrite -S 0x0 $((80069000/2))k 4k" -d  /dev/sda
> > 
> > Now I can read it w/o any errors and smartctl is happy
> > #smartctl -t short /dev/sda
> > #smartctl -l selftest /dev/sda
> > Num  Test_Description    Status                  Remaining
> > LifeTime(hours)  LBA_of_first_error
> > # 1  Short offline       Completed without error       00%     
> >  4683 -
> > 
> > So my disk is not dead right?
> 
> Correct.
> 
> > Why the hell HDD fail read from very beginning
> > Is this because HDD firmware detect internal crcXX sum corruption?
> 
> Yes.
> 
> > How this can happen? Is this because of power failure?
> 
> Could be.  If power was cut in the middle of a write, this can 
> happen. There are other causes, though (bit rot, for example).
> 
> > AFAIK standard guarantees that sector will be updated atomically.
> 
> No, the SCSI and ATA standards most certainly do not guarantee that!
> NVMe is the only standard I know of that requires Atomic Write Unit
> Power Fail to be at lest one sector.

The mechanics of the drive mostly ensure atomic updates on the physical
block level.  You definitely get either the old data, the new data or
an unreadable sector.  The latter is a pretty rare event because
surviving power usually ensures the writes complete, but it's not
guaranteed. 

> > But it happens! Please guide me how to fix such problems in
> > general.
> 
> You fixed it.  Overwriting the sector will clear the error.

Actually only "may clear the error" depending on what happened.  If the
hamming codes on the sector itself just failed (because of a torn write
due to power fail) then a rewrite simply re-fixes the sector in situ. 
 Sometimes the magnetic substrate of the track is worn (so the sector
is permanently damaged) and the re-write forces a reallocation.  If
that's happening to your disk then eventually it will fail
irrecoverably when the reallocation table is full.

You can monitor this with the smart Reallocated_Event_Count.

James

