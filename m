From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Fri, 6 Jun 2008 17:35:35 +0000
Message-ID: <200806061735.35268.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <200806060607.29460.chris2553@googlemail.com> <1212761485.3466.6.camel@localhost.localdomain>
Reply-To: chris2553@googlemail.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_nVXSIFEmpRicM/1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:34234 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbYFFRiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 13:38:12 -0400
Received: by ik-out-1112.google.com with SMTP id c28so592248ika.5
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2008 10:38:09 -0700 (PDT)
In-Reply-To: <1212761485.3466.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>

--Boundary-00=_nVXSIFEmpRicM/1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 06 June 2008, James Bottomley wrote:
> On Fri, 2008-06-06 at 06:07 +0000, Chris Clayton wrote:
> > On Friday 06 June 2008, Andrew Morton wrote:
> > > On Sun, 1 Jun 2008 04:15:05 +0000 Chris Clayton
> > > <chris2553@googlemail.com>
> >
> > wrote:
> > > > Hi,
> > > >
> > > > I've just started testing 2.6.26 on my desktop machine and have found
> > > > that I get a long pause (20 seconds or so) as the system boots. By
> > > > pause I mean that the boot messages that normally scroll by stop
> > > > doing so for, as I say, about 20 seconds.
> > > >
> > > > I've done a bisect and arrived at:
> > > >
> > > > b0ed43360fdca227048d88a08290365cb681c1a8 is first bad commit
> > > > commit b0ed43360fdca227048d88a08290365cb681c1a8
> > > > Author: Hannes Reinecke <hare@suse.de>
> > > > Date:   Tue Mar 18 14:32:28 2008 +0100
> > > >
> > > >     [SCSI] add scsi_host and scsi_target to scsi_bus
> > > >
> > > >     This patch implements scsi_host and scsi_target device types
> > > >     and adds both to the scsi_bus.
> > > >
> > > >     Signed-off-by: Hannes Reinecke <hare@suse.de>
> > > >     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > >     Signed-off-by: James Bottomley
> > > > <James.Bottomley@HansenPartnership.com>
> > > >
> > > > :040000 040000 4e3140909966b4c9aa987d34ee4078d283fe0351
> > > >
> > > > 46e4fd28cc537ba700eb4f5652abf043fed4d76d M      drivers
> > > >
> > > > The config file for that kernel is attached as are the kernel log for
> > > > booting that kernel and the bisect log.
> > > >
> > > > I've also noticed that it takes much longer for icons to appear on my
> > > > desktop when I plug a usb storage device in. (The icons are
> > > > shown/hidden by a simple sctript that is run via udev when the device
> > > > is
> > > > attached/detached.)
> > >
> > > Do you believe that this is the same period?  20 seconds?
> >
> > Thanks for the reply, Andrew. I was beginning to think that I'd committed
> > an LKML sin :-)
> >
> > Yes, it is about the same. On 2.6.25.4 (and earlier), the icons appear
> > within a second or two, but with 2.6.26-rc2 or later, it takes about 20
> > seconds. I've now built and installed -rc5 and am seeing the same
> > behaviour.
> >
> > I've also built -rc5 on my laptop. On that my kernel uses the older IDE
> > drivers rather than libata. The boot proceeds with no pause, but I do see
> > the same delay in the desktop icons appearing when I attach a usb-storage
> > device.
> >
> > > > Let me know of any way I can help solve this.
> > > >
> > > > Please cc me to any reply as I'm not subscribed.
> > >
> > > cc's added.
> > >
> > > Rafael, we might need to track this as a post-2.6.26 regression.
>
> It already is ... as I asked in the actual bug (but no-one seems to have
> noticed, so I assume the bug entry isn't set up correctly).  Does this
> still persist with 2.6.26-rc5?  The reason for asking is that it looks
> very much like a silent manifestation of our scsi_bus_uevent() problem
> that got fixed in 2.6.26-rc5.
>

Yes, I still get the boot pause and the delay in desktop icons appearing when a 
usb-storage device is plugged in with -rc5. A boot log is attached. Is there 
some sort of verbose scsi boot messaging that I can switch on? I've looked but 
I'm damned if I can find anything in 'make menuconfig'.

Chris

> James



-- 
Beauty is in the eye of the beerholder.

--Boundary-00=_nVXSIFEmpRicM/1
Content-Type: text/x-log;
  charset="utf-8";
  name="kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernel.log"

Jun  6 17:25:18 upstairs kernel: klogd 1.3-3, log source = /proc/kmsg started.
Jun  6 17:25:18 upstairs kernel: Inspecting /boot/System.map-2.6.26-rc5
Jun  6 17:25:19 upstairs kernel: Loaded 26357 symbols from /boot/System.map-2.6.26-rc5.
Jun  6 17:25:19 upstairs kernel: Symbols match kernel version 2.6.26.
Jun  6 17:25:19 upstairs kernel: No module symbols loaded - kernel modules not enabled. 
Jun  6 17:25:19 upstairs kernel: 1cf8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:05:   dma bitmask 0xe flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:05:   io  min 0x370 max 0x370 align 1 size 6 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:05:   io  min 0x377 max 0x377 align 1 size 1 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:05: end dependent options 
Jun  6 17:25:19 upstairs kernel: pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (active) 
Jun  6 17:25:19 upstairs kernel: pnp 00:06: parse allocated resources 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   add io  0x378-0x37f flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   add io  0x778-0x77b flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   add irq 7 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   add dma 3 flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:06: parse resource options 
Jun  6 17:25:19 upstairs kernel: pnp 00:06: new independent option 
Jun  6 17:25:19 upstairs kernel: pnp 00:06: new dependent option (priority 0x0) 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   io  min 0x378 max 0x378 align 1 size 8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   io  min 0x778 max 0x778 align 1 size 4 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000080 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   dma bitmask 0x8 flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:06: new dependent option (priority 0x1) 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   io  min 0x378 max 0x378 align 1 size 8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   io  min 0x778 max 0x778 align 1 size 4 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   dma bitmask 0xb flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:06: new dependent option (priority 0x1) 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   io  min 0x278 max 0x278 align 1 size 8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   io  min 0x678 max 0x678 align 1 size 4 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   dma bitmask 0xb flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:06: new dependent option (priority 0x1) 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   io  min 0x3bc max 0x3bc align 1 size 4 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   io  min 0x7bc max 0x7bc align 1 size 4 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:06:   dma bitmask 0xb flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:06: end dependent options 
Jun  6 17:25:19 upstairs kernel: pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active) 
Jun  6 17:25:19 upstairs kernel: pnp 00:07: parse allocated resources 
Jun  6 17:25:19 upstairs kernel: pnp 00:07:   add io  0x0-0xffffffff flags 0x10000001 
Jun  6 17:25:19 upstairs kernel: pnp 00:07:   add io  0x0-0xffffffff flags 0x10000001 
Jun  6 17:25:19 upstairs kernel: pnp 00:07:   add io  0x290-0x297 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:07: PNP0c02: calling quirk_system_pci_resources+0x0/0x1c1 
Jun  6 17:25:19 upstairs kernel: pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active) 
Jun  6 17:25:19 upstairs kernel: pnp 00:08: parse allocated resources 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x10-0x1f flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x22-0x3f flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x44-0x5f flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x62-0x63 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x65-0x6f flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x72-0x7f flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x80-0x80 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x84-0x86 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x88-0x88 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x8c-0x8e flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x90-0x9f flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0xa2-0xbf flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0xe0-0xef flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x4d0-0x4d1 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x800-0x87f flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x400-0x41f flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add io  0x480-0x4bf flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add mem 0xfed20000-0xfed8ffff flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08:   add mem 0xffb00000-0xffbfffff flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08: PNP0c02: calling quirk_system_pci_resources+0x0/0x1c1 
Jun  6 17:25:19 upstairs kernel: pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active) 
Jun  6 17:25:19 upstairs kernel: pnp 00:09: parse allocated resources 
Jun  6 17:25:19 upstairs kernel: pnp 00:09:   add mem 0xfec00000-0xfec00fff flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:09:   add mem 0xfee00000-0xfee00fff flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:09: PNP0c02: calling quirk_system_pci_resources+0x0/0x1c1 
Jun  6 17:25:19 upstairs kernel: pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active) 
Jun  6 17:25:19 upstairs kernel: pnp 00:0a: parse allocated resources 
Jun  6 17:25:19 upstairs kernel: pnp 00:0a:   add io  0x60-0x60 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0a:   add io  0x64-0x64 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0a:   add irq 1 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active) 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: parse allocated resources 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   add io  0x3f8-0x3ff flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   add irq 4 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: parse resource options 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: new independent option 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: new dependent option (priority 0x0) 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   io  min 0x3f8 max 0x3f8 align 4 size 8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000010 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: new dependent option (priority 0x1) 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: new dependent option (priority 0x1) 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: new dependent option (priority 0x1) 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: new dependent option (priority 0x1) 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: end dependent options 
Jun  6 17:25:19 upstairs kernel: pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active) 
Jun  6 17:25:19 upstairs kernel: pnp 00:0c: parse allocated resources 
Jun  6 17:25:19 upstairs kernel: pnp 00:0c:   add mem 0x0-0x9ffff flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0c:   add mem 0xc0000-0xdffff flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:0c:   add mem 0xe0000-0xfffff flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:0c:   add mem 0x100000-0x7ffeffff flags 0x1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0c:   add mem 0xfff00000-0xffffffff flags 0x0 
Jun  6 17:25:19 upstairs kernel: pnp 00:0c: PNP0c01: calling quirk_system_pci_resources+0x0/0x1c1 
Jun  6 17:25:19 upstairs kernel: pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active) 
Jun  6 17:25:19 upstairs kernel: pnp: PnP ACPI: found 13 devices 
Jun  6 17:25:19 upstairs kernel: ACPI: ACPI bus type pnp unregistered 
Jun  6 17:25:19 upstairs kernel: SCSI subsystem initialized 
Jun  6 17:25:19 upstairs kernel: libata version 3.00 loaded. 
Jun  6 17:25:19 upstairs kernel: usbcore: registered new interface driver usbfs 
Jun  6 17:25:19 upstairs kernel: usbcore: registered new interface driver hub 
Jun  6 17:25:19 upstairs kernel: usbcore: registered new device driver usb 
Jun  6 17:25:19 upstairs kernel: PCI: Using ACPI for IRQ routing 
Jun  6 17:25:19 upstairs kernel: pnp: the driver 'system' has been registered 
Jun  6 17:25:19 upstairs kernel: system 00:07: ioport range 0x290-0x297 has been reserved 
Jun  6 17:25:19 upstairs kernel: system 00:07: iomem range 0x0-0x0 could not be reserved 
Jun  6 17:25:19 upstairs last message repeated 23 times
Jun  6 17:25:19 upstairs kernel: system 00:07: driver attached 
Jun  6 17:25:19 upstairs kernel: system 00:08: ioport range 0x4d0-0x4d1 has been reserved 
Jun  6 17:25:19 upstairs kernel: system 00:08: ioport range 0x800-0x87f has been reserved 
Jun  6 17:25:19 upstairs kernel: system 00:08: ioport range 0x400-0x41f has been reserved 
Jun  6 17:25:19 upstairs kernel: system 00:08: ioport range 0x480-0x4bf has been reserved 
Jun  6 17:25:19 upstairs kernel: system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved 
Jun  6 17:25:19 upstairs kernel: system 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved 
Jun  6 17:25:19 upstairs kernel: system 00:08: iomem range 0x0-0x0 could not be reserved 
Jun  6 17:25:19 upstairs last message repeated 21 times
Jun  6 17:25:19 upstairs kernel: system 00:08: driver attached 
Jun  6 17:25:19 upstairs kernel: system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved 
Jun  6 17:25:19 upstairs kernel: system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved 
Jun  6 17:25:19 upstairs kernel: system 00:09: iomem range 0x0-0x0 could not be reserved 
Jun  6 17:25:19 upstairs last message repeated 21 times
Jun  6 17:25:19 upstairs kernel: system 00:09: driver attached 
Jun  6 17:25:19 upstairs kernel: system 00:0c: iomem range 0x0-0x9ffff could not be reserved 
Jun  6 17:25:19 upstairs kernel: system 00:0c: iomem range 0xc0000-0xdffff could not be reserved 
Jun  6 17:25:19 upstairs kernel: system 00:0c: iomem range 0xe0000-0xfffff could not be reserved 
Jun  6 17:25:19 upstairs kernel: system 00:0c: iomem range 0x100000-0x7ffeffff could not be reserved 
Jun  6 17:25:19 upstairs kernel: system 00:0c: iomem range 0xfff00000-0xffffffff could not be reserved 
Jun  6 17:25:19 upstairs kernel: system 00:0c: iomem range 0x0-0x0 could not be reserved 
Jun  6 17:25:19 upstairs last message repeated 18 times
Jun  6 17:25:19 upstairs kernel: system 00:0c: driver attached 
Jun  6 17:25:19 upstairs kernel: PCI: Bridge: 0000:00:01.0 
Jun  6 17:25:19 upstairs kernel:   IO window: c000-cfff 
Jun  6 17:25:19 upstairs kernel:   MEM window: 0xfa000000-0xfbefffff 
Jun  6 17:25:19 upstairs kernel:   PREFETCH window: 0x00000000f0000000-0x00000000f8ffffff 
Jun  6 17:25:19 upstairs kernel: PCI: Bridge: 0000:00:1e.0 
Jun  6 17:25:19 upstairs kernel:   IO window: d000-efff 
Jun  6 17:25:19 upstairs kernel:   MEM window: 0xfbf00000-0xfbffffff 
Jun  6 17:25:19 upstairs kernel:   PREFETCH window: disabled. 
Jun  6 17:25:19 upstairs kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64 
Jun  6 17:25:19 upstairs kernel: NET: Registered protocol family 2 
Jun  6 17:25:19 upstairs kernel: IP route cache hash table entries: 32768 (order: 5, 131072 bytes) 
Jun  6 17:25:19 upstairs kernel: TCP established hash table entries: 131072 (order: 8, 1048576 bytes) 
Jun  6 17:25:19 upstairs kernel: TCP bind hash table entries: 65536 (order: 7, 524288 bytes) 
Jun  6 17:25:19 upstairs kernel: TCP: Hash tables configured (established 131072 bind 65536) 
Jun  6 17:25:19 upstairs kernel: TCP reno registered 
Jun  6 17:25:19 upstairs kernel: NET: Registered protocol family 1 
Jun  6 17:25:19 upstairs kernel: highmem bounce pool size: 64 pages 
Jun  6 17:25:19 upstairs kernel: msgmni has been set to 1750 for ipc namespace c03dea00 
Jun  6 17:25:19 upstairs kernel: io scheduler noop registered 
Jun  6 17:25:19 upstairs kernel: io scheduler cfq registered (default) 
Jun  6 17:25:19 upstairs kernel: pci 0000:01:00.0: Boot video device 
Jun  6 17:25:19 upstairs kernel: input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0 
Jun  6 17:25:19 upstairs kernel: ACPI: Power Button (FF) [PWRF] 
Jun  6 17:25:19 upstairs kernel: input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1 
Jun  6 17:25:19 upstairs kernel: ACPI: Power Button (CM) [PWRB] 
Jun  6 17:25:19 upstairs kernel: ACPI: ACPI0007:00 is registered as cooling_device0 
Jun  6 17:25:19 upstairs kernel: ACPI: Processor [CPU1] (supports 8 throttling states) 
Jun  6 17:25:19 upstairs kernel: ACPI: ACPI0007:01 is registered as cooling_device1 
Jun  6 17:25:19 upstairs kernel: Real Time Clock Driver v1.12ac 
Jun  6 17:25:19 upstairs kernel: Linux agpgart interface v0.103 
Jun  6 17:25:19 upstairs kernel: agpgart: Detected an Intel 865 Chipset. 
Jun  6 17:25:19 upstairs kernel: agpgart: AGP aperture is 64M @ 0xec000000 
Jun  6 17:25:19 upstairs kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled 
Jun  6 17:25:19 upstairs kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A 
Jun  6 17:25:19 upstairs kernel: pnp: the driver 'serial' has been registered 
Jun  6 17:25:19 upstairs kernel: 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A 
Jun  6 17:25:19 upstairs kernel: serial 00:0b: driver attached 
Jun  6 17:25:19 upstairs kernel: 8139too Fast Ethernet driver 0.9.28 
Jun  6 17:25:19 upstairs kernel: ACPI: PCI Interrupt 0000:02:0d.0[A] -> GSI 23 (level, low) -> IRQ 23 
Jun  6 17:25:19 upstairs kernel: eth0: RealTek RTL8139 at 0xf8816c00, 00:17:31:a9:1d:48, IRQ 23 
Jun  6 17:25:19 upstairs kernel: eth0:  Identified 8139 chip type 'RTL-8100B/8139D' 
Jun  6 17:25:19 upstairs kernel: Driver 'sd' needs updating - please use bus_type methods 
Jun  6 17:25:19 upstairs kernel: Driver 'sr' needs updating - please use bus_type methods 
Jun  6 17:25:19 upstairs kernel: ata_piix 0000:00:1f.1: version 2.12 
Jun  6 17:25:19 upstairs kernel: ata_piix 0000:00:1f.1: enabling device (0005 -> 0007) 
Jun  6 17:25:19 upstairs kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18 
Jun  6 17:25:19 upstairs kernel: PCI: Setting latency timer of device 0000:00:1f.1 to 64 
Jun  6 17:25:19 upstairs kernel: scsi0 : ata_piix 
Jun  6 17:25:19 upstairs kernel: scsi1 : ata_piix 
Jun  6 17:25:19 upstairs kernel: ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14 
Jun  6 17:25:19 upstairs kernel: ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15 
Jun  6 17:25:19 upstairs kernel: ata1.00: ATA-7: MAXTOR STM3250820A, 3.AAE, max UDMA/100 
Jun  6 17:25:19 upstairs kernel: ata1.00: 488397168 sectors, multi 16: LBA48  
Jun  6 17:25:19 upstairs kernel: ata1.01: ATA-7: Maxtor 6L160P0, BAJ41G20, max UDMA/133 
Jun  6 17:25:19 upstairs kernel: ata1.01: 320173056 sectors, multi 16: LBA48  
Jun  6 17:25:19 upstairs kernel: ata1.00: configured for UDMA/100 
Jun  6 17:25:19 upstairs kernel: ata1.01: configured for UDMA/100 
Jun  6 17:25:19 upstairs kernel: Switched to NOHz mode on CPU #1 
Jun  6 17:25:19 upstairs kernel: Switched to NOHz mode on CPU #0 
Jun  6 17:25:19 upstairs kernel: ata2.00: ATAPI: SONY    DVD RW DW-G120A, MYS2, max UDMA/66 
Jun  6 17:25:19 upstairs kernel: ata2.01: ATAPI: PHILIPS DVDR1628P1, Q2.2, max UDMA/33 
Jun  6 17:25:19 upstairs kernel: ata2.00: configured for UDMA/66 
Jun  6 17:25:19 upstairs kernel: ata2.01: configured for UDMA/33 
Jun  6 17:25:19 upstairs kernel: scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM325082 3.AA PQ: 0 ANSI: 5 
Jun  6 17:25:19 upstairs kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB) 
Jun  6 17:25:19 upstairs kernel: sd 0:0:0:0: [sda] Write Protect is off 
Jun  6 17:25:19 upstairs kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00 
Jun  6 17:25:19 upstairs kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  6 17:25:19 upstairs kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB) 
Jun  6 17:25:19 upstairs kernel: sd 0:0:0:0: [sda] Write Protect is off 
Jun  6 17:25:19 upstairs kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00 
Jun  6 17:25:19 upstairs kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  6 17:25:19 upstairs kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 > 
Jun  6 17:25:19 upstairs kernel: sd 0:0:0:0: [sda] Attached SCSI disk 
Jun  6 17:25:19 upstairs kernel: scsi 0:0:1:0: Direct-Access     ATA      Maxtor 6L160P0   BAJ4 PQ: 0 ANSI: 5 
Jun  6 17:25:19 upstairs kernel: sd 0:0:1:0: [sdb] 320173056 512-byte hardware sectors (163929 MB) 
Jun  6 17:25:19 upstairs kernel: sd 0:0:1:0: [sdb] Write Protect is off 
Jun  6 17:25:19 upstairs kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00 
Jun  6 17:25:19 upstairs kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  6 17:25:19 upstairs kernel: sd 0:0:1:0: [sdb] 320173056 512-byte hardware sectors (163929 MB) 
Jun  6 17:25:19 upstairs kernel: sd 0:0:1:0: [sdb] Write Protect is off 
Jun  6 17:25:19 upstairs kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00 
Jun  6 17:25:19 upstairs kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  6 17:25:19 upstairs kernel:  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 > 
Jun  6 17:25:19 upstairs kernel:  sdb2: <bsd: sdb9 sdb10 sdb11 sdb12 sdb13 > 
Jun  6 17:25:19 upstairs kernel: sd 0:0:1:0: [sdb] Attached SCSI disk 
Jun  6 17:25:19 upstairs kernel: scsi 1:0:0:0: CD-ROM            SONY     DVD RW DW-G120A  MYS2 PQ: 0 ANSI: 5 
Jun  6 17:25:19 upstairs kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray 
Jun  6 17:25:19 upstairs kernel: Uniform CD-ROM driver Revision: 3.20 
Jun  6 17:25:19 upstairs kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0 
Jun  6 17:25:19 upstairs kernel: scsi 1:0:1:0: CD-ROM            PHILIPS  DVDR1628P1       Q2.2 PQ: 0 ANSI: 5 
Jun  6 17:25:19 upstairs kernel: sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray 
Jun  6 17:25:19 upstairs kernel: sr 1:0:1:0: Attached scsi CD-ROM sr1 
Jun  6 17:25:19 upstairs kernel: ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 18 
Jun  6 17:25:19 upstairs kernel: ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ] 
Jun  6 17:25:19 upstairs kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64 
Jun  6 17:25:19 upstairs kernel: scsi2 : ata_piix 
Jun  6 17:25:19 upstairs kernel: scsi3 : ata_piix 
Jun  6 17:25:19 upstairs kernel: ata3: SATA max UDMA/133 cmd 0x9800 ctl 0x9400 bmdma 0x8400 irq 18 
Jun  6 17:25:19 upstairs kernel: ata4: SATA max UDMA/133 cmd 0x9000 ctl 0x8800 bmdma 0x8408 irq 18 
Jun  6 17:25:19 upstairs kernel: ata3.00: ATA-7: Hitachi HDS721616PLA380, P22OA70A, max UDMA/133 
Jun  6 17:25:19 upstairs kernel: ata3.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32) 
Jun  6 17:25:19 upstairs kernel: ata3.00: configured for UDMA/133 
Jun  6 17:25:19 upstairs kernel: scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDS72161 P22O PQ: 0 ANSI: 5 
Jun  6 17:25:19 upstairs kernel: sd 2:0:0:0: [sdc] 321672960 512-byte hardware sectors (164697 MB) 
Jun  6 17:25:19 upstairs kernel: sd 2:0:0:0: [sdc] Write Protect is off 
Jun  6 17:25:19 upstairs kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00 
Jun  6 17:25:19 upstairs kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  6 17:25:19 upstairs kernel: sd 2:0:0:0: [sdc] 321672960 512-byte hardware sectors (164697 MB) 
Jun  6 17:25:19 upstairs kernel: sd 2:0:0:0: [sdc] Write Protect is off 
Jun  6 17:25:19 upstairs kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00 
Jun  6 17:25:19 upstairs kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  6 17:25:19 upstairs kernel:  sdc: sdc1 sdc2 
Jun  6 17:25:19 upstairs kernel: sd 2:0:0:0: [sdc] Attached SCSI disk 
Jun  6 17:25:19 upstairs kernel: pnp: the driver 'i8042 kbd' has been registered 
Jun  6 17:25:19 upstairs kernel: i8042 kbd 00:0a: driver attached 
Jun  6 17:25:19 upstairs kernel: pnp: the driver 'i8042 aux' has been registered 
Jun  6 17:25:19 upstairs kernel: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1 
Jun  6 17:25:19 upstairs kernel: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp 
Jun  6 17:25:19 upstairs kernel: serio: i8042 KBD port at 0x60,0x64 irq 1 
Jun  6 17:25:19 upstairs kernel: mice: PS/2 mouse device common for all mice 
Jun  6 17:25:19 upstairs kernel: Advanced Linux Sound Architecture Driver Version 1.0.16. 
Jun  6 17:25:19 upstairs kernel: ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 17 
Jun  6 17:25:19 upstairs kernel: PCI: Setting latency timer of device 0000:00:1f.5 to 64 
Jun  6 17:25:19 upstairs kernel: intel8x0_measure_ac97_clock: measured 50838 usecs 
Jun  6 17:25:19 upstairs kernel: intel8x0: clocking to 48000 
Jun  6 17:25:19 upstairs kernel: ALSA device list: 
Jun  6 17:25:19 upstairs kernel:   #0: Intel ICH5 with ALC655 at irq 17 
Jun  6 17:25:19 upstairs kernel: TCP cubic registered 
Jun  6 17:25:19 upstairs kernel: NET: Registered protocol family 15 
Jun  6 17:25:19 upstairs kernel: p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available 
Jun  6 17:25:19 upstairs kernel: Starting balanced_irq 
Jun  6 17:25:19 upstairs kernel: Using IPI No-Shortcut mode 
Jun  6 17:25:19 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  6 17:25:19 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  6 17:25:19 upstairs kernel: VFS: Mounted root (ext3 filesystem) readonly. 
Jun  6 17:25:19 upstairs kernel: Freeing unused kernel memory: 200k freed 
Jun  6 17:25:19 upstairs kernel: EXT3 FS on sdc1, internal journal 
Jun  6 17:25:19 upstairs kernel: USB Universal Host Controller Interface driver v3.0 
Jun  6 17:25:19 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16 
Jun  6 17:25:19 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64 
Jun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller 
Jun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1 
Jun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000a800 
Jun  6 17:25:19 upstairs kernel: usb usb1: configuration #1 chosen from 1 choice 
Jun  6 17:25:19 upstairs kernel: hub 1-0:1.0: USB hub found 
Jun  6 17:25:19 upstairs kernel: hub 1-0:1.0: 2 ports detected 
Jun  6 17:25:44 upstairs kernel: ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver 
Jun  6 17:25:44 upstairs kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  6 17:25:44 upstairs kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb1: Product: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb1: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb1: SerialNumber: 0000:00:1d.0 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19 
Jun  6 17:25:44 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b000 
Jun  6 17:25:44 upstairs kernel: usb usb2: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 2-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 2-0:1.0: 2 ports detected 
Jun  6 17:25:44 upstairs kernel: pnp: the driver 'parport_pc' has been registered 
Jun  6 17:25:44 upstairs kernel: parport_pc 00:06: reported by Plug and Play ACPI 
Jun  6 17:25:44 upstairs kernel: parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)] 
Jun  6 17:25:44 upstairs kernel: parport_pc 00:06: driver attached 
Jun  6 17:25:44 upstairs kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  6 17:25:44 upstairs kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb2: Product: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb2: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb2: SerialNumber: 0000:00:1d.1 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18 
Jun  6 17:25:44 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b400 
Jun  6 17:25:44 upstairs kernel: usb usb3: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 3-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 3-0:1.0: 2 ports detected 
Jun  6 17:25:44 upstairs kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  6 17:25:44 upstairs kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb3: Product: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb3: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb3: SerialNumber: 0000:00:1d.2 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 16 
Jun  6 17:25:44 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000b800 
Jun  6 17:25:44 upstairs kernel: usb usb4: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 4-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 4-0:1.0: 2 ports detected 
Jun  6 17:25:44 upstairs kernel: usb 1-2: new full speed USB device using uhci_hcd and address 2 
Jun  6 17:25:44 upstairs kernel: usb 1-2: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: usb 1-2: New USB device found, idVendor=06bd, idProduct=2061 
Jun  6 17:25:44 upstairs kernel: usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  6 17:25:44 upstairs kernel: usb 1-2: Product: SNAPSCAN 
Jun  6 17:25:44 upstairs kernel: usb 1-2: Manufacturer: AGFA  
Jun  6 17:25:44 upstairs kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  6 17:25:44 upstairs kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb4: Product: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb4: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb4: SerialNumber: 0000:00:1d.3 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 23 
Jun  6 17:25:44 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:00:1d.7: debug port 1 
Jun  6 17:25:44 upstairs kernel: PCI: cache line size of 128 is not supported by device 0000:00:1d.7 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fffc00 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
Jun  6 17:25:44 upstairs kernel: usb usb5: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 5-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 5-0:1.0: 8 ports detected 
Jun  6 17:25:44 upstairs kernel: usb usb5: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  6 17:25:44 upstairs kernel: usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb5: Product: EHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb5: Manufacturer: Linux 2.6.26-rc5 ehci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb5: SerialNumber: 0000:00:1d.7 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 17 (level, low) -> IRQ 17 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:02:09.0: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:02:09.0: new USB bus registered, assigned bus number 6 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:02:09.0: irq 17, io base 0x0000e400 
Jun  6 17:25:44 upstairs kernel: usb usb6: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 6-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 6-0:1.0: 2 ports detected 
Jun  6 17:25:44 upstairs kernel: usb usb6: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  6 17:25:44 upstairs kernel: usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb6: Product: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb6: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb6: SerialNumber: 0000:02:09.0 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 18 (level, low) -> IRQ 18 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:02:09.1: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:02:09.1: new USB bus registered, assigned bus number 7 
Jun  6 17:25:44 upstairs kernel: uhci_hcd 0000:02:09.1: irq 18, io base 0x0000e800 
Jun  6 17:25:44 upstairs kernel: usb usb7: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 7-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 7-0:1.0: 2 ports detected 
Jun  6 17:25:44 upstairs kernel: usb usb7: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  6 17:25:44 upstairs kernel: usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb7: Product: UHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb7: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb7: SerialNumber: 0000:02:09.1 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.2[C] -> GSI 19 (level, low) -> IRQ 19 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:02:09.2: EHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:02:09.2: new USB bus registered, assigned bus number 8 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:02:09.2: irq 19, io mem 0xfbfffc00 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:02:09.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
Jun  6 17:25:44 upstairs kernel: usb usb8: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 8-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 8-0:1.0: 4 ports detected 
Jun  6 17:25:44 upstairs kernel: usb usb8: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  6 17:25:44 upstairs kernel: usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb8: Product: EHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb8: Manufacturer: Linux 2.6.26-rc5 ehci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb8: SerialNumber: 0000:02:09.2 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 21 (level, low) -> IRQ 21 
Jun  6 17:25:44 upstairs kernel: ohci_hcd 0000:02:0a.0: OHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: ohci_hcd 0000:02:0a.0: new USB bus registered, assigned bus number 9 
Jun  6 17:25:44 upstairs kernel: ohci_hcd 0000:02:0a.0: irq 21, io mem 0xfbffd000 
Jun  6 17:25:44 upstairs kernel: usb 1-2: USB disconnect, address 2 
Jun  6 17:25:44 upstairs kernel: usb usb9: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 9-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 9-0:1.0: 3 ports detected 
Jun  6 17:25:44 upstairs kernel: usb 1-2: new full speed USB device using uhci_hcd and address 3 
Jun  6 17:25:44 upstairs kernel: usb 1-2: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: usb 1-2: New USB device found, idVendor=06bd, idProduct=2061 
Jun  6 17:25:44 upstairs kernel: usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  6 17:25:44 upstairs kernel: usb 1-2: Product: SNAPSCAN 
Jun  6 17:25:44 upstairs kernel: usb 1-2: Manufacturer: AGFA  
Jun  6 17:25:44 upstairs kernel: usb usb9: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  6 17:25:44 upstairs kernel: usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb9: Product: OHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb9: Manufacturer: Linux 2.6.26-rc5 ohci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb9: SerialNumber: 0000:02:0a.0 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.1[B] -> GSI 22 (level, low) -> IRQ 22 
Jun  6 17:25:44 upstairs kernel: ohci_hcd 0000:02:0a.1: OHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: ohci_hcd 0000:02:0a.1: new USB bus registered, assigned bus number 10 
Jun  6 17:25:44 upstairs kernel: ohci_hcd 0000:02:0a.1: irq 22, io mem 0xfbffe000 
Jun  6 17:25:44 upstairs kernel: usb 8-1: new high speed USB device using ehci_hcd and address 2 
Jun  6 17:25:44 upstairs kernel: usb 8-1: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: usb 8-1: New USB device found, idVendor=2040, idProduct=9950 
Jun  6 17:25:44 upstairs kernel: usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3 
Jun  6 17:25:44 upstairs kernel: usb 8-1: Product: WinTV Nova-DT 
Jun  6 17:25:44 upstairs kernel: usb 8-1: Manufacturer: Hauppauge 
Jun  6 17:25:44 upstairs kernel: usb 8-1: SerialNumber: 4030248054 
Jun  6 17:25:44 upstairs kernel: usb 2-1: new full speed USB device using uhci_hcd and address 2 
Jun  6 17:25:44 upstairs kernel: usb 2-1: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: usb 2-1: New USB device found, idVendor=04b8, idProduct=0005 
Jun  6 17:25:44 upstairs kernel: usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3 
Jun  6 17:25:44 upstairs kernel: usb 2-1: Product: USB Printer 
Jun  6 17:25:44 upstairs kernel: usb 2-1: Manufacturer: EPSON 
Jun  6 17:25:44 upstairs kernel: usb 2-1: SerialNumber: L80020307150840450 
Jun  6 17:25:44 upstairs kernel: usb usb10: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 10-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 10-0:1.0: 2 ports detected 
Jun  6 17:25:44 upstairs kernel: usb 2-2: new low speed USB device using uhci_hcd and address 3 
Jun  6 17:25:44 upstairs kernel: usb 2-2: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: usb 2-2: New USB device found, idVendor=045e, idProduct=00f1 
Jun  6 17:25:44 upstairs kernel: usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  6 17:25:44 upstairs kernel: usb 2-2: Product: Microsoft Wireless Desktop Receiver 3.1A 
Jun  6 17:25:44 upstairs kernel: usb 2-2: Manufacturer: Microsft 
Jun  6 17:25:44 upstairs kernel: usb 9-2: new full speed USB device using ohci_hcd and address 2 
Jun  6 17:25:44 upstairs kernel: usb 9-2: not running at top speed; connect to a high speed hub 
Jun  6 17:25:44 upstairs kernel: usb 9-2: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 9-2:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 9-2:1.0: 4 ports detected 
Jun  6 17:25:44 upstairs kernel: usb usb10: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  6 17:25:44 upstairs kernel: usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb10: Product: OHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb10: Manufacturer: Linux 2.6.26-rc5 ohci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb10: SerialNumber: 0000:02:0a.1 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.2[C] -> GSI 23 (level, low) -> IRQ 23 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:02:0a.2: EHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:02:0a.2: new USB bus registered, assigned bus number 11 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:02:0a.2: irq 23, io mem 0xfbfff800 
Jun  6 17:25:44 upstairs kernel: ehci_hcd 0000:02:0a.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004 
Jun  6 17:25:44 upstairs kernel: usb usb11: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 11-0:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 11-0:1.0: 5 ports detected 
Jun  6 17:25:44 upstairs kernel: usb 9-2: New USB device found, idVendor=0409, idProduct=0059 
Jun  6 17:25:44 upstairs kernel: usb 9-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0 
Jun  6 17:25:44 upstairs kernel: usb 9-2: USB disconnect, address 2 
Jun  6 17:25:44 upstairs kernel: usb usb11: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  6 17:25:44 upstairs kernel: usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  6 17:25:44 upstairs kernel: usb usb11: Product: EHCI Host Controller 
Jun  6 17:25:44 upstairs kernel: usb usb11: Manufacturer: Linux 2.6.26-rc5 ehci_hcd 
Jun  6 17:25:44 upstairs kernel: usb usb11: SerialNumber: 0000:02:0a.2 
Jun  6 17:25:44 upstairs kernel: ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 22 (level, low) -> IRQ 22 
Jun  6 17:25:44 upstairs kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fbfff000-fbfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8] 
Jun  6 17:25:44 upstairs kernel: usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005 
Jun  6 17:25:44 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.0/input/input2 
Jun  6 17:25:44 upstairs kernel: input: USB HID v1.11 Keyboard [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun  6 17:25:44 upstairs kernel: usb 11-3: new high speed USB device using ehci_hcd and address 2 
Jun  6 17:25:44 upstairs kernel: dib0700: loaded with support for 7 different device-types 
Jun  6 17:25:44 upstairs kernel: dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state. 
Jun  6 17:25:44 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun  6 17:25:44 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun  6 17:25:44 upstairs kernel: usb 11-3: configuration #1 chosen from 1 choice 
Jun  6 17:25:44 upstairs kernel: hub 11-3:1.0: USB hub found 
Jun  6 17:25:44 upstairs kernel: hub 11-3:1.0: 4 ports detected 
Jun  6 17:25:44 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.1/input/input3 
Jun  6 17:25:44 upstairs kernel: input: USB HID v1.11 Mouse [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun  6 17:25:44 upstairs kernel: DVB: registering frontend 0 (DiBcom 3000MC/P)... 
Jun  6 17:25:44 upstairs kernel: usb 11-3: New USB device found, idVendor=0409, idProduct=0059 
Jun  6 17:25:44 upstairs kernel: usb 11-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0 
Jun  6 17:25:44 upstairs kernel: usbcore: registered new interface driver usblp 
Jun  6 17:25:44 upstairs kernel: usbcore: registered new interface driver usbhid 
Jun  6 17:25:44 upstairs kernel: usbhid: v2.6:USB HID core driver 
Jun  6 17:25:44 upstairs kernel: MT2060: successfully identified (IF1 = 1230) 
Jun  6 17:25:44 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun  6 17:25:44 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun  6 17:25:44 upstairs kernel: DVB: registering frontend 1 (DiBcom 3000MC/P)... 
Jun  6 17:25:44 upstairs kernel: MT2060: successfully identified (IF1 = 1234) 
Jun  6 17:25:44 upstairs kernel: ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
Jun  6 17:25:44 upstairs kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:09.2/usb8/8-1/input/input4 
Jun  6 17:25:44 upstairs kernel: dvb-usb: schedule remote query interval to 150 msecs. 
Jun  6 17:25:44 upstairs kernel: dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and connected. 
Jun  6 17:25:44 upstairs kernel: usbcore: registered new interface driver dvb_usb_dib0700 
Jun  6 17:25:44 upstairs kernel: fuse init (API version 7.9) 
Jun  6 17:25:44 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  6 17:25:44 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  6 17:25:44 upstairs kernel: EXT3 FS on sdb6, internal journal 
Jun  6 17:25:44 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  6 17:25:44 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  6 17:25:44 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  6 17:25:44 upstairs kernel: EXT3 FS on sda6, internal journal 
Jun  6 17:25:44 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  6 17:25:44 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  6 17:25:44 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  6 17:25:44 upstairs kernel: EXT3 FS on sda7, internal journal 
Jun  6 17:25:44 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  6 17:25:44 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  6 17:25:44 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  6 17:25:44 upstairs kernel: EXT3 FS on sdc2, internal journal 
Jun  6 17:25:44 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  6 17:25:44 upstairs kernel: Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k 
Jun  6 17:25:44 upstairs kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1 
Jun  6 17:25:44 upstairs kernel: ip_tables: (C) 2000-2006 Netfilter Core Team 
Jun  6 17:25:44 upstairs kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max) 
Jun  6 17:25:44 upstairs kernel: parport_pc 00:06: disabled 
Jun  6 17:25:44 upstairs kernel: pnp: the driver 'parport_pc' has been unregistered 
Jun  6 17:25:44 upstairs kernel: ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
Jun  6 17:26:31 upstairs kernel: usb 11-2: new high speed USB device using ehci_hcd and address 3 
Jun  6 17:26:31 upstairs kernel: usb 11-2: configuration #1 chosen from 1 choice 
Jun  6 17:26:31 upstairs kernel: usb 11-2: New USB device found, idVendor=0930, idProduct=6545 
Jun  6 17:26:31 upstairs kernel: usb 11-2: New USB device strings: Mfr=0, Product=2, SerialNumber=3 
Jun  6 17:26:31 upstairs kernel: usb 11-2: Product: USB Flash Memory 
Jun  6 17:26:31 upstairs kernel: usb 11-2: SerialNumber: 0EC065712361A91E 
Jun  6 17:26:31 upstairs kernel: Initializing USB Mass Storage driver... 
Jun  6 17:26:31 upstairs kernel: scsi4 : SCSI emulation for USB Mass Storage devices 
Jun  6 17:26:31 upstairs kernel: usbcore: registered new interface driver usb-storage 
Jun  6 17:26:31 upstairs kernel: USB Mass Storage support registered. 
Jun  6 17:26:31 upstairs kernel: usb-storage: device found at 3 
Jun  6 17:26:31 upstairs kernel: usb-storage: waiting for device to settle before scanning 
Jun  6 17:26:36 upstairs kernel: scsi 4:0:0:0: Direct-Access              USB Flash Memory 5.00 PQ: 0 ANSI: 0 CCS 
Jun  6 17:26:37 upstairs kernel: sd 4:0:0:0: [sdd] 2013184 512-byte hardware sectors (1031 MB) 
Jun  6 17:26:37 upstairs kernel: sd 4:0:0:0: [sdd] Write Protect is off 
Jun  6 17:26:37 upstairs kernel: sd 4:0:0:0: [sdd] Mode Sense: 23 00 00 00 
Jun  6 17:26:37 upstairs kernel: sd 4:0:0:0: [sdd] Assuming drive cache: write through 
Jun  6 17:26:38 upstairs kernel: sd 4:0:0:0: [sdd] 2013184 512-byte hardware sectors (1031 MB) 
Jun  6 17:26:38 upstairs kernel: sd 4:0:0:0: [sdd] Write Protect is off 
Jun  6 17:26:38 upstairs kernel: sd 4:0:0:0: [sdd] Mode Sense: 23 00 00 00 
Jun  6 17:26:38 upstairs kernel: sd 4:0:0:0: [sdd] Assuming drive cache: write through 
Jun  6 17:26:38 upstairs kernel:  sdd: sdd1 
Jun  6 17:26:38 upstairs kernel: sd 4:0:0:0: [sdd] Attached SCSI removable disk 
Jun  6 17:26:38 upstairs kernel: usb-storage: device scan complete 

--Boundary-00=_nVXSIFEmpRicM/1--
