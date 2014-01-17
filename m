From: Hannes Reinecke <hare@suse.de>
Subject: Re: XHCI issues: WD MyBook 1230 - reset SuperSpeed USB device
Date: Fri, 17 Jan 2014 08:35:33 +0100
Message-ID: <52D8DD45.9010602@suse.de>
References: <Pine.LNX.4.44L0.1401161532560.1109-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaAQHfg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 02:35:36 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401161532560.1109-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, =?UTF-8?B?UGV0ZXIgUGFsw7pjaA==?= <Peter.Paluch@fri.uniza.sk>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On 01/16/2014 09:48 PM, Alan Stern wrote:
> It's now clear that this is _not_ an XHCI issue, contrary to what=20
> $SUBJECT says.
>=20
> On Thu, 16 Jan 2014, Peter Pal=C3=BAch wrote:
>=20
>> Alan,
>>
>> I am attaching the usbmon trace after the drive has been plugged int=
o=20
>> the USB-2 port. Record of the drive in stall should occur around the=
=20
>> file offset 87808 (decimal). The log was done on the 3.12.7 kernel=20
>> without CONFIG_PM. Should I do a usbmon trace on my regular kernel w=
ith=20
>> CONFIG_PM as well?
>=20
> No need.
>=20
>> dmesg transcript:
>>
>> root@bach:/tmp# dmesg
>> usb 4-1.2: new high-speed USB device number 5 using ehci-pci
>> usb 4-1.2: New USB device found, idVendor=3D1058, idProduct=3D1230
>> usb 4-1.2: New USB device strings: Mfr=3D2, Product=3D3, SerialNumbe=
r=3D1
>> usb 4-1.2: Product: My Book 1230
>> usb 4-1.2: Manufacturer: Western Digital
>> usb 4-1.2: SerialNumber: 574D43344E30323438393836
>> usb-storage 4-1.2:1.0: USB Mass Storage device detected
>> scsi6 : usb-storage 4-1.2:1.0
>> usbcore: registered new interface driver usb-storage
>> scsi 6:0:0:0: Direct-Access     WD       My Book 1230     1050 PQ: 0=
 ANSI: 6
>> scsi 6:0:0:1: Enclosure         WD       SES Device       1050 PQ: 0=
 ANSI: 6
>> sd 6:0:0:0: Attached scsi generic sg2 type 0
>> scsi 6:0:0:1: Attached scsi generic sg3 type 13
>> sd 6:0:0:0: [sdb] Spinning up disk...
>> .........ready
>> sd 6:0:0:0: [sdb] 732558336 4096-byte logical blocks: (3.00 TB/2.72 =
TiB)
>> sd 6:0:0:0: [sdb] Write Protect is off
>> sd 6:0:0:0: [sdb] Mode Sense: 53 00 10 08
>> sd 6:0:0:0: [sdb] No Caching mode page found
>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>> sd 6:0:0:0: [sdb] 732558336 4096-byte logical blocks: (3.00 TB/2.72 =
TiB)
>> sd 6:0:0:0: [sdb] No Caching mode page found
>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>   sdb: sdb1
>> sd 6:0:0:0: [sdb] 732558336 4096-byte logical blocks: (3.00 TB/2.72 =
TiB)
>> sd 6:0:0:0: [sdb] No Caching mode page found
>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>> sd 6:0:0:0: [sdb] Attached SCSI disk
>> usb 4-1.2: reset high-speed USB device number 5 using ehci-pci
>=20
> It looks like the reset occurred because the computer sent an
> ATA-passthru command to the disk, and the disk wasn't prepared to
> handle it properly.  The firmware crashed, requiring a reset.
>=20
> If anyone can explain, the command bytes in question were:
>=20
> 	85082e00 00000000 00000000 0000ec00
>=20
> and the sense data was:
>=20
> 	7201001d 0000000e 090c0000 00005d00 01000000 0050
>=20
> I don't know what either of these means, or even what software was
> responsible for sending this command.  It appears to have come from
> some user program, though, not the kernel.  Possibly something run by=
=20
> udev.
>=20
Probably smartd.
The logic there is _less_ than perfect.
Try to disable smartd and check if the issue remains.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
