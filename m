From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: OOPS: unplugging western digital passport drive
Date: Tue, 17 Mar 2015 21:36:48 -0400
Message-ID: <5508D6B0.3010806@stratus.com>
References: <CAFrYPTP4gEBjwn2w+UVyx85OyFTU0u+JeHVTS5NKjGVE=q0TLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:57102 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbbCRCjQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 22:39:16 -0400
In-Reply-To: <CAFrYPTP4gEBjwn2w+UVyx85OyFTU0u+JeHVTS5NKjGVE=q0TLA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?U3RhbmlzxYJhdyBQaXR1Y2hh?= <viraptor@gmail.com>, linux-scsi@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>

On 03/11/2015 12:25 AM, Stanis=C5=82aw Pitucha wrote:
> Hi linux-scsi,
> I've got another case of reproducible crash when unplugging western
> digital passport drives. This was mentioned before in
> http://www.spinics.net/lists/linux-scsi/msg82603.html
>=20
> Is there any way I can get a more correct stacktrace of the original
> bug without changing/recompiling the kernel? (or with?)
>=20
> My last log from oops is:
>=20
> [ 3343.469871]: usb 4-1: USB disconnect, device number 3
> [ 3343.521948]: BUG: unable to handle kernel NULL pointer dereference
> at 00000000000001a0
> [ 3343.522052]: IP: [<ffffffff81285405>] blk_post_runtime_resume+0x65=
/0x80
> [ 3343.522131]: PGD 0
> [ 3343.522159]: Oops: 0002 [#1] PREEMPT SMP
> [ 3343.522215]: Modules linked in: nls_utf8 hfsplus ses enclosure uas
> usb_storage rfcomm fuse ctr ccm bnep ecb btusb bluetooth uvcvideo
> videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videode=
v
> joydev media mousedev iTCO_wdt iTCO_vendor_support arc4 coretemp
> intel_rapl x86_pkg_temp_thermal intel_powerclamp iwldvm kvm_intel
> mac80211 kvm evdev mac_hid psmouse serio_raw pcspkr snd_hda_codec_hdm=
i
> iwlwifi snd_hda_codec_realtek i2c_i801 snd_hda_codec_generic
> rtsx_pci_ms i915 snd_hda_intel memstick snd_hda_controller cfg80211
> snd_hda_codec r8169 snd_hwdep mii snd_pcm drm_kms_helper snd_timer
> lpc_ich shpchp drm thinkpad_acpi intel_gtt i2c_algo_bit nvram mei_me
> i2c_core snd mei soundcore led_class rfkill hwmon tpm_tis tpm battery
> wmi thermal video button processor ac sch_fq_codel usbhid
> hid_logitech_dj
> [ 3343.523406]:  hid_generic hid nfs lockd grace sunrpc fscache ext4
> crc16 mbcache jbd2 sha256_ssse3 sha256_generic algif_skcipher af_alg
> dm_crypt dm_mod sr_mod cdrom sd_mod rtsx_pci_sdmmc atkbd mmc_core
> libps2 crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
> ahci libahci aesni_intel aes_x86_64 lrw gf128mul glue_helper
> ablk_helper cryptd libata xhci_pci ehci_pci scsi_mod xhci_hcd ehci_hc=
d
> rtsx_pci usbcore usb_common i8042 serio
> [ 3343.523825]: CPU: 1 PID: 22490 Comm: kworker/1:0 Not tainted 3.18.=
6-1-ARCH #1
> [ 3343.523882]: Hardware name: LENOVO 2481CTO/2481CTO, BIOS
> G3ET36WW(1.10) 06/20/2012
> [ 3343.523953]: Workqueue: usb_hub_wq hub_event [usbcore]
> [ 3343.523997]: task: ffff880211fd5080 ti: ffff8801971bc000 task.ti:
> ffff8801971bc000
> [ 3343.524054]: RIP: 0010:[<ffffffff81285405>]  [<ffffffff81285405>]
> blk_post_runtime_resume+0x65/0x80
> [ 3343.524131]: RSP: 0018:ffff8801971bf8c8  EFLAGS: 00010092
> [ 3343.524173]: RAX: 0000000000000000 RBX: ffff880211ca1698 RCX:
> 0000000000000000
> [ 3343.524228]: RDX: 00000001000dea0f RSI: 0000000000000009 RDI:
> ffff880211ca1698
> [ 3343.524283]: RBP: ffff8801971bf8d8 R08: 0000000000000000 R09:
> ffff880216c3f000
> [ 3343.524338]: R10: ffff88021f256db0 R11: ffffea0002987d40 R12:
> 0000000000000000
> [ 3343.524392]: R13: 0000000000000000 R14: ffff88020df7b428 R15:
> 0000000000000004
> [ 3343.524448]: FS:  0000000000000000(0000) GS:ffff88021f240000(0000)
> knlGS:0000000000000000
> [ 3343.524509]: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3343.524554]: CR2: 00000000000001a0 CR3: 0000000001811000 CR4:
> 00000000001407e0
> [ 3343.524609]: Stack:
> [ 3343.524628]:  ffff8802123fe968 0000000000000000 ffff8801971bf908
> ffffffffa0119564
> [ 3343.524695]:  ffff8801971bf910 ffff8802123fe968 ffff8802123fea16
> ffffffffa01194e0
> [ 3343.524762]:  ffff8801971bf938 ffffffff813c4636 ffff8800a61f5780
> ffff8802123fe968
> [ 3343.524828]: Call Trace:
> [ 3343.524866]:  [<ffffffffa0119564>] scsi_runtime_resume+0x84/0xd0 [=
scsi_mod]
> [ 3343.524930]:  [<ffffffffa01194e0>] ?
> scsi_autopm_put_device+0x20/0x20 [scsi_mod]
> [ 3343.524990]:  [<ffffffff813c4636>] __rpm_callback+0x36/0x90
> [ 3343.525035]:  [<ffffffff813c46b6>] rpm_callback+0x26/0xa0
> [ 3343.525079]:  [<ffffffff813c5ad1>] rpm_resume+0x4b1/0x690
> [ 3343.525124]:  [<ffffffff813c5cf0>] __pm_runtime_resume+0x40/0x60
> [ 3343.525177]:  [<ffffffff813bb569>] __device_release_driver+0x29/0x=
f0
> [ 3343.525228]:  [<ffffffff813bb653>] device_release_driver+0x23/0x30
> [ 3343.525277]:  [<ffffffff813baf08>] bus_remove_device+0x108/0x180
> [ 3343.525325]:  [<ffffffff813b7249>] device_del+0x129/0x1f0
> [ 3343.525378]:  [<ffffffffa01170ed>] __scsi_remove_device+0xcd/0xe0 =
[scsi_mod]
> [ 3343.525442]:  [<ffffffffa0115484>] scsi_forget_host+0x64/0x70 [scs=
i_mod]
> [ 3343.525502]:  [<ffffffffa010970b>] scsi_remove_host+0x7b/0x130 [sc=
si_mod]
> [ 3343.525558]:  [<ffffffffa0902419>] usb_stor_disconnect+0x59/0xd0
> [usb_storage]
> [ 3343.525625]:  [<ffffffffa007f878>] usb_unbind_interface+0x1f8/0x2c=
0 [usbcore]
> [ 3343.525682]:  [<ffffffff813c5293>] ? rpm_idle+0x23/0x340
> [ 3343.525729]:  [<ffffffff813bb5bf>] __device_release_driver+0x7f/0x=
f0
> [ 3343.525779]:  [<ffffffff813bb653>] device_release_driver+0x23/0x30
> [ 3343.525828]:  [<ffffffff813baf08>] bus_remove_device+0x108/0x180
> [ 3343.525876]:  [<ffffffff813b7249>] device_del+0x129/0x1f0
> [ 3343.528574]:  [<ffffffffa007cd81>] usb_disable_device+0x91/0x290 [=
usbcore]
> [ 3343.531302]:  [<ffffffffa00721b4>] usb_disconnect+0x94/0x2d0 [usbc=
ore]
> [ 3343.533981]:  [<ffffffffa00743fa>] hub_event+0x66a/0x1640 [usbcore=
]
> [ 3343.536657]:  [<ffffffff81550f08>] ? __schedule+0x3e8/0xa50
> [ 3343.539275]:  [<ffffffff8108b845>] process_one_work+0x145/0x400
> [ 3343.541919]:  [<ffffffff8108be0b>] worker_thread+0x6b/0x480
> [ 3343.544524]:  [<ffffffff8108bda0>] ? init_pwq.part.22+0x10/0x10
> [ 3343.547108]:  [<ffffffff81090e6a>] kthread+0xea/0x100
> [ 3343.549708]:  [<ffffffff81090d80>] ? kthread_create_on_node+0x1c0/=
0x1c0
> [ 3343.552384]:  [<ffffffff8155563c>] ret_from_fork+0x7c/0xb0
> [ 3343.555353]:  [<ffffffff81090d80>] ? kthread_create_on_node+0x1c0/=
0x1c0
> [ 3343.558225]: Code: 41 5c 5d c3 66 90 48 89 df c7 83 e8 04 00 00 00
> 00 00 00 e8 de eb ff ff 48 8b 83 e0 04 00 00 48 8b 15 00 ec 65 00 be
> 09 00 00 00 <48> 89 90 a0 01 00 00 48 8b bb e0 04 00 00 e8 28 0f 14 0=
0
> eb b3
> [ 3343.563429]: RIP  [<ffffffff81285405>] blk_post_runtime_resume+0x6=
5/0x80
> [ 3343.565800]:  RSP <ffff8801971bf8c8>
> [ 3343.568107]: CR2: 00000000000001a0
> [ 3343.583852]: ---[ end trace 1d6502d52258b48f ]---
> [ 3343.583858]: note: kworker/1:0[22490] exited with preempt_count 1
> [ 3343.583976]: BUG: unable to handle kernel paging request at ffffff=
ffffffffd8
> [ 3343.586210]: IP: [<ffffffff81091530>] kthread_data+0x10/0x20
>=20

Hi Stanis=C5=82aw,

The backtrace that you generated looks like it has enough information t=
o
start some debug.  I'm not familiar with runtime suspend, but here's=20
some initial analysis.

The crash occurred in blk_post_runtime_resume, 0x65 instruction bytes=20
in.  The NULL pointer dereference at 00000000000001a0 suggests that it
was attempting to read 0x1a0 bytes offset from a NULL pointer.  (Or the
pointer itself held an address of 0x1a0, but that's less likely.)

If you could determine which source line <ffffffff81285405>
blk_post_runtime_resume+0x65 corresponds to that would be helpful.  The
easiest way to figure that out would be to find or build a debuginfo
vmlinux of your 3.18.6-1-ARCH kernel.  Then run add2line as described
here:

http://stackoverflow.com/questions/13468286/how-to-read-a-linux-kernel-=
panic

=46rom a fresh v3.18 build on my desktop, I found a similar offset (0x1=
a8)
of RAX in pm_runtime_mark_last_busy:

% objdump -DS block/blk-core.o

=2E..
static inline void pm_runtime_mark_last_busy(struct device *dev)
{      =20
        ACCESS_ONCE(dev->power.last_busy) =3D jiffies;
    438d:       48 89 90 a8 01 00 00    mov    %rdx,0x1a8(%rax)
        return __pm_runtime_resume(dev, RPM_ASYNC);
}
=2E..

which is called by blk_post_runtime_resume, as your backtrace shows:

void blk_post_runtime_resume(struct request_queue *q, int err)
{      =20
        spin_lock_irq(q->queue_lock);
        if (!err) {
                q->rpm_status =3D RPM_ACTIVE;
                __blk_run_queue(q);
                pm_runtime_mark_last_busy(q->dev);
                pm_request_autosuspend(q->dev);
        } else {
                q->rpm_status =3D RPM_SUSPENDED;
        }
        spin_unlock_irq(q->queue_lock);
}

so perhaps the device structure has been freed and/or set NULL before/
while blk_post_runtime_resume was invoked.

Start out by figuring out what <ffffffff81285405>
blk_post_runtime_resume+0x65 is referring to, either assembly or
preferrably .c source code line and we can go from there.

-- Joe
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
