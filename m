From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Thu, 14 Feb 2008 15:55:49 -0800
Message-ID: <20080214235549.GA19591@tpepper-t42p.dolavim.us>
References: <20080213214324.GB18227@tpepper-t42p.dolavim.us> <20080214204838F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:55740 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863AbYBNXz5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 18:55:57 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1ENtp8A017509
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2008 18:55:51 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1ENtpg5211102
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2008 16:55:51 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1ENtoCm004159
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2008 16:55:50 -0700
Content-Disposition: inline
In-Reply-To: <20080214204838F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, tomof@acm.org

On Thu 14 Feb at 20:48:38 +0900 fujita.tomonori@lab.ntt.co.jp said:
> 
> I have a slight doubt on the breakup code though I'm not sure you hit
> the code. Reverting only the breakup part works? The patch is against
> 2.6.24.

I've tested this revert you posted.  Essentially the same trace is logged
(see below).  The machine doesn't die though.  But /proc/scsi/scsi doesn't
show the hardware and I am getting an additional trace dumped now (see
futher below).

Feb 14 16:04:13 ipstest kernel: [ 1046.531180] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 18 (level, low) -> IRQ 18
Feb 14 16:04:13 ipstest kernel: [ 1046.553420] scsi3 : IBM PCI ServeRAID 7.12.05  Build 761 <ServeRAID 4Mx>
Feb 14 16:04:13 ipstest kernel: [ 1046.554103] PGD 7cc1f067 PUD 7c4f6067 PMD 0
Feb 14 16:04:13 ipstest kernel: [ 1046.554348] CPU 0
Feb 14 16:04:13 ipstest kernel: [ 1046.554460] Modules linked in: ips aic94xx
Feb 14 16:04:13 ipstest kernel: [ 1046.554587] Pid: 4476, comm: scsi_scan_3 Not tainted 2.6.24-fujita-revert-breakup #1
Feb 14 16:04:13 ipstest kernel: [ 1046.554827] RIP: 0010:[check_addr+16/80]  [check_addr+16/80] check_addr+0x10/0x50
Feb 14 16:04:13 ipstest kernel: [ 1046.555079] RSP: 0018:ffff81007b0f78f0  EFLAGS: 00010082
Feb 14 16:04:13 ipstest kernel: [ 1046.555208] RAX: 0000000000000000 RBX: ffff81007b92a300 RCX: 0000000000000024
Feb 14 16:04:13 ipstest kernel: [ 1046.555350] RDX: 000000007b92a600 RSI: ffffffff807a7340 RDI: ffffffff806e7f43
Feb 14 16:04:13 ipstest kernel: [ 1046.555494] RBP: ffff81007b0f78f0 R08: 0000000000000500 R09: 0000000000000000
Feb 14 16:04:13 ipstest kernel: [ 1046.555632] R10: ffff81007c463b38 R11: 0000000000000060 R12: 0000000000000000
Feb 14 16:04:13 ipstest kernel: [ 1046.555784] R13: 0000000000000001 R14: ffffffff807a7340 R15: ffff81007c463a80
Feb 14 16:04:13 ipstest kernel: [ 1046.555924] FS:  0000000000000000(0000) GS:ffffffff807d6000(0000) knlGS:0000000000000000
Feb 14 16:04:13 ipstest kernel: [ 1046.556173] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 14 16:04:13 ipstest kernel: [ 1046.556306] CR2: 0000000000000000 CR3: 000000007cd02000 CR4: 00000000000006e0
Feb 14 16:04:13 ipstest kernel: [ 1046.556443] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 14 16:04:13 ipstest kernel: [ 1046.556582] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 14 16:04:13 ipstest kernel: [ 1046.556731] Process scsi_scan_3 (pid: 4476, threadinfo ffff81007b0f6000, task ffff81007b9295c0)
Feb 14 16:04:13 ipstest kernel: [ 1046.556972] Stack:  ffff81007b0f7920 ffffffff80213118 ffff81007c463a80 ffff81007b0fcf50
Feb 14 16:04:13 ipstest kernel: [ 1046.557221]  0000000000000000 ffff81007cd14450 ffff81007b0f7930 ffffffff8047a4c2
Feb 14 16:04:13 ipstest kernel: [ 1046.557463]  ffff81007b0f79b0 ffffffff8801c28e ffff81007c463ae8 000000017c463ae8
Feb 14 16:04:13 ipstest kernel: [ 1046.557603] Call Trace:
Feb 14 16:04:13 ipstest kernel: [ 1046.557830]  [nommu_map_sg+104/176] nommu_map_sg+0x68/0xb0
Feb 14 16:04:13 ipstest kernel: [ 1046.557949]  [scsi_dma_map+66/96] scsi_dma_map+0x42/0x60
Feb 14 16:04:13 ipstest kernel: [ 1046.558083]  [_end+124740294/2127405112] :ips:ips_next+0x33e/0xc10
Feb 14 16:04:13 ipstest kernel: [ 1046.558205]  [scsi_done+0/48] scsi_done+0x0/0x30
Feb 14 16:04:13 ipstest kernel: [ 1046.558332]  [_end+124752974/2127405112] :ips:ips_queue+0x106/0x1f0
Feb 14 16:04:13 ipstest kernel: [ 1046.558459]  [scsi_dispatch_cmd+453/736] scsi_dispatch_cmd+0x1c5/0x2e0
Feb 14 16:04:13 ipstest kernel: [ 1046.558589]  [scsi_request_fn+491/976] scsi_request_fn+0x1eb/0x3d0
Feb 14 16:04:13 ipstest kernel: [ 1046.558725]  [__generic_unplug_device+37/48] __generic_unplug_device+0x25/0x30
Feb 14 16:04:13 ipstest kernel: [ 1046.558851]  [blk_execute_rq_nowait+99/176] blk_execute_rq_nowait+0x63/0xb0
Feb 14 16:04:13 ipstest kernel: [ 1046.558982]  [blk_execute_rq+122/224] blk_execute_rq+0x7a/0xe0
Feb 14 16:04:13 ipstest kernel: [ 1046.559110]  [scsi_execute+240/288] scsi_execute+0xf0/0x120
Feb 14 16:04:13 ipstest kernel: [ 1046.559237]  [scsi_execute_req+134/240] scsi_execute_req+0x86/0xf0
Feb 14 16:04:13 ipstest kernel: [ 1046.559366]  [scsi_probe_and_add_lun+594/3472] scsi_probe_and_add_lun+0x252/0xd90
Feb 14 16:04:13 ipstest kernel: [ 1046.559501]  [sas_expander_match+27/160] sas_expander_match+0x1b/0xa0
Feb 14 16:04:13 ipstest kernel: [ 1046.559633]  [get_device+23/32] get_device+0x17/0x20
Feb 14 16:04:13 ipstest kernel: [ 1046.559755]  [__scsi_scan_target+220/1680] __scsi_scan_target+0xdc/0x690
Feb 14 16:04:13 ipstest kernel: [ 1046.559887]  [enqueue_task_fair+32/64] enqueue_task_fair+0x20/0x40
Feb 14 16:04:13 ipstest kernel: [ 1046.560019]  [enqueue_task+19/48] enqueue_task+0x13/0x30
Feb 14 16:04:13 ipstest kernel: [ 1046.560141]  [update_curr+101/192] update_curr+0x65/0xc0
Feb 14 16:04:13 ipstest kernel: [ 1046.560268]  [scsi_scan_channel+139/160] scsi_scan_channel+0x8b/0xa0
Feb 14 16:04:13 ipstest kernel: [ 1046.560397]  [scsi_scan_host_selected+158/352] scsi_scan_host_selected+0x9e/0x160
Feb 14 16:04:13 ipstest kernel: [ 1046.560532]  [thread_return+61/1307] thread_return+0x3d/0x51b
Feb 14 16:04:13 ipstest kernel: [ 1046.560657]  [do_scan_async+0/384] do_scan_async+0x0/0x180
Feb 14 16:04:13 ipstest kernel: [ 1046.560784]  [do_scsi_scan_host+126/128] do_scsi_scan_host+0x7e/0x80
Feb 14 16:04:13 ipstest kernel: [ 1046.560913]  [do_scan_async+29/384] do_scan_async+0x1d/0x180
Feb 14 16:04:13 ipstest kernel: [ 1046.561041]  [do_scan_async+0/384] do_scan_async+0x0/0x180
Feb 14 16:04:13 ipstest kernel: [ 1046.561172]  [kthread+77/128] kthread+0x4d/0x80
Feb 14 16:04:13 ipstest kernel: [ 1046.561294]  [child_rip+10/18] child_rip+0xa/0x12
Feb 14 16:04:13 ipstest kernel: [ 1046.561417]  [kthread+0/128] kthread+0x0/0x80
Feb 14 16:04:13 ipstest kernel: [ 1046.561542]  [child_rip+0/18] child_rip+0x0/0x12
Feb 14 16:04:13 ipstest kernel: [ 1046.561666]
Feb 14 16:04:13 ipstest kernel: [ 1046.561772]
Feb 14 16:04:13 ipstest kernel: [ 1046.561773] Code: 4c 8b 00 48 8d 04 0a 4c 39 c0 76 2b b8 fe ff ff ff 31 f6 49
Feb 14 16:04:13 ipstest kernel: [ 1046.562268]  RSP <ffff81007b0f78f0>
Feb 14 16:04:13 ipstest kernel: [ 1046.562853] ---[ end trace 3d5dd58222a8e80a ]---
Feb 14 16:04:28 ipstest kernel: [ 1061.857443] CPU 0:
Feb 14 16:04:28 ipstest kernel: [ 1061.857673] Modules linked in: ips aic94xx
Feb 14 16:04:28 ipstest kernel: [ 1061.857996] Pid: 0, comm: swapper Tainted: G      D 2.6.24-fujita-revert-breakup #1
Feb 14 16:04:28 ipstest kernel: [ 1061.858291] RIP: 0010:[_spin_lock_irqsave+22/48]  [_spin_lock_irqsave+22/48] _spin_lock_irqsave+0x16/0x30
Feb 14 16:04:28 ipstest kernel: [ 1061.858647] RSP: 0018:ffffffff8087fe60  EFLAGS: 00000286
Feb 14 16:04:28 ipstest kernel: [ 1061.858825] RAX: 0000000000000282 RBX: ffffffff8087fe60 RCX: ffff81007c463ae8
Feb 14 16:04:28 ipstest kernel: [ 1061.859012] RDX: ffff81007cd14000 RSI: 0000000000000001 RDI: ffff81007cd14050
Feb 14 16:04:28 ipstest kernel: [ 1061.859198] RBP: ffffffff8087fde0 R08: 000000000213c81f R09: 0000000000000010
Feb 14 16:04:28 ipstest kernel: [ 1061.859385] R10: 0000000000000005 R11: 0000000000000246 R12: ffffffff8020ced6
Feb 14 16:04:28 ipstest kernel: [ 1061.859572] R13: ffffffff8087fde0 R14: ffff81007c463a80 R15: ffff81007cd14000
Feb 14 16:04:28 ipstest kernel: [ 1061.859763] FS:  0000000000000000(0000) GS:ffffffff807d6000(0000) knlGS:0000000000000000
Feb 14 16:04:28 ipstest kernel: [ 1061.860058] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 14 16:04:28 ipstest kernel: [ 1061.860240] CR2: 0000000000611ec0 CR3: 000000007c466000 CR4: 00000000000006e0
Feb 14 16:04:28 ipstest kernel: [ 1061.860425] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 14 16:04:28 ipstest kernel: [ 1061.860613] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 14 16:04:28 ipstest kernel: [ 1061.860821]
Feb 14 16:04:28 ipstest kernel: [ 1061.860822] Call Trace:
Feb 14 16:04:28 ipstest kernel: [ 1061.861141]  <IRQ>  [scsi_eh_scmd_add+62/208] scsi_eh_scmd_add+0x3e/0xd0
Feb 14 16:04:28 ipstest kernel: [ 1061.861390]  [scsi_times_out+0/192] scsi_times_out+0x0/0xc0
Feb 14 16:04:28 ipstest kernel: [ 1061.861573]  [scsi_times_out+79/192] scsi_times_out+0x4f/0xc0
Feb 14 16:04:28 ipstest kernel: [ 1061.861758]  [run_timer_softirq+359/464] run_timer_softirq+0x167/0x1d0
Feb 14 16:04:28 ipstest kernel: [ 1061.861942]  [__do_softirq+116/240] __do_softirq+0x74/0xf0
Feb 14 16:04:28 ipstest kernel: [ 1061.862129]  [profile_tick+94/160] profile_tick+0x5e/0xa0
Feb 14 16:04:28 ipstest kernel: [ 1061.862313]  [call_softirq+28/48] call_softirq+0x1c/0x30
Feb 14 16:04:28 ipstest kernel: [ 1061.862495]  [do_softirq+61/144] do_softirq+0x3d/0x90
Feb 14 16:04:28 ipstest kernel: [ 1061.862676]  [irq_exit+69/80] irq_exit+0x45/0x50
Feb 14 16:04:28 ipstest kernel: [ 1061.862857]  [smp_apic_timer_interrupt+74/112] smp_apic_timer_interrupt+0x4a/0x70
Feb 14 16:04:28 ipstest kernel: [ 1061.863041]  [mwait_idle+0/80] mwait_idle+0x0/0x50
Feb 14 16:04:28 ipstest kernel: [ 1061.863223]  [apic_timer_interrupt+102/112] apic_timer_interrupt+0x66/0x70
Feb 14 16:04:28 ipstest kernel: [ 1061.863403]  <EOI>  [mwait_idle+70/80] mwait_idle+0x46/0x50
Feb 14 16:04:28 ipstest kernel: [ 1061.863677]  [enter_idle+34/48] enter_idle+0x22/0x30
Feb 14 16:04:28 ipstest kernel: [ 1061.863857]  [cpu_idle+115/160] cpu_idle+0x73/0xa0
Feb 14 16:04:28 ipstest kernel: [ 1061.864039]  [rest_init+90/96] rest_init+0x5a/0x60
Feb 14 16:04:28 ipstest kernel: [ 1061.864225]  [start_kernel+618/752] start_kernel+0x26a/0x2f0
Feb 14 16:04:28 ipstest kernel: [ 1061.864406]  [x86_64_start_kernel+298/320] _sinittext+0x12a/0x140
Feb 14 16:04:28 ipstest kernel: [ 1061.864585]


That second trace then is repeatedly dumping every 12seconds without end.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
