From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 16:46:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106164647.F13916@one-eyed-alien.net>
References: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl> <20030106112259.B13916@one-eyed-alien.net> <20030106222322.GC29126@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="AH+kv8CCoFf6qPuz"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030106222322.GC29126@redhat.com>; from dledford@redhat.com on Mon, Jan 06, 2003 at 05:23:22PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, luben@splentec.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net


--AH+kv8CCoFf6qPuz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2003 at 05:23:22PM -0500, Doug Ledford wrote:
> On Mon, Jan 06, 2003 at 11:22:59AM -0800, Matthew Dharm wrote:
> >=20
> > The first case:  If the additional length indicates < 36 bytes, we shou=
ld
> > never issue the second request (which is where this device choked).  Th=
is
> > should be a sanity check in scsi_scan.c, and it works for reasons I've
> > previously outlined.
>=20
> No, this should be fixed in usb code.  It's a hack, I know, but it's a=20
> hack to work around the fact that usb devices are broken by and large muc=
h=20
> more so than non-usb scsi devices.  Basically, the usb code has the=20
> ability to tell that 36 bytes were actually transferred, so the usb code=
=20
> should set the length byte in the return to max(actual_transfer - 5,=20
> current_length_byte);  In actuality, other scsi HBAs that know how many=
=20
> bytes were transferred by devices could do this as well, but they don't=
=20
> need to because their SCSI devices aren't so braindead....

Okay, so what about sbp2, where this sort of thing is also common?  Why not
just fix it at the SCSI layer?

> > The second case:  This is a bad device.  A classic off-by-one error.  B=
ut
> > what can usb-storage do?  We don't know that the device is bad.  But,
> > focusing on this case, what happens?  Short data is returned... if the
> > resid field is set to indicate this, then scsi_scan.c should be able to=
 do
> > something sane here.
>=20
> Yep, as my previous email, scsi_scan.c should simply ignore the extra byt=
e=20
> because we don't care about it in the least.
>=20
> > Perhaps the "best" fix here is to simply make scsi_scan.c only send 36 =
byte
> > inquiry requests if the bus is 'emulated'.  That would solve a world of
> > problems....
>=20
> Except that if a device *does* transfer 36 bytes and then lies and says i=
t=20
> only transferred 5 then we are missing information that might actually be=
=20
> usefull, hence the reason to set the transfer length up to the real amoun=
t=20
> transferred (and BTW, I would only do this for INQUIRY responses, for=20
> anything else the device is simply too buggy to live if it lies about the=
=20
> transfer length).

First, I think this is a bogus situation.  If we reqest 36, get X, and
indicate a total of 5, then we should look at the X we got.  And that has
to be indicated by resid.

The argument that many HBAs don't set resid just doesn't hold water with
me.  Just because other drivers are broken, we should break more things
instead of fixing the problem?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Da.  Am thinkink of carbonated borscht for lonk nights of coding.
					-- Pitr
User Friendly, 7/24/1998

--AH+kv8CCoFf6qPuz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GiN3IjReC7bSPZARAsgVAKCb20KYyrqVyrHJEIAh3yEoRQ8UYACgnab7
qz413Muy7W5T6pohmGBpLz8=
=aXT0
-----END PGP SIGNATURE-----

--AH+kv8CCoFf6qPuz--
