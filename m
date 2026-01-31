Received: from mail-dy1-f196.google.com (mail-dy1-f196.google.com [74.125.82.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5E5220F2D
	for <linux-scsi@vger.kernel.org>; Sat, 31 Jan 2026 02:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769827793; cv=none; b=SdsLZrbGRAzd46IXIJY8p9JRbrDH0GC2lwrOAsXRCViq+hkkrgpAbFEu1btk6b/varxz7xJ4ieFAL8m4M0gaEPFVy+ZD+nVQW4XI8Y8jCI7wbAk/ECwJOLccOjo7Aa69tXNkV2EGpKIE/3AVvlLjirSOoxsr7CV4fKebfQe0UBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769827793; c=relaxed/simple;
	bh=iDzd1unnxhn8EXrXbgMg5cGwY/NtOt+4G/Sp/U9ux3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z4bn5Z/meaN/eUGNpaWLua3vZ7zTTLyIsa6Y6PaaPuWNBvT43i9N1/ZuFqMSSfwwZEOtMf470KvswfEBNpdhGztTWMwjM6rfvf5f6xTY/fS7+Ogmce+r62nEoyn+z60ECha4gsXq04f7y+ArQ/Mf3LOaOUNf9gGwyTLT75dOD90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0C7QlyD; arc=none smtp.client-ip=74.125.82.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0C7QlyD"
Received: by mail-dy1-f196.google.com with SMTP id 5a478bee46e88-2b7da62b487so1673454eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2026 18:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769827790; x=1770432590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A/zga0uvqTYwNaOcKsI+LaRHwr1tKM2y4Ri7Mz/9Sk8=;
        b=g0C7QlyD7/0pfF0QkEtl2ue3ee5Qz78W2W4cbzwW7DSQVlcwLyBizVjz+MbUheIClo
         UKe7lTFCe4zcSVREZ5O3mbrgBchrCgyaZGEgxPEljwCgw5A8lkwd2ikybNLkP8xkUCEL
         4w0Oxp1cnZV8TFqrog3NaJO66qIgFrv5vBb7fY/fGntvk9FltkvMPmC9gqrnX0fMCoT4
         2Ik5EVwVVku10W2ZkmBPRvPMLupWjB3PmoWjuhVHHIBd6p3ypsGZK5JafGgowjcbwZJZ
         DC+S4ocWEcjubGqoBVZRZf6JQmdAtu9nXGl3Uew8PK6hO3MB5K7y44Z6Hepg62o8W/HA
         4lYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769827790; x=1770432590;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/zga0uvqTYwNaOcKsI+LaRHwr1tKM2y4Ri7Mz/9Sk8=;
        b=MLodeFciY8/xtJ2KsuRhrSA5p7UT1plxqZuHdLoLuLLaVSvPmzMhOHmDt2aIvf8qzR
         z2UhpPUuzSb77Jc/EGBYsCrO1bePHCSUkCR7sLysTjz6H4Jze5G/5uETWmx4T86AsiJO
         IDhmWkKoLGQaQUieGJH9MgW4NW98TSQqFlsQ97leVWeI98Fj+g0RCka0GPS/hQrf/Lwe
         j95JDZjPBxkic/Jy96dToVu5kigBVsm85+WJax8gWqOG/SpXje5X8MGI0Fzz2kqQdu1e
         yax5eJamA8veghck06NKaXEHFrXo2hQKTRy7WKnZbNlqA6xbQYpuvjA2FyvFnGVUMd4p
         euQQ==
X-Gm-Message-State: AOJu0YyhApRwChNXjKeAl3ssw2gqFcuFjchJGF6zzBQovHZuXSEyX9I9
	X4lR3b2pwwwogv8ZK4uwcwW27wA39kCcinV3HT7WSbrSlDuYmsa1Qa30G1fPjtka
X-Gm-Gg: AZuq6aLmMwDv3Qg6+oUrp04rWjWjGhYuV2uu23AREZ0ccnM0Uk4AA5U2saAMfFCJj58
	Z/URdINdBMQV882o9io+HN2fNDiMMKlJFn7bqophPASMaNW+q3tueoOt7Bsizeo1eYneE8RqHip
	eOmIcOGWZH5SPPiz+Bfp62Kfeq6EQxP+To0emBHUt5FTrrOumHDhdMKSMkufhmbO6LcGSU5x3w8
	1w5RyAlfoganWnFJXqdJ+U2mq2TQZU4myRknoilrWRDek1QIaq17pDadXzvob3bTUiRTDviO6GW
	DtqVVE8ctuEkn1HRiui2gpxUYfOe8HBRwZqdMq/TWyvpfHEICdPZjqjkErFSCHYEptU565OLvTi
	XKWcEcVsZYkaqmwZb2VKIM7Q0buGTuKuuAAW/FdQN8KKv6pGxXhvZ0Q24Gq8rXxafVNgR8Z2S2h
	79ILaPF/nlpwX4C17phb2gWEBusrWfqE0RgwG34Vdn7GlkphGAPSbB7KSGBj2/g6l7h7zy6YUTF
	02dlaxih7vwGh6Tg1+e14+S5iEFRnXXYtKoZ7t4HASK5YlKfyRequNkarbHhXjvUBpCWIy3B9Zj
	poJISea8tyW9VT8=
X-Received: by 2002:a05:7300:434f:b0:2b7:1746:c947 with SMTP id 5a478bee46e88-2b7c86268ebmr2523030eec.6.1769827790393;
        Fri, 30 Jan 2026 18:49:50 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16ec51csm13812156eec.10.2026.01.30.18.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 18:49:50 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2] scsi: advansys: remove VLB support and unused constants
Date: Fri, 30 Jan 2026 18:49:43 -0800
Message-ID: <20260131024944.62356-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The VLB bus is very obsolete and last appeared on P5 Pentium-era
hardware. Support for it has been removed from other drivers, and it is
highly unlikely anyone is using it with modern Linux kernels. A comment
in the code says "the chances of finding a VLB setup in 2007 to do
testing with is slight to none", and this is even more true now. Remove
support for VLB cards from the advansys driver. Also remove unused
constants for PCMCIA and MCA devices, which the driver doesn't support.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
Changes in v2:
Rebase on latest mainline tree
Improve commit message
CC maintainers

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

