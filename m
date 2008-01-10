From: "Ke Wei" <kewei.mv@gmail.com>
Subject: [PATCH] Marvell 6440 SAS/SATA driver (draft)
Date: Thu, 10 Jan 2008 14:53:34 +0800
Message-ID: <6b2481670801092253v666e969doe5ec2bd77e10a87e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:44643 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYAJGxf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 01:53:35 -0500
Received: by rv-out-0910.google.com with SMTP id k20so483309rvb.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jan 2008 22:53:34 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, jeff@garzik.org

The 88SE6440 driver :

The driver is based on bare code from Jeff Garzik. And it can work
under linux kernel 2.6.23.
By far, Can discover and find SAS HDD, but SATA is currently
unsupported. Command queue depth can be above 1.
Most error handling, and some phy handling code is notably missing.


contains the following updates:

--- mvsas_orig.c	2007-12-06 19:21:32.000000000 -0500
+++ mvsas.c	2008-01-09 04:53:14.000000000 -0500
@@ -2,6 +2,7 @@
 	mvsas.c - Marvell 88SE6440 SAS/SATA support

 	Copyright 2007 Red Hat, Inc.
+	Copyright 2008 Marvell.

 	This program is free software; you can redistribute it and/or
 	modify it under the terms of the GNU General Public License as
@@ -37,8 +38,10 @@
 #include <scsi/libsas.h>
 #include <asm/io.h>

-#define DRV_NAME "mvsas"
-#define DRV_VERSION "0.1"
+#define DRV_NAME	"mvsas"
+#define DRV_VERSION	"0.2"
+#define _MV_DUMP 0
+#define MVS_PRINTK(_x_,...)	printk(KERN_NOTICE DRV_NAME ": " _x_ , ##
__VA_ARGS__)

 #define mr32(reg)	readl(regs + MVS_##reg)
 #define mw32(reg,val)	writel((val), regs + MVS_##reg)
@@ -47,9 +50,42 @@
 	readl(regs + MVS_##reg);		\
 	} while (0)

+#define MVS_BIT(x)                         (1L << (x))
+
+#define PORT_TYPE_SATA                    MVS_BIT(0)
+#define PORT_TYPE_SAS                     MVS_BIT(1)
+
+#define READ_PORT_CONFIG_DATA(i) \
+	((i>3)?mr32(P4_CFG_DATA+(i-4)*8):mr32(P0_CFG_DATA+i*8))
+#define WRITE_PORT_CONFIG_DATA(i,tmp) \
+	{if(i>3)mw32(P4_CFG_DATA+(i-4)*8,tmp);else mw32(P0_CFG_DATA+i*8,tmp);}
+#define WRITE_PORT_CONFIG_ADDR(i,tmp) \
+	{if(i>3)mw32(P4_CFG_ADDR+(i-4)*8,tmp);else mw32(P0_CFG_ADDR+i*8,tmp);}
+
+#define READ_PORT_PHY_CONTROL(i) \
+   ((i>3)?mr32(P4_SER_CTLSTAT+(i-4)*4):mr32(P0_SER_CTLSTAT+i*4))
+#define WRITE_PORT_PHY_CONTROL(i,tmp) \
+   {if(i>3)mw32(P4_SER_CTLSTAT+(i-4)*4,tmp);else
mw32(P0_SER_CTLSTAT+i*4,tmp);}
+
+#define READ_PORT_VSR_DATA(i) \
+   ((i>3)?mr32(P4_VSR_DATA+(i-4)*8):mr32(P0_VSR_DATA+i*8))
+#define WRITE_PORT_VSR_DATA(i,tmp) \
+   {if(i>3)mw32(P4_VSR_DATA+(i-4)*8,tmp);else mw32(P0_VSR_DATA+i*8,tmp);}
+#define WRITE_PORT_VSR_ADDR(i,tmp) \
+   {if(i>3)mw32(P4_VSR_ADDR+(i-4)*8,tmp);else mw32(P0_VSR_ADDR+i*8,tmp);}
+
+#define READ_PORT_IRQ_STAT(i) \
+   ((i>3)?mr32(P4_INT_STAT+(i-4)*8):mr32(P0_INT_STAT+i*8))
+#define WRITE_PORT_IRQ_STAT(i,tmp) \
+   {if(i>3)mw32(P4_INT_STAT+(i-4)*8,tmp);else mw32(P0_INT_STAT+i*8,tmp);}
+#define READ_PORT_IRQ_MASK(i) \
+   ((i>3)?mr32(P4_INT_MASK+(i-4)*8):mr32(P0_INT_MASK+i*8))
+#define WRITE_PORT_IRQ_MASK(i,tmp) \
+   {if(i>3)mw32(P4_INT_MASK+(i-4)*8,tmp);else mw32(P0_INT_MASK+i*8,tmp);}
+
 /* driver compile-time configuration */
 enum driver_configuration {
-	MVS_TX_RING_SZ		= 1024,	/* TX ring size (12-bit) */
+	MVS_TX_RING_SZ		= 512,	/* TX ring size (12-bit) */
 	MVS_RX_RING_SZ		= 1024, /* RX ring size (12-bit) */
 					/* software requires power-of-2
 					   ring size */
@@ -89,7 +125,7 @@
 	MVS_GBL_CTL		= 0x04,  /* global control */
 	MVS_GBL_INT_STAT	= 0x08,  /* global irq status */
 	MVS_GBL_PI		= 0x0C,  /* ports implemented bitmask */
-	MVS_GBL_PORT_TYPE	= 0x00,  /* port type */
+	MVS_GBL_PORT_TYPE	= 0xa0,  /* port type */

 	MVS_CTL			= 0x100, /* SAS/SATA port configuration */
 	MVS_PCS			= 0x104, /* SAS/SATA port control/status */
@@ -102,11 +138,12 @@
 	MVS_TX_LO		= 0x124, /* TX (delivery) ring addr */
 	MVS_TX_HI		= 0x128,

-	MVS_RX_PROD_IDX		= 0x12C, /* RX producer pointer */
-	MVS_RX_CONS_IDX		= 0x130, /* RX consumer pointer (RO) */
+	MVS_TX_PROD_IDX		= 0x12C, /* TX producer pointer */
+	MVS_TX_CONS_IDX		= 0x130, /* TX consumer pointer (RO) */
 	MVS_RX_CFG		= 0x134, /* RX configuration */
 	MVS_RX_LO		= 0x138, /* RX (completion) ring addr */
 	MVS_RX_HI		= 0x13C,
+	MVS_RX_CONS_IDX		= 0x140, /* RX consumer pointer (RO) */	

 	MVS_INT_COAL		= 0x148, /* Int coalescing config */
 	MVS_INT_COAL_TMOUT	= 0x14C, /* Int coalescing timeout */
@@ -117,9 +154,12 @@
 					 /* ports 1-3 follow after this */
 	MVS_P0_INT_STAT		= 0x160, /* port0 interrupt status */
 	MVS_P0_INT_MASK		= 0x164, /* port0 interrupt mask */
+	MVS_P4_INT_STAT		= 0x200, /* Port 4 interrupt status */
+	MVS_P4_INT_MASK		= 0x204, /* Port 4 interrupt enable/disable mask */

 					 /* ports 1-3 follow after this */
 	MVS_P0_SER_CTLSTAT	= 0x180, /* port0 serial control/status */
+	MVS_P4_SER_CTLSTAT	= 0x220, /* port4 serial control/status */

 	MVS_CMD_ADDR		= 0x1B8, /* Command register port (addr) */
 	MVS_CMD_DATA		= 0x1BC, /* Command register port (data) */
@@ -127,6 +167,14 @@
 					 /* ports 1-3 follow after this */
 	MVS_P0_CFG_ADDR		= 0x1C0, /* port0 phy register address */
 	MVS_P0_CFG_DATA		= 0x1C4, /* port0 phy register data */
+	MVS_P4_CFG_ADDR		= 0x230, /* Port 4 config address */
+	MVS_P4_CFG_DATA		= 0x234, /* Port 4 config data */	
+	
+					 /* ports 1-3 follow after this */
+	MVS_P0_VSR_ADDR		= 0x1E0, /* port0 vendor specific register address */
+	MVS_P0_VSR_DATA		= 0x1E4, /* port0 vendor specific register data */	
+	MVS_P4_VSR_ADDR		= 0x250, /* port 4 Vendor Specific Register addr */
+	MVS_P4_VSR_DATA		= 0x254, /* port 4 Vendor Specific Register Data */		
 };

 enum hw_register_bits {
@@ -140,8 +188,31 @@

 	/* MVS_GBL_PORT_TYPE */			/* shl for ports 1-3 */
 	SATA_TARGET		= (1U << 16),	/* port0 SATA target enable */
-	AUTO_DET		= (1U << 8),	/* port0 SAS/SATA autodetect */
-	SAS_MODE		= (1U << 0),	/* port0 SAS(1), SATA(0) mode */
+	MODE_AUTO_DET_PORT7 = (1U << 15),	/* port0 SAS/SATA autodetect */
+	MODE_AUTO_DET_PORT6 = (1U << 14),
+	MODE_AUTO_DET_PORT5 = (1U << 13),
+	MODE_AUTO_DET_PORT4 = (1U << 12),
+	MODE_AUTO_DET_PORT3 = (1U << 11),
+	MODE_AUTO_DET_PORT2 = (1U << 10),
+	MODE_AUTO_DET_PORT1 = (1U << 9),
+	MODE_AUTO_DET_PORT0 = (1U << 8),
+	MODE_AUTO_DET_EN    = MODE_AUTO_DET_PORT0 | MODE_AUTO_DET_PORT1 |
+	                      MODE_AUTO_DET_PORT2 | MODE_AUTO_DET_PORT3 |
+	                      MODE_AUTO_DET_PORT4 | MODE_AUTO_DET_PORT5 |
+	                      MODE_AUTO_DET_PORT6 | MODE_AUTO_DET_PORT7,	
+	MODE_SAS_PORT7_MASK = (1U << 7),  /* port0 SAS(1), SATA(0) mode */
+	MODE_SAS_PORT6_MASK = (1U << 6),
+	MODE_SAS_PORT5_MASK = (1U << 5),
+	MODE_SAS_PORT4_MASK = (1U << 4),
+	MODE_SAS_PORT3_MASK = (1U << 3),
+	MODE_SAS_PORT2_MASK = (1U << 2),
+	MODE_SAS_PORT1_MASK = (1U << 1),
+	MODE_SAS_PORT0_MASK = (1U << 0),
+	MODE_SAS_SATA		= 	MODE_SAS_PORT0_MASK | MODE_SAS_PORT1_MASK |
+							MODE_SAS_PORT2_MASK | MODE_SAS_PORT3_MASK |
+							MODE_SAS_PORT4_MASK | MODE_SAS_PORT5_MASK |
+							MODE_SAS_PORT6_MASK | MODE_SAS_PORT7_MASK,
+
 						/* SAS_MODE value may be
 						 * dictated (in hw) by values
 						 * of SATA_TARGET & AUTO_DET
@@ -167,12 +238,14 @@
 	CINT_MEM		= (1U << 26),	/* int mem parity err */
 	CINT_I2C_SLAVE		= (1U << 25),	/* slave I2C event */
 	CINT_SRS		= (1U << 3),	/* SRS event */
-	CINT_CI_STOP		= (1U << 10),	/* cmd issue stopped */
+	CINT_CI_STOP		= (1U << 1),	/* cmd issue stopped */
 	CINT_DONE		= (1U << 0),	/* cmd completion */

 						/* shl for ports 1-3 */
 	CINT_PORT_STOPPED	= (1U << 16),	/* port0 stopped */
-	CINT_PORT		= (1U << 8),	/* port0 event */
+	CINT_PORT			= (1U << 8),	/* port0 event */
+	CINT_PORT_MASK_OFFSET	= 8,
+	CINT_PORT_MASK		= (0xFF << CINT_PORT_MASK_OFFSET),

 	/* TX (delivery) ring bits */
 	TXQ_CMD_SHIFT		= 29,
@@ -236,9 +309,14 @@

 	/* MVS_Px_SER_CTLSTAT (per-phy control) */
 	PHY_SSP_RST		= (1U << 3),	/* reset SSP link layer */
-	PHY_BCAST_CHG		= (1U << 2),	/* broadcast(change) notif */
-	PHY_RST_HARD		= (1U << 1),	/* hard reset + phy reset */
+	PHY_BCAST_CHG	= (1U << 2),	/* broadcast(change) notif */
+	PHY_RST_HARD	= (1U << 1),	/* hard reset + phy reset */
 	PHY_RST			= (1U << 0),	/* phy reset */
+	PHY_MIN_SPP_PHYS_LINK_RATE_MASK = (0xF << 8),
+	PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0xF << 12),
+	PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = 16,
+	PHY_NEG_SPP_PHYS_LINK_RATE_MASK = (0xF <<
PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET),
+	PHY_READY_MASK					= (1U << 20),

 	/* MVS_Px_INT_STAT, MVS_Px_INT_MASK (per-phy events) */
 	PHYEV_UNASSOC_FIS	= (1U << 19),	/* unassociated FIS rx'd */
@@ -260,12 +338,14 @@
 	PHYEV_RDY_CH		= (1U << 0),	/* phy ready changed state */

 	/* MVS_PCS */
+	PCS_EN_PORT_XMT_START	=  (12),		/*Enable Port Transmit*/
+	PCS_EN_PORT_XMT_START2	=  (8),			/*For 6480*/
 	PCS_SATA_RETRY		= (1U << 8),	/* retry ctl FIS on R_ERR */
 	PCS_RSP_RX_EN		= (1U << 7),	/* raw response rx */
 	PCS_SELF_CLEAR		= (1U << 5),	/* self-clearing int mode */
 	PCS_FIS_RX_EN		= (1U << 4),	/* FIS rx enable */
 	PCS_CMD_STOP_ERR	= (1U << 3),	/* cmd stop-on-err enable */
-	PCS_CMD_RST		= (1U << 2),	/* reset cmd issue */
+	PCS_CMD_RST		= (1U << 1),	/* reset cmd issue */
 	PCS_CMD_EN		= (1U << 0),	/* enable cmd issue */
 };

@@ -288,7 +368,7 @@
 	CMD_SAS_CTL1		= 0x128, /* SAS control register 1 */
 	CMD_SAS_CTL2		= 0x12c, /* SAS control register 2 */
 	CMD_SAS_CTL3		= 0x130, /* SAS control register 3 */
-	CMD_ID_TEST		= 0x134, /* ID test register */
+	CMD_ID_TEST			= 0x134, /* ID test register */
 	CMD_PL_TIMER		= 0x138, /* PL timer register */
 	CMD_WD_TIMER		= 0x13c, /* WD timer register */
 	CMD_PORT_SEL_COUNT	= 0x140, /* port selector count register */
@@ -345,12 +425,15 @@

 enum pci_cfg_registers {
 	PCR_PHY_CTL		= 0x40,
-	PCR_PHY_CTL2		= 0x90,
+	PCR_PHY_CTL2	= 0x90,
+	PCR_DEV_CTRL	= 0xE8,
 };

 enum pci_cfg_register_bits {
 	PCTL_PWR_ON		= (0xFU << 24),
 	PCTL_OFF		= (0xFU << 12),
+	PRD_REQ_SIZE	= (0x4000),
+	PRD_REQ_MASK	= (0x00007000),
 };

 enum nvram_layout_offsets {
@@ -412,8 +495,20 @@

 struct mvs_phy {
 	struct mvs_port		*port;
-	struct asd_sas_phy	sas_phy;
-
+	struct asd_sas_phy	sas_phy;	
+	struct sas_identify identify;
+/* from PORT_CONFIG_ADDR0-3, PhyID/device protocol/sas_addr/SIG/wide_port */
+	__le32		DevInfo;
+	__le64		DevSASAddr;
+	__le32		AttDevInfo;
+	__le64		AttDevSASAddr;
+	u8	   		Type;
+	u8	   		WidePortPhyMap;
+	u8	   		Reserved0[2];
+/* from PORT_PHY_CONTROL0-3, REG_PORT_PHY_CONTROL, linkrate, current status */
+	__le32		PhyStatus;
+/* from PORT_IRQ_MASK0-3 */
+	__le32		IRQStatus;
 	u8			frame_rcvd[24 + 1024];
 };

@@ -447,10 +542,19 @@

 					/* further per-slot information */
 	struct mvs_slot_info	slot_info[MVS_SLOTS];
-	unsigned long		tags[(MVS_SLOTS / sizeof(unsigned long)) + 1];
-
+	unsigned long		tags[MVS_SLOTS];
 	struct mvs_phy		phy[MVS_MAX_PHYS];
 	struct mvs_port		port[MVS_MAX_PHYS];
+
+	u32					can_queue;	/* per adapter */
+	u32					tag_out;	/*Get*/
+	u32					tag_in;		/*Give*/
+};
+
+struct mvs_queue_task {
+	struct list_head list;
+
+	void   *uldd_task;
 };

 static struct scsi_transport_template *mvs_stt;
@@ -464,27 +568,128 @@
 static struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
-	.queuecommand		= sas_queuecommand,
+	.queuecommand		= sas_queuecommand,		
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
 	.slave_destroy		= sas_slave_destroy,
 	.change_queue_depth	= sas_change_queue_depth,
 	.change_queue_type	= sas_change_queue_type,
 	.bios_param		= sas_bios_param,
-	.can_queue		= 1,
+	.can_queue		= 30,
 	.cmd_per_lun		= 1,
 	.this_id		= -1,
-	.sg_tablesize		= SG_ALL,
-	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
-	.use_clustering		= ENABLE_CLUSTERING,
+	.sg_tablesize		= 32,
+	.max_sectors		= (128*1024)>>9,
+	.use_clustering		= DISABLE_CLUSTERING,
 	.eh_device_reset_handler= sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
-	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 };

-static void mvs_int_rx(struct mvs_info *mvi, bool self_clear);
+static void mvs_hexdump (u32 size, u8 *data,u32 baseaddr)
+{
+	u32 i;
+	u32 run;
+	u32 offset;
+	
+	offset = 0;
+	while (size) {
+		printk ("%08X : ", baseaddr+offset);
+		if (size >= 16)
+			run = 16;
+		else
+			run = size;
+		size -= run;
+		for (i = 0; i < 16; i++){
+			if(i<run)
+				printk ("%02X ", (unsigned int) data[i]);
+			else
+				printk ("   ");
+		}
+		printk (": ");
+		for (i = 0; i < run; i++)
+			printk ("%c", isalnum (data[i]) ? data[i] : '.');
+		printk ("\n");
+		data = &data[16];
+		offset += run;
+	}
+	printk ("\n");
+}
+
+static inline void mvs_hba_sb_dump(struct mvs_info *mvi,u32 tag)
+{
+	u32 offset=MVS_SSP_CMD_SZ+MVS_OAF_SZ+sizeof(struct mvs_prd) *
mvi->slot_info[tag].n_elem;
+	MVS_PRINTK("+---->Status buffer :\n");
+	mvs_hexdump(32,(u8*)mvi->slot_info[tag].response,(u32)mvi->slot_info[tag].buf_dma+offset);
+}
+
+static void mvs_hba_memory_dump (struct mvs_info *mvi,u32 tag)
+{
+#if _MV_DUMP
+	u32 sz,w_ptr,r_ptr;
+	u64 addr;
+	void __iomem *regs = mvi->regs;
+	
+	/*Delivery Queue*/
+	sz		= mr32(TX_CFG) & TX_RING_SZ_MASK;
+	w_ptr	= mr32(TX_PROD_IDX) & TX_RING_SZ_MASK;
+	r_ptr	= mr32(TX_CONS_IDX) & TX_RING_SZ_MASK;
+	addr	= mr32(TX_HI)<<16<<16 | mr32(TX_LO);
+	MVS_PRINTK("Delivery Queue Size=%04d , WRT_PTR=%04X ,
RD_PTR=%04X\n",sz,w_ptr,r_ptr);
+	MVS_PRINTK("Delivery Queue Base Address=0x%llX (PA)(tx_dma=0x%llX),
Entry=%04d\n",addr,mvi->tx_dma,w_ptr);
+	mvs_hexdump(sizeof(u32),(u8*)mvi->tx,(u32)mvi->tx_dma+sizeof(u32)*w_ptr);
+	/*Command List*/
+	addr	= mr32(CMD_LIST_HI)<<16<<16 | mr32(CMD_LIST_LO);
+	MVS_PRINTK("Command List Base Address=0x%llX (PA)(slot_dma=0x%llX),
Header=%03d\n",addr,mvi->slot_dma,tag);
+	MVS_PRINTK("Command Header[%03d]:\n",tag);
+	mvs_hexdump(sizeof(struct
mvs_cmd_hdr),(u8*)mvi->slot,(u32)mvi->slot_dma+tag*sizeof(struct
mvs_cmd_hdr));/*mvs_cmd_hdr*/
+	/*1.command table area*/
+	MVS_PRINTK("+---->Command Table :\n");
+	mvs_hexdump(MVS_SSP_CMD_SZ,(u8*)mvi->slot_info[tag].buf,(u32)mvi->slot_info[tag].buf_dma);
+	/*2.open address frame area*/
+	MVS_PRINTK("+---->Open Address Frame :\n");
+	mvs_hexdump(MVS_OAF_SZ,(u8*)mvi->slot_info[tag].buf+MVS_SSP_CMD_SZ,(u32)mvi->slot_info[tag].buf_dma+MVS_SSP_CMD_SZ);
+	/*3.status buffer*/
+	mvs_hba_sb_dump(mvi,tag);
+	/*4.PRD table*/
+	MVS_PRINTK("+---->PRD table :\n");
+	mvs_hexdump(sizeof(struct mvs_prd) *
mvi->slot_info[tag].n_elem,(u8*)mvi->slot_info[tag].buf+MVS_SSP_CMD_SZ+MVS_OAF_SZ,(u32)mvi->slot_info[tag].buf_dma+MVS_SSP_CMD_SZ+MVS_OAF_SZ);
+#endif
+}
+
+static void mvs_hba_cq_dump (struct mvs_info *mvi)
+{
+#if _MV_DUMP
+	u64 addr;
+	void __iomem *regs = mvi->regs;
+	u32 entry=mvi->rx_cons+1;
+	u32 rx_desc=le32_to_cpu(mvi->rx[entry]);
+	/*Completion Queue*/
+	addr	= mr32(RX_HI)<<16<<16 | mr32(RX_LO);
+	MVS_PRINTK("Completion Task = 0x%08X\n",(u32)mvi->slot_info[rx_desc
& RXQ_SLOT_MASK].task);
+	MVS_PRINTK("Completion List Base Address=0x%llX (PA), CQ_Entry=%04d,
CQ_WP=0x%08X\n",addr,entry-1,mvi->rx[0]);
+	mvs_hexdump(sizeof(u32),(u8*)&rx_desc,mvi->rx_dma+sizeof(u32)*entry);
+#endif	
+}
+
+static void mvs_hba_interrupt_enable(struct mvs_info *mvi,int enable)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mvi->lock, flags);
+	tmp = mr32(GBL_CTL);
+
+	if (enable)
+		mw32(GBL_CTL ,tmp | INT_EN);
+	else
+		mw32(GBL_CTL , tmp & ~INT_EN);
+	spin_unlock_irqrestore(&mvi->lock,flags);
+}
+
+static int mvs_int_rx(struct mvs_info *mvi, bool self_clear);

 /* move to PCI layer or libata core? */
 static int pci_go_64(struct pci_dev *pdev)
@@ -519,36 +724,35 @@
 	return rc;
 }

-static void mvs_tag_clear(struct mvs_info *mvi, unsigned int tag)
+static void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
 {
-	mvi->tags[tag / sizeof(unsigned long)] &=
-		~(1UL << (tag % sizeof(unsigned long)));
+	mvi->tag_in = (mvi->tag_in+1) & (MVS_SLOTS-1);
+	mvi->tags[mvi->tag_in] = tag;
 }

-static void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
+static void mvs_tag_free(struct mvs_info *mvi, u32 tag)
 {
-	mvi->tags[tag / sizeof(unsigned long)] |=
-		(1UL << (tag % sizeof(unsigned long)));
+	mvi->tag_out = (mvi->tag_out-1) & (MVS_SLOTS-1);
+	MVS_PRINTK("clear2 tag %d\n",tag);
 }

-static bool mvs_tag_test(struct mvs_info *mvi, unsigned int tag)
+static int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
 {
-	return mvi->tags[tag / sizeof(unsigned long)] &
-		(1UL << (tag % sizeof(unsigned long)));
+	if (mvi->tag_out != mvi->tag_in){
+		*tag_out = mvi->tags[mvi->tag_out];
+		mvi->tag_out = (mvi->tag_out+1) & (MVS_SLOTS-1);
+		return 0;
+	}
+	return -EBUSY;
 }

-static int mvs_tag_alloc(struct mvs_info *mvi, unsigned int *tag_out)
+static void mvs_tag_init(struct mvs_info *mvi)
 {
-	unsigned int i;
-
-	for (i = 0; i < MVS_SLOTS; i++)
-		if (!mvs_tag_test(mvi, i)) {
-			mvs_tag_set(mvi, i);
-			*tag_out = i;
-			return 0;
-		}
-
-	return -EBUSY;
+	int i;
+	for (i = 0; i < MVS_SLOTS; ++i)
+		mvi->tags[i]=i;
+	mvi->tag_out = 0;
+	mvi->tag_in = MVS_SLOTS-1;
 }

 static int mvs_eep_read(void __iomem *regs, unsigned int addr, u32 *data)
@@ -627,6 +831,7 @@
 static int mvs_nvram_read(struct mvs_info *mvi, unsigned int addr,
 			  void *buf, unsigned int buflen)
 {
+#if 0
 	void __iomem *regs = mvi->regs;
 	int rc, i;
 	unsigned int sum;
@@ -666,11 +871,16 @@
 err_out:
 	dev_printk(KERN_ERR, &mvi->pdev->dev, "%s", msg);
 	return rc;
+#else
+	memcpy(buf,"\x50\x05\x04\x30\x11\xab\x00\x00",8);
+	return 0;
+#endif
 }

 static void mvs_int_port(struct mvs_info *mvi, int port_no, u32 events)
 {
-	/* FIXME */
+	/* events is port event.now ,we need check the interrupt status
which belongs to per port.*/
+	
 }

 static void mvs_int_sata(struct mvs_info *mvi)
@@ -708,9 +918,34 @@
 			 unsigned int slot_idx)
 {
 	/* FIXME */
+	mvs_hba_sb_dump(mvi,slot_idx);
+}
+
+static inline int mvs_can_queue(struct mvs_info *mvi, int num)
+{
+	int res = 0;
+	unsigned long flags;
+	
+	spin_lock_irqsave(&mvi->lock, flags);
+	if ((mvi->can_queue - num) < 0)
+		res = -EBUSY;
+	else
+		mvi->can_queue -= num;
+	spin_unlock_irqrestore(&mvi->lock, flags);
+
+	return res;
+}
+
+static inline void mvs_can_dequeue(struct mvs_info *mvi, int num)
+{
+//	unsigned long flags;
+
+//	spin_lock_irqsave(&mvi->lock, flags);
+	mvi->can_queue += num;
+//	spin_unlock_irqrestore(&mvi->lock, flags);
 }

-static void mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
+static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
 {
 	unsigned int slot_idx = rx_desc & RXQ_SLOT_MASK;
 	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
@@ -728,13 +963,13 @@
 	spin_unlock(&task->task_state_lock);

 	if (aborted)
-		return;
+		return -1;

 	memset(tstat, 0, sizeof(*tstat));
 	tstat->resp = SAS_TASK_COMPLETE;

 	/* error info record present */
-	if (rx_desc & RXQ_ERR) {
+	if ((rx_desc & RXQ_ERR) && (*(u64*)slot->response)) {
 		tstat->stat = SAM_CHECK_COND;
 		mvs_slot_err(mvi, task, slot_idx);
 		goto out;
@@ -743,9 +978,10 @@
 	switch (task->task_proto) {
 	case SAS_PROTO_SSP:
 		/* hw says status == 0, datapres == 0 */
-		if (rx_desc & RXQ_GOOD)
+		if (rx_desc & RXQ_GOOD){
 			tstat->stat = SAM_GOOD;
-
+			tstat->resp = SAS_TASK_COMPLETE;
+		}
 		/* response frame present */
 		else if (rx_desc & RXQ_RSP) {
 			struct ssp_response_iu *iu =
@@ -781,6 +1017,7 @@
 out:
 	mvs_slot_free(mvi, task, slot, slot_idx);
 	task->task_done(task);
+	return tstat->stat;
 }

 static void mvs_int_full(struct mvs_info *mvi)
@@ -791,6 +1028,8 @@

 	stat = mr32(INT_STAT);

+	mvs_int_rx(mvi, false);
+	
 	for (i = 0; i < MVS_MAX_PORTS; i++) {
 		tmp = (stat >> i) & (CINT_PORT | CINT_PORT_STOPPED);
 		if (tmp)
@@ -800,14 +1039,15 @@
 	if (stat & CINT_SRS)
 		mvs_int_sata(mvi);

-	if (stat & (CINT_CI_STOP | CINT_DONE))
-		mvs_int_rx(mvi, false);
+//	if (stat & (CINT_CI_STOP | CINT_DONE))
+//		mvs_int_rx(mvi, false);

-	mw32(INT_STAT, stat);
+//	mw32(INT_STAT, stat);
 }

-static void mvs_int_rx(struct mvs_info *mvi, bool self_clear)
+static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 {
+	void __iomem *regs = mvi->regs;
 	u32 rx_prod_idx, rx_desc;
 	bool attn = false;

@@ -816,32 +1056,41 @@
 	 * we don't have to stall the CPU reading that register.
 	 * The actual RX ring is offset by one dword, due to this.
 	 */
-	rx_prod_idx = le32_to_cpu(mvi->rx[0]) & 0xfff;
-	if (rx_prod_idx == 0xfff) {	/* h/w hasn't touched RX ring yet */
+	rx_prod_idx = le32_to_cpu(mr32(RX_CONS_IDX)) & RX_RING_SZ_MASK;
+	if (rx_prod_idx == 0xfff) { /* h/w hasn't touched RX ring yet */
 		mvi->rx_cons = 0xfff;
-		return;
+		return 0;
 	}
+
+/* The CMPL_Q may come late, read from register and try again */
+/* note: if coalescing is enabled, it will need to read from register
every time for sure */
+	if(mvi->rx_cons == rx_prod_idx)
+		return 0;
+	
 	if (mvi->rx_cons == 0xfff)
 		mvi->rx_cons = MVS_RX_RING_SZ - 1;

 	while (mvi->rx_cons != rx_prod_idx) {
+		
 		/* increment our internal RX consumer pointer */
-		mvi->rx_cons = (mvi->rx_cons + 1) & (MVS_RX_RING_SZ - 1);
-
-		/* Read RX descriptor at offset+1, due to above */
-		rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons + 1]);
+		mvi->rx_cons = (mvi->rx_cons + 1) & (MVS_RX_RING_SZ - 1);/*,then
mvi->rx_cons==rx_prod_idx==Entry No.-1*/

-		if (rx_desc & RXQ_DONE)
-			/* we had a completion, error or no */
-			mvs_slot_complete(mvi, rx_desc);
+		/* Read RX descriptor at offset+1, due to above ,point to right entry*/
+		rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons+1]);

-		if (rx_desc & RXQ_ATTN)
+		mvs_hba_cq_dump(mvi);
+		if (rx_desc & RXQ_ATTN){
 			attn = true;
+			MVS_PRINTK("ATTN\n");
+		}
+		else if ((rx_desc & RXQ_DONE))
+			mvs_slot_complete(mvi, rx_desc);
 	}

 	if (attn && self_clear)
 		mvs_int_full(mvi);

+	return 0;
 }

 static irqreturn_t mvs_interrupt(int irq, void *opaque)
@@ -851,6 +1100,9 @@
 	u32 stat;

 	stat = mr32(GBL_INT_STAT);
+
+	mw32_f(INT_STAT,CINT_DONE);// clear CMD_CMPLT ASAP
+	
 	if (stat == 0 || stat == 0xffffffff)
 		return IRQ_NONE;

@@ -918,7 +1170,7 @@
 	 * Fill in TX ring and command slot header
 	 */

-	mvi->tx[tag] = cpu_to_le32(
+	mvi->tx[mvi->tx_prod] = cpu_to_le32(
 		(TXQ_CMD_SMP << TXQ_CMD_SHIFT) | TXQ_MODE_I | tag);

 	hdr->flags = 0;
@@ -959,7 +1211,7 @@
 	unsigned int i, req_len, resp_len;

 	/* FIXME: fill in SATA register set */
-	mvi->tx[tag] = cpu_to_le32(TXQ_MODE_I | tag |
+	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
 		(TXQ_CMD_STP << TXQ_CMD_SHIFT) |
 		(sas_port->phy_mask << TXQ_PHY_SHIFT));

@@ -1044,7 +1296,7 @@
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct mvs_slot_info *slot;
 	struct scatterlist *sg;
-	unsigned int resp_len, req_len, i, tag = tei->tag;
+	u32 resp_len, req_len, i, tag = tei->tag;
 	struct mvs_prd *buf_prd;
 	struct ssp_frame_hdr *ssp_hdr;
 	void *buf_tmp;
@@ -1054,7 +1306,7 @@

 	slot = &mvi->slot_info[tag];

-	mvi->tx[tag] = cpu_to_le32(TXQ_MODE_I | tag |
+	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
 		(TXQ_CMD_SSP << TXQ_CMD_SHIFT) |
 		(sas_port->phy_mask << TXQ_PHY_SHIFT));

@@ -1104,10 +1356,12 @@
 	slot->response = buf_tmp;
 	hdr->status_buf = cpu_to_le64(buf_tmp_dma);

-	req_len = sizeof(struct ssp_frame_hdr) + 28;
 	resp_len = MVS_SLOT_BUF_SZ - MVS_SSP_CMD_SZ - MVS_OAF_SZ -
-		   sizeof(struct mvs_err_info) - i;
+	   sizeof(struct mvs_err_info) - i;
+	resp_len = min(resp_len,(u32)0x400);

+	req_len = sizeof(struct ssp_frame_hdr) + 28;
+	
 	/* request, response lengths */
 	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));

@@ -1118,7 +1372,7 @@
 	buf_oaf[3] = tag;
 	memcpy(buf_oaf + 4, task->dev->sas_addr, SAS_ADDR_SIZE);

-	/* fill in SSP frame header */
+	/* fill in SSP frame header (Command Table.SSP frame header)*/
 	ssp_hdr = (struct ssp_frame_hdr *) buf_cmd;
 	ssp_hdr->frame_type = SSP_COMMAND;
 	memcpy(ssp_hdr->hashed_dest_addr, task->dev->hashed_sas_addr,
@@ -1133,7 +1387,7 @@
 	buf_cmd[9] = fburst |
 		task->ssp_task.task_attr |
 		(task->ssp_task.task_prio << 3);
-	memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
+	memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);/*CDB*/

 	/* fill in PRD (scatter/gather) table, if any */
 	sg = task->scatter;
@@ -1155,72 +1409,99 @@
 	void __iomem *regs = mvi->regs;
 	unsigned long flags;
 	struct mvs_task_exec_info tei;
+	struct sas_task *t = task;
+	u32 n=num,pass=0;

-	/* FIXME: STP/SATA support not complete yet */
-	if (task->task_proto == SATA_PROTO || task->task_proto == SAS_PROTO_STP)
-		return -SAS_DEV_NO_RESPONSE;
-
-	if (task->num_scatter) {
-		n_elem = pci_map_sg(mvi->pdev, task->scatter,
-				    task->num_scatter, task->data_dir);
-		if (!n_elem)
-			return -ENOMEM;
-	}
-
-	spin_lock_irqsave(&mvi->lock, flags);
+	mvs_hba_interrupt_enable(mvi,0);

-	rc = mvs_tag_alloc(mvi, &tag);
-	if (rc)
-		goto err_out;
-
-	mvi->slot_info[tag].task = task;
-	mvi->slot_info[tag].n_elem = n_elem;
-	tei.task = task;
-	tei.hdr = &mvi->slot[tag];
-	tei.tag = tag;
-	tei.n_elem = n_elem;
+	do {
+		/* FIXME: STP/SATA support not complete yet */
+		if (t->task_proto == SATA_PROTO || t->task_proto == SAS_PROTO_STP)
+			return -SAS_DEV_NO_RESPONSE;
+
+		if (t->num_scatter) {
+			n_elem = pci_map_sg(mvi->pdev, t->scatter,
+					    t->num_scatter, t->data_dir);
+			if (!n_elem){
+				rc = -ENOMEM;
+				goto err_out;
+			}
+		}	

-	switch (task->task_proto) {
-	case SAS_PROTO_SMP:
-		rc = mvs_task_prep_smp(mvi, &tei);
-		break;
-	case SAS_PROTO_SSP:
-		rc = mvs_task_prep_ssp(mvi, &tei);
-		break;
-	case SATA_PROTO:
-	case SAS_PROTO_STP:
-		rc = mvs_task_prep_ata(mvi, &tei);
-		break;
-	default:
-		rc = -EINVAL;
-		break;
-	}
+		rc=mvs_tag_alloc(mvi, &tag);
+		if(rc)
+			goto err_out;

-	if (rc)
-		goto err_out_tag;
+		mvi->slot_info[tag].task = t;
+		mvi->slot_info[tag].n_elem = n_elem;
+		tei.task = t;
+		tei.hdr = &mvi->slot[tag];
+		tei.tag = tag;
+		tei.n_elem = n_elem;
+
+		switch (t->task_proto) {
+		case SAS_PROTO_SMP:
+			rc = mvs_task_prep_smp(mvi, &tei);
+			break;
+		case SAS_PROTO_SSP:
+			rc = mvs_task_prep_ssp(mvi, &tei);
+			break;
+		case SATA_PROTO:
+		case SAS_PROTO_STP:
+			rc = mvs_task_prep_ata(mvi, &tei);
+			break;
+		default:
+			rc = -EINVAL;
+			break;
+		}

-	/* TODO: select normal or high priority */
+		if (rc)
+			goto err_out_tag;

-	mw32(RX_PROD_IDX, mvi->tx_prod);
+		/* TODO: select normal or high priority */

-	mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_TX_RING_SZ - 1);
+		spin_lock_irqsave(&t->task_state_lock,flags);		
+		t->task_state_flags |= SAS_TASK_AT_INITIATOR;
+		spin_unlock_irqrestore(&t->task_state_lock,flags);	
+		
+		if( n == 1 ){
+			mvs_hba_interrupt_enable(mvi,1);
+			mw32(TX_PROD_IDX, mvi->tx_prod);
+		}
+			
+		++pass;
+		mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_TX_RING_SZ - 1);
+
+//		MVS_PRINTK("task=0x%08X,proto=%d,tag=%d,num=%d,mvi->tx_prod=%d\n",(u32)t,t->task_proto,tag,n,mvi->tx_prod);
+		mvs_hba_memory_dump(mvi,tag);
+		
+		if( n == 1 )
+			break;

-	spin_lock(&task->task_state_lock);
-	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
-	spin_unlock(&task->task_state_lock);
+		t = list_entry(t->list.next, struct sas_task, list);
+	}while(--n);

-	spin_unlock_irqrestore(&mvi->lock, flags);
 	return 0;

 err_out_tag:
-	mvs_tag_clear(mvi, tag);
+	mvs_tag_free(mvi, tag);
 err_out:
+	MVS_PRINTK("mvsas exec failed[%d]!\n",pass);
 	if (n_elem)
-		pci_unmap_sg(mvi->pdev, task->scatter, n_elem, task->data_dir);
-	spin_unlock_irqrestore(&mvi->lock, flags);
+		pci_unmap_sg(mvi->pdev, t->scatter, n_elem, t->data_dir);
+	if(pass)
+		mw32(TX_PROD_IDX, (mvi->tx_prod - 1) & (MVS_TX_RING_SZ - 1) );
+	mvs_hba_interrupt_enable(mvi,1);	
 	return rc;
 }

+static int mvs_abort_task(struct sas_task *task)
+{
+	/*FIXME*/
+	MVS_PRINTK("mvs abort task\n");
+	return TMF_RESP_FUNC_COMPLETE;
+}
+
 static void mvs_free(struct mvs_info *mvi)
 {
 	int i;
@@ -1249,10 +1530,12 @@
 				  mvi->rx, mvi->rx_dma);
 	if (mvi->slot)
 		dma_free_coherent(&mvi->pdev->dev,
-				  sizeof(*mvi->slot) * MVS_RX_RING_SZ,
+				  sizeof(*mvi->slot) * MVS_SLOTS,
 				  mvi->slot, mvi->slot_dma);
+#if 0	
 	if (mvi->peri_regs)
 		iounmap(mvi->peri_regs);
+#endif	
 	if (mvi->regs)
 		iounmap(mvi->regs);
 	if (mvi->shost)
@@ -1325,7 +1608,7 @@
 	sas_phy->tproto = 0;
 	sas_phy->type = PHY_TYPE_PHYSICAL;
 	sas_phy->role = PHY_ROLE_INITIATOR;
-	sas_phy->oob_mode = OOB_NOT_CONNECTED;
+	sas_phy->oob_mode = OOB_NOT_CONNECTED;	/*TODO*/
 	sas_phy->linkrate = SAS_LINK_RATE_UNKNOWN;

 	sas_phy->id = phy_id;
@@ -1339,7 +1622,7 @@
 				const struct pci_device_id *ent)
 {
 	struct mvs_info *mvi;
-	unsigned long res_start, res_len;
+	unsigned long res_start, res_len,res_flag;
 	struct asd_sas_phy **arr_phy;
 	struct asd_sas_port **arr_port;
 	const struct mvs_chip_info *chip = &mvs_chips[ent->driver_data];
@@ -1368,22 +1651,23 @@
 	if (!mvi->shost)
 		goto err_out;

-	arr_phy = kcalloc(MVS_MAX_PHYS, sizeof(void *), GFP_KERNEL);
-	arr_port = kcalloc(MVS_MAX_PHYS, sizeof(void *), GFP_KERNEL);
+	arr_phy = kcalloc( MVS_MAX_PHYS , sizeof(void *), GFP_KERNEL);
+	arr_port = kcalloc(MVS_MAX_PHYS , sizeof(void *), GFP_KERNEL);
 	if (!arr_phy || !arr_port)
 		goto err_out;

 	for (i = 0; i < MVS_MAX_PHYS; i++) {
 		mvs_phy_init(mvi, i);
 		arr_phy[i] = &mvi->phy[i].sas_phy;
-		arr_port[i] = &mvi->port[i].sas_port;
+		arr_port[i] = &mvi->port[i].sas_port;	
 	}

 	SHOST_TO_SAS_HA(mvi->shost) = &mvi->sas;
 	mvi->shost->transportt = mvs_stt;
-	mvi->shost->max_id = ~0;
-	mvi->shost->max_lun = ~0;
-	mvi->shost->max_cmd_len = ~0;
+	mvi->shost->max_id = 21;
+	mvi->shost->max_lun = 2;
+	mvi->shost->max_channel=0;
+	mvi->shost->max_cmd_len = 16;

 	mvi->sas.sas_ha_name = DRV_NAME;
 	mvi->sas.dev = &pdev->dev;
@@ -1392,12 +1676,14 @@
 	mvi->sas.sas_phy = arr_phy;
 	mvi->sas.sas_port = arr_port;
 	mvi->sas.num_phys = chip->n_phy;
-	mvi->sas.lldd_max_execute_num = MVS_TX_RING_SZ - 1;/* FIXME: correct? */
-	mvi->sas.lldd_queue_size = MVS_TX_RING_SZ - 1;	   /* FIXME: correct? */
+	mvi->sas.lldd_max_execute_num = MVS_TX_RING_SZ - 1;
+	mvi->sas.lldd_queue_size = mvi->shost->hostt->can_queue;
+	mvi->can_queue = (MVS_TX_RING_SZ>>1)-1;
 	mvi->sas.lldd_ha = mvi;
 	mvi->sas.core.shost = mvi->shost;

-	mvs_tag_set(mvi, MVS_TX_RING_SZ - 1);
+//	mvs_tag_set(mvi, MVS_TX_RING_SZ - 1);
+	mvs_tag_init(mvi);

 	/*
 	 * ioremap main and peripheral registers
@@ -1408,16 +1694,23 @@
 	if (!res_start || !res_len)
 		goto err_out;

+#if 0
 	mvi->peri_regs = ioremap_nocache(res_start, res_len);
-	if (!mvi->regs)
+	if (!mvi->peri_regs)
 		goto err_out;
+#endif

 	res_start = pci_resource_start(pdev, 4);
 	res_len = pci_resource_len(pdev, 4);
 	if (!res_start || !res_len)
 		goto err_out;

-	mvi->regs = ioremap_nocache(res_start, res_len);
+	res_flag = pci_resource_flags(pdev, 4);
+	if (res_flag & IORESOURCE_CACHEABLE)
+		mvi->regs = ioremap(res_start, res_len);
+	else
+		mvi->regs = ioremap_nocache(res_start, res_len);
+	
 	if (!mvi->regs)
 		goto err_out;

@@ -1468,7 +1761,6 @@
 	/* finally, read NVRAM to get our SAS address */
 	if (mvs_nvram_read(mvi, NVR_SAS_ADDR, &mvi->sas_addr, 8))
 		goto err_out;
-
 	return mvi;

 err_out:
@@ -1547,6 +1839,111 @@
 	tmp &= 0x1fffffff;
 	tmp |= (2U << 29);	/* 8 ms retry */
 	mvs_cw32(regs, CMD_PHY_TIMER, tmp);
+
+	/* TEST - for phy decoding error, adjust voltage levels */
+	mw32(P0_VSR_ADDR+0, 0x8);
+	mw32(P0_VSR_DATA+0, 0x2F0);
+
+	mw32(P0_VSR_ADDR+8, 0x8);
+	mw32(P0_VSR_DATA+8, 0x2F0);
+
+	mw32(P0_VSR_ADDR+16, 0x8);
+	mw32(P0_VSR_DATA+16, 0x2F0);
+
+	mw32(P0_VSR_ADDR+24, 0x8);
+	mw32(P0_VSR_DATA+24, 0x2F0);
+
+}
+
+static void mvs_enable_xmt(struct mvs_info *mvi, int PhyId)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	tmp=mr32(PCS);
+	if( mvi->chip->n_phy <= 4 )
+		tmp |= 1<<(PhyId + PCS_EN_PORT_XMT_START);
+	else
+		tmp |= 1<<(PhyId + PCS_EN_PORT_XMT_START2);
+	mw32(PCS , tmp);
+}
+
+static void mvs_detect_porttype(struct mvs_info *mvi, int i)
+{
+	void __iomem *regs = mvi->regs;
+	u32 reg;
+	struct mvs_phy *phy=&mvi->phy[i];
+
+	/* enable auto port detection */
+	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
+	msleep(100);
+
+    /* TODO check & save device type*/
+	reg = mr32(GBL_PORT_TYPE);
+
+	if (reg & MODE_SAS_SATA & (1 << i)){
+		phy->Type=PORT_TYPE_SAS;
+		phy->identify.target_port_protocols = SAS_PROTOCOL_SSP;
+		phy->identify.device_type = SAS_END_DEVICE;
+	}
+	else{
+		phy->Type=PORT_TYPE_SATA;
+		phy->identify.target_port_protocols = SAS_PROTOCOL_STP;
+		phy->identify.device_type = SAS_PHY_UNUSED;	
+	}
+	
+}
+
+static void mvs_update_phyinfo(struct mvs_info *mvi, int i)
+{
+	void __iomem *regs = mvi->regs;
+	struct mvs_phy *phy=&mvi->phy[i];
+	u32 tmp;
+	__le64 tmp64;
+
+	WRITE_PORT_CONFIG_ADDR(i,PHYR_IDENTIFY);
+	phy->DevInfo = READ_PORT_CONFIG_DATA(i);
+
+	WRITE_PORT_CONFIG_ADDR(i,PHYR_ADDR_HI);
+	phy->DevSASAddr = (__le64)READ_PORT_CONFIG_DATA(i) << 32;
+
+	WRITE_PORT_CONFIG_ADDR(i,PHYR_ADDR_LO);
+	phy->DevSASAddr |= READ_PORT_CONFIG_DATA(i);/*le*/
+
+	phy->PhyStatus = READ_PORT_PHY_CONTROL(i);
+
+//	MVS_PRINTK("PhyStatus=%X\n",phy->PhyStatus);
+	if (phy->PhyStatus & PHY_READY_MASK){
+		if (phy->Type&PORT_TYPE_SAS){
+			WRITE_PORT_CONFIG_ADDR(i,PHYR_ATT_DEV_INFO);
+			phy->AttDevInfo = READ_PORT_CONFIG_DATA(i);
+
+			WRITE_PORT_CONFIG_ADDR(i,PHYR_ATT_ADDR_HI);
+			phy->AttDevSASAddr  = (__le64)READ_PORT_CONFIG_DATA(i)<<32;
+			
+			WRITE_PORT_CONFIG_ADDR(i,PHYR_ATT_ADDR_LO);
+			phy->AttDevSASAddr |= READ_PORT_CONFIG_DATA(i);
+
+			/*Updated attached_sas_addr*/
+			tmp64=phy->AttDevSASAddr;
+			MVS_PRINTK("phy[%d] Get Attached Address 0x%llX  ",i,tmp64);
+			tmp64=cpu_to_be64(tmp64);
+			memcpy(mvi->sas.sas_phy[i]->attached_sas_addr,&tmp64,SAS_ADDR_SIZE);
+			/**/
+			mvi->sas.sas_phy[i]->linkrate=(phy->PhyStatus &
PHY_NEG_SPP_PHYS_LINK_RATE_MASK)>>PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
+//			mvi->sas.sas_phy[i]->tproto=phy->identify.target_port_protocols;
+		}		
+		/* workaround for HW phy decoding error on 1.5g disk drive */
+		WRITE_PORT_VSR_ADDR(i,0x06);
+		tmp=READ_PORT_VSR_DATA(i);
+		if( ((phy->PhyStatus & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET) == SAS_LINK_RATE_1_5_GBPS)
+			tmp&=~0x20000000;
+		else
+			tmp|=0x20000000;
+		WRITE_PORT_VSR_DATA(i,tmp);
+	
+	}
+	phy->IRQStatus = READ_PORT_IRQ_STAT(i);
 }

 static int __devinit mvs_hw_init(struct mvs_info *mvi)
@@ -1559,6 +1956,7 @@
 	mw32(GBL_CTL, 0);
 	tmp = mr32(GBL_CTL);

+	/*ResetController*/
 	if (!(tmp & HBA_RST)) {
 		if (mvi->flags & MVF_PHY_PWR_FIX) {
 			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
@@ -1590,13 +1988,23 @@
 		return -EBUSY;
 	}

+	/*InitChip*/
 	/* make sure RST is set; HBA_RST /should/ have done that for us */
-	cctl = mr32(CTL);
+	cctl = mr32(CTL);	/*MVS_CTL*/
 	if (cctl & CCTL_RST)
 		cctl &= ~CCTL_RST;
 	else
 		mw32_f(CTL, cctl | CCTL_RST);

+	pci_read_config_dword(mvi->pdev, PCI_COMMAND, &tmp);
+	tmp |= PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
PCI_COMMAND_MASTER;	/*MV_PCI_DEV_EN*/
+	pci_write_config_dword(mvi->pdev, PCI_COMMAND, tmp);
+	/* write to device control _AND_ device status register? - A.C. */
+	pci_read_config_dword(mvi->pdev, PCR_DEV_CTRL, &tmp);
+	tmp &= ~PRD_REQ_MASK;
+	tmp |= PRD_REQ_SIZE;
+	pci_write_config_dword(mvi->pdev, PCR_DEV_CTRL, tmp);	
+	
 	pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
 	tmp |= PCTL_PWR_ON;
 	tmp &= ~PCTL_OFF;
@@ -1609,6 +2017,9 @@

 	mw32_f(CTL, cctl);

+	/* reset control */
+	mw32(PCS, 0);	/*MVS_PCS*/
+
 	mvs_phy_hacks(mvi);

 	mw32(CMD_LIST_LO, mvi->slot_dma);
@@ -1631,6 +2042,8 @@
 		u32 lo = *((u32 *) &mvi->sas_addr[0]);
 		u32 hi = *((u32 *) &mvi->sas_addr[4]);

+		mvs_detect_porttype(mvi,i);
+		
 		/* set phy local SAS address */
 		mvs_phy_write(mvi, i, PHYR_ADDR_LO, lo);
 		mvs_phy_write(mvi, i, PHYR_ADDR_HI, hi);
@@ -1651,19 +2064,51 @@
 		/* clear phy int status */
 		tmp = readl(regs + MVS_P0_INT_STAT + (i * 8));
 		writel(tmp, regs + MVS_P0_INT_STAT + (i * 8));
+		mvs_update_phyinfo(mvi, i);
+		mvs_enable_xmt(mvi, i);
 	}

 	/* FIXME: update wide port bitmaps */

+	/* little endian for open address and command table, etc. */
+	/* A.C.
+	 * it seems that ( from the spec ) turning on big-endian won't
+	 * do us any good on big-endian machines, need further confirmation
+	 */
+	cctl = mr32(CTL);
+	cctl |= CCTL_ENDIAN_CMD;
+	cctl |= CCTL_ENDIAN_DATA;
+	cctl &= ~CCTL_ENDIAN_OPEN;
+	cctl |= CCTL_ENDIAN_RSP;
+	mw32_f(CTL, cctl);
+
+	/* reset CMD queue */
+	tmp = mr32(PCS);
+	tmp |= PCS_CMD_RST;
+	mw32(PCS, tmp);
+	/* interrupt coalescing may cause missing HW interrput in some case */
+	/* and the max count is 0x1ff, while our max slot is 0x200, it will
make count 0 */
+	tmp = 0;
+	mw32(INT_COAL, tmp);
+
+	tmp = 0x100;
+	mw32(INT_COAL_TMOUT, tmp);
+
 	/* ladies and gentlemen, start your engines */
+	mw32(TX_CFG,0);
 	mw32(TX_CFG, MVS_TX_RING_SZ | TX_EN);
 	mw32(RX_CFG, MVS_RX_RING_SZ | RX_EN);
+	/* enable CMD/CMPL_Q/RESP mode */
 	mw32(PCS, PCS_SATA_RETRY | PCS_FIS_RX_EN | PCS_CMD_EN |
 	     ((mvi->flags & MVF_MSI) ? PCS_SELF_CLEAR : 0));

 	/* re-enable interrupts globally */
 	mw32(GBL_CTL, INT_EN);

+	/* enable completion queue interrupt */
+	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM);
+	mw32(INT_MASK, tmp);
+
 	return 0;
 }

@@ -1731,7 +2176,25 @@

 	mvs_print_info(mvi);

+#if 0	/*For debugging*/
 	scsi_scan_host(mvi->shost);
+#else
+{
+	int i;
+	static struct sas_identify_frame id[4];/*sas_get_port_device*/
+//	id=kcalloc(mvi->chip->n_phy * sizeof(struct sas_identify_frame),
sizeof(void *), GFP_KERNEL);
+	for (i = 0; i < mvi->chip->n_phy; ++i) {
+		struct mvs_phy *phy=&mvi->phy[i];
+		id[i].dev_type=phy->identify.device_type;
+		id[i].initiator_bits=SAS_PROTO_ALL;
+		id[i].target_bits=phy->identify.target_port_protocols;
+		mvi->sas.sas_phy[i]->frame_rcvd=(u8*)&(id[i]);/*SAS_END_DEV,sas_identify_frame*/
+		mvi->sas.sas_phy[i]->frame_rcvd_size=32;	
+		mvi->sas.notify_port_event(mvi->sas.sas_phy[i], PORTE_BYTES_DMAED);
+	}
+}
+#endif
+
 	return 0;

 err_out_shost:
@@ -1771,6 +2234,7 @@
 static struct sas_domain_function_template mvs_transport_ops = {
 	.lldd_execute_task	= mvs_task_exec,
 	.lldd_control_phy	= mvs_phy_control,
+	.lldd_abort_task	= mvs_abort_task,
 };

 static struct pci_device_id __devinitdata mvs_pci_table[] = {
