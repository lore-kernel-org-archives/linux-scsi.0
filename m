From: Kurt Garloff <garloff@suse.de>
Subject: Re: WWID / SerialNo in sysfs?
Date: Tue, 10 Feb 2004 02:09:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210010901.GI4538@tpkurt.garloff.de>
References: <20040209160856.GS3944@tpkurt.garloff.de> <1076343628.1804.19.camel@mulgrave> <20040209162906.GV3944@tpkurt.garloff.de> <20040209090421.B1568@beaverton.ibm.com> <20040210001928.GE4538@tpkurt.garloff.de> <20040209164802.A6756@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/qIPZgKzMPM+y5U5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:41148 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265627AbUBJBMO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 20:12:14 -0500
Content-Disposition: inline
In-Reply-To: <20040209164802.A6756@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--/qIPZgKzMPM+y5U5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 09, 2004 at 04:48:02PM -0800, Patrick Mansfield wrote:
> On Tue, Feb 10, 2004 at 01:19:28AM +0100, Kurt Garloff wrote:
> Yes, and (a) is harder with the host number being always incremented.
>=20
> > Thus my patch to export the names.
>=20
> Does that only narrow the scope of the problem? If you have two host
> adapters of the same name, the name is not enough to identify a particular
> adapter, and we have to fall back to something else. Using the full sysfs
> path with a wildcard for the host number would cover some cases (for
> example, if the PCI bus id were constant).

scsidev the host number and the unique_id (ioport) by default for=20
historical reasons. But you can construct path names using scsi.alias.
You can encode the hostname and the unique_id (hostid) in there
to construct a path.

> > > Also has these items that could be done in scsidev:
> > >=20
> > > - a white/black list text file, so we don't need to rebuild a kernel =
or
> > >   recompile the user binary to add or remove devices from the lists
> >=20
> > I don't understand what you're telling me here.
>=20
> That we should have a white and black list, since there are devices that
> do not properly support page 0x80 or page 0x83, and that it should not be
> compiled into the command.

Ah, I see.

> If you're system has all known good devices (high end server, and no low
> cost USB mass storage devices will be attached to it), you might want to
> use a black list; if you're system is generic, you might want a white
> list.

Lucky enough, all devices I tested so far survived scsidev ...
And I did not get bug reports.=20

Maybe the patch to do it in the kernel should have just avoided it
for usb-storage and everything would have been fine ;-)

More seriously: I wonder whether a devices_are_likely_broken flag in
the host template that is set by usb-storage wouldn't save us from
a lot of hacks in SCSI.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--/qIPZgKzMPM+y5U5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAKC8txmLh6hyYd04RAqMeAJ9DU/ZUTRtY51qKLw+36jpM7Zw5DQCdGKu9
zrB74xKi00/IfoOWIvAWG5A=
=k+gN
-----END PGP SIGNATURE-----

--/qIPZgKzMPM+y5U5--
