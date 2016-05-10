From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Application error handling with write-back caching
Date: Tue, 10 May 2016 14:47:37 +0100
Message-ID: <20160510134737.GA1922@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbcEJNrj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2016 09:47:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

SBC-3 4.15.3 Write caching says:

"If processing a write command results in logical block data in cache
that is different from the logical block data on the medium, then the
device server shall retain that logical block data in cache until a
write medium operation is performed using that logical block data."

Does "is performed" mean "completes successfully" or just "completes"?

If "is performed" just means "completes", maybe with an error, the
application would have to resubmit write requests and then try to flush
the write cache again.

I'm not aware of applications that keep acknowledged write data around
until the cache flush completion in order to retry writes.

Can anyone clarify the SBC spec on this point?

Thanks,
Stefan

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJXMeZ5AAoJEJykq7OBq3PIs44H/2iE+UpaN4mUaKamCb7F+aC6
6vBfBcEeCDATmM5pRm3ETuvr2MwYgiVOigOfJAvVgQ9SdwDxQQQNv2+uPQTKkiA9
KYvD6itTWAiuPGBKK2KESkQf18vDFVv1hsfvfJRxM8SMEURtVud3eWdQ3ERsJWNU
VwE0Ce692+OGo/O6xrV23aalUD0rQLvvF1xnDMySjbFgAl/6p1ucFt01pvq/so0x
VQmjwb8Wp0yIOIlCW5eSLGyJOsPV6nH3wQZCTyIiVnJTFgB9LfL5Esf5jMSzVYA2
wrtyMvlrEPYAoA8aMDUfUaz9PJ2zk2WPIu9OlMD8yWDazpDhkkOlgR4OEUKlECg=
=wTek
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
