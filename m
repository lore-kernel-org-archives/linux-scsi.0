From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 3/7] [SCSI] powerpc: remove the legacy iSeries part of
 ibmvscsi
Date: Thu, 8 Mar 2012 15:35:38 +1100
Message-ID: <20120308153538.5f466c64807973648452afa3@canb.auug.org.au>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_15_35_38_+1100_+7atrA6t1+8e+Iwa"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:46793 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2CHEnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2012 23:43:41 -0500
In-Reply-To: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>, LKML <linux-kernel@vger.kernel.org>

--Signature=_Thu__8_Mar_2012_15_35_38_+1100_+7atrA6t1+8e+Iwa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The PowerPC legacy iSeries platform is being removed and this code is
no longer selectable.  There is more clean up that can be done, but this
just gets the old code out of the way.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/Kconfig                  |    3 +-
 drivers/scsi/ibmvscsi/Makefile        |    1 -
 drivers/scsi/ibmvscsi/ibmvscsi.c      |   12 +--
 drivers/scsi/ibmvscsi/ibmvscsi.h      |    1 -
 drivers/scsi/ibmvscsi/iseries_vscsi.c |  173 -----------------------------=
----
 5 files changed, 3 insertions(+), 187 deletions(-)
 delete mode 100644 drivers/scsi/ibmvscsi/iseries_vscsi.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 16570aa..e38d843 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -967,9 +967,8 @@ config SCSI_IPS
=20
 config SCSI_IBMVSCSI
 	tristate "IBM Virtual SCSI support"
-	depends on PPC_PSERIES || PPC_ISERIES
+	depends on PPC_PSERIES
 	select SCSI_SRP_ATTRS
-	select VIOPATH if PPC_ISERIES
 	help
 	  This is the IBM POWER Virtual SCSI Client
=20
diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
index a423d96..ff5b5c5 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_SCSI_IBMVSCSI)	+=3D ibmvscsic.o
=20
 ibmvscsic-y			+=3D ibmvscsi.o
-ibmvscsic-$(CONFIG_PPC_ISERIES)	+=3D iseries_vscsi.o=20
 ibmvscsic-$(CONFIG_PPC_PSERIES)	+=3D rpa_vscsi.o=20
=20
 obj-$(CONFIG_SCSI_IBMVSCSIS)	+=3D ibmvstgt.o
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvs=
csi.c
index 3d391dc..e984951 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -55,13 +55,7 @@
  * and sends a CRQ message back to inform the client that the request has
  * completed.
  *
- * Note that some of the underlying infrastructure is different between
- * machines conforming to the "RS/6000 Platform Architecture" (RPA) and
- * the older iSeries hypervisor models.  To support both, some low level
- * routines have been broken out into rpa_vscsi.c and iseries_vscsi.c.
- * The Makefile should pick one, not two, not zero, of these.
- *
- * TODO: This is currently pretty tied to the IBM i/pSeries hypervisor
+ * TODO: This is currently pretty tied to the IBM pSeries hypervisor
  * interfaces.  It would be really nice to abstract this above an RDMA
  * layer.
  */
@@ -2085,9 +2079,7 @@ int __init ibmvscsi_module_init(void)
 	driver_template.can_queue =3D max_requests;
 	max_events =3D max_requests + 2;
=20
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		ibmvscsi_ops =3D &iseriesvscsi_ops;
-	else if (firmware_has_feature(FW_FEATURE_VIO))
+	if (firmware_has_feature(FW_FEATURE_VIO))
 		ibmvscsi_ops =3D &rpavscsi_ops;
 	else
 		return -ENODEV;
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvscsi/ibmvs=
csi.h
index 02197a2..c503e17 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.h
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
@@ -127,7 +127,6 @@ struct ibmvscsi_ops {
 	int (*resume) (struct ibmvscsi_host_data *hostdata);
 };
=20
-extern struct ibmvscsi_ops iseriesvscsi_ops;
 extern struct ibmvscsi_ops rpavscsi_ops;
=20
 #endif				/* IBMVSCSI_H */
diff --git a/drivers/scsi/ibmvscsi/iseries_vscsi.c b/drivers/scsi/ibmvscsi/=
iseries_vscsi.c
deleted file mode 100644
index f477645..0000000
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_15_35_38_+1100_+7atrA6t1+8e+Iwa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWDcaAAoJEECxmPOUX5FEPLQP/0S/CDVMUkn2Cyj719p+1eta
A+DpHLKao+NaGMAngY4ZHdcDDyEZKPNP+7kU8okUuNG8vhj8j8RlpVIBzx5XIlSB
w0hKHHveGO2mIHt3VrLs7RBzJP3DRr2xo1fTVp0ur22Wrby6tbcyv2tiuXzd/dMt
EobbbN+JJsdNrwfPaXI6Z+kA47YDv3ir7um0qKGhholaHIctpUBlT1IR86mOIxm8
6m3IxlYFxIk7i6kudRAknLfJ06E1xa4VY6rgEvG1mvozjWMiU7z6bIYyGxHOs8Oa
cgKMiEJc0XaIbxPTJ7Ig9TMF0QZEAQhsLJg+/W29mKFkSLaA9aUYDNcA3QiPLtcy
DRJzlQQo1E492yfNtvPiEwNFsjdW5yQGVYr3mRIoU5Ed6akRRpSzQ7D7kWbPuXhA
NUIWu3mf0R5M+8bVbpHWg1q8nNLv6qxkSJX0OaquLtRTsrZedLBpbaqqQl2fsqFc
ybsvnVV9K321djfsyRV7Rxok+P3NeTubwlCKJqByVHM18KgSdFa6qtr87NqCTWIv
G9IoUA7OJWKpbqQZzoKgCWhnJ+KQpnkBWm+BqthsFqhZkZEgDvG1AehUNNUztefn
DySrqSnJIwyX1gZIrincIYXdgO3ET0wyic1XHS9b6zpAxJWcKGHosae87KbWrzsx
+0kQCJIWBu5aOfgkVzzb
=UXvv
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_15_35_38_+1100_+7atrA6t1+8e+Iwa--
