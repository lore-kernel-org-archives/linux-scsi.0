From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 02:42:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015004225.GA25625@nbkurt.casa-etp.nl>
References: <mdharm-scsi@one-eyed-alien.net> <20021014103059.C9725@one-eyed-alien.net> <200210141739.g9EHdYX03416@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210141739.g9EHdYX03416@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, Oct 14, 2002 at 10:39:34AM -0700, James Bottomley wrote:
> mdharm-scsi@one-eyed-alien.net said:
> > In userspace, something should get a new device notification and
> > decide what to do with the new device. Format?  Mount?  Ignore?  But,
> > it needs a /dev node to be able to handle the device, therefore the
> > kernel must do the work up to that point.=20
>=20
> SCSI was designed with this in mind.

Better not ask Eric Youngdale about this.

Basically the code is in there as you have no other way to trigger a SCSI
device detection, as the classical (parallel) SCSI host adapter drivers
don't scan themselves ...
Otherwise the mechanism would have been the other way round right from
the start: HBA drivers scan and tell upper layers what they found.
Which would have been the cleaner approach.

USB needs to know about attached devices anyway, so let's offer it the
cleaner way.

> The add/remove-single-device API works=20
> before a dev node exists.  It expects four numeric parameters=20
> (host,channel,pun and lun), and will do the inquiry and attach the correc=
t=20
> SCSI upper layer drivers.

I don't think you should take "hotpluging must go via userspace" to the
extreme.

There's nothing to be configured here. Just no decision to take. Because
no information is available on which this decision could be based.

Devices being recognized should show up und /proc/scsi/scsi resp. driverfs.=
=20
No point in wasting a few thousand CPU cycles going through userspace which
can not do anything useful except just sending some ASCII string with the
numbers it got from the kernel back to the kernel to parse them.

Now, devices are available (in /proc/scsi/scsi and/or driverfs) and you=20
can send userspace a hotplug event, because now userspace can inquire
information from the kernel and actually do take decisions and do something
useful.

Best regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9q2RxxmLh6hyYd04RAnreAJ4mSRBmn8PnapkLz0/FU6yNyGoiGQCgrAJW
L+RXxsacCUIbD8h7xw4+cNQ=
=hLNz
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
