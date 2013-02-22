From: Fabio David <fabiodavid@gmail.com>
Subject: Re: Issue with mini-SaS to eSATA to USB 3.0 setup
Date: Fri, 22 Feb 2013 12:00:34 -0300
Message-ID: <CAAfSSYieWjJxUts7aawc06mkiC+gT2hs54h2_06rPa_RbS7jZg@mail.gmail.com>
References: <CAAfSSYhT+r07yQfok_BvKj_bTnCUv7nMX8Wafd-xjB1ejEZusQ@mail.gmail.com>
 <CAAfSSYj4ycBUVW3rVy1jrbJEY2hW_Ui88MyWdA5yGose80Vggw@mail.gmail.com>
 <20130221192646.GE27219@xanatos> <CAA6KcBBJbmHXem97fiqDZweCgE90p+VfYz=KHn=J5qtZL6VqKQ@mail.gmail.com>
 <CAAfSSYhmy-wPeu=BPwqLDeXqvMFw5skXKwRsk1UuaqCYyGkMUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:39106 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3BVPBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 10:01:00 -0500
In-Reply-To: <CAAfSSYhmy-wPeu=BPwqLDeXqvMFw5skXKwRsk1UuaqCYyGkMUw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

RESENT

---------- Forwarded message ----------
From: Fabio David <fabiodavid@gmail.com>
Date: Thu, Feb 21, 2013 at 5:42 PM
Subject: Re: [usb-storage] Issue with mini-SaS to eSATA to USB 3.0 setup

Thanks for your reply, Matt.

But it works! Only sometimes the OS doesnt "see" hot-insertion /
hot-remove. And if I connect the USB/eSata directly to PC (without the
USB 3.0 hub), it works 100%, never miss an insertion/removal!

I have created some UDEV mounting rules, and they work fine, no mather
in which bay the HDD has been inserted. The problem is that sometimes
it can not recognize a hot-insert (which is not a big problem, the
user just has to remove/insert it again). But the major problem occurs
when it cannot detect a hot-removal, because the device stays mounted,
partitions still appear at /proc/partitions, etc. as if the HDD was
still there.

Fabio

On Thu, Feb 21, 2013 at 5:16 PM, Matthew Dharm
<mdharm-usb@one-eyed-alien.net> wrote:
>
> I highly doubt hot-insert and hot-remove of HDDs from the 4-bay
> container (without removing the corresponding USB/eSATA adaptor) will
> work.
>
> The USB/eSATA adaptor does not have a way to inform the host that the
> eSATA side has been disconnected from the HDD.  That functionality
> isn't in the usb-storage protocol.
>
> This type of functionality *might* be supported in the UAS protocol,
> but I don't know.
>
> Matt
>
> On Thu, Feb 21, 2013 at 11:26 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> > Cc-ing the SCSI and USB storage list.
> >
> > Folks, does the attached picture look like a sane setup?  I've never
> > used mini-SaS to eSATA adapter before, let alone with four eSATA to USB
> > 3.0 adapters.
> >
> > On Tue, Jan 29, 2013 at 12:56:02PM -0200, Fabio David wrote:
> >> Hi Sarah,
> >>
> >> My name is Fabio David and I am from Brazil. I've seen your posts on
> >> several forums and read articles about you. I really admire your work.
> >>
> >> Maybe you can help me. I'm trying to connect a PC running Centos 6.3
> >> to a CRU dataport 4-bay storage device. This device only has a miniSaS
> >> port.
> >>
> >> Here is my scenario:
> >>
> >> - DataCRU device with 4 hot-swapables bays.
> >> http://www.cru-inc.com/slideshow.php?dir=//Digital-Cinema//&sel=5
> >> - MiniSaS cable connects to the DataCRU device and on the other side
> >> there are 4 eSata connectors
> >>   http://www.elpeus.com/sas-mini-sas/external-mini-sas-cables/sff-8088-to-4-esata/3m-mini-sas-sff-8088-to-4-esata-cable/
> >> - 4 eSata<->USB3.0 adaptors connected to each eSata connector
> >> - Adaptors connected to a USB3.0 HUB
> >> - USB3.0 hub connected to PC
> >>
> >> Everything works ok, I can mount/read the HDs, but sometimes the
> >> system does not detect when a hard drive is inserted/removed from a
> >> DataCru bay. No events are generated, nothing appears in
> >> /proc/partitions nor udev
> >> is called to apply my rules.
> >
> > Do you lose only hard drive insertion events, or do you lose remove
> > events as well?
> >
> > For example, what happens when you do this:
> >
> > 1. Unplug the eSATA to USB adapters from the USB 3.0 hub.
> > 2. Insert a hard drive into the bay.
> > 3. Connect the eSATA to USB adapter to the USB 3.0 hub.
> > 4. Wait for hard drive detection, then hot-remove the drive from the
> > bay.
> >
> >> However, everything works fine when connected directly to PC's USB
> >> port. Please look at the attached picture.
> >
> > It looks like you're only attaching one eSATA to USB adapter to the
> > roothub.  Do you only have one USB 3.0 port on the host, or can you try
> > plugging in multiple eSATA to USB adapters into the roothub?
> >
> > Does the setup work when only one eSATA to USB adapter is plugged into
> > the USB 3.0 hub?
> >
> >> Do you have any suggestions?
> >
> > A couple possible root causes come to mind:
> >
> > 1. Perhaps the USB 3.0 hub is interfering with communication to your
> > eSATA to USB 3.0 adapters.
> >
> > 2. Maybe USB device suspend is to blame.  Do you have USB device suspend
> > enabled for the eSATA to USB adapters?
> >
> > 3. Perhaps the SATA adapters aren't responding with a Medium Changed
> > status when the USB storage device is plugged in.
> >
> > Can you send me dmesg, starting from just before you insert a hard drive
> > into the drive bays?  I need dmesg for both when the SATA adapter is
> > connected directly to the roothub, and when it's connected to the USB
> > 3.0 hub.
> >
> > A usbmon trace might also be useful for the USB storage developers.
> > Documentation on how to take that trace is here:
> >
> > http://lxr.linux.no/#linux/Documentation/usb/usbmon.txt
> >
> > Sarah Sharp
> >
> >> ===================================================================
> >>
> >> lsusb returns
> >>
> >> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> >> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> >> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> >> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> >> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> >> Bus 001 Device 002: ID 13d3:3323 IMC Networks
> >> Bus 001 Device 009: ID 2109:3431  <----------------------------  HUB 3.0
> >> Bus 006 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> >> Bus 007 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
> >> Bus 007 Device 040: ID 2109:0810  <----------------------------  HUB 3.0
> >> Bus 007 Device 041: ID 1234:5678 Brain Actuated Technologies
> >> Bus 007 Device 042: ID 1234:5678 Brain Actuated Technologies
> >> Bus 007 Device 043: ID 1234:5678 Brain Actuated Technologies
> >> Bus 007 Device 044: ID 1234:5678 Brain Actuated Technologies
> >>
> >> /var/log/messages
> >> ....
> >> Jan 27 18:00:28 localhost kernel: usb 7-1: New USB device found,
> >> idVendor=2109, idProduct=0810
> >> Jan 27 18:00:28 localhost kernel: usb 7-1: New USB device strings:
> >> Mfr=1, Product=2, SerialNumber=0
> >> Jan 27 18:00:28 localhost kernel: usb 7-1: Product: 4-Port USB 3.0 Hub
> >> Jan 27 18:00:28 localhost kernel: usb 7-1: Manufacturer: VIA Labs, Inc.
> >> Jan 27 18:00:28 localhost kernel: usb 7-1: configuration #1 chosen from 1 choice
> >> Jan 27 18:00:28 localhost kernel: hub 7-1:1.0: USB hub found
> >> Jan 27 18:00:28 localhost kernel: hub 7-1:1.0: 4 ports detected
> >> ....
> >> Jan 28 21:32:02 localhost kernel: usb 7-1.1: new SuperSpeed USB device
> >> number 9 using xhci_hcd
> >> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: PCI INT A ->
> >> GSI 16 (level, low) -> IRQ 16
> >> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: xHCI Host Controller
> >> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: new USB bus
> >> registered, assigned bus number 6
> >> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: irq 16, io
> >> mem 0xdfe00000
> >> Jan 28 21:32:56 localhost kernel: usb usb6: Manufacturer: Linux
> >> 2.6.32-279.19.1.el6.i686 xhci_hcd
> >> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: xHCI Host Controller
> >> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: new USB bus
> >> registered, assigned bus number 7
> >> Jan 28 21:32:56 localhost kernel: usb usb7: Manufacturer: Linux
> >> 2.6.32-279.19.1.el6.i686 xhci_hcd
> >> Jan 28 21:32:56 localhost kernel: usb 7-1: new SuperSpeed USB device
> >> number 2 using xhci_hcd
> >> Jan 28 21:32:56 localhost kernel: usb 7-1.1: new SuperSpeed USB device
> >> number 3 using xhci_hcd
> >> Jan 28 21:32:56 localhost kernel: usb 7-1.2: new SuperSpeed USB device
> >> number 4 using xhci_hcd
> >> Jan 28 21:32:56 localhost kernel: usb 7-1.3: new SuperSpeed USB device
> >> number 5 using xhci_hcd
> >> Jan 28 21:32:56 localhost kernel: usb 7-1.4: new SuperSpeed USB device
> >> number 6 using xhci_hcd
> >
> >
> > --
> > You received this message because you are subscribed to the Google Groups "USB Mass Storage on Linux" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to usb-storage+unsubscribe@lists.one-eyed-alien.net.
> > To post to this group, send email to usb-storage@lists.one-eyed-alien.net.
> > Visit this group at http://groups.google.com/a/lists.one-eyed-alien.net/group/usb-storage/?hl=en.
> > For more options, visit https://groups.google.com/a/lists.one-eyed-alien.net/groups/opt_out.
> >
> >
>
>
>
> --
> Matthew Dharm
> Maintainer, USB Mass Storage driver for Linux
