From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] [SCSI] mvsas: mark symbols static where possible
Date: Sun, 25 Sep 2016 13:48:50 +0800
Message-ID: <1474782530-17964-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, Wilfried.Weissmann@gmx.at, hare@suse.de, jthumshirn@suse.de, tj@kernel.org, davispuh@gmail.com, luisbg@osg.samsung.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get a few warnings when building kernel with W=1:
drivers/scsi/mvsas/mv_sas.c:77:18: warning: no previous prototype for 'mvs_find_dev_mvi' [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:105:5: warning: no previous prototype for 'mvs_find_dev_phyno' [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1161:20: warning: no previous prototype for 'mvs_alloc_dev' [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1178:6: warning: no previous prototype for 'mvs_free_dev' [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1188:5: warning: no previous prototype for 'mvs_dev_found_notify' [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1244:6: warning: no previous prototype for 'mvs_dev_gone_notify' [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1614:6: warning: no previous prototype for 'mvs_set_sense' [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1653:6: warning: no previous prototype for 'mvs_fill_ssp_resp_iu' [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:139:6: warning: no previous prototype for 'mvs_64xx_clear_srs_irq' [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_64xx.c:566:6: warning: no previous prototype for 'mvs_64xx_make_prd' [-Wmissing-prototypes]
....

In fact, these functions are only used in the file in which they are
declared and don't need a declaration, but can be made static.
so this patch marks these functions with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/mvsas/mv_64xx.c | 19 ++++++++++---------
 drivers/scsi/mvsas/mv_94xx.c | 41 +++++++++++++++++++++--------------------
 drivers/scsi/mvsas/mv_sas.c  | 16 ++++++++--------
 3 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 8bb0699..b757d38 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -136,7 +136,8 @@ static void mvs_64xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int hard)
 	}
 }
 
-void mvs_64xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear_all)
+static void
+mvs_64xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear_all)
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp;
@@ -563,7 +564,7 @@ static u8 mvs_64xx_assign_reg_set(struct mvs_info *mvi, u8 *tfs)
 	return MVS_ID_NOT_MAPPED;
 }
 
-void mvs_64xx_make_prd(struct scatterlist *scatter, int nr, void *prd)
+static void mvs_64xx_make_prd(struct scatterlist *scatter, int nr, void *prd)
 {
 	int i;
 	struct scatterlist *sg;
@@ -633,7 +634,7 @@ static void mvs_64xx_phy_work_around(struct mvs_info *mvi, int i)
 	mvs_write_port_vsr_data(mvi, i, tmp);
 }
 
-void mvs_64xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
+static void mvs_64xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
 			struct sas_phy_linkrates *rates)
 {
 	u32 lrmin = 0, lrmax = 0;
@@ -668,20 +669,20 @@ static void mvs_64xx_clear_active_cmds(struct mvs_info *mvi)
 }
 
 
-u32 mvs_64xx_spi_read_data(struct mvs_info *mvi)
+static u32 mvs_64xx_spi_read_data(struct mvs_info *mvi)
 {
 	void __iomem *regs = mvi->regs_ex;
 	return ior32(SPI_DATA_REG_64XX);
 }
 
-void mvs_64xx_spi_write_data(struct mvs_info *mvi, u32 data)
+static void mvs_64xx_spi_write_data(struct mvs_info *mvi, u32 data)
 {
 	void __iomem *regs = mvi->regs_ex;
 	 iow32(SPI_DATA_REG_64XX, data);
 }
 
 
-int mvs_64xx_spi_buildcmd(struct mvs_info *mvi,
+static int mvs_64xx_spi_buildcmd(struct mvs_info *mvi,
 			u32      *dwCmd,
 			u8       cmd,
 			u8       read,
@@ -705,7 +706,7 @@ int mvs_64xx_spi_buildcmd(struct mvs_info *mvi,
 }
 
 
-int mvs_64xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
+static int mvs_64xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
 {
 	void __iomem *regs = mvi->regs_ex;
 	int     retry;
@@ -720,7 +721,7 @@ int mvs_64xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
 	return 0;
 }
 
-int mvs_64xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
+static int mvs_64xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
 {
 	void __iomem *regs = mvi->regs_ex;
 	u32 i, dwTmp;
@@ -735,7 +736,7 @@ int mvs_64xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
 	return -1;
 }
 
-void mvs_64xx_fix_dma(struct mvs_info *mvi, u32 phy_mask,
+static void mvs_64xx_fix_dma(struct mvs_info *mvi, u32 phy_mask,
 				int buf_len, int from, void *prd)
 {
 	int i;
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index f6fc4a7..4c57d9a 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -48,8 +48,8 @@ static void mvs_94xx_detect_porttype(struct mvs_info *mvi, int i)
 	}
 }
 
-void set_phy_tuning(struct mvs_info *mvi, int phy_id,
-			struct phy_tuning phy_tuning)
+static void set_phy_tuning(struct mvs_info *mvi, int phy_id,
+			   struct phy_tuning phy_tuning)
 {
 	u32 tmp, setting_0 = 0, setting_1 = 0;
 	u8 i;
@@ -110,8 +110,8 @@ void set_phy_tuning(struct mvs_info *mvi, int phy_id,
 	}
 }
 
-void set_phy_ffe_tuning(struct mvs_info *mvi, int phy_id,
-				struct ffe_control ffe)
+static void set_phy_ffe_tuning(struct mvs_info *mvi, int phy_id,
+			       struct ffe_control ffe)
 {
 	u32 tmp;
 
@@ -177,7 +177,7 @@ void set_phy_ffe_tuning(struct mvs_info *mvi, int phy_id,
 }
 
 /*Notice: this function must be called when phy is disabled*/
-void set_phy_rate(struct mvs_info *mvi, int phy_id, u8 rate)
+static void set_phy_rate(struct mvs_info *mvi, int phy_id, u8 rate)
 {
 	union reg_phy_cfg phy_cfg, phy_cfg_tmp;
 	mvs_write_port_vsr_addr(mvi, phy_id, VSR_PHY_MODE2);
@@ -679,7 +679,8 @@ static void mvs_94xx_command_active(struct mvs_info *mvi, u32 slot_idx)
 	}
 }
 
-void mvs_94xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear_all)
+static void
+mvs_94xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear_all)
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp;
@@ -906,8 +907,8 @@ static void mvs_94xx_fix_phy_info(struct mvs_info *mvi, int i,
 
 }
 
-void mvs_94xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
-			struct sas_phy_linkrates *rates)
+static void mvs_94xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
+				       struct sas_phy_linkrates *rates)
 {
 	u32 lrmax = 0;
 	u32 tmp;
@@ -936,25 +937,25 @@ static void mvs_94xx_clear_active_cmds(struct mvs_info *mvi)
 }
 
 
-u32 mvs_94xx_spi_read_data(struct mvs_info *mvi)
+static u32 mvs_94xx_spi_read_data(struct mvs_info *mvi)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
 	return mr32(SPI_RD_DATA_REG_94XX);
 }
 
-void mvs_94xx_spi_write_data(struct mvs_info *mvi, u32 data)
+static void mvs_94xx_spi_write_data(struct mvs_info *mvi, u32 data)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
 	 mw32(SPI_RD_DATA_REG_94XX, data);
 }
 
 
-int mvs_94xx_spi_buildcmd(struct mvs_info *mvi,
-				u32      *dwCmd,
-				u8       cmd,
-				u8       read,
-				u8       length,
-				u32      addr
+static int mvs_94xx_spi_buildcmd(struct mvs_info *mvi,
+				 u32      *dwCmd,
+				 u8       cmd,
+				 u8       read,
+				 u8       length,
+				 u32      addr
 				)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
@@ -974,7 +975,7 @@ int mvs_94xx_spi_buildcmd(struct mvs_info *mvi,
 }
 
 
-int mvs_94xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
+static int mvs_94xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
 	mw32(SPI_CTRL_REG_94XX, cmd | SPI_CTRL_SpiStart_94XX);
@@ -982,7 +983,7 @@ int mvs_94xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
 	return 0;
 }
 
-int mvs_94xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
+static int mvs_94xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
 	u32   i, dwTmp;
@@ -997,8 +998,8 @@ int mvs_94xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
 	return -1;
 }
 
-void mvs_94xx_fix_dma(struct mvs_info *mvi, u32 phy_mask,
-				int buf_len, int from, void *prd)
+static void mvs_94xx_fix_dma(struct mvs_info *mvi, u32 phy_mask,
+			     int buf_len, int from, void *prd)
 {
 	int i;
 	struct mvs_prd *buf_prd = prd;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 5b9fcff..86eb199 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -74,7 +74,7 @@ void mvs_tag_init(struct mvs_info *mvi)
 		mvs_tag_clear(mvi, i);
 }
 
-struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
+static struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 {
 	unsigned long i = 0, j = 0, hi = 0;
 	struct sas_ha_struct *sha = dev->port->ha;
@@ -102,7 +102,7 @@ struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 
 }
 
-int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
+static int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
 {
 	unsigned long i = 0, j = 0, n = 0, num = 0;
 	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
@@ -1158,7 +1158,7 @@ void mvs_port_deformed(struct asd_sas_phy *sas_phy)
 	mvs_port_notify_deformed(sas_phy, 1);
 }
 
-struct mvs_device *mvs_alloc_dev(struct mvs_info *mvi)
+static struct mvs_device *mvs_alloc_dev(struct mvs_info *mvi)
 {
 	u32 dev;
 	for (dev = 0; dev < MVS_MAX_DEVICES; dev++) {
@@ -1175,7 +1175,7 @@ struct mvs_device *mvs_alloc_dev(struct mvs_info *mvi)
 	return NULL;
 }
 
-void mvs_free_dev(struct mvs_device *mvi_dev)
+static void mvs_free_dev(struct mvs_device *mvi_dev)
 {
 	u32 id = mvi_dev->device_id;
 	memset(mvi_dev, 0, sizeof(*mvi_dev));
@@ -1185,7 +1185,7 @@ void mvs_free_dev(struct mvs_device *mvi_dev)
 	mvi_dev->taskfileset = MVS_ID_NOT_MAPPED;
 }
 
-int mvs_dev_found_notify(struct domain_device *dev, int lock)
+static int mvs_dev_found_notify(struct domain_device *dev, int lock)
 {
 	unsigned long flags = 0;
 	int res = 0;
@@ -1241,7 +1241,7 @@ int mvs_dev_found(struct domain_device *dev)
 	return mvs_dev_found_notify(dev, 1);
 }
 
-void mvs_dev_gone_notify(struct domain_device *dev)
+static void mvs_dev_gone_notify(struct domain_device *dev)
 {
 	unsigned long flags = 0;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
@@ -1611,7 +1611,7 @@ static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
 	return stat;
 }
 
-void mvs_set_sense(u8 *buffer, int len, int d_sense,
+static void mvs_set_sense(u8 *buffer, int len, int d_sense,
 		int key, int asc, int ascq)
 {
 	memset(buffer, 0, len);
@@ -1650,7 +1650,7 @@ void mvs_set_sense(u8 *buffer, int len, int d_sense,
 	return;
 }
 
-void mvs_fill_ssp_resp_iu(struct ssp_response_iu *iu,
+static void mvs_fill_ssp_resp_iu(struct ssp_response_iu *iu,
 				u8 key, u8 asc, u8 asc_q)
 {
 	iu->datapres = 2;
-- 
2.7.4
