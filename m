From: Kurt Garloff <garloff@suse.de>
Subject: Re: RE: [PATCH] 2.4.26 scsi_scan.c Blacklist Entries
Date: Mon, 19 Apr 2004 15:54:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040419135406.GB4868@tpkurt.garloff.de>
References: <F65B33CAD23A284EAE6E4AE353BF94DC031A44CD@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SfqqZ2zU93BLT28p"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:49383 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264433AbUDSNyM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 09:54:12 -0400
Content-Disposition: inline
In-Reply-To: <F65B33CAD23A284EAE6E4AE353BF94DC031A44CD@tayexc13.americas.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: "Czerkowicz, John" <john.czerkowicz@hp.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--SfqqZ2zU93BLT28p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Mon, Apr 19, 2004 at 09:25:16AM -0400, Czerkowicz, John wrote:
> These devices have a tape drive at LUN 0 and a loader device at LUN 1.
> Without this patch, only the tape drive at LUN 0 is detected.  After
> applying this patch, both the drive and loader are detected.

LUN 1 should just be detected without blacklist entry.

Here's how Linux-2.6 scans:
* Send INQUIRY to LUN 0, if it fails we skip this device
* If it's SCSI-3, try REPORT_LUNS, if it succeeds, use results,
  otherwise continue with sequential scanning:
* Limit the number of possible LUNs from shost->max)luns dow to
  - max_scsi_luns (unless BLIST_FORCELUN or BLIST_SPARELUN are set)
  - limit to 5 if BLIST_MAX5LUN is set
  - limit to 8 if device is <=3D SCSI-2 and BLIST_LARGELUN is not set
* Scan sequentially, stop after the first non-existing device unless
  BLIST_SPARSELUN is set.

As you can see, BLIST_FORCELUN is only used at one place.
This leaves only one conclusion:
Your kernel is misconfigured:
  * You passed max_luns=3D1 boot/module parameter
  * Your kernel configuration is broken as CONFIG_SCSI_MULTI_LUN is=20
    not set

Later 2.4 kernels work in a similar way, except that REPORT_LUNS is
not used. (Well it is used in the SUSE 2.4 kernel, but that's a
different story.)

I see no possibility to use BLIST_FORCELUN in a meaningful way.
If you need it to override max_luns=3D1 (or unset CONFIG_SCSI_MULTI_LUN)
that setting is the error in the first place, IMVHO.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--SfqqZ2zU93BLT28p
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAg9n+xmLh6hyYd04RAvoJAKCdW/UOqsqt8R/2Ww4Tk97z2M+I3ACg11ix
5//6JjAhDJ8n1Pmbbk5DwIk=
=eRWZ
-----END PGP SIGNATURE-----

--SfqqZ2zU93BLT28p--
