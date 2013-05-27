From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] [SCSI] sd: Fix parsing of 'temporary ' cache mode prefix
Date: Mon, 27 May 2013 19:07:19 +0100
Message-ID: <1369678039.3469.395.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JDsINHFEkEnTRycEmRaP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51254 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755265Ab3E0SH2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 May 2013 14:07:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>


--=-JDsINHFEkEnTRycEmRaP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit 39c60a0948cc '[SCSI] sd: fix array cache flushing bug causing
performance problems' added temp as a pointer to "temporary " and used
sizeof(temp) - 1 as its length.  But sizeof(temp) is the size of the
pointer, not the size of the string constant.  Change temp to a static
array so that sizeof() does what was intended.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c1c5552..6f6a1b4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -142,7 +142,7 @@ sd_store_cache_type(struct device *dev, struct device_a=
ttribute *attr,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
-	const char *temp =3D "temporary ";
+	static const char temp[] =3D "temporary ";
 	int len;
=20
 	if (sdp->type !=3D TYPE_DISK)


--=-JDsINHFEkEnTRycEmRaP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaOg1+e/yOyVhhEJAQqVeA//fJrYmRlaoNJIMqPEa6M7PuuYLWWqMlJU
Aa5hLZasBXM/bvXwPQUmLfZx+NzOBG4HzkQaiWzXH54YTeZuGqRBnX3mLRrJoieU
nlFQTgFB79Pzc5IY/AQs/erpKEqX45gSqDFBl3ElZPoLHaj8gjOvEDVzRu4Xl/x6
huHiqaoZcglyH+RFrPKXOqdVOQFxzDaD3giaSqoQQ7SAoD/n2j2i8YJv3av/kaDk
wdlmd24XsBYWhZ8GlSFTiX32RRwFtXma4eJPK2wCxocaviSD97Wu2hmEIaRfsM2B
MWST0C2eoL+TdD9jFb+XAn4+sbtfU6LnZe7Gz4hGxPZmI4U0C0uWQ6raRPfpMmVi
ikYsJwHbSh/l4ggxECxE3oEskuDkf+gnqwvQXf2hVFpqBYzbhArYmqxZjV2RPawA
jDqIdqpUpmOms5sDZfiBuRuYfHCNrYiTKV0awUSlUsbWE2UMW0lNM8nFE6vc+xLU
QrRZXMw2UG8A6QXYw0Yw0SO+vGCMhP4MZAl3Sw8Fv7C1sx3bzI2V2BUzxRKSCb5t
bxbnOr+bNeDLmufD7lYPgW6yNFqFxW48hLighuf8UrHOLAlIuiO5csAlgQg/a2f4
IRgURiNAojw2TA1/jPcYJV2kbiAMpwPTW5ewJGZDdtnXSOCgYg7fHq3dMkvtICm8
4MX+PZE4pWQ=
=UJiX
-----END PGP SIGNATURE-----

--=-JDsINHFEkEnTRycEmRaP--
