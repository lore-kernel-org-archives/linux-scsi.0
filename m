From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] sd_many done right (1/5)
Date: Sat, 27 Jul 2002 00:32:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40468.5903377414$1027723030@news.gmane.org>
References: <20020726154533.GD19721@nbkurt.etpnet.phys.tue.nl> <Pine.GSO.4.21.0207261245070.21586-100000@weyl.math.psu.edu> <20020726165411.GI19721@nbkurt.etpnet.phys.tue.nl> <20020726175027.GC2746@clusterfs.com> <20020726185545.B18629@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S0GG+JvAI2G0KxBG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020726185545.B18629@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@math.psu.edu>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>, Marcelo Tosatti <marcelo@conectiva.com.br>


--S0GG+JvAI2G0KxBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph, Andreas,

On Fri, Jul 26, 2002 at 06:55:45PM +0100, Christoph Hellwig wrote:
> On Fri, Jul 26, 2002 at 11:50:27AM -0600, Andreas Dilger wrote:
> > Actually, one interesting aspect of the EVMS vs. device-mapper argument
> > going on that has totally been missed is that EVMS can do management of
> > ALL disk block devices.
>=20
> That's only natural as it try to duplicate the whole Linux block layer.
> But it's everything but a good idea.

I won't go into that discussion ... Duplicating the Linux block layer is
certainly not such a good idea as the block layer is getting really nice
nowadays. But I have no idea to what extent something like this is done in
EVMS.

But the idea of having a number of majors assigned to disks, no matter what
the driver below is looks certainly like a good idea. With the current
approach, we'll need way too many majors, even if we'd have some more bits
in the future. Why not have a pool of disk majors and sd, hd, dasd, rd
(DAC960), the IDE-Raids, and ... allocate some of these as needed.

driverfs + some userspace tool will be needed to provide a consistent view
on them and to handle the permissions. Fortunately, disk devs tend to all
have the same perms, so we can start before this is addressed to its
full extent.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--S0GG+JvAI2G0KxBG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9Qc34xmLh6hyYd04RArTyAJ0Uig6iiCc+2TVB41EQJuZJ3aJ22QCgj9X6
U9rTa6iLaVo8Tis9ryARyBc=
=NRTi
-----END PGP SIGNATURE-----

--S0GG+JvAI2G0KxBG--
