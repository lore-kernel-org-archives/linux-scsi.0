From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: yet another crash at CD-ROM removal, in elv_put_request
Date: Wed, 24 Aug 2011 08:55:44 +0200
Message-ID: <20110824085544.546b1ec7@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43827 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1HXGzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2011 02:55:49 -0400
Received: from stein ([83.221.231.7])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.13.6/8.13.6/Debian-1) with ESMTP id p7O6tjui004829
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2011 08:55:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

this happened while I tested an otherwise successful fix for
firewire-sbp2 module removal
(http://marc.info/?l=linux-kernel&m=131405379711937) on top of kernel
3.0.1.  I suppose some older kernels behave the same.

The command line which provoked the bug while a FireWire CD-RW is
connected:
# modprobe firewire-sbp2; sleep .2; modprobe -r firewire-sbp2

I have not checked how reliably this can be reproduced, but I will
try to eventually.  AFAIR, unplug of removable-media HDDs (e.g. card
readers) and of CD-ROMs is highly probable to crash since 2.6.38-rc1.
Or was it 2.6.37-rc1 even?

The kernel log:
Aug 23 00:34:26 mini kernel: scsi4 : SBP-2 IEEE-1394
Aug 23 00:34:34 mini kernel: firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retries)
Aug 23 00:34:34 mini kernel: scsi 4:0:0:0: CD-ROM            TEAC     CD-W28E          1.1A PQ: 0 ANSI: 0 CCS
Aug 23 00:34:34 mini kernel: sr1: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Aug 23 00:34:34 mini kernel: sr 4:0:0:0: Attached scsi CD-ROM sr1
Aug 23 00:34:34 mini kernel: sr 4:0:0:0: Attached scsi generic sg2 type 5
Aug 23 00:34:34 mini kernel: firewire_sbp2: fw1.0: orb reply timed out, rcode=0x00
Aug 23 00:34:34 mini kernel: BUG: unable to handle kernel paging request at 6b6b6b9f
Aug 23 00:34:34 mini kernel: IP: [<c10eb3ab>] elv_put_request+0x8/0x15
Aug 23 00:34:34 mini kernel: *pde = 00000000 
Aug 23 00:34:34 mini kernel: Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Aug 23 00:34:34 mini kernel: Modules linked in: firewire_sbp2(-) firewire_ohci firewire_core netconsole snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nfs lockd sunrpc snd_hda_codec_idt sg sr_mod applesmc cdrom input_polldev snd_hda_intel snd_hda_codec rtc snd_pcm i2c_i801 snd_timer snd sky2 snd_page_alloc
Aug 23 00:34:34 mini kernel: 
Aug 23 00:34:34 mini kernel: Pid: 12048, comm: cdrom_id Not tainted 3.0.1 #5
Aug 23 00:34:34 mini kernel: firewire_sbp2: released fw1.0, target 4:0:0
Aug 23 00:34:34 mini kernel: Apple Computer, Inc. Macmini1,1/Mac-F4208EC8
Aug 23 00:34:34 mini kernel: EIP: 0060:[<c10eb3ab>] EFLAGS: 00010006 CPU: 1
Aug 23 00:34:34 mini kernel: EIP is at elv_put_request+0x8/0x15
Aug 23 00:34:34 mini kernel: EAX: 6b6b6b6b EBX: f2cb2b10 ECX: 023a4800 EDX: f4b6af20
Aug 23 00:34:34 mini kernel: ESI: f4b6af20 EDI: 023a4800 EBP: f2fa7d54 ESP: f2fa7d54
Aug 23 00:34:34 mini kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Aug 23 00:34:34 mini kernel: Process cdrom_id (pid: 12048, ti=f2fa6000 task=f2e1a730 task.ti=f2fa6000)
Aug 23 00:34:34 mini kernel: Stack:
Aug 23 00:34:34 mini kernel: f2fa7d68 c10ed5e8 f2cb2b10 00000246 f4b6af20 f2fa7d7c c10edb89 f4b6af20
Aug 23 00:34:34 mini kernel: 00000001 00020000 f2fa7d94 c11bd605 f2fa7df6 f2e1f5e8 f2fa7df6 f3e1dbf0
Aug 23 00:34:34 mini kernel: f2fa7dcc c11bd661 00000000 00000000 f2e1f5e8 00007530 00000003 00000000
Aug 23 00:34:34 mini kernel: Call Trace:
Aug 23 00:34:34 mini kernel: [<c10ed5e8>] __blk_put_request+0x63/0x8c
Aug 23 00:34:34 mini kernel: [<c10edb89>] blk_put_request+0x21/0x33
Aug 23 00:34:34 mini kernel: [<c11bd605>] scsi_execute+0x101/0x10b
Aug 23 00:34:34 mini kernel: [<c11bd661>] scsi_execute_req+0x52/0x7f
Aug 23 00:34:34 mini kernel: [<c11bd6df>] scsi_test_unit_ready+0x51/0xb2
Aug 23 00:34:34 mini kernel: [<f816c00c>] sr_drive_status+0x33/0xc0 [sr_mod]
Aug 23 00:34:34 mini kernel: [<f816573d>] cdrom_ioctl+0x666/0xab9 [cdrom]
Aug 23 00:34:34 mini kernel: [<c1023176>] ? get_parent_ip+0xb/0x31
Aug 23 00:34:34 mini kernel: [<c102536b>] ? sub_preempt_count+0x7c/0x89
Aug 23 00:34:34 mini kernel: [<c12777a8>] ? mutex_lock_nested+0x276/0x291
Aug 23 00:34:34 mini kernel: [<f816b602>] sr_block_ioctl+0x4f/0x9a [sr_mod]
Aug 23 00:34:34 mini kernel: [<f816b5b3>] ? sr_block_check_events+0x13/0x13 [sr_mod]
Aug 23 00:34:34 mini kernel: [<c10f233e>] __blkdev_driver_ioctl+0x22/0x2e
Aug 23 00:34:34 mini kernel: [<c10f2c46>] blkdev_ioctl+0x65b/0x691
Aug 23 00:34:34 mini kernel: [<c10b1bbf>] block_ioctl+0x30/0x38
Aug 23 00:34:34 mini kernel: [<c10b1bbf>] ? block_ioctl+0x30/0x38
Aug 23 00:34:34 mini kernel: [<c10b1b8f>] ? nr_blockdev_pages+0x4c/0x4c
Aug 23 00:34:34 mini kernel: [<c109b9ea>] do_vfs_ioctl+0x46a/0x4af
Aug 23 00:34:34 mini kernel: [<c104c142>] ? trace_hardirqs_on_caller+0x100/0x121
Aug 23 00:34:34 mini kernel: [<c104c16e>] ? trace_hardirqs_on+0xb/0xd
Aug 23 00:34:34 mini kernel: [<c108e427>] ? do_sys_open+0x16a/0x174
Aug 23 00:34:34 mini kernel: [<c108e427>] ? do_sys_open+0x16a/0x174
Aug 23 00:34:34 mini kernel: [<c109ba5d>] sys_ioctl+0x2e/0x48
Aug 23 00:34:34 mini kernel: [<c12791d0>] sysenter_do_call+0x12/0x36
Aug 23 00:34:34 mini kernel: Code: 5b c9 c3 55 89 e5 53 8b 58 0c 8b 1b 8b 5b 30 85 db 74 04 ff d3 eb 09 c7 42 58 00 00 00 00 31 c0 5b c9 c3 55 8b 40 0c 89 e5 8b 00 <8b> 48 34 85 c9 74 04 89 d0 ff d1 c9 c3 55 89 e5 53 31 db 8b 48 
Aug 23 00:34:34 mini kernel: EIP: [<c10eb3ab>] elv_put_request+0x8/0x15 SS:ESP 0068:f2fa7d54
Aug 23 00:34:34 mini kernel: CR2: 000000006b6b6b9f
Aug 23 00:34:34 mini kernel: ---[ end trace 9699e8e492a6add7 ]---
Aug 23 00:34:34 mini kernel: note: cdrom_id[12048] exited with preempt_count 1
Aug 23 00:34:34 mini kernel: BUG: sleeping function called from invalid context at kernel/rwsem.c:21
Aug 23 00:34:34 mini kernel: in_atomic(): 1, irqs_disabled(): 1, pid: 12048, name: cdrom_id
Aug 23 00:34:34 mini kernel: INFO: lockdep is turned off.
Aug 23 00:34:34 mini kernel: irq event stamp: 2412
Aug 23 00:34:34 mini kernel: hardirqs last  enabled at (2411): [<c1278769>] _raw_spin_unlock_irq+0x22/0x43
Aug 23 00:34:34 mini kernel: hardirqs last disabled at (2412): [<c1278205>] _raw_spin_lock_irqsave+0xf/0x3e
Aug 23 00:34:34 mini kernel: softirqs last  enabled at (2380): [<c102da31>] __do_softirq+0xf6/0x105
Aug 23 00:34:34 mini kernel: softirqs last disabled at (2369): [<c1003d03>] do_softirq+0x52/0x9e
Aug 23 00:34:34 mini kernel: Pid: 12048, comm: cdrom_id Tainted: G      D     3.0.1 #5
Aug 23 00:34:34 mini kernel: Call Trace:
Aug 23 00:34:34 mini kernel: [<c1003d03>] ? do_softirq+0x52/0x9e
Aug 23 00:34:34 mini kernel: [<c1022d58>] __might_sleep+0xdb/0xe2
Aug 23 00:34:34 mini kernel: [<c1277a33>] down_read+0x17/0x40
Aug 23 00:34:34 mini kernel: [<c102a856>] exit_mm+0x2b/0x104
Aug 23 00:34:34 mini kernel: [<c102bfc1>] do_exit+0x1b1/0x57e
Aug 23 00:34:34 mini kernel: [<c1004b84>] oops_end+0x75/0x7c
Aug 23 00:34:34 mini kernel: [<c101a8c6>] no_context+0x110/0x11a
Aug 23 00:34:34 mini kernel: [<c101a9c1>] __bad_area_nosemaphore+0xf1/0xf9
Aug 23 00:34:34 mini kernel: [<c101ab78>] ? mm_fault_error+0x129/0x129
Aug 23 00:34:34 mini kernel: [<c101a9d6>] bad_area_nosemaphore+0xd/0x10
Aug 23 00:34:34 mini kernel: [<c101acd2>] do_page_fault+0x15a/0x34c
Aug 23 00:34:34 mini kernel: [<c10f759c>] ? cfq_set_request+0x2d7/0x30f
Aug 23 00:34:34 mini kernel: [<c10f72c5>] ? changed_ioprio+0x70/0x70
Aug 23 00:34:34 mini kernel: [<c101ab78>] ? mm_fault_error+0x129/0x129
Aug 23 00:34:34 mini kernel: [<c1278f63>] error_code+0x5f/0x64
Aug 23 00:34:34 mini kernel: [<c10e007b>] ? do_get_write_access+0x260/0x45c
Aug 23 00:34:34 mini kernel: [<c101ab78>] ? mm_fault_error+0x129/0x129
Aug 23 00:34:34 mini kernel: [<c10eb3ab>] ? elv_put_request+0x8/0x15
Aug 23 00:34:34 mini kernel: [<c10ed5e8>] __blk_put_request+0x63/0x8c
Aug 23 00:34:34 mini kernel: [<c10edb89>] blk_put_request+0x21/0x33
Aug 23 00:34:34 mini kernel: [<c11bd605>] scsi_execute+0x101/0x10b
Aug 23 00:34:34 mini kernel: [<c11bd661>] scsi_execute_req+0x52/0x7f
Aug 23 00:34:34 mini kernel: [<c11bd6df>] scsi_test_unit_ready+0x51/0xb2
Aug 23 00:34:34 mini kernel: [<f816c00c>] sr_drive_status+0x33/0xc0 [sr_mod]
Aug 23 00:34:34 mini kernel: [<f816573d>] cdrom_ioctl+0x666/0xab9 [cdrom]
Aug 23 00:34:34 mini kernel: [<c1023176>] ? get_parent_ip+0xb/0x31
Aug 23 00:34:34 mini kernel: [<c102536b>] ? sub_preempt_count+0x7c/0x89
Aug 23 00:34:34 mini kernel: [<c12777a8>] ? mutex_lock_nested+0x276/0x291
Aug 23 00:34:34 mini kernel: [<f816b602>] sr_block_ioctl+0x4f/0x9a [sr_mod]
Aug 23 00:34:34 mini kernel: [<f816b5b3>] ? sr_block_check_events+0x13/0x13 [sr_mod]
Aug 23 00:34:34 mini kernel: [<c10f233e>] __blkdev_driver_ioctl+0x22/0x2e
Aug 23 00:34:34 mini kernel: [<c10f2c46>] blkdev_ioctl+0x65b/0x691
Aug 23 00:34:34 mini kernel: [<c10b1bbf>] block_ioctl+0x30/0x38
Aug 23 00:34:34 mini kernel: [<c10b1bbf>] ? block_ioctl+0x30/0x38
Aug 23 00:34:34 mini kernel: [<c10b1b8f>] ? nr_blockdev_pages+0x4c/0x4c
Aug 23 00:34:34 mini kernel: [<c109b9ea>] do_vfs_ioctl+0x46a/0x4af
Aug 23 00:34:34 mini kernel: [<c104c142>] ? trace_hardirqs_on_caller+0x100/0x121
Aug 23 00:34:34 mini kernel: [<c104c16e>] ? trace_hardirqs_on+0xb/0xd
Aug 23 00:34:34 mini kernel: [<c108e427>] ? do_sys_open+0x16a/0x174
Aug 23 00:34:34 mini kernel: [<c108e427>] ? do_sys_open+0x16a/0x174
Aug 23 00:34:34 mini kernel: [<c109ba5d>] sys_ioctl+0x2e/0x48
Aug 23 00:34:34 mini kernel: [<c12791d0>] sysenter_do_call+0x12/0x36
Aug 23 00:34:34 mini kernel: BUG: scheduling while atomic: cdrom_id/12048/0x10000002
Aug 23 00:34:34 mini kernel: INFO: lockdep is turned off.
Aug 23 00:34:34 mini kernel: Modules linked in: firewire_sbp2(-) firewire_ohci firewire_core netconsole snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nfs lockd sunrpc snd_hda_codec_idt sg sr_mod applesmc cdrom input_polldev snd_hda_intel snd_hda_codec rtc snd_pcm i2c_i801 snd_timer snd sky2 snd_page_alloc [last unloaded: firewire_sbp2]
Aug 23 00:34:34 mini kernel: irq event stamp: 2412
Aug 23 00:34:34 mini kernel: hardirqs last  enabled at (2411): [<c1278769>] _raw_spin_unlock_irq+0x22/0x43
Aug 23 00:34:34 mini kernel: hardirqs last disabled at (2412): [<c1278205>] _raw_spin_lock_irqsave+0xf/0x3e
Aug 23 00:34:34 mini kernel: softirqs last  enabled at (2380): [<c102da31>] __do_softirq+0xf6/0x105
Aug 23 00:34:34 mini kernel: softirqs last disabled at (2369): [<c1003d03>] do_softirq+0x52/0x9e
Aug 23 00:34:34 mini kernel: Pid: 12048, comm: cdrom_id Tainted: G      D     3.0.1 #5
Aug 23 00:34:34 mini kernel: Call Trace:
Aug 23 00:34:34 mini kernel: [<c1003d03>] ? do_softirq+0x52/0x9e
Aug 23 00:34:34 mini kernel: [<c10249a1>] __schedule_bug+0x5e/0x65
Aug 23 00:34:34 mini kernel: [<c1275de4>] schedule+0x75/0x6e3
Aug 23 00:34:34 mini kernel: [<c10a46c7>] ? vfsmount_lock_global_unlock_online+0x62/0x65
Aug 23 00:34:34 mini kernel: [<c10a4b18>] ? mntput_no_expire+0x46/0xd3
Aug 23 00:34:34 mini kernel: [<c10a4bbe>] ? mntput+0x19/0x1b
Aug 23 00:34:34 mini kernel: [<c1090edc>] ? fput+0x175/0x17e
Aug 23 00:34:34 mini kernel: [<c1026c5d>] __cond_resched+0x12/0x1e
Aug 23 00:34:34 mini kernel: [<c12765f7>] _cond_resched+0x1d/0x28
Aug 23 00:34:34 mini kernel: [<c102aaef>] put_files_struct+0xaf/0x127
Aug 23 00:34:34 mini kernel: [<c102ab9e>] exit_files+0x37/0x3c
Aug 23 00:34:34 mini kernel: [<c102bfcf>] do_exit+0x1bf/0x57e
Aug 23 00:34:34 mini kernel: [<c1004b84>] oops_end+0x75/0x7c
Aug 23 00:34:34 mini kernel: [<c101a8c6>] no_context+0x110/0x11a
Aug 23 00:34:34 mini kernel: [<c101a9c1>] __bad_area_nosemaphore+0xf1/0xf9
Aug 23 00:34:34 mini kernel: [<c101ab78>] ? mm_fault_error+0x129/0x129
Aug 23 00:34:34 mini kernel: [<c101a9d6>] bad_area_nosemaphore+0xd/0x10
Aug 23 00:34:34 mini kernel: [<c101acd2>] do_page_fault+0x15a/0x34c
Aug 23 00:34:34 mini kernel: [<c10f759c>] ? cfq_set_request+0x2d7/0x30f
Aug 23 00:34:34 mini kernel: [<c10f72c5>] ? changed_ioprio+0x70/0x70
Aug 23 00:34:34 mini kernel: [<c101ab78>] ? mm_fault_error+0x129/0x129
Aug 23 00:34:34 mini kernel: [<c1278f63>] error_code+0x5f/0x64
Aug 23 00:34:34 mini kernel: [<c10e007b>] ? do_get_write_access+0x260/0x45c
Aug 23 00:34:34 mini kernel: [<c101ab78>] ? mm_fault_error+0x129/0x129
Aug 23 00:34:34 mini kernel: [<c10eb3ab>] ? elv_put_request+0x8/0x15
Aug 23 00:34:34 mini kernel: [<c10ed5e8>] __blk_put_request+0x63/0x8c
Aug 23 00:34:34 mini kernel: [<c10edb89>] blk_put_request+0x21/0x33
Aug 23 00:34:34 mini kernel: [<c11bd605>] scsi_execute+0x101/0x10b
Aug 23 00:34:34 mini kernel: [<c11bd661>] scsi_execute_req+0x52/0x7f
Aug 23 00:34:34 mini kernel: [<c11bd6df>] scsi_test_unit_ready+0x51/0xb2
Aug 23 00:34:34 mini kernel: [<f816c00c>] sr_drive_status+0x33/0xc0 [sr_mod]
Aug 23 00:34:34 mini kernel: [<f816573d>] cdrom_ioctl+0x666/0xab9 [cdrom]
Aug 23 00:34:34 mini kernel: [<c1023176>] ? get_parent_ip+0xb/0x31
Aug 23 00:34:34 mini kernel: [<c102536b>] ? sub_preempt_count+0x7c/0x89
Aug 23 00:34:34 mini kernel: [<c12777a8>] ? mutex_lock_nested+0x276/0x291
Aug 23 00:34:34 mini kernel: [<f816b602>] sr_block_ioctl+0x4f/0x9a [sr_mod]
Aug 23 00:34:34 mini kernel: [<f816b5b3>] ? sr_block_check_events+0x13/0x13 [sr_mod]
Aug 23 00:34:34 mini kernel: [<c10f233e>] __blkdev_driver_ioctl+0x22/0x2e
Aug 23 00:34:34 mini kernel: [<c10f2c46>] blkdev_ioctl+0x65b/0x691
Aug 23 00:34:34 mini kernel: [<c10b1bbf>] block_ioctl+0x30/0x38
Aug 23 00:34:34 mini kernel: [<c10b1bbf>] ? block_ioctl+0x30/0x38
Aug 23 00:34:34 mini kernel: [<c10b1b8f>] ? nr_blockdev_pages+0x4c/0x4c
Aug 23 00:34:34 mini kernel: [<c109b9ea>] do_vfs_ioctl+0x46a/0x4af
Aug 23 00:34:34 mini kernel: [<c104c142>] ? trace_hardirqs_on_caller+0x100/0x121
Aug 23 00:34:34 mini kernel: [<c104c16e>] ? trace_hardirqs_on+0xb/0xd
Aug 23 00:34:34 mini kernel: [<c108e427>] ? do_sys_open+0x16a/0x174
Aug 23 00:34:34 mini kernel: [<c108e427>] ? do_sys_open+0x16a/0x174
Aug 23 00:34:34 mini kernel: [<c109ba5d>] sys_ioctl+0x2e/0x48
Aug 23 00:34:34 mini kernel: [<c12791d0>] sysenter_do_call+0x12/0x36
Aug 23 00:34:34 mini kernel: BUG: scheduling while atomic: cdrom_id/12048/0x00000002
Aug 23 00:34:34 mini kernel: INFO: lockdep is turned off.
Aug 23 00:34:34 mini kernel: Modules linked in: firewire_ohci firewire_core netconsole snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nfs lockd sunrpc snd_hda_codec_idt sg sr_mod applesmc cdrom input_polldev snd_hda_intel snd_hda_codec rtc snd_pcm i2c_i801 snd_timer snd sky2 snd_page_alloc [last unloaded: firewire_sbp2]
Aug 23 00:34:34 mini kernel: Pid: 12048, comm: cdrom_id Tainted: G      D     3.0.1 #5
Aug 23 00:34:34 mini kernel: Call Trace:
Aug 23 00:34:34 mini kernel: [<c10249a1>] __schedule_bug+0x5e/0x65
Aug 23 00:34:34 mini kernel: [<c1275de4>] schedule+0x75/0x6e3
Aug 23 00:34:34 mini kernel: [<f816b69e>] ? sr_block_release+0x19/0x3a [sr_mod]
Aug 23 00:34:34 mini kernel: [<f816b69e>] ? sr_block_release+0x19/0x3a [sr_mod]
Aug 23 00:34:34 mini kernel: [<c1277694>] mutex_lock_nested+0x162/0x291
Aug 23 00:34:34 mini kernel: [<f816b69e>] sr_block_release+0x19/0x3a [sr_mod]
Aug 23 00:34:34 mini kernel: [<c10b2a18>] __blkdev_put+0x84/0x124
Aug 23 00:34:34 mini kernel: [<c10b2b9d>] blkdev_put+0xe5/0xeb
Aug 23 00:34:34 mini kernel: [<c10b2bbd>] blkdev_close+0x1a/0x1c
Aug 23 00:34:34 mini kernel: [<c1090e4f>] fput+0xe8/0x17e
Aug 23 00:34:34 mini kernel: [<c108e13e>] filp_close+0x57/0x61
Aug 23 00:34:34 mini kernel: [<c102aad9>] put_files_struct+0x99/0x127
Aug 23 00:34:34 mini kernel: [<c102ab9e>] exit_files+0x37/0x3c
Aug 23 00:34:34 mini kernel: [<c102bfcf>] do_exit+0x1bf/0x57e
Aug 23 00:34:34 mini kernel: [<c1004b84>] oops_end+0x75/0x7c
Aug 23 00:34:34 mini kernel: [<c101a8c6>] no_context+0x110/0x11a
Aug 23 00:34:34 mini kernel: [<c101a9c1>] __bad_area_nosemaphore+0xf1/0xf9
Aug 23 00:34:34 mini kernel: [<c101ab78>] ? mm_fault_error+0x129/0x129
Aug 23 00:34:34 mini kernel: [<c101a9d6>] bad_area_nosemaphore+0xd/0x10
Aug 23 00:34:34 mini kernel: [<c101acd2>] do_page_fault+0x15a/0x34c
Aug 23 00:34:34 mini kernel: [<c10f759c>] ? cfq_set_request+0x2d7/0x30f
Aug 23 00:34:34 mini kernel: [<c10f72c5>] ? changed_ioprio+0x70/0x70
Aug 23 00:34:34 mini kernel: [<c101ab78>] ? mm_fault_error+0x129/0x129
Aug 23 00:34:34 mini kernel: [<c1278f63>] error_code+0x5f/0x64
Aug 23 00:34:34 mini kernel: [<c10e007b>] ? do_get_write_access+0x260/0x45c
Aug 23 00:34:34 mini kernel: [<c101ab78>] ? mm_fault_error+0x129/0x129
Aug 23 00:34:34 mini kernel: [<c10eb3ab>] ? elv_put_request+0x8/0x15
Aug 23 00:34:34 mini kernel: [<c10ed5e8>] __blk_put_request+0x63/0x8c
Aug 23 00:34:34 mini kernel: [<c10edb89>] blk_put_request+0x21/0x33
Aug 23 00:34:34 mini kernel: [<c11bd605>] scsi_execute+0x101/0x10b
Aug 23 00:34:34 mini kernel: [<c11bd661>] scsi_execute_req+0x52/0x7f
Aug 23 00:34:34 mini kernel: [<c11bd6df>] scsi_test_unit_ready+0x51/0xb2
Aug 23 00:34:34 mini kernel: [<f816c00c>] sr_drive_status+0x33/0xc0 [sr_mod]
Aug 23 00:34:34 mini kernel: [<f816573d>] cdrom_ioctl+0x666/0xab9 [cdrom]
Aug 23 00:34:34 mini kernel: [<c1023176>] ? get_parent_ip+0xb/0x31
Aug 23 00:34:34 mini kernel: [<c102536b>] ? sub_preempt_count+0x7c/0x89
Aug 23 00:34:34 mini kernel: [<c12777a8>] ? mutex_lock_nested+0x276/0x291
Aug 23 00:34:34 mini kernel: [<f816b602>] sr_block_ioctl+0x4f/0x9a [sr_mod]
Aug 23 00:34:34 mini kernel: [<f816b5b3>] ? sr_block_check_events+0x13/0x13 [sr_mod]
Aug 23 00:34:34 mini kernel: [<c10f233e>] __blkdev_driver_ioctl+0x22/0x2e
Aug 23 00:34:34 mini kernel: [<c10f2c46>] blkdev_ioctl+0x65b/0x691
Aug 23 00:34:34 mini kernel: [<c10b1bbf>] block_ioctl+0x30/0x38
Aug 23 00:34:34 mini kernel: [<c10b1bbf>] ? block_ioctl+0x30/0x38
Aug 23 00:34:34 mini kernel: [<c10b1b8f>] ? nr_blockdev_pages+0x4c/0x4c
Aug 23 00:34:34 mini kernel: [<c109b9ea>] do_vfs_ioctl+0x46a/0x4af
Aug 23 00:34:34 mini kernel: [<c104c142>] ? trace_hardirqs_on_caller+0x100/0x121
Aug 23 00:34:34 mini kernel: [<c104c16e>] ? trace_hardirqs_on+0xb/0xd
Aug 23 00:34:34 mini kernel: [<c108e427>] ? do_sys_open+0x16a/0x174
Aug 23 00:34:34 mini kernel: [<c108e427>] ? do_sys_open+0x16a/0x174
Aug 23 00:34:34 mini kernel: [<c109ba5d>] sys_ioctl+0x2e/0x48
Aug 23 00:34:34 mini kernel: [<c12791d0>] sysenter_do_call+0x12/0x36

-- 
Stefan Richter
-=====-==-== =--- ==---
http://arcgraph.de/sr/
