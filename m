From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 16 Jan 2003 11:43:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030116114323.C29001@one-eyed-alien.net>
References: <10426732153816@kroah.com> <10426732212871@kroah.com> <20030116093112.B29001@one-eyed-alien.net> <20030116173539.GA31235@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030116173539.GA31235@kroah.com>; from greg@kroah.com on Thu, Jan 16, 2003 at 09:35:39AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Well, we only create the host when the device is first attached.  After
that, if it goes away and comes back, we re-connect it to the old SCSI
host.

But, while the device is gone, you've created an association between a SCSI
node that exists and a non-existant USB device.  Basically, you've got a
pointer that is no longer valid.  And when the device is re-attached, there
isn't code to re-establish the correct SCSI<->USB association.

Something like this would proabably make sense if the hot-unplugging code
for SCSI hosts was really stable -- then we could unregister the host when
the device went away, and this relation would be disconnected
automatically.

Matt

On Thu, Jan 16, 2003 at 09:35:39AM -0800, Greg KH wrote:
> On Thu, Jan 16, 2003 at 09:31:12AM -0800, Matthew Dharm wrote:
> > Hrm... doesn't this all fall to pot when the device is unplugged and
> > repluged?
>=20
> Um, how?  This seems to work for me, but I don't have a lot of devices
> here.  And if there is a problem, you might want to tell the scsi
> people, as they are the ones advocating this call be added.

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You are needink to look more evil.  You likink very strong coffee?
					-- Pitr to Dust Puppy
User Friendly, 10/16/1998

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+JwtbIjReC7bSPZARAgdpAJ90AFne+T9QdHx2fizKY0bAdA7PwACgpCBj
DQh4Udp0nHnBNTYAaoE3sxQ=
=tDeA
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
