From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: [Bugme-new] [Bug 5998] New: oops on mount "kernel access
 of bad area, sig: 11 [#1]"
Date: Fri, 03 Feb 2006 08:30:52 +0100
Message-ID: <43E306AC.60004@s5r6.in-berlin.de>
References: <20060202150719.0dafc8ae.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:1934 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932195AbWBCHeS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2006 02:34:18 -0500
In-Reply-To: <20060202150719.0dafc8ae.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: johnstul@us.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Begin forwarded message:
> 
> Date: Thu, 2 Feb 2006 15:03:45 -0800
> From: bugme-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 5998] New: oops on mount "kernel access of bad area, sig: 11 [#1]"
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=5998
> 
>            Summary: oops on mount "kernel access of bad area, sig: 11 [#1]"
>     Kernel Version: 2.6.15-rc5
>             Status: NEW
>           Severity: normal
>              Owner: drivers_ieee1394@kernel-bugs.osdl.org
>          Submitter: johnstul@us.ibm.com
> 
> 
> Most recent kernel where this bug did not occur: unknown
> Distribution: Ubuntu
> Hardware Environment: ppc32 Apple Mac mini
> Problem Description:
> 
> After over 10 days of uptime, mounting and unmounting my external firewire
> hardddrive for backups, I got the following OOPs today when trying to mount the
> drive.

I am Cc'ing linux-scsi because it is not entirely clear (to me) whether 
sbp2 or upper layers may cause it. Although I suspect sbp2's interaction 
with the scsi core to be the culprit again.

> I've seen problems where the cable gets bumped loose and I'll see
> something similar, however I have not been able to verify if the cable was
> secure when this occured.  The mount command is still hung, but the box seems to
> be running fine.

When the cable is pulled during I/O, sbp2 did not take care to finish 
SCSI commands that were enqueued right before the cable pull. (Other 
hardware problems may have the same effect.) I discovered this problem 
when I still ran Linux 2.6.14, there it simply lead to knodemgrd being 
stuck in uninteruptible sleep in blk_execute_rq(). I have not checked 
yet how Linux 2.6.15 or other configurations than preemptible i386 
uniprocessor would react on this. A fix for this is making its way 
downstream. (Upstream?) 
http://www.kernel.org/git/?p=linux/kernel/git/scjody/ieee1394.git;a=commitdiff;h=61daa34c132c5d4ed8630e2c46e9bf2f0c7b3428
I don't know if the patch alone can be applied to 2.6.15, but this patch 
set can: http://me.in-berlin.de/~s5r6/linux1394/updates/

> ieee1394: sbp2: aborting sbp2 command
> sd 0:0:0:0: 
>         command: cdb[0]=0x28: 28 00 09 27 c0 03 00 00 02 00
> ieee1394: sbp2: aborting sbp2 command
> sd 0:0:0:0: 
>         command: cdb[0]=0x0: 00 00 00 00 00 00
> Oops: kernel access of bad area, sig: 11 [#1]
> PREEMPT 
> NIP: C0023FF8 LR: C0023FF8 SP: EFC0FEB0 REGS: efc0fe00 TRAP: 0300    Not tainted
> MSR: 00001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11
> DAR: 00000000, DSISR: 40000000
> TASK = c134b230[317] 'scsi_eh_0' THREAD: efc0e000
> Last syscall: -1 
> GPR00: 00000000 EFC0FEB0 C134B230 00000001 C05BDE28 FFFFFFFF C0650000 C0664E84 
> GPR08: 00040000 00000001 C13DF400 EFC0E000 C0650000 00000000 00000000 00000000 
> GPR16: 00000000 C02EF5A0 C06070EC C0586F7C C06070EC C0586F7C C06070EC C0650000 
> GPR24: 00000003 C13EE204 C13EE268 00000001 00009032 00000000 C13EE1C0 C02EF440 
> NIP [c0023ff8] complete+0x28/0x90
> LR [c0023ff8] complete+0x28/0x90
> Call trace:
>  [c02ef45c] scsi_eh_done+0x1c/0x30
>  [c03248b8] sbp2scsi_abort+0x158/0x170
>  [c02efbcc] scsi_send_eh_cmnd+0x10c/0x1a0
>  [c02efce8] scsi_eh_tur+0x88/0xe0
>  [c02f0930] scsi_error_handler+0x450/0xa10
>  [c00437e8] kthread+0x108/0x110
>  [c0007534] kernel_thread+0x44/0x60
> note: scsi_eh_0[317] exited with preempt_count 1
> 
> 
> Steps to reproduce: Not easily reproduced.

It looks actually different from what I described above. Perhaps 
scsi_eh_done was called on a command which was already completed shortly 
before. sbp2scsi_abort calls the "done" handler for the command to be 
aborted and for all other pending commands (for the latter to be 
enqueued again). Sbp2 also calls the done handler right after a SBP-2 
reconnect in sbp2_update, i.e. after the FireWire bus was reset. Perhaps 
one or the other or both places in sbp2 need to take the Scsi_Host's 
host_lock.

John, do you have the syslog still available from when the oops 
occurred? Was there a reconnect logged?

This report from October may be related: "slab error in 
cache_free_debugcheck(): cache `sgpool-8" 
http://marc.theaimsgroup.com/?t=112931959700002
Although it appeared (to the reporter) as if this problem was fixed 
lately. Maybe it was only masked out by an unrelated change.
-- 
Stefan Richter
-=====-=-==- --=- ---==
http://arcgraph.de/sr/
