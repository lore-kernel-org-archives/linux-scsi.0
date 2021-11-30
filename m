Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192CCC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241065AbhK3Xhd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:37:33 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:54036 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhK3Xhb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:31 -0500
Received: by mail-pj1-f43.google.com with SMTP id iq11so16525238pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MiKRALvhWmW8Or+0S/sRoVq0CehcMvWWtso+YlMRmbk=;
        b=38UhosVm5LKN+SW860A/PluHTJg7uXEgY3Q0JDEBzwZko7AnUsFcubVwn2BCH5AeEL
         hxLzBwGTz4ReRpGzE5TaTwNGjrT9+fZjYQdORZ9WkrVL1N+ezSefhiCU7STnLxcze5qH
         n/2WM8GnitcBuUguGfU9yX9hv00177+C8ZSvz4SUQUelzPdMSE33KNZBeqeUcEeRxJxg
         n9bH0ak1fjNi7xCE9OJzkmjMdsia1CvduUxnWC5QaLnNc0W8Ujj+18o9bsYQ2TGZ0r++
         b2S+XGTPe/15RkP9WMAqyl/bgoHJX9YJ4Pock423zbC020P5ydeNcFNhZkH+Xzd5Gjm9
         ssHg==
X-Gm-Message-State: AOAM5337l8zAYOgIrhalQg+v+rvtNhKx1ku6ngCS2Uv4xUcLW+Dlu3Cy
        rRY4xz0PGcfeIhyPe9u1IYE=
X-Google-Smtp-Source: ABdhPJz3oxVeXU0xcSNvSZVe3xxxxDhJJTR5HTFNMXXMu92G0rPu71fF0fJyTpetthUw3l7cxQQHoQ==
X-Received: by 2002:a17:90b:4a50:: with SMTP id lb16mr2769427pjb.37.1638315251257;
        Tue, 30 Nov 2021 15:34:11 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:34:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Yue Hu <huyue2@yulong.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Namjae Jeon <linkinjeon@gmail.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>
Subject: [PATCH v3 07/17] scsi: ufs: Fix race conditions related to driver data
Date:   Tue, 30 Nov 2021 15:33:14 -0800
Message-Id: <20211130233324.1402448-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver data pointer must be set before any callbacks are registered
that use that pointer. Hence move the initialization of that pointer
from after the ufshcd_init() call to inside ufshcd_init().

Fixes: 3b1d05807a9a ("[SCSI] ufs: Segregate PCI Specific Code")
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
