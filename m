From: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Subject: Re: bus:id:lun to device name
Date: 16 Jul 2003 10:29:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058344192.3983.98.camel@lt-sv>
References: <OF19C5DBC5.6CF569E6-ON87256D64.005C1908-88256D64.005DBB45@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rm5B+S/UdN9z/qGCgfKB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pong.to.com ([194.221.251.36]:49677 "EHLO pong.to.com")
	by vger.kernel.org with ESMTP id S270324AbTGPIPl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 04:15:41 -0400
In-Reply-To: <OF19C5DBC5.6CF569E6-ON87256D64.005C1908-88256D64.005DBB45@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org


--=-rm5B+S/UdN9z/qGCgfKB
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Tue, 2003-07-15 at 19:03, Bryan Henderson wrote:
>=20
>=20
> >Theoretically /dev/foobar might be a scsi device, meaning that I
> >must/should ioctl() all files under /dev/. Thats what I do not like
> >about ioctl() :).
>=20
> Once you admit that devices in Linux are not fundamentally associated wit=
h
> names in the file tree, the problem takes on a whole new perspective.

True. What I do not like about a list of devices is the fact that I will
duplicate code, eg (from sd.c)

static void sd_devname(unsigned int disknum, char *buffer)

> >> Another option is to use scsidev
> >> http://www.garloff.de/kurt/linux/scsidev/
> >> where the device nodes are dynamically created and (by default) have
> >> names which contain this information.
> >
> >AFAIR devfs does this too, depending on devfs would be an option.
>=20
> [...] Or do you want the name by which people normally know and
> use the device?  E.g. "I have /dev/sda mounted, but what device is that?"

Yes, basically. I have this information: host_id:bus:target:lun, and now
I'd like the "device file name with which one normally access' this
specific lun".

Let me give you some details (hope that will make it clearer). I am
implementing FC-HBA (ftp://ftp.t11.org/t11/pub/fc/hba/03-108v2.pdf). The
problem occures with HBA_GetFcpTargetMapping() on page 73 (7.4.4), the
parameters are describerd on page 31 (6.6.1) and the specific struct is
HBA_ScsiId (6.6.1.5), actually the member OSDeviceName (6.6.2.11).

As it seems, I must use the file-name-list-ioctl() approach without
devfs and something like snprintf("/dev/scsi/host%d/bus%d/...", ...); if
devfs is mounted.

Thank you all for your time

regards
	Stefan
--=20
--------------------------------------------------------------------
Stefan V=F6lkel                            stefan.voelkel@millenux.com
Millenux GmbH                              mobile: +49.170.79177.17
Lilienthalstra=DFe 2                          phone: +49.711.88770.300
70825 Stuttgart-Korntal                       fax: +49.711.88770.349
     -=3D linux without limits -=3D- http://linux.zSeries.org/ =3D-

--=-rm5B+S/UdN9z/qGCgfKB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/FQz/tWF28C4HGsQRArqDAKCpkoil5gjEa9nPxHtljQUec9bVsgCfZuVc
o4wIEo/pnoRLX2AnR0QjU8o=
=+Vua
-----END PGP SIGNATURE-----

--=-rm5B+S/UdN9z/qGCgfKB--

