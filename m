From: textshell-dOFHIR@neutronstar.dyndns.org
Subject: Regression: hang while burning DVD in scsi_init_sgtable
Date: Sun, 25 Apr 2010 19:56:39 +0200
Message-ID: <20100425175639.GA31060@neutronstar.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

After upgradeing from 2.6.31 to 2.6.33.2 buring a DVD with growisofs
occasionally looks up in the kernel. 
The DVD drive is connected via IDE to an ICH7 IDE controller(using ATA_PIIX
driver). 

i usually burn DVDs with
growisofs -speed 4 -Z /dev/sr0 -dvd-video -udf .
and sometimes it does work with just outputting:

2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current] 
2010-04-11T15:22:14+02:00 eclipse alert Info fld=0x0
2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Add. Sense: Logical block address out of range
2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
2010-04-11T15:22:14+02:00 eclipse err end_request: I/O error, dev sr0, sector 0
2010-04-11T15:22:14+02:00 eclipse err Buffer I/O error on device sr0, logical block 0
2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current] 
2010-04-11T15:22:14+02:00 eclipse alert Info fld=0x0
2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Add. Sense: Logical block address out of range
2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
2010-04-11T15:22:14+02:00 eclipse err end_request: I/O error, dev sr0, sector 0
2010-04-11T15:22:14+02:00 eclipse err Buffer I/O error on device sr0, logical block 0

But the DVD gets written properly, so i don't really care, although it
looks like something might be working here already.
Anyway now for the second time it didn't output these messages, but instead
just hangs in the kernel.
The other processes keep running but the growisofs process is hung in the
kernel. ctrl-C or even killing with SIGKILL doesn't work.
according to /proc the task is in state "D (disk sleep)" (at the time of
writing this email).

a bit later the kernel logs this:

2010-04-22T23:50:00+02:00 eclipse err INFO: task growisofs:23916 blocked for more than 120 seconds.
2010-04-22T23:50:00+02:00 eclipse err "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2010-04-22T23:50:00+02:00 eclipse info growisofs     D ffff8800a96ee3c0     0 23916  23913 0x00000000
2010-04-22T23:50:00+02:00 eclipse alert ffff8800b7845858 0000000000000086 0000007fcf195000 ffff8800aa14f058
2010-04-22T23:50:00+02:00 eclipse alert 000000000000ddc8 ffff8800b7845fd8 0000000000012400 0000000000012400
2010-04-22T23:50:00+02:00 eclipse alert ffff8800b78457c8 ffffffff811ea32c ffff88000181a1c0 ffff88009e829b00
2010-04-22T23:50:00+02:00 eclipse alert Call Trace:
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff811ea32c>] ? scsi_init_sgtable+0x83/0x8a
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff811ea72c>] ? scsi_setup_blk_pc_cmnd+0x99/0x115
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d1dfe>] schedule_timeout+0x26/0x1c9
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8115d60e>] ? kobject_put+0x47/0x4b
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d38c4>] ? _raw_spin_lock_irq+0x17/0x2f
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d0f3c>] wait_for_common+0xc2/0x138
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8102f944>] ? default_wake_function+0x0/0xf
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8114d751>] ? __generic_unplug_device+0x2d/0x31
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d103c>] wait_for_completion+0x18/0x1a
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8115105a>] blk_execute_rq+0x92/0xb0
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81150bbb>] ? blk_rq_append_bio+0x19/0x46
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81150e60>] ? blk_rq_map_user+0x160/0x204
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8113a233>] ? security_capable+0x27/0x29
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff811542ac>] sg_io+0x273/0x385
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81154896>] scsi_cmd_ioctl+0x1e2/0x448
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8104bfeb>] ? sched_clock_cpu+0xc6/0xd4
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8102574e>] ? cpuacct_charge+0x57/0x5f
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8121412a>] cdrom_ioctl+0x30/0xe01
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81027e0d>] ? enqueue_entity+0x125/0x12d
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81024c00>] ? wakeup_preempt_entity+0x9d/0xab
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81026c61>] ? check_preempt_wakeup+0x1ae/0x23d
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff811f398f>] sr_block_ioctl+0x4b/0x82
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8115229d>] __blkdev_driver_ioctl+0x75/0x9d
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81152b31>] blkdev_ioctl+0x86c/0x8a7
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d364a>] ? _raw_spin_unlock+0x10/0x29
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81055dcd>] ? do_futex+0xc2/0x92a
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d38f4>] ? _raw_spin_lock_irqsave+0x18/0x34
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d3621>] ? _raw_spin_unlock_irqrestore+0x12/0x2b
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810474c7>] ? remove_wait_queue+0x48/0x4d
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d3621>] ? _raw_spin_unlock_irqrestore+0x12/0x2b
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810c8ef7>] block_ioctl+0x38/0x3c
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810b09f4>] vfs_ioctl+0x2a/0x9e
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810b0f2c>] do_vfs_ioctl+0x449/0x486
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810a4ac9>] ? fget_light+0xa8/0xc0
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81056743>] ? sys_futex+0x10e/0x12c
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810b0fbe>] sys_ioctl+0x55/0x77
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810a434b>] ? sys_write+0x60/0x6e
2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b


later messages like this look quite alike. so it doesn't seem to make any progress.
the only difference is this
-info growisofs     D ffff8800a96ee3c0     0 23916  23913 0x00000000
+info growisofs     D ffff8800a96ee3c0     0 23916  23913 0x00000004



after growisofs is hung in the kernel any attempt to access the sr0 device
(like trying to unlock the device tray) results in the process also hanging
like this: 
2010-04-25T15:36:00+02:00 eclipse err INFO: task hdparm:18123 blocked for more than 120 seconds.
2010-04-25T15:36:00+02:00 eclipse err "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2010-04-25T15:36:00+02:00 eclipse info hdparm        D ffff880001612400     0 18123  25879 0x00000004
2010-04-25T15:36:00+02:00 eclipse alert ffff8800bd94b858 0000000000000082 00ff880000000000 0000000000000002
2010-04-25T15:36:00+02:00 eclipse alert 000000000000ddc8 ffff8800bd94bfd8 0000000000012400 0000000000012400
2010-04-25T15:36:00+02:00 eclipse alert dead000000200200 ffffffff8114d73e ffff88009fe29440 ffffffff81400020
2010-04-25T15:36:00+02:00 eclipse alert Call Trace:
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8114d73e>] ? __generic_unplug_device+0x1a/0x31
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff812d1dfe>] schedule_timeout+0x26/0x1c9
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff811e9fba>] ? scsi_request_fn+0x385/0x43e
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff812d0f3c>] wait_for_common+0xc2/0x138
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8102f944>] ? default_wake_function+0x0/0xf
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8114d73e>] ? __generic_unplug_device+0x1a/0x31
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff812d103c>] wait_for_completion+0x18/0x1a
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8115105a>] blk_execute_rq+0x92/0xb0
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8113a233>] ? security_capable+0x27/0x29
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff811542ac>] sg_io+0x273/0x385
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff81154896>] scsi_cmd_ioctl+0x1e2/0x448
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff81077866>] ? find_get_page+0x88/0x9f
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8121412a>] cdrom_ioctl+0x30/0xe01
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8104bec1>] ? sched_clock_local+0x1c/0x80
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8104bfeb>] ? sched_clock_cpu+0xc6/0xd4
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff812d3621>] ? _raw_spin_unlock_irqrestore+0x12/0x2b
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff811f398f>] sr_block_ioctl+0x4b/0x82
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8115229d>] __blkdev_driver_ioctl+0x75/0x9d
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff81152b31>] blkdev_ioctl+0x86c/0x8a7
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff81077fd5>] ? filemap_fault+0x62/0x32b
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff81077aa6>] ? unlock_page+0x22/0x26
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff81089e09>] ? __do_fault+0x3c5/0x3fc
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff810c8ef7>] block_ioctl+0x38/0x3c
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff810b09f4>] vfs_ioctl+0x2a/0x9e
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff810b0f2c>] do_vfs_ioctl+0x449/0x486
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff81160b2b>] ? __up_read+0x9e/0xa7
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff8104aa63>] ? up_read+0x9/0xb
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff810b0fbe>] sys_ioctl+0x55/0x77
2010-04-25T15:36:00+02:00 eclipse alert [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b

About the system and additional things:

the system where this happens is a debian lenny with vanilla 2.6.33.2
kernel. I might as well note that the system was quite a bit swapping while
i burned the DVD, but it seems modern hardware and linux burn usable DVDs
even in such a situation, at least it used to work.

I'll also include the boot messages and .config. 

Is there anything else i should send to help narrowing down this problem?


also for reference the disassembly from my kernel build for
scsi_init_sgtable
(gdb) disassemble scsi_init_sgtable
Dump of assembler code for function scsi_init_sgtable:
0xffffffff811ea2a9 <scsi_init_sgtable+0>:       push   %rbp
0xffffffff811ea2aa <scsi_init_sgtable+1>:       mov    %edx,%ecx
0xffffffff811ea2ac <scsi_init_sgtable+3>:       mov    %rsp,%rbp
0xffffffff811ea2af <scsi_init_sgtable+6>:       push   %r12
0xffffffff811ea2b1 <scsi_init_sgtable+8>:       mov    %rdi,%r12
0xffffffff811ea2b4 <scsi_init_sgtable+11>:      push   %rbx
0xffffffff811ea2b5 <scsi_init_sgtable+12>:      mov    %rsi,%rbx
0xffffffff811ea2b8 <scsi_init_sgtable+15>:      movzwl 0xc0(%rdi),%esi
0xffffffff811ea2bf <scsi_init_sgtable+22>:      test   %esi,%esi
0xffffffff811ea2c1 <scsi_init_sgtable+24>:      jne    0xffffffff811ea2c7 <scsi_init_sgtable+30>
0xffffffff811ea2c3 <scsi_init_sgtable+26>:      ud2a   
0xffffffff811ea2c5 <scsi_init_sgtable+28>:      jmp    0xffffffff811ea2c5 <scsi_init_sgtable+28>
0xffffffff811ea2c7 <scsi_init_sgtable+30>:      mov    $0xffffffff811ea378,%r8
0xffffffff811ea2ce <scsi_init_sgtable+37>:      mov    $0x80,%edx
0xffffffff811ea2d3 <scsi_init_sgtable+42>:      mov    %rbx,%rdi
0xffffffff811ea2d6 <scsi_init_sgtable+45>:      callq  0xffffffff811665d9 <__sg_alloc_table>
0xffffffff811ea2db <scsi_init_sgtable+50>:      test   %eax,%eax
0xffffffff811ea2dd <scsi_init_sgtable+52>:      je     0xffffffff811ea310 <scsi_init_sgtable+103>
0xffffffff811ea2df <scsi_init_sgtable+54>:      mov    $0xffffffff811ea333,%rdx
0xffffffff811ea2e6 <scsi_init_sgtable+61>:      mov    $0x80,%esi
0xffffffff811ea2eb <scsi_init_sgtable+66>:      mov    %rbx,%rdi
0xffffffff811ea2ee <scsi_init_sgtable+69>:      callq  0xffffffff81166240 <__sg_free_table>
0xffffffff811ea2f3 <scsi_init_sgtable+74>:      mov    $0x2,%eax
0xffffffff811ea2f8 <scsi_init_sgtable+79>:      jmp    0xffffffff811ea30b <scsi_init_sgtable+98>
0xffffffff811ea2fa <scsi_init_sgtable+81>:      ud2a   
0xffffffff811ea2fc <scsi_init_sgtable+83>:      jmp    0xffffffff811ea2fc <scsi_init_sgtable+83>
0xffffffff811ea2fe <scsi_init_sgtable+85>:      mov    %eax,0x8(%rbx)
0xffffffff811ea301 <scsi_init_sgtable+88>:      mov    0x60(%r12),%eax
0xffffffff811ea306 <scsi_init_sgtable+93>:      mov    %eax,0x10(%rbx)
0xffffffff811ea309 <scsi_init_sgtable+96>:      xor    %eax,%eax
0xffffffff811ea30b <scsi_init_sgtable+98>:      pop    %rbx
0xffffffff811ea30c <scsi_init_sgtable+99>:      pop    %r12
0xffffffff811ea30e <scsi_init_sgtable+101>:     leaveq 
0xffffffff811ea30f <scsi_init_sgtable+102>:     retq   
0xffffffff811ea310 <scsi_init_sgtable+103>:     movq   $0x0,0xd0(%r12)
0xffffffff811ea31c <scsi_init_sgtable+115>:     mov    0x40(%r12),%rdi
0xffffffff811ea321 <scsi_init_sgtable+120>:     mov    (%rbx),%rdx
0xffffffff811ea324 <scsi_init_sgtable+123>:     mov    %r12,%rsi
0xffffffff811ea327 <scsi_init_sgtable+126>:     callq  0xffffffff81151826 <blk_rq_map_sg>
0xffffffff811ea32c <scsi_init_sgtable+131>:     cmp    0x8(%rbx),%eax
0xffffffff811ea32f <scsi_init_sgtable+134>:     jbe    0xffffffff811ea2fe <scsi_init_sgtable+85>
0xffffffff811ea331 <scsi_init_sgtable+136>:     jmp    0xffffffff811ea2fa <scsi_init_sgtable+81>
End of assembler dump.







2010-04-06T19:48:39+02:00 eclipse notice Linux version 2.6.33.2-mh1 (admin@eclipse.s) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP PREEMPT Tue Apr 6 19:23:59 CEST 2010
2010-04-06T19:48:39+02:00 eclipse info Command line: root=/dev/mapper/disk-main ro 
2010-04-06T19:48:39+02:00 eclipse info BIOS-provided physical RAM map:
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 0000000000100000 - 00000000cf7b0000 (usable)
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 00000000cf7b0000 - 00000000cf7c0000 (ACPI data)
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 00000000cf7c0000 - 00000000cf7f0000 (ACPI NVS)
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 00000000cf7f0000 - 00000000cf800000 (reserved)
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
2010-04-06T19:48:39+02:00 eclipse info BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
2010-04-06T19:48:39+02:00 eclipse info NX (Execute Disable) protection: active
2010-04-06T19:48:39+02:00 eclipse info DMI present.
2010-04-06T19:48:39+02:00 eclipse notice AMI BIOS detected: BIOS may corrupt low RAM, working around it.
2010-04-06T19:48:39+02:00 eclipse debug e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
2010-04-06T19:48:39+02:00 eclipse info No AGP bridge found
2010-04-06T19:48:39+02:00 eclipse info last_pfn = 0xcf7b0 max_arch_pfn = 0x400000000
2010-04-06T19:48:39+02:00 eclipse debug MTRR default type: uncachable
2010-04-06T19:48:39+02:00 eclipse debug MTRR fixed ranges enabled:
2010-04-06T19:48:39+02:00 eclipse debug 00000-9FFFF write-back
2010-04-06T19:48:39+02:00 eclipse debug A0000-DFFFF uncachable
2010-04-06T19:48:39+02:00 eclipse debug E0000-EFFFF write-through
2010-04-06T19:48:39+02:00 eclipse debug F0000-FFFFF write-protect
2010-04-06T19:48:39+02:00 eclipse debug MTRR variable ranges enabled:
2010-04-06T19:48:39+02:00 eclipse debug 0 base 000000000 mask F80000000 write-back
2010-04-06T19:48:39+02:00 eclipse debug 1 base 080000000 mask FC0000000 write-back
2010-04-06T19:48:39+02:00 eclipse debug 2 base 0C0000000 mask FF0000000 write-back
2010-04-06T19:48:39+02:00 eclipse debug 3 base 0CF800000 mask FFF800000 uncachable
2010-04-06T19:48:39+02:00 eclipse debug 4 disabled
2010-04-06T19:48:39+02:00 eclipse debug 5 disabled
2010-04-06T19:48:39+02:00 eclipse debug 6 disabled
2010-04-06T19:48:39+02:00 eclipse debug 7 disabled
2010-04-06T19:48:39+02:00 eclipse info x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
2010-04-06T19:48:39+02:00 eclipse debug original variable MTRRs
2010-04-06T19:48:39+02:00 eclipse debug reg 0, base: 0GB, range: 2GB, type WB
2010-04-06T19:48:39+02:00 eclipse debug reg 1, base: 2GB, range: 1GB, type WB
2010-04-06T19:48:39+02:00 eclipse debug reg 2, base: 3GB, range: 256MB, type WB
2010-04-06T19:48:39+02:00 eclipse debug reg 3, base: 3320MB, range: 8MB, type UC
2010-04-06T19:48:39+02:00 eclipse info total RAM covered: 3320M
2010-04-06T19:48:39+02:00 eclipse info Found optimal setting for mtrr clean up
2010-04-06T19:48:39+02:00 eclipse info gran_size: 64K 	chunk_size: 16M 	num_reg: 4  	lose cover RAM: 0G
2010-04-06T19:48:39+02:00 eclipse debug New variable MTRRs
2010-04-06T19:48:39+02:00 eclipse debug reg 0, base: 0GB, range: 2GB, type WB
2010-04-06T19:48:39+02:00 eclipse debug reg 1, base: 2GB, range: 1GB, type WB
2010-04-06T19:48:39+02:00 eclipse debug reg 2, base: 3GB, range: 256MB, type WB
2010-04-06T19:48:39+02:00 eclipse debug reg 3, base: 3320MB, range: 8MB, type UC
2010-04-06T19:48:39+02:00 eclipse debug initial memory mapped : 0 - 20000000
2010-04-06T19:48:39+02:00 eclipse info found SMP MP-table at [ffff8800000ff780] ff780
2010-04-06T19:48:39+02:00 eclipse info init_memory_mapping: 0000000000000000-00000000cf7b0000
2010-04-06T19:48:39+02:00 eclipse debug 0000000000 - 00cf600000 page 2M
2010-04-06T19:48:39+02:00 eclipse debug 00cf600000 - 00cf7b0000 page 4k
2010-04-06T19:48:39+02:00 eclipse debug kernel direct mapping tables up to cf7b0000 @ 12000-18000
2010-04-06T19:48:39+02:00 eclipse info RAMDISK: 37ba9000 - 37fef1a4
2010-04-06T19:48:39+02:00 eclipse warning ACPI: RSDP 00000000000f8c50 00014 (v00 ACPIAM)
2010-04-06T19:48:39+02:00 eclipse warning ACPI: RSDT 00000000cf7b0000 00034 (v01 A M I  OEMRSDT  09000612 MSFT 00000097)
2010-04-06T19:48:39+02:00 eclipse warning ACPI: FACP 00000000cf7b0200 00084 (v02 A M I  OEMFACP  09000612 MSFT 00000097)
2010-04-06T19:48:39+02:00 eclipse warning ACPI: DSDT 00000000cf7b0440 044A6 (v01  C94GD C94GD112 00000112 INTL 02002026)
2010-04-06T19:48:39+02:00 eclipse warning ACPI: FACS 00000000cf7c0000 00040
2010-04-06T19:48:39+02:00 eclipse warning ACPI: APIC 00000000cf7b0390 0006C (v01 A M I  OEMAPIC  09000612 MSFT 00000097)
2010-04-06T19:48:39+02:00 eclipse warning ACPI: MCFG 00000000cf7b0400 0003C (v01 A M I  OEMMCFG  09000612 MSFT 00000097)
2010-04-06T19:48:39+02:00 eclipse warning ACPI: OEMB 00000000cf7c0040 00046 (v01 A M I  AMI_OEM  09000612 MSFT 00000097)
2010-04-06T19:48:39+02:00 eclipse debug ACPI: Local APIC address 0xfee00000
2010-04-06T19:48:39+02:00 eclipse info (11 early reservations) ==> bootmem [0000000000 - 00cf7b0000]
2010-04-06T19:48:39+02:00 eclipse info #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
2010-04-06T19:48:39+02:00 eclipse info #1 [0001000000 - 000151bd64]    TEXT DATA BSS ==> [0001000000 - 000151bd64]
2010-04-06T19:48:39+02:00 eclipse info #2 [0037ba9000 - 0037fef1a4]          RAMDISK ==> [0037ba9000 - 0037fef1a4]
2010-04-06T19:48:39+02:00 eclipse info #3 [000151c000 - 000151c12b]              BRK ==> [000151c000 - 000151c12b]
2010-04-06T19:48:39+02:00 eclipse info #4 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
2010-04-06T19:48:39+02:00 eclipse info #5 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
2010-04-06T19:48:39+02:00 eclipse info #6 [000009fc00 - 00000fc640]    BIOS reserved ==> [000009fc00 - 00000fc640]
2010-04-06T19:48:39+02:00 eclipse info #7 [00000fc79c - 00000ff780]    BIOS reserved ==> [00000fc79c - 00000ff780]
2010-04-06T19:48:39+02:00 eclipse info #8 [00000fc640 - 00000fc79c]     MP-table mpc ==> [00000fc640 - 00000fc79c]
2010-04-06T19:48:39+02:00 eclipse info #9 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
2010-04-06T19:48:39+02:00 eclipse info #10 [0000012000 - 0000016000]          PGTABLE ==> [0000012000 - 0000016000]
2010-04-06T19:48:39+02:00 eclipse debug [ffffea0000000000-ffffea0002dfffff] PMD -> [ffff880001a00000-ffff8800047fffff] on node 0
2010-04-06T19:48:39+02:00 eclipse warning Zone PFN ranges:
2010-04-06T19:48:39+02:00 eclipse warning DMA      0x00000010 -> 0x00001000
2010-04-06T19:48:39+02:00 eclipse warning DMA32    0x00001000 -> 0x00100000
2010-04-06T19:48:39+02:00 eclipse warning Normal   0x00100000 -> 0x00100000
2010-04-06T19:48:39+02:00 eclipse warning Movable zone start PFN for each node
2010-04-06T19:48:39+02:00 eclipse warning early_node_map[2] active PFN ranges
2010-04-06T19:48:39+02:00 eclipse warning 0: 0x00000010 -> 0x0000009f
2010-04-06T19:48:39+02:00 eclipse warning 0: 0x00000100 -> 0x000cf7b0
2010-04-06T19:48:39+02:00 eclipse debug On node 0 totalpages: 849727
2010-04-06T19:48:39+02:00 eclipse debug DMA zone: 56 pages used for memmap
2010-04-06T19:48:39+02:00 eclipse debug DMA zone: 101 pages reserved
2010-04-06T19:48:39+02:00 eclipse debug DMA zone: 3826 pages, LIFO batch:0
2010-04-06T19:48:39+02:00 eclipse debug DMA32 zone: 11563 pages used for memmap
2010-04-06T19:48:39+02:00 eclipse debug DMA32 zone: 834181 pages, LIFO batch:31
2010-04-06T19:48:39+02:00 eclipse info ACPI: PM-Timer IO Port: 0x808
2010-04-06T19:48:39+02:00 eclipse debug ACPI: Local APIC address 0xfee00000
2010-04-06T19:48:39+02:00 eclipse info ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
2010-04-06T19:48:39+02:00 eclipse info ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
2010-04-06T19:48:39+02:00 eclipse info ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
2010-04-06T19:48:39+02:00 eclipse info ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
2010-04-06T19:48:39+02:00 eclipse info ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
2010-04-06T19:48:39+02:00 eclipse info IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
2010-04-06T19:48:39+02:00 eclipse info ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
2010-04-06T19:48:39+02:00 eclipse info ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
2010-04-06T19:48:39+02:00 eclipse debug ACPI: IRQ0 used by override.
2010-04-06T19:48:39+02:00 eclipse debug ACPI: IRQ2 used by override.
2010-04-06T19:48:39+02:00 eclipse debug ACPI: IRQ9 used by override.
2010-04-06T19:48:39+02:00 eclipse info Using ACPI (MADT) for SMP configuration information
2010-04-06T19:48:39+02:00 eclipse info SMP: Allowing 4 CPUs, 2 hotplug CPUs
2010-04-06T19:48:39+02:00 eclipse debug nr_irqs_gsi: 24
2010-04-06T19:48:39+02:00 eclipse info Allocating PCI resources starting at cf800000 (gap: cf800000:2f500000)
2010-04-06T19:48:39+02:00 eclipse info setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
2010-04-06T19:48:39+02:00 eclipse info PERCPU: Embedded 26 pages/cpu @ffff880001600000 s77144 r8192 d21160 u524288
2010-04-06T19:48:39+02:00 eclipse info pcpu-alloc: s77144 r8192 d21160 u524288 alloc=1*2097152
2010-04-06T19:48:39+02:00 eclipse info pcpu-alloc: [0] 0 1 2 3 
2010-04-06T19:48:39+02:00 eclipse warning Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 838007
2010-04-06T19:48:39+02:00 eclipse notice Kernel command line: root=/dev/mapper/disk-main ro 
2010-04-06T19:48:39+02:00 eclipse info PID hash table entries: 4096 (order: 3, 32768 bytes)
2010-04-06T19:48:39+02:00 eclipse info Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
2010-04-06T19:48:39+02:00 eclipse info Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
2010-04-06T19:48:39+02:00 eclipse info Checking aperture...
2010-04-06T19:48:39+02:00 eclipse info No AGP bridge found
2010-04-06T19:48:39+02:00 eclipse info Memory: 3334792k/3399360k available (2905k kernel code, 452k absent, 63472k reserved, 1457k data, 452k init)
2010-04-06T19:48:39+02:00 eclipse info SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
2010-04-06T19:48:39+02:00 eclipse info Experimental preemptable hierarchical RCU implementation.
2010-04-06T19:48:39+02:00 eclipse info NR_IRQS:384
2010-04-06T19:48:39+02:00 eclipse warning Console: colour VGA+ 80x25
2010-04-06T19:48:39+02:00 eclipse info console [tty0] enabled
2010-04-06T19:48:39+02:00 eclipse warning Fast TSC calibration using PIT
2010-04-06T19:48:39+02:00 eclipse warning Detected 1861.235 MHz processor.
2010-04-06T19:48:39+02:00 eclipse info Calibrating delay loop (skipped), value calculated using timer frequency.. 3723.57 BogoMIPS (lpj=6204116)
2010-04-06T19:48:39+02:00 eclipse info Security Framework initialized
2010-04-06T19:48:39+02:00 eclipse warning Mount-cache hash table entries: 256
2010-04-06T19:48:39+02:00 eclipse info Initializing cgroup subsys ns
2010-04-06T19:48:39+02:00 eclipse info Initializing cgroup subsys cpuacct
2010-04-06T19:48:39+02:00 eclipse info Initializing cgroup subsys devices
2010-04-06T19:48:39+02:00 eclipse info Initializing cgroup subsys freezer
2010-04-06T19:48:39+02:00 eclipse info Initializing cgroup subsys blkio
2010-04-06T19:48:39+02:00 eclipse info CPU: Physical Processor ID: 0
2010-04-06T19:48:39+02:00 eclipse info CPU: Processor Core ID: 0
2010-04-06T19:48:39+02:00 eclipse info mce: CPU supports 6 MCE banks
2010-04-06T19:48:39+02:00 eclipse info CPU0: Thermal monitoring enabled (TM2)
2010-04-06T19:48:39+02:00 eclipse info using mwait in idle threads.
2010-04-06T19:48:39+02:00 eclipse info Performance Events: Core2 events, Intel PMU driver.
2010-04-06T19:48:39+02:00 eclipse info ... version:                2
2010-04-06T19:48:39+02:00 eclipse info ... bit width:              40
2010-04-06T19:48:39+02:00 eclipse info ... generic registers:      2
2010-04-06T19:48:39+02:00 eclipse info ... value mask:             000000ffffffffff
2010-04-06T19:48:39+02:00 eclipse info ... max period:             000000007fffffff
2010-04-06T19:48:39+02:00 eclipse info ... fixed-purpose events:   3
2010-04-06T19:48:39+02:00 eclipse info ... event mask:             0000000700000003
2010-04-06T19:48:39+02:00 eclipse info Freeing SMP alternatives: 25k freed
2010-04-06T19:48:39+02:00 eclipse info ACPI: Core revision 20091214
2010-04-06T19:48:39+02:00 eclipse info Setting APIC routing to flat
2010-04-06T19:48:39+02:00 eclipse info ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
2010-04-06T19:48:39+02:00 eclipse info CPU0: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
2010-04-06T19:48:39+02:00 eclipse info Booting Node   0, Processors  #1
2010-04-06T19:48:39+02:00 eclipse info Brought up 2 CPUs
2010-04-06T19:48:39+02:00 eclipse info Total of 2 processors activated (7448.49 BogoMIPS).
2010-04-06T19:48:39+02:00 eclipse info NET: Registered protocol family 16
2010-04-06T19:48:39+02:00 eclipse info ACPI: bus type pci registered
2010-04-06T19:48:39+02:00 eclipse info PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
2010-04-06T19:48:39+02:00 eclipse info PCI: Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support
2010-04-06T19:48:39+02:00 eclipse info PCI: not using MMCONFIG
2010-04-06T19:48:39+02:00 eclipse info PCI: Using configuration type 1 for base access
2010-04-06T19:48:39+02:00 eclipse warning bio: create slab <bio-0> at 0
2010-04-06T19:48:39+02:00 eclipse debug ACPI: EC: Look up EC in DSDT
2010-04-06T19:48:39+02:00 eclipse warning ACPI: Executed 1 blocks of module-level executable AML code
2010-04-06T19:48:39+02:00 eclipse info ACPI: Interpreter enabled
2010-04-06T19:48:39+02:00 eclipse info ACPI: (supports S0 S5)
2010-04-06T19:48:39+02:00 eclipse info ACPI: Using IOAPIC for interrupt routing
2010-04-06T19:48:39+02:00 eclipse warning ACPI Warning: Incorrect checksum in table [OEMB] - C6, should be B7 (20091214/tbutils-314)
2010-04-06T19:48:39+02:00 eclipse info ACPI: No dock devices found.
2010-04-06T19:48:39+02:00 eclipse info ACPI: PCI Root Bridge [PCI0] (0000:00)
2010-04-06T19:48:39+02:00 eclipse info pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
2010-04-06T19:48:39+02:00 eclipse debug pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
2010-04-06T19:48:39+02:00 eclipse debug pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
2010-04-06T19:48:39+02:00 eclipse debug pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
2010-04-06T19:48:39+02:00 eclipse debug pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
2010-04-06T19:48:39+02:00 eclipse debug pci_root PNP0A08:00: host bridge window [mem 0xcf800000-0xffffffff] (ignored)
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:02.0: reg 10: [mem 0xfe900000-0xfe97ffff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:02.0: reg 14: [io  0xcc00-0xcc07]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:02.0: reg 1c: [mem 0xfe8c0000-0xfe8fffff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:02.1: reg 10: [mem 0xfe980000-0xfe9fffff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1b.0: reg 10: [mem 0xfe8b8000-0xfe8bbfff 64bit]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1b.0: PME# disabled
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1c.0: PME# disabled
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1c.1: PME# disabled
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1d.0: reg 20: [io  0xc400-0xc41f]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1d.1: reg 20: [io  0xc480-0xc49f]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1d.2: reg 20: [io  0xc800-0xc81f]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1d.3: reg 20: [io  0xc880-0xc89f]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1d.7: reg 10: [mem 0xfe8b7c00-0xfe8b7fff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1d.7: PME# disabled
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0280 (mask 00ff)
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.1: reg 18: [io  0x08f0-0x08f7]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.1: reg 1c: [io  0x08f8-0x08fb]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.2: reg 10: [io  0xc080-0xc087]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.2: reg 14: [io  0xc000-0xc003]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.2: reg 18: [io  0xbc00-0xbc07]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.2: reg 1c: [io  0xb880-0xb883]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.2: reg 20: [io  0xb800-0xb80f]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.2: PME# supported from D3hot
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.2: PME# disabled
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.0: PCI bridge to [bus 02-02]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1c.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:01:00.0: reg 10: [io  0xd800-0xd8ff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:01:00.0: reg 18: [mem 0xfeaff000-0xfeafffff 64bit]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:01:00.0: reg 30: [mem 0xfeac0000-0xfeadffff pref]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:01:00.0: supports D1 D2
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:01:00.0: PME# supported from D1 D2 D3hot D3cold
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:01:00.0: PME# disabled
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.1: PCI bridge to [bus 01-01]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1c.1:   bridge window [mem 0xfea00000-0xfeafffff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:01.0: reg 10: [io  0xe800-0xe8ff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:01.0: reg 14: [mem 0xfebfdc00-0xfebfdcff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:01.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:01.0: supports D1 D2
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:01.0: PME# supported from D1 D2 D3hot
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:01.0: PME# disabled
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:02.0: reg 10: [mem 0xfebfe000-0xfebfffff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:02.0: supports D1 D2
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:02.0: PME# supported from D0 D1 D2 D3hot D3cold
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:03:02.0: PME# disabled
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:00: on NUMA node 0
2010-04-06T19:48:39+02:00 eclipse debug ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
2010-04-06T19:48:39+02:00 eclipse debug ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
2010-04-06T19:48:39+02:00 eclipse debug ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
2010-04-06T19:48:39+02:00 eclipse debug ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
2010-04-06T19:48:39+02:00 eclipse info ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
2010-04-06T19:48:39+02:00 eclipse info ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
2010-04-06T19:48:39+02:00 eclipse info ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
2010-04-06T19:48:39+02:00 eclipse info ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
2010-04-06T19:48:39+02:00 eclipse info ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
2010-04-06T19:48:39+02:00 eclipse info ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
2010-04-06T19:48:39+02:00 eclipse info ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
2010-04-06T19:48:39+02:00 eclipse info ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 *15)
2010-04-06T19:48:39+02:00 eclipse info vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
2010-04-06T19:48:39+02:00 eclipse info vgaarb: loaded
2010-04-06T19:48:39+02:00 eclipse notice SCSI subsystem initialized
2010-04-06T19:48:39+02:00 eclipse debug libata version 3.00 loaded.
2010-04-06T19:48:39+02:00 eclipse info PCI: Using ACPI for IRQ routing
2010-04-06T19:48:39+02:00 eclipse debug PCI: pci_cache_line_size set to 64 bytes
2010-04-06T19:48:39+02:00 eclipse debug hpet clockevent registered
2010-04-06T19:48:39+02:00 eclipse info HPET: 3 timers in total, 0 timers will be used for per-cpu timer
2010-04-06T19:48:39+02:00 eclipse info hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
2010-04-06T19:48:39+02:00 eclipse info hpet0: 3 comparators, 64-bit 14.318180 MHz counter
2010-04-06T19:48:39+02:00 eclipse info Switching to clocksource tsc
2010-04-06T19:48:39+02:00 eclipse info pnp: PnP ACPI init
2010-04-06T19:48:39+02:00 eclipse info ACPI: bus type pnp registered
2010-04-06T19:48:39+02:00 eclipse info pnp: PnP ACPI: found 19 devices
2010-04-06T19:48:39+02:00 eclipse info ACPI: ACPI bus type pnp unregistered
2010-04-06T19:48:39+02:00 eclipse info system 00:01: [mem 0xfed13000-0xfed19fff] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:09: [io  0x04d0-0x04d1] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:09: [io  0x0800-0x087f] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:09: [io  0x0480-0x04bf] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:09: [io  0x0900-0x090f] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:09: [mem 0xfed20000-0xfed8ffff] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:0b: [mem 0xffc00000-0xfff7ffff] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:10: [io  0x0290-0x029f] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:11: [mem 0xe0000000-0xefffffff] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:12: [mem 0x00000000-0x0009ffff] could not be reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:12: [mem 0x000c0000-0x000cffff] has been reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:12: [mem 0x000e0000-0x000fffff] could not be reserved
2010-04-06T19:48:39+02:00 eclipse info system 00:12: [mem 0x00100000-0xcf7fffff] could not be reserved
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.0: BAR 8: assigned [mem 0xf0000000-0xf03fffff]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.1: BAR 9: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.0: PCI bridge to [bus 02-02]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf03fffff]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.1: PCI bridge to [bus 01-01]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.1:   bridge window [mem 0xfea00000-0xfeafffff]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1e.0: PCI bridge to [bus 03-03]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1e.0:   bridge window [mem pref disabled]
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.0: enabling device (0106 -> 0107)
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1c.0: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse info pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1c.1: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:1e.0: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:02: resource 1 [mem 0xf0000000-0xf03fffff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:01: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:03: resource 3 [io  0x0000-0xffff]
2010-04-06T19:48:39+02:00 eclipse debug pci_bus 0000:03: resource 4 [mem 0x00000000-0xffffffffffffffff]
2010-04-06T19:48:39+02:00 eclipse info NET: Registered protocol family 2
2010-04-06T19:48:39+02:00 eclipse info IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
2010-04-06T19:48:39+02:00 eclipse info TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
2010-04-06T19:48:39+02:00 eclipse info TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
2010-04-06T19:48:39+02:00 eclipse info TCP: Hash tables configured (established 262144 bind 65536)
2010-04-06T19:48:39+02:00 eclipse info TCP reno registered
2010-04-06T19:48:39+02:00 eclipse info UDP hash table entries: 2048 (order: 4, 65536 bytes)
2010-04-06T19:48:39+02:00 eclipse info UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
2010-04-06T19:48:39+02:00 eclipse info NET: Registered protocol family 1
2010-04-06T19:48:39+02:00 eclipse debug pci 0000:00:02.0: Boot video device
2010-04-06T19:48:39+02:00 eclipse debug PCI: CLS 32 bytes, default 64
2010-04-06T19:48:39+02:00 eclipse info Trying to unpack rootfs image as initramfs...
2010-04-06T19:48:39+02:00 eclipse info Freeing initrd memory: 4376k freed
2010-04-06T19:48:39+02:00 eclipse notice VFS: Disk quotas dquot_6.5.2
2010-04-06T19:48:39+02:00 eclipse warning Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
2010-04-06T19:48:39+02:00 eclipse info msgmni has been set to 6523
2010-04-06T19:48:39+02:00 eclipse info alg: No test for stdrng (krng)
2010-04-06T19:48:39+02:00 eclipse info Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
2010-04-06T19:48:39+02:00 eclipse info io scheduler noop registered
2010-04-06T19:48:39+02:00 eclipse info io scheduler deadline registered
2010-04-06T19:48:39+02:00 eclipse info io scheduler cfq registered (default)
2010-04-06T19:48:39+02:00 eclipse debug pcieport 0000:00:1c.0: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse debug pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
2010-04-06T19:48:39+02:00 eclipse debug pcieport 0000:00:1c.1: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse debug pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
2010-04-06T19:48:39+02:00 eclipse info Real Time Clock Driver v1.12b
2010-04-06T19:48:39+02:00 eclipse info Linux agpgart interface v0.103
2010-04-06T19:48:39+02:00 eclipse info agpgart-intel 0000:00:00.0: Intel 945G Chipset
2010-04-06T19:48:39+02:00 eclipse info agpgart-intel 0000:00:00.0: detected 7932K stolen memory
2010-04-06T19:48:39+02:00 eclipse info agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
2010-04-06T19:48:39+02:00 eclipse info Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
2010-04-06T19:48:39+02:00 eclipse info serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
2010-04-06T19:48:39+02:00 eclipse info serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
2010-04-06T19:48:39+02:00 eclipse info 00:0f: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
2010-04-06T19:48:39+02:00 eclipse info Floppy drive(s): fd0 is 1.44M
2010-04-06T19:48:39+02:00 eclipse info FDC 0 is a post-1991 82077
2010-04-06T19:48:39+02:00 eclipse info brd: module loaded
2010-04-06T19:48:39+02:00 eclipse info loop: module loaded
2010-04-06T19:48:39+02:00 eclipse debug ata_piix 0000:00:1f.1: version 2.13
2010-04-06T19:48:39+02:00 eclipse info ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
2010-04-06T19:48:39+02:00 eclipse debug ata_piix 0000:00:1f.1: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse info scsi0 : ata_piix
2010-04-06T19:48:39+02:00 eclipse info scsi1 : ata_piix
2010-04-06T19:48:39+02:00 eclipse info ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
2010-04-06T19:48:39+02:00 eclipse info ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
2010-04-06T19:48:39+02:00 eclipse info ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
2010-04-06T19:48:39+02:00 eclipse info ata_piix 0000:00:1f.2: MAP [
2010-04-06T19:48:39+02:00 eclipse debug ata2: port disabled. ignoring.
2010-04-06T19:48:39+02:00 eclipse warning P0 P2 P1 P3 ]
2010-04-06T19:48:39+02:00 eclipse debug ata_piix 0000:00:1f.2: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse info scsi2 : ata_piix
2010-04-06T19:48:39+02:00 eclipse info scsi3 : ata_piix
2010-04-06T19:48:39+02:00 eclipse info ata3: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xb800 irq 19
2010-04-06T19:48:39+02:00 eclipse info ata4: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb808 irq 19
2010-04-06T19:48:39+02:00 eclipse info r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
2010-04-06T19:48:39+02:00 eclipse info r8169 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
2010-04-06T19:48:39+02:00 eclipse debug r8169 0000:01:00.0: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse debug r8169 0000:01:00.0: irq 26 for MSI/MSI-X
2010-04-06T19:48:39+02:00 eclipse info eth0: RTL8168b/8111b at 0xffffc90000044000, 00:13:8f:e8:4c:b4, XID 18000000 IRQ 26
2010-04-06T19:48:39+02:00 eclipse info PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
2010-04-06T19:48:39+02:00 eclipse info serio: i8042 KBD port at 0x60,0x64 irq 1
2010-04-06T19:48:39+02:00 eclipse info serio: i8042 AUX port at 0x60,0x64 irq 12
2010-04-06T19:48:39+02:00 eclipse info mice: PS/2 mouse device common for all mice
2010-04-06T19:48:39+02:00 eclipse info cpuidle: using governor ladder
2010-04-06T19:48:39+02:00 eclipse info cpuidle: using governor menu
2010-04-06T19:48:39+02:00 eclipse info TCP cubic registered
2010-04-06T19:48:39+02:00 eclipse info Initializing XFRM netlink socket
2010-04-06T19:48:39+02:00 eclipse info NET: Registered protocol family 15
2010-04-06T19:48:39+02:00 eclipse warning registered taskstats version 1
2010-04-06T19:48:39+02:00 eclipse info input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
2010-04-06T19:48:39+02:00 eclipse info ata3.00: ATA-7: SAMSUNG HD401LJ, ZZ100-15, max UDMA7
2010-04-06T19:48:39+02:00 eclipse info ata3.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
2010-04-06T19:48:39+02:00 eclipse info ata3.01: ATA-7: SAMSUNG HD753LJ, 1AA01109, max UDMA7
2010-04-06T19:48:39+02:00 eclipse info ata3.01: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
2010-04-06T19:48:39+02:00 eclipse info ata3.00: configured for UDMA/133
2010-04-06T19:48:39+02:00 eclipse info ata3.01: configured for UDMA/133
2010-04-06T19:48:39+02:00 eclipse info ata1.00: ATA-6: ST3200822A, 3.01, max UDMA/100
2010-04-06T19:48:39+02:00 eclipse info ata1.00: 390721968 sectors, multi 16: LBA48 
2010-04-06T19:48:39+02:00 eclipse info ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-4163B, A100, max UDMA/33
2010-04-06T19:48:39+02:00 eclipse info input: PS2++ Logitech MX Mouse as /devices/platform/i8042/serio1/input/input1
2010-04-06T19:48:39+02:00 eclipse info ata1.00: configured for UDMA/100
2010-04-06T19:48:39+02:00 eclipse info ata1.01: configured for UDMA/33
2010-04-06T19:48:39+02:00 eclipse notice scsi 0:0:0:0: Direct-Access     ATA      ST3200822A       3.01 PQ: 0 ANSI: 5
2010-04-06T19:48:39+02:00 eclipse notice sd 0:0:0:0: [sda] 390721968 512-byte logical blocks: (200 GB/186 GiB)
2010-04-06T19:48:39+02:00 eclipse notice sd 0:0:0:0: [sda] Write Protect is off
2010-04-06T19:48:39+02:00 eclipse debug sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2010-04-06T19:48:39+02:00 eclipse notice scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-4163B A100 PQ: 0 ANSI: 5
2010-04-06T19:48:39+02:00 eclipse notice sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2010-04-06T19:48:39+02:00 eclipse info sda: sda1 sda2
2010-04-06T19:48:39+02:00 eclipse warning sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
2010-04-06T19:48:39+02:00 eclipse info Uniform CD-ROM driver Revision: 3.20
2010-04-06T19:48:39+02:00 eclipse notice sd 0:0:0:0: [sda] Attached SCSI disk
2010-04-06T19:48:39+02:00 eclipse debug sr 0:0:1:0: Attached scsi CD-ROM sr0
2010-04-06T19:48:39+02:00 eclipse notice scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD401LJ  ZZ10 PQ: 0 ANSI: 5
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:0:0: [sdb] 781422768 512-byte logical blocks: (400 GB/372 GiB)
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:0:0: [sdb] Write Protect is off
2010-04-06T19:48:39+02:00 eclipse debug sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
2010-04-06T19:48:39+02:00 eclipse notice scsi 2:0:1:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2010-04-06T19:48:39+02:00 eclipse info sdb: sdb1 sdb2
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:1:0: [sdc] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:1:0: [sdc] Write Protect is off
2010-04-06T19:48:39+02:00 eclipse warning sdb3 sdb4
2010-04-06T19:48:39+02:00 eclipse debug sd 2:0:1:0: [sdc] Mode Sense: 00 3a 00 00
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2010-04-06T19:48:39+02:00 eclipse info sdc: unknown partition table
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:0:0: [sdb] Attached SCSI disk
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:1:0: [sdc] Attached SCSI disk
2010-04-06T19:48:39+02:00 eclipse info Freeing unused kernel memory: 452k freed
2010-04-06T19:48:39+02:00 eclipse info 8139too Fast Ethernet driver 0.9.28
2010-04-06T19:48:39+02:00 eclipse info 8139too 0000:03:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
2010-04-06T19:48:39+02:00 eclipse info eth0: RealTek RTL8139 at 0xffffc90000062c00, 00:1d:0f:c1:d7:5c, IRQ 22
2010-04-06T19:48:39+02:00 eclipse info usbcore: registered new interface driver usbfs
2010-04-06T19:48:39+02:00 eclipse info usbcore: registered new interface driver hub
2010-04-06T19:48:39+02:00 eclipse info usbcore: registered new device driver usb
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd: USB Universal Host Controller Interface driver
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
2010-04-06T19:48:39+02:00 eclipse debug uhci_hcd 0000:00:1d.0: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.0: UHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000c400
2010-04-06T19:48:39+02:00 eclipse info usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
2010-04-06T19:48:39+02:00 eclipse info usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
2010-04-06T19:48:39+02:00 eclipse info usb usb1: Product: UHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info usb usb1: Manufacturer: Linux 2.6.33.2-mh1 uhci_hcd
2010-04-06T19:48:39+02:00 eclipse info usb usb1: SerialNumber: 0000:00:1d.0
2010-04-06T19:48:39+02:00 eclipse info hub 1-0:1.0: USB hub found
2010-04-06T19:48:39+02:00 eclipse info hub 1-0:1.0: 2 ports detected
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
2010-04-06T19:48:39+02:00 eclipse debug uhci_hcd 0000:00:1d.1: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.1: UHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000c480
2010-04-06T19:48:39+02:00 eclipse info usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
2010-04-06T19:48:39+02:00 eclipse info usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
2010-04-06T19:48:39+02:00 eclipse info usb usb2: Product: UHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info usb usb2: Manufacturer: Linux 2.6.33.2-mh1 uhci_hcd
2010-04-06T19:48:39+02:00 eclipse info usb usb2: SerialNumber: 0000:00:1d.1
2010-04-06T19:48:39+02:00 eclipse info hub 2-0:1.0: USB hub found
2010-04-06T19:48:39+02:00 eclipse info hub 2-0:1.0: 2 ports detected
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
2010-04-06T19:48:39+02:00 eclipse debug uhci_hcd 0000:00:1d.2: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.2: UHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c800
2010-04-06T19:48:39+02:00 eclipse info usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
2010-04-06T19:48:39+02:00 eclipse info usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
2010-04-06T19:48:39+02:00 eclipse info usb usb3: Product: UHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info usb usb3: Manufacturer: Linux 2.6.33.2-mh1 uhci_hcd
2010-04-06T19:48:39+02:00 eclipse info usb usb3: SerialNumber: 0000:00:1d.2
2010-04-06T19:48:39+02:00 eclipse info hub 3-0:1.0: USB hub found
2010-04-06T19:48:39+02:00 eclipse info hub 3-0:1.0: 2 ports detected
2010-04-06T19:48:39+02:00 eclipse info ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
2010-04-06T19:48:39+02:00 eclipse warning Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
2010-04-06T19:48:39+02:00 eclipse info ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
2010-04-06T19:48:39+02:00 eclipse debug ehci_hcd 0000:00:1d.7: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse info ehci_hcd 0000:00:1d.7: EHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
2010-04-06T19:48:39+02:00 eclipse info ehci_hcd 0000:00:1d.7: using broken periodic workaround
2010-04-06T19:48:39+02:00 eclipse info ehci_hcd 0000:00:1d.7: debug port 1
2010-04-06T19:48:39+02:00 eclipse debug ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
2010-04-06T19:48:39+02:00 eclipse info ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe8b7c00
2010-04-06T19:48:39+02:00 eclipse info ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
2010-04-06T19:48:39+02:00 eclipse info usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
2010-04-06T19:48:39+02:00 eclipse info usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
2010-04-06T19:48:39+02:00 eclipse info usb usb4: Product: EHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info usb usb4: Manufacturer: Linux 2.6.33.2-mh1 ehci_hcd
2010-04-06T19:48:39+02:00 eclipse info usb usb4: SerialNumber: 0000:00:1d.7
2010-04-06T19:48:39+02:00 eclipse info hub 4-0:1.0: USB hub found
2010-04-06T19:48:39+02:00 eclipse info hub 4-0:1.0: 8 ports detected
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
2010-04-06T19:48:39+02:00 eclipse debug uhci_hcd 0000:00:1d.3: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.3: UHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
2010-04-06T19:48:39+02:00 eclipse info uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000c880
2010-04-06T19:48:39+02:00 eclipse info usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
2010-04-06T19:48:39+02:00 eclipse info usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
2010-04-06T19:48:39+02:00 eclipse info usb usb5: Product: UHCI Host Controller
2010-04-06T19:48:39+02:00 eclipse info usb usb5: Manufacturer: Linux 2.6.33.2-mh1 uhci_hcd
2010-04-06T19:48:39+02:00 eclipse info usb usb5: SerialNumber: 0000:00:1d.3
2010-04-06T19:48:39+02:00 eclipse info hub 5-0:1.0: USB hub found
2010-04-06T19:48:39+02:00 eclipse info hub 5-0:1.0: 2 ports detected
2010-04-06T19:48:39+02:00 eclipse notice sd 0:0:0:0: Attached scsi generic sg0 type 0
2010-04-06T19:48:39+02:00 eclipse notice sr 0:0:1:0: Attached scsi generic sg1 type 5
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:0:0: Attached scsi generic sg2 type 0
2010-04-06T19:48:39+02:00 eclipse notice sd 2:0:1:0: Attached scsi generic sg3 type 0
2010-04-06T19:48:39+02:00 eclipse info udev: renamed network interface eth0 to eth1
2010-04-06T19:48:39+02:00 eclipse info md: linear personality registered for level -1
2010-04-06T19:48:39+02:00 eclipse info md: multipath personality registered for level -4
2010-04-06T19:48:39+02:00 eclipse info md: raid0 personality registered for level 0
2010-04-06T19:48:39+02:00 eclipse info md: raid1 personality registered for level 1
2010-04-06T19:48:39+02:00 eclipse info xor: automatically using best checksumming function: generic_sse
2010-04-06T19:48:39+02:00 eclipse info generic_sse:  6517.200 MB/sec
2010-04-06T19:48:39+02:00 eclipse info xor: using function: generic_sse (6517.200 MB/sec)
2010-04-06T19:48:39+02:00 eclipse warning raid6: int64x1   1691 MB/s
2010-04-06T19:48:39+02:00 eclipse info usb 1-2: new full speed USB device using uhci_hcd and address 2
2010-04-06T19:48:39+02:00 eclipse warning raid6: int64x2   2082 MB/s
2010-04-06T19:48:39+02:00 eclipse warning raid6: int64x4   1553 MB/s
2010-04-06T19:48:39+02:00 eclipse warning raid6: int64x8   1430 MB/s
2010-04-06T19:48:39+02:00 eclipse info usb 1-2: New USB device found, idVendor=0482, idProduct=0003
2010-04-06T19:48:39+02:00 eclipse info usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
2010-04-06T19:48:39+02:00 eclipse info usb 1-2: Product: Kyocera Mita FS-1010
2010-04-06T19:48:39+02:00 eclipse info usb 1-2: Manufacturer: Kyocera Mita
2010-04-06T19:48:39+02:00 eclipse info usb 1-2: SerialNumber: XAL3751311
2010-04-06T19:48:39+02:00 eclipse warning raid6: sse2x1    3134 MB/s
2010-04-06T19:48:39+02:00 eclipse warning raid6: sse2x2    3982 MB/s
2010-04-06T19:48:39+02:00 eclipse warning raid6: sse2x4    5566 MB/s
2010-04-06T19:48:39+02:00 eclipse warning raid6: using algorithm sse2x4 (5566 MB/s)
2010-04-06T19:48:39+02:00 eclipse info md: raid6 personality registered for level 6
2010-04-06T19:48:39+02:00 eclipse info md: raid5 personality registered for level 5
2010-04-06T19:48:39+02:00 eclipse info md: raid4 personality registered for level 4
2010-04-06T19:48:39+02:00 eclipse info md: raid10 personality registered for level 10
2010-04-06T19:48:39+02:00 eclipse info device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
2010-04-06T19:48:39+02:00 eclipse info kjournald starting.  Commit interval 5 seconds
2010-04-06T19:48:39+02:00 eclipse info EXT3-fs (dm-2): mounted filesystem with ordered data mode
2010-04-06T19:48:39+02:00 eclipse info udevd version 125 started
2010-04-06T19:48:39+02:00 eclipse warning ACPI Warning: 
2010-04-06T19:48:39+02:00 eclipse info input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
2010-04-06T19:48:39+02:00 eclipse info ACPI: Power Button [PWRB]
2010-04-06T19:48:39+02:00 eclipse warning Incorrect checksum in table [SSDT] - 0F, should be 16 (20091214/tbutils-314)
2010-04-06T19:48:39+02:00 eclipse warning ACPI: SSDT 00000000cf7b48f0 002E3 (v01    AMI   CPU1PM 00000001 INTL 20051117)
2010-04-06T19:48:39+02:00 eclipse info input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
2010-04-06T19:48:39+02:00 eclipse info ACPI: Power Button [PWRF]
2010-04-06T19:48:39+02:00 eclipse warning ACPI: SSDT 00000000cf7b4be0 002DA (v01    AMI   CPU2PM 00000001 INTL 20051117)
2010-04-06T19:48:39+02:00 eclipse notice intel_rng: FWH not detected
2010-04-06T19:48:39+02:00 eclipse info parport_pc 00:08: reported by Plug and Play ACPI
2010-04-06T19:48:39+02:00 eclipse info parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
2010-04-06T19:48:39+02:00 eclipse info input: PC Speaker as /devices/platform/pcspkr/input/input4
2010-04-06T19:48:39+02:00 eclipse info i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
2010-04-06T19:48:39+02:00 eclipse info usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x0482 pid 0x0003
2010-04-06T19:48:39+02:00 eclipse info usbcore: registered new interface driver usblp
2010-04-06T19:48:39+02:00 eclipse info Loaded prism54 driver, version 1.2
2010-04-06T19:48:39+02:00 eclipse info prism54 0000:03:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
2010-04-06T19:48:39+02:00 eclipse info NET: Registered protocol family 23
2010-04-06T19:48:39+02:00 eclipse info udev: renamed network interface eth0 to eth2
2010-04-06T19:48:39+02:00 eclipse info HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
2010-04-06T19:48:39+02:00 eclipse debug HDA Intel 0000:00:1b.0: irq 27 for MSI/MSI-X
2010-04-06T19:48:39+02:00 eclipse debug HDA Intel 0000:00:1b.0: setting latency timer to 64
2010-04-06T19:48:39+02:00 eclipse info hda_codec: ALC888: BIOS auto-probing.
2010-04-06T19:48:39+02:00 eclipse info input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
2010-04-06T19:48:39+02:00 eclipse info EXT3-fs (dm-2): using internal journal
2010-04-06T19:48:39+02:00 eclipse info fuse init (API version 7.13)
2010-04-06T19:48:39+02:00 eclipse info Initializing USB Mass Storage driver...
2010-04-06T19:48:39+02:00 eclipse info usbcore: registered new interface driver usb-storage
2010-04-06T19:48:39+02:00 eclipse info USB Mass Storage support registered.
2010-04-06T19:48:39+02:00 eclipse info ip6_tables: (C) 2000-2006 Netfilter Core Team
2010-04-06T19:48:39+02:00 eclipse info ip_tables: (C) 2000-2006 Netfilter Core Team
2010-04-06T19:48:39+02:00 eclipse info w83627ehf: Found W83627EHG chip at 0x290
2010-04-06T19:48:39+02:00 eclipse info NET: Registered protocol family 10
2010-04-06T19:48:39+02:00 eclipse info lo: Disabled Privacy Extensions
2010-04-06T19:48:39+02:00 eclipse alert nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
2010-04-06T19:48:39+02:00 eclipse warning CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
2010-04-06T19:48:39+02:00 eclipse warning nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
2010-04-06T19:48:39+02:00 eclipse warning sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
2010-04-06T19:48:39+02:00 eclipse info tun: Universal TUN/TAP device driver, 1.6
2010-04-06T19:48:39+02:00 eclipse info tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
2010-04-06T19:48:39+02:00 eclipse info tunoctet: Disabled Privacy Extensions
2010-04-06T19:48:39+02:00 eclipse info tunLocal: Disabled Privacy Extensions
2010-04-06T19:48:39+02:00 eclipse info kjournald starting.  Commit interval 5 seconds
2010-04-06T19:48:39+02:00 eclipse info EXT3-fs (sdb1): using internal journal
2010-04-06T19:48:39+02:00 eclipse info EXT3-fs (sdb1): mounted filesystem with ordered data mode
2010-04-06T19:48:39+02:00 eclipse info kjournald starting.  Commit interval 5 seconds
2010-04-06T19:48:39+02:00 eclipse info EXT3-fs (dm-1): using internal journal
2010-04-06T19:48:39+02:00 eclipse info EXT3-fs (dm-1): mounted filesystem with ordered data mode
2010-04-06T19:48:39+02:00 eclipse notice REISERFS (device sda2): found reiserfs format "3.6" with standard journal
2010-04-06T19:48:39+02:00 eclipse notice REISERFS (device sda2): using ordered data mode
2010-04-06T19:48:39+02:00 eclipse notice REISERFS (device sda2): journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
2010-04-06T19:48:39+02:00 eclipse notice REISERFS (device sda2): checking transaction log (sda2)
2010-04-06T19:48:39+02:00 eclipse notice REISERFS (device sda2): Using r5 hash to sort names
2010-04-06T19:48:39+02:00 eclipse info Adding 4194296k swap on /dev/mapper/disk-swap.  Priority:-1 extents:1 across:4194296k 
2010-04-06T19:48:39+02:00 eclipse info alg: No test for cipher_null (cipher_null-generic)
2010-04-06T19:48:39+02:00 eclipse info alg: No test for ecb(cipher_null) (ecb-cipher_null)
2010-04-06T19:48:39+02:00 eclipse info alg: No test for digest_null (digest_null-generic)
2010-04-06T19:48:39+02:00 eclipse info alg: No test for compress_null (compress_null-generic)
2010-04-06T19:48:39+02:00 eclipse info Intel AES-NI instructions are not detected.
2010-04-06T19:48:39+02:00 eclipse info r8169: eth0: link up
2010-04-06T19:48:39+02:00 eclipse info r8169: eth0: link up
2010-04-06T19:48:39+02:00 eclipse info eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
2010-04-06T19:48:39+02:00 eclipse debug eth2: resetting device...
2010-04-06T19:48:39+02:00 eclipse debug eth2: uploading firmware...
2010-04-06T19:48:39+02:00 eclipse info prism54 0000:03:02.0: firmware: requesting isl3890
2010-04-06T19:48:39+02:00 eclipse debug eth2: firmware version: 1.0.4.3
2010-04-06T19:48:39+02:00 eclipse debug eth2: firmware upload complete
2010-04-06T19:48:39+02:00 eclipse debug eth2: interface reset complete
2010-04-06T19:48:39+02:00 eclipse info ADDRCONF(NETDEV_UP): eth2: link is not ready
2010-04-06T19:48:39+02:00 eclipse info ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
2010-04-06T19:48:39+02:00 eclipse debug eth0: no IPv6 routers present
2010-04-06T19:48:39+02:00 eclipse debug eth1: no IPv6 routers present
2010-04-06T19:48:39+02:00 eclipse debug eth2: no IPv6 routers present
2010-04-06T19:48:40+02:00 eclipse info PPP generic driver version 2.4.2
2010-04-06T19:48:40+02:00 eclipse info NET: Registered protocol family 17
2010-04-06T19:48:40+02:00 eclipse info NET: Registered protocol family 24
2010-04-06T19:48:42+02:00 eclipse info IPv6 over IPv4 tunneling driver
2010-04-06T19:48:42+02:00 eclipse info sit0: Disabled Privacy Extensions
2010-04-06T19:48:42+02:00 eclipse info tun6to4: Disabled Privacy Extensions
2010-04-06T19:48:52+02:00 eclipse info lp0: using parport0 (interrupt-driven).
2010-04-06T19:48:52+02:00 eclipse info ppdev: user-space parallel port driver
2010-04-06T19:49:23+02:00 eclipse info [drm] Initialized drm 1.1.0 20060810
2010-04-06T19:49:23+02:00 eclipse info pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
2010-04-06T19:49:23+02:00 eclipse debug pci 0000:00:02.0: setting latency timer to 64
2010-04-06T19:49:23+02:00 eclipse info [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
2010-04-06T19:53:42+02:00 eclipse info Adding 1023992k swap on /swap.  Priority:-2 extents:264 across:1315448k 
2010-04-06T19:53:43+02:00 eclipse info Adding 1048564k swap on /swap2.  Priority:-3 extents:466 across:225021560k 
2010-04-06T19:53:44+02:00 eclipse info Adding 1048568k swap on /swap3.  Priority:-4 extents:683 across:152709220k 








#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.33.2-mh1
# Tue Apr  6 19:16:53 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
# CONFIG_TREE_RCU is not set
CONFIG_TREE_PREEMPT_RCU=y
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=8
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=16
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=y
# CONFIG_SLOW_WORK_DEBUG is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEBUG_CFQ_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=4
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_POWER_METER=m
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
# CONFIG_NET_IPGRE_BROADCAST is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
# CONFIG_NF_NAT_SNMP_BASIC is not set
CONFIG_NF_NAT_PROTO_DCCP=m
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_BT_ATH3K=m
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_DRBD=m
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=64000
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_DS1682 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_RAID6_PQ=m
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MDIO_BITBANG=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=m
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=m
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
CONFIG_PRISM54=m
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
# CONFIG_HDLC_RAW is not set
# CONFIG_HDLC_RAW_ETH is not set
# CONFIG_HDLC_CISCO is not set
# CONFIG_HDLC_FR is not set
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=m
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
# CONFIG_ATM_DRIVERS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1792
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_WINBOND_CIR=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_88PM8607 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_MGA=m
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
# CONFIG_SND_HDA_CODEC_CA0110 is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
# CONFIG_SND_USB_CAIAQ_INPUT is not set
CONFIG_SND_USB_US122L=m
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_KYE=m
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LOGITECH=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_NTRIG=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_VST is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_NOP_USB_XCEIV=m
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_NILFS2_FS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_XTS is not set
CONFIG_CRYPTO_FPU=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=m
