From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: eata - issue appeared in Linus git master in last 24-48 hours
Date: Mon, 30 Jun 2014 05:29:50 +0930
Message-ID: <mq768b-m35.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
References: <dd468b-sj5.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51128 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbaF2UDX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2014 16:03:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1X1LJo-0002XW-5t
	for linux-scsi@vger.kernel.org; Sun, 29 Jun 2014 22:03:20 +0200
Received: from ppp14-2-63-118.lns21.adl2.internode.on.net ([14.2.63.118])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 29 Jun 2014 22:03:20 +0200
Received: from arthur.marsh by ppp14-2-63-118.lns21.adl2.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 29 Jun 2014 22:03:20 +0200
In-Reply-To: <dd468b-sj5.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Arthur Marsh wrote, on 30/06/14 04:31:
> Hi, I haven't had time to do a git bisect yet, but just saw this after
> rebuilding the kernel in the last day or so:
>
> [    1.044035] EATA0: warning, DMA protocol support not asserted.
> [    1.044035] EATA0: IRQ 11 mapped to IO-APIC IRQ 16.
> [    1.046040] usb usb1: New USB device found, idVendor=1d6b,
> idProduct=0002
> [    1.046123] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=
> 1
> [    1.046204] usb usb1: Product: EHCI Host Controller
> [    1.046275] usb usb1: Manufacturer: Linux 3.16.0-rc2+ ehci_hcd
> [    1.046348] usb usb1: SerialNumber: 0000:00:03.3
> [    1.049496] hub 1-0:1.0: USB hub found
> [    1.050029] hub 1-0:1.0: 6 ports detected
> [    1.050625] BUG: spinlock wrong CPU on CPU#1, systemd-udevd/63
> [    1.050700]  lock: driver_lock+0x0/0xffffef00 [eata], .magic:
> dead4ead, .owne
> r: systemd-udevd/63, .owner_cpu: 0
> [    1.050785] CPU: 1 PID: 63 Comm: systemd-udevd Not tainted
> 3.16.0-rc2+ #1038
> [    1.050850] Hardware name: System Manufacturer System Name/P4S800,
> BIOS ASUS
> P4S800 ACPI BIOS Revision 1011 Beta 001 08/30/2005
> [    1.050935]  f8048100 00000000 f707fad8 c1416ba9 f43aad44 f707fb04
> c1081b6f c
> 158aab0
> [    1.051301]  f8048100 dead4ead f43aad44 0000003f 00000000 f8048100
> c155b1eb 0
> 0000010
> [    1.051678]  f707fb14 c1081bdc f8048100 f50e8000 f707fb20 c1081e43
> f8048100 f
> 707fb2c
> [    1.052051] Call Trace:
> [    1.052119]  [<c1416ba9>] dump_stack+0x41/0x52
> [    1.052183]  [<c1081b6f>] spin_dump+0x8c/0xde
> [    1.052249]  [<c1081bdc>] spin_bug+0x1b/0x1f
> [    1.052310]  [<c1081e43>] do_raw_spin_unlock+0x79/0x7b
> [    1.052377]  [<c141c495>] _raw_spin_unlock_irq+0x1d/0x26
> [    1.052444]  [<f8046176>] port_detect+0xa54/0xefc [eata]
> [    1.052509]  [<c141a510>] ? __mutex_unlock_slowpath+0xb6/0x136
> [    1.052576]  [<c141a598>] ? mutex_unlock+0x8/0xa
> [    1.052641]  [<c102d766>] ? ioapic_write_entry+0x17/0x43
> [    1.052706]  [<c102d78b>] ? ioapic_write_entry+0x3c/0x43
> [    1.052771]  [<c102d78b>] ? ioapic_write_entry+0x3c/0x43
> [    1.052837]  [<c102e633>] ? io_apic_setup_irq_pin+0x175/0x319
> [    1.052904]  [<c12804bf>] ? acpi_os_release_lock+0x8/0xa
> [    1.052970]  [<c131f7dc>] ? pci_conf1_read+0x43/0xdd
> [    1.053036]  [<c131f801>] ? pci_conf1_read+0x68/0xdd
> [    1.053101]  [<c1410ccc>] ? klist_next+0x1b/0xef
> [    1.053166]  [<c1410d9e>] ? klist_next+0xed/0xef
> [    1.053237]  [<c141c449>] ? _raw_spin_unlock+0x1d/0x20
> [    1.053304]  [<c1410d9e>] ? klist_next+0xed/0xef
> [    1.053383]  [<c12505f6>] ? pci_do_find_bus+0x36/0x36
> [    1.053449]  [<c12e1a18>] ? bus_find_device+0x5b/0x7d
> [    1.053511]  [<c12dfc7c>] ? put_device+0xf/0x11
> [    1.053571]  [<c124f172>] ? pci_dev_put+0xf/0x11
> [    1.053635]  [<c125078e>] ? pci_get_dev_by_id+0x3f/0x8a
> [    1.053701]  [<c12505f6>] ? pci_do_find_bus+0x36/0x36
> [    1.053763]  [<c12508d4>] ? pci_get_class+0x46/0x48
> [    1.053829]  [<f80466f7>] eata2x_detect+0xd9/0x3ef [eata]
> [    1.053836] ohci-pci: OHCI PCI platform driver
> [    1.054213] ohci-pci 0000:00:03.0: OHCI PCI host controller
> [    1.054231] ohci-pci 0000:00:03.0: new USB bus registered, assigned
> bus numbe
> r 2
> [    1.054293] ohci-pci 0000:00:03.0: irq 9, io mem 0xbe800000
> [    1.054782]  [<f8021000>] ? 0xf8020fff
> [    1.054853]  [<f8021054>] init_this_scsi_driver+0x54/0x1000 [eata]
> [    1.054923]  [<f8021000>] ? 0xf8020fff
> [    1.054987]  [<c100041b>] do_one_initcall+0x75/0x198
> [    1.055051]  [<f8021000>] ? 0xf8020fff
> [    1.055115]  [<c11255cd>] ? __vunmap+0x77/0xce
> [    1.055179]  [<c10aa53b>] load_module+0x19a6/0x224a
> [    1.055248]  [<c10aaed2>] SyS_finit_module+0x5c/0x6b
> [    1.055320]  [<f8039000>] ? 0xf8038fff
> [    1.055385]  [<c141ce0e>] syscall_call+0x7/0xb
> [    1.060902] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
> [    1.060966] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n,
> ip:n, ep:n,
>   pp:y.
> [    1.061029] EATA0: 2.0C, PCI 0x7410, IRQ 16, BMST, SG 122, MB 64.
> [    1.061080] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
> [    1.061132] EATA0: SCSI channel 0 enabled, host target ID 7.
> [    1.061192] scsi0 : EATA/DMA 2.0x rev. 8.10.00

This wasn't repeated on a reboot, so at this stage it is a one-off problem.

Arthur.

