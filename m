From: Kurt Garloff <garloff@suse.de>
Subject: Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 13:33:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020617113327.GC27995@gum01m.etpnet.phys.tue.nl>
References: <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl> <200206151408.g5FE8s731047@numbat.Os2.Ami.Com.Au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200206151408.g5FE8s731047@numbat.Os2.Ami.Com.Au>
List-Id: linux-scsi@vger.kernel.org
To: John Summerfield <summer@os2.ami.com.au>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Sat, Jun 15, 2002 at 10:08:54PM +0800, John Summerfield wrote:
> > Life would be easier if the scsi subsystem would just report which SCSI
> > device (uniquely identified by the controller,bus,target,unit tuple) be=
longs
> > to which high-level device. The information is available in the kernel.
>=20
> Does this not fail if I pull a device off, change its ID (perhaps to fit
> into another system), then plug it in again? Or if I move it from one
> adaptor to another? =20

Sure it does.
The kernel can offer you the knowledge of a hardware path to your device,
which is given by controller,bust,SCSI target and unit numbers. This is
pretty stable in most configurations.

If you want to have more, you will probably use some sort of signatures.

But that's nothing which happens at SCSI layer.
For plain old SCSI devices, you may e.g. inquire the serial number (INQUIRY,
page code 0x80) which gives you a unique identifier if combined with
vendor and model strings. scsidev does this for you. But it occasinally
fails, as the open on scsi device may fail and we don't know the relation
between the sg devices (that can be used reliably to collect such
information) and the other high level devices. /proc/scsi/map solves this.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9DckHxmLh6hyYd04RAnztAJ9Fn5BJXZ5yxNz/HCjT3/rfEzsMYACglhmT
TB8VgIS8kGBD8zOZ6Mq0PNs=
=PLpB
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
