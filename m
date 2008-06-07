From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Sat, 7 Jun 2008 05:16:44 +0000
Message-ID: <200806070516.44291.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <20080606110345.581fdc77.akpm@linux-foundation.org> <1212777612.16182.21.camel@localhost.localdomain>
Reply-To: chris2553@googlemail.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8mhSILcXFhxThCy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:62100 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYFGFTX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jun 2008 01:19:23 -0400
Received: by ik-out-1112.google.com with SMTP id c28so737603ika.5
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2008 22:19:20 -0700 (PDT)
In-Reply-To: <1212777612.16182.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>

--Boundary-00=_8mhSILcXFhxThCy
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 06 June 2008, James Bottomley wrote:
> On Fri, 2008-06-06 at 11:03 -0700, Andrew Morton wrote:
> > On Fri, 06 Jun 2008 10:22:22 -0500 James Bottomley=20
<James.Bottomley@HansenPartnership.com> wrote:
> > > On Thu, 2008-06-05 at 23:25 -0700, Andrew Morton wrote:
> > > > On Thu, 5 Jun 2008 23:21:45 -0700 Andrew Morton=20
<akpm@linux-foundation.org> wrote:
> > > > > <watches wodim wibble for five minutes then report "CD/DVD-Record=
er
> > > > > not ready."  Pretends not to have noticed.>
> > > >
> > > > It goes much better when the CD is inserted upside up.
> > >
> > > So I can close this regression if I send you a pack of CD ring labels
> > > with "other way up" on them for you to affix to the underside of your
> > > CDs ... ?
> >
> > Would prefer double-sided CDs.
>
> I just discovered my budget only runs to a permanent marker for you to
> write the instructions on the rim yourself ...
>
> > Is this 20-second-delay thing known-about/expected/etc?
>
> If it's not the scsi_bus_uevent problem, then no, it isn't.
>
> The odd thing is that it occurs in the middle of USB initialisation from
>
> the log:
> > =EF=BB=BFJun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: UHCI H=
ost
> > Controller Jun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: new
> > USB bus registered, assigned bus number 1 Jun  6 17:25:19 upstairs
> > kernel: uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000a800 Jun  6 17:25:=
19
> > upstairs kernel: usb usb1: configuration #1 chosen from 1 choice Jun  6
> > 17:25:19 upstairs kernel: hub 1-0:1.0: USB hub found
> > Jun  6 17:25:19 upstairs kernel: hub 1-0:1.0: 2 ports detected
> > Jun  6 17:25:44 upstairs kernel: ohci_hcd: 2006 August 04 USB 1.1 'Open'
> > Host Controller (OHCI) Driver Jun  6 17:25:44 upstairs kernel: usb usb1:
> > New USB device found, idVendor=3D1d6b, idProduct=3D0001 Jun  6 17:25:44
> > upstairs kernel: usb usb1: New USB device strings: Mfr=3D3, Product=3D2,
> > SerialNumber=3D1 Jun  6 17:25:44 upstairs kernel: usb usb1: Product: UH=
CI
> > Host Controller Jun  6 17:25:44 upstairs kernel: usb usb1: Manufacturer:
> > Linux 2.6.26-rc5 uhci_hcd
>
> Note the jump from 19 to 44 seconds.
>
> There's another one here:
> > =EF=BB=BFJun  6 17:25:44 upstairs kernel: EXT3-fs: mounted filesystem w=
ith
> > ordered data mode. Jun  6 17:25:44 upstairs kernel: Adding 4096532k swap
> > on /dev/sda5.  Priority:-1 extents:1 across:4096532k Jun  6 17:25:44
> > upstairs kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1 Jun  6
> > 17:25:44 upstairs kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
> > Jun  6 17:25:44 upstairs kernel: nf_conntrack version 0.5.0 (16384
> > buckets, 65536 max) Jun  6 17:25:44 upstairs kernel: parport_pc 00:06:
> > disabled
> > Jun  6 17:25:44 upstairs kernel: pnp: the driver 'parport_pc' has been
> > unregistered Jun  6 17:25:44 upstairs kernel: ieee1394: Node removed:
> > ID:BUS[0-00:1023]  GUID[00110666000013cc] Jun  6 17:26:31 upstairs
> > kernel: usb 11-2: new high speed USB device using ehci_hcd and address 3
> > Jun  6 17:26:31 upstairs kernel: usb 11-2: configuration #1 chosen from=
 1
> > choice Jun  6 17:26:31 upstairs kernel: usb 11-2: New USB device found,
> > idVendor=3D0930, idProduct=3D6545 Jun  6 17:26:31 upstairs kernel: usb =
11-2:
> > New USB device strings: Mfr=3D0, Product=3D2, SerialNumber=3D3 Jun  6 1=
7:26:31
> > upstairs kernel: usb 11-2: Product: USB Flash Memory Jun  6 17:26:31
> > upstairs kernel: usb 11-2: SerialNumber: 0EC065712361A91E
>
> I'm a bit baffled as to how that could be SCSI related, but I suppose it
> could be udev related somehow.  Perhaps turning on driver core debugging
> might help (that's CONFIG_DEBUG DRIVER ... it depends on
> CONFIG_DEBUG_KERNEL for activation).  Hopefully the verbose kernel logs
> from here might tell us what's going on in the lacunae.
>

OK, here's a boot log with driver core debugging turned on. Hope it helps!

(Oh, and thanks for adding the word lacunae to my vocabulary. I'd never com=
e=20
across it before.)

Chris

> James



=2D-=20
Beauty is in the eye of the beerholder.

--Boundary-00=_8mhSILcXFhxThCy
Content-Type: text/x-log;
  charset="utf-8";
  name="driverdebug.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="driverdebug.log"

Jun  7 04:51:03 upstairs kernel: klogd 1.3-3, log source = /proc/kmsg started.
Jun  7 04:51:03 upstairs kernel: Inspecting /boot/System.map-2.6.26-rc5
Jun  7 04:51:04 upstairs kernel: Loaded 26357 symbols from /boot/System.map-2.6.26-rc5.
Jun  7 04:51:04 upstairs kernel: Symbols match kernel version 2.6.26.
Jun  7 04:51:04 upstairs kernel: No module symbols loaded - kernel modules not enabled. 
Jun  7 04:51:04 upstairs kernel: evice, IDs PNP0c04 (active) 
Jun  7 04:51:04 upstairs kernel: pnp 00:05: parse allocated resources 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   add irq 6 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   add dma 2 flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   add io  0x3f0-0x3f5 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   add io  0x3f7-0x3f7 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05: parse resource options 
Jun  7 04:51:04 upstairs kernel: pnp 00:05: new independent option 
Jun  7 04:51:04 upstairs kernel: pnp 00:05: new dependent option (priority 0x0) 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000040 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   dma bitmask 0x4 flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   io  min 0x3f0 max 0x3f0 align 1 size 6 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   io  min 0x3f7 max 0x3f7 align 1 size 1 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05: new dependent option (priority 0x1) 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   dma bitmask 0xe flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   io  min 0x3f0 max 0x3f0 align 1 size 6 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   io  min 0x3f7 max 0x3f7 align 1 size 1 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05: new dependent option (priority 0x1) 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   dma bitmask 0xe flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   io  min 0x370 max 0x370 align 1 size 6 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05:   io  min 0x377 max 0x377 align 1 size 1 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:05: end dependent options 
Jun  7 04:51:04 upstairs kernel: pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (active) 
Jun  7 04:51:04 upstairs kernel: pnp 00:06: parse allocated resources 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   add io  0x378-0x37f flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   add io  0x778-0x77b flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   add irq 7 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   add dma 3 flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:06: parse resource options 
Jun  7 04:51:04 upstairs kernel: pnp 00:06: new independent option 
Jun  7 04:51:04 upstairs kernel: pnp 00:06: new dependent option (priority 0x0) 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   io  min 0x378 max 0x378 align 1 size 8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   io  min 0x778 max 0x778 align 1 size 4 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000080 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   dma bitmask 0x8 flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:06: new dependent option (priority 0x1) 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   io  min 0x378 max 0x378 align 1 size 8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   io  min 0x778 max 0x778 align 1 size 4 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   dma bitmask 0xb flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:06: new dependent option (priority 0x1) 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   io  min 0x278 max 0x278 align 1 size 8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   io  min 0x678 max 0x678 align 1 size 4 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   dma bitmask 0xb flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:06: new dependent option (priority 0x1) 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   io  min 0x3bc max 0x3bc align 1 size 4 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   io  min 0x7bc max 0x7bc align 1 size 4 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:06:   dma bitmask 0xb flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:06: end dependent options 
Jun  7 04:51:04 upstairs kernel: pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active) 
Jun  7 04:51:04 upstairs kernel: pnp 00:07: parse allocated resources 
Jun  7 04:51:04 upstairs kernel: pnp 00:07:   add io  0x0-0xffffffff flags 0x10000001 
Jun  7 04:51:04 upstairs kernel: pnp 00:07:   add io  0x0-0xffffffff flags 0x10000001 
Jun  7 04:51:04 upstairs kernel: pnp 00:07:   add io  0x290-0x297 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:07: PNP0c02: calling quirk_system_pci_resources+0x0/0x1c1 
Jun  7 04:51:04 upstairs kernel: pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active) 
Jun  7 04:51:04 upstairs kernel: pnp 00:08: parse allocated resources 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x10-0x1f flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x22-0x3f flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x44-0x5f flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x62-0x63 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x65-0x6f flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x72-0x7f flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x80-0x80 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x84-0x86 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x88-0x88 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x8c-0x8e flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x90-0x9f flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0xa2-0xbf flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0xe0-0xef flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x4d0-0x4d1 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x800-0x87f flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x400-0x41f flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add io  0x480-0x4bf flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add mem 0xfed20000-0xfed8ffff flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08:   add mem 0xffb00000-0xffbfffff flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08: PNP0c02: calling quirk_system_pci_resources+0x0/0x1c1 
Jun  7 04:51:04 upstairs kernel: pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active) 
Jun  7 04:51:04 upstairs kernel: pnp 00:09: parse allocated resources 
Jun  7 04:51:04 upstairs kernel: pnp 00:09:   add mem 0xfec00000-0xfec00fff flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:09:   add mem 0xfee00000-0xfee00fff flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:09: PNP0c02: calling quirk_system_pci_resources+0x0/0x1c1 
Jun  7 04:51:04 upstairs kernel: pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active) 
Jun  7 04:51:04 upstairs kernel: pnp 00:0a: parse allocated resources 
Jun  7 04:51:04 upstairs kernel: pnp 00:0a:   add io  0x60-0x60 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0a:   add io  0x64-0x64 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0a:   add irq 1 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active) 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: parse allocated resources 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   add io  0x3f8-0x3ff flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   add irq 4 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: parse resource options 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: new independent option 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: new dependent option (priority 0x0) 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   io  min 0x3f8 max 0x3f8 align 4 size 8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000010 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: new dependent option (priority 0x1) 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: new dependent option (priority 0x1) 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: new dependent option (priority 0x1) 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: new dependent option (priority 0x1) 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: end dependent options 
Jun  7 04:51:04 upstairs kernel: pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active) 
Jun  7 04:51:04 upstairs kernel: pnp 00:0c: parse allocated resources 
Jun  7 04:51:04 upstairs kernel: pnp 00:0c:   add mem 0x0-0x9ffff flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0c:   add mem 0xc0000-0xdffff flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:0c:   add mem 0xe0000-0xfffff flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:0c:   add mem 0x100000-0x7ffeffff flags 0x1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0c:   add mem 0xfff00000-0xffffffff flags 0x0 
Jun  7 04:51:04 upstairs kernel: pnp 00:0c: PNP0c01: calling quirk_system_pci_resources+0x0/0x1c1 
Jun  7 04:51:04 upstairs kernel: pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active) 
Jun  7 04:51:04 upstairs kernel: pnp: PnP ACPI: found 13 devices 
Jun  7 04:51:04 upstairs kernel: ACPI: ACPI bus type pnp unregistered 
Jun  7 04:51:04 upstairs kernel: SCSI subsystem initialized 
Jun  7 04:51:04 upstairs kernel: libata version 3.00 loaded. 
Jun  7 04:51:04 upstairs kernel: usbcore: registered new interface driver usbfs 
Jun  7 04:51:04 upstairs kernel: usbcore: registered new interface driver hub 
Jun  7 04:51:04 upstairs kernel: usbcore: registered new device driver usb 
Jun  7 04:51:04 upstairs kernel: PCI: Using ACPI for IRQ routing 
Jun  7 04:51:04 upstairs kernel: pnp: the driver 'system' has been registered 
Jun  7 04:51:04 upstairs kernel: system 00:07: ioport range 0x290-0x297 has been reserved 
Jun  7 04:51:04 upstairs kernel: system 00:07: iomem range 0x0-0x0 could not be reserved 
Jun  7 04:51:04 upstairs last message repeated 23 times
Jun  7 04:51:04 upstairs kernel: system 00:07: driver attached 
Jun  7 04:51:04 upstairs kernel: system 00:08: ioport range 0x4d0-0x4d1 has been reserved 
Jun  7 04:51:04 upstairs kernel: system 00:08: ioport range 0x800-0x87f has been reserved 
Jun  7 04:51:04 upstairs kernel: system 00:08: ioport range 0x400-0x41f has been reserved 
Jun  7 04:51:04 upstairs kernel: system 00:08: ioport range 0x480-0x4bf has been reserved 
Jun  7 04:51:04 upstairs kernel: system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved 
Jun  7 04:51:04 upstairs kernel: system 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved 
Jun  7 04:51:04 upstairs kernel: system 00:08: iomem range 0x0-0x0 could not be reserved 
Jun  7 04:51:04 upstairs last message repeated 21 times
Jun  7 04:51:04 upstairs kernel: system 00:08: driver attached 
Jun  7 04:51:04 upstairs kernel: system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved 
Jun  7 04:51:04 upstairs kernel: system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved 
Jun  7 04:51:04 upstairs kernel: system 00:09: iomem range 0x0-0x0 could not be reserved 
Jun  7 04:51:04 upstairs last message repeated 21 times
Jun  7 04:51:04 upstairs kernel: system 00:09: driver attached 
Jun  7 04:51:04 upstairs kernel: system 00:0c: iomem range 0x0-0x9ffff could not be reserved 
Jun  7 04:51:04 upstairs kernel: system 00:0c: iomem range 0xc0000-0xdffff could not be reserved 
Jun  7 04:51:04 upstairs kernel: system 00:0c: iomem range 0xe0000-0xfffff could not be reserved 
Jun  7 04:51:04 upstairs kernel: system 00:0c: iomem range 0x100000-0x7ffeffff could not be reserved 
Jun  7 04:51:04 upstairs kernel: system 00:0c: iomem range 0xfff00000-0xffffffff could not be reserved 
Jun  7 04:51:04 upstairs kernel: system 00:0c: iomem range 0x0-0x0 could not be reserved 
Jun  7 04:51:04 upstairs last message repeated 18 times
Jun  7 04:51:04 upstairs kernel: system 00:0c: driver attached 
Jun  7 04:51:04 upstairs kernel: PCI: Bridge: 0000:00:01.0 
Jun  7 04:51:04 upstairs kernel:   IO window: c000-cfff 
Jun  7 04:51:04 upstairs kernel:   MEM window: 0xfa000000-0xfbefffff 
Jun  7 04:51:04 upstairs kernel:   PREFETCH window: 0x00000000f0000000-0x00000000f8ffffff 
Jun  7 04:51:04 upstairs kernel: PCI: Bridge: 0000:00:1e.0 
Jun  7 04:51:04 upstairs kernel:   IO window: d000-efff 
Jun  7 04:51:04 upstairs kernel:   MEM window: 0xfbf00000-0xfbffffff 
Jun  7 04:51:04 upstairs kernel:   PREFETCH window: disabled. 
Jun  7 04:51:04 upstairs kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64 
Jun  7 04:51:04 upstairs kernel: NET: Registered protocol family 2 
Jun  7 04:51:04 upstairs kernel: IP route cache hash table entries: 32768 (order: 5, 131072 bytes) 
Jun  7 04:51:04 upstairs kernel: TCP established hash table entries: 131072 (order: 8, 1048576 bytes) 
Jun  7 04:51:04 upstairs kernel: TCP bind hash table entries: 65536 (order: 7, 524288 bytes) 
Jun  7 04:51:04 upstairs kernel: TCP: Hash tables configured (established 131072 bind 65536) 
Jun  7 04:51:04 upstairs kernel: TCP reno registered 
Jun  7 04:51:04 upstairs kernel: NET: Registered protocol family 1 
Jun  7 04:51:04 upstairs kernel: highmem bounce pool size: 64 pages 
Jun  7 04:51:04 upstairs kernel: msgmni has been set to 1750 for ipc namespace c03dea00 
Jun  7 04:51:04 upstairs kernel: io scheduler noop registered 
Jun  7 04:51:04 upstairs kernel: io scheduler cfq registered (default) 
Jun  7 04:51:04 upstairs kernel: pci 0000:01:00.0: Boot video device 
Jun  7 04:51:04 upstairs kernel: input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0 
Jun  7 04:51:04 upstairs kernel: ACPI: Power Button (FF) [PWRF] 
Jun  7 04:51:04 upstairs kernel: input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1 
Jun  7 04:51:04 upstairs kernel: ACPI: Power Button (CM) [PWRB] 
Jun  7 04:51:04 upstairs kernel: ACPI: ACPI0007:00 is registered as cooling_device0 
Jun  7 04:51:04 upstairs kernel: ACPI: Processor [CPU1] (supports 8 throttling states) 
Jun  7 04:51:04 upstairs kernel: ACPI: ACPI0007:01 is registered as cooling_device1 
Jun  7 04:51:04 upstairs kernel: Real Time Clock Driver v1.12ac 
Jun  7 04:51:04 upstairs kernel: Linux agpgart interface v0.103 
Jun  7 04:51:04 upstairs kernel: agpgart: Detected an Intel 865 Chipset. 
Jun  7 04:51:04 upstairs kernel: agpgart: AGP aperture is 64M @ 0xec000000 
Jun  7 04:51:04 upstairs kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled 
Jun  7 04:51:04 upstairs kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A 
Jun  7 04:51:04 upstairs kernel: pnp: the driver 'serial' has been registered 
Jun  7 04:51:04 upstairs kernel: 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A 
Jun  7 04:51:04 upstairs kernel: serial 00:0b: driver attached 
Jun  7 04:51:04 upstairs kernel: 8139too Fast Ethernet driver 0.9.28 
Jun  7 04:51:04 upstairs kernel: ACPI: PCI Interrupt 0000:02:0d.0[A] -> GSI 23 (level, low) -> IRQ 23 
Jun  7 04:51:04 upstairs kernel: eth0: RealTek RTL8139 at 0xf8816c00, 00:17:31:a9:1d:48, IRQ 23 
Jun  7 04:51:04 upstairs kernel: eth0:  Identified 8139 chip type 'RTL-8100B/8139D' 
Jun  7 04:51:04 upstairs kernel: Driver 'sd' needs updating - please use bus_type methods 
Jun  7 04:51:04 upstairs kernel: Driver 'sr' needs updating - please use bus_type methods 
Jun  7 04:51:04 upstairs kernel: ata_piix 0000:00:1f.1: version 2.12 
Jun  7 04:51:04 upstairs kernel: ata_piix 0000:00:1f.1: enabling device (0005 -> 0007) 
Jun  7 04:51:04 upstairs kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18 
Jun  7 04:51:04 upstairs kernel: PCI: Setting latency timer of device 0000:00:1f.1 to 64 
Jun  7 04:51:04 upstairs kernel: scsi0 : ata_piix 
Jun  7 04:51:04 upstairs kernel: scsi1 : ata_piix 
Jun  7 04:51:04 upstairs kernel: ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14 
Jun  7 04:51:04 upstairs kernel: ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15 
Jun  7 04:51:04 upstairs kernel: ata1.00: ATA-7: MAXTOR STM3250820A, 3.AAE, max UDMA/100 
Jun  7 04:51:04 upstairs kernel: ata1.00: 488397168 sectors, multi 16: LBA48  
Jun  7 04:51:04 upstairs kernel: ata1.01: ATA-7: Maxtor 6L160P0, BAJ41G20, max UDMA/133 
Jun  7 04:51:04 upstairs kernel: ata1.01: 320173056 sectors, multi 16: LBA48  
Jun  7 04:51:04 upstairs kernel: ata1.00: configured for UDMA/100 
Jun  7 04:51:04 upstairs kernel: ata1.01: configured for UDMA/100 
Jun  7 04:51:04 upstairs kernel: ata2.00: ATAPI: SONY    DVD RW DW-G120A, MYS2, max UDMA/66 
Jun  7 04:51:04 upstairs kernel: ata2.01: ATAPI: PHILIPS DVDR1628P1, Q2.2, max UDMA/33 
Jun  7 04:51:04 upstairs kernel: Switched to NOHz mode on CPU #1 
Jun  7 04:51:04 upstairs kernel: Switched to NOHz mode on CPU #0 
Jun  7 04:51:04 upstairs kernel: ata2.00: configured for UDMA/66 
Jun  7 04:51:04 upstairs kernel: ata2.01: configured for UDMA/33 
Jun  7 04:51:04 upstairs kernel: scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM325082 3.AA PQ: 0 ANSI: 5 
Jun  7 04:51:04 upstairs kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB) 
Jun  7 04:51:04 upstairs kernel: sd 0:0:0:0: [sda] Write Protect is off 
Jun  7 04:51:04 upstairs kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00 
Jun  7 04:51:04 upstairs kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  7 04:51:04 upstairs kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB) 
Jun  7 04:51:04 upstairs kernel: sd 0:0:0:0: [sda] Write Protect is off 
Jun  7 04:51:04 upstairs kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00 
Jun  7 04:51:04 upstairs kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  7 04:51:04 upstairs kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 > 
Jun  7 04:51:04 upstairs kernel: sd 0:0:0:0: [sda] Attached SCSI disk 
Jun  7 04:51:04 upstairs kernel: scsi 0:0:1:0: Direct-Access     ATA      Maxtor 6L160P0   BAJ4 PQ: 0 ANSI: 5 
Jun  7 04:51:04 upstairs kernel: sd 0:0:1:0: [sdb] 320173056 512-byte hardware sectors (163929 MB) 
Jun  7 04:51:04 upstairs kernel: sd 0:0:1:0: [sdb] Write Protect is off 
Jun  7 04:51:04 upstairs kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00 
Jun  7 04:51:04 upstairs kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  7 04:51:04 upstairs kernel: sd 0:0:1:0: [sdb] 320173056 512-byte hardware sectors (163929 MB) 
Jun  7 04:51:04 upstairs kernel: sd 0:0:1:0: [sdb] Write Protect is off 
Jun  7 04:51:04 upstairs kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00 
Jun  7 04:51:04 upstairs kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  7 04:51:04 upstairs kernel:  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 > 
Jun  7 04:51:04 upstairs kernel:  sdb2: <bsd: sdb9 sdb10 sdb11 sdb12 sdb13 > 
Jun  7 04:51:04 upstairs kernel: sd 0:0:1:0: [sdb] Attached SCSI disk 
Jun  7 04:51:04 upstairs kernel: scsi 1:0:0:0: CD-ROM            SONY     DVD RW DW-G120A  MYS2 PQ: 0 ANSI: 5 
Jun  7 04:51:04 upstairs kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray 
Jun  7 04:51:04 upstairs kernel: Uniform CD-ROM driver Revision: 3.20 
Jun  7 04:51:04 upstairs kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0 
Jun  7 04:51:04 upstairs kernel: scsi 1:0:1:0: CD-ROM            PHILIPS  DVDR1628P1       Q2.2 PQ: 0 ANSI: 5 
Jun  7 04:51:04 upstairs kernel: sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray 
Jun  7 04:51:04 upstairs kernel: sr 1:0:1:0: Attached scsi CD-ROM sr1 
Jun  7 04:51:04 upstairs kernel: ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 18 
Jun  7 04:51:04 upstairs kernel: ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ] 
Jun  7 04:51:04 upstairs kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64 
Jun  7 04:51:04 upstairs kernel: scsi2 : ata_piix 
Jun  7 04:51:04 upstairs kernel: scsi3 : ata_piix 
Jun  7 04:51:04 upstairs kernel: ata3: SATA max UDMA/133 cmd 0x9800 ctl 0x9400 bmdma 0x8400 irq 18 
Jun  7 04:51:04 upstairs kernel: ata4: SATA max UDMA/133 cmd 0x9000 ctl 0x8800 bmdma 0x8408 irq 18 
Jun  7 04:51:04 upstairs kernel: ata3.00: ATA-7: Hitachi HDS721616PLA380, P22OA70A, max UDMA/133 
Jun  7 04:51:04 upstairs kernel: ata3.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32) 
Jun  7 04:51:04 upstairs kernel: ata3.00: configured for UDMA/133 
Jun  7 04:51:04 upstairs kernel: scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDS72161 P22O PQ: 0 ANSI: 5 
Jun  7 04:51:04 upstairs kernel: sd 2:0:0:0: [sdc] 321672960 512-byte hardware sectors (164697 MB) 
Jun  7 04:51:04 upstairs kernel: sd 2:0:0:0: [sdc] Write Protect is off 
Jun  7 04:51:04 upstairs kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00 
Jun  7 04:51:04 upstairs kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  7 04:51:04 upstairs kernel: sd 2:0:0:0: [sdc] 321672960 512-byte hardware sectors (164697 MB) 
Jun  7 04:51:04 upstairs kernel: sd 2:0:0:0: [sdc] Write Protect is off 
Jun  7 04:51:04 upstairs kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00 
Jun  7 04:51:04 upstairs kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Jun  7 04:51:04 upstairs kernel:  sdc: sdc1 sdc2 
Jun  7 04:51:04 upstairs kernel: sd 2:0:0:0: [sdc] Attached SCSI disk 
Jun  7 04:51:04 upstairs kernel: pnp: the driver 'i8042 kbd' has been registered 
Jun  7 04:51:04 upstairs kernel: i8042 kbd 00:0a: driver attached 
Jun  7 04:51:04 upstairs kernel: pnp: the driver 'i8042 aux' has been registered 
Jun  7 04:51:04 upstairs kernel: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1 
Jun  7 04:51:04 upstairs kernel: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp 
Jun  7 04:51:04 upstairs kernel: serio: i8042 KBD port at 0x60,0x64 irq 1 
Jun  7 04:51:04 upstairs kernel: mice: PS/2 mouse device common for all mice 
Jun  7 04:51:04 upstairs kernel: Advanced Linux Sound Architecture Driver Version 1.0.16. 
Jun  7 04:51:04 upstairs kernel: ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 17 
Jun  7 04:51:04 upstairs kernel: PCI: Setting latency timer of device 0000:00:1f.5 to 64 
Jun  7 04:51:34 upstairs kernel: intel8x0_measure_ac97_clock: measured 50842 usecs 
Jun  7 04:51:34 upstairs kernel: intel8x0: clocking to 48000 
Jun  7 04:51:34 upstairs kernel: ALSA device list: 
Jun  7 04:51:34 upstairs kernel:   #0: Intel ICH5 with ALC655 at irq 17 
Jun  7 04:51:34 upstairs kernel: TCP cubic registered 
Jun  7 04:51:34 upstairs kernel: NET: Registered protocol family 15 
Jun  7 04:51:34 upstairs kernel: p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available 
Jun  7 04:51:34 upstairs kernel: Starting balanced_irq 
Jun  7 04:51:34 upstairs kernel: Using IPI No-Shortcut mode 
Jun  7 04:51:34 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  7 04:51:34 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  7 04:51:34 upstairs kernel: VFS: Mounted root (ext3 filesystem) readonly. 
Jun  7 04:51:34 upstairs kernel: Freeing unused kernel memory: 200k freed 
Jun  7 04:51:34 upstairs kernel: EXT3 FS on sdc1, internal journal 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 23 
Jun  7 04:51:34 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:00:1d.7: debug port 1 
Jun  7 04:51:34 upstairs kernel: PCI: cache line size of 128 is not supported by device 0000:00:1d.7 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fffc00 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
Jun  7 04:51:34 upstairs kernel: usb usb1: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 1-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 1-0:1.0: 8 ports detected 
Jun  7 04:51:34 upstairs kernel: ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver 
Jun  7 04:51:34 upstairs kernel: USB Universal Host Controller Interface driver v3.0 
Jun  7 04:51:34 upstairs kernel: pnp: the driver 'parport_pc' has been registered 
Jun  7 04:51:34 upstairs kernel: parport_pc 00:06: reported by Plug and Play ACPI 
Jun  7 04:51:34 upstairs kernel: parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)] 
Jun  7 04:51:34 upstairs kernel: parport_pc 00:06: driver attached 
Jun  7 04:51:34 upstairs kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  7 04:51:34 upstairs kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb1: Product: EHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb1: Manufacturer: Linux 2.6.26-rc5 ehci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb1: SerialNumber: 0000:00:1d.7 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16 
Jun  7 04:51:34 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000a800 
Jun  7 04:51:34 upstairs kernel: usb usb2: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 2-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 2-0:1.0: 2 ports detected 
Jun  7 04:51:34 upstairs kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 04:51:34 upstairs kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb2: Product: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb2: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb2: SerialNumber: 0000:00:1d.0 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19 
Jun  7 04:51:34 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b000 
Jun  7 04:51:34 upstairs kernel: usb usb3: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 3-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 3-0:1.0: 2 ports detected 
Jun  7 04:51:34 upstairs kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 04:51:34 upstairs kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb3: Product: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb3: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb3: SerialNumber: 0000:00:1d.1 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18 
Jun  7 04:51:34 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b400 
Jun  7 04:51:34 upstairs kernel: usb usb4: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 4-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 4-0:1.0: 2 ports detected 
Jun  7 04:51:34 upstairs kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 04:51:34 upstairs kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb4: Product: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb4: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb4: SerialNumber: 0000:00:1d.2 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.2[C] -> GSI 19 (level, low) -> IRQ 19 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:02:09.2: EHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:02:09.2: new USB bus registered, assigned bus number 5 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:02:09.2: irq 19, io mem 0xfbfffc00 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 16 
Jun  7 04:51:34 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 6 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000b800 
Jun  7 04:51:34 upstairs kernel: usb usb6: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 6-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 6-0:1.0: 2 ports detected 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:02:09.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
Jun  7 04:51:34 upstairs kernel: usb usb6: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 04:51:34 upstairs kernel: usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb6: Product: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb6: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb6: SerialNumber: 0000:00:1d.3 
Jun  7 04:51:34 upstairs kernel: usb usb5: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 5-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 5-0:1.0: 4 ports detected 
Jun  7 04:51:34 upstairs kernel: usb usb5: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  7 04:51:34 upstairs kernel: usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb5: Product: EHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb5: Manufacturer: Linux 2.6.26-rc5 ehci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb5: SerialNumber: 0000:02:09.2 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.2[C] -> GSI 23 (level, low) -> IRQ 23 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:02:0a.2: EHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:02:0a.2: new USB bus registered, assigned bus number 7 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:02:0a.2: irq 23, io mem 0xfbfff800 
Jun  7 04:51:34 upstairs kernel: usb 2-2: new full speed USB device using uhci_hcd and address 2 
Jun  7 04:51:34 upstairs kernel: ehci_hcd 0000:02:0a.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004 
Jun  7 04:51:34 upstairs kernel: usb usb7: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 7-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 7-0:1.0: 5 ports detected 
Jun  7 04:51:34 upstairs kernel: usb 2-2: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: usb 2-2: New USB device found, idVendor=06bd, idProduct=2061 
Jun  7 04:51:34 upstairs kernel: usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  7 04:51:34 upstairs kernel: usb 2-2: Product: SNAPSCAN 
Jun  7 04:51:34 upstairs kernel: usb 2-2: Manufacturer: AGFA  
Jun  7 04:51:34 upstairs kernel: usb usb7: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  7 04:51:34 upstairs kernel: usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb7: Product: EHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb7: Manufacturer: Linux 2.6.26-rc5 ehci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb7: SerialNumber: 0000:02:0a.2 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 17 (level, low) -> IRQ 17 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:02:09.0: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:02:09.0: new USB bus registered, assigned bus number 8 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:02:09.0: irq 17, io base 0x0000e400 
Jun  7 04:51:34 upstairs kernel: usb usb8: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 8-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 8-0:1.0: 2 ports detected 
Jun  7 04:51:34 upstairs kernel: usb usb8: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 04:51:34 upstairs kernel: usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb8: Product: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb8: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb8: SerialNumber: 0000:02:09.0 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 18 (level, low) -> IRQ 18 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:02:09.1: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:02:09.1: new USB bus registered, assigned bus number 9 
Jun  7 04:51:34 upstairs kernel: uhci_hcd 0000:02:09.1: irq 18, io base 0x0000e800 
Jun  7 04:51:34 upstairs kernel: usb usb9: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 9-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 9-0:1.0: 2 ports detected 
Jun  7 04:51:34 upstairs kernel: usb 3-2: new low speed USB device using uhci_hcd and address 2 
Jun  7 04:51:34 upstairs kernel: usb usb9: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 04:51:34 upstairs kernel: usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb9: Product: UHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb9: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb9: SerialNumber: 0000:02:09.1 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 21 (level, low) -> IRQ 21 
Jun  7 04:51:34 upstairs kernel: ohci_hcd 0000:02:0a.0: OHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: ohci_hcd 0000:02:0a.0: new USB bus registered, assigned bus number 10 
Jun  7 04:51:34 upstairs kernel: ohci_hcd 0000:02:0a.0: irq 21, io mem 0xfbffd000 
Jun  7 04:51:34 upstairs kernel: usb 3-2: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: usb 3-2: New USB device found, idVendor=045e, idProduct=00f1 
Jun  7 04:51:34 upstairs kernel: usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  7 04:51:34 upstairs kernel: usb 3-2: Product: Microsoft Wireless Desktop Receiver 3.1A 
Jun  7 04:51:34 upstairs kernel: usb 3-2: Manufacturer: Microsft 
Jun  7 04:51:34 upstairs kernel: usb 5-1: new high speed USB device using ehci_hcd and address 2 
Jun  7 04:51:34 upstairs kernel: usb 5-1: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: usb 5-1: New USB device found, idVendor=2040, idProduct=9950 
Jun  7 04:51:34 upstairs kernel: usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3 
Jun  7 04:51:34 upstairs kernel: usb 5-1: Product: WinTV Nova-DT 
Jun  7 04:51:34 upstairs kernel: usb 5-1: Manufacturer: Hauppauge 
Jun  7 04:51:34 upstairs kernel: usb 5-1: SerialNumber: 4030248054 
Jun  7 04:51:34 upstairs kernel: dib0700: loaded with support for 7 different device-types 
Jun  7 04:51:34 upstairs kernel: usb 7-3: new high speed USB device using ehci_hcd and address 2 
Jun  7 04:51:34 upstairs kernel: usb 7-3: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 7-3:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 7-3:1.0: 4 ports detected 
Jun  7 04:51:34 upstairs kernel: usb usb10: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 10-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 10-0:1.0: 3 ports detected 
Jun  7 04:51:34 upstairs kernel: usb 7-3: New USB device found, idVendor=0409, idProduct=0059 
Jun  7 04:51:34 upstairs kernel: usb 7-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0 
Jun  7 04:51:34 upstairs kernel: dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold state, will try to load a firmware 
Jun  7 04:51:34 upstairs kernel: firmware: requesting dvb-usb-dib0700-1.10.fw 
Jun  7 04:51:34 upstairs kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw' 
Jun  7 04:51:34 upstairs kernel: usb usb10: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 04:51:34 upstairs kernel: usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb10: Product: OHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb10: Manufacturer: Linux 2.6.26-rc5 ohci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb10: SerialNumber: 0000:02:0a.0 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 22 (level, low) -> IRQ 22 
Jun  7 04:51:34 upstairs kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fbfff000-fbfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8] 
Jun  7 04:51:34 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.1[B] -> GSI 22 (level, low) -> IRQ 22 
Jun  7 04:51:34 upstairs kernel: ohci_hcd 0000:02:0a.1: OHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: ohci_hcd 0000:02:0a.1: new USB bus registered, assigned bus number 11 
Jun  7 04:51:34 upstairs kernel: ohci_hcd 0000:02:0a.1: irq 22, io mem 0xfbffe000 
Jun  7 04:51:34 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input2 
Jun  7 04:51:34 upstairs kernel: dib0700: firmware started successfully. 
Jun  7 04:51:34 upstairs kernel: input: USB HID v1.11 Keyboard [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun  7 04:51:34 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.1/input/input3 
Jun  7 04:51:34 upstairs kernel: input: USB HID v1.11 Mouse [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun  7 04:51:34 upstairs kernel: usb usb11: configuration #1 chosen from 1 choice 
Jun  7 04:51:34 upstairs kernel: hub 11-0:1.0: USB hub found 
Jun  7 04:51:34 upstairs kernel: hub 11-0:1.0: 2 ports detected 
Jun  7 04:51:34 upstairs kernel: dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state. 
Jun  7 04:51:34 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun  7 04:51:34 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun  7 04:51:34 upstairs kernel: DVB: registering frontend 0 (DiBcom 3000MC/P)... 
Jun  7 04:51:34 upstairs kernel: MT2060: successfully identified (IF1 = 1230) 
Jun  7 04:51:34 upstairs kernel: usb usb11: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 04:51:34 upstairs kernel: usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 04:51:34 upstairs kernel: usb usb11: Product: OHCI Host Controller 
Jun  7 04:51:34 upstairs kernel: usb usb11: Manufacturer: Linux 2.6.26-rc5 ohci_hcd 
Jun  7 04:51:34 upstairs kernel: usb usb11: SerialNumber: 0000:02:0a.1 
Jun  7 04:51:34 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun  7 04:51:34 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun  7 04:51:34 upstairs kernel: DVB: registering frontend 1 (DiBcom 3000MC/P)... 
Jun  7 04:51:34 upstairs kernel: ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
Jun  7 04:51:34 upstairs kernel: MT2060: successfully identified (IF1 = 1234) 
Jun  7 04:51:34 upstairs kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:09.2/usb5/5-1/input/input4 
Jun  7 04:51:34 upstairs kernel: dvb-usb: schedule remote query interval to 150 msecs. 
Jun  7 04:51:34 upstairs kernel: dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and connected. 
Jun  7 04:51:34 upstairs kernel: usbcore: registered new interface driver usbhid 
Jun  7 04:51:34 upstairs kernel: usbhid: v2.6:USB HID core driver 
Jun  7 04:51:34 upstairs kernel: usbcore: registered new interface driver dvb_usb_dib0700 
Jun  7 04:51:34 upstairs kernel: fuse init (API version 7.9) 
Jun  7 04:51:34 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  7 04:51:34 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  7 04:51:34 upstairs kernel: EXT3 FS on sdb6, internal journal 
Jun  7 04:51:34 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  7 04:51:34 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  7 04:51:34 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  7 04:51:34 upstairs kernel: EXT3 FS on sda6, internal journal 
Jun  7 04:51:34 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  7 04:51:34 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  7 04:51:34 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  7 04:51:34 upstairs kernel: EXT3 FS on sda7, internal journal 
Jun  7 04:51:34 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  7 04:51:34 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  7 04:51:34 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  7 04:51:34 upstairs kernel: EXT3 FS on sdc2, internal journal 
Jun  7 04:51:34 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  7 04:51:34 upstairs kernel: Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k 
Jun  7 04:51:34 upstairs kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1 
Jun  7 04:51:34 upstairs kernel: ip_tables: (C) 2000-2006 Netfilter Core Team 
Jun  7 04:51:34 upstairs kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max) 
Jun  7 04:51:34 upstairs kernel: parport_pc 00:06: disabled 
Jun  7 04:51:34 upstairs kernel: pnp: the driver 'parport_pc' has been unregistered 
Jun  7 04:51:34 upstairs kernel: ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
Jun  7 05:04:29 upstairs kernel: klogd 1.3-3, log source = /proc/kmsg started.
Jun  7 05:04:29 upstairs kernel: Inspecting /boot/System.map-2.6.26-rc5
Jun  7 05:04:30 upstairs kernel: Loaded 26367 symbols from /boot/System.map-2.6.26-rc5.
Jun  7 05:04:30 upstairs kernel: Symbols match kernel version 2.6.26.
Jun  7 05:04:30 upstairs kernel: No module symbols loaded - kernel modules not enabled. 
Jun  7 05:04:30 upstairs kernel: _add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 2-0:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:2-0:1.0 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 2-0:1.0 
Jun  7 05:04:30 upstairs kernel: hub 2-0:1.0: USB hub found 
Jun  7 05:04:30 upstairs kernel: hub 2-0:1.0: 2 ports detected 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': add driver ohci1394 
Jun  7 05:04:30 upstairs kernel: driver: '2-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev2.1_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev2.1_ep81 
Jun  7 05:04:30 upstairs kernel: driver: 'usb2': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device usb2 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev2.1_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev2.1_ep00 
Jun  7 05:04:30 upstairs kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 05:04:30 upstairs kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:04:30 upstairs kernel: usb usb2: Product: UHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: usb usb2: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 05:04:30 upstairs kernel: usb usb2: SerialNumber: 0000:00:1d.1 
Jun  7 05:04:30 upstairs kernel: driver: '0000:00:1d.1': driver_bound: bound to device 'uhci_hcd' 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: bound device 0000:00:1d.1 to driver uhci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:00:1d.2 with driver uhci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.2 
Jun  7 05:04:30 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18 
Jun  7 05:04:30 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: device: 'usb_host3': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usb_host3 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b400 
Jun  7 05:04:30 upstairs kernel: device: 'usb3': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device usb3 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:usb3 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb3 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb3 
Jun  7 05:04:30 upstairs kernel: usb usb3: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '3-0:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 3-0:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:3-0:1.0 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 3-0:1.0 with driver hub 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 3-0:1.0 
Jun  7 05:04:30 upstairs kernel: hub 3-0:1.0: USB hub found 
Jun  7 05:04:30 upstairs kernel: hub 3-0:1.0: 2 ports detected 
Jun  7 05:04:30 upstairs kernel: driver: '3-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 3-0:1.0 to driver hub 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev3.1_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev3.1_ep81 
Jun  7 05:04:30 upstairs kernel: driver: 'usb3': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device usb3 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev3.1_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev3.1_ep00 
Jun  7 05:04:30 upstairs kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 05:04:30 upstairs kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:04:30 upstairs kernel: usb usb3: Product: UHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: usb usb3: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 05:04:30 upstairs kernel: usb usb3: SerialNumber: 0000:00:1d.2 
Jun  7 05:04:30 upstairs kernel: driver: '0000:00:1d.2': driver_bound: bound to device 'uhci_hcd' 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: bound device 0000:00:1d.2 to driver uhci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:00:1d.3 with driver uhci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.3 
Jun  7 05:04:30 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 16 
Jun  7 05:04:30 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: device: 'usb_host4': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usb_host4 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000b800 
Jun  7 05:04:30 upstairs kernel: device: 'usb4': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device usb4 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:usb4 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb4 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb4 
Jun  7 05:04:30 upstairs kernel: usb usb4: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '4-0:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 4-0:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:4-0:1.0 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 4-0:1.0 with driver hub 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 4-0:1.0 
Jun  7 05:04:30 upstairs kernel: hub 4-0:1.0: USB hub found 
Jun  7 05:04:30 upstairs kernel: hub 4-0:1.0: 2 ports detected 
Jun  7 05:04:30 upstairs kernel: usb 1-2: new full speed USB device using uhci_hcd and address 2 
Jun  7 05:04:30 upstairs kernel: device: '1-2': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 1-2 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:1-2 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 1-2 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device 1-2 
Jun  7 05:04:30 upstairs kernel: usb 1-2: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '1-2:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 1-2:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:1-2:1.0 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.2_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev1.2_ep81 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.2_ep02': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev1.2_ep02 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.2_ep83': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev1.2_ep83 
Jun  7 05:04:30 upstairs kernel: driver: '1-2': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 1-2 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.2_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev1.2_ep00 
Jun  7 05:04:30 upstairs kernel: usb 1-2: New USB device found, idVendor=06bd, idProduct=2061 
Jun  7 05:04:30 upstairs kernel: usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  7 05:04:30 upstairs kernel: usb 1-2: Product: SNAPSCAN 
Jun  7 05:04:30 upstairs kernel: usb 1-2: Manufacturer: AGFA  
Jun  7 05:04:30 upstairs kernel: driver: '4-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 4-0:1.0 to driver hub 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev4.1_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev4.1_ep81 
Jun  7 05:04:30 upstairs kernel: driver: 'usb4': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device usb4 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev4.1_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev4.1_ep00 
Jun  7 05:04:30 upstairs kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 05:04:30 upstairs kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:04:30 upstairs kernel: usb usb4: Product: UHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: usb usb4: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 05:04:30 upstairs kernel: usb usb4: SerialNumber: 0000:00:1d.3 
Jun  7 05:04:30 upstairs kernel: driver: '0000:00:1d.3': driver_bound: bound to device 'uhci_hcd' 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: bound device 0000:00:1d.3 to driver uhci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:00:1d.7 with driver ehci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:1d.7 
Jun  7 05:04:30 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 23 
Jun  7 05:04:30 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: device: 'usb_host5': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usb_host5 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:00:1d.7: debug port 1 
Jun  7 05:04:30 upstairs kernel: PCI: cache line size of 128 is not supported by device 0000:00:1d.7 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fffc00 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
Jun  7 05:04:30 upstairs kernel: device: 'usb5': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device usb5 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:usb5 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb5 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb5 
Jun  7 05:04:30 upstairs kernel: usb usb5: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '5-0:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 5-0:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:5-0:1.0 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 5-0:1.0 with driver hub 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 5-0:1.0 
Jun  7 05:04:30 upstairs kernel: hub 5-0:1.0: USB hub found 
Jun  7 05:04:30 upstairs kernel: hub 5-0:1.0: 8 ports detected 
Jun  7 05:04:30 upstairs kernel: driver: '5-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 5-0:1.0 to driver hub 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev5.1_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev5.1_ep81 
Jun  7 05:04:30 upstairs kernel: driver: 'usb5': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device usb5 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev5.1_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev5.1_ep00 
Jun  7 05:04:30 upstairs kernel: usb usb5: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  7 05:04:30 upstairs kernel: usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:04:30 upstairs kernel: usb usb5: Product: EHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: usb usb5: Manufacturer: Linux 2.6.26-rc5 ehci_hcd 
Jun  7 05:04:30 upstairs kernel: usb usb5: SerialNumber: 0000:00:1d.7 
Jun  7 05:04:30 upstairs kernel: driver: '0000:00:1d.7': driver_bound: bound to device 'ehci_hcd' 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: bound device 0000:00:1d.7 to driver ehci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:09.0 with driver uhci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:02:09.0 
Jun  7 05:04:30 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 17 (level, low) -> IRQ 17 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:02:09.0: UHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: device: 'usb_host6': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usb_host6 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:02:09.0: new USB bus registered, assigned bus number 6 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:02:09.0: irq 17, io base 0x0000e400 
Jun  7 05:04:30 upstairs kernel: device: 'usb6': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device usb6 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:usb6 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb6 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb6 
Jun  7 05:04:30 upstairs kernel: usb usb6: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '6-0:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 6-0:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:6-0:1.0 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 6-0:1.0 with driver hub 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 6-0:1.0 
Jun  7 05:04:30 upstairs kernel: hub 6-0:1.0: USB hub found 
Jun  7 05:04:30 upstairs kernel: hub 6-0:1.0: 2 ports detected 
Jun  7 05:04:30 upstairs kernel: driver: '6-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 6-0:1.0 to driver hub 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev6.1_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev6.1_ep81 
Jun  7 05:04:30 upstairs kernel: driver: 'usb6': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device usb6 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev6.1_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev6.1_ep00 
Jun  7 05:04:30 upstairs kernel: usb usb6: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 05:04:30 upstairs kernel: usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:04:30 upstairs kernel: usb usb6: Product: UHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: usb usb6: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 05:04:30 upstairs kernel: usb usb6: SerialNumber: 0000:02:09.0 
Jun  7 05:04:30 upstairs kernel: driver: '0000:02:09.0': driver_bound: bound to device 'uhci_hcd' 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:09.0 to driver uhci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:09.1 with driver uhci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:02:09.1 
Jun  7 05:04:30 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 18 (level, low) -> IRQ 18 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:02:09.1: UHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: device: 'usb_host7': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usb_host7 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:02:09.1: new USB bus registered, assigned bus number 7 
Jun  7 05:04:30 upstairs kernel: uhci_hcd 0000:02:09.1: irq 18, io base 0x0000e800 
Jun  7 05:04:30 upstairs kernel: device: 'usb7': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device usb7 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:usb7 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb7 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb7 
Jun  7 05:04:30 upstairs kernel: usb usb7: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '7-0:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 7-0:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:7-0:1.0 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 7-0:1.0 with driver hub 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 7-0:1.0 
Jun  7 05:04:30 upstairs kernel: hub 7-0:1.0: USB hub found 
Jun  7 05:04:30 upstairs kernel: hub 7-0:1.0: 2 ports detected 
Jun  7 05:04:30 upstairs kernel: driver: '7-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 7-0:1.0 to driver hub 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev7.1_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev7.1_ep81 
Jun  7 05:04:30 upstairs kernel: driver: 'usb7': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device usb7 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev7.1_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev7.1_ep00 
Jun  7 05:04:30 upstairs kernel: usb usb7: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 05:04:30 upstairs kernel: usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:04:30 upstairs kernel: usb usb7: Product: UHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: usb usb7: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 
Jun  7 05:04:30 upstairs kernel: usb usb7: SerialNumber: 0000:02:09.1 
Jun  7 05:04:30 upstairs kernel: driver: '0000:02:09.1': driver_bound: bound to device 'uhci_hcd' 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:09.1 to driver uhci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:09.2 with driver ehci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:02:09.2 
Jun  7 05:04:30 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.2[C] -> GSI 19 (level, low) -> IRQ 19 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:02:09.2: EHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: device: 'usb_host8': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usb_host8 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:02:09.2: new USB bus registered, assigned bus number 8 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:02:09.2: irq 19, io mem 0xfbfffc00 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:02:09.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
Jun  7 05:04:30 upstairs kernel: device: 'usb8': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device usb8 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:usb8 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb8 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb8 
Jun  7 05:04:30 upstairs kernel: usb usb8: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '8-0:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 8-0:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:8-0:1.0 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 8-0:1.0 with driver hub 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 8-0:1.0 
Jun  7 05:04:30 upstairs kernel: hub 8-0:1.0: USB hub found 
Jun  7 05:04:30 upstairs kernel: hub 8-0:1.0: 4 ports detected 
Jun  7 05:04:30 upstairs kernel: driver: '8-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 8-0:1.0 to driver hub 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev8.1_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev8.1_ep81 
Jun  7 05:04:30 upstairs kernel: driver: 'usb8': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device usb8 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev8.1_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev8.1_ep00 
Jun  7 05:04:30 upstairs kernel: usb usb8: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  7 05:04:30 upstairs kernel: usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:04:30 upstairs kernel: usb usb8: Product: EHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: usb usb8: Manufacturer: Linux 2.6.26-rc5 ehci_hcd 
Jun  7 05:04:30 upstairs kernel: usb usb8: SerialNumber: 0000:02:09.2 
Jun  7 05:04:30 upstairs kernel: driver: '0000:02:09.2': driver_bound: bound to device 'ehci_hcd' 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:09.2 to driver ehci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:0a.0 with driver ohci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:02:0a.0 
Jun  7 05:04:30 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 21 (level, low) -> IRQ 21 
Jun  7 05:04:30 upstairs kernel: ohci_hcd 0000:02:0a.0: OHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: device: 'usb_host9': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usb_host9 
Jun  7 05:04:30 upstairs kernel: ohci_hcd 0000:02:0a.0: new USB bus registered, assigned bus number 9 
Jun  7 05:04:30 upstairs kernel: ohci_hcd 0000:02:0a.0: irq 21, io mem 0xfbffd000 
Jun  7 05:04:30 upstairs kernel: usb 1-2: USB disconnect, address 2 
Jun  7 05:04:30 upstairs kernel: PM: Removing info for usb:1-2:1.0 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': remove device 1-2:1.0 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.2_ep81': device_unregister 
Jun  7 05:04:30 upstairs kernel: PM: Removing info for No Bus:usbdev1.2_ep81 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.2_ep02': device_unregister 
Jun  7 05:04:30 upstairs kernel: PM: Removing info for No Bus:usbdev1.2_ep02 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.2_ep83': device_unregister 
Jun  7 05:04:30 upstairs kernel: PM: Removing info for No Bus:usbdev1.2_ep83 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.2_ep00': device_unregister 
Jun  7 05:04:30 upstairs kernel: PM: Removing info for No Bus:usbdev1.2_ep00 
Jun  7 05:04:30 upstairs kernel: PM: Removing info for usb:1-2 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': remove device 1-2 
Jun  7 05:04:30 upstairs kernel: usb 1-2: new full speed USB device using uhci_hcd and address 3 
Jun  7 05:04:30 upstairs kernel: device: '1-2': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 1-2 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:1-2 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 1-2 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device 1-2 
Jun  7 05:04:30 upstairs kernel: usb 1-2: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '1-2:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 1-2:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:1-2:1.0 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.3_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev1.3_ep81 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.3_ep02': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev1.3_ep02 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.3_ep83': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev1.3_ep83 
Jun  7 05:04:30 upstairs kernel: driver: '1-2': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 1-2 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev1.3_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev1.3_ep00 
Jun  7 05:04:30 upstairs kernel: usb 1-2: New USB device found, idVendor=06bd, idProduct=2061 
Jun  7 05:04:30 upstairs kernel: usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  7 05:04:30 upstairs kernel: usb 1-2: Product: SNAPSCAN 
Jun  7 05:04:30 upstairs kernel: usb 1-2: Manufacturer: AGFA  
Jun  7 05:04:30 upstairs kernel: device: 'usb9': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device usb9 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:usb9 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb9 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb9 
Jun  7 05:04:30 upstairs kernel: usb usb9: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '9-0:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 9-0:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:9-0:1.0 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 9-0:1.0 with driver hub 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 9-0:1.0 
Jun  7 05:04:30 upstairs kernel: hub 9-0:1.0: USB hub found 
Jun  7 05:04:30 upstairs kernel: hub 9-0:1.0: 3 ports detected 
Jun  7 05:04:30 upstairs kernel: usb 8-1: new high speed USB device using ehci_hcd and address 2 
Jun  7 05:04:30 upstairs kernel: device: '8-1': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 8-1 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:8-1 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': driver_probe_device: matched device 8-1 with driver usb 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device 8-1 
Jun  7 05:04:30 upstairs kernel: usb 8-1: configuration #1 chosen from 1 choice 
Jun  7 05:04:30 upstairs kernel: device: '8-1:1.0': device_add 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': add device 8-1:1.0 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for usb:8-1:1.0 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev8.2_ep01': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev8.2_ep01 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev8.2_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev8.2_ep81 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev8.2_ep82': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev8.2_ep82 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev8.2_ep83': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev8.2_ep83 
Jun  7 05:04:30 upstairs kernel: driver: '8-1': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 8-1 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev8.2_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev8.2_ep00 
Jun  7 05:04:30 upstairs kernel: usb 8-1: New USB device found, idVendor=2040, idProduct=9950 
Jun  7 05:04:30 upstairs kernel: usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3 
Jun  7 05:04:30 upstairs kernel: usb 8-1: Product: WinTV Nova-DT 
Jun  7 05:04:30 upstairs kernel: usb 8-1: Manufacturer: Hauppauge 
Jun  7 05:04:30 upstairs kernel: usb 8-1: SerialNumber: 4030248054 
Jun  7 05:04:30 upstairs kernel: driver: '9-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device 9-0:1.0 to driver hub 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev9.1_ep81': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev9.1_ep81 
Jun  7 05:04:30 upstairs kernel: driver: 'usb9': driver_bound: bound to device 'usb' 
Jun  7 05:04:30 upstairs kernel: bus: 'usb': really_probe: bound device usb9 to driver usb 
Jun  7 05:04:30 upstairs kernel: device: 'usbdev9.1_ep00': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usbdev9.1_ep00 
Jun  7 05:04:30 upstairs kernel: usb usb9: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 05:04:30 upstairs kernel: usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:04:30 upstairs kernel: usb usb9: Product: OHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: usb usb9: Manufacturer: Linux 2.6.26-rc5 ohci_hcd 
Jun  7 05:04:30 upstairs kernel: usb usb9: SerialNumber: 0000:02:0a.0 
Jun  7 05:04:30 upstairs kernel: driver: '0000:02:0a.0': driver_bound: bound to device 'ohci_hcd' 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0a.0 to driver ohci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:0a.2 with driver ehci_hcd 
Jun  7 05:04:30 upstairs kernel: bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:02:0a.2 
Jun  7 05:04:30 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.2[C] -> GSI 23 (level, low) -> IRQ 23 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:02:0a.2: EHCI Host Controller 
Jun  7 05:04:30 upstairs kernel: device: 'usb_host10': device_add 
Jun  7 05:04:30 upstairs kernel: PM: Adding info for No Bus:usb_host10 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:02:0a.2: new USB bus registered, assigned bus number 10 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:02:0a.2: irq 23, io mem 0xfbfff800 
Jun  7 05:04:30 upstairs kernel: usb 2-2: new low speed USB device using uhci_hcd and address 2 
Jun  7 05:04:30 upstairs kernel: ehci_hcd 0000:02:0a.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004 
Jun  7 05:05:03 upstairs kernel: device: 'usb10': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add device usb10 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for usb:usb10 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb10 with driver usb 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb10 
Jun  7 05:05:03 upstairs kernel: usb usb10: configuration #1 chosen from 1 choice 
Jun  7 05:05:03 upstairs kernel: device: '10-0:1.0': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add device 10-0:1.0 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for usb:10-0:1.0 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device 10-0:1.0 with driver hub 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 10-0:1.0 
Jun  7 05:05:03 upstairs kernel: hub 10-0:1.0: USB hub found 
Jun  7 05:05:03 upstairs kernel: hub 10-0:1.0: 5 ports detected 
Jun  7 05:05:03 upstairs kernel: device: '2-2': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add device 2-2 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for usb:2-2 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device 2-2 with driver usb 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device 2-2 
Jun  7 05:05:03 upstairs kernel: usb 2-2: configuration #1 chosen from 1 choice 
Jun  7 05:05:03 upstairs kernel: device: '2-2:1.0': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add device 2-2:1.0 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for usb:2-2:1.0 
Jun  7 05:05:03 upstairs kernel: device: 'usbdev2.2_ep81': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usbdev2.2_ep81 
Jun  7 05:05:03 upstairs kernel: device: '2-2:1.1': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add device 2-2:1.1 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for usb:2-2:1.1 
Jun  7 05:05:03 upstairs kernel: device: 'usbdev2.2_ep82': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usbdev2.2_ep82 
Jun  7 05:05:03 upstairs kernel: driver: '2-2': driver_bound: bound to device 'usb' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device 2-2 to driver usb 
Jun  7 05:05:03 upstairs kernel: device: 'usbdev2.2_ep00': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usbdev2.2_ep00 
Jun  7 05:05:03 upstairs kernel: usb 2-2: New USB device found, idVendor=045e, idProduct=00f1 
Jun  7 05:05:03 upstairs kernel: usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  7 05:05:03 upstairs kernel: usb 2-2: Product: Microsoft Wireless Desktop Receiver 3.1A 
Jun  7 05:05:03 upstairs kernel: usb 2-2: Manufacturer: Microsft 
Jun  7 05:05:03 upstairs kernel: driver: '10-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device 10-0:1.0 to driver hub 
Jun  7 05:05:03 upstairs kernel: device: 'usbdev10.1_ep81': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usbdev10.1_ep81 
Jun  7 05:05:03 upstairs kernel: driver: 'usb10': driver_bound: bound to device 'usb' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device usb10 to driver usb 
Jun  7 05:05:03 upstairs kernel: device: 'usbdev10.1_ep00': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usbdev10.1_ep00 
Jun  7 05:05:03 upstairs kernel: usb usb10: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  7 05:05:03 upstairs kernel: usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:05:03 upstairs kernel: usb usb10: Product: EHCI Host Controller 
Jun  7 05:05:03 upstairs kernel: usb usb10: Manufacturer: Linux 2.6.26-rc5 ehci_hcd 
Jun  7 05:05:03 upstairs kernel: usb usb10: SerialNumber: 0000:02:0a.2 
Jun  7 05:05:03 upstairs kernel: driver: '0000:02:0a.2': driver_bound: bound to device 'ehci_hcd' 
Jun  7 05:05:03 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0a.2 to driver ehci_hcd 
Jun  7 05:05:03 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:0a.1 with driver ohci_hcd 
Jun  7 05:05:03 upstairs kernel: bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:02:0a.1 
Jun  7 05:05:03 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.1[B] -> GSI 22 (level, low) -> IRQ 22 
Jun  7 05:05:03 upstairs kernel: ohci_hcd 0000:02:0a.1: OHCI Host Controller 
Jun  7 05:05:03 upstairs kernel: device: 'usb_host11': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usb_host11 
Jun  7 05:05:03 upstairs kernel: ohci_hcd 0000:02:0a.1: new USB bus registered, assigned bus number 11 
Jun  7 05:05:03 upstairs kernel: ohci_hcd 0000:02:0a.1: irq 22, io mem 0xfbffe000 
Jun  7 05:05:03 upstairs kernel: usb 10-3: new high speed USB device using ehci_hcd and address 2 
Jun  7 05:05:03 upstairs kernel: device: '10-3': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add device 10-3 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for usb:10-3 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device 10-3 with driver usb 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device 10-3 
Jun  7 05:05:03 upstairs kernel: usb 10-3: configuration #1 chosen from 1 choice 
Jun  7 05:05:03 upstairs kernel: device: '10-3:1.0': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add device 10-3:1.0 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for usb:10-3:1.0 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device 10-3:1.0 with driver hub 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 10-3:1.0 
Jun  7 05:05:03 upstairs kernel: hub 10-3:1.0: USB hub found 
Jun  7 05:05:03 upstairs kernel: hub 10-3:1.0: 4 ports detected 
Jun  7 05:05:03 upstairs kernel: driver: '10-3:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device 10-3:1.0 to driver hub 
Jun  7 05:05:03 upstairs kernel: device: 'usbdev10.2_ep81': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usbdev10.2_ep81 
Jun  7 05:05:03 upstairs kernel: driver: '10-3': driver_bound: bound to device 'usb' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device 10-3 to driver usb 
Jun  7 05:05:03 upstairs kernel: device: 'usbdev10.2_ep00': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usbdev10.2_ep00 
Jun  7 05:05:03 upstairs kernel: usb 10-3: New USB device found, idVendor=0409, idProduct=0059 
Jun  7 05:05:03 upstairs kernel: usb 10-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0 
Jun  7 05:05:03 upstairs kernel: device: 'usb11': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add device usb11 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for usb:usb11 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb11 with driver usb 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb11 
Jun  7 05:05:03 upstairs kernel: usb usb11: configuration #1 chosen from 1 choice 
Jun  7 05:05:03 upstairs kernel: device: '11-0:1.0': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add device 11-0:1.0 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for usb:11-0:1.0 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device 11-0:1.0 with driver hub 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 11-0:1.0 
Jun  7 05:05:03 upstairs kernel: hub 11-0:1.0: USB hub found 
Jun  7 05:05:03 upstairs kernel: hub 11-0:1.0: 2 ports detected 
Jun  7 05:05:03 upstairs kernel: driver: '11-0:1.0': driver_bound: bound to device 'hub' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device 11-0:1.0 to driver hub 
Jun  7 05:05:03 upstairs kernel: device: 'usbdev11.1_ep81': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usbdev11.1_ep81 
Jun  7 05:05:03 upstairs kernel: driver: 'usb11': driver_bound: bound to device 'usb' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device usb11 to driver usb 
Jun  7 05:05:03 upstairs kernel: device: 'usbdev11.1_ep00': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:usbdev11.1_ep00 
Jun  7 05:05:03 upstairs kernel: usb usb11: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  7 05:05:03 upstairs kernel: usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  7 05:05:03 upstairs kernel: usb usb11: Product: OHCI Host Controller 
Jun  7 05:05:03 upstairs kernel: usb usb11: Manufacturer: Linux 2.6.26-rc5 ohci_hcd 
Jun  7 05:05:03 upstairs kernel: usb usb11: SerialNumber: 0000:02:0a.1 
Jun  7 05:05:03 upstairs kernel: driver: '0000:02:0a.1': driver_bound: bound to device 'ohci_hcd' 
Jun  7 05:05:03 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0a.1 to driver ohci_hcd 
Jun  7 05:05:03 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:0b.0 with driver ohci1394 
Jun  7 05:05:03 upstairs kernel: bus: 'pci': really_probe: probing driver ohci1394 with device 0000:02:0b.0 
Jun  7 05:05:03 upstairs kernel: ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 22 (level, low) -> IRQ 22 
Jun  7 05:05:03 upstairs kernel: device: 'fw-host0': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'ieee1394': add device fw-host0 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for ieee1394:fw-host0 
Jun  7 05:05:03 upstairs kernel: driver: 'fw-host0': driver_bound: bound to device 'nodemgr' 
Jun  7 05:05:03 upstairs kernel: device: 'fw-host0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:fw-host0 
Jun  7 05:05:03 upstairs kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fbfff000-fbfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8] 
Jun  7 05:05:03 upstairs kernel: driver: '0000:02:0b.0': driver_bound: bound to device 'ohci1394' 
Jun  7 05:05:03 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0b.0 to driver ohci1394 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add driver usbhid 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device 2-2:1.0 with driver usbhid 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver usbhid with device 2-2:1.0 
Jun  7 05:05:03 upstairs kernel: bus: 'i2c': registered 
Jun  7 05:05:03 upstairs kernel: device class 'i2c-adapter': registering 
Jun  7 05:05:03 upstairs kernel: bus: 'i2c': add driver dummy 
Jun  7 05:05:03 upstairs kernel: device: 'input2': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:input2 
Jun  7 05:05:03 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.0/input/input2 
Jun  7 05:05:03 upstairs kernel: device: 'event2': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:event2 
Jun  7 05:05:03 upstairs kernel: input: USB HID v1.11 Keyboard [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun  7 05:05:03 upstairs kernel: driver: '2-2:1.0': driver_bound: bound to device 'usbhid' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device 2-2:1.0 to driver usbhid 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device 2-2:1.1 with driver usbhid 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver usbhid with device 2-2:1.1 
Jun  7 05:05:03 upstairs kernel: device class 'firmware': registering 
Jun  7 05:05:03 upstairs kernel: device class 'dvb': registering 
Jun  7 05:05:03 upstairs kernel: dib0700: loaded with support for 7 different device-types 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': add driver dvb_usb_dib0700 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': driver_probe_device: matched device 8-1:1.0 with driver dvb_usb_dib0700 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: probing driver dvb_usb_dib0700 with device 8-1:1.0 
Jun  7 05:05:03 upstairs kernel: dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state. 
Jun  7 05:05:03 upstairs kernel: device: 'i2c-0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:i2c-0 
Jun  7 05:05:03 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun  7 05:05:03 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun  7 05:05:03 upstairs kernel: device: 'dvb0.demux0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:dvb0.demux0 
Jun  7 05:05:03 upstairs kernel: device: 'dvb0.dvr0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:dvb0.dvr0 
Jun  7 05:05:03 upstairs kernel: device: 'dvb0.net0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:dvb0.net0 
Jun  7 05:05:03 upstairs kernel: device: 'input3': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:input3 
Jun  7 05:05:03 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.1/input/input3 
Jun  7 05:05:03 upstairs kernel: device: 'mouse0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:mouse0 
Jun  7 05:05:03 upstairs kernel: device: 'event3': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:event3 
Jun  7 05:05:03 upstairs kernel: input: USB HID v1.11 Mouse [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun  7 05:05:03 upstairs kernel: driver: '2-2:1.1': driver_bound: bound to device 'usbhid' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device 2-2:1.1 to driver usbhid 
Jun  7 05:05:03 upstairs kernel: usbcore: registered new interface driver usbhid 
Jun  7 05:05:03 upstairs kernel: usbhid: v2.6:USB HID core driver 
Jun  7 05:05:03 upstairs kernel: device: 'i2c-1': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:i2c-1 
Jun  7 05:05:03 upstairs kernel: DVB: registering frontend 0 (DiBcom 3000MC/P)... 
Jun  7 05:05:03 upstairs kernel: device: 'dvb0.frontend0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:dvb0.frontend0 
Jun  7 05:05:03 upstairs kernel: MT2060: successfully identified (IF1 = 1230) 
Jun  7 05:05:03 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun  7 05:05:03 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun  7 05:05:03 upstairs kernel: device: 'dvb1.demux0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:dvb1.demux0 
Jun  7 05:05:03 upstairs kernel: device: 'dvb1.dvr0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:dvb1.dvr0 
Jun  7 05:05:03 upstairs kernel: device: 'dvb1.net0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:dvb1.net0 
Jun  7 05:05:03 upstairs kernel: device: 'i2c-2': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:i2c-2 
Jun  7 05:05:03 upstairs kernel: DVB: registering frontend 1 (DiBcom 3000MC/P)... 
Jun  7 05:05:03 upstairs kernel: device: 'dvb1.frontend0': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:dvb1.frontend0 
Jun  7 05:05:03 upstairs kernel: MT2060: successfully identified (IF1 = 1234) 
Jun  7 05:05:03 upstairs kernel: device: '00110666000013cc': device_add 
Jun  7 05:05:03 upstairs kernel: bus: 'ieee1394': add device 00110666000013cc 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for ieee1394:00110666000013cc 
Jun  7 05:05:03 upstairs kernel: device: '00110666000013cc': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:00110666000013cc 
Jun  7 05:05:03 upstairs kernel: ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
Jun  7 05:05:03 upstairs kernel: device: 'input4': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:input4 
Jun  7 05:05:03 upstairs kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:09.2/usb8/8-1/input/input4 
Jun  7 05:05:03 upstairs kernel: device: 'event4': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:event4 
Jun  7 05:05:03 upstairs kernel: dvb-usb: schedule remote query interval to 150 msecs. 
Jun  7 05:05:03 upstairs kernel: dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and connected. 
Jun  7 05:05:03 upstairs kernel: driver: '8-1:1.0': driver_bound: bound to device 'dvb_usb_dib0700' 
Jun  7 05:05:03 upstairs kernel: bus: 'usb': really_probe: bound device 8-1:1.0 to driver dvb_usb_dib0700 
Jun  7 05:05:03 upstairs kernel: usbcore: registered new interface driver dvb_usb_dib0700 
Jun  7 05:05:03 upstairs kernel: fuse init (API version 7.9) 
Jun  7 05:05:03 upstairs kernel: device: 'fuse': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:fuse 
Jun  7 05:05:03 upstairs kernel: device: '8:1-fuseblk': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:8:1-fuseblk 
Jun  7 05:05:03 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  7 05:05:03 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  7 05:05:03 upstairs kernel: EXT3 FS on sdb6, internal journal 
Jun  7 05:05:03 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  7 05:05:03 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  7 05:05:03 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  7 05:05:03 upstairs kernel: EXT3 FS on sda6, internal journal 
Jun  7 05:05:03 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  7 05:05:03 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  7 05:05:03 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  7 05:05:03 upstairs kernel: EXT3 FS on sda7, internal journal 
Jun  7 05:05:03 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  7 05:05:03 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  7 05:05:03 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  7 05:05:03 upstairs kernel: EXT3 FS on sdc2, internal journal 
Jun  7 05:05:03 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  7 05:05:03 upstairs kernel: Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_unregister 
Jun  7 05:05:03 upstairs kernel: PM: Removing info for No Bus:vcs1 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_create_release 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_unregister 
Jun  7 05:05:03 upstairs kernel: PM: Removing info for No Bus:vcsa1 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_create_release 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:vcs1 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:vcsa1 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_unregister 
Jun  7 05:05:03 upstairs kernel: PM: Removing info for No Bus:vcs1 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_create_release 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_unregister 
Jun  7 05:05:03 upstairs kernel: PM: Removing info for No Bus:vcsa1 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_create_release 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:vcs1 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:vcsa1 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_unregister 
Jun  7 05:05:03 upstairs kernel: PM: Removing info for No Bus:vcs1 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_create_release 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_unregister 
Jun  7 05:05:03 upstairs kernel: PM: Removing info for No Bus:vcsa1 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_create_release 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:vcs1 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:vcsa1 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_unregister 
Jun  7 05:05:03 upstairs kernel: PM: Removing info for No Bus:vcs1 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_create_release 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_unregister 
Jun  7 05:05:03 upstairs kernel: PM: Removing info for No Bus:vcsa1 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_create_release 
Jun  7 05:05:03 upstairs kernel: device: 'vcs1': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:vcs1 
Jun  7 05:05:03 upstairs kernel: device: 'vcsa1': device_add 
Jun  7 05:05:03 upstairs kernel: PM: Adding info for No Bus:vcsa1 
Jun  7 05:05:03 upstairs kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1 
Jun  7 05:05:03 upstairs kernel: ip_tables: (C) 2000-2006 Netfilter Core Team 
Jun  7 05:05:03 upstairs kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max) 
Jun  7 05:05:03 upstairs kernel: bus: 'pci': remove driver parport_pc 
Jun  7 05:05:03 upstairs kernel: driver: 'parport_pc': driver_release 
Jun  7 05:05:03 upstairs kernel: bus: 'pnp': remove driver parport_pc 
Jun  7 05:05:03 upstairs kernel: parport_pc 00:06: disabled 
Jun  7 05:05:03 upstairs kernel: driver: 'parport_pc': driver_release 
Jun  7 05:05:06 upstairs kernel: pnp: the driver 'parport_pc' has been unregistered 
Jun  7 05:05:06 upstairs kernel: bus: 'platform': remove driver parport_pc 
Jun  7 05:05:06 upstairs kernel: driver: 'parport_pc': driver_release 
Jun  7 05:05:06 upstairs kernel: bus: 'pci': remove driver ohci1394 
Jun  7 05:05:06 upstairs kernel: ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
Jun  7 05:05:06 upstairs kernel: device: '00110666000013cc': device_unregister 
Jun  7 05:05:06 upstairs kernel: PM: Removing info for No Bus:00110666000013cc 
Jun  7 05:05:06 upstairs kernel: device: '00110666000013cc': device_unregister 
Jun  7 05:05:06 upstairs kernel: PM: Removing info for ieee1394:00110666000013cc 
Jun  7 05:05:06 upstairs kernel: bus: 'ieee1394': remove device 00110666000013cc 
Jun  7 05:05:06 upstairs kernel: device: 'fw-host0': device_unregister 
Jun  7 05:05:06 upstairs kernel: PM: Removing info for No Bus:fw-host0 
Jun  7 05:05:06 upstairs kernel: device: 'fw-host0': device_unregister 
Jun  7 05:05:06 upstairs kernel: PM: Removing info for ieee1394:fw-host0 
Jun  7 05:05:06 upstairs kernel: bus: 'ieee1394': remove device fw-host0 
Jun  7 05:05:06 upstairs kernel: driver: 'ohci1394': driver_release 
Jun  7 05:05:06 upstairs kernel: bus: 'ieee1394': remove driver nodemgr 
Jun  7 05:05:06 upstairs kernel: driver: 'nodemgr': driver_release 
Jun  7 05:05:06 upstairs kernel: device class 'ieee1394': unregistering 
Jun  7 05:05:06 upstairs kernel: class 'ieee1394': release. 
Jun  7 05:05:06 upstairs kernel: class 'ieee1394' does not have a release() function, be careful 
Jun  7 05:05:06 upstairs kernel: device class 'ieee1394_node': unregistering 
Jun  7 05:05:06 upstairs kernel: class 'ieee1394_node': release. 
Jun  7 05:05:06 upstairs kernel: class 'ieee1394_node' does not have a release() function, be careful 
Jun  7 05:05:06 upstairs kernel: device class 'ieee1394_protocol': unregistering 
Jun  7 05:05:06 upstairs kernel: class 'ieee1394_protocol': release. 
Jun  7 05:05:06 upstairs kernel: class_create_release called for ieee1394_protocol 
Jun  7 05:05:06 upstairs kernel: device class 'ieee1394_host': unregistering 
Jun  7 05:05:06 upstairs kernel: class 'ieee1394_host': release. 
Jun  7 05:05:06 upstairs kernel: class 'ieee1394_host' does not have a release() function, be careful 
Jun  7 05:05:06 upstairs kernel: bus: 'ieee1394': unregistering 
Jun  7 05:05:06 upstairs kernel: device: 'vcs3': device_add 
Jun  7 05:05:06 upstairs kernel: PM: Adding info for No Bus:vcs3 
Jun  7 05:05:06 upstairs kernel: device: 'vcsa3': device_add 
Jun  7 05:05:06 upstairs kernel: PM: Adding info for No Bus:vcsa3 
Jun  7 05:05:06 upstairs kernel: device: 'vcs2': device_add 
Jun  7 05:05:06 upstairs kernel: PM: Adding info for No Bus:vcs2 
Jun  7 05:05:06 upstairs kernel: device: 'vcsa2': device_add 
Jun  7 05:05:06 upstairs kernel: PM: Adding info for No Bus:vcsa2 
Jun  7 05:05:06 upstairs kernel: device: 'vcs4': device_add 
Jun  7 05:05:06 upstairs kernel: PM: Adding info for No Bus:vcs4 
Jun  7 05:05:06 upstairs kernel: device: 'vcsa4': device_add 
Jun  7 05:05:06 upstairs kernel: PM: Adding info for No Bus:vcsa4 
Jun  7 05:05:06 upstairs kernel: device: 'vcs5': device_add 
Jun  7 05:05:06 upstairs kernel: PM: Adding info for No Bus:vcs5 
Jun  7 05:05:06 upstairs kernel: device: 'vcsa5': device_add 
Jun  7 05:05:06 upstairs kernel: PM: Adding info for No Bus:vcsa5 

--Boundary-00=_8mhSILcXFhxThCy--
