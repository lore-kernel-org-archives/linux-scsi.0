From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Sun, 2 Feb 2003 10:13:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030202101317.A26796@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com> <20030124164553.C27859@one-eyed-alien.net> <20030125010729.GG28812@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030125010729.GG28812@redhat.com>; from dledford@redhat.com on Fri, Jan 24, 2003 at 08:07:29PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

So, was any of this ever implemented?  As far as I can tell, the required
changes were:

(o) addition of scsi_schedule_host_removal() (possibly optional)
(o) implementation of scsi_set_device_offline() (possibly optional)
(o) change the behavior of the 'hotplug initialization model' to call my
release function

Matt

On Fri, Jan 24, 2003 at 08:07:29PM -0500, Doug Ledford wrote:
> On Fri, Jan 24, 2003 at 04:45:53PM -0800, Matthew Dharm wrote:
> > Okay... so what do I do if it fails?  Sleep for a while and try again
> > later?  Wait on a flag somewhere?
>=20
> Well, the better option is what I think we are working on.  Instead of
> trying to remove the host completely, just unhook it from the USB stuff,
> then call the set_scsi_device_offline(), then send back any outstanding
> commands via scsi_done(), then possibly call the
> scsi_schedule_host_removal() if Mike adds that function.  Then return. =
=20
> Don't to anything else.  Take all the remaining code you would normally
> run at this point and put it into a function in your source called
> usb_release() and in your Scsi_Host_Template struct that you pass to the
> scsi layer, init the release pointer with the address of your
> usb_release() routine.  That way, the scsi layer can do what it's best at,
> taking care of the clean up details we've been talking about, and when
> it's all done, it will call your usb_release() routine with a single
> argument of the host struct you are wanting released.  At that point, you
> can do all the freeing you would have done in that khubd loop (at least I
> think that's the context you are doing the freeing from now) and know for
> a fact that not only are you freeing everything, but so is the scsi mid
> layer.  I think this will solve all the issues you've had, because this
> *won't* leak, it won't block your other actions, and it lets the scsi
> subsystem clean up properly.

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We can customize our colonels.
					-- Tux
User Friendly, 12/1/1998

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+PV+9IjReC7bSPZARAmC0AKDBrBv+fFz7aNdE5vZphXVbLk+rNwCeICHq
wyypQJctPw8Nx/tHeIRE7wo=
=zuIJ
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
