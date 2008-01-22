From: "Ke Wei" <kewei.mv@gmail.com>
Subject: [PATCH] Marvell 6440 SAS/SATA driver
Date: Tue, 22 Jan 2008 23:24:40 +0800
Message-ID: <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
References: <20080122151857.GA8680@ubuntu.domain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:29170 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYAVPYl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 10:24:41 -0500
Received: by wa-out-1112.google.com with SMTP id v27so4446754wah.23
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jan 2008 07:24:40 -0800 (PST)
In-Reply-To: <20080122151857.GA8680@ubuntu.domain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, jeff@garzik.org

This is Marvell 88SE6440 SAS/SATA HBA support for kernel version 2.6.24-rc8
which is 'sas' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git .

Marvell 6440 SAS/SATA non-raid driver supports SAS HDD , SATA Devices(ATA/ATAPI)
.

No support for Wide Port , SATA PM , Expander and Hot plug.

I disabled PCI MSI at the kernel boot prompt , so the driver will work failed
for this version if using MSI .

Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c | 1241 ++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 998 insertions(+), 243 deletions(-)
 mode change 100644 => 100755 drivers/scsi/mvsas.c

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
old mode 100644
new mode 100755
index e31ed5a..fb376a7
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2,6 +2,7 @@
       mvsas.c - Marvell 88SE6440 SAS/SATA support

       Copyright 2007 Red Hat, Inc.
+       Copyright 2008 Marvell. <kewei@marvell.com>

       This program is free software; you can redistribute it and/or
       modify it under the terms of the GNU General Public License as
@@ -37,8 +38,13 @@
 #include <scsi/libsas.h>
 #include <asm/io.h>

-#define DRV_NAME "mvsas"
-#define DRV_VERSION "0.1"
+#define DRV_NAME       "mvsas"
+#define DRV_VERSION    "0.3"
+#define _MV_DUMP 0
+#define MVS_DISABLE_NVRAM
+#define MVS_QUEUE_SIZE (30)
+#define MVS_PRINTK(_x_, ...) \
+       printk(KERN_NOTICE DRV_NAME ": " _x_ , ## __VA_ARGS__)

 #define mr32(reg)      readl(regs + MVS_##reg)
 #define mw32(reg,val)  writel((val), regs + MVS_##reg)
@@ -47,6 +53,65 @@
       readl(regs + MVS_##reg);                \
       } while (0)

+#define MVS_BIT(x)             (1L << (x))
+
+#define PORT_TYPE_SATA         MVS_BIT(0)
+#define PORT_TYPE_SAS          MVS_BIT(1)
+
+#define MVS_ID_NOT_MAPPED      0xff
+#define MVS_CHIP_SLOT_SZ       (1U << mvi->chip->slot_width)
+
+/* offset for D2H FIS in the Received FIS List Structure */
+#define SATA_RECEIVED_D2H_FIS(reg_set) \
+       (mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x40)
+#define SATA_RECEIVED_PIO_FIS(reg_set) \
+       (mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x20)
+#define UNASSOC_D2H_FIS(id) \
+       (mvi->rx_fis + 0x100 * id)
+
+
+#define READ_PORT_CONFIG_DATA(i) \
+       ((i > 3)?mr32(P4_CFG_DATA + (i - 4) * 8):mr32(P0_CFG_DATA + i * 8))
+#define WRITE_PORT_CONFIG_DATA(i,tmp) \
+       {if (i > 3)mw32(P4_CFG_DATA + (i - 4) * 8, tmp); \
+       else \
+               mw32(P0_CFG_DATA + i * 8, tmp); }
+#define WRITE_PORT_CONFIG_ADDR(i,tmp) \
+       {if (i > 3)mw32(P4_CFG_ADDR + (i - 4) * 8, tmp); \
+       else \
+               mw32(P0_CFG_ADDR + i * 8, tmp); }
+
+#define READ_PORT_PHY_CONTROL(i) \
+       ((i > 3)?mr32(P4_SER_CTLSTAT + (i - 4) * 4):mr32(P0_SER_CTLSTAT+i * 4))
+#define WRITE_PORT_PHY_CONTROL(i,tmp) \
+       {if (i > 3)mw32(P4_SER_CTLSTAT + (i - 4) * 4, tmp); \
+       else \
+               mw32(P0_SER_CTLSTAT + i * 4, tmp); }
+
+#define READ_PORT_VSR_DATA(i) \
+       ((i > 3)?mr32(P4_VSR_DATA + (i - 4) * 8):mr32(P0_VSR_DATA+i*8))
+#define WRITE_PORT_VSR_DATA(i,tmp) \
+       {if (i > 3)mw32(P4_VSR_DATA + (i - 4) * 8, tmp); \
+       else \
+               mw32(P0_VSR_DATA + i*8, tmp); }
+#define WRITE_PORT_VSR_ADDR(i,tmp) \
+       {if (i > 3)mw32(P4_VSR_ADDR + (i - 4) * 8, tmp); \
+       else \
+               mw32(P0_VSR_ADDR + i * 8, tmp); }
+
+#define READ_PORT_IRQ_STAT(i) \
+       ((i > 3)?mr32(P4_INT_STAT + (i - 4) * 8):mr32(P0_INT_STAT + i * 8))
+#define WRITE_PORT_IRQ_STAT(i,tmp) \
+       {if (i > 3)mw32(P4_INT_STAT + (i-4) * 8, tmp); \
+       else \
+               mw32(P0_INT_STAT + i * 8, tmp); }
+#define READ_PORT_IRQ_MASK(i) \
+       ((i > 3)?mr32(P4_INT_MASK + (i-4) * 8):mr32(P0_INT_MASK+i*8))
+#define WRITE_PORT_IRQ_MASK(i,tmp) \
+       {if (i > 3)mw32(P4_INT_MASK + (i-4) * 8, tmp); \
+       else \
+               mw32(P0_INT_MASK + i * 8, tmp); }
+
 /* driver compile-time configuration */
 enum driver_configuration {
       MVS_TX_RING_SZ          = 1024, /* TX ring size (12-bit) */
@@ -57,7 +122,7 @@ enum driver_configuration {
       MVS_SLOTS               = 512,  /* command slots */
       MVS_SLOT_BUF_SZ         = 8192, /* cmd tbl + IU + status + PRD */
       MVS_SSP_CMD_SZ          = 64,   /* SSP command table buffer size */
-       MVS_ATA_CMD_SZ          = 128,  /* SATA command table buffer size */
+       MVS_ATA_CMD_SZ          = 96,   /* SATA command table buffer size */
       MVS_OAF_SZ              = 64,   /* Open address frame buffer size */

       MVS_RX_FIS_COUNT        = 17,   /* Optional rx'd FISs (max 17) */
@@ -89,7 +154,7 @@ enum hw_registers {
       MVS_GBL_CTL             = 0x04,  /* global control */
       MVS_GBL_INT_STAT        = 0x08,  /* global irq status */
       MVS_GBL_PI              = 0x0C,  /* ports implemented bitmask */
-       MVS_GBL_PORT_TYPE       = 0x00,  /* port type */
+       MVS_GBL_PORT_TYPE       = 0xa0,  /* port type */

       MVS_CTL                 = 0x100, /* SAS/SATA port configuration */
       MVS_PCS                 = 0x104, /* SAS/SATA port control/status */
@@ -102,11 +167,12 @@ enum hw_registers {
       MVS_TX_LO               = 0x124, /* TX (delivery) ring addr */
       MVS_TX_HI               = 0x128,

-       MVS_RX_PROD_IDX         = 0x12C, /* RX producer pointer */
-       MVS_RX_CONS_IDX         = 0x130, /* RX consumer pointer (RO) */
+       MVS_TX_PROD_IDX         = 0x12C, /* TX producer pointer */
+       MVS_TX_CONS_IDX         = 0x130, /* TX consumer pointer (RO) */
       MVS_RX_CFG              = 0x134, /* RX configuration */
       MVS_RX_LO               = 0x138, /* RX (completion) ring addr */
       MVS_RX_HI               = 0x13C,
+       MVS_RX_CONS_IDX         = 0x140, /* RX consumer pointer (RO) */

       MVS_INT_COAL            = 0x148, /* Int coalescing config */
       MVS_INT_COAL_TMOUT      = 0x14C, /* Int coalescing timeout */
@@ -117,9 +183,12 @@ enum hw_registers {
                                        /* ports 1-3 follow after this */
       MVS_P0_INT_STAT         = 0x160, /* port0 interrupt status */
       MVS_P0_INT_MASK         = 0x164, /* port0 interrupt mask */
+       MVS_P4_INT_STAT         = 0x200, /* Port 4 interrupt status */
+       MVS_P4_INT_MASK         = 0x204, /* Port 4 interrupt enable mask */

                                        /* ports 1-3 follow after this */
       MVS_P0_SER_CTLSTAT      = 0x180, /* port0 serial control/status */
+       MVS_P4_SER_CTLSTAT      = 0x220, /* port4 serial control/status */

       MVS_CMD_ADDR            = 0x1B8, /* Command register port (addr) */
       MVS_CMD_DATA            = 0x1BC, /* Command register port (data) */
@@ -127,6 +196,14 @@ enum hw_registers {
                                        /* ports 1-3 follow after this */
       MVS_P0_CFG_ADDR         = 0x1C0, /* port0 phy register address */
       MVS_P0_CFG_DATA         = 0x1C4, /* port0 phy register data */
+       MVS_P4_CFG_ADDR         = 0x230, /* Port 4 config address */
+       MVS_P4_CFG_DATA         = 0x234, /* Port 4 config data */
+
+                                        /* ports 1-3 follow after this */
+       MVS_P0_VSR_ADDR         = 0x1E0, /* port0 VSR address */
+       MVS_P0_VSR_DATA         = 0x1E4, /* port0 VSR data */
+       MVS_P4_VSR_ADDR         = 0x250, /* port 4 VSR addr */
+       MVS_P4_VSR_DATA         = 0x254, /* port 4 VSR data */
 };

 enum hw_register_bits {
@@ -140,12 +217,35 @@ enum hw_register_bits {

       /* MVS_GBL_PORT_TYPE */                 /* shl for ports 1-3 */
       SATA_TARGET             = (1U << 16),   /* port0 SATA target enable */
-       AUTO_DET                = (1U << 8),    /* port0 SAS/SATA autodetect */
-       SAS_MODE                = (1U << 0),    /* port0 SAS(1), SATA(0) mode */
-                                               /* SAS_MODE value may be
-                                                * dictated (in hw) by values
-                                                * of SATA_TARGET & AUTO_DET
-                                                */
+       MODE_AUTO_DET_PORT7 = (1U << 15),       /* port0 SAS/SATA autodetect */
+       MODE_AUTO_DET_PORT6 = (1U << 14),
+       MODE_AUTO_DET_PORT5 = (1U << 13),
+       MODE_AUTO_DET_PORT4 = (1U << 12),
+       MODE_AUTO_DET_PORT3 = (1U << 11),
+       MODE_AUTO_DET_PORT2 = (1U << 10),
+       MODE_AUTO_DET_PORT1 = (1U << 9),
+       MODE_AUTO_DET_PORT0 = (1U << 8),
+       MODE_AUTO_DET_EN    =   MODE_AUTO_DET_PORT0 | MODE_AUTO_DET_PORT1 |
+                               MODE_AUTO_DET_PORT2 | MODE_AUTO_DET_PORT3 |
+                               MODE_AUTO_DET_PORT4 | MODE_AUTO_DET_PORT5 |
+                               MODE_AUTO_DET_PORT6 | MODE_AUTO_DET_PORT7,
+       MODE_SAS_PORT7_MASK = (1U << 7),  /* port0 SAS(1), SATA(0) mode */
+       MODE_SAS_PORT6_MASK = (1U << 6),
+       MODE_SAS_PORT5_MASK = (1U << 5),
+       MODE_SAS_PORT4_MASK = (1U << 4),
+       MODE_SAS_PORT3_MASK = (1U << 3),
+       MODE_SAS_PORT2_MASK = (1U << 2),
+       MODE_SAS_PORT1_MASK = (1U << 1),
+       MODE_SAS_PORT0_MASK = (1U << 0),
+       MODE_SAS_SATA   =       MODE_SAS_PORT0_MASK | MODE_SAS_PORT1_MASK |
+                               MODE_SAS_PORT2_MASK | MODE_SAS_PORT3_MASK |
+                               MODE_SAS_PORT4_MASK | MODE_SAS_PORT5_MASK |
+                               MODE_SAS_PORT6_MASK | MODE_SAS_PORT7_MASK,
+
+                               /* SAS_MODE value may be
+                                * dictated (in hw) by values
+                                * of SATA_TARGET & AUTO_DET
+                                */

       /* MVS_TX_CFG */
       TX_EN                   = (1U << 16),   /* Enable TX */
@@ -167,12 +267,14 @@ enum hw_register_bits {
       CINT_MEM                = (1U << 26),   /* int mem parity err */
       CINT_I2C_SLAVE          = (1U << 25),   /* slave I2C event */
       CINT_SRS                = (1U << 3),    /* SRS event */
-       CINT_CI_STOP            = (1U << 10),   /* cmd issue stopped */
+       CINT_CI_STOP            = (1U << 1),    /* cmd issue stopped */
       CINT_DONE               = (1U << 0),    /* cmd completion */

                                               /* shl for ports 1-3 */
       CINT_PORT_STOPPED       = (1U << 16),   /* port0 stopped */
-       CINT_PORT               = (1U << 8),    /* port0 event */
+       CINT_PORT                       = (1U << 8),    /* port0 event */
+       CINT_PORT_MASK_OFFSET   = 8,
+       CINT_PORT_MASK          = (0xFF << CINT_PORT_MASK_OFFSET),

       /* TX (delivery) ring bits */
       TXQ_CMD_SHIFT           = 29,
@@ -239,6 +341,12 @@ enum hw_register_bits {
       PHY_BCAST_CHG           = (1U << 2),    /* broadcast(change) notif */
       PHY_RST_HARD            = (1U << 1),    /* hard reset + phy reset */
       PHY_RST                 = (1U << 0),    /* phy reset */
+       PHY_MIN_SPP_PHYS_LINK_RATE_MASK = (0xF << 8),
+       PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0xF << 12),
+       PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = (16),
+       PHY_NEG_SPP_PHYS_LINK_RATE_MASK =
+                       (0xF << PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET),
+       PHY_READY_MASK          = (1U << 20),

       /* MVS_Px_INT_STAT, MVS_Px_INT_MASK (per-phy events) */
       PHYEV_UNASSOC_FIS       = (1U << 19),   /* unassociated FIS rx'd */
@@ -260,13 +368,33 @@ enum hw_register_bits {
       PHYEV_RDY_CH            = (1U << 0),    /* phy ready changed state */

       /* MVS_PCS */
+       PCS_EN_SATA_REG         = (16),         /* Enable SATA Register Set*/
+       PCS_EN_PORT_XMT_START   = (12),         /* Enable Port Transmit*/
+       PCS_EN_PORT_XMT_START2  = (8),          /* For 6480*/
       PCS_SATA_RETRY          = (1U << 8),    /* retry ctl FIS on R_ERR */
       PCS_RSP_RX_EN           = (1U << 7),    /* raw response rx */
       PCS_SELF_CLEAR          = (1U << 5),    /* self-clearing int mode */
       PCS_FIS_RX_EN           = (1U << 4),    /* FIS rx enable */
       PCS_CMD_STOP_ERR        = (1U << 3),    /* cmd stop-on-err enable */
-       PCS_CMD_RST             = (1U << 2),    /* reset cmd issue */
+       PCS_CMD_RST             = (1U << 1),    /* reset cmd issue */
       PCS_CMD_EN              = (1U << 0),    /* enable cmd issue */
+
+       /*Port n Attached Device Info*/
+       PORT_DEV_SSP_TRGT       = (1U << 19),
+       PORT_DEV_SMP_TRGT       = (1U << 18),
+       PORT_DEV_STP_TRGT       = (1U << 17),
+       PORT_DEV_SSP_INIT       = (1U << 11),
+       PORT_DEV_SMP_INIT       = (1U << 10),
+       PORT_DEV_STP_INIT       = (1U << 9),
+       PORT_PHY_ID_MASK        = (0xFFU << 24),
+       PORT_DEV_TRGT_MASK      = (0x7U << 17),
+       PORT_DEV_INIT_MASK      = (0x7U << 9),
+       PORT_DEV_TYPE_MASK      = (0x7U << 0),
+
+       /*Port n PHY Status*/
+       PHY_RDY                 = (1U << 2),
+       PHY_DW_SYNC             = (1U << 1),
+       PHY_OOB_DTCTD           = (1U << 0),
 };

 enum mvs_info_flags {
@@ -329,14 +457,20 @@ enum sas_cmd_port_registers {

 /* SAS/SATA configuration port registers, aka phy registers */
 enum sas_sata_config_port_regs {
-       PHYR_IDENTIFY           = 0x0,  /* info for IDENTIFY frame */
-       PHYR_ADDR_LO            = 0x4,  /* my SAS address (low) */
-       PHYR_ADDR_HI            = 0x8,  /* my SAS address (high) */
-       PHYR_ATT_DEV_INFO       = 0xC,  /* attached device info */
+       PHYR_IDENTIFY           = 0x00, /* info for IDENTIFY frame */
+       PHYR_ADDR_LO            = 0x04, /* my SAS address (low) */
+       PHYR_ADDR_HI            = 0x08, /* my SAS address (high) */
+       PHYR_ATT_DEV_INFO       = 0x0C, /* attached device info */
       PHYR_ATT_ADDR_LO        = 0x10, /* attached dev SAS addr (low) */
       PHYR_ATT_ADDR_HI        = 0x14, /* attached dev SAS addr (high) */
       PHYR_SATA_CTL           = 0x18, /* SATA control */
       PHYR_PHY_STAT           = 0x1C, /* PHY status */
+       PHYR_SATA_SIG0          = 0x20, /*port SATA signature FIS(Byte 0-3) */
+       PHYR_SATA_SIG1          = 0x24, /*port SATA signature FIS(Byte 4-7) */
+       PHYR_SATA_SIG2          = 0x28, /*port SATA signature FIS(Byte 8-11) */
+       PHYR_SATA_SIG3          = 0x2c, /*port SATA signature FIS(Byte 12-15) */
+       PHYR_R_ERR_COUNT        = 0x30, /* port R_ERR count register */
+       PHYR_CRC_ERR_COUNT      = 0x34, /* port CRC error count register */
       PHYR_WIDE_PORT          = 0x38, /* wide port participating */
       PHYR_CURRENT0           = 0x80, /* current connection info 0 */
       PHYR_CURRENT1           = 0x84, /* current connection info 1 */
@@ -344,18 +478,21 @@ enum sas_sata_config_port_regs {
 };

 enum pci_cfg_registers {
-       PCR_PHY_CTL             = 0x40,
-       PCR_PHY_CTL2            = 0x90,
+       PCR_PHY_CTL     = 0x40,
+       PCR_PHY_CTL2    = 0x90,
+       PCR_DEV_CTRL    = 0xE8,
 };

 enum pci_cfg_register_bits {
-       PCTL_PWR_ON             = (0xFU << 24),
-       PCTL_OFF                = (0xFU << 12),
+       PCTL_PWR_ON     = (0xFU << 24),
+       PCTL_OFF        = (0xFU << 12),
+       PRD_REQ_SIZE    = (0x4000),
+       PRD_REQ_MASK    = (0x00007000),
 };

 enum nvram_layout_offsets {
-       NVR_SIG                 = 0x00,         /* 0xAA, 0x55 */
-       NVR_SAS_ADDR            = 0x02,         /* 8-byte SAS address */
+       NVR_SIG         = 0x00,         /* 0xAA, 0x55 */
+       NVR_SAS_ADDR    = 0x02,         /* 8-byte SAS address */
 };

 enum chip_flavors {
@@ -365,9 +502,9 @@ enum chip_flavors {
 };

 struct mvs_chip_info {
-       unsigned int            n_phy;
-       unsigned int            srs_sz;
-       unsigned int            slot_width;
+       u32             n_phy;
+       u32             srs_sz;
+       u32             slot_width;
 };

 struct mvs_err_info {
@@ -408,13 +545,24 @@ struct mvs_slot_info {

 struct mvs_port {
       struct asd_sas_port     sas_port;
+       u8                      taskfileset;
 };

 struct mvs_phy {
       struct mvs_port         *port;
       struct asd_sas_phy      sas_phy;
+       struct sas_identify identify;
+       __le32          devinfo;
+       __le64          devsasaddr;
+       __le32          attdevinfo;
+       __le64          attdevsasaddr;
+       u32             type;
+       __le32          phystatus;
+       __le32          irqstatus;
+       u8              wideportphymap;
+       u32             frame_rcvd_size;
+       u8              frame_rcvd[32];

-       u8                      frame_rcvd[24 + 1024];
 };

 struct mvs_info {
@@ -437,27 +585,39 @@ struct mvs_info {
       dma_addr_t              rx_dma;
       u32                     rx_cons;        /* RX consumer idx */

-       __le32                  *rx_fis;        /* RX'd FIS area */
+       void                    *rx_fis;        /* RX'd FIS area */
       dma_addr_t              rx_fis_dma;

-       struct mvs_cmd_hdr      *slot;          /* DMA command header slots */
+       struct mvs_cmd_hdr      *slot;  /* DMA command header slots */
       dma_addr_t              slot_dma;

       const struct mvs_chip_info *chip;

-                                       /* further per-slot information */
+       unsigned long           tags[MVS_SLOTS];
       struct mvs_slot_info    slot_info[MVS_SLOTS];
-       unsigned long           tags[(MVS_SLOTS / sizeof(unsigned long)) + 1];
-
+                               /* further per-slot information */
       struct mvs_phy          phy[MVS_MAX_PHYS];
       struct mvs_port         port[MVS_MAX_PHYS];
+
+       u32                     can_queue;      /* per adapter */
+       u32                     tag_out;        /*Get*/
+       u32                     tag_in;         /*Give*/
+};
+
+struct mvs_queue_task {
+       struct list_head list;
+
+       void   *uldd_task;
 };

+static int mvs_scan_finished(struct Scsi_Host *, unsigned long);
+static void mvs_scan_start(struct Scsi_Host *);
+
 static struct scsi_transport_template *mvs_stt;

 static const struct mvs_chip_info mvs_chips[] = {
-       [chip_6320] =           { 2, 16, 9 },
-       [chip_6440] =           { 4, 16, 9 },
+       [chip_6320] =           { 2, 16, 9  },
+       [chip_6440] =           { 4, 16, 9  },
       [chip_6480] =           { 8, 32, 10 },
 };

@@ -468,6 +628,8 @@ static struct scsi_host_template mvs_sht = {
       .target_alloc           = sas_target_alloc,
       .slave_configure        = sas_slave_configure,
       .slave_destroy          = sas_slave_destroy,
+       .scan_finished          = mvs_scan_finished,
+       .scan_start             = mvs_scan_start,
       .change_queue_depth     = sas_change_queue_depth,
       .change_queue_type      = sas_change_queue_type,
       .bios_param             = sas_bios_param,
@@ -477,14 +639,154 @@ static struct scsi_host_template mvs_sht = {
       .sg_tablesize           = SG_ALL,
       .max_sectors            = SCSI_DEFAULT_MAX_SECTORS,
       .use_clustering         = ENABLE_CLUSTERING,
-       .eh_device_reset_handler= sas_eh_device_reset_handler,
+       .eh_device_reset_handler        = sas_eh_device_reset_handler,
       .eh_bus_reset_handler   = sas_eh_bus_reset_handler,
       .slave_alloc            = sas_slave_alloc,
       .target_destroy         = sas_target_destroy,
       .ioctl                  = sas_ioctl,
 };

-static void mvs_int_rx(struct mvs_info *mvi, bool self_clear);
+static void mvs_hexdump(u32 size, u8 *data, u32 baseaddr)
+{
+       u32 i;
+       u32 run;
+       u32 offset;
+
+       offset = 0;
+       while (size) {
+               printk("%08X : ", baseaddr + offset);
+               if (size >= 16)
+                       run = 16;
+               else
+                       run = size;
+               size -= run;
+               for (i = 0; i < 16; i++) {
+                       if (i < run)
+                               printk("%02X ", (unsigned int)data[i]);
+                       else
+                               printk("   ");
+               }
+               printk(": ");
+               for (i = 0; i < run; i++)
+                       printk("%c", isalnum(data[i]) ? data[i] : '.');
+               printk("\n");
+               data = &data[16];
+               offset += run;
+       }
+       printk("\n");
+}
+
+static inline void mvs_hba_sb_dump(struct mvs_info *mvi, u32 tag,
+                                  enum sas_proto proto)
+{
+       u32 offset;
+       u32 len_ct;
+
+       if (sas_protocol_ata(proto))
+               len_ct = MVS_ATA_CMD_SZ;
+       else
+               len_ct = MVS_SSP_CMD_SZ;
+
+       offset =
+           len_ct + MVS_OAF_SZ +
+           sizeof(struct mvs_prd) * mvi->slot_info[tag].n_elem;
+       MVS_PRINTK("+---->Status buffer :\n");
+       mvs_hexdump(32, (u8 *) mvi->slot_info[tag].response,
+                   (u32) mvi->slot_info[tag].buf_dma + offset);
+}
+
+static void mvs_hba_memory_dump(struct mvs_info *mvi, u32 tag,
+                               enum sas_proto proto)
+{
+#if _MV_DUMP
+       u32 sz, w_ptr, r_ptr;
+       u64 addr;
+       void __iomem *regs = mvi->regs;
+       u32 len_ct;
+
+       if (sas_protocol_ata(proto))
+               len_ct = MVS_ATA_CMD_SZ;
+       else
+               len_ct = MVS_SSP_CMD_SZ;
+
+       /*Delivery Queue */
+       sz = mr32(TX_CFG) & TX_RING_SZ_MASK;
+       w_ptr = mr32(TX_PROD_IDX) & TX_RING_SZ_MASK;
+       r_ptr = mr32(TX_CONS_IDX) & TX_RING_SZ_MASK;
+       addr = mr32(TX_HI) << 16 << 16 | mr32(TX_LO);
+       MVS_PRINTK("Delivery Queue Size=%04d , WRT_PTR=%04X , RD_PTR=%04X\n",
+                  sz, w_ptr, r_ptr);
+       MVS_PRINTK
+           ("Delivery Queue Base Address=0x%llX (PA)"
+               "(tx_dma=0x%llX), Entry=%04d\n",
+               addr, mvi->tx_dma, w_ptr);
+       mvs_hexdump(sizeof(u32), (u8 *)(&mvi->tx[mvi->tx_prod]),
+                       (u32) mvi->tx_dma + sizeof(u32) * w_ptr);
+       /*Command List */
+       addr = mr32(CMD_LIST_HI) << 16 << 16 | mr32(CMD_LIST_LO);
+       MVS_PRINTK
+           ("Command List Base Address=0x%llX (PA)"
+               "(slot_dma=0x%llX), Header=%03d\n",
+               addr, mvi->slot_dma, tag);
+       MVS_PRINTK("Command Header[%03d]:\n", tag);
+       /*mvs_cmd_hdr */
+       mvs_hexdump(sizeof(struct mvs_cmd_hdr), (u8 *)(&mvi->slot[tag]),
+               (u32) mvi->slot_dma + tag * sizeof(struct mvs_cmd_hdr));
+       /*1.command table area */
+       MVS_PRINTK("+---->Command Table :\n");
+       mvs_hexdump(len_ct, (u8 *) mvi->slot_info[tag].buf,
+                       (u32) mvi->slot_info[tag].buf_dma);
+       /*2.open address frame area */
+       MVS_PRINTK("+---->Open Address Frame :\n");
+       mvs_hexdump(MVS_OAF_SZ, (u8 *) mvi->slot_info[tag].buf + len_ct,
+                       (u32) mvi->slot_info[tag].buf_dma + len_ct);
+       /*3.status buffer */
+       mvs_hba_sb_dump(mvi, tag, proto);
+       /*4.PRD table */
+       MVS_PRINTK("+---->PRD table :\n");
+       mvs_hexdump(sizeof(struct mvs_prd) * mvi->slot_info[tag].n_elem,
+               (u8 *) mvi->slot_info[tag].buf + len_ct + MVS_OAF_SZ,
+               (u32) mvi->slot_info[tag].buf_dma + len_ct + MVS_OAF_SZ);
+#endif
+}
+
+static void mvs_hba_cq_dump(struct mvs_info *mvi)
+{
+#if _MV_DUMP
+       u64 addr;
+       void __iomem *regs = mvi->regs;
+       u32 entry = mvi->rx_cons + 1;
+       u32 rx_desc = le32_to_cpu(mvi->rx[entry]);
+       /*Completion Queue */
+       addr = mr32(RX_HI) << 16 << 16 | mr32(RX_LO);
+       MVS_PRINTK("Completion Task = 0x%08X\n",
+                  (u32) mvi->slot_info[rx_desc & RXQ_SLOT_MASK].task);
+       MVS_PRINTK
+           ("Completion List Base Address=0x%llX (PA), "
+               "CQ_Entry=%04d, CQ_WP=0x%08X\n",
+               addr, entry - 1, mvi->rx[0]);
+       mvs_hexdump(sizeof(u32), (u8 *)(&rx_desc),
+                   mvi->rx_dma + sizeof(u32) * entry);
+#endif
+}
+
+static void mvs_hba_interrupt_enable(struct mvs_info *mvi, int enable)
+{
+       void __iomem *regs = mvi->regs;
+       u32 tmp;
+       unsigned long flags;
+
+       spin_lock_irqsave(&mvi->lock, flags);
+       tmp = mr32(GBL_CTL);
+
+       if (enable)
+               mw32(GBL_CTL, tmp | INT_EN);
+       else
+               mw32(GBL_CTL, tmp & ~INT_EN);
+       spin_unlock_irqrestore(&mvi->lock, flags);
+}
+
+static int mvs_int_rx(struct mvs_info *mvi, bool self_clear);

 /* move to PCI layer or libata core? */
 static int pci_go_64(struct pci_dev *pdev)
@@ -519,38 +821,37 @@ static int pci_go_64(struct pci_dev *pdev)
       return rc;
 }

-static void mvs_tag_clear(struct mvs_info *mvi, unsigned int tag)
+static inline void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
 {
-       mvi->tags[tag / sizeof(unsigned long)] &=
-               ~(1UL << (tag % sizeof(unsigned long)));
+       mvi->tag_in = (mvi->tag_in + 1) & (MVS_SLOTS - 1);
+       mvi->tags[mvi->tag_in] = tag;
 }

-static void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
+static inline void mvs_tag_free(struct mvs_info *mvi, u32 tag)
 {
-       mvi->tags[tag / sizeof(unsigned long)] |=
-               (1UL << (tag % sizeof(unsigned long)));
+       mvi->tag_out = (mvi->tag_out - 1) & (MVS_SLOTS - 1);
 }

-static bool mvs_tag_test(struct mvs_info *mvi, unsigned int tag)
+static inline int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
 {
-       return mvi->tags[tag / sizeof(unsigned long)] &
-               (1UL << (tag % sizeof(unsigned long)));
+       if (mvi->tag_out != mvi->tag_in) {
+               *tag_out = mvi->tags[mvi->tag_out];
+               mvi->tag_out = (mvi->tag_out + 1) & (MVS_SLOTS - 1);
+               return 0;
+       }
+       return -EBUSY;
 }

-static int mvs_tag_alloc(struct mvs_info *mvi, unsigned int *tag_out)
+static void mvs_tag_init(struct mvs_info *mvi)
 {
-       unsigned int i;
-
-       for (i = 0; i < MVS_SLOTS; i++)
-               if (!mvs_tag_test(mvi, i)) {
-                       mvs_tag_set(mvi, i);
-                       *tag_out = i;
-                       return 0;
-               }
-
-       return -EBUSY;
+       int i;
+       for (i = 0; i < MVS_SLOTS; ++i)
+               mvi->tags[i] = i;
+       mvi->tag_out = 0;
+       mvi->tag_in = MVS_SLOTS - 1;
 }

+#ifndef MVS_DISABLE_NVRAM
 static int mvs_eep_read(void __iomem *regs, unsigned int addr, u32 *data)
 {
       int timeout = 1000;
@@ -592,7 +893,7 @@ static int mvs_eep_read_buf(void __iomem *regs, unsigned int
addr,
               if (rc)
                       return rc;

-               tmp8 = (u8 *) &tmp;
+               tmp8 = (u8 *)&tmp;
               for (i = j; i < 4; i++)
                       *buf8++ = tmp8[i];

@@ -613,7 +914,7 @@ static int mvs_eep_read_buf(void __iomem *regs, unsigned int
addr,
               if (rc)
                       return rc;

-               tmp8 = (u8 *) &tmp;
+               tmp8 = (u8 *)&tmp;
               j = addr_end - tmp_addr;
               for (i = 0; i < j; i++)
                       *buf8++ = tmp8[i];
@@ -623,10 +924,12 @@ static int mvs_eep_read_buf(void __iomem *regs, unsigned
int addr,

       return 0;
 }
+#endif

 static int mvs_nvram_read(struct mvs_info *mvi, unsigned int addr,
                         void *buf, unsigned int buflen)
 {
+#ifndef MVS_DISABLE_NVRAM
       void __iomem *regs = mvi->regs;
       int rc, i;
       unsigned int sum;
@@ -644,7 +947,8 @@ static int mvs_nvram_read(struct mvs_info *mvi, unsigned int
addr,
               goto err_out;
       }

-       if (hdr[0] != 0x5A) {           /* entry id */
+       if (hdr[0] != 0x5A) {
+               /* entry id */
               msg = "invalid nvram entry id";
               rc = -ENOENT;
               goto err_out;
@@ -666,11 +970,53 @@ static int mvs_nvram_read(struct mvs_info *mvi, unsigned
int addr,
 err_out:
       dev_printk(KERN_ERR, &mvi->pdev->dev, "%s", msg);
       return rc;
+#else
+       memcpy(buf, "\x50\x05\x04\x30\x11\xab\x00\x00", 8);
+       return 0;
+#endif
+}
+
+static int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+       /* give the phy enabling interrupt event time to come in (1s
+        * is empirically about all it takes) */
+       if (time < HZ)
+               return 0;
+       /* Wait for discovery to finish */
+       scsi_flush_work(shost);
+       return 1;
+}
+
+static void mvs_scan_start(struct Scsi_Host *shost)
+{
+       int i;
+       struct sas_identify_frame *id;
+       struct mvs_info *mvi = SHOST_TO_SAS_HA(shost)->lldd_ha;
+
+       for (i = 0; i < mvi->chip->n_phy; ++i) {
+               struct mvs_phy *phy = &mvi->phy[i];
+               id = (struct sas_identify_frame *)phy->frame_rcvd;
+               if (phy->type & PORT_TYPE_SAS) {
+                       id->dev_type = phy->identify.device_type;
+                       id->initiator_bits = SAS_PROTO_ALL;
+                       id->target_bits = phy->identify.target_port_protocols;
+               } else if (phy->type & PORT_TYPE_SATA) {
+               }
+               mvi->sas.sas_phy[i]->frame_rcvd_size = phy->frame_rcvd_size;
+               mvi->sas.notify_port_event(mvi->sas.sas_phy[i],
+                                          PORTE_BYTES_DMAED);
+       }
+
 }

 static void mvs_int_port(struct mvs_info *mvi, int port_no, u32 events)
 {
-       /* FIXME */
+       void __iomem *regs = mvi->regs;
+       /*
+               events is port event.now ,
+               we need check the interrupt status which belongs to per port.
+       */
+       MVS_PRINTK("Port0 = %d", READ_PORT_IRQ_STAT(0));
 }

 static void mvs_int_sata(struct mvs_info *mvi)
@@ -681,9 +1027,10 @@ static void mvs_int_sata(struct mvs_info *mvi)
 static void mvs_slot_free(struct mvs_info *mvi, struct sas_task *task,
                         struct mvs_slot_info *slot, unsigned int slot_idx)
 {
-       if (slot->n_elem)
-               pci_unmap_sg(mvi->pdev, task->scatter,
-                            slot->n_elem, task->data_dir);
+       if (!sas_protocol_ata(task->task_proto))
+               if (slot->n_elem)
+                       pci_unmap_sg(mvi->pdev, task->scatter,
+                                    slot->n_elem, task->data_dir);

       switch (task->task_proto) {
       case SAS_PROTO_SMP:
@@ -708,9 +1055,34 @@ static void mvs_slot_err(struct mvs_info *mvi, struct
sas_task *task,
                        unsigned int slot_idx)
 {
       /* FIXME */
+       mvs_hba_sb_dump(mvi, slot_idx, task->task_proto);
 }

-static void mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
+static inline int mvs_can_queue(struct mvs_info *mvi, int num)
+{
+       int res = 0;
+       unsigned long flags;
+
+       spin_lock_irqsave(&mvi->lock, flags);
+       if ((mvi->can_queue - num) < 0)
+               res = -EBUSY;
+       else
+               mvi->can_queue -= num;
+       spin_unlock_irqrestore(&mvi->lock, flags);
+
+       return res;
+}
+
+static inline void mvs_can_dequeue(struct mvs_info *mvi, int num)
+{
+       /*unsigned long flags;*/
+
+       /*spin_lock_irqsave(&mvi->lock, flags);*/
+       mvi->can_queue += num;
+       /*spin_unlock_irqrestore(&mvi->lock, flags);*/
+}
+
+static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
 {
       unsigned int slot_idx = rx_desc & RXQ_SLOT_MASK;
       struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
@@ -722,19 +1094,19 @@ static void mvs_slot_complete(struct mvs_info *mvi, u32
rx_desc)
       aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
       if (!aborted) {
               task->task_state_flags &=
-                       ~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+                   ~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
               task->task_state_flags |= SAS_TASK_STATE_DONE;
       }
       spin_unlock(&task->task_state_lock);

       if (aborted)
-               return;
+               return -1;

       memset(tstat, 0, sizeof(*tstat));
       tstat->resp = SAS_TASK_COMPLETE;

       /* error info record present */
-       if (rx_desc & RXQ_ERR) {
+       if ((rx_desc & RXQ_ERR) && (*(u64 *) slot->response)) {
               tstat->stat = SAM_CHECK_COND;
               mvs_slot_err(mvi, task, slot_idx);
               goto out;
@@ -743,13 +1115,14 @@ static void mvs_slot_complete(struct mvs_info *mvi, u32
rx_desc)
       switch (task->task_proto) {
       case SAS_PROTO_SSP:
               /* hw says status == 0, datapres == 0 */
-               if (rx_desc & RXQ_GOOD)
+               if (rx_desc & RXQ_GOOD) {
                       tstat->stat = SAM_GOOD;
-
+                       tstat->resp = SAS_TASK_COMPLETE;
+               }
               /* response frame present */
               else if (rx_desc & RXQ_RSP) {
                       struct ssp_response_iu *iu =
-                               slot->response + sizeof(struct mvs_err_info);
+                           slot->response + sizeof(struct mvs_err_info);
                       ssp_task_response(&mvi->pdev->dev, task, iu);
               }

@@ -763,15 +1136,26 @@ static void mvs_slot_complete(struct mvs_info *mvi, u32
rx_desc)
               break;

       case SATA_PROTO:
-       case SAS_PROTO_STP:
-               if ((rx_desc & (RXQ_DONE | RXQ_ERR | RXQ_ATTN)) == RXQ_DONE)
-                       tstat->stat = SAM_GOOD;
-               else
-                       tstat->stat = SAM_CHECK_COND;
-               /* FIXME: read taskfile data from SATA register set
-                * associated with SATA target
-                */
-               break;
+       case SAS_PROTO_STP:{
+                       struct ata_task_resp *resp =
+                           (struct ata_task_resp *)tstat->buf;
+                       struct domain_device *dev = task->dev;
+                       struct mvs_port *port =
+                           (struct mvs_port *)dev->port->lldd_port;
+
+                       if ((rx_desc & (RXQ_DONE | RXQ_ERR | RXQ_ATTN)) ==
+                           RXQ_DONE)
+                               tstat->stat = SAM_GOOD;
+                       else
+                               tstat->stat = SAM_CHECK_COND;
+
+                       resp->frame_len = sizeof(struct dev_to_host_fis);
+                       memcpy(&resp->ending_fis[0],
+                              SATA_RECEIVED_D2H_FIS(port->taskfileset),
+                              sizeof(struct dev_to_host_fis));
+                       /*mvs_hexdump(16,resp->ending_fis,0);*/
+                       break;
+               }

       default:
               tstat->stat = SAM_CHECK_COND;
@@ -781,6 +1165,7 @@ static void mvs_slot_complete(struct mvs_info *mvi, u32
rx_desc)
 out:
       mvs_slot_free(mvi, task, slot, slot_idx);
       task->task_done(task);
+       return tstat->stat;
 }

 static void mvs_int_full(struct mvs_info *mvi)
@@ -791,6 +1176,8 @@ static void mvs_int_full(struct mvs_info *mvi)

       stat = mr32(INT_STAT);

+       mvs_int_rx(mvi, false);
+
       for (i = 0; i < MVS_MAX_PORTS; i++) {
               tmp = (stat >> i) & (CINT_PORT | CINT_PORT_STOPPED);
               if (tmp)
@@ -800,14 +1187,12 @@ static void mvs_int_full(struct mvs_info *mvi)
       if (stat & CINT_SRS)
               mvs_int_sata(mvi);

-       if (stat & (CINT_CI_STOP | CINT_DONE))
-               mvs_int_rx(mvi, false);
-
       mw32(INT_STAT, stat);
 }

-static void mvs_int_rx(struct mvs_info *mvi, bool self_clear)
+static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 {
+       void __iomem *regs = mvi->regs;
       u32 rx_prod_idx, rx_desc;
       bool attn = false;

@@ -816,32 +1201,45 @@ static void mvs_int_rx(struct mvs_info *mvi, bool
self_clear)
        * we don't have to stall the CPU reading that register.
        * The actual RX ring is offset by one dword, due to this.
        */
-       rx_prod_idx = le32_to_cpu(mvi->rx[0]) & 0xfff;
+       rx_prod_idx = le32_to_cpu(mr32(RX_CONS_IDX)) & RX_RING_SZ_MASK;
       if (rx_prod_idx == 0xfff) {     /* h/w hasn't touched RX ring yet */
               mvi->rx_cons = 0xfff;
-               return;
+               return 0;
       }
+
+       /* The CMPL_Q may come late, read from register and try again
+       * note: if coalescing is enabled,
+       * it will need to read from register every time for sure
+       */
+       if (mvi->rx_cons == rx_prod_idx)
+               return 0;
+
       if (mvi->rx_cons == 0xfff)
               mvi->rx_cons = MVS_RX_RING_SZ - 1;

       while (mvi->rx_cons != rx_prod_idx) {
+
               /* increment our internal RX consumer pointer */
               mvi->rx_cons = (mvi->rx_cons + 1) & (MVS_RX_RING_SZ - 1);

-               /* Read RX descriptor at offset+1, due to above */
               rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons + 1]);

-               if (rx_desc & RXQ_DONE)
-                       /* we had a completion, error or no */
-                       mvs_slot_complete(mvi, rx_desc);
+               mvs_hba_cq_dump(mvi);

-               if (rx_desc & RXQ_ATTN)
+               if (unlikely(rx_desc & RXQ_DONE))
+                       mvs_slot_complete(mvi, rx_desc);
+               else if (rx_desc & RXQ_ATTN) {
                       attn = true;
+                       MVS_PRINTK("ATTN\n");
+               } else if (rx_desc & RXQ_ERR) {
+                       MVS_PRINTK("RXQ_ERR\n");
+               }
       }

       if (attn && self_clear)
               mvs_int_full(mvi);

+       return 0;
 }

 static irqreturn_t mvs_interrupt(int irq, void *opaque)
@@ -851,6 +1249,10 @@ static irqreturn_t mvs_interrupt(int irq, void *opaque)
       u32 stat;

       stat = mr32(GBL_INT_STAT);
+
+       /* clear CMD_CMPLT ASAP */
+       mw32_f(INT_STAT, CINT_DONE);
+
       if (stat == 0 || stat == 0xffffffff)
               return IRQ_NONE;

@@ -877,13 +1279,14 @@ static irqreturn_t mvs_msi_interrupt(int irq, void
*opaque)
 }

 struct mvs_task_exec_info {
-       struct sas_task         *task;
-       struct mvs_cmd_hdr      *hdr;
-       unsigned int            tag;
-       int                     n_elem;
+       struct sas_task *task;
+       struct mvs_cmd_hdr *hdr;
+       unsigned int tag;
+       int n_elem;
 };

-static int mvs_task_prep_smp(struct mvs_info *mvi, struct mvs_task_exec_info
*tei)
+static int mvs_task_prep_smp(struct mvs_info *mvi,
+                            struct mvs_task_exec_info *tei)
 {
       int elem, rc;
       struct mvs_cmd_hdr *hdr = tei->hdr;
@@ -918,8 +1321,8 @@ static int mvs_task_prep_smp(struct mvs_info *mvi, struct
mvs_task_exec_info *te
        * Fill in TX ring and command slot header
        */

-       mvi->tx[tag] = cpu_to_le32(
-               (TXQ_CMD_SMP << TXQ_CMD_SHIFT) | TXQ_MODE_I | tag);
+       mvi->tx[mvi->tx_prod] = cpu_to_le32((TXQ_CMD_SMP << TXQ_CMD_SHIFT) |
+                                           TXQ_MODE_I | tag);

       hdr->flags = 0;
       hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));
@@ -941,6 +1344,65 @@ err_out:
       return rc;
 }

+static inline void mvs_free_reg_set(struct mvs_info *mvi, struct mvs_port
*port)
+{
+       void __iomem *regs = mvi->regs;
+       u32 tmp, offs;
+
+       if (port->taskfileset == MVS_ID_NOT_MAPPED)
+               return;
+
+       offs = 1U << ((port->taskfileset & 0x0f) + PCS_EN_SATA_REG);
+       if (port->taskfileset < 16) {
+               tmp = mr32(PCS);
+               mw32(PCS, tmp | ~offs);
+       } else {
+               tmp = mr32(CTL);
+               mw32(CTL, tmp | ~offs);
+       }
+
+       port->taskfileset = MVS_ID_NOT_MAPPED;
+}
+
+static inline u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_port
*port)
+{
+       int i;
+       u32 tmp, offs;
+       void __iomem *regs = mvi->regs;
+
+       if (port->taskfileset != MVS_ID_NOT_MAPPED)
+               return 0;
+
+       tmp = mr32(PCS);
+
+       for (i = 0; i < mvi->chip->srs_sz; i++) {
+               if (i == 16)
+                       tmp = mr32(CTL);
+               offs = 1U << ((i & 0x0f) + PCS_EN_SATA_REG);
+               if (!(tmp & offs)) {
+                       port->taskfileset = i;
+
+                       if (i < 16)
+                               mw32(PCS, tmp | offs);
+                       else
+                               mw32(CTL, tmp | offs);
+                       return 0;
+               }
+       }
+       return MVS_ID_NOT_MAPPED;
+}
+
+static inline u32 mvs_get_ncq_tag(struct sas_task *task)
+{
+       u32 tag = 0;
+       struct ata_queued_cmd *qc = task->uldd_task;
+
+       if (qc)
+               tag = qc->tag;
+
+       return tag;
+}
+
 static int mvs_task_prep_ata(struct mvs_info *mvi,
                            struct mvs_task_exec_info *tei)
 {
@@ -949,7 +1411,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
       struct mvs_cmd_hdr *hdr = tei->hdr;
       struct asd_sas_port *sas_port = dev->port;
       unsigned int tag = tei->tag;
-       struct mvs_slot_info *slot = &mvi->slot_info[tag];
+       struct mvs_slot_info *slot;
       u32 flags = (tei->n_elem << MCH_PRD_LEN_SHIFT);
       struct scatterlist *sg;
       struct mvs_prd *buf_prd;
@@ -957,20 +1419,38 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
       u8 *buf_cmd, *buf_oaf;
       dma_addr_t buf_tmp_dma;
       unsigned int i, req_len, resp_len;
+       struct mvs_port *port = (struct mvs_port *)sas_port->lldd_port;
+
+       if (mvs_assign_reg_set(mvi, port) == MVS_ID_NOT_MAPPED)
+               return -EBUSY;
+
+       slot = &mvi->slot_info[tag];

-       /* FIXME: fill in SATA register set */
-       mvi->tx[tag] = cpu_to_le32(TXQ_MODE_I | tag |
-               (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
-               (sas_port->phy_mask << TXQ_PHY_SHIFT));
+       mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
+                                           (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
+                                           (sas_port->
+                                            phy_mask << TXQ_PHY_SHIFT) |
+                                           (port->
+                                            taskfileset << TXQ_SRS_SHIFT));

       if (task->ata_task.use_ncq)
               flags |= MCH_FPDMA;
-       if (dev->sata_dev.command_set == ATAPI_COMMAND_SET)
-               flags |= MCH_ATAPI;
+       if (dev->sata_dev.command_set == ATAPI_COMMAND_SET) {
+               if (task->ata_task.fis.command != ATA_CMD_ID_ATAPI)
+                       flags |= MCH_ATAPI;
+       }
+
       /* FIXME: fill in port multiplier number */

       hdr->flags = cpu_to_le32(flags);
-       hdr->tags = cpu_to_le32(tag);
+
+       /* FIXME: the low order order 5 bits for the TAG if enable NCQ */
+       if (task->ata_task.use_ncq) {
+               hdr->tags = cpu_to_le32(mvs_get_ncq_tag(task));
+               /*Fill in task file */
+               task->ata_task.fis.sector_count = hdr->tags << 3;
+       } else
+               hdr->tags = cpu_to_le32(tag);
       hdr->data_len = cpu_to_le32(task->total_xfer_len);

       /*
@@ -978,9 +1458,8 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
        */
       memset(slot->buf, 0, MVS_SLOT_BUF_SZ);

-       /* region 1: command table area (MVS_ATA_CMD_SZ bytes) ***************/
-       buf_cmd =
-       buf_tmp = slot->buf;
+       /* region 1: command table area (MVS_ATA_CMD_SZ bytes) ************** */
+       buf_cmd = buf_tmp = slot->buf;
       buf_tmp_dma = slot->buf_dma;

       hdr->cmd_tbl = cpu_to_le64(buf_tmp_dma);
@@ -988,7 +1467,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
       buf_tmp += MVS_ATA_CMD_SZ;
       buf_tmp_dma += MVS_ATA_CMD_SZ;

-       /* region 2: open address frame area (MVS_OAF_SZ bytes) **********/
+       /* region 2: open address frame area (MVS_OAF_SZ bytes) ********* */
       /* used for STP.  unused for SATA? */
       buf_oaf = buf_tmp;
       hdr->open_frame = cpu_to_le64(buf_tmp_dma);
@@ -996,32 +1475,37 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
       buf_tmp += MVS_OAF_SZ;
       buf_tmp_dma += MVS_OAF_SZ;

-       /* region 3: PRD table ***********************************************/
+       /* region 3: PRD table ********************************************** */
       buf_prd = buf_tmp;
-       hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
+       if (tei->n_elem)
+               hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
+       else
+               hdr->prd_tbl = 0;

       i = sizeof(struct mvs_prd) * tei->n_elem;
       buf_tmp += i;
       buf_tmp_dma += i;

-       /* region 4: status buffer (larger the PRD, smaller this buf) ********/
+       /* region 4: status buffer (larger the PRD, smaller this buf) ******* */
       /* FIXME: probably unused, for SATA.  kept here just in case
        * we get a STP/SATA error information record
        */
       slot->response = buf_tmp;
       hdr->status_buf = cpu_to_le64(buf_tmp_dma);

-       req_len = sizeof(struct ssp_frame_hdr) + 28;
+       req_len = sizeof(struct host_to_dev_fis);
       resp_len = MVS_SLOT_BUF_SZ - MVS_ATA_CMD_SZ -
-                  sizeof(struct mvs_err_info) - i;
+           sizeof(struct mvs_err_info) - i;

       /* request, response lengths */
+       resp_len = min(resp_len, (u32) 0x400);
       hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));

       /* fill in command FIS and ATAPI CDB */
-       memcpy(buf_cmd, &task->ata_task.fis,
-              sizeof(struct host_to_dev_fis));
-       memcpy(buf_cmd + 0x40, task->ata_task.atapi_packet, 16);
+       task->ata_task.fis.flags |= 0x80;
+       memcpy(buf_cmd, &task->ata_task.fis, sizeof(struct host_to_dev_fis));
+       if (dev->sata_dev.command_set == ATAPI_COMMAND_SET)
+               memcpy(buf_cmd + 0x40, task->ata_task.atapi_packet, 16);

       /* fill in PRD (scatter/gather) table, if any */
       sg = task->scatter;
@@ -1044,7 +1528,7 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
       struct mvs_cmd_hdr *hdr = tei->hdr;
       struct mvs_slot_info *slot;
       struct scatterlist *sg;
-       unsigned int resp_len, req_len, i, tag = tei->tag;
+       u32 resp_len, req_len, i, tag = tei->tag;
       struct mvs_prd *buf_prd;
       struct ssp_frame_hdr *ssp_hdr;
       void *buf_tmp;
@@ -1054,9 +1538,10 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,

       slot = &mvi->slot_info[tag];

-       mvi->tx[tag] = cpu_to_le32(TXQ_MODE_I | tag |
-               (TXQ_CMD_SSP << TXQ_CMD_SHIFT) |
-               (sas_port->phy_mask << TXQ_PHY_SHIFT));
+       mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
+                                           (TXQ_CMD_SSP << TXQ_CMD_SHIFT) |
+                                           (sas_port->
+                                            phy_mask << TXQ_PHY_SHIFT));

       flags = MCH_RETRY;
       if (task->ssp_task.enable_first_burst) {
@@ -1064,8 +1549,8 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
               fburst = (1 << 7);
       }
       hdr->flags = cpu_to_le32(flags |
-               (tei->n_elem << MCH_PRD_LEN_SHIFT) |
-               (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));
+                                (tei->n_elem << MCH_PRD_LEN_SHIFT) |
+                                (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));

       hdr->tags = cpu_to_le32(tag);
       hdr->data_len = cpu_to_le32(task->total_xfer_len);
@@ -1075,9 +1560,8 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
        */
       memset(slot->buf, 0, MVS_SLOT_BUF_SZ);

-       /* region 1: command table area (MVS_SSP_CMD_SZ bytes) ***************/
-       buf_cmd =
-       buf_tmp = slot->buf;
+       /* region 1: command table area (MVS_SSP_CMD_SZ bytes) ************** */
+       buf_cmd = buf_tmp = slot->buf;
       buf_tmp_dma = slot->buf_dma;

       hdr->cmd_tbl = cpu_to_le64(buf_tmp_dma);
@@ -1085,28 +1569,33 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
       buf_tmp += MVS_SSP_CMD_SZ;
       buf_tmp_dma += MVS_SSP_CMD_SZ;

-       /* region 2: open address frame area (MVS_OAF_SZ bytes) **********/
+       /* region 2: open address frame area (MVS_OAF_SZ bytes) ********* */
       buf_oaf = buf_tmp;
       hdr->open_frame = cpu_to_le64(buf_tmp_dma);

       buf_tmp += MVS_OAF_SZ;
       buf_tmp_dma += MVS_OAF_SZ;

-       /* region 3: PRD table ***********************************************/
+       /* region 3: PRD table ********************************************** */
       buf_prd = buf_tmp;
-       hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
+       if (tei->n_elem)
+               hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
+       else
+               hdr->prd_tbl = 0;

       i = sizeof(struct mvs_prd) * tei->n_elem;
       buf_tmp += i;
       buf_tmp_dma += i;

-       /* region 4: status buffer (larger the PRD, smaller this buf) ********/
+       /* region 4: status buffer (larger the PRD, smaller this buf) ******* */
       slot->response = buf_tmp;
       hdr->status_buf = cpu_to_le64(buf_tmp_dma);

-       req_len = sizeof(struct ssp_frame_hdr) + 28;
       resp_len = MVS_SLOT_BUF_SZ - MVS_SSP_CMD_SZ - MVS_OAF_SZ -
-                  sizeof(struct mvs_err_info) - i;
+           sizeof(struct mvs_err_info) - i;
+       resp_len = min(resp_len, (u32) 0x400);
+
+       req_len = sizeof(struct ssp_frame_hdr) + 28;

       /* request, response lengths */
       hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));
@@ -1118,8 +1607,8 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
       buf_oaf[3] = tag;
       memcpy(buf_oaf + 4, task->dev->sas_addr, SAS_ADDR_SIZE);

-       /* fill in SSP frame header */
-       ssp_hdr = (struct ssp_frame_hdr *) buf_cmd;
+       /* fill in SSP frame header (Command Table.SSP frame header) */
+       ssp_hdr = (struct ssp_frame_hdr *)buf_cmd;
       ssp_hdr->frame_type = SSP_COMMAND;
       memcpy(ssp_hdr->hashed_dest_addr, task->dev->hashed_sas_addr,
              HASHED_SAS_ADDR_SIZE);
@@ -1131,12 +1620,11 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
       buf_cmd += sizeof(*ssp_hdr);
       memcpy(buf_cmd, &task->ssp_task.LUN, 8);
       buf_cmd[9] = fburst |
-               task->ssp_task.task_attr |
-               (task->ssp_task.task_prio << 3);
+           task->ssp_task.task_attr | (task->ssp_task.task_prio << 3);
       memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
-
-       /* fill in PRD (scatter/gather) table, if any */
-       sg = task->scatter;
+       /*CDB*/
+           /* fill in PRD (scatter/gather) table, if any */
+           sg = task->scatter;
       for (i = 0; i < tei->n_elem; i++) {
               buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
               buf_prd->len = cpu_to_le32(sg_dma_len(sg));
@@ -1155,72 +1643,106 @@ static int mvs_task_exec(struct sas_task *task, const
int num, gfp_t gfp_flags)
       void __iomem *regs = mvi->regs;
       unsigned long flags;
       struct mvs_task_exec_info tei;
+       struct sas_task *t = task;
+       u32 n = num, pass = 0;
+
+       mvs_hba_interrupt_enable(mvi, 0);
+
+       do {
+               if (!sas_protocol_ata(t->task_proto)) {
+                       if (t->num_scatter) {
+                               n_elem = pci_map_sg(mvi->pdev, t->scatter,
+                                                   t->num_scatter,
+                                                   t->data_dir);
+                               if (!n_elem) {
+                                       rc = -ENOMEM;
+                                       goto err_out;
+                               }
+                       }
+               } else {
+                       n_elem = t->num_scatter;
+               }

-       /* FIXME: STP/SATA support not complete yet */
-       if (task->task_proto == SATA_PROTO || task->task_proto == SAS_PROTO_STP)
-               return -SAS_DEV_NO_RESPONSE;
+               rc = mvs_tag_alloc(mvi, &tag);
+               if (rc)
+                       goto err_out;

-       if (task->num_scatter) {
-               n_elem = pci_map_sg(mvi->pdev, task->scatter,
-                                   task->num_scatter, task->data_dir);
-               if (!n_elem)
-                       return -ENOMEM;
-       }
+               mvi->slot_info[tag].task = t;
+               mvi->slot_info[tag].n_elem = n_elem;
+               tei.task = t;
+               tei.hdr = &mvi->slot[tag];
+               tei.tag = tag;
+               tei.n_elem = n_elem;

-       spin_lock_irqsave(&mvi->lock, flags);
+               switch (t->task_proto) {
+               case SAS_PROTO_SMP:
+                       rc = mvs_task_prep_smp(mvi, &tei);
+                       break;
+               case SAS_PROTO_SSP:
+                       rc = mvs_task_prep_ssp(mvi, &tei);
+                       break;
+               case SATA_PROTO:
+               case SAS_PROTO_STP:
+                       rc = mvs_task_prep_ata(mvi, &tei);
+                       break;
+               default:
+                       rc = -EINVAL;
+                       break;
+               }

-       rc = mvs_tag_alloc(mvi, &tag);
-       if (rc)
-               goto err_out;
+               if (rc)
+                       goto err_out_tag;

-       mvi->slot_info[tag].task = task;
-       mvi->slot_info[tag].n_elem = n_elem;
-       tei.task = task;
-       tei.hdr = &mvi->slot[tag];
-       tei.tag = tag;
-       tei.n_elem = n_elem;
+               /* TODO: select normal or high priority */

-       switch (task->task_proto) {
-       case SAS_PROTO_SMP:
-               rc = mvs_task_prep_smp(mvi, &tei);
-               break;
-       case SAS_PROTO_SSP:
-               rc = mvs_task_prep_ssp(mvi, &tei);
-               break;
-       case SATA_PROTO:
-       case SAS_PROTO_STP:
-               rc = mvs_task_prep_ata(mvi, &tei);
-               break;
-       default:
-               rc = -EINVAL;
-               break;
-       }
-
-       if (rc)
-               goto err_out_tag;
+               spin_lock_irqsave(&t->task_state_lock, flags);
+               t->task_state_flags |= SAS_TASK_AT_INITIATOR;
+               spin_unlock_irqrestore(&t->task_state_lock, flags);

-       /* TODO: select normal or high priority */
+               if (n == 1) {
+                       mvs_hba_interrupt_enable(mvi, 1);
+                       mw32(TX_PROD_IDX, mvi->tx_prod);
+               }
+               /*
+               MVS_PRINTK("task=0x%08X,proto=%d,tag=%d,"
+                       "num=%d,mvi->tx_prod=%d\n",
+                       (u32)t,t->task_proto,tag,n,mvi->tx_prod);
+               */
+               mvs_hba_memory_dump(mvi, tag, t->task_proto);

-       mw32(RX_PROD_IDX, mvi->tx_prod);
+               ++pass;
+               mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);

-       mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_TX_RING_SZ - 1);
+               if (n == 1)
+                       break;

-       spin_lock(&task->task_state_lock);
-       task->task_state_flags |= SAS_TASK_AT_INITIATOR;
-       spin_unlock(&task->task_state_lock);
+               t = list_entry(t->list.next, struct sas_task, list);
+       } while (--n);

-       spin_unlock_irqrestore(&mvi->lock, flags);
       return 0;

 err_out_tag:
-       mvs_tag_clear(mvi, tag);
+       mvs_tag_free(mvi, tag);
+       MVS_PRINTK("Error : free tag %d\n", tag);
 err_out:
-       if (n_elem)
-               pci_unmap_sg(mvi->pdev, task->scatter, n_elem, task->data_dir);
-       spin_unlock_irqrestore(&mvi->lock, flags);
+       MVS_PRINTK("mvsas exec failed[%d]!\n", pass);
+       if (!sas_protocol_ata(t->task_proto))
+               if (n_elem)
+                       pci_unmap_sg(mvi->pdev, t->scatter, n_elem,
+                                    t->data_dir);
+       if (pass)
+               mw32(TX_PROD_IDX, (mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
+       mvs_hba_interrupt_enable(mvi, 1);
       return rc;
 }

+static int mvs_abort_task(struct sas_task *task)
+{
+       /*FIXME*/
+       MVS_PRINTK("mvs abort task\n");
+       return TMF_RESP_FUNC_COMPLETE;
+}
+
 static void mvs_free(struct mvs_info *mvi)
 {
       int i;
@@ -1238,7 +1760,7 @@ static void mvs_free(struct mvs_info *mvi)

       if (mvi->tx)
               dma_free_coherent(&mvi->pdev->dev,
-                                 sizeof(*mvi->tx) * MVS_TX_RING_SZ,
+                                 sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
                                 mvi->tx, mvi->tx_dma);
       if (mvi->rx_fis)
               dma_free_coherent(&mvi->pdev->dev, MVS_RX_FISL_SZ,
@@ -1249,10 +1771,12 @@ static void mvs_free(struct mvs_info *mvi)
                                 mvi->rx, mvi->rx_dma);
       if (mvi->slot)
               dma_free_coherent(&mvi->pdev->dev,
-                                 sizeof(*mvi->slot) * MVS_RX_RING_SZ,
+                                 sizeof(*mvi->slot) * MVS_SLOTS,
                                 mvi->slot, mvi->slot_dma);
+#if 0
       if (mvi->peri_regs)
               iounmap(mvi->peri_regs);
+#endif
       if (mvi->regs)
               iounmap(mvi->regs);
       if (mvi->shost)
@@ -1274,25 +1798,25 @@ static int mvs_phy_control(struct asd_sas_phy *sas_phy,
enum phy_func func,
       reg = mvi->regs + MVS_P0_SER_CTLSTAT + (phy_id * 4);

       switch (func) {
-       case PHY_FUNC_SET_LINK_RATE: {
-               struct sas_phy_linkrates *rates = funcdata;
-               u32 lrmin = 0, lrmax = 0;
+       case PHY_FUNC_SET_LINK_RATE:{
+                       struct sas_phy_linkrates *rates = funcdata;
+                       u32 lrmin = 0, lrmax = 0;

-               lrmin = (rates->minimum_linkrate << 8);
-               lrmax = (rates->maximum_linkrate << 12);
+                       lrmin = (rates->minimum_linkrate << 8);
+                       lrmax = (rates->maximum_linkrate << 12);

-               tmp = readl(reg);
-               if (lrmin) {
-                       tmp &= ~(0xf << 8);
-                       tmp |= lrmin;
-               }
-               if (lrmax) {
-                       tmp &= ~(0xf << 12);
-                       tmp |= lrmax;
+                       tmp = readl(reg);
+                       if (lrmin) {
+                               tmp &= ~(0xf << 8);
+                               tmp |= lrmin;
+                       }
+                       if (lrmax) {
+                               tmp &= ~(0xf << 12);
+                               tmp |= lrmax;
+                       }
+                       writel(tmp, reg);
+                       break;
               }
-               writel(tmp, reg);
-               break;
-       }

       case PHY_FUNC_HARD_RESET:
               tmp = readl(reg);
@@ -1335,11 +1859,11 @@ static void __devinit mvs_phy_init(struct mvs_info *mvi,
int phy_id)
       sas_phy->lldd_phy = phy;
 }

-static struct mvs_info * __devinit mvs_alloc(struct pci_dev *pdev,
-                               const struct pci_device_id *ent)
+static struct mvs_info *__devinit mvs_alloc(struct pci_dev *pdev,
+                                           const struct pci_device_id *ent)
 {
       struct mvs_info *mvi;
-       unsigned long res_start, res_len;
+       unsigned long res_start, res_len, res_flag;
       struct asd_sas_phy **arr_phy;
       struct asd_sas_port **arr_port;
       const struct mvs_chip_info *chip = &mvs_chips[ent->driver_data];
@@ -1381,9 +1905,10 @@ static struct mvs_info * __devinit mvs_alloc(struct
pci_dev *pdev,

       SHOST_TO_SAS_HA(mvi->shost) = &mvi->sas;
       mvi->shost->transportt = mvs_stt;
-       mvi->shost->max_id = ~0;
-       mvi->shost->max_lun = ~0;
-       mvi->shost->max_cmd_len = ~0;
+       mvi->shost->max_id = 21;
+       mvi->shost->max_lun = 2;
+       mvi->shost->max_channel = 0;
+       mvi->shost->max_cmd_len = 16;

       mvi->sas.sas_ha_name = DRV_NAME;
       mvi->sas.dev = &pdev->dev;
@@ -1392,12 +1917,13 @@ static struct mvs_info * __devinit mvs_alloc(struct
pci_dev *pdev,
       mvi->sas.sas_phy = arr_phy;
       mvi->sas.sas_port = arr_port;
       mvi->sas.num_phys = chip->n_phy;
-       mvi->sas.lldd_max_execute_num = MVS_TX_RING_SZ - 1;/* FIXME: correct? */
-       mvi->sas.lldd_queue_size = MVS_TX_RING_SZ - 1;     /* FIXME: correct? */
+       mvi->sas.lldd_max_execute_num = MVS_CHIP_SLOT_SZ - 1;
+       mvi->sas.lldd_queue_size = MVS_QUEUE_SIZE;
+       mvi->can_queue = (MVS_CHIP_SLOT_SZ >> 1) - 1;
       mvi->sas.lldd_ha = mvi;
       mvi->sas.core.shost = mvi->shost;

-       mvs_tag_set(mvi, MVS_TX_RING_SZ - 1);
+       mvs_tag_init(mvi);

       /*
        * ioremap main and peripheral registers
@@ -1408,16 +1934,23 @@ static struct mvs_info * __devinit mvs_alloc(struct
pci_dev *pdev,
       if (!res_start || !res_len)
               goto err_out;

+#if 0
       mvi->peri_regs = ioremap_nocache(res_start, res_len);
-       if (!mvi->regs)
+       if (!mvi->peri_regs)
               goto err_out;
+#endif

       res_start = pci_resource_start(pdev, 4);
       res_len = pci_resource_len(pdev, 4);
       if (!res_start || !res_len)
               goto err_out;

-       mvi->regs = ioremap_nocache(res_start, res_len);
+       res_flag = pci_resource_flags(pdev, 4);
+       if (res_flag & IORESOURCE_CACHEABLE)
+               mvi->regs = ioremap(res_start, res_len);
+       else
+               mvi->regs = ioremap_nocache(res_start, res_len);
+
       if (!mvi->regs)
               goto err_out;

@@ -1426,14 +1959,14 @@ static struct mvs_info * __devinit mvs_alloc(struct
pci_dev *pdev,
        */

       mvi->tx = dma_alloc_coherent(&pdev->dev,
-                                    sizeof(*mvi->tx) * MVS_TX_RING_SZ,
+                                    sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
                                    &mvi->tx_dma, GFP_KERNEL);
       if (!mvi->tx)
               goto err_out;
-       memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_TX_RING_SZ);
+       memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);

       mvi->rx_fis = dma_alloc_coherent(&pdev->dev, MVS_RX_FISL_SZ,
-                                    &mvi->rx_fis_dma, GFP_KERNEL);
+                                        &mvi->rx_fis_dma, GFP_KERNEL);
       if (!mvi->rx_fis)
               goto err_out;
       memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
@@ -1459,7 +1992,7 @@ static struct mvs_info * __devinit mvs_alloc(struct
pci_dev *pdev,
               struct mvs_slot_info *slot = &mvi->slot_info[i];

               slot->buf = dma_alloc_coherent(&pdev->dev, MVS_SLOT_BUF_SZ,
-                                      &slot->buf_dma, GFP_KERNEL);
+                                              &slot->buf_dma, GFP_KERNEL);
               if (!slot->buf)
                       goto err_out;
               memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
@@ -1468,7 +2001,6 @@ static struct mvs_info * __devinit mvs_alloc(struct
pci_dev *pdev,
       /* finally, read NVRAM to get our SAS address */
       if (mvs_nvram_read(mvi, NVR_SAS_ADDR, &mvi->sas_addr, 8))
               goto err_out;
-
       return mvi;

 err_out:
@@ -1476,13 +2008,13 @@ err_out:
       return NULL;
 }

-static u32 mvs_cr32(void __iomem *regs, u32 addr)
+static inline u32 mvs_cr32(void __iomem *regs, u32 addr)
 {
       mw32(CMD_ADDR, addr);
       return mr32(CMD_DATA);
 }

-static void mvs_cw32(void __iomem *regs, u32 addr, u32 val)
+static inline void mvs_cw32(void __iomem *regs, u32 addr, u32 val)
 {
       mw32(CMD_ADDR, addr);
       mw32(CMD_DATA, val);
@@ -1497,7 +2029,6 @@ static u32 mvs_phy_read(struct mvs_info *mvi, unsigned int
phy_id, u32 addr)
       writel(addr, phy_regs);
       return readl(phy_regs + 4);
 }
-#endif

 static void mvs_phy_write(struct mvs_info *mvi, unsigned int phy_id,
                         u32 addr, u32 val)
@@ -1509,6 +2040,7 @@ static void mvs_phy_write(struct mvs_info *mvi, unsigned
int phy_id,
       writel(val, phy_regs + 4);
       readl(phy_regs);        /* flush */
 }
+#endif

 static void __devinit mvs_phy_hacks(struct mvs_info *mvi)
 {
@@ -1547,6 +2079,174 @@ static void __devinit mvs_phy_hacks(struct mvs_info
*mvi)
       tmp &= 0x1fffffff;
       tmp |= (2U << 29);      /* 8 ms retry */
       mvs_cw32(regs, CMD_PHY_TIMER, tmp);
+
+       /* TEST - for phy decoding error, adjust voltage levels */
+       mw32(P0_VSR_ADDR + 0, 0x8);
+       mw32(P0_VSR_DATA + 0, 0x2F0);
+
+       mw32(P0_VSR_ADDR + 8, 0x8);
+       mw32(P0_VSR_DATA + 8, 0x2F0);
+
+       mw32(P0_VSR_ADDR + 16, 0x8);
+       mw32(P0_VSR_DATA + 16, 0x2F0);
+
+       mw32(P0_VSR_ADDR + 24, 0x8);
+       mw32(P0_VSR_DATA + 24, 0x2F0);
+
+}
+
+static inline void mvs_enable_xmt(struct mvs_info *mvi, int PhyId)
+{
+       void __iomem *regs = mvi->regs;
+       u32 tmp;
+
+       tmp = mr32(PCS);
+       if (mvi->chip->n_phy <= 4)
+               tmp |= 1 << (PhyId + PCS_EN_PORT_XMT_START);
+       else
+               tmp |= 1 << (PhyId + PCS_EN_PORT_XMT_START2);
+       mw32(PCS, tmp);
+}
+
+static void mvs_detect_porttype(struct mvs_info *mvi, int i)
+{
+       void __iomem *regs = mvi->regs;
+       u32 reg;
+       struct mvs_phy *phy = &mvi->phy[i];
+
+       /* enable auto port detection */
+       mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
+       msleep(100);
+
+       /* TODO check & save device type */
+       reg = mr32(GBL_PORT_TYPE);
+
+       if (reg & MODE_SAS_SATA & (1 << i)) {
+               phy->type = PORT_TYPE_SAS;
+               phy->identify.target_port_protocols = SAS_PROTO_SSP;
+       } else {
+               phy->type = PORT_TYPE_SATA;
+               phy->identify.target_port_protocols = SAS_PROTO_STP;
+       }
+
+}
+
+static inline void *mvs_get_d2h_reg(struct mvs_info *mvi, int i, void *buf)
+{
+       u32 *s = (u32 *) buf;
+       void __iomem *regs = mvi->regs;
+
+       if (!s)
+               return NULL;
+
+       WRITE_PORT_CONFIG_ADDR(i, PHYR_SATA_SIG3);
+       s[3] = READ_PORT_CONFIG_DATA(i);
+
+       WRITE_PORT_CONFIG_ADDR(i, PHYR_SATA_SIG2);
+       s[2] = READ_PORT_CONFIG_DATA(i);
+
+       WRITE_PORT_CONFIG_ADDR(i, PHYR_SATA_SIG1);
+       s[1] = READ_PORT_CONFIG_DATA(i);
+
+       WRITE_PORT_CONFIG_ADDR(i, PHYR_SATA_SIG0);
+       s[0] = READ_PORT_CONFIG_DATA(i);
+
+       return (void *)s;
+}
+
+static inline u32 mvs_is_sig_fis_received(struct mvs_info *mvi, int i)
+{
+       u32 tmp;
+       void __iomem *regs = mvi->regs;
+
+       tmp = (READ_PORT_IRQ_STAT(i) & PHYEV_SIG_FIS);
+       if (tmp)
+               WRITE_PORT_IRQ_STAT(i, PHYEV_SIG_FIS);
+
+       return tmp;
+}
+
+static void __devinit mvs_update_phyinfo(struct mvs_info *mvi, int i)
+{
+       void __iomem *regs = mvi->regs;
+       struct mvs_phy *phy = &mvi->phy[i];
+       u32 tmp;
+       __le64 tmp64;
+
+       WRITE_PORT_CONFIG_ADDR(i, PHYR_IDENTIFY);
+       phy->devinfo = READ_PORT_CONFIG_DATA(i);
+
+       WRITE_PORT_CONFIG_ADDR(i, PHYR_ADDR_HI);
+       phy->devsasaddr = (__le64) READ_PORT_CONFIG_DATA(i) << 32;
+
+       WRITE_PORT_CONFIG_ADDR(i, PHYR_ADDR_LO);
+       phy->devsasaddr |= READ_PORT_CONFIG_DATA(i);    /*le */
+
+       phy->phystatus = READ_PORT_PHY_CONTROL(i);
+       /*MVS_PRINTK("PhyStatus=%X\n",phy->phystatus);*/
+
+       /*FIXME Update Wide Port info */
+       phy->port = &mvi->port[i];
+       phy->port->sas_port.lldd_port = phy->port;
+       phy->port->taskfileset = MVS_ID_NOT_MAPPED;
+
+       if (phy->phystatus & PHY_READY_MASK) {
+               u32 phy_st;
+               struct asd_sas_phy *sas_phy = mvi->sas.sas_phy[i];
+
+               WRITE_PORT_CONFIG_ADDR(i, PHYR_PHY_STAT);
+               phy_st = READ_PORT_CONFIG_DATA(i);
+
+               WRITE_PORT_CONFIG_ADDR(i, PHYR_ATT_ADDR_HI);
+               phy->attdevsasaddr = (__le64) READ_PORT_CONFIG_DATA(i) << 32;
+
+               WRITE_PORT_CONFIG_ADDR(i, PHYR_ATT_ADDR_LO);
+               phy->attdevsasaddr |= READ_PORT_CONFIG_DATA(i);
+
+               /*Updated attached_sas_addr */
+               tmp64 = phy->attdevsasaddr;
+               MVS_PRINTK("phy[%d] Get Attached Address 0x%llX  \n", i, tmp64);
+               tmp64 = cpu_to_be64(tmp64);
+               memcpy(sas_phy->attached_sas_addr, &tmp64, SAS_ADDR_SIZE);
+
+               if (phy->type & PORT_TYPE_SAS) {
+                       WRITE_PORT_CONFIG_ADDR(i, PHYR_ATT_DEV_INFO);
+                       phy->attdevinfo = READ_PORT_CONFIG_DATA(i);
+                       phy->identify.device_type =
+                           phy->attdevinfo & PORT_DEV_TYPE_MASK;
+                       MVS_PRINTK("device_type = %d\n",
+                                  phy->identify.device_type);
+
+                       sas_phy->linkrate =
+                       (phy->phystatus & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
+                               PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
+                       if (phy_st & PHY_OOB_DTCTD)
+                               sas_phy->oob_mode = SAS_OOB_MODE;
+                       phy->frame_rcvd_size =
+                           sizeof(struct sas_identify_frame);
+               } else if (phy->type & PORT_TYPE_SATA) {
+                       if (mvs_is_sig_fis_received(mvi, i)) {
+                               if (phy_st & PHY_OOB_DTCTD)
+                                       sas_phy->oob_mode = SATA_OOB_MODE;
+                               phy->frame_rcvd_size =
+                                   sizeof(struct dev_to_host_fis);
+                               mvs_get_d2h_reg(mvi, i,
+                                               (void *)sas_phy->frame_rcvd);
+                       }
+               }
+               /* workaround for HW phy decoding error on 1.5g disk drive */
+               WRITE_PORT_VSR_ADDR(i, 0x06);
+               tmp = READ_PORT_VSR_DATA(i);
+               if (((phy->phystatus & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
+                    PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET) ==
+                       SAS_LINK_RATE_1_5_GBPS)
+                       tmp &= ~0x20000000;
+               else
+                       tmp |= 0x20000000;
+               WRITE_PORT_VSR_DATA(i, tmp);
+
+       }
+       phy->irqstatus = READ_PORT_IRQ_STAT(i);
 }

 static int __devinit mvs_hw_init(struct mvs_info *mvi)
@@ -1559,6 +2259,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
       mw32(GBL_CTL, 0);
       tmp = mr32(GBL_CTL);

+       /*ResetController */
       if (!(tmp & HBA_RST)) {
               if (mvi->flags & MVF_PHY_PWR_FIX) {
                       pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
@@ -1576,7 +2277,6 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
               mw32_f(GBL_CTL, HBA_RST);
       }

-
       /* wait for reset to finish; timeout is just a guess */
       i = 1000;
       while (i-- > 0) {
@@ -1590,13 +2290,24 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
               return -EBUSY;
       }

+       /*InitChip */
       /* make sure RST is set; HBA_RST /should/ have done that for us */
-       cctl = mr32(CTL);
+       cctl = mr32(CTL);       /*MVS_CTL */
       if (cctl & CCTL_RST)
               cctl &= ~CCTL_RST;
       else
               mw32_f(CTL, cctl | CCTL_RST);

+       pci_read_config_dword(mvi->pdev, PCI_COMMAND, &tmp);
+       /*MV_PCI_DEV_EN */
+       tmp |= PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER;
+       pci_write_config_dword(mvi->pdev, PCI_COMMAND, tmp);
+       /* write to device control _AND_ device status register? - A.C. */
+       pci_read_config_dword(mvi->pdev, PCR_DEV_CTRL, &tmp);
+       tmp &= ~PRD_REQ_MASK;
+       tmp |= PRD_REQ_SIZE;
+       pci_write_config_dword(mvi->pdev, PCR_DEV_CTRL, tmp);
+
       pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
       tmp |= PCTL_PWR_ON;
       tmp &= ~PCTL_OFF;
@@ -1609,6 +2320,9 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)

       mw32_f(CTL, cctl);

+       /* reset control */
+       mw32(PCS, 0);           /*MVS_PCS */
+
       mvs_phy_hacks(mvi);

       mw32(CMD_LIST_LO, mvi->slot_dma);
@@ -1617,7 +2331,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
       mw32(RX_FIS_LO, mvi->rx_fis_dma);
       mw32(RX_FIS_HI, (mvi->rx_fis_dma >> 16) >> 16);

-       mw32(TX_CFG, MVS_TX_RING_SZ);
+       mw32(TX_CFG, MVS_CHIP_SLOT_SZ);
       mw32(TX_LO, mvi->tx_dma);
       mw32(TX_HI, (mvi->tx_dma >> 16) >> 16);

@@ -1628,42 +2342,82 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
       /* init and reset phys */
       for (i = 0; i < mvi->chip->n_phy; i++) {
               /* FIXME: is this the correct dword order? */
-               u32 lo = *((u32 *) &mvi->sas_addr[0]);
-               u32 hi = *((u32 *) &mvi->sas_addr[4]);
+               u32 lo = *((u32 *)&mvi->sas_addr[0]);
+               u32 hi = *((u32 *)&mvi->sas_addr[4]);
+
+               mvs_detect_porttype(mvi, i);

               /* set phy local SAS address */
-               mvs_phy_write(mvi, i, PHYR_ADDR_LO, lo);
-               mvs_phy_write(mvi, i, PHYR_ADDR_HI, hi);
+               WRITE_PORT_CONFIG_ADDR(i, PHYR_ADDR_LO);
+               WRITE_PORT_CONFIG_DATA(i, lo);
+               WRITE_PORT_CONFIG_ADDR(i, PHYR_ADDR_HI);
+               WRITE_PORT_CONFIG_DATA(i, hi);

               /* reset phy */
-               tmp = readl(regs + MVS_P0_SER_CTLSTAT + (i * 4));
+               tmp = READ_PORT_PHY_CONTROL(i);
               tmp |= PHY_RST;
-               writel(tmp, regs + MVS_P0_SER_CTLSTAT + (i * 4));
+               WRITE_PORT_PHY_CONTROL(i, tmp);
       }

       msleep(100);

       for (i = 0; i < mvi->chip->n_phy; i++) {
+               /* clear phy int status */
+               tmp = READ_PORT_IRQ_STAT(i);
+               tmp &= ~PHYEV_SIG_FIS;
+               WRITE_PORT_IRQ_STAT(i, tmp);
+
               /* set phy int mask */
-               writel(PHYEV_BROAD_CH | PHYEV_RDY_CH,
-                      regs + MVS_P0_INT_MASK + (i * 8));
+               tmp = PHYEV_RDY_CH | PHYEV_BROAD_CH | PHYEV_UNASSOC_FIS;
+               WRITE_PORT_IRQ_MASK(i, tmp);

-               /* clear phy int status */
-               tmp = readl(regs + MVS_P0_INT_STAT + (i * 8));
-               writel(tmp, regs + MVS_P0_INT_STAT + (i * 8));
+               mvs_update_phyinfo(mvi, i);
+               mvs_enable_xmt(mvi, i);
       }

       /* FIXME: update wide port bitmaps */

+       /* little endian for open address and command table, etc. */
+       /* A.C.
+        * it seems that ( from the spec ) turning on big-endian won't
+        * do us any good on big-endian machines, need further confirmation
+        */
+       cctl = mr32(CTL);
+       cctl |= CCTL_ENDIAN_CMD;
+       cctl |= CCTL_ENDIAN_DATA;
+       cctl &= ~CCTL_ENDIAN_OPEN;
+       cctl |= CCTL_ENDIAN_RSP;
+       mw32_f(CTL, cctl);
+
+       /* reset CMD queue */
+       tmp = mr32(PCS);
+       tmp |= PCS_CMD_RST;
+       mw32(PCS, tmp);
+       /* interrupt coalescing may cause missing HW interrput in some case,
+        * and the max count is 0x1ff, while our max slot is 0x200,
+        * it will make count 0.
+        */
+       tmp = 0;
+       mw32(INT_COAL, tmp);
+
+       tmp = 0x100;
+       mw32(INT_COAL_TMOUT, tmp);
+
       /* ladies and gentlemen, start your engines */
-       mw32(TX_CFG, MVS_TX_RING_SZ | TX_EN);
+       mw32(TX_CFG, 0);
+       mw32(TX_CFG, MVS_CHIP_SLOT_SZ | TX_EN);
       mw32(RX_CFG, MVS_RX_RING_SZ | RX_EN);
+       /* enable CMD/CMPL_Q/RESP mode */
       mw32(PCS, PCS_SATA_RETRY | PCS_FIS_RX_EN | PCS_CMD_EN |
            ((mvi->flags & MVF_MSI) ? PCS_SELF_CLEAR : 0));

       /* re-enable interrupts globally */
       mw32(GBL_CTL, INT_EN);

+       /* enable completion queue interrupt */
+       tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM);
+       mw32(INT_MASK, tmp);
+
       return 0;
 }

@@ -1680,7 +2434,7 @@ static void __devinit mvs_print_info(struct mvs_info *mvi)
 }

 static int __devinit mvs_pci_init(struct pci_dev *pdev,
-                                const struct pci_device_id *ent)
+                                 const struct pci_device_id *ent)
 {
       int rc;
       struct mvs_info *mvi;
@@ -1732,6 +2486,7 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
       mvs_print_info(mvi);

       scsi_scan_host(mvi->shost);
+
       return 0;

 err_out_shost:
@@ -1771,6 +2526,7 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 static struct sas_domain_function_template mvs_transport_ops = {
       .lldd_execute_task      = mvs_task_exec,
       .lldd_control_phy       = mvs_phy_control,
+       .lldd_abort_task        = mvs_abort_task,
 };

 static struct pci_device_id __devinitdata mvs_pci_table[] = {
@@ -1822,4 +2578,3 @@ MODULE_DESCRIPTION("Marvell 88SE6440 SAS/SATA controller
driver");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, mvs_pci_table);
-
--
1.5.3.7
