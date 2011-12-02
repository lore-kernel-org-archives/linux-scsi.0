From: Stratos Psomadakis <psomas@gentoo.org>
Subject: [SCSI] NULL pointer dereference in sym53c8xx (bisected)
Date: Fri, 02 Dec 2011 17:26:20 +0200
Message-ID: <4ED8EE1C.4090404@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCB5596E22225BED68BC8E22B"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, gregkh@suse.de, linux-scsi@vger.kernel.org, JBottomley@parallels.com, matthew@wil.cx, Martin.vGagern@gmx.net, kernel@gentoo.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCB5596E22225BED68BC8E22B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

After upstream commit 4e6c82b3614a18740ef63109d58743a359266daf ([SCSI]
fix WARNING: at drivers/scsi/scsi_lib.c:1704), which is also included in
3.0-stable and 3.1-stable kernels, the kernel fails to boot (NULL
pointer dereference in sym53c8xx_slave_destroy).

Bug report at the Gentoo Bugzilla (reported and bisected by Martin von
Gagern). [1]  (stack trace [2])

I think that the problem is that (after commit 4e6c82b)
__scsi_remove_device() is called if slave_alloc() in scsi_alloc_sdev()
fails. But __scsi_remove_device() calls slave_destroy(), which (I think)
doesn't make much sense (ie to call slave_destroy() when slave_alloc()
fails).

For sym53c8xx, this results in a NULL pointer dereference (struct
sym_lcb pointer) in slave_destroy().

[1] https://bugs.gentoo.org/show_bug.cgi?id=3D392567
[2] https://392567.bugs.gentoo.org/attachment.cgi?id=3D294381

--=20
Stratos Psomadakis
<psomas@gentoo.org>



--------------enigCB5596E22225BED68BC8E22B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7Y7iQACgkQid1lVeNDMmAxfACfYlTiR0gHMzFSYXZb/Hic1H3p
st8An0jGY3UOYc2mD3vLLU95fJI+HMxB
=2FGp
-----END PGP SIGNATURE-----

--------------enigCB5596E22225BED68BC8E22B--
