From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Date: Tue, 31 May 2011 00:26:45 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAD84E1E@SC-VEXCH4.marvell.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
 <20110526021809.GA22496@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
 <20110526141430.GD4164@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD848FB@SC-VEXCH4.marvell.com>
 <20110527073302.GA16178@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84C40@SC-VEXCH4.marvell.com>
 <20110530074508.GB7806@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84CD9@SC-VEXCH4.marvell.com>
 <20110530144815.GB2689@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110530144815.GB2689@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "jslaby@suse.cz" <jslaby@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>
List-Id: linux-scsi@vger.kernel.org


>Then I would strongly recommend never exporting this value to allow it
>to be changed at all then.  It doesn't sound worth it.
OK, Thanks!
I remove the sysfs file and the modified patch is:

drivers/scsi/mvsas/mv_64xx.c |   25 ++++++++++++++++++++++++-
 drivers/scsi/mvsas/mv_94xx.c |   26 +++++++++++++++++++++++++-
 drivers/scsi/mvsas/mv_init.c |    5 +++++
 drivers/scsi/mvsas/mv_sas.h  |    2 ++
 4 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 0e13e64..c88b8a7 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -402,7 +402,7 @@ static int __devinit mvs_64xx_init(struct mvs_info *mvi)
 	tmp = 0;
 	mw32(MVS_INT_COAL, tmp);
 
-	tmp = 0x100;
+	tmp = 0x10000 | interrupt_coalescing;
 	mw32(MVS_INT_COAL_TMOUT, tmp);
 
 	/* ladies and gentlemen, start your engines */
@@ -758,6 +758,28 @@ void mvs_64xx_fix_dma(dma_addr_t buf_dma, int buf_len, int from, void *prd)
 }
 #endif
 
+static void mvs_64xx_tune_interrupt(struct mvs_info *mvi, u32 time)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp = 0;
+	/* interrupt coalescing may cause missing HW interrput in some case,
+	 * and the max count is 0x1ff, while our max slot is 0x200,
+	 * it will make count 0.
+	 */
+	if (time == 0) {
+		mw32(MVS_INT_COAL, 0);
+		mw32(MVS_INT_COAL_TMOUT, 0x10000);
+	} else {
+		if (MVS_CHIP_SLOT_SZ > 0x1ff)
+			mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
+		else
+			mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
+
+		tmp = 0x10000 | time;
+		mw32(MVS_INT_COAL_TMOUT, tmp);
+	}
+}
+
 const struct mvs_dispatch mvs_64xx_dispatch = {
 	"mv64xx",
 	mvs_64xx_init,
@@ -811,6 +833,7 @@ const struct mvs_dispatch mvs_64xx_dispatch = {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	mvs_64xx_fix_dma,
 #endif
+	mvs_64xx_tune_interrupt,
 	NULL,
 };
 
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 3f2ad93..e589f31 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -475,7 +475,7 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	tmp = 0;
 	mw32(MVS_INT_COAL, tmp);
 
-	tmp = 0x100;
+	tmp = 0x10000 | interrupt_coalescing;
 	mw32(MVS_INT_COAL_TMOUT, tmp);
 
 	/* ladies and gentlemen, start your engines */
@@ -894,6 +894,29 @@ static void mvs_94xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set,
 {
 }
 
+static void mvs_94xx_tune_interrupt(struct mvs_info *mvi, u32 time)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp = 0;
+	/* interrupt coalescing may cause missing HW interrput in some case,
+	 * and the max count is 0x1ff, while our max slot is 0x200,
+	 * it will make count 0.
+	 */
+	if (time == 0) {
+		mw32(MVS_INT_COAL, 0);
+		mw32(MVS_INT_COAL_TMOUT, 0x10000);
+	} else {
+		if (MVS_CHIP_SLOT_SZ > 0x1ff)
+			mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
+		else
+			mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
+
+		tmp = 0x10000 | time;
+		mw32(MVS_INT_COAL_TMOUT, tmp);
+	}
+
+}
+
 const struct mvs_dispatch mvs_94xx_dispatch = {
 	"mv94xx",
 	mvs_94xx_init,
@@ -947,6 +970,7 @@ const struct mvs_dispatch mvs_94xx_dispatch = {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	mvs_94xx_fix_dma,
 #endif
+	mvs_94xx_tune_interrupt,
 	mvs_94xx_non_spec_ncq_error,
 };
 
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 9f1cccc..d977684 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -34,6 +34,8 @@ MODULE_PARM_DESC(collector, "\n"
 	"\tThe mvsas SAS LLDD supports both modes.\n"
 	"\tDefault: 1 (Direct Mode).\n");
 
+int interrupt_coalescing = 0x80;
+
 static struct scsi_transport_template *mvs_stt;
 struct kmem_cache *mvs_task_list_cache;
 static const struct mvs_chip_info mvs_chips[] = {
@@ -48,6 +50,8 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 };
 
+struct device_attribute *mvst_host_attrs[] = { NULL };
+
 #define SOC_SAS_NUM 2
 #define SG_MX 64
 
@@ -74,6 +78,7 @@ static struct scsi_host_template mvs_sht = {
 	.slave_alloc		= mvs_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+	.shost_attrs		= mvst_host_attrs,
 };
 
 static struct sas_domain_function_template mvs_transport_ops = {
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 8740b78..fed8495 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -64,6 +64,7 @@
 #endif
 #define MV_MAX_U32			0xffffffff
 
+extern int interrupt_coalescing;
 extern struct mvs_tgt_initiator mvs_tgt;
 extern struct mvs_info *tgt_mvi;
 extern const struct mvs_dispatch mvs_64xx_dispatch;
@@ -170,6 +171,7 @@ struct mvs_dispatch {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	void (*dma_fix)(dma_addr_t buf_dma, int buf_len, int from, void *prd);
 #endif
+	void (*tune_interrupt)(struct mvs_info *mvi, u32 time);
 	void (*non_spec_ncq_error)(struct mvs_info *mvi);
 
 };
-- 
1.7.4.4
