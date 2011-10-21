From: Petr Uzel <petr.uzel@suse.cz>
Subject: [PATCH] st: fix race in st_scsi_execute_end
Date: Fri, 21 Oct 2011 13:31:09 +0200
Message-ID: <20111021113108.GA26181@foxbat.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Willem Riede <osst@riede.org>
Cc: jack@suse.cz, linux-scsi@vger.kernel.org, juergen.gross@ts.fujitsu.com
List-Id: linux-scsi@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The call to complete() in st_scsi_execute_end() wakes up sleeping thread
in write_behind_check(), which frees the st_request, thus invalidating
the pointer to the associated bio structure, which is then passed to the
blk_rq_unmap_user(). Fix by storing pointer to bio structure into
temporary local variable.

This bug is present since at least linux-2.6.32.

CC: stable@kernel.org
Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
Reported-by: Juergen Gro=DF <juergen.gross@ts.fujitsu.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 drivers/scsi/st.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1871b8a..9b28f39 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -462,14 +462,16 @@ static void st_scsi_execute_end(struct request *req, =
int uptodate)
 {
 	struct st_request *SRpnt =3D req->end_io_data;
 	struct scsi_tape *STp =3D SRpnt->stp;
+	struct bio *tmp;
=20
 	STp->buffer->cmdstat.midlevel_result =3D SRpnt->result =3D req->errors;
 	STp->buffer->cmdstat.residual =3D req->resid_len;
=20
+	tmp =3D SRpnt->bio;
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
=20
-	blk_rq_unmap_user(SRpnt->bio);
+	blk_rq_unmap_user(tmp);
 	__blk_put_request(req->q, req);
 }
=20
--=20
1.7.3.4


Petr

--
Petr Uzel
IRC: ptr_uzl @ freenode

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk6hV/wACgkQnZxG0T6qDD33dwCfYtwcpkuAUN9DOIv0IJrHxFOJ
GOcAnimW3duyDk55HgkwXCaxtEE48b7i
=GQ9t
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
