From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: XHCI issues: WD MyBook 1230 - reset SuperSpeed USB device
Date: Thu, 16 Jan 2014 15:48:33 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401161532560.1109-100000@iolanthe.rowland.org>
References: <52D8376E.1090805@fri.uniza.sk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35345 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751047AbaAPUse (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 15:48:34 -0500
In-Reply-To: <52D8376E.1090805@fri.uniza.sk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?UGV0ZXIgUGFsw7pjaA==?= <Peter.Paluch@fri.uniza.sk>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

It's now clear that this is _not_ an XHCI issue, contrary to what=20
$SUBJECT says.

On Thu, 16 Jan 2014, Peter Pal=C3=BAch wrote:

> Alan,
>=20
> I am attaching the usbmon trace after the drive has been plugged into=
=20
> the USB-2 port. Record of the drive in stall should occur around the=20
> file offset 87808 (decimal). The log was done on the 3.12.7 kernel=20
> without CONFIG_PM. Should I do a usbmon trace on my regular kernel wi=
th=20
> CONFIG_PM as well?

No need.

> dmesg transcript:
>=20
> root@bach:/tmp# dmesg
> usb 4-1.2: new high-speed USB device number 5 using ehci-pci
> usb 4-1.2: New USB device found, idVendor=3D1058, idProduct=3D1230
> usb 4-1.2: New USB device strings: Mfr=3D2, Product=3D3, SerialNumber=
=3D1
> usb 4-1.2: Product: My Book 1230
> usb 4-1.2: Manufacturer: Western Digital
> usb 4-1.2: SerialNumber: 574D43344E30323438393836
> usb-storage 4-1.2:1.0: USB Mass Storage device detected
> scsi6 : usb-storage 4-1.2:1.0
> usbcore: registered new interface driver usb-storage
> scsi 6:0:0:0: Direct-Access     WD       My Book 1230     1050 PQ: 0 =
ANSI: 6
> scsi 6:0:0:1: Enclosure         WD       SES Device       1050 PQ: 0 =
ANSI: 6
> sd 6:0:0:0: Attached scsi generic sg2 type 0
> scsi 6:0:0:1: Attached scsi generic sg3 type 13
> sd 6:0:0:0: [sdb] Spinning up disk...
> .........ready
> sd 6:0:0:0: [sdb] 732558336 4096-byte logical blocks: (3.00 TB/2.72 T=
iB)
> sd 6:0:0:0: [sdb] Write Protect is off
> sd 6:0:0:0: [sdb] Mode Sense: 53 00 10 08
> sd 6:0:0:0: [sdb] No Caching mode page found
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> sd 6:0:0:0: [sdb] 732558336 4096-byte logical blocks: (3.00 TB/2.72 T=
iB)
> sd 6:0:0:0: [sdb] No Caching mode page found
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>   sdb: sdb1
> sd 6:0:0:0: [sdb] 732558336 4096-byte logical blocks: (3.00 TB/2.72 T=
iB)
> sd 6:0:0:0: [sdb] No Caching mode page found
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> sd 6:0:0:0: [sdb] Attached SCSI disk
> usb 4-1.2: reset high-speed USB device number 5 using ehci-pci

It looks like the reset occurred because the computer sent an
ATA-passthru command to the disk, and the disk wasn't prepared to
handle it properly.  The firmware crashed, requiring a reset.

If anyone can explain, the command bytes in question were:

	85082e00 00000000 00000000 0000ec00

and the sense data was:

	7201001d 0000000e 090c0000 00005d00 01000000 0050

I don't know what either of these means, or even what software was
responsible for sending this command.  It appears to have come from
some user program, though, not the kernel.  Possibly something run by=20
udev.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
