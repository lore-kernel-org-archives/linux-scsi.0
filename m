From: "George Spelvin" <linux@horizon.com>
Subject: [mptscsih] Watchdog detected hard LOCKUP on cpu 0
Date: 25 Nov 2013 02:48:49 -0500
Message-ID: <20131125074849.21605.qmail@science.horizon.com>
References: <20131014090818.28591.qmail@science.horizon.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:16751 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752089Ab3KYHsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2013 02:48:51 -0500
In-Reply-To: <20131014090818.28591.qmail@science.horizon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: DL-MPTFusionLinux@lsi.com, kashyap.desai@lsi.com, linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com
Cc: linux@horizon.com

I first reported this in mid-October, but I've been AFK for a month
and haven't done anything about it in that time.  Basically, sustained
linear reads from 6 (7200 RPM 2 TB) disks on a BR10i controller causes
a hard lockup.

Anyway, I recompiled with CONFIG_LOCKUP_DETECTOR, and it didn't take
long to capture this (hand-transcribed, but double-checked).  I omitted
most of the timestamps, as they're not very interesting, but I uncluded
a few at the end that had significant delays between them.

Does anyone have any ideas for where to start debugging this?

Thank you very much!

[  321.243221] ------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel.watchdog.c:245 watchdog_overflow_callback+0x9a/0xc0()
Watchdog detected hard LOCKUP on cpu 0
Modules linked in: twofish_generic twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common ecb cmac xcbc fuse
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.1-00045-g27b879d64d #306
Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./X79-UP4, BIOS F2 07/16/2012
 0000000000000009 ffff88043fc06c40 ffffffff815d0ee9 ffff88043fc06c88
 ffff88043fc06c78 ffffffff8104fef3 ffff88042d816800 0000000000000000
 ffff88043fc06da0 0000000000000000 ffff88043fc06ef8 ffff88043fc06cd8
Call Trace:
 <NMI>  [<ffffffff815d0ee9>] dump_stack+0x54/0x74
 [<ffffffff8104fef3>] warn_slowpath_common+0x73/0x90
 [<ffffffff8104ff57>] warn_slowpath_fmt+0x47/0x50
 [<ffffffff810bc990>] ? restart_watchdog_hrtimer+0x40/0x40
 [<ffffffff810bca2a>] watchdog_overflow_callback+0x9a/0xc0
 [<ffffffff810c924e>] __perf_event_overflow+0x8e/0x2c0
 [<ffffffff810c9c44>] perf_event_overflow+0x14/0x20
 [<ffffffff8101be36>] intel_pmu_handle_irq+0x1b6/0x390
 [<ffffffff810150cb>] perf_event_nmi_handler+0x2b/0x50
 [<ffffffff81006857>] nmi_handle.isra.3+0x87/0x140
 [<ffffffff810069e0>] do_nmi+0xd0/0x340
 [<ffffffff815d9ab7>] end_repeat_nmi+0x1e/0x2e
 [<ffffffff815d9161>] ? _raw_spin_lock+0x11/0x40
 [<ffffffff815d9161>] ? _raw_spin_lock+0x11/0x40
 [<ffffffff815d9161>] ? _raw_spin_lock+0x11/0x40
 <<EOE>>  <IRQ>  [<ffffffff814dbc2a>] ? qi_submit_sync+0x28a/0x450
 [<ffffffff813b1e1d>] ? scsi_run_queue+0x11d/0x280
 [<ffffffff814dbeca>] qi_flush_iotlb+0x5a/0x60
 [<ffffffff814dce9a>] flush_unmaps+0x15a/0x170
 [<ffffffff814dceb0>] ? flush_unmaps+0x170/0x170
 [<ffffffff814dcec9>] flush_unmaps_timeout+0x19/0x30
 [<ffffffff8105a7c2>] call_timer_fn.isra.29+0x22/0x80
 [<ffffffff8105a9d9>] run_timer_softirq+0x1b9/0x290
 [<ffffffff8120cc00>] ? timerqueue_add+0x60/0xb0
 [<ffffffff810546c9>] __do_softirq+0xd9/0x1a0
 [<ffffffff815daf7c>] call_softirq+0x1c/0x30
 [<ffffffff81004d75>] do_softirq+0x35/0x70
 [<ffffffff810548e5>] irq_exit+0x95/0xa0
 [<ffffffff8102c08f>] smp_apic_timer_interrupt+0x3f/0x50
 [<ffffffff815da90a>] apic_timer_interrupt+0x6a/0x70
 <EOI>  [<ffffffff81070b52>] ? __hrtimer_start_range_ns+0x1f2/0x3b0
 [<ffffffff814ca1c7>] ? cpuidle_enter_state+0x47/0xc0
 [<ffffffff814ca1c3>] ? cpuidle_enter_state+0x43/0xc0
 [<ffffffff814ca2e9>] cpuidle_idle_call+0xa9/0x150
 [<ffffffff8100bed9>] arch_cpu_idle+0x9/0x20
 [<ffffffff8109619e>] cpu_startup_entry+0x7e/0x170
 [<ffffffff815c97eb>] rest_init+0x8b/0x90
 [<ffffffff81ab5d35>] start_kernel+0x2d9/0x2e4
 [<ffffffff81ab5865>] ? repair_env_string+0x5c/0x5c
 [<ffffffff81ab55a3>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81ab566c>] x86_64_start_kernel+0xc7/0xca
[  321.271385] ---[ end trace e25797a0833ba41e ]---
[  321.272175] perf samples too long (226338 > 2500), lowering kernel.perf_event_max_sample_rate to 50100
[  321.272986] INFO: NMI handler (perf_event_nmi_handler_ took too long to run: 29.766 msecs
[  329.848706] perf samples too long (224588 > 4990), lowering kernel.perf_event_max_sample_rate to 25200
[  338.553847] perf samples too long (222847 > 9920), lowering kernel.perf_event_max_sample_rate to 12600
[  339.993145] mptscsih: ioc0: attampting task abort! (sc=ffff880422009d00)
[  339.993331] sd 14:0:3:0: [sdf] CDB:
[  339.993603] Read(10): 28 00 01 fa 8d 00 00 04 00 00
