From: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Subject: Re: Issue with mini-SaS to eSATA to USB 3.0 setup
Date: Thu, 21 Feb 2013 15:48:42 -0500
Message-ID: <5126882A.1060603@interlog.com>
References: <CAAfSSYhT+r07yQfok_BvKj_bTnCUv7nMX8Wafd-xjB1ejEZusQ@mail.gmail.com> <CAAfSSYj4ycBUVW3rVy1jrbJEY2hW_Ui88MyWdA5yGose80Vggw@mail.gmail.com> <20130221192646.GE27219@xanatos>
Reply-To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130221192646.GE27219@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Fabio David <fabiodavid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 13-02-21 02:26 PM, Sarah Sharp wrote:
> Cc-ing the SCSI and USB storage list.
>
> Folks, does the attached picture look like a sane setup?  I've never
> used mini-SaS to eSATA adapter before, let alone with four eSATA to USB
> 3.0 adapters.

Well SAS to eSATA is okay (works for me: LSI SAS9212-4i4e HBA
via a SATA to eSATA cable to a SATA disk caddy with an eSATA
port).

eSATA to USB 3.0 adapters sound pretty dodgy, especially when
no mention is made of UAS(P).

Doug Gilbert

> On Tue, Jan 29, 2013 at 12:56:02PM -0200, Fabio David wrote:
>> Hi Sarah,
>>
>> My name is Fabio David and I am from Brazil. I've seen your posts on
>> several forums and read articles about you. I really admire your work.
>>
>> Maybe you can help me. I'm trying to connect a PC running Centos 6.3
>> to a CRU dataport 4-bay storage device. This device only has a miniSaS
>> port.
>>
>> Here is my scenario:
>>
>> - DataCRU device with 4 hot-swapables bays.
>> http://www.cru-inc.com/slideshow.php?dir=//Digital-Cinema//&sel=5
>> - MiniSaS cable connects to the DataCRU device and on the other side
>> there are 4 eSata connectors
>>    http://www.elpeus.com/sas-mini-sas/external-mini-sas-cables/sff-8088-to-4-esata/3m-mini-sas-sff-8088-to-4-esata-cable/
>> - 4 eSata<->USB3.0 adaptors connected to each eSata connector
>> - Adaptors connected to a USB3.0 HUB
>> - USB3.0 hub connected to PC
>>
>> Everything works ok, I can mount/read the HDs, but sometimes the
>> system does not detect when a hard drive is inserted/removed from a
>> DataCru bay. No events are generated, nothing appears in
>> /proc/partitions nor udev
>> is called to apply my rules.
>
> Do you lose only hard drive insertion events, or do you lose remove
> events as well?
>
> For example, what happens when you do this:
>
> 1. Unplug the eSATA to USB adapters from the USB 3.0 hub.
> 2. Insert a hard drive into the bay.
> 3. Connect the eSATA to USB adapter to the USB 3.0 hub.
> 4. Wait for hard drive detection, then hot-remove the drive from the
> bay.
>
>> However, everything works fine when connected directly to PC's USB
>> port. Please look at the attached picture.
>
> It looks like you're only attaching one eSATA to USB adapter to the
> roothub.  Do you only have one USB 3.0 port on the host, or can you try
> plugging in multiple eSATA to USB adapters into the roothub?
>
> Does the setup work when only one eSATA to USB adapter is plugged into
> the USB 3.0 hub?
>
>> Do you have any suggestions?
>
> A couple possible root causes come to mind:
>
> 1. Perhaps the USB 3.0 hub is interfering with communication to your
> eSATA to USB 3.0 adapters.
>
> 2. Maybe USB device suspend is to blame.  Do you have USB device suspend
> enabled for the eSATA to USB adapters?
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
> Sarah Sharp
>
>> ===================================================================
>>
>> lsusb returns
>>
>> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 001 Device 002: ID 13d3:3323 IMC Networks
>> Bus 001 Device 009: ID 2109:3431  <----------------------------  HUB 3.0
>> Bus 006 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Bus 007 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
>> Bus 007 Device 040: ID 2109:0810  <----------------------------  HUB 3.0
>> Bus 007 Device 041: ID 1234:5678 Brain Actuated Technologies
>> Bus 007 Device 042: ID 1234:5678 Brain Actuated Technologies
>> Bus 007 Device 043: ID 1234:5678 Brain Actuated Technologies
>> Bus 007 Device 044: ID 1234:5678 Brain Actuated Technologies
>>
>> /var/log/messages
>> ....
>> Jan 27 18:00:28 localhost kernel: usb 7-1: New USB device found,
>> idVendor=2109, idProduct=0810
>> Jan 27 18:00:28 localhost kernel: usb 7-1: New USB device strings:
>> Mfr=1, Product=2, SerialNumber=0
>> Jan 27 18:00:28 localhost kernel: usb 7-1: Product: 4-Port USB 3.0 Hub
>> Jan 27 18:00:28 localhost kernel: usb 7-1: Manufacturer: VIA Labs, Inc.
>> Jan 27 18:00:28 localhost kernel: usb 7-1: configuration #1 chosen from 1 choice
>> Jan 27 18:00:28 localhost kernel: hub 7-1:1.0: USB hub found
>> Jan 27 18:00:28 localhost kernel: hub 7-1:1.0: 4 ports detected
>> ....
>> Jan 28 21:32:02 localhost kernel: usb 7-1.1: new SuperSpeed USB device
>> number 9 using xhci_hcd
>> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: PCI INT A ->
>> GSI 16 (level, low) -> IRQ 16
>> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: xHCI Host Controller
>> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: new USB bus
>> registered, assigned bus number 6
>> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: irq 16, io
>> mem 0xdfe00000
>> Jan 28 21:32:56 localhost kernel: usb usb6: Manufacturer: Linux
>> 2.6.32-279.19.1.el6.i686 xhci_hcd
>> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: xHCI Host Controller
>> Jan 28 21:32:56 localhost kernel: xhci_hcd 0000:01:00.0: new USB bus
>> registered, assigned bus number 7
>> Jan 28 21:32:56 localhost kernel: usb usb7: Manufacturer: Linux
>> 2.6.32-279.19.1.el6.i686 xhci_hcd
>> Jan 28 21:32:56 localhost kernel: usb 7-1: new SuperSpeed USB device
>> number 2 using xhci_hcd
>> Jan 28 21:32:56 localhost kernel: usb 7-1.1: new SuperSpeed USB device
>> number 3 using xhci_hcd
>> Jan 28 21:32:56 localhost kernel: usb 7-1.2: new SuperSpeed USB device
>> number 4 using xhci_hcd
>> Jan 28 21:32:56 localhost kernel: usb 7-1.3: new SuperSpeed USB device
>> number 5 using xhci_hcd
>> Jan 28 21:32:56 localhost kernel: usb 7-1.4: new SuperSpeed USB device
>> number 6 using xhci_hcd
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
