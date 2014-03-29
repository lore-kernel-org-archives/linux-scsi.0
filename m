From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 31/55] scsi: Mark functions as static in mvsas/mv_sas.c
Date: Sat, 29 Mar 2014 23:49:26 +0530
Message-ID: <36003591ecb5adf76db0306aa63b2f6b2d208e43.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>, Masanari Iida <standby24x7@gmail.com>, Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in mvsas/mv_sas.c because they are not used
outside this file.

This eliminates the following warnings in mvsas/mv_sas.c:
drivers/scsi/mvsas/mv_sas.c:77:18: warning: no previous prototype for =E2=
=80=98mvs_find_dev_mvi=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:105:5: warning: no previous prototype for =E2=
=80=98mvs_find_dev_phyno=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1260:20: warning: no previous prototype for=
 =E2=80=98mvs_alloc_dev=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1277:6: warning: no previous prototype for =
=E2=80=98mvs_free_dev=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1287:5: warning: no previous prototype for =
=E2=80=98mvs_dev_found_notify=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1343:6: warning: no previous prototype for =
=E2=80=98mvs_dev_gone_notify=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1709:6: warning: no previous prototype for =
=E2=80=98mvs_set_sense=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1748:6: warning: no previous prototype for =
=E2=80=98mvs_fill_ssp_resp_iu=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/mvsas/mv_sas.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 6c1f223..80c2b1d 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -74,7 +74,7 @@ void mvs_tag_init(struct mvs_info *mvi)
 		mvs_tag_clear(mvi, i);
 }
=20
-struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
+static struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 {
 	unsigned long i =3D 0, j =3D 0, hi =3D 0;
 	struct sas_ha_struct *sha =3D dev->port->ha;
@@ -102,7 +102,7 @@ struct mvs_info *mvs_find_dev_mvi(struct domain_dev=
ice *dev)
=20
 }
=20
-int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
+static int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
 {
 	unsigned long i =3D 0, j =3D 0, n =3D 0, num =3D 0;
 	struct mvs_device *mvi_dev =3D (struct mvs_device *)dev->lldd_dev;
@@ -1257,7 +1257,7 @@ void mvs_port_deformed(struct asd_sas_phy *sas_ph=
y)
 	mvs_port_notify_deformed(sas_phy, 1);
 }
=20
-struct mvs_device *mvs_alloc_dev(struct mvs_info *mvi)
+static struct mvs_device *mvs_alloc_dev(struct mvs_info *mvi)
 {
 	u32 dev;
 	for (dev =3D 0; dev < MVS_MAX_DEVICES; dev++) {
@@ -1274,7 +1274,7 @@ struct mvs_device *mvs_alloc_dev(struct mvs_info =
*mvi)
 	return NULL;
 }
=20
-void mvs_free_dev(struct mvs_device *mvi_dev)
+static void mvs_free_dev(struct mvs_device *mvi_dev)
 {
 	u32 id =3D mvi_dev->device_id;
 	memset(mvi_dev, 0, sizeof(*mvi_dev));
@@ -1284,7 +1284,7 @@ void mvs_free_dev(struct mvs_device *mvi_dev)
 	mvi_dev->taskfileset =3D MVS_ID_NOT_MAPPED;
 }
=20
-int mvs_dev_found_notify(struct domain_device *dev, int lock)
+static int mvs_dev_found_notify(struct domain_device *dev, int lock)
 {
 	unsigned long flags =3D 0;
 	int res =3D 0;
@@ -1340,7 +1340,7 @@ int mvs_dev_found(struct domain_device *dev)
 	return mvs_dev_found_notify(dev, 1);
 }
=20
-void mvs_dev_gone_notify(struct domain_device *dev)
+static void mvs_dev_gone_notify(struct domain_device *dev)
 {
 	unsigned long flags =3D 0;
 	struct mvs_device *mvi_dev =3D dev->lldd_dev;
@@ -1706,7 +1706,7 @@ static int mvs_sata_done(struct mvs_info *mvi, st=
ruct sas_task *task,
 	return stat;
 }
=20
-void mvs_set_sense(u8 *buffer, int len, int d_sense,
+static void mvs_set_sense(u8 *buffer, int len, int d_sense,
 		int key, int asc, int ascq)
 {
 	memset(buffer, 0, len);
@@ -1745,8 +1745,8 @@ void mvs_set_sense(u8 *buffer, int len, int d_sen=
se,
 	return;
 }
=20
-void mvs_fill_ssp_resp_iu(struct ssp_response_iu *iu,
-				u8 key, u8 asc, u8 asc_q)
+static void mvs_fill_ssp_resp_iu(struct ssp_response_iu *iu,
+				 u8 key, u8 asc, u8 asc_q)
 {
 	iu->datapres =3D 2;
 	iu->response_data_len =3D 0;
--=20
1.7.9.5
