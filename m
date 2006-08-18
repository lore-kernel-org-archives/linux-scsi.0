From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Fri, 18 Aug 2006 18:00:45 -0400
Message-ID: <44E6388D.1000206@torque.net>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33702 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751504AbWHRWAr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 18:00:47 -0400
In-Reply-To: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: linux-scsi@vger.kernel.org

Fajun Chen wrote:
> Hi Folks,
> 
> I use ATA pass through via sg ioctl interface for data read/write.
> Linux 2.6.18-rc2 patched with Jeff Garzik's libata git patch was
> running on ARM IOP80321 board. The HBA Sil3124 was used.
> 
> Two problems were observed:
> 1. sg mmap bug?
>    My test program could not write data correctly to the mmapped
> buffer in the user space.      The program did a read immediately
> after a write and the data mismatches.  Swapped the sg_vma_nopage()
> function with the one in 2.6.15.4 release fixed the problem. So this
> appears to be a wrong change to the sg mmap code in 2.6.18-rc2
> release.

Thanks for the report. I can confirm that mmap-ed IO
in the sg driver is broken. Simply reading 16 blocks
from some arbitrary offset with sg_dd and sgm_dd
and comparing the fetched data shows mismatches starting
above the first page (i.e. above byte offset 4096 on
i386).

Your point about the change to sg_vma_nopage() between
lk 2.6.15 and lk 2.6.16 also seems to be correct.
The most indented part of that function has been
changed from incrementing the change count on the
reported page (as indicated by 'offset') in a
compound page allocation to ignoring the 'offset'
and incrementing the page count on the first page
in a compound page allocation.

> 2. sg hangs or have really slow response
>   Under certain unknown conditions, sg will be busy with one
> read/write ioctl call for over half an hour.  From scsi proc
> interface, sg and scsi mid layer were processing requests as  states
> "act" or "rcv" was shown in /proc/scsi/sg/debug. My test program set
> the command timeout to be 30 seconds, but this timeout did not trigger
> the command abort.

Well yes, I have noticed on transport errors, the attempt
to abort the command (or use a larger hammer) fails and
the command just keeps on chugging. The "elapsed" time
in the /proc/scsi/sg/debug just keeps on growing, typically
to a value much larger than the given timeout.

> Are these problems genuine bugs in sg 2.6.18-rc2 release? Since the
> problem is reproducible in my test hardware, please let me know if any
> log/traces can be collected.

I was able to confirm the breakage in point 1)
with a recent SATA disk with an old SIL 3112 controller
and with a SAS disk with some pretty recent MPT Fusion
hardware. That was enough for me.

> BTW, scsi logging through proc FS seems to be broken as well even
> though SCSI logging and Proc FS are enabled in my 2.6.18-rc2 kernel
> config.

Looks like we should be doing a lot more testing,
especially when our friends from other kernel areas
offer to clean up our code and remove cruft.

Doug Gilbert

