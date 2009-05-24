From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: next-20090522: kernel hungs at boot (async, libata/scsi)
Date: Sun, 24 May 2009 08:23:39 -0500
Message-ID: <1243171419.2889.4.camel@localhost.localdomain>
References: <a4423d670905240443q75da19f7k210263fcb81297ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50925 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbZEXNXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2009 09:23:39 -0400
In-Reply-To: <a4423d670905240443q75da19f7k210263fcb81297ae@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2009-05-24 at 15:43 +0400, Alexander Beregalov wrote:
> Hi
> 
> Host has pata_amd (ata1,2) and pata_pdc2027x (ata3,4).
> 
> It cannot add ata2 and ata4.
> 
> bus: 'pci': driver_probe_device: matched device 0000:00:09.0 with
> driver pata_amd
> bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:09.0
> pata_amd 0000:00:09.0: version 0.4.1
> pata_amd 0000:00:09.0: setting latency timer to 64
> scsi0 : pata_amd
> device: 'host0': device_add
> bus: 'scsi': add device host0
> device: 'host0': device_add
> scsi1 : pata_amd
> device: 'host1': device_add
> bus: 'scsi': add device host1
> device: 'host1': device_add
> ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
> ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
> driver: '0000:00:09.0': driver_bound: bound to device 'pata_amd'
> bus: 'pci': really_probe: bound device 0000:00:09.0 to driver pata_amd
> bus: 'pci': add driver pata_pdc2027x
> bus: 'pci': driver_probe_device: matched device 0000:01:08.0 with
> driver pata_pdc2027x
> bus: 'pci': really_probe: probing driver pata_pdc2027x with device 0000:01:08.0
> pata_pdc2027x 0000:01:08.0: version 1.0
> ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> pata_pdc2027x 0000:01:08.0: PCI INT A -> Link[APC1] -> GSI 16 (level,
> high) -> IRQ 16
> pata_pdc2027x 0000:01:08.0: PLL input clock 16686 kHz
> scsi2 : pata_pdc2027x
> device: 'host2': device_add
> bus: 'scsi': add device host2
> device: 'host2': device_add
> ata1.00: ATA-7: ST3250823A, 3.02, max UDMA/100
> ata1.00: 488397168 sectors, multi 16: LBA48
> ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000
> (0xc600c600) ACPI=0x3f01f (20:600:0x13)
> scsi3 : pata_pdc2027x
> device: 'host3': device_add
> bus: 'scsi': add device host3
> device: 'host3': device_add
> ata3: PATA max UDMA/100 mmio m65536@0xed040000 cmd 0xed0417c0 irq 16
> ata4: PATA max UDMA/100 mmio m65536@0xed040000 cmd 0xed0415c0 irq 16
> driver: '0000:01:08.0': driver_bound: bound to device 'pata_pdc2027x'
> bus: 'pci': really_probe: bound device 0000:01:08.0 to driver pata_pdc2027x
> ata1.00: configured for UDMA/100
> 
> ata3.00: ATA-7: ST3250823A, 3.03, max UDMA/100
> ata3.00: 488397168 sectors, multi 16: LBA48
> ata3.00: configured for UDMA/100
> 
> INFO: task swapper:1 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> swapper       D c0586e00  5492     1      0 0x00000000
>  f704ff3c 00000046 c014eca4 c0586e00 00000296 f7050000 f7050284 e41d1a0a
>  00000003 00000001 f7050284 f704ff3c c0144247 f704ff60 c0586e6c 00000000
>  f704ff80 c014456d f7050000 f7050000 c044fb85 c06eb6e0 00000005 c014eca4
> Call Trace:
>  [<c014eca4>] ? trace_hardirqs_on_caller+0x124/0x180
>  [<c0144247>] ? lowest_in_progress+0x37/0x70
>  [<c014456d>] async_synchronize_cookie_domain+0xbd/0x150
>  [<c044fb85>] ? _spin_unlock_irqrestore+0x55/0x70
>  [<c014eca4>] ? trace_hardirqs_on_caller+0x124/0x180
>  [<c013e520>] ? autoremove_wake_function+0x0/0x40
>  [<c014460d>] async_synchronize_cookie+0xd/0x10
>  [<c0144628>] async_synchronize_full+0x18/0x40
>  [<c033e318>] wait_for_device_probe+0x68/0x70
>  [<c013e520>] ? autoremove_wake_function+0x0/0x40
>  [<c0704e62>] prepare_namespace+0x18/0x17c
>  [<c018b510>] ? sys_access+0x20/0x30
>  [<c070450b>] kernel_init+0xd8/0xf1
>  [<c0704433>] ? kernel_init+0x0/0xf1
>  [<c0103677>] kernel_thread_helper+0x7/0x10
> no locks held by swapper/1.
> INFO: task async/0:500 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> async/0       D c0586e00  7380   500      2 0x00000000
>  f7103ed4 00000046 c014eca4 c0586e00 00000292 f72a0000 f72a0284 5b573649
>  00000001 00000003 f72a0284 f7103ed4 c0144247 f7103ef8 c06ec3c0 00000000
>  f7103f18 c014456d f7103f20 c034ca95 00000002 f70ed9cc 00000005 22222222
> Call Trace:
>  [<c014eca4>] ? trace_hardirqs_on_caller+0x124/0x180
>  [<c0144247>] ? lowest_in_progress+0x37/0x70
>  [<c014456d>] async_synchronize_cookie_domain+0xbd/0x150
>  [<c034ca95>] ? scsi_alloc_target+0x275/0x2c0
>  [<c013e520>] ? autoremove_wake_function+0x0/0x40
>  [<c0144665>] async_synchronize_full_domain+0x15/0x20
>  [<c034d5f2>] __scsi_add_device+0xb2/0xe0
>  [<c01444dd>] ? async_synchronize_cookie_domain+0x2d/0x150
>  [<c03611d3>] ata_scsi_scan_host+0x103/0x180
>  [<c035dac1>] async_port_probe+0x91/0xc0
>  [<c0144350>] async_thread+0xd0/0x230
>  [<c044d12d>] ? schedule+0x37d/0x4c0
>  [<c014ed0b>] ? trace_hardirqs_on+0xb/0x10
>  [<c0124ac0>] ? default_wake_function+0x0/0x10
>  [<c0144280>] ? async_thread+0x0/0x230
>  [<c013e2a3>] kthread+0x43/0x80
>  [<c013e260>] ? kthread+0x0/0x80
>  [<c0103677>] kernel_thread_helper+0x7/0x10
> 1 lock held by async/0/500:
>  #0:  (&shost->scan_mutex){+.+...}, at: [<c034d5ae>] __scsi_add_device+0x6e/0xe0

This one's a strange one.  It's entangled in the SCSI async conversion:

commit 2c6dd125bace93f54d53f3e908f50db21733cbc9
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Tue Apr 28 13:35:58 2009 -0600

    [SCSI] Convert scsi_scan to use generic async mechanism

I already reverted it for other reasons, so I think reverting it will
make your problem go away.  However, if your system only has ATA ports
and no SCSI ones, it shouldn't have got caught here.  The SCSI async
scan uses a separate run queue, which should be empty and thus it
shouldn't be waiting here unless there's a problem inside the async
scanning code.

James


