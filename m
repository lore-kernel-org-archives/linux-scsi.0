From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: strange queue_if_no_path behavior
Date: Tue, 19 Jun 2007 16:42:44 +0200
Message-ID: <598027198.20070619164244@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout4.netvision.net.il ([194.90.9.27]:29391 "EHLO
	mxout4.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbXFSOI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 10:08:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, malahal@us.ibm.com

Hi!
Reposting a shorter version.
I have a question regarding queue_if_no_path behavior.
I tried Red Hat 5.0 2.6.18-8.el5 kernel and more or less recent multipath-tools.
Set no_path_retry queue in multipath.conf and tried losing all paths
to a SAN device, while I'm dd-ing from /dev/zero to /dev/mapper/...

What's strange is that not only ios to that device got blocked, but
also ios to /tmp and /var/log/messages etc that reside on local drive.
When I return some paths to the SAN device, all ios resume, both ios
to that device and those unexpectedly blocked.

Please tell me if this is an expected behavior and if not, how could
we find a source of the problem and fix it?

# ps aux | grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      2872  0.0  0.0  10064   748 ?        Ds   21:58   0:00 syslogd -m 0
root      3800 24.9  0.0  63300  1592 ttyS0    D    22:01   0:22 dd if
/dev/zero of /dev/mapper/...
root      3990  0.0  0.0  58020   476 ttyS0    D    22:02   0:00 tail -f /var/log/messages

Thanks much,

Maxim.

Can't include here the full sysrq output as the message doesn't reach
the mailing list.
Sometimes (maybe it depends if root is on lvm or not) it tells
BUG: soft lockup detected on CPU#3!
BUG: soft lockup detected on CPU#0!
BUG: soft lockup detected on CPU#1!
BUG: soft lockup detected on CPU#2!

But I always see
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff80060d55>] io_schedule_timeout+0x4b/0x79
 [<ffffffff8003a9c4>] blk_congestion_wait+0x66/0x80
 for all processes in D state.

syslogd       D ffff810075f779c8     0 15395      1         15398 15380 (NOTLB)
 ffff810075f779c8 ffff8100022c7750 ffff810002667068 0000000000000009
 ffff81007fbe5080 ffff810037d1b100 0000006b91ee3bd1 00000000000014f4
 ffff81007fbe5268 0000000000000003 ffff810037d1b100 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff80060d55>] io_schedule_timeout+0x4b/0x79
 [<ffffffff8003a9c4>] blk_congestion_wait+0x66/0x80
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8004ece5>] writeback_inodes+0xa8/0xd8
 [<ffffffff800bc61b>] balance_dirty_pages_ratelimited_nr+0x183/0x1fa
 [<ffffffff8000fc69>] generic_file_buffered_write+0x5a4/0x6d8
 [<ffffffff80030dd5>] skb_copy_datagram_iovec+0x4f/0x237
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff80251b9e>] unix_dgram_recvmsg+0x240/0x25e
 [<ffffffff80015d10>] __generic_file_aio_write_nolock+0x36d/0x3b8
 [<ffffffff800b9744>] __generic_file_write_nolock+0x8f/0xa8
 [<ffffffff800d8408>] core_sys_select+0x1f9/0x265
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80061622>] mutex_lock+0xd/0x1d
 [<ffffffff800b97a5>] generic_file_writev+0x48/0xa2
 [<ffffffff8001770b>] do_sync_write+0x0/0x104
 [<ffffffff800d0f6c>] do_readv_writev+0x176/0x295
 [<ffffffff8001770b>] do_sync_write+0x0/0x104
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff800d1115>] sys_writev+0x45/0x93
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

klogd         S ffff8100757e5be8     0 15398      1         15410 15395 (NOTLB)
 ffff8100757e5be8 ffff81007fbe5080 ffffffff80086480 000000000000000a
 ffff810037fe37a0 ffff81007c30a7e0 000000690912dbde 000000000003fc7a
 ffff810037fe3988 0000000000000000 ffffffff80044d16 fffffffffffffffe
Call Trace:
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff8005a534>] cache_alloc_refill+0x106/0x186
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80045be5>] prepare_to_wait_exclusive+0x38/0x61
 [<ffffffff80250e8f>] unix_wait_for_peer+0x90/0xac
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80251422>] unix_dgram_sendmsg+0x3de/0x4cf
 [<ffffffff80037264>] do_sock_write+0xc4/0xce
 [<ffffffff8004543e>] sock_aio_write+0x4f/0x5e
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff800177d2>] do_sync_write+0xc7/0x104
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80016134>] vfs_write+0xe1/0x174
 [<ffffffff800169b2>] sys_write+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

irqbalance    S ffff810074c05eb8     0 15410      1         15432 15398 (NOTLB)
 ffff810074c05eb8 ffff810074c05e58 ffff810074c05e58 0000000000000007
 ffff81007d6bb7a0 ffffffff802d1ae0 0000006b8b7abaa3 000000000007f864
 ffff81007d6bb988 ffff810000000000 ffff810002c384e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074031d48     0 15432      1         15436 15410 (NOTLB)
 ffff810074031d48 ffff810075f5c140 fffffffffffffff0 0000000000000001
 ffff81007dbd2080 ffff810037fe9080 000000290837b6b9 0000000000091d38
 ffff81007dbd2268 ffff810000000000 0000004400000000 ffff81000000fc10
Call Trace:
 [<ffffffff800baea2>] __rmqueue+0x4c/0xe1
 [<ffffffff80035295>] find_extend_vma+0x16/0x59
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8003d7be>] do_futex+0x1da/0xbc7
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800336bb>] wake_up_new_task+0x231/0x240
 [<ffffffff8009eb55>] sys_futex+0x101/0x123
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074063b68     0 15436      1         15456 15432 (NOTLB)
 ffff810074063b68 ffff81007fbe5080 ffffffff80086480 000000000000000a
 ffff81007fb2a7a0 ffffffff802d1ae0 00000069091b6af3 000000000000de22
 ffff81007fb2a988 0000000000000000 ffffffff80044d16 ffffffffffffffff
Call Trace:
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80045be5>] prepare_to_wait_exclusive+0x38/0x61
 [<ffffffff80250e8f>] unix_wait_for_peer+0x90/0xac
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80251422>] unix_dgram_sendmsg+0x3de/0x4cf
 [<ffffffff80052bee>] sock_sendmsg+0xf3/0x110
 [<ffffffff8000e5d0>] link_path_walk+0xd3/0xe5
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8000c172>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8002c649>] mntput_no_expire+0x19/0x89
 [<ffffffff8020079d>] sys_sendto+0x11c/0x14f
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff81007464beb8     0 15472      1         15473 15456 (NOTLB)
 ffff81007464beb8 ffff81007464be58 ffff81007464be58 0000000000000001
 ffff81007c2bd040 ffffffff802d1ae0 0000006b6a8a5c09 0000000000062de2
 ffff81007c2bd228 ffff810000000000 ffff810002c384e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074647cd8     0 15473      1         15475 15472 (NOTLB)
 ffff810074647cd8 0000000000000000 ffffffff800765f4 0000000000000001
 ffff810037fe9080 ffff81007fd19100 00000069653ee680 00000000000126da
 ffff810037fe9268 0000000000000001 0000004400000000 ffffffffffffffff
Call Trace:
 [<ffffffff800765f4>] physflat_send_IPI_allbutself+0x41/0x46
 [<ffffffff88164ffb>] :dm_mod:dev_wait+0x0/0x83
 [<ffffffff881622eb>] :dm_mod:dm_wait_event+0x92/0xb0
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff881645b3>] :dm_mod:find_device+0x7c/0x84
 [<ffffffff8816502e>] :dm_mod:dev_wait+0x33/0x83
 [<ffffffff881659d8>] :dm_mod:ctl_ioctl+0x20d/0x258
 [<ffffffff8003fc73>] do_ioctl+0x55/0x6b
 [<ffffffff8002fa45>] vfs_ioctl+0x248/0x261
 [<ffffffff8004a24b>] sys_ioctl+0x59/0x78
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff81007465fcd8     0 15475      1         15476 15473 (NOTLB)
 ffff81007465fcd8 0000000000000000 ffffffff800765f4 0000000000000001
 ffff81007bae97a0 ffff81007c9f17e0 00000029083cfff6 000000000003b5ff
 ffff81007bae9988 0000000000000000 0000004400000000 ffff81000000fc10
Call Trace:
 [<ffffffff800765f4>] physflat_send_IPI_allbutself+0x41/0x46
 [<ffffffff800728c3>] do_flush_tlb_all+0x0/0x6a
 [<ffffffff88164ffb>] :dm_mod:dev_wait+0x0/0x83
 [<ffffffff881622eb>] :dm_mod:dm_wait_event+0x92/0xb0
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff881645b3>] :dm_mod:find_device+0x7c/0x84
 [<ffffffff8816502e>] :dm_mod:dev_wait+0x33/0x83
 [<ffffffff881659d8>] :dm_mod:ctl_ioctl+0x20d/0x258
 [<ffffffff8003fc73>] do_ioctl+0x55/0x6b
 [<ffffffff8002fa45>] vfs_ioctl+0x248/0x261
 [<ffffffff8004a24b>] sys_ioctl+0x59/0x78
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff81007409beb8     0 15476      1         15477 15475 (NOTLB)
 ffff81007409beb8 ffff81007409be58 ffff81007409be58 0000000000000001
 ffff81007c9f17e0 ffff810037d1b100 0000006b6a8448b9 00000000000164ba
 ffff81007c9f19c8 ffff810000000003 ffff810002c504e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074085b58     0 15477      1         15478 15476 (NOTLB)
 ffff810074085b58 0000000000000000 0000000000000000 0000000000000001
 ffff81007bae9040 ffff81007c14f7a0 0000002dfbb7b3a5 0000000000002bd9
 ffff81007bae9228 0000000100000000 ffff81007fb32040 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80045be5>] prepare_to_wait_exclusive+0x38/0x61
 [<ffffffff80053232>] skb_recv_datagram+0x160/0x1e3
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff802519c8>] unix_dgram_recvmsg+0x6a/0x25e
 [<ffffffff800864bc>] __activate_task+0x27/0x39
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff8002fdc0>] sock_recvmsg+0x101/0x120
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff8003dd7f>] do_futex+0x79b/0xbc7
 [<ffffffff8004fed1>] unix_bind+0x23b/0x29b
 [<ffffffff8002b2c7>] sys_recvfrom+0xd4/0x137
 [<ffffffff80032e9b>] lock_sock+0xa7/0xb2
 [<ffffffff8003058f>] release_sock+0x13/0xaa
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff81007414bb38     0 15478      1         15479 15477 (NOTLB)
 ffff81007414bb38 ffff81007e6b2c70 ffff81007e6b2c70 0000000000000001
 ffff81007da2b040 ffffffff802d1ae0 0000006b5bdbbbea 0000000000002ab1
 ffff81007da2b228 0000000000000000 ffffffff802d1ae0 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8001910d>] __getblk+0x25/0x22c
 [<ffffffff880327af>] :jbd:journal_stop+0x1f3/0x1ff
 [<ffffffff8805586b>] :ext3:__ext3_journal_stop+0x1f/0x3d
 [<ffffffff8000ce95>] dput+0x2c/0x113
 [<ffffffff8004fed1>] unix_bind+0x23b/0x29b
 [<ffffffff80200919>] sys_bind+0x90/0xa6
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074157d48     0 15479      1         15494 15478 (NOTLB)
 ffff810074157d48 0000000000000000 0000000000000000 0000000000000001
 ffff81007c14f7a0 ffff81007fb32040 0000002dfbb7ca33 000000000000168e
 ffff81007c14f988 0000000000000000 ffff81007bae9040 ffffffffffffffff
Call Trace:
 [<ffffffff80035295>] find_extend_vma+0x16/0x59
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8003d7be>] do_futex+0x1da/0xbc7
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009eb55>] sys_futex+0x101/0x123
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

dd            D ffff8100648dba68     0 16320  16288                     (NOTLB)
 ffff8100648dba68 ffff8100022886a8 ffff8100022886e0 0000000000000007
 ffff81007d6bb040 ffff81007fd28080 0000006b91ee7d94 00000000000015a9
 ffff81007d6bb228 ffff810000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff80060d55>] io_schedule_timeout+0x4b/0x79
 [<ffffffff8003a9c4>] blk_congestion_wait+0x66/0x80
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8004ece5>] writeback_inodes+0xa8/0xd8
 [<ffffffff800bc61b>] balance_dirty_pages_ratelimited_nr+0x183/0x1fa
 [<ffffffff8000fc69>] generic_file_buffered_write+0x5a4/0x6d8
 [<ffffffff800133d9>] __mark_inode_dirty+0x22/0x16e
 [<ffffffff80015d10>] __generic_file_aio_write_nolock+0x36d/0x3b8
 [<ffffffff800b981f>] generic_file_aio_write_nolock+0x20/0x6c
 [<ffffffff800b9be9>] generic_file_write_nolock+0x8f/0xa8
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8002e8df>] __clear_user+0x12/0x50
 [<ffffffff801836d9>] read_zero+0x1cc/0x225
 [<ffffffff800d491e>] blkdev_file_write+0x1a/0x1f
 [<ffffffff80016121>] vfs_write+0xce/0x174
 [<ffffffff800169b2>] sys_write+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

BUG: soft lockup detected on CPU#3!

Call Trace:
 <IRQ>  [<ffffffff800b2c85>] softlockup_tick+0xdb/0xed
 [<ffffffff800933d1>] update_process_times+0x42/0x68
 [<ffffffff80073d97>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074459>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80054f13>] mwait_idle+0x0/0x4a
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80054f49>] mwait_idle+0x36/0x4a
 [<ffffffff80046f9c>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb5>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2c85>] softlockup_tick+0xdb/0xed
 [<ffffffff800933d1>] update_process_times+0x42/0x68
 [<ffffffff80073d97>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074459>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80054f13>] mwait_idle+0x0/0x4a
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80054f49>] mwait_idle+0x36/0x4a
 [<ffffffff80046f9c>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2c85>] softlockup_tick+0xdb/0xed
 [<ffffffff800933d1>] update_process_times+0x42/0x68
 [<ffffffff80073d97>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074459>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80054f13>] mwait_idle+0x0/0x4a
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80054f49>] mwait_idle+0x36/0x4a
 [<ffffffff80046f9c>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb5>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#2!

Call Trace:
 <IRQ>  [<ffffffff800b2c85>] softlockup_tick+0xdb/0xed
 [<ffffffff800933d1>] update_process_times+0x42/0x68
 [<ffffffff80073d97>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074459>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80054f13>] mwait_idle+0x0/0x4a
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80054f49>] mwait_idle+0x36/0x4a
 [<ffffffff80046f9c>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb5>] start_secondary+0x45a/0x469 

