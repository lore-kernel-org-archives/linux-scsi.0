Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F551F708E
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 20:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730753351; cv=none; b=DfwZ1RHof/td8nwUbF51qSsUPEIKal5XfelbYl1/d0SNn/zZwyJwzybz4SJsc7eje+ifWly2RUry9L17sVyipK7LY/3E9+LyOOq1lYgk8mcwStvqsZexomfvJd5hGxWiodZybJeuxXpkIcBT4UGSyf/Cth0T16Ro3c0sWS54ZOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730753351; c=relaxed/simple;
	bh=s7g+2WFyZXA72jYL2PshW+rlLqLNv+p5ym6dJP3Ft/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ioJM/jE50cU92kEV2GJRGAaUY6typpuxF85RY5QsFrvYYm6naHdWElNq8iF9jzAlQaB1MqqLO2QC0t08MsI0ppzEBOU7eRO0ryI/wAb4tgOGkxXNXKBlRvbKjHYDzuQhJ0iayjvV4sIL2k+ZGc7qq3XH18aXxBEdDe4TMO6ZZtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aay6Orck; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aay6Orck"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539f4d8ef66so5989477e87.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2024 12:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730753348; x=1731358148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WXedNd+XsWLIdiETHP93HM0+h9dapd2musrzw6znav4=;
        b=aay6Orckw/WUjG7CFq88/dhsw7FkaPXjpMFMDkPjMBhXgRnJusUpKzT6rqSGZF7S61
         ybGVCqrGLM2smzVy/p1zljTy9kDiAIW/UxQ5WNzblBlot4ZtkR6axsUbb1Fff0Bnes/m
         c4Yhx6Z0P7jJ0NCIgvbP6oPX6sQhC0SDvENhVlVqIhmfeSPs4zOrzEvEkPte7eX2B3qs
         Fgf6dNJ008L4bMnYvryGQhvHe57n+THjU1yZHkcGh53qIAi7rITn6MN/OU6pM+fLsBDz
         s5mzmwnymuI79XUEmR9+Tuc6WXsc6KibjS8vSi0zJ3NWRJZvCph69ho1RfZl8S/3xQ7D
         saTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730753348; x=1731358148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXedNd+XsWLIdiETHP93HM0+h9dapd2musrzw6znav4=;
        b=ICmO61yZlL7gV4AM+EEHhTYMghigr5ZZid2At35ToYabIWP2VGIIVhln9UxTSP34ib
         1j/MzGbFfx/nI85xRVM4IxoDLLVtREhGLsEuDWTkfGlbN+PA0kVJla+V/QfpMIjrR4WK
         AfbSStN/fLfBEVq1LPFUSoro0IOJJ8uVRX1MsuvDOWHWsNurD0630xd9VlmKzCi2TxHj
         jQB2pMs4373Kxk8Vqltyb3eCPKVPT+2Iv0k/hXONBGHq3zl0qh0eSILpEhpX4szxg1nM
         w//VEowzNW4XdbJMIW/HgMxX2KrEb6iqwyuGbL5OUaDsxGf9OJzRrz58CRF2n/KQ24Qv
         qG0A==
X-Gm-Message-State: AOJu0YzagI9U3kvhEwbkdMfuZF2/WO28pRaJqCy13sjw0C9UWb2CPRbf
	ptZx4dXi2ieV+ln+KmvuEOzdFVCnAP2yxOyLhugwj6oF5Ja+rZmObjNV/g==
X-Google-Smtp-Source: AGHT+IEEE4fVLw8xx1wySqwwFgSRAlQEybehQ9kBT7c/5g1oKivCvDxSEcdnZH9S2IaGNn0SxSS2WA==
X-Received: by 2002:a05:651c:a0a:b0:2fb:6198:d230 with SMTP id 38308e7fff4ca-2fcbdfc65d6mr162519131fa.18.1730753347668;
        Mon, 04 Nov 2024 12:49:07 -0800 (PST)
Received: from es40.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fdef616446sm18495281fa.56.2024.11.04.12.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 12:49:06 -0800 (PST)
From: Magnus Lindholm <linmag7@gmail.com>
To: linux-scsi@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: linmag7@gmail.com
Subject: [PATCH v3] scsi: qla1280.c 
Date: Mon,  4 Nov 2024 21:46:00 +0100
Message-ID: <20241104204845.1785-1-linmag7@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 Use dma_get_required_mask() to determine an acceptable DMA_BIT_MASK 
 since on some platforms, qla1040 cards do not work with a 64-bit
 mask. For example, on alpha systems with more than 2GB ram a 64-bit DMA mask
 will result in filesystem corruption, but a 64-bit mask is required on
 IP30/MIPS.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
---
 drivers/scsi/qla1280.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8958547ac111..4ba4084bf252 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -8,9 +8,11 @@
 * Copyright (C) 2003-2004 Christoph Hellwig
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.27.1"
+#define QLA1280_VERSION      "3.27.2"
 /*****************************************************************************
     Revision History:
+    Rev  3.27.2, November 3, 2024, Magnus Lindholm
+	- Use dma_get_required_mask() to determine DMA_BIT_MASK if QLA_64BIT_PTR
     Rev  3.27.1, February 8, 2010, Michael Reed
 	- Retain firmware image for error recovery.
     Rev  3.27, February 10, 2009, Michael Reed
@@ -4143,6 +4145,8 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *host;
 	struct scsi_qla_host *ha;
 	int error = -ENODEV;
+	/* use 32-bit mask as default in case driver is built for 32-only */
+	u64 required_mask = DMA_BIT_MASK(32);
 
 	/* Bypass all AMI SUBSYS VENDOR IDs */
 	if (pdev->subsystem_vendor == PCI_VENDOR_ID_AMI) {
@@ -4177,7 +4181,8 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (dma_set_mask_and_coherent(&ha->pdev->dev, DMA_BIT_MASK(64))) {
+	required_mask = dma_get_required_mask(&ha->pdev->dev);
+	if (dma_set_mask_and_coherent(&ha->pdev->dev, required_mask)) {
 		if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32))) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
@@ -4185,10 +4190,10 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto error_put_host;
 		}
 	} else
-		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
-			ha->host_no);
+		dprintk(2, "scsi(%li): %d-bit PCI Addressing Enabled\n",
+			ha->host_no, fls64(required_mask));
 #else
-	if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(&ha->pdev->dev, required_mask)) {
 		printk(KERN_WARNING "scsi(%li): Unable to set a "
 		       "suitable DMA mask - aborting\n", ha->host_no);
 		error = -ENODEV;
-- 
2.47.0

