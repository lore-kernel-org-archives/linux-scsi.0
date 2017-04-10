From: NeilBrown <neilb@suse.com>
Subject: [PATCH] scsi: ibmvfc: don't check for failure from mempool_alloc()
Date: Mon, 10 Apr 2017 12:15:13 +1000
Message-ID: <878tn9xb2m.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


mempool_alloc() cannot fail when passed GFP_NOIO or any
other gfp setting that is permitted to sleep.
So remove this pointless code.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/scsi/ibmvscsi/ibmvfc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 2c92dabb55f6..26cd3c28186a 100644
=2D-- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3910,12 +3910,6 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *v=
host, u64 scsi_id)
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
=20
 	tgt =3D mempool_alloc(vhost->tgt_pool, GFP_NOIO);
=2D	if (!tgt) {
=2D		dev_err(vhost->dev, "Target allocation failure for scsi id %08llx\n",
=2D			scsi_id);
=2D		return -ENOMEM;
=2D	}
=2D
 	memset(tgt, 0, sizeof(*tgt));
 	tgt->scsi_id =3D scsi_id;
 	tgt->new_scsi_id =3D scsi_id;
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljq6rEACgkQOeye3VZi
gbngbQ//XtuQiu7ppun4sOfhtZVgLW+G1k4u3zn7N4O+u4gvRO7Cb5Ki9jq6Nx58
aiHnOOJbBdBupSowZe/kfHeNGQCgk3/BdvVq48i5A33OmVJhcKRHPJpinI+Y11Ei
WguYoeqjokO9aaNEVQ8X3SD0mz/L5su3oF3dxIPKjW1KsWOD1iAjjrINw03YrqOP
OQCOsvENbwThBAxqdIN6LIexcHycdiR7g6bxx35ywzefNy6JGWz2+fJs1RXTYRWk
yTq75+622ek0qACG3uWWT3WwGzqMrcTWK8UhVVnge4eQGBJuwqzXJuNBAZnIjokQ
bMyPwuoSexEx0kalL7IUxpvmzLzt1X4NITTu349vd33ZVA7WX3EJtW5I82W3Auyj
ORQU328e4rAJooccDKCue2ZxNs/FPBw5OjCRyGGd43cf2oBKFyLZGMRgBiLypbgf
TSyQTlee2W55KA0/4C24PAeUuDqDgB1EN+QH8mk5+pRgj1cOI+I3TJGDil3ptwpW
T5FY5xUqbD/Z5kZIT8IHyVyZOeA3sOnGf1b+LOGODzw1W0ld/2PV9RS8jYbAsJgN
Y12amk5eleKT7/Pu5Og41gq3FByL+9ml5jJvtVGrJ2EVPihB6y4bVyfHakYfTeKK
pBHGA3S2ywZA+jO3i8MMPoIJfbIhutXNZkJbA9Wf8bICNsaWQ1U=
=Gvh/
-----END PGP SIGNATURE-----
--=-=-=--
