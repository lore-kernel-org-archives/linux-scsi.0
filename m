From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 28 Feb 2003 17:41:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030228174149.A31554@one-eyed-alien.net>
References: <20030202101317.A26796@one-eyed-alien.net> <20030202120628.A28024@one-eyed-alien.net> <20030203171726.GA1583@beaverton.ibm.com> <20030216131835.B23422@one-eyed-alien.net> <20030217193737.GB1990@beaverton.ibm.com> <20030222234834.A32167@one-eyed-alien.net> <20030226233702.GC1376@beaverton.ibm.com> <20030226171043.F28571@one-eyed-alien.net> <20030227063737.GB13803@beaverton.ibm.com> <20030227113239.A19703@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030227113239.A19703@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Thu, Feb 27, 2003 at 11:32:39AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

After conversing with Mike some more, there is a deadlock problem.  I need
to hold the host_lock to walk the device list, but I can't hold the
host_lock when I call scsi_set_device_offline().

Mike's looking into this.  Until he finds a good answer, no patch for
usb-storage.

Matt

On Thu, Feb 27, 2003 at 11:32:39AM -0800, Matthew Dharm wrote:
> This was discussed, but I didn't recall a firm decision.
>=20
> I'll keep my eyes open for the patch that uses release().
>=20
> Matt
>=20
> On Wed, Feb 26, 2003 at 10:37:37PM -0800, Mike Anderson wrote:
> > Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> > > Right... but I removed the release() function because that was marked=
 (in
> > > the documentation) as only for the old-style drivers.  So I'll need to
> > > re-introduce it -- but it looks like all it has to do is free some me=
mory.
> > > Does that sound about right?
> >=20
> > Yes it was previously removed, but IIRC this is the direction
> > discussed on this thread. For a idle device the release functionality c=
ould
> > be done in the context of the scsi_remove_host call, but for a busy
> > device we need to have this call to clean up later.
> >=20
> > -andmike
> > --
> > Michael Anderson
> > andmike@us.ibm.com
> >=20
> >=20
> >=20
> > -------------------------------------------------------
> > This SF.net email is sponsored by: Scholarships for Techies!
> > Can't afford IT training? All 2003 ictp students receive scholarships.
> > Get hands-on training in Microsoft, Cisco, Sun, Linux/UNIX, and more.
> > www.ictp.com/training/sourceforge.asp
> > _______________________________________________
> > linux-usb-devel@lists.sourceforge.net
> > To unsubscribe, use the last form field at:
> > https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
>=20
> --=20
> Matthew Dharm                              Home: mdharm-usb@one-eyed-alie=
n.net=20
> Maintainer, Linux USB Mass Storage Driver
>=20
> C:  They kicked your ass, didn't they?
> S:  They were cheating!
> 					-- The Chief and Stef
> User Friendly, 11/19/1997



--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+YA/dIjReC7bSPZARAv8MAJ9eBNm0a+FRa5eDEy7IUon/SuXq5QCdGiUm
3C9QK2msSHQs9W9EO2xsTVM=
=RMXX
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
