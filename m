From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Sun, 7 Sep 2003 10:28:07 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309070128.KAA28169@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=shift_jis
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:56494 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S262201AbTIGB3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Sep 2003 21:29:07 -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Hi Alan,

Thank you for your help and useful comment.

Alan wrote:

Haruo> I tested using kernel 2.4.22-bk6. It failed by the=20
Haruo> following two patterns.
Haruo> 1. Bulk command transfer result=3D-104
Haruo> 2.  usb_stor_bulk_msg() returned -32
=20
Alan> This was two different failures on two separate runs?

Yes. I tested separately.=20
It is because it is hard to generate an error in testing
two simultaneously. When testing simultaneously,
much time is required by the time it generates an error.
The reason is not known.

Haruo> 1. Bulk command transfer result=3D-104

[skip]

Alan> This was the same sort of pattern we saw before.  No data was=20
Alan> transferred from the drive, and the command timed out
=82`=82=8C=82=81=82=8E> and was aborted.

I am also looking at this pattern repeatedly.
It seems that a device does not answer in the case of kernel 2.4.
However, when operating by kernel 2.6 and two or more devices
are connected simultaneously, it operates.=20
I cannot think the error of a device.

[skip]

Haruo> hub.c: port 1, portstatus 503, change 10, 480 Mb/s
Haruo> usb.c: ignoring set_interface for dev 3, iface 0, alt 0
Haruo> usb-storage: Examinging driver usb-storage...skipping ourselves.
Haruo> usb-storage: bus_reset() complete
=20
Alan> This time the bus_reset() routine worked, which is an=20
Alan> improvement over=20
Alan> what you were seeing before.  But the device still didn't respond=
:

If a device becomes an error, it seems that reset is not effective.
Using ioctl (fd, USBDEVFS_RESET, 0) and this device, =20
Is checking whether a device can reset correctly by=20
performing effective?

[skip]
=20
Haruo> scsi: device set offline - not ready or command retry=20
Haruo> failed after bus reset: host 0 channel 0 id 0 lun 0
Haruo> SCSI cdrom error : host 0 channel 0 id 0 lun 0 return code =3D 5=
0000
Haruo>  I/O error: dev 0b:00, sector 473224
Haruo>  I/O error: dev 0b:00, sector 473228
Haruo>  I/O error: dev 0b:00, sector 473476
Haruo>  I/O error: dev 0b:00, sector 473224

Alan> Once that happened there were no error recovery procedures=20
Alan> left to try, so=20
Alan> the driver gave up and marked the device offline.

Doesn't a device receive any commands?

Alan> There's something a little strange I just noticed in the log.  It=
's
Alan> probably not related to your problem, but we should check it=20
Alan> out anyway. =20
Alan> Please send a copy of /proc/bus/usb/devices, with the drive=20
Alan> plugged in.

OK.=20
=20
> > 2.  usb_stor_bulk_msg() returned -32
=20
Alan> Under what circumstances did this error occur?  It must have=20
Alan> been quite different from the other error.

The used device(Logitec LCW-WIN40U2) is different.=20
It is the same circumstances except a device.


Haruo> usb-storage: usb_stor_transfer_partial(): xfer 2048 bytes
Haruo> usb-storage: usb_stor_bulk_msg() returned -32 xferred 0/2048
Haruo> usb-storage: -- code: 0x70, key: 0x2, ASC: 0x4, ASCQ: 0x1
Haruo> usb-storage: Not Ready: LUN in process of becoming ready

Alan> That's normal.  It means that the drive was just turned on or=20
Alan> reset, and it's not yet ready to execute commands.

I see.

Haruo> usb-storage: Unit Attention: not ready to ready transition
=20
Haruo> More of the same.  This means that the drive just finished its=20
Haruo> initialization and now it's ready to operate.
Haruo> usb-storage: scsi cmd done, result=3D0x2
Haruo> usb-storage: *** thread sleeping.
Haruo>  I/O error: dev 0b:00, sector 804236
Haruo>  I/O error: dev 0b:00, sector 804240
Haruo>  I/O error: dev 0b:00, sector 804492
Haruo>  I/O error: dev 0b:00, sector 804236
=20
Alan> But apparently at this point the SCSI driver got tired of=20
Alan> waiting and set=20
Alan> the drive offline.  This should be fixed in the SCSI driver. =20

If a SCSI driver performs retry,=20
is it that usb-storage can also restart processing?

Alan> That's why=20
Alan> it's important to know what you were doing when the error occurre=
d.

Ok, echo is put into a script, and as processing can be distinguished, =
test it.

Thanks again,
Haruo=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
