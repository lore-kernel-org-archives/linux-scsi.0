From: paul launspach <paul@n5faz.org>
Subject: Re: FW drive has incorrect size
Date: Sat, 14 Jan 2006 08:49:00 -0700
Message-ID: <D14749C1-E99A-454B-A36D-40B1E63794E0@n5faz.org>
References: <DC0427D0-BD6B-4E50-B4D0-701A22E5CFD6@n5faz.org> <43C40FE1.7020401@s5r6.in-berlin.de>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-209-30-135-237.dsl.elpstx.swbell.net ([209.30.135.237]:28938
	"EHLO websrv1.home.n5faz.org") by vger.kernel.org with ESMTP
	id S932161AbWANPnB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 10:43:01 -0500
In-Reply-To: <43C40FE1.7020401@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org


On Jan 10, 2006, at 12:49 PM, Stefan Richter wrote:

> (I added the linux-scsi mailinglist as recipient because it is read  
> by people who might know more about the matter.)
>
> paul launspach wrote to linux1394-user:
>> having problems with an external fw/usb drive. it works fine on  
>> usb,  but wont mount on fw.
>> have another fw drive that works fine.
>> Using Debian Linux 2.6.14-2-686-smp kernel,
>> VIA Mini-ITX CL1000 mainboard,
>> 0000:00:14.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61)  
>> host  adapter,
>> OWC FW400/USB2 enclosure with Oxford WF911PLUS bridge,
>> and Western Digital WD800 drive.
>> when pluged into usb i get:
>> usb 4-1: new high speed USB device using ehci_hcd and address 2
>> Initializing USB Mass Storage driver...
>> scsi3 : SCSI emulation for USB Mass Storage devices
>> usb-storage: device found at 2
>> usb-storage: waiting for device to settle before scanning
>> usbcore: registered new driver usb-storage
>> USB Mass Storage support registered.
>>   Vendor: WDC WD80  Model: 0BB-00CAA1        Rev: 17.0
>>   Type:   Direct-Access                      ANSI SCSI revision: 00
>> SCSI device sda: 156301489 512-byte hdwr sectors (80026 MB)
>> sda: assuming drive cache: write through
>> SCSI device sda: 156301489 512-byte hdwr sectors (80026 MB)
>> sda: assuming drive cache: write through
>>  sda: sda1
>> Attached scsi disk sda at scsi3, channel 0, id 0, lun 0
>> usb-storage: device scan complete
>> sda: Current: sense key: No Sense
>>     Additional sense: No additional sense information
>> and the drive mounts and access with no problems.
>> but on FW:
>> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0001d202e09c0819]
>> ieee1394: Node changed: 0-00:1023 -> 0-01:1023
>> scsi1 : SCSI emulation for IEEE-1394 SBP-2 Devices
>> ieee1394: sbp2: Logged into SBP-2 device
>> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>>   Vendor: WDC WD80  Model: 0BB-00CAA1        Rev: 17.0
>>   Type:   Direct-Access-RBC                  ANSI SCSI revision: 04
>> SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
>> sda: asking for cache data failed
>> sda: assuming drive cache: write through
>> SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
>> sda: asking for cache data failed
>> sda: assuming drive cache: write through
>> sda:<6>sda: Current: sense key: No Sense
>>     Additional sense: No additional sense information
>> sda1
>> Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
>> EXT2-fs error (device sda1): ext2_check_descriptors: Block bitmap  
>> for  group 52 not in group (block 3086152523)!
>> EXT2-fs: group descriptors corrupted!
>> The "... Current: sense key: No Sense ..." message is repeated  
>> about  10 times.
>> and the drive wont mount and e2fsck reports tons of errors.
>> on FW the drive is reported as 1 sector smaller.
>> not sure if this is a drive, bridge, host controller, or kernel  
>> issue.
>> can someone point me in the right direction?
>
> It looks like a problem at the SCSI command set level, i.e.  
> misinterpretation of commands given to the device or of status  
> returned from the device. (OTOH, problems at the physical level of  
> the FireWire bus could _perhaps_ lead to "Current: sense key: No  
> Sense" messages but I am not sure of that.)
>
> See how the device type is reported differently via usb-storage and  
> sbp2 ("Direct-Access" versus "Direct-Access-RBC", RBC meaning to  
> use a reduced command set). I don't know if this comes from extra  
> conversions done differently in usb-storage and sbp2 or if the  
> device actually represents itself differently at the interfaces.
>
> Sbp2 in Linux 2.6.14 does still a lot of command set conversions,  
> or at least is supposed to do. Needlessly though because there is  
> working RBC support in Linux' SCSI command set drivers, i.e. in  
> sd_mod. Sbp2 has been converted to omit all command set conversions  
> and let sd_mod handle it; alas the according patch was not merged  
> to mainline for some reasons for a long time. It went into Linus'  
> tree just a couple of days ago.
>
> Perhaps you have more luck if you apply the according patch to sbp2  
> and recompile the kernel modules. You can get the patch from Linus'  
> git tree:
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/ 
> linux-2.6.git;a=commitdiff_plain;h=365c786f0be44ee92e018773cb0bc4b1908 
> 0b6aa
> or from my site, of which I am sure that the patch can actually be  
> applied to Linux 2.6.14:
> http://me.in-berlin.de/~s5r6/linux1394/merged/ 
> available_in_2.6.16/02-ieee1394-remove-sbp2's-TYPE_RBC-and-10byte- 
> handling.patch
>
> I actually used the original 1394 drivers of 2.6.14 only briefly  
> and therefore don't know exactly what the status of these drivers is.
>
> BTW, does your OWC enclosure look like this one? http:// 
> macpower.com.tw/products/hdd3/icecube/ic_400plus
> Current revisions of this enclosure are built with Prolific bridge  
> chip, not an Oxford chip. Many Prolific based products come with  
> buggy firmwares. I own a MacPower 5.25" enclosure which uses a  
> Prolific based bridge board. It works very well but I am using it  
> with a DVD-RW, not a HDD, i.e. with a different command set than  
> that for harddisks.
> -- 
> Stefan Richter
> -=====-=-==- ---= -=-=-
> http://arcgraph.de/sr/

hi stefan et all,

i tried another host adapter, this one using a via chip. i no longer  
get any of the Current sense key messages and all drives i try will  
mount fine but
if i do any large reads or writes to the drive i get a kernel panic.  
no fun as this is a production server which takes about a half hour  
to reboot after
these crashes.

here is dmesg for the new card:

ieee1394: Initialized config rom entry `ip1394'
ohci1394: $Rev: 1313 $ Ben Collins <bcollins@debian.org>
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LNKB] -> GSI 11 (level,  
low) -> IRQ 11
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[11]  MMIO=[ea003000- 
ea0037ff]  Max Packet=[2]
ohci1394: fw-host0: Serial EEPROM has suspicious values, attempting  
to setting max_packet_size to 512 bytes
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[4d5a900003000000]
eth1394: $Rev: 1312 $ Ben Collins <bcollins@debian.org>
eth1394: eth2: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)

and lspci:

0000:00:14.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394  
Host Controller (rev 46) (prog-if 10 [OHCI])
         Flags: bus master, medium devsel, latency 32, IRQ 11
         Memory at ea003000 (32-bit, non-prefetchable) [size=2K]
         I/O ports at ec00 [size=128]
         Capabilities: [50] Power Management version 2

i have not tried the patch yet.

was going to try testing on another box but am having trouble getting  
to it upgrade from 2.4.27 to 2.6.14.  will try again today...

the case looks identical the macpower 400plus,  my mac even  
identifies it as a macpower device. one chip is clearly marked as
an oxford semi FW911PLUS-TQ-A, and the USB chip is a PL-2507.

ill have more when i get my other box going..

thanks again
paul at n5faz dot org

