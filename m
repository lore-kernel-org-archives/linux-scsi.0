From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Fri, 28 Feb 2014 12:21:42 +0000
Message-ID: <bug-71231-11613-Iuw1Huz290@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36021 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbaB1MVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 07:21:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 271F92027D
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2014 12:21:46 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A78D6202A1
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2014 12:21:42 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #3 from Alex <alexandernaumann@gmx.de> ---
Kernel 3.8.13 is working fine
Kernel 3.9.11 is working fine
Kernel 3.12.13 has the bug too
Kernel 3.13.5 is working fine again.

So what has changed in 3.13? It would be nice to have it fixed for the longterm
kernel versions 3.10 and/or 3.12.


With kernel 3.13 is just get these error messages but the system is not
crashing:

[  457.702295] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by
1, t=2102 jiffies, g=5964, c=5963, q=317961)
[  457.702296] sending NMI to all CPUs:
[  457.702299] NMI backtrace for cpu 3
[  457.702302] CPU: 3 PID: 1363 Comm: kworker/3:2 Not tainted 3.13.5-64bit #2
[  457.702303] Hardware name: Dell Inc. PowerEdge R210/0M877N, BIOS 1.1.4
11/16/2009
[  457.702307] task: ffff88003cc01b00 ti: ffff88003c076000 task.ti:
ffff88003c076000
[  457.702312] RIP: 0010:[<ffffffff81073bdc>]  [<ffffffff81073bdc>]
dequeue_task_fair+0x27c/0x6f0
[  457.702313] RSP: 0018:ffff88003c077d38  EFLAGS: 00000046
[  457.702314] RAX: ffff88003f591980 RBX: ffff88003f5919f0 RCX:
ffff88003f591980
[  457.702314] RDX: ffffffff81c70a40 RSI: ffff88003cc01b68 RDI:
ffff88003f5919f0
[  457.702315] RBP: ffff88003c077d88 R08: 0000000000000001 R09:
00000000000002e5
[  457.702315] R10: 0000000000000000 R11: 0000000000000001 R12:
0000000000000001
[  457.702316] R13: 0000000000000001 R14: 0000000000000000 R15:
ffff88003f5919f0
[  457.702317] FS:  0000000000000000(0000) GS:ffff88003f580000(0000)
knlGS:0000000000000000
[  457.702318] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  457.702319] CR2: 00000000000000b8 CR3: 0000000026aa6000 CR4:
00000000000007e0
[  457.702319] Stack:
[  457.702321]  ffff88003c077d68 ffffffff8106f665 0000000100000000
ffff88003f591980
[  457.702322]  ffff88003f591980 ffff88003cc01b00 ffff88003f591980
0000000000000001
[  457.702323]  ffff88003f591200 ffff88003cefe200 ffff88003c077db8
ffffffff8106a73a
[  457.702324] Call Trace:
[  457.702328]  [<ffffffff8106f665>] ? sched_clock_cpu+0xc5/0x120
[  457.702330]  [<ffffffff8106a73a>] dequeue_task+0x5a/0x80
[  457.702331]  [<ffffffff8106adfe>] deactivate_task+0x1e/0x20
[  457.702334]  [<ffffffff817a5239>] __schedule+0x3a9/0x6a0
[  457.702336]  [<ffffffff817a5554>] schedule+0x24/0x70
[  457.702339]  [<ffffffff8105cc53>] worker_thread+0x1c3/0x370
[  457.702340]  [<ffffffff8105ca90>] ? manage_workers.isra.26+0x2a0/0x2a0
[  457.702342]  [<ffffffff81062fc4>] kthread+0xc4/0xe0
[  457.702344]  [<ffffffff81062f00>] ? flush_kthread_worker+0x70/0x70
[  457.702345]  [<ffffffff817a8fcc>] ret_from_fork+0x7c/0xb0
[  457.702346]  [<ffffffff81062f00>] ? flush_kthread_worker+0x70/0x70
[  457.702358] Code: 0f 1f 80 00 00 00 00 49 8b 87 a8 00 00 00 48 8b 80 30 08
00 00 eb ba 0f 1f 84 00 00 00 00 00 48 8b 45 c8 48 8b 4d c8 83 68 04 01 <48> 8b
80 30 08 00 00 48 89 c2 48 2b 91 68 09 00 00 0f 88 75 03 
[  457.702359] NMI backtrace for cpu 1
[  457.702361] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.5-64bit #2
[  457.702361] Hardware name: Dell Inc. PowerEdge R210/0M877N, BIOS 1.1.4
11/16/2009
[  457.702362] task: ffff88003f1f3cc0 ti: ffff88003f214000 task.ti:
ffff88003f214000
[  457.702367] RIP: 0010:[<ffffffff812f4d75>]  [<ffffffff812f4d75>]
delay_tsc+0x45/0x80
[  457.702368] RSP: 0018:ffff88003f483ce8  EFLAGS: 00000046
[  457.702369] RAX: 00000133cef2efb6 RBX: 0000000000000001 RCX:
0000000000000082
[  457.702369] RDX: 0000000000000057 RSI: 0000000000000002 RDI:
00000000002487e6
[  457.702370] RBP: ffff88003f483d08 R08: 0000000000000e81 R09:
ffffffff81c85198
[  457.702371] R10: 0000000000000018 R11: 0000000000040000 R12:
00000000cef2ef5f
[  457.702372] R13: 00000000002487e6 R14: 0000000000000001 R15:
0000000000000001
[  457.702373] FS:  0000000000000000(0000) GS:ffff88003f480000(0000)
knlGS:0000000000000000
[  457.702373] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  457.702374] CR2: 00000000080f2c58 CR3: 000000002abd6000 CR4:
00000000000007e0
[  457.702375] Stack:
[  457.702376]  0000000000002710 ffffffff81af50c0 ffffffff81b48ae0
ffffffff81af50c0
[  457.702377]  ffff88003f483d18 ffffffff812f4cc9 ffff88003f483d38
ffffffff8102f02e
[  457.702378]  000000000000174b ffff88003f48d4e0 ffff88003f483d98
ffffffff81087b90
[  457.702379] Call Trace:
[  457.702380]  <IRQ> 
[  457.702382]  [<ffffffff812f4cc9>] __const_udelay+0x29/0x30
[  457.702385]  [<ffffffff8102f02e>] arch_trigger_all_cpu_backtrace+0x5e/0x80
[  457.702388]  [<ffffffff81087b90>] rcu_check_callbacks+0x5a0/0x5c0
[  457.702391]  [<ffffffff810509b3>] update_process_times+0x43/0x80
[  457.702394]  [<ffffffff81090d31>] tick_sched_handle.isra.13+0x31/0x40
[  457.702395]  [<ffffffff81090e74>] tick_sched_timer+0x44/0x70
[  457.702398]  [<ffffffff810657af>] __run_hrtimer.isra.30+0x4f/0xd0
[  457.702400]  [<ffffffff81065f85>] hrtimer_interrupt+0xf5/0x230
[  457.702403]  [<ffffffff81032ef1>] hpet_interrupt_handler+0x11/0x30
[  457.702404]  [<ffffffff8107f4f3>] handle_irq_event_percpu+0x43/0x160
[  457.702410]  [<ffffffff8107f64c>] handle_irq_event+0x3c/0x60
[  457.702412]  [<ffffffff81081c5f>] handle_edge_irq+0x6f/0x110
[  457.702414]  [<ffffffff8100491d>] handle_irq+0x1d/0x30
[  457.702415]  [<ffffffff81004725>] do_IRQ+0x55/0xd0
[  457.702418]  [<ffffffff817a88ed>] common_interrupt+0x6d/0x6d
[  457.702419]  <EOI> 
[  457.702421]  [<ffffffff81686c79>] ? cpuidle_enter_state+0x59/0xe0
[  457.702423]  [<ffffffff81686c72>] ? cpuidle_enter_state+0x52/0xe0
[  457.702424]  [<ffffffff81686d9a>] cpuidle_idle_call+0x9a/0x140
[  457.702427]  [<ffffffff8100bbe9>] arch_cpu_idle+0x9/0x30
[  457.702428]  [<ffffffff8107eaa1>] cpu_startup_entry+0x71/0x1a0
[  457.702431]  [<ffffffff8102c3a0>] start_secondary+0x1a0/0x1f0
[  457.702443] Code: 0f ae e8 e8 8e 53 d1 ff 66 90 41 89 c4 eb 16 0f 1f 80 00
00 00 00 f3 90 65 8b 1c 25 1c b0 00 00 41 39 de 75 20 66 66 90 0f ae e8 <e8> 66
53 d1 ff 66 90 89 c2 44 29 e2 44 39 ea 72 da 5b 41 5c 41 
[  457.702444] NMI backtrace for cpu 2
[  457.702446] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.5-64bit #2
[  457.702446] Hardware name: Dell Inc. PowerEdge R210/0M877N, BIOS 1.1.4
11/16/2009
[  457.702447] task: ffff88003f1f4380 ti: ffff88003f216000 task.ti:
ffff88003f216000
[  457.702451] RIP: 0010:[<ffffffff812e93e0>]  [<ffffffff812e93e0>]
cpumask_next_and+0x10/0x50
[  457.702451] RSP: 0018:ffff88003f503bb8  EFLAGS: 00000202
[  457.702452] RAX: 0000000000000001 RBX: ffff88003f0046f8 RCX:
ffff88003f1f3cc0
[  457.702453] RDX: ffff88003f50d130 RSI: ffff88003f0046f8 RDI:
0000000000000001
[  457.702453] RBP: ffff88003f503bc8 R08: 0000000000000000 R09:
0000000000000000
[  457.702454] R10: 0000000000000400 R11: 0000000000000000 R12:
ffff88003f50d130
[  457.702455] R13: ffff88003f0046e0 R14: 0000000000000001 R15:
ffff88003f503db0
[  457.702456] FS:  0000000000000000(0000) GS:ffff88003f500000(0000)
knlGS:0000000000000000
[  457.702457] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  457.702457] CR2: 00000000f763688f CR3: 0000000001acd000 CR4:
00000000000007e0
[  457.702458] Stack:
[  457.702459]  0000000000000000 ffff88003f503c10 ffff88003f503d28
ffffffff810748ab
[  457.702460]  ffff88003f503c68 000000008173c358 fffffffffffffff8
0000000000000000
[  457.702462]  ffff88003f0046f8 ffff88003f503c50 ffff88003f503c28
0000000000000000
[  457.702462] Call Trace:
[  457.702463]  <IRQ> 
[  457.702465]  [<ffffffff810748ab>] find_busiest_group+0x12b/0x890
[  457.702467]  [<ffffffff8107516a>] load_balance+0x15a/0x8a0
[  457.702469]  [<ffffffff8106f665>] ? sched_clock_cpu+0xc5/0x120
[  457.702471]  [<ffffffff8106a6bb>] ? update_rq_clock+0x2b/0x50
[  457.702472]  [<ffffffff81075a01>] rebalance_domains+0x151/0x250
[  457.702474]  [<ffffffff81075b45>] run_rebalance_domains+0x45/0x180
[  457.702475]  [<ffffffff8104a0a5>] __do_softirq+0xd5/0x1d0
[  457.702479]  [<ffffffff8104a475>] irq_exit+0x95/0xa0
[  457.702480]  [<ffffffff8100472e>] do_IRQ+0x5e/0xd0
[  457.702482]  [<ffffffff817a88ed>] common_interrupt+0x6d/0x6d
[  457.702483]  <EOI> 
[  457.702485]  [<ffffffff81686c79>] ? cpuidle_enter_state+0x59/0xe0
[  457.702486]  [<ffffffff81686c72>] ? cpuidle_enter_state+0x52/0xe0
[  457.702488]  [<ffffffff81686d9a>] cpuidle_idle_call+0x9a/0x140
[  457.702490]  [<ffffffff8100bbe9>] arch_cpu_idle+0x9/0x30
[  457.702492]  [<ffffffff8107eaa1>] cpu_startup_entry+0x71/0x1a0
[  457.702494]  [<ffffffff8102c3a0>] start_secondary+0x1a0/0x1f0
[  457.702506] Code: 89 65 00 48 8b 45 d8 48 83 c4 10 5b 41 5c 41 5d 41 5e 5d
c3 45 31 e4 eb e6 90 90 55 48 89 e5 41 54 49 89 d4 53 48 89 f3 0f 1f 00 <8d> 4f
01 be 40 00 00 00 48 89 df 48 63 d1 e8 cd 13 01 00 3b 05 
[  457.702506] NMI backtrace for cpu 0
[  457.702508] CPU: 0 PID: 29356 Comm: kworker/u8:12 Not tainted 3.13.5-64bit
#2
[  457.702509] Hardware name: Dell Inc. PowerEdge R210/0M877N, BIOS 1.1.4
11/16/2009
[  457.702512] Workqueue: events_unbound async_run_entry_fn
[  457.702513] task: ffff8800001e4380 ti: ffff88002f25c000 task.ti:
ffff88002f25c000
[  457.702516] RIP: 0010:[<ffffffff81388820>]  [<ffffffff81388820>]
io_serial_in+0x10/0x20
[  457.702517] RSP: 0018:ffff88002f25d968  EFLAGS: 00000002
[  457.702518] RAX: 00000133cef2e800 RBX: ffffffff81cc7d60 RCX:
0000000000000000
[  457.702519] RDX: 00000000000003fd RSI: 00000000000003fd RDI:
ffffffff81cc7d60
[  457.702519] RBP: ffff88002f25d968 R08: 000000000000000a R09:
0000000000000000
[  457.702520] R10: 0000000000000000 R11: 0000000000000e7c R12:
0000000000002622
[  457.702521] R13: 0000000000000020 R14: ffffffff81cb1e15 R15:
0000000000000035
[  457.702522] FS:  0000000000000000(0000) GS:ffff88003f400000(0000)
knlGS:0000000000000000
[  457.702523] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  457.702523] CR2: 00000000080ee9b4 CR3: 0000000001acd000 CR4:
00000000000007f0
[  457.702524] Stack:
[  457.702525]  ffff88002f25d998 ffffffff81388d1b ffff88002f25d9a8
ffffffff81cc7d60
[  457.702526]  0000000000000074 ffffffff81cc7d60 ffff88002f25d9b8
ffffffff81388da0
[  457.702528]  ffffffff81cb1e05 ffffffff81388d80 ffff88002f25d9e8
ffffffff81384742
[  457.702528] Call Trace:
[  457.702530]  [<ffffffff81388d1b>] wait_for_xmitr+0x3b/0xa0
[  457.702532]  [<ffffffff81388da0>] serial8250_console_putchar+0x20/0x40
[  457.702534]  [<ffffffff81388d80>] ? wait_for_xmitr+0xa0/0xa0
[  457.702535]  [<ffffffff81384742>] uart_console_write+0x32/0x70
[  457.702537]  [<ffffffff81389ad1>] serial8250_console_write+0xb1/0x140
[  457.702539]  [<ffffffff8107bf73>]
call_console_drivers.constprop.25+0x93/0xb0
[  457.702541]  [<ffffffff8107d2c8>] console_unlock+0x398/0x3d0
[  457.702542]  [<ffffffff8107d665>] vprintk_emit+0x1e5/0x480
[  457.702544]  [<ffffffff812f19d2>] ? put_dec+0x72/0x90
[  457.702546]  [<ffffffff8139ea97>] dev_vprintk_emit+0x57/0x70
[  457.702548]  [<ffffffff812f256e>] ? string.isra.3+0x3e/0xd0
[  457.702550]  [<ffffffff812f3a49>] ? vsnprintf+0x309/0x5f0
[  457.702551]  [<ffffffff8139eae4>] dev_printk_emit+0x34/0x40
[  457.702553]  [<ffffffff8139f309>] __dev_printk+0x59/0x90
[  457.702554]  [<ffffffff8139f620>] dev_printk+0x40/0x50
[  457.702557]  [<ffffffff8142d910>] sd_revalidate_disk+0x580/0x1c30
[  457.702559]  [<ffffffff8106aeb5>] ? check_preempt_curr+0x85/0xa0
[  457.702560]  [<ffffffff8142f085>] sd_probe_async+0xc5/0x1d0
[  457.702562]  [<ffffffff810681b6>] async_run_entry_fn+0x36/0x130
[  457.702564]  [<ffffffff8105b50f>] process_one_work+0x14f/0x3e0
[  457.702565]  [<ffffffff8105cba9>] worker_thread+0x119/0x370
[  457.702567]  [<ffffffff8105ca90>] ? manage_workers.isra.26+0x2a0/0x2a0
[  457.702569]  [<ffffffff81062fc4>] kthread+0xc4/0xe0
[  457.702570]  [<ffffffff81062f00>] ? flush_kthread_worker+0x70/0x70
[  457.702572]  [<ffffffff817a8fcc>] ret_from_fork+0x7c/0xb0
[  457.702573]  [<ffffffff81062f00>] ? flush_kthread_worker+0x70/0x70
[  457.702585] Code: 48 89 e5 d3 e6 48 63 f6 48 03 77 10 8b 06 5d c3 66 66 2e
0f 1f 84 00 00 00 00 00 0f b6 4f 61 55 48 89 e5 d3 e6 03 77 08 89 f2 ec <0f> b6
c0 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f b6 4f 61 55

-- 
You are receiving this mail because:
You are the assignee for the bug.
