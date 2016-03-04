From: Yves-Alexis Perez <corsac-vD43ovf/fd+sTnJN9+BGXg@public.gmane.org>
Subject: Re: Page allocation failure (order 7) in UAS code
Date: Fri, 04 Mar 2016 08:13:58 +0100
Message-ID: <1457075638.23913.4.camel@corsac.net>
References: <1456825361.17330.9.camel@corsac.net>
	 <56D573CF.1000600@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ms6L2G7Bq1n0gvzM0lQi"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D573CF.1000600-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--=-ms6L2G7Bq1n0gvzM0lQi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2016-03-01 at 11:49 +0100, Hans de Goede wrote:
> Hi,
>=20
> On 01-03-16 10:42, Yves-Alexis Perez wrote:
> >=20
> > Hi,
> >=20
> > [sorry if this is not the right point for reporting bugs, I took the em=
ail
> > addresses from MAINTAINERS but please point me to the correct place if
> > needed]
> >=20
> > I have an external USB drive (Samsung M3), which apparently uses the UA=
S
> > code.
> > Starting with 4.4 (from Debian sid, I could retry with vanilla if neede=
d),
> > I
> > can't mount the drive anymore after a while (few hours/days uptime). Ju=
st
> > plugging the disk, I get page allocation failure in kernel logs:
> Can you try building a kernel with the following line in
> drivers/usb/storage/uas.c :
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.can_queue =3D 6553=
6,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Is there a limit on the _host_ ? */
>=20
> (around line 815) Replaced with
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.can_queue =3D MAX_=
CMNDS,
>=20
> That should help as MAX_CMNDS is 256, so claiming that we can queue more
> is not helpful, and that likely is what is causing this quite high order
> alloc.

After a few days, it seems that it does work fine, although I can't say
anything about sides effects.

Regards,
--=20
Yves-Alexis


--=-ms6L2G7Bq1n0gvzM0lQi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJW2TW2AAoJEG3bU/KmdcClo7UIAJO7zCNIFGord1UHAxRgdyzI
8nu/O/Ig8GwGoagNCr+G8Q9D80WiLNWhgurVSPdWzciB4lVP6FHLz16N5WIBHwI2
NoxK0gsOfhhadqPvwkW4jIt6zuSc3Z6+C6vcr9cH+j5HTKQjiK3xjjJZaf6pXmXy
p17e3/KK+LyVu7DM3gmRb7inqWQS7GdS3WMb6kTCwttIZk8P3wpmC6m3RM3ZHhoY
ARH/HX4/bNY3QOx+Bgac2Fe8q2T9uid0Hpkz4DcMwYUiZW3LS7qeHbdwq/UEGYq/
/v+R+nYsSjMLOsmfUgIM0gSD963gtPlsCG3eisuDqWtIXK6GDc5rxgfryJlilKU=
=/ccY
-----END PGP SIGNATURE-----

--=-ms6L2G7Bq1n0gvzM0lQi--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
