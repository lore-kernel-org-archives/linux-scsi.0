From: "Mike R." <turbanator1@verizon.net>
Subject: Oopses with SCSI emulation for USB Mass-Storage
Date: Sat, 21 Aug 2004 19:27:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4127DA63.8030908@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out006pub.verizon.net ([206.46.170.106]:60118 "EHLO
	out006.verizon.net") by vger.kernel.org with ESMTP id S268014AbUHUX07
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 19:26:59 -0400
Received: from [192.168.0.2] ([68.237.218.208]) by out006.verizon.net
          (InterMail vM.5.01.06.06 201-253-122-130-106-20030910) with ESMTP
          id <20040821232656.XBGB22385.out006.verizon.net@[192.168.0.2]>
          for <linux-scsi@vger.kernel.org>; Sat, 21 Aug 2004 18:26:56 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This should be of interest. You may have seen something about this 
forwarded to here by Alan Stern.

Here's the output of /sbin/lspci:

00:00.0 Host bridge: VIA Technologies, Inc. VT82C693A/694x [Apollo 
PRO133x] (rev c4)
00:01.0 PCI bridge: VIA Technologies, Inc. VT82C598/694x [Apollo 
MVP3/Pro133x AGP]
00:04.0 ISA bridge: VIA Technologies, Inc. VT82C596 ISA [Mobile South] 
(rev 23)
00:04.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C/VT8235 PIPC Bus Master IDE (rev 10)
00:04.2 USB Controller: VIA Technologies, Inc. VT6202 [USB 2.0 
controller] (rev 11)
00:04.3 Host bridge: VIA Technologies, Inc. VT82C596 Power Management 
(rev 30)
00:0a.0 Ethernet controller: Accton Technology Corporation SMC2-1211TX 
(rev 10)
00:0b.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 08)
00:0b.1 Input device controller: Creative Labs SB Live! MIDI/Game Port 
(rev 08)
00:0c.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:0c.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)
01:00.0 VGA compatible controller: nVidia Corporation NV25 [GeForce4 Ti 
4200] (rev a3)

This are two oopses:

Aug 21 13:12:29 opiate kernel: SCSI error: host 1 id 0 lun 0 return code 
= 4000000
Aug 21 13:12:29 opiate kernel: ^ISense class 0, sense error 0, extended 
sense 0
Aug 21 13:12:29 opiate kernel: Unable to handle kernel paging request at 
virtual address 6e697
463
Aug 21 13:12:29 opiate kernel:  printing eip:
Aug 21 13:12:29 opiate kernel: c01f85af
Aug 21 13:12:29 opiate kernel: *pde = 00000000
Aug 21 13:12:29 opiate kernel: Oops: 0000 [#1]
Aug 21 13:12:29 opiate kernel: PREEMPT
Aug 21 13:12:29 opiate kernel: Modules linked in: usb_storage 
snd_pcm_oss snd_mixer_oss snd_em
u10k1 snd_rawmidi snd_pcm snd_timer snd_seq_device snd_ac97_codec 
snd_page_alloc snd_util_mem
snd_hwdep snd nvidia
Aug 21 13:12:29 opiate kernel: CPU:    0
Aug 21 13:12:29 opiate kernel: EIP:    0060:[<c01f85af>]    Tainted: P
Aug 21 13:12:29 opiate kernel: EFLAGS: 00210047   (2.6.8.1)
Aug 21 13:12:29 opiate kernel: EIP is at as_insert_request+0x8f/0x180
Aug 21 13:12:29 opiate kernel: eax: 6e697463   ebx: d7c11ba0   ecx: 
00000001   edx: 00000000
Aug 21 13:12:29 opiate kernel: esi: d7ef14b0   edi: 00000000   ebp: 
00000000   esp: c88f3d48
Aug 21 13:12:29 opiate kernel: ds: 007b   es: 007b   ss: 0068
Aug 21 13:12:29 opiate kernel: Process growisofs (pid: 966, 
threadinfo=c88f3000 task=c8a97830)
Aug 21 13:12:29 opiate kernel: Stack: 00200082 c88f3d74 00200082 
c0320198 d7c418ec d7ef14b0 00
000001 00200202
Aug 21 13:12:29 opiate kernel:        c01efe65 d7c418ec d7ef14b0 
00000001 d7ef14b0 00000001 d7
c418ec c01f2657
Aug 21 13:12:29 opiate kernel:        d7c418ec d7ef14b0 00000001 
00000000 c88f3de0 d7ef1400 c0
332d40 c88f3ea0
Aug 21 13:12:29 opiate kernel: Call Trace:
Aug 21 13:12:29 opiate kernel:  [<c01efe65>] __elv_add_request+0x45/0xb0
Aug 21 13:12:29 opiate kernel:  [<c01f2657>] blk_insert_request+0x77/0xe0
Aug 21 13:12:29 opiate kernel:  [<c0225c38>] 
scsi_insert_special_req+0x38/0x40
Aug 21 13:12:29 opiate kernel:  [<c0225ea8>] scsi_wait_req+0x68/0xa0
Aug 21 13:12:29 opiate kernel:  [<c0225db0>] scsi_wait_done+0x0/0x90
Aug 21 13:12:29 opiate kernel:  [<c022c132>] sr_do_ioctl+0x92/0x2a0
Aug 21 13:12:29 opiate kernel:  [<c022be25>] sr_packet+0x25/0x40
Aug 21 13:12:29 opiate kernel:  [<c02365f5>] cdrom_get_disc_info+0x65/0xc0
Aug 21 13:12:29 opiate kernel:  [<c02324fb>] cdrom_mrw_exit+0x1b/0x70
Aug 21 13:12:29 opiate kernel:  [<c02320e4>] unregister_cdrom+0x94/0xe0
Aug 21 13:12:29 opiate kernel:  [<c022be82>] sr_kref_release+0x42/0x70
Aug 21 13:12:29 opiate kernel:  [<c01ccb38>] kref_put+0x18/0x20
Aug 21 13:12:29 opiate kernel:  [<c022b3a9>] sr_block_release+0x69/0x80
Aug 21 13:12:29 opiate kernel:  [<c015528a>] blkdev_put+0x17a/0x1a0
Aug 21 13:12:29 opiate kernel:  [<c014d920>] __fput+0x110/0x130
Aug 21 13:12:29 opiate kernel:  [<c014bfb9>] filp_close+0x59/0x90
Aug 21 13:12:29 opiate kernel:  [<c01182b4>] put_files_struct+0x64/0xd0
Aug 21 13:12:29 opiate kernel:  [<c011904b>] do_exit+0x18b/0x410
Aug 21 13:12:29 opiate kernel:  [<c011937a>] do_group_exit+0x3a/0xb0
Aug 21 13:12:29 opiate kernel:  [<c010405b>] syscall_call+0x7/0xb
Aug 21 13:12:29 opiate kernel: Code: 8b 10 89 72 04 89 16 89 46 04 89 30 
90 8d 74 26 00 89 74
24
Aug 21 13:12:29 opiate kernel:  <6>note: growisofs[966] exited with 
preempt_count 2

Aug 21 13:41:39 opiate kernel: scsi0 (0:0): rejecting I/O to dead device
Aug 21 13:41:39 opiate last message repeated 2 times
Aug 21 13:41:39 opiate kernel: SCSI error: host 0 id 0 lun 0 return code 
= 4000000
Aug 21 13:41:39 opiate kernel: ^ISense class 0, sense error 0, extended 
sense 0
Aug 21 13:41:39 opiate kernel: ^ISense class 0, sense error 0, extended 
sense 0
Aug 21 13:41:39 opiate kernel: Unable to handle kernel paging request at 
virtual address 6e697
463
Aug 21 13:41:39 opiate kernel:  printing eip:
Aug 21 13:41:39 opiate kernel: c01f85af
Aug 21 13:41:39 opiate kernel: *pde = 00000000
Aug 21 13:41:39 opiate kernel: Oops: 0000 [#1]
Aug 21 13:41:39 opiate kernel: PREEMPT
Aug 21 13:41:39 opiate kernel: Modules linked in: snd_pcm_oss snd_pcm 
snd_timer snd_page_alloc
  snd_mixer_oss snd usb_storage nvidia
Aug 21 13:41:39 opiate kernel: CPU:    0
Aug 21 13:41:39 opiate kernel: EIP:    0060:[<c01f85af>]    Tainted: P
Aug 21 13:41:39 opiate kernel: EFLAGS: 00210047   (2.6.8.1)
Aug 21 13:41:39 opiate kernel: EIP is at as_insert_request+0x8f/0x180
Aug 21 13:41:39 opiate kernel: eax: 6e697463   ebx: d7fac7c0   ecx: 
00000001   edx: 00000000
Aug 21 13:41:39 opiate kernel: esi: d7fe5ab0   edi: 00000000   ebp: 
00000000   esp: c4f04d84
Aug 21 13:41:39 opiate kernel: ds: 007b   es: 007b   ss: 0068
Aug 21 13:41:39 opiate kernel: Process growisofs (pid: 431, 
threadinfo=c4f04000 task=c4915870)
Aug 21 13:41:39 opiate kernel: Stack: 00200086 c4f04db0 00200086 
c0320198 d7c4102c d7fe5ab0 00
000001 00200202
Aug 21 13:41:39 opiate kernel:        c01efe65 d7c4102c d7fe5ab0 
00000001 d7fe5ab0 00000001 d7
c4102c c01f2657
Aug 21 13:41:39 opiate kernel:        d7c4102c d7fe5ab0 00000001 
00000000 c4f04e1c d7fe5a00 c0
332d40 c4f04edc
Aug 21 13:41:39 opiate kernel: Call Trace:
Aug 21 13:41:39 opiate kernel:  [<c01efe65>] __elv_add_request+0x45/0xb0
Aug 21 13:41:39 opiate kernel:  [<c01f2657>] blk_insert_request+0x77/0xe0
Aug 21 13:41:39 opiate kernel:  [<c0225c38>] 
scsi_insert_special_req+0x38/0x40
Aug 21 13:41:39 opiate kernel:  [<c0225ea8>] scsi_wait_req+0x68/0xa0
Aug 21 13:41:39 opiate kernel:  [<c0225db0>] scsi_wait_done+0x0/0x90
Aug 21 13:41:39 opiate kernel:  [<c022c132>] sr_do_ioctl+0x92/0x2a0
Aug 21 13:41:39 opiate kernel:  [<c022be25>] sr_packet+0x25/0x40
Aug 21 13:41:39 opiate kernel:  [<c02365f5>] cdrom_get_disc_info+0x65/0xc0
Aug 21 13:41:39 opiate kernel:  [<c02324fb>] cdrom_mrw_exit+0x1b/0x70
Aug 21 13:41:39 opiate kernel:  [<c02320e4>] unregister_cdrom+0x94/0xe0
Aug 21 13:41:39 opiate kernel:  [<c022be82>] sr_kref_release+0x42/0x70
Aug 21 13:41:39 opiate kernel:  [<c01ccb38>] kref_put+0x18/0x20
Aug 21 13:41:39 opiate kernel:  [<c022b3a9>] sr_block_release+0x69/0x80
Aug 21 13:41:39 opiate kernel:  [<c015528a>] blkdev_put+0x17a/0x1a0
Aug 21 13:41:39 opiate kernel:  [<c014d920>] __fput+0x110/0x130
Aug 21 13:41:39 opiate kernel:  [<c014bfb9>] filp_close+0x59/0x90
Aug 21 13:41:39 opiate kernel:  [<c014c051>] sys_close+0x61/0xa0
Aug 21 13:41:39 opiate kernel:  [<c010405b>] syscall_call+0x7/0xb
Aug 21 13:41:39 opiate kernel: Code: 8b 10 89 72 04 89 16 89 46 04 89 30 
90 8d 74 26 00 89 74
24
Aug 21 13:41:39 opiate kernel:  <6>note: growisofs[431] exited with 
preempt_count 2
Aug 21 13:41:39 opiate kernel: bad: scheduling while atomic!
Aug 21 13:41:39 opiate kernel:  [<c02cee65>] schedule+0x4c5/0x4d0
Aug 21 13:41:39 opiate kernel:  [<c013cfc3>] unmap_page_range+0x53/0x80
Aug 21 13:41:39 opiate kernel:  [<c013d1a6>] unmap_vmas+0x1b6/0x1d0
Aug 21 13:41:39 opiate kernel:  [<c014140d>] exit_mmap+0x7d/0x160
Aug 21 13:41:39 opiate kernel:  [<c0114de5>] mmput+0x65/0x90
Aug 21 13:41:39 opiate kernel:  [<c0119012>] do_exit+0x152/0x410
Aug 21 13:41:39 opiate kernel:  [<c0111c40>] do_page_fault+0x0/0x56d
Aug 21 13:41:39 opiate kernel:  [<c0105189>] die+0xf9/0x100
Aug 21 13:41:39 opiate kernel:  [<c0111e1e>] do_page_fault+0x1de/0x56d
Aug 21 13:41:39 opiate kernel:  [<c0112d68>] recalc_task_prio+0xa8/0x1a0
Aug 21 13:41:39 opiate kernel:  [<c0112ec2>] activate_task+0x62/0x80
Aug 21 13:41:39 opiate kernel:  [<c0112fc6>] try_to_wake_up+0xa6/0xc0
Aug 21 13:41:39 opiate kernel:  [<c0111c40>] do_page_fault+0x0/0x56d
Aug 21 13:41:39 opiate kernel:  [<c0104a65>] error_code+0x2d/0x38
Aug 21 13:41:39 opiate kernel:  [<c01f85af>] as_insert_request+0x8f/0x180
Aug 21 13:41:39 opiate kernel:  [<c01efe65>] __elv_add_request+0x45/0xb0
Aug 21 13:41:39 opiate kernel:  [<c01f2657>] blk_insert_request+0x77/0xe0
Aug 21 13:41:39 opiate kernel:  [<c0225c38>] 
scsi_insert_special_req+0x38/0x40
Aug 21 13:41:39 opiate kernel:  [<c0225ea8>] scsi_wait_req+0x68/0xa0
Aug 21 13:41:39 opiate kernel:  [<c0225db0>] scsi_wait_done+0x0/0x90
Aug 21 13:41:39 opiate kernel:  [<c022c132>] sr_do_ioctl+0x92/0x2a0
Aug 21 13:41:39 opiate kernel:  [<c022be25>] sr_packet+0x25/0x40
Aug 21 13:41:39 opiate kernel:  [<c02365f5>] cdrom_get_disc_info+0x65/0xc0
Aug 21 13:41:39 opiate kernel:  [<c02324fb>] cdrom_mrw_exit+0x1b/0x70
Aug 21 13:41:39 opiate kernel:  [<c02320e4>] unregister_cdrom+0x94/0xe0
Aug 21 13:41:39 opiate kernel:  [<c022be82>] sr_kref_release+0x42/0x70
Aug 21 13:41:39 opiate kernel:  [<c01ccb38>] kref_put+0x18/0x20
Aug 21 13:41:39 opiate kernel:  [<c022b3a9>] sr_block_release+0x69/0x80
Aug 21 13:41:39 opiate kernel:  [<c015528a>] blkdev_put+0x17a/0x1a0
Aug 21 13:41:39 opiate kernel:  [<c014d920>] __fput+0x110/0x130
Aug 21 13:41:39 opiate kernel:  [<c014bfb9>] filp_close+0x59/0x90
Aug 21 13:41:39 opiate kernel:  [<c014c051>] sys_close+0x61/0xa0
Aug 21 13:41:39 opiate kernel:  [<c010405b>] syscall_call+0x7/0xb
Aug 21 13:41:39 opiate kernel: sr0: scsi-1 drive
Aug 21 13:52:37 opiate kernel: Emergency Sync complete
Aug 21 13:52:42 opiate kernel: Emergency Sync complete


