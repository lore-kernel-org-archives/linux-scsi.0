From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB HD: No Sense / Info fld=0x0 and read corruption
Date: Wed, 24 Dec 2008 13:02:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812241253300.27059-100000@netrider.rowland.org>
References: <49523B7C.5010600@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3907 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750946AbYLXSDC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Dec 2008 13:03:02 -0500
In-Reply-To: <49523B7C.5010600@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ludovico Cavedon <ludovico.cavedon@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 24 Dec 2008, Ludovico Cavedon wrote:

> Hi,
> I have a problem with a USB hard drive.
> 
> The problem starts to happen after some random time of operation; the
> time may range from 1 minute up to one hour...
> 
> The first symptom are these messages in the kernel log.
> ---------------
> sd 5:0:0:0: [sdb] Sense Key : No Sense [current]
> Info fld=0x0
> 5:0:0:0: [sdb] Add. Sense: No additional sense information
> ---------------
> The may appear only once or multiple times.
> 
> Sometime they are not associated with other errors, sometimes I start to
> see filesystem corrpution:
> ---------------
> attempt to access beyond end of device
> sdb8: rw=0, want=15514452856, limit=207045657
> ---------------
> 
> If I unmount the device and replug it, I am able to read the same data
> without any problem.
> I suspect that some read corruption is happening. However I have *never*
> seen I/O error reported!
> 
> Here is the usbmon log:
> http://pastebin.com/f4e1afeb1
> 
> There are some successful read operation, than the read operation
> 31 = 55534243 8f150000 00100100 80000a28 0022ebd0 a8000088 00000000 000000
> 
> whose command completion status ends with "01". The subsequent REQUEST
> SENSE, however is empty.
> 
> What may be happening here?
> My situation looks different from
> http://thread.gmane.org/gmane.linux.kernel/747753
> -there is an additional "Info fld=0x0" line in the log

That's because your "empty" sense information has the Valid flag set.

> -there log messages are not always looping
> -it is happening also with 2.6.28-rc8 (which should have the patch, right?)

What patch?  Do you mean the patch at the end of that email thread?  It 
affects only Argosy USB drives, not your Western Digital.

> I am not able to understand if this is HD problem or a kernel problem. I

Partly both.  The HD (or more likely, its USB interface) is responsible 
for sending those unnecessary empty sense records.  The kernel is 
responsible for not reporting an I/O error (assuming an error actually 
did take place).

> am able to replicate it:
> -2.6.28-rc8 vanilla kernel
> -2.6.27 ubuntu (intrepid) kernel

2.6.27 doesn't go into an endless loop?  This may indicate that 
eventually the drive stops sending the Check Condition status.

> -2.6.25 ubuntu (hardy) kernel
> -on two different computers
> -with different USB cables (so it not a cable problem)
> 
> However, I have never got errors reported by Windows (dual boot on the
> same machine).
> 
> The HD driver is a Wester Didital 320GB (WD3200):
> T:  Bus=07 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  5 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1058 ProdID=0704 Rev= 1.05
> S:  Manufacturer=Western Digital
> S:  Product=External HDD
> S:  SerialNumber=5758453730384E5036333734
> C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
> E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> 
> The USB controller is
> 00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family)
> USB2 EHCI Controller #2 [8086:283a] (rev 03)
> 
> 
> Please tell me if I can provide other useful information.

It would help to see the dmesg log for when one of these errors occurs.

It would also help to know what happens under Windows.  Do the same 
"empty sense" errors occur?  If they do, how does Windows handle them?

Alan Stern

