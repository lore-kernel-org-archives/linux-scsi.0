From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: PATCH: usb-storage: fix typo
Date: Sat, 25 Jan 2003 12:32:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030125123214.A3594@one-eyed-alien.net>
References: <20030119143058.A31114@one-eyed-alien.net> <20030119171602.D31114@one-eyed-alien.net> <20030123044306.GA6584@kroah.com> <20030125101141.A2506@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030125101141.A2506@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Sat, Jan 25, 2003 at 10:11:41AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I finally got 2.5.59 to run, tho without modules.  I can confirm that the
three patches, taken together, produce a working hotplug system.

So far, it's not 100%.  But I think these patches should go in, because
there is still some debate going on as to how to make hot-unplug work best.
That's the last problem area.

I'm able to attach devices (which then get SCSI /dev/s), use them, then
hot-unplug the device (only tested for devices in quiet state).  Attaching
a device (new or the old one) gets a new set of /dev entries.

In addition, the sysfs entries seem to all be correct.  The lsscsi utility
likes it all enough, too.

It's a bit odd to see one device as /dev/sda one moment, then another as
/dev/sda the next (in an unplug-then-replace scenario), but that's for the
high-level drivers (sd, sg, etc.) to sort out.

You can crash this if you try.  The methods seem to be:
(1) Lots of plugging, as the unplug cleanup code isn't 100% yet
(2) Unplug a device that's still in use.

Both of these issues will be addressed once the unplugging technique gets
worked out (see the copious e-mails on the topic on l-u-d and linux-scsi).

Matt

On Sat, Jan 25, 2003 at 10:11:41AM -0800, Matthew Dharm wrote:
> On Wed, Jan 22, 2003 at 08:43:06PM -0800, Greg KH wrote:
> > On Sun, Jan 19, 2003 at 05:16:02PM -0800, Matthew Dharm wrote:
> > > This patch goes on top of the last one.  It fixes a typo in the test =
for
> > > scsi_register() failure.
> >=20
> > With these two patches applied, when plugging in a usb-storage device I
> > get the following oops.  So I've backed the changes out :)
>=20
> Try this patch on top of the other two.  It should fix the OOPS on attach.
>=20
> This fixes a silly error where I fail to initialize a pointer early enough
> for the scanning code.  If this isn't a perfect example of why
> scsi_register() and scsi_add_host() aren't two separate functions, I don't
> know what is.  :)
>=20
> Oh, and I added a couple of comments, too.
>=20
> Testing and comments are welcome, as always.
>=20
> Matt
>=20
> # This is a BitKeeper generated patch for the following project:
> # Project Name: greg k-h's linux 2.5 USB kernel tree
> # This patch format is intended for GNU patch command version 2.5 or high=
er.
> # This patch includes the following deltas:
> #	           ChangeSet	1.668   -> 1.669 =20
> #	drivers/usb/storage/usb.c	1.69    -> 1.70  =20
> #
> # The following is the BitKeeper ChangeSet Log
> # --------------------------------------------
> # 03/01/25	mdharm@zen.san.one-eyed-alien.net	1.669
> # Fix an OOPS by moving the setting of the hostdata[] pointer to _before_
> # the device scan starts.
> # --------------------------------------------
> #
> diff -Nru a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> --- a/drivers/usb/storage/usb.c	Sat Jan 25 10:07:43 2003
> +++ b/drivers/usb/storage/usb.c	Sat Jan 25 10:07:43 2003
> @@ -926,6 +926,12 @@
>  		goto BadDevice;
>  	}
> =20
> +	/* set the hostdata to prepare for scanning */
> +	ss->host->hostdata[0] =3D (unsigned long)ss;
> +
> +	/* associate this host with our interface */
> +	scsi_set_device(ss->host, &intf->dev);
> +
>  	/* now add the host */
>  	result =3D scsi_add_host(ss->host, NULL);
>  	if (result) {
> @@ -941,9 +947,6 @@
>  		down(&ss->dev_semaphore);
>  		goto BadDevice;
>  	}
> -
> -	ss->host->hostdata[0] =3D (unsigned long)ss;
> -	scsi_set_device(ss->host, &intf->dev);
> =20
>  	printk(KERN_DEBUG=20
>  	       "WARNING: USB Mass Storage data integrity not assured\n");
> --=20
> Matthew Dharm                              Home: mdharm-usb@one-eyed-alie=
n.net=20
> Maintainer, Linux USB Mass Storage Driver
>=20
> I need a computer?
> 					-- Customer
> User Friendly, 2/19/1998



--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+MvROIjReC7bSPZARAmxQAKDCql2VugM2tSgRcxGfMKUdG2wUBACfecMT
di/9waIErYVMNkYdpT9Ezc0=
=+cyT
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
