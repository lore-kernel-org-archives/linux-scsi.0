From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: External USB3 disk fails with "Invalid field in cdb"
Date: Fri, 27 Jun 2014 14:42:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1406271440130.875-100000@iolanthe.rowland.org>
References: <20140627195503.49e2dc55@wiggum>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37403 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750990AbaF0SmC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 14:42:02 -0400
In-Reply-To: <20140627195503.49e2dc55@wiggum>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Bryn M. Reeves" <bmr@redhat.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Fri, 27 Jun 2014, Michael B=C3=BCsch wrote:

> On Fri, 27 Jun 2014 08:48:01 -0700
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>=20
> > On Fri, 2014-06-27 at 17:34 +0200, Michael B=C3=BCsch wrote:
> > > I tried the following patch:
> > >=20
> > > Index: linux/drivers/scsi/sd.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux.orig/drivers/scsi/sd.c	2014-06-26 18:40:39.214696552 +0=
200
> > > +++ linux/drivers/scsi/sd.c	2014-06-27 15:52:30.776159456 +0200
> > > @@ -2440,7 +2440,7 @@ sd_read_cache_type(struct scsi_disk *sdk
> > >  			sdkp->RCD =3D 0;
> > >  		}
> > > =20
> > > -		sdkp->DPOFUA =3D (data.device_specific & 0x10) !=3D 0;
> > > +		sdkp->DPOFUA =3D 0;
> > >  		if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
> > >  			sd_first_printk(KERN_NOTICE, sdkp,
> > >  				  "Uses READ/WRITE(6), disabling FUA\n");
> > > =20
> > >=20
> > > This obviously is not the correct thing to do, but it makes the d=
isk usable:
> > >=20
> > > Jun 27 17:26:50 marge kernel: [  523.909815] usb 2-1: new SuperSp=
eed USB device number 2 using xhci_hcd
> > > Jun 27 17:26:50 marge kernel: [  523.929246] usb 2-1: New USB dev=
ice found, idVendor=3D152d, idProduct=3D0567
> > > Jun 27 17:26:50 marge kernel: [  523.929258] usb 2-1: New USB dev=
ice strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
> > > Jun 27 17:26:50 marge kernel: [  523.929265] usb 2-1: Product: US=
B to ATA/ATAPI Bridge
> > > Jun 27 17:26:50 marge kernel: [  523.929271] usb 2-1: Manufacture=
r: JMicron
> > > Jun 27 17:26:50 marge kernel: [  523.929276] usb 2-1: SerialNumbe=
r: xxx
> > > Jun 27 17:26:50 marge kernel: [  523.930999] usb-storage 2-1:1.0:=
 USB Mass Storage device detected
> > > Jun 27 17:26:50 marge kernel: [  523.931237] scsi12 : usb-storage=
 2-1:1.0
> > > Jun 27 17:26:51 marge kernel: [  524.930451] scsi 12:0:0:0: Direc=
t-Access     JMicron  Generic          0114 PQ: 0 ANSI: 6
> > > Jun 27 17:26:51 marge kernel: [  524.931228] sd 12:0:0:0: Attache=
d scsi generic sg3 type 0
> > > Jun 27 17:26:51 marge kernel: [  524.932964] sd 12:0:0:0: [sdd] S=
pinning up disk...
> > > Jun 27 17:26:53 marge kernel: [  525.937848] ..ready
> > > Jun 27 17:26:53 marge kernel: [  526.942395] sd 12:0:0:0: [sdd] 9=
76773168 512-byte logical blocks: (500 GB/465 GiB)
> > > Jun 27 17:26:53 marge kernel: [  526.943037] sd 12:0:0:0: [sdd] W=
rite Protect is off
> > > Jun 27 17:26:53 marge kernel: [  526.943048] sd 12:0:0:0: [sdd] M=
ode Sense: 47 00 10 08
> > > Jun 27 17:26:53 marge kernel: [  526.943662] sd 12:0:0:0: [sdd] W=
rite cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > > Jun 27 17:26:53 marge kernel: [  526.987919]  sdd: sdd1
> > > Jun 27 17:26:53 marge kernel: [  526.990055] sd 12:0:0:0: [sdd] A=
ttached SCSI disk
> > > Jun 27 17:27:29 marge kernel: [  563.227849] EXT4-fs (sdd1): warn=
ing: mounting fs with errors, running e2fsck is recommended
> > > Jun 27 17:27:29 marge kernel: [  563.228043] EXT4-fs (sdd1): moun=
ted filesystem with ordered data mode. Opts: (null)
> > >=20
> > > (This is on another machine, but it shows the same behavior witho=
ut the patch.)
> > >=20
> > > Does somebody have a hint for a real fix?
> >=20
> > I suspect the problem is in the USB bridge: The device reports FUA
> > support in its initial IDENTIFY, which gets translated to the corre=
ct
> > mode page bits, but when we send a READ/WRITE with the FUA bit set,=
 the
> > bridge doesn't know how to translate it and gives us the error.  Th=
ere's
> > probably some way in USB to blacklist the bridge, but we need to
> > understand the consequences of the blacklist: The device is claimin=
g a
> > writeback cache which means if it won't do either FUA or SYNC CACHE=
,
> > there's going to be a data integrity failure.
> >=20
> > The fact that your initial hack works suggests that sync cache is
> > accepted by it, so we probably just need a USB blacklist fixing the=
 FUA
> > problem.

Michael, can you post the "lsusb -v" output for this device?  I see it=20
is made by JMicron; they are notorious for buggy USB-ATA bridges.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
