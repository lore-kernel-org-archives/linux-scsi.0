From: Fabio David <fabiodavid@gmail.com>
Subject: Re: Issue with mini-SaS to eSATA to USB 3.0 setup
Date: Fri, 22 Feb 2013 11:54:56 -0300
Message-ID: <CAAfSSYh_+YmwJ36qhy0C2hMXWHtDPoUT-VYFusd_Jp4WX5MhVg@mail.gmail.com>
References: <CAAfSSYhT+r07yQfok_BvKj_bTnCUv7nMX8Wafd-xjB1ejEZusQ@mail.gmail.com>
 <CAAfSSYj4ycBUVW3rVy1jrbJEY2hW_Ui88MyWdA5yGose80Vggw@mail.gmail.com>
 <20130221192646.GE27219@xanatos> <CAAfSSYhUzSv+R8qkhBpvM0z39mKFH07FZ3Vuk_y3XVM81aAnSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60077 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3BVOzS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 09:55:18 -0500
In-Reply-To: <CAAfSSYhUzSv+R8qkhBpvM0z39mKFH07FZ3Vuk_y3XVM81aAnSw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

resent

On Thu, Feb 21, 2013 at 4:26 PM, Sarah Sharp <sarah.a.sharp@linux.intel.com>
wrote:
>
> Cc-ing the SCSI and USB storage list.
>
> Folks, does the attached picture look like a sane setup?  I've never
> used mini-SaS to eSATA adapter before, let alone with four eSATA to USB
> 3.0 adapters.
>

I know it is a weird setup...

> On Tue, Jan 29, 2013 at 12:56:02PM -0200, Fabio David wrote:
> > Hi Sarah,
> >
> > My name is Fabio David and I am from Brazil. I've seen your posts on
> > several forums and read articles about you. I really admire your work.
> >
> > Maybe you can help me. I'm trying to connect a PC running Centos 6.3
> > to a CRU dataport 4-bay storage device. This device only has a miniSaS
> > port.
> >
> > Here is my scenario:
> >
> > - DataCRU device with 4 hot-swapables bays.
> > http://www.cru-inc.com/slideshow.php?dir=//Digital-Cinema//&sel=5
> > - MiniSaS cable connects to the DataCRU device and on the other side
> > there are 4 eSata connectors
> >
> > http://www.elpeus.com/sas-mini-sas/external-mini-sas-cables/sff-8088-to-4-esata/3m-mini-sas-sff-8088-to-4-esata-cable/
> > - 4 eSata<->USB3.0 adaptors connected to each eSata connector
> > - Adaptors connected to a USB3.0 HUB
> > - USB3.0 hub connected to PC
> >
> > Everything works ok, I can mount/read the HDs, but sometimes the
> > system does not detect when a hard drive is inserted/removed from a
> > DataCru bay. No events are generated, nothing appears in
> > /proc/partitions nor udev
> > is called to apply my rules.
>
> Do you lose only hard drive insertion events, or do you lose remove
> events as well?
>

It loses both events, randomly.

>
> For example, what happens when you do this:
>
> 1. Unplug the eSATA to USB adapters from the USB 3.0 hub.
> 2. Insert a hard drive into the bay.
> 3. Connect the eSATA to USB adapter to the USB 3.0 hub.
> 4. Wait for hard drive detection, then hot-remove the drive from the
> bay.


Sometimes it will detect, sometimes dont.

>
> > However, everything works fine when connected directly to PC's USB
> > port. Please look at the attached picture.
>
> It looks like you're only attaching one eSATA to USB adapter to the
> roothub.  Do you only have one USB 3.0 port on the host, or can you try
> plugging in multiple eSATA to USB adapters into the roothub?


Unfortunately, the host only has 1 USB3.0 port

>
>
> Does the setup work when only one eSATA to USB adapter is plugged into
> the USB 3.0 hub?


Same problem...

>
> > Do you have any suggestions?
>
> A couple possible root causes come to mind:
>
> 1. Perhaps the USB 3.0 hub is interfering with communication to your
> eSATA to USB 3.0 adapters.
>
> 2. Maybe USB device suspend is to blame.  Do you have USB device suspend
> enabled for the eSATA to USB adapters?


I am not sure, I thought it was disabled by default. How can I check?

>
> 3. Perhaps the SATA adapters aren't responding with a Medium Changed
> status when the USB storage device is plugged in.
>
> Can you send me dmesg, starting from just before you insert a hard drive
> into the drive bays?  I need dmesg for both when the SATA adapter is
> connected directly to the roothub, and when it's connected to the USB
> 3.0 hub.
>
> A usbmon trace might also be useful for the USB storage developers.
> Documentation on how to take that trace is here:
>
> http://lxr.linux.no/#linux/Documentation/usb/usbmon.txt
>

I will send you as soon as possible

Thanks in advance for your help

Fabio

>
> Sarah Sharp
>
> > ===================================================================
> >
> > lsusb returns
> >
> > Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 001 Device 002: ID 13d3:3323 IMC Networks
> > Bus 001 Device 009: ID 2109:3431  <----------------------------  HUB 3.0
> > Bus 006 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 007 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
> > Bus 007 Device 040: ID 2109:0810  <----------------------------  HUB 3.0
> > Bus 007 Device 041: ID 1234:5678 Brain Actuated Technologies
> > Bus 007 Device 042: ID 1234:5678 Brain Actuated Technologies
> > Bus 007 Device 043: ID 1234:5678 Brain Actuated Technologies
> > Bus 007 Device 044: ID 1234:5678 Brain Actuated Technologies
> >
> > /var/log/messages
> > ....
> > Jan 27 18:00:28 localhost kernel: usb 7-1: New USB device found,
> > idVendor=2109, idProduct=0810
> > Jan 27 18:00:28 localhost kernel: usb 7-1: New USB device strings:
> > Mfr=1, Product=2, SerialNumber=0
> > Jan 27 18:00:28 localhost kernel: usb 7-1: Product: 4-Port USB 3.0 Hub
> > Jan 27 18:00:28 localhost kernel: usb 7-1: Manufacturer: VIA Labs, Inc.
> > Jan 27 18:00:28 localhost kernel: usb 7-1: configuration #1 chosen from
> > 1 choice
> > Jan 27 18:00:28 localhost kernel: hub 7-1:1.0: USB hub found
> > Jan 27 18:00:28 localhost kernel: hub 7-1:1.0: 4 ports detected
> > ....
> > Jan 28 21:32:02 localhost kernel: usb 7-1.1: new SuperSpeed USB device
> > number 9 using xhci_hcd
> > Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: PCI INT A ->
> > GSI 16 (level, low) -> IRQ 16
> > Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: xHCI Host
> > Controller
> > Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: new USB bus
> > registered, assigned bus number 6
> > Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: irq 16, io
> > mem 0xdfe00000
> > Jan 28 21:32:56 localhost kernel: usb usb6: Manufacturer: Linux
> > 2.6.32-279.19.1.el6.i686 xhci_hcd
> > Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: xHCI Host
> > Controller
> > Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: new USB bus
> > registered, assigned bus number 7
> > Jan 28 21:32:56 localhost kernel: usb usb7: Manufacturer: Linux
> > 2.6.32-279.19.1.el6.i686 xhci_hcd
> > Jan 28 21:32:56 localhost kernel: usb 7-1: new SuperSpeed USB device
> > number 2 using xhci_hcd
> > Jan 28 21:32:56 localhost kernel: usb 7-1.1: new SuperSpeed USB device
> > number 3 using xhci_hcd
> > Jan 28 21:32:56 localhost kernel: usb 7-1.2: new SuperSpeed USB device
> > number 4 using xhci_hcd
> > Jan 28 21:32:56 localhost kernel: usb 7-1.3: new SuperSpeed USB device
> > number 5 using xhci_hcd
> > Jan 28 21:32:56 localhost kernel: usb 7-1.4: new SuperSpeed USB device
> > number 6 using xhci_hcd
>
>
