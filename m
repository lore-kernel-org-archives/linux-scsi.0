From: Kurt Garloff <garloff@suse.de>
Subject: Re: PATCH 2/5: scsi-scan-blist_replun
Date: Wed, 21 Apr 2004 17:30:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421153030.GE29699@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141234.GT28633@tpkurt.garloff.de> <20040421161412.B6793@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:39553 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263210AbUDUPah (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 11:30:37 -0400
Content-Disposition: inline
In-Reply-To: <20040421161412.B6793@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Wed, Apr 21, 2004 at 04:14:12PM +0100, Christoph Hellwig wrote:
> Hmm, where does this number come from?

1 page. I've mentioned it in the email.

> >  	/*
> > -	 * Only support SCSI-3 and up devices.
> > -	 */
> > -	if (sdev->scsi_level < SCSI_3)
> > +	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
> > +	 * Also allow SCSI-2 if BLIST_REPORTLUN2 is set and host adapter does
> > +	 * support more than 8 LUNs.
>=20
> This comment and the nested if is a little confusing.  Also why shouldn't
> the arbitrary SCSI2 limit for BLIST_REPORTLUN2?  I'm sure we won't find
> SCSI1 devices supporting it, but there should not be any harm leaving out
> that check - and doing so makes the logic much cleaner.

It's just straightforward plain simple boolean logic ;-)

I think default_dev_flags=3D0x20000 would be a good default for many
machines out there, so don't take a risk of breaking SCSI-1 devices.
That's why the check for a HBA which support more than 8 LUNs is in
there as well.

> 	/*
> 	 * REPORT_LUN is used by default only for SCSI 3 devices (unless
> 	 * BLIST_NOREPORTLUN is set).  For other devices BLIST_REPORTLUN
> 	 * enables it if the HBA does support more than 8 LUNs.
>=20
> 	 if (bflags & BLIST_NOREPORTLUN)
> 	 	return 1;
> 	 if (sdev->scsi_level < 3 && sdev->host->max_lun <=3D 8 &&
> 	     !(bflags & BLIST_REPORTLUN2))
> 	     	return 1;
>=20
> Note that I'd prefer not to add BLIST_NOREPORTLUN if the discussing
> about the LUN mapping comes to a useable consensus.

I'm sure there will be devices that are SCSI-3 and break on REPORT_LUNS.
It's not just for helping those devs that don't fit into our 32bit LUN
scheme. Also we need to have a replacement for the CONFIG option that
used to be there before.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux: SUSE Labs (Head)        <garloff@suse.de>    [SUSE Nuernberg, DE]

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhpOWxmLh6hyYd04RAuWCAJ9rPwvQ5Z0Qvfffb/sRirJ3pLg+rgCdGUBY
J+6opvPJ85W3CsBHSw/Zl2k=
=X8f/
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--
