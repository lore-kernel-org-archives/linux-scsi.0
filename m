From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 32/55] scsi: Mark functions as static in mvsas/mv_64xx.c
Date: Sat, 29 Mar 2014 23:50:37 +0530
Message-ID: <3ceb3e7560a62f8411760c499b096c06bfa74007.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56859 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaC2SUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Mar 2014 14:20:12 -0400
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org

Mark functions as static in mvsas/mv_64xx.c because they are not used
outside this file.

This eliminates the following warnings in mvsas/mv_64xx.c:
drivers/scsi/mvsas/mv_64xx.c:139:6: warning: no previous prototype for =
=E2=80=98mvs_64xx_clear_srs_irq=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:566:6: warning: no previous prototype for =
=E2=80=98mvs_64xx_make_prd=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:636:6: warning: no previous prototype for =
=E2=80=98mvs_64xx_phy_set_link_rate=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:671:5: warning: no previous prototype for =
=E2=80=98mvs_64xx_spi_read_data=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:677:6: warning: no previous prototype for =
=E2=80=98mvs_64xx_spi_write_data=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:684:5: warning: no previous prototype for =
=E2=80=98mvs_64xx_spi_buildcmd=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:708:5: warning: no previous prototype for =
=E2=80=98mvs_64xx_spi_issuecmd=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:723:5: warning: no previous prototype for =
=E2=80=98mvs_64xx_spi_waitdataready=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:738:6: warning: no previous prototype for =
=E2=80=98mvs_64xx_fix_dma=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/mvsas/mv_64xx.c |   35 ++++++++++++++++++----------------=
-
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.=
c
index 8bb0699..2420386 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -136,7 +136,8 @@ static void mvs_64xx_phy_reset(struct mvs_info *mvi=
, u32 phy_id, int hard)
 	}
 }
=20
-void mvs_64xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear=
_all)
+static void mvs_64xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set,
+				   u8 clear_all)
 {
 	void __iomem *regs =3D mvi->regs;
 	u32 tmp;
@@ -563,7 +564,7 @@ static u8 mvs_64xx_assign_reg_set(struct mvs_info *=
mvi, u8 *tfs)
 	return MVS_ID_NOT_MAPPED;
 }
=20
-void mvs_64xx_make_prd(struct scatterlist *scatter, int nr, void *prd)
+static void mvs_64xx_make_prd(struct scatterlist *scatter, int nr, voi=
d *prd)
 {
 	int i;
 	struct scatterlist *sg;
@@ -633,8 +634,8 @@ static void mvs_64xx_phy_work_around(struct mvs_inf=
o *mvi, int i)
 	mvs_write_port_vsr_data(mvi, i, tmp);
 }
=20
-void mvs_64xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
-			struct sas_phy_linkrates *rates)
+static void mvs_64xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_i=
d,
+				struct sas_phy_linkrates *rates)
 {
 	u32 lrmin =3D 0, lrmax =3D 0;
 	u32 tmp;
@@ -668,26 +669,26 @@ static void mvs_64xx_clear_active_cmds(struct mvs=
_info *mvi)
 }
=20
=20
-u32 mvs_64xx_spi_read_data(struct mvs_info *mvi)
+static u32 mvs_64xx_spi_read_data(struct mvs_info *mvi)
 {
 	void __iomem *regs =3D mvi->regs_ex;
 	return ior32(SPI_DATA_REG_64XX);
 }
=20
-void mvs_64xx_spi_write_data(struct mvs_info *mvi, u32 data)
+static void mvs_64xx_spi_write_data(struct mvs_info *mvi, u32 data)
 {
 	void __iomem *regs =3D mvi->regs_ex;
 	 iow32(SPI_DATA_REG_64XX, data);
 }
=20
=20
-int mvs_64xx_spi_buildcmd(struct mvs_info *mvi,
-			u32      *dwCmd,
-			u8       cmd,
-			u8       read,
-			u8       length,
-			u32      addr
-			)
+static int mvs_64xx_spi_buildcmd(struct mvs_info *mvi,
+				u32      *dwCmd,
+				u8       cmd,
+				u8       read,
+				u8       length,
+				u32      addr
+				)
 {
 	u32  dwTmp;
=20
@@ -705,7 +706,7 @@ int mvs_64xx_spi_buildcmd(struct mvs_info *mvi,
 }
=20
=20
-int mvs_64xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
+static int mvs_64xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
 {
 	void __iomem *regs =3D mvi->regs_ex;
 	int     retry;
@@ -720,7 +721,7 @@ int mvs_64xx_spi_issuecmd(struct mvs_info *mvi, u32=
 cmd)
 	return 0;
 }
=20
-int mvs_64xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
+static int mvs_64xx_spi_waitdataready(struct mvs_info *mvi, u32 timeou=
t)
 {
 	void __iomem *regs =3D mvi->regs_ex;
 	u32 i, dwTmp;
@@ -735,8 +736,8 @@ int mvs_64xx_spi_waitdataready(struct mvs_info *mvi=
, u32 timeout)
 	return -1;
 }
=20
-void mvs_64xx_fix_dma(struct mvs_info *mvi, u32 phy_mask,
-				int buf_len, int from, void *prd)
+static void mvs_64xx_fix_dma(struct mvs_info *mvi, u32 phy_mask,
+			     int buf_len, int from, void *prd)
 {
 	int i;
 	struct mvs_prd *buf_prd =3D prd;
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
