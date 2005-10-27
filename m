From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: slow external firewire drive
Date: Thu, 27 Oct 2005 09:48:51 +0200
Message-ID: <43608663.7020103@s5r6.in-berlin.de>
References: <20051027015655.GC14010@toucan.gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:31450 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964980AbVJ0Hts (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 03:49:48 -0400
In-Reply-To: <20051027015655.GC14010@toucan.gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric Edgar <rocket@gentoo.org>, Matthew Wilcox <matthew@wil.cx>

Eric Edgar wrote:
>   I am having trouble with an external firewire drive.  I have a texas
>   instruments based card and a maxtor external enclosure.  Whenever I
>   try to do anything with this disk the iowait goes through the roof and
>   it can take half an hour or more to untar an 80mb file.  I am not sure
>   if its something with my computer or the card or the enclosure.  Any
>   help would be greatly appreciated.
> 
> 
> hci1394: $Rev: 1313 $ Ben Collins <bcollins@debian.org>
> PCI: Enabling device 0000:00:0c.0 (0014 -> 0016)
> PCI: Found IRQ 11 for device 0000:00:0c.0
> ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[11]  MMIO=[d9800000-d98007ff]  Max
>  Packet=[2048]
> sbp2: $Rev: 1306 $ Ben Collins <bcollins@debian.org>
> ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
> ieee1394: sbp2: Try serialize_io=0 for better performance

Like Matthew already mentioned, a "modprobe sbp2 serialize_io=0" before 
sbp2 is automatically loaded, or the line "options sbp2 serialize_io=0" 
in /etc/modprobe.conf may achieve better performance. However as far as 
I know, the performance gain is below variance of measurement with 
typical 1394a ("FireWire 400") disks. Only 1394b/S800 ("FireWire 800") 
disks show a noticable improved throughput with that option. But it is 
not an improvement by an order of magnitude. It may be something like 
30% better throughput with S800 devices.

> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>   Vendor: Maxtor    Model: 1394 storage      Rev: v1.3
>   Type:   Direct-Access-RBC                  ANSI SCSI revision: 04
> SCSI device sda: 156355584 512-byte hdwr sectors (80054 MB)
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> SCSI device sda: 156355584 512-byte hdwr sectors (80054 MB)
> sda: asking for cache data failed
> sda: assuming drive cache: write through
>  sda: sda1
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 14
> 
> 
> hdparm -tT /dev/sda
> 
> /dev/sda:
>  Timing cached reads:   644 MB in  2.01 seconds = 320.40 MB/sec
>  Timing buffered disk reads:    8 MB in  3.09 seconds =   2.59 MB/sec

This is really bad. 3.5" S400 disks on S400 host adapters show typically 
about 23 MB/s with hdparm, 2.5" disks also nearly as much.

At least we can rule out a filesystem related problem with that info.

> uname -a 
> 2.6.14-rc4
>   
> I dont seem to see any error messages ... just bad performance.

I did not hear of a serious performance regression with that kernel yet. 
I tested 2.6.14-rc3 and -rc5 myself but they should behave like -rc4.

Anyhow, if there are no error messages, one possible cause are 
recoverable transport errors at the FireWire bus. Perhaps a syslog with 
ieee1394 compiled with the "excessive debug output" option could provide 
clues. Note however that (a) such logs may become really huge, (b) the 
logging activity might actually mask some problems of the Heisenbug kind 
out, (c) these logs are no pleasure to read and I for one am typically 
slow to read and respond to such reports...

BTW, I have a no-name 1394b FireWire 800 card with TI chipset whith an 
obviously buggy PHY chip which causes extreme slow transfers, even 
slower than what you see. I need to force this card into 1394a 
arbitration mode and to optimize the gap count in order to bring that 
card up to speed. Both is not implemented directly in the 1394 drivers yet.

What is the manufacturer and model of the card and which link chip and 
PHY chip is it built on? (The PHY chip can only be found out by looking 
on the card, not by lspci and the like. lspci shows only the link chip.)
-- 
Stefan Richter
-=====-=-=-= =-=- ==-==
http://arcgraph.de/sr/
