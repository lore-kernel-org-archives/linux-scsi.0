From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 16 Jan 2003 14:51:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030116145107.D29001@one-eyed-alien.net>
References: <10426732153816@kroah.com> <20030116173539.GA31235@kroah.com> <20030116114323.C29001@one-eyed-alien.net> <20030116195306.GA32697@kroah.com> <b073ja$12i$1@penguin.transmeta.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b073ja$12i$1@penguin.transmeta.com>; from torvalds@transmeta.com on Thu, Jan 16, 2003 at 08:10:18PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2003 at 08:10:18PM +0000, Linus Torvalds wrote:
> In article <20030116195306.GA32697@kroah.com>, Greg KH  <greg@kroah.com> =
wrote:
> >On Thu, Jan 16, 2003 at 11:43:23AM -0800, Matthew Dharm wrote:
> >> Well, we only create the host when the device is first attached.  After
> >> that, if it goes away and comes back, we re-connect it to the old SCSI
> >> host.
> >
> >Ick, so when the device is gone, where does the SCSI host go?  Is it
> >still represented in sysfs and in the SCSI core properly?
>=20
> This is pure and utter USB storage stupidity, and nothing else.

Well, I happen to agree.  But it was a necessary evil.

Up until recently, an attempt to hot-unplug a SCSI host would result is
gross system instability.

Also, up until recently, the debounce on USB ports means that a usb-storage
device could get disconnected and reconnected when a completely unrelated
device was attached to a hub.  Newer hubs fixed this.

Also, the _vast_ majority of devices keep sane serial numbers.  You happen
to have one of the broken ones, which tends to skew your perception.  But
of the two dozen or so storage devices I have, only one exhibits that
problem (and only with the old firmware loaded).

I'd like to fix this.  I've been wanting to fix this for a while.  I want
SCSI hot-unplug to work well enough to rely on it.  I want to be able to
take a USB disk, unplug it while writing to it, plug in a new USB disk, and
have a guarantee that the SCSI layer won't get confused and try to write
the data for the old disk to the new one (think scsi0 goes away, to be
replaced by a new scsi0, without properly stopping command initiators).

Heck, it was only in early 2.4.x that the SCSI mid-layer fixed an
off-by-one error that made it queue one-too-many commands to a HBA.

So, here's how it is:  We all want it fixed.  Linus, if you're willing to
deal with a major change for this at this late-date in the 2.5.x lifecycle,
then we'll do it.  Simple as that.  That's pretty much the only reason I
haven't started already -- the SCSI add-ons that support the hot-unplug
were too new and too late for me to be comfortable making a major change
like this.

Matt

P.S. BTW, this is also the original behavior of usb-storage, all the way
back to before I was working on it (and before it was called usb-storage).
I've never liked it this way...

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Hey Chief.  We've figured out how to save the technical department.  We=20
need to be committed.
					-- The Techs
User Friendly, 1/22/1998

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+JzdbIjReC7bSPZARAiz1AJ9hElYPXF4sD1MHocJ8+yxO/ryyrACgjoaz
AvPjVYVKakenTH4nx0nortA=
=Cilk
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
