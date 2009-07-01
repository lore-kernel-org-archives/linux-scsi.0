From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] Add BLIST_REPORTLUN2 to EMC SYMMETRIX
Date: Wed, 1 Jul 2009 21:42:24 +0200
Message-ID: <20090701194224.GC20681@tpkurt2.suse.de>
References: <200907012018.13695.jdelvare@suse.de> <1246476812.3894.56.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbZGATlu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jul 2009 15:41:50 -0400
Content-Disposition: inline
In-Reply-To: <1246476812.3894.56.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jean Delvare <jdelvare@suse.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

James,

On Wed, Jul 01, 2009 at 07:33:32PM +0000, James Bottomley wrote:
> > --- root.orig/drivers/scsi/scsi_devinfo.c
> > +++ root/drivers/scsi/scsi_devinfo.c
> > @@ -152,7 +152,7 @@ static struct {
> >  	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on L=
UN 0 */
> >  	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage o=
n LUN 0 */
> >  	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> > -	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_F=
ORCELUN},
> > +	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_R=
EPORTLUN2},
>=20
> You don't actually need SPARSE or LARGELUN ... that's implied by
> REPORTLUN2, so only REPORTLUN2 is needed here.

When I created the patch, all SYMMETRIXes that I had ever been exposed
to did support REPORT_LUNs, but I was not sure that every single=20
SYMMETRIX out there would actually support it. So in case some old
SYMMETRIX would not and the kernel would fall back to sequential
scanning, we would still find all LUNs by not dropping SPARSELUN
and LARGELUN. (Dropping FORCELUN on the other hand was absolutely right;
the flag is broken by design anyway and should never be used.)

So leaving in SPARSELUN and LARGELUN was not an oversight, but really
trying to be conservative.

If you have additional insight (you positively know that every SYMMETRIX
does support REPORT_LUNS) or you want to force possible devices that
do not support it into the open by breaking them, then remove the two
flags.

> >  	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
> >  	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
> >  	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},

Best,
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKS7wgxmLh6hyYd04RAr9xAKDCjtq57g6rK14/q9CmJVTQEMsyPACfXMoH
T4MflDS2z+FO57OEryA+gsY=
=S+8V
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
