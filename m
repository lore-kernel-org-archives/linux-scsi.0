Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048C1C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376848AbhLCXYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:24:10 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:43555 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376419AbhLCXYJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:24:09 -0500
Received: by mail-pl1-f177.google.com with SMTP id m24so3096964pls.10
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:20:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=putL4xFG36SbL3f3NePHbD7K4DAwsBAAKE4Bav0mrJU=;
        b=8PFmGFudlY+3D31vmHkeyyz0ia63pojcrcwXCwK+OM5vaTN9yhqatCpLaIrWSEFx9O
         HO/JBbTq3b+yuUfCkGLZLgId9s2HI299DGMlsxLQJ8TDyL0eJKJ/3aNkJtQ49dpcsgWY
         rJwxcpWokGIMCjpRU/W18WwuZ9zeVbNdtiJGfk5D8lZcDOKzmwOuCFM9OjxgGYThQsuN
         5ShfRtuf41aG4+A7mlO6HEq3uER1NUl6W32xdFuFkoDvTYQGUjB00JNVCn4qKGqdMXu1
         fJQo6Mc6J2t3EJjYcQ/FQMzS79D4iVkQmlkSS6Nh86MizOMwL2yi5OhsQiHliEw5e71Y
         UJTQ==
X-Gm-Message-State: AOAM532qkW1/qIrPOmB3ptRZNBgiCP+R3v6nb3sDrYDAS8hBvc1KPXca
        34V2HsZztiFnVhXj6EmdSX4=
X-Google-Smtp-Source: ABdhPJxwB9czl1wsGACRFx/F5EMfGQ+VoXxz5vQx5vnMEzCsux8F9wQ07Tik9e8UxVi5/fBg9KG/mg==
X-Received: by 2002:a17:90b:4c8b:: with SMTP id my11mr18038150pjb.96.1638573644754;
        Fri, 03 Dec 2021 15:20:44 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:20:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Yue Hu <huyue2@yulong.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 06/17] scsi: ufs: Fix race conditions related to driver data
Date:   Fri,  3 Dec 2021 15:19:39 -0800
Message-Id: <20211203231950.193369-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver data pointer must be set before any callbacks are registered
that use that pointer. Hence move the initialization of that pointer
from after the ufshcd_init() call to inside ufshcd_init().

Fixes: 3b1d05807a9a ("[SCSI] ufs: Segregate PCI Specific Code")
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/tc-dwc-g210-pci.c | 1 -
 drivers/scsi/ufs/ufshcd-pci.c      | 2 --
 drivers/scsi/ufs/ufshcd-pltfrm.c   | 2 --
 drivers/scsi/ufs/ufshcd.c          | 7 +++++++
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index 679289e1a78e..7b08e2e07cc5 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -110,7 +110,6 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	pci_set_drvdata(pdev, hba);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 51424557810d..a673eedb2f05 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -522,8 +522,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	pci_set_drvdata(pdev, hba);
-
 	hba->vops = (struct ufs_hba_variant_ops *)id->driver_data;
 
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index eaeae83b999f..8b16bbbcb806 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -361,8 +361,6 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
-	platform_set_drvdata(pdev, hba);
-
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d4996ada55b6..04a19b826837 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9481,6 +9481,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	struct device *dev = hba->dev;
 	char eh_wq_name[sizeof("ufs_eh_wq_00")];
 
+	/*
+	 * dev_set_drvdata() must be called before any callbacks are registered
+	 * that use dev_get_drvdata() (frequency scaling, clock scaling, hwmon,
+	 * sysfs).
+	 */
+	dev_set_drvdata(dev, hba);
+
 	if (!mmio_base) {
 		dev_err(hba->dev,
 		"Invalid memory reference for mmio_base is NULL\n");
