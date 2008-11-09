From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11990] Kernel hang in spin_unlock_irq from scsi_request_fn from do_IRQ
Date: Sun,  9 Nov 2008 07:23:02 -0800 (PST)
Message-ID: <20081109152302.1F873108056@picon.linux-foundation.org>
References: <bug-11990-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754912AbYKIPXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 10:23:34 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA9FN2sI003592
	for <linux-scsi@vger.kernel.org>; Sun, 9 Nov 2008 07:23:03 -0800
In-Reply-To: <bug-11990-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11990





------- Comment #2 from anonymous@kernel-bugs.osdl.org  2008-11-09 07:22 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Sat, 2008-11-08 at 19:50 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11990
> 
>            Summary: Kernel hang in spin_unlock_irq from scsi_request_fn from
>                     do_IRQ
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.28-rc3
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: vandrove@vc.cvut.cz
> 
> 
> Latest working kernel version: commit c8d7aa after 2.6.28-rc2
> Earliest failing kernel version: commit 920da6 after 2.6.28-rc2
> Distribution: Debian
> Hardware Environment: sata_sil24, amd64, 2cpu
> Software Environment: 64bit kernel, 32bit userspace, preemptible kernel
> Problem Description:
> 
> When I/O is under stress, from time to time CPU1 hangs, most probably due to
> endless stream of interrupts.  Backtrace printed either by kernel's softlockup
> detection or alt-sysrq-p is below (written down; I/O is dead when this
> happens).
> 
> _spin_unlock_irq + 0x30  (after sti)
> scsi_request_fn + 0x1b9  (after spin_unlock_irq(shost->host_lock) at
> not_ready:)
> blk_invoke_request_fn
> __blk_runqueue
> scsi_run_queue
> scsi_next_command
> scsi_end_request
> scsi_io_completion
> scsi_finish_command
> scsi_softirq_done
> blk_done_softirq
> __do_softirq
> call_softirq
> do_softirq
> irqexit
> do_IRQ
> ret_from_intr
> <EOI>
> native_safe_halt
> trace_hardirqs_on
> default_idle
> c1e_idle
> cpu_idle
> start_secondary
> 
> Steps to reproduce:
> 
> It seems to occur under heavy I/O (updatedb, dumping core from ~3GB app), but I
> was not able to trigger it reliably - most reliable is hard resetting box, then
> it occurs in ~80% cases when replaying journals on disks connected to
> sata_sil24 (through PMP, but problem does not seem to occur on 2.6.28-rc2 with
> Jens's PMP patches).

This looks identical to

http://bugzilla.kernel.org/show_bug.cgi?id=11898

Could you see if this refinement of the discussed patches fixes it for
you?

Thanks,

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f5d3b96..e09a661 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -606,6 +606,7 @@ static void scsi_run_queue(struct request_queue *q)
                }

                list_del_init(&sdev->starved_entry);
+               starved_head = NULL;
                spin_unlock(shost->host_lock);

                spin_lock(sdev->request_queue->queue_lock);
@@ -620,6 +621,12 @@ static void scsi_run_queue(struct request_queue *q)
                spin_unlock(sdev->request_queue->queue_lock);

                spin_lock(shost->host_lock);
+               if (unlikely(!list_empty(&sdev->starved_entry)))
+                       /* 
+                        * sdev got put back on the starved list
+                        * so finish starved handling
+                        */
+                       break;
        }
        spin_unlock_irqrestore(shost->host_lock, flags);



-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
