From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Application error handling with write-back caching
Date: Tue, 10 May 2016 07:16:48 -0700
Message-ID: <1462889808.2320.4.camel@HansenPartnership.com>
References: <20160510134737.GA1922@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-vzF2KeB16VTo9a9HmTSx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39630 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbcEJOQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2016 10:16:58 -0400
In-Reply-To: <20160510134737.GA1922@stefanha-x1.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>


--=-vzF2KeB16VTo9a9HmTSx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-05-10 at 14:47 +0100, Stefan Hajnoczi wrote:
> SBC-3 4.15.3 Write caching says:
>=20
> "If processing a write command results in logical block data in cache
> that is different from the logical block data on the medium, then the
> device server shall retain that logical block data in cache until a
> write medium operation is performed using that logical block data."
>=20
> Does "is performed" mean "completes successfully" or just
> "completes"?

It means completes.  If there's an error, it will be reported via
deferred sense and an error to the SYNC CACHE command.

> If "is performed" just means "completes", maybe with an error, the
> application would have to resubmit write requests and then try to=20
> flush the write cache again.
>=20
> I'm not aware of applications that keep acknowledged write data=20
> around until the cache flush completion in order to retry writes.

I think you may be misunderstanding the nature of the returned error.=20
 It will be permanent and fatal and usually signal that the device has
a failed sector that can't be remapped and so the device itself has for
most purposes failed.  The only recovery is if you happen to have RAID,
in which case the RAID layer will mostly take care of it.

James

--=-vzF2KeB16VTo9a9HmTSx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXMe1XAAoJEDeqqVYsXL0MzVcH/2rbDv+vLOjy4llKlvPqq2qK
uMKIqqiXYZSPvrj+3yANAxGkF/vzWJF7R46tJ7hwrdZ/ElfdTHlVmR1GMBreaLv8
GwgSFREudWZrkWpXax55Iab4wVeQzH6FBfGcBlJaZBr3qgxDMk6octt7/1BZ5sv6
asqd3MzosjUFknoauS7mBDBrGyQuUpsFLOqgHFmGpl6WO/OyraX9aS9u+dUBmU7x
QLx1kdqDjVxceZrgBodcPcdONovuXtfPICSq8a7ge+XnP1fh4ll0JEubn0JKwGzX
ugQkjzyl7uSaHoTz5e8x3HxAs0bDf/2nq40o7ul3hxaBInjlr24EI8luyLaN1Dw=
=Ti7q
-----END PGP SIGNATURE-----

--=-vzF2KeB16VTo9a9HmTSx--

