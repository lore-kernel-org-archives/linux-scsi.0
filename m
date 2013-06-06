From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] [SCSI] mpt2sas: fix build warning
Date: Thu, 6 Jun 2013 17:53:16 +1000
Message-ID: <20130606175316.e81a7ca7361d6223369b0e45@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Jun_2013_17_53_16_+1000_LjznmZpG=+T+bJNs"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Thu__6_Jun_2013_17_53_16_+1000_LjznmZpG=+T+bJNs
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fixes this warning:

drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function =E2=80=98_scsih_sas_broad=
cast_primitive_event=E2=80=99:
drivers/scsi/mpt2sas/mpt2sas_scsih.c:5810:40: warning: unused variable =E2=
=80=98event_data=E2=80=99 [-Wunused-variable]

when CONFIG_SCSI_MPT2SAS_LOGGING is not enabled.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/mpt2sas/mpt2sas_debug.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Equivalent patches for drivers/message/fusion/mptdebug.h and
drivers/scsi/mpt3sas/mpt3sas_debug.h would fix similar, but to me
theoretical, warnings.

diff --git a/drivers/scsi/mpt2sas/mpt2sas_debug.h b/drivers/scsi/mpt2sas/mp=
t2sas_debug.h
index 69cc7d0..18b9a0c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_debug.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_debug.h
@@ -79,7 +79,11 @@
 		CMD;						\
 }
 #else
-#define MPT_CHECK_LOGGING(IOC, CMD, BITS)
+#define MPT_CHECK_LOGGING(IOC, CMD, BITS)			\
+{								\
+	if (0)							\
+		CMD;						\
+}
 #endif /* CONFIG_SCSI_MPT2SAS_LOGGING */
=20
=20
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Jun_2013_17_53_16_+1000_LjznmZpG=+T+bJNs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsD/sAAoJEECxmPOUX5FEAzkP/Rxi2qAS2T57c/y3kP4MJ58o
uDxZyh25FR3xcBCuAImG2CkvYKftFsNeu6qrQejQ+YN5D+MJnSFKjRxnSBaNJpM1
OhKtapEedggAR5xGc2RJ9bj8tMZQu0AxxfDDBuvZtBhYz9ZwiLSnDMRk8woC6QKd
TZN/AtZScadz0xzrXhJC3hWU0rBHmQSxNWQGHGrV4z1WyGNPD1YthPH2suPhlt2I
ZVLhwUqP9rA8zafaG/vUe3MTXLlQgJyoQbVUxkgiGo7i7FlMxrYJYYADFbVqwH5S
3ubhTXXeA2vaSwT8h2pdNTiebXoothyRjDeqDdkrs7bGa0wxmbMlNHasbJPhMoA9
YLkvmZHCZYcL3mWUGMGy3YDumvHh6iaPChBC2ARjxNpxjr6UCwO4YSP36k2oiWh6
bo385yfDoc5klkpTZxsdPjvVKOgT3b1R1ypOGIrYMI/Ao+3aMVIqmSpjf7lKbh4A
/FqWAc7fTOaNl+VwfBQL7drVWOG+HqAtxWqqflMI22g7/enMu8F2llM3eOdQ6JLR
pAqj5G74zX577MeYfcn6XorcJOQq3/f2AXBloncUbzD7zCYHzwEl6os1wudJyMc8
RCVeeLptorGiMtXxC+H1fvA8P8vAnnJyn1WmY6A0/qPF8AqPjyVpu/z0b3Yb4J1z
DEUwW2Ufo4YMWrwzyW68
=eE70
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jun_2013_17_53_16_+1000_LjznmZpG=+T+bJNs--
