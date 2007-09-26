From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: /dev/sda with 8 byte offset
Date: Wed, 26 Sep 2007 22:55:11 +0200
Message-ID: <46FAC72F.5020304@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.0709262121040.17048@valhalla.fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0709262121040.17048@valhalla.fs.tum.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-user-bounces@lists.sourceforge.net
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: Stefan Rutzinger <rutzi@fs.tum.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(Adding Cc: linux-scsi)

Stefan Rutzinger wrote:
> I experience a very weird offset in the data from my FW disk. It worked 
> well last time i used it, which is about half a year ago. Unfortunately i 
> can't tell what exactly changed in the meanwhile, i continued updating 
> debian testing an think (but am not sure) changed the kernel. However, 
> this seems to be a real bug which should not be there anyway.
> 
> So, the disk is a USB / firewire disk. It still works fine with USB in 
> linux and with USB + firewire in Win XP. So the hardware is certainly 
> still fine.
> 
> But with firewire and linux, there is this problem:
> 
> It't still detected with correct disk geometry and /dev/sda and /dev/sda1 
> are recognised. But fdisk -l /dev/sda fails: "Disk /dev/sda doesn't 
> contain a valid partition table"
> 
> I dd'ed the mbr to a file, once when connected by USB and once when 
> connected to Firewire and found out with cmp:
> 
> The data in /dev/sda and /dev/sda1 are shifted by an offset of 8 byte in 
> the firewire case. I.e. there are some additional 8 byte at the beginning 
> of /dev/sda and /dev/sda1 which should not be there. Have a look at the 
> cmp output below. Of course fdisk fails then.

Strange.  I haven't heard of this before.  From which vendor and model
is the device, and do you know which chip is on its IDE bridge board?

Did you ever install new firmware on the device?

> Who can help out?
> 
> 
> Here' some debugging data:
> 
> I tried debian pre-compiled kernel 2.6.15-1-686-smp and 2.6.21-2-686.
> 
> stefaniello:~# cmp -bln16 usb-sda1 ieee-sda1
>   1 353 M-k   40       -
>   2 130 X    123 S      |
>   3 220 M-^P 131 Y      |
>   4 115 M    123 S      |
>   5 123 S      0 ^@     |
>   6 127 W      0 ^@     |
>   7 111 I    125 U      |
>   8 116 N    252 M-*    |
>   9  64 4    353 M-k  -- -> 8 byte offset !
> 10  56 .    130 X
> 11  61 1    220 M-^P
> 12   0 ^@   115 M
> 13   2 ^B   123 S
> 14 100 @    127 W
> 15  46 &    111 I
> 16   0 ^@   116 N
> 
> USB connected:
> stefaniello:~# tail /var/log/messages
> Sep 20 19:30:47 stefaniello kernel: usb 1-1: new full speed USB device using uhci_hcd and address 2
> Sep 20 19:30:47 stefaniello kernel: scsi0 : SCSI emulation for USB Mass Storage devices
> Sep 20 19:30:52 stefaniello kernel:   Vendor: WDC WD20  Model: 00JB-00GVA0 Rev: 08.0
> Sep 20 19:30:52 stefaniello kernel:   Type:   Direct-Access ANSI SCSI revision: 00
> Sep 20 19:30:52 stefaniello kernel: SCSI device sda: 390721969 512-byte hdwr sectors (200050 MB)
> Sep 20 19:30:52 stefaniello kernel: SCSI device sda: 390721969 512-byte hdwr sectors (200050 MB)
> Sep 20 19:30:52 stefaniello kernel:  sda: sda1
> Sep 20 19:30:52 stefaniello kernel: sd 0:0:0:0: Attached scsi disk sda
> Sep 20 19:30:53 stefaniello kernel: sda: Current: sense key: No Sense
> Sep 20 19:30:53 stefaniello kernel:     Additional sense: No additional sense information
> 
> stefaniello:~# fdisk -l /dev/sda
> Disk /dev/sda: 200.0 GB, 200049648128 bytes
> 255 heads, 63 sectors/track, 24321 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1       24321   195358401    b  W95 FAT32
> 
> 
> ieee1394 connected:
> 
> stefaniello:~# tail -f /var/log/messages
> Sep 20 19:42:04 stefaniello kernel: scsi1 : SCSI emulation for IEEE-1394 SBP-2 Devices

(This was obviously obtained from Debian's 2.6.15.)

> Sep 20 19:42:05 stefaniello kernel: ieee1394: sbp2: Logged into SBP-2 device
> Sep 20 19:42:05 stefaniello kernel:   Vendor: WDC WD20  Model: 00JB-00GVA0 Rev:
> Sep 20 19:42:05 stefaniello kernel:   Type:   Direct-Access-RBC ANSI SCSI revision: 04
> Sep 20 19:42:05 stefaniello kernel: SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
> Sep 20 19:42:05 stefaniello kernel: SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
> Sep 20 19:42:05 stefaniello kernel:  sda: sda1
> Sep 20 19:42:05 stefaniello kernel: sd 1:0:0:0: Attached scsi disk sda
> 
> stefaniello:~# fdisk -l /dev/sda
> Disk /dev/sda: 200.0 GB, 200049647616 bytes
> 255 heads, 63 sectors/track, 24321 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
> Disk /dev/sda doesn't contain a valid partition table

I don't know what could cause this.  The sbp2 driver did a lot of SCSI
command conversions between the RBC and SBC command sets in older
kernels, and this was gradually pulled out of sbp2 because the sd driver
already handled RBC properly at some point.  In Linux 2.6.15, sbp2 had
still all this conversion code but it was AFAIK already deadwood.

However I don't know if there could really be differences in how very
old kernels sent SCSI commands which could cause the device to return
data with an offset.

Perhaps the problem is not in what data the device returns when sd reads
from it, but in where the data is written into buffers.  I.e. if going
through sbp2, the data might be written 8 bytes behind the actual start
of the data buffer.  I will check in the SBP-2 spec if there is anything
that could be mistaken about the buffer address.

By the way, in addition to the 8 bytes offset which you found, there is
also a difference in the reported disk size.  The USB firmware says
390721969 sectors, the FireWire firmware says 390721968 sectors.  The
USB firmware's value seems to be the wrong one.
-- 
Stefan Richter
-=====-=-=== =--= ==-=-
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
