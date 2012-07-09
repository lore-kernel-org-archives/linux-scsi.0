From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] [SCSI] suppress a warning in mpt2sas
Date: Mon, 9 Jul 2012 10:35:44 +1000
Message-ID: <20120709103544.a8e356f2981249277ab26c3c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jul_2012_10_35_44_+1000_OKFVEdpOjNOP32xL"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Eric Moore <eric.moore@lsi.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Mon__9_Jul_2012_10_35_44_+1000_OKFVEdpOjNOP32xL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Suppress this warning:

drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function '_scsih_sas_broadcast_pri=
mitive_event':
drivers/scsi/mpt2sas/mpt2sas_scsih.c:5811:40: warning: unused variable 'eve=
nt_data' [-Wunused-variable]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/mpt2sas/mpt2sas_debug.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

After this patch, the same code is generated.  This is relative to Linus tr=
ee.

diff --git a/drivers/scsi/mpt2sas/mpt2sas_debug.h b/drivers/scsi/mpt2sas/mp=
t2sas_debug.h
index 9731f8e..2a6516e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_debug.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_debug.h
@@ -79,7 +79,11 @@
 		CMD;						\
 }
 #else
-#define MPT_CHECK_LOGGING(IOC, CMD, BITS)
+#define MPT_CHECK_LOGGING(IOC, CMD, BITS)			\
+{								\
+	if (0 & IOC->logging_level & BITS)			\
+		CMD;						\
+}
 #endif /* CONFIG_SCSI_MPT2SAS_LOGGING */
=20
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__9_Jul_2012_10_35_44_+1000_OKFVEdpOjNOP32xL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+idgAAoJEECxmPOUX5FEHDcQAJ2Vb38XfgZw+ZNP2vppk1HA
ODRQppn5mXwBLHjuD1lWeYS+ACbLQ994mMC9A0pJ3VEqse8hQHSqVSxVmdJv07JR
kaGibW4SRKsD6yjB5JsofBqIjUmCfFsrpBDOpHFAHwupT1H00rK8CqHUW80PhSR2
E1icED6e7eqxJnokRBiKGZetgOvcOUHpRF/m5hL694kAKkwwKK+lh5SvLneQagM8
qdWW1gkw2cDu4ebsqAaNox6NpGHra6b3JLjux/450g9QNXVVTsfXdutE6h70IzwB
aqhTCpKL84qyIBVMFLUKJuLUMaBD2Okxg/nORXNDGDmbMZhH/lat7Osrcb/SOuHX
VKdhzQmYxaWoeN/Jiuy9XrUPpB5BHVsYBDmJQGyH1BSs9dITcxXawz2QW1mwmBNl
/JJR0VVZ9S9cHY2XhP4LQ10xOnl3q4cY4fd+aosF3uZ36xMzfMZrEkKsXpyvwdOE
8TgasSCIZ/SMdl899ZitC8BdwpOYxY6Sz3LmBfgwb/DiEZO+kPJQjzXiRvGXEYR2
1msWny03MPfzTLhvldcUX89jay8LI25Iec1BzJ6HUAdozRtsJy6ZdwHxMp3W6arc
RayHoFuR27/XrdZJOBSM78J+e3EVfoD6wCl79Lo8N7W6cOhBHIWIqkv/BXUuQzYX
Bf/GNGyC2I1rRzBjBnMi
=FRee
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jul_2012_10_35_44_+1000_OKFVEdpOjNOP32xL--
