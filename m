From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] 2.4.X Avoid excessive recursion when setting device
	offline
Date: Mon, 29 Mar 2004 19:26:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080581208.3570.10.camel@laptop.fenrus.com>
References: <387680000.1080580020@aslan.btc.adaptec.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2HGxmxR76Wv4Yrhw6LWW"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36500 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S263012AbUC2R0x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 12:26:53 -0500
In-Reply-To: <387680000.1080580020@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Cc: linux-scsi@vger.kernel.org


--=-2HGxmxR76Wv4Yrhw6LWW
Content-Type: multipart/mixed; boundary="=-NAyUroEndoorNZSHOv3h"


--=-NAyUroEndoorNZSHOv3h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-03-29 at 19:07, Justin T. Gibbs wrote:
> How to reproduce: Queue up lots of I/O to a device.  Set that device
> 		  offline.
>=20
> Result: The SCSI mid-layer blows out the kernel stack due to the inherent
> 	recursion in its request function.  The repeating stack trace goes
> 	something like:
>=20
> 	scsi_request_fn
> 	__scsi_end_request
> 	scsi_release_command
> 	scsi_queue_next_request
> 	scsi_request_fn
> 	...
>=20
> This patch prevents recursive calls through the scsi_request_fn
> for the same queue:

won't this achieve the same ?

diff -urN Linux/drivers/scsi/scsi_lib.c linux/drivers/scsi/scsi_lib.c
--- Linux/drivers/scsi/scsi_lib.c       2002-10-03 16:50:07.000000000
+0200
+++ linux/drivers/scsi/scsi_lib.c       2002-10-03 17:33:20.000000000
+0200
@@ -442,7 +442,7 @@
         * This will goose the queue request function at the end, so we
don't
         * need to worry about launching another command.
         */
-       scsi_release_command(SCpnt);
+       __scsi_release_command(SCpnt);
 =20
        if( frequeue ) {
                request_queue_t *q;


--=-NAyUroEndoorNZSHOv3h
Content-Disposition: attachment; filename=scsi.patch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name=scsi.patch; charset=UTF-8

ZGlmZiAtdXJOIExpbnV4L2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jIGxpbnV4L2RyaXZlcnMvc2Nz
aS9zY3NpX2xpYi5jDQotLS0gTGludXgvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMJMjAwMi0xMC0w
MyAxNjo1MDowNy4wMDAwMDAwMDAgKzAyMDANCisrKyBsaW51eC9kcml2ZXJzL3Njc2kvc2NzaV9s
aWIuYwkyMDAyLTEwLTAzIDE3OjMzOjIwLjAwMDAwMDAwMCArMDIwMA0KQEAgLTQ0Miw3ICs0NDIs
NyBAQA0KIAkgKiBUaGlzIHdpbGwgZ29vc2UgdGhlIHF1ZXVlIHJlcXVlc3QgZnVuY3Rpb24gYXQg
dGhlIGVuZCwgc28gd2UgZG9uJ3QNCiAJICogbmVlZCB0byB3b3JyeSBhYm91dCBsYXVuY2hpbmcg
YW5vdGhlciBjb21tYW5kLg0KIAkgKi8NCi0Jc2NzaV9yZWxlYXNlX2NvbW1hbmQoU0NwbnQpOw0K
KwlfX3Njc2lfcmVsZWFzZV9jb21tYW5kKFNDcG50KTsNCiANCiAJaWYoIGZyZXF1ZXVlICkgew0K
IAkJcmVxdWVzdF9xdWV1ZV90ICpxOw0K

--=-NAyUroEndoorNZSHOv3h--

--=-2HGxmxR76Wv4Yrhw6LWW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAaFxYxULwo51rQBIRAvL4AJ0QU3wX7mgusXniE4WIROS6/gBtFgCeLOHt
Xs+xBtP1BR9yBDHpt1d9huQ=
=dGm3
-----END PGP SIGNATURE-----

--=-2HGxmxR76Wv4Yrhw6LWW--

