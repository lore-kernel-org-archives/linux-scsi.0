Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD9EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 080616102A
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhKSUCL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:02:11 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:33602 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbhKSUCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:02:00 -0500
Received: by mail-pg1-f182.google.com with SMTP id q132so507976pgq.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HIggx46fqkobnDGo3m+G+qKCcPySQGDE1Cs2ilKyMro=;
        b=06eUgrhiGpWTtOvYo21+eJAXwZE/KUpCpvhp+qVDYJf78xL9N5J77gVMyHW2LxE1pd
         iE/tmsvIBzXBe9QcotAtGum7oxxPdZlRuN74Ssl+nBuFc8HPWVkpBQYNUOyllKu17qbz
         BfkpwsAmI5blIXdQ+rCvM2fn1ONUbS7vaxf60EDdC+UDlCOcNST7zUFLrRKmg2gwoTkH
         4q3qZdpE3kNMIbtrx/kjjyCKSdepjEnEkWsZ5YpUo8Dbb0U26g/FbHBS1xtddspmaCbl
         u9W3+Q03MW6zsxldVxSg4bmHEh1NwjM3PrUA1OTWFN/X57v02T0BvHsGU+c6IUFmrnA4
         T77Q==
X-Gm-Message-State: AOAM532Uz+/M9d246kEl6NViXXqUmyUorF7kAIhscjCKRjGURBDTdi6y
        u0Y1yfj+d13nkD8TT2a0Wfo=
X-Google-Smtp-Source: ABdhPJwVi3/fZ29W7LF3suG7lZazJLgbeSoECYFmOpEydW7itW1oD53CFlWgNr+SVnoTidCiD2GHKQ==
X-Received: by 2002:a65:4249:: with SMTP id d9mr19513198pgq.351.1637351938021;
        Fri, 19 Nov 2021 11:58:58 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:57 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Can Guo <cang@codeaurora.org>, Yue Hu <huyue2@yulong.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 20/20] scsi: ufs: Fix race conditions related to driver data
Date:   Fri, 19 Nov 2021 11:57:43 -0800
Message-Id: <20211119195743.2817-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
index 14043d74389d..b78e92298407 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9523,6 +9523,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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
