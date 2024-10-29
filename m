Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE54195F22
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730218285; cv=none; b=Kq9ekcpitZyZT55bFmifnTO5DWH06Wg4jyhKKBLc+QA/YcfUNLAS2FmsUaQbWHiLbhfuN3WycBBdfxDaHlGKpYpZqv2mG+/b/Ht6synepIBurwo6AlfSosCAZmAaNKIKh6AyTlkhpmzxfZcv2RB3+hNBXy0ecig4WOTCRp0FJeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730218285; c=relaxed/simple;
	bh=A0QR+i0oR2j64GU3yjvLVEdK/Mm2bGaFgA/nviyBNvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sctnQ6PBqYBPey5Luuzh9Ufvkl2CxngHYOmEss6sM2vB7GWOyr0GmDy1Kc3R3Fy0q433/M5XLy/3yzQhzvq9gFT1wBDmnQ27pagqcaDrUER7lLbOtv/Cleq4cMVAWNqWOVxIPawHvNXWqlT1IGhDjC/9mqdGzOEWhjPs+eBfGX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y8TW9it+; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y8TW9it+"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539e7e73740so4759226e87.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 09:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730218280; x=1730823080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l8abWMH6Q71x08q8zPwmsFN95wNg/pL6URzYog/1D64=;
        b=Y8TW9it+wP8XSRy6kFPWRAiafPMiml9fPAbXGeCmErzJpsBib1mxEVZK2mC06akIh1
         DRBugO94x8rlg4YL1BnpAEFy8ayetpdBDIttN7hn7yZEM9Eo7XBt7FetZNIVA3E25jkU
         4jWsNz3iieG5Jcp87iDE3hFZmOz2mEB7/JNDxiwsXpiVFYgwN4CK9ri9GVE1Xa+ZYz40
         cbaNM+BIAyjU5ohTfa3diAPQDqnqaHx8ZAxmongpFCLrvaJgMzMBqtvnEfoVeyccK4tH
         9IKwjdk1XENQB5UxtLyPFCWTxY3tINa2vxjbHKI0IeRDBWZxVs8j7mvkDjCkpCf1hqYK
         a7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730218280; x=1730823080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l8abWMH6Q71x08q8zPwmsFN95wNg/pL6URzYog/1D64=;
        b=q/qo2emS9J21n+RC7Y2vS+tIVLc411GY7evrNWKszxkN0aP6QWiD9KAT76T9ywpUtw
         0urvvDQXVLnEc8WqvHmFplRiPaw6wNfXo7bDqaYduw8Yz2XWktmCakj5YSLQyF4IKueb
         +6gJeGMp0LQgfZRZb6a65WBC53TzmEaelTVoP1ooWhPXTkY6yjeTSqk2m6HpAd/4H8YV
         +monT+z0OoMHEd7uYL7HYNNRgmEVfNuGOFiYjvqNajrsDkOGmhYNzNA56CswkrQIRNXJ
         gADhpqWM8NE/3Kldfy+0GNPUIYEvzKGg4B5GRWKKxGb52wM2W/q5gWV2lYB1LyIkm3Hu
         5Nfg==
X-Gm-Message-State: AOJu0YyNNoTZIud6l2Kt817zdRU5R4zlqEOmDQjlZUg4UzR+q5Y9GXFM
	wSUxlNZpW8XNzBE2EDr7Z7QBMJJv+j09mlLdkNgO97TCvPzfIjoyBMmz2A==
X-Google-Smtp-Source: AGHT+IF4XrqLHANrIlroy8VhQXlSpWXFiHHaiD2jrz/BLm/I0xVvLXLIRjz5DmUuubjuHgIEp4LjLQ==
X-Received: by 2002:a05:6512:281b:b0:536:55ef:69e8 with SMTP id 2adb3069b0e04-53b7eb9d73fmr183191e87.0.1730218280015;
        Tue, 29 Oct 2024 09:11:20 -0700 (PDT)
Received: from es40.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b2e1272bdsm1391301e87.88.2024.10.29.09.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 09:11:19 -0700 (PDT)
From: Magnus Lindholm <linmag7@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: linmag7@gmail.com
Subject: [PATCH 1/1] qla1280.c set DMA_BIT_MASK from bus width
Date: Tue, 29 Oct 2024 17:08:45 +0100
Message-ID: <20241029161049.2133-2-linmag7@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241029161049.2133-1-linmag7@gmail.com>
References: <20241029161049.2133-1-linmag7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
---
 drivers/scsi/qla1280.c | 112 ++++++++++++++++++++++++++++++-----------
 1 file changed, 84 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8958547ac111..70409a140461 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -8,9 +8,15 @@
 * Copyright (C) 2003-2004 Christoph Hellwig
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.27.1"
+#define QLA1280_VERSION      "3.27.2"
 /*****************************************************************************
     Revision History:
+    Rev  3.27.2, October 28, 2024, Magnus Lindholm
+	- Explicitly set enable_64bit_addressing flag if QLA_64BIT_PTR is
+	  defined and card is in a 64-bit slot.
+	- Add information about chip hardware revision and pci-slot width to
+	  driver information string
+	- For QLA1040, limit DMA_BIT_MASK to 32 bits for 32-bit cards
     Rev  3.27.1, February 8, 2010, Michael Reed
 	- Retain firmware image for error recovery.
     Rev  3.27, February 10, 2009, Michael Reed
@@ -368,6 +374,7 @@
 
 #define	MEMORY_MAPPED_IO	1
 
+
 #include "qla1280.h"
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
@@ -655,18 +662,51 @@ qla1280_info(struct Scsi_Host *host)
 {
 	static char qla1280_scsi_name_buffer[125];
 	char *bp;
+	char hwrev = ' ';
+	int bits;
 	struct scsi_qla_host *ha;
 	struct qla_boards *bdp;
+	struct device_reg __iomem *reg;
 
 	bp = &qla1280_scsi_name_buffer[0];
 	ha = (struct scsi_qla_host *)host->hostdata;
+	reg = ha->iobase;
 	bdp = &ql1280_board_tbl[ha->devnum];
 	memset(bp, 0, sizeof(qla1280_scsi_name_buffer));
 
+
+	if (IS_ISP1040(ha))
+		switch (ha->revision) {
+		case 1:
+			hwrev = ' ';
+			break;
+		case 2:
+			hwrev = 'A';
+			break;
+		case 3:
+			hwrev = ' ';
+			break;
+		case 4:
+			hwrev = 'A';
+			break;
+		case 5:
+			hwrev = 'B';
+			break;
+		case 6:
+			hwrev = 'C';
+			break;
+		default:
+			hwrev = '?';
+			break;
+	}
+	if (RD_REG_WORD(&reg->istatus) & PCI_64BIT_SLOT)
+		bits = 64;
+	else
+		bits = 32;
 	sprintf (bp,
-		 "QLogic %s PCI to SCSI Host Adapter\n"
+		 "QLogic %s%c %d-bit PCI to SCSI Host Adapter\n"
 		 "       Firmware version: %2d.%02d.%02d, Driver version %s",
-		 &bdp->name[0], ha->fwver1, ha->fwver2, ha->fwver3,
+		 &bdp->name[0], hwrev, bits, ha->fwver1, ha->fwver2, ha->fwver3,
 		 QLA1280_VERSION);
 	return bp;
 }
@@ -2168,6 +2208,13 @@ qla1280_nvram_config(struct scsi_qla_host *ha)
 	} else {
 		qla1280_set_defaults(ha);
 	}
+#ifdef QLA_64BIT_PTR
+	/* set flag in nvram if we're using 64 bit addressing */
+	if (RD_REG_WORD(&reg->istatus) & PCI_64BIT_SLOT)
+		nv->cntr_flags_1.enable_64bit_addressing = 1;
+	else
+		nv->cntr_flags_1.enable_64bit_addressing = 0;
+#endif
 
 	qla1280_print_settings(nv);
 
@@ -2177,9 +2224,9 @@ qla1280_nvram_config(struct scsi_qla_host *ha)
 
 	if (IS_ISP1040(ha)) {
 		uint16_t hwrev, cfg1, cdma_conf;
-
 		hwrev = RD_REG_WORD(&reg->cfg_0) & ISP_CFG0_HWMSK;
 
+		ha->revision = hwrev;
 		cfg1 = RD_REG_WORD(&reg->cfg_1) & ~(BIT_4 | BIT_5 | BIT_6);
 		cdma_conf = RD_REG_WORD(&reg->cdma_cfg);
 
@@ -4139,9 +4186,11 @@ static int
 qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int devnum = id->driver_data;
+	u64 mask;
 	struct qla_boards *bdp = &ql1280_board_tbl[devnum];
 	struct Scsi_Host *host;
 	struct scsi_qla_host *ha;
+	struct device_reg __iomem *reg;
 	int error = -ENODEV;
 
 	/* Bypass all AMI SUBSYS VENDOR IDs */
@@ -4176,9 +4225,38 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->pdev = pdev;
 	ha->devnum = devnum;	/* specifies microcode load address */
 
+
+
+#if MEMORY_MAPPED_IO
+	ha->mmpbase = pci_ioremap_bar(ha->pdev, 1);
+	if (!ha->mmpbase) {
+		printk(KERN_INFO "qla1280: Unable to map I/O memory\n");
+	goto error_free_response_ring;
+	}
+
+	host->base = (unsigned long)ha->mmpbase;
+	ha->iobase = (struct device_reg __iomem *)ha->mmpbase;
+#else
+	host->io_port = pci_resource_start(ha->pdev, 0);
+	if (!request_region(host->io_port, 0xff, "qla1280")) {
+		printk(KERN_INFO "qla1280: Failed to reserve i/o region "
+				 "0x%04lx-0x%04lx - already in use\n",
+		host->io_port, host->io_port + 0xff);
+	goto error_free_response_ring;
+	}
+
+	ha->iobase = (struct device_reg *)host->io_port;
+#endif
+
+
 #ifdef QLA_64BIT_PTR
-	if (dma_set_mask_and_coherent(&ha->pdev->dev, DMA_BIT_MASK(64))) {
-		if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32))) {
+	reg = ha->iobase;
+	if (RD_REG_WORD(&reg->istatus) & PCI_64BIT_SLOT)
+		mask = DMA_BIT_MASK(64);
+	else
+		mask = DMA_BIT_MASK(32);
+	if (dma_set_mask_and_coherent(&ha->pdev->dev, mask)) {
+		if (dma_set_mask(&ha->pdev->dev, mask)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
 			error = -ENODEV;
@@ -4225,28 +4303,6 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->unique_id = host->host_no;
 
 	error = -ENODEV;
-
-#if MEMORY_MAPPED_IO
-	ha->mmpbase = pci_ioremap_bar(ha->pdev, 1);
-	if (!ha->mmpbase) {
-		printk(KERN_INFO "qla1280: Unable to map I/O memory\n");
-		goto error_free_response_ring;
-	}
-
-	host->base = (unsigned long)ha->mmpbase;
-	ha->iobase = (struct device_reg __iomem *)ha->mmpbase;
-#else
-	host->io_port = pci_resource_start(ha->pdev, 0);
-	if (!request_region(host->io_port, 0xff, "qla1280")) {
-		printk(KERN_INFO "qla1280: Failed to reserve i/o region "
-				 "0x%04lx-0x%04lx - already in use\n",
-		       host->io_port, host->io_port + 0xff);
-		goto error_free_response_ring;
-	}
-
-	ha->iobase = (struct device_reg *)host->io_port;
-#endif
-
 	INIT_LIST_HEAD(&ha->done_q);
 
 	/* Disable ISP interrupts. */
-- 
2.47.0

