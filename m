From: yxlraid@gmail.com
Subject: [PATCH 4/8] [SCSI] mvsas: fixed wrong destination when hiting NAK for command frame
Date: Thu, 29 Sep 2011 00:34:11 -0700
Message-ID: <4e834cae.e515440a.102b.0e75@mx.google.com>
References: <mvsas>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mvsas>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- disable non data frame retry

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_94xx.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 8f32c7c..ca2b9d9 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -398,6 +398,17 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	/* init phys */
 	mvs_phy_hacks(mvi);
 
+	/* disable non data frame retry */
+	tmp = mvs_cr32(mvi, CMD_SAS_CTL1);
+	if((revision == VANIR_A0_REV) ||
+		(revision == VANIR_B0_REV) ||
+		(revision == VANIR_C0_REV))
+	{
+		tmp &= ~0xffff;
+		tmp |= 0x007f;
+		mvs_cw32(mvi, CMD_SAS_CTL1, tmp);
+	}
+
 	/* set LED blink when IO*/
 	mw32(MVS_PA_VSR_ADDR, VSR_PHY_ACT_LED);
 	tmp = mr32(MVS_PA_VSR_PORT);
-- 
1.7.4.4
