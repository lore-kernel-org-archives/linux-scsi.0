From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: usercopy whitelist woe in scsi_sense_cache
Date: Wed, 04 Apr 2018 21:07:06 +0200
Message-ID: <10360653.ov98egbaqx@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi, Kees, David et al.

With v4.16 I get the following dump while using smartctl:

===
[  261.260617] ------------[ cut here ]------------
[  261.262135] Bad or missing usercopy whitelist? Kernel memory exposure 
attempt detected from SLUB object 'scsi_sense_cache' (offset 94, size 22)!
[  261.267672] WARNING: CPU: 2 PID: 27041 at mm/usercopy.c:81 usercopy_warn
+0x7e/0xa0
[  261.273624] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel 
kvm iTCO_wdt ppdev irqbypass bochs_drm ttm iTCO_vendor_support drm_kms_helper 
drm psmouse input_leds led_class pcspkr joydev intel_agp parport_pc mousedev 
evdev syscopyarea intel_gtt i2c_i801 sysfillrect parport rtc_cmos sysimgblt 
qemu_fw_cfg mac_hid agpgart fb_sys_fops lpc_ich ip_tables x_tables xfs 
dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c 
crc32c_generic dm_crypt algif_skcipher af_alg dm_mod raid10 md_mod hid_generic 
usbhid hid sr_mod cdrom sd_mod crct10dif_pclmul uhci_hcd crc32_pclmul 
crc32c_intel ghash_clmulni_intel pcbc serio_raw ahci atkbd aesni_intel 
xhci_pci aes_x86_64 ehci_pci libahci crypto_simd libps2 glue_helper xhci_hcd 
ehci_hcd libata cryptd usbcore usb_common i8042 serio virtio_scsi scsi_mod
[  261.300752]  virtio_blk virtio_net virtio_pci virtio_ring virtio
[  261.305534] CPU: 2 PID: 27041 Comm: smartctl Not tainted 4.16.0-1-ARCH #1
[  261.309936] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 
02/06/2015
[  261.313668] RIP: 0010:usercopy_warn+0x7e/0xa0
[  261.315653] RSP: 0018:ffffab5aca6cfc40 EFLAGS: 00010286
[  261.320038] RAX: 0000000000000000 RBX: ffff8e8cd893605e RCX: 
0000000000000001
[  261.322215] RDX: 0000000080000001 RSI: ffffffff83eb4672 RDI: 
00000000ffffffff
[  261.325680] RBP: 0000000000000016 R08: 0000000000000000 R09: 
0000000000000282
[  261.328462] R10: ffffffff83e896b1 R11: 0000000000000001 R12: 
0000000000000001
[  261.330584] R13: ffff8e8cd8936074 R14: ffff8e8cd893605e R15: 
0000000000000016
[  261.332748] FS:  00007f5a81bdf040(0000) GS:ffff8e8cdf700000(0000) knlGS:
0000000000000000
[  261.337929] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  261.343128] CR2: 00007fff3a6790a8 CR3: 0000000018228006 CR4: 
0000000000160ee0
[  261.345976] Call Trace:
[  261.350620]  __check_object_size+0x130/0x1a0
[  261.355775]  sg_io+0x269/0x3f0
[  261.360729]  ? path_lookupat+0xaa/0x1f0
[  261.364027]  ? current_time+0x18/0x70
[  261.366684]  scsi_cmd_ioctl+0x257/0x410
[  261.369871]  ? xfs_bmapi_read+0x1c3/0x340 [xfs]
[  261.372231]  sd_ioctl+0xbf/0x1a0 [sd_mod]
[  261.375456]  blkdev_ioctl+0x8ca/0x990
[  261.381156]  ? read_null+0x10/0x10
[  261.384984]  block_ioctl+0x39/0x40
[  261.388739]  do_vfs_ioctl+0xa4/0x630
[  261.392624]  ? vfs_write+0x164/0x1a0
[  261.396658]  SyS_ioctl+0x74/0x80
[  261.399563]  do_syscall_64+0x74/0x190
[  261.402685]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[  261.414154] RIP: 0033:0x7f5a8115ed87
[  261.417184] RSP: 002b:00007fff3a65a458 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  261.427362] RAX: ffffffffffffffda RBX: 00007fff3a65a700 RCX: 
00007f5a8115ed87
[  261.432075] RDX: 00007fff3a65a470 RSI: 0000000000002285 RDI: 
0000000000000003
[  261.436200] RBP: 00007fff3a65a750 R08: 0000000000000010 R09: 
0000000000000000
[  261.446689] R10: 0000000000000000 R11: 0000000000000246 R12: 
000055b5481d9ce0
[  261.450059] R13: 0000000000000000 R14: 000055b5481d3550 R15: 
00000000000000da
[  261.455103] Code: 48 c7 c0 f1 af e5 83 48 0f 44 c2 41 50 51 41 51 48 89 f9 
49 89 f1 4d 89 d8 4c 89 d2 48 89 c6 48 c7 c7 48 b0 e5 83 e8 32 a7 e3 ff <0f> 
0b 48 83 c4 18 c3 48 c7 c6 44 0d e5 83 49 89 f1 49 89 f3 eb 
[  261.467988] ---[ end trace 75034b3832c364e4 ]---
===

I can easily reproduce it with a qemu VM and 2 virtual SCSI disks by calling 
smartctl in a loop and doing some usual background I/O. The warning is 
triggered within 3 minutes or so (not instantly).

Initially, it was produced on my server after a kernel update (because disks 
are monitored with smartctl via Zabbix).

Looks like the thing was introduced with 
0afe76e88c57d91ef5697720aed380a339e3df70.

Any idea how to deal with this please? If needed, I can provide any additional 
info, and also I'm happy/ready to test any proposed patches.

Thanks.

Regards,
  Oleksandr
