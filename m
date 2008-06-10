From: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Tue, 10 Jun 2008 22:06:26 +0000
Message-ID: <200806102206.26818.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <200806080619.17531.chris2553@googlemail.com> <1212950276.3574.7.camel@localhost.localdomain>
Reply-To: chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_irvTIAqiIgDofeV"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1212950276.3574.7.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_irvTIAqiIgDofeV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


[Apologies to copy recipients - I accidentally replied to only James earlier 
this evening. I've enclosed the text of my reply in square brackets at the 
relevant places below, followed, where appropriate, by my findings from 
tonight's investigations]

On Sunday 08 June 2008, James Bottomley wrote:
> On Sun, 2008-06-08 at 06:19 +0000, Chris Clayton wrote:
> > --Boundary-00=_NG3SIU63+Zdv2JV
> > Content-Type: text/plain;
> >   charset="utf-8"
> > Content-Transfer-Encoding: quoted-printable
> > Content-Disposition: inline
> >
> > On Friday 06 June 2008, James Bottomley wrote:
> > > On Fri, 2008-06-06 at 11:03 -0700, Andrew Morton wrote:
> > > > On Fri, 06 Jun 2008 10:22:22 -0500 James Bottomley=20
> >
> > <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > > > > On Thu, 2008-06-05 at 23:25 -0700, Andrew Morton wrote:
> > > > > > On Thu, 5 Jun 2008 23:21:45 -0700 Andrew Morton=20
> >
> > <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > > > > > > <watches wodim wibble for five minutes then report
> > > > > > > "CD/DVD-Record=
> >
> > er
> >
> > > > > > > not ready."  Pretends not to have noticed.>
> > > > > >
> > > > > > It goes much better when the CD is inserted upside up.
> > > > >
> > > > > So I can close this regression if I send you a pack of CD ring
> > > > > labels with "other way up" on them for you to affix to the
> > > > > underside of your CDs ... ?
> > > >
> > > > Would prefer double-sided CDs.
> > >
> > > I just discovered my budget only runs to a permanent marker for you to
> > > write the instructions on the rim yourself ...
> > >
> > > > Is this 20-second-delay thing known-about/expected/etc?
> > >
> > > If it's not the scsi_bus_uevent problem, then no, it isn't.
> > >
> > > The odd thing is that it occurs in the middle of USB initialisation
> > > from
> >
> > Because of this oddity, I've also built 2.6.26-rc5-git2 with verbose USB
> > debugging on. A boot log from that kernel is attached. You will see lots
> > of ETIME errors from usb. A log from a similarly verbose 2.6.25.5 kernel
> > does not show these errors. usb-devel added to cc list.
>
> I'm starting to think this might be a distribution problem.  I tried
> booting my laptop on your config (only system I have with ata_piix)
> without an initrd (bit painful for fedora 9) and I didn't see any slow
> downs (in fact it was a lot faster than previously; makes note to file
> bug with redhat about their initramfs).
>
 [OK, I'll start investigating this line. My desktop system was originally (the 
 now lapsed) Peanut Linux, which was a Slackware derivative. But I've been 
 running it for 3 or 4 years, upgrading and adding packages along the way. My 
 udev setup is based on that in a fairly recent Slackware, although I can't now 
 recall precisely which version.]

For the time being I'll try and isolate what it is that causes the delay in 
icons appearing on my desktop when I plug in a usb-storage device. The script 
that shows the icon is invoked by adding the script name to udev's run list. 
Here is a typical rule from /etc/udev/rules.d/20-local.rules:

ACTION=="add", KERNEL=="sd[a-z][0-9]", SYSFS{idProduct}=="6545", 
SYSFS{idVendor}=="0930", SYMLINK+="usbstickc%n", MODE="0666", 
RUN+="/usr/bin/udevshowicon.sh"

I've added a couple of calls to logger (from util-linux-2.12r) to the script. 
What this has shown is that, when I plug in a usb-storage device, there seems 
to be a delay between the usb/scsi/usb-storage drivers setting up the device 
and my icon-showing script being run. Here is the snippet from the kernel log 
file:

Jun 10 20:27:45 upstairs kernel: [ 3200.592107] hub 3-0:1.0: state 7 ports 5 chg 
0000 evt 0004
Jun 10 20:27:45 upstairs kernel: [ 3200.592107] ehci_hcd 0000:02:0a.2: GetStatus 
port 2 status 001803 POWER sig=j CSC CONNECT
Jun 10 20:27:45 upstairs kernel: [ 3200.592107] hub 3-0:1.0: port 2, status 
0501, change 0001, 480 Mb/s
Jun 10 20:27:45 upstairs kernel: [ 3200.695130] hub 3-0:1.0: debounce: port 2: 
total 100ms stable 100ms status 0x501
Jun 10 20:27:45 upstairs kernel: [ 3200.746270] ehci_hcd 0000:02:0a.2: port 2 
high speed
Jun 10 20:27:45 upstairs kernel: [ 3200.746279] ehci_hcd 0000:02:0a.2: GetStatus 
port 2 status 001005 POWER sig=se0 PE CONNECT
Jun 10 20:27:45 upstairs kernel: [ 3200.797136] usb 3-2: new high speed USB 
device using ehci_hcd and address 9
Jun 10 20:27:45 upstairs kernel: [ 3200.811464] usb 3-2: default language 0x0409
Jun 10 20:27:45 upstairs kernel: [ 3200.812116] device: '3-2': device_add
Jun 10 20:27:45 upstairs kernel: [ 3200.812116] bus: 'usb': add device 3-2
Jun 10 20:27:45 upstairs kernel: [ 3200.812116] PM: Adding info for usb:3-2
Jun 10 20:27:45 upstairs kernel: [ 3200.812116] usb 3-2: uevent
Jun 10 20:27:45 upstairs kernel: [ 3200.812116] bus: 'usb': driver_probe_device: 
matched device 3-2 with driver usb
Jun 10 20:27:45 upstairs kernel: [ 3200.812116] bus: 'usb': really_probe: 
probing driver usb with device 3-2
Jun 10 20:27:45 upstairs kernel: [ 3200.812116] usb 3-2: usb_probe_device
Jun 10 20:27:45 upstairs kernel: [ 3200.812116] usb 3-2: configuration #1 chosen 
from 1 choice
Jun 10 20:27:45 upstairs kernel: [ 3200.814424] usb 3-2: adding 3-2:1.0 (config 
#1, interface 0)
Jun 10 20:27:45 upstairs kernel: [ 3200.814434] device: '3-2:1.0': device_add
Jun 10 20:27:45 upstairs kernel: [ 3200.814458] bus: 'usb': add device 3-2:1.0
Jun 10 20:27:45 upstairs kernel: [ 3200.814466] PM: Adding info for usb:3-2:1.0
Jun 10 20:27:45 upstairs kernel: [ 3200.814479] usb 3-2:1.0: uevent
Jun 10 20:27:45 upstairs kernel: [ 3200.814520] bus: 'usb': driver_probe_device: 
matched device 3-2:1.0 with driver usb-storage
Jun 10 20:27:45 upstairs kernel: [ 3200.814526] bus: 'usb': really_probe: 
probing driver usb-storage with device 3-2:1.0
Jun 10 20:27:45 upstairs kernel: [ 3200.814569] usb-storage 3-2:1.0: 
usb_probe_interface
Jun 10 20:27:45 upstairs kernel: [ 3200.814577] usb-storage 3-2:1.0: 
usb_probe_interface - got id
Jun 10 20:27:45 upstairs kernel: [ 3200.814982] scsi10 : SCSI emulation for USB 
Mass Storage devices
Jun 10 20:27:45 upstairs kernel: [ 3200.814994] device: 'host10': device_add
Jun 10 20:27:45 upstairs kernel: [ 3200.815006] bus: 'scsi': add device host10
Jun 10 20:27:45 upstairs kernel: [ 3200.815020] PM: Adding info for scsi:host10
Jun 10 20:27:45 upstairs kernel: [ 3200.815051] device: 'host10': device_add
Jun 10 20:27:45 upstairs kernel: [ 3200.815143] PM: Adding info for No 
Bus:host10
Jun 10 20:27:45 upstairs kernel: [ 3200.815303] driver: '3-2:1.0': driver_bound: 
bound to device 'usb-storage'
Jun 10 20:27:45 upstairs kernel: [ 3200.815310] bus: 'usb': really_probe: bound 
device 3-2:1.0 to driver usb-storage
Jun 10 20:27:45 upstairs kernel: [ 3200.815325] device: 'usbdev3.9_ep81': 
device_add
Jun 10 20:27:45 upstairs kernel: [ 3200.815375] PM: Adding info for No 
Bus:usbdev3.9_ep81
Jun 10 20:27:45 upstairs kernel: [ 3200.815401] device: 'usbdev3.9_ep02': 
device_add
Jun 10 20:27:45 upstairs kernel: [ 3200.815421] PM: Adding info for No 
Bus:usbdev3.9_ep02
Jun 10 20:27:45 upstairs kernel: [ 3200.815437] drivers/usb/core/inode.c: 
creating file '009'
Jun 10 20:27:45 upstairs kernel: [ 3200.815446] driver: '3-2': driver_bound: 
bound to device 'usb'
Jun 10 20:27:45 upstairs kernel: [ 3200.815449] bus: 'usb': really_probe: bound 
device 3-2 to driver usb
Jun 10 20:27:45 upstairs kernel: [ 3200.815459] device: 'usbdev3.9_ep00': 
device_add
Jun 10 20:27:45 upstairs kernel: [ 3200.815478] PM: Adding info for No 
Bus:usbdev3.9_ep00
Jun 10 20:27:45 upstairs kernel: [ 3200.815492] usb 3-2: New USB device found, 
idVendor=0930, idProduct=6545
Jun 10 20:27:45 upstairs kernel: [ 3200.815495] usb 3-2: New USB device strings: 
Mfr=0, Product=2, SerialNumber=3
Jun 10 20:27:45 upstairs kernel: [ 3200.815497] usb 3-2: Product: USB Flash 
Memory
Jun 10 20:27:45 upstairs kernel: [ 3200.815500] usb 3-2: SerialNumber: 
0EC065712361A91E
Jun 10 20:27:45 upstairs kernel: [ 3200.815769] usb-storage: device found at 9
Jun 10 20:27:45 upstairs kernel: [ 3200.815772] usb-storage: waiting for device 
to settle before scanning
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] scsi 10:0:0:0: Direct-Access              
USB Flash Memory 5.00 PQ: 0 ANSI: 0 CCS
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] device: 'target10:0:0': 
device_add
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] bus: 'scsi': add device 
target10:0:0
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] PM: Adding info for 
scsi:target10:0:0
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] device: '10:0:0:0': device_add
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] bus: 'scsi': add device 10:0:0:0
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] PM: Adding info for 
scsi:10:0:0:0
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] bus: 'scsi': 
driver_probe_device: matched device 10:0:0:0 with driver sd
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] bus: 'scsi': really_probe: 
probing driver sd with device 10:0:0:0
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] device: '10:0:0:0': device_add
Jun 10 20:27:50 upstairs kernel: [ 3205.817115] PM: Adding info for No 
Bus:10:0:0:0
Jun 10 20:27:51 upstairs kernel: [ 3206.045117] sd 10:0:0:0: [sdd] 2013184 
512-byte hardware sectors (1031 MB)
Jun 10 20:27:51 upstairs kernel: [ 3206.045369] sd 10:0:0:0: [sdd] Write Protect 
is off
Jun 10 20:27:51 upstairs kernel: [ 3206.045380] sd 10:0:0:0: [sdd] Mode Sense: 
23 00 00 00
Jun 10 20:27:51 upstairs kernel: [ 3206.045386] sd 10:0:0:0: [sdd] Assuming 
drive cache: write through
Jun 10 20:27:51 upstairs kernel: [ 3206.045425] device: 'sdd': device_add
Jun 10 20:27:51 upstairs kernel: [ 3206.045495] PM: Adding info for No Bus:sdd
Jun 10 20:27:51 upstairs kernel: [ 3206.047204] sd 10:0:0:0: [sdd] 2013184 
512-byte hardware sectors (1031 MB)
Jun 10 20:27:51 upstairs kernel: [ 3206.047306] sd 10:0:0:0: [sdd] Write Protect 
is off
Jun 10 20:27:51 upstairs kernel: [ 3206.047306] sd 10:0:0:0: [sdd] Mode Sense: 
23 00 00 00
Jun 10 20:27:51 upstairs kernel: [ 3206.047306] sd 10:0:0:0: [sdd] Assuming 
drive cache: write through
Jun 10 20:27:51 upstairs kernel: [ 3206.047306]  sdd: sdd1
Jun 10 20:27:51 upstairs kernel: [ 3206.049452] device: 'sdd1': device_add
Jun 10 20:27:51 upstairs kernel: [ 3206.049482] PM: Adding info for No Bus:sdd1
Jun 10 20:27:51 upstairs kernel: [ 3206.049594] device: '8:48': device_add
Jun 10 20:27:51 upstairs kernel: [ 3206.049623] PM: Adding info for No Bus:8:48
Jun 10 20:27:51 upstairs kernel: [ 3206.049648] sd 10:0:0:0: [sdd] Attached SCSI 
removable disk
Jun 10 20:27:51 upstairs kernel: [ 3206.049654] driver: '10:0:0:0': 
driver_bound: bound to device 'sd'
Jun 10 20:27:51 upstairs kernel: [ 3206.049660] bus: 'scsi': really_probe: bound 
device 10:0:0:0 to driver sd
Jun 10 20:27:51 upstairs kernel: [ 3206.049667] device: '10:0:0:0': device_add
Jun 10 20:27:51 upstairs kernel: [ 3206.049691] PM: Adding info for No 
Bus:10:0:0:0
Jun 10 20:27:51 upstairs kernel: [ 3206.050108] usb-storage: device scan 
complete

And here is the output from the calls to logger, that get written 
to /var/log/messages:

Jun 10 20:28:07 upstairs logger: udevshowicon: starting to get icon name
Jun 10 20:28:07 upstairs logger: udevshowicon: about to show usbstickc1

As you can see, 16 seconds elapses between the drivers finishing and the script 
being run. That's an awful time on a system that is doing nothing (because I'm 
busy scratching my head and looking bewildered :-)

I'm using udev-121, which is pretty recent. There is a later version, but the 
changelog doesn't describe any fixes that (to me) sound as if they would come 
anywhere near this problem.

I'll do so more poking about tomorrow night, but if anyone has any ideas in the 
meantime, I'd be very grateful.

> The one thing the patch you identified does is to add the SCSI target to
> the BUS and type model for the generic device.  What this does is to add
> extra uevents for the target.  If your hotplug handlers aren't set up to
> expect this, they could be delaying the system progress.
>
> What hotplug scripts are you using (and does /sbin/hotplug exist)?
>

 [ I don't have hotplug installed and CONFIG_UEVENT_HELPER_PATH is set to
 the empty string.]

> > > > upstairs kernel: usb 11-2: Product: USB Flash Memory Jun  6 17:26:31
> > > > upstairs kernel: usb 11-2: SerialNumber: 0EC065712361A91E
> > >
> > > I'm a bit baffled as to how that could be SCSI related, but I suppose
> > > it could be udev related somehow.  Perhaps turning on driver core
> > > debugging might help (that's CONFIG_DEBUG DRIVER ... it depends on
> > > CONFIG_DEBUG_KERNEL for activation).  Hopefully the verbose kernel logs
> > > from here might tell us what's going on in the lacunae.
> >
> > Triggered by James' bafflement and for my own peace of mind, I've run
> > another bisect session. This time I started with v2.6.26 as good and
> > v2.6.26-rc2 as bad. It highlighted the same patch as the "culprit".
>
> Actually, that's not really necessary.  Bisection is taking you back
> through kernel history, so unless the bug has two separate causes, it's
> pretty likely to home in on the same section of code.
>

 [I appreciate that but I was a tint bit worried that, late i the process, I had 
 reported an erronious good or bad to git bisect and ended up in the wrong 
 place.]

> James

I've also attached a log from a boot with CONFIG_PRINTK_TIME enabled.

Thanks

Chris

-- 
Beauty is in the eye of the beerholder.

--Boundary-00=_irvTIAqiIgDofeV
Content-Type: text/x-log;
  charset="utf-8";
  name="printktimer.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="printktimer.log"

Jun 10 19:14:05 upstairs kernel: klogd 1.3-3, log source = /proc/kmsg started.
Jun 10 19:14:05 upstairs kernel: Inspecting /boot/System.map-2.6.26-rc5-git2
Jun 10 19:14:05 upstairs kernel: Loaded 26388 symbols from /boot/System.map-2.6.26-rc5-git2.
Jun 10 19:14:05 upstairs kernel: Symbols match kernel version 2.6.26.
Jun 10 19:14:05 upstairs kernel: No module symbols loaded - kernel modules not enabled. 
Jun 10 19:14:05 upstairs kernel: d 
Jun 10 19:14:05 upstairs kernel: [    6.238912] PM: Adding info for No Bus:usbdev7.2_ep83 
Jun 10 19:14:05 upstairs kernel: [    6.238912] drivers/usb/core/inode.c: creating file '002' 
Jun 10 19:14:05 upstairs kernel: [    6.238912] driver: '7-1': driver_bound: bound to device 'usb' 
Jun 10 19:14:05 upstairs kernel: [    6.238912] bus: 'usb': really_probe: bound device 7-1 to driver usb 
Jun 10 19:14:05 upstairs kernel: [    6.238912] device: 'usbdev7.2_ep00': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.238912] PM: Adding info for No Bus:usbdev7.2_ep00 
Jun 10 19:14:05 upstairs kernel: [    6.238912] usb 7-1: New USB device found, idVendor=2040, idProduct=9950 
Jun 10 19:14:05 upstairs kernel: [    6.239959] usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3 
Jun 10 19:14:05 upstairs kernel: [    6.240012] usb 7-1: Product: WinTV Nova-DT 
Jun 10 19:14:05 upstairs kernel: [    6.240062] usb 7-1: Manufacturer: Hauppauge 
Jun 10 19:14:05 upstairs kernel: [    6.240112] usb 7-1: SerialNumber: 4030248054 
Jun 10 19:14:05 upstairs kernel: [    6.240166] uhci_hcd 0000:02:09.0: port 2 portsc 018a,00 
Jun 10 19:14:05 upstairs kernel: [    6.240175] hub 7-0:1.0: port 2, status 0300, change 0003, 1.5 Mb/s 
Jun 10 19:14:05 upstairs kernel: [    6.343916] hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x300 
Jun 10 19:14:05 upstairs kernel: [    6.343920] hub 6-0:1.0: state 7 ports 3 chg 0000 evt 0004 
Jun 10 19:14:05 upstairs kernel: [    6.343925] hub 6-2:1.0: state 7 ports 4 chg 0000 evt 0000 
Jun 10 19:14:05 upstairs kernel: [    6.354523] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000 
Jun 10 19:14:05 upstairs kernel: [    6.497290] driver: '8-0:1.0': driver_bound: bound to device 'hub' 
Jun 10 19:14:05 upstairs kernel: [    6.497290] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000 
Jun 10 19:14:05 upstairs kernel: [    6.497290] bus: 'usb': really_probe: bound device 8-0:1.0 to driver hub 
Jun 10 19:14:05 upstairs kernel: [    6.497290] device: 'usbdev8.1_ep81': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.497290] PM: Adding info for No Bus:usbdev8.1_ep81 
Jun 10 19:14:05 upstairs kernel: [    6.497290] drivers/usb/core/inode.c: creating file '001' 
Jun 10 19:14:05 upstairs kernel: [    6.497290] driver: 'usb8': driver_bound: bound to device 'usb' 
Jun 10 19:14:05 upstairs kernel: [    6.497290] bus: 'usb': really_probe: bound device usb8 to driver usb 
Jun 10 19:14:05 upstairs kernel: [    6.497290] device: 'usbdev8.1_ep00': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.497290] PM: Adding info for No Bus:usbdev8.1_ep00 
Jun 10 19:14:05 upstairs kernel: [    6.498149] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001 
Jun 10 19:14:05 upstairs kernel: [    6.498204] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun 10 19:14:05 upstairs kernel: [    6.498266] usb usb8: Product: OHCI Host Controller 
Jun 10 19:14:05 upstairs kernel: [    6.498293] usb usb8: Manufacturer: Linux 2.6.26-rc5-git2 ohci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.498349] usb usb8: SerialNumber: 0000:02:0a.1 
Jun 10 19:14:05 upstairs kernel: [    6.498405] driver: '0000:02:0a.1': driver_bound: bound to device 'ohci_hcd' 
Jun 10 19:14:05 upstairs kernel: [    6.498408] bus: 'pci': really_probe: bound device 0000:02:0a.1 to driver ohci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.499396] bus: 'pci': driver_probe_device: matched device 0000:02:09.1 with driver uhci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.499400] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:02:09.1 
Jun 10 19:14:05 upstairs kernel: [    6.499419] ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 18 (level, low) -> IRQ 18 
Jun 10 19:14:05 upstairs kernel: [    6.499523] uhci_hcd 0000:02:09.1: UHCI Host Controller 
Jun 10 19:14:05 upstairs kernel: [    6.499579] device: 'usb_host9': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.499591] PM: Adding info for No Bus:usb_host9 
Jun 10 19:14:05 upstairs kernel: [    6.499605] drivers/usb/core/inode.c: creating file '009' 
Jun 10 19:14:05 upstairs kernel: [    6.499610] uhci_hcd 0000:02:09.1: new USB bus registered, assigned bus number 9 
Jun 10 19:14:05 upstairs kernel: [    6.499675] uhci_hcd 0000:02:09.1: detected 2 ports 
Jun 10 19:14:05 upstairs kernel: [    6.499728] uhci_hcd 0000:02:09.1: uhci_check_and_reset_hc: cmd = 0x0000 
Jun 10 19:14:05 upstairs kernel: [    6.499730] uhci_hcd 0000:02:09.1: Performing full reset 
Jun 10 19:14:05 upstairs kernel: [    6.499747] uhci_hcd 0000:02:09.1: irq 18, io base 0x0000e800 
Jun 10 19:14:05 upstairs kernel: [    6.499829] usb usb9: default language 0x0409 
Jun 10 19:14:05 upstairs kernel: [    6.499838] device: 'usb9': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.499865] bus: 'usb': add device usb9 
Jun 10 19:14:05 upstairs kernel: [    6.499870] PM: Adding info for usb:usb9 
Jun 10 19:14:05 upstairs kernel: [    6.499880] usb usb9: uevent 
Jun 10 19:14:05 upstairs kernel: [    6.499890] bus: 'usb': driver_probe_device: matched device usb9 with driver usb 
Jun 10 19:14:05 upstairs kernel: [    6.499892] bus: 'usb': really_probe: probing driver usb with device usb9 
Jun 10 19:14:05 upstairs kernel: [    6.499897] usb usb9: usb_probe_device 
Jun 10 19:14:05 upstairs kernel: [    6.499900] usb usb9: configuration #1 chosen from 1 choice 
Jun 10 19:14:05 upstairs kernel: [    6.499954] usb usb9: adding 9-0:1.0 (config #1, interface 0) 
Jun 10 19:14:05 upstairs kernel: [    6.499956] device: '9-0:1.0': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.499969] bus: 'usb': add device 9-0:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.499973] PM: Adding info for usb:9-0:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.499979] usb 9-0:1.0: uevent 
Jun 10 19:14:05 upstairs kernel: [    6.499990] bus: 'usb': driver_probe_device: matched device 9-0:1.0 with driver hub 
Jun 10 19:14:05 upstairs kernel: [    6.499992] bus: 'usb': really_probe: probing driver hub with device 9-0:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.499997] hub 9-0:1.0: usb_probe_interface 
Jun 10 19:14:05 upstairs kernel: [    6.499999] hub 9-0:1.0: usb_probe_interface - got id 
Jun 10 19:14:05 upstairs kernel: [    6.500001] hub 9-0:1.0: USB hub found 
Jun 10 19:14:05 upstairs kernel: [    6.500057] hub 9-0:1.0: 2 ports detected 
Jun 10 19:14:05 upstairs kernel: [    6.500107] hub 9-0:1.0: standalone hub 
Jun 10 19:14:05 upstairs kernel: [    6.500109] hub 9-0:1.0: no power switching (usb 1.0) 
Jun 10 19:14:05 upstairs kernel: [    6.500110] hub 9-0:1.0: individual port over-current protection 
Jun 10 19:14:05 upstairs kernel: [    6.500113] hub 9-0:1.0: power on to power good time: 2ms 
Jun 10 19:14:05 upstairs kernel: [    6.500117] hub 9-0:1.0: local power source is good 
Jun 10 19:14:05 upstairs kernel: [    6.500119] hub 9-0:1.0: trying to enable port power on non-switchable hub 
Jun 10 19:14:05 upstairs kernel: [    6.600298] driver: '9-0:1.0': driver_bound: bound to device 'hub' 
Jun 10 19:14:05 upstairs kernel: [    6.600302] bus: 'usb': really_probe: bound device 9-0:1.0 to driver hub 
Jun 10 19:14:05 upstairs kernel: [    6.600308] device: 'usbdev9.1_ep81': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.600335] PM: Adding info for No Bus:usbdev9.1_ep81 
Jun 10 19:14:05 upstairs kernel: [    6.600351] drivers/usb/core/inode.c: creating file '001' 
Jun 10 19:14:05 upstairs kernel: [    6.600355] driver: 'usb9': driver_bound: bound to device 'usb' 
Jun 10 19:14:05 upstairs kernel: [    6.600358] bus: 'usb': really_probe: bound device usb9 to driver usb 
Jun 10 19:14:05 upstairs kernel: [    6.600364] device: 'usbdev9.1_ep00': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.600381] PM: Adding info for No Bus:usbdev9.1_ep00 
Jun 10 19:14:05 upstairs kernel: [    6.600394] usb usb9: New USB device found, idVendor=1d6b, idProduct=0001 
Jun 10 19:14:05 upstairs kernel: [    6.600448] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun 10 19:14:05 upstairs kernel: [    6.600510] usb usb9: Product: UHCI Host Controller 
Jun 10 19:14:05 upstairs kernel: [    6.600561] usb usb9: Manufacturer: Linux 2.6.26-rc5-git2 uhci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.600613] usb usb9: SerialNumber: 0000:02:09.1 
Jun 10 19:14:05 upstairs kernel: [    6.600671] driver: '0000:02:09.1': driver_bound: bound to device 'uhci_hcd' 
Jun 10 19:14:05 upstairs kernel: [    6.600674] bus: 'pci': really_probe: bound device 0000:02:09.1 to driver uhci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.602522] hub 9-0:1.0: state 7 ports 2 chg 0000 evt 0006 
Jun 10 19:14:05 upstairs kernel: [    6.602522] bus: 'pci': driver_probe_device: matched device 0000:02:09.2 with driver ehci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.602526] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:02:09.2 
Jun 10 19:14:05 upstairs kernel: [    6.602537] uhci_hcd 0000:02:09.1: port 1 portsc 008a,00 
Jun 10 19:14:05 upstairs kernel: [    6.602547] hub 9-0:1.0: port 1, status 0100, change 0003, 12 Mb/s 
Jun 10 19:14:05 upstairs kernel: [    6.602547] ACPI: PCI Interrupt 0000:02:09.2[C] -> GSI 19 (level, low) -> IRQ 19 
Jun 10 19:14:05 upstairs kernel: [    6.602558] ehci_hcd 0000:02:09.2: EHCI Host Controller 
Jun 10 19:14:05 upstairs kernel: [    6.602563] device: 'usb_host10': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.602574] PM: Adding info for No Bus:usb_host10 
Jun 10 19:14:05 upstairs kernel: [    6.602587] drivers/usb/core/inode.c: creating file '010' 
Jun 10 19:14:05 upstairs kernel: [    6.602592] ehci_hcd 0000:02:09.2: new USB bus registered, assigned bus number 10 
Jun 10 19:14:05 upstairs kernel: [    6.602598] ehci_hcd 0000:02:09.2: reset hcs_params 0x2204 dbg=0 cc=2 pcc=2 ordered !ppc ports=4 
Jun 10 19:14:05 upstairs kernel: [    6.602602] ehci_hcd 0000:02:09.2: reset hcc_params 6872 thresh 7 uframes 256/512/1024 
Jun 10 19:14:05 upstairs kernel: [    6.602621] ehci_hcd 0000:02:09.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT 
Jun 10 19:14:05 upstairs kernel: [    6.602638] ehci_hcd 0000:02:09.2: MWI active 
Jun 10 19:14:05 upstairs kernel: [    6.602640] ehci_hcd 0000:02:09.2: supports USB remote wakeup 
Jun 10 19:14:05 upstairs kernel: [    6.602646] ehci_hcd 0000:02:09.2: irq 19, io mem 0xfbfffc00 
Jun 10 19:14:05 upstairs kernel: [    6.602650] ehci_hcd 0000:02:09.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT 
Jun 10 19:14:05 upstairs kernel: [    6.602656] ehci_hcd 0000:02:09.2: init command 010009 (park)=0 ithresh=1 period=256 RUN 
Jun 10 19:14:05 upstairs kernel: [    6.608295] ehci_hcd 0000:02:09.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
Jun 10 19:14:05 upstairs kernel: [    6.608370] usb usb10: default language 0x0409 
Jun 10 19:14:05 upstairs kernel: [    6.608378] device: 'usb10': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.608404] bus: 'usb': add device usb10 
Jun 10 19:14:05 upstairs kernel: [    6.608410] PM: Adding info for usb:usb10 
Jun 10 19:14:05 upstairs kernel: [    6.608418] usb usb10: uevent 
Jun 10 19:14:05 upstairs kernel: [    6.608428] bus: 'usb': driver_probe_device: matched device usb10 with driver usb 
Jun 10 19:14:05 upstairs kernel: [    6.608431] bus: 'usb': really_probe: probing driver usb with device usb10 
Jun 10 19:14:05 upstairs kernel: [    6.608437] usb usb10: usb_probe_device 
Jun 10 19:14:05 upstairs kernel: [    6.608439] usb usb10: configuration #1 chosen from 1 choice 
Jun 10 19:14:05 upstairs kernel: [    6.608494] usb usb10: adding 10-0:1.0 (config #1, interface 0) 
Jun 10 19:14:05 upstairs kernel: [    6.608496] device: '10-0:1.0': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.608506] bus: 'usb': add device 10-0:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.608510] PM: Adding info for usb:10-0:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.608517] usb 10-0:1.0: uevent 
Jun 10 19:14:05 upstairs kernel: [    6.608527] bus: 'usb': driver_probe_device: matched device 10-0:1.0 with driver hub 
Jun 10 19:14:05 upstairs kernel: [    6.608530] bus: 'usb': really_probe: probing driver hub with device 10-0:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.608535] hub 10-0:1.0: usb_probe_interface 
Jun 10 19:14:05 upstairs kernel: [    6.608537] hub 10-0:1.0: usb_probe_interface - got id 
Jun 10 19:14:05 upstairs kernel: [    6.608539] hub 10-0:1.0: USB hub found 
Jun 10 19:14:05 upstairs kernel: [    6.608594] hub 10-0:1.0: 4 ports detected 
Jun 10 19:14:05 upstairs kernel: [    6.608644] hub 10-0:1.0: standalone hub 
Jun 10 19:14:05 upstairs kernel: [    6.608646] hub 10-0:1.0: no power switching (usb 1.0) 
Jun 10 19:14:05 upstairs kernel: [    6.608648] hub 10-0:1.0: individual port over-current protection 
Jun 10 19:14:05 upstairs kernel: [    6.608650] hub 10-0:1.0: power on to power good time: 20ms 
Jun 10 19:14:05 upstairs kernel: [    6.608654] hub 10-0:1.0: local power source is good 
Jun 10 19:14:05 upstairs kernel: [    6.608657] hub 10-0:1.0: trying to enable port power on non-switchable hub 
Jun 10 19:14:05 upstairs kernel: [    6.706301] hub 9-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100 
Jun 10 19:14:05 upstairs kernel: [    6.706308] uhci_hcd 0000:02:09.1: port 2 portsc 018a,00 
Jun 10 19:14:05 upstairs kernel: [    6.706316] hub 9-0:1.0: port 2, status 0300, change 0003, 1.5 Mb/s 
Jun 10 19:14:05 upstairs kernel: [    6.710246] driver: '10-0:1.0': driver_bound: bound to device 'hub' 
Jun 10 19:14:05 upstairs kernel: [    6.710250] bus: 'usb': really_probe: bound device 10-0:1.0 to driver hub 
Jun 10 19:14:05 upstairs kernel: [    6.710257] device: 'usbdev10.1_ep81': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.710279] PM: Adding info for No Bus:usbdev10.1_ep81 
Jun 10 19:14:05 upstairs kernel: [    6.710288] drivers/usb/core/inode.c: creating file '001' 
Jun 10 19:14:05 upstairs kernel: [    6.710288] driver: 'usb10': driver_bound: bound to device 'usb' 
Jun 10 19:14:05 upstairs kernel: [    6.710288] bus: 'usb': really_probe: bound device usb10 to driver usb 
Jun 10 19:14:05 upstairs kernel: [    6.710288] device: 'usbdev10.1_ep00': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.710288] PM: Adding info for No Bus:usbdev10.1_ep00 
Jun 10 19:14:05 upstairs kernel: [    6.710288] usb usb10: New USB device found, idVendor=1d6b, idProduct=0002 
Jun 10 19:14:05 upstairs kernel: [    6.710288] usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun 10 19:14:05 upstairs kernel: [    6.710288] usb usb10: Product: EHCI Host Controller 
Jun 10 19:14:05 upstairs kernel: [    6.710288] usb usb10: Manufacturer: Linux 2.6.26-rc5-git2 ehci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.710288] usb usb10: SerialNumber: 0000:02:09.2 
Jun 10 19:14:05 upstairs kernel: [    6.710288] driver: '0000:02:09.2': driver_bound: bound to device 'ehci_hcd' 
Jun 10 19:14:05 upstairs kernel: [    6.710288] bus: 'pci': really_probe: bound device 0000:02:09.2 to driver ehci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.711733] bus: 'pci': driver_probe_device: matched device 0000:02:0a.2 with driver ehci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.711736] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:02:0a.2 
Jun 10 19:14:05 upstairs kernel: [    6.711756] ACPI: PCI Interrupt 0000:02:0a.2[C] -> GSI 23 (level, low) -> IRQ 23 
Jun 10 19:14:05 upstairs kernel: [    6.711867] ehci_hcd 0000:02:0a.2: EHCI Host Controller 
Jun 10 19:14:05 upstairs kernel: [    6.711922] device: 'usb_host11': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.711934] PM: Adding info for No Bus:usb_host11 
Jun 10 19:14:05 upstairs kernel: [    6.711948] drivers/usb/core/inode.c: creating file '011' 
Jun 10 19:14:05 upstairs kernel: [    6.711953] ehci_hcd 0000:02:0a.2: new USB bus registered, assigned bus number 11 
Jun 10 19:14:05 upstairs kernel: [    6.712020] ehci_hcd 0000:02:0a.2: reset hcs_params 0x2395 dbg=0 cc=2 pcc=3 ports=5 
Jun 10 19:14:05 upstairs kernel: [    6.712026] ehci_hcd 0000:02:0a.2: reset portroute 1 0 1 0 0  
Jun 10 19:14:05 upstairs kernel: [    6.712030] ehci_hcd 0000:02:0a.2: reset hcc_params 0002 thresh 0 uframes 256/512/1024 
Jun 10 19:14:05 upstairs kernel: [    6.712050] ehci_hcd 0000:02:0a.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT 
Jun 10 19:14:05 upstairs kernel: [    6.712056] ehci_hcd 0000:02:0a.2: ...powerup ports... 
Jun 10 19:14:05 upstairs kernel: [    6.732419] ehci_hcd 0000:02:0a.2: MWI active 
Jun 10 19:14:05 upstairs kernel: [    6.732425] ehci_hcd 0000:02:0a.2: supports USB remote wakeup 
Jun 10 19:14:05 upstairs kernel: [    6.732435] ehci_hcd 0000:02:0a.2: irq 23, io mem 0xfbfff800 
Jun 10 19:14:05 upstairs kernel: [    6.732493] ehci_hcd 0000:02:0a.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT 
Jun 10 19:14:05 upstairs kernel: [    6.732499] ehci_hcd 0000:02:0a.2: init command 010009 (park)=0 ithresh=1 period=256 RUN 
Jun 10 19:14:05 upstairs kernel: [    6.738397] ehci_hcd 0000:02:0a.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004 
Jun 10 19:14:05 upstairs kernel: [    6.738477] usb usb11: default language 0x0409 
Jun 10 19:14:05 upstairs kernel: [    6.738485] device: 'usb11': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.738515] bus: 'usb': add device usb11 
Jun 10 19:14:05 upstairs kernel: [    6.738527] PM: Adding info for usb:usb11 
Jun 10 19:14:05 upstairs kernel: [    6.738536] usb usb11: uevent 
Jun 10 19:14:05 upstairs kernel: [    6.738550] bus: 'usb': driver_probe_device: matched device usb11 with driver usb 
Jun 10 19:14:05 upstairs kernel: [    6.738553] bus: 'usb': really_probe: probing driver usb with device usb11 
Jun 10 19:14:05 upstairs kernel: [    6.738561] usb usb11: usb_probe_device 
Jun 10 19:14:05 upstairs kernel: [    6.738564] usb usb11: configuration #1 chosen from 1 choice 
Jun 10 19:14:05 upstairs kernel: [    6.738620] usb usb11: adding 11-0:1.0 (config #1, interface 0) 
Jun 10 19:14:05 upstairs kernel: [    6.738623] device: '11-0:1.0': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.738633] bus: 'usb': add device 11-0:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.738637] PM: Adding info for usb:11-0:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.738643] usb 11-0:1.0: uevent 
Jun 10 19:14:05 upstairs kernel: [    6.738654] bus: 'usb': driver_probe_device: matched device 11-0:1.0 with driver hub 
Jun 10 19:14:05 upstairs kernel: [    6.738656] bus: 'usb': really_probe: probing driver hub with device 11-0:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.738663] hub 11-0:1.0: usb_probe_interface 
Jun 10 19:14:05 upstairs kernel: [    6.738665] hub 11-0:1.0: usb_probe_interface - got id 
Jun 10 19:14:05 upstairs kernel: [    6.738667] hub 11-0:1.0: USB hub found 
Jun 10 19:14:05 upstairs kernel: [    6.738723] hub 11-0:1.0: 5 ports detected 
Jun 10 19:14:05 upstairs kernel: [    6.738772] hub 11-0:1.0: standalone hub 
Jun 10 19:14:05 upstairs kernel: [    6.738774] hub 11-0:1.0: individual port power switching 
Jun 10 19:14:05 upstairs kernel: [    6.738776] hub 11-0:1.0: individual port over-current protection 
Jun 10 19:14:05 upstairs kernel: [    6.738779] hub 11-0:1.0: power on to power good time: 20ms 
Jun 10 19:14:05 upstairs kernel: [    6.738783] hub 11-0:1.0: local power source is good 
Jun 10 19:14:05 upstairs kernel: [    6.738785] hub 11-0:1.0: enabling power on all ports 
Jun 10 19:14:05 upstairs kernel: [    6.810301] hub 9-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x300 
Jun 10 19:14:05 upstairs kernel: [    6.810306] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0002 
Jun 10 19:14:05 upstairs kernel: [    6.810313] uhci_hcd 0000:02:09.0: port 1 portsc 009a,00 
Jun 10 19:14:05 upstairs kernel: [    6.810321] hub 7-0:1.0: port 1, status 0100, change 0003, 12 Mb/s 
Jun 10 19:14:05 upstairs kernel: [    6.810324] usb 7-1: USB disconnect, address 2 
Jun 10 19:14:05 upstairs kernel: [    6.810375] usb 7-1: unregistering device 
Jun 10 19:14:05 upstairs kernel: [    6.810377] usb 7-1: usb_disable_device nuking all URBs 
Jun 10 19:14:05 upstairs kernel: [    6.810382] usb 7-1: unregistering interface 7-1:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.810384] PM: Removing info for usb:7-1:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.810400] bus: 'usb': remove device 7-1:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.810407] usb 7-1:1.0: uevent 
Jun 10 19:14:05 upstairs kernel: [    6.810422] device: 'usbdev7.2_ep01': device_unregister 
Jun 10 19:14:05 upstairs kernel: [    6.810425] PM: Removing info for No Bus:usbdev7.2_ep01 
Jun 10 19:14:05 upstairs kernel: [    6.810452] device: 'usbdev7.2_ep81': device_unregister 
Jun 10 19:14:05 upstairs kernel: [    6.810454] PM: Removing info for No Bus:usbdev7.2_ep81 
Jun 10 19:14:05 upstairs kernel: [    6.810476] device: 'usbdev7.2_ep82': device_unregister 
Jun 10 19:14:05 upstairs kernel: [    6.810478] PM: Removing info for No Bus:usbdev7.2_ep82 
Jun 10 19:14:05 upstairs kernel: [    6.810500] device: 'usbdev7.2_ep83': device_unregister 
Jun 10 19:14:05 upstairs kernel: [    6.810502] PM: Removing info for No Bus:usbdev7.2_ep83 
Jun 10 19:14:05 upstairs kernel: [    6.810527] device: 'usbdev7.2_ep00': device_unregister 
Jun 10 19:14:05 upstairs kernel: [    6.810529] PM: Removing info for No Bus:usbdev7.2_ep00 
Jun 10 19:14:05 upstairs kernel: [    6.810555] PM: Removing info for usb:7-1 
Jun 10 19:14:05 upstairs kernel: [    6.810579] bus: 'usb': remove device 7-1 
Jun 10 19:14:05 upstairs kernel: [    6.810591] usb 7-1: uevent 
Jun 10 19:14:05 upstairs kernel: [    6.826817] ohci_hcd 0000:02:0a.0: urb f76dfb00 path 2 ep1in 5f160000 cc 5 --> status -62 
Jun 10 19:14:05 upstairs kernel: [    6.826817] hub 6-2:1.0: transfer --> -62 
Jun 10 19:14:05 upstairs kernel: [    6.839297] driver: '11-0:1.0': driver_bound: bound to device 'hub' 
Jun 10 19:14:05 upstairs kernel: [    6.839300] bus: 'usb': really_probe: bound device 11-0:1.0 to driver hub 
Jun 10 19:14:05 upstairs kernel: [    6.839306] device: 'usbdev11.1_ep81': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.839328] PM: Adding info for No Bus:usbdev11.1_ep81 
Jun 10 19:14:05 upstairs kernel: [    6.839344] drivers/usb/core/inode.c: creating file '001' 
Jun 10 19:14:05 upstairs kernel: [    6.839349] driver: 'usb11': driver_bound: bound to device 'usb' 
Jun 10 19:14:05 upstairs kernel: [    6.839352] bus: 'usb': really_probe: bound device usb11 to driver usb 
Jun 10 19:14:05 upstairs kernel: [    6.839357] device: 'usbdev11.1_ep00': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.839374] PM: Adding info for No Bus:usbdev11.1_ep00 
Jun 10 19:14:05 upstairs kernel: [    6.839387] usb usb11: New USB device found, idVendor=1d6b, idProduct=0002 
Jun 10 19:14:05 upstairs kernel: [    6.839442] usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
Jun 10 19:14:05 upstairs kernel: [    6.839504] usb usb11: Product: EHCI Host Controller 
Jun 10 19:14:05 upstairs kernel: [    6.839555] usb usb11: Manufacturer: Linux 2.6.26-rc5-git2 ehci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.839607] usb usb11: SerialNumber: 0000:02:0a.2 
Jun 10 19:14:05 upstairs kernel: [    6.839659] driver: '0000:02:0a.2': driver_bound: bound to device 'ehci_hcd' 
Jun 10 19:14:05 upstairs kernel: [    6.839662] bus: 'pci': really_probe: bound device 0000:02:0a.2 to driver ehci_hcd 
Jun 10 19:14:05 upstairs kernel: [    6.892636] bus: 'i2c': registered 
Jun 10 19:14:05 upstairs kernel: [    6.892641] device class 'i2c-adapter': registering 
Jun 10 19:14:05 upstairs kernel: [    6.892654] bus: 'i2c': add driver dummy 
Jun 10 19:14:05 upstairs kernel: [    6.914309] hub 7-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100 
Jun 10 19:14:05 upstairs kernel: [    6.914316] hub 10-0:1.0: state 7 ports 4 chg 0000 evt 0000 
Jun 10 19:14:05 upstairs kernel: [    6.914325] ehci_hcd 0000:02:09.2: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT 
Jun 10 19:14:05 upstairs kernel: [    6.914332] hub 10-0:1.0: port 1, status 0501, change 0001, 480 Mb/s 
Jun 10 19:14:05 upstairs kernel: [    6.922801] ohci_hcd 0000:02:0a.0: urb f76dfb00 path 2 ep1in 5e160000 cc 5 --> status -62 
Jun 10 19:14:05 upstairs kernel: [    6.922808] hub 6-2:1.0: transfer --> -62 
Jun 10 19:14:05 upstairs kernel: [    6.947291] device class 'firmware': registering 
Jun 10 19:14:05 upstairs kernel: [    6.963959] device class 'dvb': registering 
Jun 10 19:14:05 upstairs kernel: [    6.967903] bus: 'usb': add driver usbhid 
Jun 10 19:14:05 upstairs kernel: [    6.967925] bus: 'usb': driver_probe_device: matched device 2-2:1.0 with driver usbhid 
Jun 10 19:14:05 upstairs kernel: [    6.967928] bus: 'usb': really_probe: probing driver usbhid with device 2-2:1.0 
Jun 10 19:14:05 upstairs kernel: [    6.967934] usbhid 2-2:1.0: usb_probe_interface 
Jun 10 19:14:05 upstairs kernel: [    6.967936] usbhid 2-2:1.0: usb_probe_interface - got id 
Jun 10 19:14:05 upstairs kernel: [    6.981833] device: 'input3': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.981865] PM: Adding info for No Bus:input3 
Jun 10 19:14:05 upstairs kernel: [    6.981903] input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.0/input/input3 
Jun 10 19:14:05 upstairs kernel: [    6.982335] uhci_hcd 0000:00:1d.1: reserve dev 4 ep81-INT, period 8, phase 4, 118 us 
Jun 10 19:14:05 upstairs kernel: [    6.983576] device: 'event3': device_add 
Jun 10 19:14:05 upstairs kernel: [    6.983587] PM: Adding info for No Bus:event3 
Jun 10 19:14:05 upstairs kernel: [    6.983600] input: USB HID v1.11 Keyboard [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun 10 19:14:05 upstairs kernel: [    6.983760] driver: '2-2:1.0': driver_bound: bound to device 'usbhid' 
Jun 10 19:14:05 upstairs kernel: [    6.983763] bus: 'usb': really_probe: bound device 2-2:1.0 to driver usbhid 
Jun 10 19:14:05 upstairs kernel: [    6.983767] bus: 'usb': driver_probe_device: matched device 2-2:1.1 with driver usbhid 
Jun 10 19:14:05 upstairs kernel: [    6.983769] bus: 'usb': really_probe: probing driver usbhid with device 2-2:1.1 
Jun 10 19:14:05 upstairs kernel: [    6.983775] usbhid 2-2:1.1: usb_probe_interface 
Jun 10 19:14:05 upstairs kernel: [    6.983777] usbhid 2-2:1.1: usb_probe_interface - got id 
Jun 10 19:14:05 upstairs kernel: [    6.992291] dib0700: loaded with support for 7 different device-types 
Jun 10 19:14:05 upstairs kernel: [    6.992291] bus: 'usb': add driver dvb_usb_dib0700 
Jun 10 19:14:05 upstairs kernel: [    7.018301] hub 10-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501 
Jun 10 19:14:05 upstairs kernel: [    7.018782] ohci_hcd 0000:02:0a.0: urb f76dfb00 path 2 ep1in 5f160000 cc 5 --> status -62 
Jun 10 19:14:05 upstairs kernel: [    7.018787] hub 6-2:1.0: transfer --> -62 
Jun 10 19:14:05 upstairs kernel: [    7.069540] ehci_hcd 0000:02:09.2: port 1 high speed 
Jun 10 19:14:05 upstairs kernel: [    7.069546] ehci_hcd 0000:02:09.2: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT 
Jun 10 19:14:05 upstairs kernel: [    7.114757] ohci_hcd 0000:02:0a.0: urb f76dfb00 path 2 ep1in 5e160000 cc 5 --> status -62 
Jun 10 19:14:05 upstairs kernel: [    7.114757] hub 6-2:1.0: transfer --> -62 
Jun 10 19:14:05 upstairs kernel: [    7.119542] device: 'input4': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.119542] PM: Adding info for No Bus:input4 
Jun 10 19:14:05 upstairs kernel: [    7.119542] input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.1/input/input4 
Jun 10 19:14:05 upstairs kernel: [    7.119542] uhci_hcd 0000:00:1d.1: reserve dev 4 ep82-INT, period 8, phase 4, 118 us 
Jun 10 19:14:05 upstairs kernel: [    7.119542] device: 'mouse1': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.119542] PM: Adding info for No Bus:mouse1 
Jun 10 19:14:05 upstairs kernel: [    7.120305] usb 10-1: new high speed USB device using ehci_hcd and address 2 
Jun 10 19:14:05 upstairs kernel: [    7.120687] device: 'event4': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.120697] PM: Adding info for No Bus:event4 
Jun 10 19:14:05 upstairs kernel: [    7.120710] input: USB HID v1.11 Mouse [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
Jun 10 19:14:05 upstairs kernel: [    7.120854] driver: '2-2:1.1': driver_bound: bound to device 'usbhid' 
Jun 10 19:14:05 upstairs kernel: [    7.120857] bus: 'usb': really_probe: bound device 2-2:1.1 to driver usbhid 
Jun 10 19:14:05 upstairs kernel: [    7.132922] usb 10-1: default language 0x0409 
Jun 10 19:14:05 upstairs kernel: [    7.133293] device: '10-1': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.133293] bus: 'usb': add device 10-1 
Jun 10 19:14:05 upstairs kernel: [    7.133293] PM: Adding info for usb:10-1 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1: uevent 
Jun 10 19:14:05 upstairs kernel: [    7.133293] bus: 'usb': driver_probe_device: matched device 10-1 with driver usb 
Jun 10 19:14:05 upstairs kernel: [    7.133293] bus: 'usb': really_probe: probing driver usb with device 10-1 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1: usb_probe_device 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1: configuration #1 chosen from 1 choice 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1: adding 10-1:1.0 (config #1, interface 0) 
Jun 10 19:14:05 upstairs kernel: [    7.133293] device: '10-1:1.0': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.133293] bus: 'usb': add device 10-1:1.0 
Jun 10 19:14:05 upstairs kernel: [    7.133293] PM: Adding info for usb:10-1:1.0 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1:1.0: uevent 
Jun 10 19:14:05 upstairs kernel: [    7.133293] device: 'usbdev10.2_ep01': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.133293] PM: Adding info for No Bus:usbdev10.2_ep01 
Jun 10 19:14:05 upstairs kernel: [    7.133293] device: 'usbdev10.2_ep81': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.133293] PM: Adding info for No Bus:usbdev10.2_ep81 
Jun 10 19:14:05 upstairs kernel: [    7.133293] device: 'usbdev10.2_ep82': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.133293] PM: Adding info for No Bus:usbdev10.2_ep82 
Jun 10 19:14:05 upstairs kernel: [    7.133293] device: 'usbdev10.2_ep83': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.133293] PM: Adding info for No Bus:usbdev10.2_ep83 
Jun 10 19:14:05 upstairs kernel: [    7.133293] drivers/usb/core/inode.c: creating file '002' 
Jun 10 19:14:05 upstairs kernel: [    7.133293] driver: '10-1': driver_bound: bound to device 'usb' 
Jun 10 19:14:05 upstairs kernel: [    7.133293] bus: 'usb': really_probe: bound device 10-1 to driver usb 
Jun 10 19:14:05 upstairs kernel: [    7.133293] device: 'usbdev10.2_ep00': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.133293] PM: Adding info for No Bus:usbdev10.2_ep00 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1: New USB device found, idVendor=2040, idProduct=9950 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1: Product: WinTV Nova-DT 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1: Manufacturer: Hauppauge 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 10-1: SerialNumber: 4030248054 
Jun 10 19:14:05 upstairs kernel: [    7.133293] hub 6-0:1.0: state 7 ports 3 chg 0000 evt 0004 
Jun 10 19:14:05 upstairs kernel: [    7.133293] ohci_hcd 0000:02:0a.0: GetStatus roothub.portstatus [1] = 0x00030100 PESC CSC PPS 
Jun 10 19:14:05 upstairs kernel: [    7.133293] hub 6-0:1.0: port 2, status 0100, change 0003, 12 Mb/s 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 6-2: USB disconnect, address 2 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 6-2: unregistering device 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usb 6-2: usb_disable_device nuking all URBs 
Jun 10 19:14:05 upstairs kernel: [    7.133293] ohci_hcd 0000:02:0a.0: shutdown urb f76dfb00 ep1in-intr 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usbcore: registered new interface driver usbhid 
Jun 10 19:14:05 upstairs kernel: [    7.133293] usbhid: v2.6:USB HID core driver 
Jun 10 19:14:05 upstairs kernel: [    7.135292] bus: 'usb': driver_probe_device: matched device 10-1:1.0 with driver dvb_usb_dib0700 
Jun 10 19:14:05 upstairs kernel: [    7.135292] bus: 'usb': really_probe: probing driver dvb_usb_dib0700 with device 10-1:1.0 
Jun 10 19:14:05 upstairs kernel: [    7.135292] dvb_usb_dib0700 10-1:1.0: usb_probe_interface 
Jun 10 19:14:05 upstairs kernel: [    7.135292] dvb_usb_dib0700 10-1:1.0: usb_probe_interface - got id 
Jun 10 19:14:05 upstairs kernel: [    7.135292] usb 6-2: unregistering interface 6-2:1.0 
Jun 10 19:14:05 upstairs kernel: [    7.135292] PM: Removing info for usb:6-2:1.0 
Jun 10 19:14:05 upstairs kernel: [    7.135292] bus: 'usb': remove device 6-2:1.0 
Jun 10 19:14:05 upstairs kernel: [    7.135292] usb 6-2:1.0: uevent 
Jun 10 19:14:05 upstairs kernel: [    7.135292] device: 'usbdev6.2_ep81': device_unregister 
Jun 10 19:14:05 upstairs kernel: [    7.135292] PM: Removing info for No Bus:usbdev6.2_ep81 
Jun 10 19:14:05 upstairs kernel: [    7.135292] device: 'usbdev6.2_ep00': device_unregister 
Jun 10 19:14:05 upstairs kernel: [    7.135292] PM: Removing info for No Bus:usbdev6.2_ep00 
Jun 10 19:14:05 upstairs kernel: [    7.135292] PM: Removing info for usb:6-2 
Jun 10 19:14:05 upstairs kernel: [    7.135292] bus: 'usb': remove device 6-2 
Jun 10 19:14:05 upstairs kernel: [    7.135292] usb 6-2: uevent 
Jun 10 19:14:05 upstairs kernel: [    7.135292] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state. 
Jun 10 19:14:05 upstairs kernel: [    7.136301] device: 'i2c-0': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.136312] PM: Adding info for No Bus:i2c-0 
Jun 10 19:14:05 upstairs kernel: [    7.136326] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun 10 19:14:05 upstairs kernel: [    7.136612] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun 10 19:14:05 upstairs kernel: [    7.136731] device: 'dvb0.demux0': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.136731] PM: Adding info for No Bus:dvb0.demux0 
Jun 10 19:14:05 upstairs kernel: [    7.136731] device: 'dvb0.dvr0': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.136731] PM: Adding info for No Bus:dvb0.dvr0 
Jun 10 19:14:05 upstairs kernel: [    7.136749] device: 'dvb0.net0': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.136757] PM: Adding info for No Bus:dvb0.net0 
Jun 10 19:14:05 upstairs kernel: [    7.226291] device: 'i2c-1': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.226291] PM: Adding info for No Bus:i2c-1 
Jun 10 19:14:05 upstairs kernel: [    7.230050] DVB: registering frontend 0 (DiBcom 3000MC/P)... 
Jun 10 19:14:05 upstairs kernel: [    7.230111] device: 'dvb0.frontend0': device_add 
Jun 10 19:14:05 upstairs kernel: [    7.230124] PM: Adding info for No Bus:dvb0.frontend0 
Jun 10 19:14:36 upstairs kernel: [    7.238303] hub 6-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100 
Jun 10 19:14:36 upstairs kernel: [    7.238310] hub 11-0:1.0: state 7 ports 5 chg 0000 evt 0000 
Jun 10 19:14:36 upstairs kernel: [    7.238323] ehci_hcd 0000:02:0a.2: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT 
Jun 10 19:14:36 upstairs kernel: [    7.238331] hub 11-0:1.0: port 3, status 0501, change 0001, 480 Mb/s 
Jun 10 19:14:36 upstairs kernel: [    7.260292] MT2060: successfully identified (IF1 = 1230) 
Jun 10 19:14:36 upstairs kernel: [    7.342300] hub 11-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501 
Jun 10 19:14:36 upstairs kernel: [    7.393466] ehci_hcd 0000:02:0a.2: port 3 high speed 
Jun 10 19:14:36 upstairs kernel: [    7.393471] ehci_hcd 0000:02:0a.2: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT 
Jun 10 19:14:36 upstairs kernel: [    7.444310] usb 11-3: new high speed USB device using ehci_hcd and address 2 
Jun 10 19:14:36 upstairs kernel: [    7.457763] device: '11-3': device_add 
Jun 10 19:14:36 upstairs kernel: [    7.457793] bus: 'usb': add device 11-3 
Jun 10 19:14:36 upstairs kernel: [    7.457804] PM: Adding info for usb:11-3 
Jun 10 19:14:36 upstairs kernel: [    7.457814] usb 11-3: uevent 
Jun 10 19:14:36 upstairs kernel: [    7.457827] bus: 'usb': driver_probe_device: matched device 11-3 with driver usb 
Jun 10 19:14:36 upstairs kernel: [    7.457830] bus: 'usb': really_probe: probing driver usb with device 11-3 
Jun 10 19:14:36 upstairs kernel: [    7.457839] usb 11-3: usb_probe_device 
Jun 10 19:14:36 upstairs kernel: [    7.457842] usb 11-3: configuration #1 chosen from 1 choice 
Jun 10 19:14:36 upstairs kernel: [    7.458013] usb 11-3: adding 11-3:1.0 (config #1, interface 0) 
Jun 10 19:14:36 upstairs kernel: [    7.458016] device: '11-3:1.0': device_add 
Jun 10 19:14:36 upstairs kernel: [    7.458028] bus: 'usb': add device 11-3:1.0 
Jun 10 19:14:36 upstairs kernel: [    7.458033] PM: Adding info for usb:11-3:1.0 
Jun 10 19:14:36 upstairs kernel: [    7.458039] usb 11-3:1.0: uevent 
Jun 10 19:14:36 upstairs kernel: [    7.458051] bus: 'usb': driver_probe_device: matched device 11-3:1.0 with driver hub 
Jun 10 19:14:36 upstairs kernel: [    7.458053] bus: 'usb': really_probe: probing driver hub with device 11-3:1.0 
Jun 10 19:14:36 upstairs kernel: [    7.458060] hub 11-3:1.0: usb_probe_interface 
Jun 10 19:14:36 upstairs kernel: [    7.458062] hub 11-3:1.0: usb_probe_interface - got id 
Jun 10 19:14:36 upstairs kernel: [    7.458064] hub 11-3:1.0: USB hub found 
Jun 10 19:14:36 upstairs kernel: [    7.458258] hub 11-3:1.0: 4 ports detected 
Jun 10 19:14:36 upstairs kernel: [    7.458324] hub 11-3:1.0: standalone hub 
Jun 10 19:14:36 upstairs kernel: [    7.458327] hub 11-3:1.0: ganged power switching 
Jun 10 19:14:36 upstairs kernel: [    7.458329] hub 11-3:1.0: global over-current protection 
Jun 10 19:14:36 upstairs kernel: [    7.458331] hub 11-3:1.0: Single TT 
Jun 10 19:14:36 upstairs kernel: [    7.458333] hub 11-3:1.0: TT requires at most 16 FS bit times (1332 ns) 
Jun 10 19:14:36 upstairs kernel: [    7.458335] hub 11-3:1.0: Port indicators are supported 
Jun 10 19:14:36 upstairs kernel: [    7.458337] hub 11-3:1.0: power on to power good time: 100ms 
Jun 10 19:14:36 upstairs kernel: [    7.458636] hub 11-3:1.0: local power source is good 
Jun 10 19:14:36 upstairs kernel: [    7.458639] hub 11-3:1.0: no over-current condition exists 
Jun 10 19:14:36 upstairs kernel: [    7.458642] hub 11-3:1.0: enabling power on all ports 
Jun 10 19:14:36 upstairs kernel: [    7.559302] usb 11-3: link qh256-0001/f70fa100 start 255 [1/0 us] 
Jun 10 19:14:36 upstairs kernel: [    7.559310] driver: '11-3:1.0': driver_bound: bound to device 'hub' 
Jun 10 19:14:36 upstairs kernel: [    7.559313] bus: 'usb': really_probe: bound device 11-3:1.0 to driver hub 
Jun 10 19:14:36 upstairs kernel: [    7.559320] device: 'usbdev11.2_ep81': device_add 
Jun 10 19:14:36 upstairs kernel: [    7.559352] PM: Adding info for No Bus:usbdev11.2_ep81 
Jun 10 19:14:36 upstairs kernel: [    7.559370] drivers/usb/core/inode.c: creating file '002' 
Jun 10 19:14:36 upstairs kernel: [    7.559377] driver: '11-3': driver_bound: bound to device 'usb' 
Jun 10 19:14:36 upstairs kernel: [    7.559380] bus: 'usb': really_probe: bound device 11-3 to driver usb 
Jun 10 19:14:36 upstairs kernel: [    7.559389] device: 'usbdev11.2_ep00': device_add 
Jun 10 19:14:36 upstairs kernel: [    7.559406] PM: Adding info for No Bus:usbdev11.2_ep00 
Jun 10 19:14:36 upstairs kernel: [    7.559420] usb 11-3: New USB device found, idVendor=0409, idProduct=0059 
Jun 10 19:14:36 upstairs kernel: [    7.559478] usb 11-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0 
Jun 10 19:14:36 upstairs kernel: [    7.559550] hub 11-3:1.0: state 7 ports 4 chg 0000 evt 0000 
Jun 10 19:14:36 upstairs kernel: [    7.708226] ohci_hcd 0000:02:0a.1: auto-stop root hub 
Jun 10 19:14:36 upstairs kernel: [    7.708226] usb usb9: suspend_rh (auto-stop) 
Jun 10 19:14:36 upstairs kernel: [    7.733195] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
Jun 10 19:14:36 upstairs kernel: [    7.733195] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
Jun 10 19:14:36 upstairs kernel: [    7.733195] device: 'dvb1.demux0': device_add 
Jun 10 19:14:36 upstairs kernel: [    7.733195] PM: Adding info for No Bus:dvb1.demux0 
Jun 10 19:14:36 upstairs kernel: [    7.733195] device: 'dvb1.dvr0': device_add 
Jun 10 19:14:36 upstairs kernel: [    7.733195] PM: Adding info for No Bus:dvb1.dvr0 
Jun 10 19:14:36 upstairs kernel: [    7.733195] device: 'dvb1.net0': device_add 
Jun 10 19:14:36 upstairs kernel: [    7.733195] PM: Adding info for No Bus:dvb1.net0 
Jun 10 19:14:36 upstairs kernel: [    7.740962] device: 'i2c-2': device_add 
Jun 10 19:14:36 upstairs kernel: [    7.740977] PM: Adding info for No Bus:i2c-2 
Jun 10 19:14:36 upstairs kernel: [    7.743463] DVB: registering frontend 1 (DiBcom 3000MC/P)... 
Jun 10 19:14:36 upstairs kernel: [    7.743529] device: 'dvb1.frontend0': device_add 
Jun 10 19:14:36 upstairs kernel: [    7.743547] PM: Adding info for No Bus:dvb1.frontend0 
Jun 10 19:14:36 upstairs kernel: [    7.748460] MT2060: successfully identified (IF1 = 1234) 
Jun 10 19:14:36 upstairs kernel: [    7.958215] usb usb7: suspend_rh (auto-stop) 
Jun 10 19:14:36 upstairs kernel: [    8.208211] ohci_hcd 0000:02:0a.0: auto-stop root hub 
Jun 10 19:14:36 upstairs kernel: [    8.248204] device: 'input5': device_add 
Jun 10 19:14:36 upstairs kernel: [    8.248204] PM: Adding info for No Bus:input5 
Jun 10 19:14:36 upstairs kernel: [    8.248204] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:09.2/usb10/10-1/input/input5 
Jun 10 19:14:36 upstairs kernel: [    8.255024] device: 'event5': device_add 
Jun 10 19:14:36 upstairs kernel: [    8.255039] PM: Adding info for No Bus:event5 
Jun 10 19:14:36 upstairs kernel: [    8.255056] dvb-usb: schedule remote query interval to 150 msecs. 
Jun 10 19:14:36 upstairs kernel: [    8.255115] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and connected. 
Jun 10 19:14:36 upstairs kernel: [    8.255342] driver: '10-1:1.0': driver_bound: bound to device 'dvb_usb_dib0700' 
Jun 10 19:14:36 upstairs kernel: [    8.255347] bus: 'usb': really_probe: bound device 10-1:1.0 to driver dvb_usb_dib0700 
Jun 10 19:14:36 upstairs kernel: [    8.255369] usbcore: registered new interface driver dvb_usb_dib0700 
Jun 10 19:14:36 upstairs kernel: [   25.621292] fuse init (API version 7.9) 
Jun 10 19:14:36 upstairs kernel: [   25.621396] device: 'fuse': device_add 
Jun 10 19:14:36 upstairs kernel: [   25.621413] PM: Adding info for No Bus:fuse 
Jun 10 19:14:36 upstairs kernel: [   25.848583] device: '8:1-fuseblk': device_add 
Jun 10 19:14:36 upstairs kernel: [   25.848606] PM: Adding info for No Bus:8:1-fuseblk 
Jun 10 19:14:36 upstairs kernel: [   25.901286] kjournald starting.  Commit interval 5 seconds 
Jun 10 19:14:36 upstairs kernel: [   25.901286] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun 10 19:14:36 upstairs kernel: [   25.901286] EXT3 FS on sdb6, internal journal 
Jun 10 19:14:36 upstairs kernel: [   25.901286] EXT3-fs: mounted filesystem with ordered data mode. 
Jun 10 19:14:36 upstairs kernel: [   25.920285] kjournald starting.  Commit interval 5 seconds 
Jun 10 19:14:36 upstairs kernel: [   25.927112] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun 10 19:14:36 upstairs kernel: [   25.927112] EXT3 FS on sda6, internal journal 
Jun 10 19:14:36 upstairs kernel: [   25.930337] EXT3-fs: mounted filesystem with ordered data mode. 
Jun 10 19:14:36 upstairs kernel: [   25.941287] kjournald starting.  Commit interval 5 seconds 
Jun 10 19:14:36 upstairs kernel: [   25.947298] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun 10 19:14:36 upstairs kernel: [   25.947298] EXT3 FS on sda7, internal journal 
Jun 10 19:14:36 upstairs kernel: [   25.947298] EXT3-fs: mounted filesystem with ordered data mode. 
Jun 10 19:14:36 upstairs kernel: [   25.970305] kjournald starting.  Commit interval 5 seconds 
Jun 10 19:14:36 upstairs kernel: [   25.980305] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
Jun 10 19:14:36 upstairs kernel: [   25.988964] EXT3 FS on sdc2, internal journal 
Jun 10 19:14:36 upstairs kernel: [   25.988964] EXT3-fs: mounted filesystem with ordered data mode. 
Jun 10 19:14:36 upstairs kernel: [   26.022049] Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k 
Jun 10 19:14:36 upstairs kernel: [   26.730357] device: 'vcs1': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   26.730362] PM: Removing info for No Bus:vcs1 
Jun 10 19:14:36 upstairs kernel: [   26.730404] device: 'vcs1': device_create_release 
Jun 10 19:14:36 upstairs kernel: [   26.730407] device: 'vcsa1': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   26.730409] PM: Removing info for No Bus:vcsa1 
Jun 10 19:14:36 upstairs kernel: [   26.730429] device: 'vcsa1': device_create_release 
Jun 10 19:14:36 upstairs kernel: [   26.745475] device: 'vcs1': device_add 
Jun 10 19:14:36 upstairs kernel: [   26.745492] PM: Adding info for No Bus:vcs1 
Jun 10 19:14:36 upstairs kernel: [   26.745509] device: 'vcsa1': device_add 
Jun 10 19:14:36 upstairs kernel: [   26.745517] PM: Adding info for No Bus:vcsa1 
Jun 10 19:14:36 upstairs kernel: [   26.745581] device: 'vcs1': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   26.745583] PM: Removing info for No Bus:vcs1 
Jun 10 19:14:36 upstairs kernel: [   26.745599] device: 'vcs1': device_create_release 
Jun 10 19:14:36 upstairs kernel: [   26.745602] device: 'vcsa1': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   26.745603] PM: Removing info for No Bus:vcsa1 
Jun 10 19:14:36 upstairs kernel: [   26.745616] device: 'vcsa1': device_create_release 
Jun 10 19:14:36 upstairs kernel: [   26.745630] device: 'vcs1': device_add 
Jun 10 19:14:36 upstairs kernel: [   26.745639] PM: Adding info for No Bus:vcs1 
Jun 10 19:14:36 upstairs kernel: [   26.745649] device: 'vcsa1': device_add 
Jun 10 19:14:36 upstairs kernel: [   26.745656] PM: Adding info for No Bus:vcsa1 
Jun 10 19:14:36 upstairs kernel: [   26.745714] device: 'vcs1': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   26.745716] PM: Removing info for No Bus:vcs1 
Jun 10 19:14:36 upstairs kernel: [   26.745729] device: 'vcs1': device_create_release 
Jun 10 19:14:36 upstairs kernel: [   26.745732] device: 'vcsa1': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   26.745733] PM: Removing info for No Bus:vcsa1 
Jun 10 19:14:36 upstairs kernel: [   26.745745] device: 'vcsa1': device_create_release 
Jun 10 19:14:36 upstairs kernel: [   26.745757] device: 'vcs1': device_add 
Jun 10 19:14:36 upstairs kernel: [   26.745765] PM: Adding info for No Bus:vcs1 
Jun 10 19:14:36 upstairs kernel: [   26.745775] device: 'vcsa1': device_add 
Jun 10 19:14:36 upstairs kernel: [   26.745782] PM: Adding info for No Bus:vcsa1 
Jun 10 19:14:36 upstairs kernel: [   26.745885] device: 'vcs1': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   26.745888] PM: Removing info for No Bus:vcs1 
Jun 10 19:14:36 upstairs kernel: [   26.745901] device: 'vcs1': device_create_release 
Jun 10 19:14:36 upstairs kernel: [   26.745904] device: 'vcsa1': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   26.745906] PM: Removing info for No Bus:vcsa1 
Jun 10 19:14:36 upstairs kernel: [   26.745917] device: 'vcsa1': device_create_release 
Jun 10 19:14:36 upstairs kernel: [   26.745885] device: 'vcs1': device_add 
Jun 10 19:14:36 upstairs kernel: [   26.745885] PM: Adding info for No Bus:vcs1 
Jun 10 19:14:36 upstairs kernel: [   26.745885] device: 'vcsa1': device_add 
Jun 10 19:14:36 upstairs kernel: [   26.745885] PM: Adding info for No Bus:vcsa1 
Jun 10 19:14:36 upstairs kernel: [   26.861764] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1 
Jun 10 19:14:36 upstairs kernel: [   28.023909] ip_tables: (C) 2000-2006 Netfilter Core Team 
Jun 10 19:14:36 upstairs kernel: [   28.029759] nf_conntrack version 0.5.0 (16384 buckets, 65536 max) 
Jun 10 19:14:36 upstairs kernel: [   33.631050] bus: 'pci': remove driver parport_pc 
Jun 10 19:14:36 upstairs kernel: [   33.631325] driver: 'parport_pc': driver_release 
Jun 10 19:14:36 upstairs kernel: [   33.631333] bus: 'pnp': remove driver parport_pc 
Jun 10 19:14:36 upstairs kernel: [   33.631803] parport_pc 00:06: disabled 
Jun 10 19:14:36 upstairs kernel: [   33.632459] driver: 'parport_pc': driver_release 
Jun 10 19:14:36 upstairs kernel: [   33.632463] pnp: the driver 'parport_pc' has been unregistered 
Jun 10 19:14:36 upstairs kernel: [   33.632469] bus: 'platform': remove driver parport_pc 
Jun 10 19:14:36 upstairs kernel: [   33.632483] driver: 'parport_pc': driver_release 
Jun 10 19:14:36 upstairs kernel: [   33.638664] bus: 'pci': remove driver ohci1394 
Jun 10 19:14:36 upstairs kernel: [   33.638696] ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
Jun 10 19:14:36 upstairs kernel: [   33.638700] device: '00110666000013cc': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   33.638703] PM: Removing info for No Bus:00110666000013cc 
Jun 10 19:14:36 upstairs kernel: [   33.638728] device: '00110666000013cc': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   33.638731] PM: Removing info for ieee1394:00110666000013cc 
Jun 10 19:14:36 upstairs kernel: [   33.638738] bus: 'ieee1394': remove device 00110666000013cc 
Jun 10 19:14:36 upstairs kernel: [   33.638755] device: 'fw-host0': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   33.638758] PM: Removing info for No Bus:fw-host0 
Jun 10 19:14:36 upstairs kernel: [   33.638774] device: 'fw-host0': device_unregister 
Jun 10 19:14:36 upstairs kernel: [   33.638776] PM: Removing info for ieee1394:fw-host0 
Jun 10 19:14:36 upstairs kernel: [   33.638783] bus: 'ieee1394': remove device fw-host0 
Jun 10 19:14:36 upstairs kernel: [   33.644288] driver: 'ohci1394': driver_release 
Jun 10 19:14:36 upstairs kernel: [   33.650839] bus: 'ieee1394': remove driver nodemgr 
Jun 10 19:14:36 upstairs kernel: [   33.650855] driver: 'nodemgr': driver_release 
Jun 10 19:14:36 upstairs kernel: [   33.650858] device class 'ieee1394': unregistering 
Jun 10 19:14:36 upstairs kernel: [   33.650870] class 'ieee1394': release. 
Jun 10 19:14:36 upstairs kernel: [   33.650872] class 'ieee1394' does not have a release() function, be careful 
Jun 10 19:14:36 upstairs kernel: [   33.650875] device class 'ieee1394_node': unregistering 
Jun 10 19:14:36 upstairs kernel: [   33.650884] class 'ieee1394_node': release. 
Jun 10 19:14:36 upstairs kernel: [   33.650886] class 'ieee1394_node' does not have a release() function, be careful 
Jun 10 19:14:36 upstairs kernel: [   33.650889] device class 'ieee1394_protocol': unregistering 
Jun 10 19:14:36 upstairs kernel: [   33.650897] class 'ieee1394_protocol': release. 
Jun 10 19:14:36 upstairs kernel: [   33.650900] class_create_release called for ieee1394_protocol 
Jun 10 19:14:36 upstairs kernel: [   33.650902] device class 'ieee1394_host': unregistering 
Jun 10 19:14:36 upstairs kernel: [   33.650911] class 'ieee1394_host': release. 
Jun 10 19:14:36 upstairs kernel: [   33.650913] class 'ieee1394_host' does not have a release() function, be careful 
Jun 10 19:14:36 upstairs kernel: [   33.650919] bus: 'ieee1394': unregistering 
Jun 10 19:14:36 upstairs kernel: [   33.889343] device: 'vcs2': device_add 
Jun 10 19:14:36 upstairs kernel: [   33.889367] PM: Adding info for No Bus:vcs2 
Jun 10 19:14:36 upstairs kernel: [   33.889393] device: 'vcsa2': device_add 
Jun 10 19:14:36 upstairs kernel: [   33.889401] PM: Adding info for No Bus:vcsa2 
Jun 10 19:14:36 upstairs kernel: [   33.890188] device: 'vcs4': device_add 
Jun 10 19:14:36 upstairs kernel: [   33.890200] PM: Adding info for No Bus:vcs4 
Jun 10 19:14:36 upstairs kernel: [   33.890215] device: 'vcsa4': device_add 
Jun 10 19:14:36 upstairs kernel: [   33.890223] PM: Adding info for No Bus:vcsa4 
Jun 10 19:14:36 upstairs kernel: [   33.890692] device: 'vcs3': device_add 
Jun 10 19:14:36 upstairs kernel: [   33.890704] PM: Adding info for No Bus:vcs3 
Jun 10 19:14:36 upstairs kernel: [   33.890721] device: 'vcsa3': device_add 
Jun 10 19:14:36 upstairs kernel: [   33.890729] PM: Adding info for No Bus:vcsa3 
Jun 10 19:14:36 upstairs kernel: [   36.137134] device: 'vcs5': device_add 
Jun 10 19:14:36 upstairs kernel: [   36.137183] PM: Adding info for No Bus:vcs5 
Jun 10 19:14:36 upstairs kernel: [   36.137225] device: 'vcsa5': device_add 
Jun 10 19:14:36 upstairs kernel: [   36.137243] PM: Adding info for No Bus:vcsa5 

--Boundary-00=_irvTIAqiIgDofeV--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
