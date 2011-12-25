From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Yet another hot unplug NULL pointer dereference (was Re: status of
 oops in sd_revalidate_disk?)
Date: Sun, 25 Dec 2011 21:58:04 +0100
Message-ID: <20111225215804.03ef9402@stein>
References: <4EE8E419.8010000@pre-sense.de>
	<CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Huajun Li <huajun.li.lee@gmail.com>, Axel Theilmann <theilmann@pre-sense.de>, jbottomley@parallels.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

as far as I remember, all Linux releases in 2011 have been broken WRT hot
removal of block devices; some more severely, some less.  Various patches
for this went in over the year, but if they fixed anything, they always
uncovered the next lingering unplug related bug.  The presumed first Linux
release in 2012 will be broken too, again in an easy to trigger way.  Here
is a quick test:
  - Start grip or any other program for CD-ROM access.
  - Unplug CD-ROM drive.
  - Have the program issue an ioctl, e.g. poll for medium presence.

With a little bit of bad luck, udisks-daemon or in older distros hald
should hit the bug too.  Under kernel 3.1 I typically just got processes
hanging in unkillable sleep.  With kernel 3.2-rc7 I get an instant kernel
panic.

First I tested a FireWire drive and got the first log which is included
below, instantly in two attempts.  Then I made two attempts with a USB
CD-ROM which did not oops immediately at device removal but when I then
hit the eject button in the still open grip.  This consistently produced
the second log at the end of this post.

First test with 1394 CD-ROM:
-----------------------------------------------------------------
  - attach CD-ROM drive
-----------------------------------------------------------------
scsi4 : SBP-2 IEEE-1394
firewire_sbp2 fw1.0: logged in to LUN 0000 (0 retries)
scsi 4:0:0:0: CD-ROM		TEAC	 CD-W28E	  1.1A PQ: 0 ANSI: 0 CCS
sr1: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
sr 4:0:0:0: Attached scsi CD-ROM sr1
-----------------------------------------------------------------
  - start grip
  - detach CD-ROM drive
-----------------------------------------------------------------
sr 4:0:0:0: Attached scsi generic sg2 type 5
scsi 4:0:0:0: killing request
BUG: unable to handle kernel NULL pointer dereference at 000003f0
IP: [<c11bc19f>] scsi_prep_state_check+0x6/0x68
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: firewire_sbp2 firewire_ohci firewire_core netconsole snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nfs lockd sunrpc i2c_i801 applesmc sr_mod rtc sg input_polldev cdrom snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_pcm snd_timer snd sky2 snd_page_alloc

Pid: 2832, comm: grip Not tainted 3.2.0-rc7 #1 Apple Computer, Inc. Macmini1,1/Mac-F4208EC8
EIP: 0060:[<c11bc19f>] EFLAGS: 00010046 CPU: 0
EIP is at scsi_prep_state_check+0x6/0x68
EAX: 00000000 EBX: f33f3f18 ECX: 00000000 EDX: f33f3f18
ESI: f4815a68 EDI: 00000000 EBP: f160bc14 ESP: f160bc10
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process grip (pid: 2832, ti=f160a000 task=f5d48760 task.ti=f160a000)
Stack:
 f33f3f18 f160bc2c c11bc8b1 f160bc3c f33f3f18 f4815a68 f33f3f18 f160bc3c
 c11bc9a5 f33f3f18 f4815a68 f160bc50 c10efad5 00000000 f33f3f18 f4815a68
 f160bc78 c11bd09f f4815db0 f33f3f18 00000001 f33f3f18 f4815a68 f4815a68

Call Trace:
 [<c11bc8b1>] scsi_setup_blk_pc_cmnd+0x12/0xe7
 [<c11bc9a5>] scsi_prep_fn+0x1f/0x2e
 [<c10efad5>] blk_peek_request+0x98/0x168
 [<c11bd09f>] scsi_request_fn+0x23/0x3b5
 [<c10ed9d6>] __blk_run_queue+0x14/0x16
 [<c10f25d5>] blk_execute_rq_nowait+0x7d/0x98
 [<c10f2697>] blk_execute_rq+0xa7/0xe8
 [<c10f2530>] ? blk_rq_map_user+0x1b7/0x1b7
 [<c10f8c81>] ? changed_ioprio+0x70/0x70
 [<c10ed700>] ? elv_set_request+0x12/0x20
 [<c10eeebd>] ? get_request+0x21e/0x2bb
 [<c11bcad2>] scsi_execute+0xc4/0x10a
 [<c11bcb6c>] scsi_execute_req+0x54/0x81
 [<c11bcbea>] scsi_test_unit_ready+0x51/0xb2
 [<f828248b>] sr_drive_status+0x33/0xd5 [sr_mod]
 [<f81f7860>] cdrom_ioctl+0x6a9/0xb31 [cdrom]
 [<c1279f36>] ? mutex_lock_nested+0x26c/0x2b0
 [<c10231e5>] ? get_parent_ip+0xb/0x31
 [<c1023287>] ? sub_preempt_count+0x7c/0x89
 [<c1279f5f>] ? mutex_lock_nested+0x295/0x2b0
 [<f82815f1>] ? sr_block_ioctl+0x2e/0x9a [sr_mod]
 [<f8281612>] sr_block_ioctl+0x4f/0x9a [sr_mod]
 [<f82815c3>] ? sr_block_check_events+0x13/0x13 [sr_mod]
 [<c10f39ee>] __blkdev_driver_ioctl+0x22/0x2e
 [<c10f42f5>] blkdev_ioctl+0x66d/0x68c
 [<c104bf7e>] ? __lock_acquire+0x62e/0x14bb
 [<c10b1861>] block_ioctl+0x32/0x3a
 [<c10b1861>] ? block_ioctl+0x32/0x3a
 [<c10b182f>] ? bd_set_size+0x67/0x67
 [<c109bfd5>] do_vfs_ioctl+0x481/0x4b7
 [<c1090993>] ? fget_light+0x4c/0xd0
 [<c109c039>] sys_ioctl+0x2e/0x49
 [<c127bb50>] sysenter_do_call+0x12/0x36
Code: 55 dc 8b 42 04 8b 80 68 03 00 00 e8 65 f0 0b 00 8b 43 64 e8 bf e9 0b 00 e9 59 ff ff ff 83 c4 1c 5b 5e 5f c9 c3 55 31 c9 89 e5 53 98 f0 03 00 00 83 fb 02 74 50 8d 4b fc 83 f9 04 77 3f ff 24
EIP: [<c11bc19f>] scsi_prep_state_check+0x6/0x68 SS:ESP 0068:f160bc10
CR2: 00000000000003f0
---[ end trace fba59fe8183510a7 ]---
note: grip[2832] exited with preempt_count 1
BUG: sleeping function called from invalid context at mm/memory.c:3905
in_atomic(): 1, irqs_disabled(): 0, pid: 2832, name: grip
INFO: lockdep is turned off.
Pid: 2832, comm: grip Tainted: G      D      3.2.0-rc7 #1
Call Trace:
 [<c1020b11>] __might_sleep+0xdb/0xe2
 [<c107cb36>] might_fault+0x22/0x7c
 [<c10503d0>] exit_robust_list+0x24/0x112
 [<c127b3f0>] ? restore_all+0xf/0xf
 [<c102721c>] mm_release+0x21/0xad
 [<c102a72f>] exit_mm+0x18/0xe7
 [<c127831f>] ? printk+0xf/0x18
 [<c102ba91>] do_exit+0x193/0x574
 [<c1004ac9>] oops_end+0x75/0x7c
 [<c101a8fc>] no_context+0x10e/0x118
 [<c104bf7e>] ? __lock_acquire+0x62e/0x14bb
 [<c101a9fa>] __bad_area_nosemaphore+0xf4/0xfc
 [<c101acd2>] ? vmalloc_sync_all+0x101/0x101
 [<c101aa0f>] bad_area_nosemaphore+0xd/0x10
 [<c101ae2d>] do_page_fault+0x15b/0x352
 [<c1090993>] ? fget_light+0x4c/0xd0
 [<c101acd2>] ? vmalloc_sync_all+0x101/0x101
 [<c127b8e7>] error_code+0x5f/0x64
 [<c101acd2>] ? vmalloc_sync_all+0x101/0x101
 [<c11bc19f>] ? scsi_prep_state_check+0x6/0x68
 [<c11bc8b1>] scsi_setup_blk_pc_cmnd+0x12/0xe7
 [<c11bc9a5>] scsi_prep_fn+0x1f/0x2e
 [<c10efad5>] blk_peek_request+0x98/0x168
 [<c11bd09f>] scsi_request_fn+0x23/0x3b5
 [<c10ed9d6>] __blk_run_queue+0x14/0x16
 [<c10f25d5>] blk_execute_rq_nowait+0x7d/0x98
 [<c10f2697>] blk_execute_rq+0xa7/0xe8
 [<c10f2530>] ? blk_rq_map_user+0x1b7/0x1b7
 [<c10f8c81>] ? changed_ioprio+0x70/0x70
 [<c10ed700>] ? elv_set_request+0x12/0x20
 [<c10eeebd>] ? get_request+0x21e/0x2bb
 [<c11bcad2>] scsi_execute+0xc4/0x10a
 [<c11bcb6c>] scsi_execute_req+0x54/0x81
 [<c11bcbea>] scsi_test_unit_ready+0x51/0xb2
 [<f828248b>] sr_drive_status+0x33/0xd5 [sr_mod]
 [<f81f7860>] cdrom_ioctl+0x6a9/0xb31 [cdrom]
 [<c1279f36>] ? mutex_lock_nested+0x26c/0x2b0
 [<c10231e5>] ? get_parent_ip+0xb/0x31
 [<c1023287>] ? sub_preempt_count+0x7c/0x89
 [<c1279f5f>] ? mutex_lock_nested+0x295/0x2b0
 [<f82815f1>] ? sr_block_ioctl+0x2e/0x9a [sr_mod]
 [<f8281612>] sr_block_ioctl+0x4f/0x9a [sr_mod]
 [<f82815c3>] ? sr_block_check_events+0x13/0x13 [sr_mod]
 [<c10f39ee>] __blkdev_driver_ioctl+0x22/0x2e
 [<c10f42f5>] blkdev_ioctl+0x66d/0x68c
 [<c104bf7e>] ? __lock_acquire+0x62e/0x14bb
 [<c10b1861>] block_ioctl+0x32/0x3a
 [<c10b1861>] ? block_ioctl+0x32/0x3a
 [<c10b182f>] ? bd_set_size+0x67/0x67
 [<c109bfd5>] do_vfs_ioctl+0x481/0x4b7
 [<c1090993>] ? fget_light+0x4c/0xd0
 [<c109c039>] sys_ioctl+0x2e/0x49
 [<c127bb50>] sysenter_do_call+0x12/0x36


Second test with USB CD-ROM:
-----------------------------------------------------------------
  - attach CD-ROM drive
-----------------------------------------------------------------
scsi4 : usb-storage 1-5:1.0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 4:0:0:0: CD-ROM		PLEXTOR  DVDR	PX-716A   1.08 PQ: 0 ANSI: 0 CCS
sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 4:0:0:0: Attached scsi CD-ROM sr1
sr 4:0:0:0: Attached scsi generic sg2 type 5
-----------------------------------------------------------------
  - start grip
  - detach CD-ROM drive
-----------------------------------------------------------------
usb 1-5: USB disconnect, device number 7
-----------------------------------------------------------------
  - hit grip's eject button
-----------------------------------------------------------------
BUG: unable to handle kernel NULL pointer dereference at 00000024
IP: [<c10f636a>] __blk_send_generic.clone.9+0x21/0x70
*pde = 00000000
Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: usb_storage netconsole snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nfs lockd sunrpc sr_mod i2c_i801 sg cdrom applesmc input_polldev rtc snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_pcm snd_timer snd sky2 snd_page_alloc

Pid: 2845, comm: grip Not tainted 3.2.0-rc7 #1 Apple Computer, Inc. Macmini1,1/Mac-F4208EC8
EIP: 0060:[<c10f636a>] EFLAGS: 00010246 CPU: 1
EIP is at __blk_send_generic.clone.9+0x21/0x70
EAX: 00000000 EBX: 00000000 ECX: 00000006 EDX: c10ef095
ESI: f3f3ca68 EDI: f1d55bf0 EBP: f1625d78 ESP: f1625d68
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process grip (pid: 2845, ti=f1624000 task=f3043760 task.ti=f1624000)
Stack:
 00000003 f3f3ca68 fffffffa 00000005 f1625e18 c10f6711 c150ede4 0000005d
 f1d55bf0 00000000 f3043ac4 f1625e08 00000046 00000282 f1625dc8 f1625df4
 00000000 f1625db8 f829b200 00000000 c150ede4 00000001 0000022d f3043702

Call Trace:
 [<c10f6711>] scsi_cmd_ioctl+0x358/0x373
 [<f829b200>] ? sr_packet+0x1a/0x3b [sr_mod]
 [<f81f71dd>] cdrom_ioctl+0x26/0xb31 [cdrom]
 [<c1279f36>] ? mutex_lock_nested+0x26c/0x2b0
 [<c10231e5>] ? get_parent_ip+0xb/0x31
 [<c1023287>] ? sub_preempt_count+0x7c/0x89
 [<c1279f5f>] ? mutex_lock_nested+0x295/0x2b0
 [<f829b5f1>] ? sr_block_ioctl+0x2e/0x9a [sr_mod]
 [<f829b612>] sr_block_ioctl+0x4f/0x9a [sr_mod]
 [<f829b5c3>] ? sr_block_check_events+0x13/0x13 [sr_mod]
 [<c10f39ee>] __blkdev_driver_ioctl+0x22/0x2e
 [<c10f42f5>] blkdev_ioctl+0x66d/0x68c
 [<c104bf7e>] ? __lock_acquire+0x62e/0x14bb
 [<c10b1861>] block_ioctl+0x32/0x3a
 [<c10b1861>] ? block_ioctl+0x32/0x3a
 [<c10b182f>] ? bd_set_size+0x67/0x67
 [<c109bfd5>] do_vfs_ioctl+0x481/0x4b7
 [<c1090993>] ? fget_light+0x4c/0xd0
 [<c109c039>] sys_ioctl+0x2e/0x49
 [<c127bb50>] sysenter_do_call+0x12/0x36
 [<c1270000>] ? pcibios_scan_specific_bus+0x43/0x72
Code: 8d 65 f4 89 f0 5b 5e 5f c9 c3 55 89 e5 57 89 d7 56 ba 01 00 00 00 53 89 c6 83 ec 04 89 4d f0 b9 10 00 00 00 e8 d8 8c ff ff 89 c3 40 24 02 00 00 00 c7 80 c0 00 00 00 60 ea 00 00 89 d9 8b 80
EIP: [<c10f636a>] __blk_send_generic.clone.9+0x21/0x70 SS:ESP 0068:f1625d68
CR2: 0000000000000024
---[ end trace 41f5b857579a5ae9 ]---

-- 
Stefan Richter
-=====-==-== ==-- ==--=
http://arcgraph.de/sr/
