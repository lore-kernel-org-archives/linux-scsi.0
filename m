From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: Time to conclude the Sony USB mass storage thread
Date: Fri, 14 Nov 2003 12:30:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114123031.E19467@one-eyed-alien.net>
References: <1068825146.2134.6.camel@mulgrave> <20031114092644.A2794@beaverton.ibm.com> <20031114093503.B19467@one-eyed-alien.net> <20031114095823.A3597@beaverton.ibm.com> <20031114105212.C19467@one-eyed-alien.net> <20031114120048.A4527@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:22277 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264540AbTKNUaf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 15:30:35 -0500
Content-Disposition: inline
In-Reply-To: <20031114120048.A4527@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Nov 14, 2003 at 12:00:48PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

So the vendor/model blacklist completely overrides the .flags setting in
the host template?

I thought the flags were just logically-or'ed

Matt

On Fri, Nov 14, 2003 at 12:00:48PM -0800, Patrick Mansfield wrote:
> On Fri, Nov 14, 2003 at 10:52:12AM -0800, Matthew Dharm wrote:
>=20
> > It's not immediately clear how we can override it if it's
> > scsi_devinfo/dev_flags.  Can you elaborate?
>=20
> The same way you can set it is the same way it can be cleared.
>=20
> If we want to allow all standard scsi core usage, as if there were not
> special flag settings at all, and including using MODE SENSE 6, use
> ("model" is synonymous with SCSI product):
>=20
> 	echo "vendor:model:0" > /proc/scsi/device_info
>=20
> If we want MODE SENSE 10, default cache write through (if the device can't
> do MODE SENSE page 8), use BLIST_USE_10_BYTE_MS | BLIST_MS_SKIP_PAGE_08
> (0x8000 | 0x2000):
>=20
> 	echo "vendor:model:0xa000" > /proc/scsi/device_info
>=20
> The above can also be done at boot time or scsi_mod load time, on boot
> use:
>=20
> 	scsi_mod.dev_flags=3Dvendor:model:0xa000
>=20
> For scsi_mod as a module just drop the "scsi_mod." prefix.
>=20
> The above does not allow us to send a variant of the MODE SENSE, like the
> Sony really wants - MODE SENSE with a 10 byte (or larger) buffer - but
> that would require a patch like the other one I sent, or command filtering
> code, plus other code to enable/disable its use.
>=20
> We still need a sysfs attribute to eventually replace the proc one - this
> should be done by using module_param_call instead of module_param_string
> (we need a special callout to parse the string, I did not understand
> module_param_call when I added module_param usage), plus code to always
> (not just for modules) add sysfs parameters for all module_param entries.
>=20
> The device specific flags override any other settings - the shost->flags
> or the scsi_default_dev_flags. We don't have any deletion method other
> than reboot, but the last setting added overrides earlier settings, and so
> you can even overide static entries in scsi_devinfo.c.
>=20
> -- Patrick Mansfield
> _______________________________________________
> usb-storage mailing list
> usb-storage@one-eyed-alien.net
> http://www2.one-eyed-alien.net/mailman/listinfo/usb-storage

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

THEY CASTRATED MY QUAKE BITS! I WANT THEM BACK!!!!
					-- Greg
User Friendly, 3/27/1998

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tTtnIjReC7bSPZARAlwsAJ9eq9+Els61hJ6Ph92icbYoecJj6wCeJRNi
+9SgchDaBXfePgzpVfUYhxE=
=g0Bb
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
