From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] [SCSI] hpsa: Fix driver support flag initialisation on !x86
Date: Mon, 21 Jul 2014 01:09:17 +0100
Message-ID: <1405901357.8631.24.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uDu/N4BolXiv5hDdxxVJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36645 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794AbaGUAJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jul 2014 20:09:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


--=-uDu/N4BolXiv5hDdxxVJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On !x86 we currently don't read the existing support flags:

/home/benh/linux-3.14.13/drivers/scsi/hpsa.c:4375:17: warning: 'driver_supp=
ort' is used uninitialized in this function [-Wuninitialized]
  driver_support |=3D ENABLE_UNIT_ATTN;
                 ^

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 28e134464734 ("[SCSI] hpsa: enable unit attention reporting")
Cc: <stable@vger.kernel.org> # 3.14+
---
Compile-tested only.

Ben.

 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9a6e4a2..7c3ff51 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6350,9 +6350,9 @@ static inline void hpsa_set_driver_support_bits(struc=
t ctlr_info *h)
 {
 	u32 driver_support;
=20
+	driver_support =3D readl(&(h->cfgtable->driver_support));
 #ifdef CONFIG_X86
 	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
-	driver_support =3D readl(&(h->cfgtable->driver_support));
 	driver_support |=3D ENABLE_SCSI_PREFETCH;
 #endif
 	driver_support |=3D ENABLE_UNIT_ATTN;

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-uDu/N4BolXiv5hDdxxVJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU8xaQee/yOyVhhEJAQoyqg/+PKIVKoI3B+rR0ohe9uLT7SmcYm1xMSBe
SbBD7QRdX5+qHgV54es3mpz8g+PQU2ZtWmzUi0eIHd8dgVoEFMJ2oD5+Ebg0ZZ/e
5RbpIWOpPMjwrxdy8B/KBLplK0KsMPim/vckx4mUX4jEvC4dL2eXI0AinK6rQxPE
0zMiyrC5cyDGOfgS+xekH+J7E3C5724FIq3t54y4yeBQCz1LEE4K6GuFDy1o4ktB
ZB28ojWXfBq+6HSb3N+roY6mv8Z6JwefoN8oa+w8iec+lPT8YbDBgN54QHJNvnlO
Xy8ktLtHuv9mlq8OgNuJuMRVMh11bvrqIZVsPsnllT/HpE6XTAJG64K51WNzxH9R
CmLsWTAtdPnpFNtLIhpXqenm1ivzVhPUHTeYLxRKMENxvrZhysf0iD7ihEx8SShf
L5Nc6dAqmhgklHrQU1up8ssdVfdIij9Y/If4VrdnQN87WpcbozU4p6Lboh8mDf6K
C1hRDdH2miI5JCBPKQ1FgzJuItYBh4PTUSbFHCy7tnK1o5YKYIEihYzInYkKNOnj
7acIsuf5aIlGqQ5jh/P6bGYNTp01Gh/+O/oaVd3jDdd59ZErGrze4Pfn/VZEzjop
snSl3FSvFLwP1h4RIiA+TPyMg5suhCC4+8I1mjR+PrwXQbJrS5Mo8/zDGzNh4dV5
+DH0YXs7zsM=
=svq0
-----END PGP SIGNATURE-----

--=-uDu/N4BolXiv5hDdxxVJ--
