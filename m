From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 3/7]MVSAS: bug fix with big endian
Date: Mon, 9 Nov 2009 20:11:41 +0800
Message-ID: <20091109121141.GB32336@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:55684 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZKIDPF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 22:15:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, jeff@garzik.org, linux-scsi@vger.kernel.org
Cc: qswang@marvell.com, jfeng@marvell.com


>From 8cbb984df30eced387272905dfe13b552724024b Mon Sep 17 00:00:00 2001
From: andy <ayan@marvell.com>
Date: Fri, 6 Nov 2009 17:13:12 +0800
Subject: [PATCH 3/7] bug fix with big endian

Fixed some issue with working on big endian platform
correct SAS address and SG table for big endian

Signed-off-by: Andy <ayan@marvell.com>
Signed-off-by: Jacky <jfeng@marvell.com>
Signed-off-by: Ke <kewei@marvell.com>

---
 drivers/scsi/mvsas/mv_94xx.c |   31 ++++++++++++++++++++++---------
 drivers/scsi/mvsas/mv_94xx.h |    9 ++++++++-
 drivers/scsi/mvsas/mv_defs.h |    4 ++++
 drivers/scsi/mvsas/mv_init.c |    2 ++
 4 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index f0017fc..bb1026d 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -183,7 +183,7 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 		mvs_94xx_phy_disable(mvi, i);
 		/* set phy local SAS address */
 		mvs_set_sas_addr(mvi, i, CONFIG_ID_FRAME3, CONFIG_ID_FRAME4,
-						(mvi->phy[i].dev_sas_addr));
+					cpu_to_le64(mvi->phy[i].dev_sas_addr));
 
 		mvs_94xx_enable_xmt(mvi, i);
 		mvs_94xx_phy_enable(mvi, i);
@@ -228,7 +228,6 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	 */
 	cctl = mr32(MVS_CTL);
 	cctl |= CCTL_ENDIAN_CMD;
-	cctl |= CCTL_ENDIAN_DATA;
 	cctl &= ~CCTL_ENDIAN_OPEN;
 	cctl |= CCTL_ENDIAN_RSP;
 	mw32_f(MVS_CTL, cctl);
@@ -436,9 +435,13 @@ static void mvs_94xx_make_prd(struct scatterlist *scatter, int nr, void *prd)
 	int i;
 	struct scatterlist *sg;
 	struct mvs_prd *buf_prd = prd;
+	struct mvs_prd_imt im_len;
+	*(u32 *)&im_len = 0;
 	for_each_sg(scatter, sg, nr, i) {
 		buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
-		buf_prd->im_len.len = cpu_to_le32(sg_dma_len(sg));
+		im_len.len = sg_dma_len(sg);
+		buf_prd->im_len =
+			cpu_to_le32(*(u32 *)&im_len);
 		buf_prd++;
 	}
 }
@@ -461,7 +464,7 @@ static void mvs_94xx_get_dev_identify_frame(struct mvs_info *mvi, int port_id,
 	for (i = 0; i < 7; i++) {
 		mvs_write_port_cfg_addr(mvi, port_id,
 					CONFIG_ID_FRAME0 + i * 4);
-		id_frame[i] = mvs_read_port_cfg_data(mvi, port_id);
+		id_frame[i] = cpu_to_le32(mvs_read_port_cfg_data(mvi, port_id));
 	}
 	memcpy(id, id_frame, 28);
 }
@@ -476,7 +479,7 @@ static void mvs_94xx_get_att_identify_frame(struct mvs_info *mvi, int port_id,
 	for (i = 0; i < 7; i++) {
 		mvs_write_port_cfg_addr(mvi, port_id,
 					CONFIG_ATT_ID_FRAME0 + i * 4);
-		id_frame[i] = mvs_read_port_cfg_data(mvi, port_id);
+		id_frame[i] = cpu_to_le32(mvs_read_port_cfg_data(mvi, port_id));
 		mv_dprintk("94xx phy %d atta frame %d %x.\n",
 			port_id + mvi->id * mvi->chip->n_phy, i, id_frame[i]);
 	}
@@ -622,11 +625,21 @@ void mvs_94xx_fix_dma(dma_addr_t buf_dma, int buf_len, int from, void *prd)
 {
 	int i;
 	struct mvs_prd *buf_prd = prd;
+	struct mvs_prd_imt im_len;
+	*(u32 *)&im_len = 0;
 	buf_prd += from;
-	for (i = 0; i < MAX_SG_ENTRY - from; i++) {
-		buf_prd->addr = cpu_to_le64(buf_dma);
-		buf_prd->im_len.len = cpu_to_le32(buf_len);
-		++buf_prd;
+
+#define PRD_CHAINED_ENTRY 0x01
+	for (i = from; i < MAX_SG_ENTRY; i++, ++buf_prd) {
+		if (i == MAX_SG_ENTRY - 1) {
+			buf_prd->addr = cpu_to_le64(virt_to_phys(buf_prd - 1));
+			im_len.len = 2;
+			im_len.misc_ctl = PRD_CHAINED_ENTRY;
+		} else {
+			buf_prd->addr = cpu_to_le64(buf_dma);
+			im_len.len = buf_len;
+		}
+		buf_prd->im_len = cpu_to_le32(*(u32 *)&im_len);
 	}
 }
 #endif
diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index a510ad8..1df38a9 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -172,17 +172,24 @@ enum pci_interrupt_cause {
 #define MAX_SG_ENTRY		255
 
 struct mvs_prd_imt {
+#ifndef __BIG_ENDIAN
 	__le32			len:22;
 	u8			_r_a:2;
 	u8			misc_ctl:4;
 	u8			inter_sel:4;
+#else
+	u32			inter_sel:4;
+	u32			misc_ctl:4;
+	u32			_r_a:2;
+	u32			len:22;
+#endif
 };
 
 struct mvs_prd {
 	/* 64-bit buffer address */
 	__le64			addr;
 	/* 22-bit length */
-	struct mvs_prd_imt	im_len;
+	__le32		im_len;
 } __attribute__ ((packed));
 
 #define SPI_CTRL_REG_94XX           	0xc800
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 1849da1..5096de8 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -503,4 +503,8 @@ struct mvs_tmf_task{
 	u8 tmf;
 	u16 tag_of_task_to_be_managed;
 };
+enum pci_cfg_comm_registers {
+	PCR_CMD		= 0x04,
+	PCR_MSI_CTRL 	= 0x50,
+};
 #endif
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index d030959..bbbc20e 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -533,6 +533,8 @@ static void mvs_init_sas_add(struct mvs_info *mvi)
 	u8 i;
 	for (i = 0; i < mvi->chip->n_phy; i++) {
 		mvi->phy[i].dev_sas_addr = 0x5005043011ab0000ULL;
+		if (mvi->id == 1)
+			mvi->phy[i].dev_sas_addr =  0x5005043011ab0001ULL;
 		mvi->phy[i].dev_sas_addr =
 			cpu_to_be64((u64)(*(u64 *)&mvi->phy[i].dev_sas_addr));
 	}
-- 
1.6.2.2

