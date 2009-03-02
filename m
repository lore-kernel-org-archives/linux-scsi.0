From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH] Set manage_start_stop for some USB storage devices by
	default
Date: Mon, 2 Mar 2009 16:52:38 -0300
Message-ID: <20090302195238.GM3741@vespa.holoscopio.com>
References: <20090302174240.GA22206@vespa.holoscopio.com> <Pine.LNX.4.44L0.0903021432060.12263-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M0YLxmUXciMpOLPE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.18.203]:50340 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZCBTwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 14:52:30 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903021432060.12263-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org


--M0YLxmUXciMpOLPE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 02, 2009 at 02:42:15PM -0500, Alan Stern wrote:
> On Mon, 2 Mar 2009, Thadeu Lima de Souza Cascardo wrote:
>=20
> > Hello,
> >=20
> > Some time ago, I've worked with a Sandisk storage device, which could
> > not resume properly. I've found out that it was timing out when
> > receiving requests. I could mount it right after resuming, but using a
> > mounted device was not possible. Since this device is the only storage
> > present in some mobile, it is used as the root device and cannot be
> > unmounted.
> >=20
> > I've thought this was a bug in the device itself and not a problem in
> > the bus or host controller, since other devices worked pretty well.
> > After doing some tests, I've realized that doing a rescan in the device
> > before accessing it worked. And setting manage_start_stop as true does
> > this automatically when resuming for us.
> >=20
> > Thus, the patch below. I would like some comments about this particular
> > issue and, if the solution is acceptable, I will send a proper commit
> > log.
>=20
> Maybe there doesn't need to be a patch for this at all.  Can't you get=20
> the same result by writing a udev rule?  In fact, isn't that how the=20
> manage_start_stop flag is intended to be set?

I did expect that doing it in user space would be the proper way. Any
tips on how to find out the USB id's given the disk?

> As for the patch itself...  You are setting the flag in the wrong=20
> place.  The manage_start_stop flag applies only to SCSI disk devices=20
> AFAICT.  (The sysfs interface isn't present if the device isn't a disk,=
=20
> at any rate.)  So you should set the flag in the code that applies to=20
> disks.

I thought on adding a quirk flag to the SCSI host and, then, testing
that in the SCSI code itself. Didn't think SCSI guys would like that.

> Also, this patch won't apply to the current development tree, because
> there have been several changes to usb-storage's recently.  In
> particular there is new code allowing quirk flags to be set by a module
> parameter, and your new flag (if it is accepted) should be added to
> this mechanism.

Also expected. But I didn't know about the new changes in the quirk
flags code. Which tree should I refer to regarding usb-storage or USB,
besides next and rc trees?

> Alan Stern
>=20

Thank you very much for your prompt answer and advice.

Regards,
Cascardo.

--M0YLxmUXciMpOLPE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmsOQYACgkQyTpryRcqtS2CFgCgmvr5BaSbCgLw3uNyYb4cduTl
ikYAn3v1ycA2PBLv9VKXcgqN9FhAu1S0
=4yP6
-----END PGP SIGNATURE-----

--M0YLxmUXciMpOLPE--
