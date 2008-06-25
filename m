From: "Ashutosh Naik" <ashutosh.naik@gmail.com>
Subject: Kernel Crash when using the open-iscsi initiator on 2.6.25.6
Date: Wed, 25 Jun 2008 11:06:26 +0530
Message-ID: <81083a450806242236m62754185t3099c06f9f77676@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:51403 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbYFYFg1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2008 01:36:27 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2763666wfd.4
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2008 22:36:27 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com

Please find the kernel log attached. I was using the open-iscsi
initiator on kernel 2.6.25.6 with a chelsio iSCSI target and the crash
happened on the initiator machine.

 connection5:0: ping timeout of 5 secs expired, last rx 4309640121,
last ping 4309645121, now 4309650121
 connection5:0: detected conn error (1011)
 connection5:0: ping timeout of 5 secs expired, last rx 4309652882,
last ping 4309657882, now 4309662882
 connection5:0: detected conn error (1011)
 connection5:0: detected conn error (1011)
 session5: host reset succeeded
INFO: task fdisk:5226 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000000     0  5226   3300
 ffff810050d8baf8 0000000000000046 0000000000000000 ffffffff802271b3
 ffff81007dbeee70 ffff81007e1a0ab0 ffffffff80569da0 ffff81007e1a0e10
 0000000050d8bb48 0000000100df3c30 ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff802271b3>] enqueue_task+0x4d/0x58
 [<ffffffff80264e44>] sync_page+0x0/0x40
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264e31>] __lock_page+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff8026ca28>] pagevec_lookup+0x17/0x1e
 [<ffffffff8026d1a7>] truncate_inode_pages_range+0x26e/0x2ff
 [<ffffffff8021c099>] smp_call_function+0x33/0x38
 [<ffffffff802a9e9c>] invalidate_bh_lru+0x2b/0x42
 [<ffffffff802aea4f>] __blkdev_put+0x4f/0x145
 [<ffffffff8028d29f>] __fput+0xb1/0x17e
 [<ffffffff8028abd3>] filp_close+0x5d/0x65
 [<ffffffff802358d1>] put_files_struct+0x66/0xc4
 [<ffffffff80236a9d>] do_exit+0x269/0x67a
 [<ffffffff80236f1d>] do_group_exit+0x6f/0x8a
 [<ffffffff8023e5bd>] get_signal_to_deliver+0x2cb/0x2f4
 [<ffffffff8020b0ad>] do_notify_resume+0xb2/0x7e6
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8025cc1f>] audit_syscall_exit+0x2e4/0x303
 [<ffffffff8020beb3>] int_signal+0x12/0x17

INFO: task fdisk:5226 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000000     0  5226   3300
 ffff810050d8baf8 0000000000000046 0000000000000000 ffffffff802271b3
 ffff81007dbeee70 ffff81007e1a0ab0 ffffffff80569da0 ffff81007e1a0e10
 0000000050d8bb48 0000000100df3c30 ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff802271b3>] enqueue_task+0x4d/0x58
 [<ffffffff80264e44>] sync_page+0x0/0x40
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264e31>] __lock_page+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff8026ca28>] pagevec_lookup+0x17/0x1e
 [<ffffffff8026d1a7>] truncate_inode_pages_range+0x26e/0x2ff
 [<ffffffff8021c099>] smp_call_function+0x33/0x38
 [<ffffffff802a9e9c>] invalidate_bh_lru+0x2b/0x42
 [<ffffffff802aea4f>] __blkdev_put+0x4f/0x145
 [<ffffffff8028d29f>] __fput+0xb1/0x17e
 [<ffffffff8028abd3>] filp_close+0x5d/0x65
 [<ffffffff802358d1>] put_files_struct+0x66/0xc4
 [<ffffffff80236a9d>] do_exit+0x269/0x67a
 [<ffffffff80236f1d>] do_group_exit+0x6f/0x8a
 [<ffffffff8023e5bd>] get_signal_to_deliver+0x2cb/0x2f4
 [<ffffffff8020b0ad>] do_notify_resume+0xb2/0x7e6
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8025cc1f>] audit_syscall_exit+0x2e4/0x303
 [<ffffffff8020beb3>] int_signal+0x12/0x17

INFO: task fdisk:5226 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000000     0  5226   3300
 ffff810050d8baf8 0000000000000046 0000000000000000 ffffffff802271b3
 ffff81007dbeee70 ffff81007e1a0ab0 ffffffff80569da0 ffff81007e1a0e10
 0000000050d8bb48 0000000100df3c30 ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff802271b3>] enqueue_task+0x4d/0x58
 [<ffffffff80264e44>] sync_page+0x0/0x40
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264e31>] __lock_page+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff8026ca28>] pagevec_lookup+0x17/0x1e
 [<ffffffff8026d1a7>] truncate_inode_pages_range+0x26e/0x2ff
 [<ffffffff8021c099>] smp_call_function+0x33/0x38
 [<ffffffff802a9e9c>] invalidate_bh_lru+0x2b/0x42
 [<ffffffff802aea4f>] __blkdev_put+0x4f/0x145
 [<ffffffff8028d29f>] __fput+0xb1/0x17e
 [<ffffffff8028abd3>] filp_close+0x5d/0x65
 [<ffffffff802358d1>] put_files_struct+0x66/0xc4
 [<ffffffff80236a9d>] do_exit+0x269/0x67a
 [<ffffffff80236f1d>] do_group_exit+0x6f/0x8a
 [<ffffffff8023e5bd>] get_signal_to_deliver+0x2cb/0x2f4
 [<ffffffff8020b0ad>] do_notify_resume+0xb2/0x7e6
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8025cc1f>] audit_syscall_exit+0x2e4/0x303
 [<ffffffff8020beb3>] int_signal+0x12/0x17

 connection5:0: ping timeout of 5 secs expired, last rx 4310063907,
last ping 4310068907, now 4310073907
 connection5:0: detected conn error (1011)
sd 8:0:0:0: timing out command, waited 360s
sd 8:0:0:0: [sdb] Result: hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 0
printk: 39 messages suppressed.
Buffer I/O error on device sdb, logical block 0
Buffer I/O error on device sdb, logical block 1
Buffer I/O error on device sdb, logical block 2
Buffer I/O error on device sdb, logical block 3
 session5: session recovery timed out after 120 secs
 connection5:0: ping timeout of 5 secs expired, last rx 4310819770,
last ping 4310824770, now 4310829770
 connection5:0: detected conn error (1011)
 connection5:0: ping timeout of 5 secs expired, last rx 4310833033,
last ping 4310838033, now 4310843033
 connection5:0: detected conn error (1011)
 connection5:0: detected conn error (1011)
 session5: host reset succeeded
INFO: task fdisk:5304 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000082     0  5304   5283
 ffff810050d47c58 0000000000000086 ffff81007dbeee70 ffff81005fa64000
 ffff81007dbeee70 ffff81007e1a0ab0 ffff81007d32d620 ffff81007e1a0e10
 0000000100000287 ffffffff88071e50 ffff810050d10210 ffff81007db222b8
Call Trace:
 [<ffffffff88071e50>] :scsi_mod:scsi_dispatch_cmd+0x1f7/0x279
 [<ffffffff8807783a>] :scsi_mod:scsi_request_fn+0x321/0x375
 [<ffffffff80248b27>] getnstimeofday+0x2f/0x83
 [<ffffffff8026662c>] sync_page_killable+0x0/0x31
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80266635>] sync_page_killable+0x9/0x31
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264dcd>] __lock_page_killable+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff80266990>] generic_file_aio_read+0x2ff/0x4b3
 [<ffffffff8028c423>] do_sync_read+0xc9/0x10c
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028cbac>] vfs_read+0xaa/0x132
 [<ffffffff8028cf48>] sys_read+0x45/0x6e
 [<ffffffff8020be19>] tracesys+0xdc/0xe1

INFO: task fdisk:5304 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000082     0  5304   5283
 ffff810050d47c58 0000000000000086 ffff81007dbeee70 ffff81005fa64000
 ffff81007dbeee70 ffff81007e1a0ab0 ffff81007d32d620 ffff81007e1a0e10
 0000000100000287 ffffffff88071e50 ffff810050d10210 ffff81007db222b8
Call Trace:
 [<ffffffff88071e50>] :scsi_mod:scsi_dispatch_cmd+0x1f7/0x279
 [<ffffffff8807783a>] :scsi_mod:scsi_request_fn+0x321/0x375
 [<ffffffff80248b27>] getnstimeofday+0x2f/0x83
 [<ffffffff8026662c>] sync_page_killable+0x0/0x31
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80266635>] sync_page_killable+0x9/0x31
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264dcd>] __lock_page_killable+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff80266990>] generic_file_aio_read+0x2ff/0x4b3
 [<ffffffff8028c423>] do_sync_read+0xc9/0x10c
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028cbac>] vfs_read+0xaa/0x132
 [<ffffffff8028cf48>] sys_read+0x45/0x6e
 [<ffffffff8020be19>] tracesys+0xdc/0xe1

INFO: task fdisk:5304 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000082     0  5304   5283
 ffff810050d47c58 0000000000000086 ffff81007dbeee70 ffff81005fa64000
 ffff81007dbeee70 ffff81007e1a0ab0 ffff81007d32d620 ffff81007e1a0e10
 0000000100000287 ffffffff88071e50 ffff810050d10210 ffff81007db222b8
Call Trace:
 [<ffffffff88071e50>] :scsi_mod:scsi_dispatch_cmd+0x1f7/0x279
 [<ffffffff8807783a>] :scsi_mod:scsi_request_fn+0x321/0x375
 [<ffffffff80248b27>] getnstimeofday+0x2f/0x83
 [<ffffffff8026662c>] sync_page_killable+0x0/0x31
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80266635>] sync_page_killable+0x9/0x31
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264dcd>] __lock_page_killable+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff80266990>] generic_file_aio_read+0x2ff/0x4b3
 [<ffffffff8028c423>] do_sync_read+0xc9/0x10c
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028cbac>] vfs_read+0xaa/0x132
 [<ffffffff8028cf48>] sys_read+0x45/0x6e
 [<ffffffff8020be19>] tracesys+0xdc/0xe1

INFO: task fdisk:5304 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000082     0  5304   5283
 ffff810050d47c58 0000000000000086 ffff81007dbeee70 ffff81005fa64000
 ffff81007dbeee70 ffff81007e1a0ab0 ffff81007d32d620 ffff81007e1a0e10
 0000000100000287 ffffffff88071e50 ffff810050d10210 ffff81007db222b8
Call Trace:
 [<ffffffff88071e50>] :scsi_mod:scsi_dispatch_cmd+0x1f7/0x279
 [<ffffffff8807783a>] :scsi_mod:scsi_request_fn+0x321/0x375
 [<ffffffff80248b27>] getnstimeofday+0x2f/0x83
 [<ffffffff8026662c>] sync_page_killable+0x0/0x31
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80266635>] sync_page_killable+0x9/0x31
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264dcd>] __lock_page_killable+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff80266990>] generic_file_aio_read+0x2ff/0x4b3
 [<ffffffff8028c423>] do_sync_read+0xc9/0x10c
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028cbac>] vfs_read+0xaa/0x132
 [<ffffffff8028cf48>] sys_read+0x45/0x6e
 [<ffffffff8020be19>] tracesys+0xdc/0xe1

INFO: task fdisk:5304 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000082     0  5304   5283
 ffff810050d47c58 0000000000000086 ffff81007dbeee70 ffff81005fa64000
 ffff81007dbeee70 ffff81007e1a0ab0 ffff81007d32d620 ffff81007e1a0e10
 0000000100000287 ffffffff88071e50 ffff810050d10210 ffff81007db222b8
Call Trace:
 [<ffffffff88071e50>] :scsi_mod:scsi_dispatch_cmd+0x1f7/0x279
 [<ffffffff8807783a>] :scsi_mod:scsi_request_fn+0x321/0x375
 [<ffffffff80248b27>] getnstimeofday+0x2f/0x83
 [<ffffffff8026662c>] sync_page_killable+0x0/0x31
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80266635>] sync_page_killable+0x9/0x31
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264dcd>] __lock_page_killable+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff80266990>] generic_file_aio_read+0x2ff/0x4b3
 [<ffffffff8028c423>] do_sync_read+0xc9/0x10c
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028cbac>] vfs_read+0xaa/0x132
 [<ffffffff8028cf48>] sys_read+0x45/0x6e
 [<ffffffff8020be19>] tracesys+0xdc/0xe1

INFO: task fdisk:5304 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000082     0  5304   5283
 ffff810050d47c58 0000000000000086 ffff81007dbeee70 ffff81005fa64000
 ffff81007dbeee70 ffff81007e1a0ab0 ffff81007d32d620 ffff81007e1a0e10
 0000000100000287 ffffffff88071e50 ffff810050d10210 ffff81007db222b8
Call Trace:
 [<ffffffff88071e50>] :scsi_mod:scsi_dispatch_cmd+0x1f7/0x279
 [<ffffffff8807783a>] :scsi_mod:scsi_request_fn+0x321/0x375
 [<ffffffff80248b27>] getnstimeofday+0x2f/0x83
 [<ffffffff8026662c>] sync_page_killable+0x0/0x31
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80266635>] sync_page_killable+0x9/0x31
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264dcd>] __lock_page_killable+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff80266990>] generic_file_aio_read+0x2ff/0x4b3
 [<ffffffff8028c423>] do_sync_read+0xc9/0x10c
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028cbac>] vfs_read+0xaa/0x132
 [<ffffffff8028cf48>] sys_read+0x45/0x6e
 [<ffffffff8020be19>] tracesys+0xdc/0xe1

INFO: task fdisk:5304 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000082     0  5304   5283
 ffff810050d47c58 0000000000000086 ffff81007dbeee70 ffff81005fa64000
 ffff81007dbeee70 ffff81007e1a0ab0 ffff81007d32d620 ffff81007e1a0e10
 0000000100000287 ffffffff88071e50 ffff810050d10210 ffff81007db222b8
Call Trace:
 [<ffffffff88071e50>] :scsi_mod:scsi_dispatch_cmd+0x1f7/0x279
 [<ffffffff8807783a>] :scsi_mod:scsi_request_fn+0x321/0x375
 [<ffffffff80248b27>] getnstimeofday+0x2f/0x83
 [<ffffffff8026662c>] sync_page_killable+0x0/0x31
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80266635>] sync_page_killable+0x9/0x31
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264dcd>] __lock_page_killable+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff80266990>] generic_file_aio_read+0x2ff/0x4b3
 [<ffffffff8028c423>] do_sync_read+0xc9/0x10c
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028cbac>] vfs_read+0xaa/0x132
 [<ffffffff8028cf48>] sys_read+0x45/0x6e
 [<ffffffff8020be19>] tracesys+0xdc/0xe1

INFO: task fdisk:5304 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fdisk         D 0000000000000082     0  5304   5283
 ffff810050d47c58 0000000000000086 ffff81007dbeee70 ffff81005fa64000
 ffff81007dbeee70 ffff81007e1a0ab0 ffff81007d32d620 ffff81007e1a0e10
 0000000100000287 ffffffff88071e50 ffff810050d10210 ffff81007db222b8
Call Trace:
 [<ffffffff88071e50>] :scsi_mod:scsi_dispatch_cmd+0x1f7/0x279
 [<ffffffff8807783a>] :scsi_mod:scsi_request_fn+0x321/0x375
 [<ffffffff80248b27>] getnstimeofday+0x2f/0x83
 [<ffffffff8026662c>] sync_page_killable+0x0/0x31
 [<ffffffff80472949>] io_schedule+0x5d/0x9f
 [<ffffffff80264e80>] sync_page+0x3c/0x40
 [<ffffffff80266635>] sync_page_killable+0x9/0x31
 [<ffffffff80472abc>] __wait_on_bit_lock+0x36/0x66
 [<ffffffff80264dcd>] __lock_page_killable+0x5e/0x64
 [<ffffffff80244f03>] wake_bit_function+0x0/0x23
 [<ffffffff80266990>] generic_file_aio_read+0x2ff/0x4b3
 [<ffffffff8028c423>] do_sync_read+0xc9/0x10c
 [<ffffffff80244ed5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8028cbac>] vfs_read+0xaa/0x132
 [<ffffffff8028cf48>] sys_read+0x45/0x6e
 [<ffffffff8020be19>] tracesys+0xdc/0xe1
