From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Regression: hang while burning DVD in scsi_init_sgtable
Date: Mon, 26 Apr 2010 19:24:37 -0600
Message-ID: <4BD63CD5.3020307@gmail.com>
References: <20100425175639.GA31060@neutronstar.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100425175639.GA31060@neutronstar.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: textshell-dOFHIR@neutronstar.dyndns.org
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On 04/25/2010 11:56 AM, textshell-dOFHIR@neutronstar.dyndns.org wrote:
> After upgradeing from 2.6.31 to 2.6.33.2 buring a DVD with growisofs
> occasionally looks up in the kernel.
> The DVD drive is connected via IDE to an ICH7 IDE controller(using ATA_PIIX
> driver).
>
> i usually burn DVDs with
> growisofs -speed 4 -Z /dev/sr0 -dvd-video -udf .
> and sometimes it does work with just outputting:
>
> 2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> 2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current]
> 2010-04-11T15:22:14+02:00 eclipse alert Info fld=0x0
> 2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Add. Sense: Logical block address out of range
> 2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
> 2010-04-11T15:22:14+02:00 eclipse err end_request: I/O error, dev sr0, sector 0
> 2010-04-11T15:22:14+02:00 eclipse err Buffer I/O error on device sr0, logical block 0
> 2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> 2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current]
> 2010-04-11T15:22:14+02:00 eclipse alert Info fld=0x0
> 2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] Add. Sense: Logical block address out of range
> 2010-04-11T15:22:14+02:00 eclipse info sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
> 2010-04-11T15:22:14+02:00 eclipse err end_request: I/O error, dev sr0, sector 0
> 2010-04-11T15:22:14+02:00 eclipse err Buffer I/O error on device sr0, logical block 0
>
> But the DVD gets written properly, so i don't really care, although it
> looks like something might be working here already.
> Anyway now for the second time it didn't output these messages, but instead
> just hangs in the kernel.
> The other processes keep running but the growisofs process is hung in the
> kernel. ctrl-C or even killing with SIGKILL doesn't work.
> according to /proc the task is in state "D (disk sleep)" (at the time of
> writing this email).
>
> a bit later the kernel logs this:
>
> 2010-04-22T23:50:00+02:00 eclipse err INFO: task growisofs:23916 blocked for more than 120 seconds.
> 2010-04-22T23:50:00+02:00 eclipse err "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2010-04-22T23:50:00+02:00 eclipse info growisofs     D ffff8800a96ee3c0     0 23916  23913 0x00000000
> 2010-04-22T23:50:00+02:00 eclipse alert ffff8800b7845858 0000000000000086 0000007fcf195000 ffff8800aa14f058
> 2010-04-22T23:50:00+02:00 eclipse alert 000000000000ddc8 ffff8800b7845fd8 0000000000012400 0000000000012400
> 2010-04-22T23:50:00+02:00 eclipse alert ffff8800b78457c8 ffffffff811ea32c ffff88000181a1c0 ffff88009e829b00
> 2010-04-22T23:50:00+02:00 eclipse alert Call Trace:
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff811ea32c>] ? scsi_init_sgtable+0x83/0x8a
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff811ea72c>] ? scsi_setup_blk_pc_cmnd+0x99/0x115
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d1dfe>] schedule_timeout+0x26/0x1c9
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8115d60e>] ? kobject_put+0x47/0x4b
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d38c4>] ? _raw_spin_lock_irq+0x17/0x2f
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d0f3c>] wait_for_common+0xc2/0x138
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8102f944>] ? default_wake_function+0x0/0xf
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8114d751>] ? __generic_unplug_device+0x2d/0x31
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d103c>] wait_for_completion+0x18/0x1a
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8115105a>] blk_execute_rq+0x92/0xb0
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81150bbb>] ? blk_rq_append_bio+0x19/0x46
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81150e60>] ? blk_rq_map_user+0x160/0x204
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8113a233>] ? security_capable+0x27/0x29
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff811542ac>] sg_io+0x273/0x385
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81154896>] scsi_cmd_ioctl+0x1e2/0x448
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8104bfeb>] ? sched_clock_cpu+0xc6/0xd4
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8102574e>] ? cpuacct_charge+0x57/0x5f
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8121412a>] cdrom_ioctl+0x30/0xe01
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81027e0d>] ? enqueue_entity+0x125/0x12d
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81024c00>] ? wakeup_preempt_entity+0x9d/0xab
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81026c61>] ? check_preempt_wakeup+0x1ae/0x23d
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff811f398f>] sr_block_ioctl+0x4b/0x82
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff8115229d>] __blkdev_driver_ioctl+0x75/0x9d
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81152b31>] blkdev_ioctl+0x86c/0x8a7
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d364a>] ? _raw_spin_unlock+0x10/0x29
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81055dcd>] ? do_futex+0xc2/0x92a
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d38f4>] ? _raw_spin_lock_irqsave+0x18/0x34
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d3621>] ? _raw_spin_unlock_irqrestore+0x12/0x2b
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810474c7>] ? remove_wait_queue+0x48/0x4d
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff812d3621>] ? _raw_spin_unlock_irqrestore+0x12/0x2b
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810c8ef7>] block_ioctl+0x38/0x3c
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810b09f4>] vfs_ioctl+0x2a/0x9e
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810b0f2c>] do_vfs_ioctl+0x449/0x486
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810a4ac9>] ? fget_light+0xa8/0xc0
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff81056743>] ? sys_futex+0x10e/0x12c
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810b0fbe>] sys_ioctl+0x55/0x77
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810a434b>] ? sys_write+0x60/0x6e
> 2010-04-22T23:50:00+02:00 eclipse alert [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b

It won't actually be blocked in scsi_init_sgtable, that's likely a 
spurious IP value on the stack. It looks like we're waiting for a 
completion of a command - could be we lost a completion somehow and it 
never timed out, or the application specified some huge timeout value (I 
think the app can do that for SG_IO commands..)
