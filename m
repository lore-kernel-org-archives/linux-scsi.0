From: Patrick Mochel <mochel@osdl.org>
Subject: Oops + schedule while atomic + slab poisoning
Date: Sun, 20 Jul 2003 08:50:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0307200846030.22018-100000@cherise>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:37054 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267260AbTGTPbT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jul 2003 11:31:19 -0400
Received: from cherise.pdx.osdl.net (cherise.pdx.osdl.net [172.20.1.70])
	by mail.osdl.org (8.11.6/8.11.6) with ESMTP id h6KFkJI08855
	for <linux-scsi@vger.kernel.org>; Sun, 20 Jul 2003 08:46:19 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Happens when trying to mount a usb-storage device (compact flash reader) 
under the latest BK tree. The backtraces are below. 

Any suggestions? 

Thanks,


	-pat

Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi removable disk sdb at scsi1, channel 0, id 0, lun 0
sdb : READ CAPACITY failed.
sdb : status=0, message=00, host=7, driver=00 
sdb : sense not available. 
sdb: Write Protect is off
sdb: Mode Sense: 00 00 00 00
usb 1-1: USB disconnect, address 2
drivers/scsi/scsi.c:265: spin_is_locked on uninitialized spinlock 
c4332ad0.
Unable to handle kernel paging request at virtual address 6b6b6b6b
 printing eip:
c01d24ab
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c01d24ab>]    Not tainted
EFLAGS: 00010097
EIP is at vsnprintf+0x20b/0x430
eax: 6b6b6b6b   ebx: c0404403   ecx: 6b6b6b6b   edx: fffffffe
esi: ffffffff   edi: c2775d44   ebp: ffffffff   esp: c2775cf4
ds: 007b   es: 007b   ss: 0068
Process mount (pid: 686, threadinfo=c2774000 task=c3bce380)
Stack: 00000000 c04047df 0000000a 0000019b c04043e0 00000046 00000286 
c012378c 
       c04043e0 00000400 c8d4a992 c2775d38 6b6b6b6b 6b6b6b6b c27f0b84 
c8d3f445 
       c8d4a980 c8d48d52 00000109 6b6b6b6b c4332ad0 6b6b6b6b 6b6b6b6b 
6b6b6b6b 
Call Trace:
 [<c012378c>] printk+0x13c/0x310
 [<c8d3f445>] scsi_put_command+0x95/0x290 [scsi_mod]
 [<c8d44bc1>] scsi_next_command+0x11/0x20 [scsi_mod]
 [<c8d44112>] scsi_wait_req+0xd2/0xe0 [scsi_mod]
 [<c011c6be>] try_to_wake_up+0x38e/0x3a0
 [<c011d6d9>] default_wake_function+0x19/0x20
 [<c8d45e8e>] __scsi_mode_sense+0xde/0x200 [scsi_mod]
 [<c8d2c040>] sd_read_cache_type+0x30/0x170 [sd_mod]
 [<c8d2c25d>] sd_revalidate_disk+0xdd/0x110 [sd_mod]
 [<c018b5a4>] __invalidate_device+0x44/0x50
 [<c01748f6>] check_disk_change+0x46/0x60
 [<c8d2b302>] sd_open+0x52/0xc0 [sd_mod]
 [<c0174bab>] do_open+0x1fb/0x640
 [<c0175095>] blkdev_open+0x25/0x30
 [<c01685e0>] dentry_open+0x100/0x1f0
 [<c014deda>] kmem_cache_alloc+0x9a/0x140
 [<c01684cd>] filp_open+0x4d/0x60
 [<c0168bb5>] sys_open+0x35/0x70
 [<c0109c9f>] syscall_call+0x7/0xb

Code: 80 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 f6 04 24 10 89 c6 
 <6>note: mount[686] exited with preempt_count 3
bad: scheduling while atomic!
Call Trace:
 [<c011d09d>] schedule+0x3d/0x610
 [<c0155610>] unmap_vmas+0x1e0/0x2f0
 [<c015a713>] exit_mmap+0xe3/0x260
 [<c012055c>] mmput+0xdc/0x100
 [<c0125c0b>] do_exit+0x28b/0x820
 [<c011b315>] do_page_fault+0x315/0x44d
 [<c011d6d9>] default_wake_function+0x19/0x20
 [<c011d720>] __wake_up_common+0x40/0x60
 [<c012be24>] mod_timer+0x514/0x6b0
 [<c011c6be>] try_to_wake_up+0x38e/0x3a0
 [<c011b000>] do_page_fault+0x0/0x44d
 [<c010a6a9>] error_code+0x2d/0x38
 [<c01d24ab>] vsnprintf+0x20b/0x430
 [<c012378c>] printk+0x13c/0x310
 [<c8d3f445>] scsi_put_command+0x95/0x290 [scsi_mod]
 [<c8d44bc1>] scsi_next_command+0x11/0x20 [scsi_mod]
 [<c8d44112>] scsi_wait_req+0xd2/0xe0 [scsi_mod]
 [<c011c6be>] try_to_wake_up+0x38e/0x3a0
 [<c011d6d9>] default_wake_function+0x19/0x20
 [<c8d45e8e>] __scsi_mode_sense+0xde/0x200 [scsi_mod]
 [<c8d2c040>] sd_read_cache_type+0x30/0x170 [sd_mod]
 [<c8d2c25d>] sd_revalidate_disk+0xdd/0x110 [sd_mod]
 [<c018b5a4>] __invalidate_device+0x44/0x50
 [<c01748f6>] check_disk_change+0x46/0x60
 [<c8d2b302>] sd_open+0x52/0xc0 [sd_mod]
 [<c0174bab>] do_open+0x1fb/0x640
 [<c0175095>] blkdev_open+0x25/0x30
 [<c01685e0>] dentry_open+0x100/0x1f0
 [<c014deda>] kmem_cache_alloc+0x9a/0x140
 [<c01684cd>] filp_open+0x4d/0x60
 [<c0168bb5>] sys_open+0x35/0x70
 [<c0109c9f>] syscall_call+0x7/0xb

hub 1-0:0: debounce: port 1: delay 100ms stable 4 status 0x101
hub 1-0:0: new USB device on port 1, assigned address 3
scsi2 : SCSI emulation for USB Mass Storage devices
Slab corruption: start=c4332a9c, expend=c4332e9b, problemat=c4332ad8
Last user: [<c01d02a9>](kset_hotplug+0x349/0x360)
Data: ************************************************************6A 
*****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************!
 
*********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************A5 
Next: 71 F0 2C .A9 02 1D C0 A5 C2 0F 17 A8 2E 33 C4 A8 2E 33 C4 00 00 00 
00 50 AD 23 C0 B0 AE 23 C0 
slab error in check_poison_obj(): cache `size-1024': object was modified 
after freeing
Call Trace:
 [<c014c2d9>] check_poison_obj+0x189/0x1a0
 [<c014ded1>] kmem_cache_alloc+0x91/0x140
 [<c8d45c8c>] scsi_alloc_queue+0x1c/0xb0 [scsi_mod]
 [<c014deda>] kmem_cache_alloc+0x9a/0x140
 [<c8d45c8c>] scsi_alloc_queue+0x1c/0xb0 [scsi_mod]
 [<c01940b6>] simple_lookup+0x16/0x20
 [<c8d462dc>] scsi_alloc_sdev+0xfc/0x200 [scsi_mod]
 [<c8d46d27>] scsi_probe_and_add_lun+0x27/0x120 [scsi_mod]
 [<c8d48233>] scsi_proc_host_add+0x83/0xe0 [scsi_mod]
 [<c8d46ff5>] scsi_scan_target+0x35/0x70 [scsi_mod]
 [<c8d4707b>] scsi_scan_host+0x4b/0x70 [scsi_mod]
 [<c8d55c13>] storage_probe+0x1a3/0x1e0 [usb_storage]
 [<c02597ee>] usb_device_probe+0x6e/0xa0
 [<c0230394>] bus_match+0x34/0x60
 [<c023041a>] device_attach+0x5a/0x80
 [<c0230596>] bus_add_device+0x66/0xb0
 [<c022ef8c>] device_add+0xbc/0xf0
 [<c025ab1b>] usb_new_device+0x49b/0x4e0
 [<c025d076>] hub_port_connect_change+0x236/0x2c0
 [<c025d349>] hub_events+0x249/0x4a0
 [<c011d43f>] schedule+0x3df/0x610
 [<c025d5c5>] hub_thread+0x25/0xe0
 [<c011d6c0>] default_wake_function+0x0/0x20
 [<c025d5a0>] hub_thread+0x0/0xe0
 [<c0107225>] kernel_thread_helper+0x5/0x10

  Vendor: SIIG      Model: CompactFlash Car  Rev: 0113
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdb: 125953 512-byte hdwr sectors (64 MB)
sdb: Write Protect is off
sdb: Mode Sense: 06 00 00 00
SCSI device sdb: drive cache: write through


