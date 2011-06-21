From: Takashi TAKATORI <ttaka@tech.khi.co.jp>
Subject: Re: kernel oops on the kernel with 'fix race conditions in SCSI/Block leading to oops' patch.
Date: Wed, 22 Jun 2011 08:42:39 +0900
Message-ID: <201106212342.AA00355@h01364.tech.khi.co.jp>
References: <201106161207.p5GC7cX8003727@msag502.nifty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-c11.khi.co.jp ([210.159.10.171]:49784 "EHLO
	out-c11.khi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab1FVAA5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2011 20:00:57 -0400
Received: from mailhub2c.khi.co.jp
        by out-c11.khi.co.jp (8.13.8/8.13.8) with ESMTP id p5LNgO2T016094
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2011 08:42:24 +0900
Received: from mailhub2c.khi.co.jp
        by mailhub2c.khi.co.jp (8.13.8/8.13.8) with ESMTP id p5LNgOTA027057
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2011 08:42:24 +0900
Received: from vcheck04.khi.co.jp
        by mailhub2c.khi.co.jp (8.13.8/8.13.8) with ESMTP id p5LNgOCa027053
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2011 08:42:24 +0900
Received: from techserv.tech.khi.co.jp
	by vcheck04.khi.co.jp (8.13.8+Sun/8.13.8) with ESMTP id p5LNgOw2001662
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2011 08:42:24 +0900 (JST)
Received: from h01364.tech.khi.co.jp (h01364.tech.khi.co.jp [172.16.12.82])
	by techserv.tech.khi.co.jp (Postfix) with SMTP id 3D2091C33C1
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2011 08:42:04 +0900 (JST)
In-Reply-To: <201106161207.p5GC7cX8003727@msag502.nifty.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>I'm using kernel-2.6.33.7 and rt-patch(patch-2.6.33.7.2-rt30).
>My first problem is a very rare occurrence, the kernel stops during boot sequence.(the 
log at the bottom of this mail)
>
>I found a similar issue.
>
>https://bugzilla.kernel.org/show_bug.cgi?id=33802
>
>So I patched followings for work around boot time hung-up.
>
>https://patchwork.kernel.org/patch/705411/
>https://patchwork.kernel.org/patch/750832/
>
>After that, oops occurred insted of hung-up.
-- snip --
>(Sorry, I didn't log serial console. So I typed messages on the screen.)

I logged serial console and  got Oops messages.
Would you please give me some advice?

ttaka

---
scsi 2:0:0:0: Direct-Access     I-O DATA USB Flash Disk   4.90 PQ: 0 ANSI: 0 CCS
sd 2:0:0:0: [sda] 239872 512-byte logical blocks: (122 MB/117 MiB)
sd 2:0:0:0: Attached scsi generic sg0 type 0
BUG: unable to handle kernel NULL pointer dereference at 00000020
IP: [<c05acd6e>] elv_queue_empty+0x15/0x24
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: 
Modules linked in:

Pid: 8, comm: sirq-block/0 Not tainted 2.6.33.14-rt31 #4 GA8-IBLV/To be filled by O.E.M.
EIP: 0060:[<c05acd6e>] EFLAGS: 00010246 CPU: 0
EIP is at elv_queue_empty+0x15/0x24
EAX: d0891aa8 EBX: d0891aa8 ECX: 00000001 EDX: 00000000
ESI: dee77e00 EDI: ded2f838 EBP: df4b3e90 ESP: df4b3e90
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00000000
Process sirq-block/0 (pid: 8, ti=df4b2000 task=df4b1940 task.ti=df4b2000)
Stack:
 df4b3e9c c05b0dd4 d0891aa8 df4b3ea8 c05b0f52 ded2f800 df4b3ed8 c0656ea1
<0> df4b3ec4 c06531be ded2f814 d0891aa8 ded2f838 df4b3ec4 df4b3ec4 deda80d0
<0> dec93c80 d0891aa8 df4b3eec c06584f6 dec93c80 fffffffb dee9c238 df4b3f2c
Call Trace:
 [<c05b0dd4>] ? __blk_run_queue+0x24/0x111
 [<c05b0f52>] ? blk_run_queue+0x1d/0x2b
 [<c0656ea1>] ? scsi_run_queue+0x25a/0x2e8
 [<c06531be>] ? __scsi_put_command+0x5b/0x61
 [<c06584f6>] ? scsi_next_command+0x2d/0x39
 [<c06588b4>] ? scsi_io_completion+0x371/0x3b2
 [<c0653114>] ? scsi_finish_command+0x94/0x9a
 [<c06584c1>] ? scsi_softirq_done+0xd2/0xda
 [<c05b7231>] ? blk_done_softirq+0x55/0x62
 [<c0430e23>] ? run_ksoftirqd+0x12d/0x20a
 [<c0430cf6>] ? run_ksoftirqd+0x0/0x20a
 [<c0442951>] ? kthread+0x64/0x69
 [<c04428ed>] ? kthread+0x0/0x69
 [<c0402cfe>] ? kernel_thread_helper+0x6/0x10
Code: 39 f9 77 04 39 f2 76 09 8b 5b 04 85 db 75 d9 31 c0 5b 5e 5f 5d c3 55 89 e5 e8 ab 5f 
e5 ff 31 c9 39 00 8b 50 0c 75 0f 8b 12 b1 01 <8b> 52 20 85 d2 74 04 ff d2 89 c1 89 c8 5d 
c3 55 89 e5 e8 87 5f 
EIP: [<c05acd6e>] elv_queue_empty+0x15/0x24 SS:ESP 0068:df4b3e90
CR2: 0000000000000020
---[ end trace 70bcf2571826f3f9 ]---
NOHZ: local_softirq_pending 10
NOHZ: local_softirq_pending 10
NOHZ: local_softirq_pending 10
NOHZ: local_softirq_pending 10
NOHZ: local_softirq_pending 10
NOHZ: local_softirq_pending 10
NOHZ: local_softirq_pending 10
NOHZ: local_softirq_pending 10
NOHZ: local_softirq_pending 10
NOHZ: local_softirq_pending 10
[  OK  ]
Bringing up interface eth1:  [  OK  ]
Starting system logger: process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
[  OK  ]
Starting kernel logger: [  OK  ]
Starting sshd:BUG: unable to handle kernel paging request at f3e5e624
IP: [<c0447cc0>] sched_clock_cpu+0x55/0x126
*pde = 00000000 
Oops: 0000 [#2] PREEMPT SMP 
last sysfs file: 
Modules linked in: ipv6

Pid: 0, comm: swapper Tainted: G      D    2.6.33.14-rt31 #4 GA8-IBLV/To be filled by 
O.E.M.
EIP: 0060:[<c0447cc0>] EFLAGS: 00010002 CPU: 0
EIP is at sched_clock_cpu+0x55/0x126
EAX: 00000092 EBX: 00000000 ECX: 00000000 EDX: 0000cccc
ESI: cccccccc EDI: c0a4e000 EBP: c0a4debc ESP: c0a4de8c
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00000004
Process swapper (pid: 0, ti=c0a4c000 task=c0ac3660 task.ti=c0a4c000)
Stack:
 c0a4dea4 c0402d2b c0a4dedc 00000000 c0baab40 c08aa488 c0a4debc c041ef46
<0> c0a4dedc 0000001e df4b1940 c0a4e000 c0a4deec c0426b33 c0426ea8 c0430aec
<0> 00000000 c0465388 c0baab40 00000004 00000046 00000001 00000004 c0a4e000
Call Trace:
 [<c0402d2b>] ? ftrace_call+0x5/0x8
 [<c08aa488>] ? _raw_spin_lock+0x8/0x29
 [<c041ef46>] ? task_rq_lock+0x41/0x72
 [<c0426b33>] ? try_to_wake_up+0x37/0x334
 [<c0426ea8>] ? wake_up_process+0x3/0x18
 [<c0430aec>] ? wakeup_softirqd+0x2d/0x2f
 [<c0465388>] ? ftrace_list_func+0x18/0x28
 [<c0426ebb>] ? wake_up_process+0x16/0x18
 [<c0430aec>] ? wakeup_softirqd+0x2d/0x2f
 [<c0430b0f>] ? trigger_softirqs+0x21/0x2c
 [<c0431abb>] ? __do_softirq+0x1b8/0x1c0
 [<c0431ac7>] ? do_softirq+0x4/0x30
 [<c0431b79>] ? irq_exit+0x31/0x6e
 [<c0465388>] ? ftrace_list_func+0x18/0x28
 [<c0431aee>] ? do_softirq+0x2b/0x30
 [<c0431b79>] ? irq_exit+0x31/0x6e
 [<c04131ed>] ? smp_apic_timer_interrupt+0x74/0x82
 [<c08aac45>] ? apic_timer_interrupt+0x31/0x38
 [<c04076c6>] ? mwait_idle+0x9a/0xa0
 [<c0401518>] ? cpu_idle+0x6f/0x9e
 [<c087dce5>] ? rest_init+0x85/0x87
 [<c0b2d735>] ? start_kernel+0x314/0x319
 [<c0b2d092>] ? i386_start_kernel+0x92/0x99
Code: c6 05 c1 0c c0 c0 01 83 3d 04 b5 b2 c0 00 74 0a e8 a9 ee fb ff e9 d2 00 00 00 31 c9 
31 db 83 3d 08 b5 b2 c0 00 0f 84 c5 00 00 00 <8b> 14 b5 f4 b2 b2 c0 b8 80 b0 ba c0 01 c2 
89 55 ec 64 8b 15 64 
EIP: [<c0447cc0>] sched_clock_cpu+0x55/0x126 SS:ESP 0068:c0a4de8c
CR2: 00000000f3e5e624
---[ end trace 70bcf2571826f3fa ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Pid: 0, comm: swapper Tainted: G      D    2.6.33.14-rt31 #4
Call Trace:
 [<c08a8400>] ? printk+0x14/0x16
 [<c08a8348>] panic+0x48/0xec
 [<c042ee7c>] do_exit+0x61/0x5d0
 [<c08aa2b6>] ? rt_spin_unlock+0x9/0x43
 [<c042d7dd>] ? kmsg_dump+0xe2/0xed
 [<c08ab75c>] oops_end+0x7a/0x81
 [<c0418a2e>] no_context+0x113/0x11d
 [<c0418b27>] __bad_area_nosemaphore+0xef/0xf7
 [<c0418b41>] bad_area_nosemaphore+0x12/0x15
 [<c08acc53>] do_page_fault+0x1e7/0x359
 [<c08aa483>] ? _raw_spin_lock+0x3/0x29
 [<c08aa483>] ? _raw_spin_lock+0x3/0x29
 [<c08aca6c>] ? do_page_fault+0x0/0x359
 [<c08aaeaf>] error_code+0x73/0x78
 [<c08a007b>] ? niu_pci_init_one+0xf32/0x2a46
 [<c04100d8>] ? mtrr_write+0x6/0x1cd
 [<c0447cc0>] ? sched_clock_cpu+0x55/0x126
 [<c0402d2b>] ? ftrace_call+0x5/0x8
 [<c08aa488>] ? _raw_spin_lock+0x8/0x29
 [<c041ef46>] ? task_rq_lock+0x41/0x72
 [<c0426b33>] try_to_wake_up+0x37/0x334
 [<c0426ea8>] ? wake_up_process+0x3/0x18
 [<c0430aec>] ? wakeup_softirqd+0x2d/0x2f
 [<c0465388>] ? ftrace_list_func+0x18/0x28
 [<c0426ebb>] wake_up_process+0x16/0x18
 [<c0430aec>] wakeup_softirqd+0x2d/0x2f
 [<c0430b0f>] trigger_softirqs+0x21/0x2c
 [<c0431abb>] __do_softirq+0x1b8/0x1c0
 [<c0431ac7>] ? do_softirq+0x4/0x30
 [<c0431b79>] ? irq_exit+0x31/0x6e
 [<c0465388>] ? ftrace_list_func+0x18/0x28
 [<c0431aee>] do_softirq+0x2b/0x30
 [<c0431b79>] irq_exit+0x31/0x6e
 [<c04131ed>] smp_apic_timer_interrupt+0x74/0x82
 [<c08aac45>] apic_timer_interrupt+0x31/0x38
 [<c04076c6>] ? mwait_idle+0x9a/0xa0
 [<c0401518>] cpu_idle+0x6f/0x9e
 [<c087dce5>] rest_init+0x85/0x87
 [<c0b2d735>] start_kernel+0x314/0x319
 [<c0b2d092>] i386_start_kernel+0x92/0x99
---
