From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: External USB3 disk fails with "Invalid field in cdb"
Date: Fri, 27 Jun 2014 08:48:01 -0700
Message-ID: <1403884081.19382.7.camel@dabdike.int.hansenpartnership.com>
References: <20140626205519.314a71ae@wiggum>
	 <20140627101540.GB10042@localhost.localdomain>
	 <20140627142223.48c5c18f@wiggum> <20140627173432.46ea93bd@marge>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54317 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbaF0PsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 11:48:05 -0400
In-Reply-To: <20140627173432.46ea93bd@marge>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, linux-scsi@vger.kernel.org

On Fri, 2014-06-27 at 17:34 +0200, Michael B=FCsch wrote:
> I tried the following patch:
>=20
> Index: linux/drivers/scsi/sd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/sd.c	2014-06-26 18:40:39.214696552 +0200
> +++ linux/drivers/scsi/sd.c	2014-06-27 15:52:30.776159456 +0200
> @@ -2440,7 +2440,7 @@ sd_read_cache_type(struct scsi_disk *sdk
>  			sdkp->RCD =3D 0;
>  		}
> =20
> -		sdkp->DPOFUA =3D (data.device_specific & 0x10) !=3D 0;
> +		sdkp->DPOFUA =3D 0;
>  		if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
>  			sd_first_printk(KERN_NOTICE, sdkp,
>  				  "Uses READ/WRITE(6), disabling FUA\n");
> =20
>=20
> This obviously is not the correct thing to do, but it makes the disk =
usable:
>=20
> Jun 27 17:26:50 marge kernel: [  523.909815] usb 2-1: new SuperSpeed =
USB device number 2 using xhci_hcd
> Jun 27 17:26:50 marge kernel: [  523.929246] usb 2-1: New USB device =
found, idVendor=3D152d, idProduct=3D0567
> Jun 27 17:26:50 marge kernel: [  523.929258] usb 2-1: New USB device =
strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
> Jun 27 17:26:50 marge kernel: [  523.929265] usb 2-1: Product: USB to=
 ATA/ATAPI Bridge
> Jun 27 17:26:50 marge kernel: [  523.929271] usb 2-1: Manufacturer: J=
Micron
> Jun 27 17:26:50 marge kernel: [  523.929276] usb 2-1: SerialNumber: x=
xx
> Jun 27 17:26:50 marge kernel: [  523.930999] usb-storage 2-1:1.0: USB=
 Mass Storage device detected
> Jun 27 17:26:50 marge kernel: [  523.931237] scsi12 : usb-storage 2-1=
:1.0
> Jun 27 17:26:51 marge kernel: [  524.930451] scsi 12:0:0:0: Direct-Ac=
cess     JMicron  Generic          0114 PQ: 0 ANSI: 6
> Jun 27 17:26:51 marge kernel: [  524.931228] sd 12:0:0:0: Attached sc=
si generic sg3 type 0
> Jun 27 17:26:51 marge kernel: [  524.932964] sd 12:0:0:0: [sdd] Spinn=
ing up disk...
> Jun 27 17:26:53 marge kernel: [  525.937848] ..ready
> Jun 27 17:26:53 marge kernel: [  526.942395] sd 12:0:0:0: [sdd] 97677=
3168 512-byte logical blocks: (500 GB/465 GiB)
> Jun 27 17:26:53 marge kernel: [  526.943037] sd 12:0:0:0: [sdd] Write=
 Protect is off
> Jun 27 17:26:53 marge kernel: [  526.943048] sd 12:0:0:0: [sdd] Mode =
Sense: 47 00 10 08
> Jun 27 17:26:53 marge kernel: [  526.943662] sd 12:0:0:0: [sdd] Write=
 cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Jun 27 17:26:53 marge kernel: [  526.987919]  sdd: sdd1
> Jun 27 17:26:53 marge kernel: [  526.990055] sd 12:0:0:0: [sdd] Attac=
hed SCSI disk
> Jun 27 17:27:29 marge kernel: [  563.227849] EXT4-fs (sdd1): warning:=
 mounting fs with errors, running e2fsck is recommended
> Jun 27 17:27:29 marge kernel: [  563.228043] EXT4-fs (sdd1): mounted =
filesystem with ordered data mode. Opts: (null)
>=20
> (This is on another machine, but it shows the same behavior without t=
he patch.)
>=20
> Does somebody have a hint for a real fix?

I suspect the problem is in the USB bridge: The device reports FUA
support in its initial IDENTIFY, which gets translated to the correct
mode page bits, but when we send a READ/WRITE with the FUA bit set, the
bridge doesn't know how to translate it and gives us the error.  There'=
s
probably some way in USB to blacklist the bridge, but we need to
understand the consequences of the blacklist: The device is claiming a
writeback cache which means if it won't do either FUA or SYNC CACHE,
there's going to be a data integrity failure.

The fact that your initial hack works suggests that sync cache is
accepted by it, so we probably just need a USB blacklist fixing the FUA
problem.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
