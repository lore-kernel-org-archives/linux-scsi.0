From: Kurt Garloff <garloff@suse.de>
Subject: Re: 2.4 [PATCH REQUEST] for scsi_scan.c (scan_scsis_single)
Date: Thu, 22 Apr 2004 20:47:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040422184700.GB4250@tpkurt.garloff.de>
References: <20040422112841.69638e0a@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:61079 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261181AbUDVXHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 19:07:04 -0400
Content-Disposition: inline
In-Reply-To: <20040422112841.69638e0a@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Scott O'Connor <soconnor@sanblaze.com>
Cc: linux-scsi@vger.kernel.org


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Scott,

On Thu, Apr 22, 2004 at 11:28:41AM -0400, Scott O'Connor wrote:
> I don't know if this has been proposed before, I just joined this mailing=
 list.
>=20
> I'm seeing a problem with a USB -> IDE device (SMSC USB97c202) with a DVD
> R/W drive connected.  The INQUIRY command with a 255 byte request size is
> causing the DVD to go out to lunch.  No data is sent back and the SCSI
> subsystem is using what ever data is in the inquiry buffer.
>=20
> I've noticed in Linux 2.6 that the scsi_scan.c stuff has changed the INQU=
IRY
> data request size to 36.  When I make that change in 2.4, everything works
> properly with my device.

Have a look at
http://www.suse.de/~garloff/linux/scsi-scan/scsi-scanning.html
for a better patch.
It does pretty much what 2.6 does: First do a 36byte inquiry and do
another one with a longer buffer if the device claims to support longer
INQUIRYs.
Your patch will break U80/160/320 support as the needed flags are needed
=66rom byte 56 and some host adapters snoop this data to determine maximum
allowable speeds.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAiBMkxmLh6hyYd04RAmJWAJ9RHq3HJ/sHbQr+PZMdJSdFBFic7gCeKn3o
eBF3wqR+q/vXJiSfoZAw0bA=
=mhev
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
