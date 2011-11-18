From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] be2iscsi: fix chip cleanup
Date: Fri, 18 Nov 2011 10:57:00 +0300
Message-ID: <20111118075659.GE4349@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lb0e7rgc7IsuDeGj"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:37737 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab1KRHzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2011 02:55:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jayamohan,

My static checker complains about 069adc7b061 "[SCSI] be2iscsi: fix
chip cleanup"

--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -202,8 +202,8 @@ int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigne=
d short chute)
                           OPCODE_COMMON_ISCSI_CLEANUP, sizeof(*req));
=20
        req->chute =3D chute;
-       req->hdr_ring_id =3D 0;
-       req->data_ring_id =3D 0;
+       req->hdr_ring_id =3D cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba));
            ^^^^^^^^^^^^
+       req->data_ring_id =3D cpu_to_le16(HWI_GET_DEF_BUFQ_ID(phba));
            ^^^^^^^^^^^^^

These two are only 8 bits so we lose part of the le16 value.  My
guess is that we can just remove the calls to cpu_to_le16() and
save the lower bits, since that what this code does on Intel.  But I
don't know this subsystem.

In mgmt_open_connection() ->hdr_ring_id is a 16bit field, but we just
store a CPU endian HWI_GET_DEF_HDRQ_ID() into it.

regards,
dan carpenter


--Lb0e7rgc7IsuDeGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxg/LAAoJEOnZkXI/YHqRcgcQAJV45xCGg8zLPFIHgRT3yFKG
LcETMnhEWqZQr6Sduo2I6ZXUe4/CzFZnwWxEs8aLWFm2aZFUqoUwUuomfILDF4+Q
1tiPvcQWSozyhZ7gGvji+st9qcDr3XuoLKrl04vzqDrvPhDAPPyaPhY8wAAhZyRj
GNa/RToY4vpnDzAqW0j4ldHuVos3TvG5d9CoNv7Sg7YWXyIWp13YH7STWdqEDNi5
nzJPtYfFdqgQcGsVS/iBIwMM74+NsNCBaNmBnMtOPV61Ysx5sjvlGMFSvnV4mvbK
Xd74caSJgSA9V8x2hAk5Jgf82qlL/LCEoPUoqrYNJZqLVfqL0s/30L6/Jdt3tiRi
tqI69k7tauN3/az9PuNDoGMeyGJNz5i6PGZZ3pQ9oy7E2lBiQerck+zHDzcAk+Qs
B8BMo4QGCSdKvo9hVRAnwO0uqYVAxvBlix28cE7LSa4lre9GoZc+zWECByvUUZjg
4oSt1WwGzRhlurFqKJncJHnRJtvXPcDiizPhK56qUTqT++isZDCvJLoJLAUfAIVJ
ey4kruj8d42GjBHHs+UMZwupTfUVKoP+jHeH+hHho8kqi4dRJGFEniaOJoKaVbzI
ZSeZAiqMBp30UvpgudMckgCh+G2Cda8o+NvJV8Oui7Djkg+HTtIwdas8RGnTuwdb
QY3NTv1BxUYwriVdTtPk
=dwMF
-----END PGP SIGNATURE-----

--Lb0e7rgc7IsuDeGj--
