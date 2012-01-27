From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] target: handle empty string writes in sysfs
Date: Fri, 27 Jan 2012 15:50:55 +0300
Message-ID: <20120127125055.GT3294@mwanda>
References: <20120124084036.GB29097@elgon.mountain>
 <4F1E8E31.1070507@bfs.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3T2jnoiI0lx9XXvh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:48282 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab2A0Mtk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2012 07:49:40 -0500
Content-Disposition: inline
In-Reply-To: <4F1E8E31.1070507@bfs.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org


--3T2jnoiI0lx9XXvh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

These are root only and we're not likely to hit the problem in practise,
but it makes the static checkers happy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: only set ->su_dev_flags on success.

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_=
core_configfs.c
index 0955bb8..6e043ee 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1704,13 +1704,15 @@ static ssize_t target_core_store_dev_alias(
 		return -EINVAL;
 	}
=20
-	se_dev->su_dev_flags |=3D SDF_USING_ALIAS;
 	read_bytes =3D snprintf(&se_dev->se_dev_alias[0], SE_DEV_ALIAS_LEN,
 			"%s", page);
-
+	if (!read_bytes)
+		return -EINVAL;
 	if (se_dev->se_dev_alias[read_bytes - 1] =3D=3D '\n')
 		se_dev->se_dev_alias[read_bytes - 1] =3D '\0';
=20
+	se_dev->su_dev_flags |=3D SDF_USING_ALIAS;
+
 	pr_debug("Target_Core_ConfigFS: %s/%s set alias: %s\n",
 		config_item_name(&hba->hba_group.cg_item),
 		config_item_name(&se_dev->se_dev_group.cg_item),
@@ -1753,13 +1755,15 @@ static ssize_t target_core_store_dev_udev_path(
 		return -EINVAL;
 	}
=20
-	se_dev->su_dev_flags |=3D SDF_USING_UDEV_PATH;
 	read_bytes =3D snprintf(&se_dev->se_dev_udev_path[0], SE_UDEV_PATH_LEN,
 			"%s", page);
-
+	if (!read_bytes)
+		return -EINVAL;
 	if (se_dev->se_dev_udev_path[read_bytes - 1] =3D=3D '\n')
 		se_dev->se_dev_udev_path[read_bytes - 1] =3D '\0';
=20
+	se_dev->su_dev_flags |=3D SDF_USING_UDEV_PATH;
+
 	pr_debug("Target_Core_ConfigFS: %s/%s set udev_path: %s\n",
 		config_item_name(&hba->hba_group.cg_item),
 		config_item_name(&se_dev->se_dev_group.cg_item),

--3T2jnoiI0lx9XXvh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIp2uAAoJEOnZkXI/YHqR130P/R3GshEG6EUHDfv2OSuAAzWW
nlV27hFGvPyLz1K1rd/2RDu8qvhGXjzLA+avBJySLMAKSpDm1c9HEhvM3aN+gAQr
rqLUX3HCyX6AdeHaXzyV3nFgaVske0fHgtF+b6QUGX7t0186fHJ6IMMLQKITUhJ6
6P4fhQuR7b0BH1MG9OWRDYqy2SyoyzIJforPEkFYQNSWjor5EIDU4luwU6FMF8ev
GgHHNT+Llmi67txhgrsmu29N1FS0unl2LRg9x/49FKgZH4QSV2uinUiMGzz29rIi
kJDAvQ1Q5s2HYg10pGaZglrPMp4lGR7UJ1m1uHRb/eofg/Ob8ZU2q9qjfM79hazL
o5PrCuZAAwh/rd0EVmSiVkI9h3FcHk5VWnSavtL5qq5r/iR8A+XwBbszu2rBtaBD
yTo5TWpgXC7OK5SL5/2c3M4ljpsiZKfvHA2/nveJQUGMi0/kQPXEUMER+f8ZCEnp
bA7v+A/REHgwIEGdp5ROb+mP9Bqz/tmU35jAvIC3SVBYuZeLpHYvDBkX2zzv5V7i
HseGLrLGY2i25p2aKoy+BpkEsT5N6iN4thL+HeCKHycsel12TSTRQkahsWQ474j+
Ynh40nxxPUruS3ZM7k7ShLdoj0WxdT7A4OOl5tJJ88Uz6U89YZyjCtkhxx/Ureaz
OQZ+JZRMSRZaXxSA0LRj
=jgDj
-----END PGP SIGNATURE-----

--3T2jnoiI0lx9XXvh--
