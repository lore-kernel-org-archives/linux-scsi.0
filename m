From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] virtio scsi: fix unused variable warning
Date: Tue, 30 Jun 2015 10:59:04 +1000
Message-ID: <20150630105904.4c3d46b1@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bf/MqTt3Qc1uDFShG7Fam9/"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:56401 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbbF3A7L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2015 20:59:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>

--Sig_/bf/MqTt3Qc1uDFShG7Fam9/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fixes:

drivers/scsi/virtio_scsi.c: In function 'virtscsi_probe':
drivers/scsi/virtio_scsi.c:952:11: warning: unused variable 'host_prot' [-W=
unused-variable]
  int err, host_prot;
           ^

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/virtio_scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 285f77544c36..7dbbb29d24c6 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -949,7 +949,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 {
 	struct Scsi_Host *shost;
 	struct virtio_scsi *vscsi;
-	int err, host_prot;
+	int err;
 	u32 sg_elems, num_targets;
 	u32 cmd_per_lun;
 	u32 num_queues;
@@ -1009,6 +1009,8 @@ static int virtscsi_probe(struct virtio_device *vdev)
=20
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {
+		int host_prot;
+
 		host_prot =3D SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
 			    SHOST_DIF_TYPE3_PROTECTION | SHOST_DIX_TYPE1_PROTECTION |
 			    SHOST_DIX_TYPE2_PROTECTION | SHOST_DIX_TYPE3_PROTECTION;
--=20
2.1.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/bf/MqTt3Qc1uDFShG7Fam9/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVkendAAoJEMDTa8Ir7ZwVskIP/1oRCHoeDiz4Fs8h/pqBg6/L
Vm4OUTZtRXDyNYSd2HDauqc23+jy6CKDcb6S9EMm8iCoAvLYrZxrEzsBT5YJ2CHC
inONSDSqesD+U6vsXjwqxIWdrq7SP0PoMa+eoMdAELCJf6pJV4Tt2LpdwIEGw28T
kohfHes+DvBQ9gRa7xaFXj+6Hy1G44faBO+oq1OP6qbgfGqacoWJCtOd3xtarmzN
Z3jc3MGXdQZk2adoWvrrIjmOgJp9dZesD7YtDfEBPm/hyzJZ5wX5T+4P9UFiBgYo
7ytftk6eNZoJEm0ChVGJXYXqcY8PVIdPjsjzi+f6WMb9D3wQXxaFEzCasEQCSA8Q
kQDHWr8XQNPE3cwAaziw18E/ArT9+2cEkDLPQE/6drE2jvfTVYBcfn04SmnFdgJm
vsk4+XaoLBidA4iUkMdvyIpqOKbK8YqmSy+OJ9qkjBKFUDyMPqvI3nF+78+stcXq
Qh8d+0JrQAPAmqVP2KQGChcjHRBKmfhEr9YPXuQFKGHIexeSdQTNNpyroaOZNhnM
zphXbSGppC/62LUlrJ5CM9EJgOJnIAFjy8EuVA47FhQIo44zyFXb8smsPZTl+ktE
NuIdm1gsQSoqO7qvTnfelAS2PPoODzWXv8Ohr16IA2WUpJWOjH/AC0zSnUyK3Tut
os2R9HSR66zrS8w589kI
=q0Xc
-----END PGP SIGNATURE-----

--Sig_/bf/MqTt3Qc1uDFShG7Fam9/--
