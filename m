From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 16:45:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030124164553.C27859@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030125000529.GE28812@redhat.com>; from dledford@redhat.com on Fri, Jan 24, 2003 at 07:05:29PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Ah... the sweet feeling of progress.

On Fri, Jan 24, 2003 at 07:05:29PM -0500, Doug Ledford wrote:
> On Fri, Jan 24, 2003 at 03:25:40PM -0800, Matthew Dharm wrote:
> > So, if I read this correctly, you're saying that the correct sequence i=
s:
> >=20
> > (1) get disconnect notification from USB
> > (2) Call scsi_set_device_offline() (must hold host lock for this)

> > (3) call scsi_done() for all command in queue (max: 1)
>=20
> Hmmm...only 1?  USB limit or driver limit?

Driver limit.  I added support for queueing, but the queue is fixed at size
1.  It's an improvement for the future.

> > (4) Call scsi_remove_host(), which should now work because no commands =
are
> > outstanding
>=20
> > (5) Call scsi_unregister()
> >=20
> > And we're done, all structures can be freed.  And, as I understand it, =
the
> > following is true:
> >=20
> > (b) once (3) is done, (4) is guaranteed to work
>=20
> No!  Remember, command completion is delayed!  We have a tasklet that=20
> processes your now complete command, and with that processing comes=20
> marking the device unbusy, which is also required for 4 to work.  That's=
=20
> why I was suggesting waking up the error handler thread and letting it=20
> finish this process off.  The error handler thread has the luxury of bein=
g=20
> able to wait for the command completion to happen, and in my opinion it's=
=20
> a slightly better place to do the work of cleaning out the request queue.

Okay... so what do I do if it fails?  Sleep for a while and try again
later?  Wait on a flag somewhere?

> > Tho, this does leave me with a couple of questions:
> >=20
> > (i) Doesn't scsi_set_device_offline() work on devices, not hosts?  How =
do I
> > map from my host to my device list?
>=20
> Well, in hosts.c::scsi_remove_host() we do it thusly:
>=20
>         list_for_each_entry(sdev, &shost->my_devices, siblings)
>                 if (scsi_check_device_busy(sdev))
>                         return 1;

Right, perfect example.

> > (iii) What should I shove into the status field of the scsi command bef=
ore
> > I scsi_done() it?
>=20
> Well, to force an error I always put DID_ERROR into the driver byte of=20
> the result dword, aka:
>=20
> cmd->result =3D DID_ERROR << 16;

Sounds reasonable.

> > Async is fine with me, but up until this e-mail,
> > all I've seen is people arguing over what the sequence is, and theoreti=
cal
> > issues of what users should and should not do.  And I also think that a
> > large number of hotplugable hosts are going to replicate a whole bunch =
of
> > code to do (2)+(3)+(4) in one, synchronous burst.
>=20
> Which would be wrong BTW.  If you can support multiple devices behind a=
=20
> bridge then you can't put (2)+(3)+(4) together in one burst.  That's why=
=20
> they aren't that way now.

Hrm... I can see your point if we're talking about hotplugging an
individual device, but I don't see how (2)+(3)+(4) isn't what we want for
hotplugging an entire host.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You are needink to look more evil.  You likink very strong coffee?
					-- Pitr to Dust Puppy
User Friendly, 10/16/1998

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Md5BIjReC7bSPZARAnB1AJ0XTxAcl7oVCX3HoAsO2/F0ggn1RACgutDu
KY2yoWYgFFYRHwxoClo7OMU=
=mLv/
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--
