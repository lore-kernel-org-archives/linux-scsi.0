From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH v11 0/7] block, scsi, md: Improve suspend and resume
Date: Thu, 09 Nov 2017 07:16:52 +0100
Message-ID: <15255980.N0RxqQ3jgM@natalenko.name>
References: <20171030224205.25212-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171030224205.25212-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>
List-Id: linux-scsi@vger.kernel.org

Bart,

is this something known to you, or it is just my fault applying this series=
 to=20
v4.13? Except having this warning, suspend/resume works for me:

=3D=3D=3D
[   27.383846] sd 0:0:0:0: [sda] Starting disk
[   27.383976] sd 1:0:0:0: [sdb] Starting disk
[   27.451218] sdb: Attempt to allocate non-preempt request in preempt-only=
=20
mode.
[   27.459640] ------------[ cut here ]------------
[   27.464521] WARNING: CPU: 0 PID: 172 at block/blk-core.c:823=20
blk_queue_enter+0x222/0x280
[   27.470867] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_inte=
l=20
iTCO_wdt bochs_drm iTCO_vendor_support ppdev kvm ttm irqbypass evdev=20
input_leds drm_kms_helper joydev psmouse led_class lpc_ich pcspkr i2c_i801=
=20
mousedev parport_pc mac_hid qemu_fw_cfg drm parport syscopyarea sysfillrect=
=20
sysimgblt button fb_sys_fops intel_agp intel_gtt sch_fq_codel ip_tables=20
x_tables xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc3=
2c=20
crc32c_generic dm_crypt algif_skcipher af_alg dm_mod dax raid10 md_mod sr_m=
od=20
sd_mod cdrom hid_generic usbhid hid crct10dif_pclmul crc32_pclmul crc32c_in=
tel=20
ghash_clmulni_intel uhci_hcd pcbc serio_raw atkbd libps2 ahci aesni_intel=20
xhci_pci ehci_pci aes_x86_64 crypto_simd glue_helper xhci_hcd ehci_hcd liba=
hci=20
cryptd libata usbcore usb_common i8042 serio virtio_pci
[   27.501799]  virtio_net virtio_scsi scsi_mod virtio_ring virtio
[   27.503639] CPU: 0 PID: 172 Comm: md0_raid10 Not tainted 4.13.0-pf13 #1
[   27.505492] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0=
=2E0=20
02/06/2015
[   27.507693] task: ffff88001f6aa340 task.stack: ffffc900005e8000
[   27.509516] RIP: 0010:blk_queue_enter+0x222/0x280
[   27.511623] RSP: 0018:ffffc900005ebb70 EFLAGS: 00010282
[   27.512978] RAX: 0000000000000042 RBX: 0000000000000000 RCX:=20
0000000000000000
[   27.514389] RDX: 0000000000000000 RSI: ffff88001f80dbd8 RDI:=20
ffff88001f80dbd8
[   27.516339] RBP: ffffc900005ebbd0 R08: 000000000000028e R09:=20
0000000000000000
[   27.519083] R10: ffffc900005ebc50 R11: 00000000ffffffff R12:=20
0000000100000000
[   27.521298] R13: ffff88001deaa100 R14: 0000000000000000 R15:=20
ffff88001deaa100
[   27.523577] FS:  0000000000000000(0000) GS:ffff88001f800000(0000) knlGS:
0000000000000000
[   27.525889] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.527928] CR2: 00005568d4d27858 CR3: 000000001983b000 CR4:=20
00000000001406f0
[   27.529721] Call Trace:
[   27.530622]  ? wait_woken+0x80/0x80
[   27.531739]  generic_make_request+0xf1/0x320
[   27.532806]  submit_bio+0x73/0x150
[   27.533775]  ? submit_bio+0x73/0x150
[   27.534773]  md_super_write.part.58+0xbd/0xe0 [md_mod]
[   27.536078]  md_update_sb.part.59+0x534/0x840 [md_mod]
[   27.537468]  ? percpu_ref_switch_to_percpu+0x36/0x40
[   27.538862]  md_check_recovery+0x452/0x510 [md_mod]
[   27.540273]  raid10d+0x62/0x1420 [raid10]
[   27.541757]  ? schedule+0x3d/0xb0
[   27.542744]  ? schedule+0x3d/0xb0
[   27.544013]  ? schedule_timeout+0x208/0x390
[   27.546399]  md_thread+0x120/0x160 [md_mod]
[   27.548810]  ? md_thread+0x120/0x160 [md_mod]
[   27.550394]  ? wait_woken+0x80/0x80
[   27.551840]  kthread+0x124/0x140
[   27.551846]  ? state_show+0x2f0/0x2f0 [md_mod]
[   27.551848]  ? kthread_create_on_node+0x70/0x70
[   27.551852]  ? SyS_exit_group+0x14/0x20
[   27.551857]  ret_from_fork+0x25/0x30
[   27.551859] Code: 00 00 e9 6d fe ff ff 31 c0 e9 66 fe ff ff 49 8b 87 e0 =
01=20
00 00 48 c7 c7 78 73 95 81 c6 05 6c 11 80 00 01 48 8b 30 e8 0f 0f de ff <0f=
>=20
ff e9 97 fe ff ff 49 8b b7 a8 01 00 00 89 c2 83 e6 20 0f 85=20
[   27.551882] ---[ end trace ba6164315560503f ]---
[   27.701328] ata4: SATA link down (SStatus 0 SControl 300)
[   27.710425] ata5: SATA link down (SStatus 0 SControl 300)
[   27.714620] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   27.722375] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   27.733520] ata6: SATA link down (SStatus 0 SControl 300)
[   27.738315] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   27.743962] ata3.00: configured for UDMA/100
[   27.747153] ata2.00: configured for UDMA/100
[   27.750833] ata1.00: configured for UDMA/100
[   27.781627] usb 2-1: reset high-speed USB device number 2 using xhci_hcd
[   27.963142] PM: resume of devices complete after 627.949 msecs
[   27.971546] OOM killer enabled.
[   27.978424] Restarting tasks ... done.
=3D=3D=3D

Thanks.

On pond=C4=9Bl=C3=AD 30. =C5=99=C3=ADjna 2017 23:41:58 CET Bart Van Assche =
wrote:
> It is known that during the resume following a hibernate, especially when
> using an md RAID1 array created on top of SCSI devices, sometimes the sys=
tem
> hangs instead of coming up properly. This patch series fixes that
> problem. These patches have been tested on top of the block layer for-next
> branch. Please consider these changes for kernel v4.15.

> Changes between v10 and v11:
> - Left out the three md patches because a deadlock was reported when using
> XFS on top of md RAID 1. This deadlock occurred because the md kernel
> thread got frozen before the kernel thread running xfsaild().
> - Left out the blk_queue_enter() / blk_queue_exit() changes from
>   block/blk-timeout.c because a recent patch removed these calls from
>   blk_timeout_work().
> - Retested the whole series.
