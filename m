From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Sun, 16 Feb 2003 13:18:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030216131835.B23422@one-eyed-alien.net>
References: <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com> <20030124164553.C27859@one-eyed-alien.net> <20030125010729.GG28812@redhat.com> <20030202101317.A26796@one-eyed-alien.net> <20030202120628.A28024@one-eyed-alien.net> <20030203171726.GA1583@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030203171726.GA1583@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, Feb 03, 2003 at 09:17:26AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Any updates on this?  I saw some patches, but they don't seem to be in my
tree (the usb tree, which is synced from Linus' tree).

People are starting to reports OOPSes to me because of this being
missing....

Matt

On Mon, Feb 03, 2003 at 09:17:26AM -0800, Mike Anderson wrote:
> Sorry Matthew I got side tracked on some issues for the last week. The
> scsi_set_device_offline(); function has not been added to any of James
> linux-scsi trees. You could add a ifndef in your code until we get the
> interface in the tree.=20
>=20
> Would scsi_set_device_offline() do more than sdev->online =3D 0? It
> depends on the state of the device at the calling of the function.
>=20
> I currently have scsi_set_device_offline() trying to do the following:
> 	1.) set device offline and mark host in_recovery.
> 	2.) mark all outstanding commands to be canceled and wake up
> 	error handler.
> 	3.) flush the request queue.
> 	4.) Once device is really offline send hotplug event.
>=20
> (2) needs some changes in the error handler which are needed in other
> cases. This the large part of the change, but it is not directly part of
> your request.
>=20
> (3) need a cleaner way to flush request specials off the queue . It
> would also be nice if there was a method to stop the incoming side of the
> request queue.
>=20
> (4) need export of do_hotplug interface or a method to generate a call
> to it for an offline event.
>=20
> I am working on these changes pretty much in order.
>=20
> Doug suggested a scsi_schedule_host_removal(), but I thought we could
> just change scsi_remove_host() to handle this task unless there is a
> side effect that all callers would not want???.
>=20
> -andmike
>=20
> Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> > Willem Riede <wrlk@riede.org> suggested to me that I simply set
> > sdev->online =3D 0 for scsi_set_device_offline()
> >=20
> > Any reason that isn't good enough?
> >=20
> > On Sun, Feb 02, 2003 at 10:13:17AM -0800, Matthew Dharm wrote:
> > > So, was any of this ever implemented?  As far as I can tell, the requ=
ired
> > > changes were:
> > >=20
> > > (o) addition of scsi_schedule_host_removal() (possibly optional)
> > > (o) implementation of scsi_set_device_offline() (possibly optional)
> > > (o) change the behavior of the 'hotplug initialization model' to call=
 my
> > > release function
> > >=20
> > > Matt
> > > > then call the set_scsi_device_offline(), then send back any outstan=
ding
> > > > commands via scsi_done(), then possibly call the
> > > > scsi_schedule_host_removal() if Mike adds that function.  Then retu=
rn. =20
> > > > Don't to anything else.  Take all the remaining code you would norm=
ally
> > > > run at this point and put it into a function in your source called
> > > > usb_release() and in your Scsi_Host_Template struct that you pass t=
o the
> > > > scsi layer, init the release pointer with the address of your
> > > > usb_release() routine.  That way, the scsi layer can do what it's b=
est at,
> > > > taking care of the clean up details we've been talking about, and w=
hen
> > > > it's all done, it will call your usb_release() routine with a single
> > > > argument of the host struct you are wanting released.  At that poin=
t, you
> > > > can do all the freeing you would have done in that khubd loop (at l=
east I
> > > > think that's the context you are doing the freeing from now) and kn=
ow for
> > > > a fact that not only are you freeing everything, but so is the scsi=
 mid
> > > > layer.  I think this will solve all the issues you've had, because =
this
> > > > *won't* leak, it won't block your other actions, and it lets the sc=
si
> > > > subsystem clean up properly.
>=20
>=20
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

My mother not mind to die for stoppink Windows NT!  She is rememberink=20
Stalin!
					-- Pitr
User Friendly, 9/6/1998

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+UAArIjReC7bSPZARAvM6AKDM21uX24dI/ikJwOw1zYP1hP+xVgCfe6gR
j2FOA3+acrmVbvoQeDfe/EU=
=DYya
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
