From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sun, 23 Mar 2003 22:58:11 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030323225811.D24668@one-eyed-alien.net>
References: <20030323173733.B24668@one-eyed-alien.net> <Pine.LNX.4.44.0303231754350.31675-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="bjuZg6miEcdLYP6q"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0303231754350.31675-100000@home.transmeta.com>; from torvalds@transmeta.com on Sun, Mar 23, 2003 at 05:58:43PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--bjuZg6miEcdLYP6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Well, I've already done that -- notice that we don't use START_STOP
anymore...

EVPD INQUIRY, INQUIRY for bytes !=3D 36, and MODE_SENSE are big offenders.

But, EVPD INQUIRY is something that's a problem.  Getting rid of it isn't
easy -- someone put it in there because they wanted/needed the data.

INQUIRY !=3D 36 bytes has been discussed before.  Since low-level drivers
snoop the data past 36-bytes, we can't completely get rid of this -- tho I
think this really means that the LLDD need fixing.

MODE_SENSE is something that Linux uses to check for write-protect status.
I could chuck the entire thing, but then we would assume write-enabled for
all disk-like media.

Note that not all of these fall into the 'not-well tested' category.
Certainly, INQUIRY !=3D 36 is something that we blacklist (for having a long
history of problems).  MODE_SENSE doesn't have any historical problems that
I know about.  EVPD certainly hasn't had much testing.... but can I just
get rid of it then?

Matt

On Sun, Mar 23, 2003 at 05:58:43PM -0800, Linus Torvalds wrote:
>=20
> On Sun, 23 Mar 2003, Matthew Dharm wrote:
>=20
> > On Sun, Mar 23, 2003 at 07:26:09PM -0600, James Bottomley wrote:
> > > The problem with this type of approach is that there's no unified list
> > > of "known good" commands that actually let you operate a device.  The
> > > SCSI and ATAPI standards have been gradually deprecating the commands
> > > that SCSI-1 (and sometimes even SCSI-2) regard as mandatory
> > > (READ_6/WRITE_6 springs to mind).
> >=20
> > Actually, there is such a list.  It's the commands that the 'popular OS'
> > uses, and I have a pretty good idea exactly what those are.  That's why=
 my
> > original approach was to just cut out the commands that fell outside th=
at
> > definition.
>=20
> Now _this_ is actually a valid approach, but then I would suggest you do
> what Andries Brouwer has done a few times: just make the Linux SCSI layer
> not use those commands _at_all_ - and instead use the sequences of
> commands that "that other OS" uses. That fixed a lot of the smartmedia=20
> problems I used to have - doing simple things like _not_ trying to spin u=
p=20
> devices that reported themselves to be already active etc.
>=20
> This isn't an "emulated vs native" thing, btw, it's a much more generic=
=20
> "don't use commands that haven't gotten much testing" approach, and shoul=
d=20
> probably be done both on emulated devices _and_ on "real" SCSI devices.
>=20
> After all, "real" devices have problems too - I bet a lot of our
> historical SCSI black-lists have been due to exactly the same issues you
> see on emulated USB, with devices just reacting badly to command sequences
> that they didn't expect and that hadn't been tested by the manufacturer.
>=20
> 			Linus

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm seen in many forms.  Now open your mouth.  It's caffeine time.
					-- Cola Man to Greg
User Friendly, 10/28/1998

--bjuZg6miEcdLYP6q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+fqyDIjReC7bSPZARAviJAJ9P6fj1I8D4yszI1PHE0Mm0jHeFggCfZ5Ou
gT86Fe9G9miL0HiHgNJZizg=
=al5y
-----END PGP SIGNATURE-----

--bjuZg6miEcdLYP6q--
