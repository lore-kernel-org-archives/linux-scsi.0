From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Help - sd vs. sg Devices, and Low-level Driver.
Date: Tue, 20 Apr 2004 10:56:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420175617.GB2726@one-eyed-alien.net>
References: <519672568F040C41B6FAC21ADF51B18FEFB3@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:15530 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263354AbUDTR41 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 13:56:27 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFB3@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2004 at 11:31:32AM -0500, Lee Xing wrote:
> I really appreciate the information and your help.  It makes sense and
> helps a lot!
>=20
> Follow up questions:
>=20
> Q1:
> Can we say:
> - if the "Peripheral device type" (bit 0-4 of byte 0) of INQUIRY data is
> Direct-access device (00h), then this device will be presented as a sd
> device, and
> - if the "Peripheral device type" of INQUIRY data is Scanner device
> (06h), then this device will be presented as a sg device.

No, this is incorrect.

First, 'sg' is not specific to SCANNER devices.  It is the 'generic'
interface, which is compatible for ALL device types.  Thus, the sg driver
will attach to any device.  Note that sg can be attached to a device at the
same time as another driver (sg, sr, st, osst, etc.) is attached.

'sg' is used to communicate with scanners because sg provides an interface
which user-level programs can use to communicate with devices.

> Q2:
> Sounds like the low-level driver just passes the INQUIRY data received
> from the physical device to the mid-level driver.  The mid-level driver
> then picks up a right upper-level driver (sd, sg, sr or st) depending on
> the "Peripheral device type" field of INQUIRY data.  The physical device
> is presented as the type of the upper-level driver being used.  Is it
> right?

This is _basically_ correct.

> Q3:
> Suppose the physical device is a FC disk but we (low-level driver) still
> want to present it as a sg device (because sg can support up to 256
> physical devices while sd can only support 128).  Can low-level driver
> fool the SCSI sub-system by sending it a fake "Peripheral device type"
> such as Scanner device (06h)?  Are there any potential problems by doing
> this?  If I remember right, all types of SCSI devices are accessible via
> the sg driver, right?

First, see my above comments -- sg will attach to anything, regardless of
PDT code.

Also, while sg will attach to the device, you can't use block-operations on
an sg device.  That is, programs like 'mount', 'dd', etc. will not function
on a sg device.  This is likely not what you want to do.

My understanding is that there are patches available to make sg support a
large number of disks.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I could always suspend a few hundred accounts and watch what happens.
					-- Tanya
User Friendly, 7/31/1998

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAhWRBIjReC7bSPZARAgCQAKCRAxJqG8FWwsETXc0pkp3CDiH8IQCfdh4D
+BGUJOM6c92CNp2aSyyPMLk=
=sdQg
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
