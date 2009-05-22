From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: kernel crash when BSG request timesout
Date: Fri, 22 May 2009 13:51:52 -0700
Message-ID: <8DE113F8-5448-44BD-9EFE-27701933C126@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:54107 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbZEVUvv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 16:51:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

	While testing the FC pass thru support I am constantly hitting a  
kernel crash when BSG request times out.
I took the latest FC pass thru patches from James Smart from
http://marc.info/?l=linux-scsi&m=123436574018579&w=2. and on top of it  
applied Boaz patches from
http://markmail.org/search/?q=FC+pass-through+support+&x=0&y=0#query:FC 
%20passthrough%20support%20from%3A%22Boaz%20Harrosh%22+page:2+mid:ke4lj4cg5ftc6nsc+state:results

Is there any additional patches I am missing?

Thanks,
Giridhar.M.B

[ 1464.584437] ------------[ cut here ]------------
[ 1464.584437] kernel BUG at block/blk-softirq.c:110!
[ 1464.584437] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 1464.584437] last sysfs file: /sys/devices/system/cpu/cpu3/cache/ 
index2/shared_cpu_map
[ 1464.584437] CPU 3
[ 1464.584437] Modules linked in: qla2xxx netconsole scsi_transport_fc  
[last unloaded: qla2xxx]
[ 1464.584437] Pid: 0, comm: swapper Not tainted 2.6.30-rc4 #3 X7DB8
[ 1464.584437] RIP: 0010:[<ffffffff80361112>]  [<ffffffff80361112>]  
__blk_complete_request+0xe8/0xec
[ 1464.584437] RSP: 0018:ffff880001063e10  EFLAGS: 00010046
[ 1464.584437] RAX: 0000000000000001 RBX: ffff88007ab93e80 RCX:  
ffffffff8070f680
[ 1464.584437] RDX: 0000000000008988 RSI: 0000000000000086 RDI:  
ffff88007ab93e80
[ 1464.584437] RBP: ffff880001063e30 R08: 00000000ffffffff R09:  
0000000000000003
[ 1464.584437] R10: 000000000000000a R11: 0000000000000000 R12:  
ffff88007a8b26c8
[ 1464.584437] R13: ffff88007a8b2a70 R14: ffff88007a8b26c8 R15:  
0000000000000286
[ 1464.584437] FS:  0000000000000000(0000) GS:ffff880001060000(0000)  
knlGS:0000000000000000
[ 1464.584437] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1464.584437] CR2: 00007f7943ffd4a8 CR3: 000000007fb1e000 CR4:  
00000000000006e0
[ 1464.584437] DR0: 0000000000000000 DR1: 0000000000000000 DR2:  
0000000000000000
[ 1464.584437] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:  
0000000000000400
[ 1464.584437] Process swapper (pid: 0, threadinfo ffff88007f9fe000,  
task ffff88007f9e1990)
[ 1464.584437] Stack:
[ 1464.584437]  ffff88007a8b2970 ffff88007ab93e80 0000000000000000  
ffff88007a8b2a70
[ 1464.584437]  ffff880001063e50 ffffffff80361299 ffff88007a8b26c8  
ffff88007a8b2930
[ 1464.584437]  ffff880001063e90 ffffffff803614e5 ffff88007f9b8000  
ffff88007a8b26c8
[ 1464.584437] Call Trace:
[ 1464.584437]  <IRQ> <0> [<ffffffff80361299>] blk_rq_timed_out 
+0x48/0x67
[ 1464.584437]  [<ffffffff803614e5>] blk_rq_timed_out_timer+0xd6/0x121
[ 1464.584437]  [<ffffffff8036140f>] ? blk_rq_timed_out_timer+0x0/0x121
[ 1464.584437]  [<ffffffff80240857>] run_timer_softirq+0x147/0x215
[ 1464.584437]  [<ffffffff8023b67b>] ? raise_softirq+0x59/0x68
[ 1464.584437]  [<ffffffff8023bf67>] __do_softirq+0xba/0x1a3
[ 1464.584437]  [<ffffffff8020c36c>] call_softirq+0x1c/0x30
[ 1464.584437]  [<ffffffff8020de61>] do_softirq+0x61/0xa0
[ 1464.584437]  [<ffffffff8023b8b1>] irq_exit+0x51/0x59
[ 1464.584437]  [<ffffffff8021d888>] smp_apic_timer_interrupt+0x6d/0x96
[ 1464.584437]  [<ffffffff8020bd83>] apic_timer_interrupt+0x13/0x20
[ 1464.584437]  <EOI> <0> [<ffffffff80212ac8>] ? mwait_idle+0xfe/0x10f
[ 1464.584437]  [<ffffffff80212abf>] ? mwait_idle+0xf5/0x10f
[ 1464.584437]  [<ffffffff8020a4ce>] ? cpu_idle+0x63/0x97
[ 1464.584437]  [<ffffffff8050d3c4>] ? start_secondary+0x183/0x1df
[ 1464.584437] Code: b7 0f 36 80 48 89 5b 28 66 c7 43 30 00 00 48 8d  
73 10 31 d2 e8 4c 8a ef ff eb b2 bf 04 00 00 00 e8 05 a3 ed ff 0f 1f  
40 00 eb a2 <0f> 0b eb fe 55 48 89 e5 48 8d 47 50 f0 0f ba 28 00 19 d2  
85 d2
[ 1464.584437] RIP  [<ffffffff80361112>] __blk_complete_request 
+0xe8/0xec
[ 1464.584437]  RSP <ffff880001063e10>
[ 1464.584437] ---[ end trace 7325773d478b6460 ]---
[ 1464.584437] Kernel panic - not syncing: Fatal exception in interrupt
[ 1464.584437] Pid: 0, comm: swapper Tainted: G      D    2.6.30-rc4 #3
[ 1464.584437] Call Trace:
[ 1464.584437]  <IRQ>  [<ffffffff8051098a>] panic+0x75/0x146
[ 1464.584437]  [<ffffffff8020f31b>] oops_end+0x8f/0x97
[ 1464.584437]  [<ffffffff8020f4ea>] die+0x46/0x60
[ 1464.584437]  [<ffffffff8020cb76>] do_trap+0x129/0x152
[ 1464.584437]  [<ffffffff8024f84d>] ? atomic_notifier_call_chain 
+0x15/0x17
[ 1464.584437]  [<ffffffff8020cf62>] do_invalid_op+0x90/0xa1
[ 1464.584437]  [<ffffffff80361112>] ? __blk_complete_request+0xe8/0xec
[ 1464.584437]  [<ffffffff80513acf>] ? trace_hardirqs_off_thunk+0x3a/ 
0x6c
[ 1464.584437]  [<ffffffff8020c005>] invalid_op+0x15/0x20
[ 1464.584437]  [<ffffffff80361112>] ? __blk_complete_request+0xe8/0xec
[ 1464.584437]  [<ffffffff80361299>] blk_rq_timed_out+0x48/0x67
[ 1464.584437]  [<ffffffff803614e5>] blk_rq_timed_out_timer+0xd6/0x121
[ 1464.584437]  [<ffffffff8036140f>] ? blk_rq_timed_out_timer+0x0/0x121
[ 1464.584437]  [<ffffffff80240857>] run_timer_softirq+0x147/0x215
[ 1464.584437]  [<ffffffff8023b67b>] ? raise_softirq+0x59/0x68
[ 1464.584437]  [<ffffffff8023bf67>] __do_softirq+0xba/0x1a3
[ 1464.584437]  [<ffffffff8020c36c>] call_softirq+0x1c/0x30
[ 1464.584437]  [<ffffffff8020de61>] do_softirq+0x61/0xa0
[ 1464.584437]  [<ffffffff8023b8b1>] irq_exit+0x51/0x59
[ 1464.584437]  [<ffffffff8021d888>] smp_apic_timer_interrupt+0x6d/0x96
[ 1464.584437]  [<ffffffff8020bd83>] apic_timer_interrupt+0x13/0x20
[ 1464.584437]  <EOI>  [<ffffffff80212ac8>] ? mwait_idle+0xfe/0x10f
[ 1464.584437]  [<ffffffff80212abf>] ? mwait_idle+0xf5/0x10f
[ 1464.584437]  [<ffffffff8020a4ce>] ? cpu_idle+0x63/0x97
[ 1464.584437]  [<ffffffff8050d3c4>] ? start_secondary+0x183/0x1df

