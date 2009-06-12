From: Andrea Shepard <andrea@persephoneslair.org>
Subject: USB mass storage devices larger than 2 TB?
Date: Thu, 11 Jun 2009 22:48:23 -0700
Message-ID: <20090612054823.GA4486@charon.persephoneslair.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charon.persephoneslair.org ([216.254.15.24]:35635 "EHLO
	charon.persephoneslair.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbZFLGDg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2009 02:03:36 -0400
Received: from charon.persephoneslair.org (localhost [127.0.0.1])
	by charon.persephoneslair.org (8.13.8/8.13.8) with ESMTP id n5C5mOZM004694
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2009 22:48:24 -0700
Received: (from andrea@localhost)
	by charon.persephoneslair.org (8.13.8/8.13.8/Submit) id n5C5mN5H004693
	for linux-scsi@vger.kernel.org; Thu, 11 Jun 2009 22:48:23 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I have a USB disk enclosure with four Seagate ST31000340AS drives in
it.  Each drive has 1953525168 sectors, so that's 7814100672
sectors total for the array, or 3.64 TB.  There is a mode switch on
the back of the array; according to the manual, when the switch is in
position A, it will present a single large volume even when over 2 TB,
which supposedly works with 64-bit Windows, or, with the switch in
position B, it will split itself into two volumes under 2 TB if
necessary.

Now, with a stock 2.6.30 kernel on sparc64, here's what happens when I
attach the enclosure with the mode switch in position B:

usb 3-3.6: new high speed USB device using ehci_hcd and address 10
usb 3-3.6: New USB device found, idVendor=3D0dc4, idProduct=3D0004
usb 3-3.6: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 3-3.6: Product: MGB Quadro
usb 3-3.6: Manufacturer: GalaxyMetalGear
usb 3-3.6: SerialNumber: 540323
usb 3-3.6: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
scsi 4:0:0:0: Direct-Access     External  Disk 0          1.15 PQ: 0 ANSI: 4
sd 4:0:0:0: [sda] 3907050336 512-byte hardware sectors: (2.00 TB/1.81 TiB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 10 00 00 00
sd 4:0:0:0: [sda] Assuming drive cache: write through
sd 4:0:0:1: [sdb] 3907050336 512-byte hardware sectors: (2.00 TB/1.81 TiB)
sd 4:0:0:1: [sdb] Write Protect is off
sd 4:0:0:1: [sdb] Mode Sense: 10 00 00 00
sd 4:0:0:1: [sdb] Assuming drive cache: write through

Okay, that looks good.  Two LUNs of 3907050336 sectors each exactly
account for all the disk capacity I have installed.  I can run LVM
over them and get a single 3.6 TB volume.  The trouble starts when I
try to put the mode switch in position A:

usb 3-3.6: new high speed USB device using ehci_hcd and address 11
usb 3-3.6: New USB device found, idVendor=3D0dc4, idProduct=3D0004
usb 3-3.6: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 3-3.6: Product: MGB Quadro
usb 3-3.6: Manufacturer: GalaxyMetalGear
usb 3-3.6: SerialNumber: 540323
usb 3-3.6: configuration #1 chosen from 1 choice
scsi5 : SCSI emulation for USB Mass Storage devices
scsi 5:0:0:0: Direct-Access     External  Disk 0          1.15 PQ: 0 ANSI: 4
sd 5:0:0:0: [sda] 3519133184 512-byte hardware sectors: (1.80 TB/1.63 TiB)
sd 5:0:0:0: [sda] Write Protect is off
sd 5:0:0:0: [sda] Mode Sense: 10 00 00 00
sd 5:0:0:0: [sda] Assuming drive cache: write through

Now, it seems noteworthy that 3519133184 is just 7814100672 &
0xffffff00, but I'm not sure exactly what it means.  Noticing that the
code in sd_read_capacity() of drivers/scsi/sd.c tries READ
CAPACITY(10) first, and then uses READ CAPACITY(16) only if that
returns 0xffffffff, I tried patching it to always try READ
CAPACITY(16) first on this device.  That led to this (with verbose USB
mass storage messages enabled):

usb-storage: Command (unknown command) (16 bytes)
usb-storage:  9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
usb-storage: Bulk Command S 0x43425355 T 0x3 L 32 F 128 Trg 0 LUN 0 CL 16
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=3D0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 32 bytes, 1 entries
usb-storage: Status code -32; transferred 0/32
usb-storage: clearing endpoint halt for pipe 0xc0008380
usb-storage: usb_stor_control_msg: rq=3D01 rqtype=3D02 value=3D0000 index=
=3D81 len=3D0
usb-storage: usb_stor_clear_halt: result =3D 0
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result =3D 0
usb-storage: Bulk Status S 0x53425355 T 0x3 R 32 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=3D0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result =3D 0
usb-storage: Bulk Status S 0x53425355 T 0x4 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x5, ASC: 0x20, ASCQ: 0x0
usb-storage: Illegal Request: Invalid command operation code
usb-storage: scsi cmd done, result=3D0x2

So, as far as I can tell, this means that this device doesn't support
READ CAPACITY(16).  Does anyone out there know anything else it might
be expecting?  I have no access to a Windows machine, so I can't
whether it really does work with 64-bit Windows.  Is this hardware
just buggy over 2 TB, or is there some other mechanism besides the
0xffffffff from READ CAPACITY(10), then READ CAPACITY(16) that it
could be using to indicate its capacity?

--=20
Andrea Shepard

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFKMewn0di3sWv+984RAuwgAJ4g0qFKTJXOaZtSW1kSPmDfobTN9QCdH2xX
Wzexdb3jhZ0uwqP0sHy7B/Y=
=A8P5
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
