From: Stefan Rutzinger <rutzi@fs.tum.de>
Subject: Re: /dev/sda with 8 byte offset
Date: Thu, 27 Sep 2007 21:48:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709271916470.23129@valhalla.fs.tum.de>
References: <Pine.LNX.4.64.0709262121040.17048@valhalla.fs.tum.de>
	<46FAC72F.5020304@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
In-Reply-To: <46FAC72F.5020304@s5r6.in-berlin.de>
Content-ID: <Pine.LNX.4.64.0709271917041.23129@valhalla.fs.tum.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-user-bounces@lists.sourceforge.net
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: linux1394-user@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 26 Sep 2007, Stefan Richter wrote:

> (Adding Cc: linux-scsi)
>
> Stefan Rutzinger wrote:
>> I experience a very weird offset in the data from my FW disk. It worked
>> well last time i used it, which is about half a year ago. Unfortunately i
>> can't tell what exactly changed in the meanwhile, i continued updating
>> debian testing an think (but am not sure) changed the kernel. However,
>> this seems to be a real bug which should not be there anyway.
>>
>> So, the disk is a USB / firewire disk. It still works fine with USB in
>> linux and with USB + firewire in Win XP. So the hardware is certainly
>> still fine.
>>
>> But with firewire and linux, there is this problem:
>>
>> It't still detected with correct disk geometry and /dev/sda and /dev/sda1
>> are recognised. But fdisk -l /dev/sda fails: "Disk /dev/sda doesn't
>> contain a valid partition table"
>>
>> I dd'ed the mbr to a file, once when connected by USB and once when
>> connected to Firewire and found out with cmp:
>>
>> The data in /dev/sda and /dev/sda1 are shifted by an offset of 8 byte in
>> the firewire case. I.e. there are some additional 8 byte at the beginning
>> of /dev/sda and /dev/sda1 which should not be there. Have a look at the
>> cmp output below. Of course fdisk fails then.
>
> Strange.  I haven't heard of this before.  From which vendor and model
> is the device, and do you know which chip is on its IDE bridge board?
>
> Did you ever install new firmware on the device?
>
>> Who can help out?
>>
>>
>> Here' some debugging data:
>>
>> I tried debian pre-compiled kernel 2.6.15-1-686-smp and 2.6.21-2-686.
>>
>> stefaniello:~# cmp -bln16 usb-sda1 ieee-sda1
>>   1 353 M-k   40       -
>>   2 130 X    123 S      |
>>   3 220 M-^P 131 Y      |
>>   4 115 M    123 S      |
>>   5 123 S      0 ^@     |
>>   6 127 W      0 ^@     |
>>   7 111 I    125 U      |
>>   8 116 N    252 M-*    |
>>   9  64 4    353 M-k  -- -> 8 byte offset !
>> 10  56 .    130 X
>> 11  61 1    220 M-^P
>> 12   0 ^@   115 M
>> 13   2 ^B   123 S
>> 14 100 @    127 W
>> 15  46 &    111 I
>> 16   0 ^@   116 N
>>
>> USB connected:
>> stefaniello:~# tail /var/log/messages
>> Sep 20 19:30:47 stefaniello kernel: usb 1-1: new full speed USB device using uhci_hcd and address 2
>> Sep 20 19:30:47 stefaniello kernel: scsi0 : SCSI emulation for USB Mass Storage devices
>> Sep 20 19:30:52 stefaniello kernel:   Vendor: WDC WD20  Model: 00JB-00GVA0 Rev: 08.0
>> Sep 20 19:30:52 stefaniello kernel:   Type:   Direct-Access ANSI SCSI revision: 00
>> Sep 20 19:30:52 stefaniello kernel: SCSI device sda: 390721969 512-byte hdwr sectors (200050 MB)
>> Sep 20 19:30:52 stefaniello kernel: SCSI device sda: 390721969 512-byte hdwr sectors (200050 MB)
>> Sep 20 19:30:52 stefaniello kernel:  sda: sda1
>> Sep 20 19:30:52 stefaniello kernel: sd 0:0:0:0: Attached scsi disk sda
>> Sep 20 19:30:53 stefaniello kernel: sda: Current: sense key: No Sense
>> Sep 20 19:30:53 stefaniello kernel:     Additional sense: No additional sense information
>>
>> stefaniello:~# fdisk -l /dev/sda
>> Disk /dev/sda: 200.0 GB, 200049648128 bytes
>> 255 heads, 63 sectors/track, 24321 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>>
>>     Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1               1       24321   195358401    b  W95 FAT32
>>
>>
>> ieee1394 connected:
>>
>> stefaniello:~# tail -f /var/log/messages
>> Sep 20 19:42:04 stefaniello kernel: scsi1 : SCSI emulation for IEEE-1394 SBP-2 Devices
>
> (This was obviously obtained from Debian's 2.6.15.)
>
>> Sep 20 19:42:05 stefaniello kernel: ieee1394: sbp2: Logged into SBP-2 device
>> Sep 20 19:42:05 stefaniello kernel:   Vendor: WDC WD20  Model: 00JB-00GVA0 Rev:
>> Sep 20 19:42:05 stefaniello kernel:   Type:   Direct-Access-RBC ANSI SCSI revision: 04
>> Sep 20 19:42:05 stefaniello kernel: SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
>> Sep 20 19:42:05 stefaniello kernel: SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
>> Sep 20 19:42:05 stefaniello kernel:  sda: sda1
>> Sep 20 19:42:05 stefaniello kernel: sd 1:0:0:0: Attached scsi disk sda
>>
>> stefaniello:~# fdisk -l /dev/sda
>> Disk /dev/sda: 200.0 GB, 200049647616 bytes
>> 255 heads, 63 sectors/track, 24321 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>>
>> Disk /dev/sda doesn't contain a valid partition table
>
> I don't know what could cause this.  The sbp2 driver did a lot of SCSI
> command conversions between the RBC and SBC command sets in older
> kernels, and this was gradually pulled out of sbp2 because the sd driver
> already handled RBC properly at some point.  In Linux 2.6.15, sbp2 had
> still all this conversion code but it was AFAIK already deadwood.
>
> However I don't know if there could really be differences in how very
> old kernels sent SCSI commands which could cause the device to return
> data with an offset.
>
> Perhaps the problem is not in what data the device returns when sd reads
> from it, but in where the data is written into buffers.  I.e. if going
> through sbp2, the data might be written 8 bytes behind the actual start
> of the data buffer.  I will check in the SBP-2 spec if there is anything
> that could be mistaken about the buffer address.
>
> By the way, in addition to the 8 bytes offset which you found, there is
> also a difference in the reported disk size.  The USB firmware says
> 390721969 sectors, the FireWire firmware says 390721968 sectors.  The
> USB firmware's value seems to be the wrong one.

Yes, i saw that as well. But one after the other. I'll send some more 
logging info to make things complete. Take a look at the dmesg, 
there's some failure in cache recognition. Hope it helps:

The disk worked well with 2.4 kernels. I can't track down the 2.6 kernel 
histoy perfectly, but according to a memo, 2.6.15 was installed last year 
November, while the disk was still fine in march. Seems reasonable that I 
made a backup in march before another kernel upgrade without a full 
hardware test afterwards.

And no, firmware was never touched or updated.

stefaniello:~# cat /proc/version
Linux version 2.6.15-1-686-smp (Debian 2.6.15-8) (waldi@debian.org) (gcc 
version 4.0.3 20060212 (prerelease) (Debian 4.0.2-9)) #2 SMP Mon Mar 6 
15:34:50 UTC 2006

stefaniello:~# lspci (excerpt)
00:00.0 Host bridge: Intel Corporation 82845 845 (Brookdale) Chipset Host 
Bridge (rev 04)
02:01.2 FireWire (IEEE 1394): Texas Instruments PCI4451 IEEE-1394 
Controller

stefaniello:~# lspci -n (excerpt)
00:00.0 0600: 8086:1a30 (rev 04)
02:01.2 0c00: 104c:8027

stefaniello:~# find /lib /usr/lib -name "*libraw*"
/usr/lib/libraw1394.so.8.1.1
/usr/lib/libraw1394.so.8

stefaniello:/var/log# lsmod (excerpt)
Module                  Size  Used by
sbp2                   21732  0
sd_mod                 17536  0
usb_storage            65600  0
scsi_mod              127592  3 sbp2,sd_mod,usb_storage
ieee80211_crypt         5952  1 hostap
pci_hotplug            25628  1 shpchp
eth1394                19336  0
ide_core              115664  6 
usb_storage,ide_generic,ide_cd,ide_disk,piix,generic
uhci_hcd               29360  0
usbcore               116196  3 usb_storage,uhci_hcd
ohci1394               31252  0
ieee1394               89848  3 sbp2,eth1394,ohci1394

As you can see, ohci1394 is used instead of pcilynx. This one doesn't seem 
to do anything if loaded and sbp2 won't see any storage device at all.

stefaniello:~# dmesg (excerpt)
ieee1394: Initialized config rom entry `ip1394'
ohci1394: $Rev: 1313 $ Ben Collins <bcollins@debian.org>
ACPI: PCI Interrupt 0000:02:01.2[A] -> Link [LNKD] -> GSI 11 (level, low) 
-> IRQ 11
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[11] 
MMIO=[f8fff000-f8fff7ff]  Max Packet=[2048]
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[484fc000221cb010]
eth1394: $Rev: 1312 $ Ben Collins <bcollins@debian.org>
eth1394: eth1: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
sbp2: $Rev: 1306 $ Ben Collins <bcollins@debian.org>
ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
ieee1394: sbp2: Try serialize_io=0 for better performance
ohci1394: fw-host0: SelfID received, but NodeID invalid (probably new bus 
reset occurred): 0000FFC0
ieee1394: Error parsing configrom for node 0-00:1023
ieee1394: Node changed: 0-00:1023 -> 0-01:1023
ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0030e00e82010087]
scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
   Vendor: WDC WD20  Model: 00JB-00GVA0       Rev:
   Type:   Direct-Access-RBC                  ANSI SCSI revision: 04
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
  sda: sda1
sd 0:0:0:0: Attached scsi disk sda
ieee1394: sbp2: Logged out of SBP-2 device

stefaniello:/dev/disk# hwinfo --disk
19: SCSI 500.0: 10600 Disk
   [Created at block.222]
   UDI: /org/freedesktop/Hal/devices/storage_serial_0030e00e82010087_0_0
   Unique ID: _q_W.vhEfakOr9HF
   Parent ID: _p6J.FYVVb9QLEAF
   SysFS ID: /block/sda
   SysFS BusID: 5:0:0:0
   SysFS Device Link: 
/devices/pci0000:00/0000:00:1e.0/0000:02:01.2/fw-host0/0030e00e82010087/0030e00e82010087-0/host5/target5:0:0/5:0:0:0
   Hardware Class: disk
   Model: "WDC WD20 00JB-00GVA0"
   Vendor: "WDC WD20"
   Device: "00JB-00GVA0"
   Driver: "sbp2", "sd"
   Device File: /dev/sda (/dev/sg0)
   Device Files: /dev/sda, /dev/disk/by-id/ieee1394-0030e00e82010087:0:0, 
/dev/disk/by-path/pci-0000:02:01.2-ieee1394-0x0030e00e82010087:0:0
   Device Number: block 8:0-8:15 (char 21:0)
   Features: Hotpluggable
   Geometry (Logical): CHS 24321/255/63
   Size: 390721968 sectors a 512 bytes
   Config Status: cfg=new, avail=yes, need=no, active=unknown
   Attached to: #15 (FireWire (IEEE 1394))

That's all info i can imagine at the moment. And with all information put 
together now, we might probably stop full-quoting at this point.

cheers Stefan

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
