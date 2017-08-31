From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH 0/9] block/scsi: safe SCSI quiescing
Date: Thu, 31 Aug 2017 20:31:54 +0200
Message-ID: <14328863.IIXMb7O2AM@natalenko.name>
References: <20170831172728.15817-1-ming.lei@redhat.com> <1576539.niWZoWEnd8@natalenko.name> <20170831173833.GC5928@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:45166 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdHaSb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 14:31:57 -0400
In-Reply-To: <20170831173833.GC5928@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>

Tested against v4.13-rc7. With this patchset it looks like I/O doesn't hang=
,=20
but once (just once, not each time) I've got the following stacktrace on=20
resume:

=3D=3D=3D
[   55.577173] ata1.00: Security Log not supported
[   55.580690] ata1.00: configured for UDMA/100
[   55.582257] ------------[ cut here ]------------
[   55.583924] usb 1-1: reset high-speed USB device number 2 using xhci_hcd
[   55.587489] WARNING: CPU: 3 PID: 646 at lib/percpu-refcount.c:361=20
percpu_ref_reinit+0x21/0x80
[   55.590073] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat iTCO_wdt=
=20
kvm_intel bochs_drm ppdev kvm ttm iTCO_vendor_support drm_kms_helper irqbyp=
ass=20
8139too input_leds drm evdev psmouse led_class pcspkr syscopyarea joydev=20
sysfillrect lpc_ich 8139cp parport_pc sysimgblt mousedev intel_agp i2c_i801=
=20
fb_sys_fops mii mac_hid intel_gtt parport qemu_fw_cfg button sch_fq_codel=20
ip_tables x_tables xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_buf=
io=20
libcrc32c crc32c_generic algif_skcipher af_alg dm_crypt dm_mod dax raid10=20
md_mod sr_mod cdrom sd_mod hid_generic usbhid hid uhci_hcd crct10dif_pclmul=
=20
crc32_pclmul crc32c_intel ghash_clmulni_intel virtio_rng ahci xhci_pci=20
serio_raw pcbc ehci_pci xhci_hcd rng_core atkbd libps2 libahci ehci_hcd lib=
ata=20
aesni_intel aes_x86_64 crypto_simd glue_helper cryptd
[   55.611580]  usbcore virtio_pci scsi_mod usb_common virtio_ring virtio=20
i8042 serio
[   55.614305] CPU: 3 PID: 646 Comm: kworker/u8:23 Not tainted 4.13.0-pf1 #1
[   55.616611] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0=
=2E0=20
02/06/2015
[   55.619903] Workqueue: events_unbound async_run_entry_fn
[   55.621888] task: ffff88001b271e00 task.stack: ffffc90000a2c000
[   55.623674] RIP: 0010:percpu_ref_reinit+0x21/0x80
[   55.625751] RSP: 0000:ffffc90000a2fdb0 EFLAGS: 00010002
[   55.628687] RAX: 0000000000000002 RBX: ffff88001dd80768 RCX:=20
ffff88001dd80758
[   55.631475] RDX: 0000000000000001 RSI: 0000000000000212 RDI:=20
ffffffff81f3e2f0
[   55.633694] RBP: ffffc90000a2fdc0 R08: 0000000cc61e7800 R09:=20
ffff88001f9929c0
[   55.637144] R10: ffffffffffec3296 R11: 7fffffffffffffff R12:=20
0000000000000246
[   55.642456] R13: ffff88001f410800 R14: ffff88001f414300 R15:=20
0000000000000000
[   55.644832] FS:  0000000000000000(0000) GS:ffff88001f980000(0000) knlGS:
0000000000000000
[   55.647388] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.649608] CR2: 00000000ffffffff CR3: 000000001aa50000 CR4:=20
00000000001406e0
[   55.652688] Call Trace:
[   55.654597]  blk_unfreeze_queue+0x2f/0x50
[   55.656794]  scsi_device_resume+0x28/0x70 [scsi_mod]
[   55.659059]  scsi_dev_type_resume+0x38/0x90 [scsi_mod]
[   55.660875]  async_sdev_resume+0x15/0x20 [scsi_mod]
[   55.662564]  async_run_entry_fn+0x36/0x150
[   55.664241]  process_one_work+0x1de/0x430
[   55.666018]  worker_thread+0x47/0x3f0
[   55.667387]  kthread+0x125/0x140
[   55.672740]  ? process_one_work+0x430/0x430
[   55.674971]  ? kthread_create_on_node+0x70/0x70
[   55.677110]  ret_from_fork+0x25/0x30
[   55.679098] Code: 5b 41 5c 5d c3 0f 1f 44 00 00 55 48 89 e5 41 54 53 48 =
89=20
fb 48 c7 c7 f0 e2 f3 81 e8 0a de 32 00 49 89 c4 48 8b 43 08 a8 03 75 42 <0f=
>=20
ff 48 83 63 08 fd 65 ff 05 31 7d cc 7e 48 8b 53 08 f6 c2 03=20
[   55.684822] ---[ end trace dbbf5aed3cf35331 ]---
[   55.714306] PM: resume of devices complete after 500.175 msecs
[   55.717299] OOM killer enabled.
=3D=3D=3D

Here:

=3D=3D=3D
355 void percpu_ref_reinit(struct percpu_ref *ref)
356 {
357     unsigned long flags;
358=20
359     spin_lock_irqsave(&percpu_ref_switch_lock, flags);
360=20
361     WARN_ON_ONCE(!percpu_ref_is_zero(ref));   // <--
362=20
363     ref->percpu_count_ptr &=3D ~__PERCPU_REF_DEAD;
364     percpu_ref_get(ref);
365     __percpu_ref_switch_mode(ref, NULL);
366=20
367     spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
368 }
=3D=3D=3D

On =C4=8Dtvrtek 31. srpna 2017 19:38:34 CEST Ming Lei wrote:
> On Thu, Aug 31, 2017 at 07:34:06PM +0200, Oleksandr Natalenko wrote:
> > Since I'm in CC, does this series aim to replace 2 patches I've tested
> > before:
> >=20
> > blk-mq: add requests in the tail of hctx->dispatch
> > blk-mq: align to legacy's implementation of blk_execute_rq
> >=20
> > ?
>=20
> Yeah, this solution is more generic, and the old one in above
> two patches may run into the same deadlock inevitably.
>=20
> Oleksandr, could you test this patchset and provide the feedback?
>=20
> BTW, it fixes the I/O hang in my raid10 test, but I just write
> 'devices' to pm_test.
>=20
> Thanks!
