From: Kurt Garloff <garloff@suse.de>
Subject: Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 22:28:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020617202840.GA1313@gum01m.etpnet.phys.tue.nl>
References: <OFF92A995C.C87665ED-ON87256BDB.00565A27@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OFF92A995C.C87665ED-ON87256BDB.00565A27@boulder.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bryan,

thanks for your comments!

On Mon, Jun 17, 2002 at 09:57:38AM -0600, Bryan Henderson wrote:
> >Actually, the exact format of /proc/scsi/map is certainly something
> >that can be discussed separately from the basic idea of adding a file
> >that does expose the mapping of a SCSI address (CBTU) and the attached
> >high level drivers.
>=20
> Good.  Because there's one thing in the currently proposed format that is
> wrong.  The "sg_num" column doesn't make sense -- it's a layering
> violation. =20

Actually, the column header was sg_nm which should have the interpretation
sg name.
The userspace should know three things:
(1) What sort of driver the driver refers to: "sd"
(2) What sequential number it has: "5"
(3) What major:minor the device node uses: b:08:50

What I actually do is concatenate (1) and (2) and make the commonly used
device name out of it. It's a convenience thing for the script that may
deduce the device nodes from this and it causes no pain except maybe for
the "sd" case where the device names are not just the driver name (tag)
with the number appended.
If you criticize this, I do understand what you mean.

I do not understand what you want to say with SCSI slot. All high level
driver have their own numbering and the sequential number a device
get for the attachment of the sg driver does in no way have any meaning
in a way that it would give some ordering to the low-level devices.
Remove and insert more than one device and you'll see that the ordering in
which the script does output the lines is not co=EFnciding with the sg
numbering any longer.

> The information in this column is meaningful independent of
> whether the user uses  or the system has a Generic SCSI high level driver
> (sg).  And the names here can be confused with device special file names
> (/dev/sg5, etc) which of course the kernel knows nothing about.

No. I was not wanting to give a numbering to SCSI devices. They don't have.
The high level driver attached to them however do. That's what is reported.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9DkZ4xmLh6hyYd04RAoe8AJ9osURsQ0BqLlJ1wOMcKJtKpg5RrwCeOMsx
2WOvNzqQjjS3W7V+LqI2V34=
=B1gi
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
