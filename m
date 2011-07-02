From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 02 Jul 2011 07:24:42 -0500
Message-ID: <1309609482.2554.8.camel@mulgrave>
References: <1309554818.2722.48.camel@mulgrave>
	 <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org>
	 <20110702060846.GH23059@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44728 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011Ab1GBMYq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2011 08:24:46 -0400
In-Reply-To: <20110702060846.GH23059@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl, linux-usb@vger.kernel.org

On Sat, 2011-07-02 at 08:08 +0200, Andi Kleen wrote:
> > I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> > give the exact sequence of steps you went through to trigger the bug?
> 
> Connect USB storage device with builtin fake CD rom. Wait for udisk
> to mount it. Pull cable. udisk does umount. Oops.
> 
> I also got a log of the refcounting now if you want it.

So I've got the log, but this is the relevant section:

---
usb 2-1.5: USB disconnect, device number 4
sr 5:0:0:1: scsi put_device 13 from device_del+0x177/0x1c0
sr 5:0:0:1: scsi put_device 12 from bsg_kref_release_function+0x28/0x30
sr 5:0:0:1: scsi put_device 10 from device_del+0x177/0x1c0
sr 5:0:0:1: scsi put_device 8 from device_del+0x177/0x1c0
sr 5:0:0:1: scsi put_device 7 from scsi_device_cls_release+0x15/0x20
sr 5:0:0:1: scsi put_device 6 from klist_children_put+0x12/0x20
sr 5:0:0:1: scsi put_device 5 from klist_devices_put+0x12/0x20
sr 5:0:0:1: scsi put_device 3 from device_del+0x177/0x1c0
scsi: killing requests for dead queue
BUG: sleeping function called from invalid context
at /home/ak/lsrc/git/linux-2.6/arch/x86/mm/fault.c:1103
in_atomic(): 0, irqs_disabled(): 1, pid: 2527, name: umount
Pid: 2527, comm: umount Not tainted 3.0.0-rc5+ #8
Call Trace:
 [<ffffffff8103af8c>] __might_sleep+0xcc/0xf0
 [<ffffffff8155af42>] do_page_fault+0x142/0x4c0
 [<ffffffffa01d5385>] ? write_msg+0x105/0x120 [netconsole]
 [<ffffffff810514f7>] ? __call_console_drivers+0x97/0xb0
 [<ffffffff81079692>] ? up+0x32/0x50
 [<ffffffff81557f5f>] page_fault+0x1f/0x30
 [<ffffffff81389a70>] ? scsi_setup_blk_pc_cmnd+0x170/0x170
 [<ffffffff81388e19>] ? scsi_prep_state_check+0x9/0x90
 [<ffffffff8138992b>] scsi_setup_blk_pc_cmnd+0x2b/0x170
 [<ffffffff81389abd>] scsi_prep_fn+0x4d/0x60
 [<ffffffff812847ad>] blk_peek_request+0xbd/0x230
 [<ffffffff8138a1ea>] scsi_request_fn+0x44a/0x470
 [<ffffffff8127e42b>] __blk_run_queue+0x1b/0x20
 [<ffffffff812885a3>] blk_execute_rq_nowait+0x63/0xb0
 [<ffffffff81288676>] blk_execute_rq+0x86/0xf0
 [<ffffffff8128430d>] ? blk_get_request+0x6d/0xa0
 [<ffffffff81389c6c>] scsi_execute+0xfc/0x160
 [<ffffffff8138a40a>] scsi_execute_req+0xca/0x140
 [<ffffffff81383ea8>] ioctl_internal_command.clone.4+0x68/0x1a0
 [<ffffffff81103f82>] ? pagevec_lookup+0x22/0x30
 [<ffffffff8138405e>] scsi_set_medium_removal+0x7e/0xb0
 [<ffffffff8139b390>] sr_lock_door+0x20/0x30
 [<ffffffff813c4d63>] cdrom_release+0xa3/0x260
 [<ffffffff8118157e>] ? invalidate_bh_lru+0x2e/0x50
 [<ffffffff81181550>] ? buffer_cpu_notify+0xa0/0xa0
 [<ffffffff8139a088>] sr_block_release+0x38/0x60
 [<ffffffff8118833c>] __blkdev_put+0x16c/0x1b0
 [<ffffffff811883b2>] blkdev_put+0x32/0x130
 [<ffffffff8115650e>] kill_block_super+0x4e/0x80
 [<ffffffff81156865>] deactivate_locked_super+0x45/0x70
 [<ffffffff8115724a>] deactivate_super+0x4a/0x70
 [<ffffffff81171d54>] mntput_no_expire+0xc4/0x110
 [<ffffffff81172a2c>] sys_umount+0x6c/0x360
 [<ffffffff8155f52b>] system_call_fastpath+0x16/0x1b
BUG: unable to handle kernel NULL pointer dereference at
0000000000000650
IP: [<ffffffff81388e19>] scsi_prep_state_check+0x9/0x90
PGD 0 
Oops: 0000 [#1] SMP 
CPU 2 
Modules linked in: nls_utf8 udf ses enclosure netconsole configfs fuse
sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 kvm_intel kvm
uinput snd_hda_codec_hdmi snd_hda_codec_realtek snd_seq snd_seq_device
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore
iTCO_wdt snd_page_alloc iTCO_vendor_support joydev i7core_edac edac_core
broadcom tg3 e1000 dcdbas microcode serio_raw pcspkr i2c_i801
firewire_ohci firewire_core crc_itu_t usb_storage radeon ttm
drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]

Pid: 2527, comm: umount Not tainted 3.0.0-rc5+ #8 Dell Inc. Studio XPS
8000/0X231R
RIP: 0010:[<ffffffff81388e19>]  [<ffffffff81388e19>]
scsi_prep_state_check+0x9/0x90
RSP: 0018:ffff88021b3859c8  EFLAGS: 00010086
RAX: ffffffff81389a70 RBX: ffff88022d2c85a0 RCX: 0000000000001fa7
RDX: 0000000000000001 RSI: ffff88022d2c85a0 RDI: 0000000000000000
RBP: ffff88021b3859c8 R08: 0000000000000004 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88022e0a9428
R13: ffff88022d2c85a0 R14: 0000000000000000 R15: ffff88022e404d20
FS:  00007f2d10454760(0000) GS:ffff88023fc80000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000650 CR3: 0000000214443000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 2527, threadinfo ffff88021b384000, task
ffff88022e02dc80)
Stack:
 ffff88021b3859f8 ffffffff8138992b ffff88022d2c85a0 ffff88022e0a9428
 ffff88022d2c85a0 ffff88021b385cf8 ffff88021b385a18 ffffffff81389abd
 ffff88022d2c85a0 ffff88022e0a9428 ffff88021b385a48 ffffffff812847ad
Call Trace:
 [<ffffffff8138992b>] scsi_setup_blk_pc_cmnd+0x2b/0x170
 [<ffffffff81389abd>] scsi_prep_fn+0x4d/0x60
 [<ffffffff812847ad>] blk_peek_request+0xbd/0x230
 [<ffffffff8138a1ea>] scsi_request_fn+0x44a/0x470
 [<ffffffff8127e42b>] __blk_run_queue+0x1b/0x20
 [<ffffffff812885a3>] blk_execute_rq_nowait+0x63/0xb0
 [<ffffffff81288676>] blk_execute_rq+0x86/0xf0
 [<ffffffff8128430d>] ? blk_get_request+0x6d/0xa0
 [<ffffffff81389c6c>] scsi_execute+0xfc/0x160
 [<ffffffff8138a40a>] scsi_execute_req+0xca/0x140
 [<ffffffff81383ea8>] ioctl_internal_command.clone.4+0x68/0x1a0
 [<ffffffff81103f82>] ? pagevec_lookup+0x22/0x30
 [<ffffffff8138405e>] scsi_set_medium_removal+0x7e/0xb0
 [<ffffffff813c4d63>] cdrom_release+0xa3/0x260
 [<ffffffff8118157e>] ? invalidate_bh_lru+0x2e/0x50
 [<ffffffff81181550>] ? buffer_cpu_notify+0xa0/0xa0
 [<ffffffff8139a088>] sr_block_release+0x38/0x60
 [<ffffffff8118833c>] __blkdev_put+0x16c/0x1b0
 [<ffffffff811883b2>] blkdev_put+0x32/0x130
 [<ffffffff8115650e>] kill_block_super+0x4e/0x80
 [<ffffffff81156865>] deactivate_locked_super+0x45/0x70
 [<ffffffff8115724a>] deactivate_super+0x4a/0x70
 [<ffffffff81171d54>] mntput_no_expire+0xc4/0x110
 [<ffffffff81172a2c>] sys_umount+0x6c/0x360
 [<ffffffff8155f52b>] system_call_fastpath+0x16/0x1b
Code: 7b 58 e8 4b ea 1c 00 48 8b 4d a8 48 89 45 b8 48 89 cf e8 7b 88 ff
ff eb a1 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 <8b> 87
50 06 00 00 83 f8 02 75 04 31 c0 c9 c3 83 e8 04 83 f8 04 
RIP  [<ffffffff81388e19>] scsi_prep_state_check+0x9/0x90
 RSP <ffff88021b3859c8>
CR2: 0000000000000650
---[ end trace 06d5981e67b7b7c9 ]---
---

Which goes from the device unplug to the oops.  However, there are puts
missing from this; particularly the one where the reference goes to
zero.

James


