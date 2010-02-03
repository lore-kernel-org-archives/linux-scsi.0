From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: RE: Bug 14579 (was: RE: Bug 14579 -  Devices disappear... and Bug
 14577 - Data corruption with Adaptec)
Date: Wed, 03 Feb 2010 14:36:51 +0100
Message-ID: <1265204211.3170.114.camel@larosa.zuhause>
References: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
	 <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C04462@inbmail01.lsi.com>
	 <20091117142242.GA15638@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74A49@inbmail01.lsi.com>
	 <20091118133909.GD16440@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74BD4@inbmail01.lsi.com>
	 <1258625851.8918.20.camel@muchoki.zuhause>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74C80@inbmail01.lsi.com>
	 <1258627720.8918.33.camel@muchoki.zuhause>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74C97@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-iaJ8rjrxrlpdrcCeROHy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:56732 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757283Ab0BCNri (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2010 08:47:38 -0500
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93C74C97@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, sfrey@techfak.uni-bielefeld.de, Ganapathy_Sridaran@adaptec.com, Carsten Gnoerlich <cg@techfak.uni-bielefeld.de>


--=-iaJ8rjrxrlpdrcCeROHy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello all,

I'm sorry it took us so long to get back to you. We had hardware issues
with said machine and had to replace it. So now we're facing these
crashes again.

Hardware:
As in http://bugzilla.kernel.org/show_bug.cgi?id=14579

Software: Debian Lenny, with Kernel 2.6.32(.4, I believe).
Adaptec 52445 for the RAID, LSI SAS1068E for the tape library.

We tested with aacraid driver versions 24900 and 2461, mptfusion
versions 3.04.12 and 3.04.13.

What works: Booting system from the RAID,
dd if=/dev/zero of=/dev/backup/drv2 bs=1M
(/dev/backup/drv2 is the second tape drive within the library)
No crash (at least not within 12 hours)

And subsequently:
dd if=/dev/sdb of=/dev/null bs=1M
No crash (at least not within 12 hours)

When doing the two dd's *simultaneously*, the machine *crashes*
reproducibly after a maximum of 10 minutes. The machine also crashes
reproducibly when transferring data from the RAID to the tape.

Stacktrace taken from a serial line is attached. Any help would be
really appreciated.

Kind regards,
Lukas Kolbe



Am Donnerstag, den 19.11.2009, 16:28 +0530 schrieb Desai, Kashyap:
> 
> > -----Original Message-----
> > From: Lukas Kolbe [mailto:lkolbe@techfak.uni-bielefeld.de]
> > Sent: Thursday, November 19, 2009 4:19 PM
> > To: Desai, Kashyap
> > Cc: linux-scsi@vger.kernel.org; sfrey@techfak.uni-bielefeld.de
> > Subject: RE: Bug 14579 (was: RE: Bug 14579 - Devices disappear... and Bug
> > 14577 - Data corruption with Adaptec)
> > 
> > Am Donnerstag, den 19.11.2009, 16:00 +0530 schrieb Desai, Kashyap:
> > >
> > > > -----Original Message-----
> > > > From: Lukas Kolbe [mailto:lkolbe@techfak.uni-bielefeld.de]
> > > > Sent: Thursday, November 19, 2009 3:48 PM
> > > > To: Desai, Kashyap
> > > > Cc: linux-scsi@vger.kernel.org; sfrey@techfak.uni-bielefeld.de
> > > > Subject: Bug 14579 (was: RE: Bug 14579 - Devices disappear... and Bug
> > > > 14577 - Data corruption with Adaptec)
> > > >
> > > > Am Donnerstag, den 19.11.2009, 10:43 +0530 schrieb Desai, Kashyap:
> > > > > OK. So I get it now. You are working to solve major issue which is
> > > > > related to your RAID 60 + Adaptec controller. If you want to upgrade
> > > > > LSI driver, we can always go for latest driver. I can provide you
> > > > > latest driver source tar ball.  Back porting to 2.6.30 is fine.
> > > >
> > > > That would be great, thank you. It seems the Adaptec-problem will
> > still
> > > > take a while to debug, so if we can get further with the LSI issue it
> > > > would be much appreciated. It might take a few days of testing after
> > we
> > > > build 2.6.30 with the new mtpfusion.
> > > >
> > > I think, without solving one issue (Adaptec related), I am not in
> > > position to understand what is an issue w.r.t LSI ? Pls clarify. If
> > > you can provide me Logs for LSI driver and provide me pointer to look
> > > inside, I can do something on this.
> > 
> > It's all in Bug #14579, see
> > http://bugzilla.kernel.org/show_bug.cgi?id=14579
> > 
> > Basically, after a while writing to the tape drive that is attached to
> > the LSI controller, the bus either resets itself without finding the
> > tape drives again, or we get an oops and the system crashes. This is a
> > seperate problem from the one we have with the Adaptec RAID on 2.6.32,
> > that is the reason why we opened two bugs.
> > 
> Looking at oops message attached to bug14579, I am still unable to map anything which might be related to LSI driver, in sort I am not getting any pointers related to fusion driver from OOPS message . Better way to provide Oops will be console redirect. 
> 
> > If you can provide us with the current mptfusion, we can build it for
> > 2.6.30 and test wether the bus reset and/or oops do still happen. If
> > they don't, you made a few people very happy :)
> > 
> I have attached latest fusion driver version 3.04.13 for upstream kernel.
> You can run *compile* script inside fusion folder to compile it.
> You have to copy *.ko to /lib/modules/`uname -r`/ and create mkinitrd once again to reflect driver update in mkinitrd. 
> 
> Please try 
> > --
> > Kind regards,
> > Lukas
> > 
> 



--=-iaJ8rjrxrlpdrcCeROHy
Content-Disposition: attachment; filename="stacktrace.txt"
Content-Type: text/plain; name="stacktrace.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[  503.019570] BUG: unable to handle kernel paging request at ffff88022d4751e4
[  503.022581] IP: [<ffffffff812e6b91>] _spin_lock_irqsave+0x1a/0x34
[  503.022581] PGD 1002063 PUD 18067 PMD 5f776f68735f726f BAD
[  503.022581] Oops: 000b [#1] SMP 
[  503.022581] last sysfs file: /sys/devices/pci0000:00/0000:00:07.0/0000:04:00.0/0000:05:00.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:1/model
[  503.022581] CPU 3 
[  503.022581] Modules linked in: mptsas(+) kvm_intel kvm autofs4 nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp bonding snd_pcm snd_timer snd soundcore snd_page_alloc serio_raw i5k_amb rng_core i2c_i801 psmouse i2c_core evdev pcspkr i5400_edac ioatdma shpchp edac_core pci_hotplug container processor button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod st ch osst sg sr_mod usbhid hid usb_storage ses enclosure sd_mod crc_t10dif ide_cd_mod cdrom ata_generic ehci_hcd uhci_hcd ata_piix mptscsih piix libata ide_pci_generic mptbase scsi_transport_sas aacraid floppy igb ide_core scsi_mod usbcore nls_base dca thermal fan thermal_sys [last unloaded: mptsas]
[  503.022581] Pid: 3395, comm: cat Tainted: G  R        2.6.32-trunk-amd64 #1 X7DW3
[  503.022581] RIP: 0010:[<ffffffff812e6b91>]  [<ffffffff812e6b91>] _spin_lock_irqsave+0x1a/0x34
[  503.022581] RSP: 0000:ffff88022d64bee8  EFLAGS: 00010096
[  503.022581] RAX: 0000000000000296 RBX: ffff88022d4751e0 RCX: 00007fffc5978ebb
[  503.022581] RDX: 0000000000010000 RSI: 0000000000000296 RDI: ffff88022d4751e4
[  503.022581] RBP: ffff88022d4751e4 R08: 0000000000000004 R09: 0000000000000003
[  503.022581] R10: 0000000000000000 R11: 00007fd89d962a30 R12: 0000000000000014
[  503.022581] R13: ffff88022d64bf58 R14: ffff88022c9b3880 R15: ffff88022d475180
[  503.022581] FS:  00007fd89ddfa6e0(0000) GS:ffff880008d80000(0000) knlGS:0000000000000000
[  503.022581] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  503.022581] CR2: ffffb768735f73a8 CR3: 000000022e249000 CR4: 00000000000426e0
[  503.022581] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  503.022581] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  503.022581] Process cat (pid: 3395, threadinfo ffff88022d64a000, task ffff88022c9b3880)
[  503.022581] Stack:
[  503.022581]  ffff88022ddce600 ffffffff81189a43 ffff88022e240f00 0000000000000000
[  503.022581] <0> 00007fd89d962a30 ffffffff810326c9 ffff88022d4751e0 0000000000000000
[  503.022581] <0> 00000000020de000 0000000000001000 00007fffc5977620 0000000000001000
[  503.022581] Call Trace:
[  503.022581]  [<ffffffff81189a43>] ? __down_read_trylock+0x15/0x44
[  503.022581]  [<ffffffff810326c9>] ? do_page_fault+0xf6/0x282
[  503.022581]  [<ffffffff812e6ff5>] ? page_fault+0x25/0x30
[  503.022581] Code: 31 d2 89 d0 c3 f0 83 2f 01 79 05 e8 fa 62 ea ff c3 48 83 ec 08 9c 58 0f 1f 44 00 00 48 89 c6 fa 66 0f 1f 44 00 00 ba 00 00 01 00 <f0> 0f c1 17 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 0f b7 0f eb f5 
[  503.022581] RIP  [<ffffffff812e6b91>] _spin_lock_irqsave+0x1a/0x34
[  503.022581]  RSP <ffff88022d64bee8>
[  503.022581] CR2: ffff88022d4751e4
[  503.022581] ---[ end trace 38f9af02ed8ec666 ]---
[  503.024004] BUG: unable to handle kernel paging request at ffff88022fc08000
[  503.024004] IP: [<ffffffff8109345e>] irq_to_desc+0x16/0x1e
[  503.024004] PGD 1002063 PUD 18067 PMD 7461670063657865 BAD
[  503.024004] Oops: 0009 [#2] SMP 
[  503.024004] last sysfs file: /sys/devices/pci0000:00/0000:00:07.0/0000:04:00.0/0000:05:00.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:1/model
[  503.024004] CPU 2 
[  503.024004] Modules linked in: mptsas(+) kvm_intel kvm autofs4 nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp bonding snd_pcm snd_timer snd soundcore snd_page_alloc serio_raw i5k_amb rng_core i2c_i801 psmouse i2c_core evdev pcspkr i5400_edac ioatdma shpchp edac_core pci_hotplug container processor button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod st ch osst sg sr_mod usbhid hid usb_storage ses enclosure sd_mod crc_t10dif ide_cd_mod cdrom ata_generic ehci_hcd uhci_hcd ata_piix mptscsih piix libata ide_pci_generic mptbase scsi_transport_sas aacraid floppy igb ide_core scsi_mod usbcore nls_base dca thermal fan thermal_sys [last unloaded: mptsas]
[  503.024004] Pid: 0, comm: swapper Tainted: G  R   D    2.6.32-trunk-amd64 #1 X7DW3
[  503.024004] RIP: 0010:[<ffffffff8109345e>]  [<ffffffff8109345e>] irq_to_desc+0x16/0x1e
[  503.024004] RSP: 0018:ffff880008d03f70  EFLAGS: 00010087
[  503.024004] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff880008d00000
[  503.024004] RDX: ffff88022fc08000 RSI: ffff88022f0a3da8 RDI: 0000000000000000
[  503.024004] RBP: 0000000000000000 R08: 00000000003d0900 R09: ffffffffffbacca3
[  503.024004] R10: fffffffe9c1dc023 R11: 000000000000000a R12: 0000000000000030
[  503.024004] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  503.024004] FS:  0000000000000000(0000) GS:ffff880008d00000(0000) knlGS:0000000000000000
[  503.024004] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  503.024004] CR2: ffffaf0063657040 CR3: 0000000001001000 CR4: 00000000000426e0
[  503.024004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  503.024004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  503.024004] Process swapper (pid: 0, threadinfo ffff88022f0a2000, task ffff88022f0754c0)
[  503.024004] Stack:
[  503.024004]  ffffffff81013908 ffff88022f0a3da8 ffffffff81012f71 ffff88022f0a3dd0
[  503.024004] <0> 000000000000071d ffff88022f0a3dd0 00000000000001fd ffff88022d2c6000
[  503.024004] <0> ffffffff81011493 ffff88022f0a3dd0 <EOI>  ffff88022d2c6520 ffff88022d2c65a8
[  503.024004] Call Trace:
[  503.024004]  <IRQ> 
[  503.024004]  [<ffffffff81013908>] ? handle_irq+0x8/0x1d
[  503.024004]  [<ffffffff81012f71>] ? do_IRQ+0x57/0xb6
[  503.024004]  [<ffffffff81011493>] ? ret_from_intr+0x0/0x11
[  503.024004]  <EOI> 
[  503.024004]  [<ffffffffa025e61b>] ? acpi_idle_enter_simple+0x108/0x13a [processor]
[  503.024004]  [<ffffffffa025e614>] ? acpi_idle_enter_simple+0x101/0x13a [processor]
[  503.024004]  [<ffffffffa025e344>] ? acpi_idle_enter_bm+0xcf/0x29e [processor]
[  503.024004]  [<ffffffff812278ca>] ? menu_select+0x145/0x205
[  503.024004]  [<ffffffff81226bcb>] ? cpuidle_idle_call+0x95/0xee
[  503.024004]  [<ffffffff8100fe6f>] ? cpu_idle+0xa2/0xda
[  503.024004] Code: 48 8b 3d 7e 01 56 00 e8 ac 6d fb ff 59 89 d8 5b 5d c3 90 90 90 48 8b 15 49 bb 41 00 48 85 d2 74 0f 3b 3d e6 5b 3b 00 73 07 89 f8 <48> 8b 04 c2 c3 31 c0 c3 c3 31 c0 c3 31 c0 c3 c3 48 8b 15 23 bb 
[  503.024004] RIP  [<ffffffff8109345e>] irq_to_desc+0x16/0x1e
[  503.024004]  RSP <ffff880008d03f70>
[  503.024004] CR2: ffff88022fc08000
[  503.024004] ---[ end trace 38f9af02ed8ec667 ]---
[  503.024004] Kernel panic - not syncing: Fatal exception in interrupt
[  503.024004] Pid: 0, comm: swapper Tainted: G  R   D    2.6.32-trunk-amd64 #1
[  503.024004] Call Trace:
[  503.024004]  <IRQ>  [<ffffffff812e4da2>] ? panic+0x86/0x141
[  503.024004]  [<ffffffff810680b0>] ? down_trylock+0x28/0x2e
[  503.024004]  [<ffffffff8104e415>] ? console_unblank+0x16/0x60
[  503.024004]  [<ffffffff81014a3e>] ? oops_end+0xa7/0xb4
[  503.024004]  [<ffffffff8103228c>] ? no_context+0x1e9/0x1f8
[  503.024004]  [<ffffffff81032441>] ? __bad_area_nosemaphore+0x1a6/0x1ca
[  503.024004]  [<ffffffff8103a5eb>] ? activate_task+0x20/0x26
[  503.024004]  [<ffffffff8104a1cb>] ? try_to_wake_up+0x249/0x259
[  503.024004]  [<ffffffff810170de>] ? native_sched_clock+0x2e/0x66
[  503.024004]  [<ffffffff8105a5b6>] ? process_timeout+0x0/0x5
[  503.024004]  [<ffffffff8103263c>] ? do_page_fault+0x69/0x282
[  503.024004]  [<ffffffff812e6ff5>] ? page_fault+0x25/0x30
[  503.024004]  [<ffffffff8109345e>] ? irq_to_desc+0x16/0x1e
[  503.024004]  [<ffffffff81013908>] ? handle_irq+0x8/0x1d
[  503.024004]  [<ffffffff81012f71>] ? do_IRQ+0x57/0xb6
[  503.024004]  [<ffffffff81011493>] ? ret_from_intr+0x0/0x11
[  503.024004]  <EOI>  [<ffffffffa025e61b>] ? acpi_idle_enter_simple+0x108/0x13a [processor]
[  503.024004]  [<ffffffffa025e614>] ? acpi_idle_enter_simple+0x101/0x13a [processor]
[  503.024004]  [<ffffffffa025e344>] ? acpi_idle_enter_bm+0xcf/0x29e [processor]
[  503.024004]  [<ffffffff812278ca>] ? menu_select+0x145/0x205
[  503.024004]  [<ffffffff81226bcb>] ? cpuidle_idle_call+0x95/0xee
[  503.024004]  [<ffffffff8100fe6f>] ? cpu_idle+0xa2/0xda
[  503.022581] BUG: unable to handle kernel paging request at ffff88022d475210
[  503.022581] IP: [<ffffffff81050f56>] do_exit+0x171/0x6b5
[  503.022581] PGD 1002063 PUD 18067 PMD 5f776f68735f726f BAD
[  503.022581] Oops: 0009 [#3] SMP 
[  503.022581] last sysfs file: /sys/devices/pci0000:00/0000:00:07.0/0000:04:00.0/0000:05:00.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:1/model
[  503.022581] CPU 3 
[  503.022581] Modules linked in: mptsas(+) kvm_intel kvm autofs4 nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp bonding snd_pcm snd_timer snd soundcore snd_page_alloc serio_raw i5k_amb rng_core i2c_i801 psmouse i2c_core evdev pcspkr i5400_edac ioatdma shpchp edac_core pci_hotplug container processor button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod st ch osst sg sr_mod usbhid hid usb_storage ses enclosure sd_mod crc_t10dif ide_cd_mod cdrom ata_generic ehci_hcd uhci_hcd ata_piix mptscsih piix libata ide_pci_generic mptbase scsi_transport_sas aacraid floppy igb ide_core scsi_mod usbcore nls_base dca thermal fan thermal_sys [last unloaded: mptsas]
[  503.022581] Pid: 3395, comm: cat Tainted: G  R   D    2.6.32-trunk-amd64 #1 X7DW3
[  503.022581] RIP: 0010:[<ffffffff81050f56>]  [<ffffffff81050f56>] do_exit+0x171/0x6b5
[  503.022581] RSP: 0000:ffff88022d64bca8  EFLAGS: 00010082
[  503.022581] RAX: 0000000000000000 RBX: 0000000000000009 RCX: ffff88022d475180
[  503.022581] RDX: ffff88022d64bc48 RSI: 0000000000000092 RDI: ffff88022cbb8b40
[  503.022581] RBP: ffff88022c9b3880 R08: 0000000000000000 R09: 000000000000000a
[  503.022581] R10: 0000000000000000 R11: ffffffff811add5d R12: 0000000000000046
[  503.022581] R13: ffff88022c9b3880 R14: 000000000000000b R15: 0000000000000001
[  503.022581] FS:  00007fd89ddfa6e0(0000) GS:ffff880008d80000(0000) knlGS:0000000000000000
[  503.022581] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  503.022581] CR2: ffffb768735f73a8 CR3: 000000022e249000 CR4: 00000000000426e0
[  503.022581] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  503.022581] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  503.022581] Process cat (pid: 3395, threadinfo ffff88022d64a000, task ffff88022c9b3880)
[  503.022581] Stack:
[  503.022581]  ffff88022d64be38 0000000000012416 0000000000000096 ffffffff8104e259
[  503.022581] <0> f50000000000000b ffff88022d64be38 0000000000000009 0000000000000046
[  503.022581] <0> ffff88022c9b3880 000000000000000b 0000000000000046 ffffffff81014a46
[  503.022581] Call Trace:
[  503.022581]  [<ffffffff8104e259>] ? release_console_sem+0x17e/0x1af
[  503.022581]  [<ffffffff81014a46>] ? oops_end+0xaf/0xb4
[  503.022581]  [<ffffffff8103228c>] ? no_context+0x1e9/0x1f8
[  503.022581]  [<ffffffff81032441>] ? __bad_area_nosemaphore+0x1a6/0x1ca
[  503.022581]  [<ffffffff810ebe5d>] ? do_sync_read+0xce/0x113
[  503.022581]  [<ffffffff8103263c>] ? do_page_fault+0x69/0x282
[  503.022581]  [<ffffffff812e6ff5>] ? page_fault+0x25/0x30
[  503.022581]  [<ffffffff812e6b91>] ? _spin_lock_irqsave+0x1a/0x34
[  503.022581]  [<ffffffff81189a43>] ? __down_read_trylock+0x15/0x44
[  503.022581]  [<ffffffff810326c9>] ? do_page_fault+0xf6/0x282
[  503.022581]  [<ffffffff812e6ff5>] ? page_fault+0x25/0x30
[  503.022581] Code: ff 74 5e 48 8b bd b8 04 00 00 48 83 c7 68 e8 8f 67 01 00 48 8b bd b8 04 00 00 e8 40 2c 01 00 48 8b 8d b8 01 00 00 48 85 c9 74 36 <48> 8b 81 90 00 00 00 48 8b 91 98 00 00 00 48 8b b5 b8 04 00 00 
[  503.022581] RIP  [<ffffffff81050f56>] do_exit+0x171/0x6b5
[  503.022581]  RSP <ffff88022d64bca8>
[  503.022581] CR2: ffff88022d475210
[  503.022581] ---[ end trace 38f9af02ed8ec668 ]---
[  503.022581] Fixing recursive fault but reboot is needed!
[  503.022581] BUG: unable to handle kernel paging request at ffff88022d4751d4
[  503.022581] IP: [<ffffffff812e57db>] schedule+0x76b/0x7da
[  503.022581] PGD 1002063 PUD 18067 PMD 5f776f68735f726f BAD
[  503.022581] Oops: 000b [#4] SMP 
[  503.022581] last sysfs file: /sys/devices/pci0000:00/0000:00:07.0/0000:04:00.0/0000:05:00.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:1/model
[  503.022581] CPU 3 
[  503.022581] Modules linked in: mptsas(+) kvm_intel kvm autofs4 nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp bonding snd_pcm snd_timer snd soundcore snd_page_alloc serio_raw i5k_amb rng_core i2c_i801 psmouse i2c_core evdev pcspkr i5400_edac ioatdma shpchp edac_core pci_hotplug container processor button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod st ch osst sg sr_mod usbhid hid usb_storage ses enclosure sd_mod crc_t10dif ide_cd_mod cdrom ata_generic ehci_hcd uhci_hcd ata_piix mptscsih piix libata ide_pci_generic mptbase scsi_transport_sas aacraid floppy igb ide_core scsi_mod usbcore nls_base dca thermal fan thermal_sys [last unloaded: mptsas]
[  503.022581] Pid: 3395, comm: cat Tainted: G  R   D    2.6.32-trunk-amd64 #1 X7DW3
[  503.022581] RIP: 0010:[<ffffffff812e57db>]  [<ffffffff812e57db>] schedule+0x76b/0x7da
[  503.022581] RSP: 0000:ffff88022d64b998  EFLAGS: 00010046
[  503.022581] RAX: ffff88022d4751d4 RBX: ffff880008d955c0 RCX: ffff88022c9b3880
[  503.022581] RDX: ffff88022c9b3880 RSI: ffff88022f077100 RDI: ffff88022c9b3880
[  503.022581] RBP: ffff88022f077100 R08: 0000000000000000 R09: ffff88022c9b3880
[  503.022581] R10: 0000000000000000 R11: ffffffff811add5d R12: ffff88022d475180
[  503.022581] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880008d8f8a0
[  503.022581] FS:  00007fd89ddfa6e0(0000) GS:ffff880008d80000(0000) knlGS:0000000000000000
[  503.022581] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  503.022581] CR2: ffffb768735f73a8 CR3: 000000022e249000 CR4: 00000000000426e0
[  503.022581] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  503.022581] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  503.022581] Process cat (pid: 3395, threadinfo ffff88022d64a000, task ffff88022c9b3880)
[  503.022581] Stack:
[  503.022581]  0000000000000000 00000000298d6588 ffff88022d64b9b8 000000000000f8a0
[  503.022581] <0> ffff88022d64bfd8 00000000000155c0 00000000000155c0 ffff88022c9b3880
[  503.022581] <0> ffff88022c9b3b78 00000003812e4eab 0000003000000010 ffffffff814ade80
[  503.022581] Call Trace:
[  503.022581]  [<ffffffff81050ea5>] ? do_exit+0xc0/0x6b5
[  503.022581]  [<ffffffff8104e259>] ? release_console_sem+0x17e/0x1af
[  503.022581]  [<ffffffff81014a46>] ? oops_end+0xaf/0xb4
[  503.022581]  [<ffffffff8103228c>] ? no_context+0x1e9/0x1f8
[  503.022581]  [<ffffffff81032441>] ? __bad_area_nosemaphore+0x1a6/0x1ca
[  503.022581]  [<ffffffff8104e259>] ? release_console_sem+0x17e/0x1af
[  503.022581]  [<ffffffff8103263c>] ? do_page_fault+0x69/0x282
[  503.022581]  [<ffffffff812e6ff5>] ? page_fault+0x25/0x30
[  503.022581]  [<ffffffff811add5d>] ? vgacon_cursor+0x0/0x140
[  503.022581]  [<ffffffff81050f56>] ? do_exit+0x171/0x6b5
[  503.022581]  [<ffffffff81050f4a>] ? do_exit+0x165/0x6b5
[  503.022581]  [<ffffffff8104e259>] ? release_console_sem+0x17e/0x1af
[  503.022581]  [<ffffffff81014a46>] ? oops_end+0xaf/0xb4
[  503.022581]  [<ffffffff8103228c>] ? no_context+0x1e9/0x1f8
[  503.022581]  [<ffffffff81032441>] ? __bad_area_nosemaphore+0x1a6/0x1ca
[  503.022581]  [<ffffffff810ebe5d>] ? do_sync_read+0xce/0x113
[  503.022581]  [<ffffffff8103263c>] ? do_page_fault+0x69/0x282
[  503.022581]  [<ffffffff812e6ff5>] ? page_fault+0x25/0x30
[  503.022581]  [<ffffffff812e6b91>] ? _spin_lock_irqsave+0x1a/0x34
[  503.022581]  [<ffffffff81189a43>] ? __down_read_trylock+0x15/0x44
[  503.022581]  [<ffffffff810326c9>] ? do_page_fault+0xf6/0x282
[  503.022581]  [<ffffffff812e6ff5>] ? page_fault+0x25/0x30
[  503.022581] Code: 24 38 4c 8b ad b8 01 00 00 4c 8b a1 c0 01 00 00 48 89 cf 0f 1f 80 00 00 00 00 4d 85 ed 75 2c 4c 89 a5 c0 01 00 00 49 8d 44 24 54 <f0> 41 ff 44 24 54 65 8b 04 25 88 55 01 00 ff c8 75 1c 65 c7 04 
[  503.022581] RIP  [<ffffffff812e57db>] schedule+0x76b/0x7da
[  503.022581]  RSP <ffff88022d64b998>
[  503.022581] CR2: ffff88022d4751d4
[  503.022581] ---[ end trace 38f9af02ed8ec669 ]---
[  503.022581] Fixing recursive fault but reboot is needed!

--=-iaJ8rjrxrlpdrcCeROHy--

