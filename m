From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: FW drive has incorrect size
Date: Tue, 10 Jan 2006 20:49:53 +0100
Message-ID: <43C40FE1.7020401@s5r6.in-berlin.de>
References: <DC0427D0-BD6B-4E50-B4D0-701A22E5CFD6@n5faz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47577 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751131AbWAJTuf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 14:50:35 -0500
In-Reply-To: <DC0427D0-BD6B-4E50-B4D0-701A22E5CFD6@n5faz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: paul launspach <paul@n5faz.org>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

(I added the linux-scsi mailinglist as recipient because it is read by 
people who might know more about the matter.)

paul launspach wrote to linux1394-user:
> 
> having problems with an external fw/usb drive. it works fine on usb,  
> but wont mount on fw.
> have another fw drive that works fine.
> 
> Using Debian Linux 2.6.14-2-686-smp kernel,
> VIA Mini-ITX CL1000 mainboard,
> 0000:00:14.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61) host  
> adapter,
> OWC FW400/USB2 enclosure with Oxford WF911PLUS bridge,
> and Western Digital WD800 drive.
> 
> when pluged into usb i get:
> 
> usb 4-1: new high speed USB device using ehci_hcd and address 2
> Initializing USB Mass Storage driver...
> scsi3 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> usbcore: registered new driver usb-storage
> USB Mass Storage support registered.
>   Vendor: WDC WD80  Model: 0BB-00CAA1        Rev: 17.0
>   Type:   Direct-Access                      ANSI SCSI revision: 00
> SCSI device sda: 156301489 512-byte hdwr sectors (80026 MB)
> sda: assuming drive cache: write through
> SCSI device sda: 156301489 512-byte hdwr sectors (80026 MB)
> sda: assuming drive cache: write through
>  sda: sda1
> Attached scsi disk sda at scsi3, channel 0, id 0, lun 0
> usb-storage: device scan complete
> sda: Current: sense key: No Sense
>     Additional sense: No additional sense information
> 
> and the drive mounts and access with no problems.
> 
> but on FW:
> 
> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0001d202e09c0819]
> ieee1394: Node changed: 0-00:1023 -> 0-01:1023
> scsi1 : SCSI emulation for IEEE-1394 SBP-2 Devices
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>   Vendor: WDC WD80  Model: 0BB-00CAA1        Rev: 17.0
>   Type:   Direct-Access-RBC                  ANSI SCSI revision: 04
> SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> sda:<6>sda: Current: sense key: No Sense
>     Additional sense: No additional sense information
> sda1
> Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
> 
> EXT2-fs error (device sda1): ext2_check_descriptors: Block bitmap for  
> group 52 not in group (block 3086152523)!
> EXT2-fs: group descriptors corrupted!
> 
> The "... Current: sense key: No Sense ..." message is repeated about  10 
> times.
> 
> and the drive wont mount and e2fsck reports tons of errors.
> 
> on FW the drive is reported as 1 sector smaller.
> 
> not sure if this is a drive, bridge, host controller, or kernel issue.
> can someone point me in the right direction?

It looks like a problem at the SCSI command set level, i.e. 
misinterpretation of commands given to the device or of status returned 
from the device. (OTOH, problems at the physical level of the FireWire 
bus could _perhaps_ lead to "Current: sense key: No Sense" messages but 
I am not sure of that.)

See how the device type is reported differently via usb-storage and sbp2 
("Direct-Access" versus "Direct-Access-RBC", RBC meaning to use a 
reduced command set). I don't know if this comes from extra conversions 
done differently in usb-storage and sbp2 or if the device actually 
represents itself differently at the interfaces.

Sbp2 in Linux 2.6.14 does still a lot of command set conversions, or at 
least is supposed to do. Needlessly though because there is working RBC 
support in Linux' SCSI command set drivers, i.e. in sd_mod. Sbp2 has 
been converted to omit all command set conversions and let sd_mod handle 
it; alas the according patch was not merged to mainline for some reasons 
for a long time. It went into Linus' tree just a couple of days ago.

Perhaps you have more luck if you apply the according patch to sbp2 and 
recompile the kernel modules. You can get the patch from Linus' git tree:
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=365c786f0be44ee92e018773cb0bc4b19080b6aa
or from my site, of which I am sure that the patch can actually be 
applied to Linux 2.6.14:
http://me.in-berlin.de/~s5r6/linux1394/merged/available_in_2.6.16/02-ieee1394-remove-sbp2's-TYPE_RBC-and-10byte-handling.patch

I actually used the original 1394 drivers of 2.6.14 only briefly and 
therefore don't know exactly what the status of these drivers is.

BTW, does your OWC enclosure look like this one? 
http://macpower.com.tw/products/hdd3/icecube/ic_400plus
Current revisions of this enclosure are built with Prolific bridge chip, 
not an Oxford chip. Many Prolific based products come with buggy 
firmwares. I own a MacPower 5.25" enclosure which uses a Prolific based 
bridge board. It works very well but I am using it with a DVD-RW, not a 
HDD, i.e. with a different command set than that for harddisks.
-- 
Stefan Richter
-=====-=-==- ---= -=-=-
http://arcgraph.de/sr/
