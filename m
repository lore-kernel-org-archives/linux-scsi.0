From: NeilBrown <neilb@suse.com>
Subject: [PATCH] virtio_scsi: don't check for failure from mempool_alloc()
Date: Mon, 10 Apr 2017 12:16:28 +1000
Message-ID: <8760idxb0j.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


mempool_alloc() cannot fail when passed GFP_NOIO or any
other gfp setting that is permitted to sleep.
So remove this pointless code.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/scsi/virtio_scsi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 939c47df73fa..7c2a5f7c5fb7 100644
=2D-- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -688,9 +688,6 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
=20
 	sdev_printk(KERN_INFO, sc->device, "device reset\n");
 	cmd =3D mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
=2D	if (!cmd)
=2D		return FAILED;
=2D
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->sc =3D sc;
 	cmd->req.tmf =3D (struct virtio_scsi_ctrl_tmf_req){
@@ -725,9 +722,6 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
=20
 	scmd_printk(KERN_INFO, sc, "abort\n");
 	cmd =3D mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
=2D	if (!cmd)
=2D		return FAILED;
=2D
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->sc =3D sc;
 	cmd->req.tmf =3D (struct virtio_scsi_ctrl_tmf_req){
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljq6vwACgkQOeye3VZi
gblVPxAAuLMOoIJ5M2xgzHOp1hZDzF0Y96A64DmWvN4SjMMyWT4nkHr+HdyCCnJA
uvcnlmHnIZ0FjH+DuhRmdUXgisNxDC8zjwYqfRn9XkEBYnGPz3X0gcorsxlb+TR5
ea2zEwWMfD1n1mP72OGK1acHjFByvtHCx+UChTVuzgETcT8Of7ObWzP5NHPOdatL
GGn3X7LZpML6mXAJRkTSpOA80nsbFVQ4z0xfdR33c8nvNU/Ixwm2LAR4W90Rghhf
QdRRVNgbTqXZQMJIv/CFYAWJR9PCVaPvQl+9FWh+J4odbkYFTJPUqtJy6nOx2UgX
FsW05+viOV54QbBRe0s3wZsSfm7Fsew2cZpalZ5aaK7fDTw0FQIu9syFpHSas1th
o8teScPaEBmlk3u1rZhqQOjphw+C+Q8n1IvqtzFD2KS8kFm6AVhpUvAtcQVx5zQA
8SkV4WRoan65o5Z4LD3VVkkD6LcggmHtVgFuYvIGrTE44xvzyQbyQJCjxfaafwni
O59YYVZ2Ovc2zTLcDMA/Rf1tMabJ8SeKcfBOfIpC7Jm6Lth0+lA9w39EYp9o0eWo
MaxK8Uju1je4SyTvsKr3fYy33y33R1kIV5cfeBYjNm3yxRDhU4AaCnwkZAoO40i8
yFW9VQXztTep93Pnjjo7rzQmI5IXKX6zCOqhXmx8lEaKTB0ZjC0=
=hGWW
-----END PGP SIGNATURE-----
--=-=-=--
