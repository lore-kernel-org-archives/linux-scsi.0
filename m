From: Ludovico Cavedon <ludovico.cavedon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: USB HD: No Sense / Info fld=0x0 and read corruption
Date: Wed, 24 Dec 2008 14:39:08 +0100
Message-ID: <49523B7C.5010600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,
I have a problem with a USB hard drive.

The problem starts to happen after some random time of operation; the
time may range from 1 minute up to one hour...

The first symptom are these messages in the kernel log.
---------------
sd 5:0:0:0: [sdb] Sense Key : No Sense [current]
Info fld=0x0
5:0:0:0: [sdb] Add. Sense: No additional sense information
---------------
The may appear only once or multiple times.

Sometime they are not associated with other errors, sometimes I start to
see filesystem corrpution:
---------------
attempt to access beyond end of device
sdb8: rw=0, want=15514452856, limit=207045657
---------------

If I unmount the device and replug it, I am able to read the same data
without any problem.
I suspect that some read corruption is happening. However I have *never*
seen I/O error reported!

Here is the usbmon log:
http://pastebin.com/f4e1afeb1

There are some successful read operation, than the read operation
31 = 55534243 8f150000 00100100 80000a28 0022ebd0 a8000088 00000000 000000

whose command completion status ends with "01". The subsequent REQUEST
SENSE, however is empty.

What may be happening here?
My situation looks different from
http://thread.gmane.org/gmane.linux.kernel/747753
-there is an additional "Info fld=0x0" line in the log
-there log messages are not always looping
-it is happening also with 2.6.28-rc8 (which should have the patch, right?)

I am not able to understand if this is HD problem or a kernel problem. I
am able to replicate it:
-2.6.28-rc8 vanilla kernel
-2.6.27 ubuntu (intrepid) kernel
-2.6.25 ubuntu (hardy) kernel
-on two different computers
-with different USB cables (so it not a cable problem)

However, I have never got errors reported by Windows (dual boot on the
same machine).

The HD driver is a Wester Didital 320GB (WD3200):
T:  Bus=07 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  5 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1058 ProdID=0704 Rev= 1.05
S:  Manufacturer=Western Digital
S:  Product=External HDD
S:  SerialNumber=5758453730384E5036333734
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

The USB controller is
00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family)
USB2 EHCI Controller #2 [8086:283a] (rev 03)


Please tell me if I can provide other useful information.

Thank you,
Ludovico Cavedon
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
