Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD6072618
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2025 01:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765503629; cv=none; b=OdqCIgYOrplLk4/lxXZxnrzkp89MfdC81SEoVcQVOob81LtpWfFfecBoeaG+azoj6Hl3GMZ4Ph5WMu8jxP1wXdCxib1w+qHBURmcn+KJSSBKfV3vdWtcDVmT2LO/M0I9e6x/qI6JkobPltXAgNZjXbT+LgVvFW0W+USMoorQvWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765503629; c=relaxed/simple;
	bh=Uo3AN1IPJXynhGZUagYxSlzCkO0FXLjeJgmj7tdWIU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VZ4RZzvFPYgYr3bIOqIOfTimpXzcG4UKEvw3FRkXtWRhhCule68keOlZE2BH1+LWZIgCOH7n0WVXdy3v+UfpbYStuopRvvWIWUZMaRrqWfjHElKmxw2K6IX9glxpKcowuYfL3KBKDaq1HuCfM//dssV9yBppFJ0sp4bKzt1nb/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dz2TAUoN; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dz2TAUoN"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-7baf61be569so828797b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 17:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765503627; x=1766108427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qH4EVLd3m9XYYS7SD7jFgl795htu9dKie2EC0LSVabk=;
        b=dz2TAUoNWk5nMK5yK3AsqvG3whTi7L3g0CEyQzjKOXfWf4ifheuxuZvPnuornByBXg
         zQMkBlCc8a3GAYrNZipOZoEaUZSpwftVXuycIvne3SQhiHsTiRHbp+4QmhU604lao0Co
         lVwHRXOaicihtJeY41oPh6AG75z4SaMavgbIhwvxBsET2Q1Sfe25k9ZZ9uCMBN1/H1um
         LlVm7ciA2jLzI6ia7IOJ/VmBrsfVQhZajIuGF71m6VGK7IhboHWARsuGRshqNMI+FENY
         u59AcD9gCkd73I6fJ/cK3bMNscUqz+htls3LlyWskgkqIavB37lLhlTzSOXe8srqSSur
         05dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765503627; x=1766108427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qH4EVLd3m9XYYS7SD7jFgl795htu9dKie2EC0LSVabk=;
        b=vNy5mvLlkU5Py/f2E9s/ciL64hS6Ij9QSCdRMqqyUEcxeIB7OmOLwfOEjdIRa64F8U
         RWHnFloZdGxyQQdXqdnBWtdvuih9Z7XxRzzX4y4Z062TTTQkD1GzrH5+hFxYQCVM4DlR
         D5gQe5bb6ZY0vT2HN3TGaMHZHymuQibw6LjZDwl/eN8a4IynoAzQ6r6uBrD3b33z21s+
         AbT2qTTB3pHaPCsBcTngg58m7rxNOrP2JDXT1PX2vjIHb+dUL91GjhOCANdXift8hTgU
         WjJaiKiMOAt05iCFnN9tpmaC+pjD/K6pJtdV+5CZzbz1pi3Z4UXT1OLMrniIJ8EC0zSJ
         NqLQ==
X-Gm-Message-State: AOJu0Yy8aKh7oKA3rMLk9FAz5JABpYnNouBeTL5G/8hilvsWTWj048al
	+W+rfZ13okZC59dAxEml4JLdsGrro3r7QZkKEQr1SEl6ugypIG/Hk1c/ceB6hHmM2YjLng==
X-Gm-Gg: AY/fxX44ltQKPcqCbUXf6ZsgLE8HGsn4XLM69NFkDM9bqsqoyh1QQywRlAtlQ8Ee+w2
	YvTUMFpZ43UPh/6ZM50sVCbSml9RjwPr2Eq+793x/t5rGMBx2z95gyfxVw6L+9gqMVk5gUY1X1V
	gPbGaKXGjBSBLxKpu5FMHaoFC4AeR0y7o/d0HtHi8CFCoi1KshVvR0RfaOh+Iji4bUj8RuwX7gO
	dp7KPo0Si9KNdtNz54E30UmqKAWUimB/JI92ckbYm3tHhkTMFkxp9T8LbW4tNmuBlCKvuHJs/Yt
	59Y/8y9FGOe2k1U19bF88gPBRtYPeta3kLmrgv8Yxnl6U4Z4g8NW0w59T0JExRmm1OyuK2PrXFK
	2p2W5ngHBM+jy6nFP5zCKyfJEnXDP7nsuz+tr44VBcsRfF2IRLEpvlYtRTDjzgWYl0yZCPdojCM
	I87XHHB+laCOHmufdgvXx6IOrZU1sTesgUeqZd9Qx3os+L93Gva3RwOgXqVIo+EnMzWXQ6rUSCt
	71K1YxxxsRDpCZg9lE=
X-Google-Smtp-Source: AGHT+IG1fJLJsdUiFnVOEApFh76c31GsJsQXnJ1waXnfObKOTNXYpczE42NvFe3zUG/kHIxwwGazyQ==
X-Received: by 2002:a05:7022:2490:b0:11f:1e59:4c2d with SMTP id a92af1059eb24-11f349a4815mr436859c88.7.1765503626413;
        Thu, 11 Dec 2025 17:40:26 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2ff110sm13675348c88.10.2025.12.11.17.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 17:40:26 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH] scsi: advansys: remove VLB support and unused constants
Date: Thu, 11 Dec 2025 17:39:30 -0800
Message-ID: <20251212013930.14525-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The VLB bus is very obsolete and last appeared on P5 Pentium-era
hardware. Support for it has been removed from other drivers, and
it is highly unlikely anyone is using it with modern Linux kernels.
Also remove unused constants for PCMCIA and MCA devices,
which the driver doesn't support.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/advansys.c | 156 ++++------------------------------------
 1 file changed, 12 insertions(+), 144 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 06223b5ee6da..8364440b5a6c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -51,7 +51,7 @@
  *
  *  1. Use scsi_transport_spi
  *  2. advansys_info is not safe against multiple simultaneous callers
- *  3. Add module_param to override ISA/VLB ioport array
+ *  3. Add module_param to override ISA ioport array
  */
 
 /* Enable driver /proc statistics. */
@@ -87,15 +87,10 @@ typedef unsigned char uchar;
 #define ASC_IS_EISA         (0x0002)
 #define ASC_IS_PCI          (0x0004)
 #define ASC_IS_PCI_ULTRA    (0x0104)
-#define ASC_IS_PCMCIA       (0x0008)
-#define ASC_IS_MCA          (0x0020)
-#define ASC_IS_VL           (0x0040)
 #define ASC_IS_WIDESCSI_16  (0x0100)
 #define ASC_IS_WIDESCSI_32  (0x0200)
 #define ASC_IS_BIG_ENDIAN   (0x8000)
 
-#define ASC_CHIP_MIN_VER_VL      (0x01)
-#define ASC_CHIP_MAX_VER_VL      (0x07)
 #define ASC_CHIP_MIN_VER_PCI     (0x09)
 #define ASC_CHIP_MAX_VER_PCI     (0x0F)
 #define ASC_CHIP_VER_PCI_BIT     (0x08)
@@ -107,7 +102,7 @@ typedef unsigned char uchar;
 #define ASC_CHIP_MAX_VER_EISA (0x47)
 #define ASC_CHIP_VER_EISA_BIT (0x40)
 #define ASC_CHIP_LATEST_VER_EISA   ((ASC_CHIP_MIN_VER_EISA - 1) + 3)
-#define ASC_MAX_VL_DMA_COUNT    (0x07FFFFFFL)
+#define ASC_MAX_EISA_DMA_COUNT    (0x07FFFFFFL)
 #define ASC_MAX_PCI_DMA_COUNT   (0xFFFFFFFFL)
 
 #define ASC_SCSI_ID_BITS  3
@@ -554,8 +549,6 @@ typedef struct asc_cap_info_array {
 #define ASC_CNTL_SCSI_PARITY       (ushort)0x1000
 #define ASC_CNTL_BURST_MODE        (ushort)0x2000
 #define ASC_CNTL_SDTR_ENABLE_ULTRA (ushort)0x4000
-#define ASC_EEP_DVC_CFG_BEG_VL    2
-#define ASC_EEP_MAX_DVC_ADDR_VL   15
 #define ASC_EEP_DVC_CFG_BEG      32
 #define ASC_EEP_MAX_DVC_ADDR     45
 #define ASC_EEP_MAX_RETRY        20
@@ -2627,9 +2620,7 @@ static const char *advansys_info(struct Scsi_Host *shost)
 		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
 		ASC_DBG(1, "begin\n");
 
-		if (asc_dvc_varp->bus_type & ASC_IS_VL) {
-			busname = "VL";
-		} else if (asc_dvc_varp->bus_type & ASC_IS_EISA) {
+		if (asc_dvc_varp->bus_type & ASC_IS_EISA) {
 			busname = "EISA";
 		} else if (asc_dvc_varp->bus_type & ASC_IS_PCI) {
 			if ((asc_dvc_varp->bus_type & ASC_IS_PCI_ULTRA)
@@ -6954,7 +6945,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 				       CC_SINGLE_STEP | CC_DIAG | CC_TEST));
 	chipstat = AscGetChipStatus(iop_base);
 	if (chipstat & CSW_SCSI_RESET_LATCH) {
-		if (!(asc_dvc->bus_type & (ASC_IS_VL | ASC_IS_EISA))) {
+		if (!(asc_dvc->bus_type & ASC_IS_EISA)) {
 			int i = 10;
 			int_pending = ASC_TRUE;
 			asc_dvc->sdtr_done = 0;
@@ -8583,8 +8574,8 @@ static int AscStopQueueExe(PortAddr iop_base)
 
 static unsigned int AscGetMaxDmaCount(ushort bus_type)
 {
-	if (bus_type & (ASC_IS_EISA | ASC_IS_VL))
-		return ASC_MAX_VL_DMA_COUNT;
+	if (bus_type & ASC_IS_EISA)
+		return ASC_MAX_EISA_DMA_COUNT;
 	return ASC_MAX_PCI_DMA_COUNT;
 }
 
@@ -8597,7 +8588,7 @@ static void AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	iop_base = asc_dvc->iop_base;
 	asc_dvc->err_code = 0;
 	if ((asc_dvc->bus_type &
-	     (ASC_IS_PCI | ASC_IS_EISA | ASC_IS_VL)) == 0) {
+	     (ASC_IS_PCI | ASC_IS_EISA)) == 0) {
 		asc_dvc->err_code |= ASC_IERR_NO_BUS_TYPE;
 	}
 	AscSetChipControl(iop_base, CC_HALT);
@@ -8702,8 +8693,8 @@ static ushort AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf,
 	ushort wval;
 	ushort sum;
 	ushort *wbuf;
-	int cfg_beg;
-	int cfg_end;
+	int cfg_beg = ASC_EEP_DVC_CFG_BEG;
+	int cfg_end = ASC_EEP_MAX_DVC_ADDR;
 	int uchar_end_in_config = ASC_EEP_MAX_DVC_ADDR - 2;
 	int s_addr;
 
@@ -8714,13 +8705,6 @@ static ushort AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf,
 		*wbuf = AscReadEEPWord(iop_base, (uchar)s_addr);
 		sum += *wbuf;
 	}
-	if (bus_type & ASC_IS_VL) {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG_VL;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR_VL;
-	} else {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR;
-	}
 	for (s_addr = cfg_beg; s_addr <= (cfg_end - 1); s_addr++, wbuf++) {
 		wval = AscReadEEPWord(iop_base, (uchar)s_addr);
 		if (s_addr <= uchar_end_in_config) {
@@ -8817,8 +8801,8 @@ static int AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf,
 	ushort word;
 	ushort sum;
 	int s_addr;
-	int cfg_beg;
-	int cfg_end;
+	int cfg_beg = ASC_EEP_DVC_CFG_BEG;
+	int cfg_end = ASC_EEP_MAX_DVC_ADDR;
 	int uchar_end_in_config = ASC_EEP_MAX_DVC_ADDR - 2;
 
 	wbuf = (ushort *)cfg_buf;
@@ -8831,13 +8815,6 @@ static int AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf,
 			n_error++;
 		}
 	}
-	if (bus_type & ASC_IS_VL) {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG_VL;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR_VL;
-	} else {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR;
-	}
 	for (s_addr = cfg_beg; s_addr <= (cfg_end - 1); s_addr++, wbuf++) {
 		if (s_addr <= uchar_end_in_config) {
 			/*
@@ -8874,13 +8851,6 @@ static int AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf,
 			n_error++;
 		}
 	}
-	if (bus_type & ASC_IS_VL) {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG_VL;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR_VL;
-	} else {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR;
-	}
 	for (s_addr = cfg_beg; s_addr <= (cfg_end - 1); s_addr++, wbuf++) {
 		if (s_addr <= uchar_end_in_config) {
 			/*
@@ -10779,9 +10749,6 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 		 */
 		switch (asc_dvc_varp->bus_type) {
 #ifdef CONFIG_ISA
-		case ASC_IS_VL:
-			share_irq = 0;
-			break;
 		case ASC_IS_EISA:
 			share_irq = IRQF_SHARED;
 			break;
@@ -11180,95 +11147,6 @@ static int advansys_release(struct Scsi_Host *shost)
 	return 0;
 }
 
-#define ASC_IOADR_TABLE_MAX_IX  11
-
-static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
-	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
-	0x0210, 0x0230, 0x0250, 0x0330
-};
-
-static void advansys_vlb_remove(struct device *dev, unsigned int id)
-{
-	int ioport = _asc_def_iop_base[id];
-	advansys_release(dev_get_drvdata(dev));
-	release_region(ioport, ASC_IOADR_GAP);
-}
-
-/*
- * The VLB IRQ number is found in bits 2 to 4 of the CfgLsw.  It decodes as:
- * 000: invalid
- * 001: 10
- * 010: 11
- * 011: 12
- * 100: invalid
- * 101: 14
- * 110: 15
- * 111: invalid
- */
-static unsigned int advansys_vlb_irq_no(PortAddr iop_base)
-{
-	unsigned short cfg_lsw = AscGetChipCfgLsw(iop_base);
-	unsigned int chip_irq = ((cfg_lsw >> 2) & 0x07) + 9;
-	if ((chip_irq < 10) || (chip_irq == 13) || (chip_irq > 15))
-		return 0;
-	return chip_irq;
-}
-
-static int advansys_vlb_probe(struct device *dev, unsigned int id)
-{
-	int err = -ENODEV;
-	PortAddr iop_base = _asc_def_iop_base[id];
-	struct Scsi_Host *shost;
-	struct asc_board *board;
-
-	if (!request_region(iop_base, ASC_IOADR_GAP, DRV_NAME)) {
-		ASC_DBG(1, "I/O port 0x%x busy\n", iop_base);
-		return -ENODEV;
-	}
-	ASC_DBG(1, "probing I/O port 0x%x\n", iop_base);
-	if (!AscFindSignature(iop_base))
-		goto release_region;
-	/*
-	 * I don't think this condition can actually happen, but the old
-	 * driver did it, and the chances of finding a VLB setup in 2007
-	 * to do testing with is slight to none.
-	 */
-	if (AscGetChipVersion(iop_base, ASC_IS_VL) > ASC_CHIP_MAX_VER_VL)
-		goto release_region;
-
-	err = -ENOMEM;
-	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
-	if (!shost)
-		goto release_region;
-
-	board = shost_priv(shost);
-	board->irq = advansys_vlb_irq_no(iop_base);
-	board->dev = dev;
-	board->shost = shost;
-
-	err = advansys_board_found(shost, iop_base, ASC_IS_VL);
-	if (err)
-		goto free_host;
-
-	dev_set_drvdata(dev, shost);
-	return 0;
-
- free_host:
-	scsi_host_put(shost);
- release_region:
-	release_region(iop_base, ASC_IOADR_GAP);
-	return -ENODEV;
-}
-
-static struct isa_driver advansys_vlb_driver = {
-	.probe		= advansys_vlb_probe,
-	.remove		= advansys_vlb_remove,
-	.driver = {
-		.owner	= THIS_MODULE,
-		.name	= "advansys_vlb",
-	},
-};
-
 static struct eisa_device_id advansys_eisa_table[] = {
 	{ "ABP7401" },
 	{ "ABP7501" },
@@ -11510,17 +11388,10 @@ static struct pci_driver advansys_pci_driver = {
 
 static int __init advansys_init(void)
 {
-	int error;
-
-	error = isa_register_driver(&advansys_vlb_driver,
-				    ASC_IOADR_TABLE_MAX_IX);
+	int error = eisa_driver_register(&advansys_eisa_driver);
 	if (error)
 		goto fail;
 
-	error = eisa_driver_register(&advansys_eisa_driver);
-	if (error)
-		goto unregister_vlb;
-
 	error = pci_register_driver(&advansys_pci_driver);
 	if (error)
 		goto unregister_eisa;
@@ -11529,8 +11400,6 @@ static int __init advansys_init(void)
 
  unregister_eisa:
 	eisa_driver_unregister(&advansys_eisa_driver);
- unregister_vlb:
-	isa_unregister_driver(&advansys_vlb_driver);
  fail:
 	return error;
 }
@@ -11539,7 +11408,6 @@ static void __exit advansys_exit(void)
 {
 	pci_unregister_driver(&advansys_pci_driver);
 	eisa_driver_unregister(&advansys_eisa_driver);
-	isa_unregister_driver(&advansys_vlb_driver);
 }
 
 module_init(advansys_init);
-- 
2.43.0

