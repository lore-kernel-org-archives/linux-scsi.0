Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4DC175BF
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 12:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730379355; cv=none; b=K1lufYV0F0EGO7ewPyF3Yskotxnn3x4XtVhxux30j8aaOdDnMd4YAY3epRtCy0/ZWmoUMfAvMgrlF6pxaGxBx04WywdBHiWC9sWOyv136Lfkiw0abz9UQoURSDFu8k5UUVhP+4t30mNiIaMZOrtc7lt4NcrJicIpXE1MxFHmHug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730379355; c=relaxed/simple;
	bh=K55yylv8OFxEN63mGG4YWcaBDMPkH1bdAzRCtu0WaKs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kN2W1paGlsH7032REfUDM5jI272DF/tJYYqnyaghCI/DV3UzXFPspnlTMPs8WaWuPBan51YYI5VAjOeiKvy22SMnJSeQ+yOPrEIW2vsx6mtQHL65A5wJ0/yLy16nhW/QN/02mIgXX97CqoJYKlZ5iSOTqIzEySTF5MY4xE6Ufps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZZ5Y5tOF; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZ5Y5tOF"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53c779ef19cso1030569e87.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 05:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730379351; x=1730984151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=yy20HBXer45G2MlqGPyY/SKUCG+7qddRdC/kse9UmlU=;
        b=ZZ5Y5tOFllpWKm4BKrLEnGrFB6d8qXkI03WlwZr81Bj0009GSDSwZvWympqKH0QD/B
         3BhJKK+71rrbD70LxhA9800dUAZpIL3V8e4BC9ZVK6Oag6HNR40qv7jsPelfW3vnyqkU
         aawQYO/TpowwGCn+agYp3n5+Yl07tMw4zi/yZS3ema7Om3q70exq2VGM1/kDfPrJdR6e
         CDS8c7nA/XrWuTcv4u7m0lGNkZBkdGJdD2nXId4S4rQyaCBlrW+IPgEAu5JzaLeqIER/
         ijFL2Hi8VgP0Z1sRfQ595Sa2ARzRjZ001Eyorxo0JoHXnLxV8Eb0yZGt+oz0GfRTGC/B
         xEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730379351; x=1730984151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yy20HBXer45G2MlqGPyY/SKUCG+7qddRdC/kse9UmlU=;
        b=lGCayPiQHHHlqCaXPj7upNuZ0G9yBPVoUvuBLgAloecUOl/nk9egureKX2Lhhxx0uH
         NuoYaeT6oAs9+F+oyY0B8WrioLKiwRhbFA/eRig6x0g3+Wj/LZ3djAs8Nb4RyA8ehXRD
         nQGToWOzizcQod/enBdGGabHztAhYF0ttrtgHaaY6qeTN/Zt7jfG49od18np9HMQXgO/
         yWptBxvX9RrnQx5EOviwoWUf69TeaYKHpVMLkUqOiBq5uzC8lMgNA7+ZtebEh4pdiQ6z
         ithnRHodLLgFGPinxDIeYUBnha4oGbORmUvEutfdmJj51j4ohWNjS4smFCuSTBFh4eER
         Jtuw==
X-Gm-Message-State: AOJu0YwdHYgVxuu8QftvtGZc0okWHH9cbP5eo4wQumwLYmwbGUKTbwJq
	igGifxbc+Yyn0/9op92HXj02UCjR0Q/pRwmtjTHfgxwKaW8aGcbs7pN3k0GO
X-Google-Smtp-Source: AGHT+IGdmxd5+uIMCzPtikxt7zOreyADfoDohHh9ALzoacVc2cVWuQ7R7uXr7P3mz4O2WiYpb3lf1g==
X-Received: by 2002:a05:6512:acf:b0:539:f496:aa88 with SMTP id 2adb3069b0e04-53c79ea6c68mr1792840e87.53.1730379351085;
        Thu, 31 Oct 2024 05:55:51 -0700 (PDT)
Received: from es40.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53c7bcce4efsm189672e87.152.2024.10.31.05.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 05:55:50 -0700 (PDT)
From: Magnus Lindholm <linmag7@gmail.com>
To: linux-scsi@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	mdr@sgi.com,
	martin.petersen@oracle.com,
	linmag7@gmail.com
Subject: [PATCH v2] scsi: qla1280.c 
Date: Thu, 31 Oct 2024 13:54:08 +0100
Message-ID: <20241031125506.20215-1-linmag7@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to prevent file system corruption on disks attached
to 32-bit ISP1020/1040 cards in 64-bit enabled systems, while maintaing the
possibility to run other qlogic cards in 64-bit mode, limit DMA_BIT_MASK to 32-bit.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
---
 drivers/scsi/qla1280.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8958547ac111..a732aaa3658a 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -8,9 +8,12 @@
 * Copyright (C) 2003-2004 Christoph Hellwig
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.27.1"
+#define QLA1280_VERSION      "3.27.2"
 /*****************************************************************************
     Revision History:
+    Rev  3.27.2, October 31, 2024, Magnus Lindholm
+	- Limit DMA_BIT_MASK to 32-bit for QLA1020 and QLA1040 cards in order to prevent
+	  file system corruption on some platforms
     Rev  3.27.1, February 8, 2010, Michael Reed
 	- Retain firmware image for error recovery.
     Rev  3.27, February 10, 2009, Michael Reed
@@ -4142,6 +4145,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct qla_boards *bdp = &ql1280_board_tbl[devnum];
 	struct Scsi_Host *host;
 	struct scsi_qla_host *ha;
+	u64 mask;
 	int error = -ENODEV;
 
 	/* Bypass all AMI SUBSYS VENDOR IDs */
@@ -4177,8 +4181,13 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (dma_set_mask_and_coherent(&ha->pdev->dev, DMA_BIT_MASK(64))) {
-		if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32))) {
+	/* for 1020 and 1040, force 32-bit DMA mask */
+	if (IS_ISP1040(ha))
+		mask = DMA_BIT_MASK(32);
+	else
+		mask = DMA_BIT_MASK(64);
+	if (dma_set_mask_and_coherent(&ha->pdev->dev, mask)) {
+		if (dma_set_mask(&ha->pdev->dev, mask)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
 			error = -ENODEV;
-- 
2.47.0

