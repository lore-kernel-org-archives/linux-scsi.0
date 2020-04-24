Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233DEC54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB3F620767
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:37:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="NqyydDht"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgDXLhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:37:25 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:43924 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726844AbgDXLhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 07:37:24 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 98D04C0338;
        Fri, 24 Apr 2020 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587728243; bh=JwK+rd4eKzzIt8cqna9j4dEcQEMTpAfxKj9SeaP4h+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=NqyydDhtrljf3bMIYvUQ6b17IC1XCLqf3U6t24PPt54usJ65miUylB47+4ANFUlHp
         XDwOKb/jN2c+YFmlgsavE8W7L/X2qW9rRnKsRQwxYAzdbrta/UMXNNjbY62cRepuTT
         pRddVaKyPgmlP+gBYCFIcgFd9MNrFDPiH+usqz8Ok2YgssFCr46vGx8v6APuCs+Wik
         iw64HcpYm/UpAfTiUQPK9kIsi+Cmg+Nw+e3ViX2/MRBr8RHI9icrS9aglkbPPt2PU9
         nwKmx0WHixLRVyvCwk9y0dsYlSCHPLymOn5nqGH8wUkRN+FgPhilJ0C/6/NxSlwvn2
         dIQ7Yj6j1JEig==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 530F8A0067;
        Fri, 24 Apr 2020 11:37:21 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-scsi@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] scsi: ufs: tc-dwc-pci: Use PDI ID to match Test Chip type
Date:   Fri, 24 Apr 2020 13:36:58 +0200
Message-Id: <8427c06b92bae656ab3ef75c7edc980900cdf075.1587727756.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1587727756.git.Jose.Abreu@synopsys.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1587727756.git.Jose.Abreu@synopsys.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for the addition of new Test Chips, we re-arrange the
initialization sequence so that we rely on PCI ID to match for given
Test Chip type.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Joao Lima <Joao.Lima@synopsys.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/ufs/tc-dwc-pci.c | 68 ++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-pci.c b/drivers/scsi/ufs/tc-dwc-pci.c
index aeb11f7f0c91..74a2d80d32bd 100644
--- a/drivers/scsi/ufs/tc-dwc-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-pci.c
@@ -14,6 +14,11 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 
+struct tc_dwc_data {
+	struct ufs_hba_variant_ops ops;
+	int (*setup)(struct pci_dev *pdev, struct tc_dwc_data *data);
+};
+
 /* Test Chip type expected values */
 #define TC_G210_20BIT 20
 #define TC_G210_40BIT 40
@@ -23,6 +28,20 @@ static int tc_type = TC_G210_INV;
 module_param(tc_type, int, 0);
 MODULE_PARM_DESC(tc_type, "Test Chip Type (20 = 20-bit, 40 = 40-bit)");
 
+static int tc_dwc_g210_set_config(struct pci_dev *pdev, struct tc_dwc_data *data)
+{
+	if (tc_type == TC_G210_20BIT) {
+		data->ops.phy_initialization = tc_dwc_g210_config_20_bit;
+	} else if (tc_type == TC_G210_40BIT) {
+		data->ops.phy_initialization = tc_dwc_g210_config_40_bit;
+	} else {
+		dev_err(&pdev->dev, "test chip version not specified\n");
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 static int tc_dwc_pci_suspend(struct device *dev)
 {
 	return ufshcd_system_suspend(dev_get_drvdata(dev));
@@ -48,14 +67,6 @@ static int tc_dwc_pci_runtime_idle(struct device *dev)
 	return ufshcd_runtime_idle(dev_get_drvdata(dev));
 }
 
-/*
- * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
- */
-static struct ufs_hba_variant_ops tc_dwc_pci_hba_vops = {
-	.name                   = "tc-dwc-pci",
-	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
-};
-
 /**
  * tc_dwc_pci_shutdown - main function to put the controller in reset state
  * @pdev: pointer to PCI device handle
@@ -89,22 +100,11 @@ static void tc_dwc_pci_remove(struct pci_dev *pdev)
 static int
 tc_dwc_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct ufs_hba *hba;
+	struct tc_dwc_data *data = (struct tc_dwc_data *)id->driver_data;
 	void __iomem *mmio_base;
+	struct ufs_hba *hba;
 	int err;
 
-	/* Check Test Chip type and set the specific setup routine */
-	if (tc_type == TC_G210_20BIT) {
-		tc_dwc_pci_hba_vops.phy_initialization =
-						tc_dwc_g210_config_20_bit;
-	} else if (tc_type == TC_G210_40BIT) {
-		tc_dwc_pci_hba_vops.phy_initialization =
-						tc_dwc_g210_config_40_bit;
-	} else {
-		dev_err(&pdev->dev, "test chip version not specified\n");
-		return -EPERM;
-	}
-
 	err = pcim_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pcim_enable_device failed\n");
@@ -127,7 +127,16 @@ tc_dwc_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	hba->vops = &tc_dwc_pci_hba_vops;
+	/* Check Test Chip type and set the specific setup routine */
+	if (data && data->setup) {
+		err = data->setup(pdev, data);
+		if (err)
+			return err;
+	} else {
+		return -ENOENT;
+	}
+
+	hba->vops = &data->ops;
 
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
@@ -150,9 +159,20 @@ static const struct dev_pm_ops tc_dwc_pci_pm_ops = {
 	.runtime_idle    = tc_dwc_pci_runtime_idle,
 };
 
+static struct tc_dwc_data tc_dwc_g210_data = {
+	.setup = tc_dwc_g210_set_config,
+	.ops = {
+		.name = "tc-dwc-g210-pci",
+		.link_startup_notify = ufshcd_dwc_link_startup_notify,
+	},
+};
+
+#define PCI_DEVICE_ID_SYNOPSYS_TC_G210_1	0xB101
+#define PCI_DEVICE_ID_SYNOPSYS_TC_G210_2	0xB102
+
 static const struct pci_device_id tc_dwc_pci_tbl[] = {
-	{ PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_DEVICE_DATA(SYNOPSYS, TC_G210_1, &tc_dwc_g210_data) },
+	{ PCI_DEVICE_DATA(SYNOPSYS, TC_G210_2, &tc_dwc_g210_data) },
 	{ }	/* terminate list */
 };
 
-- 
2.7.4

