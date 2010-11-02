From: Ralf Gerbig <rge@quengel.org>
Subject: Re: 2.6.36 Crash/Panik in scsi_eh
Date: Tue, 02 Nov 2010 20:22:42 +0100
Message-ID: <87bp67led9.fsf@gerlin1.hsp-law.de>
References: <87fwvkm215.fsf@gerlin1.hsp-law.de>
	<1288710413.3056.256.camel@mulgrave.site>
	<87pqunwszm.fsf@gerlin1.hsp-law.de>
	<1288723004.3056.473.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxy.quengel.org ([213.146.113.159]:48386 "EHLO
	gerlin1.hsp-law.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752789Ab0KBTWp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2010 15:22:45 -0400
In-Reply-To: <1288723004.3056.473.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 02 Nov 2010 14:36:44 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

Hi James,

* James Bottomley writes:

> On Tue, 2010-11-02 at 18:11 +0100, Ralf Gerbig wrote:
>> >> Nov  2 10:40:57 gerlin1 kernel: [45977.560407] RIP: 0010:[<ffffffff811d2290>]  [<ffffffff811d2290>] scsi_dispatch_cmd+0x92/0x22e
>> 
>> > This is the faulting location ... could you run addr2line on this
>> > address to map it to a line of source code?
>> 
>> addr2line id only say ??:0
>> 
>> I recompiled vmlinux with debugging symbols, and gdb says:
>> 
>> Reading symbols from /usr/src/linux-git/linux-2.6/vmlinux...done.
>> (gdb) l *(scsi_dispatch_cmd + 0x92)
>> 0xffffffff811d2290 is in scsi_dispatch_cmd (drivers/scsi/scsi.c:707).
>> 702              * We will wait MIN_RESET_DELAY clock ticks after the
>> last reset so
>> 703              * we can avoid the drive not being ready.
>> 704              */
>> 705             timeout = host->last_reset + MIN_RESET_DELAY;
>> 706
>> 707             if (host->resetting && time_before(jiffies, timeout)) {
>> 708                     int ticks_remaining = timeout - jiffies;
>> 709                     /*
>> 710                      * NOTE: This may be executed from within an interrupt
>> 711                      * handler!  This is bad, but for now, it'll do. The irq

> Um, that's bad.  It's saying the junk pointer is host on line 707 but
> when it was dereferenced on line 705 it was fine.  This is most likely
> to indicate either memory corruption (another thread overwrote the host
> location or even a hardware fault).

Oh well, back to 2.6.36-rc8-00045-g51ea8a8, lets wait and see.

BTW there was a secondary trace - short transcript:

general protection fault: 0000 [#2] PREEMPT SMP
last sysfs file: /sys/system/virtual/sound/uevent
CPU 2
Modules ....

Pid: 0, comm: kworker/0:1 Tainted: G	D 
Rip: 0010:[<ffffffff811d6a9b>] [<ffffffff811d6a9b>] scsi_times_out+0x1b/0x6d

[...]

(gdb) l *(scsi_times_out + 0x1b)
0xffffffff811d6a9b is in scsi_times_out (drivers/scsi/scsi_error.c:136).
131             enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
132
133             trace_scsi_dispatch_cmd_timeout(scmd);
134             scsi_log_completion(scmd, TIMEOUT_ERROR);
135
136             if (scmd->device->host->transportt->eh_timed_out)
137                     rtn = scmd->device->host->transportt->eh_timed_out(scmd);
138             else if (scmd->device->host->hostt->eh_timed_out)
139                     rtn = scmd->device->host->hostt->eh_timed_out(scmd);
140

JPEG is there for the asking.

Thanks for your help,

Ralf
