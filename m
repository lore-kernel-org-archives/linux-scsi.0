From: yxlraid@gmail.com
Subject: [PATCH 5/8] [SCSI] mvsas: change SL mode0 register value
Date: Thu, 29 Sep 2011 00:34:32 -0700
Message-ID: <4e834cc3.280d440a.5c55.19fb@mx.google.com>
References: <mvsas>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mvsas>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- change connection behavior
-- set bit8 to 1 for performance tuning
-- set bit0 to 0 to enable retry for no_dest reject case.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_94xx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index ca2b9d9..4d1a8c7 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -511,6 +511,14 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	tmp |= CINT_PHY_MASK;
 	mw32(MVS_INT_MASK, tmp);
 
+	/* change the connection open-close behavior (bit 9) 
+	 * set bit8 to 1 for performance tuning */
+	tmp = mvs_cr32(mvi, CMD_SL_MODE0);
+	tmp |= 0x00000300;
+	/* set bit0 to 0 to enable retry for no_dest reject case */
+	tmp &= 0xFFFFFFFE;
+	mvs_cw32(mvi, CMD_SL_MODE0, tmp);
+
 	/* Enable SRS interrupt */
 	mw32(MVS_INT_MASK_SRS_0, 0xFFFF);
 
-- 
1.7.4.4
