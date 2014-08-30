From: Milan Broz <gmazyland@gmail.com>
Subject: scsi_debug module deadlock on 3.17-rc2
Date: Sat, 30 Aug 2014 22:56:00 +0200
Message-ID: <54023A60.1090208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:50355 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaH3U4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Aug 2014 16:56:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi,

I am using scsi_debug in cryptsetup testsuite and with recent 3.17-rc kernel
it deadlocks on rmmod of scsi_debug module.

For me even this simple reproducer causes deadlock:
  modprobe scsi_debug dev_size_mb=16 sector_size=512 num_tgts=1
  DEV="/dev/"$(grep -l -e scsi_debug /sys/block/*/device/model | cut -f4 -d /)
  mkfs -t ext4 $DEV
  rmmod scsi_debug

(adding small delay before rmmod obviously helps here)

Bisect tracked it to commit
  commit cbf67842c3d9e7af8ccc031332b79e88d9cca592
  Author: Douglas Gilbert <dgilbert@interlog.com>
  Date:   Sat Jul 26 11:55:35 2014 -0400
  scsi_debug: support scsi-mq, queues and locks

I guess that with introducing mq the del_timer_sync() must not be called
with acquired queued_arr_lock.
(to me it looks like situation described in comment before
del_timer_sync() in kernel/time/timer.c...)

Here is the log (running on vmware VM and i686 arch):

[   67.916472] scsi_debug: host protection
[   67.916483] scsi host3: scsi_debug, version 1.84 [20140706], dev_size_mb=16, opts=0x0
[   67.917446] scsi 3:0:0:0: Direct-Access     Linux    scsi_debug       0184 PQ: 0 ANSI: 5
[   67.920539] sd 3:0:0:0: Attached scsi generic sg8 type 0
[   67.940542] sd 3:0:0:0: [sdh] 32768 512-byte logical blocks: (16.7 MB/16.0 MiB)
[   67.940548] sd 3:0:0:0: [sdh] 4096-byte physical blocks
[   67.950705] sd 3:0:0:0: [sdh] Write Protect is off
[   67.950715] sd 3:0:0:0: [sdh] Mode Sense: 73 00 10 08
[   67.970514] sd 3:0:0:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   68.040566]  sdh: unknown partition table
[   68.090618] sd 3:0:0:0: [sdh] Attached SCSI disk
[   68.799699]  sdh: unknown partition table
[   69.072314] 
[   69.072387] ======================================================
[   69.072433] [ INFO: possible circular locking dependency detected ]
[   69.072487] 3.17.0-rc2+ #80 Not tainted
[   69.072518] -------------------------------------------------------
[   69.072560] rmmod/2890 is trying to acquire lock:
[   69.072595]  ((sqcp->cmnd_timerp)){+.-...}, at: [<c10846c0>] del_timer_sync+0x0/0xb0
[   69.072704] 
[   69.072704] but task is already holding lock:
[   69.072743]  (queued_arr_lock){..-...}, at: [<e1271887>] stop_all_queued+0x17/0xc0 [scsi_debug]
[   69.072852] 
[   69.072852] which lock already depends on the new lock.
[   69.072852] 
[   69.072902] 
[   69.072902] the existing dependency chain (in reverse order) is:
[   69.072949] 
[   69.072949] -> #1 (queued_arr_lock){..-...}:
[   69.073045]        [<c1072689>] lock_acquire+0x59/0xa0
[   69.073114]        [<c1465cb1>] _raw_spin_lock_irqsave+0x31/0x70
[   69.073438]        [<e1271cf7>] sdebug_q_cmd_complete+0x27/0x190 [scsi_debug]
[   69.073515]        [<c108434b>] call_timer_fn+0x5b/0xd0
[   69.073581]        [<c10848d1>] run_timer_softirq+0x161/0x200
[   69.073649]        [<c103dbc9>] __do_softirq+0x119/0x230
[   69.073726]        [<c1003c77>] do_softirq_own_stack+0x27/0x30
[   69.073811]        [<c103de1e>] irq_exit+0x7e/0xa0
[   69.073889]        [<c102a893>] smp_apic_timer_interrupt+0x33/0x40
[   69.073969]        [<c14672ae>] apic_timer_interrupt+0x32/0x38
[   69.074254]        [<c100a529>] arch_cpu_idle+0x9/0x10
[   69.074318]        [<c10674ec>] cpu_startup_entry+0x22c/0x280
[   69.074381]        [<c145e1ec>] rest_init+0x9c/0xb0
[   69.074441]        [<c16799e0>] start_kernel+0x2e9/0x2ee
[   69.074504]        [<c16792ab>] i386_start_kernel+0x79/0x7d
[   69.074567] 
[   69.074567] -> #0 ((sqcp->cmnd_timerp)){+.-...}:
[   69.074794]        [<c1071b94>] __lock_acquire+0x16e4/0x1c30
[   69.074859]        [<c1072689>] lock_acquire+0x59/0xa0
[   69.074919]        [<c10846e9>] del_timer_sync+0x29/0xb0
[   69.074981]        [<e12718fa>] stop_all_queued+0x8a/0xc0 [scsi_debug]
[   69.075050]        [<e1276f85>] scsi_debug_exit+0x16/0xac [scsi_debug]
[   69.075117]        [<c109a7bd>] SyS_delete_module+0xfd/0x180
[   69.075181]        [<c1466b2e>] syscall_after_call+0x0/0x4
[   69.075243] 
[   69.075243] other info that might help us debug this:
[   69.075243] 
[   69.075321]  Possible unsafe locking scenario:
[   69.075321] 
[   69.075380]        CPU0                    CPU1
[   69.075424]        ----                    ----
[   69.075468]   lock(queued_arr_lock);
[   69.075534]                                lock((sqcp->cmnd_timerp));
[   69.075613]                                lock(queued_arr_lock);
[   69.075690]   lock((sqcp->cmnd_timerp));
[   69.075758] 
[   69.075758]  *** DEADLOCK ***
[   69.075758] 
[   69.075827] 1 lock held by rmmod/2890:
[   69.075867]  #0:  (queued_arr_lock){..-...}, at: [<e1271887>] stop_all_queued+0x17/0xc0 [scsi_debug]
[   69.076009] 
[   69.076009] stack backtrace:
[   69.076064] CPU: 1 PID: 2890 Comm: rmmod Not tainted 3.17.0-rc2+ #80
[   69.076117] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[   69.076200]  c1c93200 00000000 da25fe30 c146081f c1c93330 da25fe60 c145fbf6 c158bbfc
[   69.076375]  c158bb99 c158bb7c c158bb91 c158bb7c da25fe9c df319070 df319098 df319618
[   69.076550]  df3195f0 da25fecc c1071b94 df3195f0 c1c4a0b0 00000001 00000000 00000001
[   69.076724] Call Trace:
[   69.076760]  [<c146081f>] dump_stack+0x4b/0x75
[   69.076805]  [<c145fbf6>] print_circular_bug+0x22d/0x23a
[   69.076863]  [<c1071b94>] __lock_acquire+0x16e4/0x1c30
[   69.076922]  [<c1072689>] lock_acquire+0x59/0xa0
[   69.076968]  [<c10846c0>] ? try_to_del_timer_sync+0x60/0x60
[   69.077017]  [<c10846e9>] del_timer_sync+0x29/0xb0
[   69.077063]  [<c10846c0>] ? try_to_del_timer_sync+0x60/0x60
[   69.077113]  [<e12718fa>] stop_all_queued+0x8a/0xc0 [scsi_debug]
[   69.077166]  [<e1276f85>] scsi_debug_exit+0x16/0xac [scsi_debug]
[   69.077218]  [<c109a7bd>] SyS_delete_module+0xfd/0x180
[   69.077265]  [<c1466b61>] ? restore_all+0xf/0xf
[   69.077311]  [<c12893ff>] ? __this_cpu_preempt_check+0xf/0x20
[   69.077361]  [<c106eab9>] ? trace_hardirqs_on_caller+0xe9/0x220
[   69.077412]  [<c1466b2e>] syscall_call+0x7/0x7

Milan
