From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] add ISP1040 register definitions
Date: Sun, 6 Jun 2004 14:57:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606125728.GB31063@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:25802 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263544AbUFFM5c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 08:57:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org

The old 1020/1040 has some registers where the newer controlers only
have reserved space, add that to qla1280.h


diff -Nru a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
--- a/drivers/scsi/qla1280.h	2004-06-06 14:45:26 +02:00
+++ b/drivers/scsi/qla1280.h	2004-06-06 14:45:26 +02:00
@@ -126,7 +126,20 @@
 	uint16_t id_l;		/* ID low */
 	uint16_t id_h;		/* ID high */
 	uint16_t cfg_0;		/* Configuration 0 */
+#define ISP_CFG0_HWMSK   0x000f	/* Hardware revision mask */
+#define ISP_CFG0_1020    BIT_0	/* ISP1020 */
+#define ISP_CFG0_1020A	 BIT_1	/* ISP1020A */
+#define ISP_CFG0_1040	 BIT_2	/* ISP1040 */
+#define ISP_CFG0_1040A	 BIT_3	/* ISP1040A */
+#define ISP_CFG0_1040B	 BIT_4	/* ISP1040B */
+#define ISP_CFG0_1040C	 BIT_5	/* ISP1040C */
 	uint16_t cfg_1;		/* Configuration 1 */
+#define ISP_CFG1_F128    BIT_6  /* 128-byte FIFO threshold */
+#define ISP_CFG1_F64     BIT_4|BIT_5 /* 128-byte FIFO threshold */
+#define ISP_CFG1_F32     BIT_5  /* 128-byte FIFO threshold */
+#define ISP_CFG1_F16     BIT_4  /* 128-byte FIFO threshold */
+#define ISP_CFG1_BENAB   BIT_2  /* Global Bus burst enable */
+#define ISP_CFG1_SXP     BIT_0  /* SXP register select */
 	uint16_t ictrl;		/* Interface control */
 #define ISP_RESET        BIT_0	/* ISP soft reset */
 #define ISP_EN_INT       BIT_1	/* ISP enable interrupts. */
@@ -147,7 +160,42 @@
 	uint16_t flash_data;	/* Flash BIOS data */
 	uint16_t flash_address;	/* Flash BIOS address */
 
-	uint16_t unused_1[0x2e];	/* 0x14-0x6f Gap */
+	uint16_t unused_1[0x06];
+	
+	/* cdma_* and ddma_* are 1040 only */
+	uint16_t cdma_cfg;
+#define CDMA_CONF_SENAB  BIT_3	/* SXP to DMA Data enable */
+#define CDMA_CONF_RIRQ   BIT_2	/* RISC interrupt enable */
+#define CDMA_CONF_BENAB  BIT_1	/* Bus burst enable */
+#define CDMA_CONF_DIR    BIT_0	/* DMA direction (0=fifo->host 1=host->fifo) */
+	uint16_t cdma_ctrl; 
+	uint16_t cdma_status;   
+	uint16_t cdma_fifo_status;
+	uint16_t cdma_count;
+	uint16_t cdma_reserved;
+	uint16_t cdma_address_count_0;
+	uint16_t cdma_address_count_1;
+	uint16_t cdma_address_count_2;
+	uint16_t cdma_address_count_3;
+
+	uint16_t unused_2[0x06];
+
+	uint16_t ddma_cfg;
+#define DDMA_CONF_SENAB  BIT_3	/* SXP to DMA Data enable */
+#define DDMA_CONF_RIRQ   BIT_2	/* RISC interrupt enable */
+#define DDMA_CONF_BENAB  BIT_1	/* Bus burst enable */
+#define DDMA_CONF_DIR    BIT_0	/* DMA direction (0=fifo->host 1=host->fifo) */
+	uint16_t ddma_ctrl;
+	uint16_t ddma_status; 
+	uint16_t ddma_fifo_status;
+	uint16_t ddma_xfer_count_low;
+	uint16_t ddma_xfer_count_high;
+	uint16_t ddma_addr_count_0;
+	uint16_t ddma_addr_count_1;
+	uint16_t ddma_addr_count_2;
+	uint16_t ddma_addr_count_3; 
+
+	uint16_t unused_3[0x0e];
 
 	uint16_t mailbox0;	/* Mailbox 0 */
 	uint16_t mailbox1;	/* Mailbox 1 */
@@ -158,18 +206,18 @@
 	uint16_t mailbox6;	/* Mailbox 6 */
 	uint16_t mailbox7;	/* Mailbox 7 */
 
-	uint16_t unused_2[0x20];/* 0x80-0xbf Gap */
+	uint16_t unused_4[0x20];/* 0x80-0xbf Gap */
 
 	uint16_t host_cmd;	/* Host command and control */
 #define HOST_INT      BIT_7	/* host interrupt bit */
 #define BIOS_ENABLE   BIT_0
 
-	uint16_t unused_6[0x5];	/* 0xc2-0xcb Gap */
+	uint16_t unused_5[0x5];	/* 0xc2-0xcb Gap */
 
 	uint16_t gpio_data;
 	uint16_t gpio_enable;
 
-	uint16_t unused_7[0x11];	/* d0-f0 */
+	uint16_t unused_6[0x11];	/* d0-f0 */
 	uint16_t scsiControlPins;	/* f2 */
 };
 
