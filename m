From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux 2.6.29-rc3 kernel failure with mptsas
Date: Fri, 6 Feb 2009 15:50:38 -0800
Message-ID: <20090206155038.67847521.akpm@linux-foundation.org>
References: <B4ED8DE8E195E84A872496A085BC07822F11@exchange01.corp.win-professional.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbZBFXvN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2009 18:51:13 -0500
In-Reply-To: <B4ED8DE8E195E84A872496A085BC07822F11@exchange01.corp.win-professional.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 5 Feb 2009 23:29:10 +0100
"Morten P.D. Stevens" <mstevens@win-professional.com> wrote:

> Hi,
> 
> I get a kernel failure with linux 2.6.29-rc3 on my Dell T7400
> Workstation.
> 
> failure message:
> 
> WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a8/0x353()
> (Tainted: G        W )
> Hardware name: Precision WorkStation T7400  
> Modules linked in: ata_generic pata_acpi mptsas(+) mptscsih mptbase
> scsi_transport_sas
> Pid: 35, comm: work_on_cpu/0 Tainted: G        W
> 2.6.29-0.66.rc3.fc11.x86_64 #1
> Call Trace:
> [<ffffffff8104a5c1>] warn_slowpath+0xb9/0xfe
> [<ffffffff813806d9>] ? printk+0x3c/0x43
> [<ffffffff8119b5fb>] __debug_object_init+0x2a8/0x353
> [<ffffffff8106d74a>] ? trace_hardirqs_on+0xd/0xf
> [<ffffffff8119b6d3>] debug_object_init+0x14/0x19
> [<ffffffff8105461f>] init_timer+0x18/0x5b
> [<ffffffffa001122d>] mpt_config+0x1e4/0x305 [mptbase]
> [<ffffffffa001017a>] ? pci_free_consistent+0x75/0x81 [mptbase]
> [<ffffffffa0012f25>] mpt_do_ioc_recovery+0x142a/0x15e8 [mptbase]
> [<ffffffff81046c95>] ? finish_task_switch+0x5f/0xf6
> [<ffffffff81046c36>] ? finish_task_switch+0x0/0xf6
> [<ffffffffa00132a5>] ? mpt_timer_expired+0x0/0x60 [mptbase]
> [<ffffffff8101414a>] ? dump_trace+0x269/0x27b
> [<ffffffff8101c12b>] ? save_stack_trace+0x2a/0x48
> [<ffffffff8106c546>] ? save_trace+0x3f/0x95
> [<ffffffff8106d137>] ? mark_lock+0x22/0x3ad
> [<ffffffff8106d137>] ? mark_lock+0x22/0x3ad
> [<ffffffff8106d529>] ? mark_held_locks+0x67/0x83
> [<ffffffff81383395>] ? _spin_unlock_irqrestore+0x47/0x57
> [<ffffffff8106d719>] ? trace_hardirqs_on_caller+0x12f/0x153
> [<ffffffff8106d74a>] ? trace_hardirqs_on+0xd/0xf
> [<ffffffff81194602>] ? __up_read+0x7c/0x85
> [<ffffffff810624ad>] ? up_read+0x26/0x2a
> [<ffffffffa001480f>] mpt_attach+0xa1b/0xb80 [mptbase]
> [<ffffffffa002f70a>] mptsas_probe+0x1a/0x487 [mptsas]
> [<ffffffff811a491f>] local_pci_probe+0x12/0x16
> [<ffffffff8105b0d7>] do_work_for_cpu+0x13/0x1b
> [<ffffffff8105b268>] run_workqueue+0x103/0x20a
> [<ffffffff8105b216>] ? run_workqueue+0xb1/0x20a
> [<ffffffff8106d719>] ? trace_hardirqs_on_caller+0x12f/0x153
> [<ffffffff8105b0c4>] ? do_work_for_cpu+0x0/0x1b
> [<ffffffff8105b44f>] worker_thread+0xe0/0xf1
> [<ffffffff8105f090>] ? autoremove_wake_function+0x0/0x38
> [<ffffffff8105b36f>] ? worker_thread+0x0/0xf1
> [<ffffffff8105ed18>] kthread+0x49/0x76
> [<ffffffff8101262a>] child_rip+0xa/0x20
> [<ffffffff81011f3e>] ? restore_args+0x0/0x30
> [<ffffffff8105ecaa>] ? kthreadd+0x176/0x19b
> [<ffffffff8105eccf>] ? kthread+0x0/0x76
> [<ffffffff81012620>] ? child_rip+0x0/0x20
> ---[ end trace af29b8e50456f967 ]---
> 
> 
> Kernel failure message 2:
> ODEBUG: object is on stack, but not annotated

This should fix it:

From: "Eric Paris" <eparis@parisplace.org>

ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x1f3/0x276()
Hardware name: VMware Virtual Platform
Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi ext3 jbd mbcache
Pid: 540, comm: insmod Not tainted 2.6.28-mm1 #2
Call Trace:
 [<c042c51c>] warn_slowpath+0x74/0x8a
 [<c0469600>] ? start_critical_timing+0x96/0xb7
 [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
 [<c0446fad>] ? trace_hardirqs_off_caller+0x18/0xaf
 [<c044704f>] ? trace_hardirqs_off+0xb/0xd
 [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
 [<c042cb84>] ? release_console_sem+0x1a5/0x1ad
 [<c05013e6>] __debug_object_init+0x1f3/0x276
 [<c0501494>] debug_object_init+0x13/0x17
 [<c0433c56>] init_timer+0x10/0x1a
 [<e08e5b54>] mpt_config+0x1c1/0x2b7 [mptbase]
 [<e08e3b82>] ? kmalloc+0x8/0xa [mptbase]
 [<e08e3b82>] ? kmalloc+0x8/0xa [mptbase]
 [<e08e6fa2>] mpt_do_ioc_recovery+0x950/0x1212 [mptbase]
 [<c04496c2>] ? __lock_acquire+0xa69/0xacc
 [<c060c8f1>] ? _spin_unlock_irqrestore+0x36/0x3c
 [<c060c3af>] ? _spin_unlock_irq+0x22/0x26
 [<c04f2d8b>] ? string+0x2b/0x76
 [<c04f310e>] ? vsnprintf+0x338/0x7b3
 [<c04496c2>] ? __lock_acquire+0xa69/0xacc
 [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
 [<c04496c2>] ? __lock_acquire+0xa69/0xacc
 [<c044897d>] ? debug_check_no_locks_freed+0xeb/0x105
 [<c060c8f1>] ? _spin_unlock_irqrestore+0x36/0x3c
 [<c04488bc>] ? debug_check_no_locks_freed+0x2a/0x105
 [<c0446b8c>] ? lock_release_holdtime+0x43/0x48
 [<c043f742>] ? up_read+0x16/0x29
 [<c05076f8>] ? pci_get_slot+0x66/0x72
 [<e08e89ca>] mpt_attach+0x881/0x9b1 [mptbase]
 [<e091c8e5>] mptspi_probe+0x11/0x354 [mptspi]

Noticing that every caller of mpt_config has its CONFIGPARMS struct
declared on the stack and thus the &pCfg->timer is always on the stack I
changed init_timer() to init_timer_on_stack() and it seems to have shut
up.....

Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptbase.c~scsi-mpt-suppress-debugobjects-warning drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~scsi-mpt-suppress-debugobjects-warning
+++ a/drivers/message/fusion/mptbase.c
@@ -5934,7 +5934,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 
 	/* Initalize the timer
 	 */
-	init_timer(&pCfg->timer);
+	init_timer_on_stack(&pCfg->timer);
 	pCfg->timer.data = (unsigned long) ioc;
 	pCfg->timer.function = mpt_timer_expired;
 	pCfg->wait_done = 0;
_

