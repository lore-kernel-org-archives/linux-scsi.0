From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Mon, 30 Jan 2017 18:43:12 +0100
Message-ID: <201701301843.12242@pali>
References: <Pine.LNX.4.44L0.1701301055100.2025-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9530786.GuVk2cUNAx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1701301055100.2025-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Dainius =?utf-8?q?Masili=C5=ABnas?= <pastas4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--nextPart9530786.GuVk2cUNAx
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 30 January 2017 17:17:03 Alan Stern wrote:
> On Sun, 29 Jan 2017, Pali Roh=C3=A1r wrote:
> > On Wednesday 11 January 2017 16:23:29 Alan Stern wrote:
> > > On Tue, 10 Jan 2017, James Bottomley wrote:
> > > > On Tue, 2017-01-10 at 16:00 -0500, Alan Stern wrote:
> > > > > In theory, I suppose we could change the kernel so that it
> > > > > would default to READ CAPACITY(16) for devices that report a
> > > > > SCSI level
> > > > >=20
> > > > > >=3D 3, or something along those lines.  In general we hesitate
> > > > > >to
> > > > >=20
> > > > > make changes of this sort, because they almost always end up
> > > > > breaking _some_ devices -- and if that happens then the
> > > > > change is reverted, with no exceptions.  Linus has a very
> > > > > strict rule about not breaking working systems.
> > > >=20
> > > > You shouldn't have to change anything: it already does
> > > > (otherwise how else would we detect physical exponent for
> > > > proper SCSI devices) see sd.c:sd_try_rc16_first().  It always
> > > > returns false for USB because you set sdev->try_rc_10_first
> > >=20
> > > In fact, this approach probably won't work.  See Bugzilla entries
> > > #43265 and #43391.  The devices in those reports claimed to be
> > > ANSI level 4, but they failed anyway.
> >=20
> > Seems those devices return capacity 0x7F000000000001 or
> > 0xFF000000000001 Maybe there is some error pattern?
>=20
> As far as I can tell, they both reported 0xFF000000000001.  That's a
> pattern -- unless somebody really does have a storage device that
> large (18 exabytes).  For the time being, perhaps we can ignore this
> possibility.
>=20
> > > If you guys want to try the quirk flag, you can apply the patch
> > > below. Then set the usb-storage module parameter
> > > quirks=3Dvvvv:pppp:k where vvvv and pppp are the Vendor and
> > > Product ID codes for your device (as 4 hex digits).
> > >=20
> > > In the long run, however, this is not a viable approach.  We'd be
> > > better off with an explicit blacklist.
> >=20
> > Ok, so what are next steps? I think that explicit blacklist would
> > be needed if "bad" devices is less.
> >=20
> > How many bug reports were there?
>=20
> I don't know.
>=20
> Anyway, please try out the patch below.  I don't know if it will be
> acceptable to the SCSI maintainers, but we should at least make sure
> it fixes your problem before submitting it.

I'm not original reporter of this problem.

Dainius, can you test it?

> Alan Stern
>=20
>=20
>=20
>=20
> Index: usb-4.x/drivers/scsi/sd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-4.x.orig/drivers/scsi/sd.c
> +++ usb-4.x/drivers/scsi/sd.c
> @@ -2157,6 +2157,13 @@ static int read_capacity_16(struct scsi_
>  		return -ENODEV;
>  	}
>=20
> +	/* Some buggy devices report an impossibly large size */
> +	if (lba >=3D (1ULL << 54)) {
> +		sd_printk(KERN_WARNING, sdkp, "Read Capacity(16) returned
> excessively large value: %llu", lba); +		sdkp->capacity =3D 0;
> +		return -EINVAL;
> +	}
> +
>  	if ((sizeof(sdkp->capacity) =3D=3D 4) && (lba >=3D 0xffffffffULL)) {
>  		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
>  			"kernel compiled with support for large block "
> Index: usb-4.x/drivers/usb/storage/scsiglue.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-4.x.orig/drivers/usb/storage/scsiglue.c
> +++ usb-4.x/drivers/usb/storage/scsiglue.c
> @@ -247,8 +247,11 @@ static int slave_configure(struct scsi_d
>  		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
>  		 * However some USB 3.0 drive enclosures return capacity
>  		 * modulo 2TB. Those must use READ_CAPACITY_16
> +		 *
> +		 * Assume SPC3 or later devices can handle READ_CAPACITY_16.
>  		 */
> -		if (!(us->fflags & US_FL_NEEDS_CAP16))
> +		if (sdev->scsi_level <=3D SCSI_SPC_2 &&
> +				!(us->fflags & US_FL_NEEDS_CAP16))
>  			sdev->try_rc_10_first =3D 1;
>=20
>  		/* assume SPC3 or latter devices support sense size > 18 */

=2D-=20
Pali Roh=C3=A1r
pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

--nextPart9530786.GuVk2cUNAx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAliPezAACgkQi/DJPQPkQ1KCYQCbBee4mN2hin5dACmTD5KJLBaM
olAAn0JPrnaSCwgcqbhNOkFv+/O5yvWU
=ubeW
-----END PGP SIGNATURE-----

--nextPart9530786.GuVk2cUNAx--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
