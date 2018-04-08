From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Sun, 08 Apr 2018 21:07:12 +0200
Message-ID: <2679696.GDoj5zcZOu@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5jL8oLV2xvjBVYv_SNXr74LdgpXEmU7K+cLYpD7jh2chgw@mail.gmail.com> <CAGXu5j+mVc6O_=GOF3YQmS4QZxeFgVPQtMxNH8sjBAhpJLjm9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+mVc6O_=GOF3YQmS4QZxeFgVPQtMxNH8sjBAhpJLjm9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, paolo.valente@linaro.org
List-Id: linux-scsi@vger.kernel.org

Hi.

Cc'ing linux-block people (mainly, Christoph) too because of 17cb960f29c2. 
Also, duplicating the initial statement for them.

With v4.16 (and now with v4.16.1) it is possible to trigger usercopy whitelist 
warning and/or bug while doing smartctl on a SATA disk having blk-mq and BFQ 
enabled. The warning looks like this:

===
[  574.997022] Bad or missing usercopy whitelist? Kernel memory exposure 
attempt detected from SLUB object 'scsi_sense_cache' (offset 76, size 22)!
[  575.017332] WARNING: CPU: 0 PID: 32436 at mm/usercopy.c:81 usercopy_warn
+0x7d/0xa0
[  575.025262] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel 
kvm bochs_drm iTCO_wdt ttm irqbypass iTCO_vendor_support ppdev drm_kms_helper 
psmouse parport_pc i2c_i801 joydev pcspkr drm parport rtc_cmos mousedev 
input_leds led_class intel_agp evdev syscopyarea qemu_fw_cfg intel_gtt 
sysfillrect mac_hid lpc_ich sysimgblt agpgart fb_sys_fops ip_tables x_tables 
xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c 
crc32c_generic dm_crypt algif_skcipher af_alg hid_generic usbhid hid dm_mod 
raid10 md_mod sr_mod sd_mod cdrom uhci_hcd crct10dif_pclmul crc32_pclmul 
crc32c_intel ghash_clmulni_intel pcbc serio_raw xhci_pci ahci atkbd libps2 
ehci_pci xhci_hcd aesni_intel libahci aes_x86_64 ehci_hcd crypto_simd 
glue_helper cryptd libata usbcore usb_common i8042 serio virtio_scsi scsi_mod
[  575.068775]  virtio_blk virtio_net virtio_pci virtio_ring virtio
[  575.073935] CPU: 0 PID: 32436 Comm: smartctl Not tainted 4.16.0-pf2 #1
[  575.078078] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 
02/06/2015
[  575.082451] RIP: 0010:usercopy_warn+0x7d/0xa0
[  575.086223] RSP: 0018:ffff9ca84aee7c40 EFLAGS: 00010286
[  575.097637] RAX: 0000000000000000 RBX: ffff95199d68304c RCX: 
0000000000000001
[  575.101471] RDX: 0000000000000001 RSI: ffffffffaeeb050a RDI: 
00000000ffffffff
[  575.105939] RBP: 0000000000000016 R08: 0000000000000000 R09: 
000000000000028b
[  575.110370] R10: ffffffffaee854e9 R11: 0000000000000001 R12: 
0000000000000001
[  575.113269] R13: ffff95199d683062 R14: ffff95199d68304c R15: 
0000000000000016
[  575.116132] FS:  00007f993d405040(0000) GS:ffff95199f600000(0000) knlGS:
0000000000000000
[  575.119285] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  575.129619] CR2: 00007ffe2390f0a8 CR3: 000000001d774004 CR4: 
0000000000160ef0
[  575.133976] Call Trace:
[  575.136311]  __check_object_size+0x12f/0x1a0
[  575.139576]  sg_io+0x269/0x3f0
[  575.142000]  ? path_lookupat+0xaa/0x1f0
[  575.144521]  ? current_time+0x18/0x70
[  575.147006]  scsi_cmd_ioctl+0x257/0x410
[  575.149782]  ? xfs_bmapi_read+0x1c3/0x340 [xfs]
[  575.161441]  sd_ioctl+0xbf/0x1a0 [sd_mod]
[  575.165036]  blkdev_ioctl+0x8ca/0x990
[  575.168291]  ? read_null+0x10/0x10
[  575.171638]  block_ioctl+0x39/0x40
[  575.174998]  do_vfs_ioctl+0xa4/0x630
[  575.178261]  ? vfs_write+0x164/0x1a0
[  575.181410]  SyS_ioctl+0x74/0x80
[  575.190904]  do_syscall_64+0x74/0x190
[  575.195200]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[  575.199267] RIP: 0033:0x7f993c984d87
[  575.201350] RSP: 002b:00007ffe238aeed8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  575.204386] RAX: ffffffffffffffda RBX: 00007ffe238af180 RCX: 
00007f993c984d87
[  575.208349] RDX: 00007ffe238aeef0 RSI: 0000000000002285 RDI: 
0000000000000003
[  575.211254] RBP: 00007ffe238af1d0 R08: 0000000000000010 R09: 
0000000000000000
[  575.220511] R10: 0000000000000000 R11: 0000000000000246 R12: 
00005637ec8e9ce0
[  575.225238] R13: 0000000000000000 R14: 00005637ec8e3550 R15: 
00000000000000da
[  575.230056] Code: 6c e4 ae 41 51 48 c7 c0 19 6e e5 ae 49 89 f1 48 0f 44 c2 
48 89 f9 4d 89 d8 4c 89 d2 48 c7 c7 70 6e e5 ae 48 89 c6 e8 c3 5c e5 ff <0f> 
0b 48 83 c4 18 c3 48 c7 c6 04 cb e4 ae 49 89 f1 49 89 f3 eb 
[  575.239027] ---[ end trace 6e3293933bdd4761 ]---
===

Usually, the warning is triggered first, and all the subsequent printouts are 
bugs because offset gets too big so that it doesn't fit into a real SLAB 
object size:

[ 1687.609889] usercopy: Kernel memory exposure attempt detected from SLUB 
object 'scsi_sense_cache' (offset 107, size 22)!
[ 1687.614197] ------------[ cut here ]------------
[ 1687.615993] kernel BUG at mm/usercopy.c:100!

To give you an idea regarding variety of offsets, I've summarised the kernel 
log from my server:

$ sudo journalctl -kb | grep "Kernel memory exposure attempt detected" | 
grep -oE 'offset [0-9]+, size [0-9]+' | sort | uniq -c
       9 offset 107, size 22
       6 offset 108, size 22
       8 offset 109, size 22
       7 offset 110, size 22
       5 offset 111, size 22
       5 offset 112, size 22
       2 offset 113, size 22
       2 offset 114, size 22
       1 offset 115, size 22
       1 offset 116, size 22
       1 offset 119, size 22
       1 offset 85, size 22

So far, I wasn't able to trigger this with mq-deadline (or without blk-mq). 
Maybe, this has something to do with blk-mq+BFQ re-queuing, or it's just me 
not being persistent enough.

It looks like this code path was re-written completely with 17cb960f29c2, but 
it went merged for the upcoming v4.17 only, and thus I haven't tried it yet.

Kees took a brief look at it already: [1]. This is what smartctl does [2] 
(just a usual strace capture when the bug is not triggered).

Christoph, do you have some idea on why this can happen?

Thanks.

Regards,
  Oleksandr

[1] https://marc.info/?l=linux-scsi&m=152287333013845&w=2
[2] https://gist.github.com/pfactum/6f58f8891468aeba1ab2cc9f45668735
