From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11990] New: Kernel hang in spin_unlock_irq from scsi_request_fn from do_IRQ
Date: Sat,  8 Nov 2008 19:50:19 -0800 (PST)
Message-ID: <bug-11990-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812AbYKIDuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Nov 2008 22:50:22 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA93oJcI001949
	for <linux-scsi@vger.kernel.org>; Sat, 8 Nov 2008 19:50:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11990

           Summary: Kernel hang in spin_unlock_irq from scsi_request_fn from
                    do_IRQ
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.28-rc3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: vandrove@vc.cvut.cz


Latest working kernel version: commit c8d7aa after 2.6.28-rc2
Earliest failing kernel version: commit 920da6 after 2.6.28-rc2
Distribution: Debian
Hardware Environment: sata_sil24, amd64, 2cpu
Software Environment: 64bit kernel, 32bit userspace, preemptible kernel
Problem Description:

When I/O is under stress, from time to time CPU1 hangs, most probably due to
endless stream of interrupts.  Backtrace printed either by kernel's softlockup
detection or alt-sysrq-p is below (written down; I/O is dead when this
happens).

_spin_unlock_irq + 0x30  (after sti)
scsi_request_fn + 0x1b9  (after spin_unlock_irq(shost->host_lock) at
not_ready:)
blk_invoke_request_fn
__blk_runqueue
scsi_run_queue
scsi_next_command
scsi_end_request
scsi_io_completion
scsi_finish_command
scsi_softirq_done
blk_done_softirq
__do_softirq
call_softirq
do_softirq
irqexit
do_IRQ
ret_from_intr
<EOI>
native_safe_halt
trace_hardirqs_on
default_idle
c1e_idle
cpu_idle
start_secondary

Steps to reproduce:

It seems to occur under heavy I/O (updatedb, dumping core from ~3GB app), but I
was not able to trigger it reliably - most reliable is hard resetting box, then
it occurs in ~80% cases when replaying journals on disks connected to
sata_sil24 (through PMP, but problem does not seem to occur on 2.6.28-rc2 with
Jens's PMP patches).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
