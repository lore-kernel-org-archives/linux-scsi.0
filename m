From: Kurt Garloff <garloff@suse.de>
Subject: Re: Patches for SCSI scanning
Date: Tue, 20 Apr 2004 15:02:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420130233.GJ4356@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <20040420130414.A24817@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G44BJl3Aq1QbV/QL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:30403 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262703AbUDTNCh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 09:02:37 -0400
Content-Disposition: inline
In-Reply-To: <20040420130414.A24817@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


--G44BJl3Aq1QbV/QL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Tue, Apr 20, 2004 at 01:04:14PM +0100, Christoph Hellwig wrote:
> > * Patch 2: Drop REPORT_LUN config option and introduce=20
> >   noreportlun and reportlun2 parameters (the latter allowing SCSI-2
> >   devs to be scanned with REPORT_LUNS).
>=20
> I'm all for this one.

Alternatively, two BLIST flags would do as well.
The more I think about it, the more I like the BLIST approach and
default_dev_flags=3D0x10000 (NOREPORTLUN) / 0x20000 (REPORTLUN2).

Just wondering whether 0x20000 should be default anyway.
(No, it won't break USB crap, as shost->max_lun will not be > 8
 for usb-storage.)

> > * Patch 3: Allow host adapters to avoid REPORT_LUNS.
>=20
> Alson sounds okay, do you already have drivers that would set it?

zfcp on S/390 (as mentioned in the patch).

(With BLIST flags, one would just pass dev_flags=3DIBM:ESS:0x10000)

> > * Patch 4: allow_ghost_devices parameter
>=20
> I still think this should be a blacklist flag as it's really a spec
> violation from EMC if they really don't get it right.  And I still
> haven't an answer why they can't work around it by setting those
> magic devices online from userland.

Me neither.

> > * Patch 5: inq_timeout parameter
>=20
> Maybe this one should actually be a per-device tunable in sysfs?  Sure,
> to actually make use of it for the root device you'd need an initrd but
> the distros do that anyway.

Where would you assign it? Per hostadapter?
Per SCSI device is useless, of course, as the device is not yet known
when it gets scanned ...

> > Sidenote: We should drop SCSI_FORCELUN and CONFIG_SCSI_MULTI_LUN, other=
wise=20
                             BLIST
> > people will misconfigure their kernel (such as the HP guy) and start to=
 want=20
> > every multi-lun device listed.
>=20
> Agreed.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--G44BJl3Aq1QbV/QL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhR9pxmLh6hyYd04RAt1vAJ9NCT7ZiZw7L9skvnucM0Sn85GQXwCfQMRY
5xsz6xYdVAJEs2ktgvj4+jY=
=udNP
-----END PGP SIGNATURE-----

--G44BJl3Aq1QbV/QL--
