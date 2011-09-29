From: yxlraid@gmail.com
Subject: [PATCH 6/8] [SCSI] mvsas: expander write performance enhancement
Date: Thu, 29 Sep 2011 00:34:55 -0700
Message-ID: <4e834cda.e515440a.102b.0ea3@mx.google.com>
References: <mvsas>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mvsas>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- with 1 expander, connect 8 HDD, the write performance will be
   improved by 80%.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_94xx.c |    9 +++++++++
 drivers/scsi/mvsas/mv_defs.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 4d1a8c7..ba667db 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -511,6 +511,15 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	tmp |= CINT_PHY_MASK;
 	mw32(MVS_INT_MASK, tmp);
 
+	/* tune STP performance */
+	tmp = 0x003F003F;
+	mvs_cw32(mvi, CMD_PL_TIMER, tmp);
+
+	/* This can improve expander large block size seq write performance */
+	tmp = mvs_cr32(mvi, CMD_PORT_LAYER_TIMER1);
+	tmp |= 0xFFFF007F;
+	mvs_cw32(mvi, CMD_PORT_LAYER_TIMER1, tmp);
+
 	/* change the connection open-close behavior (bit 9) 
 	 * set bit8 to 1 for performance tuning */
 	tmp = mvs_cr32(mvi, CMD_SL_MODE0);
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index dec7cad..8e21482 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -387,6 +387,7 @@ enum sas_cmd_port_registers {
 	CMD_SL_MODE0		= 0x1BC, /* SL Mode 0 */
 	CMD_SL_MODE1		= 0x1C0, /* SL Mode 1 */
 	CMD_PND_FIFO_CTL1	= 0x1C4, /* Pending FIFO Control 1 */
+	CMD_PORT_LAYER_TIMER1	= 0x1E0, /* Port Layer Timer 1 */
 };
 
 enum mvs_info_flags {
-- 
1.7.4.4
