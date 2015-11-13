From: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>
Subject: [PATCH 1/1] mvsas: add SGPIO support to Marvell 94xx
Date: Fri, 13 Nov 2015 11:43:44 +0100
Message-ID: <5645BEE0.3050406@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63875 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854AbbKMKoB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Nov 2015 05:44:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org

add SGPIO support to Marvell 94xx

Signed-off-by: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>
---

  drivers/scsi/mvsas/mv_94xx.c |  134 +++++++++++++++++++++++++++++++++
  drivers/scsi/mvsas/mv_94xx.h |   71 +++++++++++++++++
  drivers/scsi/mvsas/mv_init.c |    2
  drivers/scsi/mvsas/mv_sas.c  |   13 +++
  drivers/scsi/mvsas/mv_sas.h  |    5 +
  5 files changed, 225 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 9270d15..35ea54c 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -330,6 +330,51 @@ static void mvs_94xx_phy_enable(struct mvs_info *mvi, u32 phy_id)
  	mvs_write_port_vsr_data(mvi, phy_id, tmp & 0xfd7fffff);
  }
  
+static void mvs_94xx_sgpio_init(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	u32 tmp;
+
+	tmp = mr32(MVS_HST_CHIP_CONFIG);
+	tmp |= 0x100;
+	mw32(MVS_HST_CHIP_CONFIG, tmp);
+
+	mw32(MVS_SGPIO_CTRL + MVS_SGPIO_HOST_OFFSET * mvi->id,
+		MVS_SGPIO_CTRL_SDOUT_AUTO << MVS_SGPIO_CTRL_SDOUT_SHIFT);
+
+	mw32(MVS_SGPIO_CFG1 + MVS_SGPIO_HOST_OFFSET * mvi->id,
+		8 << MVS_SGPIO_CFG1_LOWA_SHIFT |
+		8 << MVS_SGPIO_CFG1_HIA_SHIFT |
+		4 << MVS_SGPIO_CFG1_LOWB_SHIFT |
+		4 << MVS_SGPIO_CFG1_HIB_SHIFT |
+		2 << MVS_SGPIO_CFG1_MAXACTON_SHIFT |
+		1 << MVS_SGPIO_CFG1_FORCEACTOFF_SHIFT
+	);
+
+	mw32(MVS_SGPIO_CFG2 + MVS_SGPIO_HOST_OFFSET * mvi->id,
+		(300000 / 100) << MVS_SGPIO_CFG2_CLK_SHIFT | /* 100kHz clock */
+		66 << MVS_SGPIO_CFG2_BLINK_SHIFT /* (66 * 0,121 Hz?)*/
+	);
+
+	mw32(MVS_SGPIO_CFG0 + MVS_SGPIO_HOST_OFFSET * mvi->id,
+		MVS_SGPIO_CFG0_ENABLE |
+		MVS_SGPIO_CFG0_BLINKA |
+		MVS_SGPIO_CFG0_BLINKB |
+		/* 3*4 data bits / PDU */
+		(12 - 1) << MVS_SGPIO_CFG0_AUT_BITLEN_SHIFT
+	);
+
+	mw32(MVS_SGPIO_DCTRL + MVS_SGPIO_HOST_OFFSET * mvi->id,
+		DEFAULT_SGPIO_BITS);
+
+	mw32(MVS_SGPIO_DSRC + MVS_SGPIO_HOST_OFFSET * mvi->id,
+		((mvi->id * 4) + 3) << (8 * 3) |
+		((mvi->id * 4) + 2) << (8 * 2) |
+		((mvi->id * 4) + 1) << (8 * 1) |
+		((mvi->id * 4) + 0) << (8 * 0));
+
+}
+
  static int mvs_94xx_init(struct mvs_info *mvi)
  {
  	void __iomem *regs = mvi->regs;
@@ -533,6 +578,8 @@ static int mvs_94xx_init(struct mvs_info *mvi)
  	/* Enable SRS interrupt */
  	mw32(MVS_INT_MASK_SRS_0, 0xFFFF);
  
+	mvs_94xx_sgpio_init(mvi);
+
  	return 0;
  }
  
@@ -1005,6 +1052,92 @@ static void mvs_94xx_tune_interrupt(struct mvs_info *mvi, u32 time)
  
  }
  
+static int mvs_94xx_gpio_write(struct mvs_prv_info *mvs_prv,
+			u8 reg_type, u8 reg_index,
+			u8 reg_count, u8 *write_data)
+{
+	int i;
+
+	switch (reg_type) {
+
+	case SAS_GPIO_REG_TX_GP:
+		if (reg_index == 0)
+			return -EINVAL;
+
+		if (reg_count > 1)
+			return -EINVAL;
+
+		if (reg_count == 0)
+			return 0;
+
+		/* maximum supported bits = hosts * 4 drives * 3 bits */
+		for (i = 0; i < mvs_prv->n_host * 4 * 3; i++) {
+
+			/* select host */
+			struct mvs_info *mvi = mvs_prv->mvi[i/(4*3)];
+
+			void __iomem *regs = mvi->regs_ex - 0x10200;
+
+			int drive = (i/3) & (4-1); /* drive number on host */
+			u32 block = mr32(MVS_SGPIO_DCTRL +
+				MVS_SGPIO_HOST_OFFSET * mvi->id);
+
+
+			/*
+			* if bit is set then create a mask with the first
+			* bit of the drive set in the mask ...
+			*/
+			u32 bit = (write_data[i/8] & (1 << (i&(8-1)))) ?
+				1<<(24-drive*8) : 0;
+
+			/*
+			* ... and then shift it to the right position based
+			* on the led type (activity/id/fail)
+			*/
+			switch (i%3) {
+			case 0: /* activity */
+				block &= ~((0x7 << MVS_SGPIO_DCTRL_ACT_SHIFT)
+					<< (24-drive*8));
+					/* hardwire activity bit to SOF */
+				block |= led_blinka_sof << (
+					MVS_SGPIO_DCTRL_ACT_SHIFT +
+					(24-drive*8));
+				break;
+			case 1: /* id */
+				block &= ~((0x3 << MVS_SGPIO_DCTRL_LOC_SHIFT)
+					<< (24-drive*8));
+				block |= bit << MVS_SGPIO_DCTRL_LOC_SHIFT;
+				break;
+			case 2: /* fail */
+				block &= ~((0x7 << MVS_SGPIO_DCTRL_ERR_SHIFT)
+					<< (24-drive*8));
+				block |= bit << MVS_SGPIO_DCTRL_ERR_SHIFT;
+				break;
+			}
+
+			mw32(MVS_SGPIO_DCTRL + MVS_SGPIO_HOST_OFFSET * mvi->id,
+				block);
+
+		}
+
+		return reg_count;
+
+	case SAS_GPIO_REG_TX:
+		if (reg_index + reg_count > mvs_prv->n_host)
+			return -EINVAL;
+
+		for (i = 0; i < reg_count; i++) {
+			struct mvs_info *mvi = mvs_prv->mvi[i+reg_index];
+			void __iomem *regs = mvi->regs_ex - 0x10200;
+
+			mw32(MVS_SGPIO_DCTRL + MVS_SGPIO_HOST_OFFSET * mvi->id,
+				be32_to_cpu(((u32 *) write_data)[i]));
+		}
+		return reg_count;
+	}
+	return -ENOSYS;
+}
+
  const struct mvs_dispatch mvs_94xx_dispatch = {
  	"mv94xx",
  	mvs_94xx_init,
@@ -1057,5 +1190,6 @@ const struct mvs_dispatch mvs_94xx_dispatch = {
  	mvs_94xx_fix_dma,
  	mvs_94xx_tune_interrupt,
  	mvs_94xx_non_spec_ncq_error,
+	mvs_94xx_gpio_write,
  };
  
diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 14e1974..82b1893 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -38,6 +38,10 @@ enum VANIR_REVISION_ID {
  	VANIR_C2_REV		= 0xC2,
  };
  
+enum host_registers {
+	MVS_HST_CHIP_CONFIG	= 0x10104,	/* chip configuration */
+};
+
  enum hw_registers {
  	MVS_GBL_CTL		= 0x04,  /* global control */
  	MVS_GBL_INT_STAT	= 0x00,  /* global irq status */
@@ -239,6 +243,73 @@ struct mvs_prd {
  	__le32			im_len;
  } __attribute__ ((packed));
  
+enum sgpio_registers {
+	MVS_SGPIO_HOST_OFFSET	= 0x100,	/* offset between hosts */
+
+	MVS_SGPIO_CFG0	= 0xc200,
+	MVS_SGPIO_CFG0_ENABLE	= (1 << 0),	/* enable pins */
+	MVS_SGPIO_CFG0_BLINKB	= (1 << 1),	/* blink generators */
+	MVS_SGPIO_CFG0_BLINKA	= (1 << 2),
+	MVS_SGPIO_CFG0_INVSCLK	= (1 << 3),	/* invert signal? */
+	MVS_SGPIO_CFG0_INVSLOAD	= (1 << 4),
+	MVS_SGPIO_CFG0_INVSDOUT	= (1 << 5),
+	MVS_SGPIO_CFG0_SLOAD_FALLEDGE = (1 << 6),	/* rise/fall edge? */
+	MVS_SGPIO_CFG0_SDOUT_FALLEDGE = (1 << 7),
+	MVS_SGPIO_CFG0_SDIN_RISEEDGE = (1 << 8),
+	MVS_SGPIO_CFG0_MAN_BITLEN_SHIFT = 18,	/* bits/frame manual mode */
+	MVS_SGPIO_CFG0_AUT_BITLEN_SHIFT = 24,	/* bits/frame auto mode */
+
+	MVS_SGPIO_CFG1	= 0xc204,	/* blink timing register */
+	MVS_SGPIO_CFG1_LOWA_SHIFT	= 0,	/* A off time */
+	MVS_SGPIO_CFG1_HIA_SHIFT	= 4,	/* A on time */
+	MVS_SGPIO_CFG1_LOWB_SHIFT	= 8,	/* B off time */
+	MVS_SGPIO_CFG1_HIB_SHIFT	= 12,	/* B on time */
+	MVS_SGPIO_CFG1_MAXACTON_SHIFT	= 16,	/* max activity on time */
+
+		/* force activity off time */
+	MVS_SGPIO_CFG1_FORCEACTOFF_SHIFT	= 20,
+		/* stretch activity on time */
+	MVS_SGPIO_CFG1_STRCHACTON_SHIFT	= 24,
+		/* stretch activiity off time */
+	MVS_SGPIO_CFG1_STRCHACTOFF_SHIFT	= 28,
+
+
+	MVS_SGPIO_CFG2	= 0xc208,	/* clock speed register */
+	MVS_SGPIO_CFG2_CLK_SHIFT	= 0,
+	MVS_SGPIO_CFG2_BLINK_SHIFT	= 20,
+
+	MVS_SGPIO_CTRL	= 0xc20c,	/* SDOUT/SDIN mode control */
+	MVS_SGPIO_CTRL_SDOUT_AUTO	= 2,
+	MVS_SGPIO_CTRL_SDOUT_SHIFT	= 2,
+
+	MVS_SGPIO_DSRC	= 0xc220,	/* map ODn bits to drives */
+
+	MVS_SGPIO_DCTRL	= 0xc238,
+	MVS_SGPIO_DCTRL_ERR_SHIFT	= 0,
+	MVS_SGPIO_DCTRL_LOC_SHIFT	= 3,
+	MVS_SGPIO_DCTRL_ACT_SHIFT	= 5,
+};
+
+enum sgpio_led_status {
+	led_off	= 0,
+	led_on	= 1,
+	led_blinka	= 2,
+	led_blinka_inv	= 3,
+	led_blinka_sof	= 4,
+	led_blinka_eof	= 5,
+	led_blinkb	= 6,
+	led_blinkb_inv	= 7,
+};
+
+#define DEFAULT_SGPIO_BITS ((led_blinka_sof << \
+				MVS_SGPIO_DCTRL_ACT_SHIFT) << (8 * 3) | \
+			(led_blinka_sof << \
+				MVS_SGPIO_DCTRL_ACT_SHIFT) << (8 * 2) | \
+			(led_blinka_sof << \
+				MVS_SGPIO_DCTRL_ACT_SHIFT) << (8 * 1) | \
+			(led_blinka_sof << \
+				MVS_SGPIO_DCTRL_ACT_SHIFT) << (8 * 0))
+
  /*
   * these registers are accessed through port vendor
   * specific address/data registers
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index e2d555c..0c56b11 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -85,6 +85,8 @@ static struct sas_domain_function_template mvs_transport_ops = {
  	.lldd_port_formed	= mvs_port_formed,
  	.lldd_port_deformed     = mvs_port_deformed,
  
+	.lldd_write_gpio	= mvs_gpio_write,
+
  };
  
  static void mvs_phy_init(struct mvs_info *mvi, int phy_id)
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 454536c..4cd9d99 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -2103,3 +2103,16 @@ int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
  	return 0;
  }
  
+int mvs_gpio_write(struct sas_ha_struct *sha, u8 reg_type, u8 reg_index,
+			u8 reg_count, u8 *write_data)
+{
+	struct mvs_prv_info *mvs_prv = sha->lldd_ha;
+	struct mvs_info *mvi = mvs_prv->mvi[0];
+
+	if (MVS_CHIP_DISP->gpio_write) {
+		return MVS_CHIP_DISP->gpio_write(mvs_prv, reg_type,
+			reg_index, reg_count, write_data);
+	}
+
+	return -ENOSYS;
+}
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index dc409c0..f9afd4c 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -103,6 +103,7 @@ enum dev_reset {
  };
  
  struct mvs_info;
+struct mvs_prv_info;
  
  struct mvs_dispatch {
  	char *name;
@@ -172,6 +173,8 @@ struct mvs_dispatch {
  				int buf_len, int from, void *prd);
  	void (*tune_interrupt)(struct mvs_info *mvi, u32 time);
  	void (*non_spec_ncq_error)(struct mvs_info *mvi);
+	int (*gpio_write)(struct mvs_prv_info *mvs_prv, u8 reg_type,
+			u8 reg_index, u8 reg_count, u8 *write_data);
  
  };
  
@@ -476,5 +479,7 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events);
  void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
  int mvs_int_rx(struct mvs_info *mvi, bool self_clear);
  struct mvs_device *mvs_find_dev_by_reg_set(struct mvs_info *mvi, u8 reg_set);
+int mvs_gpio_write(struct sas_ha_struct *, u8 reg_type, u8 reg_index,
+			u8 reg_count, u8 *write_data);
  #endif
  

