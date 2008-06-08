From: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Sun, 8 Jun 2008 06:19:17 +0000
Message-ID: <200806080619.17531.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <20080606110345.581fdc77.akpm@linux-foundation.org> <1212777612.16182.21.camel@localhost.localdomain>
Reply-To: chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ln3SIX/0dCJM3wi"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1212777612.16182.21.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_ln3SIX/0dCJM3wi
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-00=_NG3SIU63+Zdv2JV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 06 June 2008, James Bottomley wrote:
> On Fri, 2008-06-06 at 11:03 -0700, Andrew Morton wrote:
> > On Fri, 06 Jun 2008 10:22:22 -0500 James Bottomley=20
<James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > > On Thu, 2008-06-05 at 23:25 -0700, Andrew Morton wrote:
> > > > On Thu, 5 Jun 2008 23:21:45 -0700 Andrew Morton=20
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
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

Because of this oddity, I've also built 2.6.26-rc5-git2 with verbose USB 
debugging on. A boot log from that kernel is attached. You will see lots of 
ETIME errors from usb. A log from a similarly verbose 2.6.25.5 kernel does not 
show these errors. usb-devel added to cc list.


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

Triggered by James' bafflement and for my own peace of mind, I've run another
bisect session. This time I started with v2.6.26 as good and v2.6.26-rc2 as bad.
It highlighted the same patch as the "culprit".


Chris
> James

--
Beauty is in the eye of the beerholder.


--Boundary-00=_ln3SIX/0dCJM3wi
Content-Type: text/x-log;
  charset="utf-8";
  name="driver+usbdebug.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="driver+usbdebug.log"

Jun  8 05:26:34 upstairs kernel: klogd 1.3-3, log source = /proc/kmsg started.
Jun  8 05:26:34 upstairs kernel: Inspecting /boot/System.map-2.6.26-rc5-git2
Jun  8 05:26:35 upstairs kernel: Loaded 26388 symbols from /boot/System.map-2.6.26-rc5-git2.
Jun  8 05:26:35 upstairs kernel: Symbols match kernel version 2.6.26.
Jun  8 05:26:35 upstairs kernel: No module symbols loaded - kernel modules not enabled. 
Jun  8 05:26:35 upstairs kernel: n from 1 choice 
Jun  8 05:26:35 upstairs kernel: usb usb7: adding 7-0:1.0 (config #1, interface 0) 
Jun  8 05:26:35 upstairs kernel: device: '7-0:1.0': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 7-0:1.0 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:7-0:1.0 
Jun  8 05:26:35 upstairs kernel: usb 7-0:1.0: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device 7-0:1.0 with driver hub 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 7-0:1.0 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: usb_probe_interface 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: usb_probe_interface - got id 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: USB hub found 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: 2 ports detected 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: standalone hub 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: no power switching (usb 1.0) 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: global over-current protection 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: power on to power good time: 510ms 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: local power source is good 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: no over-current condition exists 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: trying to enable port power on non-switchable hub 
Jun  8 05:26:35 upstairs kernel: hub 6-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:00:1d.7: port 2 full speed --> companion 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT 
Jun  8 05:26:35 upstairs kernel: hub 6-0:1.0: port 2 not reset yet, waiting 50ms 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001403 POWER sig=k CSC CONNECT 
Jun  8 05:26:35 upstairs kernel: hub 6-0:1.0: port 4, status 0501, change 0001, 480 Mb/s 
Jun  8 05:26:35 upstairs kernel: hub 6-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:00:1d.7: port 4 low speed --> companion 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:00:1d.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC 
Jun  8 05:26:35 upstairs kernel: hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0000 
Jun  8 05:26:35 upstairs kernel: hub 6-0:1.0: state 7 ports 8 chg 0000 evt 0010 
Jun  8 05:26:35 upstairs kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00 
Jun  8 05:26:35 upstairs kernel: hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s 
Jun  8 05:26:35 upstairs kernel: hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101 
Jun  8 05:26:35 upstairs kernel: driver: '7-0:1.0': driver_bound: bound to device 'hub' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device 7-0:1.0 to driver hub 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev7.1_ep81': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev7.1_ep81 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '001' 
Jun  8 05:26:35 upstairs kernel: driver: 'usb7': driver_bound: bound to device 'usb' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device usb7 to driver usb 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev7.1_ep00': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev7.1_ep00 
Jun  8 05:26:35 upstairs kernel: usb usb7: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  8 05:26:35 upstairs kernel: usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  8 05:26:35 upstairs kernel: usb usb7: Product: OHCI Host Controller 
Jun  8 05:26:35 upstairs kernel: usb usb7: Manufacturer: Linux 2.6.26-rc5-git2 ohci_hcd 
Jun  8 05:26:35 upstairs kernel: usb usb7: SerialNumber: 0000:02:0a.1 
Jun  8 05:26:35 upstairs kernel: driver: '0000:02:0a.1': driver_bound: bound to device 'ohci_hcd' 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0a.1 to driver ohci_hcd 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:09.0 with driver uhci_hcd 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:02:09.0 
Jun  8 05:26:35 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 17 (level, low) -> IRQ 17 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.0: UHCI Host Controller 
Jun  8 05:26:35 upstairs kernel: device: 'usb_host8': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usb_host8 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '008' 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.0: new USB bus registered, assigned bus number 8 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.0: detected 2 ports 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.0: uhci_check_and_reset_hc: cmd = 0x0000 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.0: Performing full reset 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.0: irq 17, io base 0x0000e400 
Jun  8 05:26:35 upstairs kernel: usb usb8: default language 0x0409 
Jun  8 05:26:35 upstairs kernel: device: 'usb8': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device usb8 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:usb8 
Jun  8 05:26:35 upstairs kernel: usb usb8: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb8 with driver usb 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb8 
Jun  8 05:26:35 upstairs kernel: usb usb8: usb_probe_device 
Jun  8 05:26:35 upstairs kernel: usb usb8: configuration #1 chosen from 1 choice 
Jun  8 05:26:35 upstairs kernel: usb usb8: adding 8-0:1.0 (config #1, interface 0) 
Jun  8 05:26:35 upstairs kernel: device: '8-0:1.0': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 8-0:1.0 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:8-0:1.0 
Jun  8 05:26:35 upstairs kernel: usb 8-0:1.0: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device 8-0:1.0 with driver hub 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 8-0:1.0 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: usb_probe_interface 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: usb_probe_interface - got id 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: USB hub found 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: 2 ports detected 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: standalone hub 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: no power switching (usb 1.0) 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: individual port over-current protection 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: power on to power good time: 2ms 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: local power source is good 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: trying to enable port power on non-switchable hub 
Jun  8 05:26:35 upstairs kernel: usb 2-2: new full speed USB device using uhci_hcd and address 3 
Jun  8 05:26:35 upstairs kernel: usb 2-2: ep0 maxpacket = 8 
Jun  8 05:26:35 upstairs kernel: driver: '8-0:1.0': driver_bound: bound to device 'hub' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device 8-0:1.0 to driver hub 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev8.1_ep81': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev8.1_ep81 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '001' 
Jun  8 05:26:35 upstairs kernel: driver: 'usb8': driver_bound: bound to device 'usb' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device usb8 to driver usb 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev8.1_ep00': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev8.1_ep00 
Jun  8 05:26:35 upstairs kernel: usb usb8: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  8 05:26:35 upstairs kernel: usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  8 05:26:35 upstairs kernel: usb usb8: Product: UHCI Host Controller 
Jun  8 05:26:35 upstairs kernel: usb usb8: Manufacturer: Linux 2.6.26-rc5-git2 uhci_hcd 
Jun  8 05:26:35 upstairs kernel: usb usb8: SerialNumber: 0000:02:09.0 
Jun  8 05:26:35 upstairs kernel: driver: '0000:02:09.0': driver_bound: bound to device 'uhci_hcd' 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:09.0 to driver uhci_hcd 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:09.1 with driver uhci_hcd 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:02:09.1 
Jun  8 05:26:35 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 18 (level, low) -> IRQ 18 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.1: UHCI Host Controller 
Jun  8 05:26:35 upstairs kernel: device: 'usb_host9': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usb_host9 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '009' 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.1: new USB bus registered, assigned bus number 9 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.1: detected 2 ports 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.1: uhci_check_and_reset_hc: cmd = 0x0000 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.1: Performing full reset 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.1: irq 18, io base 0x0000e800 
Jun  8 05:26:35 upstairs kernel: usb usb9: default language 0x0409 
Jun  8 05:26:35 upstairs kernel: device: 'usb9': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device usb9 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:usb9 
Jun  8 05:26:35 upstairs kernel: usb usb9: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb9 with driver usb 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb9 
Jun  8 05:26:35 upstairs kernel: usb usb9: usb_probe_device 
Jun  8 05:26:35 upstairs kernel: usb usb9: configuration #1 chosen from 1 choice 
Jun  8 05:26:35 upstairs kernel: usb usb9: adding 9-0:1.0 (config #1, interface 0) 
Jun  8 05:26:35 upstairs kernel: device: '9-0:1.0': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 9-0:1.0 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:9-0:1.0 
Jun  8 05:26:35 upstairs kernel: usb 9-0:1.0: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device 9-0:1.0 with driver hub 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 9-0:1.0 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: usb_probe_interface 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: usb_probe_interface - got id 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: USB hub found 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: 2 ports detected 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: standalone hub 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: no power switching (usb 1.0) 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: individual port over-current protection 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: power on to power good time: 2ms 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: local power source is good 
Jun  8 05:26:35 upstairs kernel: hub 9-0:1.0: trying to enable port power on non-switchable hub 
Jun  8 05:26:35 upstairs kernel: usb 2-2: default language 0x0409 
Jun  8 05:26:35 upstairs kernel: device: '2-2': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 2-2 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:2-2 
Jun  8 05:26:35 upstairs kernel: usb 2-2: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device 2-2 with driver usb 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device 2-2 
Jun  8 05:26:35 upstairs kernel: usb 2-2: usb_probe_device 
Jun  8 05:26:35 upstairs kernel: usb 2-2: configuration #1 chosen from 1 choice 
Jun  8 05:26:35 upstairs kernel: usb 2-2: adding 2-2:1.0 (config #1, interface 0) 
Jun  8 05:26:35 upstairs kernel: device: '2-2:1.0': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 2-2:1.0 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:2-2:1.0 
Jun  8 05:26:35 upstairs kernel: usb 2-2:1.0: uevent 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev2.3_ep81': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev2.3_ep81 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev2.3_ep02': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev2.3_ep02 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev2.3_ep83': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev2.3_ep83 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '003' 
Jun  8 05:26:35 upstairs kernel: driver: '2-2': driver_bound: bound to device 'usb' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device 2-2 to driver usb 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev2.3_ep00': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev2.3_ep00 
Jun  8 05:26:35 upstairs kernel: usb 2-2: New USB device found, idVendor=06bd, idProduct=2061 
Jun  8 05:26:35 upstairs kernel: usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  8 05:26:35 upstairs kernel: usb 2-2: Product: SNAPSCAN 
Jun  8 05:26:35 upstairs kernel: usb 2-2: Manufacturer: AGFA  
Jun  8 05:26:35 upstairs kernel: hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:00:1d.1: port 2 portsc 01a3,00 
Jun  8 05:26:35 upstairs kernel: hub 3-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s 
Jun  8 05:26:35 upstairs kernel: driver: '9-0:1.0': driver_bound: bound to device 'hub' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device 9-0:1.0 to driver hub 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev9.1_ep81': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev9.1_ep81 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '001' 
Jun  8 05:26:35 upstairs kernel: driver: 'usb9': driver_bound: bound to device 'usb' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device usb9 to driver usb 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev9.1_ep00': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev9.1_ep00 
Jun  8 05:26:35 upstairs kernel: usb usb9: New USB device found, idVendor=1d6b, idProduct=0001 
Jun  8 05:26:35 upstairs kernel: usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  8 05:26:35 upstairs kernel: usb usb9: Product: UHCI Host Controller 
Jun  8 05:26:35 upstairs kernel: usb usb9: Manufacturer: Linux 2.6.26-rc5-git2 uhci_hcd 
Jun  8 05:26:35 upstairs kernel: usb usb9: SerialNumber: 0000:02:09.1 
Jun  8 05:26:35 upstairs kernel: driver: '0000:02:09.1': driver_bound: bound to device 'uhci_hcd' 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:09.1 to driver uhci_hcd 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:09.2 with driver ehci_hcd 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:02:09.2 
Jun  8 05:26:35 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.2[C] -> GSI 19 (level, low) -> IRQ 19 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: EHCI Host Controller 
Jun  8 05:26:35 upstairs kernel: device: 'usb_host10': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usb_host10 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '010' 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: new USB bus registered, assigned bus number 10 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: reset hcs_params 0x2204 dbg=0 cc=2 pcc=2 ordered !ppc ports=4 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: reset hcc_params 6872 thresh 7 uframes 256/512/1024 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: MWI active 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: supports USB remote wakeup 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: irq 19, io mem 0xfbfffc00 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: init command 010009 (park)=0 ithresh=1 period=256 RUN 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:09.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
Jun  8 05:26:35 upstairs kernel: usb usb10: default language 0x0409 
Jun  8 05:26:35 upstairs kernel: device: 'usb10': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device usb10 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:usb10 
Jun  8 05:26:35 upstairs kernel: usb usb10: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb10 with driver usb 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb10 
Jun  8 05:26:35 upstairs kernel: usb usb10: usb_probe_device 
Jun  8 05:26:35 upstairs kernel: usb usb10: configuration #1 chosen from 1 choice 
Jun  8 05:26:35 upstairs kernel: usb usb10: adding 10-0:1.0 (config #1, interface 0) 
Jun  8 05:26:35 upstairs kernel: device: '10-0:1.0': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 10-0:1.0 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:10-0:1.0 
Jun  8 05:26:35 upstairs kernel: usb 10-0:1.0: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device 10-0:1.0 with driver hub 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 10-0:1.0 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: usb_probe_interface 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: usb_probe_interface - got id 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: USB hub found 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: 4 ports detected 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: standalone hub 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: no power switching (usb 1.0) 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: individual port over-current protection 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: power on to power good time: 20ms 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: local power source is good 
Jun  8 05:26:35 upstairs kernel: hub 10-0:1.0: trying to enable port power on non-switchable hub 
Jun  8 05:26:35 upstairs kernel: hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301 
Jun  8 05:26:35 upstairs kernel: driver: '10-0:1.0': driver_bound: bound to device 'hub' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device 10-0:1.0 to driver hub 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev10.1_ep81': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev10.1_ep81 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '001' 
Jun  8 05:26:35 upstairs kernel: driver: 'usb10': driver_bound: bound to device 'usb' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device usb10 to driver usb 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev10.1_ep00': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev10.1_ep00 
Jun  8 05:26:35 upstairs kernel: usb usb10: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  8 05:26:35 upstairs kernel: usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  8 05:26:35 upstairs kernel: usb usb10: Product: EHCI Host Controller 
Jun  8 05:26:35 upstairs kernel: usb usb10: Manufacturer: Linux 2.6.26-rc5-git2 ehci_hcd 
Jun  8 05:26:35 upstairs kernel: usb usb10: SerialNumber: 0000:02:09.2 
Jun  8 05:26:35 upstairs kernel: driver: '0000:02:09.2': driver_bound: bound to device 'ehci_hcd' 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:09.2 to driver ehci_hcd 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:0a.2 with driver ehci_hcd 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:02:0a.2 
Jun  8 05:26:35 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.2[C] -> GSI 23 (level, low) -> IRQ 23 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: EHCI Host Controller 
Jun  8 05:26:35 upstairs kernel: device: 'usb_host11': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usb_host11 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '011' 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: new USB bus registered, assigned bus number 11 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: reset hcs_params 0x2395 dbg=0 cc=2 pcc=3 ports=5 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: reset portroute 1 0 1 0 0  
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: reset hcc_params 0002 thresh 0 uframes 256/512/1024 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: ...powerup ports... 
Jun  8 05:26:35 upstairs kernel: usb 3-2: new low speed USB device using uhci_hcd and address 3 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: MWI active 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: supports USB remote wakeup 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: irq 23, io mem 0xfbfff800 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: init command 010009 (park)=0 ithresh=1 period=256 RUN 
Jun  8 05:26:35 upstairs kernel: ehci_hcd 0000:02:0a.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004 
Jun  8 05:26:35 upstairs kernel: usb usb11: default language 0x0409 
Jun  8 05:26:35 upstairs kernel: device: 'usb11': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device usb11 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:usb11 
Jun  8 05:26:35 upstairs kernel: usb usb11: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device usb11 with driver usb 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device usb11 
Jun  8 05:26:35 upstairs kernel: usb usb11: usb_probe_device 
Jun  8 05:26:35 upstairs kernel: usb usb11: configuration #1 chosen from 1 choice 
Jun  8 05:26:35 upstairs kernel: usb usb11: adding 11-0:1.0 (config #1, interface 0) 
Jun  8 05:26:35 upstairs kernel: device: '11-0:1.0': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 11-0:1.0 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:11-0:1.0 
Jun  8 05:26:35 upstairs kernel: usb 11-0:1.0: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device 11-0:1.0 with driver hub 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 11-0:1.0 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: usb_probe_interface 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: usb_probe_interface - got id 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: USB hub found 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: 5 ports detected 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: standalone hub 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: individual port power switching 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: individual port over-current protection 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: power on to power good time: 20ms 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: local power source is good 
Jun  8 05:26:35 upstairs kernel: hub 11-0:1.0: enabling power on all ports 
Jun  8 05:26:35 upstairs kernel: usb 3-2: skipped 1 descriptor after interface 
Jun  8 05:26:35 upstairs kernel: usb 3-2: skipped 1 descriptor after interface 
Jun  8 05:26:35 upstairs kernel: usb 3-2: default language 0x0409 
Jun  8 05:26:35 upstairs kernel: device: '3-2': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 3-2 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:3-2 
Jun  8 05:26:35 upstairs kernel: usb 3-2: uevent 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': driver_probe_device: matched device 3-2 with driver usb 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device 3-2 
Jun  8 05:26:35 upstairs kernel: usb 3-2: usb_probe_device 
Jun  8 05:26:35 upstairs kernel: usb 3-2: configuration #1 chosen from 1 choice 
Jun  8 05:26:35 upstairs kernel: usb 3-2: adding 3-2:1.0 (config #1, interface 0) 
Jun  8 05:26:35 upstairs kernel: device: '3-2:1.0': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 3-2:1.0 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:3-2:1.0 
Jun  8 05:26:35 upstairs kernel: usb 3-2:1.0: uevent 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev3.3_ep81': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev3.3_ep81 
Jun  8 05:26:35 upstairs kernel: usb 3-2: adding 3-2:1.1 (config #1, interface 1) 
Jun  8 05:26:35 upstairs kernel: device: '3-2:1.1': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': add device 3-2:1.1 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for usb:3-2:1.1 
Jun  8 05:26:35 upstairs kernel: usb 3-2:1.1: uevent 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev3.3_ep82': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev3.3_ep82 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '003' 
Jun  8 05:26:35 upstairs kernel: driver: '3-2': driver_bound: bound to device 'usb' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device 3-2 to driver usb 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev3.3_ep00': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev3.3_ep00 
Jun  8 05:26:35 upstairs kernel: usb 3-2: New USB device found, idVendor=045e, idProduct=00f1 
Jun  8 05:26:35 upstairs kernel: usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
Jun  8 05:26:35 upstairs kernel: usb 3-2: Product: Microsoft Wireless Desktop Receiver 3.1A 
Jun  8 05:26:35 upstairs kernel: usb 3-2: Manufacturer: Microsft 
Jun  8 05:26:35 upstairs kernel: hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0006 
Jun  8 05:26:35 upstairs kernel: uhci_hcd 0000:02:09.0: port 1 portsc 009a,00 
Jun  8 05:26:35 upstairs kernel: hub 8-0:1.0: port 1, status 0100, change 0003, 12 Mb/s 
Jun  8 05:26:35 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5f160000 cc 5 --> status -62 
Jun  8 05:26:35 upstairs kernel: hub 1-2:1.0: transfer --> -62 
Jun  8 05:26:35 upstairs kernel: driver: '11-0:1.0': driver_bound: bound to device 'hub' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device 11-0:1.0 to driver hub 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev11.1_ep81': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev11.1_ep81 
Jun  8 05:26:35 upstairs kernel: drivers/usb/core/inode.c: creating file '001' 
Jun  8 05:26:35 upstairs kernel: driver: 'usb11': driver_bound: bound to device 'usb' 
Jun  8 05:26:35 upstairs kernel: bus: 'usb': really_probe: bound device usb11 to driver usb 
Jun  8 05:26:35 upstairs kernel: device: 'usbdev11.1_ep00': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:usbdev11.1_ep00 
Jun  8 05:26:35 upstairs kernel: usb usb11: New USB device found, idVendor=1d6b, idProduct=0002 
Jun  8 05:26:35 upstairs kernel: usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun  8 05:26:35 upstairs kernel: usb usb11: Product: EHCI Host Controller 
Jun  8 05:26:35 upstairs kernel: usb usb11: Manufacturer: Linux 2.6.26-rc5-git2 ehci_hcd 
Jun  8 05:26:35 upstairs kernel: usb usb11: SerialNumber: 0000:02:0a.2 
Jun  8 05:26:35 upstairs kernel: driver: '0000:02:0a.2': driver_bound: bound to device 'ehci_hcd' 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0a.2 to driver ehci_hcd 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': driver_probe_device: matched device 0000:02:0b.0 with driver ohci1394 
Jun  8 05:26:35 upstairs kernel: bus: 'pci': really_probe: probing driver ohci1394 with device 0000:02:0b.0 
Jun  8 05:26:35 upstairs kernel: ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 22 (level, low) -> IRQ 22 
Jun  8 05:26:35 upstairs kernel: device: 'fw-host0': device_add 
Jun  8 05:26:35 upstairs kernel: bus: 'ieee1394': add device fw-host0 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for ieee1394:fw-host0 
Jun  8 05:26:35 upstairs kernel: driver: 'fw-host0': driver_bound: bound to device 'nodemgr' 
Jun  8 05:26:35 upstairs kernel: device: 'fw-host0': device_add 
Jun  8 05:26:35 upstairs kernel: PM: Adding info for No Bus:fw-host0 
Jun  8 05:26:35 upstairs kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fbfff000-fbfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8] 
Jun  8 05:26:35 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5e160000 cc 5 --> status -62 
Jun  8 05:26:35 upstairs kernel: hub 1-2:1.0: transfer --> -62 
Jun  8 05:27:08 upstairs kernel: driver: '0000:02:0b.0': driver_bound: bound to device 'ohci1394' 
Jun  8 05:27:08 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0b.0 to driver ohci1394 
Jun  8 05:27:08 upstairs kernel: hub 8-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100 
Jun  8 05:27:08 upstairs kernel: uhci_hcd 0000:02:09.0: port 2 portsc 018a,00 
Jun  8 05:27:08 upstairs kernel: hub 8-0:1.0: port 2, status 0300, change 0003, 1.5 Mb/s 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': add driver usbhid 
Jun  8 05:27:08 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5f160000 cc 5 --> status -62 
Jun  8 05:27:08 upstairs kernel: hub 1-2:1.0: transfer --> -62 
Jun  8 05:27:08 upstairs kernel: hub 8-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x300 
Jun  8 05:27:08 upstairs kernel: hub 9-0:1.0: state 7 ports 2 chg 0000 evt 0006 
Jun  8 05:27:08 upstairs kernel: uhci_hcd 0000:02:09.1: port 1 portsc 018a,00 
Jun  8 05:27:08 upstairs kernel: hub 9-0:1.0: port 1, status 0300, change 0003, 1.5 Mb/s 
Jun  8 05:27:08 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5e160000 cc 5 --> status -62 
Jun  8 05:27:08 upstairs kernel: hub 1-2:1.0: transfer --> -62 
Jun  8 05:27:08 upstairs kernel: hub 9-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x300 
Jun  8 05:27:08 upstairs kernel: uhci_hcd 0000:02:09.1: port 2 portsc 008a,00 
Jun  8 05:27:08 upstairs kernel: hub 9-0:1.0: port 2, status 0100, change 0003, 12 Mb/s 
Jun  8 05:27:08 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5f160000 cc 5 --> status -62 
Jun  8 05:27:08 upstairs kernel: hub 1-2:1.0: transfer --> -62 
Jun  8 05:27:08 upstairs kernel: hub 9-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100 
Jun  8 05:27:08 upstairs kernel: hub 10-0:1.0: state 7 ports 4 chg 0000 evt 0000 
Jun  8 05:27:08 upstairs kernel: ehci_hcd 0000:02:09.2: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT 
Jun  8 05:27:08 upstairs kernel: hub 10-0:1.0: port 1, status 0501, change 0001, 480 Mb/s 
Jun  8 05:27:08 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5e160000 cc 5 --> status -62 
Jun  8 05:27:08 upstairs kernel: hub 1-2:1.0: transfer --> -62 
Jun  8 05:27:08 upstairs kernel: hub 10-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501 
Jun  8 05:27:08 upstairs kernel: ehci_hcd 0000:02:09.2: port 1 high speed 
Jun  8 05:27:08 upstairs kernel: ehci_hcd 0000:02:09.2: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT 
Jun  8 05:27:08 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5f160000 cc 5 --> status -62 
Jun  8 05:27:08 upstairs kernel: hub 1-2:1.0: transfer --> -62 
Jun  8 05:27:08 upstairs kernel: usb 10-1: new high speed USB device using ehci_hcd and address 2 
Jun  8 05:27:08 upstairs kernel: usb 10-1: default language 0x0409 
Jun  8 05:27:08 upstairs kernel: device: '10-1': device_add 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': add device 10-1 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for usb:10-1 
Jun  8 05:27:08 upstairs kernel: usb 10-1: uevent 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': driver_probe_device: matched device 10-1 with driver usb 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device 10-1 
Jun  8 05:27:08 upstairs kernel: usb 10-1: usb_probe_device 
Jun  8 05:27:08 upstairs kernel: usb 10-1: configuration #1 chosen from 1 choice 
Jun  8 05:27:08 upstairs kernel: usb 10-1: adding 10-1:1.0 (config #1, interface 0) 
Jun  8 05:27:08 upstairs kernel: device: '10-1:1.0': device_add 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': add device 10-1:1.0 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for usb:10-1:1.0 
Jun  8 05:27:08 upstairs kernel: usb 10-1:1.0: uevent 
Jun  8 05:27:08 upstairs kernel: device: 'usbdev10.2_ep01': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:usbdev10.2_ep01 
Jun  8 05:27:08 upstairs kernel: device: 'usbdev10.2_ep81': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:usbdev10.2_ep81 
Jun  8 05:27:08 upstairs kernel: device: 'usbdev10.2_ep82': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:usbdev10.2_ep82 
Jun  8 05:27:08 upstairs kernel: device: 'usbdev10.2_ep83': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:usbdev10.2_ep83 
Jun  8 05:27:08 upstairs kernel: drivers/usb/core/inode.c: creating file '002' 
Jun  8 05:27:08 upstairs kernel: driver: '10-1': driver_bound: bound to device 'usb' 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: bound device 10-1 to driver usb 
Jun  8 05:27:08 upstairs kernel: device: 'usbdev10.2_ep00': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:usbdev10.2_ep00 
Jun  8 05:27:08 upstairs kernel: usb 10-1: New USB device found, idVendor=2040, idProduct=9950 
Jun  8 05:27:08 upstairs kernel: usb 10-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3 
Jun  8 05:27:08 upstairs kernel: usb 10-1: Product: WinTV Nova-DT 
Jun  8 05:27:08 upstairs kernel: usb 10-1: Manufacturer: Hauppauge 
Jun  8 05:27:08 upstairs kernel: usb 10-1: SerialNumber: 4030248054 
Jun  8 05:27:08 upstairs kernel: hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0004 
Jun  8 05:27:08 upstairs kernel: ohci_hcd 0000:02:0a.0: GetStatus roothub.portstatus [1] = 0x00030100 PESC CSC PPS 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': driver_probe_device: matched device 3-2:1.0 with driver usbhid 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: probing driver usbhid with device 3-2:1.0 
Jun  8 05:27:08 upstairs kernel: hub 1-0:1.0: port 2, status 0100, change 0003, 12 Mb/s 
Jun  8 05:27:08 upstairs kernel: usbhid 3-2:1.0: usb_probe_interface 
Jun  8 05:27:08 upstairs kernel: usb 1-2: USB disconnect, address 2 
Jun  8 05:27:08 upstairs kernel: usb 1-2: unregistering device 
Jun  8 05:27:08 upstairs kernel: usb 1-2: usb_disable_device nuking all URBs 
Jun  8 05:27:08 upstairs kernel: ohci_hcd 0000:02:0a.0: shutdown urb f71cb680 ep1in-intr 
Jun  8 05:27:08 upstairs kernel: usbhid 3-2:1.0: usb_probe_interface - got id 
Jun  8 05:27:08 upstairs kernel: usb 1-2: unregistering interface 1-2:1.0 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for usb:1-2:1.0 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': remove device 1-2:1.0 
Jun  8 05:27:08 upstairs kernel: usb 1-2:1.0: uevent 
Jun  8 05:27:08 upstairs kernel: device: 'usbdev1.2_ep81': device_unregister 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for No Bus:usbdev1.2_ep81 
Jun  8 05:27:08 upstairs kernel: device: 'usbdev1.2_ep00': device_unregister 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for No Bus:usbdev1.2_ep00 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for usb:1-2 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': remove device 1-2 
Jun  8 05:27:08 upstairs kernel: usb 1-2: uevent 
Jun  8 05:27:08 upstairs kernel: device: 'input2': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:input2 
Jun  8 05:27:08 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input2 
Jun  8 05:27:08 upstairs kernel: bus: 'i2c': registered 
Jun  8 05:27:08 upstairs kernel: device class 'i2c-adapter': registering 
Jun  8 05:27:08 upstairs kernel: bus: 'i2c': add driver dummy 
Jun  8 05:27:08 upstairs kernel: uhci_hcd 0000:00:1d.1: reserve dev 3 ep81-INT, period 8, phase 4, 118 us 
Jun  8 05:27:08 upstairs kernel: device: 'event2': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:event2 
Jun  8 05:27:08 upstairs kernel: input: USB HID v1.11 Keyboard [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun  8 05:27:08 upstairs kernel: driver: '3-2:1.0': driver_bound: bound to device 'usbhid' 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: bound device 3-2:1.0 to driver usbhid 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': driver_probe_device: matched device 3-2:1.1 with driver usbhid 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: probing driver usbhid with device 3-2:1.1 
Jun  8 05:27:08 upstairs kernel: usbhid 3-2:1.1: usb_probe_interface 
Jun  8 05:27:08 upstairs kernel: usbhid 3-2:1.1: usb_probe_interface - got id 
Jun  8 05:27:08 upstairs kernel: device class 'firmware': registering 
Jun  8 05:27:08 upstairs kernel: device class 'dvb': registering 
Jun  8 05:27:08 upstairs kernel: dib0700: loaded with support for 7 different device-types 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': add driver dvb_usb_dib0700 
Jun  8 05:27:08 upstairs kernel: hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100 
Jun  8 05:27:08 upstairs kernel: hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000 
Jun  8 05:27:08 upstairs kernel: hub 11-0:1.0: state 7 ports 5 chg 0000 evt 0000 
Jun  8 05:27:08 upstairs kernel: ehci_hcd 0000:02:0a.2: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT 
Jun  8 05:27:08 upstairs kernel: hub 11-0:1.0: port 3, status 0501, change 0001, 480 Mb/s 
Jun  8 05:27:08 upstairs kernel: ohci_hcd 0000:02:0a.1: auto-stop root hub 
Jun  8 05:27:08 upstairs kernel: device: 'input3': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:input3 
Jun  8 05:27:08 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.1/input/input3 
Jun  8 05:27:08 upstairs kernel: uhci_hcd 0000:00:1d.1: reserve dev 3 ep82-INT, period 8, phase 4, 118 us 
Jun  8 05:27:08 upstairs kernel: device: 'mouse0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:mouse0 
Jun  8 05:27:08 upstairs kernel: device: 'event3': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:event3 
Jun  8 05:27:08 upstairs kernel: input: USB HID v1.11 Mouse [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun  8 05:27:08 upstairs kernel: driver: '3-2:1.1': driver_bound: bound to device 'usbhid' 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: bound device 3-2:1.1 to driver usbhid 
Jun  8 05:27:08 upstairs kernel: hub 11-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501 
Jun  8 05:27:08 upstairs kernel: ehci_hcd 0000:02:0a.2: port 3 high speed 
Jun  8 05:27:08 upstairs kernel: ehci_hcd 0000:02:0a.2: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT 
Jun  8 05:27:08 upstairs kernel: usb 11-3: new high speed USB device using ehci_hcd and address 2 
Jun  8 05:27:08 upstairs kernel: device: '11-3': device_add 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': add device 11-3 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for usb:11-3 
Jun  8 05:27:08 upstairs kernel: usb 11-3: uevent 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': driver_probe_device: matched device 11-3 with driver usb 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: probing driver usb with device 11-3 
Jun  8 05:27:08 upstairs kernel: usb 11-3: usb_probe_device 
Jun  8 05:27:08 upstairs kernel: usb 11-3: configuration #1 chosen from 1 choice 
Jun  8 05:27:08 upstairs kernel: usb 11-3: adding 11-3:1.0 (config #1, interface 0) 
Jun  8 05:27:08 upstairs kernel: device: '11-3:1.0': device_add 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': add device 11-3:1.0 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for usb:11-3:1.0 
Jun  8 05:27:08 upstairs kernel: usb 11-3:1.0: uevent 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': driver_probe_device: matched device 11-3:1.0 with driver hub 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: probing driver hub with device 11-3:1.0 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: usb_probe_interface 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: usb_probe_interface - got id 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: USB hub found 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: 4 ports detected 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: standalone hub 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: ganged power switching 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: global over-current protection 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: Single TT 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: TT requires at most 16 FS bit times (1332 ns) 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: Port indicators are supported 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: power on to power good time: 100ms 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: local power source is good 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: no over-current condition exists 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: enabling power on all ports 
Jun  8 05:27:08 upstairs kernel: usb 11-3: link qh256-0001/f77ef100 start 255 [1/0 us] 
Jun  8 05:27:08 upstairs kernel: driver: '11-3:1.0': driver_bound: bound to device 'hub' 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: bound device 11-3:1.0 to driver hub 
Jun  8 05:27:08 upstairs kernel: device: 'usbdev11.2_ep81': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:usbdev11.2_ep81 
Jun  8 05:27:08 upstairs kernel: drivers/usb/core/inode.c: creating file '002' 
Jun  8 05:27:08 upstairs kernel: driver: '11-3': driver_bound: bound to device 'usb' 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: bound device 11-3 to driver usb 
Jun  8 05:27:08 upstairs kernel: device: 'usbdev11.2_ep00': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:usbdev11.2_ep00 
Jun  8 05:27:08 upstairs kernel: usb 11-3: New USB device found, idVendor=0409, idProduct=0059 
Jun  8 05:27:08 upstairs kernel: usb 11-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0 
Jun  8 05:27:08 upstairs kernel: hub 9-0:1.0: state 7 ports 2 chg 0000 evt 0000 
Jun  8 05:27:08 upstairs kernel: hub 11-3:1.0: state 7 ports 4 chg 0000 evt 0000 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': driver_probe_device: matched device 10-1:1.0 with driver dvb_usb_dib0700 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: probing driver dvb_usb_dib0700 with device 10-1:1.0 
Jun  8 05:27:08 upstairs kernel: dvb_usb_dib0700 10-1:1.0: usb_probe_interface 
Jun  8 05:27:08 upstairs kernel: dvb_usb_dib0700 10-1:1.0: usb_probe_interface - got id 
Jun  8 05:27:08 upstairs kernel: dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state. 
Jun  8 05:27:08 upstairs kernel: device: 'i2c-0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:i2c-0 
Jun  8 05:27:08 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun  8 05:27:08 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun  8 05:27:08 upstairs kernel: device: 'dvb0.demux0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:dvb0.demux0 
Jun  8 05:27:08 upstairs kernel: device: 'dvb0.dvr0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:dvb0.dvr0 
Jun  8 05:27:08 upstairs kernel: device: 'dvb0.net0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:dvb0.net0 
Jun  8 05:27:08 upstairs kernel: usbcore: registered new interface driver usbhid 
Jun  8 05:27:08 upstairs kernel: usbhid: v2.6:USB HID core driver 
Jun  8 05:27:08 upstairs kernel: device: 'i2c-1': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:i2c-1 
Jun  8 05:27:08 upstairs kernel: DVB: registering frontend 0 (DiBcom 3000MC/P)... 
Jun  8 05:27:08 upstairs kernel: device: 'dvb0.frontend0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:dvb0.frontend0 
Jun  8 05:27:08 upstairs kernel: MT2060: successfully identified (IF1 = 1230) 
Jun  8 05:27:08 upstairs kernel: usb usb8: suspend_rh (auto-stop) 
Jun  8 05:27:08 upstairs kernel: device: '00110666000013cc': device_add 
Jun  8 05:27:08 upstairs kernel: bus: 'ieee1394': add device 00110666000013cc 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for ieee1394:00110666000013cc 
Jun  8 05:27:08 upstairs kernel: device: '00110666000013cc': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:00110666000013cc 
Jun  8 05:27:08 upstairs kernel: ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
Jun  8 05:27:08 upstairs kernel: usb usb9: suspend_rh (auto-stop) 
Jun  8 05:27:08 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun  8 05:27:08 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun  8 05:27:08 upstairs kernel: device: 'dvb1.demux0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:dvb1.demux0 
Jun  8 05:27:08 upstairs kernel: device: 'dvb1.dvr0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:dvb1.dvr0 
Jun  8 05:27:08 upstairs kernel: device: 'dvb1.net0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:dvb1.net0 
Jun  8 05:27:08 upstairs kernel: device: 'i2c-2': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:i2c-2 
Jun  8 05:27:08 upstairs kernel: DVB: registering frontend 1 (DiBcom 3000MC/P)... 
Jun  8 05:27:08 upstairs kernel: device: 'dvb1.frontend0': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:dvb1.frontend0 
Jun  8 05:27:08 upstairs kernel: MT2060: successfully identified (IF1 = 1234) 
Jun  8 05:27:08 upstairs kernel: ohci_hcd 0000:02:0a.0: auto-stop root hub 
Jun  8 05:27:08 upstairs kernel: device: 'input4': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:input4 
Jun  8 05:27:08 upstairs kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:09.2/usb10/10-1/input/input4 
Jun  8 05:27:08 upstairs kernel: device: 'event4': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:event4 
Jun  8 05:27:08 upstairs kernel: dvb-usb: schedule remote query interval to 150 msecs. 
Jun  8 05:27:08 upstairs kernel: dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and connected. 
Jun  8 05:27:08 upstairs kernel: driver: '10-1:1.0': driver_bound: bound to device 'dvb_usb_dib0700' 
Jun  8 05:27:08 upstairs kernel: bus: 'usb': really_probe: bound device 10-1:1.0 to driver dvb_usb_dib0700 
Jun  8 05:27:08 upstairs kernel: usbcore: registered new interface driver dvb_usb_dib0700 
Jun  8 05:27:08 upstairs kernel: fuse init (API version 7.9) 
Jun  8 05:27:08 upstairs kernel: device: 'fuse': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:fuse 
Jun  8 05:27:08 upstairs kernel: device: '8:1-fuseblk': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:8:1-fuseblk 
Jun  8 05:27:08 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  8 05:27:08 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  8 05:27:08 upstairs kernel: EXT3 FS on sdb6, internal journal 
Jun  8 05:27:08 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  8 05:27:08 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  8 05:27:08 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  8 05:27:08 upstairs kernel: EXT3 FS on sda6, internal journal 
Jun  8 05:27:08 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  8 05:27:08 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  8 05:27:08 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  8 05:27:08 upstairs kernel: EXT3 FS on sda7, internal journal 
Jun  8 05:27:08 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  8 05:27:08 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
Jun  8 05:27:08 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun  8 05:27:08 upstairs kernel: EXT3 FS on sdc2, internal journal 
Jun  8 05:27:08 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
Jun  8 05:27:08 upstairs kernel: Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_unregister 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for No Bus:vcs1 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_create_release 
Jun  8 05:27:08 upstairs kernel: device: 'vcsa1': device_unregister 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for No Bus:vcsa1 
Jun  8 05:27:08 upstairs kernel: device: 'vcsa1': device_create_release 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:vcs1 
Jun  8 05:27:08 upstairs kernel: device: 'vcsa1': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:vcsa1 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_unregister 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for No Bus:vcs1 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_create_release 
Jun  8 05:27:08 upstairs kernel: device: 'vcsa1': device_unregister 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for No Bus:vcsa1 
Jun  8 05:27:08 upstairs kernel: device: 'vcsa1': device_create_release 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:vcs1 
Jun  8 05:27:08 upstairs kernel: device: 'vcsa1': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:vcsa1 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_unregister 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for No Bus:vcs1 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_create_release 
Jun  8 05:27:08 upstairs kernel: device: 'vcsa1': device_unregister 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for No Bus:vcsa1 
Jun  8 05:27:08 upstairs kernel: device: 'vcsa1': device_create_release 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:vcs1 
Jun  8 05:27:08 upstairs kernel: device: 'vcsa1': device_add 
Jun  8 05:27:08 upstairs kernel: PM: Adding info for No Bus:vcsa1 
Jun  8 05:27:08 upstairs kernel: device: 'vcs1': device_unregister 
Jun  8 05:27:08 upstairs kernel: PM: Removing info for No Bus:vcs1 
Jun  8 05:27:12 upstairs kernel: device: 'vcs1': device_create_release 
Jun  8 05:27:12 upstairs kernel: device: 'vcsa1': device_unregister 
Jun  8 05:27:12 upstairs kernel: PM: Removing info for No Bus:vcsa1 
Jun  8 05:27:12 upstairs kernel: device: 'vcsa1': device_create_release 
Jun  8 05:27:12 upstairs kernel: device: 'vcs1': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcs1 
Jun  8 05:27:12 upstairs kernel: device: 'vcsa1': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcsa1 
Jun  8 05:27:12 upstairs kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1 
Jun  8 05:27:12 upstairs kernel: ip_tables: (C) 2000-2006 Netfilter Core Team 
Jun  8 05:27:12 upstairs kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max) 
Jun  8 05:27:12 upstairs kernel: bus: 'pci': remove driver parport_pc 
Jun  8 05:27:12 upstairs kernel: driver: 'parport_pc': driver_release 
Jun  8 05:27:12 upstairs kernel: bus: 'pnp': remove driver parport_pc 
Jun  8 05:27:12 upstairs kernel: parport_pc 00:06: disabled 
Jun  8 05:27:12 upstairs kernel: driver: 'parport_pc': driver_release 
Jun  8 05:27:12 upstairs kernel: pnp: the driver 'parport_pc' has been unregistered 
Jun  8 05:27:12 upstairs kernel: bus: 'platform': remove driver parport_pc 
Jun  8 05:27:12 upstairs kernel: driver: 'parport_pc': driver_release 
Jun  8 05:27:12 upstairs kernel: bus: 'pci': remove driver ohci1394 
Jun  8 05:27:12 upstairs kernel: ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
Jun  8 05:27:12 upstairs kernel: device: '00110666000013cc': device_unregister 
Jun  8 05:27:12 upstairs kernel: PM: Removing info for No Bus:00110666000013cc 
Jun  8 05:27:12 upstairs kernel: device: '00110666000013cc': device_unregister 
Jun  8 05:27:12 upstairs kernel: PM: Removing info for ieee1394:00110666000013cc 
Jun  8 05:27:12 upstairs kernel: bus: 'ieee1394': remove device 00110666000013cc 
Jun  8 05:27:12 upstairs kernel: device: 'fw-host0': device_unregister 
Jun  8 05:27:12 upstairs kernel: PM: Removing info for No Bus:fw-host0 
Jun  8 05:27:12 upstairs kernel: device: 'fw-host0': device_unregister 
Jun  8 05:27:12 upstairs kernel: PM: Removing info for ieee1394:fw-host0 
Jun  8 05:27:12 upstairs kernel: bus: 'ieee1394': remove device fw-host0 
Jun  8 05:27:12 upstairs kernel: driver: 'ohci1394': driver_release 
Jun  8 05:27:12 upstairs kernel: bus: 'ieee1394': remove driver nodemgr 
Jun  8 05:27:12 upstairs kernel: driver: 'nodemgr': driver_release 
Jun  8 05:27:12 upstairs kernel: device class 'ieee1394': unregistering 
Jun  8 05:27:12 upstairs kernel: class 'ieee1394': release. 
Jun  8 05:27:12 upstairs kernel: class 'ieee1394' does not have a release() function, be careful 
Jun  8 05:27:12 upstairs kernel: device class 'ieee1394_node': unregistering 
Jun  8 05:27:12 upstairs kernel: class 'ieee1394_node': release. 
Jun  8 05:27:12 upstairs kernel: class 'ieee1394_node' does not have a release() function, be careful 
Jun  8 05:27:12 upstairs kernel: device class 'ieee1394_protocol': unregistering 
Jun  8 05:27:12 upstairs kernel: class 'ieee1394_protocol': release. 
Jun  8 05:27:12 upstairs kernel: class_create_release called for ieee1394_protocol 
Jun  8 05:27:12 upstairs kernel: device class 'ieee1394_host': unregistering 
Jun  8 05:27:12 upstairs kernel: class 'ieee1394_host': release. 
Jun  8 05:27:12 upstairs kernel: class 'ieee1394_host' does not have a release() function, be careful 
Jun  8 05:27:12 upstairs kernel: bus: 'ieee1394': unregistering 
Jun  8 05:27:12 upstairs kernel: device: 'vcs4': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcs4 
Jun  8 05:27:12 upstairs kernel: device: 'vcsa4': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcsa4 
Jun  8 05:27:12 upstairs kernel: device: 'vcs3': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcs3 
Jun  8 05:27:12 upstairs kernel: device: 'vcsa3': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcsa3 
Jun  8 05:27:12 upstairs kernel: device: 'vcs2': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcs2 
Jun  8 05:27:12 upstairs kernel: device: 'vcsa2': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcsa2 
Jun  8 05:27:12 upstairs kernel: device: 'vcs5': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcs5 
Jun  8 05:27:12 upstairs kernel: device: 'vcsa5': device_add 
Jun  8 05:27:12 upstairs kernel: PM: Adding info for No Bus:vcsa5 

--Boundary-00=_ln3SIX/0dCJM3wi--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
