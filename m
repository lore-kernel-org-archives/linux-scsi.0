From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Sat, 1 Feb 2003 19:49:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030201194914.B19267@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030125000529.GE28812@redhat.com>; from dledford@redhat.com on Fri, Jan 24, 2003 at 07:05:29PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

So, I was trying to implement this bit of logic in usb-storage, when I
discovered that scsi_set_device_offline() doesn't exist.

Okay, what did I miss?  I'm sure it's obvious, but for the life of me I
don't see it.

Matt

On Fri, Jan 24, 2003 at 07:05:29PM -0500, Doug Ledford wrote:
> > (i) Doesn't scsi_set_device_offline() work on devices, not hosts?  How =
do I
> > map from my host to my device list?
>=20
> Well, in hosts.c::scsi_remove_host() we do it thusly:
>=20
>         list_for_each_entry(sdev, &shost->my_devices, siblings)
>                 if (scsi_check_device_busy(sdev))
>                         return 1;
>=20
> > (ii) Do I need to call scsi_set_device_offline() for each device?  I
> > presume 'yes'.
>=20
> Yes.  As people pointed out to me the reason a USB device is done as a=20
> host is because it very well may *be* a host with several devices behind=
=20
> it, so it must handle the multiple device scenario correctly and set all=
=20
> devices offline and clean up after all of them that might be behind this=
=20
> bridge.

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm seen in many forms.  Now open your mouth.  It's caffeine time.
					-- Cola Man to Greg
User Friendly, 10/28/1998

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+PJU6IjReC7bSPZARAp83AKDW1zwFJNkKJrXqjkEmfgqViQqAywCeNZq5
pPKA2aJZ0T16ILn8IjxGLTY=
=AETu
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
