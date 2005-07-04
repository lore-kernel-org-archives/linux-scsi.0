From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/9] qla1280: don't use bitfields for hardware access in isp_config
Date: Mon, 4 Jul 2005 17:48:55 +0200
Message-ID: <20050704154855.GH30435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:57036 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261338AbVGDPtA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 11:49:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org, ths@linux-mips.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thiemo Seufer <ths@linux-mips.org>

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2005-06-26 16:58:55.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.c	2005-06-26 16:58:59.000000000 +0200
@@ -2189,9 +2189,9 @@
 	/* nv->cntr_flags_1.disable_loading_risc_code = 1; */
 	nv->firmware_feature.f.enable_fast_posting = 1;
 	nv->firmware_feature.f.disable_synchronous_backoff = 1;
-	nv->termination.f.scsi_bus_0_control = 3;
-	nv->termination.f.scsi_bus_1_control = 3;
-	nv->termination.f.auto_term_support = 1;
+	nv->termination.scsi_bus_0_control = 3;
+	nv->termination.scsi_bus_1_control = 3;
+	nv->termination.auto_term_support = 1;
 
 	/*
 	 * Set default FIFO magic - What appropriate values would be here
@@ -2201,7 +2201,12 @@
 	 * header file provided by QLogic seems to be bogus or incomplete
 	 * at best.
 	 */
-	nv->isp_config.c = ISP_CFG1_BENAB|ISP_CFG1_F128;
+	nv->isp_config.burst_enable = 1;
+	if (IS_ISP1040(ha))
+		nv->isp_config.fifo_threshold |= 3;
+	else
+		nv->isp_config.fifo_threshold |= 4;
+
 	if (IS_ISP1x160(ha))
 		nv->isp_parameter = 0x01; /* fast memory enable */
 
@@ -2362,31 +2367,40 @@
 
 		hwrev = RD_REG_WORD(&reg->cfg_0) & ISP_CFG0_HWMSK;
 
-		cfg1 = RD_REG_WORD(&reg->cfg_1);
+		cfg1 = RD_REG_WORD(&reg->cfg_1) & ~(BIT_4 | BIT_5 | BIT_6);
 		cdma_conf = RD_REG_WORD(&reg->cdma_cfg);
 		ddma_conf = RD_REG_WORD(&reg->ddma_cfg);
 
 		/* Busted fifo, says mjacob. */
-		if (hwrev == ISP_CFG0_1040A)
-			WRT_REG_WORD(&reg->cfg_1, cfg1 | ISP_CFG1_F64);
-		else
-			WRT_REG_WORD(&reg->cfg_1, cfg1 | ISP_CFG1_F64 | ISP_CFG1_BENAB);
+		if (hwrev != ISP_CFG0_1040A)
+			cfg1 |= nv->isp_config.fifo_threshold << 4;
+
+		cfg1 |= nv->isp_config.burst_enable << 2;
+		WRT_REG_WORD(&reg->cfg_1, cfg1);
 
 		WRT_REG_WORD(&reg->cdma_cfg, cdma_conf | CDMA_CONF_BENAB);
 		WRT_REG_WORD(&reg->ddma_cfg, cdma_conf | DDMA_CONF_BENAB);
 	} else {
+		uint16_t cfg1, term;
+
 		/* Set ISP hardware DMA burst */
-		mb[0] = nv->isp_config.c;
+		cfg1 = nv->isp_config.fifo_threshold << 4;
+		cfg1 |= nv->isp_config.burst_enable << 2;
 		/* Enable DMA arbitration on dual channel controllers */
 		if (ha->ports > 1)
-			mb[0] |= BIT_13;
-		WRT_REG_WORD(&reg->cfg_1, mb[0]);
+			cfg1 |= BIT_13;
+		WRT_REG_WORD(&reg->cfg_1, cfg1);
 
 		/* Set SCSI termination. */
-		WRT_REG_WORD(&reg->gpio_enable, (BIT_3 + BIT_2 + BIT_1 + BIT_0));
-		mb[0] = nv->termination.c & (BIT_3 + BIT_2 + BIT_1 + BIT_0);
-		WRT_REG_WORD(&reg->gpio_data, mb[0]);
+		WRT_REG_WORD(&reg->gpio_enable,
+			     BIT_7 | BIT_3 | BIT_2 | BIT_1 | BIT_0);
+		term = nv->termination.scsi_bus_1_control;
+		term |= nv->termination.scsi_bus_0_control << 2;
+		term |= nv->termination.auto_term_support << 7;
+		RD_REG_WORD(&reg->id_l);	/* Flush PCI write */
+		WRT_REG_WORD(&reg->gpio_data, term);
 	}
+	RD_REG_WORD(&reg->id_l);	/* Flush PCI write */
 
 	/* ISP parameter word. */
 	mb[0] = MBC_SET_SYSTEM_PARAMETER;
Index: linux-2.6/drivers/scsi/qla1280.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.h	2005-06-26 16:58:54.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.h	2005-06-26 16:58:59.000000000 +0200
@@ -375,29 +375,23 @@
 	uint16_t unused_12;	/* 12, 13 */
 	uint16_t unused_14;	/* 14, 15 */
 
-	union {
-		uint8_t c;
-		struct {
-			uint8_t reserved:2;
-			uint8_t burst_enable:1;
-			uint8_t reserved_1:1;
-			uint8_t fifo_threshold:4;
-		} f;
+	struct {
+		uint8_t reserved:2;
+		uint8_t burst_enable:1;
+		uint8_t reserved_1:1;
+		uint8_t fifo_threshold:4;
 	} isp_config;		/* 16 */
 
 	/* Termination
 	 * 0 = Disable, 1 = high only, 3 = Auto term
 	 */
-	union {
-		uint8_t c;
-		struct {
-			uint8_t scsi_bus_1_control:2;
-			uint8_t scsi_bus_0_control:2;
-			uint8_t unused_0:1;
-			uint8_t unused_1:1;
-			uint8_t unused_2:1;
-			uint8_t auto_term_support:1;
-		} f;
+	struct {
+		uint8_t scsi_bus_1_control:2;
+		uint8_t scsi_bus_0_control:2;
+		uint8_t unused_0:1;
+		uint8_t unused_1:1;
+		uint8_t unused_2:1;
+		uint8_t auto_term_support:1;
 	} termination;		/* 17 */
 
 	uint16_t isp_parameter;	/* 18, 19 */
