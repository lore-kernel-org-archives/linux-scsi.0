From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc5-mm1 - SCSI/blkdev probing hang
Date: Thu, 20 Dec 2007 13:22:12 -0800
Message-ID: <20071220132212.173fa493.akpm@linux-foundation.org>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	<20071220155745.1f079a3b@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760885AbXLTVXW@vger.kernel.org>
In-Reply-To: <20071220155745.1f079a3b@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 20 Dec 2007 15:57:45 -0500
Rik van Riel <riel@redhat.com> wrote:

> 2.6.24-rc5-mm1 seems to have a hang related to the SCSI or block
> device probing code.
> 
> This is on a dual quad-core x86-64 system with megaraid_sas controller.
> 
> scsi 0:2:0:0: Direct-Access     DELL     PERC 5/i         1.03 PQ: 0 ANSI: 5
> general protection fault: 0000 [1] SMP 
> last sysfs file: /sys/class/firmware/timeout
> CPU 7 
> Modules linked in: ata_piix libata dm_snapshot dm_zero dm_mirror dm_mod shpchp megaraid_sas sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
> Pid: 678, comm: scsi_scan_0 Not tainted 2.6.24-rc5-mm1 #1
> RIP: 0010:[<ffffffff81058183>]  [<ffffffff81058183>] mark_lock+0x1b/0x472

Could be that someone passed a garbage pointer into lockdep.

> RSP: 0018:ffff81043ba29c20  EFLAGS: 00010002
> RAX: 0000000000000010 RBX: ffff81043b9ee8f0 RCX: ffff81043b9ee804
> RDX: 6b6b6b6b6b6b6b6b RSI: ffff81043b9ee8f0 RDI: ffff81043b9ee000
> RBP: ffff81043b9ee000 R08: 0000000000000002 R09: 0000000000000000
> R10: ffffffff81129055 R11: 0000000281128c8d R12: 0000000000000004
> R13: 0000000000000001 R14: 0000000000000002 R15: ffff81043e508028
> FS:  0000000000000000(0000) GS:ffff81043e4e6a28(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 000000361969afa0 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process scsi_scan_0 (pid: 678, threadinfo ffff81043ba28000, task ffff81043b9ee000)
> Stack:  ffff81043b9ee8f0 6b6b6b6b6b6b6b6b ffff81043b9ee000<6>ata1.00: ATAPI: HL-DT-STCD-RW/DVD-ROM GCC-T10N, A102, max UDMA/33
>  ffffffff81059139
>  000000003ba29c50 0000000000000002 0000000000000000 ffffffff81058623
>  ffff81043b504660 0000000000000246 ffff81043e508028 ffff81043b504660
> Call Trace:
>  [<ffffffff81059139>] __lock_acquire+0x4d7/0xc8e
>  [<ffffffff81058623>] mark_held_locks+0x49/0x67
>  [<ffffffff81059ce2>] lock_acquire+0x5a/0x73
>  [<ffffffff81129055>] kobject_add+0xca/0x194
>  [<ffffffff8126d56c>] mutex_lock_nested+0x2a1/0x2b0
>  [<ffffffff8126e997>] _spin_lock+0x26/0x52
>  [<ffffffff81129055>] kobject_add+0xca/0x194
>  [<ffffffff811a318c>] device_add+0x9a/0x56e
>  [<ffffffff8805c327>] :scsi_mod:scsi_alloc_target+0x2cd/0x343
>  [<ffffffff8805c492>] :scsi_mod:__scsi_scan_target+0x66/0x5c6
>  [<ffffffff810587f0>] trace_hardirqs_on+0x115/0x138
>  [<ffffffff8805ca37>] :scsi_mod:scsi_scan_channel+0x45/0x70
>  [<ffffffff8805cb37>] :scsi_mod:scsi_scan_host_selected+0xd5/0x110
> ata1.00: configured for UDMA/33
> ata2: port disabled. ignoring.
>  [<ffffffff8805cbe5>] :scsi_mod:do_scan_async+0x0/0x152
>  [<ffffffff8805cbf9>] :scsi_mod:do_scan_async+0x14/0x152
>  [<ffffffff8805cbe5>] :scsi_mod:do_scan_async+0x0/0x152
>  [<ffffffff8104d4e8>] kthread+0x47/0x73
>  [<ffffffff8126e418>] trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff8100cee8>] child_rip+0xa/0x12
>  [<ffffffff8100c5ff>] restore_args+0x0/0x30
>  [<ffffffff811e0908>] menu_reflect+0x0/0x75
>  [<ffffffff8104d371>] kthreadd+0x115/0x13a
>  [<ffffffff8104d4a1>] kthread+0x0/0x73
>  [<ffffffff8100cede>] child_rip+0x0/0x12
> 

It could be a scsi problem, or it could be all the kobject changes in
Greg's driver tree.  Or a combination of the two.

Don't know, sorry.

