From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: kernel BUG at cfq-iosched.c triggered by EMC multipathing
Date: Tue, 02 Feb 2010 09:22:29 -0600
Message-ID: <1265124149.2800.41.camel@mulgrave.site>
References: <87tytzllva.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tytzllva.fsf@tac.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ferenc Wagner <wferi@niif.hu>
Cc: Eddie Williams <Eddie.Williams@steeleye.com>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I don't see this on the SCSI reflector, so I suspect the size of the
attachments was over the limit; trimming for a resend.

On Tue, 2010-02-02 at 16:04 +0100, Ferenc Wagner wrote:
> Far too often, but not always, a blade server freezes during boot.  My
> feeling is that it happens more often when a (slow) Serial Over LAN
> console connection is active, but I've got no hard data on this.  The
> system is booted from SAN, using an Adaptec FC BIOS feature, but the
> freeze always happens in the initramfs phase, when udev's discovering
> the devices.  All this on a mostly up to date Debian Sid i686 system
> under a 2.6.32.3-based Debian kernel (2.6.32-5).  Sorry for the
> somewhat
> broken logs, this is what the Bladecenter SOL gave me...
> 
> [   33.344207] sd 0:0:0:2: emc: detected Clariion CX3-40f, flags 0
> [   33.344274] sd 0:0:0:0: [sdd] Assuming drive cache: write through
> [   33.344281] sd 0:0:0:0: [sdd] Attached SCSI disk
> [   33.445033] sd 0:0:0:2: emc: connected to SP A Port 3 (bound,
> default SP B)
> [   33.487579] sd 0:0:1:0: emc: detected Clariion CX3-40f, flags 0
> [   33.524301] sd 0:0:1:0: emc: connected to SP B Port 3 (owned,
> default SP B)
> [   33.566418] sd 2:0:1:0: emc: detected Clariion CX3-40f, flags 0
> [   33.603504] sd 2:0:1:0: emc: connected to SP B Port 2 (owned,
> default SP B)
> [   33.645902] sd 2:0:1:2: emc: detected Clariion CX3-40f, flags 0
> [   33.681606] sd 2:0:1:2: emc: connected to SP B Port 2 (owned,
> default SP B)
> [   33.723554] sd 0:0:1:2: emc: detected Clariion CX3-40f, flags 0
> [   33.759484] sd 0:0:1:2: emc: connected to SP B Port 3 (owned,
> default SP B)
> [   33.801231] emc: device handler registered
> [   33.830450] device-mapper: multipath round-robin: version 1.0.0
> loaded
> [   33.869763] sd 2:0:1:0: emc: at SP B Port 2 (owned, default SP B)
> [   33.908577] sd 0:0:1:0: emc: at SP B Port 3 (owned, default SP B)
> [   33.945720] ------------[ cut here ]------------
> [   33.949646] kernel BUG
> at /tmp/buildd/linux-2.6-2.6.32/debian/build/source_i386_none/block/cfq-iosched.c:2329!

Without exact source, it's hard to be certain, but I'd suspect this bug
on:

static void cfq_put_queue(struct cfq_queue *cfqq)
{
	struct cfq_data *cfqd = cfqq->cfqd;
	struct cfq_group *cfqg, *orig_cfqg;

	BUG_ON(atomic_read(&cfqq->ref) <= 0);


> [   33.949646] invalid opcode: 0000 [#1] SMP 
> [   33.949646] last sysfs
> file: /sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/0000:06:01.0/host0/rport-0:0-1/target0:0:1/fc_transport/target0:0:1/node_name
> [   33.949646] Modules linked in: dm_round_robin scsi_dh_emc sd_mod
> crc_t10dif dm_multipath dm_mod scsi_dh uhci_hcd ehci_hcd
> ide_pci_generic ata_generic qla2xxx mptspi mptscsih mptbase libata
> scsi_transport_fc scsi_transport_spi piix scsi_tgt scsi_mod tg3 button
> libphy ide_core usbcore nls_base thermal fan thermal_sys [last
> unloaded: scsi_wait_scan]
> [   33.949646] 
> [   33.949646] Pid: 329, comm: kmpath_handlerd Not tainted
> (2.6.32-trunk-686 #1) IBM BladeCenter HS20 -[884321Y]-
> [   33.949646] EIP: 0060:[<c112c454>] EFLAGS: 00010046 CPU: 0
> [   33.949646] EIP is at cfq_put_request+0x1c/0x4a
> [   33.949646] EAX: 00000000 EBX: f6676e10 ECX: c112c438 EDX: 0000000d
> [   33.949646] ESI: f6fd9700 EDI: f60194c0 EBP: 00000001 ESP: f64a3ed4
> [   33.949646]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   33.949646] Process kmpath_handlerd (pid: 329, ti=f64a2000
> task=f64e8440 task.ti=f64a2000)
> [   33.949646] Stack:
> [   33.949646]  f6676e10 01282c4f c111bb19 c1122618 f60194c0 f6676e10
> 00000292 c1122ad3
> [   33.949646] <0> f607f70c f83842cb 00000000 f8383491 f607f610
> f666bc00 f666bc00 f6676e10
> [   33.949646] <0> 00000000 00000003 00000000 f607f600 f666bc00
> f607f60c f8383761 00000000
> [   33.949646] Call Trace:
> [   33.949646]  [<c111bb19>] ? elv_put_request+0x10/0x11
> [   33.949646]  [<c1122618>] ? __blk_put_request+0x60/0x8e
> [   33.949646]  [<c1122ad3>] ? blk_put_request+0x1e/0x2e
> [   33.949646]  [<f8383491>] ? send_trespass_cmd+0x21c/0x226
> [scsi_dh_emc]
> [   33.949646]  [<f8383761>] ? clariion_activate+0x3b/0xeb
> [scsi_dh_emc]

So best guess would be a reference counting error in the way scsi_dh_emc
sends trespass commands.

> [   33.[   98.784502] BUG: soft lockup - CPU#1 stuck for 61s!
> [scsi_id:700]
> [   98.784502] Modules linked in: dm_round_robin scsi_dh_emc sd_mod
> crc_t10dif dm_multipath dm_mod scsi_dh uhci_hcd ehci_hcd
> ide_pci_generic ata_generic qla2xxx mptspi mptscsih mptbase libata
> scsi_transport_fc scsi_transport_spi piix scsi_tgt scsi_mod tg3 button
> libphy ide_core usbcore nls_base thermal fan thermal_sys [last
> unloaded: scsi_wait_scan]
> [   98.784502] 
> [   98.784502] Pid: 700, comm: scsi_id Tainted: G      D
> (2.6.32-trunk-686 #1) IBM BladeCenter HS20 -[884321Y]-
> [   98.784502] EIP: 0060:[<c125aeca>] EFLAGS: 00000293 CPU: 1
> [   98.784502] EIP is at lock_kernel+0x22/0x33
> [   98.784502] EAX: 00003331 EBX: f6944600 ECX: f6c01070 EDX: 00000000
> [   98.784502] ESI: fffffff4 EDI: f6944600 EBP: f6093950 ESP: f611de68
> [   98.784502]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   98.784502] CR0: 8005003b CR2: 0804a8e0 CR3: 35d74000 CR4: 000006d0
> [   98.784502] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   98.784502] DR6: ffff0ff0 DR7: 00000400
> [   98.784502] Call Trace:
> [   98.784502]  [<c10d0cc5>] ? __blkdev_get+0x3e/0x2cc
> [   98.784502]  [<c10b8da6>] ? __link_path_walk+0x505/0x5bf
> [   98.784502]  [<c10d0fba>] ? blkdev_open+0x60/0x8b
> [   98.784502]  [<c10b059b>] ? __dentry_open+0x156/0x246
> [   98.784502]  [<c10b071c>] ? nameidata_to_filp+0x29/0x3c
> [   98.784502]  [<c10d0f5a>] ? blkdev_open+0x0/0x8b
> [   98.784502]  [<c10ba621>] ? do_filp_open+0x41d/0x7e0
> [   98.784502]  [<c109b1bc>] ? handle_mm_fault+0x3c6/0x847
> [   98.784502]  [<c10a4691>] ? free_pages_and_swap_cache+0x3b/0x48
> [   98.784502]  [<c10c22a1>] ? alloc_fd+0x52/0xb7
> [   98.784502]  [<c10b0353>] ? do_sys_open+0x4c/0xdf
> [   98.784502]  [<c10b042a>] ? sys_open+0x1e/0x23
> [   98.784502]  [<c10031dc>] ? syscall_call+0x7/0xb
> 
> and the same soft lockup messages keep repeating for both CPUs.
> 
> Here is another very similar case, with truncated output again:
> 
> 18.430416] device-mapper: uevent: version 1.0.3
>  ... Begin: Runn[   18.459246] device-mapper: ioctl: 4.15.0-ioctl
> (2009-04-01) initialised: dm-devel@redhat.com
> ing /scripts/loc[   18.520650] device-mapper: multipath: version 1.1.0
> loaded
> al-top ... Begin: Loading multip[   18.574110] sd 1:0:0:0: emc:
> detected Clariion CX3-40f, flags 0
> ath modules ... [   18.610974] sd 1:0:0:0: emc: connected to SP A Port
> 2 (bound, default SP B)
> Success: loaded [   18.660875] sd 1:0:0:2: emc: detected Clariion
> CX3-40f, flags 0
> module dm-multip[   18.704472] sd 1:0:0:2: emc: connected to SP A Port
> 2 (bound, default SP B)
> ath.
> Failure: f[   18.754298] emc: device handler registered
> ailed to load mo[   18.789165] device-mapper: multipath round-robin:
> version 1.0.0 loaded
> dule dm-emc.
> done.
> Begin: Disc[   18.849378] ------------[ cut here ]------------
> overing multipat[   18.853314] kernel BUG
> at /tmp/buildd/linux-2.6-2.6.32/debian/build/source_i386_none/block/cfq-iosched.c:2329!
> [   18.853314] invalid opcode: 0000 [#1] hs ... done.
> SMP 
> [   18.853314] last sysfs
> file: /sys/devices/virtual/block/dm-1/dm/suspended
> [   18.853314] Modules linked in: dm_round_robin scsi_dh_emc
> dm_multipath dm_mod scsi_dh sd_mod crc_t10dif uhci_hcd ehci_hcd
> ide_pci_generic ata_generic libata qla2xxx piix scsi_transport_fc
> mptspi mptscsih mptbase scsi_transport_spi tg3 libphy scsi_tgt usbcore
> nls_base scsi_mod ide_core button thermal fan thermal_sys [last
> unloaded: scsi_wait_scan]
> [   18.853314] 
> [   18.853314] Pid: 341, comm: kmpath_handlerd Not tainted
> (2.6.32-trunk-686 #1) IBM BladeCenter HS20 -[884321Y]-
> [   18.853314] EIP: 0060:[<c112c454>] EFLAGS: 00010046 CPU: 0
> [   18.853314] EIP is at cfq_put_request+0x1c/0x4a
> [   18.853314] EAX: 00000000 EBX: f6ff87d0 ECX: c112c438 EDX: 0000000d
> [   18.853314] ESI: f64ec1c0 EDI: f67f8000 EBP: 00000001 ESP: f6055ed4
> [   18.853314]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   18.853314] Process kmpath_handlerd (pid: 341, ti=f6054000
> task=f64a8cc0 task.ti=f6054000)
> [   18.853314] Stack:
> [   18.853314]  f6ff87d0 01282c4f c111bb19 c1122618 f67f8000 f6ff87d0
> 00000292 c1122ad3
> [   18.853314] <0> f605eb0c f839d2cb 00000000 f839c491 f605ea10
> f6d36c00 f6d36c00 f6ff87d0
> [   18.853314] <0> c1259c36 c1364ba0 00000000 f605ea00 f6d36c00
> f605ea0c f839c761 f64a8e7c
> [   18.853314] Call Trace:
> [   18.853314]  [<c111bb19>] ? elv_put_request+0x10/0x11
> [   18.853314]  [<c1122618>] ? __blk_put_request+0x60/0x8e
> [   18.853314]  [<c1122ad3>] ? blk_put_request+0x1e/0x2e
> [   18.853314]  [<f839c491>] ? send_trespass_cmd+0x21c/0x226
> [scsi_dh_emc]
> [   18.853314]  [<c1259c36>] ? sc
> 
> And one more, where the beginning part is missing (I really wonder why
> the management system behaves like this):
> 
> Begin: Mounting root file system ... Begin: Runn[   18.791487]
> device-mapper: uevent: version 1.0.3
> ing /scripts/loc[   18.828401] device-mapper: ioctl: 4.15.0-ioctl
> (2009-04-01) initialised: dm-devel@redhat.com
> al-top ... Begin[   18.889718] device-mapper: multipath: version 1.1.0
> loaded
> : Loading multipath modules ... [   18.940906] sd 0:0:0:0: emc:
> detected Clariion CX3-40f, flags 0
> Success: loaded [   18.979823] sd 0:0:0:0: emc: connected to SP A Port
> 3 (bound, default SP B)
> module dm-multip[   19.029770] sd 0:0:0:2: emc: detected Clariion
> CX3-40f, flags 0
> ath.
> all Trace:
> [   19.221341]  [<c111bb19>] ? elv_put_request+0x10/0x11
> [   19.221341]  [<c1122618>] ? __blk_put_request+0x60/0x8e
> [   19.221341]  [<c1122ad3>] ? blk_put_request+0x1e/0x2e
> [   19.221341]  [<f8374491>] ? send_trespass_cmd+0x21c/0x226
> [scsi_dh_emc]
> [   19.221341]  [<c1259c36>] ? schedule+0x78f/0x7dc
> [   19.221341]  [<f8374761>] ? clariion_activate+0x3b/0xeb
> [scsi_dh_emc]
> [   19.221341]  [<f83055f1>] ? scsi_dh_activate+0x6d/0x82 [scsi_dh]
> [   19.221341]  [<f8340b8c>] ? activate_path+0x1d/0x118 [dm_multipath]
> [   19.221341]  [<c1041677>] ? worker_thread+0x141/0x1bd
> [   19.221341]  [<f8340b6f>] ? activate_path+0x0/0x118 [dm_multipath]
> [   19.221341]  [<c10443b2>] ? autoremove_wake_function+0x0/0x2d
> [   19.221341]  [<c1041536>] ? worker_thread+0x0/0x1bd
> [   19.221341]  [<c1044180>] ? kthread+0x61/0x66
> [   19.221341]  [<c104411f>] ? kthread+0x0/0x66
> [   19.221341]  [<c1003d47>] ? kernel_thread_helper+0x7/0x10
> [   19.221341] Code: 6b 49 c1 89 da 5b 5e e9 3b 13 f8 ff 5b 5e c3 56
> 53 8b 70 5c 89 c3 85 f6 74 3c 8b 40 24 83 e0 01 8d 50 0c 8b 44 96 0c
> 85 c0 75 04 <0f> 0b eb fe 48 89 44 96 0c 8b 43 58 8b 40 10 e8 4a 8f ff
> ff 89 
> [   19.221341] EIP: [<c112c454>] cfq_put_request+0x1c/0x4a SS:ESP
> 0068:f64b3ed4
> [   19.221341] ---[ end trace 2406ac42e6ebdd24 ]---
> 
> At least we have a the full stack trace now...  Can you perhaps
> pinpoint
> the problem based on such fragmented information?  Please find my
> kernel
> config below.

James
